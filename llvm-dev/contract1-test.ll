%struct.evm_callctx = type { %struct.evm_stack*, i64, i64, i32 (i8*, i8, i8*, i16, i8*, i16)*, i8* }
%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare i128 @llvm.bswap.i128(i128)
@const_zero32 = constant [32 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"

@const_data0 = constant [32 x i8] c"\01\02\05\04\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\16\14\21"
@const_data1 = constant [1 x i8] c"\02"
@const_data2 = constant [8 x i8] c"\11\11\11\11\11\11\11\11"
@const_data5 = constant [1 x i8] c"\02"

define i32 @test(%struct.evm_callctx* noundef %callctx) {
entry:
%zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
%stack_alloc = alloca [8192 x i8], align 32
%stack_addr = getelementptr inbounds [8192 x i8], [8192 x i8]* %stack_alloc, i64 0, i64 0
%stack_position_ptr = alloca i64, align 4
store i64 0, i64* %stack_position_ptr

%callctx_ptr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 0
%heap_stack = load %struct.evm_stack*, %struct.evm_stack** %callctx_ptr, align 8

%heap_stack_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %heap_stack, i32 0, i32 0
%heap_stack_addr = load i8*, i8** %heap_stack_ptr, align 8
%heap_stack_position_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %heap_stack, i32 0, i32 1

%jump_target = alloca i64, align 4
br label %post_jumptable
jump_table:
%jump_target_val = load i64, i64* %jump_target, align 8
switch i64 %jump_target_val, label %jump_invalid [
  i64 50, label %br_50
]
jump_invalid:
  ret i32 -12
post_jumptable:

; OP 0: PUSH32 2114160101010101010101010101010101010101010101010101010104050201
%l0_2 = load i64, i64* %stack_position_ptr, align 8
%l0_overflow_check = icmp ugt i64 %l0_2, 8160
br i1 %l0_overflow_check, label %l0_err_overflow, label %l0_ok
l0_err_overflow:
  ret i32 -11
l0_ok:
%l0_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l0_2
%l0_4 = bitcast [32 x i8]* @const_data0 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l0_3, i8* noundef nonnull align 1 dereferenceable(32) %l0_4, i64 32, i1 false)
%l0_6 = add i64 %l0_2, 32
store i64 %l0_6, i64* %stack_position_ptr, align 8

; OP 1: PUSH1 02
%l1_2 = load i64, i64* %stack_position_ptr, align 8
%l1_overflow_check = icmp ugt i64 %l1_2, 8160
br i1 %l1_overflow_check, label %l1_err_overflow, label %l1_ok
l1_err_overflow:
  ret i32 -11
l1_ok:
%l1_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l1_2
%l1_4 = bitcast [1 x i8]* @const_data1 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l1_3, i8* noundef nonnull align 1 dereferenceable(32) %l1_4, i64 1, i1 false)
%l1_5 = getelementptr i8, i8* %l1_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l1_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l1_6 = add i64 %l1_2, 32
store i64 %l1_6, i64* %stack_position_ptr, align 8

; OP 2: PUSH8 1111111111111111
%l2_2 = load i64, i64* %stack_position_ptr, align 8
%l2_overflow_check = icmp ugt i64 %l2_2, 8160
br i1 %l2_overflow_check, label %l2_err_overflow, label %l2_ok
l2_err_overflow:
  ret i32 -11
l2_ok:
%l2_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l2_2
%l2_4 = bitcast [8 x i8]* @const_data2 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_3, i8* noundef nonnull align 1 dereferenceable(32) %l2_4, i64 8, i1 false)
%l2_5 = getelementptr i8, i8* %l2_3, i32 8
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 24, i1 false)
%l2_6 = add i64 %l2_2, 32
store i64 %l2_6, i64* %stack_position_ptr, align 8

; OP 3: SWAP2
%l3_1 = load i64, i64* %stack_position_ptr, align 8
%l3_underflow_check = icmp ult i64 %l3_1, 96
br i1 %l3_underflow_check, label %l3_err_underflow, label %l3_ok
l3_err_underflow:
ret i32 -10
l3_ok:
%l3_2 = alloca [32 x i8], align 16
%l3_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l3_1
%l3_4 = getelementptr inbounds i8, i8* %l3_3, i64 -32
%l3_5 = shl nsw i32 2, 5
%l3_6 = sext i32 %l3_5 to i64
%l3_7 = sub nsw i64 0, %l3_6
%l3_8 = getelementptr inbounds i8, i8* %l3_4, i64 %l3_7
%l3_9 = getelementptr inbounds [32 x i8], [32 x i8]* %l3_2, i64 0, i64 0
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %l3_9, i8* noundef nonnull align 1 dereferenceable(32) %l3_4, i64 32, i1 false)
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l3_4, i8* noundef nonnull align 1 dereferenceable(32) %l3_8, i64 32, i1 false)
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l3_8, i8* noundef nonnull align 16 dereferenceable(32) %l3_9, i64 32, i1 false)

