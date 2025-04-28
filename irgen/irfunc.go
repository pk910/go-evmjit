package irgen

import (
	"bytes"
	"fmt"

	"github.com/pk910/go-eofjit/irgen/irtpl"
)

// IRFunction represents a function in the LLVM IR code which contains a EOF code section.
type IRFunction struct {
	name    string
	opcount uint32
	defcode bytes.Buffer
	fncode  bytes.Buffer
	verbose bool
}

// NewIRFunction creates a new IRFunction.
func NewIRFunction(name string, verbose bool) *IRFunction {
	return &IRFunction{
		name:    name,
		opcount: 0,
		defcode: bytes.Buffer{},
		fncode:  bytes.Buffer{},
		verbose: verbose,
	}
}

func (irf *IRFunction) AppendOpcode(opcode uint8, data []uint8) (uint8, error) {
	switch opcode {
	case 0x00:
		return 0, nil
	case 0x01:
		return 0, nil
	default:
		return 0, fmt.Errorf("unknown opcode: %d", opcode)
	}
}

func (irf *IRFunction) String() string {
	return fmt.Sprintf(`%s

define i32 @%s(%%struct.evm_stack* noundef %%stack) {
entry:
  %%zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
  %%stack_ptr = getelementptr %%struct.evm_stack, %%struct.evm_stack* %%stack, i32 0, i32 0
  %%stack_addr = load i8*, i8** %%stack_ptr, align 8
  %%stack_position_ptr = getelementptr %%struct.evm_stack, %%struct.evm_stack* %%stack, i32 0, i32 1
%s
  ret i32 0
}
`, irf.defcode.String(), irf.name, irf.fncode.String())
}

func (irf *IRFunction) appendTemplate(name string, model map[string]interface{}) error {
	tpl := irtpl.GetTemplate(name)
	tpl.ExecuteTemplate(&irf.defcode, "defcode", model)
	tpl.ExecuteTemplate(&irf.fncode, "ircode", model)
	return nil
}

func (irf *IRFunction) AppendPushN(n uint8, data []uint8) error {
	irf.opcount++
	return irf.appendTemplate("stack-pushn.ll", map[string]interface{}{
		"Id":      irf.opcount,
		"DataLen": uint64(n),
		"Data":    data,
		"Verbose": irf.verbose,
	})
}

func (irf *IRFunction) AppendDupN(n uint8) error {
	irf.opcount++
	return irf.appendTemplate("stack-dupn.ll", map[string]interface{}{
		"Id":       irf.opcount,
		"Position": uint64(n),
		"Verbose":  irf.verbose,
	})
}

func (irf *IRFunction) AppendSwapN(n uint8) error {
	irf.opcount++
	return irf.appendTemplate("stack-swapn.ll", map[string]interface{}{
		"Id":       irf.opcount,
		"Position": uint64(n),
		"Verbose":  irf.verbose,
	})
}

func (irf *IRFunction) AppendPop() error {
	irf.opcount++
	return irf.appendTemplate("stack-pop.ll", map[string]interface{}{
		"Id":      irf.opcount,
		"Verbose": irf.verbose,
	})
}

func (irf *IRFunction) AppendAdd() error {
	irf.opcount++
	return irf.appendTemplate("math-add.ll", map[string]interface{}{
		"Id":      irf.opcount,
		"Verbose": irf.verbose,
	})
}

func (irf *IRFunction) AppendSub() error {
	irf.opcount++
	return irf.appendTemplate("math-sub.ll", map[string]interface{}{
		"Id":      irf.opcount,
		"Verbose": irf.verbose,
	})
}

func (irf *IRFunction) AppendMul() error {
	irf.opcount++
	return irf.appendTemplate("math-mul.ll", map[string]interface{}{
		"Id":      irf.opcount,
		"Verbose": irf.verbose,
	})
}

func (irf *IRFunction) AppendDiv() error {
	irf.opcount++
	return irf.appendTemplate("math-div.ll", map[string]interface{}{
		"Id":      irf.opcount,
		"Verbose": irf.verbose,
	})
}
