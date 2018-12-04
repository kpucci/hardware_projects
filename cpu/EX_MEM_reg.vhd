-- Katie Pucci
-- COE1502:: CPU
-- Register between EX and MEM stages

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY EX_MEM_reg IS
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
        memReadIn   : IN STD_LOGIC;
        memWriteIn  : IN STD_LOGIC;
        memToRegIn  : IN STD_LOGIC;
        aluRIn      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluIn2      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memReadOut  : OUT STD_LOGIC;
        memWriteOut : OUT STD_LOGIC;
        memToRegOut : OUT STD_LOGIC;
        aluROut     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluIn2Out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Behavioral OF EX_MEM_reg IS
    -- Internal signals
    SIGNAL mem_read : STD_LOGIC;
    SIGNAL mem_write : STD_LOGIC;
    SIGNAL mem_to_reg : STD_LOGIC;
    SIGNAL alu_r : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_in2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    -- Process for writing to the registers
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                mem_read <= '0';
                mem_write <= '0';
                mem_to_reg <= '0';
                alu_r <= (OTHERS => '0');
                alu_in2 <= (OTHERS => '0');
            ELSE
                mem_read <= memReadIn;
                mem_write <= memWriteIn;
                mem_to_reg <= memToRegIn;
                alu_r <= aluRIn;
                alu_in2 <= aluIn2In;
            END IF;
        END IF;
    END PROCESS;

    -- Concurrent statements
    memReadOut <= mem_read;
    memWriteOut <= mem_write;
    memToRegOut <= mem_to_reg;
    aluROut <= alu_r;
    aluIn2Out <= alu_in2;
END ARCHITECTURE;
