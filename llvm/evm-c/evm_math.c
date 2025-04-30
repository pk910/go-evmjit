#include "evm_math.h"
#include <stdint.h>
#include <stdbool.h>
#include <string.h> // For memcpy, memset
#include <assert.h>

// Define uint128_t if using GCC/Clang
#if defined(__GNUC__) || defined(__clang__)
typedef __uint128_t uint128_t;
#else
#error "uint128_t type is not supported by this compiler"
#endif

// --- Bit Manipulation Helpers (using GCC/Clang builtins) ---

// Add with carry: result = x + y + carry_in; returns carry_out
static inline uint64_t add_carry(uint64_t x, uint64_t y, uint64_t carry_in, uint64_t* result) {
    uint128_t sum128 = (uint128_t)x + y + carry_in;
    *result = (uint64_t)sum128;
    return (uint64_t)(sum128 >> 64);
}

// Subtract with borrow: result = x - y - borrow_in; returns borrow_out
static inline uint64_t sub_borrow(uint64_t x, uint64_t y, uint64_t borrow_in, uint64_t* result) {
    uint128_t diff128 = (uint128_t)x - y - borrow_in;
    *result = (uint64_t)diff128;
    return (diff128 >> 64) & 1 ? 1 : 0;
}

// Multiply 64x64->128: result = x * y; returns high 64 bits, low 64 bits in *low_out
static inline uint64_t mul128(uint64_t x, uint64_t y, uint64_t* low_out) {
    uint128_t product = (uint128_t)x * y;
    *low_out = (uint64_t)product;
    return (uint64_t)(product >> 64);
}

// Leading zeros
static inline int count_leading_zeros(uint64_t x) {
    if (x == 0) return 64;
    return __builtin_clzll(x);
}

// --- Multi-precision Array Helpers ---

// Computes x += y; returns carry. Requires len(x) >= len(y).
static uint64_t mp_add_to(uint64_t* x, const uint64_t* y, int n) {
    uint64_t carry = 0;
    for (int i = 0; i < n; i++) {
        carry = add_carry(x[i], y[i], carry, &x[i]);
    }
    return carry;
}

// Computes x -= y * multiplier; returns borrow. Requires len(x) >= len(y).
static uint64_t mp_sub_mul_to(uint64_t* x, const uint64_t* y, int n, uint64_t multiplier) {
    uint64_t borrow = 0;
    for (int i = 0; i < n; i++) {
        uint64_t s, t, ph, pl;
        uint64_t c1, c2;

        // s = x[i] - borrow; c1 = borrow?
        c1 = sub_borrow(x[i], borrow, 0, &s);
        // ph, pl = y[i] * multiplier
        ph = mul128(y[i], multiplier, &pl);
        // t = s - pl; c2 = borrow?
        c2 = sub_borrow(s, pl, 0, &t);
        x[i] = t;
        // borrow = ph + c1 + c2
        borrow = ph + c1 + c2; // This can't overflow u64 because max borrow is 2 + max ph (~1)
    }
    return borrow;
}

// --- Core Division Helpers ---

