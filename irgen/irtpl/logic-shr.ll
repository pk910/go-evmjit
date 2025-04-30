{{- define "defcode" }}
{{- end }}

{{- define "ircode" }}
{{ if .Verbose }}; OP {{ .Id }}: SHL{{- end }}
%l{{ .Id }}_1 = load i64, i64* %stack_position_ptr, align 8
{{- if .StackCheck }}
%l{{ .Id }}_stack_check = icmp ult i64 %l{{ .Id }}_1, 64
br i1 %l{{ .Id }}_stack_check, label %l{{ .Id }}_err1, label %l{{ .Id }}_ok_shl
l{{ .Id }}_err1:
  ret i32 -10
l{{ .Id }}_ok_shl:
{{- end }}
%l{{ .Id }}_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l{{ .Id }}_1
%l{{ .Id }}_shiftptr = getelementptr inbounds i8, i8* %l{{ .Id }}_2, i64 -32
%l{{ .Id }}_valptr = getelementptr inbounds i8, i8* %l{{ .Id }}_shiftptr, i64 -32
%l{{ .Id }}_shiftptr2 = bitcast i8* %l{{ .Id }}_shiftptr to i256*
%l{{ .Id }}_valptr2 = bitcast i8* %l{{ .Id }}_valptr to i256*
%l{{ .Id }}_shift = load i256, i256* %l{{ .Id }}_shiftptr2, align 1
%l{{ .Id }}_value = load i256, i256* %l{{ .Id }}_valptr2, align 1
%l{{ .Id }}_shift_check = icmp uge i256 %l{{ .Id }}_shift, 256
br i1 %l{{ .Id }}_shift_check, label %l{{ .Id }}_shift_large, label %l{{ .Id }}_shift_ok
l{{ .Id }}_shift_large:
  br label %l{{ .Id }}_store_res
l{{ .Id }}_shift_ok:
  %l{{ .Id }}_shifted_val = shr i256 %l{{ .Id }}_value, %l{{ .Id }}_shift
  br label %l{{ .Id }}_store_res
l{{ .Id }}_store_res:
%l{{ .Id }}_final_res = phi i256 [ 0, %l{{ .Id }}_shift_large ], [ %l{{ .Id }}_shifted_val, %l{{ .Id }}_shift_ok ]
store i256 %l{{ .Id }}_final_res, i256* %l{{ .Id }}_valptr2, align 1
%l{{ .Id }}_sdv = add i64 %l{{ .Id }}_1, -32
store i64 %l{{ .Id }}_sdv, i64* %stack_position_ptr, align 8
{{ end }} 