-- Katie Pucci
-- COE1502:: CPU
-- Instruction Decode Stage

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ID_stage IS
    -- Define ports
    -- Inputs::
    --     clk - clock signal
    --     reset - control signal for resetting cpu
    --     pcInc - incremented PC address (PC + 4)
    --     instr - instruction from memory
    --       RTYPE:
    --         (31-26) = opcode
    --         (25-21) = rs
    --         (20-16) = rt
    --         (15-11) = rd
    --         (10-6)  = shamt
    --         (5-0)   = funct
    --       ITYPE:
    --         (31-26) = opcode
    --         (25-21) = rs
    --         (20-16) = rt
    --         (15-0)  = intermediate
    --       JTYPE:
    --         (31-26) = opcode
    --         (25-0)  = instruction index
    --     writeReg - address of register to write
    --     writeData - data to write to register specified by writeReg
    --     regWrite - control signal for writing to register file
    -- Outputs::
    --     readData2 - data read from register specified by the rs field
    --     readData2 - data read from register specified by the rt field
    --     immediate - sign-extended immediate value
    --     bAddr - calculated branch address
	PORT (
        clk       : IN STD_LOGIC;
        reset     : IN STD_LOGIC;
        pcInc     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instr     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeReg  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        regWrite  : IN STD_LOGIC;
        readData1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        readData2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediate : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        bAddr     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ID_stage;

ARCHITECTURE Structural OF ID_stage IS
    -- Define register file component
    COMPONENT reg_file
    PORT (
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;
        readReg1    : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        readReg2    : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        writeReg    : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        writeData   : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        writeEnable : IN STD_LOGIC;
        readData1   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        readData2   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
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

    -- Define sign extension component
    COMPONENT sign_ext
    PORT (
        dataIn  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Define shifter component
    COMPONENT shift_left
    PORT (
        dataIn  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Internal signals
    SIGNAL rs_data   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rt_data   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ext_out   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL shift_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_addr    : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    -- Initialize the register file
    REGS : reg_file
    PORT MAP (
        clk         => clk,
        reset       => reset,
        readReg1    => instr(25 DOWNTO 21),
        readReg2    => instr(20 DOWNTO 16),
        writeReg    => writeReg,
        writeData   => writeData,
        writeEnable => regWrite,
        readData1   => rs_data,
        readData2   => rt_data
    );

    -- Initialize the sign extension component
    EXT : sign_ext
    PORT MAP (
        dataIn  => instr(15 DOWNTO 0),
        dataOut => ext_out
    );

    -- Initialize the shift left component
    SHIFT : shift_left
    PORT MAP (
        dataIn  => ext_out,
        dataOut => shift_out
    );

    -- Initialize adder
    ADD : adder
    PORT MAP (
        a   => pcInc,
        b   => shift_out,
        cin => '0',
        sum => b_addr,
        cout => OPEN -- unused
    );

    readData1 <= rs_data;
    readData2 <= rt_data;
    immediate <= ext_out;
end Structural;
