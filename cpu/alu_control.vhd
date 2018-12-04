-- Katie Pucci
-- COE1502:: CPU
-- ALU Control Unit

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu_control IS
    -- Define ports
    -- Inputs::
    --   aluOp - defines the type of instruction
    --      000: I-Type
    --      001: Branch-equal
    --      010: R-Type
    --      011: J-Type
    --   funct - function code from instruction
    -- Outputs::
    --   aluCtrl - determines which alu operation to perform
    --      0
    PORT (
        aluOp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        funct : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        aluCtrl : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );

END alu_control;

ARCHITECTURE Behavioral OF alu_control IS

BEGIN

    PROCESS (aluOp, funct)
    BEGIN
        CASE aluOp IS

        -- I-Type
        WHEN "000" =>
            aluCtrl <= "0010"; -- add

        -- Branch-equal
        WHEN "001" =>
            aluCtrl <= "0110"; -- subtract

        -- R-Type
        WHEN "010" =>
            CASE funct IS

            -- add
            WHEN "100000" =>
                aluCtrl <= "0010";

            -- subtract
            WHEN "100010" =>
                aluCtrl <= "0110";

            -- AND
            WHEN "100100" =>
                aluCtrl <= "0000";

            -- OR
            WHEN "100101" =>
                aluCtrl <= "0001";

            -- SLT
            WHEN "101010" =>
                aluCtrl <= "0111";


            END CASE;

        -- J-Type
        WHEN "011" =>

        END CASE;
    END PROCESS;

END Behavioral;
