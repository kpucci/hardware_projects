-- Katie Pucci
-- ECE1120:: Battleship AI
-- EnemyBoard

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY battleship_ai_lib;
USE battleship_ai_lib.BattleshipTypes.ALL;

ENTITY EnemyBoard IS
  PORT (
    Turn       : IN STD_LOGIC;
    Reset      : IN STD_LOGIC;
    Won        : IN STD_LOGIC := '0';
    Lost       : IN STD_LOGIC := '0';
    Result     : IN STATE;
    ResultLocation : IN ADDR;
    Fire       : OUT STD_LOGIC;
    Location   : OUT ADDR
  );
END ENTITY EnemyBoard;

ARCHITECTURE behavior OF EnemyBoard IS

  -- Generate random space
  FUNCTION generate_random_space (
    SIGNAL range_of_rand : IN REAL
  )
  RETURN
    ADDR
  IS
    VARIABLE seed1, seed2: POSITIVE;            -- seed values for random generator
    VARIABLE rand: REAL;                        -- random real-number value in range 0 to 1.0
    VARIABLE row : INTEGER;
    VARIABLE col : INTEGER;
  BEGIN
      uniform(seed1, seed2, rand);   -- generate random number
      row := INTEGER(rand*range_of_rand);  -- rescale to 0..1000, convert integer part

      uniform(seed1, seed2, rand);
      col := INTEGER(rand*range_of_rand);

      RETURN ADDR(row*col);
  END generate_random_space;

  -- 10 x 10 gameboard
  TYPE STATE_ARRAY IS ARRAY (0 TO 99) OF SPACE_STATE;
  SIGNAL space_states : STATE_ARRAY;

  TYPE TYPE_ARRAY IS ARRAY (0 TO 99) OF SPACE_TYPE;
  SIGNAL space_types : TYPE_ARRAY;

  SIGNAL D  : DESTROYER_SPACES;
  SIGNAL S1 : SUBMARINE_SPACES;
  SIGNAL S2 : SUBMARINE_SPACES;
  SIGNAL CR : CRUISER_SPACES;
  SIGNAL B  : BATTLESHIP_SPACES;
  SIGNAL CA : CARRIER_SPACES;

  SIGNAL ship_buffer : SPACE_BUFFER;

  SIGNAL destroyer_count  : INTEGER := 2;
  SIGNAL submarine1_count : INTEGER := 3;
  SIGNAL submarine2_count : INTEGER := 3;
  SIGNAL cruiser_count    : INTEGER := 3;
  SIGNAL battleship_count : INTEGER := 4;
  SIGNAL carrier_count    : INTEGER := 5;

  SIGNAL dir : DIRECTION;
  SIGNAL rand_space : ADDR;
  SIGNAL rand_col : INTEGER;

  TYPE SEARCH_STATE IS (
    INITIAL, TRY_UP, SEARCH_UP, TRY_DOWN, SEARCH_DOWN,
    TRY_LEFT, SEARCH_LEFT, SEARCH_RIGHT
  );

  SIGNAL state : SEARCH_STATE;

  SIGNAL curr_space : ADDR;
  SIGNAL next_space : ADDR;
