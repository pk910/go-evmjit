package types

import (
	"errors"

	"github.com/holiman/uint256"
)

var (
	ErrStackUnderflow = errors.New("stack underflow")
	ErrStackOverflow  = errors.New("stack overflow")
	ErrOutOfGas       = errors.New("out of gas")
	ErrStopToken      = errors.New("stop token")
)

type Module interface {
	LoadIR(ir string) error
	Dispose()
	InitEngine() error
	Call(callctx CallCtx, name string) (int, error)
	Marshal() ([]byte, error)
	Unmarshal(data []byte) error
}

type CallCtx interface {
	Dispose()
	SetOpBindings(opbindings OpBindings)
	SetOpCallback(opcallback OpBindingFn)
	GetPC() uint64
	GetGas() uint64
	PrintStack(n int)
	GetStackSize() int
	GetUserValue() interface{}
}

type OpBindingFn func(c CallCtx, op uint8, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) error

type OpBindings interface {
	Dispose()
	AddBinding(opcode uint8, fn OpBindingFn)
	GetBinding(opcode uint8) OpBindingFn
}
