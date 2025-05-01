{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{- if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): JUMPDEST{{- end }}
{{- end }} 

{{- define "ircode" }}
{{- end }} 