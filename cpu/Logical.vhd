-- Katie Pucci
-- COE1502:: CPU
-- ALU Logical Unit

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY Logical IS
    PORT (
        A        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        B        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALUOp    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        LogicalR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE Structural OF Logical IS

    -- Internal signals
    SIGNAL ANDR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL NORR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ORR  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL XORR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
BEGIN
    ANDR <= A AND B;
    ORR <= A OR B;
    XORR <= A XOR B;
    NORR <= A NOR B;

    LogicalR <= ANDR when ALUOp="00" else
                ORR when ALUOp="01" else
                XORR when ALUOP="10" else
                NORR;

END Structural;
