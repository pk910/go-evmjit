{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): SGT{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_cmp = icmp sgt i256 {{ .StackRef0 }}, {{ .StackRef1 }}
%l{{ .Id }}_res0 = select i1 %l{{ .Id }}_cmp, i256 1, i256 0
{{ end }} 