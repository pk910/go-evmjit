package llvm

/*
#cgo CFLAGS: -I/usr/lib/llvm-14/include
#cgo LDFLAGS: -L/usr/lib/llvm-14/lib -lLLVM

#include <stdlib.h>
#include <llvm-c/BitWriter.h>
#include <llvm-c/BitReader.h>
#include "evm_stack.h"
#include "evm_callctx.h"
#include "evm_math.h"
#include "module.h"

*/
import "C"
import (
	"errors"
	"fmt"
	"unsafe"
)

type Module struct {
	mod    C.LLVMModuleRef
	engine C.LLVMExecutionEngineRef
	stack  *C.evm_stack
}

func init() {
	C.LLVMInitializeNativeTarget()
	C.LLVMInitializeNativeAsmPrinter()
}

func NewModule() *Module {
	return &Module{}
}

func (m *Module) LoadIR(ir string) {
	cstr := C.CString(ir)
	defer C.free(unsafe.Pointer(cstr))
	m.mod = C.parseIR(cstr)
}

func (m *Module) Dispose() {
	if m.engine != nil {
		C.LLVMDisposeExecutionEngine(m.engine)
	}
}

func (m *Module) initEngine() {
	if m.mod == nil || m.engine != nil {
		return
	}

	m.engine = C.createJIT(m.mod)
}

func (m *Module) Call(name string, gaslimit uint64) (int, error) {
	if m.engine == nil {
		m.initEngine()
		if m.engine == nil {
			return 0, errors.New("failed to create JIT engine")
		}
	}

	stack := C.stack_init(C.uint16_t(512))
	if m.stack != nil {
		C.stack_free(m.stack)
	}
	m.stack = stack

	callctx := C.callctx_init(stack, C.int(gaslimit))
	defer C.callctx_free(callctx)

	funcName := C.CString(name)
	defer C.free(unsafe.Pointer(funcName))

	fnAddr := C.LLVMGetFunctionAddress(m.engine, funcName)
	if fnAddr == 0 {
		return 0, errors.New("failed to get function address")
	}

	fmt.Printf("jit function pointer: %x\n", fnAddr)

	testFuncPtr := (C.jit_func_ptr)(unsafe.Pointer(uintptr(fnAddr)))
	retVal := C.call_jit_func(testFuncPtr, callctx)

	fmt.Printf("Result from @test: %d\n", retVal)
	fmt.Printf("  Gas left: %d\n", C.callctx_get_gas(callctx))
	fmt.Printf("  PC: %d\n", C.callctx_get_pc(callctx))

	return int(retVal), nil
}

func (m *Module) PrintStack(n int) {
	C.stack_print_item(m.stack, C.int(n))
}

func (m *Module) GetStackSize() int {
	return int(C.stack_get_size(m.stack))
}

// Marshal serializes the LLVM module to a byte slice using bitcode format.
func (m *Module) Marshal() ([]byte, error) {
	if m.mod == nil {
		return nil, errors.New("module is not loaded")
	}

	buf := C.LLVMWriteBitcodeToMemoryBuffer(m.mod)
	if buf == nil {
		return nil, errors.New("failed to write bitcode to memory buffer")
	}
	defer C.LLVMDisposeMemoryBuffer(buf)

	start := C.LLVMGetBufferStart(buf)
	size := C.LLVMGetBufferSize(buf)

	return C.GoBytes(unsafe.Pointer(start), C.int(size)), nil
}

// Unmarshal deserializes a byte slice into an LLVM module.
func (m *Module) Unmarshal(data []byte) error {
	if len(data) == 0 {
		return errors.New("cannot unmarshal empty data")
	}

	// Create a C string from the byte slice
	cdata := (*C.char)(unsafe.Pointer(&data[0]))
	bufName := C.CString("buffer")
	defer C.free(unsafe.Pointer(bufName))
	buf := C.LLVMCreateMemoryBufferWithMemoryRange(cdata, C.size_t(len(data)), bufName, 0) // 0 for no copy
	if buf == nil {
		return errors.New("failed to create memory buffer from data")
	}
	// No need to defer dispose buf here, LLVMParseBitcodeInContext consumes it

	var newMod C.LLVMModuleRef
	var errorMsg *C.char

	// Note: LLVMParseBitcodeInContext consumes the buffer, so we don't dispose it manually if successful.
	ctx := C.LLVMGetGlobalContext()
	if C.LLVMParseBitcodeInContext(ctx, buf, &newMod, &errorMsg) != 0 {
		errStr := C.GoString(errorMsg)
		C.LLVMDisposeMessage(errorMsg)
		// We need to dispose the buffer if parsing failed
		C.LLVMDisposeMemoryBuffer(buf)
		return fmt.Errorf("failed to parse bitcode: %s", errStr)
	}

	// Dispose existing module and engine if they exist
	if m.engine != nil {
		C.LLVMDisposeExecutionEngine(m.engine)
		m.engine = nil // Engine is now invalid
	}
	// Module disposal happens within LLVMDisposeExecutionEngine if JIT was created for it
	// If no engine was created, we might need to dispose m.mod here if it exists.
	// However, creating a new module implies replacing the old one, so we assign the new one.
	if m.mod != nil && m.engine == nil { // Only dispose if no engine managed it
		// Check if LLVMDisposeExecutionEngine already disposed the module linked to the engine
		// It's safer to assume the old module might need disposal if no engine was linked or if the new load replaces it.
		// Let's simplify: replacing the module means the old one is gone. If an engine existed, it handled disposal.
		// If no engine, the user is responsible or we might leak. Assigning overwrites the reference.
		// We might need LLVMDisposeModule(m.mod) here if m.engine was nil.
		// For now, let's assume assignment replaces ownership. Consider adding explicit disposal if needed.
		// Explicitly dispose the old module if it exists and wasn't tied to an engine
		C.LLVMDisposeModule(m.mod)
	}

	m.mod = newMod
	m.engine = nil // Engine needs to be re-initialized for the new module

	return nil
}
