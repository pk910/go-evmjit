package bindings

import (
	"github.com/pk910/go-evmjit/llvm/types"
)

type OpBindings struct {
	bindings [256]types.OpBindingFn
}

func NewOpBindings() types.OpBindings {
	return &OpBindings{}
}

func (b *OpBindings) Dispose() {

}

func (b *OpBindings) AddBinding(opcode uint8, fn types.OpBindingFn) {
	b.bindings[opcode] = fn
}

func (b *OpBindings) GetBinding(opcode uint8) types.OpBindingFn {
	return b.bindings[opcode]
}
