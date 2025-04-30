
{{- define "ircode" }}
%jump_target = alloca i64, align 4
br label %post_jumptable
jump_table:
{{- if .HasBranches }}
%jump_target_val = load i64, i64* %jump_target, align 8
switch i64 %jump_target_val, label %jump_invalid [
{{- range $pc := .Branches }}
  i64 {{ $pc }}, label %br_{{ $pc }}
{{- end }}
]
jump_invalid:
{{- end }}
  store i32 -12, i32* %exitcode_ptr
  br label %error_return
post_jumptable:
{{ end }}
