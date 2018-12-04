-- Katie Pucci
-- COE1502:: CPU
-- Program Counter Register

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY cpu IS
    -- Define ports
    -- Inputs::
    --   clk - clock signal
    --   reset - synchronous reset control signal
    --   initialize - control signal for initializing cpu (for writing to instruction memory)
    --   instrWriteAddr - address in instruction memory to write
    --   instrWriteData - data to write to instruction memory
    -- Outputs::

    PORT (
        clk            : IN STD_LOGIC;
        reset          : IN STD_LOGIC;
        initialize     : IN STD_LOGIC;
        instrWriteAddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instrWriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END cpu;

ARCHITECTURE Structural OF cpu IS
    -- Define control unit
    COMPONENT control_unit
    PORT (
        opcode   : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        pcSrc    : OUT STD_LOGIC;
        regWrite : OUT STD_LOGIC;
        regDst   : OUT STD_LOGIC;
        aluSrc   : OUT STD_LOGIC;
        memRead  : OUT STD_LOGIC;
        memWrite : OUT STD_LOGIC;
        memToReg : OUT STD_LOGIC
    );
    END COMPONENT;

    -- Define hazard detection unit
    COMPONENT hazard_detection
    PORT (
        blah
    );
    END COMPONENT;

    -- Define forwarding unit
    COMPONENT forwarding_unit
    PORT (
        blah
    );
    END COMPONENT;

    -- Define IF stage
    COMPONENT IF_stage
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
    END COMPONENT;

    -- Define IF/ID register
    COMPONENT IF_ID_reg
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
    END COMPONENT;

    -- Define ID stage
    COMPONENT ID_stage
    PORT (
        clk       : IN STD_LOGIC;
        reset     : IN STD_LOGIC;
        pcInc     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instr     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        writeReg  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        readData1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        readData2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediate : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        bAddr     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Define control MUX component
    COMPONENT control_mux
    PORT (
        controls : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        s        : IN STD_LOGIC;
        m        : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
    END COMPONENT;

    -- Define ID/EX register
    COMPONENT ID_EX_reg
    PORT (
        clk       : IN STD_LOGIC;
        reset     : IN STD_LOGIC;
        rsDataIn  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rtDataIn  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        immIn     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rsDataOut : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rtDataOut : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        immOut    : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Define EX stage
    COMPONENT EX_stage
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
    END COMPONENT;

    -- Define EX/MEM register
    COMPONENT EX_MEM_reg
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
    END COMPONENT;

    -- Define MEM stage
    COMPONENT MEM_stage
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
    END COMPONENT;

    -- Define MEM/WB register
    COMPONENT MEM_WB_reg
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
    END COMPONENT;

    -- Define WB stage
    COMPONENT WB_stage
    PORT (
        clk
        reset
        memToReg
        readData
        aluR
        writeData
    );
    END COMPONENT;

    -- Internal signals --
    -- IF stage outputs
    SIGNAL pc_inc_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr_reg  : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- IF/ID register outputs
    SIGNAL if_id_pc    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL if_id_instr : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Control unit outputs
    SIGNAL pc_src     : STD_LOGIC;
    SIGNAL flush_reg  : STD_LOGIC;
    SIGNAL reg_write  : STD_LOGIC;
    SIGNAL reg_dst    : STD_LOGIC;
    SIGNAL alu_src    : STD_LOGIC;
    SIGNAL mem_read   : STD_LOGIC;
    SIGNAL mem_write  : STD_LOGIC;
    SIGNAL mem_to_reg : STD_LOGIC;

    -- Control MUX output
    SIGNAL c_mux_out : STD_LOGIC_VECTOR(4 DOWNTO 0);

    -- ID stage outputs
    SIGNAL b_addr  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rs_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rt_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL imm_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- ID/EX register outputs
    SIGNAL id_ex_rs  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL id_ex_rt  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL id_ex_imm : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    -- Instantiate IF stage
    FETCH : IF_stage
    PORT MAP (
        clk            => clk,
        reset          => reset,
        memWrite       =>
        pcWrite        =>
        instrWriteAddr => instrWriteAddr,
        instrWriteData => instrWriteData,
        branchAddr     => b_addr,
        pcSrc          =>
        stall          =>
        instr          => instr_reg,
        pcInc          => pc_inc_reg
    );

    -- Instantiate IF/ID register
    IF_ID : IF_ID_reg
    PORT MAP (
        clk         => clk,
        reset       => reset,
        writeEnable =>
        flush       => flush_reg,
        pcIncIn     => pc_inc_reg,
        instrIn     => instr_reg,
        pcIncOut    => if_id_pc,
        instrOut    => if_id_instr
    );

    -- Instantiate control unit
    CONTROL : control_unit
    PORT MAP (
        opcode   => instr_reg(31 DOWNTO 26),
        pcSrc    => pc_src,
        flush    => flush_reg,
        regWrite => reg_write,
        regDst   => reg_dst,
        aluSrc   => alu_src,
        memRead  => mem_read,
        memWrite => mem_write,
        memToReg => mem_to_reg
    );

    -- Instantiate control MUX
    MUX : control_mux
    PORT MAP (
        controls => reg_dst & alu_src & mem_read & mem_write & mem_to_reg;
        s        =>
        m        => c_mux_out
    );

    -- Instantiate ID stage
    DECODE : ID_stage
    PORT MAP (
        clk       => clk,
        reset     => reset,
        pcInc     => if_id_pc,
        instr     => if_id_instr,
        writeReg  =>
        writeData =>
        regWrite  => reg_write,
        readData1 => rs_data,
        readData2 => rt_data,
        immediate => imm_reg,
        bAddr     => b_addr
    );

    -- Instantiate ID/EX register
    ID_EX : ID_EX_reg
    PORT MAP (
        clk         => clk,
        reset       => reset,
        rsIn        =>
        rtIn        =>
        rdIn        =>
        rsDataIn    => rs_data,
        rtDataIn    => rt_data,
        immIn       => imm_reg,
        regDstIn    =>
        aluSrcIn    =>
        aluOpIn     =>
        memReadIn   =>
        memWriteIn  =>
        memToRegIn  =>
        rsOut       =>
        rtOut       =>
        rdOut       =>
        rsDataOut   => id_ex_rs,
        rtDataOut   => id_ex_rt,
        immOut      => id_ex_imm,
        regDstOut   =>
        aluSrcOut   =>
        aluOpOut    =>
        memReadOut  =>
        memWriteOut =>
        memToRegOut =>
    );

    EXECUTE : EX_stage
    PORT MAP (
        clk       => clk,
        reset     => reset,
        rs        =>
        rt        =>
        rd        =>
        rsData    => id_ex_rs,
        rtData    => id_ex_rt,
        imm       => id_ex_imm,
        regDst    =>
        aluSrc    =>
        aluOp     =>
        aluFwd    =>
        wbFwd     =>
        fwdSrc    =>
        aluR      =>
        aluInput2 =>
    );

end Structural;
