<h1>RISCV MIPS32 processor pipeline implementation</h1>

MIPS is 32-bit processor. MIPS32 registers: 32, 32-bit general purpose registers and a special purpose 32-bit register program counter (PC). A program counter points to the next instruction in memory to be fetched and executed.

The design consists of addressing modes such as Register, Immediate, Base addressing, PC relative and Pseudo-direct. Only load and store instructions can access memory. Assuming memory word size is 32 bits and is word addressable.

<h2>Instruction subset considered for design</h2>
<h3>Load and store instructions: </h3>
LW R2, 124(R8)
SW R5, -10(R25)

<h3>Arithmetic and logical instructions(only register operands)</h3>
ADD R1, R2, R3
ADD R1, R2, R0 //R0 register for 0
SUB R12, R10, R8
AND R20, R1, R5
OR R11, R5, R6
MUL R5, R6, R7
SLT R5, R11, R12

<h3>Immediate Insructions</h3>
ADDI R1, R2, 25
SUBI R5, R1, 150
SLTI R2, R10, 10

<h3>Branch instructions</h3>
BEQZ R1, Loop
BNEQZ R5, Label

<h3>Jump instructions</h3>
J Loop

<h3>Miscellaneous Instructions</h3>
HLT      //Halt

3 types of instructions R-type, I-type and J-type
Note: all instructions may not use all fields

R-type:
<table>
  <th>31     26</th>
  <th>25     21</th>
  <th>20     16</th>
  <th>15     11</th>
  <th>10      6</th>
  <th>5      0</th>
  <tr>opcode</tr>
  <tr>rs</tr>
  <tr>rt</tr>
  <tr>shamt</tr>
  <tr>funct</tr>
</table>
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

THe instruction cycle is divided into five stages:
IF (Instruction Fetch), ID (Instruction Decode/Register Fetch), EX (Execution/Effective Address Calculation), MEM (Memory Access/Branch Completion), WB (Register write-back)

IF:
Instruction pointed to by PC is fetched from memory and also the next value is computed. For a branch instruction, new value of the PC may be the target address. So PC is not updated in this stage, new value is stored in a register NPC.
IR <- Mem[PC];
NPC <- PC+1;

ID: 
Instruction fetched in IR is decoded
Decoding is done in parallel with reading the register operands rs and rt, similarly the immediate data are sign-extended
A <-Reg[rs];
B <- Reg[rt];
Imm <- (IR15)16 IR[15:0]
Imm1 <- (IR25)16 IR[25:0]

EX:
Exact operation depends on the instruction that is already decoded
ALU operated on operands that have already made ready in the previous cycle.
Memory reference:
ALUOut <- A+Imm;
Register Register ALU Instruction:
ALUOut <- A func B;
Register Immediate ALU Instruction:
ALUOut <- A func Imm;
Branch:
ALUOut <- NPC+Imm;
cond <- (A op 0);

MEM:
Load, store and branch instructions make use of this stage
Load and store instructions access the memory, the branch instruction updates PC depending upon the outcome of the branch condition

Load: 
PC <- NPC;
LMD <- Mem[ALUOut];

Store:
PC <- NPC;
Mem[ALUOut] <- B;

Branch:
if(cond) PC <- ALUOut;
else PC <- NPC:

WB:
Result may come from ALU or from memory system(a LOAD instruction)
Register-Register ALU Instruction: Reg[rd] <- ALUOut;

