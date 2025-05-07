package builder

import (
	"bytes"
	"fmt"
	"html/template"

	"github.com/holiman/uint256"
	"github.com/pk910/go-evmjit/irgen/irtpl"
)

// IRFunction represents a function in the LLVM IR code which contains a EOF code section.
type IRFunction struct {
	name        string
	branches    []*IRBranch
	branchCount uint32
	opcount     uint32
	pccount     uint32
	maxstack    uint16
	inputs      uint8
	outputs     uint8
	verbose     bool
	stackcheck  bool
	noinitjump  bool
}

type IRBranch struct {
	pc        uint32
	opcodes   []*IROpcode
	stackPos  int
	heapPos   int
	stackMax  int
	stackMin  int
	stackRefs map[int]*IRStackRef
}

type IRStackRef struct {
	opcode *IROpcode
	refVar string
}

type IROpcodeCheck struct {
	Id       uint32
	Pc       uint64
	MinStack uint64
	MaxStack uint64
	MinGas   uint64
}

type IROpcode struct {
	name          string
	id            uint32
	pc            uint32
	gas           int32
	tpl           *template.Template
	model         map[string]interface{}
	stackLoad     []string
	stackAddLoad  int
	stackStore    map[string]interface{}
	skipGasCheck  bool
	breakGasGroup bool
	stackCheck    int
}

// NewIRFunction creates a new IRFunction.
func NewIRFunction(name string, stacksize uint16, verbose bool) *IRFunction {
	return &IRFunction{
		name:        name,
		branches:    []*IRBranch{},
		branchCount: 0,
		pccount:     0,
		maxstack:    stacksize,
		inputs:      0,
		outputs:     0,
		verbose:     verbose,
		stackcheck:  true,
	}
}

func (irf *IRFunction) SetStackInputOutputs(inputs, outputs uint8, stacksize uint16) {
	irf.inputs = inputs
	irf.outputs = outputs
	irf.maxstack = stacksize
}

