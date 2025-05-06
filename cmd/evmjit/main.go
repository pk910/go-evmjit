package main

import (
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"os"

	"github.com/pk910/go-evmjit/irgen"
	"github.com/pk910/go-evmjit/llvm"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "evmjit",
	Short: "evmjit development tool",
	Long:  `A CLI tool for interacting with the evmjit library components during development.`,
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

var runCmd = &cobra.Command{
	Use:   "run",
	Short: "Run LLVM IR",
	Long:  `Reads LLVM IR from stdin, runs it, and outputs the result to stdout.`,
	Run: func(cmd *cobra.Command, args []string) {
		irBytes, err := io.ReadAll(os.Stdin)
		if err != nil {
			log.Fatalf("Failed to read IR from stdin: %v", err)
		}
		irString := string(irBytes)

		moduleRef := llvm.NewModule()
		moduleRef.LoadIR(irString)

		err = moduleRef.InitEngine()
		if err != nil {
			log.Fatalf("Failed to initialize engine: %v", err)
		}

		callctx, err := llvm.NewCallCtx(nil, 0, 10000, nil)
		if err != nil {
			log.Fatalf("Error creating call context: %v", err)
		}

		defer callctx.Dispose()

		result, err := moduleRef.Call(callctx, "main")
		if err != nil {
			log.Fatalf("Failed to call function: %v", err)
		}

		fmt.Printf("Result: %v\n", result)
	},
}

func init() {
	buildCmd.Flags().StringP("input", "i", "", "Hex string of the EVM bytecode")
	rootCmd.AddCommand(buildCmd)
	rootCmd.AddCommand(optimizeCmd)
	rootCmd.AddCommand(runCmd)
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "Whoops. There was an error while executing your CLI '%s'", err)
		os.Exit(1)
	}
}
