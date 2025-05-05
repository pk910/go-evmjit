{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): MUL{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_res0 = mul i256 {{ .StackRef0 }}, {{ .StackRef1 }}
{{ end }}
