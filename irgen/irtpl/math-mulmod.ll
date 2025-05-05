{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): MULMOD{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_prod = mul i256 {{ .StackRef0 }}, {{ .StackRef1 }}
%l{{ .Id }}_is_n_zero = icmp eq i256 {{ .StackRef2 }}, 0
%l{{ .Id }}_mod_result_unsafe = urem i256 %l{{ .Id }}_prod, {{ .StackRef2 }}
%l{{ .Id }}_res0 = select i1 %l{{ .Id }}_is_n_zero, i256 0, i256 %l{{ .Id }}_mod_result_unsafe
{{ end }} 