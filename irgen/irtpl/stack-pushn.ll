{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): PUSH{{ .DataLen }} {{ hex .Data }}{{- end }}
{{- end }} 

{{- define "ircode" }}
{{ end }}

