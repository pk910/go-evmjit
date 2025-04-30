package main

import (
	"fmt"
	"os"

	"github.com/pk910/go-eofjit/irgen"
	"github.com/pk910/go-eofjit/llvm"
)

func main() {
	irf := irgen.NewIRFunction("test", true)

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
	//irf.AppendHighOpcode(0x05, 2, 1)
	//irf.AppendDiv()
	//irf.AppendDupN(2)
	//irf.AppendPop()

	irf.AppendGas()
	irf.AppendPushN(1, []uint8{50})
	irf.AppendGas()
	irf.AppendGt()
	irf.AppendPushN(1, []uint8{50})
	irf.AppendJumpI()

	irf.AppendPushN(1, []uint8{0x02})
	//irf.AppendMul()
	//irf.AppendSwapN(1)
	irf.AppendStop()
	irf.SetInputOutputs(0, 4)

	irb := irgen.NewIRBuilder()
	irb.AddFunction(irf)
	llvmIR := irb.String()

	os.WriteFile("./contract1-test.ll", []byte(llvmIR), 0644)
	//fmt.Println(llvmIR)

	mod := llvm.NewModule()
	mod.LoadIR(llvmIR)
	mod.Call("test", 1000)

	fmt.Printf("Stack size: %d\n", mod.GetStackSize())
	for i := 1; i <= mod.GetStackSize(); i++ {
		mod.PrintStack(i)
	}

	modBytes, err := mod.Marshal()
	if err != nil {
		fmt.Println("Error marshalling module:", err)
	}

	fmt.Printf("Module IR bytecode: %d bytes\n", len(modBytes))
}
