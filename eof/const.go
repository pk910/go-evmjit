package eof

// EOF format constants
const (
	Magic = 0xEF00

	Version1 = 0x01

	KindTypes     = 0x01
	KindCode      = 0x02
	KindContainer = 0x03 // Optional section kind
	KindData      = 0xff
	Terminator    = 0x00

	MinHeaderSize                      = 15 // Minimum size with no container sections
	MinHeaderSizeWithContainerSections = 19 // Minimum size with container sections present (includes kind, num, and at least one size)

	MaxInitCodeSize = 49152 // From EIP-3860

	MaxTypesSize            = 0x1000     // 4096 bytes
	MaxCodeSections         = 0x0400     // 1024 sections
	MaxContainerSections    = 0x0100     // 256 sections
	MaxCodeSectionSize      = 0xFFFF     // 65535 bytes
	MaxContainerSectionSize = 0xFFFFFFFF // ~4GB (practically limited by MaxInitCodeSize)
	MaxDataSectionSize      = 0xFFFF     // 65535 bytes
)
