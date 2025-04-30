#include "evm_callctx.h"
#include "evm_stack.h"
#include "evm_math.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int callctx_opcode_callback(evm_callctx *callctx, unsigned char opcode, unsigned char *inputs, uint16_t inputs_len, unsigned char *outputs, uint16_t outputs_len);

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

int callctx_opcode_callback(evm_callctx *callctx, unsigned char opcode, unsigned char *inputs, uint16_t inputs_len, unsigned char *outputs, uint16_t outputs_len) {
    assert(callctx != NULL);

    printf("EVM-C [OP: %d] ", opcode);
    if (inputs) {
        printf("in (%d): 0x", inputs_len / 32);
        for (int i = 0; i < inputs_len; i++) {
            printf("%02x", inputs[i]);
        }
        printf(" ");
    }

    int res = 0;
    switch (opcode) {
        case 0x04: res = evm_math_div(inputs + 32, inputs, outputs); break;
        case 0x05: res = evm_math_sdiv(inputs + 32, inputs, outputs); break;
        case 0x06: res = evm_math_mod(inputs + 32, inputs, outputs); break;
        case 0x07: res = evm_math_smod(inputs + 32, inputs, outputs); break;
        default:
            res = -1;
    }

    if(outputs) {
        printf("out (%d): 0x", outputs_len / 32);
        for (int i = 0; i < outputs_len; i++) {
            printf("%02x", outputs[i]);
        }
    }
    printf("\n");

    return 0;
}
