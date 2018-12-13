-- Katie Pucci
-- ECE1120:: Battleship AI
-- Game Space

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

-- Inputs::
--    Piece: type of gamepiece
--       000 - Unoccupied
--       001 - Destroyer
--       010 - Submarine #1
--       011 - Submarine #2
--       100 - Cruiser
--       101 - Battleship
--       110 - Carrier
--    North: game space number connected in north direction
--    East: game space number connected in east direction
--    South: game space number connected in south direction
--    West: game space number connected in west direction
--    Shoot: other player shot at this location
--    Sunken: controller will broadcast a sunken signal equal 
--            to the piece ID of the most recently sunken ship
--            NOTE: other player has to say when ship is sunken
--    Reset: reset signal to restart game (asynchronous)
-- Outputs::
--    State: current state of piece
--       00 - Free
--       01 - Miss
--       10 - Hit
--       11 - Sunk
ENTITY GameSpace IS
  PORT (
    Piece  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    North  : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    East   : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    West   : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    South  : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    Shoot  : IN STD_LOGIC;
    Sunken : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    Reset  : IN STD_LOGIC;
    State  : OUT STD_LOGIC
  );
END ENTITY GameSpace;

--
ARCHITECTURE behavior OF GameSpace IS
  TYPE STATE_TYPE IS (
        FREE, MISS, HIT, SUNK
      );
  
  SIGNAL state_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
  
  PROCESS(Shoot, Sunken, Reset)
  BEGIN
    -- Restart game
    IF Reset = '1' THEN
      state_sig <= FREE;
      State <= "00";
    
    -- Other player indicated a sunken ship
    ELSIF Sunken = Piece THEN
      state_sig <= SUNK;
      State <= "11";
    
    -- Other player fired a shot at this piece
    ELSIF Shoot = '1' THEN
      IF state_sig = FREE THEN
        IF NOT(Piece = "000") THEN
          state_sig <= HIT;
          State <= "10";
        ELSE
          state_sig <= MISS;
          State <= "01";
        END IF;
      END IF;
        
      -- NOTE: Don't need to do anything for other states
        
    END IF;
  END PROCESS;
END ARCHITECTURE behavior;

