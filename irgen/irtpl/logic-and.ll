{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): AND{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_res0 = and i256 {{ .StackRef0 }}, {{ .StackRef1 }}
{{ end }}