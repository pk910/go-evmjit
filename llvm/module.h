#ifndef MODULE_H
#define MODULE_H

#include <llvm-c/Core.h>
#include <llvm-c/ExecutionEngine.h>

#include "evm_callctx.h"

LLVMModuleRef parseIR(const char* ir, char** error);
void optimizeModule(LLVMModuleRef mod);
LLVMExecutionEngineRef createJIT(LLVMModuleRef module, char** error);
void disposeError(char** error);

typedef int32_t (*jit_func_ptr)(void *);
int32_t call_jit_func(jit_func_ptr fn, struct evm_callctx *callctx);

#endif