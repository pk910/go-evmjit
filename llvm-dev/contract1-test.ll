
%struct.evm_callctx = type { %struct.evm_stack*, i64, i64, i32 (i8*, i8, i8*, i16, i8*, i16, i64*)*, i8* }
%struct.evm_stack = type { i8*, i64 }
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
declare i128 @llvm.bswap.i128(i128)
declare i32 @llvm.ctlz.i256(i256, i1 immarg)
@const_zero32 = constant [32 x i8] c"\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"

@const_data0 = constant [32 x i8] c"\01\02\05\04\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\16\14\21"
@const_data1 = constant [1 x i8] c"\02"
@const_data2 = constant [8 x i8] c"\11\11\11\11\11\11\11\11"
@const_data5 = constant [1 x i8] c"\32"
@const_data9 = constant [2 x i8] c"\00\0a"
@const_data12 = constant [1 x i8] c"\32"
@const_data14 = constant [1 x i8] c"\02"

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

; OP 0 (pc: 0): PUSH32 2114160101010101010101010101010101010101010101010101010104050201
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

; OP 1 (pc: 33): PUSH1 02
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

; OP 2 (pc: 35): PUSH8 1111111111111111
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

; OP 3 (pc: 44): SWAP2
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

; OP 4 (pc: 45): SWAP1
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

; OP 5 (pc: 46): PUSH1 32
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

; OP 6 (pc: 48): JUMP
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

; OP 7 (pc: 49): SHL
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
; OP 8 (pc: 50): JUMPDEST
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
; OP 9 (pc: 51): PUSH2 0a00
%l9_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l9_gas2 = icmp ult i64 %l9_gas1, 3
br i1 %l9_gas2, label %l9_gaserr, label %l9_gasok
l9_gaserr:
  store i64 51, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l9_gasok:
%l9_gas4 = add i64 %l9_gas1, -3
store i64 %l9_gas4, i64* %stack_gasleft_ptr, align 1
%l9_2 = load i64, i64* %stack_position_ptr, align 8
%l9_overflow_check = icmp ugt i64 %l9_2, 32736
br i1 %l9_overflow_check, label %l9_err_overflow, label %l9_ok
l9_err_overflow:
  store i64 51, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l9_ok:
%l9_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l9_2
%l9_4 = bitcast [2 x i8]* @const_data9 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l9_3, i8* noundef nonnull align 1 dereferenceable(32) %l9_4, i64 2, i1 false)
%l9_5 = getelementptr i8, i8* %l9_3, i32 2
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l9_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 30, i1 false)
%l9_6 = add i64 %l9_2, 32
store i64 %l9_6, i64* %stack_position_ptr, align 8

; OP 10 (pc: 54): PC
%l10_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l10_gas2 = icmp ult i64 %l10_gas1, 2
br i1 %l10_gas2, label %l10_gaserr, label %l10_gasok
l10_gaserr:
  store i64 54, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l10_gasok:
%l10_gas4 = add i64 %l10_gas1, -2
store i64 %l10_gas4, i64* %stack_gasleft_ptr, align 1
%l10_1 = load i64, i64* %stack_position_ptr, align 8
%l10_overflow_check = icmp ugt i64 %l10_1, 32736
br i1 %l10_overflow_check, label %l10_err_overflow, label %l10_ok
l10_err_overflow:
  store i64 54, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l10_ok:
%l10_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l10_1
%l10_aptr2 = bitcast i8* %l10_2 to i256*
%l10_3 = load i64, i64* %stack_gasleft_ptr, align 8
%l10_4 = zext i64 %l10_3 to i256
store i256 %l10_4, i256* %l10_aptr2, align 1
%l10_6 = add i64 %l10_1, 32
store i64 %l10_6, i64* %stack_position_ptr, align 8

; OP 11 (pc: 55): GT
%l11_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l11_gas2 = icmp ult i64 %l11_gas1, 3
br i1 %l11_gas2, label %l11_gaserr, label %l11_gasok
l11_gaserr:
  store i64 55, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l11_gasok:
%l11_gas4 = add i64 %l11_gas1, -3
store i64 %l11_gas4, i64* %stack_gasleft_ptr, align 1
%l11_1 = load i64, i64* %stack_position_ptr, align 8
%l11_stack_check = icmp ult i64 %l11_1, 64
br i1 %l11_stack_check, label %l11_err1, label %l11_ok
l11_err1:
  store i64 55, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l11_ok:
