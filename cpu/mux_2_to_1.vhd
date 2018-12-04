-- Katie Pucci
-- COE1502:: CPU
-- 32-bit 2-to-1 MUX

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Inputs::
--      a: input option #1
--      b: input option #2
--      s: selection bit
-- Outputs::
--      m: selected output
ENTITY mux_2_to_1 IS
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavior OF mux_2_to_1 IS
BEGIN
    PROCESS(a,b,s)
    BEGIN
      IF(s = '0') THEN
          m <= a;
      ELSE
          m <= b;
      END IF;
    END PROCESS;
END ARCHITECTURE behavior;
