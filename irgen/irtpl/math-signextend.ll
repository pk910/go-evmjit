{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): SIGNEXTEND{{- end }}
{{- end }}

{{- define "ircode" }}
%l{{ .Id }}_b_ge_31 = icmp uge i256 {{ .StackRef0 }}, 31
%l{{ .Id }}_b = select i1 %l{{ .Id }}_b_ge_31, i256 31, i256 {{ .StackRef0 }}
%l{{ .Id }}_b_plus_1 = add i256 %l{{ .Id }}_b, 1
%l{{ .Id }}_num_bits = mul i256 %l{{ .Id }}_b_plus_1, 8
%l{{ .Id }}_shift_amount = sub i256 256, %l{{ .Id }}_num_bits
%l{{ .Id }}_x_shl = shl i256 {{ .StackRef1 }}, %l{{ .Id }}_shift_amount
%l{{ .Id }}_y_extended = ashr i256 %l{{ .Id }}_x_shl, %l{{ .Id }}_shift_amount
%l{{ .Id }}_res0 = select i1 %l{{ .Id }}_b_ge_31, i256 {{ .StackRef1 }}, i256 %l{{ .Id }}_y_extended
{{ end }} 