; OP 4: SWAP1
%l4_1 = load i64, i64* %stack_position_ptr, align 8
%l4_underflow_check = icmp ult i64 %l4_1, 64
br i1 %l4_underflow_check, label %l4_err_underflow, label %l4_ok
l4_err_underflow:
ret i32 -10
l4_ok:
%l4_2 = alloca [32 x i8], align 16
%l4_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l4_1
%l4_4 = getelementptr inbounds i8, i8* %l4_3, i64 -32
%l4_5 = shl nsw i32 1, 5
%l4_6 = sext i32 %l4_5 to i64
%l4_7 = sub nsw i64 0, %l4_6
%l4_8 = getelementptr inbounds i8, i8* %l4_4, i64 %l4_7
%l4_9 = getelementptr inbounds [32 x i8], [32 x i8]* %l4_2, i64 0, i64 0
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %l4_9, i8* noundef nonnull align 1 dereferenceable(32) %l4_4, i64 32, i1 false)
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l4_4, i8* noundef nonnull align 1 dereferenceable(32) %l4_8, i64 32, i1 false)
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l4_8, i8* noundef nonnull align 16 dereferenceable(32) %l4_9, i64 32, i1 false)

; OP 5: PUSH1 02
%l5_2 = load i64, i64* %stack_position_ptr, align 8
%l5_overflow_check = icmp ugt i64 %l5_2, 8160
br i1 %l5_overflow_check, label %l5_err_overflow, label %l5_ok
l5_err_overflow:
  ret i32 -11
l5_ok:
%l5_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l5_2
%l5_4 = bitcast [1 x i8]* @const_data5 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l5_3, i8* noundef nonnull align 1 dereferenceable(32) %l5_4, i64 1, i1 false)
%l5_5 = getelementptr i8, i8* %l5_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l5_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l5_6 = add i64 %l5_2, 32
store i64 %l5_6, i64* %stack_position_ptr, align 8

; OP 6: JUMP
%l6_1 = load i64, i64* %stack_position_ptr, align 8
%l6_stack_check = icmp ult i64 %l6_1, 32
br i1 %l6_stack_check, label %l6_err1, label %l6_ok
l6_err1:
  ret i32 -10
l6_ok:
%l6_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l6_1
%l6_aptr = getelementptr inbounds i8, i8* %l6_2, i64 -32
%l6_aptr2 = bitcast i8* %l6_aptr to i256*
%l6_a = load i256, i256* %l6_aptr2, align 1
%l6_a_trunc = trunc i256 %l6_a to i64
store i64 %l6_a_trunc, i64* %jump_target, align 1
br label %jump_table

; OP 7: SHL
%l7_1 = load i64, i64* %stack_position_ptr, align 8
%l7_stack_check = icmp ult i64 %l7_1, 64
br i1 %l7_stack_check, label %l7_err1, label %l7_ok_shl
l7_err1:
  ret i32 -10
l7_ok_shl:
%l7_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l7_1
%l7_shiftptr = getelementptr inbounds i8, i8* %l7_2, i64 -32
%l7_valptr = getelementptr inbounds i8, i8* %l7_shiftptr, i64 -32
%l7_shiftptr2 = bitcast i8* %l7_shiftptr to i256*
%l7_valptr2 = bitcast i8* %l7_valptr to i256*
%l7_shift = load i256, i256* %l7_shiftptr2, align 1
%l7_value = load i256, i256* %l7_valptr2, align 1
%l7_shift_check = icmp uge i256 %l7_shift, 256
br i1 %l7_shift_check, label %l7_shift_large, label %l7_shift_ok
l7_shift_large:
  br label %l7_store_res
l7_shift_ok:
  %l7_shifted_val = shl i256 %l7_value, %l7_shift
  br label %l7_store_res
