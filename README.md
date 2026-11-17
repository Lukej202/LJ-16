# LJ-16 — Custom 16-bit CPU

## Overview

The LJ-16 is a custom 16-bit multicycle processor designed from scratch in Verilog. This independent engineering project explores computer architecture, RTL design, functional verification, and FPGA implementation.

The long-term goal is to develop a standalone computing system featuring a custom processor, instruction set architecture (ISA), assembler, peripheral controllers, and lightweight operating system (LJ-OS).

## Architecture

| Specification | Description |
|---|---|
| Architecture | 16-bit Harvard architecture |
| Execution model | Multicycle |
| Instruction width | 16 bits |
| Opcode width | 5 bits |
| Address width | 16 bits |
| General-purpose registers | 15 |
| Constant register | 1 (R15) |
| Instruction memory | 4,096 × 16 bits (8 KiB) |
| Data memory | 4,096 × 16 bits (8 KiB) |
| HDL | Verilog |
| Simulation | Icarus Verilog |
| Target hardware | FPGA |

## Current Development Status

The project is currently under active development. Individual datapath components have been implemented and have passed initial functional simulations.

- [x] 16-bit arithmetic logic unit (ALU)
- [x] Register file
- [x] Program counter
- [x] Instruction memory
- [x] Instruction-fetch subsystem
- [x] Data memory
- [x] Initial Python assembler
- [ ] Finalize ISA and opcode mapping
- [ ] Multicycle control unit FSM
- [ ] Full CPU integration
- [ ] Automated regression testing
- [ ] FPGA synthesis and implementation
- [ ] UART communication
- [ ] Peripheral controllers
- [ ] LJ-OS

## Repository Structure

```text
LJ-16/
├── rtl/          # Verilog hardware modules
├── tb/           # Verilog testbenches
├── assembler/    # Python assembler
├── programs/     # Assembly programs and memory images
├── docs/         # ISA and architecture documentation
├── tests/        # Python tests
└── README.md
```

## Simulation

The project uses Icarus Verilog for functional simulation.

Example: compile and simulate the ALU from the project root.

```bash
iverilog -g2012 -Wall -s alu_tb \
    -o alu_sim rtl/alu.v tb/alu_tb.v

vvp alu_sim
```

## Assembler

The Python assembler converts LJ-16 assembly instructions into hexadecimal memory initialization files.

```bash
python3 assembler/assembler.py programs/countdown.asm -o programs/countdown.mem
```

The assembler is provisional and will be updated to match the finalized CPU instruction encoding.

## Assembler Tests

```bash
python3 -m unittest discover -s tests -v
```

## Long-Term Goals

- Develop a fully functional custom 16-bit processor.
- Implement and verify the processor on physical FPGA hardware.
- Design a UART controller from scratch in Verilog.
- Develop a Python-based processor emulator and debugging interface.
- Implement a lightweight operating system in LJ-16 assembly.
- Build a standalone computing system with external peripherals.

## Author

Luke Jennings

Master of Engineering — Computer Engineering  
University of Cincinnati

## Project Status

Work in progress — actively developed as an independent digital hardware engineering project.