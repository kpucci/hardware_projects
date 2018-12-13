-- Katie Pucci
-- ECE1120:: Battleship AI
-- GameBoard

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

LIBRARY battleship_ai_lib;
USE battleship_ai_lib.BattleshipTypes.ALL;

-- NOTE: Another option for loading game piece configs is to give the first
--       space num and then the direction. Then, when the space is in the
--       setup config, it'll propagate the signal through to the rest of the
--       pieces. Consider this if the IO utilization is too high.
--
--       Can also consider not having an actual component for the game space
--       and use a matrix instead.

ENTITY GameBoard IS
  PORT (
    Turn       : IN STD_LOGIC
    D          : IN DESTROYER_SPACES;
    S1         : IN SUBMARINE_SPACES;
    S2         : IN SUBMARINE_SPACES;
    CR         : IN CRUISER_SPACES;
    B          : IN BATTLESHIP_SPACES;
    CA         : IN CARRIER_SPACES;
    Fired      : IN STD_LOGIC;
    Location   : IN ADDR;
    Reset      : IN STD_LOGIC;
    Initialize : IN STD_LOGIC;
    Won        : IN STD_LOGIC := '0';
    Result     : OUT SPACE_STATE;
    ResultLocation : OUT ADDR;
    Lost       : OUT STD_LOGIC
  );
END ENTITY GameBoard;

ARCHITECTURE behavior OF GameBoard IS
  -- 10 x 10 gameboard
  TYPE STATE_ARRAY IS ARRAY (0 TO 99) OF SPACE_STATE;
  SIGNAL space_states : STATE_ARRAY;

  TYPE TYPE_ARRAY IS ARRAY (0 TO 99) OF SPACE_TYPE;
  SIGNAL space_types : TYPE_ARRAY;

  SIGNAL destroyer_count : INTEGER := 2;
  SIGNAL submarine1_count : INTEGER := 3;
  SIGNAL submarine2_count : INTEGER := 3;
  SIGNAL cruiser_count : INTEGER := 3;
  SIGNAL battleship_count : INTEGER := 4;
  SIGNAL carrier_count : INTEGER := 5;
  SIGNAL result_int : SPACE_STATE;
  SIGNAL result_location : ADDR;
