{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: STOP{{- end }}
store i64 {{ .Pc }}, i64* %pc_ptr
br label %graceful_return
{{ end }}