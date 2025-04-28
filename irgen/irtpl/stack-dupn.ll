{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: DUP{{ .Position }}{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_3 = shl nsw i32 {{ .Position }}, 5
%l{{ .Id }}_4 = sext i32 %l{{ .Id }}_3 to i64
%l{{ .Id }}_5 = sub nsw i64 0, %l{{ .Id }}_4
%l{{ .Id }}_6 = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 %l{{ .Id }}_5
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_2, i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_6, i64 32, i1 false)
%l{{ .Id }}_7 = add i64 %l{{ .Id }}_1, 32
store i64 %l{{ .Id }}_7, i64* %stack_position_ptr, align 8
{{ end }}
