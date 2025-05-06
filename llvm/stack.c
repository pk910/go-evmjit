#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "stack.h"

evm_stack *stack_init(uint16_t size) {
    evm_stack *stack = malloc(sizeof(evm_stack));
    if (!stack) return NULL;
    stack->stack = malloc(size * STACK_WORD_SIZE);
    if (!stack->stack) {
        free(stack);
        return NULL;
    }
    stack->position = 0;
    return stack;
}

void stack_free(evm_stack *stack) {
    free(stack->stack);
    free(stack);
}

int stack_print_item(evm_stack *stack, int n) {
    unsigned char *item_ptr = stack->stack + ((stack->position - n) * STACK_WORD_SIZE);
    printf("Stack[%d/%d]: 0x", n, stack->position);
    for (int i = 0; i < STACK_WORD_SIZE; i++) {
        printf("%02x", item_ptr[31-i]);
    }
    printf("\n");
    return 0;
}

int stack_get_size(evm_stack *stack) {
    return stack->position;
}
