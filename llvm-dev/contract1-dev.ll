
; evm stack
%struct.evm_stack = type { i8*, i64 }
declare %struct.evm_stack* @stack_init()
declare i32 @stack_push(%struct.evm_stack* noundef, i8* noundef)
declare i32 @stack_dupn(%struct.evm_stack* noundef, i32 noundef)
declare i32 @stack_swapn(%struct.evm_stack* noundef, i32 noundef)
declare i32 @stack_pop(%struct.evm_stack* noundef)
declare i32 @stack_print_item(%struct.evm_stack* noundef, i32 noundef)

; evm math
declare i32 @math_add(%struct.evm_stack* noundef)
declare i32 @math_sub(%struct.evm_stack* noundef)
declare i32 @math_mul(%struct.evm_stack* noundef)
declare i32 @math_div(%struct.evm_stack* noundef)

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #5


@const_push32_1 = constant [32 x i8] c"\AB\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF"
@const_push32_2 = constant [32 x i8] c"\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA"
@const_zero32 = constant [32 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"
@const_data1 = constant [6 x i8] c"\33\33\33\33\33\33"
@const_data2 = constant [8 x i8] c"\11\11\11\11\11\11\11\11"


; Main function for testing
define i32 @main() {
entry:
  %zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*

; define stack
  %stack = tail call %struct.evm_stack* @stack_init()
  %stack_is_null = icmp eq %struct.evm_stack* %stack, null
  br i1 %stack_is_null, label %stack_err, label %stack_ready
stack_err:
  ret i32 -1
stack_ready:
  %stack_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %stack, i32 0, i32 0
  %stack_addr = load i8*, i8** %stack_ptr, align 8
  %stack_position_ptr = getelementptr %struct.evm_stack, %struct.evm_stack* %stack, i32 0, i32 1

  
; PUSH32 
  %op1_value_ptr = bitcast [32 x i8]* @const_push32_1 to i8*
  %op1_errcode = call i32 @stack_push(%struct.evm_stack* %stack, i8* %op1_value_ptr)
  %op1_is_error = icmp slt i32 %op1_errcode, 0
  br i1 %op1_is_error, label %op1_error, label %op1_ok
op1_error:
  ret i32 %op1_errcode
op1_ok:

; PUSH32 
  %op2_value_ptr = bitcast [32 x i8]* @const_push32_2 to i8*
  %op2_errcode = call i32 @stack_push(%struct.evm_stack* %stack, i8* %op2_value_ptr)
  %op2_is_error = icmp slt i32 %op2_errcode, 0
  br i1 %op2_is_error, label %op2_error, label %op2_ok
op2_error:
  ret i32 %op2_errcode
op2_ok:
  
; DUPN 2
  %op3_errcode = call i32 @stack_dupn(%struct.evm_stack* %stack, i32 2)
  %op3_is_error = icmp slt i32 %op3_errcode, 0
  br i1 %op2_is_error, label %op3_error, label %op3_ok
op3_error:
  ret i32 %op3_errcode
op3_ok:

; SWAPN 1
  %op4_errcode = call i32 @stack_swapn(%struct.evm_stack* %stack, i32 1)
  %op4_is_error = icmp slt i32 %op4_errcode, 0
  br i1 %op4_is_error, label %op4_error, label %op4_ok
op4_error:
  ret i32 %op4_errcode
op4_ok:

; POP
  %op5_errcode = call i32 @stack_pop(%struct.evm_stack* %stack)
  %op5_is_error = icmp slt i32 %op5_errcode, 0
  br i1 %op5_is_error, label %op5_error, label %op5_ok
op5_error:
  ret i32 %op5_errcode
op5_ok:

; DIV
  %op6_errcode = call i32 @math_div(%struct.evm_stack* %stack)
  %op6_is_error = icmp slt i32 %op6_errcode, 0
  br i1 %op6_is_error, label %op6_error, label %op6_ok
op6_error:
  ret i32 %op6_errcode
op6_ok:

; PUSH32
  %t6 = load i64, i64* %stack_position_ptr, align 8
  %t8 = getelementptr inbounds i8, i8* %stack_addr, i64 %t6
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %t8, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 32, i1 false)
  %t9 = load i64, i64* %stack_position_ptr, align 8
  %t10 = add i64 %t9, 32
  store i64 %t10, i64* %stack_position_ptr, align 8


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

; OP 4: ADD
%l4_1 = load i64, i64* %stack_position_ptr, align 8
%l4_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l4_1
%l4_aptr = getelementptr inbounds i8, i8* %l4_2, i64 -32
%l4_bptr = getelementptr inbounds i8, i8* %l4_aptr, i64 -32
%l4_aptr2 = bitcast i8* %l4_aptr to i256*
%l4_bptr2 = bitcast i8* %l4_bptr to i256*
%l4_a = load i256, i256* %l4_aptr2
%l4_b = load i256, i256* %l4_bptr2
%l4_sum = add i256 %l4_a, %l4_b
store i256 %l4_sum, i256* %l4_aptr2



  call i32 @stack_print_item(%struct.evm_stack* %stack, i32 1)
  call i32 @stack_print_item(%struct.evm_stack* %stack, i32 2)
  call i32 @stack_print_item(%struct.evm_stack* %stack, i32 3)
  call i32 @stack_print_item(%struct.evm_stack* %stack, i32 4)

  
  ret i32 0
}