l7_store_res:
%l7_final_res = phi i256 [ 0, %l7_shift_large ], [ %l7_shifted_val, %l7_shift_ok ]
store i256 %l7_final_res, i256* %l7_valptr2, align 1
%l7_sdv = add i64 %l7_1, -32
store i64 %l7_sdv, i64* %stack_position_ptr, align 8

br label %br_50
br_50:

; OP 8: JUMPDEST

; OP 9: c5 (Generic Callback)
%l9_in_buffer_alloca = alloca i8, i64 64, align 32
%l9_in_stack_pos = load i64, i64* %stack_position_ptr
%l9_in_stack_check1 = icmp ult i64 %l9_in_stack_pos, 64
br i1 %l9_in_stack_check1, label %l9_err_underflow, label %l9_in_ok1
l9_err_underflow:
  ret i32 -10
l9_in_ok1:
%l9_in_stack_read_pos = sub i64 %l9_in_stack_pos, 64
%l9_in_stack_read_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l9_in_stack_read_pos
%l9_in_src_ptr_0 = getelementptr i8, i8* %l9_in_stack_read_ptr, i64 0
%l9_in_dst_ptr_0 = getelementptr i8, i8* %l9_in_buffer_alloca, i64 0 ; Use alloca buffer ptr
%l9_in_src_ptr_lo_0 = bitcast i8* %l9_in_src_ptr_0 to i128*
%l9_in_src_ptr_hi_0 = getelementptr i128, i128* %l9_in_src_ptr_lo_0, i32 1
%l9_in_dst_ptr_lo_0 = bitcast i8* %l9_in_dst_ptr_0 to i128*
%l9_in_dst_ptr_hi_0 = getelementptr i128, i128* %l9_in_dst_ptr_lo_0, i32 1
%l9_in_word_lo_0 = load i128, i128* %l9_in_src_ptr_lo_0
%l9_in_word_hi_0 = load i128, i128* %l9_in_src_ptr_hi_0
%l9_in_reversed_lo_0 = call i128 @llvm.bswap.i128(i128 %l9_in_word_hi_0)
%l9_in_reversed_hi_0 = call i128 @llvm.bswap.i128(i128 %l9_in_word_lo_0)
store i128 %l9_in_reversed_lo_0, i128* %l9_in_dst_ptr_lo_0
store i128 %l9_in_reversed_hi_0, i128* %l9_in_dst_ptr_hi_0
%l9_in_src_ptr_1 = getelementptr i8, i8* %l9_in_stack_read_ptr, i64 32
%l9_in_dst_ptr_1 = getelementptr i8, i8* %l9_in_buffer_alloca, i64 32 ; Use alloca buffer ptr
%l9_in_src_ptr_lo_1 = bitcast i8* %l9_in_src_ptr_1 to i128*
%l9_in_src_ptr_hi_1 = getelementptr i128, i128* %l9_in_src_ptr_lo_1, i32 1
%l9_in_dst_ptr_lo_1 = bitcast i8* %l9_in_dst_ptr_1 to i128*
%l9_in_dst_ptr_hi_1 = getelementptr i128, i128* %l9_in_dst_ptr_lo_1, i32 1
%l9_in_word_lo_1 = load i128, i128* %l9_in_src_ptr_lo_1
%l9_in_word_hi_1 = load i128, i128* %l9_in_src_ptr_hi_1
%l9_in_reversed_lo_1 = call i128 @llvm.bswap.i128(i128 %l9_in_word_hi_1)
%l9_in_reversed_hi_1 = call i128 @llvm.bswap.i128(i128 %l9_in_word_lo_1)
store i128 %l9_in_reversed_lo_1, i128* %l9_in_dst_ptr_lo_1
store i128 %l9_in_reversed_hi_1, i128* %l9_in_dst_ptr_hi_1
%l9_new_evm_stack_pos_after_in = sub i64 %l9_in_stack_pos, 64
store i64 %l9_new_evm_stack_pos_after_in, i64* %stack_position_ptr, align 8
%l9_out_buffer_alloca = alloca i8, i64 32, align 32
%l9_out_stack_pos = load i64, i64* %stack_position_ptr
%l9_overflow_check = icmp ugt i64 %l9_out_stack_pos, 8160
br i1 %l9_overflow_check, label %l9_err_overflow, label %l9_out_ok1
l9_err_overflow:
  ret i32 -11
