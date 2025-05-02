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
#include <llvm-c/Transforms/PassManagerBuilder.h>

extern void LLVMAddPromoteMemoryToRegisterPass(LLVMPassManagerRef pm);

LLVMModuleRef parseIR(const char* ir, char** error) {
    LLVMModuleRef mod = NULL;

    LLVMMemoryBufferRef buf = LLVMCreateMemoryBufferWithMemoryRangeCopy(ir, strlen(ir), "buffer");
    if (LLVMParseIRInContext(LLVMGetGlobalContext(), buf, &mod, error) != 0) 
        return NULL;
    return mod;
}

void optimizeModule(LLVMModuleRef mod) {
    LLVMPassManagerRef pm = LLVMCreatePassManager();
    LLVMPassManagerBuilderRef builder = LLVMPassManagerBuilderCreate();

    LLVMPassManagerBuilderSetOptLevel(builder, 2); // -O2
    LLVMPassManagerBuilderPopulateModulePassManager(builder, pm);
    LLVMRunPassManager(pm, mod);

    LLVMPassManagerBuilderDispose(builder);
    LLVMDisposePassManager(pm);
}

LLVMExecutionEngineRef createJIT(LLVMModuleRef module, char** error) {
    LLVMExecutionEngineRef engine;
    if (LLVMCreateJITCompilerForModule(&engine, module, 2, error) != 0) {
        return NULL;
    }
    return engine;
}

void disposeError(char** error) {
    if (*error != NULL) {
        LLVMDisposeMessage(*error);
    }
}

typedef int32_t (*jit_func_ptr)(void *);
int32_t call_jit_func(jit_func_ptr fn, struct evm_callctx *callctx) {
	//printf("Calling JIT function\n StackPos: %d\n", callctx->stack->position);
    printf("Calling JIT function\n");
    return fn(callctx);
}