func (irf *IRFunction) generateOpIRCode() (string, string) {
	defcode := bytes.Buffer{}
	opscode := bytes.Buffer{}

	ophelper := irtpl.GetTemplate("op-helper.ll")

	for _, branch := range irf.branches {
		if branch.pc > 0 || !irf.noinitjump {
			opscode.WriteString(fmt.Sprintf(`
br label %%br_%d
br_%d:
`, branch.pc, branch.pc))
		}

		for idx, opcode := range branch.opcodes {
			model := map[string]interface{}{
				"Id":         opcode.id,
				"Pc":         opcode.pc,
				"Verbose":    irf.verbose,
				"StackCheck": irf.stackcheck,
				"MaxStack":   uint64(irf.maxstack),
				"StackStore": "",
			}
			if opcode.model != nil {
				for k, v := range opcode.model {
					model[k] = v
				}
			}

			opcode.tpl.ExecuteTemplate(&defcode, "defcode", model)
			opcode.tpl.ExecuteTemplate(&opscode, "irhead", model)

			opChecks := []*IROpcodeCheck{}
			getOpCheck := func(pc uint32) *IROpcodeCheck {
				for _, check := range opChecks {
					if check.Pc == uint64(pc) {
						return check
					}
				}

				check := &IROpcodeCheck{
					Id:       pc,
					Pc:       uint64(pc),
					MinStack: 0,
					MaxStack: 0,
					MinGas:   0,
				}
				opChecks = append(opChecks, check)
				return check
			}

			// batch opcode checks
			if !opcode.skipGasCheck {
				//fmt.Println("collect checks for opcode", opcode.name, "pc", opcode.pc, "gas", opcode.gas, "stackCheck", opcode.stackCheck)
				// collect all followup static gas checks
				totalGas := int32(opcode.gas)
				checkedStackIn := int32(0)
				totalStackIn := int32(len(opcode.stackLoad))
				totalStackOut := int32(opcode.stackCheck)

				opCheck := getOpCheck(opcode.pc)
				opCheck.MinGas = uint64(totalGas)
				opCheck.MaxStack = uint64(totalStackOut)

				checkStackIn := totalStackIn
				if opcode.stackAddLoad > 0 {
					checkStackIn = totalStackIn + int32(opcode.stackAddLoad)
				}
				if checkStackIn > checkedStackIn {
					opCheck.MinStack = uint64(checkStackIn)
					checkedStackIn = checkStackIn
				}

				if !opcode.breakGasGroup && opcode.gas > 0 {
					for _, followup := range branch.opcodes[idx+1:] {
						if followup.gas > 0 && !followup.skipGasCheck {
							totalGas += followup.gas
							totalStackIn += int32(len(followup.stackLoad))
							if followup.stackCheck > 0 {
								totalStackOut = int32(followup.stackCheck)
							}
							opCheck := getOpCheck(followup.pc)
							opCheck.MinGas = uint64(totalGas)
							opCheck.MaxStack = uint64(followup.stackCheck)

							checkStackIn := totalStackIn
							if followup.stackAddLoad > 0 {
								checkStackIn = totalStackIn + int32(followup.stackAddLoad)
							}
							if checkStackIn > checkedStackIn {
								opCheck.MinStack = uint64(checkStackIn)
								checkedStackIn = checkStackIn
							}

							followup.skipGasCheck = true

							if followup.breakGasGroup {
								break
							}
						} else {
							break
						}
					}
				}

				filteredChecks := []*IROpcodeCheck{}
				for _, check := range opChecks {
					if check.MinStack > 0 || check.MaxStack > 0 || check.MinGas > 0 {
						filteredChecks = append(filteredChecks, check)
					}
				}

				if len(filteredChecks) > 0 {
					err := ophelper.ExecuteTemplate(&opscode, "op-checks", map[string]interface{}{
						"Id":        opcode.id,
						"Pc":        opcode.pc,
						"Gas":       uint64(totalGas),
						"MinStack":  uint64(checkedStackIn),
						"MaxStack":  uint64(totalStackOut),
						"StackSize": uint64(irf.maxstack),
						"Checks":    filteredChecks,
						"Verbose":   irf.verbose,
					})
					if err != nil {
						fmt.Println("error executing op-checks", err)
					}
				}
			}

			if len(opcode.stackLoad) > 0 {
				ophelper.ExecuteTemplate(&opscode, "stack-load", map[string]interface{}{
					"Id":         opcode.id,
					"Pc":         opcode.pc,
					"Count":      uint64(len(opcode.stackLoad)),
					"StackCheck": irf.stackcheck,
					"Verbose":    irf.verbose,
				})
			}
			if len(opcode.stackStore) > 0 {
				storeBuf := bytes.Buffer{}
				opcode.stackStore["Id"] = opcode.id
				opcode.stackStore["Verbose"] = irf.verbose
				ophelper.ExecuteTemplate(&storeBuf, "stack-store", opcode.stackStore)
				model["StackStore"] = storeBuf.String()
			}
			opcode.tpl.ExecuteTemplate(&opscode, "ircode", model)
		}

		stackStoreModel := irf.getStackStoreModel(branch)
		if len(stackStoreModel) > 0 {
			stackStoreModel["Id"] = fmt.Sprintf("b%d", branch.pc)
			stackStoreModel["StackCheck"] = irf.stackcheck
			stackStoreModel["Verbose"] = irf.verbose
			ophelper.ExecuteTemplate(&opscode, "stack-store", stackStoreModel)
		}
	}

	return defcode.String(), opscode.String()
}

