-- Katie Pucci
-- COE1502: CPU
-- ALU Shifter Unit

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY Shifter IS
    PORT(
        A        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALUOp    : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        SHAMT    : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        ShifterR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Shifter;

ARCHITECTURE Behavioral OF Shifter IS
BEGIN
    PROCESS (A, ALUOp, SHAMT)
        VARIABLE LeftOne    : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE LeftTwo    : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE LeftFour   : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE LeftEight  : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE Fill       : STD_LOGIC_VECTOR(15 DOWNTO 0);
        VARIABLE RightOne   : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE RightTwo   : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE RightFour  : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE RightEight : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        -- Shift left logical
        IF ALUOp(1)='0' THEN
            IF SHAMT(0)='1' THEN
                LeftOne(31 DOWNTO 0) := A(30 DOWNTO 0) & '0';
            ELSE
                LeftOne(31 DOWNTO 0) := A(31 DOWNTO 0);
            END IF;

            IF SHAMT(1)='1' THEN
                LeftTwo(31 DOWNTO 0) := LeftOne(29 DOWNTO 0) & "00";
            ELSE
                LeftTwo(31 DOWNTO 0) := LeftOne(31 DOWNTO 0);
            END IF;

            IF SHAMT(2)='1' THEN
                LeftFour(31 DOWNTO 0) := LeftTwo(27 DOWNTO 0) & "0000";
            ELSE
                LeftFour(31 DOWNTO 0) := LeftTwo(31 DOWNTO 0);
            END IF;

            IF SHAMT(3)='1' THEN
                LeftEight(31 DOWNTO 0) := LeftFour(23 DOWNTO 0) & "00000000";
            ELSE
                LeftEight(31 DOWNTO 0) := LeftFour(31 DOWNTO 0);
            END IF;

            IF SHAMT(4)='1' THEN
                ShifterR(31 DOWNTO 0) <= LeftEight(15 DOWNTO 0) & "0000000000000000";
            ELSE
                ShifterR(31 DOWNTO 0) <= LeftEight(31 DOWNTO 0);
            END IF;

        -- Shift right
        ELSE

            FillLoop: FOR i IN 0 TO 15 LOOP
                Fill(i) := ALUOp(0) AND A(31);
            END LOOP FillLoop;

            IF SHAMT(0)='1' THEN
                RightOne(31 DOWNTO 0) := Fill(0) & A(31 DOWNTO 1);
            ELSE
                RightOne(31 DOWNTO 0) := A(31 DOWNTO 0);
            END IF;

            IF SHAMT(1)='1' THEN
               RightTwo(31 DOWNTO 0) := FILL(1 DOWNTO 0) & RightOne(31 DOWNTO 2);
            ELSE
                RightTwo(31 DOWNTO 0) := RightOne(31 DOWNTO 0);
            END IF;

            IF SHAMT(2)='1' THEN
                RightFour(31 DOWNTO 0) := FILL(3 DOWNTO 0) & RightTwo(31 DOWNTO 4);
            ELSE
                RightFour(31 DOWNTO 0) := RightTwo(31 DOWNTO 0);
            END IF;

            IF SHAMT(3)='1' THEN
                RightEight(31 DOWNTO 0) := FILL(7 DOWNTO 0) & RightFour(31 DOWNTO 8);
            ELSE
                RightEight(31 DOWNTO 0) := RightFour(31 DOWNTO 0);
            END IF;

            IF SHAMT(4)='1' THEN
                ShifterR(31 DOWNTO 0) <= FILL(15 DOWNTO 0) & RightEight(31 DOWNTO 16);
            ELSE
                ShifterR(31 DOWNTO 0) <= RightEight(31 DOWNTO 0);
            END IF;

        END IF;

    END PROCESS;

END ARCHITECTURE Behavioral;