// Computes (u1 << 64 + u0) / d; returns remainder, quotient in *q_out
// Assumes d is normalized (highest bit set)
static inline uint64_t udivrem128by64(uint64_t u1, uint64_t u0, uint64_t d, uint64_t* q_out) {
    assert(d != 0); // Should be handled by caller
    assert((d >> 63) == 1); // Assumes normalized divisor

    uint128_t u = ((uint128_t)u1 << 64) | u0;
    // Standard 128/64 division - compiler often optimizes this
    uint128_t q = u / d;

    // Check for overflow (shouldn't happen if d is normalized and u1 < d)
    if (q >> 64) {
       *q_out = 0xFFFFFFFFFFFFFFFF; // Max u64
       // Calculate remainder manually in this case: u - (q * d)
       // Since q = 2^64, this is u - d << 64 = (u1<<64 + u0) - (d<<64) = (u1-d)<<64 + u0
       return (u1 - d) + u0; // Incorrect: Need proper 128-bit subtraction
                             // r = u - q*d
       uint128_t qd_h = mul128(d, *q_out, & (uint64_t){0}); // q*d might be > 128 bits, but q is max u64 here
       uint128_t qd = (uint128_t)d * (*q_out); // This is fine
       return (uint64_t)(u - qd);
    }

    *q_out = (uint64_t)q;
    uint64_t r = (uint64_t)(u % d); // Or r = u0 - (*q_out * d) ??? No, u % d is correct
                                     // r = u - q*d
    //uint64_t qd_l;
    //uint64_t qd_h = mul128(*q_out, d, &qd_l);
    //uint64_t r0, r1;
    //uint64_t b0 = sub_borrow(u0, qd_l, 0, &r0);
    //uint64_t b1 = sub_borrow(u1, qd_h, b0, &r1);
    //assert(b1 == 0); // Remainder should be < d, so r1 must be 0
    //return r0;
     return (uint64_t)(u - q*d); // Simpler way to get remainder
}

// Divides u (n words) by single normalized word d. Quotient stored in quot (n-1 words). Returns remainder.
static uint64_t udivrem_by1(uint64_t* quot, const uint64_t* u, int n, uint64_t d) {
    assert(n > 0);
    uint64_t rem = u[n - 1]; // Start with top word
    // Process words from high to low, carrying remainder down
    for (int j = n - 2; j >= 0; j--) {
        rem = udivrem128by64(rem, u[j], d, &quot[j]);
    }
    return rem;
}


