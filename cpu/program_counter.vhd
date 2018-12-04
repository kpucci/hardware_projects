-- Katie Pucci
-- COE1502:: CPU
-- Program Counter Register

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY program_counter IS
    -- Define ports
    -- Inputs::
    --   clk - clock signal
    --   reset - synchronous reset control signal
    --   writeData   - data to write to the PC
    --   writeEnable - control signal for writing to the PC (disable for no-ops)
    -- Outputs::
    --   readData - data read from PC (the address of the next instruction)
    --              assumes a 32-bit architecture
    PORT (
        clk          : IN STD_LOGIC;
        reset        : IN STD_LOGIC;
        writeData    : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        writeEnable  : IN STD_LOGIC;
        readData     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );

END program_counter;

ARCHITECTURE Behavioral OF program_counter IS
    -- Register file
    SIGNAL reg : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";

BEGIN
    -- Process for writing to the PC
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                reg <= (OTHERS => '0');
            ELSIF writeEnable = '1' THEN
                reg <= writeData;
            END IF;
        END IF;
    END PROCESS;

    -- Concurrent statements
    readData <= reg;

END Behavioral;
