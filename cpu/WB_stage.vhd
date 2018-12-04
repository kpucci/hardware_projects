-- Katie Pucci
-- COE1502:: CPU
-- Write-Back Stage

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY WB_stage IS
    -- Define ports
    -- Inputs::
    --     clk - clock signal
    --     reset - control signal for resetting cpu
    --     readData - data read from memory in MEM stage
    --     aluR - result from ALU
    -- Outputs::
    --     writeData - data to write to registers
	PORT (
        clk    : IN STD_LOGIC;
        reset  : IN STD_LOGIC;
        readData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END WB_stage;

ARCHITECTURE Structural OF WB_stage IS
    -- Define 2-to-1 MUX
    COMPONENT mux_2_to_1
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

BEGIN
    -- Instantiate 2-to-1 MUX for ALUSrc
    MUX : mux_2_to_1
    PORT MAP (
        a => readData,
        b => aluR,
        s => memToReg,
        m => writeData
    );

END Structural;
