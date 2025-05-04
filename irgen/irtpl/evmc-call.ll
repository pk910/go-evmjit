{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): {{ .Name }} (Generic Callback){{- end }}
{{- end }} 

{{- define "ircode" }}
{{- $id := .Id }}
{{- $input_bytes := mul .Inputs 32 }}
{{- $output_bytes := mul .Outputs 32 }}

{{- /* input handling */}}
{{- if gt .Inputs 0 }}
%l{{ $id }}_in_stack_pos = load i64, i64* %stack_position_ptr
{{- if .StackCheck }}
%l{{ $id }}_in_underflow = icmp ult i64 %l{{ $id }}_in_stack_pos, {{ $input_bytes }}
br i1 %l{{ $id }}_in_underflow, label %l{{ $id }}_err_underflow, label %l{{ $id }}_in_ok
l{{ $id }}_err_underflow:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l{{ $id }}_in_ok:
{{- end }}
%l{{ $id }}_in_read_pos = sub i64 %l{{ $id }}_in_stack_pos, {{ $input_bytes }}
%l{{ $id }}_in_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ $id }}_in_read_pos
%l{{ $id }}_stack_pos_after_in = sub i64 %l{{ $id }}_in_stack_pos, {{ $input_bytes }}
store i64 %l{{ $id }}_stack_pos_after_in, i64* %stack_position_ptr, align 8
{{- end }}

{{- /* output handling */}}
{{- if gt .Outputs 0 }}
%l{{ $id }}_out_stack_pos = load i64, i64* %stack_position_ptr
{{- if and .StackCheck (gt .Outputs .Inputs) }}
%l{{ $id }}_overflow_check = icmp ugt i64 %l{{ $id }}_out_stack_pos, {{ sub (mul .MaxStack 32) (mul .Outputs 32) }}
br i1 %l{{ $id }}_overflow_check, label %l{{ $id }}_err_overflow, label %l{{ $id }}_out_ok
l{{ $id }}_err_overflow:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l{{ $id }}_out_ok:
{{- end }}
%l{{ $id }}_out_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ $id }}_out_stack_pos
{{- end }}

{{- /* function call */}}
store i64 {{ .Pc }}, i64* %pc_ptr
%l{{ $id }}_fn_ptr_addr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 3
%l{{ $id }}_fn_ptr = load i32 (i8*, i8, i8*, i16, i8*, i16, i64*)*, i32 (i8*, i8, i8*, i16, i8*, i16, i64*)** %l{{ $id }}_fn_ptr_addr, align 8
%l{{ $id }}_ctx_as_i8 = bitcast %struct.evm_callctx* %callctx to i8*
%l{{ $id }}_ret = call i32 %l{{ $id }}_fn_ptr(
    i8* %l{{ $id }}_ctx_as_i8,
    i8 {{ .Opcode }},
    i8* {{ if gt .Inputs 0 }}%l{{ $id }}_in_ptr{{ else }}null{{ end }},
    i16 {{ $input_bytes }},
    i8* {{ if gt .Outputs 0 }}%l{{ $id }}_out_ptr{{ else }}null{{ end }},
    i16 {{ $output_bytes }},
    i64* %stack_gasleft_ptr
)

{{- /* result handling */}}
%l{{ $id }}_ret_check = icmp ne i32 %l{{ $id }}_ret, 0
br i1 %l{{ $id }}_ret_check, label %l{{ $id }}_err_callback, label %l{{ $id }}_callback_ok
l{{ $id }}_err_callback:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 %l{{ $id }}_ret, i32* %exitcode_ptr
  br label %error_return
l{{ $id }}_callback_ok:
{{- if gt .Outputs 0 }}
%l{{ $id }}_new_stack_pos_after_out = add i64 %l{{ $id }}_out_stack_pos, {{ $output_bytes }}
store i64 %l{{ $id }}_new_stack_pos_after_out, i64* %stack_position_ptr, align 8
{{- end }}
{{ end }}
