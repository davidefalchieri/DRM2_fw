-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- --------------------------------------------------------------------------
-- Module:          SRAM
-- Description:     External Sram (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY SRAM IS
   GENERIC(
      DEPTH : integer := 256
   );
   PORT(
      NOERAM : IN     std_logic;
      NWRAM  : IN     std_logic;
      RAMAD  : IN     std_logic_vector;
      RAMDT  : INOUT  std_logic_vector(15 downto 0)
   );

-- Declarations

END SRAM ;

ARCHITECTURE BEHAV OF SRAM IS

  constant DEPTH1 : integer := 65536;

  subtype memcell is std_logic_vector(RAMDT'range);
  type memory_array is array (integer range 0 to DEPTH1-1) of memcell;

  signal mem  : memory_array  := (others => (others => '0'));
  signal data : memcell := (others => '0');

  begin

  -- Scrittura
  data <= transport RAMDT after 1 ns;
  process(NWRAM,NOERAM,RAMAD)
  variable addw : integer range 0 to DEPTH1 := 0;
  begin
    if NWRAM'event and NWRAM='0' then
      addw := conv_integer(RAMAD) mod DEPTH1;
    end if;
    if NWRAM'event and NWRAM='1' then
      mem(addw) <= data;
    end if;
  end process;

  RAMDT <= mem(conv_integer(RAMAD) mod DEPTH1) when NOERAM = '0' and NWRAM = '1' else (others => 'Z');


  -- Lettura
--  process(NOERAM,NWRAM,RAMAD)
--  variable addr : integer range 0 to DEPTH1 := 0;
--  begin
--    if NOERAM = '0' and NWRAM = '1' then
--      addr  := conv_integer(RAMAD) mod DEPTH1;
--      RAMDT <= mem(addr);
--    else
--      RAMDT <= (others => 'Z');
--    end if;
--  end process;



END BEHAV;
