package main

import (
	"fmt"

	"github.com/pk910/go-eofjit/irgen"
	"github.com/pk910/go-eofjit/llvm"
)

func main() {
	irf := irgen.NewIRFunction("test", true)

	irf.AppendPushN(32, []uint8{0x01, 0x14, 0x16, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x04, 0x05, 0x02, 0x01})
	irf.AppendPushN(1, []uint8{2})
	irf.AppendPushN(8, []uint8{0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11})
	irf.AppendSwapN(2)
	irf.AppendSwapN(1)
	//irf.AppendAdd()
	//irf.AppendMul()
	irf.AppendShl()
	//irf.AppendDupN(2)
	//irf.AppendDupN(1)
	//irf.AppendPushN(1, []uint8{0x02})
	//irf.AppendMul()
	//irf.AppendSwapN(1)

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
