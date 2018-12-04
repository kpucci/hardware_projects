-- Katie Pucci
-- COE1502:: CPU
-- Program Counter Register

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY program_counter_tb IS
END program_counter_tb;

ARCHITECTURE Behavioral OF program_counter_tb IS
    COMPONENT program_counter
    PORT (
        clk          : IN STD_LOGIC;
        reset        : IN STD_LOGIC;
        writeData    : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        writeEnable  : IN STD_LOGIC;
        readData     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
    END COMPONENT;

    -- Internal signals
    SIGNAL clk_int : STD_LOGIC;
    SIGNAL reset_int : STD_LOGIC;
    SIGNAL write_data_int : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_enable_int : STD_LOGIC;
    SIGNAL read_data_int : STD_LOGIC_VECTOR(31 DOWNTO 0) := OTHERS => '0'; -- Initialize to 0
BEGIN

    PROCESS
    BEGIN
        -- Initial values
        reset_int <= '0';
        write_data_int <= (0      => '1',
                           2      => '1',
                           OTHERS => '0');
        write_enable_int <= '0';

        -- Toggle clock
        clk_int <= '0';
        WAIT FOR 5 ns;
        clk_int <= '1';
        WAIT FOR 5 ns;

        -- TEST CASE 1: Register output should be zero at this point

        -- TEST CASE 2: Register output should be one after toggling clock 1-0-1

        write_enable_int <= '1';

        clk_int <= '0';
        WAIT FOR 5 ns;
        -- Check that output is 0

        clk_int <= '1';
        WAIT FOR 5 ns;
        -- Check that output is 5

        -- TEST CASE 3: Asynchronous reset test
        reset_int <= '1';
        -- Check that output is 0

    END PROCESS;

END Behavioral;
