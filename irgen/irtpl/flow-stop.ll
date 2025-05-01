{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): STOP{{- end }}
{{- end }} 

{{- define "ircode" }}
store i64 {{ .Pc }}, i64* %pc_ptr
br label %graceful_return
{{ end }}