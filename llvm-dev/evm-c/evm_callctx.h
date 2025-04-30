#ifndef EVM_CALLCTX_H
#define EVM_CALLCTX_H

#include <stdint.h>
#include "evm_stack.h"

typedef int (*opcode_func_ptr)(void *callctx, uint8_t opcode, uint8_t *inputs, uint8_t inputs_len, uint8_t *outputs, uint8_t outputs_len);

struct evm_callctx {
    evm_stack *stack;
    uint64_t pc;
    uint64_t gas;
    opcode_func_ptr opcode_fn;
    void *custom_data;
};

typedef struct evm_callctx evm_callctx;

evm_callctx *callctx_init(evm_stack *stack);
void callctx_free(evm_callctx *callctx);
uint64_t callctx_get_pc(evm_callctx *callctx);
uint64_t callctx_get_gas(evm_callctx *callctx);

#endif