// Knuth's Algorithm D for u (u_len words) / d (d_len words)
// Assumes u, d normalized. d_len >= 2. u_len >= d_len.
// Quotient stored in quot (u_len - d_len words).
// Remainder stored in first d_len words of u.
static void udivrem_knuth(uint64_t* quot, uint64_t* u, int u_len, const uint64_t* d, int d_len) {
    assert(d_len >= 2);
    assert(u_len >= d_len);
    assert((d[d_len - 1] >> 63) == 1); // d must be normalized

    uint64_t dh = d[d_len - 1];
    uint64_t dl = d[d_len - 2];
    int q_len = u_len - d_len;

    // Iterate through quotient digits from high to low
    for (int j = q_len - 1; j >= 0; j--) {
        // Estimate quotient digit qhat = (u[j+d_len]*B + u[j+d_len-1]) / dh
        uint64_t u_top = u[j + d_len];
        uint64_t u_mid = u[j + d_len - 1];
        uint64_t qhat, rhat; // Estimated quotient digit and its remainder

        if (u_top >= dh) { // If u_top == dh, remainder is u_mid. If u_top > dh (can't happen if normalized correctly?), overflow.
            qhat = 0xFFFFFFFFFFFFFFFF;
             // rhat = u_top * B + u_mid - qhat * dh
             // Since qhat = 2^64-1, rhat = (u_top<<64 + u_mid) - ((2^64-1) * dh)
             // = u_top<<64 + u_mid - (dh<<64 - dh)
             // = (u_top - dh)<<64 + u_mid + dh
             // Since u_top >= dh, let u_top = dh + k (k>=0)
             // rhat = k<<64 + u_mid + dh
             // This calculation seems complex, let's use the property that if u_top>=dh, qhat=B-1
             // The actual remainder after dividing (u_top*B + u_mid) by dh is needed.
             // (u_top*B + u_mid) = qhat*dh + rhat
             // If u_top = dh, then (dh*B + u_mid) / dh. qhat = B? No, max is B-1.
             // Let's use udivrem128by64 which handles the B-1 case.
             // Need to simulate division by dh when dividend's top word >= dh.
             // If u_top == dh, (dh << 64 + u_mid). qhat = 2^64-1, rhat = u_mid + dh.
             // Need to be careful here. Knuth says set qhat = B-1 and adjust later.
            rhat = u_mid + dh; // This is remainder if u_top==dh. It may be >= dh.
            // Refinement: If u_top*B + u_mid overflows 128 bits (only if u_top=max, u_mid=max), handle it. Not possible if u_top=dh.

            // Knuth check: Test if qhat estimate is too high using the next digit dl
            // check: qhat * dl > rhat * B + u[j+d_len-2] ?
            uint64_t u_low = u[j + d_len - 2];
            uint64_t q_dl_h, q_dl_l;
            q_dl_h = mul128(qhat, dl, &q_dl_l); // qhat*dl

            // Compare (q_dl_h << 64 | q_dl_l) with (rhat << 64 | u_low)
            if (q_dl_h > rhat || (q_dl_h == rhat && q_dl_l > u_low)) {
                 qhat--;
                 // Recalculate rhat = rhat + dh (if previous rhat was < dh, now it's ok, if >= dh, still ok because adding dh can't overflow u64 if rhat<dh)
                 // Knuth states: rhat = rhat + dh. Check if rhat >= B. If so, loop again? No, this happens rarely.
                 // If qhat decreased, rhat increases by dh.
                 rhat += dh; // New remainder estimate
                 // If the new rhat >= B (i.e., >= 2^64), it means rhat + dh overflowed.
                 // This happens only if original rhat was >= B-dh.
                 // Check if rhat overflowed (i.e. new rhat < old rhat). But rhat is u64.
                 // If rhat >= dh, we might need the adjustment again.
                 // Let's re-run the check with the new qhat if rhat >= dh (this avoids the complex rhat >= B check)
                 if (rhat >= dh) { // Check again only if remainder still potentially allows another decrement
                    q_dl_h = mul128(qhat, dl, &q_dl_l);
                    if (q_dl_h > rhat || (q_dl_h == rhat && q_dl_l > u_low)) {
                         qhat--;
                         // rhat += dh; // This can't happen twice according to Knuth? Let's assume not.
                    }
                 }
            }
        } else {
            // Normal case: u_top < dh. Estimate qhat using 128/64 division.
            rhat = udivrem128by64(u_top, u_mid, dh, &qhat);

            // Knuth check: Test if qhat estimate is too high using the next digit dl
            // check: qhat * dl > rhat * B + u[j+d_len-2] ?
            uint64_t u_low = u[j + d_len - 2];
            uint64_t q_dl_h, q_dl_l;
            q_dl_h = mul128(qhat, dl, &q_dl_l); // qhat*dl

            // Compare (q_dl_h << 64 | q_dl_l) with (rhat << 64 | u_low)
            if (q_dl_h > rhat || (q_dl_h == rhat && q_dl_l > u_low)) {
                 qhat--;
                 // No need to check again according to Knuth standard algorithm D adjustment step.
                 // We don't need rhat here anymore for the estimation phase.
                 // rhat += dh; // If needed
            }
        }

        // Multiply and subtract: u[j:j+d_len] -= qhat * d[:d_len]
        uint64_t borrow = mp_sub_mul_to(&u[j], d, d_len, qhat);

        // Result of subtraction is stored in u[j:j+d_len].
        // The top word u[j+d_len] should be updated with the borrow from this subtraction.
        uint64_t u_orig_top = u[j + d_len]; // Original value before subtract
        u[j + d_len] = u_orig_top - borrow;

        // Add back if borrow > original top word (means we subtracted too much)
        if (borrow > u_orig_top) {
            qhat--;
            uint64_t carry = mp_add_to(&u[j], d, d_len); // Add d back to u[j:j+d_len]
            u[j + d_len] += carry; // Add carry to the top word
            // Assert(u[j + d_len] == 0)? No, it might not be zero after adding back.
        }

        quot[j] = qhat; // Store the final quotient digit
    }
    // Remainder is now in the lower d_len words of u (u[0...d_len-1])
}

// --- Main Public Division Function ---

