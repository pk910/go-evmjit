{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): JUMP{{- end }}
{{- end }} 

{{- define "ircode" }}
{{- .StackStore }}
{{- if .IsStatic }}
{{- if .IsValidTarget }}
br label %br_{{ .StackRef0 }}
{{- else }}
store i64 {{ .Pc }}, i64* %pc_ptr
store i32 -12, i32* %exitcode_ptr
br label %error_return
{{- end }}
{{- else }}
%l{{ .Id }}_a_max = icmp ugt i256 {{ .StackRef0 }}, 18446744073709551615
br i1 %l{{ .Id }}_a_max, label %jump_invalid, label %l{{ .Id }}_continue
l{{ .Id }}_continue:
%l{{ .Id }}_a_trunc = trunc i256 {{ .StackRef0 }} to i64
store i64 %l{{ .Id }}_a_trunc, i64* %jump_target, align 1
store i64 {{ .Pc }}, i64* %pc_ptr
br label %jump_table
{{- end }}
{{ end }}