BEGIN

  PROCESS(Fired, Reset, Initialize)
  BEGIN
    -- Restart game
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

    -- Initialize with gamepiece locations
    ELSIF Initialize = '1' THEN
      type_loop : FOR sp IN 0 TO 99 LOOP
        IF(sp = ADDR'POS(D(0)) OR sp = ADDR'POS(D(1))) THEN
          space_types(sp) <= DESTROYER;
        ELSIF(sp = ADDR'POS(S1(0)) OR sp = ADDR'POS(S1(1)) OR sp = ADDR'POS(S1(2))) THEN
          space_types(sp) <= SUBMARINE1;
        ELSIF(sp = ADDR'POS(S2(0)) OR sp = ADDR'POS(S2(1)) OR sp = ADDR'POS(S2(2))) THEN
          space_types(sp) <= SUBMARINE2;
        ELSIF(sp = ADDR'POS(CR(0)) OR sp = ADDR'POS(CR(1)) OR sp = ADDR'POS(CR(2))) THEN
          space_types(sp) <= CRUISER;
        ELSIF(sp = ADDR'POS(B(0)) OR sp = ADDR'POS(B(1)) OR sp = ADDR'POS(B(2)) OR sp = ADDR'POS(B(3))) THEN
          space_types(sp) <= BATTLESHIP;
        ELSIF(sp = ADDR'POS(CA(0)) OR sp = ADDR'POS(CA(1)) OR sp = ADDR'POS(CA(2)) OR sp = ADDR'POS(CA(3)) OR sp = ADDR'POS(CA(4))) THEN
          space_types(sp) <= CARRIER;
        END IF;
      END LOOP type_loop;

      -- Set all states to FREE
      state_loop : FOR s IN 0 TO 99 LOOP
        space_states(s) <= FREE;
      END LOOP state_loop;

      destroyer_count <= 1;
      submarine1_count <= 2;
      submarine2_count <= 2;
      cruiser_count <= 2;
      battleship_count <= 3;
      carrier_count <= 4;

    ELSIF Won = '0' AND Turn = '0' THEN
      -- Other player fired a shot at this piece
      IF Turn = '0' AND Fired = '1' THEN
        result_location <= location;
        IF space_states(ADDR'POS(Location)) = FREE THEN
          CASE space_types(ADDR'POS(Location)) IS
            WHEN VACANT =>
              space_states(ADDR'POS(Location)) <= MISS;
              result_int <= MISS;

            WHEN DESTROYER =>
              IF destroyer_count = 0 THEN
                result_int <= SUNK;
                sink_destroyer : FOR i IN 0 TO 1 LOOP
                  space_states(ADDR'POS(D(i))) <= SUNK;
                END LOOP;
              ELSE
                destroyer_count <= destroyer_count - 1;
                space_states(ADDR'POS(Location)) <= HIT;
                result_int <= HIT;
              END IF;

            WHEN SUBMARINE1 =>
              IF submarine1_count = 0 THEN
                result_int <= SUNK;
                sink_sub1 : FOR i IN 0 TO 2 LOOP
                  space_states(ADDR'POS(S1(i))) <= SUNK;
                END LOOP;
              ELSE
                submarine1_count <= submarine1_count - 1;
                space_states(ADDR'POS(Location)) <= HIT;
                result_int <= HIT;
              END IF;

            WHEN SUBMARINE2 =>
              IF submarine2_count = 0 THEN
                result_int <= SUNK;
                sink_sub2 : FOR i IN 0 TO 2 LOOP
                  space_states(ADDR'POS(S2(i))) <= SUNK;
                END LOOP;
              ELSE
                submarine2_count <= submarine2_count - 1;
                space_states(ADDR'POS(Location)) <= HIT;
                result_int <= HIT;
              END IF;

            WHEN CRUISER =>
              IF cruiser_count = 0 THEN
                result_int <= SUNK;
                sink_cruiser : FOR i IN 0 TO 2 LOOP
                  space_states(ADDR'POS(CR(i))) <= SUNK;
                END LOOP;
              ELSE
                cruiser_count <= cruiser_count - 1;
                space_states(ADDR'POS(Location)) <= HIT;
                result_int <= HIT;
              END IF;

            WHEN BATTLESHIP =>
              IF battleship_count = 0 THEN
                result_int <= SUNK;
                sink_battleship : FOR i IN 0 TO 2 LOOP
                  space_states(ADDR'POS(B(i))) <= SUNK;
                END LOOP;
              ELSE
                battleship_count <= battleship_count - 1;
                space_states(ADDR'POS(Location)) <= HIT;
                result_int <= HIT;
              END IF;

            WHEN CARRIER =>
              IF carrier_count = 0 THEN
                result_int <= SUNK;
                sink_carrier : FOR i IN 0 TO 2 LOOP
                  space_states(ADDR'POS(CA(i))) <= SUNK;
                END LOOP;
              ELSE
                carrier_count <= carrier_count - 1;
                space_states(ADDR'POS(Location)) <= HIT;
                result_int <= HIT;
              END IF;

          END CASE;
        END IF;
      END IF;

      -- Check if you lost
      IF destroyer_count = 0 AND submarine1_count = 0 AND submarine2_count = 0 AND
         cruiser_count = 0 AND battleship_count = 0 AND carrier_count = 0 THEN
             Lost <= '1';
      END IF;
    END IF;

    -- Need to send result first to ensure both values are being propagated correctly,
    -- since it's waiting for location to change first. Because results have already
    -- been updated, once location is sent, these values should be synchronized for
    -- the same pair of values.
    Result <= result_int;
    wait for 1 ns;
    ResultLocation <= result_location;
    Turn <= '0';
  END PROCESS;


END ARCHITECTURE behavior;
