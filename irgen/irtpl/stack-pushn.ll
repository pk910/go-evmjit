{{- define "defcode" }}
{{- if gt .DataLen 0 }}
@const_data{{ .Id }} = constant [{{ .DataLen }} x i8] c"{{ llhex .Data }}"
{{- end }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: PUSH{{ .DataLen }} {{ hex .Data }}{{- end }}
%l{{ .Id }}_2 = load i64, i64* %stack_position_ptr, align 8
%l{{ .Id }}_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_2
{{- if lt .DataLen 32 }}
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_3, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 {{ sub 32 .DataLen }}, i1 false)
{{- end }}
{{- if gt .DataLen 0 }}
%l{{ .Id }}_4 = bitcast [{{ .DataLen }} x i8]* @const_data{{ .Id }} to i8*
{{- end }}
{{- if eq .DataLen 32 }}
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_3, i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_4, i64 32, i1 false)
{{- else if gt .DataLen 0 }}
%l{{ .Id }}_5 = getelementptr i8, i8* %l{{ .Id }}_3, i32 {{ sub 32 .DataLen }}
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_5, i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_4, i64 {{ .DataLen }}, i1 false)
{{- end }}
%l{{ .Id }}_6 = add i64 %l{{ .Id }}_2, 32
store i64 %l{{ .Id }}_6, i64* %stack_position_ptr, align 8
{{ end }}

