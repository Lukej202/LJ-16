# LJ-16 — Custom 16-bit CPU

**Stage:** ISA v0.1 and working Python assembler. No CPU RTL is included yet so the datapath and FSM can be designed intentionally.

## Assemble a test program

From the project root, with Python 3 installed:

```bash
python3 assembler/assembler.py programs/countdown.asm -o programs/countdown.mem
```

This writes an Icarus-Verilog-compatible hex ROM initialization file (one 16-bit instruction per line).

## Run tests

```bash
python3 -m unittest discover -s tests -v
```

## Next steps

1. Review and agree on `docs/isa.md` (particularly bit allocations and flags).
2. Build `rtl/alu.v`, simulate with self-checking testbench.
3. Build register file, PC, ROM and RAM; wire a multicycle control FSM.
4. Run `programs/countdown.mem` on the CPU and verify R1 reaches zero.

There is no preexisting Verilog implementation of these semantics; the ISA is the hardware contract.
