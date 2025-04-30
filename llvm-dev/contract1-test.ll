
%struct.evm_callctx = type { %struct.evm_stack*, i64, i64, i32 (i8*, i8, i8*, i16, i8*, i16, i64*)*, i8* }
%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare i128 @llvm.bswap.i128(i128)
@const_zero32 = constant [32 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"

@const_data0 = constant [32 x i8] c"\01\02\05\04\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\16\14\21"
@const_data1 = constant [1 x i8] c"\02"
@const_data2 = constant [8 x i8] c"\11\11\11\11\11\11\11\11"
@const_data5 = constant [1 x i8] c"\32"
@const_data10 = constant [1 x i8] c"\32"
@const_data13 = constant [1 x i8] c"\32"
@const_data15 = constant [1 x i8] c"\02"

define i32 @test(%struct.evm_callctx* noundef %callctx) {
entry:
%zero32_ptr = bitcast [32 x i8]* @const_zero32 to i8*
%stack_alloc = alloca [32768 x i8], align 32
%stack_addr = getelementptr inbounds [32768 x i8], [32768 x i8]* %stack_alloc, i64 0, i64 0
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
  i64 50, label %br_50
]
jump_invalid:
  store i32 -12, i32* %exitcode_ptr
  br label %error_return
post_jumptable:

; OP 0: PUSH32 2114160101010101010101010101010101010101010101010101010104050201
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
%l0_2 = load i64, i64* %stack_position_ptr, align 8
%l0_overflow_check = icmp ugt i64 %l0_2, 32736
br i1 %l0_overflow_check, label %l0_err_overflow, label %l0_ok
l0_err_overflow:
  store i64 0, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l0_ok:
%l0_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l0_2
%l0_4 = bitcast [32 x i8]* @const_data0 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l0_3, i8* noundef nonnull align 1 dereferenceable(32) %l0_4, i64 32, i1 false)
%l0_6 = add i64 %l0_2, 32
store i64 %l0_6, i64* %stack_position_ptr, align 8

; OP 1: PUSH1 02
%l1_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l1_gas2 = icmp ult i64 %l1_gas1, 3
br i1 %l1_gas2, label %l1_gaserr, label %l1_gasok
l1_gaserr:
  store i64 33, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l1_gasok:
%l1_gas4 = add i64 %l1_gas1, -3
store i64 %l1_gas4, i64* %stack_gasleft_ptr, align 1
%l1_2 = load i64, i64* %stack_position_ptr, align 8
%l1_overflow_check = icmp ugt i64 %l1_2, 32736
br i1 %l1_overflow_check, label %l1_err_overflow, label %l1_ok
l1_err_overflow:
  store i64 33, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l1_ok:
%l1_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l1_2
%l1_4 = bitcast [1 x i8]* @const_data1 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l1_3, i8* noundef nonnull align 1 dereferenceable(32) %l1_4, i64 1, i1 false)
%l1_5 = getelementptr i8, i8* %l1_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l1_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l1_6 = add i64 %l1_2, 32
store i64 %l1_6, i64* %stack_position_ptr, align 8

; OP 2: PUSH8 1111111111111111
%l2_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l2_gas2 = icmp ult i64 %l2_gas1, 3
br i1 %l2_gas2, label %l2_gaserr, label %l2_gasok
l2_gaserr:
  store i64 35, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l2_gasok:
%l2_gas4 = add i64 %l2_gas1, -3
store i64 %l2_gas4, i64* %stack_gasleft_ptr, align 1
%l2_2 = load i64, i64* %stack_position_ptr, align 8
%l2_overflow_check = icmp ugt i64 %l2_2, 32736
br i1 %l2_overflow_check, label %l2_err_overflow, label %l2_ok
l2_err_overflow:
  store i64 35, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l2_ok:
%l2_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l2_2
%l2_4 = bitcast [8 x i8]* @const_data2 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_3, i8* noundef nonnull align 1 dereferenceable(32) %l2_4, i64 8, i1 false)
%l2_5 = getelementptr i8, i8* %l2_3, i32 8
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l2_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 24, i1 false)
%l2_6 = add i64 %l2_2, 32
store i64 %l2_6, i64* %stack_position_ptr, align 8

; OP 3: SWAP2
%l3_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l3_gas2 = icmp ult i64 %l3_gas1, 3
br i1 %l3_gas2, label %l3_gaserr, label %l3_gasok
l3_gaserr:
  store i64 44, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l3_gasok:
%l3_gas4 = add i64 %l3_gas1, -3
store i64 %l3_gas4, i64* %stack_gasleft_ptr, align 1
%l3_1 = load i64, i64* %stack_position_ptr, align 8
%l3_underflow_check = icmp ult i64 %l3_1, 96
br i1 %l3_underflow_check, label %l3_err_underflow, label %l3_ok
l3_err_underflow:
  store i64 44, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
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
%l4_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l4_gas2 = icmp ult i64 %l4_gas1, 3
br i1 %l4_gas2, label %l4_gaserr, label %l4_gasok
l4_gaserr:
  store i64 45, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l4_gasok:
%l4_gas4 = add i64 %l4_gas1, -3
store i64 %l4_gas4, i64* %stack_gasleft_ptr, align 1
%l4_1 = load i64, i64* %stack_position_ptr, align 8
%l4_underflow_check = icmp ult i64 %l4_1, 64
br i1 %l4_underflow_check, label %l4_err_underflow, label %l4_ok
l4_err_underflow:
  store i64 45, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
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

; OP 5: PUSH1 32
%l5_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l5_gas2 = icmp ult i64 %l5_gas1, 3
br i1 %l5_gas2, label %l5_gaserr, label %l5_gasok
l5_gaserr:
  store i64 46, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l5_gasok:
%l5_gas4 = add i64 %l5_gas1, -3
store i64 %l5_gas4, i64* %stack_gasleft_ptr, align 1
%l5_2 = load i64, i64* %stack_position_ptr, align 8
%l5_overflow_check = icmp ugt i64 %l5_2, 32736
br i1 %l5_overflow_check, label %l5_err_overflow, label %l5_ok
l5_err_overflow:
  store i64 46, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l5_ok:
%l5_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l5_2
%l5_4 = bitcast [1 x i8]* @const_data5 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l5_3, i8* noundef nonnull align 1 dereferenceable(32) %l5_4, i64 1, i1 false)
%l5_5 = getelementptr i8, i8* %l5_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l5_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l5_6 = add i64 %l5_2, 32
store i64 %l5_6, i64* %stack_position_ptr, align 8

; OP 6: JUMP
%l6_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l6_gas2 = icmp ult i64 %l6_gas1, 8
br i1 %l6_gas2, label %l6_gaserr, label %l6_gasok
l6_gaserr:
  store i64 48, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l6_gasok:
%l6_gas4 = add i64 %l6_gas1, -8
store i64 %l6_gas4, i64* %stack_gasleft_ptr, align 1
%l6_1 = load i64, i64* %stack_position_ptr, align 8
%l6_stack_check = icmp ult i64 %l6_1, 32
br i1 %l6_stack_check, label %l6_err1, label %l6_ok
l6_err1:
  store i64 48, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l6_ok:
%l6_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l6_1
%l6_aptr = getelementptr inbounds i8, i8* %l6_2, i64 -32
%l6_aptr2 = bitcast i8* %l6_aptr to i256*
%l6_a = load i256, i256* %l6_aptr2, align 1
%l6_a_trunc = trunc i256 %l6_a to i64
store i64 %l6_a_trunc, i64* %jump_target, align 1
store i64 48, i64* %pc_ptr
%l6_sdv = add i64 %l6_1, -32
store i64 %l6_sdv, i64* %stack_position_ptr, align 8
br label %jump_table

; OP 7: SHL
%l7_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l7_gas2 = icmp ult i64 %l7_gas1, 3
br i1 %l7_gas2, label %l7_gaserr, label %l7_gasok
l7_gaserr:
  store i64 49, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l7_gasok:
%l7_gas4 = add i64 %l7_gas1, -3
store i64 %l7_gas4, i64* %stack_gasleft_ptr, align 1
%l7_1 = load i64, i64* %stack_position_ptr, align 8
%l7_stack_check = icmp ult i64 %l7_1, 64
br i1 %l7_stack_check, label %l7_err1, label %l7_ok_shl
l7_err1:
  store i64 49, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
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
%l8_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l8_gas2 = icmp ult i64 %l8_gas1, 1
br i1 %l8_gas2, label %l8_gaserr, label %l8_gasok
l8_gaserr:
  store i64 50, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l8_gasok:
