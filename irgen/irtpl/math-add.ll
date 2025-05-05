{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): ADD{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_res0 = add i256 {{ .StackRef0 }}, {{ .StackRef1 }}
{{ end }}