%l11_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l11_1
%l11_aptr = getelementptr inbounds i8, i8* %l11_2, i64 -32
%l11_bptr = getelementptr inbounds i8, i8* %l11_aptr, i64 -32
%l11_aptr2 = bitcast i8* %l11_aptr to i256*
%l11_bptr2 = bitcast i8* %l11_bptr to i256*
%l11_a = load i256, i256* %l11_aptr2, align 1
%l11_b = load i256, i256* %l11_bptr2, align 1
%l11_cmp = icmp ugt i256 %l11_a, %l11_b
%l11_res = select i1 %l11_cmp, i256 1, i256 0
store i256 %l11_res, i256* %l11_bptr2, align 1
%l11_sdv = add i64 %l11_1, -32
store i64 %l11_sdv, i64* %stack_position_ptr, align 8

; OP 12 (pc: 56): PUSH1 32
%l12_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l12_gas2 = icmp ult i64 %l12_gas1, 3
br i1 %l12_gas2, label %l12_gaserr, label %l12_gasok
l12_gaserr:
  store i64 56, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l12_gasok:
%l12_gas4 = add i64 %l12_gas1, -3
store i64 %l12_gas4, i64* %stack_gasleft_ptr, align 1
%l12_2 = load i64, i64* %stack_position_ptr, align 8
%l12_overflow_check = icmp ugt i64 %l12_2, 32736
br i1 %l12_overflow_check, label %l12_err_overflow, label %l12_ok
l12_err_overflow:
  store i64 56, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l12_ok:
%l12_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l12_2
%l12_4 = bitcast [1 x i8]* @const_data12 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l12_3, i8* noundef nonnull align 1 dereferenceable(32) %l12_4, i64 1, i1 false)
%l12_5 = getelementptr i8, i8* %l12_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l12_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l12_6 = add i64 %l12_2, 32
store i64 %l12_6, i64* %stack_position_ptr, align 8

; OP 13 (pc: 58): JUMP
%l13_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l13_gas2 = icmp ult i64 %l13_gas1, 10
br i1 %l13_gas2, label %l13_gaserr, label %l13_gasok
l13_gaserr:
  store i64 58, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l13_gasok:
%l13_gas4 = add i64 %l13_gas1, -10
store i64 %l13_gas4, i64* %stack_gasleft_ptr, align 1
%l13_1 = load i64, i64* %stack_position_ptr, align 8
%l13_stack_check = icmp ult i64 %l13_1, 64
br i1 %l13_stack_check, label %l13_err1, label %l13_ok
l13_err1:
  store i64 58, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l13_ok:
%l13_2 = getelementptr inbounds i8, i8* %stack_addr, i64 %l13_1
%l13_aptr = getelementptr inbounds i8, i8* %l13_2, i64 -32
%l13_bptr = getelementptr inbounds i8, i8* %l13_aptr, i64 -32
%l13_bptr2 = bitcast i8* %l13_bptr to i256*
%l13_b = load i256, i256* %l13_bptr2, align 1
%l13_sdv = add i64 %l13_1, -64
store i64 %l13_sdv, i64* %stack_position_ptr, align 8
%l13_cmp = icmp ne i256 %l13_b, 0
br i1 %l13_cmp, label %l13_jump, label %l13_skip
l13_jump:
%l13_aptr2 = bitcast i8* %l13_aptr to i256*
%l13_a = load i256, i256* %l13_aptr2, align 1
%l13_a_trunc = trunc i256 %l13_a to i64
store i64 %l13_a_trunc, i64* %jump_target, align 1
store i64 58, i64* %pc_ptr
br label %jump_table
l13_skip:

; OP 14 (pc: 59): PUSH1 02
%l14_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l14_gas2 = icmp ult i64 %l14_gas1, 3
br i1 %l14_gas2, label %l14_gaserr, label %l14_gasok
l14_gaserr:
  store i64 59, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l14_gasok:
%l14_gas4 = add i64 %l14_gas1, -3
store i64 %l14_gas4, i64* %stack_gasleft_ptr, align 1
%l14_2 = load i64, i64* %stack_position_ptr, align 8
%l14_overflow_check = icmp ugt i64 %l14_2, 32736
br i1 %l14_overflow_check, label %l14_err_overflow, label %l14_ok
l14_err_overflow:
  store i64 59, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l14_ok:
