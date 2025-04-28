#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "evm_stack.h"

int stack_grow(evm_stack *stack);

evm_stack *stack_init() {
    evm_stack *stack = malloc(sizeof(evm_stack));
    if (!stack) return NULL;
    stack->stack = malloc(STACK_CHUNK * STACK_WORD_SIZE);
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

int stack_push(evm_stack *stack, unsigned char value[STACK_WORD_SIZE]) {
    memcpy(stack->stack + stack->position, value, STACK_WORD_SIZE);
    stack->position += STACK_WORD_SIZE;
    return 0;
}

int stack_dupn(evm_stack *stack, int n) {
    memcpy(stack->stack + stack->position, stack->stack + stack->position - (n * STACK_WORD_SIZE), STACK_WORD_SIZE);
    stack->position += STACK_WORD_SIZE;
    return 0;
}

int stack_swapn(evm_stack *stack, int n) {
    unsigned char *s_pos = stack->stack + stack->position - STACK_WORD_SIZE;
    unsigned char *n_pos = s_pos - (n * STACK_WORD_SIZE);
    unsigned char tmp[STACK_WORD_SIZE];
    memcpy(tmp, s_pos, STACK_WORD_SIZE);
    memcpy(s_pos, n_pos, STACK_WORD_SIZE);
    memcpy(n_pos, tmp, STACK_WORD_SIZE);
    return 0;
}

int stack_pop(evm_stack *stack) {
    stack->position -= STACK_WORD_SIZE;
    return 0;
}

int stack_print_item(evm_stack *stack, int n) {
    unsigned char *item_ptr = stack->stack + stack->position - (n * STACK_WORD_SIZE);
    printf("Stack[%d/%d]: 0x", n, stack->position/STACK_WORD_SIZE);
    for (int i = 0; i < STACK_WORD_SIZE; i++) {
        printf("%02x", item_ptr[i]);
    }
    printf("\n");
    return 0;
}

unsigned char heap[STACK_WORD_SIZE * STACK_CHUNK];
int heap_position = 0;

int stack_load_input(evm_stack *stack, int n) {
    unsigned char *s_pos = stack->stack + stack->position - (n * STACK_WORD_SIZE);
    memcpy(heap, s_pos, (n * STACK_WORD_SIZE));
    heap_position = n;
    return 0;
}

int stack_load_output(evm_stack *stack, int n) {
    unsigned char *h_pos = heap_position;
    unsigned char *s_pos = stack->stack + stack->position - (n * STACK_WORD_SIZE);

    memcpy(s_pos, heap, (n * STACK_WORD_SIZE));
    heap_position = n;
    return 0;
}
