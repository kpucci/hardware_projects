-- Katie Pucci
-- COE1502:: CPU
-- Instruction Memory

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_READ.ALL;

-- Inputs::
--    clk       - clock signal
--    reset     - synchronous reset control signal
--    readAddr  - address of memory location to read
--    writeAddr - address of memory location to write
--    writeData - data to write to memory
--    memWrite  - control signal for loading instructions
-- Outputs::
--    readData  - instruction at given address
--    memWait   - control signal to notify subsequent components not to read
ENTITY instr_mem IS
    PORT (
        clk       : IN STD_LOGIC;
        reset     : IN STD_LOGIC;
        readAddr  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeAddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memWrite  : IN STD_LOGIC;
        readData  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        memWait   : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE Behavioral OF instr_mem IS
    -- Assumes 32-bit architecture
    TYPE ROM IS ARRAY (0 TO 2**32-1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MEM : ROM;
BEGIN
    PROCESS(clk)
    BEGIN
        -- On the rising clock edge
        IF(rising_edge(clk)) THEN
            IF reset = '1' THEN
                reset_loop: FOR i IN 0 TO 2**32-1 LOOP
                    MEM(i) <= (OTHERS => '0');
                END LOOP reset_loop;

            -- If write signal is true
            ELSIF memWrite = '1' THEN
                -- Write data at specified address
                MEM(to_integer(unsigned(writeAddr))) <= writeData;

                -- Set control value to let next component know now to read while writing
                memWait <= '1';
            ELSE
                -- Retrieve data at specified address
                readData <= MEM(to_integer(unsigned(readAddr)));
                memWait <= '0';
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;
