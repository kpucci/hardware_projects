-- Katie Pucci
-- COE1502:: CPU
-- 32-bit 2-to-1 MUX

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Inputs::
--      controls: control input bus
--      s: hazard control input
-- Outputs::
--      m: selected output
ENTITY control_mux IS
    PORT (
        controls : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        s        : IN STD_LOGIC;
        m        : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Behavioral OF control_mux IS
BEGIN
    PROCESS(s)
    BEGIN
      IF(s = '0') THEN
          m <= (OTHERS => '0');
      ELSE
          m <= controls;
      END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;
