{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: ISZERO{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_stack_check = icmp ult i64 %l{{ .Id }}_1, 32
br i1 %l{{ .Id }}_stack_check, label %l{{ .Id }}_err1, label %l{{ .Id }}_ok
l{{ .Id }}_err1:
  ret i32 -10
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_aptr = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 -32
%l{{ .Id }}_aptr2 = bitcast i8* %l{{ .Id }}_aptr to i256*
%l{{ .Id }}_a = load i256, i256* %l{{ .Id }}_aptr2, align 1
%l{{ .Id }}_cmp = icmp eq i256 %l{{ .Id }}_a, 0
%l{{ .Id }}_res = select i1 %l{{ .Id }}_cmp, i256 1, i256 0
store i256 %l{{ .Id }}_res, i256* %l{{ .Id }}_aptr2, align 1
{{ end }} 