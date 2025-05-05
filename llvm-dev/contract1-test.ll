
%struct.evm_callctx = type { %struct.evm_stack*, i64, i64, i32 (i8*, i8, i8*, i16, i8*, i16, i64*)*, i8* }
%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare i128 @llvm.bswap.i128(i128)
declare i32 @llvm.ctlz.i256(i256, i1 immarg)


define i32 @test(%struct.evm_callctx* noundef %callctx) {
entry:
%stack_alloc = alloca [32736 x i8], align 32
%stack_addr = getelementptr inbounds [32736 x i8], [32736 x i8]* %stack_alloc, i64 0, i64 0
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
  i64 4, label %br_4
  i64 46, label %br_46
]
jump_invalid:
  store i32 -12, i32* %exitcode_ptr
  br label %error_return
post_jumptable:

; OP 0 (pc: 0): PUSH1 02
; gas check 0 (total gas: 6)
%l0_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l0_gas2 = icmp ult i64 %l0_gas1, 6
br i1 %l0_gas2, label %l0_gaserr, label %l0_gasok
l0_gaserr:
  %lg0_cmp = icmp ult i64 %l0_gas1, 3
  %lg0_res = select i1 %lg0_cmp, i64 0, i64 0
  %lg1_cmp = icmp ult i64 %l0_gas1, 6
  %lg1_res = select i1 %lg1_cmp, i64 2, i64 %lg0_res
  store i64 %lg1_res, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l0_gasok:
%l0_gas4 = add i64 %l0_gas1, -6
store i64 %l0_gas4, i64* %stack_gasleft_ptr, align 1

; OP 1 (pc: 2): PUSH1 04

; stack store (2 words)
%lb0_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%lb0_stack_out_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %lb0_stack_out_val
%lb0_stack_out_bptr0 = getelementptr inbounds i8, i8* %lb0_stack_out_ptr, i64 0
%lb0_stack_out_iptr0 = bitcast i8* %lb0_stack_out_bptr0 to i256*
store i256 2, i256* %lb0_stack_out_iptr0, align 1
%lb0_stack_out_bptr1 = getelementptr inbounds i8, i8* %lb0_stack_out_ptr, i64 32
%lb0_stack_out_iptr1 = bitcast i8* %lb0_stack_out_bptr1 to i256*
store i256 4, i256* %lb0_stack_out_iptr1, align 1
%lb0_stack_out_val2 = add i64 %lb0_stack_out_val, 64
store i64 %lb0_stack_out_val2, i64* %stack_position_ptr, align 8
br label %br_4
br_4:
; OP 2 (pc: 4): JUMPDEST
; gas check 2 (total gas: 22)
%l2_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l2_gas2 = icmp ult i64 %l2_gas1, 22
br i1 %l2_gas2, label %l2_gaserr, label %l2_gasok
l2_gaserr:
  %lg2_cmp = icmp ult i64 %l2_gas1, 1
  %lg2_res = select i1 %lg2_cmp, i64 4, i64 0
  %lg3_cmp = icmp ult i64 %l2_gas1, 4
  %lg3_res = select i1 %lg3_cmp, i64 5, i64 %lg2_res
  %lg4_cmp = icmp ult i64 %l2_gas1, 7
  %lg4_res = select i1 %lg4_cmp, i64 38, i64 %lg3_res
  %lg5_cmp = icmp ult i64 %l2_gas1, 10
  %lg5_res = select i1 %lg5_cmp, i64 40, i64 %lg4_res
  %lg6_cmp = icmp ult i64 %l2_gas1, 13
  %lg6_res = select i1 %lg6_cmp, i64 42, i64 %lg5_res
  %lg7_cmp = icmp ult i64 %l2_gas1, 16
  %lg7_res = select i1 %lg7_cmp, i64 43, i64 %lg6_res
  %lg8_cmp = icmp ult i64 %l2_gas1, 19
  %lg8_res = select i1 %lg8_cmp, i64 44, i64 %lg7_res
  %lg9_cmp = icmp ult i64 %l2_gas1, 22
  %lg9_res = select i1 %lg9_cmp, i64 45, i64 %lg8_res
  store i64 %lg9_res, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l2_gasok:
