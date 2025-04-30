{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: {{ .Name }} (Generic Callback){{- end }}
{{- $id := .Id }}
{{- if gt .Inputs 0 }}
%l{{ $id }}_in_buffer_alloca = alloca i8, i64 {{ mul .Inputs 32 }}, align 32
%l{{ $id }}_in_stack_pos = load i64, i64* %stack_position_ptr
{{- if .StackCheck }}
%l{{ $id }}_in_stack_check1 = icmp ult i64 %l{{ $id }}_in_stack_pos, {{ mul .Inputs 32 }}
br i1 %l{{ $id }}_in_stack_check1, label %l{{ $id }}_err_underflow, label %l{{ $id }}_in_ok1
l{{ $id }}_err_underflow:
  ret i32 -10
l{{ $id }}_in_ok1:
{{- end }}
%l{{ $id }}_in_stack_read_pos = sub i64 %l{{ $id }}_in_stack_pos, {{ mul .Inputs 32 }}
%l{{ $id }}_in_stack_read_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ $id }}_in_stack_read_pos
{{- range $idx := loop .Inputs }}
%l{{ $id }}_in_src_ptr_{{ $idx }} = getelementptr i8, i8* %l{{ $id }}_in_stack_read_ptr, i64 {{ mul $idx 32 }}
%l{{ $id }}_in_dst_ptr_{{ $idx }} = getelementptr i8, i8* %l{{ $id }}_in_buffer_alloca, i64 {{ mul $idx 32 }} ; Use alloca buffer ptr
%l{{ $id }}_in_src_ptr_lo_{{ $idx }} = bitcast i8* %l{{ $id }}_in_src_ptr_{{ $idx }} to i128*
%l{{ $id }}_in_src_ptr_hi_{{ $idx }} = getelementptr i128, i128* %l{{ $id }}_in_src_ptr_lo_{{ $idx }}, i32 1
%l{{ $id }}_in_dst_ptr_lo_{{ $idx }} = bitcast i8* %l{{ $id }}_in_dst_ptr_{{ $idx }} to i128*
%l{{ $id }}_in_dst_ptr_hi_{{ $idx }} = getelementptr i128, i128* %l{{ $id }}_in_dst_ptr_lo_{{ $idx }}, i32 1
%l{{ $id }}_in_word_lo_{{ $idx }} = load i128, i128* %l{{ $id }}_in_src_ptr_lo_{{ $idx }}
%l{{ $id }}_in_word_hi_{{ $idx }} = load i128, i128* %l{{ $id }}_in_src_ptr_hi_{{ $idx }}
%l{{ $id }}_in_reversed_lo_{{ $idx }} = call i128 @llvm.bswap.i128(i128 %l{{ $id }}_in_word_hi_{{ $idx }})
%l{{ $id }}_in_reversed_hi_{{ $idx }} = call i128 @llvm.bswap.i128(i128 %l{{ $id }}_in_word_lo_{{ $idx }})
store i128 %l{{ $id }}_in_reversed_lo_{{ $idx }}, i128* %l{{ $id }}_in_dst_ptr_lo_{{ $idx }}
store i128 %l{{ $id }}_in_reversed_hi_{{ $idx }}, i128* %l{{ $id }}_in_dst_ptr_hi_{{ $idx }}
{{- end }}
%l{{ $id }}_new_evm_stack_pos_after_in = sub i64 %l{{ $id }}_in_stack_pos, {{ mul .Inputs 32 }}
store i64 %l{{ $id }}_new_evm_stack_pos_after_in, i64* %stack_position_ptr, align 8
{{- end }}
{{- if gt .Outputs 0 }}
%l{{ $id }}_out_buffer_alloca = alloca i8, i64 {{ mul .Outputs 32 }}, align 32
%l{{ $id }}_out_stack_pos = load i64, i64* %stack_position_ptr
{{- if .StackCheck }}
%l{{ $id }}_overflow_check = icmp ugt i64 %l{{ $id }}_out_stack_pos, {{ sub (mul .MaxStack 32) (mul .Outputs 32) }}
br i1 %l{{ $id }}_overflow_check, label %l{{ $id }}_err_overflow, label %l{{ $id }}_out_ok1
l{{ $id }}_err_overflow:
  ret i32 -11
