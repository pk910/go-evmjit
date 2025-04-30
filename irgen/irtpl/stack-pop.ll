{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: POP{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_stack_check = icmp ult i64 %l{{ .Id }}_1, 32
br i1 %l{{ .Id }}_stack_check, label %l{{ .Id }}_err1, label %l{{ .Id }}_ok
l{{ .Id }}_err1:
ret i32 -10
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_2 = add i64 %l{{ .Id }}_1, -32
store i64 %l{{ .Id }}_2, i64* %stack_position_ptr, align 8
{{ end }}
