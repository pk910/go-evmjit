{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: JUMP{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_stack_check = icmp ult i64 %l{{ .Id }}_1, 64
br i1 %l{{ .Id }}_stack_check, label %l{{ .Id }}_err1, label %l{{ .Id }}_ok
l{{ .Id }}_err1:
  ret i32 -10
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_aptr = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 -32
%l{{ .Id }}_bptr = getelementptr inbounds i8, i8* %l{{ .Id }}_aptr, i64 -32
%l{{ .Id }}_bptr2 = bitcast i8* %l{{ .Id }}_bptr to i256*
%l{{ .Id }}_b = load i256, i256* %l{{ .Id }}_bptr2, align 1
%l{{ .Id }}_cmp = icmp ne i256 %l{{ .Id }}_b, 0
br i1 %l{{ .Id }}_cmp, label %l{{ .Id }}_jump, label %l{{ .Id }}_skip
l{{ .Id }}_jump:
%l{{ .Id }}_aptr2 = bitcast i8* %l{{ .Id }}_aptr to i256*
%l{{ .Id }}_a = load i256, i256* %l{{ .Id }}_aptr2, align 1
%l{{ .Id }}_a_trunc = trunc i256 %l{{ .Id }}_a to i64
store i64 %l{{ .Id }}_a_trunc, i64* %jump_target, align 1
br label %jump_table
l{{ .Id }}_skip:
{{ end }}