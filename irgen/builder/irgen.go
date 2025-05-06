package builder

import (
	"bytes"
	"fmt"
)

// IRBuilder helps construct IR code from EOF bytecode.
type IRBuilder struct {
	buf bytes.Buffer
}

// NewIRBuilder creates and initializes a new IRBuilder.
func NewIRBuilder() *IRBuilder {
	return &IRBuilder{}
}

func (b *IRBuilder) String() string {
	return fmt.Sprintf(`
%%struct.evm_callctx = type { i8*, i64, i64, i64, i32 (i8*, i8, i8*, i16, i16, i64*)*, i8* }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare i128 @llvm.bswap.i128(i128)
declare i32 @llvm.ctlz.i256(i256, i1 immarg)
%s
`, b.buf.String())
}

func (b *IRBuilder) AddFunction(irfunc *IRFunction) error {
	b.buf.WriteString(irfunc.String())
	return nil
}
