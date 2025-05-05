{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): OR{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_res0 = or i256 {{ .StackRef0 }}, {{ .StackRef1 }}
{{ end }}