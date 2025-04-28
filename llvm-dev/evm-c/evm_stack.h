#ifndef EVM_STACK_H
#define EVM_STACK_H

#include <stdint.h>

#define STACK_CHUNK 256
#define STACK_WORD_SIZE 32
#define STACK_MAX_SIZE (1024 * STACK_WORD_SIZE)

#define STACK_ERR_OSFAIL    -1
#define STACK_ERR_OVERFLOW  -2
#define STACK_ERR_UNDERFLOW -3

struct evm_stack {
    uint8_t *stack;
    uint64_t position;
};

typedef struct evm_stack evm_stack;

evm_stack *stack_init();
void stack_free(evm_stack *stack);
int stack_push(evm_stack *stack, unsigned char *value);
int stack_dupn(evm_stack *stack, int n);
int stack_swapn(evm_stack *stack, int n);
int stack_pop(evm_stack *stack);
int stack_print_item(evm_stack *stack, int n);


#endif