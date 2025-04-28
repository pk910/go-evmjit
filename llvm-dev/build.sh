#!/bin/sh

evmc=./evm-c
evmll=./evm-ll
tmpout=./tmp

clang -O2 -S -emit-llvm $evmc/evm_stack.c -o $evmll/evm_stack.ll
clang -O2 -S -emit-llvm $evmc/evm_math.c -o $evmll/evm_math.ll

llvm-link $evmll/evm_stack.ll $evmll/evm_math.ll contract1-dev.ll -o $tmpout/combined.ll
clang -O2 -S -emit-llvm $tmpout/combined.ll -o $tmpout/combined.ll

lli $tmpout/combined.ll
llc -filetype=obj $tmpout/combined.ll -o $tmpout/combined.o
clang -O3 -emit-llvm -S contract1-test.ll -o $tmpout/contract1-test.o
