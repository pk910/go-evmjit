{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): JUMP{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_cmp = icmp ne i256 {{ .StackRef1 }}, 0
br i1 %l{{ .Id }}_cmp, label %l{{ .Id }}_jump, label %l{{ .Id }}_skip
l{{ .Id }}_jump:
{{- .StackStore }}
%l{{ .Id }}_a_trunc = trunc i256 {{ .StackRef0 }} to i64
store i64 %l{{ .Id }}_a_trunc, i64* %jump_target, align 1
store i64 {{ .Pc }}, i64* %pc_ptr
br label %jump_table
l{{ .Id }}_skip:
{{ end }}