func (irf *IRFunction) String() string {
	fncode := bytes.Buffer{}
	defcode, opscode := irf.generateOpIRCode()

	fncode.WriteString(defcode)
	fncode.WriteString(fmt.Sprintf(`

define i32 @%s(%%struct.evm_callctx* noundef %%callctx) {
entry:
%%heap_stack_ptr = getelementptr inbounds %%struct.evm_callctx, %%struct.evm_callctx* %%callctx, i64 0, i32 0
%%stack_position_ptr = getelementptr inbounds %%struct.evm_callctx, %%struct.evm_callctx* %%callctx, i64 0, i32 1
%%pc_ptr = getelementptr inbounds %%struct.evm_callctx, %%struct.evm_callctx* %%callctx, i64 0, i32 2
%%gasleft_ptr = getelementptr inbounds %%struct.evm_callctx, %%struct.evm_callctx* %%callctx, i64 0, i32 3
%%evmc_callback_ptr = getelementptr inbounds %%struct.evm_callctx, %%struct.evm_callctx* %%callctx, i64 0, i32 4
%%heap_stack_addr = load i8*, i8** %%heap_stack_ptr, align 8
%%stack_addr = bitcast i8* %%heap_stack_addr to i256*
%%evmc_callback = load i32 (i8*, i8, i8*, i16, i16, i64*)*, i32 (i8*, i8, i8*, i16, i16, i64*)** %%evmc_callback_ptr, align 8
%%callctx_as_i8 = bitcast %%struct.evm_callctx* %%callctx to i8*
%%stack_gasleft_ptr = alloca i64, align 4
%%exitcode_ptr = alloca i32, align 4

%%gasleft_val = load i64, i64* %%gasleft_ptr, align 4
store i64 %%gasleft_val, i64* %%stack_gasleft_ptr
`, irf.name))

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
	fncode.WriteString(opscode)

	fncode.WriteString(`
br label %graceful_return
graceful_return:
`)

	fncode.WriteString(`
%res_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
store i64 %res_gas1, i64* %gasleft_ptr
ret i32 0
error_return:
%exitcode_val = load i32, i32* %exitcode_ptr, align 4
%err_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
store i64 %err_gas1, i64* %gasleft_ptr
ret i32 %exitcode_val
}
`)

	return fncode.String()
}

func (irf *IRFunction) getStackStoreModel(branch *IRBranch) map[string]interface{} {
	var model map[string]interface{}

	if branch.stackPos > branch.heapPos {
		resVars := []map[string]interface{}{}
		index := 0
		for stackPos := branch.heapPos; stackPos < branch.stackPos; stackPos++ {
			ref := branch.stackRefs[stackPos]
			if ref == nil {
				fmt.Println("ref is nil", stackPos)
				continue
			}
			resVars = append(resVars, map[string]interface{}{
				"Index": uint64(index),
				"Ref":   ref.refVar,
			})
			index++
		}

		model = map[string]interface{}{
			"Refs":  resVars,
			"Count": uint64(len(resVars)),
		}
	}

	return model
}

func (irf *IRFunction) appendOpcode(name string, pccount uint8, stackIn, stackOut int, gascost int32, model map[string]interface{}) error {
	if irf.branchCount == 0 {
		irf.branches = append(irf.branches, &IRBranch{
			pc:        0,
			opcodes:   []*IROpcode{},
			stackRefs: map[int]*IRStackRef{},
		})
		irf.branchCount++
		irf.noinitjump = true
	}

	if model == nil {
		model = map[string]interface{}{}
	}

	branch := irf.branches[irf.branchCount-1]
	tpl := irtpl.GetTemplate(name)
	opcode := &IROpcode{
		id:    irf.opcount,
		pc:    irf.pccount,
		gas:   gascost,
		name:  name,
		tpl:   tpl,
		model: model,
	}

	if stackIn > 0 {
		index := 0
		stackRefs := []string{}
		for stackPos := branch.stackPos - 1; stackPos >= branch.stackPos-stackIn; stackPos-- {
			stackRef := branch.stackRefs[stackPos]
			if stackRef != nil {
				delete(branch.stackRefs, stackPos)
				model[fmt.Sprintf("StackRef%d", index)] = stackRef.refVar
				stackRefs = append(stackRefs, stackRef.refVar)
			} else {
				refVar := fmt.Sprintf("%%l%v_input%d", opcode.id, len(opcode.stackLoad))
				opcode.stackLoad = append(opcode.stackLoad, refVar)
				model[fmt.Sprintf("StackRef%d", index)] = refVar
				stackRefs = append(stackRefs, refVar)
				branch.heapPos--

				if branch.heapPos < branch.stackMin {
					branch.stackMin = branch.heapPos
				}
			}
			index++
		}
		branch.stackPos -= stackIn
		model["StackRefs"] = stackRefs
	}
	if stackOut > 0 {
		index := 0
		for stackPos := branch.stackPos; stackPos < branch.stackPos+stackOut; stackPos++ {
			branch.stackRefs[stackPos] = &IRStackRef{
				opcode: opcode,
				refVar: fmt.Sprintf("%%l%v_res%d", opcode.id, index),
			}
			index++
		}
		branch.stackPos += stackOut

		if branch.stackPos > branch.stackMax {
			opcode.stackCheck = branch.stackPos
			branch.stackMax = branch.stackPos
		}
	}

	branch.opcodes = append(branch.opcodes, opcode)
	irf.pccount += uint32(pccount)
	irf.opcount++
	return nil
}

