# LJ-16 ISA v0.1 — provisional encoding, implementation contract

This is a **working proposal** for RTL development, not an immutable ISA. If we change a field, update the assembler, RTL decoder, and tests together.

## Core

- Sixteen-bit **fixed-width instructions**, one word per instruction.
- Eight 16-bit general-purpose registers, `R0`–`R7` (all writable).
- One 16-bit special constant register `CR`, initially `0x0000` after reset.
- Sixteen-bit program counter, **word-addressed**; normal fetch increments PC by 1 modulo 65536.
- Separate instruction ROM and data RAM, both 16-bit **word-addressed**. Logical address space is 0x0000..0xFFFF in each. Initially implement 256 words each; accesses outside physical RAM/ROM must be detected or defined before final integration (do not silently truncate addresses).
- The control unit is a multicycle FSM; no pipeline in v0.1.

## Bit layouts (bit 15 is leftmost)

| Kind | Bits 15:11 | Bits 10:8 | Bits 7:5 | Bits 4:2 | Bit 1 | Bit 0 |
|---|---|---|---|---|---|---|
| R-type (`ADD`/`SUB`/`AND`/`OR`/`XOR`) | opcode | destination | source A | source B | B is CR | 0 |
| Unary (`NOT`/`SHL`/`SHR`/`MOV`) | opcode | destination | source | 000 | source is CR | 0 |
| Memory (`LOAD`/`STORE`) | opcode | dest/value | address reg | 000 | 0 | 0 |
| Jump (`JMP`/`BEQ`/`BNE`) | opcode | target reg | 000 | 000 | target is CR | 0 |
| `LDCL`/`LDCH` | opcode | 000 | immediate[7:5] | immediate[4:2] | immediate[1] | immediate[0] |
| `NOP`/`HALT` | opcode | 000 | 000 | 000 | 0 | 0 |

*The `LDCL`/`LDCH` format means bits 10:8 are reserved and bits 7:0 form the immediate byte.*

### Opcodes (five bits)

| Binary | Hex | Mnemonic | Semantics |
|---|---|---|---|
| 00000 | 00 | NOP | No state change except normal PC progress |
| 00001 | 01 | HALT | Stop instruction execution until reset |
| 00010 | 02 | ADD Rd, Ra, Rb/CR | Rd ← Ra + B, modulo 2^16 |
| 00011 | 03 | SUB Rd, Ra, Rb/CR | Rd ← Ra − B, modulo 2^16 |
| 00100 | 04 | AND Rd, Ra, Rb/CR | Rd ← Ra & B |
| 00101 | 05 | OR Rd, Ra, Rb/CR | Rd ← Ra \| B |
| 00110 | 06 | XOR Rd, Ra, Rb/CR | Rd ← Ra ^ B |
| 00111 | 07 | NOT Rd, Rs/CR | Rd ← ~source |
| 01000 | 08 | SHL Rd, Rs/CR | Rd ← source << 1 (discard top bit) |
| 01001 | 09 | SHR Rd, Rs/CR | Rd ← source >> 1, logical (insert zero) |
| 01010 | 0A | MOV Rd, Rs/CR | Rd ← source |
| 01011 | 0B | LDCL imm8 | CR[7:0] ← imm8; CR[15:8] unchanged |
| 01100 | 0C | LDCH imm8 | CR[15:8] ← imm8; CR[7:0] unchanged |
| 01101 | 0D | LOAD Rd, Raddr | Rd ← RAM[Raddr] |
| 01110 | 0E | STORE Rvalue, Raddr | RAM[Raddr] ← Rvalue |
| 01111 | 0F | JMP Rtarget/CR | PC ← target |
| 10000 | 10 | BEQ Rtarget/CR | If Z=1, PC ← target; else normal PC |
| 10001 | 11 | BNE Rtarget/CR | If Z=0, PC ← target; else normal PC |

The remaining opcodes `0x12`..`0x1F` are unassigned. We have **18 instructions and 14 free primary opcode values**. A dedicated `NEG` or arithmetic right shift (`SAR`) can be considered later, but is **not** encoded in v0.1.

### Flags

- The ALU instructions (`ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`) update **Z** to 1 iff the 16-bit result is zero.
- Other instructions leave Z unchanged; initial Z after reset is **0**.
- `BEQ`/`BNE` check the stored Z flag, not registers directly. Convention: perform an ALU operation (often `SUB`) immediately before a conditional branch.
- Carry/negative/overflow may be added to the hardware later; v0.1 branches depend **only on Z**.
- Subtraction is 16-bit two's complement: `Ra + (~B) + 1`. Signed and unsigned arithmetic share the same result bits.

### Assembly syntax

- Registers are `R0`–`R7`, and the special constant operand is `CR` where supported.
- `LDCL` and `LDCH` numeric operands are unsigned bytes (`0`..`255`, `0x00`..`0xFF`). Or supply a **label**; `LDCL label` emits the low byte of its ROM word address, `LDCH label` emits the high byte.
- A jump **cannot** use a label as an operand directly. Load its address into CR with `LDCL label` / `LDCH label`, then use `JMP CR`, or copy the address to a register and jump through it.
- Labels are case-insensitive, followed by `:`. All instructions and `.word` occupy exactly one ROM word.
- `.word 0x1234` emits raw word `1234` (useful for debug/data in ROM; it is not executed unless fetched).
- `;`, `#`, and `//` begin comments.
- No macros, expression parser, or implicit load of large constants yet.

### Examples

```asm
ADD R3, R1, R2     ; [15:11]=00010; Rd=3, Ra=1, Rb=2, CR=0
ADD R3, R1, CR     ; same, with bit 1 set
LDCL 0xCD
LDCH 0xAB            ; CR = 0xABCD
MOV R1, CR
```

### ROM initialization

The Python assembler outputs one 4-digit uppercase hex word per line. Example RTL-side loading:

```verilog
reg [15:0] rom [0:255];
initial $readmemh("programs/countdown.mem", rom);
```

Run the simulator from the repository root to keep this relative path valid. ROM depth is currently 256 and the assembler rejects larger programs by default.
