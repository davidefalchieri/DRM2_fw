--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: DivVar8bit.vhd
-- File history:
--      1.20151210.1159: Versione iniziale
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::ProASIC3L> <Die::A3P250L> <Package::208 PQFP>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity DivVar8bit is
port (
    NPRESET : in std_logic;
  	DIV     : in std_logic_vector(7 downto 0);
    PCLK    : in std_logic;
    ENABLE  : in std_logic;
--  SQUARE  : inout std_logic;
    PULSE   : out std_logic
);
end DivVar8bit;

architecture struct_DivVar8bit of DivVar8bit is

signal counter : std_logic_vector (7 downto 0);
signal realDIV : std_logic_vector (7 downto 0);

begin 
	Counting : process (PCLK)
	begin
    if PCLK'event and PCLK='1'  then
		if    NPRESET = '0'     then counter <= X"00";           
		elsif ENABLE  = '0'     then counter <= counter;                
		elsif counter = realDIV then counter <= X"00";           
		else                              counter <= counter + X"01"; 
		end if;
		
		if ENABLE = '1' and counter = realDIV and NPRESET = '1' then PULSE <= '1'; else PULSE <= '0'; end if;

        realDIV <= DIV-X"01";

	end if;
	end process;

   
end struct_DivVar8bit;
