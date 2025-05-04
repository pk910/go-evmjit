package bindings

import (
	"github.com/holiman/uint256"
	"github.com/pk910/go-evmjit/llvm/types"
)

func MathDiv(c types.CallCtx, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) error {
	inputs[0].Div(&inputs[1], &inputs[0])
	return nil
}

func MathMod(c types.CallCtx, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) error {
	inputs[0].Mod(&inputs[1], &inputs[0])
	return nil
}

func MathSDiv(c types.CallCtx, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) error {
	inputs[0].SDiv(&inputs[1], &inputs[0])
	return nil
}

func MathSMod(c types.CallCtx, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) error {
	inputs[0].SMod(&inputs[1], &inputs[0])
	return nil
}

func MathExp(c types.CallCtx, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) error {
	// dynamic gas cost
	expBytes := inputs[0].ByteLen()
	dynamicGas := uint64(50) * uint64(expBytes)
	totalGas := uint64(10) + dynamicGas
	if *gasleft < totalGas {
		return types.ErrOutOfGas
	}
	*gasleft -= totalGas

	inputs[0].Exp(&inputs[1], &inputs[0])
	return nil
}
