#ifndef EVM_MATH_H
#define EVM_MATH_H

#include "evm_stack.h"

#define MATH_ERR_DIVZERO   -5

int math_add(evm_stack *stack);
int math_sub(evm_stack *stack);
int math_mul(evm_stack *stack);
int math_div(evm_stack *stack);

#endif