#ifndef EVM_MATH_H
#define EVM_MATH_H

#include <stdint.h>

int32_t evm_math_div(const unsigned char *a, const unsigned char *b, unsigned char *result);
int32_t evm_math_sdiv(const unsigned char *a, const unsigned char *b, unsigned char *result);
int32_t evm_math_mod(const unsigned char *a, const unsigned char *b, unsigned char *result);
int32_t evm_math_smod(const unsigned char *a, const unsigned char *b, unsigned char *result);
int32_t evm_math_exp(const unsigned char *a, const unsigned char *b, unsigned char *result, uint64_t *gasleft);

#endif