package llvm

/*
#include <stdlib.h>
#include "evm_callctx.h"
*/
import "C"
import (
	"errors"
	"fmt"
	"unsafe"
)

type OpBindingFn func(c *CallCtx, inputs []byte, output []byte, gasleft *uint64) error

var (
	ErrStackUnderflow = errors.New("stack underflow")
	ErrStackOverflow  = errors.New("stack overflow")
	ErrOutOfGas       = errors.New("out of gas")
)

type OpBindings struct {
	bindings map[uint8]OpBindingFn
}

func NewOpBindings() *OpBindings {
	return &OpBindings{
		bindings: make(map[uint8]OpBindingFn),
	}
}

func (b *OpBindings) Dispose() {

}

func (b *OpBindings) AddBinding(opcode uint8, fn OpBindingFn) {
	b.bindings[opcode] = fn
}

//export RunBinding
func RunBinding(c *C.evm_callctx, opcode uint8, inputs *C.uint8_t, inputs_len C.uint16_t, output *C.uint8_t, output_len C.uint16_t, gasleft *C.uint64_t) C.int32_t {
	callctx := (*CallCtx)(c.goptr)
	opbindings := callctx.opbindings
	if opbindings == nil {
		fmt.Println("No opbindings found")
		return C.int32_t(-1)
	}

	binding := opbindings.bindings[opcode]
	if binding == nil {
		return C.int32_t(-1)
	}

	inputs_slice := (*[1 << 31]byte)(unsafe.Pointer(inputs))[:inputs_len:inputs_len]
	output_slice := (*[1 << 31]byte)(unsafe.Pointer(output))[:output_len:output_len]

	err := binding(callctx, inputs_slice, output_slice, (*uint64)(unsafe.Pointer(gasleft)))
	if err == nil {
		switch err {
		case ErrStackUnderflow:
			return C.int32_t(-10)
		case ErrStackOverflow:
			return C.int32_t(-11)
		case ErrOutOfGas:
			return C.int32_t(-13)
		default:
			return C.int32_t(-1)
		}
	}
	return C.int32_t(0)
}
