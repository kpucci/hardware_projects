-- Katie Pucci
-- COE1502:: UART
-- Top Level Design

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY uart IS
    -- Define ports
    -- Inputs::
    --   clk - clock signal
    --   reset - reset control signal
    --   RX - Receive data. This is the serial data input line. This input must be held at at logic 1 when
    --        the link is idle.
    --   CS	- chip select signal
    --      1 - this device is the target of the current bus transaction
    --   writeEn - write enable control signal
    --   readEn - read enable control signal
    --   addr - contains a two bit address signal that selects which of the programmer registers in the bus
    --          interface will be accessed when the device is the target of a bus transaction
    --   data_in - connection for data from the system bus into the UART bus interface registers
    -- Outputs::
    --   TX - Transmit data. This is the serial data output line. The TX signal should be held at ogic 1 while
    --        the transmitter is idle and during reset.
    --   data_out - connection for data to the system bus from the UART bus interface registers
    --   IRQ - interrupt output

    PORT (
        clk      : IN STD_LOGIC;
        reset    : IN STD_LOGIC;
        RX       : IN STD_LOGIC;
        CS       : IN STD_LOGIC;
        writeEn  : IN STD_LOGIC;
        readEn   : IN STD_LOGIC;
        addr     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_in  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        TX       : OUT STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IRQ      : OUT STD_LOGIC
    );

END uart;

ARCHITECTURE Structural OF uart IS
BEGIN
END Structural;
