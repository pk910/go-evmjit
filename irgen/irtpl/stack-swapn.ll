{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: SWAP{{ .Position }}{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_underflow_check = icmp ult i64 %l{{ .Id }}_1, {{ mul (add .Position 1) 32 }}
br i1 %l{{ .Id }}_underflow_check, label %l{{ .Id }}_err_underflow, label %l{{ .Id }}_ok
l{{ .Id }}_err_underflow:
ret i32 -10
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_2 = alloca [32 x i8], align 16
%l{{ .Id }}_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_4 = getelementptr inbounds i8, i8* %l{{ .Id }}_3, i64 -32
%l{{ .Id }}_5 = shl nsw i32 {{ .Position }}, 5
%l{{ .Id }}_6 = sext i32 %l{{ .Id }}_5 to i64
%l{{ .Id }}_7 = sub nsw i64 0, %l{{ .Id }}_6
%l{{ .Id }}_8 = getelementptr inbounds i8, i8* %l{{ .Id }}_4, i64 %l{{ .Id }}_7
%l{{ .Id }}_9 = getelementptr inbounds [32 x i8], [32 x i8]* %l{{ .Id }}_2, i64 0, i64 0
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %l{{ .Id }}_9, i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_4, i64 32, i1 false)
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_4, i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_8, i64 32, i1 false)
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_8, i8* noundef nonnull align 16 dereferenceable(32) %l{{ .Id }}_9, i64 32, i1 false)
{{ end }}