%l14_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l14_2
%l14_4 = bitcast [1 x i8]* @const_data14 to i8*
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l14_3, i8* noundef nonnull align 1 dereferenceable(32) %l14_4, i64 1, i1 false)
%l14_5 = getelementptr i8, i8* %l14_3, i32 1
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l14_5, i8* noundef nonnull align 1 dereferenceable(32) %zero32_ptr, i64 31, i1 false)
%l14_6 = add i64 %l14_2, 32
store i64 %l14_6, i64* %stack_position_ptr, align 8

; OP 15 (pc: 61): SWAP1
%l15_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
%l15_gas2 = icmp ult i64 %l15_gas1, 3
br i1 %l15_gas2, label %l15_gaserr, label %l15_gasok
l15_gaserr:
  store i64 61, i64* %pc_ptr
  store i32 -13, i32* %exitcode_ptr
  br label %error_return
l15_gasok:
%l15_gas4 = add i64 %l15_gas1, -3
store i64 %l15_gas4, i64* %stack_gasleft_ptr, align 1
%l15_1 = load i64, i64* %stack_position_ptr, align 8
%l15_underflow_check = icmp ult i64 %l15_1, 64
br i1 %l15_underflow_check, label %l15_err_underflow, label %l15_ok
l15_err_underflow:
  store i64 61, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l15_ok:
%l15_2 = alloca [32 x i8], align 16
%l15_3 = getelementptr inbounds i8, i8* %stack_addr, i64 %l15_1
%l15_4 = getelementptr inbounds i8, i8* %l15_3, i64 -32
%l15_5 = shl nsw i32 1, 5
%l15_6 = sext i32 %l15_5 to i64
%l15_7 = sub nsw i64 0, %l15_6
%l15_8 = getelementptr inbounds i8, i8* %l15_4, i64 %l15_7
%l15_9 = getelementptr inbounds [32 x i8], [32 x i8]* %l15_2, i64 0, i64 0
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %l15_9, i8* noundef nonnull align 1 dereferenceable(32) %l15_4, i64 32, i1 false)
tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l15_4, i8* noundef nonnull align 1 dereferenceable(32) %l15_8, i64 32, i1 false)
call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l15_8, i8* noundef nonnull align 16 dereferenceable(32) %l15_9, i64 32, i1 false)

; OP 16 (pc: 62): c10 (Generic Callback)
%l16_in_buffer_alloca = alloca i8, i64 64, align 32
%l16_in_stack_pos = load i64, i64* %stack_position_ptr
%l16_in_stack_check1 = icmp ult i64 %l16_in_stack_pos, 64
br i1 %l16_in_stack_check1, label %l16_err_underflow, label %l16_in_ok1
l16_err_underflow:
  store i64 62, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l16_in_ok1:
%l16_in_stack_read_pos = sub i64 %l16_in_stack_pos, 64
%l16_in_stack_read_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l16_in_stack_read_pos
%l16_in_src_ptr_0 = getelementptr i8, i8* %l16_in_stack_read_ptr, i64 0
%l16_in_dst_ptr_0 = getelementptr i8, i8* %l16_in_buffer_alloca, i64 0 ; Use alloca buffer ptr
%l16_in_src_ptr_lo_0 = bitcast i8* %l16_in_src_ptr_0 to i128*
%l16_in_src_ptr_hi_0 = getelementptr i128, i128* %l16_in_src_ptr_lo_0, i32 1
%l16_in_dst_ptr_lo_0 = bitcast i8* %l16_in_dst_ptr_0 to i128*
%l16_in_dst_ptr_hi_0 = getelementptr i128, i128* %l16_in_dst_ptr_lo_0, i32 1
%l16_in_word_lo_0 = load i128, i128* %l16_in_src_ptr_lo_0
%l16_in_word_hi_0 = load i128, i128* %l16_in_src_ptr_hi_0
%l16_in_reversed_lo_0 = call i128 @llvm.bswap.i128(i128 %l16_in_word_hi_0)
%l16_in_reversed_hi_0 = call i128 @llvm.bswap.i128(i128 %l16_in_word_lo_0)
store i128 %l16_in_reversed_lo_0, i128* %l16_in_dst_ptr_lo_0
store i128 %l16_in_reversed_hi_0, i128* %l16_in_dst_ptr_hi_0
%l16_in_src_ptr_1 = getelementptr i8, i8* %l16_in_stack_read_ptr, i64 32
%l16_in_dst_ptr_1 = getelementptr i8, i8* %l16_in_buffer_alloca, i64 32 ; Use alloca buffer ptr
%l16_in_src_ptr_lo_1 = bitcast i8* %l16_in_src_ptr_1 to i128*
%l16_in_src_ptr_hi_1 = getelementptr i128, i128* %l16_in_src_ptr_lo_1, i32 1
%l16_in_dst_ptr_lo_1 = bitcast i8* %l16_in_dst_ptr_1 to i128*
%l16_in_dst_ptr_hi_1 = getelementptr i128, i128* %l16_in_dst_ptr_lo_1, i32 1
%l16_in_word_lo_1 = load i128, i128* %l16_in_src_ptr_lo_1
%l16_in_word_hi_1 = load i128, i128* %l16_in_src_ptr_hi_1
%l16_in_reversed_lo_1 = call i128 @llvm.bswap.i128(i128 %l16_in_word_hi_1)
%l16_in_reversed_hi_1 = call i128 @llvm.bswap.i128(i128 %l16_in_word_lo_1)
store i128 %l16_in_reversed_lo_1, i128* %l16_in_dst_ptr_lo_1
store i128 %l16_in_reversed_hi_1, i128* %l16_in_dst_ptr_hi_1
%l16_new_evm_stack_pos_after_in = sub i64 %l16_in_stack_pos, 64
store i64 %l16_new_evm_stack_pos_after_in, i64* %stack_position_ptr, align 8
%l16_out_buffer_alloca = alloca i8, i64 32, align 32
%l16_out_stack_pos = load i64, i64* %stack_position_ptr
%l16_overflow_check = icmp ugt i64 %l16_out_stack_pos, 32736
br i1 %l16_overflow_check, label %l16_err_overflow, label %l16_out_ok1
l16_err_overflow:
  store i64 62, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l16_out_ok1:
store i64 62, i64* %pc_ptr
%l16_opcode_fn_ptr_addr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 3
%l16_opcode_fn_ptr = load i32 (i8*, i8, i8*, i16, i8*, i16, i64*)*, i32 (i8*, i8, i8*, i16, i8*, i16, i64*)** %l16_opcode_fn_ptr_addr, align 8
%l16_callctx_ptr_arg = bitcast %struct.evm_callctx* %callctx to i8*
%l16_call_ret = call i32 %l16_opcode_fn_ptr(
    i8* %l16_callctx_ptr_arg,
    i8 10,
    i8* %l16_in_buffer_alloca,
    i16 64,
    i8* %l16_out_buffer_alloca,
    i16 32,
    i64* %stack_gasleft_ptr
)
%l16_call_ret_check = icmp ne i32 %l16_call_ret, 0
br i1 %l16_call_ret_check, label %l16_err_callback, label %l16_callback_ok
l16_err_callback:
  ret i32 %l16_call_ret
l16_callback_ok:
%l16_evm_stack_write_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l16_out_stack_pos
%l16_out_src_ptr_0 = getelementptr i8, i8* %l16_out_buffer_alloca, i64 0
%l16_out_dst_ptr_0 = getelementptr i8, i8* %l16_evm_stack_write_ptr, i64 0
%l16_out_src_ptr_lo_0 = bitcast i8* %l16_out_src_ptr_0 to i128*
%l16_out_src_ptr_hi_0 = getelementptr i128, i128* %l16_out_src_ptr_lo_0, i32 1
%l16_out_dst_ptr_lo_0 = bitcast i8* %l16_out_dst_ptr_0 to i128*
%l16_out_dst_ptr_hi_0 = getelementptr i128, i128* %l16_out_dst_ptr_lo_0, i32 1
%l16_out_word_lo_0 = load i128, i128* %l16_out_src_ptr_lo_0
%l16_out_word_hi_0 = load i128, i128* %l16_out_src_ptr_hi_0
%l16_out_reversed_lo_0 = call i128 @llvm.bswap.i128(i128 %l16_out_word_hi_0)
%l16_out_reversed_hi_0 = call i128 @llvm.bswap.i128(i128 %l16_out_word_lo_0)
store i128 %l16_out_reversed_lo_0, i128* %l16_out_dst_ptr_lo_0
store i128 %l16_out_reversed_hi_0, i128* %l16_out_dst_ptr_hi_0
%l16_new_evm_stack_pos_after_out = add i64 %l16_out_stack_pos, 32
store i64 %l16_new_evm_stack_pos_after_out, i64* %stack_position_ptr, align 8