%l8_gas4 = add i64 %l8_gas1, -1
store i64 %l8_gas4, i64* %stack_gasleft_ptr, align 1
; OP 9: PC
%l9_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l9_gas2 = icmp ult i64 %l9_gas1, 2
br i1 %l9_gas2, label %l9_gaserr, label %l9_gasok
l9_gaserr:
  store i64 51, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l9_gasok:
%l9_gas4 = add i64 %l9_gas1, -2
store i64 %l9_gas4, i64* %stack_gasleft_ptr, align 1
%l9_1 = load i64, i64* %stack_position_ptr, align 8
%l9_overflow_check = icmp ugt i64 %l9_1, 32736
br i1 %l9_overflow_check, label %l9_err_overflow, label %l9_ok
l9_err_overflow:
  store i64 51, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l9_ok:
%l9_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l9_1
%l9_aptr2 = bitcast i8* %l9_2 to i256*
%l9_3 = load i64, i64* %stack_gasleft_ptr, align 8
%l9_4 = zext i64 %l9_3 to i256
store i256 %l9_4, i256* %l9_aptr2, align 1
%l9_6 = add i64 %l9_1, 32
store i64 %l9_6, i64* %stack_position_ptr, align 8

; OP 10: PUSH1 32
%l10_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l10_gas2 = icmp ult i64 %l10_gas1, 3
br i1 %l10_gas2, label %l10_gaserr, label %l10_gasok
l10_gaserr:
  store i64 52, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l10_gasok:
%l10_gas4 = add i64 %l10_gas1, -3
store i64 %l10_gas4, i64* %stack_gasleft_ptr, align 1
%l10_2 = load i64, i64* %stack_position_ptr, align 8
%l10_overflow_check = icmp ugt i64 %l10_2, 32736
br i1 %l10_overflow_check, label %l10_err_overflow, label %l10_ok
l10_err_overflow:
  store i64 52, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l10_ok:
%l10_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l10_2
%l10_4 = bitcast [1 x i8]* @const_data10 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l10_3, i8* noundef nonnull align 1 dereferenceable(32) %l10_4, i64 1, i1 false)
%l10_5 = getelementptr i8, i8* %l10_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l10_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l10_6 = add i64 %l10_2, 32
store i64 %l10_6, i64* %stack_position_ptr, align 8

; OP 11: PC
%l11_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l11_gas2 = icmp ult i64 %l11_gas1, 2
br i1 %l11_gas2, label %l11_gaserr, label %l11_gasok
l11_gaserr:
  store i64 54, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l11_gasok:
%l11_gas4 = add i64 %l11_gas1, -2
store i64 %l11_gas4, i64* %stack_gasleft_ptr, align 1
%l11_1 = load i64, i64* %stack_position_ptr, align 8
%l11_overflow_check = icmp ugt i64 %l11_1, 32736
br i1 %l11_overflow_check, label %l11_err_overflow, label %l11_ok
l11_err_overflow:
  store i64 54, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l11_ok:
%l11_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l11_1
%l11_aptr2 = bitcast i8* %l11_2 to i256*
%l11_3 = load i64, i64* %stack_gasleft_ptr, align 8
%l11_4 = zext i64 %l11_3 to i256
store i256 %l11_4, i256* %l11_aptr2, align 1
%l11_6 = add i64 %l11_1, 32
store i64 %l11_6, i64* %stack_position_ptr, align 8

; OP 12: GT
%l12_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l12_gas2 = icmp ult i64 %l12_gas1, 3
br i1 %l12_gas2, label %l12_gaserr, label %l12_gasok
l12_gaserr:
  store i64 55, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l12_gasok:
%l12_gas4 = add i64 %l12_gas1, -3
store i64 %l12_gas4, i64* %stack_gasleft_ptr, align 1
%l12_1 = load i64, i64* %stack_position_ptr, align 8
%l12_stack_check = icmp ult i64 %l12_1, 64
br i1 %l12_stack_check, label %l12_err1, label %l12_ok
l12_err1:
  store i64 55, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l12_ok:
