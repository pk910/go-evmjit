#ifndef EVM_CALLCTX_H
#define EVM_CALLCTX_H

#include <stdint.h>
#include "evm_stack.h"

struct evm_callctx;
typedef struct evm_callctx evm_callctx;
typedef int (*opcode_func_ptr)(evm_callctx *callctx, unsigned char opcode, unsigned char *inputs, uint16_t inputs_len, unsigned char *outputs, uint16_t outputs_len);

struct evm_callctx {
    evm_stack *stack;
    uint64_t pc;
    uint64_t gas;
    opcode_func_ptr opcode_fn;
    void *custom_data;
};

evm_callctx *callctx_init(evm_stack *stack);
void callctx_free(evm_callctx *callctx);
uint64_t callctx_get_pc(evm_callctx *callctx);
uint64_t callctx_get_gas(evm_callctx *callctx);

#endif