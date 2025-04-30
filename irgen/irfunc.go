package irgen

import (
	"bytes"
	"fmt"
	"html/template"

	"github.com/pk910/go-eofjit/irgen/irtpl"
)

// IRFunction represents a function in the LLVM IR code which contains a EOF code section.
type IRFunction struct {
	name       string
	opcodes    []IROpcode
	pccount    uint32
	maxstack   uint16
	heapstack  uint16
	inputs     uint8
	outputs    uint8
	verbose    bool
	stackcheck bool
}

type IROpcode struct {
	name  string
	pc    uint32
	tpl   *template.Template
	model map[string]interface{}
}

// NewIRFunction creates a new IRFunction.
func NewIRFunction(name string, verbose bool) *IRFunction {
	return &IRFunction{
		name:       name,
		opcodes:    []IROpcode{},
		pccount:    0,
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
	defcode := bytes.Buffer{}
	opscode := bytes.Buffer{}
	for index, opcode := range irf.opcodes {
		model := map[string]interface{}{
			"Id":         index,
			"Pc":         opcode.pc,
			"Verbose":    irf.verbose,
			"StackCheck": irf.stackcheck,
			"MaxStack":   uint64(irf.maxstack),
		}
		if opcode.model != nil {
			for k, v := range opcode.model {
				model[k] = v
			}
		}
		opcode.tpl.ExecuteTemplate(&defcode, "defcode", model)
		opcode.tpl.ExecuteTemplate(&opscode, "ircode", model)
	}

	fncode.WriteString(defcode.String())
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

	fncode.WriteString(opscode.String())

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

func (irf *IRFunction) appendOpcode(name string, pccount uint8, model map[string]interface{}) error {
	tpl := irtpl.GetTemplate(name)
	opcode := IROpcode{
		pc:    irf.pccount,
		name:  name,
		tpl:   tpl,
		model: model,
	}
	irf.opcodes = append(irf.opcodes, opcode)
	irf.pccount += uint32(pccount)
	return nil
}

func (irf *IRFunction) AppendPushN(n uint8, data []uint8) error {
	return irf.appendOpcode("stack-pushn.ll", 1+n, map[string]interface{}{
		"DataLen": uint64(n),
		"Data":    data,
	})
}

func (irf *IRFunction) AppendDupN(n uint8) error {
	return irf.appendOpcode("stack-dupn.ll", 1, map[string]interface{}{
		"Position": uint64(n),
	})
}

func (irf *IRFunction) AppendSwapN(n uint8) error {
	return irf.appendOpcode("stack-swapn.ll", 1, map[string]interface{}{
		"Position": uint64(n),
	})
}

func (irf *IRFunction) AppendPop() error {
	return irf.appendOpcode("stack-pop.ll", 1, nil)
}

func (irf *IRFunction) AppendAdd() error {
	return irf.appendOpcode("math-add.ll", 1, nil)
}

func (irf *IRFunction) AppendSub() error {
	return irf.appendOpcode("math-sub.ll", 1, nil)
}

func (irf *IRFunction) AppendMul() error {
	return irf.appendOpcode("math-mul.ll", 1, nil)
}

func (irf *IRFunction) AppendDiv() error {
	return irf.appendOpcode("math-div.ll", 1, nil)
}

func (irf *IRFunction) AppendLt() error {
	return irf.appendOpcode("logic-lt.ll", 1, nil)
}

func (irf *IRFunction) AppendGt() error {
	return irf.appendOpcode("logic-gt.ll", 1, nil)
}

func (irf *IRFunction) AppendSlt() error {
	return irf.appendOpcode("logic-slt.ll", 1, nil)
}

func (irf *IRFunction) AppendSgt() error {
	return irf.appendOpcode("logic-sgt.ll", 1, nil)
}

func (irf *IRFunction) AppendEq() error {
	return irf.appendOpcode("logic-eq.ll", 1, nil)
}

func (irf *IRFunction) AppendIsZero() error {
	return irf.appendOpcode("logic-iszero.ll", 1, nil)
}

func (irf *IRFunction) AppendAnd() error {
	return irf.appendOpcode("logic-and.ll", 1, nil)
}

func (irf *IRFunction) AppendOr() error {
	return irf.appendOpcode("logic-or.ll", 1, nil)
}

func (irf *IRFunction) AppendXor() error {
	return irf.appendOpcode("logic-xor.ll", 1, nil)
}

func (irf *IRFunction) AppendNot() error {
	return irf.appendOpcode("logic-not.ll", 1, nil)
}

func (irf *IRFunction) AppendByte() error {
	return irf.appendOpcode("logic-byte.ll", 1, nil)
}

func (irf *IRFunction) AppendShl() error {
	return irf.appendOpcode("logic-shl.ll", 1, nil)
}

func (irf *IRFunction) AppendShr() error {
	return irf.appendOpcode("logic-shr.ll", 1, nil)
}

func (irf *IRFunction) AppendSar() error {
	return irf.appendOpcode("logic-sar.ll", 1, nil)
}
