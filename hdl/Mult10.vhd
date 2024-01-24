--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Mult10.vhd
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

entity Mult10 is
port (
  	NumIn   : in  std_logic_vector(3 downto 0);
  	NumOut  : out std_logic_vector(7 downto 0);
    PCLK    : in  std_logic
);
end Mult10;

architecture struct_Mult10 of Mult10 is
signal Num : std_logic_vector(7 downto 0);
begin 
	Calculate : process (PCLK)
	begin
    if PCLK'event and PCLK='1'  then Num <= "0000" & NumIn; NumOut <= (Num sll 1) + (Num sll 3); end if;
	end process;
 
end struct_Mult10;
