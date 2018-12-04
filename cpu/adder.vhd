-- Katie Pucci
-- COE1502:: CPU
-- 32-bit ripple-carry adder

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY adder IS
    -- Define ports
    -- Inputs::
    --      input1:
    --      input2:
    --      carry_in:
    -- Outputs::
    --      sum:
    --      carry_out:
    PORT (
        input1    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        input2    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        carry_in  : IN  STD_LOGIC;
        sum       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        carry_out : OUT STD_LOGIC
    );
END ENTITY adder;

ARCHITECTURE Dataflow OF adder IS
    -- Define full adder component
    COMPONENT full_adder
    PORT(
        input1, input2, carry_in: IN  STD_LOGIC;
        sum, carry_out          : OUT STD_LOGIC
    );
    END COMPONENT;

    -- Internal signals
    SIGNAL C : STD_LOGIC_VECTOR(30 DOWNTO 0);

BEGIN

    FA0 : full_adder PORT MAP(input1(0),  input2(0),  carry_in, sum(0),  C(0));
    FA1 : full_adder PORT MAP(input1(1),  input2(1),  C(0),     sum(1),  C(1));
    FA2 : full_adder PORT MAP(input1(2),  input2(2),  C(1),     sum(2),  C(2));
    FA3 : full_adder PORT MAP(input1(3),  input2(3),  C(2),     sum(3),  C(3));
    FA4 : full_adder PORT MAP(input1(4),  input2(4),  C(3),     sum(4),  C(4));
    FA5 : full_adder PORT MAP(input1(5),  input2(5),  C(4),     sum(5),  C(5));
    FA6 : full_adder PORT MAP(input1(6),  input2(6),  C(5),     sum(6),  C(6));
    FA7 : full_adder PORT MAP(input1(7),  input2(7),  C(6),     sum(7),  C(7));
    FA8 : full_adder PORT MAP(input1(8),  input2(8),  C(7),     sum(8),  C(8));
    FA9 : full_adder PORT MAP(input1(9),  input2(9),  C(8),     sum(9),  C(9));
    FA10: full_adder PORT MAP(input1(10), input2(10), C(9),     sum(10), C(10));
    FA11: full_adder PORT MAP(input1(11), input2(11), C(10),    sum(11), C(11));
    FA12: full_adder PORT MAP(input1(12), input2(12), C(11),    sum(12), C(12));
    FA13: full_adder PORT MAP(input1(13), input2(13), C(12),    sum(13), C(13));
    FA14: full_adder PORT MAP(input1(14), input2(14), C(13),    sum(14), C(14));
    FA15: full_adder PORT MAP(input1(15), input2(15), C(14),    sum(15), C(15));
    FA16: full_adder PORT MAP(input1(16), input2(16), C(15),    sum(16), C(16));
    FA17: full_adder PORT MAP(input1(17), input2(17), C(16),    sum(17), C(17));
    FA18: full_adder PORT MAP(input1(18), input2(18), C(17),    sum(18), C(18));
    FA19: full_adder PORT MAP(input1(19), input2(19), C(18),    sum(19), C(19));
    FA20: full_adder PORT MAP(input1(20), input2(20), C(19),    sum(20), C(20));
    FA21: full_adder PORT MAP(input1(21), input2(21), C(20),    sum(21), C(21));
    FA22: full_adder PORT MAP(input1(22), input2(22), C(21),    sum(22), C(22));
    FA23: full_adder PORT MAP(input1(23), input2(23), C(22),    sum(23), C(23));
    FA24: full_adder PORT MAP(input1(24), input2(24), C(23),    sum(24), C(24));
    FA25: full_adder PORT MAP(input1(25), input2(25), C(24),    sum(25), C(25));
    FA26: full_adder PORT MAP(input1(26), input2(26), C(25),    sum(26), C(26));
    FA27: full_adder PORT MAP(input1(27), input2(27), C(26),    sum(27), C(27));
    FA28: full_adder PORT MAP(input1(28), input2(28), C(27),    sum(28), C(28));
    FA29: full_adder PORT MAP(input1(29), input2(29), C(28),    sum(29), C(29));
    FA30: full_adder PORT MAP(input1(30), input2(30), C(29),    sum(30), C(30));
    FA31: full_adder PORT MAP(input1(31), input2(31), C(30),    sum(31), carry_out);
    
END ARCHITECTURE Dataflow;
