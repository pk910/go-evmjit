#include "callctx.h"
#include "stack.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>

extern int RunBinding(evm_callctx *callctx, unsigned char opcode, unsigned char *inputs, uint16_t inputs_len, uint16_t outputs_len, uint64_t *gasleft);

evm_callctx *callctx_init(uintptr_t goptr, evm_stack *stack, int gaslimit) {
    evm_callctx *ctx = (evm_callctx *)malloc(sizeof(evm_callctx));
    if (!ctx) {
        return NULL;
    }

    ctx->stack = stack;
    ctx->pc = 0;
    ctx->gas = gaslimit;
    ctx->opcode_fn = RunBinding;
    ctx->goptr = goptr;

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

int callctx_check_gas(uint64_t *gasleft, uint64_t gas) {
    if (*gasleft < gas) {
        return -13;
    }
    *gasleft -= gas;
    return 0;
}
