#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "module.h"

#include <llvm-c/Core.h>
#include <llvm-c/ExecutionEngine.h>
#include <llvm-c/Target.h>
#include <llvm-c/Analysis.h>
#include <llvm-c/IRReader.h>
#include <llvm-c/Support.h>
#include <llvm-c/BitWriter.h>
#include <llvm-c/BitReader.h>

LLVMModuleRef parseIR(const char* ir) {
    LLVMModuleRef mod = NULL;
    char *error = NULL;

    LLVMMemoryBufferRef buf = LLVMCreateMemoryBufferWithMemoryRangeCopy(ir, strlen(ir), "buffer");
    if (LLVMParseIRInContext(LLVMGetGlobalContext(), buf, &mod, &error) != 0) {
        LLVMDisposeMessage(error);
        return NULL;
    }
    return mod;
}

LLVMExecutionEngineRef createJIT(LLVMModuleRef module) {
    LLVMExecutionEngineRef engine;
    char *error = NULL;
    if (LLVMCreateJITCompilerForModule(&engine, module, 2, &error) != 0) {
        LLVMDisposeMessage(error);
        return NULL;
    }
    return engine;
}

typedef int32_t (*jit_func_ptr)(void *);
int32_t call_jit_func(jit_func_ptr fn, struct evm_callctx *callctx) {
	printf("Calling JIT function\n StackPos: %d\n", callctx->stack->position);
    return fn(callctx);
}
