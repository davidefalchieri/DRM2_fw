-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           VX1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini 
-- Date:            14/12/07
-- --------------------------------------------------------------------------
-- Module:          SPARE
-- Description:     RTL module: Manage LOcal Bus Spare signals
-- $Log: lbspare.vhd,v $
-- Revision 1.4  2008/03/13 13:20:39  Colombini
-- *** empty log message ***
--
-- **************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1392pkg.all;

ENTITY lbspare IS
  PORT(
       
       RUN       : IN    std_logic;
       LOS       : IN    std_logic;
       SM_SIDE   : IN    std_logic; -- Super Module side
       -- Signals from/to P2
       L0        : IN    std_logic; -- level 0 trigger
       L1A       : IN    std_logic; -- level 1 trigger, accept
       L1R       : IN    std_logic; -- level 1 trigger, reject
       L2A       : IN    std_logic; -- level 2 trigger, accept
       L2R       : IN    std_logic; -- level 2 trigger, reject
       BNC_RES   : IN    std_logic; -- BNC Reset (sincrono con CLK)
       EV_RES    : IN    std_logic; -- Event Reset
       -- Pulse from DRM
       SPULSE0   : IN    std_logic;
       SPULSE1   : IN    std_logic;
       SPULSE2   : IN    std_logic;
              
       LBSP      : INOUT std_logic_vector(31 downto 0);
              
       REG       : INOUT reg_stream
      );
END ENTITY lbspare;

--
ARCHITECTURE rtl OF lbspare IS
BEGIN

  REG   <= (others => 'Z');

-- Interface to TEST TRIGGER FPGA
-- LBSP(0)  => SRAM nCS
-- LBSP(1)  => SRAM nOE
-- This pins are reserved for CAEN internal production test.

  LBSP_DRIVER0: for i in 0 to 1 generate
    LBSP(i) <= REG(LBSPCTRL'low+i) when REG(LBSPDIR'low+i) = '0' else 'Z';
  end generate;
  
 -- Reserved pins as outputs towards Cyclone
  LBSP(2) <= BNC_RES;
  LBSP(3) <= EV_RES;
  LBSP(4) <= L0;
  LBSP(5) <= L1A;
  LBSP(6) <= L1R;
  LBSP(7) <= L2A;
  LBSP(8) <= L2R;
  LBSP(9) <= RUN;
  LBSP(10)<= LOS;
  LBSP(11)<= SPULSE0;
  LBSP(12)<= SPULSE1;
  LBSP(13)<= SPULSE2;
  LBSP(14)<= SM_SIDE;
    
  LBSP_DRIVER1: for i in 15 to 31 generate
    LBSP(i) <= REG(LBSPCTRL'low+i) when REG(LBSPDIR'low+i) = '0' else 'Z';
  end generate;  
  
END ARCHITECTURE rtl;

