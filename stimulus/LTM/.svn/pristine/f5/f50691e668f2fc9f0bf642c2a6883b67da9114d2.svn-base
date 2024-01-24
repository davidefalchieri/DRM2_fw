LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY OSC IS
   PORT(
      Stopclk  : IN     std_logic;
      CLK      : OUT    std_logic;
      RESET    : OUT    std_logic
   );

-- Declarations

END OSC ;

ARCHITECTURE BEHAV OF OSC IS

constant  PERIOD : time := 25 ns;

begin

  process begin
    RESET <= '0';
    wait for 100 ns;
    RESET <= '1';
    wait;
  end process;

  process begin
    wait for 10 ns;
    while Stopclk /= '1' loop
      CLK <= '0';
      wait for PERIOD/2;
      CLK <= '1';
      wait for PERIOD/2;
    end loop;

    wait;
  end process;



END BEHAV;
