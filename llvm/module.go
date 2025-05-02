package llvm

/*
#cgo CFLAGS: -I/usr/lib/llvm-14/include
#cgo LDFLAGS: -L/usr/lib/llvm-14/lib -lLLVM

#include <stdlib.h>
#include <llvm-c/BitWriter.h>
#include <llvm-c/BitReader.h>
#include "module.h"

*/
import "C"
import (
	"errors"
	"fmt"
	"log"
	"unsafe"
)

type Module struct {
	mod    C.LLVMModuleRef
	engine C.LLVMExecutionEngineRef
	fnaddr map[string]C.jit_func_ptr
}

var (
	nativeTarget C.LLVMTargetMachineRef
	nativeTriple *C.char
)

func init() {
	var err error
	nativeTarget, nativeTriple, err = NewNativeTargetMachine()
	if err != nil {
		log.Fatalf("Failed to initialize native target: %v", err)
	}
}

func GetNativeTarget() (C.LLVMTargetMachineRef, *C.char) {
	return nativeTarget, nativeTriple
}

func NewModule() *Module {
	return &Module{
		fnaddr: make(map[string]C.jit_func_ptr),
	}
}

func (m *Module) LoadIR(ir string) error {
	cstr := C.CString(ir)
	defer C.free(unsafe.Pointer(cstr))

	var errorObj error
	var errorMsg *C.char
	m.mod = C.parseIR(cstr, &errorMsg)
	if errorMsg != nil {
		errorObj = fmt.Errorf("LLVM error: %s", C.GoString(errorMsg))
		C.disposeError(&errorMsg)
		return errorObj
	}

	SetupTargetMachine(m.mod, nativeTriple, nativeTarget)

	C.optimizeModule(m.mod)
	return nil
}

func (m *Module) Dispose() {
	if m.engine != nil {
		C.LLVMDisposeExecutionEngine(m.engine)
	}
}

func (m *Module) InitEngine() error {
	if m.mod == nil || m.engine != nil {
		return nil
	}

	var errorMsg *C.char
	m.engine = C.createJIT(m.mod, &errorMsg)
	if errorMsg != nil {
		errorObj := fmt.Errorf("LLVM error: %s", C.GoString(errorMsg))
		C.disposeError(&errorMsg)
		return errorObj
	}

	return nil
}

func (m *Module) getFnAddr(name string) (C.jit_func_ptr, error) {
	funcName := C.CString(name)
	defer C.free(unsafe.Pointer(funcName))

	fnAddr := C.LLVMGetFunctionAddress(m.engine, funcName)
	if fnAddr == 0 {
		return nil, errors.New("failed to get function address")
	}

	fnaddr := (C.jit_func_ptr)(unsafe.Pointer(uintptr(fnAddr)))

	return fnaddr, nil
}

func (m *Module) Call(callctx *CallCtx, name string) (int, error) {
	if m.engine == nil {
		err := m.InitEngine()
		if err != nil {
			return 0, err
		}
	}

	fnaddr, found := m.fnaddr[name]
	if !found {
		fnaddr2, err := m.getFnAddr(name)
		if err != nil {
			return 0, err
		}

		m.fnaddr[name] = fnaddr2
		fnaddr = fnaddr2
	}

	fmt.Printf("jit function pointer: %x\n", fnaddr)

	retVal := C.call_jit_func(fnaddr, callctx.callctx)

	fmt.Printf("Result from @test: %d\n", retVal)
	fmt.Printf("  Gas left: %d\n", callctx.GetGas())
	fmt.Printf("  PC: %d\n", callctx.GetPC())

	return int(retVal), nil
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

	if m.engine != nil {
		C.LLVMDisposeExecutionEngine(m.engine)
		m.engine = nil
	}
	if m.mod != nil && m.engine == nil {
		C.LLVMDisposeModule(m.mod)
	}

	m.mod = newMod
	m.engine = nil // Engine needs to be re-initialized for the new module

	return nil
}

func (m *Module) GetIR() (string, error) {
	if m.mod == nil {
		return "", errors.New("module is not loaded")
	}

	buf := C.LLVMPrintModuleToString(m.mod)
	if buf == nil {
		return "", errors.New("failed to write bitcode to memory buffer")
	}

	ir := C.GoString(buf)
	defer C.LLVMDisposeMessage(buf)

	return ir, nil
}
