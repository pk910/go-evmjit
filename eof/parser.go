package eof

import (
	"encoding/binary"
	"errors"
	"fmt"
)

var (
	ErrInvalidMagic                = errors.New("invalid EOF magic number")
	ErrUnsupportedVersion          = errors.New("unsupported EOF version")
	ErrShortBytecodeHeader         = errors.New("bytecode too short for header")
	ErrShortBytecode               = errors.New("bytecode too short for declared sections")
	ErrInvalidKindMarker           = errors.New("invalid or unexpected kind marker")
	ErrInvalidSectionSize          = errors.New("invalid section size")
	ErrInvalidTypesSectionSize     = errors.New("types_size must be > 0 and divisible by 4")
	ErrCodeSectionMismatch         = errors.New("num_code_sections must equal types_size / 4")
	ErrZeroCodeSections            = errors.New("num_code_sections cannot be zero")
	ErrZeroContainerSections       = errors.New("num_container_sections cannot be zero when container section is present")
	ErrInvalidCodeSectionSize      = errors.New("code_size must be > 0")
	ErrInvalidContainerSectionSize = errors.New("container_size must be > 0")
	ErrMissingTerminator           = errors.New("missing header terminator")
	ErrExtraneousData              = errors.New("extraneous data after declared sections")
	ErrInvalidTypeEntry            = errors.New("invalid type section entry value")
)

// ParseEOF parses the given bytecode into a versioned EOF container.
func ParseEOF(bytecode []byte) (byte, interface{}, error) {
	if len(bytecode) < 3 {
		return 0, nil, ErrShortBytecodeHeader
	}

	// Check magic bytes
	if binary.BigEndian.Uint16(bytecode[0:2]) != Magic {
		return 0, nil, ErrInvalidMagic
	}

	// Check version
	version := bytecode[2]
	switch version {
	case Version1:
		container, err := parseV1(bytecode)
		return version, container, err
	default:
		return version, nil, fmt.Errorf("%w: %d", ErrUnsupportedVersion, version)
	}
}