%l2_gas4 = add i64 %l2_gas1, -22
store i64 %l2_gas4, i64* %stack_gasleft_ptr, align 1
; OP 3 (pc: 5): PUSH32 a9059cbb00000000000000000000000051a271009841ef452116efbbbef122d0

; OP 4 (pc: 38): PUSH1 06

; OP 5 (pc: 40): PUSH1 ff

; OP 6 (pc: 42): AND
%l6_res0 = and i256 255, 6

; OP 7 (pc: 43): SWAP3
%l7_1 = load i64, i64* %stack_position_ptr, align 8
%l7_underflow_check = icmp ult i64 %l7_1, 64
br i1 %l7_underflow_check, label %l7_err_underflow, label %l7_ok
l7_err_underflow:
  store i64 43, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l7_ok:
%l7_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l7_1
%l7_3 = getelementptr inbounds i8, i8* %l7_2, i64 -64
%l7_4 = bitcast i8* %l7_3 to i256*
%l7_res0 = load i256, i256* %l7_4, align 1
store i256 %l6_res0, i256* %l7_4, align 1

; OP 8 (pc: 44): SHR
%l8_shift_check = icmp uge i256 %l7_res0, 256
br i1 %l8_shift_check, label %l8_shift_large, label %l8_shift_ok
l8_shift_large:
  br label %l8_store_res
l8_shift_ok:
  %l8_shifted_val = lshr i256 76450787359836037641860180984291677750089429988765889766365144767127899677392, %l7_res0
  br label %l8_store_res
l8_store_res:
%l8_res0 = phi i256 [ 0, %l8_shift_large ], [ %l8_shifted_val, %l8_shift_ok ]

; OP 9 (pc: 45): DUP2
%l9_1 = load i64, i64* %stack_position_ptr, align 8
%l9_underflow_check = icmp ult i64 %l9_1, 32
br i1 %l9_underflow_check, label %l9_err_underflow, label %l9_ok
l9_err_underflow:
  store i64 45, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l9_ok:
%l9_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l9_1
%l9_3 = getelementptr inbounds i8, i8* %l9_2, i64 -32
%l9_4 = bitcast i8* %l9_3 to i256*
%l9_res0 = load i256, i256* %l9_4, align 1

; stack store (2 words)
%lb4_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%lb4_stack_out_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %lb4_stack_out_val
%lb4_stack_out_bptr0 = getelementptr inbounds i8, i8* %lb4_stack_out_ptr, i64 0
%lb4_stack_out_iptr0 = bitcast i8* %lb4_stack_out_bptr0 to i256*
store i256 %l8_res0, i256* %lb4_stack_out_iptr0, align 1
%lb4_stack_out_bptr1 = getelementptr inbounds i8, i8* %lb4_stack_out_ptr, i64 32
%lb4_stack_out_iptr1 = bitcast i8* %lb4_stack_out_bptr1 to i256*
store i256 %l9_res0, i256* %lb4_stack_out_iptr1, align 1
%lb4_stack_out_val2 = add i64 %lb4_stack_out_val, 64
store i64 %lb4_stack_out_val2, i64* %stack_position_ptr, align 8
br label %br_46
br_46:
; OP 10 (pc: 46): JUMPDEST
; gas check 10 (total gas: 4)
%l10_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l10_gas2 = icmp ult i64 %l10_gas1, 4
br i1 %l10_gas2, label %l10_gaserr, label %l10_gasok
l10_gaserr:
  %lg10_cmp = icmp ult i64 %l10_gas1, 1
  %lg10_res = select i1 %lg10_cmp, i64 46, i64 0
  %lg11_cmp = icmp ult i64 %l10_gas1, 4
  %lg11_res = select i1 %lg11_cmp, i64 47, i64 %lg10_res
  store i64 %lg11_res, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l10_gasok:
%l10_gas4 = add i64 %l10_gas1, -4
store i64 %l10_gas4, i64* %stack_gasleft_ptr, align 1
; OP 11 (pc: 47): PUSH1 01