; OP 17 (pc: 63): c10 (Generic Callback)
%l17_in_buffer_alloca = alloca i8, i64 64, align 32
%l17_in_stack_pos = load i64, i64* %stack_position_ptr
%l17_in_stack_check1 = icmp ult i64 %l17_in_stack_pos, 64
br i1 %l17_in_stack_check1, label %l17_err_underflow, label %l17_in_ok1
l17_err_underflow:
  store i64 63, i64* %pc_ptr
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
l17_in_ok1:
%l17_in_stack_read_pos = sub i64 %l17_in_stack_pos, 64
%l17_in_stack_read_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l17_in_stack_read_pos
%l17_in_src_ptr_0 = getelementptr i8, i8* %l17_in_stack_read_ptr, i64 0
%l17_in_dst_ptr_0 = getelementptr i8, i8* %l17_in_buffer_alloca, i64 0 ; Use alloca buffer ptr
%l17_in_src_ptr_lo_0 = bitcast i8* %l17_in_src_ptr_0 to i128*
%l17_in_src_ptr_hi_0 = getelementptr i128, i128* %l17_in_src_ptr_lo_0, i32 1
%l17_in_dst_ptr_lo_0 = bitcast i8* %l17_in_dst_ptr_0 to i128*
%l17_in_dst_ptr_hi_0 = getelementptr i128, i128* %l17_in_dst_ptr_lo_0, i32 1
%l17_in_word_lo_0 = load i128, i128* %l17_in_src_ptr_lo_0
%l17_in_word_hi_0 = load i128, i128* %l17_in_src_ptr_hi_0
%l17_in_reversed_lo_0 = call i128 @llvm.bswap.i128(i128 %l17_in_word_hi_0)
%l17_in_reversed_hi_0 = call i128 @llvm.bswap.i128(i128 %l17_in_word_lo_0)
store i128 %l17_in_reversed_lo_0, i128* %l17_in_dst_ptr_lo_0
store i128 %l17_in_reversed_hi_0, i128* %l17_in_dst_ptr_hi_0
%l17_in_src_ptr_1 = getelementptr i8, i8* %l17_in_stack_read_ptr, i64 32
%l17_in_dst_ptr_1 = getelementptr i8, i8* %l17_in_buffer_alloca, i64 32 ; Use alloca buffer ptr
%l17_in_src_ptr_lo_1 = bitcast i8* %l17_in_src_ptr_1 to i128*
%l17_in_src_ptr_hi_1 = getelementptr i128, i128* %l17_in_src_ptr_lo_1, i32 1
%l17_in_dst_ptr_lo_1 = bitcast i8* %l17_in_dst_ptr_1 to i128*
%l17_in_dst_ptr_hi_1 = getelementptr i128, i128* %l17_in_dst_ptr_lo_1, i32 1
%l17_in_word_lo_1 = load i128, i128* %l17_in_src_ptr_lo_1
%l17_in_word_hi_1 = load i128, i128* %l17_in_src_ptr_hi_1
%l17_in_reversed_lo_1 = call i128 @llvm.bswap.i128(i128 %l17_in_word_hi_1)
%l17_in_reversed_hi_1 = call i128 @llvm.bswap.i128(i128 %l17_in_word_lo_1)
store i128 %l17_in_reversed_lo_1, i128* %l17_in_dst_ptr_lo_1
store i128 %l17_in_reversed_hi_1, i128* %l17_in_dst_ptr_hi_1
%l17_new_evm_stack_pos_after_in = sub i64 %l17_in_stack_pos, 64
store i64 %l17_new_evm_stack_pos_after_in, i64* %stack_position_ptr, align 8
%l17_out_buffer_alloca = alloca i8, i64 32, align 32
%l17_out_stack_pos = load i64, i64* %stack_position_ptr
%l17_overflow_check = icmp ugt i64 %l17_out_stack_pos, 32736
br i1 %l17_overflow_check, label %l17_err_overflow, label %l17_out_ok1
l17_err_overflow:
  store i64 63, i64* %pc_ptr
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
l17_out_ok1:
store i64 63, i64* %pc_ptr
%l17_opcode_fn_ptr_addr = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %callctx, i64 0, i32 3
%l17_opcode_fn_ptr = load i32 (i8*, i8, i8*, i16, i8*, i16, i64*)*, i32 (i8*, i8, i8*, i16, i8*, i16, i64*)** %l17_opcode_fn_ptr_addr, align 8
%l17_callctx_ptr_arg = bitcast %struct.evm_callctx* %callctx to i8*
%l17_call_ret = call i32 %l17_opcode_fn_ptr(
    i8* %l17_callctx_ptr_arg,
    i8 10,
    i8* %l17_in_buffer_alloca,
    i16 64,
    i8* %l17_out_buffer_alloca,
    i16 32,
    i64* %stack_gasleft_ptr
)
%l17_call_ret_check = icmp ne i32 %l17_call_ret, 0
br i1 %l17_call_ret_check, label %l17_err_callback, label %l17_callback_ok
l17_err_callback:
  ret i32 %l17_call_ret