func (irf *IRFunction) AppendHighOpcode(op, inputs, outputs uint8, gascost int32, isStop bool) error {
	err := irf.appendOpcode("evmc-call.ll", 1, int(inputs), int(outputs), gascost, map[string]interface{}{
		"Name":    fmt.Sprintf("c%d", op),
		"Opcode":  uint64(op),
		"Inputs":  uint64(inputs),
		"Outputs": uint64(outputs),
		"IsDebug": false,
	})
	if err != nil {
		return err
	}
	branch := irf.branches[irf.branchCount-1]
	opcode := branch.opcodes[len(branch.opcodes)-1]
	opcode.breakGasGroup = isStop
	return nil
}

func (irf *IRFunction) AppendDebugOpcode() error {
	err := irf.appendOpcode("evmc-call.ll", 0, 0, 0, 0, map[string]interface{}{
		"Name":    "debug",
		"Opcode":  uint64(0xEE),
		"Inputs":  uint64(0),
		"Outputs": uint64(0),
		"IsDebug": true,
	})
	if err != nil {
		return err
	}
	return nil
}

func (irf *IRFunction) getLastStackRef() *IRStackRef {
	branch := irf.branches[irf.branchCount-1]
	return branch.stackRefs[branch.stackPos-1]
}

func (irf *IRFunction) AppendNop() error {
	irf.pccount++
	return nil
}

func (irf *IRFunction) AppendPushN(n uint8, data []uint8) error {
	gascost := int32(3)
	if n == 0 {
		gascost = 2
	}
	err := irf.appendOpcode("stack-pushn.ll", 1+n, 0, 1, gascost, map[string]interface{}{
		"DataLen": uint64(n),
		"Data":    data,
	})
	if err != nil {
		return err
	}

	stackRef := irf.getLastStackRef()
	stackRef.refVar = uint256.NewInt(0).SetBytes(data).String()
	return nil
}

func (irf *IRFunction) AppendDupN(n uint8) error {
	err := irf.appendOpcode("stack-dupn.ll", 1, 0, 1, 3, map[string]interface{}{
		"Position":  uint64(n),
		"LoadIndex": uint64(0),
	})
	if err != nil {
		return err
	}

	branch := irf.branches[irf.branchCount-1]
	opcode := branch.opcodes[len(branch.opcodes)-1]
	targetStackRef := branch.stackRefs[branch.stackPos-1]

	localStack := (0 - branch.heapPos) + branch.stackPos
	if int(n+1) > localStack {
		// need to load
		stackPos := int(n+1) - localStack
		opcode.model["LoadIndex"] = uint64(stackPos)
		opcode.stackAddLoad = stackPos
	} else {
		sourceStackRef := branch.stackRefs[branch.stackPos-int(n+1)]
		if sourceStackRef == nil {
			return fmt.Errorf("source stack ref is nil")
		}

		targetStackRef.refVar = sourceStackRef.refVar
	}

	return nil
}

func (irf *IRFunction) AppendSwapN(n uint8) error {
	err := irf.appendOpcode("stack-swapn.ll", 1, 1, 1, 3, map[string]interface{}{
		"Position":  uint64(n),
		"SwapIndex": uint64(0),
	})
	if err != nil {
		return err
	}

	branch := irf.branches[irf.branchCount-1]
	opcode := branch.opcodes[len(branch.opcodes)-1]
	targetStackRef := branch.stackRefs[branch.stackPos-1]

	localStack := (0 - branch.heapPos) + branch.stackPos
	if int(n+1) > localStack {
		// need to load
		stackPos := int(n+1) - localStack
		opcode.model["SwapIndex"] = uint64(stackPos)
		opcode.stackAddLoad = stackPos
	} else {
		targetStackRef.refVar = opcode.model["StackRef0"].(string)
		sourceStackRef := branch.stackRefs[branch.stackPos-int(n+1)]
		if sourceStackRef == nil {
			return fmt.Errorf("source stack ref is nil")
		}

		branch.stackRefs[branch.stackPos-1], branch.stackRefs[branch.stackPos-int(n+1)] = sourceStackRef, targetStackRef
	}

	return nil
}

