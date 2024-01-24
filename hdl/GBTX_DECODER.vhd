--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: GBTX_DECODER.vhd
-- File history:
--      1.20170801.1647: Inserita state machine in Command Read
--      1.20170710.1425: Nuova versione con registri di controllo GBTx
--      1.20170404.1540: Validazione
--      1.20151210.1200: Modifiche su indirizzamento Power
--      1.20150915.1610: Modificata sequenza GBTX control signal
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

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity GBTX_Decoder is
port (
		ENCMD  : in    std_logic;
		ENDATA : in    std_logic;
		ENWR   : in    std_logic;
		DIN    : in    std_logic_vector(7 downto 0);
		DOUT   : out   std_logic_vector(7 downto 0);
		FRDY   : out   std_logic;
		FRDYi  : in    std_logic;
		FERR   : out   std_logic;
		FERRi  : in    std_logic;
		FEND   : out   std_logic;
		FENDi  : in    std_logic;
--      DataCounter   : in    std_logic_vector(8 downto 0);
--------------------------------------------------------------------------------
		GDI   : out   std_logic_vector(7  downto 0); --  GBTX register data input, output in questo modulo
		GDO   : in    std_logic_vector(7  downto 0); --  GBTX register data output, input in questo modulo
		GWR   : out   std_logic;                     --  GBTX register write command 
		GEN   : out   std_logic;                     --  GBTX register enable command 
		GADD  : out   std_logic_vector(7  downto 0); --  GBTX register address
		GADDi : in    std_logic_vector(7  downto 0); --  GBTX register address
--------------------------------------------------------------------------------
--      SigORed : in  std_logic;
		RESETn   : in  std_logic;
		CLK     : in  std_logic
);
end GBTX_Decoder;
architecture ARCH_GBTX_DECODER of GBTX_Decoder is
   -- signal, component etc. declarations

-------- I2C COMMAND constant
constant cGI2CDATA : std_logic_vector(7 downto 0) :=x"30"; 

-------- Signals
signal COMMAND : std_logic_vector(7 downto 0);

signal DataCounter : std_logic_vector(8 downto 0) := "000000000" ; 
signal NumOfData   : std_logic_vector(8 downto 0) := "000000000" ; 

begin	
	Decoder_SM : process(CLK)
	variable GBUSsequence : integer range 0 to 7;	
	begin
	if CLK'event and CLK='1' then
--- D00 -------------------------------------------------------------------------
		if RESETn='0' then
			COMMAND <= x"FF";
			FERR    <= '0'; FRDY  <= '0'; FEND <= '0';
			DOUT    <= X"00";
			GDI   <= X"00";
			GADD  <= X"00"; GWR <= '0'; GEN <= '0';
--          GADDinc <= '0';
			GBUSsequence := 0;
--- D01 -------------------------------------------------------------------------
		elsif (FERRi='1' or FENDi='1' or FRDYi='1') then
			if ENCMD='0' and ENDATA='0' then
				FERR <= '0'; FEND <= '0'; FRDY <= '0';
				GBUSsequence := 0;							 
			end if;
		else
--- D02   - Command write, salvato in COMMAND ----------------------------------
			if ENCMD='1' and ENWR='1' then
				FRDY <= '1'; FERR <= '0'; FEND <= '0';
				DataCounter <= "000000001";
				COMMAND <= DIN;
				if DIN=cGI2CDATA then
					NumOfData <= '1' & x"B3";
				else
					NumOfData <= '0' & x"01";
				end if; 
--- D03    - Data write --------------------------------------------------------
			elsif ENDATA='1' and ENWR='1' then
				case GBUSsequence is 
				when 0 => 	GWR<='1'; GEN<='0'; GBUSsequence:=1; GADD<=COMMAND; GDI<= DIN; 
				when 1 => 	GWR<='1'; GEN<='1'; GBUSsequence:=2; GADD<=COMMAND; GDI<= DIN; 
				when 2 => 	GWR<='1'; GEN<='0'; GBUSsequence:=3; GADD<=COMMAND; GDI<= DIN; 
						  	DataCounter <= "000000001"+DataCounter;
						  	if COMMAND=cGI2CDATA then
								if 	  DataCounter="000000100" then 
									NumOfData(7 downto 0) <= DIN;
									NumOfData(8) <= '0';    
								elsif DataCounter="000000101" then 
									NumOfData(8)          <= DIN(0); 
								end if; -- 6 
							end if;
				when 3 => 	GWR<='0'; GEN<='0'; GBUSsequence:=4; GADD<=COMMAND; GDI<= DIN; 
							FRDY <= '1'; FERR <= '0'; FEND <= '0';
				when others => 
								null;
				end case;							
--- D04    - Command read ------------------------------------------------------
			elsif ENCMD='1' and ENWR='0' then
				DataCounter <= "000000000";
				case GBUSsequence is 
				when 0 => 	GWR <= '0'; GEN <= '0'; GBUSsequence:=1; GADD <= COMMAND; DOUT   <= COMMAND;
				when 1 => 	GWR <= '0'; GEN <= '0'; GBUSsequence:=2; GADD <= COMMAND; DOUT   <= COMMAND; --<-- 1031
				when 2 => 	GWR <= '0'; GEN <= '0'; GBUSsequence:=3; GADD <= COMMAND; DOUT   <= COMMAND;
							FRDY   <= '1'; FERR <= '0'; FEND <= '0';
				when others => null;
				end case;	
--- D05    - Data read ---------------------------------------------------------
			elsif ENDATA='1' and ENWR='0' then
				case GBUSsequence is 
				when 0 => 	GWR<='0'; GEN<='0'; GBUSsequence:=1; GADD<=COMMAND; 
				when 1 => 	GWR<='0'; GEN<='1'; GBUSsequence:=2; GADD<=COMMAND; 
						  	DataCounter <= "000000001"+DataCounter;
				when 2 => 	GWR<='0'; GEN<='0'; GBUSsequence:=3; GADD<=COMMAND; DOUT<=GDO; 
						  	if COMMAND=cGI2CDATA and DataCounter=NumOfData then 
									FRDY <= '0'; FERR <= '0'; FEND <= '1';
							else
									FRDY <= '1'; FERR <= '0'; FEND <= '1';
							end if;
				when others => null;
				end case;	
			end if;
		end if;

	end if;
	end process;
end ARCH_GBTX_DECODER;
