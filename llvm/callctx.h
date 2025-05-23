#ifndef CALLCTX_H
#define CALLCTX_H

#include <stdint.h>

struct evm_callctx;
typedef struct evm_callctx evm_callctx;
typedef int (*opcode_func_ptr)(evm_callctx *callctx, unsigned char opcode, unsigned char *inputs, uint16_t inputs_len, uint16_t outputs_len, uint64_t *gasleft);

struct evm_callctx {
    uint8_t *stack;
    uint64_t sp;
    uint64_t pc;
    uint64_t gas;
    opcode_func_ptr opcode_fn;
    uintptr_t goptr;
};

evm_callctx *callctx_init(uint8_t *stack, uint64_t sp, uint64_t gaslimit, uintptr_t goptr);
void callctx_free(evm_callctx *callctx);
uint64_t callctx_get_sp(evm_callctx *callctx);
uint64_t callctx_get_pc(evm_callctx *callctx);
uint64_t callctx_get_gas(evm_callctx *callctx);
int callctx_print_stack_item(evm_callctx *callctx, int n);

#endif