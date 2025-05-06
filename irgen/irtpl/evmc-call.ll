{{- define "defcode" }}
{{- end }}

{{- define "irhead" }}
{{ if .Verbose }}; OP {{ .Id }} (pc: {{ .Pc }}): {{ .Name }} (Generic Callback){{- end }}
{{- end }} 

{{- define "ircode" }}
{{- $id := .Id }}
{{- $buffer_size := max .Inputs .Outputs }}
{{- $stack_refs := .StackRefs }}

{{- if gt $buffer_size 0 }}
%l{{ $id }}_alloc = alloca [{{ $buffer_size }} x i256], align 32
%l{{ $id }}_alloc_ptr = bitcast [{{ $buffer_size }} x i256]* %l{{ $id }}_alloc to i256*
%l{{ $id }}_ptr = bitcast i256* %l{{ $id }}_alloc_ptr to i8*
{{- end }}

{{- /* input handling */}}
{{- if gt .Inputs 0 }}
{{- $maxinput := sub .Inputs 1 }}
{{- range $input := loop .Inputs }}
%l{{ $id }}_in_ptr{{ $input }} = getelementptr inbounds i256, i256* %l{{ $id }}_alloc_ptr, i64 {{ $input }}
store i256 {{ arrstr $stack_refs (sub $maxinput $input) }}, i256* %l{{ $id }}_in_ptr{{ $input }}
{{- end }}
{{- end }}

{{- /* function call */}}
store i64 {{ .Pc }}, i64* %pc_ptr
%l{{ $id }}_ret = call i32 %evmc_callback(
    i8* %callctx_as_i8,
    i8 {{ .Opcode }},
    i8* {{ if gt $buffer_size 0 }}%l{{ $id }}_ptr{{ else }}null{{ end }},
    i16 {{ mul .Inputs 32 }},
    i16 {{ mul .Outputs 32 }},
    i64* %stack_gasleft_ptr
)

{{- /* result handling */}}
%l{{ $id }}_ret_check = icmp ne i32 %l{{ $id }}_ret, 0
br i1 %l{{ $id }}_ret_check, label %l{{ $id }}_err_callback, label %l{{ $id }}_callback_ok
l{{ $id }}_err_callback:
  store i64 {{ .Pc }}, i64* %pc_ptr
  store i32 %l{{ $id }}_ret, i32* %exitcode_ptr
  br label %error_return
l{{ $id }}_callback_ok:

{{- /* output handling */}}
{{- if gt .Outputs 0 }}
{{- $maxoutput := sub .Outputs 1 }}
{{- range $output := loop .Outputs }}
%l{{ $id }}_out_ptr{{ $output }} = getelementptr inbounds i256, i256* %l{{ $id }}_alloc_ptr, i64 {{ $output }}
%l{{ $id }}_res{{ sub $maxoutput $output }} = load i256, i256* %l{{ $id }}_out_ptr{{ $output }}, align 1
{{- end }}
{{- end }}
{{ end }}
