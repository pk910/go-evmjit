package types

import (
	"errors"

	"github.com/holiman/uint256"
)

var (
	ErrStackUnderflow = errors.New("stack underflow")
	ErrStackOverflow  = errors.New("stack overflow")
	ErrOutOfGas       = errors.New("out of gas")
)

type CallCtx interface {
	Dispose()
	SetOpBindings(opbindings OpBindings)
	GetPC() uint64
	GetGas() uint64
	PrintStack(n int)
	GetStackSize() int
}

type OpBindingFn func(c CallCtx, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) error

type OpBindings interface {
	Dispose()
	AddBinding(opcode uint8, fn OpBindingFn)
	GetBinding(opcode uint8) OpBindingFn
}