// parseV1 handles parsing of EOF version 1 containers.
func parseV1(bytecode []byte) (*ContainerV1, error) {
	offset := 3 // Start after magic and version

	readUint16 := func() (uint16, error) {
		if offset+2 > len(bytecode) {
			return 0, ErrShortBytecodeHeader
		}
		val := binary.BigEndian.Uint16(bytecode[offset : offset+2])
		offset += 2
		return val, nil
	}

	readUint32 := func() (uint32, error) {
		if offset+4 > len(bytecode) {
			return 0, ErrShortBytecodeHeader
		}
		val := binary.BigEndian.Uint32(bytecode[offset : offset+4])
		offset += 4
		return val, nil
	}

	readByte := func() (byte, error) {
		if offset+1 > len(bytecode) {
			return 0, ErrShortBytecodeHeader
		}
		val := bytecode[offset]
		offset++
		return val, nil
	}

	var header HeaderV1

	// 1. Types Section Size
	kindTypes, err := readByte()
	if err != nil {
		return nil, err
	}
	if kindTypes != KindTypes {
		return nil, fmt.Errorf("%w: expected KindTypes (0x%02X), got 0x%02X", ErrInvalidKindMarker, KindTypes, kindTypes)
	}
	header.TypesSize, err = readUint16()
	if err != nil {
		return nil, err
	}
	if header.TypesSize == 0 || header.TypesSize%4 != 0 {
		return nil, ErrInvalidTypesSectionSize
	}
	if header.TypesSize > MaxTypesSize {
		return nil, fmt.Errorf("%w: types_size %d > max %d", ErrInvalidSectionSize, header.TypesSize, MaxTypesSize)
	}

	// 2. Code Sections
	kindCode, err := readByte()
	if err != nil {
		return nil, err
	}
	if kindCode != KindCode {
		return nil, fmt.Errorf("%w: expected KindCode (0x%02X), got 0x%02X", ErrInvalidKindMarker, KindCode, kindCode)
	}
	header.NumCodeSections, err = readUint16()
	if err != nil {
		return nil, err
	}
	if header.NumCodeSections == 0 {
		return nil, ErrZeroCodeSections
	}
	if header.NumCodeSections != header.TypesSize/4 {
		return nil, ErrCodeSectionMismatch
	}
	if header.NumCodeSections > MaxCodeSections {
		return nil, fmt.Errorf("%w: num_code_sections %d > max %d", ErrInvalidSectionSize, header.NumCodeSections, MaxCodeSections)
	}

	header.CodeSectionSizes = make([]uint16, header.NumCodeSections)
	totalCodeSize := uint64(0)
	for i := range header.CodeSectionSizes {
		size, err := readUint16()
		if err != nil {
			return nil, err
		}
		if size == 0 {
			return nil, fmt.Errorf("%w at index %d", ErrInvalidCodeSectionSize, i)
		}
		if size > MaxCodeSectionSize {
			return nil, fmt.Errorf("%w: code_size[%d] %d > max %d", ErrInvalidSectionSize, i, size, MaxCodeSectionSize)
		}
		header.CodeSectionSizes[i] = size
		totalCodeSize += uint64(size)
	}

	// 3. Optional Container Sections
	var totalContainerSize uint64
	if offset < len(bytecode) && bytecode[offset] == KindContainer {
		offset++ // Consume KindContainer marker
		numContainers, err := readUint16()
		if err != nil {
			return nil, err
		}
		if numContainers == 0 {
			return nil, ErrZeroContainerSections
		}
		if numContainers > MaxContainerSections {
			return nil, fmt.Errorf("%w: num_container_sections %d > max %d", ErrInvalidSectionSize, numContainers, MaxContainerSections)
		}
		header.NumContainerSections = numContainers

		header.ContainerSectionSizes = make([]uint32, numContainers)
		for i := range header.ContainerSectionSizes {
			size, err := readUint32()
			if err != nil {
				return nil, err
			}
			// Size 0 might be valid for future use cases, but spec says 1+
			if size == 0 {
				return nil, fmt.Errorf("%w at index %d", ErrInvalidContainerSectionSize, i)
			}
			// Max check implicitly handled by uint32 and MaxInitCodeSize check later
			header.ContainerSectionSizes[i] = size
			totalContainerSize += uint64(size)
		}
	} else {
		// No container sections
		header.NumContainerSections = 0
		header.ContainerSectionSizes = nil
	}

	// 4. Data Section Size
	kindData, err := readByte()
	if err != nil {
		return nil, err
	}
	if kindData != KindData {
		return nil, fmt.Errorf("%w: expected KindData (0x%02X), got 0x%02X", ErrInvalidKindMarker, KindData, kindData)
	}
	header.DataSize, err = readUint16()
	if err != nil {
		return nil, err
	}
	if header.DataSize > MaxDataSectionSize {
		return nil, fmt.Errorf("%w: data_size %d > max %d", ErrInvalidSectionSize, header.DataSize, MaxDataSectionSize)
	}

	// 5. Terminator
	terminator, err := readByte()
	if err != nil {
		return nil, err
	}
	if terminator != Terminator {
		return nil, ErrMissingTerminator
	}

	headerEndOffset := offset

	// --- Body Parsing ---
	container := &ContainerV1{Header: header}
	bodyOffset := headerEndOffset
	expectedBodySize := uint64(header.TypesSize) + totalCodeSize + totalContainerSize + uint64(header.DataSize)
	actualBodySize := uint64(len(bytecode) - bodyOffset)

	if actualBodySize < expectedBodySize {
		return nil, ErrShortBytecode
	}
	// Allow extraneous data for now, maybe add strict mode later?
	// if actualBodySize > expectedBodySize {
	// 	return nil, ErrExtraneousData
	// }

	// Check total size against MaxInitCodeSize
	if uint64(len(bytecode)) > MaxInitCodeSize {
		return nil, fmt.Errorf("total container size %d exceeds MaxInitCodeSize %d", len(bytecode), MaxInitCodeSize)
	}

	// Parse Types Section
	if uint64(bodyOffset)+uint64(header.TypesSize) > uint64(len(bytecode)) {
		return nil, fmt.Errorf("%w: not enough bytes for types section (expected %d)", ErrShortBytecode, header.TypesSize)
	}
	container.Types = make([]TypeSectionEntry, header.NumCodeSections)
	typesBytes := bytecode[bodyOffset : bodyOffset+int(header.TypesSize)]
	bodyOffset += int(header.TypesSize)
	for i := 0; i < int(header.NumCodeSections); i++ {
		entryOffset := i * 4
		inputs := typesBytes[entryOffset]
		outputs := typesBytes[entryOffset+1]
		maxStack := binary.BigEndian.Uint16(typesBytes[entryOffset+2 : entryOffset+4])

		// Validate type entry values based on spec ranges
		if inputs > 0x7F {
			return nil, fmt.Errorf("%w: inputs 0x%X > 0x7F at index %d", ErrInvalidTypeEntry, inputs, i)
		}
		if outputs > 0x80 {
			return nil, fmt.Errorf("%w: outputs 0x%X > 0x80 at index %d", ErrInvalidTypeEntry, outputs, i)
		}
		if maxStack > 0x03FF {
			return nil, fmt.Errorf("%w: max_stack_increase 0x%X > 0x03FF at index %d", ErrInvalidTypeEntry, maxStack, i)
		}

		container.Types[i] = TypeSectionEntry{
			Inputs:           inputs,
			Outputs:          outputs,
			MaxStackIncrease: maxStack,
		}
	}

	// Parse Code Sections
	container.Codes = make([][]byte, header.NumCodeSections)
	for i := 0; i < int(header.NumCodeSections); i++ {
		size := int(header.CodeSectionSizes[i])
		if uint64(bodyOffset)+uint64(size) > uint64(len(bytecode)) {
			return nil, fmt.Errorf("%w: not enough bytes for code section %d (expected %d)", ErrShortBytecode, i, size)
		}
		container.Codes[i] = make([]byte, size)
		copy(container.Codes[i], bytecode[bodyOffset:bodyOffset+size])
		bodyOffset += size
	}

	// Parse Container Sections (if present)
	if header.NumContainerSections > 0 {
		numContainers := int(header.NumContainerSections)
		container.Containers = make([][]byte, numContainers)
		for i := 0; i < numContainers; i++ {
			size := int(header.ContainerSectionSizes[i])
			if uint64(bodyOffset)+uint64(size) > uint64(len(bytecode)) {
				return nil, fmt.Errorf("%w: not enough bytes for container section %d (expected %d)", ErrShortBytecode, i, size)
			}
			container.Containers[i] = make([]byte, size)
			copy(container.Containers[i], bytecode[bodyOffset:bodyOffset+size])
			bodyOffset += size
		}
	} else {
		container.Containers = nil
	}

	// Parse Data Section
	size := int(header.DataSize)
	if uint64(bodyOffset)+uint64(size) > uint64(len(bytecode)) {
		size = len(bytecode) - bodyOffset
	}
	container.Data = make([]byte, size)
	copy(container.Data, bytecode[bodyOffset:bodyOffset+size])
	bodyOffset += size

	if bodyOffset < len(bytecode) {
		return nil, ErrExtraneousData
	}

	return container, nil
}