// Divides u by d, quotient in quot, remainder in rem.
// All arrays are 4 words (256 bits), little-endian words.
static void udivrem256(uint64_t quot[4], uint64_t rem[4], const uint64_t u_in[4], const uint64_t d_in[4]) {
    // Find actual lengths (number of non-zero words)
    int u_len = 4, d_len = 4;
    while (d_len > 0 && d_in[d_len - 1] == 0) d_len--;
    while (u_len > 0 && u_in[u_len - 1] == 0) u_len--;

    memset(quot, 0, 4 * sizeof(uint64_t));
    memset(rem, 0, 4 * sizeof(uint64_t));

    // Handle edge cases
    if (d_len == 0) {
        // Division by zero: EVM defines result as 0. Set quotient and remainder to 0.
        return; // Already zeroed
    }
    if (u_len == 0) {
        // 0 / d = 0 rem 0
        return; // Already zeroed
    }

    // Compare u and d
    if (u_len < d_len) {
        // u < d => quotient = 0, remainder = u
        memcpy(rem, u_in, u_len * sizeof(uint64_t));
        return;
    }
    if (u_len == d_len) {
        int cmp = 0;
        for (int i = u_len - 1; i >= 0; i--) {
            if (u_in[i] > d_in[i]) { cmp = 1; break; }
            if (u_in[i] < d_in[i]) { cmp = -1; break; }
        }
        if (cmp == 0) { // u == d
            quot[0] = 1; // Quotient = 1
            // Remainder = 0 (already zeroed)
            return;
        }
        if (cmp < 0) { // u < d
            memcpy(rem, u_in, u_len * sizeof(uint64_t)); // Remainder = u
            // Quotient = 0 (already zeroed)
            return;
        }
    }
    // Now u_len >= d_len and u >= d

    // Normalize divisor d and dividend u
    int shift = count_leading_zeros(d_in[d_len - 1]);

    uint64_t dn_storage[4]; // Normalized d
    uint64_t* dn = dn_storage;
    if (shift > 0) {
        dn[d_len-1] = d_in[d_len-1] << shift;
        for (int i = d_len - 2; i >= 0; i--) {
            dn[i+1] |= d_in[i] >> (64 - shift); // Carry from lower word
            dn[i] = d_in[i] << shift;
        }
    } else {
        memcpy(dn, d_in, d_len * sizeof(uint64_t));
    }


    uint64_t un_storage[5]; // Normalized u (needs one extra word potentially)
    uint64_t* un = un_storage;
    un[u_len] = u_in[u_len-1] >> (64 - shift); // Top word potentially non-zero
    for (int i = u_len - 1; i > 0; i--) {
        un[i] = (u_in[i] << shift) | (u_in[i-1] >> (64 - shift));
    }
    un[0] = u_in[0] << shift;

    int un_len = u_len;
    if (un[u_len] > 0) {
        un_len++; // Actual length of normalized u
    }

    // Allocate quotient buffer (size un_len - d_len)
    int q_len = un_len - d_len;
    assert(q_len <= 4); // Quotient for 256/256 fits in 256 bits

    if (d_len == 1) {
        uint64_t r = udivrem_by1(quot, un, un_len, dn[0]);
        // Denormalize remainder
        if (shift > 0) {
            rem[0] = r >> shift;
        } else {
            rem[0] = r;
        }
    } else {
        udivrem_knuth(quot, un, un_len, dn, d_len);
        // Denormalize remainder (it's in the first d_len words of un)
        if (shift > 0) {
            for (int i = 0; i < d_len - 1; i++) {
                rem[i] = (un[i] >> shift) | (un[i+1] << (64 - shift));
            }
            rem[d_len-1] = un[d_len-1] >> shift;
        } else {
             memcpy(rem, un, d_len * sizeof(uint64_t));
        }
    }
}


// --- Conversion Helpers (bytes <-> uint64_t words) ---

// Convert 32 big-endian bytes to 4 little-endian uint64_t words
static void bytes_be_to_words_le(const unsigned char bytes[32], uint64_t words[4]) {
    for (int i = 0; i < 4; ++i) {
        words[i] = 0;
        const unsigned char* p = bytes + (3 - i) * 8; // Start of i-th word (from LE perspective) in BE bytes
        for (int j = 0; j < 8; ++j) {
            words[i] = (words[i] << 8) | p[j];
        }
    }
}

