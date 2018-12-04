-- Katie Pucci
-- COE1502: CPU
-- Full adder

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

-- Inputs::
--      input1:
--      input2:
--      carry_in:
-- Outputs::
--      sum:
--      carry_out:
ENTITY full_adder IS
  PORT
    ( input1, input2, carry_in : IN  STD_LOGIC;
        sum, carry_out           : OUT STD_LOGIC
    );

END ENTITY full_adder;

ARCHITECTURE dataflow OF full_adder IS
BEGIN
  sum <= input1 XOR input2 XOR carry_in;
  carry_out <= (input1 AND input2) OR (carry_in AND input1) OR (carry_in AND input2);
END ARCHITECTURE dataflow;