func (irf *IRFunction) AppendPop() error {
	return irf.appendOpcode("stack-pop.ll", 1, 1, 0, 2, nil)
}

func (irf *IRFunction) AppendAdd() error {
	return irf.appendOpcode("math-add.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendSub() error {
	return irf.appendOpcode("math-sub.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendMul() error {
	return irf.appendOpcode("math-mul.ll", 1, 2, 1, 5, nil)
}

func (irf *IRFunction) AppendDiv() error {
	return irf.appendOpcode("math-div.ll", 1, 2, 1, 5, nil)
}

func (irf *IRFunction) AppendAddmod() error {
	return irf.appendOpcode("math-addmod.ll", 1, 3, 1, 8, nil)
}

func (irf *IRFunction) AppendMulmod() error {
	return irf.appendOpcode("math-mulmod.ll", 1, 3, 1, 8, nil)
}

func (irf *IRFunction) AppendSignextend() error {
	return irf.appendOpcode("math-signextend.ll", 1, 2, 1, 5, nil)
}

func (irf *IRFunction) AppendLt() error {
	return irf.appendOpcode("logic-lt.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendGt() error {
	return irf.appendOpcode("logic-gt.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendSlt() error {
	return irf.appendOpcode("logic-slt.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendSgt() error {
	return irf.appendOpcode("logic-sgt.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendEq() error {
	return irf.appendOpcode("logic-eq.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendIsZero() error {
	return irf.appendOpcode("logic-iszero.ll", 1, 1, 1, 3, nil)
}

func (irf *IRFunction) AppendAnd() error {
	return irf.appendOpcode("logic-and.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendOr() error {
	return irf.appendOpcode("logic-or.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendXor() error {
	return irf.appendOpcode("logic-xor.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendNot() error {
	return irf.appendOpcode("logic-not.ll", 1, 1, 1, 3, nil)
}

func (irf *IRFunction) AppendByte() error {
	return irf.appendOpcode("logic-byte.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendShl() error {
	return irf.appendOpcode("logic-shl.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendShr() error {
	return irf.appendOpcode("logic-shr.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendSar() error {
	return irf.appendOpcode("logic-sar.ll", 1, 2, 1, 3, nil)
}

func (irf *IRFunction) AppendJumpDest() error {
	irf.branches = append(irf.branches, &IRBranch{
		pc:        irf.pccount,
		opcodes:   []*IROpcode{},
		stackRefs: map[int]*IRStackRef{},
	})
	irf.branchCount++
	return irf.appendOpcode("flow-jumpdest.ll", 1, 0, 0, 1, nil)
}

func (irf *IRFunction) AppendJump() error {
	err := irf.appendOpcode("flow-jump.ll", 1, 1, 0, 8, nil)
	if err != nil {
		return err
	}
	branch := irf.branches[irf.branchCount-1]
	opcode := branch.opcodes[len(branch.opcodes)-1]
	opcode.stackStore = irf.getStackStoreModel(branch)
	opcode.breakGasGroup = true
	return nil
}

func (irf *IRFunction) AppendJumpI() error {
	err := irf.appendOpcode("flow-jumpi.ll", 1, 2, 0, 10, nil)
	if err != nil {
		return err
	}
	branch := irf.branches[irf.branchCount-1]
	opcode := branch.opcodes[len(branch.opcodes)-1]
	opcode.stackStore = irf.getStackStoreModel(branch)
	opcode.breakGasGroup = true
	return nil
}

func (irf *IRFunction) AppendStop() error {
	err := irf.appendOpcode("flow-stop.ll", 1, 0, 0, 0, nil)
	if err != nil {
		return err
	}
	branch := irf.branches[irf.branchCount-1]
	opcode := branch.opcodes[len(branch.opcodes)-1]
	opcode.breakGasGroup = true
	return nil
}

func (irf *IRFunction) AppendPc() error {
	err := irf.appendOpcode("flow-pc.ll", 1, 0, 1, 2, nil)
	if err != nil {
		return err
	}
	stackRef := irf.getLastStackRef()
	stackRef.refVar = fmt.Sprintf("%v", irf.opcount-1)
	return nil
}

func (irf *IRFunction) AppendGas() error {
	return irf.appendOpcode("flow-gas.ll", 1, 0, 1, 2, nil)
}
