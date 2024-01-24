-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            28/09/05
-- --------------------------------------------------------------------------
-- Module:          CLK_INTERFF
-- Description:     RTL module: Interface to Roboclock and clock management 
--                  circuits.
-- ****************************************************************************

-- ############################################################################
-- Revision History:
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.v1392pkg.all;

ENTITY CLK_INTERF IS
   PORT(
       CLK       : IN    std_logic;
       HWRES     : IN    std_logic;

       -- Roboclock configuration
       RSELA0    : out   std_logic;
       RSELA1    : out   std_logic;
       RSELB0    : out   std_logic;
       RSELB1    : out   std_logic;
       RSELC0    : out   std_logic;
       RSELC1    : out   std_logic;
       RSELD0    : out   std_logic;
       RSELD1    : out   std_logic;
       
       -- Roboclock clock source selection
       SELCLK    : out   std_logic;
       NSELCLK   : out   std_logic;
       
       -- Loss
       LOS       : in    std_logic;
       
       REG       : INOUT reg_stream;
       PULSE     : IN    reg_pulse;
       TICK      : IN    tick_pulses;

       DEBUG     : INOUT debug_stream
   );

END CLK_INTERF ;


--
ARCHITECTURE RTL OF CLK_INTERF IS
   
   signal ROBO_SOURCE : std_logic;
   
BEGIN
   
   REG   <= (others => 'Z');
   DEBUG <= (others => 'Z');
   
   --
   ROBO_SOURCE <= REG(CLK_SOURCE); -- '0' = LOCAL CLOCK (OSCILLATOR)
                                   -- '1' = ALICLK
                       
   SELCLK  <= not(ROBO_SOURCE);
   NSELCLK <= ROBO_SOURCE;
   
   RSELA0  <= REG(CLKSEL'low+7) when REG(CLKHIZ'low+7)='0' else 'Z';
   RSELA1  <= REG(CLKSEL'low+6) when REG(CLKHIZ'low+6)='0' else 'Z';
   RSELB0  <= REG(CLKSEL'low+5) when REG(CLKHIZ'low+5)='0' else 'Z';
   RSELB1  <= REG(CLKSEL'low+4) when REG(CLKHIZ'low+4)='0' else 'Z';
   RSELC0  <= REG(CLKSEL'low+3) when REG(CLKHIZ'low+3)='0' else 'Z';
   RSELC1  <= REG(CLKSEL'low+2) when REG(CLKHIZ'low+2)='0' else 'Z';
   RSELD0  <= REG(CLKSEL'low+1) when REG(CLKHIZ'low+1)='0' else 'Z';
   RSELD1  <= REG(CLKSEL'low+0) when REG(CLKHIZ'low+0)='0' else 'Z';
  
   REG(S_LOS) <= LOS;
   
END RTL;

