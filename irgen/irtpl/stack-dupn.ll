{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): DUP{{ .Position }}{{- end }}
{{- end }} 

{{- define "ircode" }}
{{- if gt .LoadIndex 0 }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
%l{{ .Id }}_2 = getelementptr inbounds i256, i256* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_3 = getelementptr inbounds i256, i256* %l{{ .Id }}_2, i64 -{{ .LoadIndex }}
%l{{ .Id }}_res0 = load i256, i256* %l{{ .Id }}_3, align 1
{{- end }}
{{ end }}
