{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): POP{{- end }}
{{- end }} 

{{- define "ircode" }}
{{ end }}
