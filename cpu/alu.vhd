-- Katie Pucci
-- COE1502:: CPU
-- ALU

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY alu IS
    PORT(
        a        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluCtrl  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        shamt    : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        overflow : OUT STD_LOGIC;
        r        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        zero     : OUT STD_LOGIC
    );
END alu ;

ARCHITECTURE Structural OF alu IS

    -- Component Declarations
    COMPONENT Arithmetic
    PORT (
        a           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b           : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluCtrl     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        arithmeticR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        carryOut    : OUT STD_LOGIC;
        overflow    : OUT STD_LOGIC;
        zero        : OUT STD_LOGIC
    );
    END COMPONENT;

    COMPONENT Comparison
    PORT (
        aluCtrl     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        aSign       : IN STD_LOGIC;
        bSign       : IN STD_LOGIC;
        carryOut    : IN STD_LOGIC;
        rSign       : IN STD_LOGIC;
        comparisonR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT Logical
    PORT (
        a        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluCtrl  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        logicalR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT Mux4Bus32
    PORT (
        aluCtrl       : IN STD_LOGIC_VECTOR(3 DOWNTO 2);
        arithmeticR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        comparisonR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        logicalR    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        shifterR    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        r           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT Shifter
    PORT (
        a        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluCtrl  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        shamt    : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        shifterR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    -- Internal signals
    SIGNAL aSign       : STD_LOGIC;
    SIGNAL arithmeticR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL bSign       : STD_LOGIC;
    SIGNAL carryOut    : STD_LOGIC;
    SIGNAL comparisonR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL logicalR    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rSign       : STD_LOGIC;
    SIGNAL shifterR    : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    aSign <= a(31);
    bSign <= a(31);
    rSign <= arithmeticR(31);

    U_1 : Arithmetic
    PORT MAP (
        a           => a,
        b           => b,
        aluCtrl     => aluCtrl(1 DOWNTO 0),
        arithmeticR => arithmeticR,
        carryOut    => carryOut,
        overflow    => overflow,
        zero        => zero
    );

    U_2 : Comparison
    PORT MAP (
        aluCtrl     => aluCtrl(1 DOWNTO 0),
        aSign       => aSign,
        bSign       => bSign,
        carryOut    => carryOut,
        rSign       => rSign,
        comparisonR => comparisonR
    );

    U_0 : Logical
    PORT MAP (
        a        => a,
        b        => b,
        aluCtrl  => aluCtrl(1 DOWNTO 0),
        logicalR => logicalR
    );

    U_3 : Shifter
    PORT MAP (
        a        => a,
        aluCtrl  => aluCtrl(1 DOWNTO 0),
        shamt    => shamt,
        shifterR => shifterR
    );

    U_4 : Mux4Bus32
    PORT MAP (
        aluCtrl     => aluCtrl(3 DOWNTO 2),
        arithmeticR => arithmeticR,
        comparisonR => comparisonR,
        logicalR    => logicalR,
        shifterR    => shifterR,
        r           => r
    );
END ARCHITECTURE Structural;