BEGIN

  -- Process is run at start of turn. Used to find next address to shoot at
  PROCESS(Turn, Reset)
  BEGIN
    ----- Restart game -----
    IF Reset = '1' THEN
      -- Set all states to free
      board_loop : FOR s IN 0 TO 99 LOOP
        space_states(s) <= FREE;
      END LOOP board_loop;

      destroyer_count <= 1;
      submarine1_count <= 2;
      submarine2_count <= 2;
      cruiser_count <= 2;
      battleship_count <= 3;
      carrier_count <= 4;

      Fire <= '0';

    ELSIF Turn = '0' THEN
      Fire <= '0';

    ----- Search for ship -----

    -- If it's your turn
    ELSIF Turn = '1' THEN
      curr_space <= next_space;
      Fire <= '1';

    END IF;
  END PROCESS;

  -- Process is run when results are received from other player
  PROCESS(ResultLocation)
    VARIABLE count : INTEGER := 0;
    VARIABLE start_pos : ADDR;
  BEGIN
    -- Set state in table
    space_states(ADDR'POS(ResultLocation)) <= Result;

    CASE state IS
      -- Start searching randomly until we get a hit
      WHEN RAND =>
        count := 0;

        -- If got a hit, start search upwards
        IF Result = HIT THEN
          start_pos := ResultLocation;  -- Store original position for changing directions quicker
          count := count + 1;           -- Increment hit count
          state <= TRY_UP;              -- Try hitting space above
          next_space <= ADDR(ADDR'POS(ResultLocation) + 10);

        -- Otherwise, get a random location to shoot at
        ELSE
          next_space <= generate_random_space(10);
        END IF;

      -- Try searching up
      WHEN TRY_UP =>
        IF Result = HIT THEN
          count := count + 1;
          state <= SEARCH_UP; -- If we got a hit going up, need to stay in up/down direction
          next_space <= ADDR(ADDR'POS(ResultLocation) + 10);
        ELSIF Result = MISS THEN
          state <= TRY_DOWN; -- If we didn't get a hit going up, try going down (from starting pos)
          next_space <= ADDR(ADDR'POS(start_pos) - 10);
        ELSE -- SUNK
          count := count + 1;
          state <= RAND;
        END IF;

      -- Search up
      WHEN SEARCH_UP =>
        IF Result = HIT THEN
          count := count + 1;
          next_space <= ADDR(ADDR'POS(ResultLocation) + 10);
        ELSIF Result = MISS THEN
          state <= SEARCH_DOWN; -- Once we get a hit going up, reverse directions
          next_space <= ADDR(ADDR'POS(start_pos) - 10);
        ELSE -- SUNK
          count := count + 1;
          state <= RAND;
        END IF;

      -- Try searching down
      WHEN TRY_DOWN =>
        IF Result = HIT THEN
          count := count + 1;
          state <= SEARCH_DOWN; -- If we got a hit going up, need to stay in up/down direction
          next_space <= ADDR(ADDR'POS(ResultLocation) - 10);
        ELSIF Result = MISS THEN
          state <= TRY_LEFT; -- If we didn't get a hit going up, try going left (from starting pos)
          next_space <= ADDR(ADDR'POS(start_pos) - 1);
        ELSE -- SUNK
          count := count + 1;
          state <= RAND;
        END IF;

      -- Search down
      WHEN SEARCH_DOWN =>
        IF Result = HIT THEN
          count := count + 1;
          next_space <= ADDR(ADDR'POS(ResultLocation) - 10);
        ELSIF Result = MISS THEN
          state <= RAND; -- Once we get a hit going down, finished searching
          next_space <= generate_random_space(10);
        ELSE -- SUNK
          count := count + 1;
          state <= RAND;
        END IF;

      -- Try searching left
      WHEN TRY_LEFT =>
        IF Result = HIT THEN
          count := count + 1;
          state <= SEARCH_LEFT; -- If we got a hit going up, need to stay in up/down direction
          next_space <= ADDR(ADDR'POS(ResultLocation) - 1);
        ELSIF Result = MISS THEN
          state <= SEARCH_RIGHT; -- If we didn't get a hit going up, only direction left is right
          next_space <= ADDR(ADDR'POS(start_pos) + 1);
        ELSE -- SUNK
          count := count + 1;
          state <= RAND;
        END IF;

      -- Search left
      WHEN SEARCH_LEFT =>
        IF Result = HIT THEN
          count := count + 1;
          next_space <= ADDR(ADDR'POS(ResultLocation) - 1);
        ELSIF Result = MISS THEN
          state <= SEARCH_RIGHT; -- Once we get a hit going left, reverse directions
          next_space <= ADDR(ADDR'POS(start_pos) + 1);
        ELSE -- SUNK
          count := count + 1;
          state <= RAND;
        END IF;

      -- Search down
      WHEN SEARCH_RIGHT =>
        IF Result = HIT THEN
          count := count + 1;
          next_space <= ADDR(ADDR'POS(ResultLocation) + 1);
        ELSIF Result = MISS THEN
          state <= RAND; -- Once we get a hit going down, finished searching
          next_space <= generate_random_space(10);
        ELSE -- SUNK
          count := count + 1;
          state <= RAND;
        END IF;
    END CASE;
  END PROCESS;

END ARCHITECTURE behavior;
