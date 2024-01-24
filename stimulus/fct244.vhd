-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- ----------------------------------------------------------------------------
-- Module:          FCT244
-- Description:     244 BUFFER (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY FCT244 IS
   PORT(
      A0    : IN   std_logic;
      A1    : IN   std_logic;
      A2    : IN   std_logic;
      A3    : IN   std_logic;
      A4    : IN   std_logic;
      A5    : IN   std_logic;
      A6    : IN   std_logic;
      A7    : IN   std_logic;
      B0    : OUT  std_logic;
      B1    : OUT  std_logic;
      B2    : OUT  std_logic;
      B3    : OUT  std_logic;
      B4    : OUT  std_logic;
      B5    : OUT  std_logic;
      B6    : OUT  std_logic;
      B7    : OUT  std_logic;
      NOEAB : IN   std_logic
   );


END FCT244 ;


ARCHITECTURE BEHAV OF FCT244 IS

  begin

  B0    <= A0 when NOEAB = '0' else 'Z';
  B1    <= A1 when NOEAB = '0' else 'Z';
  B2    <= A2 when NOEAB = '0' else 'Z';
  B3    <= A3 when NOEAB = '0' else 'Z';
  B4    <= A4 when NOEAB = '0' else 'Z';
  B5    <= A5 when NOEAB = '0' else 'Z';
  B6    <= A6 when NOEAB = '0' else 'Z';
  B7    <= A7 when NOEAB = '0' else 'Z';

END BEHAV;

