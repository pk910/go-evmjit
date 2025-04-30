{{- define "ircode" }}
%out_1 = load i64, i64* %heap_stack_position_ptr, align 8
%out_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %out_1
%out_3 = load i64, i64* %stack_position_ptr
{{- if .StackCheck }}
%out_stack_check1 = icmp ult i64 %out_3, {{ mul .Outputs 32 }}
br i1 %out_stack_check1, label %out_err1, label %out_ok1
out_err1:
  ret i32 -10
out_ok1:
%out_stack_check2 = icmp ugt i64 %out_1, {{ mul (sub .MaxStack .Outputs) 32 }}
br i1 %out_stack_check2, label %out_err2, label %out_ok2
out_err2:
  ret i32 -11
out_ok2:
{{- end }}
%out_4 = sub i64 %out_3, {{ mul .Outputs 32 }}
%out_5 = getelementptr inbounds i8, i8* %stack_addr, i64 %out_4
{{- range $idx := loop .Outputs }}
%out_l{{ $idx }}_src_ptr = getelementptr i8, i8* %out_5, i64 {{ mul $idx 32 }}
%out_l{{ $idx }}_dst_ptr = getelementptr i8, i8* %out_2, i64 {{ mul $idx 32 }}
%out_l{{ $idx }}_src_ptr_lo = bitcast i8* %out_l{{ $idx }}_src_ptr to i128*
%out_l{{ $idx }}_src_ptr_hi = getelementptr i128, i128* %out_l{{ $idx }}_src_ptr_lo, i32 1
%out_l{{ $idx }}_dst_ptr_lo = bitcast i8* %out_l{{ $idx }}_dst_ptr to i128*
%out_l{{ $idx }}_dst_ptr_hi = getelementptr i128, i128* %out_l{{ $idx }}_dst_ptr_lo, i32 1
%out_l{{ $idx }}_word_lo = load i128, i128* %out_l{{ $idx }}_src_ptr_lo
%out_l{{ $idx }}_word_hi = load i128, i128* %out_l{{ $idx }}_src_ptr_hi
%out_l{{ $idx }}_reversed_lo = call i128 @llvm.bswap.i128(i128 %out_l{{ $idx }}_word_hi)
%out_l{{ $idx }}_reversed_hi = call i128 @llvm.bswap.i128(i128 %out_l{{ $idx }}_word_lo)
store i128 %out_l{{ $idx }}_reversed_lo, i128* %out_l{{ $idx }}_dst_ptr_lo
store i128 %out_l{{ $idx }}_reversed_hi, i128* %out_l{{ $idx }}_dst_ptr_hi
{{- end }}
%out_6 = add i64 %out_1, {{ mul .Outputs 32 }}
store i64 %out_6, i64* %heap_stack_position_ptr, align 8
%out_7 = sub i64 %out_3, {{ mul .Outputs 32 }}
store i64 %out_7, i64* %stack_position_ptr, align 8
{{- end }}