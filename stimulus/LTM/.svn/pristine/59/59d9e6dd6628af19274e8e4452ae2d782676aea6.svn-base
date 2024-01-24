-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            23/08/05
-- ----------------------------------------------------------------------------
-- Module:          LVT125
-- Description:     3-STATE BUFFER
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY LVT125 IS
   PORT( 
      A1   : IN     std_logic;
      A2   : IN     std_logic;
      A3   : IN     std_logic;
      A4   : IN     std_logic;
      NOE1 : IN     std_logic;
      NOE2 : IN     std_logic;
      NOE3 : IN     std_logic;
      NOE4 : IN     std_logic;
      Y1   : OUT    std_logic;
      Y2   : OUT    std_logic;
      Y3   : OUT    std_logic;
      Y4   : OUT    std_logic
   );

-- Declarations

END LVT125 ;


ARCHITECTURE BEHAV OF LVT125 IS


  begin


  Y1    <= A1 when NOE1 = '0' else 'Z';
  Y2    <= A2 when NOE2 = '0' else 'Z';
  Y3    <= A3 when NOE3 = '0' else 'Z';
  Y4    <= A4 when NOE4 = '0' else 'Z';


END BEHAV;

