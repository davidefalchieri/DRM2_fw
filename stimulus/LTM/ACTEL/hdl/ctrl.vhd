-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            23/09/05
-- --------------------------------------------------------------------------
-- Module:          LB_INTERF
-- Description:     RTL module: CAEN Local Bus Interface.
--                  It interfaces with Cyclone FPGA on board (Trigger FPGA)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.v1392pkg.all;

ENTITY ctrl IS
   PORT( 
      HWRES    : IN     std_logic;
      CLK      : IN     std_logic;
      DL1      : IN     std_logic;                      -- Pilotaggio led rosso vicino a conn. TDC (su pannello)
      DL2      : IN     std_logic;                      -- Pilotaggio led verde vicino a conn. TDC (su pannello)
      DL5      : IN     std_logic;                      -- Pilotaggio led verde vicino a CTTM (non visibile su pannello)
      DL6      : IN     std_logic;                      -- Pilotaggio led giallo vicino a CTTM (non visibile su pannello)
      DL7      : IN     std_logic;                      -- Pilotaggio led rosso vicino a ALICLK (su pannello)
      DL8      : IN     std_logic;                      -- Pilotaggio led giallo vicino a ALICLK (su pannello)
      DIR_CTTM : OUT    std_logic_vector (7 DOWNTO 0);  -- CTTM LVDS Buffers dir ('0' = RX, '1' = TX)
      LED      : OUT    std_logic_vector (5 DOWNTO 0);  -- LED driver
      PSM_RES  : OUT    std_logic;                      -- Reset micro (active high)
      SP       : OUT    std_logic_vector (5 DOWNTO 0);  -- Spare conn. w/ micro
      REG      : INOUT  reg_stream;
      PULSE    : IN     reg_pulse;
      DEBUG    : INOUT  debug_stream;
      TICK     : IN     tick_pulses
   );

-- Declarations

END ctrl ;

--
ARCHITECTURE rtl OF ctrl IS

  component MONOSTABLE is
     -- generic / port declaration
     PORT( 
       CLK     : IN     std_logic;
       RESET   : IN     std_logic;
       TICK    : IN     std_logic;
       MONIN   : IN     std_logic;
       MONOUT  : OUT    std_logic
     );
  end component MONOSTABLE;
  
  signal LEDint   : std_logic_vector (5 DOWNTO 0);
  signal LEDForce : std_logic;
  signal LEDbus   : std_logic_vector(5 DOWNTO 0);
  
BEGIN
   
   
   PSM_RES     <= '0';             -- Inactive
   DIR_CTTM    <= (others => '1'); -- TX active 
   SP          <= (others => 'Z'); -- SPare Lines to micro
   REG         <= (others => 'Z');
   DEBUG       <= (others => 'Z');  
   
   -- Combinatorial driver
   with LEDForce select
     LED <= LEDbus when '1',
            LEDint when others;
   
   LED0_DRV : MONOSTABLE port map(
            CLK      => CLK,
            RESET    => HWRES,
            TICK     => TICK(T4M), -- 100 ms flash
            MONIN    => DL7,
            MONOUT   => LEDint(0)
           );

   LED1_DRV : MONOSTABLE port map(
            CLK      => CLK,
            RESET    => HWRES,
            TICK     => TICK(T4M), -- 100 ms flash
            MONIN    => DL8,
            MONOUT   => LEDint(1)
           );

  LED2_DRV : MONOSTABLE port map(
            CLK      => CLK,
            RESET    => HWRES,
            TICK     => TICK(T4M), -- 100 ms flash
            MONIN    => DL6,
            MONOUT   => LEDint(2)
           );

   LED3_DRV : MONOSTABLE port map(
            CLK      => CLK,
            RESET    => HWRES,
            TICK     => TICK(T4M), -- 100 ms flash
            MONIN    => DL5,
            MONOUT   => LEDint(3)
           );

   LED4_DRV : MONOSTABLE port map(
            CLK      => CLK,
            RESET    => HWRES,
            TICK     => TICK(T4M), -- 100 ms flash
            MONIN    => DL2,
            MONOUT   => LEDint(4)
           );

   LED5_DRV : MONOSTABLE port map(
            CLK      => CLK,
            RESET    => HWRES,
            TICK     => TICK(T4M), -- 100 ms flash
            MONIN    => DL1,
            MONOUT   => LEDint(5)
           );

  process(HWRES,CLK)
    variable TMONOS : std_logic;
  begin
    if HWRES = '0' then
      TMONOS   := '1';
      LEDForce <= '1';
      LEDbus   <= (others => '1');
    elsif CLK'event and CLK = '1' then
      if TICK(T4M) = '1' then
         if TMONOS = '1' then
          LEDForce <= '1';
          LEDbus   <= (others => '1');
          TMONOS   := '0';
        else
          LEDForce <= REG(LEDCTRL'low+15);
          LEDbus   <= REG(LEDCTRL'low+5 downto LEDCTRL'low+0);
        end if;
      end if;
    end if;
  end process;
    

END rtl;