l{{ $id }}_out_ok1:
{{- end }}
{{- end }}
store i64 {{ .Pc }}, i64* %pc_ptr
%l{{ $id }}_opcode_fn_ptr_addr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 3
%l{{ $id }}_opcode_fn_ptr = load i32 (i8*, i8, i8*, i16, i8*, i16, i16*)*, i32 (i8*, i8, i8*, i16, i8*, i16, i16*)** %l{{ $id }}_opcode_fn_ptr_addr, align 8
%l{{ $id }}_callctx_ptr_arg = bitcast %struct.evm_callctx* %callctx to i8* ; Cast callctx to i8* for the function signature
%l{{ $id }}_call_ret = call i32 %l{{ $id }}_opcode_fn_ptr(
    i8* %l{{ $id }}_callctx_ptr_arg,
    i8 {{ .Opcode }},
    i8* {{ if gt .Inputs 0 }}%l{{ $id }}_in_buffer_alloca{{ else }}null{{ end }},
    i16 {{ mul .Inputs 32 }},
    i8* {{ if gt .Outputs 0 }}%l{{ $id }}_out_buffer_alloca{{ else }}null{{ end }},
    i16 {{ mul .Outputs 32 }},
    i16* %stack_gasleft_ptr
)
%l{{ $id }}_call_ret_check = icmp ne i32 %l{{ $id }}_call_ret, 0
br i1 %l{{ $id }}_call_ret_check, label %l{{ $id }}_err_callback, label %l{{ $id }}_callback_ok
l{{ $id }}_err_callback:
  ret i32 %l{{ $id }}_call_ret
l{{ $id }}_callback_ok:
{{- if gt .Outputs 0 }}
%l{{ $id }}_evm_stack_write_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ $id }}_out_stack_pos
{{- range $idx := loop .Outputs }}
%l{{ $id }}_out_src_ptr_{{ $idx }} = getelementptr i8, i8* %l{{ $id }}_out_buffer_alloca, i64 {{ mul $idx 32 }}
%l{{ $id }}_out_dst_ptr_{{ $idx }} = getelementptr i8, i8* %l{{ $id }}_evm_stack_write_ptr, i64 {{ mul $idx 32 }}
%l{{ $id }}_out_src_ptr_lo_{{ $idx }} = bitcast i8* %l{{ $id }}_out_src_ptr_{{ $idx }} to i128*
%l{{ $id }}_out_src_ptr_hi_{{ $idx }} = getelementptr i128, i128* %l{{ $id }}_out_src_ptr_lo_{{ $idx }}, i32 1
%l{{ $id }}_out_dst_ptr_lo_{{ $idx }} = bitcast i8* %l{{ $id }}_out_dst_ptr_{{ $idx }} to i128*
%l{{ $id }}_out_dst_ptr_hi_{{ $idx }} = getelementptr i128, i128* %l{{ $id }}_out_dst_ptr_lo_{{ $idx }}, i32 1
%l{{ $id }}_out_word_lo_{{ $idx }} = load i128, i128* %l{{ $id }}_out_src_ptr_lo_{{ $idx }}
%l{{ $id }}_out_word_hi_{{ $idx }} = load i128, i128* %l{{ $id }}_out_src_ptr_hi_{{ $idx }}
%l{{ $id }}_out_reversed_lo_{{ $idx }} = call i128 @llvm.bswap.i128(i128 %l{{ $id }}_out_word_hi_{{ $idx }})
%l{{ $id }}_out_reversed_hi_{{ $idx }} = call i128 @llvm.bswap.i128(i128 %l{{ $id }}_out_word_lo_{{ $idx }})
store i128 %l{{ $id }}_out_reversed_lo_{{ $idx }}, i128* %l{{ $id }}_out_dst_ptr_lo_{{ $idx }}
store i128 %l{{ $id }}_out_reversed_hi_{{ $idx }}, i128* %l{{ $id }}_out_dst_ptr_hi_{{ $idx }}
{{- end }}
%l{{ $id }}_new_evm_stack_pos_after_out = add i64 %l{{ $id }}_out_stack_pos, {{ mul .Outputs 32 }}
store i64 %l{{ $id }}_new_evm_stack_pos_after_out, i64* %stack_position_ptr, align 8
{{- end }}
{{ end }}
