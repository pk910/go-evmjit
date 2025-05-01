{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): SIGNEXTEND{{- end }}
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
%l{{ .Id }}_bptr = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 -32
%l{{ .Id }}_xptr = getelementptr inbounds i8, i8* %l{{ .Id }}_bptr, i64 -32
%l{{ .Id }}_bptr2 = bitcast i8* %l{{ .Id }}_bptr to i256*
%l{{ .Id }}_xptr2 = bitcast i8* %l{{ .Id }}_xptr to i256*
%l{{ .Id }}_b_raw = load i256, i256* %l{{ .Id }}_bptr2
%l{{ .Id }}_x = load i256, i256* %l{{ .Id }}_xptr2
%l{{ .Id }}_b_ge_31 = icmp uge i256 %l{{ .Id }}_b_raw, 31
%l{{ .Id }}_b = select i1 %l{{ .Id }}_b_ge_31, i256 31, i256 %l{{ .Id }}_b_raw
%l{{ .Id }}_b_plus_1 = add i256 %l{{ .Id }}_b, 1
%l{{ .Id }}_num_bits = mul i256 %l{{ .Id }}_b_plus_1, 8
%l{{ .Id }}_shift_amount = sub i256 256, %l{{ .Id }}_num_bits
%l{{ .Id }}_x_shl = shl i256 %l{{ .Id }}_x, %l{{ .Id }}_shift_amount
%l{{ .Id }}_y_extended = ashr i256 %l{{ .Id }}_x_shl, %l{{ .Id }}_shift_amount
%l{{ .Id }}_final_result = select i1 %l{{ .Id }}_b_ge_31, i256 %l{{ .Id }}_x, i256 %l{{ .Id }}_y_extended
store i256 %l{{ .Id }}_final_result, i256* %l{{ .Id }}_xptr2
%l{{ .Id }}_sdv = add i64 %l{{ .Id }}_1, -32
store i64 %l{{ .Id }}_sdv, i64* %stack_position_ptr, align 8
{{ end }} 