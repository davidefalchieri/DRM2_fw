-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            23/08/05
-- ----------------------------------------------------------------------------
-- Module:          LVC16244
-- Description:     3-STATE BUFFER
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY LVC16244 IS
   PORT( 
      A1  : IN     std_logic;
      A2  : IN     std_logic;
      A3  : IN     std_logic;
      A4  : IN     std_logic;
      NOE : IN     std_logic;
      Y1  : OUT    std_logic;
      Y2  : OUT    std_logic;
      Y3  : OUT    std_logic;
      Y4  : OUT    std_logic
   );

-- Declarations

END LVC16244 ;


ARCHITECTURE BEHAV OF LVC16244 IS


  begin


  Y1    <= To_X01(A1) when NOE = '0' else 'Z';
  Y2    <= To_X01(A2) when NOE = '0' else 'Z';
  Y3    <= To_X01(A3) when NOE = '0' else 'Z';
  Y4    <= To_X01(A4) when NOE = '0' else 'Z';


END BEHAV;

