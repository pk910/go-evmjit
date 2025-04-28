{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: ADD{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_aptr = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 -32
%l{{ .Id }}_bptr = getelementptr inbounds i8, i8* %l{{ .Id }}_aptr, i64 -32
%l{{ .Id }}_aptr2 = bitcast i8* %l{{ .Id }}_aptr to i256*
%l{{ .Id }}_bptr2 = bitcast i8* %l{{ .Id }}_bptr to i256*
%l{{ .Id }}_a = load i256, i256* %l{{ .Id }}_aptr2
%l{{ .Id }}_b = load i256, i256* %l{{ .Id }}_bptr2
%l{{ .Id }}_sum = add i256 %l{{ .Id }}_a, %l{{ .Id }}_b
store i256 %l{{ .Id }}_sum, i256* %l{{ .Id }}_bptr2
%l{{ .Id }}_sdv = add i64 %l{{ .Id }}_1, -32
store i64 %l{{ .Id }}_sdv, i64* %stack_position_ptr, align 8
{{ end }}
