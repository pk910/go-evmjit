
{{- define "gascheck" }}
%l{{ .Id }}_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l{{ .Id }}_gas2 = icmp ult i64 %l{{ .Id }}_gas1, {{ .Gas }}
br i1 %l{{ .Id }}_gas2, label %l{{ .Id }}_gaserr, label %l{{ .Id }}_gasok
l{{ .Id }}_gaserr:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l{{ .Id }}_gasok:
%l{{ .Id }}_gas4 = add i64 %l{{ .Id }}_gas1, -{{ .Gas }}
store i64 %l{{ .Id }}_gas4, i64* %stack_gasleft_ptr, align 1
{{- end }}
