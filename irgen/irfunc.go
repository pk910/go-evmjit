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
		inputs:     0,
		outputs:    4,
		verbose:    verbose,
		stackcheck: true,
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
		fncode.WriteString(fmt.Sprintf(`
%%in_6 = load i64, i64* %%heap_stack_position_ptr, align 8
%%in_7 = getelementptr inbounds i8, i8* %%heap_stack_addr, i64 %%in_6
%%in_8 = shl nsw i64 %d, 5
%%in_10 = sub nsw i64 0, %%in_8
%%in_11 = getelementptr inbounds i8, i8* %%in_7, i64 %%in_10
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %%stack_addr, i8* align 1 %%in_11, i64 %%in_8, i1 false)
store i64 %%in_8, i64* %%stack_position_ptr, align 4
%%in_12 = add i64 %%in_6, -%d
store i64 %%in_12, i64* %%heap_stack_position_ptr, align 8
		`, irf.inputs, irf.inputs*32))
	}

	fncode.WriteString(irf.fncode.String())

	if irf.outputs > 0 {
		// load outputs from local stack to heap stack
		fncode.WriteString(fmt.Sprintf(`
%%out_1 = load i64, i64* %%heap_stack_position_ptr, align 8
%%out_2 = getelementptr inbounds i8, i8* %%heap_stack_addr, i64 %%out_1
%%out_3 = load i64, i64* %%stack_position_ptr
%%out_4 = sub i64 %%out_3, %d
%%out_5 = getelementptr inbounds i8, i8* %%stack_addr, i64 %%out_4
`, irf.outputs*32))

		for i := 0; i < int(irf.outputs); i++ {
			fncode.WriteString(fmt.Sprintf(`
%%out_l%d_src_ptr = getelementptr i8, i8* %%out_5, i64 %d
%%out_l%d_dst_ptr = getelementptr i8, i8* %%out_2, i64 %d`,
				i, i*32, i, i*32,
			))
			fncode.WriteString(fmt.Sprintf(`
%%out_l%d_src_ptr_lo = bitcast i8* %%out_l%d_src_ptr to i128*
%%out_l%d_src_ptr_hi = getelementptr i128, i128* %%out_l%d_src_ptr_lo, i32 1
%%out_l%d_dst_ptr_lo = bitcast i8* %%out_l%d_dst_ptr to i128*
%%out_l%d_dst_ptr_hi = getelementptr i128, i128* %%out_l%d_dst_ptr_lo, i32 1`,
				i, i, i, i, i, i, i, i,
			))
			fncode.WriteString(fmt.Sprintf(`
%%out_l%d_word_lo = load i128, i128* %%out_l%d_src_ptr_lo
%%out_l%d_word_hi = load i128, i128* %%out_l%d_src_ptr_hi
%%out_l%d_reversed_lo = call i128 @llvm.bswap.i128(i128 %%out_l%d_word_hi)
%%out_l%d_reversed_hi = call i128 @llvm.bswap.i128(i128 %%out_l%d_word_lo)
store i128 %%out_l%d_reversed_lo, i128* %%out_l%d_dst_ptr_lo
store i128 %%out_l%d_reversed_hi, i128* %%out_l%d_dst_ptr_hi`,
				i, i, i, i, i, i, i, i, i, i, i, i,
			))
		}

		/*
					fncode.WriteString(fmt.Sprintf(`
			tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %%out_2, i8* align 16 %%out_5, i64 %d, i1 false)
			`, irf.outputs*32))
		*/

		fncode.WriteString(fmt.Sprintf(`
%%out_6 = add i64 %%out_1, %d
store i64 %%out_6, i64* %%heap_stack_position_ptr, align 8
	`, irf.outputs*32))
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
