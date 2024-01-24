-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- ----------------------------------------------------------------------------
-- Module:          OSC
-- Description:     40MHz oscillator and Power On (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY OSC IS
  port
     (
     Finished : in    std_logic;
     CLK      : out   std_logic;
     NPWON    : out   std_logic
     );

END OSC ;

ARCHITECTURE BEHAV OF OSC IS

constant PERIOD  : time := 25 ns;


begin


  process begin
    NPWON <= '0';
    wait for 20 ns;
    NPWON <= '1';
  wait;
  end process;

  process begin
    wait for 1 ns;
    while Finished = '0' loop
      CLK <= '0';
      wait for PERIOD/2;
      CLK <= '1';
      wait for PERIOD/2;
    end loop;

    wait;
  end process;


END BEHAV;

