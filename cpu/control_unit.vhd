-- Katie Pucci
-- COE1502:: CPU
-- Control Unit

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY control_unit IS
    -- Define ports
    -- Inputs::
    --   opcode - opcode of instruction (31-26)
    -- Outputs::
    --   pcSrc - determines which PC value to use for next cycle
    --      0 - PC + 4
    --      1 - PC + 4 + branch
    --   flush - determines if the instruction in the IF/ID reg needs discarded due to branching
    --      0 - don't flush
    --      1 - flush
    --   regWrite - controls writing to the register file in the ID stage
    --      0 - don't write
    --      1 - write
    --   regDst - determines where the write register destination number comes from
    --      0 - rt field (20-16)
    --      1 - rd field (15-11)
    --   aluSrc - determines where the second ALU operand comes from
    --      0 - readData2 of register file
    --      1 - sign-extended immediate value
    --   aluOp - determines the type of instruction and the necessary alu action
    --   memRead - controls reading of the data memory
    --      0 - don't read
    --      1 - read
    --   memWrite - controls writing of the data memory
    --      0 - don't write
    --      1 - write
    --   memToReg - determines which value to write to register file
    --      0 - ALU output
    --      1 - value read from data memory
    PORT (
        opcode   : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        pcSrc    : OUT STD_LOGIC;
        flush    : OUT STD_LOGIC;
        regWrite : OUT STD_LOGIC;
        regDst   : OUT STD_LOGIC;
        aluSrc   : OUT STD_LOGIC;
        aluOp    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        memRead  : OUT STD_LOGIC;
        memWrite : OUT STD_LOGIC;
        memToReg : OUT STD_LOGIC
    );

END control_unit;

ARCHITECTURE Behavioral OF control_unit IS


BEGIN
    -- Process for writing to a register
    PROCESS (opcode)
    BEGIN

    END PROCESS;



END Behavioral;
