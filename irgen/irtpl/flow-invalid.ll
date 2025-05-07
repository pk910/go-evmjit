{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): INVALID{{- end }}
{{- end }} 

{{- define "ircode" }}
store i32 -14, i32* %exitcode_ptr
store i64 {{ .Pc }}, i64* %pc_ptr
br label %error_return
{{ end }}