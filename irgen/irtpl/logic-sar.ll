{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): SAR{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_shift_check = icmp uge i256 {{ .StackRef0 }}, 256
br i1 %l{{ .Id }}_shift_check, label %l{{ .Id }}_shift_large, label %l{{ .Id }}_shift_ok
l{{ .Id }}_shift_large:
  %l{{ .Id }}_sign_bit = lshr i256 {{ .StackRef1 }}, 255
  %l{{ .Id }}_is_negative = icmp eq i256 %l{{ .Id }}_sign_bit, 1
  %l{{ .Id }}_res_large_shift = select i1 %l{{ .Id }}_is_negative, i256 -1, i256 0
  br label %l{{ .Id }}_store_res
l{{ .Id }}_shift_ok:
  %l{{ .Id }}_shifted_val = ashr i256 {{ .StackRef1 }}, {{ .StackRef0 }}
  br label %l{{ .Id }}_store_res
l{{ .Id }}_store_res:
%l{{ .Id }}_res0 = phi i256 [ %l{{ .Id }}_res_large_shift, %l{{ .Id }}_shift_large ], [ %l{{ .Id }}_shifted_val, %l{{ .Id }}_shift_ok ]
{{ end }} 