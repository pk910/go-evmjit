{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): SHR{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_shift_check = icmp uge i256 {{ .StackRef0 }}, 256
br i1 %l{{ .Id }}_shift_check, label %l{{ .Id }}_shift_large, label %l{{ .Id }}_shift_ok
l{{ .Id }}_shift_large:
  br label %l{{ .Id }}_store_res
l{{ .Id }}_shift_ok:
  %l{{ .Id }}_shifted_val = lshr i256 {{ .StackRef1 }}, {{ .StackRef0 }}
  br label %l{{ .Id }}_store_res
l{{ .Id }}_store_res:
%l{{ .Id }}_res0 = phi i256 [ 0, %l{{ .Id }}_shift_large ], [ %l{{ .Id }}_shifted_val, %l{{ .Id }}_shift_ok ]
{{ end }} 