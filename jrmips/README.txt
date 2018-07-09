Katie Pucci, kev19@pitt.edu

------Signal Descriptions------
main circuit:
  OpCode - instruction opcode, bits 15-12 (4 bits)
  Rs - source operand, bits 11-9 (3 bits)
  Rt - target operand (for R-type instructions), bits 8-6 (3 bits)
  Imm - immediate (for I-type instructions), bits 8-1 (8 bits)
  SubOp - instruction subop, bit 0 (1 bit)

  Clk - clock signal (1 bit)

  W_En1 - register write enable control signal for first write address (1 bit)
  W_En2 - register write enable control signal for second write address (1 bit)

  MemWrite - data memory write enable control signal (1 bit)
  MemRead - data memory read enable control signal (1 bit)

  Halt - halt operation control signal; disables the program counter (1 bit)
  Put - put operation control signal (1 bit)

  ALU - ALU control signal (4 bits)
  ALU_A - control signal for mux connected to the first ALU input (1 bit)
    Mux operation: If ALU_A = 0, output first read address data
                   Else output second read address data (for lw and sw)

  ALU_B - control signal for mux connected to the second ALU input (2 bits)
    Mux operation: If ALU_B = 00, output second read address data
                   Else If ALU_B = 01, output sign extension result
                   Else If ALU_B = 10, output 0x0 (for zero comparisons)
                   Else output 0xFF (for lw and sw)

  PC - program counter control signal (2 bits)
    Mux operation: If PC = 00, output PC+1
                   Else If PC = 01
                     If ALU_Result[0] = 0, output PC+1
                     Else output Imm (for zero comparison functions)
                   Else If PC = 10, output Imm (for jal and j instructions)
                   Else output first read address data (for jr instruction)

  Write1 - control signal for mux connected to first write data port (2 bits)
    Mux operation: If Write1 = 00, output ALU_Result
                   Else If Write1 = 01, output sign-extension result (for li instruction)
                   Else If Write1 = 10, output data memory output (for lw)
                   Else output PC+1 (for jal instruction)

  S_Ext - control signal for sign-extend function (1 bit)

  ALU_Result - result of ALU (16 bits)
  Upper_Bits - upper bits of multiplication/division (16 bits)
  Rs+1 - source operand + 1 for multiplication and division

  PC+1 - next program instruction address (8 bits)
  R_Data1 - data read from first register file read data port (16 bits)
  Mem_Data - data read from data memory (16 bits)
  Extend - sign extended immediate value (16 bits)

RegFile:
  Read_Register1 - address of first register to read (3 bits)
  Read_Register2 - address of second register to read (3 bits)
  Write_Register1 (WriteReg1 tunnel) - address of first register to write (3 bits)
  Write_Register2 (WriteReg2 tunnel) - address of second register to write (3 bits)
  writeEnable1 (W_En1 tunnel) - control signal for first write data port (1 bit)
  writeEnable2 (W_En2 tunnel) - control signal for second write data port (1 bit)
  Read_Data1 - data to read from first read address (16 bits)
  Read_Data2 - data to read from second read address (16 bits)
  Write_Data1 - data to write to first write address (16 bits)
  Write_Data2 - data to write to second write address (16 bits)
  Data_Reg[111...000] - selected data to write to specified register (16 bits)
  En_Reg[111...000] - selected enable control signal for specified register (1 bit)
  Clock - clock signal (1 bit)

ALU:
  A - first ALU input data (16 bits)
  B - second ALU input data (16 bits)
  ALU_Op - ALU function selection signal (4 bits)
  ALU_Result - result of ALU function (16 bits)
  Mul_Upper - upper bits of multiplication result to be stored in paired register (16 bits)
  Div_Upper - upper bits of division result to be stored in paired register (16 bits)
  Mul/Div Upper - selected output of multiplication/division result (16 bits)

