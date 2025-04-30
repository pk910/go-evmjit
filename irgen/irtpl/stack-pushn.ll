{{- define "defcode" }}
{{- if gt .DataLen 0 }}
@const_data{{ .Id }} = constant [{{ .DataLen }} x i8] c"{{ llhexrev .Data }}"
{{- end }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: PUSH{{ .DataLen }} {{ hex .Data }}{{- end }}
%l{{ .Id }}_2 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_overflow_check = icmp ugt i64 %l{{ .Id }}_2, {{ sub (mul .MaxStack 32) 32 }}
br i1 %l{{ .Id }}_overflow_check, label %l{{ .Id }}_err_overflow, label %l{{ .Id }}_ok
l{{ .Id }}_err_overflow:
  ret i32 -11
l{{ .Id }}_ok:
{{- end }}
%l{{ .Id }}_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_2
{{- if gt .DataLen 0 }}
%l{{ .Id }}_4 = bitcast [{{ .DataLen }} x i8]* @const_data{{ .Id }} to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_3, i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_4, i64 {{ .DataLen }}, i1 false)
{{- end }}
{{- if lt .DataLen 32 }}
{{- /* add 0 padding for push < 32 */}}
%l{{ .Id }}_5 = getelementptr i8, i8* %l{{ .Id }}_3, i32 {{ .DataLen }}
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l{{ .Id }}_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 {{ sub 32 .DataLen }}, i1 false)
{{- end }}
%l{{ .Id }}_6 = add i64 %l{{ .Id }}_2, 32
store i64 %l{{ .Id }}_6, i64* %stack_position_ptr, align 8
{{ end }}

