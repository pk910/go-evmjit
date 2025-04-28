; EVM Stack Implementation in LLVM IR

@stack_ptr = global i8* null   ; Pointer to stack memory
@stack_pointer = global i32 0  ; Current stack size
@stack_capacity = global i32 0 ; Current allocated slots

declare i8* @malloc(i32)
declare i8* @realloc(i8*, i32)
declare void @free(i8*)
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i1)

; Initialize stack with 256 slots
define void @init_stack() {
entry:
  %bytes = mul i32 256, 32
  %mem = call i8* @malloc(i32 %bytes)
  store i8* %mem, i8** @stack_ptr
  store i32 256, i32* @stack_capacity
  ret void
}

; Free stack
define void @free_stack() {
entry:
  %stack_base = load i8*, i8** @stack_ptr
  call void @free(i8* %stack_base)
  store i8* null, i8** @stack_ptr
  store i32 0, i32* @stack_pointer
  store i32 0, i32* @stack_capacity
  ret void
}

; Grow stack when capacity is reached
define void @grow_stack() {
entry:
  %old_cap = load i32, i32* @stack_capacity
  %new_cap = mul i32 %old_cap, 2
  %new_bytes = mul i32 %new_cap, 32
  %old_ptr = load i8*, i8** @stack_ptr
  %new_ptr = call i8* @realloc(i8* %old_ptr, i32 %new_bytes)
  store i8* %new_ptr, i8** @stack_ptr
  store i32 %new_cap, i32* @stack_capacity
  ret void
}

; Push a 256-bit value onto the stack
define void @push_stack(i8* %value_ptr) {
entry:
  %sp = load i32, i32* @stack_pointer
  %cap = load i32, i32* @stack_capacity
  %need_grow = icmp eq i32 %sp, %cap
  br i1 %need_grow, label %grow, label %continue

grow:
  call void @grow_stack()
  br label %continue

continue:
  %stack_base = load i8*, i8** @stack_ptr
  %offset = mul i32 %sp, 32
  %dst_ptr = getelementptr i8, i8* %stack_base, i32 %offset
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dst_ptr, i8* %value_ptr, i32 32, i1 false)
  %new_sp = add i32 %sp, 1
  store i32 %new_sp, i32* @stack_pointer
  ret void
}

; Pop last item from the stack
define void @pop_stack() {
entry:
  %sp = load i32, i32* @stack_pointer
  %new_sp = sub i32 %sp, 1
  store i32 %new_sp, i32* @stack_pointer
  ret void
}

; DUPN: Duplicate Nth stack item
define void @dupn_stack(i32 %n) {
entry:
  %sp = load i32, i32* @stack_pointer
  %cap = load i32, i32* @stack_capacity
  %need_grow = icmp eq i32 %sp, %cap
  br i1 %need_grow, label %grow, label %copy

grow:
  call void @grow_stack()
  br label %copy

copy:
  %new_sp = load i32, i32* @stack_pointer
  %src_idx = sub i32 %new_sp, %n
  %stack_base = load i8*, i8** @stack_ptr
  %src_offset = mul i32 %src_idx, 32
  %dst_offset = mul i32 %new_sp, 32

  %src_ptr = getelementptr i8, i8* %stack_base, i32 %src_offset
  %dst_ptr = getelementptr i8, i8* %stack_base, i32 %dst_offset
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dst_ptr, i8* %src_ptr, i32 32, i1 false)

  %final_sp = add i32 %new_sp, 1
  store i32 %final_sp, i32* @stack_pointer
  ret void
}

; SWAPN: Swap top with Nth item
define void @swapn_stack(i32 %n) {
entry:
  %sp = load i32, i32* @stack_pointer
  %top_idx = sub i32 %sp, 1
  %nth_idx_calc = add i32 %n, 1
  %nth_idx = sub i32 %sp, %nth_idx_calc

  %stack_base = load i8*, i8** @stack_ptr
  %top_offset = mul i32 %top_idx, 32
  %nth_offset = mul i32 %nth_idx, 32

  %top_ptr = getelementptr i8, i8* %stack_base, i32 %top_offset
  %nth_ptr = getelementptr i8, i8* %stack_base, i32 %nth_offset

  %tmp = alloca [32 x i8]
  %tmp_i8 = bitcast [32 x i8]* %tmp to i8*

  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %tmp_i8, i8* %top_ptr, i32 32, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %top_ptr, i8* %nth_ptr, i32 32, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %nth_ptr, i8* %tmp_i8, i32 32, i1 false)

  ret void
}

@const_push32_1 = constant [32 x i8] c"\AB\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF"
@const_push32_2 = constant [32 x i8] c"\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA"







@.hex_fmt = private constant [6 x i8] c"%02X\20\00"
@.newline = private constant [2 x i8] c"\0A\00"
declare i32 @printf(i8*, ...)

; Debug function to print the Nth stack item
define void @print_stack_item(i32 %n) {
entry:
  %sp = load i32, i32* @stack_pointer
  %nth_idx = sub i32 %sp, %n

  %stack_base = load i8*, i8** @stack_ptr
  %offset = mul i32 %nth_idx, 32
  %item_ptr = getelementptr i8, i8* %stack_base, i32 %offset

  ; Loop through 32 bytes
  br label %loop

loop:
  %i = phi i32 [0, %entry], [%next, %loop]
  %byte_ptr = getelementptr i8, i8* %item_ptr, i32 %i
  %byte = load i8, i8* %byte_ptr
  %fmt_ptr = getelementptr [6 x i8], [6 x i8]* @.hex_fmt, i32 0, i32 0
  call i32 (i8*, ...) @printf(i8* %fmt_ptr, i8 %byte)

  %next = add i32 %i, 1
  %cond = icmp slt i32 %next, 32
  br i1 %cond, label %loop, label %end

end:
  %nl_ptr = getelementptr [2 x i8], [2 x i8]* @.newline, i32 0, i32 0
  call i32 (i8*, ...) @printf(i8* %nl_ptr)
  ret void
}

; Main function for testing
define i32 @main() {
entry:
  call void @init_stack()

  %ptr1 = bitcast [32 x i8]* @const_push32_1 to i8*
  call void @push_stack(i8* %ptr1)

  %ptr2 = bitcast [32 x i8]* @const_push32_2 to i8*
  call void @push_stack(i8* %ptr2)

  call void @dupn_stack(i32 2)
  call void @dupn_stack(i32 2)
  
  call void @print_stack_item(i32 1)
  call void @print_stack_item(i32 2)
  call void @print_stack_item(i32 3)
  call void @print_stack_item(i32 4)

  call void @swapn_stack(i32 1)
  call void @dupn_stack(i32 1)

  call void @print_stack_item(i32 1)
  call void @print_stack_item(i32 2)
  call void @print_stack_item(i32 3)
  call void @print_stack_item(i32 4)

  ;call void @print_stack_item(i32 1)

  ;call void @dupn_stack(i32 2)
  ;call void @print_stack_item(i32 3)

  
  ;call void @swapn(i32 3)

  call void @free_stack()

  

  ret i32 0
}
