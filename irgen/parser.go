package irgen

import "errors"

var (
	ErrInvalidOpcode = errors.New("invalid opcode")
)

type ContractParser interface {
	ParseCodeSection(name string, bytecode []byte) error
	GenerateIR() string
}

func NewParser(evmVersion string) ContractParser {
	switch evmVersion {
	case "evm0":
		return NewEVM0Parser()
	default:
		return nil
	}
}
