-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           Scheda test ACTEL APA100
-- FPGA Proj. Name: APAtst_board
-- Device:          ACTEL APA100 PQ208
-- Author:          Annalisa Mati
-- Date:            14/09/04
-- ----------------------------------------------------------------------------
-- Module:          MONOSTABLE
-- Description:     Fixed Time Monostable for LED driving
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY MONOSTABLE IS
   PORT( 
      CLK     : IN     std_logic;
      RESET   : IN     std_logic;
      TICK    : IN     std_logic;
      MONIN   : IN     std_logic;
      MONOUT  : OUT    std_logic
   );

-- Declarations

END MONOSTABLE ;


  -- *****************************************************************************
  -- TICK
  -- Un Tick e' un impulso che dura 1 periodo di CLK e viene ripetuto ogni N periodi
  -- *****************************************************************************
  -- T64:  Periodo=Tclk*64  (circa 1.6us a 40MHz)
  -- T16K: Periodo=Tclk*16K (circa 410us a 40MHz)
  -- T2M:  Periodo=Tclk*4M  (circa 104ms a 40MHz)

ARCHITECTURE RTL OF MONOSTABLE IS

--signal TMONOS : std_logic_vector(1 downto 0) := (others => '0');
signal TMONOS : std_logic := '0';

begin

  -- MONOUT si setta al primo fronte di CLK con MONIN=0 e si resetta
  -- dopo 1 colpi di TICK (o resta alto se MONIN resta alto)
  process(CLK,RESET,MONIN)
  begin
    if RESET = '0' then
      TMONOS <= '0';
      MONOUT <= '0';
    elsif MONIN = '0' then
      TMONOS <= '1';
      MONOUT <= '1';
    elsif CLK'event and CLK='1' then
      if TICK = '1' then
        if TMONOS = '1' then
          TMONOS <= '0';
        else
          MONOUT <= '0';
        end if;
      end if;
    end if;
  end process;
  
END RTL;

