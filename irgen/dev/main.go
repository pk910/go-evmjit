package main

import (
	"fmt"
	"os"

	"github.com/pk910/go-evmjit/irgen/builder"
	"github.com/pk910/go-evmjit/llvm"
)

func main() {
	irf := builder.NewIRFunction("test", 1023, true)

	irf.AppendPushN(32, []uint8{0x21, 0x14, 0x16, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x04, 0x05, 0x02, 0x01})
	irf.AppendPushN(1, []uint8{2})
	irf.AppendPushN(8, []uint8{0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11})
	irf.AppendSwapN(2)
	irf.AppendSwapN(1)
	irf.AppendPushN(1, []uint8{50})
	irf.AppendJump()
	//irf.AppendAdd()
	//irf.AppendMul()
	irf.AppendShl()
	irf.AppendJumpDest()
	//irf.AppendDiv()
	//irf.AppendDupN(2)
	//irf.AppendPop()

	irf.AppendGas()
	irf.AppendPushN(2, []uint8{2, 0x00})
	irf.AppendGas()
	irf.AppendGt()
	irf.AppendPushN(1, []uint8{50})
	irf.AppendJumpI()

	irf.AppendPushN(1, []uint8{0x02})
	irf.AppendSwapN(1)
	irf.AppendHighOpcode(0x0A, 2, 1, 0)
	//irf.AppendHighOpcode(0x48, 0, 1, 0)
	//irf.AppendDiv()

	irf.AppendStop()
	irf.SetStackInputOutputs(0, 2, 256)

	irb := builder.NewIRBuilder()
	irb.AddFunction(irf)
	llvmIR := irb.String()

	os.WriteFile("./contract1-test.ll", []byte(llvmIR), 0644)
	//fmt.Println(llvmIR)

	callctx, err := llvm.NewCallCtx(nil, 10000)
	if err != nil {
		fmt.Println("Error creating call context:", err)
		return
	}

	defer callctx.Dispose()

	mod := llvm.NewModule()
	mod.LoadIR(llvmIR)
	mod.Call(callctx, "test")

	fmt.Printf("Stack size: %d\n", callctx.GetStackSize())
	for i := 1; i <= callctx.GetStackSize(); i++ {
		callctx.PrintStack(i)
	}

	modBytes, err := mod.Marshal()
	if err != nil {
		fmt.Println("Error marshalling module:", err)
	}

	fmt.Printf("Module IR bytecode: %d bytes\n", len(modBytes))
}
