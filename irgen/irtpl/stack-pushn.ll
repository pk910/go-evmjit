{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): PUSH{{ .DataLen }} {{ hex .Data }}{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_2 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_overflow_check = icmp ugt i64 %l{{ .Id }}_2, {{ sub (mul .MaxStack 32) 32 }}
br i1 %l{{ .Id }}_overflow_check, label %l{{ .Id }}_err_overflow, label %l{{ .Id }}_ok
l{{ .Id }}_err_overflow:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_aptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_2
%l{{ .Id }}_aptr2 = bitcast i8* %l{{ .Id }}_aptr to i256*
store i256 {{ u256 .Data }}, i256* %l{{ .Id }}_aptr2, align 1
%l{{ .Id }}_6 = add i64 %l{{ .Id }}_2, 32
store i64 %l{{ .Id }}_6, i64* %stack_position_ptr, align 8
{{ end }}

