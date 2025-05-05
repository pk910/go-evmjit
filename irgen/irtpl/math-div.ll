{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): DIV{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_res0 = udiv i256 {{ .StackRef0 }}, {{ .StackRef1 }}
{{ end }}