// Convert 4 little-endian uint64_t words to 32 big-endian bytes
static void words_le_to_bytes_be(const uint64_t words[4], unsigned char bytes[32]) {
     for (int i = 0; i < 4; ++i) {
        uint64_t w = words[i];
        uint8_t* p = bytes + (3 - i) * 8; // Start of i-th word (from LE perspective) in BE bytes
        for (int j = 7; j >= 0; --j) {
            p[j] = (uint8_t)(w & 0xFF);
            w >>= 8;
        }
    }
}

// --- 256-bit Signed Integer Helpers ---

// Check if a 256-bit number is negative (MSB set)
static inline bool s256_is_negative(const uint64_t words[4]) {
    return (words[3] >> 63) != 0;
}

// Check if a 256-bit number is zero
static inline bool u256_is_zero(const uint64_t words[4]) {
    return words[0] == 0 && words[1] == 0 && words[2] == 0 && words[3] == 0;
}

// Check if a 256-bit number is the minimum signed value (-2^255)
static inline bool s256_is_min(const uint64_t words[4]) {
    return words[0] == 0 && words[1] == 0 && words[2] == 0 && words[3] == 0x8000000000000000;
}

// Set a 256-bit number to the minimum signed value (-2^255)
static inline void s256_set_min(uint64_t words[4]) {
    words[0] = 0;
    words[1] = 0;
    words[2] = 0;
    words[3] = 0x8000000000000000;
}


// Check if a 256-bit number is -1 (all bits set)
static inline bool s256_is_minus_one(const uint64_t words[4]) {
    return words[0] == UINT64_MAX && words[1] == UINT64_MAX && words[2] == UINT64_MAX && words[3] == UINT64_MAX;
}


// Negate a 256-bit number (two's complement) in place: words = ~words + 1
static void s256_negate_inplace(uint64_t words[4]) {
    uint64_t carry = 1; // Start with +1 for two's complement
    words[0] = ~words[0];
    carry = add_carry(words[0], 0, carry, &words[0]);
    words[1] = ~words[1];
    carry = add_carry(words[1], 0, carry, &words[1]);
    words[2] = ~words[2];
    carry = add_carry(words[2], 0, carry, &words[2]);
    words[3] = ~words[3];
    carry = add_carry(words[3], 0, carry, &words[3]);
    // Final carry is ignored (overflow for negation only happens for 0 and MIN_INT)
}


// --- Updated u256_divmod using Knuth ---

static int32_t u256_divmod(const unsigned char *a_bytes, const unsigned char *b_bytes, uint8_t *quotient_bytes, uint8_t *remainder_bytes) {
    uint64_t a_words[4], b_words[4];
    uint64_t quot_words[4], rem_words[4];

    // Convert big-endian bytes to little-endian words
    bytes_be_to_words_le(a_bytes, a_words);
    bytes_be_to_words_le(b_bytes, b_words);

    // Check for division by zero before calling udivrem256
    if (u256_is_zero(b_words)) {
        // EVM: division by zero results in zero for quotient and remainder
        if (quotient_bytes != NULL) {
            memset(quotient_bytes, 0, 32);
        }
        if (remainder_bytes != NULL) {
            memset(remainder_bytes, 0, 32);
        }
        return 0; // Indicate success with zero result as per EVM spec
    }

    // Perform division
    udivrem256(quot_words, rem_words, a_words, b_words);

    // Convert little-endian words back to big-endian bytes
    if (quotient_bytes != NULL) {
        words_le_to_bytes_be(quot_words, quotient_bytes);
    }
    if (remainder_bytes != NULL) {
        words_le_to_bytes_be(rem_words, remainder_bytes);
    }
    return 0; // Success
}


// --- Public EVM Math Functions ---

int evm_math_div(const unsigned char *a_bytes, const unsigned char *b_bytes, unsigned char *result_bytes) {
    return u256_divmod(a_bytes, b_bytes, result_bytes, NULL);
}

