-- Katie Pucci
-- COE1502:: CPU
-- ALU Comparison Unit

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY Comparison IS
    -- Define ports
    -- Inputs::
    --     aluCtrl - bits 2-0 of the control input
    --     ASign - sign bit of the first input
    --     BSign - sign bit of the second input
    --     CarryOut - carry out bit from subtraction of A - B
    --     RSign - sign bit of the difference of A - B
    --     Zero - zero output from arithmetic unit
    -- Outputs::
    --     ComparisonR - result of comparison (1 if true, 0 if false)
    PORT(
        aluCtrl     : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        ASign       : IN STD_LOGIC;
        BSign       : IN STD_LOGIC;
        CarryOut    : IN STD_LOGIC;
        RSign       : IN STD_LOGIC;
        Zero        : IN STD_LOGIC;
        ComparisonR : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END Comparison;

ARCHITECTURE Behavioral OF Comparison IS
BEGIN
    PROCESS(aluCtrl, ASign, BSign, CarryOut, RSign)
    BEGIN
        CASE ALUOp IS
            -- Less than --> A - B < 0
            WHEN "000" =>
                IF (ASign = '0') AND (BSign = '0') AND (RSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '0') AND (BSign = '0') AND (RSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '1') AND (BSign = '1') AND (RSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '1') AND (BSign = '1') AND (RSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '1') AND (BSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '0') AND (BSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                END IF;

            -- Less than unsigned --> A - B < 0
            WHEN "001" =>
                IF (CarryOut = '1') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSE
                    ComparisonR <= "00000000000000000000000000000001";
                END IF;

            -- Less than or equal to --> A - B <= 0
            WHEN "010" =>
                IF (Zero = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '0') AND (BSign = '0') AND (RSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '0') AND (BSign = '0') AND (RSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '1') AND (BSign = '1') AND (RSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '1') AND (BSign = '1') AND (RSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '1') AND (BSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '0') AND (BSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                END IF;

            -- Greater than --> A - B > 0 or B - A < 0
            WHEN "011" =>
                IF (ASign = '0') AND (BSign = '0') AND (RSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '0') AND (BSign = '0') AND (RSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '1') AND (BSign = '1') AND (RSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '1') AND (BSign = '1') AND (RSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '1') AND (BSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '0') AND (BSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                END IF;

            -- Greater than or equal to
            WHEN "100" =>
                IF (Zero = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '0') AND (BSign = '0') AND (RSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '0') AND (BSign = '0') AND (RSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '1') AND (BSign = '1') AND (RSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSIF (ASign = '1') AND (BSign = '1') AND (RSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '1') AND (BSign = '0') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSIF (ASign = '0') AND (BSign = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                END IF;

            -- Equal
            WHEN "101" =>
                IF (Zero = '1') THEN
                    ComparisonR <= "00000000000000000000000000000001";
                ELSE
                    ComparisonR <= "00000000000000000000000000000000";
                END IF;

            -- Not equal
            WHEN "110" =>
                IF (Zero = '1') THEN
                    ComparisonR <= "00000000000000000000000000000000";
                ELSE
                    ComparisonR <= "00000000000000000000000000000001";
                END IF;

        END CASE;

    END PROCESS;

END ARCHITECTURE Behavioral;
