-- Katie Pucci
-- COE1502:: CPU
-- Sign Extension
--
-- Extend 16-bit immediate to 32-bits

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Inputs::
--      dataIn:  16-bit input
-- Outputs::
--      dataOut: 32-bit sign-extended output
ENTITY sign_ext IS
    PORT (
        dataIn  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavior OF sign_ext IS
BEGIN
    PROCESS(dataIn)
    BEGIN
        IF(dataIn(15) = '0') THEN
            dataOut <= "0000000000000000" & dataIn;
        ELSE
            dataOut <= "1111111111111111" & dataIn;
        END IF;
    END PROCESS;
END ARCHITECTURE;
