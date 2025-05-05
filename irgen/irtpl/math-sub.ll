{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): SUB{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_res0 = sub i256 {{ .StackRef0 }}, {{ .StackRef1 }}
{{ end }}