; OP 12 (pc: 49): ADD
; gas check 12 (total gas: 25)
%l12_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l12_gas2 = icmp ult i64 %l12_gas1, 25
br i1 %l12_gas2, label %l12_gaserr, label %l12_gasok
l12_gaserr:
  %lg12_cmp = icmp ult i64 %l12_gas1, 3
  %lg12_res = select i1 %lg12_cmp, i64 49, i64 0
  %lg13_cmp = icmp ult i64 %l12_gas1, 6
  %lg13_res = select i1 %lg13_cmp, i64 50, i64 %lg12_res
  %lg14_cmp = icmp ult i64 %l12_gas1, 9
  %lg14_res = select i1 %lg14_cmp, i64 52, i64 %lg13_res
  %lg15_cmp = icmp ult i64 %l12_gas1, 12
  %lg15_res = select i1 %lg15_cmp, i64 53, i64 %lg14_res
  %lg16_cmp = icmp ult i64 %l12_gas1, 15
  %lg16_res = select i1 %lg16_cmp, i64 54, i64 %lg15_res
  %lg17_cmp = icmp ult i64 %l12_gas1, 25
  %lg17_res = select i1 %lg17_cmp, i64 56, i64 %lg16_res
  store i64 %lg17_res, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l12_gasok:
%l12_gas4 = add i64 %l12_gas1, -25
store i64 %l12_gas4, i64* %stack_gasleft_ptr, align 1
; stack load (1 words)
%l12_stack_in_val = load i64, i64* %stack_position_ptr, align 8
%l12_stack_in_check = icmp ult i64 %l12_stack_in_val, 32
br i1 %l12_stack_in_check, label %l12_stack_in_err1, label %l12_stack_in_ok
l12_stack_in_err1:
  store i64 49, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l12_stack_in_ok:
%l12_stack_in_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l12_stack_in_val
%l12_stack_in_bptr0 = getelementptr inbounds i8, i8* %l12_stack_in_ptr, i64 -32
%l12_stack_in_iptr0 = bitcast i8* %l12_stack_in_bptr0 to i256*
%l12_input0 = load i256, i256* %l12_stack_in_iptr0, align 1
%l12_stack_in_val2 = add i64 %l12_stack_in_val, -32
store i64 %l12_stack_in_val2, i64* %stack_position_ptr, align 8
%l12_res0 = add i256 1, %l12_input0

; OP 13 (pc: 50): PUSH1 32

; OP 14 (pc: 52): DUP2

; OP 15 (pc: 53): LT
%l15_cmp = icmp ult i256 %l12_res0, 50
%l15_res0 = select i1 %l15_cmp, i256 1, i256 0

; OP 16 (pc: 54): PUSH1 2e

; OP 17 (pc: 56): JUMP
%l17_cmp = icmp ne i256 %l15_res0, 0
br i1 %l17_cmp, label %l17_jump, label %l17_skip
l17_jump:
; stack store (1 words)
%l17_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%l17_stack_out_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l17_stack_out_val
%l17_stack_out_bptr0 = getelementptr inbounds i8, i8* %l17_stack_out_ptr, i64 0
%l17_stack_out_iptr0 = bitcast i8* %l17_stack_out_bptr0 to i256*
store i256 %l12_res0, i256* %l17_stack_out_iptr0, align 1
%l17_stack_out_val2 = add i64 %l17_stack_out_val, 32
store i64 %l17_stack_out_val2, i64* %stack_position_ptr, align 8
%l17_a_trunc = trunc i256 46 to i64
store i64 %l17_a_trunc, i64* %jump_target, align 1
store i64 56, i64* %pc_ptr
br label %jump_table
l17_skip:

; OP 18 (pc: 57): STOP
store i64 57, i64* %pc_ptr
br label %graceful_return

; stack store (1 words)
%lb46_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%lb46_stack_out_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %lb46_stack_out_val
%lb46_stack_out_bptr0 = getelementptr inbounds i8, i8* %lb46_stack_out_ptr, i64 0
%lb46_stack_out_iptr0 = bitcast i8* %lb46_stack_out_bptr0 to i256*
store i256 %l12_res0, i256* %lb46_stack_out_iptr0, align 1
%lb46_stack_out_val2 = add i64 %lb46_stack_out_val, 32
store i64 %lb46_stack_out_val2, i64* %stack_position_ptr, align 8
br label %graceful_return
graceful_return:

