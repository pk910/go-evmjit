package irgen

import (
	"fmt"

	"github.com/pk910/go-evmjit/irgen/builder"
)

type EVM0Parser struct {
	irb *builder.IRBuilder
}

func NewEVM0Parser() *EVM0Parser {
	return &EVM0Parser{
		irb: builder.NewIRBuilder(),
	}
}

func (p *EVM0Parser) ParseCodeSection(name string, bytecode []byte) error {
	irf := builder.NewIRFunction(name, 1023, false)
	for i := uint32(0); i < uint32(len(bytecode)); {
		used, err := p.parseOpcode(irf, bytecode[i], bytecode[i+1:])
		if err != nil {
			return err
		}
		if used == 0 {
			return fmt.Errorf("invalid opcode: %d", bytecode[i])
		}
		i += uint32(used)
	}

	p.irb.AddFunction(irf)
	return nil
}

func (p *EVM0Parser) GenerateIR() string {
	return p.irb.String()
}

func (p *EVM0Parser) parseOpcode(irf *builder.IRFunction, opcode uint8, data []uint8) (used uint8, err error) {
	used = 1
	switch opcode {
	case 0x00: // STOP
		err = irf.AppendStop()
	case 0x01: // ADD
		err = irf.AppendAdd()
	case 0x02: // MUL
		err = irf.AppendMul()
	case 0x03: // SUB
		err = irf.AppendSub()
	case 0x04: // DIV
		err = irf.AppendHighOpcode(opcode, 2, 1, 5)
	case 0x05: // SDIV
		err = irf.AppendHighOpcode(opcode, 2, 1, 5)
	case 0x06: // MOD
		err = irf.AppendHighOpcode(opcode, 2, 1, 5)
	case 0x07: // SMOD
		err = irf.AppendHighOpcode(opcode, 2, 1, 5)
	case 0x08: // ADDMOD
		err = irf.AppendAddmod()
	case 0x09: // MULMOD
		err = irf.AppendMulmod()
	case 0x0A: // EXP
		err = irf.AppendHighOpcode(opcode, 2, 1, 0)
	case 0x0B: // SIGNEXTEND
		err = irf.AppendSignextend()
	case 0x10: // LT
		err = irf.AppendLt()
	case 0x11: // GT
		err = irf.AppendGt()
	case 0x12: // SLT
		err = irf.AppendSlt()
	case 0x13: // SGT
		err = irf.AppendSgt()
	case 0x14: // EQ
		err = irf.AppendEq()
	case 0x15: // ISZERO
		err = irf.AppendIsZero()
	case 0x16: // AND
		err = irf.AppendAnd()
	case 0x17: // OR
		err = irf.AppendOr()
	case 0x18: // XOR
		err = irf.AppendXor()
	case 0x19: // NOT
		err = irf.AppendNot()
	case 0x1A: // BYTE
		err = irf.AppendByte()
	case 0x1B: // SHL
		err = irf.AppendShl()
	case 0x1C: // SHR
		err = irf.AppendShr()
	case 0x1D: // SAR
		err = irf.AppendSar()
	case 0x20: // KECCAK256
		err = irf.AppendHighOpcode(opcode, 2, 1, 0)
	case 0x30: // ADDRESS
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x31: // BALANCE
		err = irf.AppendHighOpcode(opcode, 1, 1, 2)
	case 0x32: // ORIGIN
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x33: // CALLER
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x34: // CALLVALUE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x35: // CALLDATALOAD
		err = irf.AppendHighOpcode(opcode, 1, 1, 3)
	case 0x36: // CALLDATASIZE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x37: // CALLDATACOPY
		err = irf.AppendHighOpcode(opcode, 3, 0, 0)
	case 0x38: // CODESIZE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x39: // CODECOPY
		err = irf.AppendHighOpcode(opcode, 3, 0, 0)
	case 0x3A: // GASPRICE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x3B: // EXTCODESIZE
		err = irf.AppendHighOpcode(opcode, 1, 1, 0)
	case 0x3C: // EXTCODECOPY
		err = irf.AppendHighOpcode(opcode, 4, 0, 0)
	case 0x3D: // RETURNDATASIZE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x3E: // RETURNDATACOPY
		err = irf.AppendHighOpcode(opcode, 3, 0, 0)
	case 0x3F: // EXTCODEHASH
		err = irf.AppendHighOpcode(opcode, 1, 1, 0)
	case 0x40: // BLOCKHASH
		err = irf.AppendHighOpcode(opcode, 1, 1, 20)
	case 0x41: // COINBASE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x42: // TIMESTAMP
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x43: // NUMBER
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x44: // PREVRANDAO
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x45: // GASLIMIT
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x46: // CHAINID
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x47: // SELFBALANCE
		err = irf.AppendHighOpcode(opcode, 0, 1, 5)
	case 0x48: // BASEFEE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x49: // BLOBHASH
		err = irf.AppendHighOpcode(opcode, 1, 1, 3)
	case 0x4A: // BLOBBASEFEE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x50: // POP
		err = irf.AppendPop()
	case 0x51: // MLOAD
		err = irf.AppendHighOpcode(opcode, 1, 1, 0)
	case 0x52: // MSTORE
		err = irf.AppendHighOpcode(opcode, 2, 0, 0)
	case 0x53: // MSTORE8
		err = irf.AppendHighOpcode(opcode, 2, 0, 0)
	case 0x54: // SLOAD
		err = irf.AppendHighOpcode(opcode, 1, 1, 0)
	case 0x55: // SSTORE
		err = irf.AppendHighOpcode(opcode, 2, 0, 0)
	case 0x56: // JUMP
		err = irf.AppendJump()
	case 0x57: // JUMPI
		err = irf.AppendJumpI()
	case 0x58: // PC
		err = irf.AppendPc()
	case 0x59: // MSIZE
		err = irf.AppendHighOpcode(opcode, 0, 1, 2)
	case 0x5A: // GAS
		err = irf.AppendGas()
	case 0x5B: // JUMPDEST
		err = irf.AppendJumpDest()
	case 0x5C: // TLOAD
		err = irf.AppendHighOpcode(opcode, 1, 1, 100)
	case 0x5D: // TSTORE
		err = irf.AppendHighOpcode(opcode, 2, 0, 100)
	case 0x5E: // MCOPY
		err = irf.AppendHighOpcode(opcode, 3, 0, 0)
	case 0x5F: // PUSH0
		err = irf.AppendPushN(0, []uint8{})
	case 0x60: // PUSH1
		used += 1
		err = irf.AppendPushN(1, data[:1])
	case 0x61: // PUSH2
		used += 2
		err = irf.AppendPushN(2, data[:2])
	case 0x62: // PUSH3
		used += 3
		err = irf.AppendPushN(3, data[:3])
	case 0x63: // PUSH4
		used += 4
		err = irf.AppendPushN(4, data[:4])
	case 0x64: // PUSH5
		used += 5
		err = irf.AppendPushN(5, data[:5])
	case 0x65: // PUSH6
		used += 6
		err = irf.AppendPushN(6, data[:6])
	case 0x66: // PUSH7
		used += 7
		err = irf.AppendPushN(7, data[:7])
	case 0x67: // PUSH8
		used += 8
		err = irf.AppendPushN(8, data[:8])
	case 0x68: // PUSH9
		used += 9
		err = irf.AppendPushN(9, data[:9])
	case 0x69: // PUSH10
		used += 10
		err = irf.AppendPushN(10, data[:10])
	case 0x6A: // PUSH11
		used += 11
		err = irf.AppendPushN(11, data[:11])
	case 0x6B: // PUSH12
		used += 12
		err = irf.AppendPushN(12, data[:12])
	case 0x6C: // PUSH13
		used += 13
		err = irf.AppendPushN(13, data[:13])
	case 0x6D: // PUSH14
		used += 14
		err = irf.AppendPushN(14, data[:14])
	case 0x6E: // PUSH15
		used += 15
		err = irf.AppendPushN(15, data[:15])
	case 0x6F: // PUSH16
		used += 16
		err = irf.AppendPushN(16, data[:16])
	case 0x70: // PUSH17
		used += 17
		err = irf.AppendPushN(17, data[:17])
	case 0x71: // PUSH18
		used += 18
		err = irf.AppendPushN(18, data[:18])
	case 0x72: // PUSH19
		used += 19
		err = irf.AppendPushN(19, data[:19])
	case 0x73: // PUSH20
		used += 20
		err = irf.AppendPushN(20, data[:20])
	case 0x74: // PUSH21
		used += 21
		err = irf.AppendPushN(21, data[:21])
	case 0x75: // PUSH22
		used += 22
		err = irf.AppendPushN(22, data[:22])
	case 0x76: // PUSH23
		used += 23
		err = irf.AppendPushN(23, data[:23])
	case 0x77: // PUSH24
		used += 24
		err = irf.AppendPushN(24, data[:24])
	case 0x78: // PUSH25
		used += 25
		err = irf.AppendPushN(25, data[:25])
	case 0x79: // PUSH26
		used += 26
		err = irf.AppendPushN(26, data[:26])
	case 0x7A: // PUSH27
		used += 27
		err = irf.AppendPushN(27, data[:27])
	case 0x7B: // PUSH28
		used += 28
		err = irf.AppendPushN(28, data[:28])
	case 0x7C: // PUSH29
		used += 29
		err = irf.AppendPushN(29, data[:29])
	case 0x7D: // PUSH30
		used += 30
		err = irf.AppendPushN(30, data[:30])
	case 0x7E: // PUSH31
		used += 31
		err = irf.AppendPushN(31, data[:31])
	case 0x7F: // PUSH32
		used += 32
		err = irf.AppendPushN(32, data[:32])
	case 0x80: // DUP1
		err = irf.AppendDupN(1)
	case 0x81: // DUP2
		err = irf.AppendDupN(2)
	case 0x82: // DUP3
		err = irf.AppendDupN(3)
	case 0x83: // DUP4
		err = irf.AppendDupN(4)
	case 0x84: // DUP5
		err = irf.AppendDupN(5)
	case 0x85: // DUP6
		err = irf.AppendDupN(6)
	case 0x86: // DUP7
		err = irf.AppendDupN(7)
	case 0x87: // DUP8
		err = irf.AppendDupN(8)
	case 0x88: // DUP9
		err = irf.AppendDupN(9)
	case 0x89: // DUP10
		err = irf.AppendDupN(10)
	case 0x8A: // DUP11
		err = irf.AppendDupN(11)
	case 0x8B: // DUP12
		err = irf.AppendDupN(12)
	case 0x8C: // DUP13
		err = irf.AppendDupN(13)
	case 0x8D: // DUP14
		err = irf.AppendDupN(14)
	case 0x8E: // DUP15
		err = irf.AppendDupN(15)
	case 0x8F: // DUP16
		err = irf.AppendDupN(16)
	case 0x90: // SWAP1
		err = irf.AppendSwapN(1)
	case 0x91: // SWAP2
		err = irf.AppendSwapN(2)
	case 0x92: // SWAP3
		err = irf.AppendSwapN(3)
	case 0x93: // SWAP4
		err = irf.AppendSwapN(4)
	case 0x94: // SWAP5
		err = irf.AppendSwapN(5)
	case 0x95: // SWAP6
		err = irf.AppendSwapN(6)
	case 0x96: // SWAP7
		err = irf.AppendSwapN(7)
	case 0x97: // SWAP8
		err = irf.AppendSwapN(8)
	case 0x98: // SWAP9
		err = irf.AppendSwapN(9)
	case 0x99: // SWAP10
		err = irf.AppendSwapN(10)
	case 0x9A: // SWAP11
		err = irf.AppendSwapN(11)
	case 0x9B: // SWAP12
		err = irf.AppendSwapN(12)
	case 0x9C: // SWAP13
		err = irf.AppendSwapN(13)
	case 0x9D: // SWAP14
		err = irf.AppendSwapN(14)
	case 0x9E: // SWAP15
		err = irf.AppendSwapN(15)
	case 0x9F: // SWAP16
		err = irf.AppendSwapN(16)
	case 0xA0: // LOG0
		err = irf.AppendHighOpcode(opcode, 2, 0, 0)
	case 0xA1: // LOG1
		err = irf.AppendHighOpcode(opcode, 3, 0, 0)
	case 0xA2: // LOG2
		err = irf.AppendHighOpcode(opcode, 4, 0, 0)
	case 0xA3: // LOG3
		err = irf.AppendHighOpcode(opcode, 5, 0, 0)
	case 0xA4: // LOG4
		err = irf.AppendHighOpcode(opcode, 6, 0, 0)
	case 0xF0: // CREATE
		err = irf.AppendHighOpcode(opcode, 3, 1, 0)
	case 0xF1: // CALL
		err = irf.AppendHighOpcode(opcode, 7, 1, 0)
	case 0xF2: // CALLCODE
		err = irf.AppendHighOpcode(opcode, 7, 1, 0)
	case 0xF3: // RETURN
		err = irf.AppendHighOpcode(opcode, 2, 0, 0)
	case 0xF4: // DELEGATECALL
		err = irf.AppendHighOpcode(opcode, 6, 1, 0)
	case 0xF5: // CREATE2
		err = irf.AppendHighOpcode(opcode, 4, 1, 0)
	case 0xFD: // REVERT
		err = irf.AppendHighOpcode(opcode, 2, 0, 0)
	case 0xFE: // INVALID
		err = irf.AppendHighOpcode(opcode, 0, 0, 0)
	case 0xFF: // SELFDESTRUCT
		err = irf.AppendHighOpcode(opcode, 1, 0, 0)
	default: // ignore invalid opcodes
		return 1, nil
	}

	return used, err
}
