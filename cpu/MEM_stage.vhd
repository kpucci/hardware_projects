-- Katie Pucci
-- COE1502:: CPU
-- Memory Stage

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MEM_stage IS
    -- Define ports
    -- Inputs::
    --     clk - clock signal
    --     reset - control signal for resetting cpu
    --     memRead - control signal for reading from data memory
    --     memWrite - control signal for writing to data memory
    --     aluR - ALU result
    --     aluInput2 - second input value to ALU (used in forwarding)
    -- Outputs::
    --
	PORT (
        clk       : IN STD_LOGIC;
        reset     : IN STD_LOGIC;
        memWrite  : IN STD_LOGIC;
        memRead   : IN STD_LOGIC;
        aluR      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluInput2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        readData  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluROut   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MEM_stage;

ARCHITECTURE Structural OF MEM_stage IS

    -- Define data memory component
    COMPONENT data_mem
    PORT (
        clk      : IN STD_LOGIC;
        reset    : IN STD_LOGIC;
        addr     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataIn   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        memWrite : IN STD_LOGIC;
        dataOut  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        memWait  : OUT STD_LOGIC
    );
    END COMPONENT;

    -- Internal signals --
    SIGNAL mem_wait : STD_LOGIC;

BEGIN

    MEM : data_mem
    PORT MAP (
        clk      => clk,
        reset    => reset,
        addr     => aluR,
        dataIn   =>aluInput2,
        memWrite => memWrite,
        dataOut  => readData,
        memWait  => mem_wait
    );

    aluROut <= aluR;

END Structural;
