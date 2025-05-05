
%struct.evm_callctx = type { %struct.evm_stack*, i64, i64, i32 (i8*, i8, i8*, i16, i8*, i16, i64*)*, i8* }
%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare i128 @llvm.bswap.i128(i128)
declare i32 @llvm.ctlz.i256(i256, i1 immarg)
@const_zero32 = constant [32 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"


define i32 @test(%struct.evm_callctx* noundef %callctx) {
entry:
%zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
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
]
jump_invalid:
  store i32 -12, i32* %exitcode_ptr
  br label %error_return
post_jumptable:

; OP 0 (pc: 0): PUSH1 02
%l0_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l0_gas2 = icmp ult i64 %l0_gas1, 3
br i1 %l0_gas2, label %l0_gaserr, label %l0_gasok
l0_gaserr:
  store i64 0, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l0_gasok:
%l0_gas4 = add i64 %l0_gas1, -3
store i64 %l0_gas4, i64* %stack_gasleft_ptr, align 1

; OP 1 (pc: 2): PUSH1 04
%l1_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l1_gas2 = icmp ult i64 %l1_gas1, 3
br i1 %l1_gas2, label %l1_gaserr, label %l1_gasok
l1_gaserr:
  store i64 2, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l1_gasok:
%l1_gas4 = add i64 %l1_gas1, -3
store i64 %l1_gas4, i64* %stack_gasleft_ptr, align 1

%l0_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%l0_stack_out_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l0_stack_out_val

%l0_stack_out_bptr0 = getelementptr inbounds i8, i8* %l0_stack_out_ptr, i64 0
%l0_stack_out_iptr0 = bitcast i8* %l0_stack_out_bptr0 to i256*
store i256 2, i256* %l0_stack_out_iptr0, align 1
%l0_stack_out_bptr1 = getelementptr inbounds i8, i8* %l0_stack_out_ptr, i64 32
%l0_stack_out_iptr1 = bitcast i8* %l0_stack_out_bptr1 to i256*
store i256 4, i256* %l0_stack_out_iptr1, align 1
%l0_stack_out_val2 = add i64 %l0_stack_out_val, 64
store i64 %l0_stack_out_val2, i64* %stack_position_ptr, align 8

br label %br_4
br_4:
; OP 2 (pc: 4): JUMPDEST
%l2_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l2_gas2 = icmp ult i64 %l2_gas1, 1
br i1 %l2_gas2, label %l2_gaserr, label %l2_gasok
l2_gaserr:
  store i64 4, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l2_gasok:
%l2_gas4 = add i64 %l2_gas1, -1
store i64 %l2_gas4, i64* %stack_gasleft_ptr, align 1
; OP 3 (pc: 5): PUSH32 a9059cbb00000000000000000000000051a271009841ef452116efbbbef122d0
%l3_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l3_gas2 = icmp ult i64 %l3_gas1, 3
br i1 %l3_gas2, label %l3_gaserr, label %l3_gasok
l3_gaserr:
  store i64 5, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l3_gasok:
%l3_gas4 = add i64 %l3_gas1, -3
store i64 %l3_gas4, i64* %stack_gasleft_ptr, align 1

; OP 4 (pc: 38): PUSH1 06
%l4_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l4_gas2 = icmp ult i64 %l4_gas1, 3
br i1 %l4_gas2, label %l4_gaserr, label %l4_gasok
l4_gaserr:
  store i64 38, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l4_gasok:
%l4_gas4 = add i64 %l4_gas1, -3
store i64 %l4_gas4, i64* %stack_gasleft_ptr, align 1

; OP 5 (pc: 40): PUSH1 ff
%l5_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l5_gas2 = icmp ult i64 %l5_gas1, 3
br i1 %l5_gas2, label %l5_gaserr, label %l5_gasok
l5_gaserr:
  store i64 40, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l5_gasok:
%l5_gas4 = add i64 %l5_gas1, -3
store i64 %l5_gas4, i64* %stack_gasleft_ptr, align 1

; OP 6 (pc: 42): AND
%l6_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l6_gas2 = icmp ult i64 %l6_gas1, 3
br i1 %l6_gas2, label %l6_gaserr, label %l6_gasok
l6_gaserr:
  store i64 42, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l6_gasok:
%l6_gas4 = add i64 %l6_gas1, -3
store i64 %l6_gas4, i64* %stack_gasleft_ptr, align 1
%l6_res0 = and i256 255, 6

; OP 7 (pc: 43): SWAP3
%l7_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l7_gas2 = icmp ult i64 %l7_gas1, 3
br i1 %l7_gas2, label %l7_gaserr, label %l7_gasok
l7_gaserr:
  store i64 43, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l7_gasok:
%l7_gas4 = add i64 %l7_gas1, -3
store i64 %l7_gas4, i64* %stack_gasleft_ptr, align 1
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
%l8_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l8_gas2 = icmp ult i64 %l8_gas1, 3
br i1 %l8_gas2, label %l8_gaserr, label %l8_gasok
l8_gaserr:
  store i64 44, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l8_gasok:
%l8_gas4 = add i64 %l8_gas1, -3
store i64 %l8_gas4, i64* %stack_gasleft_ptr, align 1
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
%l9_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l9_gas2 = icmp ult i64 %l9_gas1, 3
br i1 %l9_gas2, label %l9_gaserr, label %l9_gasok
l9_gaserr:
  store i64 45, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l9_gasok:
%l9_gas4 = add i64 %l9_gas1, -3
store i64 %l9_gas4, i64* %stack_gasleft_ptr, align 1
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

%l4_stack_out_val = load i64, i64* %stack_position_ptr, align 8
%l4_stack_out_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l4_stack_out_val

%l4_stack_out_bptr0 = getelementptr inbounds i8, i8* %l4_stack_out_ptr, i64 0
%l4_stack_out_iptr0 = bitcast i8* %l4_stack_out_bptr0 to i256*
store i256 %l8_res0, i256* %l4_stack_out_iptr0, align 1
%l4_stack_out_bptr1 = getelementptr inbounds i8, i8* %l4_stack_out_ptr, i64 32
%l4_stack_out_iptr1 = bitcast i8* %l4_stack_out_bptr1 to i256*
store i256 %l9_res0, i256* %l4_stack_out_iptr1, align 1
%l4_stack_out_val2 = add i64 %l4_stack_out_val, 64
store i64 %l4_stack_out_val2, i64* %stack_position_ptr, align 8

br label %graceful_return
graceful_return:

%out_1 = load i64, i64* %heap_stack_position_ptr, align 8
%out_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %out_1
%out_3 = load i64, i64* %stack_position_ptr
%out_stack_check1 = icmp ult i64 %out_3, 128
br i1 %out_stack_check1, label %out_err1, label %out_ok1
out_err1:
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
out_ok1:
%out_stack_check2 = icmp ugt i64 %out_1, 8064
br i1 %out_stack_check2, label %out_err2, label %out_ok2
out_err2:
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
out_ok2:
%out_4 = sub i64 %out_3, 128
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
%out_l3_src_ptr = getelementptr i8, i8* %out_5, i64 96
%out_l3_dst_ptr = getelementptr i8, i8* %out_2, i64 96
%out_l3_src_ptr_lo = bitcast i8* %out_l3_src_ptr to i128*
%out_l3_src_ptr_hi = getelementptr i128, i128* %out_l3_src_ptr_lo, i32 1
%out_l3_dst_ptr_lo = bitcast i8* %out_l3_dst_ptr to i128*
%out_l3_dst_ptr_hi = getelementptr i128, i128* %out_l3_dst_ptr_lo, i32 1
%out_l3_word_lo = load i128, i128* %out_l3_src_ptr_lo
%out_l3_word_hi = load i128, i128* %out_l3_src_ptr_hi
%out_l3_reversed_lo = call i128 @llvm.bswap.i128(i128 %out_l3_word_hi)
%out_l3_reversed_hi = call i128 @llvm.bswap.i128(i128 %out_l3_word_lo)
store i128 %out_l3_reversed_lo, i128* %out_l3_dst_ptr_lo
store i128 %out_l3_reversed_hi, i128* %out_l3_dst_ptr_hi
%out_6 = add i64 %out_1, 128
store i64 %out_6, i64* %heap_stack_position_ptr, align 8
%out_7 = sub i64 %out_3, 128
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

