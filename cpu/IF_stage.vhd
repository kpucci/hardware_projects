-- Katie Pucci
-- COE1502:: CPU
-- Instruction Fetch Stage

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY IF_stage IS
    -- Define ports
    -- Inputs::
    --     clk - clock signal
    --     reset - control signal for resetting cpu
    --     memWrite - control signal for writing to memory
    --     pcWrite - control signal for writing to PC (hazard control)
    --     instrWriteData - instruction to write to memory
    --     branchAddr - branch address
    --     pcSrc - control signal to determine source of PC address (for branching)
    --     stall - control signal for inserting a no-op
    -- Outputs::
    --     instr - instruction fetched from memory
    --     pcInc - the incremented PC value
	PORT (
        clk				: IN STD_LOGIC;
        reset			: IN STD_LOGIC;
        memWrite        : IN STD_LOGIC;
        pcWrite         : IN STD_LOGIC;
        instrWriteAddr  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instrWriteData  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        branchAddr      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pcSrc           : IN STD_LOGIC;
        stall           : IN STD_LOGIC;
        instr           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        pcInc           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END IF_stage;

ARCHITECTURE Structural OF IF_stage IS
    -- Define program counter component
    COMPONENT program_counter
    PORT (
        clk          : IN STD_LOGIC;
        reset        : IN STD_LOGIC;
        writeData    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeEnable  : IN STD_LOGIC;
        readData     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Define adder component
    COMPONENT adder
    PORT (
        a    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        cin  : IN STD_LOGIC;
        sum  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
    END COMPONENT;

    -- Define instruction memory component
    COMPONENT instr_mem
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
    END COMPONENT;

    -- Define MUX component
    COMPONENT mux_2_to_1
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Internal signals
    SIGNAL pc_out    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pc_inc    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mux_out   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_wait  : STD_LOGIC;

BEGIN

    -- Initialize adder to increment the PC
    add : adder
    PORT MAP (
        a   => pc_out,
        b   => "0000 0000 0000 0000 0000 0000 0000 0100", -- 4
        cin => '0',
        sum => pc_inc,
        cout => OPEN -- unused
    );

    -- Initialize the PC
    PC : program_counter
    PORT MAP (
        clk         => clk,
        reset       => reset,
        writeData   => mux_out,
        writeEnable => pcWrite,
        readData    => pc_out
    );

    -- Initialize MUX to choose between incremented PC value
    -- and the branch address
    MUX1 : mux_2_to_1
    PORT MAP (
        a => pc_inc,
        b => bAddr,
        s => bControl,
        m => mux_out
    );

    -- Initialize instruction memory
    I_MEM : instr_mem
    PORT MAP (
        clk       => clk,
        reset     => reset,
        readAddr  => mux_out,
        writeAddr => instrWriteAddr,
        writeData => instrWriteData,
        memWrite  => memWrite,
        readData  => instr,
        memWait   => mem_wait
    );

    pcInc <= pc_inc;
end Structural;
