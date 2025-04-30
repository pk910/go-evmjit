package irgen

import (
	"bytes"
	"fmt"

	"github.com/pk910/go-eofjit/irgen/irtpl"
)

// IRFunction represents a function in the LLVM IR code which contains a EOF code section.
type IRFunction struct {
	name       string
	defcode    bytes.Buffer
	fncode     bytes.Buffer
	opcount    uint32
	maxstack   uint16
	heapstack  uint16
	inputs     uint8
	outputs    uint8
	verbose    bool
	stackcheck bool
}

// NewIRFunction creates a new IRFunction.
func NewIRFunction(name string, verbose bool) *IRFunction {
	return &IRFunction{
		name:       name,
		defcode:    bytes.Buffer{},
		fncode:     bytes.Buffer{},
		opcount:    0,
		maxstack:   256,
		heapstack:  256,
		inputs:     0,
		outputs:    0,
		verbose:    verbose,
		stackcheck: true,
	}
}

func (irf *IRFunction) SetInputOutputs(inputs, outputs uint8) {
	irf.inputs = inputs
	irf.outputs = outputs
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
	fncode := bytes.Buffer{}
	fncode.WriteString(irf.defcode.String())
	fncode.WriteString(fmt.Sprintf(`

define i32 @%s(%%struct.evm_stack* noundef %%stack) {
entry:
%%zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
%%stack_alloc = alloca [%d x i8], align 32
%%stack_addr = getelementptr inbounds [%d x i8], [%d x i8]* %%stack_alloc, i64 0, i64 0
%%stack_position_ptr = alloca i64, align 4
store i64 0, i64* %%stack_position_ptr

%%heap_stack_ptr = getelementptr %%struct.evm_stack, %%struct.evm_stack* %%stack, i32 0, i32 0
%%heap_stack_addr = load i8*, i8** %%heap_stack_ptr, align 8
%%heap_stack_position_ptr = getelementptr %%struct.evm_stack, %%struct.evm_stack* %%stack, i32 0, i32 1
`, irf.name, irf.maxstack*32, irf.maxstack*32, irf.maxstack*32))

	if irf.inputs > 0 {
		// load inputs from heap stack to local stack
		tpl := irtpl.GetTemplate("stack-input.ll")
		tpl.ExecuteTemplate(&fncode, "ircode", map[string]interface{}{
			"Inputs":     uint64(irf.inputs),
			"StackCheck": irf.stackcheck,
			"MaxStack":   uint64(irf.maxstack),
		})
	}

	fncode.WriteString(irf.fncode.String())

	if irf.outputs > 0 {
		// load outputs from local stack to heap stack
		tpl := irtpl.GetTemplate("stack-output.ll")
		tpl.ExecuteTemplate(&fncode, "ircode", map[string]interface{}{
			"Outputs":    uint64(irf.outputs),
			"StackCheck": irf.stackcheck,
			"MaxStack":   uint64(irf.heapstack),
		})
	}

	fncode.WriteString(`
ret i32 0
}
`)

	return fncode.String()
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
		"Id":         irf.opcount,
		"DataLen":    uint64(n),
		"Data":       data,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
		"MaxStack":   uint64(irf.maxstack),
	})
}

func (irf *IRFunction) AppendDupN(n uint8) error {
	irf.opcount++
	return irf.appendTemplate("stack-dupn.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Position":   uint64(n),
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
		"MaxStack":   uint64(irf.maxstack),
	})
}

func (irf *IRFunction) AppendSwapN(n uint8) error {
	irf.opcount++
	return irf.appendTemplate("stack-swapn.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Position":   uint64(n),
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendPop() error {
	irf.opcount++
	return irf.appendTemplate("stack-pop.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendAdd() error {
	irf.opcount++
	return irf.appendTemplate("math-add.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendSub() error {
	irf.opcount++
	return irf.appendTemplate("math-sub.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendMul() error {
	irf.opcount++
	return irf.appendTemplate("math-mul.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendDiv() error {
	irf.opcount++
	return irf.appendTemplate("math-div.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendLt() error {
	irf.opcount++
	return irf.appendTemplate("logic-lt.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendGt() error {
	irf.opcount++
	return irf.appendTemplate("logic-gt.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendSlt() error {
	irf.opcount++
	return irf.appendTemplate("logic-slt.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendSgt() error {
	irf.opcount++
	return irf.appendTemplate("logic-sgt.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendEq() error {
	irf.opcount++
	return irf.appendTemplate("logic-eq.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendIsZero() error {
	irf.opcount++
	return irf.appendTemplate("logic-iszero.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendAnd() error {
	irf.opcount++
	return irf.appendTemplate("logic-and.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendOr() error {
	irf.opcount++
	return irf.appendTemplate("logic-or.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendXor() error {
	irf.opcount++
	return irf.appendTemplate("logic-xor.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendNot() error {
	irf.opcount++
	return irf.appendTemplate("logic-not.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendByte() error {
	irf.opcount++
	return irf.appendTemplate("logic-byte.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendShl() error {
	irf.opcount++
	return irf.appendTemplate("logic-shl.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendShr() error {
	irf.opcount++
	return irf.appendTemplate("logic-shr.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}

func (irf *IRFunction) AppendSar() error {
	irf.opcount++
	return irf.appendTemplate("logic-sar.ll", map[string]interface{}{
		"Id":         irf.opcount,
		"Verbose":    irf.verbose,
		"StackCheck": irf.stackcheck,
	})
}
