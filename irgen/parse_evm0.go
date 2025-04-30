package irgen

import "fmt"

func ParseOpcode_evm0(irf *IRFunction, opcode uint8, data []uint8) (used uint8, err error) {
	used = 1
	switch opcode {
	case 0x00:
		return 0, nil
	case 0x01: // ADD
		err = irf.AppendAdd()
	case 0x02: // MUL
		err = irf.AppendMul()
	case 0x03: // SUB
		err = irf.AppendSub()
	case 0x04: // DIV
		err = irf.AppendDiv()
	case 0x05: // SDIV
		err = fmt.Errorf("not implemented")
	case 0x06: // MOD
		err = fmt.Errorf("not implemented")
	case 0x07: // SMOD
		err = fmt.Errorf("not implemented")
	case 0x08: // ADDMOD
		err = fmt.Errorf("not implemented")
	case 0x09: // MULMOD
		err = fmt.Errorf("not implemented")
	case 0x0A: // EXP
		err = fmt.Errorf("not implemented")
	case 0x0B: // SIGNEXTEND
		err = fmt.Errorf("not implemented")
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
		err = fmt.Errorf("not implemented")
	case 0x30: // ADDRESS
		err = fmt.Errorf("not implemented")

	case 0x5F: // PUSH0
		err = irf.AppendPushN(0, data)
	case 0x60: // PUSH1
		used += 1
		err = irf.AppendPushN(1, data)
	case 0x61: // PUSH2
		used += 2
		err = irf.AppendPushN(2, data)
	case 0x62: // PUSH3
		used += 3
		err = irf.AppendPushN(3, data)
	case 0x63: // PUSH4
		used += 4
		err = irf.AppendPushN(4, data)
	case 0x64: // PUSH5
		used += 5
		err = irf.AppendPushN(5, data)
	case 0x65: // PUSH6
		used += 6
		err = irf.AppendPushN(6, data)
	case 0x66: // PUSH7
		used += 7
		err = irf.AppendPushN(7, data)
	case 0x67: // PUSH8
		used += 8
		err = irf.AppendPushN(8, data)
	case 0x68: // PUSH9
		used += 9
		err = irf.AppendPushN(9, data)
	case 0x69: // PUSH10
		used += 10
		err = irf.AppendPushN(10, data)
	case 0x6A: // PUSH11
		used += 11
		err = irf.AppendPushN(11, data)
	case 0x6B: // PUSH12
		used += 12
		err = irf.AppendPushN(12, data)
	case 0x6C: // PUSH13
		used += 13
		err = irf.AppendPushN(13, data)
	case 0x6D: // PUSH14
		used += 14
		err = irf.AppendPushN(14, data)
	case 0x6E: // PUSH15
		used += 15
		err = irf.AppendPushN(15, data)
	case 0x6F: // PUSH16
		used += 16
		err = irf.AppendPushN(16, data)
	case 0x70: // PUSH17
		used += 17
		err = irf.AppendPushN(17, data)
	case 0x71: // PUSH18
		used += 18
		err = irf.AppendPushN(18, data)
	case 0x72: // PUSH19
		used += 19
		err = irf.AppendPushN(19, data)
	case 0x73: // PUSH20
		used += 20
		err = irf.AppendPushN(20, data)
	case 0x74: // PUSH21
		used += 21
		err = irf.AppendPushN(21, data)
	case 0x75: // PUSH22
		used += 22
		err = irf.AppendPushN(22, data)
	case 0x76: // PUSH23
		used += 23
		err = irf.AppendPushN(23, data)
	case 0x77: // PUSH24
		used += 24
		err = irf.AppendPushN(24, data)
	case 0x78: // PUSH25
		used += 25
		err = irf.AppendPushN(25, data)
	case 0x79: // PUSH26
		used += 26
		err = irf.AppendPushN(26, data)
	case 0x7A: // PUSH27
		used += 27
		err = irf.AppendPushN(27, data)
	case 0x7B: // PUSH28
		used += 28
		err = irf.AppendPushN(28, data)
	case 0x7C: // PUSH29
		used += 29
		err = irf.AppendPushN(29, data)
	case 0x7D: // PUSH30
		used += 30
		err = irf.AppendPushN(30, data)
	case 0x7E: // PUSH31
		used += 31
		err = irf.AppendPushN(31, data)
	case 0x7F: // PUSH32
		used += 32
		err = irf.AppendPushN(32, data)
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

	default:
		return 0, fmt.Errorf("unknown opcode: %d", opcode)
	}

	return used, err
}
