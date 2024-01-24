--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Div5000.vhd
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

entity Div5000 is
port (
    NPRESET : in std_logic;
---	DIV     : in std_logic_vector(10 downto 0);
    PCLK    : in std_logic;
    ENABLE  : in std_logic;
--  SQUARE  : inout std_logic;
    PULSE   : out std_logic
);
end Div5000;

architecture struct_Div5000 of Div5000 is

signal counter : std_logic_vector (15 downto 0);

begin 
	Counting : process (PCLK)
	begin
    if PCLK'event and PCLK='1' then
		if    NPRESET = '0'    then counter <= X"0000";           
		elsif ENABLE  = '0'    then counter <= counter;                
		elsif counter = X"1387"    then counter <= X"0000";           
		else                              counter <= counter + X"0001"; 
		end if;
		
		if ENABLE = '1' and counter = X"1387" and NPRESET = '1' then PULSE <= '1'; else PULSE <= '0'; end if;

	end if;
	end process;
end struct_Div5000;
