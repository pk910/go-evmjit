%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)

@const_zero32 = constant [32 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"



@const_data1 = constant [6 x i8] c"\33\33\33\33\33\33"
@const_data2 = constant [8 x i8] c"\11\11\11\11\11\11\11\11"

define i32 @test(%struct.evm_stack* noundef %stack) {
entry:
  %zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
  %stack_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %stack, i32 0, i32 0
  %stack_addr = load i8*, i8** %stack_ptr, align 8
  %stack_position_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %stack, i32 0, i32 1


; OP 1: PUSH6 333333333333
%l1_2 = load i64, i64* %stack_position_ptr, align 8
%l1_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l1_2
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l1_3, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 26, i1 false)
%l1_4 = bitcast [6 x i8]* @const_data1 to i8*
%l1_5 = getelementptr i8, i8* %l1_3, i32 26
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l1_5, i8* noundef nonnull align 1 dereferenceable(32) %l1_4, i64 6, i1 false)
%l1_6 = add i64 %l1_2, 32
store i64 %l1_6, i64* %stack_position_ptr, align 8
; OP 2: PUSH8 1111111111111111
%l2_2 = load i64, i64* %stack_position_ptr, align 8
%l2_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l2_2
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_3, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 24, i1 false)
%l2_4 = bitcast [8 x i8]* @const_data2 to i8*
%l2_5 = getelementptr i8, i8* %l2_3, i32 24
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_5, i8* noundef nonnull align 1 dereferenceable(32) %l2_4, i64 8, i1 false)
%l2_6 = add i64 %l2_2, 32
store i64 %l2_6, i64* %stack_position_ptr, align 8
; OP 3: DUP1
%l3_1 = load i64, i64* %stack_position_ptr, align 8
%l3_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l3_1
%l3_3 = shl nsw i32 1, 5
%l3_4 = sext i32 %l3_3 to i64
%l3_5 = sub nsw i64 0, %l3_4
%l3_6 = getelementptr inbounds i8, i8* %l3_2, i64 %l3_5
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l3_2, i8* noundef nonnull align 1 dereferenceable(32) %l3_6, i64 32, i1 false)
%l3_7 = add i64 %l3_1, 32
store i64 %l3_7, i64* %stack_position_ptr, align 8
; OP 4: SWAP2
%l4_1 = load i64, i64* %stack_position_ptr, align 8
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
; OP 5: ADD
%l5_1 = load i64, i64* %stack_position_ptr, align 8
%l5_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l5_1
%l5_aptr = getelementptr inbounds i8, i8* %l5_2, i64 -32
%l5_bptr = getelementptr inbounds i8, i8* %l5_aptr, i64 -32
%l5_aptr1 = bitcast i8* %l5_aptr to i64*
%l5_bptr1 = bitcast i8* %l5_bptr to i64*
; add byte 4
%l5_afof4 = getelementptr inbounds i8, i8* %l5_aptr, i64 24
%l5_aptr4 = bitcast i8* %l5_afof4 to i64*
%l5_aval4 = load i64, i64* %l5_aptr4, align 8
%l5_bfof4 = getelementptr inbounds i8, i8* %l5_bptr, i64 24
%l5_bptr4 = bitcast i8* %l5_bfof4 to i64*
%l5_bval4 = load i64, i64* %l5_bptr4, align 8
%l5_res4 = add i64 %l5_aval4, %l5_bval4
%l5_res4c1 = icmp ult i64 %l5_res4, %l5_aval4
%l5_res4c2 = icmp ult i64 %l5_res4, %l5_bval4
%l5_res4co = or i1 %l5_res4c1, %l5_res4c2
%l5_res4c = zext i1 %l5_res4co to i64
store i64 %l5_res4, i64* %l5_aptr4, align 8
; add byte 3
%l5_afof3 = getelementptr inbounds i8, i8* %l5_aptr, i64 16
%l5_aptr3 = bitcast i8* %l5_afof3 to i64*
%l5_aval3 = load i64, i64* %l5_aptr3, align 8
%l5_bfof3 = getelementptr inbounds i8, i8* %l5_bptr, i64 16
%l5_bptr3 = bitcast i8* %l5_bfof3 to i64*
%l5_bval3 = load i64, i64* %l5_bptr3, align 8
%l5_res3p = add i64 %l5_aval3, %l5_res4c
%l5_res3 = add i64 %l5_res3p, %l5_bval3
%l5_res3c1 = icmp ult i64 %l5_res3, %l5_aval3
%l5_res3c2 = icmp ult i64 %l5_res3, %l5_bval3
%l5_res3c3 = or i1 %l5_res3c1, %l5_res3c2
%l5_res3c4 = icmp eq i64 %l5_res3, %l5_aval3
%l5_res3c5 = icmp ne i64 %l5_bval3, 0
%l5_res3c6 = and i1 %l5_res3c4, %l5_res3c5
%l5_res3c7 = or i1 %l5_res3c3, %l5_res3c6
%l5_res3c = zext i1 %l5_res3c7 to i64
store i64 %l5_res3, i64* %l5_aptr3, align 8
; add byte 2
%l5_afof2 = getelementptr inbounds i8, i8* %l5_aptr, i64 8
%l5_aptr2 = bitcast i8* %l5_afof2 to i64*
%l5_aval2 = load i64, i64* %l5_aptr2, align 8
%l5_bfof2 = getelementptr inbounds i8, i8* %l5_bptr, i64 8
%l5_bptr2 = bitcast i8* %l5_bfof2 to i64*
%l5_bval2 = load i64, i64* %l5_bptr2, align 8
%l5_res2p = add i64 %l5_aval2, %l5_res3c
%l5_res2 = add i64 %l5_res2p, %l5_bval2
%l5_res2c1 = icmp ult i64 %l5_res2, %l5_aval2
%l5_res2c2 = icmp ult i64 %l5_res2, %l5_bval2
%l5_res2c3 = or i1 %l5_res2c1, %l5_res2c2
%l5_res2c4 = icmp eq i64 %l5_res2, %l5_aval2
%l5_res2c5 = icmp ne i64 %l5_bval2, 0
%l5_res2c6 = and i1 %l5_res2c4, %l5_res2c5
%l5_res2c7 = or i1 %l5_res2c3, %l5_res2c6
%l5_res2c = zext i1 %l5_res2c7 to i64
store i64 %l5_res2, i64* %l5_aptr2, align 8
; add byte 3
%l5_aval1 = load i64, i64* %l5_aptr1, align 8
%l5_bval1 = load i64, i64* %l5_bptr1, align 8
%l5_res1p = add i64 %l5_aval1, %l5_res2c
%l5_res1 = add i64 %l5_res1p, %l5_bval1
store i64 %l5_res1, i64* %l5_aptr1, align 8
; decrease stack size
%l5_sdv = add i64 %l5_1, -1
store i64 %l5_sdv, i64* %stack_position_ptr, align 8
; OP 6: ADD
br label %op6_start
op6_start:
%l6_1 = load i64, i64* %stack_position_ptr, align 8
%l6_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l6_1
%l6_aptr = getelementptr inbounds i8, i8* %l6_2, i64 -32
%l6_bptr = getelementptr inbounds i8, i8* %l6_aptr, i64 -32
%l6_aptr1 = bitcast i8* %l6_aptr to i64*
%l6_afof4 = getelementptr inbounds i8, i8* %l6_aptr, i64 24
%l6_aptr4 = bitcast i8* %l6_afof4 to i64*
%l6_aval4 = load i64, i64* %l6_aptr4, align 8
%l6_bfof4 = getelementptr inbounds i8, i8* %l6_bptr, i64 24
%l6_bptr4 = bitcast i8* %l6_bfof4 to i64*
%l6_bval4 = load i64, i64* %l6_bptr4, align 8
%l6_res4 = sub i64 %l6_aval4, %l6_bval4
%l6_17 = icmp ult i64 %l6_aval4, %l6_bval4
store i64 %l6_res4, i64* %l6_aptr4, align 8
%l6_afof3 = getelementptr inbounds i8, i8* %l6_aptr, i64 16
%l6_aptr3 = bitcast i8* %l6_afof3 to i64*
%l6_aval3 = load i64, i64* %l6_aptr3, align 8
%l6_bfof3 = getelementptr inbounds i8, i8* %l6_bptr, i64 16
%l6_bptr3 = bitcast i8* %l6_bfof3 to i64*
%l6_bval3 = load i64, i64* %l6_bptr3, align 8
%l6_cmp1 = icmp ult i64 %l6_aval3, %l6_bval3
br i1 %l6_cmp1, label %l6_cmp1_f, label %l6_cmp1_t
l6_cmp1_t:
%l6_cmp2 = icmp eq i64 %l6_aval3, %l6_bval3
%l6_27 = select i1 %l6_cmp2, i1 %l6_17, i1 false
br label %l6_cmp1_f
l6_cmp1_f:
%l6_29 = phi i1 [ true, %op6_start ], [ %l6_27, %l6_cmp1_t ]
%l6_30 = zext i1 %l6_17 to i64
%l6_31 = add i64 %l6_bval3, %l6_30
%l6_32 = sub i64 %l6_aval3, %l6_31
%l6_33 = bitcast i8* %l6_bptr to i64*
%l6_34 = zext i1 %l6_29 to i64
store i64 %l6_32, i64* %l6_aptr3, align 8
%l6_afof2 = getelementptr inbounds i8, i8* %l6_aptr, i64 8
%l6_aptr2 = bitcast i8* %l6_afof2 to i64*
%l6_aval2 = load i64, i64* %l6_aptr2, align 8
%l6_bfof2 = getelementptr inbounds i8, i8* %l6_bptr, i64 8
%l6_bptr2 = bitcast i8* %l6_bfof2 to i64*
%l6_bval2 = load i64, i64* %l6_bptr2, align 8
%l6_41 = add i64 %l6_bval2, %l6_34
%l6_42 = sub i64 %l6_aval2, %l6_41
%l6_43 = icmp ult i64 %l6_aval2, %l6_bval2
%l6_44 = icmp eq i64 %l6_aval2, %l6_bval2
%l6_45 = select i1 %l6_44, i1 %l6_29, i1 false
%l6_46 = select i1 %l6_43, i1 true, i1 %l6_45
%l6_47 = zext i1 %l6_46 to i64
store i64 %l6_42, i64* %l6_aptr2, align 8
%l6_48 = load i64, i64* %l6_aptr1, align 8
%l6_49 = load i64, i64* %l6_33, align 8
%l6_50 = add i64 %l6_49, %l6_47
%l6_51 = sub i64 %l6_48, %l6_50
store i64 %l6_51, i64* %l6_aptr1, align 8
; decrease stack size
%l6_sdv = add i64 %l6_1, -1
store i64 %l6_sdv, i64* %stack_position_ptr, align 8

  ret i32 0
}