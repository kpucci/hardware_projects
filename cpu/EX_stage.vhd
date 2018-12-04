-- Katie Pucci
-- COE1502:: CPU
-- Execution Stage

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY EX_stage IS
    -- Define ports
    -- Inputs::
    --     clk - clock signal
    --     reset - control signal for resetting cpu
    --     rs - rs field register number
    --     rt - rt field register number
    --     rd - rd field register number
    --     rsData - data from rs register
    --     rtData - data from rt register
    --     imm - sign-extended immediate value
    --     regDst - regDst control signal
    --     aluSrc - aluSrc control signal
    --     aluOp - aluOp control signal
    --     aluFwd - forwarded result of ALU (from EX/MEM reg)
    --     wbFwd - output of MUX from WB stage (for forwarding)
    --     fwdSrc - forwarding source control signal
    -- Outputs::
    --     aluR - ALU result
    --     aluInput2 - second input value to ALU (used in forwarding)
	PORT (
        clk    : IN STD_LOGIC;
        reset  : IN STD_LOGIC;
        rs     : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rt     : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rd     : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rsData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rtData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        imm    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        regDst : IN STD_LOGIC;
        aluSrc : IN STD_LOGIC;
        aluOp  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        aluFwd : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        wbFwd  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        fwdSrc : IN STD_LOGIC
        aluR      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluInput2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END EX_stage;

ARCHITECTURE Structural OF EX_stage IS
    -- Define ALU component
    COMPONENT alu
    PORT (
        a        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluCtrl  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        shamt    : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        overflow : OUT STD_LOGIC;
        r        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        zero     : OUT STD_LOGIC
    );
    END COMPONENT;

    -- Define ALU control unit
    COMPONENT alu_control
    PORT (
        aluOp : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        funct : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        aluCtrl : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
    END COMPONENT;

    -- Define 2-to-1 MUX
    COMPONENT mux_2_to_1
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s : IN STD_LOGIC;
        m : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Define 3-to-1 MUX
    COMPONENT mux_3_to_1
    PORT (
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        c : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        m : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Internal signals --
    -- ALU control output
    SIGNAL alu_ctrl : STD_LOGIC_VECTOR(4 DOWNTO 0);

    -- MUX outputs
    SIGNAL mux_1_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mux_2_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mux_3_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mux_4_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    -- Instantiate alu
    ALU_UNIT : alu
    PORT MAP (
        a        => mux_1_out,
        b        => mux_3_out,
        aluCtrl  => alu_ctrl,
        shamt    => imm(10 DOWNTO 6);
        overflow =>
        r        =>
        zero     =>
    );

    -- Instantiate alu control unit
    ALU_CTRL : alu_control
    PORT MAP (
        aluOp => aluOp,
        funct => imm(5 DOWNTO 0),
        aluCtrl => alu_ctrl
    );

    -- Instantiate 3-to-1 MUX for forwarding
    MUX_1 : mux_3_to_1
    PORT MAP (
        a => rsData,
        b => wbOut,
        c => aluR,
        s => fwdSrc,
        m => mux_1_out
    );

    -- Instantiate 3-to-1 MUX for forwarding
    MUX_2 : mux_3_to_1
    PORT MAP (
        a => rtData,
        b => wbOut,
        c => aluR,
        s => fwdSrc,
        m => mux_2_out
    );

    -- Instantiate 2-to-1 MUX for ALUSrc
    MUX_3 : mux_2_to_1
    PORT MAP (
        a => mux_2_out,
        b => imm,
        s => aluSrc,
        m => mux_3_out
    );

    -- Instantiate 2-to-1 MUX
    MUX_4 : mux_2_to_1
    PORT MAP (
        a => rt,
        b => rd,
        s => regDst,
        m => mux_4_out
    );

END Structural;