%out_1 = load i64, i64* %heap_stack_position_ptr, align 8
%out_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %out_1
%out_3 = load i64, i64* %stack_position_ptr
%out_stack_check1 = icmp ult i64 %out_3, 96
br i1 %out_stack_check1, label %out_err1, label %out_ok1
out_err1:
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
out_ok1:
%out_stack_check2 = icmp ugt i64 %out_1, 8096
br i1 %out_stack_check2, label %out_err2, label %out_ok2
out_err2:
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
out_ok2:
%out_4 = sub i64 %out_3, 96
%out_5 = getelementptr inbounds i8, i8* %stack_addr, i64 %out_4
%out_l0_src_ptr = getelementptr i8, i8* %out_5, i64 0
%out_l0_dst_ptr = getelementptr i8, i8* %out_2, i64 0
%out_l0_src_ptr_lo = bitcast i8* %out_l0_src_ptr to i128*
%out_l0_src_ptr_hi = getelementptr i128, i128* %out_l0_src_ptr_lo, i32 1
%out_l0_dst_ptr_lo = bitcast i8* %out_l0_dst_ptr to i128*
%out_l0_dst_ptr_hi = getelementptr i128, i128* %out_l0_dst_ptr_lo, i32 1
%out_l0_word_lo = load i128, i128* %out_l0_src_ptr_lo
%out_l0_word_hi = load i128, i128* %out_l0_src_ptr_hi
%out_l0_reversed_lo = call i128 @llvm.bswap.i128(i128 %out_l0_word_hi)
%out_l0_reversed_hi = call i128 @llvm.bswap.i128(i128 %out_l0_word_lo)
store i128 %out_l0_reversed_lo, i128* %out_l0_dst_ptr_lo
store i128 %out_l0_reversed_hi, i128* %out_l0_dst_ptr_hi
%out_l1_src_ptr = getelementptr i8, i8* %out_5, i64 32
%out_l1_dst_ptr = getelementptr i8, i8* %out_2, i64 32
%out_l1_src_ptr_lo = bitcast i8* %out_l1_src_ptr to i128*
%out_l1_src_ptr_hi = getelementptr i128, i128* %out_l1_src_ptr_lo, i32 1
%out_l1_dst_ptr_lo = bitcast i8* %out_l1_dst_ptr to i128*
%out_l1_dst_ptr_hi = getelementptr i128, i128* %out_l1_dst_ptr_lo, i32 1
%out_l1_word_lo = load i128, i128* %out_l1_src_ptr_lo
%out_l1_word_hi = load i128, i128* %out_l1_src_ptr_hi
%out_l1_reversed_lo = call i128 @llvm.bswap.i128(i128 %out_l1_word_hi)
%out_l1_reversed_hi = call i128 @llvm.bswap.i128(i128 %out_l1_word_lo)
store i128 %out_l1_reversed_lo, i128* %out_l1_dst_ptr_lo
store i128 %out_l1_reversed_hi, i128* %out_l1_dst_ptr_hi
%out_l2_src_ptr = getelementptr i8, i8* %out_5, i64 64
%out_l2_dst_ptr = getelementptr i8, i8* %out_2, i64 64
%out_l2_src_ptr_lo = bitcast i8* %out_l2_src_ptr to i128*
%out_l2_src_ptr_hi = getelementptr i128, i128* %out_l2_src_ptr_lo, i32 1
%out_l2_dst_ptr_lo = bitcast i8* %out_l2_dst_ptr to i128*
%out_l2_dst_ptr_hi = getelementptr i128, i128* %out_l2_dst_ptr_lo, i32 1
%out_l2_word_lo = load i128, i128* %out_l2_src_ptr_lo
%out_l2_word_hi = load i128, i128* %out_l2_src_ptr_hi
%out_l2_reversed_lo = call i128 @llvm.bswap.i128(i128 %out_l2_word_hi)
%out_l2_reversed_hi = call i128 @llvm.bswap.i128(i128 %out_l2_word_lo)
store i128 %out_l2_reversed_lo, i128* %out_l2_dst_ptr_lo
store i128 %out_l2_reversed_hi, i128* %out_l2_dst_ptr_hi
%out_6 = add i64 %out_1, 96
store i64 %out_6, i64* %heap_stack_position_ptr, align 8
%out_7 = sub i64 %out_3, 96
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

