-- Katie Pucci
-- COE1502:: CPU
-- Shift left
--
-- Shift left by 2 bits

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Inputs::
--      dataIn:  input data
-- Outputs::
--      dataOut: output data, shifted left
ENTITY shift_left IS
    PORT (
        dataIn  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Behavioral OF shift_left IS
BEGIN
    PROCESS
    BEGIN
        dataOut(1) <= '0';
        dataOut(0) <= '0';
        shift_loop : FOR i IN 2 TO 31 LOOP
            dataOut(i) <= dataIn(i-2);
        END LOOP shift_loop;
    END PROCESS;
END ARCHITECTURE;
