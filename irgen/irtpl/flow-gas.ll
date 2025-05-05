{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): PC{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_3 = load i64, i64* %stack_gasleft_ptr, align 8
%l{{ .Id }}_res0 = zext i64 %l{{ .Id }}_3 to i256
{{ end }}

