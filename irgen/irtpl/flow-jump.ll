{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): JUMP{{- end }}
{{- end }} 

{{- define "ircode" }}
{{- .StackStore }}
%l{{ .Id }}_a_trunc = trunc i256 {{ .StackRef0 }} to i64
store i64 %l{{ .Id }}_a_trunc, i64* %jump_target, align 1
store i64 {{ .Pc }}, i64* %pc_ptr
br label %jump_table
{{ end }}