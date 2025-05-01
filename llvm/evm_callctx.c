#include "evm_callctx.h"
#include "evm_stack.h"
#include "evm_math.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int callctx_opcode_callback(evm_callctx *callctx, unsigned char opcode, unsigned char *inputs, uint16_t inputs_len, unsigned char *outputs, uint16_t outputs_len, uint64_t *gasleft);

evm_callctx *callctx_init(evm_stack *stack, int gaslimit) {
    evm_callctx *ctx = (evm_callctx *)malloc(sizeof(evm_callctx));
    if (!ctx) {
        return NULL;
    }

    ctx->stack = stack;
    ctx->pc = 0;
    ctx->gas = gaslimit;
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

int callctx_check_gas(uint64_t *gasleft, uint64_t gas) {
    if (*gasleft < gas) {
        return -13;
    }
    *gasleft -= gas;
    return 0;
}

int callctx_opcode_callback(evm_callctx *callctx, unsigned char opcode, unsigned char *inputs, uint16_t inputs_len, unsigned char *outputs, uint16_t outputs_len, uint64_t *gasleft) {
    assert(callctx != NULL);

    printf("EVM-C [OP: %d", opcode);
    if (gasleft) {
        printf(", gas: %d", *gasleft);
    }
    printf("] ");
    if (inputs) {
        printf("in (%d): 0x", inputs_len / 32);
        for (int i = 0; i < inputs_len; i++) {
            printf("%02x", inputs[i]);
        }
        printf(" ");
    }

    int res = 0;
    switch (opcode) {
        case 0x04:
            if (res = callctx_check_gas(gasleft, 5) == 0)
                res = evm_math_div(inputs + 32, inputs, outputs);
            break;
        case 0x05:
            if (res = callctx_check_gas(gasleft, 5) == 0)
                res = evm_math_sdiv(inputs + 32, inputs, outputs);
            break;
        case 0x06:
            if (res = callctx_check_gas(gasleft, 5) == 0)
                res = evm_math_mod(inputs + 32, inputs, outputs);
            break;
        case 0x07:
            if (res = callctx_check_gas(gasleft, 5) == 0)
                res = evm_math_smod(inputs + 32, inputs, outputs);
            break;
        case 0x0A:
            res = evm_math_exp(inputs + 32, inputs, outputs, gasleft);
            break;
        default:
            res = -1;
    }

    if(outputs) {
        printf("out (%d): 0x", outputs_len / 32);
        for (int i = 0; i < outputs_len; i++) {
            printf("%02x", outputs[i]);
        }
    }
    printf(" res: %d\n", res);
    printf("\n");

    return res;
}
