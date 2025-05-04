# go-evmjit

> **Warning:** This is a highly experimental Work-In-Progress (WIP) project. It is NOT suitable for production use. Use at your own risk.

`go-evmjit` aims to be an Ethereum Virtual Machine (EVM) Just-In-Time (JIT) compiler for Go, leveraging LLVM for optimization and code generation.

## Modules

The project is primarily divided into two main Go modules:

*   **`irgen`:** Responsible for parsing EVM bytecode (currently focusing on a subset defined as "EVM0") and generating corresponding LLVM Intermediate Representation (IR).
*   **`llvm`:** Handles the interaction with the LLVM libraries via CGo. This includes parsing the generated IR, applying optimization passes, and potentially JIT-compiling and executing the code. It also provides hooks for Go-based opcode implementations (bindings).

## Programmatic Usage

While the `cmd/evmjit` tool provides helpful utilities, the core functionality is designed to be used programmatically within Go applications.

### Generating LLVM IR from Bytecode

```go
package main

import (
	"encoding/hex"
	"fmt"
	"log"

	"github.com/pk910/go-evmjit/irgen"
)

func main() {
	// Example: PUSH1 0x42 PUSH1 0x01 ADD STOP -> 604260010100
	bytecodeHex := "604260010100"
	bytecode, err := hex.DecodeString(bytecodeHex)
	if err != nil {
		log.Fatalf("Failed to decode bytecode: %v", err)
	}

	parser := irgen.NewParser("evm0")
	if parser == nil {
		log.Fatal("Failed to create parser for evm0")
	}

	err = parser.ParseCodeSection("main", bytecode)
	if err != nil {
		log.Fatalf("Failed to parse code section: %v", err)
	}

	llvmIR := parser.GenerateIR()

	fmt.Println("Generated LLVM IR:")
	fmt.Println(llvmIR)
}
```

### Parsing, Optimizing, and JIT-ing IR

```go
package main

import (
	"encoding/hex"
	"fmt"
	"log"

	"github.com/pk910/go-evmjit/irgen"
	"github.com/pk910/go-evmjit/llvm"
)

func main() {
	// 1. Generate IR (as shown in the previous example)
	bytecodeHex := "604260010100" // PUSH1 42 PUSH1 01 ADD STOP
	bytecode, _ := hex.DecodeString(bytecodeHex)
	parser := irgen.NewParser("evm0")
	if parser == nil {
		log.Fatal("Failed to create parser for evm0")
	}
	err := parser.ParseCodeSection("main", bytecode)
	if err != nil {
		log.Fatalf("Failed to parse code section: %v", err)
	}
	llvmIR := parser.GenerateIR()

	// 2. Load IR code into module
	mod := llvm.NewModule()
	mod.LoadIR(llvmIR)

	// 3. Persist the IR in bytecode format (optional)
	modBytes, err := mod.Marshal()
	if err != nil {
		fmt.Println("Error marshalling module:", err)
	}

	// 4. Load the persisted IR bytecode (optional)
	err = mod.Unmarshal(modBytes)
	if err != nil {
		fmt.Println("Error unmarshalling module:", err)
	}

	// 4. Create call context & execute code
	callctx, err := llvm.NewCallCtx(nil, 10000) // 10000 gas
	if err != nil {
		fmt.Println("Error creating call context:", err)
		return
	}
	defer callctx.Dispose()

	res, err := mod.Call(callctx, "main")
	if err != nil {
		fmt.Println("Error executing contract: ", err)
		return
	}
	fmt.Println("Contract execution result: ", res)
}

```

### Adding Go Opcode Bindings

For certain EVM opcodes (often those interacting with the environment or requiring complex logic), the implementation is delegated to Go functions provided by the library user. You can supply these using the `OpBindings` mechanism:

```go
package main

import (
	"fmt"
	"github.com/pk910/go-evmjit/llvm"
	// ... other necessary imports like irgen, hex, log ...
)

// Example binding function for a hypothetical LOG opcode (0xA5)
func handleLog(c *llvm.CallCtx, inputs []byte, output []byte, gasleft *uint64) error {
	offset := inputs[0:32]
	length := inputs[32:64]

	// In a real scenario, you'd read memory based on offset/length
	// from the CallCtx (c) and interact with the host environment.
	fmt.Printf("LOGGING: offset=%x length=%x\n", offset, length)

	// Consume gas (example)
	const gasCost = 50
	if *gasleft < gasCost {
		return llvm.ErrOutOfGas
	}
	*gasleft -= gasCost

	return nil
}

func main() {
	opBindings := llvm.NewOpBindings()
	defer opBindings.Dispose()

	// Add the binding for opcode 0xA5
	opBindings.AddBinding(0xA5, handleLog)

	// ... 
}

```

## Development Tools (`cmd/evmjit`)

The `evmjit` command-line tool provides utilities helpful during development:

### Building LLVM IR from Bytecode

```bash
# Example: PUSH1 0x42 PUSH1 0x01 ADD STOP -> 604260010100
go run ./cmd/evmjit build -i 604260010100
```

This will output the generated LLVM IR to standard output.

### Optimizing LLVM IR

The tool can also optimize a given LLVM IR string read from standard input.

```bash
# Pipe the output from the build command to the optimize command
go run ./cmd/evmjit build -i 604260010100 | go run ./cmd/evmjit optimize
```

This will output the optimized LLVM IR to standard output.


## EVM0 Opcode Implementation Status

