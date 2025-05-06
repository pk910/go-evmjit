package main

import (
	"encoding/hex"
	"fmt"
	"os"

	"github.com/holiman/uint256"
	"github.com/pk910/go-evmjit/irgen/builder"
	"github.com/pk910/go-evmjit/llvm"
	"github.com/pk910/go-evmjit/llvm/bindings"
	"github.com/pk910/go-evmjit/llvm/types"
)

func main() {
	irf := builder.NewIRFunction("test", 1023, true)

	hexdec := func(str string) []byte {
		out, _ := hex.DecodeString(str)
		return out
	}

	irf.AppendPushN(1, []uint8{2})
	irf.AppendPushN(1, []uint8{4})
	irf.AppendJumpDest()
	irf.AppendPushN(32, hexdec("a9059cbb00000000000000000000000051a271009841ef452116efbbbef122d0"))
	irf.AppendPushN(1, []uint8{6})
	irf.AppendPushN(1, []uint8{0xff})
	irf.AppendSwapN(1)
	/*
		irf.AppendAnd()
		irf.AppendSwapN(3)
		irf.AppendShr()
		irf.AppendDupN(2)
	*/

	/*
		irf.AppendPushN(2, []uint8{0xee, 0xaa})
		irf.AppendPushN(1, []uint8{2})
		irf.AppendJumpDest()
		irf.AppendDupN(1)
		irf.AppendPop()
		irf.AppendPushN(1, []uint8{1})
		irf.AppendAdd()
		irf.AppendPushN(1, []uint8{50})
		irf.AppendDupN(2)
		irf.AppendLt()
		irf.AppendPushN(1, []uint8{5})
		irf.AppendJumpI()

		//irf.AppendPushN(1, []uint8{2})

		irf.AppendJumpDest()                       // [y, x]
		irf.AppendPushN(1, []uint8{0x40})          // [y, x, 0x40]
		irf.AppendHighOpcode(0x48, 1, 1, 0, false) // [y, x, 0x48]
		irf.AppendSwapN(1)                         // [y, 0x48, x]
		irf.AppendIsZero()                         // [y, 0x48, x!=0]
		irf.AppendIsZero()                         // [y, 0x48, x==0]
		irf.AppendDupN(2)                          // [y, 0x48, x==0, 0x48]
		irf.AppendHighOpcode(0x48, 2, 0, 0, false) // [y, 0x48]
		irf.AppendPushN(1, []uint8{0x20})          // [y, 0x48, 0x20]
		irf.AppendAdd()                            // [y, 0x68]
		irf.AppendPushN(1, []uint8{0x40})          // [y, 0x68, 0x40]
		irf.AppendHighOpcode(0x48, 1, 1, 0, false) // [y, 0x48]
		irf.AppendDupN(1)                          // [y, 0x48, 0x48]
		irf.AppendSwapN(2)                         // [0x48, 0x48, y]
		//irf.AppendStop()
	*/

	/*
		irf.AppendPushN(2, []uint8{0xee, 0xaa})
		irf.AppendPushN(1, []uint8{3})
		irf.AppendPushN(1, []uint8{2})
		irf.AppendPushN(1, []uint8{1})

		irf.AppendJumpDest() // [n3, n2, n1]
		irf.AppendSwapN(2)   // [n1, n2, n3]
		irf.AppendAdd()      // [n1, n2+n3]
		irf.AppendDupN(1)    // [n1, n2+n3, n2+n3]
		irf.AppendSwapN(3)
	*/

	/*
		irf.AppendPushN(2, []uint8{0xee, 0xaa})
		irf.AppendPushN(1, []uint8{4})
		irf.AppendPushN(1, []uint8{3})
		irf.AppendPushN(1, []uint8{2})
		irf.AppendPushN(1, []uint8{1})

		irf.AppendJumpDest()              // [n2, n1]
		irf.AppendPushN(0, []uint8{})     // [n2, n1, 0]
		irf.AppendDupN(3)                 // [n2, n1, 0, n2]
		irf.AppendGt()                    // [n2, n1, n2>0]
		irf.AppendIsZero()                // [n2, n1, n2>0==0]
		irf.AppendPushN(1, []uint8{0x68}) // [n2, n1, n2>0==0, 0x68]
		irf.AppendJumpI()                 // [n2, n1]
		irf.AppendDupN(2)                 // [n2, n1, n2]
		irf.AppendAdd()                   // [n2, n1+n2]
		irf.AppendSwapN(1)                // [n1+n2, n2]
		irf.AppendDupN(4)                 // [n1+n2, n2, n3]
		irf.AppendMul()                   // [n1+n2, n2*n3]
		irf.AppendDupN(5)                 // [n1+n2, n2, n3, n5]
		irf.AppendDupN(4)                 // [n1+n2, n2, n3, n5, n1+n2]
		irf.AppendMul()                   // [n1+n2, n2, n3, n5*(n1+n2)]
		irf.AppendSwapN(1)                // [n1+n2, n2, n5*(n1+n2), n3]
	*/

	/*
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
		//irf.AppendHighOpcode(0x48, 2, 2, 0)
		//irf.AppendDiv()
	*/

	//irf.AppendStop()
	//irf.SetStackInputOutputs(0, 4, 256)

	irb := builder.NewIRBuilder()
	irb.AddFunction(irf)
	llvmIR := irb.String()

	os.WriteFile("./contract1-test.ll", []byte(llvmIR), 0644)
	//fmt.Println(llvmIR)

	callctx, err := llvm.NewCallCtx(nil, 0, 10000, nil)
	if err != nil {
		fmt.Println("Error creating call context:", err)
		return
	}

	defer callctx.Dispose()

	opbindings := bindings.NewOpBindings()
	opbindings.AddBinding(0x04, bindings.MathDiv)
	opbindings.AddBinding(0x05, bindings.MathMod)
	opbindings.AddBinding(0x06, bindings.MathSDiv)
	opbindings.AddBinding(0x07, bindings.MathSMod)
	opbindings.AddBinding(0x0A, bindings.MathExp)
	opbindings.AddBinding(0x48, func(c types.CallCtx, op uint8, inputs []uint256.Int, output []uint256.Int, gasleft *uint64) int32 {
		fmt.Println("debug", inputs)
		return 0
	})
	callctx.SetOpBindings(opbindings)

	mod := llvm.NewModule()
	mod.LoadIR(llvmIR)
	result, err := mod.Call(callctx, "test")
	if err != nil {
		fmt.Println("Error calling function:", err)
		return
	}

	fmt.Printf("Result: %v\n", result)

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
