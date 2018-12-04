-- Katie Pucci
-- COE1502: CPU
-- ALU Arithmetic Unit

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Arithmetic IS
    -- Inputs::
    --      A - input value #1
    --      B - input value #2
    --      aluCtrl - bits 2-1 of alu control input
    -- Outputs::
    --      ArithmeticR - output value of operation
    --      CarryOut - carry out bit of operation
    --      Overflow - detects if the result is larger than 32 bits
    --      Zero - detects if the output of the operation is zero
    PORT(
        a           : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        b           : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        aluCtrl     : IN STD_LOGIC_VECTOR (1  DOWNTO 0);
        arithmeticR : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        carryOut    : OUT STD_LOGIC;
        overflow    : OUT STD_LOGIC;
        zero        : OUT STD_LOGIC
    );

END Arithmetic;

ARCHITECTURE Structural OF Arithmetic IS

    -- Define adder component
    COMPONENT add32
    PORT (
        A   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        B   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        CI  : IN STD_LOGIC;
        CO  : OUT STD_LOGIC;
        OFL : OUT STD_LOGIC;
        S   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Internal signals
    SIGNAL BTEMP : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL OFL   : STD_LOGIC;
    SIGNAL S     : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    BTEMP <= b WHEN aluCtrl(1) = '0' ELSE NOT(b);

    overflow <= OFL and NOT(aluCtrl(0));

    arithmeticR <= S;
    zero <= NOT(S(31) OR S(30) OR S(29) OR S(28) OR S(27) OR S(26) OR S(25)
    OR S(24) OR S(23) OR S(22) OR S(21) OR S(20) OR S(19) OR S(18) OR S(17)
    OR S(16) OR S(15) OR S(14) OR S(13) OR S(12) OR S(11) OR S(10) OR S(9)
    OR S(8) OR S(7) OR S(6) OR S(5) OR S(4) OR S(3) OR S(2) OR S(1) OR S(0));


    -- Instantiate adder
    ADD : add32
    PORT MAP (
        A   => a,
        B   => BTEMP,
        CI  => aluCtrl(1),
        CO  => carryOut,
        OFL => OFL,
        S   => S
    );

END Structural;
