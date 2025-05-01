{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): BYTE{{- end }}
{{- end }} 

{{- define "ircode" }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_stack_check = icmp ult i64 %l{{ .Id }}_1, 64
br i1 %l{{ .Id }}_stack_check, label %l{{ .Id }}_err1, label %l{{ .Id }}_ok_byte
l{{ .Id }}_err1:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l{{ .Id }}_ok_byte:
{{- end }}
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_iptr = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 -32
%l{{ .Id }}_xptr = getelementptr inbounds i8, i8* %l{{ .Id }}_iptr, i64 -32
%l{{ .Id }}_iptr2 = bitcast i8* %l{{ .Id }}_iptr to i256*
%l{{ .Id }}_xptr2 = bitcast i8* %l{{ .Id }}_xptr to i256*
%l{{ .Id }}_i = load i256, i256* %l{{ .Id }}_iptr2, align 1
%l{{ .Id }}_x = load i256, i256* %l{{ .Id }}_xptr2, align 1
%l{{ .Id }}_index_check = icmp uge i256 %l{{ .Id }}_i, 32
br i1 %l{{ .Id }}_index_check, label %l{{ .Id }}_index_out, label %l{{ .Id }}_index_in
l{{ .Id }}_index_out:
  br label %l{{ .Id }}_store_res
l{{ .Id }}_index_in:
  %l{{ .Id }}_le_byte_index = sub i256 31, %l{{ .Id }}_i
  %l{{ .Id }}_shift_amount = mul i256 %l{{ .Id }}_le_byte_index, 8
  %l{{ .Id }}_shifted_x = lshr i256 %l{{ .Id }}_x, %l{{ .Id }}_shift_amount
  %l{{ .Id }}_masked_res = and i256 %l{{ .Id }}_shifted_x, 255
  br label %l{{ .Id }}_store_res
l{{ .Id }}_store_res:
%l{{ .Id }}_final_res = phi i256 [ 0, %l{{ .Id }}_index_out ], [ %l{{ .Id }}_masked_res, %l{{ .Id }}_index_in ]
store i256 %l{{ .Id }}_final_res, i256* %l{{ .Id }}_xptr2, align 1
%l{{ .Id }}_sdv = add i64 %l{{ .Id }}_1, -32
store i64 %l{{ .Id }}_sdv, i64* %stack_position_ptr, align 8
{{ end }} 