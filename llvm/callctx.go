package llvm

/*
#cgo CFLAGS: -I/usr/lib/llvm-14/include
#cgo LDFLAGS: -L/usr/lib/llvm-14/lib -lLLVM

#include <stdlib.h>
#include "stack.h"
#include "callctx.h"

*/
import "C"
import (
	"errors"
	"fmt"
	"runtime/cgo"
	"unsafe"

	"github.com/holiman/uint256"
	"github.com/pk910/go-evmjit/llvm/types"
)

type CallCtx struct {
	callctx      *C.evm_callctx
	stack        *C.evm_stack
	handle       cgo.Handle
	disposeStack bool
	gaslimit     uint64
	opbindings   types.OpBindings
	userValue    interface{}
}

func NewCallCtx(stack *C.evm_stack, gaslimit uint64, userValue interface{}) (types.CallCtx, error) {
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
		userValue:    userValue,
	}

	callctx.handle = cgo.NewHandle(callctx)

	callctx.callctx = C.callctx_init(C.uintptr_t(callctx.handle), stack, C.int(gaslimit))
	if callctx.callctx == nil {
		return nil, errors.New("failed to initialize callctx")
	}

	return callctx, nil
}

func (c *CallCtx) Dispose() {
	if c.disposeStack {
		C.stack_free(c.stack)
	}
	cgo.Handle(c.handle).Delete()
	C.callctx_free(c.callctx)
}

func (c *CallCtx) SetOpBindings(opbindings types.OpBindings) {
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

func (c *CallCtx) GetUserValue() interface{} {
	return c.userValue
}

//export RunBinding
func RunBinding(c *C.evm_callctx, opcode uint8, inputs_ptr *C.uint8_t, inputs_len C.uint16_t, output_ptr *C.uint8_t, output_len C.uint16_t, gasleft *C.uint64_t) C.int32_t {
	callctx := cgo.Handle(c.goptr).Value().(*CallCtx)

	opbindings := callctx.opbindings
	if opbindings == nil {
		fmt.Println("No opbindings found")
		return C.int32_t(-1)
	}

	binding := opbindings.GetBinding(opcode)
	if binding == nil {
		return C.int32_t(-1)
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
		inputs = (*[1 << 27]uint256.Int)(unsafe.Pointer(inputs_ptr))[:words:words]
	}

	var output []uint256.Int
	if output_len > 0 {
		words := int(output_len) / 32
		output = (*[1 << 27]uint256.Int)(unsafe.Pointer(output_ptr))[:words:words]
	}

	err := binding(callctx, inputs, output, (*uint64)(unsafe.Pointer(gasleft)))
	if err != nil {
		switch err {
		case types.ErrStackUnderflow:
			return C.int32_t(-10)
		case types.ErrStackOverflow:
			return C.int32_t(-11)
		case types.ErrOutOfGas:
			return C.int32_t(-13)
		default:
			return C.int32_t(-1)
		}
	}
	return C.int32_t(0)
}
