#!/bin/sh


export CGO_CFLAGS=$(llvm-config --cflags)
export CGO_LDFLAGS="$(llvm-config --ldflags) $(llvm-config --libs core orcjit native)"

