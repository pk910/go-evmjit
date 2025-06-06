package llvm

/*
#cgo CFLAGS: -I/usr/lib/llvm-14/include
#cgo LDFLAGS: -L/usr/lib/llvm-14/lib -lLLVM

#include <stdlib.h>
#include <stdint.h>
#include "callctx.h"

*/
import "C"
import (
	"errors"
	"runtime/cgo"
	"unsafe"

	"github.com/holiman/uint256"
	"github.com/pk910/go-evmjit/llvm/types"
)

type CallCtx struct {
	callctx       *C.evm_callctx
	stack         unsafe.Pointer
	handle        cgo.Handle
	disposeStack  bool
	gaslimit      uint64
	opbindings    types.OpBindings
	opcallback    types.OpBindingFn
	debugcallback types.DbgBindingFn
	userValue     interface{}
}

func NewCallCtx(stack unsafe.Pointer, sp uint64, gaslimit uint64, userValue interface{}) (types.CallCtx, error) {
	disposeStack := false
	if stack == nil {
		stack = C.malloc(C.uint64_t(1023 * 32))
		if stack == nil {
			return nil, errors.New("failed to initialize stack")
		}

		disposeStack = true
	}

	callctx := &CallCtx{
		stack:        stack,
		disposeStack: disposeStack,
		gaslimit:     gaslimit,
		userValue:    userValue,
	}

	callctx.handle = cgo.NewHandle(callctx)

	callctx.callctx = C.callctx_init((*C.uint8_t)(stack), C.uint64_t(sp), C.uint64_t(gaslimit), C.uintptr_t(callctx.handle))
	if callctx.callctx == nil {
		return nil, errors.New("failed to initialize callctx")
	}

	return callctx, nil
}

func (c *CallCtx) Dispose() {
	if c.disposeStack {
		C.free(c.stack)
	}
	cgo.Handle(c.handle).Delete()
	C.callctx_free(c.callctx)
}

func (c *CallCtx) SetOpBindings(opbindings types.OpBindings) {
	c.opbindings = opbindings
}

func (c *CallCtx) SetOpCallback(opcallback types.OpBindingFn) {
	c.opcallback = opcallback
}

func (c *CallCtx) SetDebugCallback(debugcallback types.DbgBindingFn) {
	c.debugcallback = debugcallback
}

func (c *CallCtx) GetPC() uint64 {
	return uint64(C.callctx_get_pc(c.callctx))
}

func (c *CallCtx) GetGas() uint64 {
	return uint64(C.callctx_get_gas(c.callctx))
}

func (c *CallCtx) PrintStack(n int) {
	C.callctx_print_stack_item(c.callctx, C.int(n))
}

func (c *CallCtx) GetStackSize() int {
	return int(C.callctx_get_sp(c.callctx))
}

func (c *CallCtx) GetUserValue() interface{} {
	return c.userValue
}

//export RunBinding
func RunBinding(c *C.evm_callctx, opcode uint8, stack_ptr *C.uint8_t, inputs_len C.uint16_t, output_len C.uint16_t, gasleft *C.uint64_t) C.int32_t {
	callctx := cgo.Handle(c.goptr).Value().(*CallCtx)

	if stack_ptr == nil && inputs_len > 0 {
		if callctx.debugcallback != nil {
			return C.int32_t(callctx.debugcallback(callctx, callctx.GetPC(), (*uint64)(unsafe.Pointer(gasleft))))
		}
		return C.int32_t(0)
	}

	var binding types.OpBindingFn

	if callctx.opcallback != nil {
		binding = callctx.opcallback
	} else {
		opbindings := callctx.opbindings
		if opbindings == nil {
			return C.int32_t(-1)
		}

		binding = opbindings.GetBinding(opcode)
		if binding == nil {
			return C.int32_t(-1)
		}
	}

	// Interpret the raw byte-input as a slice of `uint256.Int` without copying
	// Each `uint256.Int` occupies exactly 32 bytes (4 * uint64). We can therefore
	// compute how many 256-bit words we received and cast the underlying memory
	// accordingly. The bytes are already in little-endian order, which matches
	// the internal limb ordering of `uint256.Int` on little-endian machines, so
	// no additional swapping is necessary.

	var inputs []uint256.Int
	if inputs_len > 0 {
		words := int(inputs_len) / 32
		inputs = (*[1 << 27]uint256.Int)(unsafe.Pointer(stack_ptr))[:words:words]
	}

	var output []uint256.Int
	if output_len > 0 {
		words := int(output_len) / 32
		output = (*[1 << 27]uint256.Int)(unsafe.Pointer(stack_ptr))[:words:words]
	}

	return C.int32_t(binding(callctx, opcode, inputs, output, (*uint64)(unsafe.Pointer(gasleft))))
}
