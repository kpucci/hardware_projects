-- Katie Pucci
-- COE1502:: CPU
-- Register between ID and EX stages

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ID_EX_reg IS
    -- Define ports
    -- Inputs::
    --     clk - clock signal
    --     reset - synchronous reset control signal
    --     rsIn - rs register number (25-21)
    --     rtIn - rt register number (20-16)
    --     rdIn - rd register number (15-11)
    --     rsDataIn - data from rs register
    --     rtDataIn - data from rt register
    --     immIn - sign-extended immediate value
    --     regDstIn - regDst control signal
    --     aluSrcIn - aluSrc control signal
    --     aluOpIn - aluOp control signal
    --     memReadIn - memRead control signal
    --     memWriteIn - memWrite control signal
    --     memToRegIn - memToReg control signal
    -- Outputs::
    --     rsOut - rs register number (25-21)
    --     rtOut - rt register number (20-16)
    --     rdOut - rd register number (15-11)
    --     rsDataOut - data from rs register
    --     rtDataOut - data from rt register
    --     immOut - sign-extended immediate value
    --     regDstOut - regDst control signal
    --     aluSrcOut - aluSrc control signal
    --     aluOpOut - aluOp control signal
    --     memReadOut - memRead control signal
    --     memWriteOut - memWrite control signal
    --     memToRegOut - memToReg control signal
    PORT (
        clk         : IN STD_LOGIC;
        reset       : IN STD_LOGIC;
        rsIn        : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rtIn        : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rdIn        : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rsDataIn    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rtDataIn    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        immIn       : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        regDstIn    : IN STD_LOGIC;
        aluSrcIn    : IN STD_LOGIC;
        aluOpIn     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        memReadIn   : IN STD_LOGIC;
        memWriteIn  : IN STD_LOGIC;
        memToRegIn  : IN STD_LOGIC;
        rsOut       : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        rtOut       : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        rdOut       : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        rsDataOut   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        rtDataOut   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        immOut      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        regDstOut   : OUT STD_LOGIC;
        aluSrcOut   : OUT STD_LOGIC;
        aluOpOut    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        memReadOut  : OUT STD_LOGIC;
        memWriteOut : OUT STD_LOGIC;
        memToRegOut : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE Behavioral OF ID_EX_reg IS
    -- Internal signals
    SIGNAL rs_reg : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rt_reg : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rd_reg : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL rs_data_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rt_data_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL imm_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL reg_dst : STD_LOGIC;
    SIGNAL alu_src : STD_LOGIC;
    SIGNAL alu_op  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mem_read : STD_LOGIC;
    SIGNAL mem_write : STD_LOGIC;
    SIGNAL mem_to_reg : STD_LOGIC;

BEGIN

    -- Process for writing to the registers
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                rs_reg <= (OTHERS => '0');
                rt_reg <= (OTHERS => '0');
                rd_reg <= (OTHERS => '0');
                rs_data_reg <= (OTHERS => '0');
                rt_data_reg <= (OTHERS => '0');
                imm_reg <= (OTHERS => '0');
                reg_dst <= '0';
                alu_src <= '0';
                alu_op <= (OTHERS => '0');
                mem_read <= '0';
                mem_write <= '0';
                mem_to_reg <= '0';
            ELSE
                rs_reg <= rsIn;
                rt_reg <= rtIn;
                rd_reg <= rdIn;
                rs_data_reg <= rsDataIn;
                rt_data_reg <= rtDataIn;
                imm_reg <= immIn;
                reg_dst <= regDstIn;
                alu_src <= aluSrcIn;
                alu_op <= aluOpIn;
                mem_read <= memReadIn;
                mem_write <= memWriteIn;
                mem_to_reg <= memToRegIn;
            END IF;
        END IF;
    END PROCESS;

    -- Concurrent statements
    rsOut <= rs_reg;
    rtOut <= rt_reg;
    rdOut <= rd_reg;
    rsDataOut <= rt_data_reg;
    rtDataOut <= rt_data_reg;
    immOut <= imm_reg;
    regDstOut <= reg_dst;
    aluSrcOut <= alu_src;
    aluOpOut <= alu_op;
    memReadOut <= mem_read;
    memWriteOut <= mem_write;
    memToRegOut <= mem_to_reg;
END ARCHITECTURE;