Control:
  OpCode - instruction opcode, bits 15-12 (4 bits)
  OpCode[3..0] - individual bits of OpCode (1 bit)
  SubOp - instruction subop, bit 0 (1 bit)

  Write_Enable1 (W_En1 tunnel) - register write enable control signal for first write address (1 bit)
    Boolean equation: W_En1 = O3'O2' + O1'O0' + O2'O1'S' + O3'O1O0S'

  Write_Enable2 (W_En2) - register write enable control signal for second write address (1 bit)
    Boolean equation: W_En2 = O3'O2'O1O0

  MemWrite - data memory write enable control signal (1 bit)
    Boolean equation: MemWrite = O2O1O0S

  MemRead - data memory read enable control signal (1 bit)
    Boolean equation: MemRead = O2O1O0S'

  Halt - halt operation control signal; disables the program counter (1 bit)
    Boolean equation: Halt = (O3O1)' + (O0S)'

  Put - put operation control signal (1 bit)
    Boolean equation: Put = O3O1O0S'

  ALU - ALU control signal (4 bits)
    Boolean equation: ALU = O2O1O0S

  ALU_A - control signal for mux connected to the first ALU input (1 bit)
    Boolean equation: ALU_A = O3'O2O1O0

  ALU_B - control signal for mux connected to the second ALU input (2 bits)
    Boolean equation: ALU_B1 = O3'O2(O1+O0)
                      ALU_B0 = O3'O0(O2 XNOR O1)

  PC - program counter control signal (2 bits)
    Boolean equation: PC = O2(O0 XOR O1) + O3O1'O0S

  Write_Data1 (Write1 tunnel) - control signal for mux connected to first write data port (2 bits)
    Boolean equation: Write1_1 = O2O1
                      Write1_0 = O3

  Sign_Extend (S_Ext tunnel) - control signal for sign-extend function (1 bit)
    Boolean equation: S_Ext = O3'S'

SignExt:
  Imm - immediate (for I-type instructions), bits 8-1 (8 bits)

  SignExt - control signal for mux (1 bit)
    Mux operation: If SignExt = 0, zero extend Imm
                   Else If SignExt = 1,
                     Sign extend Imm based on Imm[7]

  Output - sign-extended output (16 bits)
----------------------------------------------------

------Tested Functions------------------------------
~~Example Program 1:~~
    li $r1,0
    # increment from 0 to 15
    # lowest hex digit will cycle from '0' to 'F'
    loop0: put $r1,0 # output current value
           addi $r1,1 # increment value by 1
           mov $r2,$r1 # check for loop end
           addi $r2,-16 # end of loop?
           bn $r2,loop0
           halt

    Instruction file:
      8200
      B200
      1202
      2481
      2400
      15E0
      6403
      B001

    Result: Functioned as expected

~~Example Program 2:~~
    .data
    a: 10
    b: 0
    .text
    la $r1,a
    lw $r2,$r1
    loop: add $r3,$r2
          addi $r2,-1
          bp $r2,loop
          la $r1,b
          sw $r3,$r1
          lw $r4,$r1
          put $r4,0 # answer should be 0x37
          halt

    Instruction file:
      8200
      7440
      2680
      15FE
      6404
      8202
      7641
      7840
      B800
      B001

    Data file:
      000a
      0000

    Result: Functioned as expected

~~Multiplication Test:~~
    li $r0, 0
    li $r1, 4
    li $r2, 6
    mul $r2, $r1
    sw $r2, $r0
    lw $r0, $r0
    put $r0
    halt

    Instruction file:
      8000
      8208
      840c
      3441
      7401
      7000
      b000
      b001

    Result: Functioned as expected

~~Division Test:~~
    li $r0, 0
    put $r0
    li $r1, 6
    put $r1
    li $r2, 3
    put $r2
    div $r1, $r2
    sw $r1, $r0
    lw $r0, $r0
    put $r0
    halt

    Instruction file:
    8000
    b000
    820c
    b200
    8406
    b400
    3280
    7201
    7000
    b000
    b001

~~AND and NOR Test:~~
    li $r0, 1011        1000 0000 0001 0110  8016
    li $r1, 1101        1000 0010 0001 1010  821a
    and $r1, $r0 (1001) 0000 0010 0000 0000  0200
    put $r1             1011 0010 0000 0000  b200
    li $r1, 1010        1000 0010 0001 0100  8214
    nor $r1, $r0 (0100) 0000 0010 0000 0001  0201
    put $r1             1011 0010 0000 0000  b200
    halt                1011 0000 0000 0001  b001

    Instruction file:
      8016
      821a
      0200
      b200
      8214
      0201
      b200
      b001
