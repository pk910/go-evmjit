%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
@const_zero32 = constant [32 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"

@const_data1 = constant [32 x i8] c"\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01"
@const_data2 = constant [6 x i8] c"\22\22\22\22\22\22"
@const_data3 = constant [8 x i8] c"\11\11\11\11\11\11\11\11"
@const_data7 = constant [1 x i8] c"\02"

define i32 @test(%struct.evm_stack* noundef %stack) {
entry:
%zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
%stack_alloc = alloca [8192 x i8], align 16
%stack_addr = getelementptr inbounds [8192 x i8], [8192 x i8]* %stack_alloc, i64 0, i64 0
%stack_position_ptr = alloca i64, align 4
store i64 0, i64* %stack_position_ptr

%heap_stack_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %stack, i32 0, i32 0
%heap_stack_addr = load i8*, i8** %heap_stack_ptr, align 8
%heap_stack_position_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %stack, i32 0, i32 1

; OP 1: PUSH32 0101010101010101010101010101010101010101010101010101010101010101
%l1_2 = load i64, i64* %stack_position_ptr, align 8
%l1_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l1_2
%l1_4 = bitcast [32 x i8]* @const_data1 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l1_3, i8* noundef nonnull align 1 dereferenceable(32) %l1_4, i64 32, i1 false)
%l1_6 = add i64 %l1_2, 32
store i64 %l1_6, i64* %stack_position_ptr, align 8

; OP 2: PUSH6 222222222222
%l2_2 = load i64, i64* %stack_position_ptr, align 8
%l2_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l2_2
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_3, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 26, i1 false)
%l2_4 = bitcast [6 x i8]* @const_data2 to i8*
%l2_5 = getelementptr i8, i8* %l2_3, i32 26
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_5, i8* noundef nonnull align 1 dereferenceable(32) %l2_4, i64 6, i1 false)
%l2_6 = add i64 %l2_2, 32
store i64 %l2_6, i64* %stack_position_ptr, align 8

; OP 3: PUSH8 1111111111111111
%l3_2 = load i64, i64* %stack_position_ptr, align 8
%l3_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l3_2
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l3_3, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 24, i1 false)
%l3_4 = bitcast [8 x i8]* @const_data3 to i8*
%l3_5 = getelementptr i8, i8* %l3_3, i32 24
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l3_5, i8* noundef nonnull align 1 dereferenceable(32) %l3_4, i64 8, i1 false)
%l3_6 = add i64 %l3_2, 32
store i64 %l3_6, i64* %stack_position_ptr, align 8

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
%l5_aptr2 = bitcast i8* %l5_aptr to i256*
%l5_bptr2 = bitcast i8* %l5_bptr to i256*
%l5_a = load i256, i256* %l5_aptr2
%l5_b = load i256, i256* %l5_bptr2
%l5_sum = add i256 %l5_a, %l5_b
store i256 %l5_sum, i256* %l5_bptr2
%l5_sdv = add i64 %l5_1, -32
store i64 %l5_sdv, i64* %stack_position_ptr, align 8

; OP 6: DUP2
%l6_1 = load i64, i64* %stack_position_ptr, align 8
%l6_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l6_1
%l6_3 = shl nsw i32 2, 5
%l6_4 = sext i32 %l6_3 to i64
%l6_5 = sub nsw i64 0, %l6_4
%l6_6 = getelementptr inbounds i8, i8* %l6_2, i64 %l6_5
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l6_2, i8* noundef nonnull align 1 dereferenceable(32) %l6_6, i64 32, i1 false)
%l6_7 = add i64 %l6_1, 32
store i64 %l6_7, i64* %stack_position_ptr, align 8

; OP 7: PUSH1 02
%l7_2 = load i64, i64* %stack_position_ptr, align 8
%l7_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l7_2
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l7_3, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l7_4 = bitcast [1 x i8]* @const_data7 to i8*
%l7_5 = getelementptr i8, i8* %l7_3, i32 31
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l7_5, i8* noundef nonnull align 1 dereferenceable(32) %l7_4, i64 1, i1 false)
%l7_6 = add i64 %l7_2, 32
store i64 %l7_6, i64* %stack_position_ptr, align 8


%out_1 = load i64, i64* %heap_stack_position_ptr, align 8
%out_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %out_1
%out_3 = load i64, i64* %stack_position_ptr
%out_4 = sub i64 %out_3, 128
%out_5 = getelementptr inbounds i8, i8* %stack_addr, i64 %out_4
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %out_2, i8* align 16 %out_5, i64 128, i1 false)
%out_6 = add i64 %out_1, 128
store i64 %out_6, i64* %heap_stack_position_ptr, align 8

ret i32 0
}