%l12_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l12_1
%l12_aptr = getelementptr inbounds i8, i8* %l12_2, i64 -32
%l12_bptr = getelementptr inbounds i8, i8* %l12_aptr, i64 -32
%l12_aptr2 = bitcast i8* %l12_aptr to i256*
%l12_bptr2 = bitcast i8* %l12_bptr to i256*
%l12_a = load i256, i256* %l12_aptr2, align 1
%l12_b = load i256, i256* %l12_bptr2, align 1
%l12_cmp = icmp ugt i256 %l12_a, %l12_b
%l12_res = select i1 %l12_cmp, i256 1, i256 0
store i256 %l12_res, i256* %l12_bptr2, align 1
%l12_sdv = add i64 %l12_1, -32
store i64 %l12_sdv, i64* %stack_position_ptr, align 8

; OP 13: PUSH1 32
%l13_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l13_gas2 = icmp ult i64 %l13_gas1, 3
br i1 %l13_gas2, label %l13_gaserr, label %l13_gasok
l13_gaserr:
  store i64 56, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l13_gasok:
%l13_gas4 = add i64 %l13_gas1, -3
store i64 %l13_gas4, i64* %stack_gasleft_ptr, align 1
%l13_2 = load i64, i64* %stack_position_ptr, align 8
%l13_overflow_check = icmp ugt i64 %l13_2, 32736
br i1 %l13_overflow_check, label %l13_err_overflow, label %l13_ok
l13_err_overflow:
  store i64 56, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l13_ok:
%l13_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l13_2
%l13_4 = bitcast [1 x i8]* @const_data13 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l13_3, i8* noundef nonnull align 1 dereferenceable(32) %l13_4, i64 1, i1 false)
%l13_5 = getelementptr i8, i8* %l13_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l13_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l13_6 = add i64 %l13_2, 32
store i64 %l13_6, i64* %stack_position_ptr, align 8

; OP 14: JUMP
%l14_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l14_gas2 = icmp ult i64 %l14_gas1, 10
br i1 %l14_gas2, label %l14_gaserr, label %l14_gasok
l14_gaserr:
  store i64 58, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l14_gasok:
%l14_gas4 = add i64 %l14_gas1, -10
store i64 %l14_gas4, i64* %stack_gasleft_ptr, align 1
%l14_1 = load i64, i64* %stack_position_ptr, align 8
%l14_stack_check = icmp ult i64 %l14_1, 64
br i1 %l14_stack_check, label %l14_err1, label %l14_ok
l14_err1:
  store i64 58, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l14_ok:
%l14_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l14_1
%l14_aptr = getelementptr inbounds i8, i8* %l14_2, i64 -32
%l14_bptr = getelementptr inbounds i8, i8* %l14_aptr, i64 -32
%l14_bptr2 = bitcast i8* %l14_bptr to i256*
%l14_b = load i256, i256* %l14_bptr2, align 1
%l14_sdv = add i64 %l14_1, -64
store i64 %l14_sdv, i64* %stack_position_ptr, align 8
%l14_cmp = icmp ne i256 %l14_b, 0
br i1 %l14_cmp, label %l14_jump, label %l14_skip
l14_jump:
%l14_aptr2 = bitcast i8* %l14_aptr to i256*
%l14_a = load i256, i256* %l14_aptr2, align 1
%l14_a_trunc = trunc i256 %l14_a to i64
store i64 %l14_a_trunc, i64* %jump_target, align 1
store i64 58, i64* %pc_ptr
br label %jump_table
l14_skip:

; OP 15: PUSH1 02
%l15_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l15_gas2 = icmp ult i64 %l15_gas1, 3
br i1 %l15_gas2, label %l15_gaserr, label %l15_gasok
l15_gaserr:
  store i64 59, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l15_gasok:
%l15_gas4 = add i64 %l15_gas1, -3
store i64 %l15_gas4, i64* %stack_gasleft_ptr, align 1
%l15_2 = load i64, i64* %stack_position_ptr, align 8
%l15_overflow_check = icmp ugt i64 %l15_2, 32736
br i1 %l15_overflow_check, label %l15_err_overflow, label %l15_ok
l15_err_overflow:
  store i64 59, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l15_ok:
%l15_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l15_2
%l15_4 = bitcast [1 x i8]* @const_data15 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l15_3, i8* noundef nonnull align 1 dereferenceable(32) %l15_4, i64 1, i1 false)
%l15_5 = getelementptr i8, i8* %l15_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l15_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l15_6 = add i64 %l15_2, 32
store i64 %l15_6, i64* %stack_position_ptr, align 8

; OP 16: STOP
store i64 61, i64* %pc_ptr
br label %graceful_return

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

