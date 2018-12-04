-- Katie Pucci
-- COE1502:: CPU
-- Register File

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg_file IS
    -- Define ports
    -- Inputs::
    --   clk - clock signal
    --   reset - synchronous reset control signal
    --   read_reg_1 - address of first register to read from
    --   read_reg_2 - address of second register to read from
    --   write_reg - address of register to write to
    --   write_data - data to write to the register specified by write_reg
    --   write_enable - control signal for writing to a register
    -- Outputs::
    --   read_data_1 - data from register specified by read_reg_1
    --   read_data_2 - data from register specified by read_reg_2
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

END reg_file;

ARCHITECTURE Behavioral OF reg_file IS
    -- There are 32 registers
    TYPE REGFILE IS ARRAY (0 TO 2**5-1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL REGS : REGFILE;

BEGIN

    -- Process for writing to a register
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                reset_loop : FOR i IN 0 TO 2**5-1 LOOP
                    regfile(i) <= (OTHERS => '0');
                END LOOP reset_loop;
            ELSIF writeEnable = '1' THEN
                regfile(to_integer(unsigned(writeReg))) <= writeData;
            END IF;
        END IF;
    END PROCESS;

    -- Process for reading from first register
    PROCESS (clk, readReg1)
    BEGIN
        IF readReg1 = "00000"  THEN
            readReg1 <= (OTHERS => '0');
        ELSE
            readData1 <= REGS(to_integer(unsigned(readReg1)));
        END IF;
    END PROCESS;

    -- Process for reading from second register
    PROCESS (clk, readReg2)
    BEGIN
        IF readReg2 = "00000" THEN
            readReg2 <= (OTHERS => '0');
        ELSE
            readData1 <= regfile(to_integer(unsigned(readReg2)));
        END IF;
    END PROCESS;

END Behavioral;
