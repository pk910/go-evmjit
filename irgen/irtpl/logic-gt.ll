{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }}: GT{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_stack_check = icmp ult i64 %l{{ .Id }}_1, 64
br i1 %l{{ .Id }}_stack_check, label %l{{ .Id }}_err1, label %l{{ .Id }}_ok
l{{ .Id }}_err1:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_aptr = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 -32
%l{{ .Id }}_bptr = getelementptr inbounds i8, i8* %l{{ .Id }}_aptr, i64 -32
%l{{ .Id }}_aptr2 = bitcast i8* %l{{ .Id }}_aptr to i256*
%l{{ .Id }}_bptr2 = bitcast i8* %l{{ .Id }}_bptr to i256*
%l{{ .Id }}_a = load i256, i256* %l{{ .Id }}_aptr2, align 1
%l{{ .Id }}_b = load i256, i256* %l{{ .Id }}_bptr2, align 1
%l{{ .Id }}_cmp = icmp ugt i256 %l{{ .Id }}_a, %l{{ .Id }}_b
%l{{ .Id }}_res = select i1 %l{{ .Id }}_cmp, i256 1, i256 0
store i256 %l{{ .Id }}_res, i256* %l{{ .Id }}_bptr2, align 1
%l{{ .Id }}_sdv = add i64 %l{{ .Id }}_1, -32
store i64 %l{{ .Id }}_sdv, i64* %stack_position_ptr, align 8
{{ end }} 