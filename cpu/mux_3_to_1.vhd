-- Katie Pucci
-- COE1502:: CPU
-- 32-bit 3-to-1 MUX

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Inputs::
--      a: input option #0
--      b: input option #1
--      c: input option #2
--      s: selection bits
-- Outputs::
--      m: selected output
ENTITY mux_3_to_1 IS
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        c : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        m : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavior OF mux_3_to_1 IS
BEGIN
    PROCESS(a,b,c,s)
    BEGIN
        IF s = '00' THEN
            m <= a;
        ELSIF s = "01" THEN
            m <= b;
        ELSIF s = "10" THEN
            m <= c;
        END IF;
    END PROCESS;
END ARCHITECTURE behavior;
