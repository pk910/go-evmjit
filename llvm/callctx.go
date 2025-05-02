package llvm

/*
#cgo CFLAGS: -I/usr/lib/llvm-14/include
#cgo LDFLAGS: -L/usr/lib/llvm-14/lib -lLLVM

#include <stdlib.h>
#include "evm_stack.h"
#include "evm_callctx.h"

*/
import "C"
import (
	"errors"
	"unsafe"
)

type CallCtx struct {
	callctx      *C.evm_callctx
	stack        *C.evm_stack
	disposeStack bool
	gaslimit     uint64
	opbindings   *OpBindings
}

func NewCallCtx(stack *C.evm_stack, gaslimit uint64) (*CallCtx, error) {
	disposeStack := false
	if stack == nil {
		stack = C.stack_init(C.uint16_t(512))
		if stack == nil {
			return nil, errors.New("failed to initialize stack")
		}

		disposeStack = true
	}

	callctx := &CallCtx{
		stack:        stack,
		disposeStack: disposeStack,
		gaslimit:     gaslimit,
	}

	callctx.callctx = C.callctx_init(unsafe.Pointer(callctx), stack, C.int(gaslimit))
	if callctx.callctx == nil {
		return nil, errors.New("failed to initialize callctx")
	}

	return callctx, nil
}

func (c *CallCtx) Dispose() {
	if c.disposeStack {
		C.stack_free(c.stack)
	}
	C.callctx_free(c.callctx)
}

func (c *CallCtx) SetOpBindings(opbindings *OpBindings) {
	c.opbindings = opbindings
}

func (c *CallCtx) GetPC() uint64 {
	return uint64(C.callctx_get_pc(c.callctx))
}

func (c *CallCtx) GetGas() uint64 {
	return uint64(C.callctx_get_gas(c.callctx))
}

func (c *CallCtx) PrintStack(n int) {
	C.stack_print_item(c.stack, C.int(n))
}

func (c *CallCtx) GetStackSize() int {
	return int(C.stack_get_size(c.stack))
}
