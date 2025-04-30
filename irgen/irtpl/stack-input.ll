{{- define "ircode" }}

%in_1 = load i64, i64* %heap_stack_position_ptr, align 8
%in_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %in_1
%in_3 = load i64, i64* %stack_position_ptr
{{- if .StackCheck }}
%in_stack_check1 = icmp ult i64 %in_1, {{ mul .inputs 32 }}
br i1 %in_stack_check1, label %in_err1, label %in_ok1
in_err1:
  ret i32 -10
in_ok1:
%in_stack_check2 = icmp ugt i64 %in_3, {{ mul (sub .MaxStack .inputs) 32 }}
br i1 %in_stack_check2, label %in_err2, label %in_ok2
in_err2:
  ret i32 -11
in_ok2:
{{- end }}
%in_4 = sub i64 %in_3, {{ mul .Inputs 32 }}
%in_5 = getelementptr inbounds i8, i8* %stack_addr, i64 %in_4
{{- range $idx := loop .Inputs }}
%in_l{{ $idx }}_src_ptr = getelementptr i8, i8* %in_2, i64 {{ mul $idx 32 }}
%in_l{{ $idx }}_dst_ptr = getelementptr i8, i8* %in_5, i64 {{ mul $idx 32 }}
%in_l{{ $idx }}_src_ptr_lo = bitcast i8* %in_l{{ $idx }}_src_ptr to i128*
%in_l{{ $idx }}_src_ptr_hi = getelementptr i128, i128* %in_l{{ $idx }}_src_ptr_lo, i32 1
%in_l{{ $idx }}_dst_ptr_lo = bitcast i8* %in_l{{ $idx }}_dst_ptr to i128*
%in_l{{ $idx }}_dst_ptr_hi = getelementptr i128, i128* %in_l{{ $idx }}_dst_ptr_lo, i32 1
%in_l{{ $idx }}_word_lo = load i128, i128* %in_l{{ $idx }}_src_ptr_lo
%in_l{{ $idx }}_word_hi = load i128, i128* %in_l{{ $idx }}_src_ptr_hi
%in_l{{ $idx }}_reversed_lo = call i128 @llvm.bswap.i128(i128 %in_l{{ $idx }}_word_hi)
%in_l{{ $idx }}_reversed_hi = call i128 @llvm.bswap.i128(i128 %in_l{{ $idx }}_word_lo)
store i128 %in_l{{ $idx }}_reversed_lo, i128* %in_l{{ $idx }}_dst_ptr_lo
store i128 %in_l{{ $idx }}_reversed_hi, i128* %in_l{{ $idx }}_dst_ptr_hi
{{- end }}
%in_6 = sub i64 %in_1, {{ mul .Inputs 32 }}
store i64 %in_6, i64* %heap_stack_position_ptr, align 8
%in_7 = add i64 %in_3, {{ mul .Inputs 32 }}
store i64 %in_7, i64* %stack_position_ptr, align 8
{{- end }}