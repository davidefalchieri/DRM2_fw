-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- --------------------------------------------------------------------------
-- Module:          IOPAN
-- Description:     External signals (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY IOPAN IS
   PORT(
       TRM_BUSY  : IN     std_logic;

       L0        : OUT    std_logic; -- level 0 trigger         (not used)
       L1A       : OUT    std_logic; -- level 1 trigger, accept
       L1R       : OUT    std_logic; -- level 1 trigger, reject (not used)
       L2A       : OUT    std_logic; -- level 2 trigger, accept
       L2R       : OUT    std_logic; -- level 2 trigger, reject
       BNC_RESIN : OUT    std_logic; -- TDCs counters reset
       EV_RESIN  : OUT    std_logic; -- TDCs event reset
       HITA      : OUT    std_logic_vector(23 downto 0);   -- HIT dei TDC
       HITB      : OUT    std_logic_vector(23 downto 0);
      -- Segnala la fine della simulazione
       Finished  : OUT    std_logic

      );

END IOPAN ;


ARCHITECTURE BEHAV OF IOPAN IS


BEGIN

  process begin

  Finished <= '0';


  L0  <='0';
  L1A <='0';
  L1R <='0';
  L2A <='0';
  L2R <='0';
  HITA      <= (others => '0');

  BNC_RESIN <='0';
  EV_RESIN  <='0';


  wait for 10 us;

  for i in 0 TO 400 loop

    for j in 0 TO 10 loop
      L2A <='1';
      wait for 25 ns;
      L2A <='0';
      wait for 20 us;
    end loop;

--    BNC_RESIN <='1';
--    wait for 25 ns;
--    BNC_RESIN <='0';
--    wait for 10 us;
  end loop;



  wait for 60 us;

  Finished <= '1';

  wait;
  end process;

END BEHAV;

