%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare i128 @llvm.bswap.i128(i128)
@const_zero32 = constant [32 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"

@const_data1 = constant [32 x i8] c"\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01"
@const_data2 = constant [1 x i8] c"\02"
@const_data3 = constant [8 x i8] c"\11\11\11\11\11\11\11\11"

define i32 @test(%struct.evm_stack* noundef %stack) {
entry:
%zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
%stack_alloc = alloca [8192 x i8], align 32
%stack_addr = getelementptr inbounds [8192 x i8], [8192 x i8]* %stack_alloc, i64 0, i64 0
%stack_position_ptr = alloca i64, align 4
store i64 0, i64* %stack_position_ptr

%heap_stack_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %stack, i32 0, i32 0
%heap_stack_addr = load i8*, i8** %heap_stack_ptr, align 8
%heap_stack_position_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %stack, i32 0, i32 1

; OP 1: PUSH32 0101010101010101010101010101010101010101010101010101010101010101
%l1_2 = load i64, i64* %stack_position_ptr, align 8
%l1_overflow_check = icmp ugt i64 %l1_2, 8160
br i1 %l1_overflow_check, label %l1_err_overflow, label %l1_ok
l1_err_overflow:
  ret i32 -11
l1_ok:
%l1_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l1_2
%l1_4 = bitcast [32 x i8]* @const_data1 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l1_3, i8* noundef nonnull align 1 dereferenceable(32) %l1_4, i64 32, i1 false)
%l1_6 = add i64 %l1_2, 32
store i64 %l1_6, i64* %stack_position_ptr, align 8

; OP 2: PUSH1 02
%l2_2 = load i64, i64* %stack_position_ptr, align 8
%l2_overflow_check = icmp ugt i64 %l2_2, 8160
br i1 %l2_overflow_check, label %l2_err_overflow, label %l2_ok
l2_err_overflow:
  ret i32 -11
l2_ok:
%l2_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l2_2
%l2_4 = bitcast [1 x i8]* @const_data2 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_3, i8* noundef nonnull align 1 dereferenceable(32) %l2_4, i64 1, i1 false)
%l2_5 = getelementptr i8, i8* %l2_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l2_6 = add i64 %l2_2, 32
store i64 %l2_6, i64* %stack_position_ptr, align 8

; OP 3: PUSH8 1111111111111111
%l3_2 = load i64, i64* %stack_position_ptr, align 8
%l3_overflow_check = icmp ugt i64 %l3_2, 8160
br i1 %l3_overflow_check, label %l3_err_overflow, label %l3_ok
l3_err_overflow:
  ret i32 -11
l3_ok:
%l3_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l3_2
%l3_4 = bitcast [8 x i8]* @const_data3 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l3_3, i8* noundef nonnull align 1 dereferenceable(32) %l3_4, i64 8, i1 false)
%l3_5 = getelementptr i8, i8* %l3_3, i32 8
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l3_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 24, i1 false)
%l3_6 = add i64 %l3_2, 32
store i64 %l3_6, i64* %stack_position_ptr, align 8

; OP 4: SWAP2
%l4_1 = load i64, i64* %stack_position_ptr, align 8
%l4_underflow_check = icmp ult i64 %l4_1, 96
br i1 %l4_underflow_check, label %l4_err_underflow, label %l4_ok
l4_err_underflow:
ret i32 -10
l4_ok:
%l4_2 = alloca [32 x i8], align 16
%l4_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l4_1
%l4_4 = getelementptr inbounds i8, i8* %l4_3, i64 -32
%l4_5 = shl nsw i32 2, 5
%l4_6 = sext i32 %l4_5 to i64
%l4_7 = sub nsw i64 0, %l4_6
%l4_8 = getelementptr inbounds i8, i8* %l4_4, i64 %l4_7
%l4_9 = getelementptr inbounds [32 x i8], [32 x i8]* %l4_2, i64 0, i64 0
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %l4_9, i8* noundef nonnull align 1 dereferenceable(32) %l4_4, i64 32, i1 false)
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l4_4, i8* noundef nonnull align 1 dereferenceable(32) %l4_8, i64 32, i1 false)
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l4_8, i8* noundef nonnull align 16 dereferenceable(32) %l4_9, i64 32, i1 false)

; OP 5: BYTE
%l5_1 = load i64, i64* %stack_position_ptr, align 8
%l5_stack_check = icmp ult i64 %l5_1, 64
br i1 %l5_stack_check, label %l5_err1, label %l5_ok_byte
l5_err1:
  ret i32 -10
l5_ok_byte:
%l5_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l5_1
%l5_iptr = getelementptr inbounds i8, i8* %l5_2, i64 -32
%l5_xptr = getelementptr inbounds i8, i8* %l5_iptr, i64 -32
%l5_iptr2 = bitcast i8* %l5_iptr to i256*
%l5_xptr2 = bitcast i8* %l5_xptr to i256*
%l5_i = load i256, i256* %l5_iptr2, align 1
%l5_x = load i256, i256* %l5_xptr2, align 1
%l5_index_check = icmp uge i256 %l5_i, 32
br i1 %l5_index_check, label %l5_index_out, label %l5_index_in
l5_index_out:
  br label %l5_store_res
l5_index_in:
  %l5_le_byte_index = sub i256 31, %l5_i
  %l5_shift_amount = mul i256 %l5_le_byte_index, 8
  %l5_shifted_x = lshr i256 %l5_x, %l5_shift_amount
  %l5_masked_res = and i256 %l5_shifted_x, 255
  br label %l5_store_res
l5_store_res:
%l5_final_res = phi i256 [ 0, %l5_index_out ], [ %l5_masked_res, %l5_index_in ]
store i256 %l5_final_res, i256* %l5_xptr2, align 1
%l5_sdv = add i64 %l5_1, -32
store i64 %l5_sdv, i64* %stack_position_ptr, align 8

%out_1 = load i64, i64* %heap_stack_position_ptr, align 8
%out_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %out_1
%out_3 = load i64, i64* %stack_position_ptr
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

ret i32 0
}