RISCV MIPS32 processor pipeline implementation

MIPS is 32-bit processor

MIPS32 registers: 32, 32-bit general purpose registers and a special purpose 32-bit register program counter (PC). 
A program counter points to the next instruction in memory to be fetched and executed.

The design consists of addressing modes such as Register, Immediate, Base addressing, PC relative and Pseudo-direct. Only load and store instructions can access memory.
Assuming memory word size is 32 bits and is word addressable

Instruction subset considered for design:
Load and store instructions: LW R2, 124(R8)
SW R5, -10(R25)
Arithmetic and logical instructions(only register operands)
ADD R1, R2, R3
ADD R1, R2, R0 //R0 register for 0
SUB R12, R10, R8
AND R20, R1, R5
OR R11, R5, R6
MUL R5, R6, R7
SLT R5, R11, R12

Immediate Insructions
ADDI R1, R2, 25
SUBI R5, R1, 150
SLTI R2, R10, 10

Branch instructions
BEQZ R1, Loop
BNEQZ R5, Label

Jump instructions
J Loop

Miscellaneous Instructions
HLT      //Halt

3 types of instructions R-type, I-type and J-type
Note: all instructions may not use all fields

R-type:
31     26 25    21 20     16 15     11 10     6 5           0
  opcode     rs        rt        rd      shamt      funct

Instruction opcode (6 bits)
ADD 000000
SUB 000001
AND 000010
OR 000011
SLT 000100
MUL 000101
HLT 111111
  
I-type: It contains a 16-bit immediate data
31     26 25    21 20     16 15                             0
  opcode     rs        rt             immediate data

Instruction opcode (6 bits)
LW 001000
SW 001001
ADDI 001010
SUBI 001011
SLTI 001100
BNEQZ 001101
BEQZ 001110
  
J-type: It contains a 26-bit jump address field
31     26 25                                                 0
  opcode           immediate data (26 bit jump address)

Instruction opcode (6 bits)
J 010000

16-bit and 26-bit immediate data are retrieved and sign extended to 32-bits. In 16-bit the MSB (15) is extended upto bit 31 and in 26-bit the MSB (25) is extended upto bit 31.


