
{{- define "stack-load" }}
{{ if .Verbose }}; stack load ({{ .Count }} words){{- end }}
%l{{ .Id }}_stack_in_val = load i64, i64* %stack_position_ptr, align 8
%l{{ .Id }}_stack_in_ptr = getelementptr inbounds i256, i256* %stack_addr, i64 %l{{ .Id }}_stack_in_val
{{- $id := .Id }}
{{- range $index := loop .Count }}
%l{{ $id }}_stack_in_iptr{{ $index }} = getelementptr inbounds i256, i256* %l{{ $id }}_stack_in_ptr, i64 -{{ add $index 1 }}
%l{{ $id }}_input{{ $index }} = load i256, i256* %l{{ $id }}_stack_in_iptr{{ $index }}, align 1
{{- end }}
%l{{ .Id }}_stack_in_val2 = add i64 %l{{ .Id }}_stack_in_val, -{{ .Count }}
store i64 %l{{ .Id }}_stack_in_val2, i64* %stack_position_ptr, align 8
{{- end }}

{{- define "stack-store" }}
{{ if .Verbose }}; stack store ({{ len .Refs }} words){{- end }}
%l{{ .Id }}_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%l{{ .Id }}_stack_out_ptr = getelementptr inbounds i256, i256* %stack_addr, i64 %l{{ .Id }}_stack_out_val
{{- $id := .Id }}
{{- range $ref := .Refs }}
%l{{ $id }}_stack_out_iptr{{ $ref.Index }} = getelementptr inbounds i256, i256* %l{{ $id }}_stack_out_ptr, i64 {{ $ref.Index }}
store i256 {{ $ref.Ref }}, i256* %l{{ $id }}_stack_out_iptr{{ $ref.Index }}, align 1
{{- end }}
%l{{ .Id }}_stack_out_val2 = add i64 %l{{ .Id }}_stack_out_val, {{ .Count }}
store i64 %l{{ .Id }}_stack_out_val2, i64* %stack_position_ptr, align 8
{{- end }}

{{- define "op-checks" }}
{{ if .Verbose }}; op checks {{ .Id }} (total gas: {{ .Gas }}, stack-in: {{ .MinStack }}, stack-out: {{ .MaxStack }}){{- end }}
{{- if gt .Gas 0 }}
%l{{ .Id }}_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l{{ .Id }}_gas2 = icmp ult i64 %l{{ .Id }}_gas1, {{ .Gas }}
br i1 %l{{ .Id }}_gas2, label %l{{ .Id }}_checkerr, label %l{{ .Id }}_gasok
l{{ .Id }}_gasok:
{{- end }}
{{- if gt (add .MinStack .MaxStack) 0 }}
%l{{ .Id }}_stack_val = load i64, i64* %stack_position_ptr, align 8
{{- end }}
{{- if gt .MinStack 0 }}
%l{{ .Id }}_stack_in_check = icmp ult i64 %l{{ .Id }}_stack_val, {{ .MinStack }}
br i1 %l{{ .Id }}_stack_in_check, label %l{{ .Id }}_checkerr, label %l{{ .Id }}_stack_in_ok
l{{ .Id }}_stack_in_ok:
{{- end }}
{{- if gt .MaxStack 0 }}
%l{{ .Id }}_stack_out_check = icmp ugt i64 %l{{ .Id }}_stack_val, {{ sub .StackSize .MaxStack }}
br i1 %l{{ .Id }}_stack_out_check, label %l{{ .Id }}_checkerr, label %l{{ .Id }}_stack_out_ok
l{{ .Id }}_stack_out_ok:
{{- end }}
br label %l{{ .Id }}_checkok
l{{ .Id }}_checkerr:
{{- $id := .Id }}
{{- $stackSize := .StackSize }}
{{- range $chk := .Checks }}
{{- if gt $chk.MinGas 0 }}
  %lg{{ $chk.Id }}_cmp1 = icmp ult i64 %l{{ $id }}_gas1, {{ $chk.MinGas }}
  br i1 %lg{{ $chk.Id }}_cmp1, label %lg{{ $chk.Id }}_gaserr, label %lg{{ $chk.Id }}_gasok
lg{{ $chk.Id }}_gasok:
{{- end }}
{{- if gt $chk.MinStack 0 }}
  %lg{{ $chk.Id }}_cmp2 = icmp ult i64 %l{{ $id }}_stack_val, {{ $chk.MinStack }}
  br i1 %lg{{ $chk.Id }}_cmp2, label %lg{{ $chk.Id }}_minstackerr, label %lg{{ $chk.Id }}_minstackok
lg{{ $chk.Id }}_minstackok:
{{- end }}
{{- if gt $chk.MaxStack 0 }}
  %lg{{ $chk.Id }}_cmp3 = icmp ugt i64 %l{{ $id }}_stack_val, {{ sub $stackSize $chk.MaxStack }}
  br i1 %lg{{ $chk.Id }}_cmp3, label %lg{{ $chk.Id }}_maxstackerr, label %lg{{ $chk.Id }}_maxstackok
lg{{ $chk.Id }}_maxstackok:
{{- end }}
{{- end }}
  br label %l{{ .Id }}_checkok
{{- range $chk := .Checks }}
{{- if gt $chk.MinGas 0 }}
lg{{ $chk.Id }}_gaserr:
  store i64 {{ $chk.Pc }}, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
{{- end }}
{{- if gt $chk.MinStack 0 }}
lg{{ $chk.Id }}_minstackerr:
  store i64 {{ $chk.Pc }}, i64* %pc_ptr
{{- if gt $chk.MinGas 0 }}
  %lg{{ $chk.Id }}_gasres1 = add i64 %l{{ $id }}_gas1, -{{ $chk.MinGas }}
  store i64 %lg{{ $chk.Id }}_gasres1, i64* %stack_gasleft_ptr, align 1
{{- end }}
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
{{- end }}
{{- if gt $chk.MaxStack 0 }}
lg{{ $chk.Id }}_maxstackerr:
  store i64 {{ $chk.Pc }}, i64* %pc_ptr
{{- if gt $chk.MinGas 0 }}
  %lg{{ $chk.Id }}_gasres2 = add i64 %l{{ $id }}_gas1, -{{ $chk.MinGas }}
  store i64 %lg{{ $chk.Id }}_gasres2, i64* %stack_gasleft_ptr, align 1
{{- end }}
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
{{- end }}
{{- end }}
l{{ .Id }}_checkok:
{{- if gt .Gas 0 }}
%l{{ .Id }}_gas4 = add i64 %l{{ .Id }}_gas1, -{{ .Gas }}
store i64 %l{{ .Id }}_gas4, i64* %stack_gasleft_ptr, align 1
{{- end }}
{{- end }}
