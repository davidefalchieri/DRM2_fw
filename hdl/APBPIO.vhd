--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: APBPIO.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

------------------------------------------------------------------------------

library	ieee;
use	ieee.std_logic_1164.all;
use	IEEE.std_logic_unsigned.all; 
use	IEEE.std_logic_arith.all;

Entity APBPIO is
	port (
		PRDATA	: out	std_logic_vector(7	downto 0);	-- 	APB DATA READ
		PWDATA	: in	std_logic_vector(7	downto 0);	-- 	APB DATA WRITE
		PADDR	: in	std_logic_vector(7	downto 0);	-- 	APB ADDRESS
		PSELx	: in	std_logic;						-- 	APB PSELx
		PENABLE	: in	std_logic;						--	APB ENABLE
		PWRITE	: in	std_logic;						-- 	APB WRITE
		PREADY	: out	std_logic;						-- 	APB READY
---------------------------------------------------------
		DATAin	: in	std_logic_vector(7 downto 0);	-- 	I2C data in
		STRBi	: In 	std_logic;						--	Input strobe
		ACKo	: Out	std_logic;						--	ACK answer to input strobe
		LASTi	: In 	std_logic;						--	Last data/start I2C
		DATAout	: Out	std_logic_vector(7 downto 0);	--	Output data register
		BUSY	: Out	std_logic;						--	I2C running
		STRBo	: Out	std_logic;						--	Output strobe
		ACKi	: In 	std_logic;						--	ACK answer to output strobe
		LASTo	: Out	std_logic;						--	Last data
		NPRESET	: in	std_logic;						--	Last data
		PCLK	: in	std_logic);
end	APBPIO;

architecture struct_APBPIO of APBPIO is

-- Module has 9	registers inside
-------------------------------------------------+-----------+--------+------------+------------------------------+
-- Register address constant definition ---------|   PADDR   |  NAME  |   DEFAULT  |             NOTE             |
-------------------------------------------------+-----------+--------+------------+------------------------------+
constant aDATAin  : std_logic_vector(7 downto 0) := X"00"; --| DATAin |   Input    | Input data register          |
constant aSTRBi   : std_logic_vector(7 downto 0) := X"01"; --| STRBi  |   Input    | Input strobe                 |
constant aACKo    : std_logic_vector(7 downto 0) := X"02"; --| ACKo   |   Output   | ACK answer to input strobe   |
constant aLASTi   : std_logic_vector(7 downto 0) := X"03"; --| LASTi  |   Input    | Last data/start I2C          |
constant aBUSY    : std_logic_vector(7 downto 0) := X"04"; --| BUSY   |   Output   | I2C running                  |
constant aDATAout : std_logic_vector(7 downto 0) := X"07"; --| DATAout|   Output   | Output data register         |
constant aSTRBo   : std_logic_vector(7 downto 0) := X"08"; --| STRBo  |   Output   | Output strobe                |
constant aACKi    : std_logic_vector(7 downto 0) := X"09"; --| ACKi   |   Input    | ACK answer to output stobe   |
constant aLASTo   : std_logic_vector(7 downto 0) := X"0A"; --| LASTo  |   Output   | Last data                    |
-------------------------------------------------+-----------+--------+------------+------------------------------+

signal ENAB : std_logic;

begin

	ENAB_handler	: process(PSELx, PENABLE) begin	ENAB <=	PSELx and PENABLE; end process;	

	DataAccess : process(PCLK)
	begin
	if PCLK'event and PCLK='1' then
		if NPRESET='0' then
			PREADY  <= '0';
			DATAout <=	"00000000";
			ACKo	<= '0';
			BUSY	<= '0';
			STRBo	<= '0';
			LASTo	<= '0';
		elsif ENAB='1' then
			if PWRITE='0' then
				case PADDR is
				when aDATAin  	=> PRDATA <= DATAin;
				when aSTRBi   	=> PRDATA <= "0000000" & STRBi;
				when aLASTi   	=> PRDATA <= "0000000" & LASTi;
				when aACKi    	=> PRDATA <= "0000000" & ACKi; 
				when others		=> PRDATA <= X"FF";
				end	case;
				PREADY <= '1';
			else
				case PADDR is
				when aACKo    	=> ACKo   <= PWDATA(0);
				when aBUSY    	=> BUSY   <= PWDATA(0);
				when aDATAout 	=> DATAout<= PWDATA;
				when aSTRBo   	=> STRBo  <= PWDATA(0);
				when aLASTo   	=> LASTo  <= PWDATA(0);
				when others		=> PRDATA <= PWDATA;
				end	case;
				PREADY <= '1';
			end	if;
		else
			PREADY <= '0';
		end	if;

	end	if;
	end	process;
end	struct_APBPIO;