l9_out_ok1:
%l9_opcode_fn_ptr_addr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 3
%l9_opcode_fn_ptr = load i32 (i8*, i8, i8*, i16, i8*, i16)*, i32 (i8*, i8, i8*, i16, i8*, i16)** %l9_opcode_fn_ptr_addr, align 8
%l9_callctx_ptr_arg = bitcast %struct.evm_callctx* %callctx to i8* ; Cast callctx to i8* for the function signature
%l9_call_ret = call i32 %l9_opcode_fn_ptr(
    i8* %l9_callctx_ptr_arg,
    i8 5,
    i8* %l9_in_buffer_alloca,
    i16 64,
    i8* %l9_out_buffer_alloca,
    i16 32
)
%l9_call_ret_check = icmp ne i32 %l9_call_ret, 0
br i1 %l9_call_ret_check, label %l9_err_callback, label %l9_callback_ok
l9_err_callback:
  ret i32 %l9_call_ret
l9_callback_ok:
%l9_evm_stack_write_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l9_out_stack_pos
%l9_out_src_ptr_0 = getelementptr i8, i8* %l9_out_buffer_alloca, i64 0
%l9_out_dst_ptr_0 = getelementptr i8, i8* %l9_evm_stack_write_ptr, i64 0
%l9_out_src_ptr_lo_0 = bitcast i8* %l9_out_src_ptr_0 to i128*
%l9_out_src_ptr_hi_0 = getelementptr i128, i128* %l9_out_src_ptr_lo_0, i32 1
%l9_out_dst_ptr_lo_0 = bitcast i8* %l9_out_dst_ptr_0 to i128*
%l9_out_dst_ptr_hi_0 = getelementptr i128, i128* %l9_out_dst_ptr_lo_0, i32 1
%l9_out_word_lo_0 = load i128, i128* %l9_out_src_ptr_lo_0
%l9_out_word_hi_0 = load i128, i128* %l9_out_src_ptr_hi_0
%l9_out_reversed_lo_0 = call i128 @llvm.bswap.i128(i128 %l9_out_word_hi_0)
%l9_out_reversed_hi_0 = call i128 @llvm.bswap.i128(i128 %l9_out_word_lo_0)
store i128 %l9_out_reversed_lo_0, i128* %l9_out_dst_ptr_lo_0
store i128 %l9_out_reversed_hi_0, i128* %l9_out_dst_ptr_hi_0
%l9_new_evm_stack_pos_after_out = add i64 %l9_out_stack_pos, 32
store i64 %l9_new_evm_stack_pos_after_out, i64* %stack_position_ptr, align 8

; OP 10: DUP1
%l10_1 = load i64, i64* %stack_position_ptr, align 8
%l10_underflow_check = icmp ult i64 %l10_1, 32
br i1 %l10_underflow_check, label %l10_err_underflow, label %l10_check_overflow
l10_err_underflow:
ret i32 -10
l10_check_overflow:
%l10_overflow_check = icmp ugt i64 %l10_1, 8160
br i1 %l10_overflow_check, label %l10_err_overflow, label %l10_ok
l10_err_overflow:
  ret i32 -11
l10_ok:
%l10_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l10_1
%l10_3 = shl nsw i32 1, 5
%l10_4 = sext i32 %l10_3 to i64
%l10_5 = sub nsw i64 0, %l10_4
%l10_6 = getelementptr inbounds i8, i8* %l10_2, i64 %l10_5
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l10_2, i8* noundef nonnull align 1 dereferenceable(32) %l10_6, i64 32, i1 false)
%l10_7 = add i64 %l10_1, 32
store i64 %l10_7, i64* %stack_position_ptr, align 8

%out_1 = load i64, i64* %heap_stack_position_ptr, align 8
%out_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %out_1
%out_3 = load i64, i64* %stack_position_ptr
%out_stack_check1 = icmp ult i64 %out_3, 64
br i1 %out_stack_check1, label %out_err1, label %out_ok1
out_err1:
  ret i32 -10
out_ok1:
%out_stack_check2 = icmp ugt i64 %out_1, 8128
br i1 %out_stack_check2, label %out_err2, label %out_ok2
out_err2:
  ret i32 -11
out_ok2:
%out_4 = sub i64 %out_3, 64
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
%out_6 = add i64 %out_1, 64
store i64 %out_6, i64* %heap_stack_position_ptr, align 8
%out_7 = sub i64 %out_3, 64
store i64 %out_7, i64* %stack_position_ptr, align 8
ret i32 0
}