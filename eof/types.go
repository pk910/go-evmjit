package eof

// Container represents a full EOF v1 container.
type ContainerV1 struct {
	Header HeaderV1

	// Body Sections
	Types      []TypeSectionEntry // Parsed from types_section data, length must equal Header.NumCodeSections
	Codes      [][]byte           // Code sections content, length must equal Header.NumCodeSections
	Containers [][]byte           // Optional container sections content, length must equal *Header.NumContainerSections if present
	Data       []byte             // Data section content
}

// Header defines the structure of the EOF container header.
type HeaderV1 struct {
	// Types Section Info (KindTypes = 0x01)
	TypesSize uint16 // Size of the types section content in bytes (divisible by 4)

	// Code Section Info (KindCode = 0x02)
	NumCodeSections  uint16   // Number of code sections (must equal TypesSize / 4)
	CodeSectionSizes []uint16 // Sizes of each code section content in bytes

	// Container Section Info (Optional, KindContainer = 0x03)
	NumContainerSections  uint16   // Number of container sections.
	ContainerSectionSizes []uint32 // Sizes of each container section content in bytes.

	// Data Section Info (KindData = 0xff)
	DataSize uint16 // Size of the data section content in bytes
}

// TypeSectionEntry defines the metadata for a single code section.
type TypeSectionEntry struct {
	Inputs           uint8  // Number of stack elements consumed (0x00-0x7F)
	Outputs          uint8  // Number of stack elements returned (0x00-0x7F) or 0x80 for non-returning
	MaxStackIncrease uint16 // Maximum stack height increase (0x0000-0x03FF)
}
