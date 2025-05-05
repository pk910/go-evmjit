{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): XOR{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_res0 = xor i256 {{ .StackRef0 }}, {{ .StackRef1 }}
{{ end }} 