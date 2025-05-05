
%struct.evm_callctx = type { %struct.evm_stack*, i64, i64, i32 (i8*, i8, i8*, i16, i16, i64*)*, i8* }
%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare i128 @llvm.bswap.i128(i128)
declare i32 @llvm.ctlz.i256(i256, i1 immarg)


define i32 @test(%struct.evm_callctx* noundef %callctx) {
entry:
%stack_alloc = alloca [1023 x i256], align 32
%stack_addr = getelementptr inbounds [1023 x i256], [1023 x i256]* %stack_alloc, i64 0, i64 0
%stack_position_ptr = alloca i64, align 4
%stack_gasleft_ptr = alloca i64, align 4
%exitcode_ptr = alloca i32, align 4
store i64 0, i64* %stack_position_ptr

%callctx_ptr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 0
%pc_ptr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 1
%gasleft_ptr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 2
%gasleft_val = load i64, i64* %gasleft_ptr, align 4
store i64 %gasleft_val, i64* %stack_gasleft_ptr


%heap_stack = load %struct.evm_stack*, %struct.evm_stack** %callctx_ptr, align 8
%heap_stack_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %heap_stack, i32 0, i32 0
%heap_stack_addr = load i8*, i8** %heap_stack_ptr, align 8
%heap_stack_position_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %heap_stack, i32 0, i32 1

%jump_target = alloca i64, align 4
br label %post_jumptable
jump_table:
%jump_target_val = load i64, i64* %jump_target, align 8
switch i64 %jump_target_val, label %jump_invalid [
  i64 5, label %br_5
]
jump_invalid:
  store i32 -12, i32* %exitcode_ptr
  br label %error_return
post_jumptable:

; OP 0 (pc: 0): PUSH2 eeaa
; op checks 0 (total gas: 6, stack-in: 0, stack-out: 2)
%l0_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l0_gas2 = icmp ult i64 %l0_gas1, 6
br i1 %l0_gas2, label %l0_checkerr, label %l0_gasok
l0_gasok:
%l0_stack_val = load i64, i64* %stack_position_ptr, align 8
%l0_stack_out_check = icmp ugt i64 %l0_stack_val, 1021
br i1 %l0_stack_out_check, label %l0_checkerr, label %l0_stack_out_ok
l0_stack_out_ok:
br label %l0_checkok
l0_checkerr:
  %lg0_cmp1 = icmp ult i64 %l0_gas1, 3
  br i1 %lg0_cmp1, label %lg0_gaserr, label %lg0_gasok
lg0_gasok:
  %lg0_cmp3 = icmp ugt i64 %l0_stack_val, 1022
  br i1 %lg0_cmp3, label %lg0_maxstackerr, label %lg0_maxstackok
lg0_maxstackok:
  %lg3_cmp1 = icmp ult i64 %l0_gas1, 6
  br i1 %lg3_cmp1, label %lg3_gaserr, label %lg3_gasok
lg3_gasok:
  %lg3_cmp3 = icmp ugt i64 %l0_stack_val, 1021
  br i1 %lg3_cmp3, label %lg3_maxstackerr, label %lg3_maxstackok
lg3_maxstackok:
  br label %l0_checkok
lg0_gaserr:
  store i64 0, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg0_maxstackerr:
  store i64 0, i64* %pc_ptr
  %lg0_gasres = add i64 %l0_gas1, -3
  store i64 %lg0_gasres, i64* %stack_gasleft_ptr, align 1
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
lg3_gaserr:
  store i64 3, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg3_maxstackerr:
  store i64 3, i64* %pc_ptr
  %lg3_gasres = add i64 %l0_gas1, -6
  store i64 %lg3_gasres, i64* %stack_gasleft_ptr, align 1
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l0_checkok:
%l0_gas4 = add i64 %l0_gas1, -6
store i64 %l0_gas4, i64* %stack_gasleft_ptr, align 1

; OP 1 (pc: 3): PUSH1 02

; stack store (2 words)
%lb0_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%lb0_stack_out_ptr = getelementptr inbounds i256, i256* %stack_addr, i64 %lb0_stack_out_val
%lb0_stack_out_iptr0 = getelementptr inbounds i256, i256* %lb0_stack_out_ptr, i64 0
store i256 61098, i256* %lb0_stack_out_iptr0, align 1
%lb0_stack_out_iptr1 = getelementptr inbounds i256, i256* %lb0_stack_out_ptr, i64 1
store i256 2, i256* %lb0_stack_out_iptr1, align 1
%lb0_stack_out_val2 = add i64 %lb0_stack_out_val, 2
store i64 %lb0_stack_out_val2, i64* %stack_position_ptr, align 8
br label %br_5
br_5:
; OP 2 (pc: 5): JUMPDEST
; op checks 2 (total gas: 34, stack-in: 1, stack-out: 2)
%l2_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l2_gas2 = icmp ult i64 %l2_gas1, 34
br i1 %l2_gas2, label %l2_checkerr, label %l2_gasok
l2_gasok:
%l2_stack_val = load i64, i64* %stack_position_ptr, align 8
%l2_stack_in_check = icmp ult i64 %l2_stack_val, 1
br i1 %l2_stack_in_check, label %l2_checkerr, label %l2_stack_in_ok
l2_stack_in_ok:
%l2_stack_out_check = icmp ugt i64 %l2_stack_val, 1021
br i1 %l2_stack_out_check, label %l2_checkerr, label %l2_stack_out_ok
l2_stack_out_ok:
br label %l2_checkok
l2_checkerr:
  %lg5_cmp1 = icmp ult i64 %l2_gas1, 1
  br i1 %lg5_cmp1, label %lg5_gaserr, label %lg5_gasok
lg5_gasok:
  %lg6_cmp1 = icmp ult i64 %l2_gas1, 4
  br i1 %lg6_cmp1, label %lg6_gaserr, label %lg6_gasok
lg6_gasok:
  %lg6_cmp3 = icmp ugt i64 %l2_stack_val, 1022
  br i1 %lg6_cmp3, label %lg6_maxstackerr, label %lg6_maxstackok
lg6_maxstackok:
  %lg7_cmp1 = icmp ult i64 %l2_gas1, 6
  br i1 %lg7_cmp1, label %lg7_gaserr, label %lg7_gasok
lg7_gasok:
  %lg8_cmp1 = icmp ult i64 %l2_gas1, 9
  br i1 %lg8_cmp1, label %lg8_gaserr, label %lg8_gasok
lg8_gasok:
  %lg10_cmp1 = icmp ult i64 %l2_gas1, 12
  br i1 %lg10_cmp1, label %lg10_gaserr, label %lg10_gasok
lg10_gasok:
  %lg10_cmp2 = icmp ult i64 %l2_stack_val, 1
  br i1 %lg10_cmp2, label %lg10_minstackerr, label %lg10_minstackok
lg10_minstackok:
  %lg11_cmp1 = icmp ult i64 %l2_gas1, 15
  br i1 %lg11_cmp1, label %lg11_gaserr, label %lg11_gasok
lg11_gasok:
  %lg13_cmp1 = icmp ult i64 %l2_gas1, 18
  br i1 %lg13_cmp1, label %lg13_gaserr, label %lg13_gasok
lg13_gasok:
  %lg13_cmp3 = icmp ugt i64 %l2_stack_val, 1021
  br i1 %lg13_cmp3, label %lg13_maxstackerr, label %lg13_maxstackok
lg13_maxstackok:
  %lg14_cmp1 = icmp ult i64 %l2_gas1, 21
  br i1 %lg14_cmp1, label %lg14_gaserr, label %lg14_gasok
lg14_gasok:
  %lg15_cmp1 = icmp ult i64 %l2_gas1, 24
  br i1 %lg15_cmp1, label %lg15_gaserr, label %lg15_gasok
lg15_gasok:
  %lg17_cmp1 = icmp ult i64 %l2_gas1, 34
  br i1 %lg17_cmp1, label %lg17_gaserr, label %lg17_gasok
lg17_gasok:
  br label %l2_checkok
lg5_gaserr:
  store i64 5, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg6_gaserr:
  store i64 6, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg6_maxstackerr:
  store i64 6, i64* %pc_ptr
  %lg6_gasres = add i64 %l2_gas1, -4
  store i64 %lg6_gasres, i64* %stack_gasleft_ptr, align 1
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
lg7_gaserr:
  store i64 7, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg8_gaserr:
  store i64 8, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg10_gaserr:
  store i64 10, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg10_minstackerr:
  store i64 10, i64* %pc_ptr
  %lg10_gasres = add i64 %l2_gas1, -12
  store i64 %lg10_gasres, i64* %stack_gasleft_ptr, align 1
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
lg11_gaserr:
  store i64 11, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg13_gaserr:
  store i64 13, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg13_maxstackerr:
  store i64 13, i64* %pc_ptr
  %lg13_gasres = add i64 %l2_gas1, -18
  store i64 %lg13_gasres, i64* %stack_gasleft_ptr, align 1
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
lg14_gaserr:
  store i64 14, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg15_gaserr:
  store i64 15, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg17_gaserr:
  store i64 17, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l2_checkok:
%l2_gas4 = add i64 %l2_gas1, -34
store i64 %l2_gas4, i64* %stack_gasleft_ptr, align 1
; OP 3 (pc: 6): DUP1
%l3_1 = load i64, i64* %stack_position_ptr, align 8
%l3_underflow_check = icmp ult i64 %l3_1, 1
br i1 %l3_underflow_check, label %l3_err_underflow, label %l3_ok
l3_err_underflow:
  store i64 6, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l3_ok:
%l3_2 = getelementptr inbounds i256, i256* %stack_addr, i64 %l3_1
%l3_3 = getelementptr inbounds i256, i256* %l3_2, i64 -1
%l3_res0 = load i256, i256* %l3_3, align 1

; OP 4 (pc: 7): POP

; OP 5 (pc: 8): PUSH1 01

; OP 6 (pc: 10): ADD
; stack load (1 words)
%l6_stack_in_val = load i64, i64* %stack_position_ptr, align 8
%l6_stack_in_ptr = getelementptr inbounds i256, i256* %stack_addr, i64 %l6_stack_in_val
%l6_stack_in_iptr0 = getelementptr inbounds i256, i256* %l6_stack_in_ptr, i64 -1
%l6_input0 = load i256, i256* %l6_stack_in_iptr0, align 1
%l6_stack_in_val2 = add i64 %l6_stack_in_val, -1
store i64 %l6_stack_in_val2, i64* %stack_position_ptr, align 8
%l6_res0 = add i256 1, %l6_input0

; OP 7 (pc: 11): PUSH1 32

; OP 8 (pc: 13): DUP2

; OP 9 (pc: 14): LT
%l9_cmp = icmp ult i256 %l6_res0, 50
%l9_res0 = select i1 %l9_cmp, i256 1, i256 0

; OP 10 (pc: 15): PUSH1 05

; OP 11 (pc: 17): JUMP
%l11_cmp = icmp ne i256 %l9_res0, 0
br i1 %l11_cmp, label %l11_jump, label %l11_skip
l11_jump:
; stack store (1 words)
%l11_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%l11_stack_out_ptr = getelementptr inbounds i256, i256* %stack_addr, i64 %l11_stack_out_val
%l11_stack_out_iptr0 = getelementptr inbounds i256, i256* %l11_stack_out_ptr, i64 0
store i256 %l6_res0, i256* %l11_stack_out_iptr0, align 1
%l11_stack_out_val2 = add i64 %l11_stack_out_val, 1
store i64 %l11_stack_out_val2, i64* %stack_position_ptr, align 8
%l11_a_trunc = trunc i256 5 to i64
store i64 %l11_a_trunc, i64* %jump_target, align 1
store i64 17, i64* %pc_ptr
br label %jump_table
l11_skip:

; OP 12 (pc: 18): PUSH1 50
; op checks 12 (total gas: 8, stack-in: 1, stack-out: 0)
%l12_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l12_gas2 = icmp ult i64 %l12_gas1, 8
br i1 %l12_gas2, label %l12_checkerr, label %l12_gasok
l12_gasok:
%l12_stack_val = load i64, i64* %stack_position_ptr, align 8
%l12_stack_in_check = icmp ult i64 %l12_stack_val, 1
br i1 %l12_stack_in_check, label %l12_checkerr, label %l12_stack_in_ok
l12_stack_in_ok:
br label %l12_checkok
l12_checkerr:
  %lg18_cmp1 = icmp ult i64 %l12_gas1, 3
  br i1 %lg18_cmp1, label %lg18_gaserr, label %lg18_gasok
lg18_gasok:
  %lg20_cmp1 = icmp ult i64 %l12_gas1, 8
  br i1 %lg20_cmp1, label %lg20_gaserr, label %lg20_gasok
lg20_gasok:
  %lg20_cmp2 = icmp ult i64 %l12_stack_val, 1
  br i1 %lg20_cmp2, label %lg20_minstackerr, label %lg20_minstackok
lg20_minstackok:
  br label %l12_checkok
lg18_gaserr:
  store i64 18, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg20_gaserr:
  store i64 20, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
lg20_minstackerr:
  store i64 20, i64* %pc_ptr
  %lg20_gasres = add i64 %l12_gas1, -8
  store i64 %lg20_gasres, i64* %stack_gasleft_ptr, align 1
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l12_checkok:
%l12_gas4 = add i64 %l12_gas1, -8
store i64 %l12_gas4, i64* %stack_gasleft_ptr, align 1

; OP 13 (pc: 20): c10 (Generic Callback)
; stack load (1 words)
%l13_stack_in_val = load i64, i64* %stack_position_ptr, align 8
%l13_stack_in_ptr = getelementptr inbounds i256, i256* %stack_addr, i64 %l13_stack_in_val
%l13_stack_in_iptr0 = getelementptr inbounds i256, i256* %l13_stack_in_ptr, i64 -1
%l13_input0 = load i256, i256* %l13_stack_in_iptr0, align 1
%l13_stack_in_val2 = add i64 %l13_stack_in_val, -1
store i64 %l13_stack_in_val2, i64* %stack_position_ptr, align 8
%l13_alloc = alloca [3 x i256], align 32
%l13_alloc_ptr = bitcast [3 x i256]* %l13_alloc to i256*
%l13_ptr = bitcast i256* %l13_alloc_ptr to i8*
%l13_in_ptr0 = getelementptr inbounds i256, i256* %l13_alloc_ptr, i64 0
store i256 80, i256* %l13_in_ptr0
%l13_in_ptr1 = getelementptr inbounds i256, i256* %l13_alloc_ptr, i64 1
store i256 %l6_res0, i256* %l13_in_ptr1
%l13_in_ptr2 = getelementptr inbounds i256, i256* %l13_alloc_ptr, i64 2
store i256 %l13_input0, i256* %l13_in_ptr2
store i64 20, i64* %pc_ptr
%l13_fn_ptr_addr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 3
%l13_fn_ptr = load i32 (i8*, i8, i8*, i16, i16, i64*)*, i32 (i8*, i8, i8*, i16, i16, i64*)** %l13_fn_ptr_addr, align 8
%l13_ctx_as_i8 = bitcast %struct.evm_callctx* %callctx to i8*
%l13_ret = call i32 %l13_fn_ptr(
    i8* %l13_ctx_as_i8,
    i8 10,
    i8* %l13_ptr,
    i16 96,
    i16 32,
    i64* %stack_gasleft_ptr
)
%l13_ret_check = icmp ne i32 %l13_ret, 0
br i1 %l13_ret_check, label %l13_err_callback, label %l13_callback_ok
l13_err_callback:
  store i64 20, i64* %pc_ptr
  store i32 %l13_ret, i32* %exitcode_ptr
  br label %error_return
l13_callback_ok:
%l13_out_ptr0 = getelementptr inbounds i256, i256* %l13_alloc_ptr, i64 0
%l13_res0 = load i256, i256* %l13_out_ptr0, align 1

; stack store (1 words)
%lb5_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%lb5_stack_out_ptr = getelementptr inbounds i256, i256* %stack_addr, i64 %lb5_stack_out_val
%lb5_stack_out_iptr0 = getelementptr inbounds i256, i256* %lb5_stack_out_ptr, i64 0
store i256 %l13_res0, i256* %lb5_stack_out_iptr0, align 1
%lb5_stack_out_val2 = add i64 %lb5_stack_out_val, 1
store i64 %lb5_stack_out_val2, i64* %stack_position_ptr, align 8
br label %graceful_return
graceful_return:

%out_1 = load i64, i64* %heap_stack_position_ptr, align 8
%out_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %out_1
%out_3 = load i64, i64* %stack_position_ptr
%out_stack_check1 = icmp ult i64 %out_3, 1
br i1 %out_stack_check1, label %out_err1, label %out_ok1
out_err1:
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
out_ok1:
%out_stack_check2 = icmp ugt i64 %out_1, 8160
br i1 %out_stack_check2, label %out_err2, label %out_ok2
out_err2:
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
out_ok2:
%out_4 = sub i64 %out_3, 1
%out_5 = getelementptr inbounds i256, i256* %stack_addr, i64 %out_4
%out_l0_src_ptr = getelementptr i256, i256* %out_5, i64 0
%out_l0_dst_ptr = getelementptr i8, i8* %out_2, i64 0
%out_l0_src_ptr_lo = bitcast i256* %out_l0_src_ptr to i128*
%out_l0_src_ptr_hi = getelementptr i128, i128* %out_l0_src_ptr_lo, i32 1
%out_l0_dst_ptr_lo = bitcast i8* %out_l0_dst_ptr to i128*
%out_l0_dst_ptr_hi = getelementptr i128, i128* %out_l0_dst_ptr_lo, i32 1
%out_l0_word_lo = load i128, i128* %out_l0_src_ptr_lo
%out_l0_word_hi = load i128, i128* %out_l0_src_ptr_hi
%out_l0_reversed_lo = call i128 @llvm.bswap.i128(i128 %out_l0_word_hi)
%out_l0_reversed_hi = call i128 @llvm.bswap.i128(i128 %out_l0_word_lo)
store i128 %out_l0_reversed_lo, i128* %out_l0_dst_ptr_lo
store i128 %out_l0_reversed_hi, i128* %out_l0_dst_ptr_hi
%out_6 = add i64 %out_1, 32
store i64 %out_6, i64* %heap_stack_position_ptr, align 8
%out_7 = sub i64 %out_3, 1
store i64 %out_7, i64* %stack_position_ptr, align 8
%res_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
store i64 %res_gas1, i64* %gasleft_ptr
ret i32 0
error_return:
%exitcode_val = load i32, i32* %exitcode_ptr, align 4
%err_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
store i64 %err_gas1, i64* %gasleft_ptr
ret i32 %exitcode_val
}