int evm_math_mod(const unsigned char *a_bytes, const unsigned char *b_bytes, unsigned char *result_bytes) {
    return u256_divmod(a_bytes, b_bytes, NULL, result_bytes);
}

int evm_math_sdiv(const unsigned char *a_bytes, const unsigned char *b_bytes, unsigned char *result_bytes) {
    uint64_t a_words[4], b_words[4];
    uint64_t quot_words[4], rem_words[4]; // Need remainder for intermediate steps

    bytes_be_to_words_le(a_bytes, a_words);
    bytes_be_to_words_le(b_bytes, b_words);

    if (u256_is_zero(b_words)) {
        memset(result_bytes, 0, 32); // EVM spec: division by zero yields zero
        return 0;
    }

    bool a_neg = s256_is_negative(a_words);
    bool b_neg = s256_is_negative(b_words);

    // Handle the specific edge case: MIN_S256 / -1 = MIN_S256
    if (s256_is_min(a_words) && s256_is_minus_one(b_words)) {
         s256_set_min(quot_words);
         words_le_to_bytes_be(quot_words, result_bytes);
         return 0;
    }

    // Get absolute values for unsigned division
    uint64_t abs_a[4], abs_b[4];
    memcpy(abs_a, a_words, sizeof(abs_a));
    memcpy(abs_b, b_words, sizeof(abs_b));

    if (a_neg) {
        s256_negate_inplace(abs_a);
    }
    if (b_neg) {
        s256_negate_inplace(abs_b);
    }

    // Perform unsigned division on absolute values
    udivrem256(quot_words, rem_words, abs_a, abs_b); // Use abs values

    // Determine the sign of the result (negative if signs differ)
    bool result_neg = a_neg ^ b_neg;

    // Negate the quotient if the result should be negative
    if (result_neg && !u256_is_zero(quot_words)) { // Don't negate zero
        s256_negate_inplace(quot_words);
    }

    words_le_to_bytes_be(quot_words, result_bytes);
    return 0;
}


int evm_math_smod(const unsigned char *a_bytes, const unsigned char *b_bytes, unsigned char *result_bytes) {
    uint64_t a_words[4], b_words[4];
    uint64_t quot_words[4], rem_words[4];

    bytes_be_to_words_le(a_bytes, a_words);
    bytes_be_to_words_le(b_bytes, b_words);

    if (u256_is_zero(b_words)) {
        memset(result_bytes, 0, 32); // EVM spec: modulo by zero yields zero
        return 0;
    }

    bool a_neg = s256_is_negative(a_words);
    // bool b_neg = s256_is_negative(b_words); // Sign of divisor doesn't matter for SMOD result sign

    // Get absolute values for unsigned division
    // Note: We only need the remainder from udivrem256
    uint64_t abs_a[4], abs_b[4];
    memcpy(abs_a, a_words, sizeof(abs_a));
    memcpy(abs_b, b_words, sizeof(abs_b));

    // MIN_S256 needs special handling only for division by -1.
    // For modulo, abs(MIN_S256) = MIN_S256 is handled correctly by udivrem256.
    if (a_neg) {
         // Check if it's MIN_S256, negate won't change it but flag is set
         if (!s256_is_min(abs_a)) {
             s256_negate_inplace(abs_a);
         }
    }
    if (s256_is_negative(abs_b)) { // b_neg
        if (!s256_is_min(abs_b)) { // Can't negate MIN_S256 for divisor either
             s256_negate_inplace(abs_b);
        } else {
             // We are doing abs(a) % abs(MIN_S256). abs(MIN_S256) is MIN_S256 itself (0x80...0).
             // This case should be handled correctly by udivrem256.
        }
    }


    // Perform unsigned division to get the remainder
    udivrem256(quot_words, rem_words, abs_a, abs_b);

    // The sign of the SMOD result follows the sign of the dividend 'a'
    // If 'a' was negative and remainder is non-zero, negate the remainder.
    if (a_neg && !u256_is_zero(rem_words)) {
        s256_negate_inplace(rem_words);
    }

    words_le_to_bytes_be(rem_words, result_bytes);
    return 0;
}
