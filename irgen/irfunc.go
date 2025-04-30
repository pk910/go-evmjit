package irgen

import (
	"bytes"
	"fmt"
	"html/template"

	"github.com/pk910/go-eofjit/irgen/irtpl"
)

// IRFunction represents a function in the LLVM IR code which contains a EOF code section.
type IRFunction struct {
	name        string
	branches    []*IRBranch
	branchCount uint32
	opcount     uint32
	pccount     uint32
	maxstack    uint16
	heapstack   uint16
	inputs      uint8
	outputs     uint8
	verbose     bool
	stackcheck  bool
	noinitjump  bool
}

type IRBranch struct {
	pc      uint32
	opcodes []*IROpcode
}

type IROpcode struct {
	name  string
	id    uint32
	pc    uint32
	tpl   *template.Template
	model map[string]interface{}
}

// NewIRFunction creates a new IRFunction.
func NewIRFunction(name string, verbose bool) *IRFunction {
	return &IRFunction{
		name:        name,
		branches:    []*IRBranch{},
		branchCount: 0,
		pccount:     0,
		maxstack:    256,
		heapstack:   256,
		inputs:      0,
		outputs:     0,
		verbose:     verbose,
		stackcheck:  true,
	}
}

func (irf *IRFunction) SetInputOutputs(inputs, outputs uint8) {
	irf.inputs = inputs
	irf.outputs = outputs
}

func (irf *IRFunction) String() string {
	fncode := bytes.Buffer{}
	defcode := bytes.Buffer{}
	opscode := bytes.Buffer{}
	for _, branch := range irf.branches {
		if branch.pc > 0 || !irf.noinitjump {
			opscode.WriteString(fmt.Sprintf(`
br label %%br_%d
br_%d:
`, branch.pc, branch.pc))
		}

		for _, opcode := range branch.opcodes {
			model := map[string]interface{}{
				"Id":         opcode.id,
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
	}

	fncode.WriteString(defcode.String())
	fncode.WriteString(fmt.Sprintf(`

define i32 @%s(%%struct.evm_callctx* noundef %%callctx) {
entry:
%%zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
%%stack_alloc = alloca [%d x i8], align 32
%%stack_addr = getelementptr inbounds [%d x i8], [%d x i8]* %%stack_alloc, i64 0, i64 0
%%stack_position_ptr = alloca i64, align 4
store i64 0, i64* %%stack_position_ptr

%%callctx_ptr = getelementptr inbounds %%struct.evm_callctx, %%struct.evm_callctx* %%callctx, i64 0, i32 0
%%heap_stack = load %%struct.evm_stack*, %%struct.evm_stack** %%callctx_ptr, align 8

%%heap_stack_ptr = getelementptr %%struct.evm_stack, %%struct.evm_stack* %%heap_stack, i32 0, i32 0
%%heap_stack_addr = load i8*, i8** %%heap_stack_ptr, align 8
%%heap_stack_position_ptr = getelementptr %%struct.evm_stack, %%struct.evm_stack* %%heap_stack, i32 0, i32 1
`, irf.name, irf.maxstack*32, irf.maxstack*32, irf.maxstack*32))

	// load inputs from heap stack to local stack
	if irf.inputs > 0 {
		tpl := irtpl.GetTemplate("stack-input.ll")
		tpl.ExecuteTemplate(&fncode, "ircode", map[string]interface{}{
			"Inputs":     uint64(irf.inputs),
			"StackCheck": irf.stackcheck,
			"MaxStack":   uint64(irf.maxstack),
		})
	}

	// generate jumptable
	tpl := irtpl.GetTemplate("flow-jumptable.ll")
	branchPcs := []uint64{}
	hasBranches := false
	for _, branch := range irf.branches {
		if branch.pc == 0 && irf.noinitjump {
			continue
		}
		branchPcs = append(branchPcs, uint64(branch.pc))
		hasBranches = true
	}
	tpl.ExecuteTemplate(&fncode, "ircode", map[string]interface{}{
		"Branches":    branchPcs,
		"HasBranches": hasBranches,
	})

	// add opcodes
	fncode.WriteString(opscode.String())

	// load outputs from local stack to heap stack
	if irf.outputs > 0 {
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
	if irf.branchCount == 0 {
		irf.branches = append(irf.branches, &IRBranch{
			pc:      0,
			opcodes: []*IROpcode{},
		})
		irf.branchCount++
		irf.noinitjump = true
	}

	branch := irf.branches[irf.branchCount-1]
	tpl := irtpl.GetTemplate(name)
	opcode := &IROpcode{
		id:    irf.opcount,
		pc:    irf.pccount,
		name:  name,
		tpl:   tpl,
		model: model,
	}
	branch.opcodes = append(branch.opcodes, opcode)
	irf.pccount += uint32(pccount)
	irf.opcount++
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

func (irf *IRFunction) AppendHighOpcode(opcode, inputs, outputs uint8) error {
	return irf.appendOpcode("evmc-call.ll", 1, map[string]interface{}{
		"Name":    fmt.Sprintf("c%d", opcode),
		"Opcode":  uint64(opcode),
		"Inputs":  uint64(inputs),
		"Outputs": uint64(outputs),
	})
}

func (irf *IRFunction) AppendJumpDest() error {
	irf.branches = append(irf.branches, &IRBranch{
		pc:      irf.pccount,
		opcodes: []*IROpcode{},
	})
	irf.branchCount++
	return irf.appendOpcode("flow-jumpdest.ll", 1, nil)
}

func (irf *IRFunction) AppendJump() error {
	return irf.appendOpcode("flow-jump.ll", 1, nil)
}

func (irf *IRFunction) AppendJumpI() error {
	return irf.appendOpcode("flow-jumpi.ll", 1, nil)
}

func (irf *IRFunction) AppendStop() error {
	return irf.appendOpcode("flow-stop.ll", 1, nil)
}

func (irf *IRFunction) AppendPc() error {
	return irf.appendOpcode("flow-pc.ll", 1, nil)
}
