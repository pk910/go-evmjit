{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): PC{{- end }}
{{- end }} 

{{- define "ircode" }}
{{ end }}

