#include "evm_stack.h"
#include "evm_math.h"
#include <string.h>
#include <stdio.h>
#include <stdint.h>

static int stack_unsafe_pop_two_operands(evm_stack *stack, uint8_t **a, uint8_t **b) {
    if (stack->position < 2) return STACK_ERR_UNDERFLOW;
    *b = stack->stack + (stack->position - 1) * STACK_WORD_SIZE;
    *a = stack->stack + (stack->position - 2) * STACK_WORD_SIZE;
    stack->position -= 2;
    return 0;
}

static int stack_unsafe_push_buffer(evm_stack *stack, uint8_t **buf) {
    stack->position++;
    *buf = stack->stack + (stack->position - 1) * STACK_WORD_SIZE;
    return 0;
}

static int stack_unsafe_push_new(evm_stack *stack, uint8_t **buf) {
    uint8_t zero[STACK_WORD_SIZE] = {0};
    int res = stack_push(stack, zero);
    if (res) return res;
    *buf = stack->stack + (stack->position - 1) * STACK_WORD_SIZE;
    return 0;
}

int math_add(evm_stack *stack) {
    unsigned char *a = stack->stack + stack->position - STACK_WORD_SIZE;
    unsigned char *b = a - STACK_WORD_SIZE;

    uint64_t *a64 = (uint64_t*)a;
    uint64_t *b64 = (uint64_t*)b;
    uint64_t carry = 0;
    for (int i = 3; i >= 0; i--) {
        uint64_t sum = a64[i] + b64[i] + carry;
        carry = (sum < a64[i]) || (sum < b64[i]) || ((sum == a64[i]) && (b64[i] > 0));
        a64[i] = sum;
    }

    stack->position--;

    return 0;
}

int math_sub(evm_stack *stack) {
    unsigned char *a = stack->stack + stack->position - STACK_WORD_SIZE;
    unsigned char *b = a - STACK_WORD_SIZE;

    uint64_t *a64 = (uint64_t*)a;
    uint64_t *b64 = (uint64_t*)b;
    uint64_t borrow = 0;
    for (int i = 3; i >= 0; i--) {
        uint64_t diff = a64[i] - b64[i] - borrow;
        borrow = (a64[i] < b64[i]) || ((a64[i] == b64[i]) && (borrow > 0));
        a64[i] = diff;
    }

    stack->position--;

    return 0;
}

int math_mul(evm_stack *stack) {
    uint16_t temp[64] = {0};  // 512-bit temp storage

    uint8_t *a = NULL;
    uint8_t *b = NULL;
    int err = stack_unsafe_pop_two_operands(stack, &a, &b);
    if (err) return err;

    uint8_t *result = NULL;
    err = stack_unsafe_push_buffer(stack, &result);
    if (err) return err;

    for (int i = 31; i >= 0; i--) {
        for (int j = 31; j >= 0; j--) {
            int k = i + j + 1;
            temp[k] += a[i] * b[j];
        }
    }

    // Propagate carry
    for (int i = 63; i > 0; i--) {
        temp[i - 1] += temp[i] >> 8;
        temp[i] &= 0xFF;
    }

    // Store lower 256 bits
    for (int i = 0; i < 32; i++) {
        result[i] = (uint8_t)temp[i + 32];
    }

    return 0;
}

int math_div(evm_stack *stack) {
    uint8_t *dividend = NULL;
    uint8_t *divisor = NULL;
    int err = stack_unsafe_pop_two_operands(stack, &dividend, &divisor);
    if (err) return err;

    // Check division by zero
    int zero = 1;
    for (int i = 0; i < 32; i++) {
        if (divisor[i] != 0) {
            zero = 0;
            break;
        }
    }
    if (zero) {
        return MATH_ERR_DIVZERO;
    }

    uint8_t quotient[32] = {0};
    uint8_t remainder[32] = {0};
    uint8_t temp_dividend[32] = {0};
    memcpy(temp_dividend, dividend, 32);

    for (int bit = 0; bit < 256; bit++) {
        // Shift remainder left by 1
        for (int i = 0; i < 32; i++) {
            remainder[i] <<= 1;
            if (i < 31 && (remainder[i + 1] & 0x80)) remainder[i] |= 1;
        }
        // Bring in next bit from dividend
        if (temp_dividend[bit / 8] & (0x80 >> (bit % 8))) {
            remainder[31] |= 1;
        }

        // If remainder >= divisor
        int cmp = memcmp(remainder, divisor, 32);
        if (cmp >= 0) {
            // remainder -= divisor
            int borrow = 0;
            for (int i = 31; i >= 0; i--) {
                int diff = remainder[i] - divisor[i] - borrow;
                if (diff < 0) {
                    diff += 256;
                    borrow = 1;
                } else {
                    borrow = 0;
                }
                remainder[i] = diff;
            }
            // Set bit in quotient
            quotient[bit / 8] |= (0x80 >> (bit % 8));
        }
    }

    return stack_push(stack, quotient);
}
