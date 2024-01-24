-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- ----------------------------------------------------------------------------
-- Module:          FCT16543
-- Description:     LATCHED TRANSCEIVER (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY FCT16543 IS
   PORT(
      A0    : INOUT  std_logic;
      A1    : INOUT  std_logic;
      A2    : INOUT  std_logic;
      A3    : INOUT  std_logic;
      A4    : INOUT  std_logic;
      A5    : INOUT  std_logic;
      A6    : INOUT  std_logic;
      A7    : INOUT  std_logic;
      B0    : INOUT  std_logic;
      B1    : INOUT  std_logic;
      B2    : INOUT  std_logic;
      B3    : INOUT  std_logic;
      B4    : INOUT  std_logic;
      B5    : INOUT  std_logic;
      B6    : INOUT  std_logic;
      B7    : INOUT  std_logic;
      NOEAB : IN     std_logic;
      NOEBA : IN     std_logic;
      NCEAB : IN     std_logic;
      NCEBA : IN     std_logic;
      NLEAB : IN     std_logic;
      NLEBA : IN     std_logic
   );


END FCT16543 ;


ARCHITECTURE BEHAV OF FCT16543 IS

  signal AL0, BL0 : std_logic;
  signal AL1, BL1 : std_logic;
  signal AL2, BL2 : std_logic;
  signal AL3, BL3 : std_logic;
  signal AL4, BL4 : std_logic;
  signal AL5, BL5 : std_logic;
  signal AL6, BL6 : std_logic;
  signal AL7, BL7 : std_logic;
  signal CKAB, CKBA, OEAB, OEBA : std_logic;

  begin

  OEAB <= not NOEAB and not NCEAB;
  OEBA <= not NOEBA and not NCEBA;

  CKAB <=  not NLEAB and not NCEAB;
  CKBA <=  not NLEBA and not NCEBA;

  A0    <= BL0 when OEBA = '1' else 'Z';
  A1    <= BL1 when OEBA = '1' else 'Z';
  A2    <= BL2 when OEBA = '1' else 'Z';
  A3    <= BL3 when OEBA = '1' else 'Z';
  A4    <= BL4 when OEBA = '1' else 'Z';
  A5    <= BL5 when OEBA = '1' else 'Z';
  A6    <= BL6 when OEBA = '1' else 'Z';
  A7    <= BL7 when OEBA = '1' else 'Z';
  B0    <= AL0 when OEAB = '1' else 'Z';
  B1    <= AL1 when OEAB = '1' else 'Z';
  B2    <= AL2 when OEAB = '1' else 'Z';
  B3    <= AL3 when OEAB = '1' else 'Z';
  B4    <= AL4 when OEAB = '1' else 'Z';
  B5    <= AL5 when OEAB = '1' else 'Z';
  B6    <= AL6 when OEAB = '1' else 'Z';
  B7    <= AL7 when OEAB = '1' else 'Z';

  LATCHAB : process (CKAB,A0,A1,A2,A3,A4,A5,A6,A7)
  begin
    if CKAB = '1' then
      AL0 <= A0;
      AL1 <= A1;
      AL2 <= A2;
      AL3 <= A3;
      AL4 <= A4;
      AL5 <= A5;
      AL6 <= A6;
      AL7 <= A7;
    end if;
  end process LATCHAB;

  LATCHBA : process (CKBA,B0,B1,B2,B3,B4,B5,B6,B7)
  begin
    if CKBA = '1' then
      BL0 <= B0;
      BL1 <= B1;
      BL2 <= B2;
      BL3 <= B3;
      BL4 <= B4;
      BL5 <= B5;
      BL6 <= B6;
      BL7 <= B7;
    end if;
  end process LATCHBA;

END BEHAV;

