-- Katie Pucci
-- COE1502:: CPU
-- Register between MEM and WB stages

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MEM_WB_reg IS
    -- Define ports
    -- Inputs::
    --     clk - clock signal
    --     reset - synchronous reset control signal
    --     memReadIn - memRead control signal
    --     memWriteIn - memWrite control signal
    --     memToRegIn - memToReg control signal
    --     aluRIn - ALU result
    --     aluIn2In - second ALU input
    -- Outputs::
    --     memReadOut - memRead control signal
    --     memWriteOut - memWrite control signal
    --     memToRegOut - memToReg control signal
    --     aluROut - ALU result
    --     aluIn2Out - second ALU input
    PORT (
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;
        readDataIn  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluRIn      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memToRegIn  : IN STD_LOGIC;
        regWriteIn  : IN STD_LOGIC;
        readDataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluROut     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        memToRegOut : OUT STD_LOGIC;
        regWriteOut : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE Behavioral OF MEM_WB_reg IS
    -- Internal signals
    SIGNAL read_data : STD_LOGIC;
    SIGNAL alu_r : STD_LOGIC;
    SIGNAL mem_to_reg : STD_LOGIC;
    SIGNAL reg_write : STD_LOGIC;

BEGIN

    -- Process for writing to the registers
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                read_data <= (OTHERS => '0');
                alu_r <= (OTHERS => '0');
                mem_to_reg <= '0';
                reg_write <= '0';
            ELSE
                read_data <= readDataIn;
                alu_r <= aluRIn;
                mem_to_reg <= memToRegIn;
                reg_write <= regWriteIn;
            END IF;
        END IF;
    END PROCESS;

    -- Concurrent statements
    readDataOut <= read_data;
    aluROut <= alu_r;
    memToRegOut <= mem_to_reg;
    regWriteOut <= reg_write;
END ARCHITECTURE;
