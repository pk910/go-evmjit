package bindings

import (
	"github.com/holiman/uint256"
	"github.com/pk910/go-evmjit/llvm/types"
)

func MathDiv(c types.CallCtx, op uint8, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) int32 {
	inputs[0].Div(&inputs[1], &inputs[0])
	return 0
}

func MathMod(c types.CallCtx, op uint8, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) int32 {
	inputs[0].Mod(&inputs[1], &inputs[0])
	return 0
}

func MathSDiv(c types.CallCtx, op uint8, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) int32 {
	inputs[0].SDiv(&inputs[1], &inputs[0])
	return 0
}

func MathSMod(c types.CallCtx, op uint8, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) int32 {
	inputs[0].SMod(&inputs[1], &inputs[0])
	return 0
}

func MathExp(c types.CallCtx, op uint8, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) int32 {
	// dynamic gas cost
	expBytes := inputs[0].ByteLen()
	dynamicGas := uint64(50) * uint64(expBytes)
	totalGas := uint64(10) + dynamicGas
	if *gasleft < totalGas {
		return -13
	}
	*gasleft -= totalGas

	inputs[0].Exp(&inputs[1], &inputs[0])
	return 0
}
