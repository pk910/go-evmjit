{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): BYTE{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_index_check = icmp uge i256 {{ .StackRef0 }}, 32
br i1 %l{{ .Id }}_index_check, label %l{{ .Id }}_index_out, label %l{{ .Id }}_index_in
l{{ .Id }}_index_out:
  br label %l{{ .Id }}_store_res
l{{ .Id }}_index_in:
  %l{{ .Id }}_le_byte_index = sub i256 31, {{ .StackRef0 }}
  %l{{ .Id }}_shift_amount = mul i256 %l{{ .Id }}_le_byte_index, 8
  %l{{ .Id }}_shifted_x = lshr i256 {{ .StackRef1 }}, %l{{ .Id }}_shift_amount
  %l{{ .Id }}_masked_res = and i256 %l{{ .Id }}_shifted_x, 255
  br label %l{{ .Id }}_store_res
l{{ .Id }}_store_res:
%l{{ .Id }}_res0 = phi i256 [ 0, %l{{ .Id }}_index_out ], [ %l{{ .Id }}_masked_res, %l{{ .Id }}_index_in ]
{{ end }} 