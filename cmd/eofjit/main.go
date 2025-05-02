package main

import (
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"os"

	"github.com/pk910/go-eofjit/irgen"
	"github.com/pk910/go-eofjit/llvm"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "eofjit",
	Short: "EOFJIT development tool",
	Long:  `A CLI tool for interacting with the EOFJIT library components during development.`,
}

var buildCmd = &cobra.Command{
	Use:   "build",
	Short: "Build LLVM IR from EVM bytecode",
	Long:  `Parses EVM bytecode (provided as hex) and outputs the generated LLVM IR.`,
	Run: func(cmd *cobra.Command, args []string) {
		inputHex, _ := cmd.Flags().GetString("input")
		if inputHex == "" {
			log.Fatal("Input bytecode hex string is required via --input flag")
		}

		bytecode, err := hex.DecodeString(inputHex)
		if err != nil {
			log.Fatalf("Failed to decode input hex: %v", err)
		}

		// Assuming EVM0 for now, might need a flag later
		parser := irgen.NewParser("evm0")
		if parser == nil {
			log.Fatal("Failed to create parser for evm0")
		}

		err = parser.ParseCodeSection("main", bytecode)
		if err != nil {
			log.Fatalf("Failed to parse code section: %v", err)
		}

		irCode := parser.GenerateIR()
		fmt.Println(irCode)
	},
}

var optimizeCmd = &cobra.Command{
	Use:   "optimize",
	Short: "Optimize LLVM IR",
	Long:  `Reads LLVM IR from stdin, optimizes it, and outputs the optimized IR to stdout.`,
	Run: func(cmd *cobra.Command, args []string) {
		irBytes, err := io.ReadAll(os.Stdin)
		if err != nil {
			log.Fatalf("Failed to read IR from stdin: %v", err)
		}
		irString := string(irBytes)

		moduleRef := llvm.NewModule()
		moduleRef.LoadIR(irString)
		ir, err := moduleRef.GetIR()
		if err != nil {
			log.Fatalf("Failed to get IR: %v", err)
		}
		fmt.Println(ir)
	},
}

func init() {
	buildCmd.Flags().StringP("input", "i", "", "Hex string of the EVM bytecode")
	rootCmd.AddCommand(buildCmd)
	rootCmd.AddCommand(optimizeCmd)
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "Whoops. There was an error while executing your CLI '%s'", err)
		os.Exit(1)
	}
}
