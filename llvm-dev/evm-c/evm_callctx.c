#include "evm_callctx.h"
#include "evm_stack.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int32_t callctx_opcode_callback(evm_callctx *callctx, uint8_t opcode, uint8_t *inputs, uint8_t *outputs);

evm_callctx *callctx_init(evm_stack *stack) {
    evm_callctx *ctx = (evm_callctx *)malloc(sizeof(evm_callctx));
    if (!ctx) {
        return NULL;
    }

    ctx->stack = stack;
    ctx->pc = 0;
    ctx->gas = 0;
    ctx->opcode_fn = callctx_opcode_callback;
    ctx->custom_data = NULL;

    return ctx;
}

void callctx_free(evm_callctx *callctx) {
    assert(callctx != NULL);
    free(callctx);
}

uint64_t callctx_get_pc(evm_callctx *callctx) {
    assert(callctx != NULL);
    return callctx->pc;
}

uint64_t callctx_get_gas(evm_callctx *callctx) {
    assert(callctx != NULL);
    return callctx->gas;
}

int32_t callctx_opcode_callback(evm_callctx *callctx, uint8_t opcode, uint8_t *inputs, uint8_t *outputs) {
    assert(callctx != NULL);
    printf("Opcode: %d\n", opcode);
    return 0;
}

int32_t callctx_call(evm_callctx *callctx) {
    uint8_t opcode = 8;
    uint8_t inputs[32] = {0};
    uint8_t outputs[32] = {0};
    return callctx->opcode_fn(callctx, opcode, inputs, 32, NULL, 0);
}

int32_t callctx_stack_inc(evm_callctx *callctx) {
    callctx->stack->position += 32;
    return 0;
}

int32_t callctx_switch_branch(evm_callctx *callctx, uint64_t pc) {
    switch (pc) {
        case 42:
            return 1;
        case 48:
            return 2;
        case 4:
            return 3;
        case 77:
            return 88;
        default:
            return 0;
    }
}