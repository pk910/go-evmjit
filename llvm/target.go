package llvm

/*
#include <stdlib.h>
#include <llvm-c/Core.h>
#include <llvm-c/Target.h>
#include <llvm-c/TargetMachine.h>
#include <llvm-c/Analysis.h>
*/
import "C"
import (
	"fmt"
	"unsafe"
)

// detectHostCPUAndFeatures queries the actual host CPU name and feature set.
func detectHostCPUAndFeatures() (cpu, features string) {
	// Use LLVM C API to get host CPU name and features
	cpuCStr := C.LLVMGetHostCPUName()
	featuresCStr := C.LLVMGetHostCPUFeatures()
	defer C.free(unsafe.Pointer(cpuCStr))
	defer C.free(unsafe.Pointer(featuresCStr))

	cpu = C.GoString(cpuCStr)
	features = C.GoString(featuresCStr)

	// Fallback if LLVM fails to detect
	if cpu == "" {
		cpu = "generic"
	}

	return
}

// NewNativeTargetMachine initializes and configures a target machine
// for the current host, and applies it to the given LLVM module.
func NewNativeTargetMachine() (C.LLVMTargetMachineRef, *C.char, error) {
	// Initialize native target components
	if C.LLVMInitializeNativeTarget() != 0 {
		return nil, nil, fmt.Errorf("failed to initialize native target")
	}
	if C.LLVMInitializeNativeAsmPrinter() != 0 {
		return nil, nil, fmt.Errorf("failed to initialize native asm printer")
	}

	// Get the host target triple
	triple := C.LLVMGetDefaultTargetTriple()

	// Lookup the target
	var target C.LLVMTargetRef
	var errMsg *C.char
	if C.LLVMGetTargetFromTriple(triple, &target, &errMsg) != 0 {
		err := C.GoString(errMsg)
		C.LLVMDisposeMessage(errMsg)
		return nil, nil, fmt.Errorf("LLVMGetTargetFromTriple failed: %s", err)
	}

	// Detect host CPU and features
	cpuStr, featureStr := detectHostCPUAndFeatures()
	cpu := C.CString(cpuStr)
	features := C.CString(featureStr)
	defer C.free(unsafe.Pointer(cpu))
	defer C.free(unsafe.Pointer(features))

	// Create the target machine
	tm := C.LLVMCreateTargetMachine(
		target,
		triple,
		cpu,
		features,
		C.LLVMCodeGenLevelAggressive,
		C.LLVMRelocDefault,
		C.LLVMCodeModelDefault,
	)
	if tm == nil {
		return nil, nil, fmt.Errorf("failed to create target machine")
	}

	return tm, triple, nil
}

func SetupTargetMachine(mod C.LLVMModuleRef, triple *C.char, tm C.LLVMTargetMachineRef) {
	// Set the module's target triple and data layout
	C.LLVMSetTarget(mod, triple)
	layout := C.LLVMCreateTargetDataLayout(tm)
	C.LLVMSetModuleDataLayout(mod, layout)
}