The `irgen` module currently supports parsing the following EVM0 opcodes. "IR Code" means the opcode logic is directly translated into LLVM IR. "Go Binding" means the IR generates a callout to a Go function that must be provided by the user via `OpBindings`.

| Opcode | Name         | Status      |
| :----- | :----------- | :---------- |
| 0x00   | STOP         | IR Code     |
| 0x01   | ADD          | IR Code     |
| 0x02   | MUL          | IR Code     |
| 0x03   | SUB          | IR Code     |
| 0x04   | DIV          | Go Binding  |
| 0x05   | SDIV         | Go Binding  |
| 0x06   | MOD          | Go Binding  |
| 0x07   | SMOD         | Go Binding  |
| 0x08   | ADDMOD       | IR Code     |
| 0x09   | MULMOD       | IR Code     |
| 0x0A   | EXP          | Go Binding  |
| 0x0B   | SIGNEXTEND   | IR Code     |
| 0x10   | LT           | IR Code     |
| 0x11   | GT           | IR Code     |
| 0x12   | SLT          | IR Code     |
| 0x13   | SGT          | IR Code     |
| 0x14   | EQ           | IR Code     |
| 0x15   | ISZERO       | IR Code     |
| 0x16   | AND          | IR Code     |
| 0x17   | OR           | IR Code     |
| 0x18   | XOR          | IR Code     |
| 0x19   | NOT          | IR Code     |
| 0x1A   | BYTE         | IR Code     |
| 0x1B   | SHL          | IR Code     |
| 0x1C   | SHR          | IR Code     |
| 0x1D   | SAR          | IR Code     |
| 0x20   | KECCAK256    | Go Binding  |
| 0x30   | ADDRESS      | Go Binding  |
| 0x31   | BALANCE      | Go Binding  |
| 0x32   | ORIGIN       | Go Binding  |
| 0x33   | CALLER       | Go Binding  |
| 0x34   | CALLVALUE    | Go Binding  |
| 0x35   | CALLDATALOAD | Go Binding  |
| 0x36   | CALLDATASIZE | Go Binding  |
| 0x37   | CALLDATACOPY | Go Binding  |
| 0x38   | CODESIZE     | Go Binding  |
| 0x39   | CODECOPY     | Go Binding  |
| 0x3A   | GASPRICE     | Go Binding  |
| 0x3B   | EXTCODESIZE  | Go Binding  |
| 0x3C   | EXTCODECOPY  | Go Binding  |
| 0x3D   | RETURNDATASIZE| Go Binding |
| 0x3E   | RETURNDATACOPY| Go Binding |
| 0x3F   | EXTCODEHASH  | Go Binding  |
| 0x40   | BLOCKHASH    | Go Binding  |
| 0x41   | COINBASE     | Go Binding  |
| 0x42   | TIMESTAMP    | Go Binding  |
| 0x43   | NUMBER       | Go Binding  |
| 0x44   | PREVRANDAO   | Go Binding  |
| 0x45   | GASLIMIT     | Go Binding  |
| 0x46   | CHAINID      | Go Binding  |
| 0x47   | SELFBALANCE  | Go Binding  |
| 0x48   | BASEFEE      | Go Binding  |
| 0x49   | BLOBHASH     | Go Binding  |
| 0x4A   | BLOBBASEFEE  | Go Binding  |
| 0x50   | POP          | IR Code     |
| 0x51   | MLOAD        | Go Binding  |
| 0x52   | MSTORE       | Go Binding  |
| 0x53   | MSTORE8      | Go Binding  |
| 0x54   | SLOAD        | Go Binding  |
| 0x55   | SSTORE       | Go Binding  |
| 0x56   | JUMP         | IR Code     |
| 0x57   | JUMPI        | IR Code     |
| 0x58   | PC           | IR Code     |
| 0x59   | MSIZE        | Go Binding  |
| 0x5A   | GAS          | IR Code     |
| 0x5B   | JUMPDEST     | IR Code     |
| 0x5C   | TLOAD        | Go Binding  |
| 0x5D   | TSTORE       | Go Binding  |
| 0x5E   | MCOPY        | Go Binding  |
| 0x5F   | PUSH0        | IR Code     |
| 0x60   | PUSH1        | IR Code     |
| 0x61   | PUSH2        | IR Code     |
| ...    | ...          | ...         |
| 0x7F   | PUSH32       | IR Code     |
| 0x80   | DUP1         | IR Code     |
| 0x81   | DUP2         | IR Code     |
| ...    | ...          | ...         |
| 0x8F   | DUP16        | IR Code     |
| 0x90   | SWAP1        | IR Code     |
| 0x91   | SWAP2        | IR Code     |
| ...    | ...          | ...         |
| 0x9F   | SWAP16       | IR Code     |
| 0xA0   | LOG0         | Go Binding  |
| 0xA1   | LOG1         | Go Binding  |
| 0xA2   | LOG2         | Go Binding  |
| 0xA3   | LOG3         | Go Binding  |
| 0xA4   | LOG4         | Go Binding  |
| 0xF0   | CREATE       | Go Binding  |
| 0xF1   | CALL         | Go Binding  |
| 0xF2   | CALLCODE     | Go Binding  |
| 0xF3   | RETURN       | Go Binding  |
| 0xF4   | DELEGATECALL | Go Binding  |
| 0xF5   | CREATE2      | Go Binding  |
| 0xFA   | STATICCALL   | Go Binding  |
| 0xFD   | REVERT       | IR Code     |
| 0xFE   | INVALID      | IR Code     |
| 0xFF   | SELFDESTRUCT | Go Binding  |