l17_callback_ok:
%l17_evm_stack_write_ptr = getelementptr inbounds i8, i8* %stack_addr, i64 %l17_out_stack_pos
%l17_out_src_ptr_0 = getelementptr i8, i8* %l17_out_buffer_alloca, i64 0
%l17_out_dst_ptr_0 = getelementptr i8, i8* %l17_evm_stack_write_ptr, i64 0
%l17_out_src_ptr_lo_0 = bitcast i8* %l17_out_src_ptr_0 to i128*
%l17_out_src_ptr_hi_0 = getelementptr i128, i128* %l17_out_src_ptr_lo_0, i32 1
%l17_out_dst_ptr_lo_0 = bitcast i8* %l17_out_dst_ptr_0 to i128*
%l17_out_dst_ptr_hi_0 = getelementptr i128, i128* %l17_out_dst_ptr_lo_0, i32 1
%l17_out_word_lo_0 = load i128, i128* %l17_out_src_ptr_lo_0
%l17_out_word_hi_0 = load i128, i128* %l17_out_src_ptr_hi_0
%l17_out_reversed_lo_0 = call i128 @llvm.bswap.i128(i128 %l17_out_word_hi_0)
%l17_out_reversed_hi_0 = call i128 @llvm.bswap.i128(i128 %l17_out_word_lo_0)
store i128 %l17_out_reversed_lo_0, i128* %l17_out_dst_ptr_lo_0
store i128 %l17_out_reversed_hi_0, i128* %l17_out_dst_ptr_hi_0
%l17_new_evm_stack_pos_after_out = add i64 %l17_out_stack_pos, 32
store i64 %l17_new_evm_stack_pos_after_out, i64* %stack_position_ptr, align 8

; OP 18 (pc: 64): STOP
store i64 64, i64* %pc_ptr
br label %graceful_return

br label %graceful_return
graceful_return:

%out_1 = load i64, i64* %heap_stack_position_ptr, align 8
%out_2 = getelementptr inbounds i8, i8* %heap_stack_addr, i64 %out_1
%out_3 = load i64, i64* %stack_position_ptr
%out_stack_check1 = icmp ult i64 %out_3, 64
br i1 %out_stack_check1, label %out_err1, label %out_ok1
out_err1:
  store i32 -10, i32* %exitcode_ptr
  br label %error_return
out_ok1:
%out_stack_check2 = icmp ugt i64 %out_1, 8128
br i1 %out_stack_check2, label %out_err2, label %out_ok2
out_err2:
  store i32 -11, i32* %exitcode_ptr
  br label %error_return
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
%res_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
store i64 %res_gas1, i64* %gasleft_ptr
ret i32 0
error_return:
%exitcode_val = load i32, i32* %exitcode_ptr, align 4
%err_gas1 = load i64, i64* %stack_gasleft_ptr, align 8
store i64 %err_gas1, i64* %gasleft_ptr
ret i32 %exitcode_val
}

