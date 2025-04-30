{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: PC{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_overflow_check = icmp ugt i64 %l{{ .Id }}_1, {{ sub (mul .MaxStack 32) 32 }}
br i1 %l{{ .Id }}_overflow_check, label %l{{ .Id }}_err_overflow, label %l{{ .Id }}_ok
l{{ .Id }}_err_overflow:
  ret i32 -11
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_aptr2 = bitcast i8* %l{{ .Id }}_2 to i256*
store i256 {{ .Pc }}, i256* %l{{ .Id }}_aptr2, align 1
%l{{ .Id }}_6 = add i64 %l{{ .Id }}_1, 32
store i64 %l{{ .Id }}_6, i64* %stack_position_ptr, align 8
{{ end }}

