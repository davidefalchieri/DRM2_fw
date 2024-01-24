--!------------------------------------------------------------------------
--! Project       A2795 
--! @author       Annalisa Mati  (a.mati@caen.it)                     
--!               Luca Colombini (l.colombini@caen.it)                     
--! @date         Apr 2014                                                 
--! @file         FDIV.vhd                                                       
--! Contact       support.frontend@caen.it                                 
--!------------------------------------------------------------------------
--! @brief                                                                 
--!------------------------------------------------------------------------
--! $Id: FDIV.vhd 30 2014-11-05 13:22:11Z mati $ FDIV.vhd 28 2014-11-05 13:19:58Z mati $                                                                   
--!------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------
entity FDIV is
---------------------------
  generic (
    FXTAL : positive := 100E6;     -- System Clock Frequency
    DEBUG : boolean  := false  );  -- True in simulation to speed up the simulation
  port (  clk       : in  std_logic;
          reset     : in  std_logic;
          TICK500NS : out std_logic;
          TICK1US   : out std_logic;
          TICK10US  : out std_logic;
          TICK100US : out std_logic;
          TICK1MS   : out std_logic;
          TICK10MS  : out std_logic;
          TICK50MS  : out std_logic;
          TICK100MS : out std_logic;
          TICK1S    : out std_logic  
          );
end entity FDIV;

---------------------------------------
architecture RTL of FDIV is
---------------------------------------

  -- TICK500NS division signals
  constant TICK500NS_DIVISOR : positive := FXTAL / 2000000;   
  signal TICK500NS_DIV       : integer range 0 to TICK500NS_DIVISOR;

  signal iTICK500NS : std_logic; 
  signal iTICK1US   : std_logic; 
  signal iTICK10US  : std_logic; 
  signal iTICK100US : std_logic;
  signal iTICK1MS   : std_logic;
  signal iTICK10MS  : std_logic;
  signal iTICK50MS  : std_logic;
  signal iTICK100MS : std_logic;
  signal iTICK1S    : std_logic;

  signal CNT0       : integer range 0 to 1;  
  signal CNT1       : integer range 0 to 9; 
  signal CNT2       : integer range 0 to 9;
  signal CNT3       : integer range 0 to 9;
  signal CNT4       : integer range 0 to 9;
  signal CNT5       : integer range 0 to 9;
  signal CNT6       : integer range 0 to 9;  
  signal CNT7       : integer range 0 to 4;  


---------
begin
---------

  TICK500NS <= iTICK500NS; 
  TICK1US   <= iTICK1US; 
  TICK10US  <= iTICK10US; 
  TICK100US <= iTICK100US;
  TICK1MS   <= iTICK1MS;  
      
  G1 : if not DEBUG generate
    TICK10MS  <= iTICK10MS; 
    TICK50MS  <= iTICK50MS; 
    TICK100MS <= iTICK100MS;
    TICK1S    <= iTICK1S;
  end generate G1;
  
  G2 : if DEBUG generate
    TICK10MS  <= iTICK100US;
    TICK50MS  <= iTICK1MS; 
    TICK100MS <= iTICK10MS;
    TICK1S    <= iTICK1MS;
  end generate G2;

  process (reset, clk)
  begin
    if(reset = '1') then
      iTICK500NS    <= '0';
      iTICK1US      <= '0';
      iTICK10US     <= '0';
      iTICK100US    <= '0';
      iTICK1MS      <= '0';
      iTICK10MS     <= '0';
      iTICK50MS     <= '0';
      iTICK100MS    <= '0';
      iTICK1S       <= '0';
      TICK500NS_DIV <= 0;
      CNT0          <= 0;
      CNT1          <= 0;
      CNT2          <= 0;
      CNT3          <= 0;
      CNT4          <= 0;
      CNT5          <= 0;
      CNT6          <= 0;

    elsif(rising_edge(clk)) then

      iTICK500NS <= '0';
      iTICK1US   <= '0';
      iTICK10US  <= '0';
      iTICK100US <= '0';
      iTICK1MS   <= '0';
      iTICK10MS  <= '0';
      iTICK50MS  <= '0';
      iTICK100MS <= '0';
      iTICK1S    <= '0';

      if TICK500NS_DIV < TICK500NS_DIVISOR-1 then
        TICK500NS_DIV <= TICK500NS_DIV + 1;
      else
        TICK500NS_DIV <= 0;
        iTICK500NS    <= '1';
      end if;

      if iTICK500NS = '1' then
        if CNT0 < 1 then
          CNT0 <= CNT0 + 1;
        else
          CNT0 <= 0;
          iTICK1US <= '1';
        end if;
      end if;

      if iTICK1US = '1' then
        if CNT6 < 9 then
          CNT6 <= CNT6 + 1;
        else
          CNT6 <= 0;
          iTICK10US <= '1';
        end if;
      end if;
      
      if iTICK10US = '1' then
        if CNT1 < 9 then
          CNT1 <= CNT1 + 1;
        else
          CNT1 <= 0;
          iTICK100US <= '1';
        end if;
      end if;

      if iTICK100US = '1' then
        if CNT2 < 9 then
          CNT2 <= CNT2 + 1;
        else
          CNT2 <= 0;
          iTICK1MS <= '1';
        end if;
      end if;

      if iTICK1MS = '1' then
        if CNT3 < 9 then
          CNT3 <= CNT3 + 1;
        else
          CNT3 <= 0;
          iTICK10MS <= '1';
        end if;
      end if;

      if iTICK10MS = '1' then
        if CNT4 < 9 then
          CNT4 <= CNT4 + 1;
        else
          CNT4 <= 0;
          iTICK100MS <= '1';
        end if;
      end if;

      if iTICK10MS = '1' then
        if CNT7 < 4 then
          CNT7 <= CNT7 + 1;
        else
          CNT7 <= 0;
          iTICK50MS <= '1';
        end if;
      end if;
      
      if iTICK100MS = '1' then
        if CNT5 < 9 then
          CNT5 <= CNT5 + 1;
        else
          CNT5 <= 0;
          iTICK1S <= '1';
        end if;
      end if;

    end if;
  end process;

end architecture RTL;