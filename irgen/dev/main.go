package main

import (
	"fmt"

	"github.com/pk910/go-eofjit/irgen"
	"github.com/pk910/go-eofjit/llvm"
)

func main() {
	irf := irgen.NewIRFunction("test", true)

	/*
		irf.AppendPushN(32, []uint8{0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01})
		irf.AppendPushN(6, []uint8{0x22, 0x22, 0x22, 0x22, 0x22, 0x22})
		irf.AppendPushN(8, []uint8{0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11})
		//irf.AppendSwapN(2)
		irf.AppendAdd()
		irf.AppendDupN(2)
		irf.AppendMul()
		irf.AppendSwapN(1)
	*/
	irf.AppendPushN(1, []uint8{50})
	irf.AppendPushN(1, []uint8{200})
	irf.AppendDiv()

	irb := irgen.NewIRBuilder()
	irb.AddFunction(irf)
	llvmIR := irb.String()
	fmt.Println(llvmIR)

	mod := llvm.NewModule()
	mod.LoadIR(llvmIR)
	mod.Call("test")
	mod.PrintStack(1)
	mod.PrintStack(2)
	mod.PrintStack(3)
	mod.PrintStack(4)

	modBytes, err := mod.Marshal()
	if err != nil {
		fmt.Println("Error marshalling module:", err)
	}

	fmt.Printf("Module IR bytecode: %d bytes\n", len(modBytes))
	fmt.Println(string(llvmIR))

	mod.Dispose()

	mod = llvm.NewModule()
	mod.Unmarshal(modBytes)
	mod.Call("test")
	mod.PrintStack(1)
	mod.PrintStack(2)
	mod.PrintStack(3)
	mod.PrintStack(4)
}
