
{{- define "stack-load" }}
%l{{ .Id }}_stack_in_val = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_stack_in_check = icmp ult i64 %l{{ .Id }}_stack_in_val, {{ mul .Count 32 }}
br i1 %l{{ .Id }}_stack_in_check, label %l{{ .Id }}_stack_in_err1, label %l{{ .Id }}_stack_in_ok
l{{ .Id }}_stack_in_err1:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l{{ .Id }}_stack_in_ok:
{{- end }}
%l{{ .Id }}_stack_in_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_stack_in_val
{{ $id := .Id }}
{{- range $index := loop .Count }}
%l{{ $id }}_stack_in_bptr{{ $index }} = getelementptr inbounds i8, i8* %l{{ $id }}_stack_in_ptr, i64 -{{ mul (add $index 1) 32 }}
%l{{ $id }}_stack_in_iptr{{ $index }} = bitcast i8* %l{{ $id }}_stack_in_bptr{{ $index }} to i256*
%l{{ $id }}_input{{ $index }} = load i256, i256* %l{{ $id }}_stack_in_iptr{{ $index }}, align 1
{{- end }}
%l{{ .Id }}_stack_in_val2 = add i64 %l{{ .Id }}_stack_in_val, -{{ mul .Count 32 }}
store i64 %l{{ .Id }}_stack_in_val2, i64* %stack_position_ptr, align 8
{{ end }}

{{- define "stack-store" }}
%l{{ .Id }}_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%l{{ .Id }}_stack_out_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_stack_out_val
{{ $id := .Id }}
{{- range $ref := .Refs }}
%l{{ $id }}_stack_out_bptr{{ $ref.Index }} = getelementptr inbounds i8, i8* %l{{ $id }}_stack_out_ptr, i64 {{ mul $ref.Index 32 }}
%l{{ $id }}_stack_out_iptr{{ $ref.Index }} = bitcast i8* %l{{ $id }}_stack_out_bptr{{ $ref.Index }} to i256*
store i256 {{ $ref.Ref }}, i256* %l{{ $id }}_stack_out_iptr{{ $ref.Index }}, align 1
{{- end }}
%l{{ .Id }}_stack_out_val2 = add i64 %l{{ .Id }}_stack_out_val, {{ mul .Count 32 }}
store i64 %l{{ .Id }}_stack_out_val2, i64* %stack_position_ptr, align 8
{{ end }}
