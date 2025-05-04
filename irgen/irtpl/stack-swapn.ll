{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): SWAP{{ .Position }}{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_underflow_check = icmp ult i64 %l{{ .Id }}_1, {{ mul (add .Position 1) 32 }}
br i1 %l{{ .Id }}_underflow_check, label %l{{ .Id }}_err_underflow, label %l{{ .Id }}_ok
l{{ .Id }}_err_underflow:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_3 = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 -32
%l{{ .Id }}_7 = getelementptr inbounds i8, i8* %l{{ .Id }}_3, i64 -{{ mul .Position 32 }}
%l{{ .Id }}_8 = bitcast i8* %l{{ .Id }}_3 to i256*
%l{{ .Id }}_9 = bitcast i8* %l{{ .Id }}_7 to i256*
%l{{ .Id }}_10 = load i256, i256* %l{{ .Id }}_8, align 1
%l{{ .Id }}_11 = load i256, i256* %l{{ .Id }}_9, align 1
store i256 %l{{ .Id }}_10, i256* %l{{ .Id }}_9, align 1
store i256 %l{{ .Id }}_11, i256* %l{{ .Id }}_8, align 1
{{ end }}
