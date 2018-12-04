-- Katie Pucci
-- COE1502:: CPU
-- Register between IF and ID stages

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY IF_ID_reg IS
    -- Define ports
    -- Inputs::
    --     clk - clock signal
    --     reset - synchronous reset control signal
    --     writeEnable - control signal for writing to register (for hazard control)
    --     flush - control signal
    --     pcIncIn - the incremented PC address (PC + 4)
    --     instrIn -  the instruction fetched from memory
    -- Outputs::
    --     pcIncOut - the incremented PC address (PC + 4)
    --     instrOut - the instruction fetched from memory
    PORT (
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;
        writeEnable : IN STD_LOGIC;
        flush       : IN STD_LOGIC;
        pcIncIn     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instrIn     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pcIncOut    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        instrOut    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Behavioral OF IF_ID_reg IS
    -- Internal signals
    SIGNAL pc_inc_reg : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";
    SIGNAL instr_reg   : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";

BEGIN
    -- Process for flushing the instruction field
    PROCESS(clk)
    BEGIN
        IF flush = '1' THEN
            instr_reg <= (OTHERS => '0');
        END IF;
    END PROCESS;

    -- Process for writing to the registers
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                pc_inc_reg <= (OTHERS => '0');
                instr_reg <= (OTHERS => '0');
            ELSIF writeEnable = '1' THEN
                pc_inc_reg <= pcIncIn;
                instr_reg <= instrIn;
            END IF;
        END IF;
    END PROCESS;

    -- Concurrent statements
    pcIncOut <= pc_inc_reg;
    instrOut <= instr_reg;
END ARCHITECTURE;
