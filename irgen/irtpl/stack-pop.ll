{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: POP{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
%l{{ .Id }}_2 = add i64 %l{{ .Id }}_1, -32
store i64 %l{{ .Id }}_2, i64* %stack_position_ptr, align 8
{{ end }}
