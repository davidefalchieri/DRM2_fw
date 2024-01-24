--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity ErrorDebugI2C is
port (
		I2CErrEn    : in   std_logic;
		I2CErr      : in   std_logic_vector(3 downto 0);
		SDAIin      : in   std_logic;
		SCLIin      : in   std_logic;
		SDAIout     : out  std_logic;
		SCLIout     : out  std_logic;
		SDAOin      : in   std_logic;
		SCLOin      : in   std_logic;
		SDAOout     : out  std_logic;
		SCLOout     : out  std_logic;
		DebugEnable : in   std_logic;
		RESETn      : in   std_logic
);
end ErrorDebugI2C;
architecture architecture_ErrorDebugI2C of ErrorDebugI2C is

constant cDT_NoAnsw : std_logic_vector(3 downto 0) := x"0"; -----|     | DEBUG    | x"0" I2C no answer Gbt
constant cDT_SDAto0 : std_logic_vector(3 downto 0) := x"1"; -----|     | DEBUG    | x"1" I2C SDA hold to '0'
constant cDT_SCLto0 : std_logic_vector(3 downto 0) := x"2"; -----|     | DEBUG    | x"2" I2C SCL hold to '0'
constant cDT_SDAto1 : std_logic_vector(3 downto 0) := x"3"; -----|     | DEBUG    | x"3" I2C SDA hold to '1'
constant cDT_SCLto1 : std_logic_vector(3 downto 0) := x"4"; -----|     | DEBUG    | x"4" I2C SCL hold to '1'

begin

	EN_delay_handler : process(I2CErrEn, I2CErr, SDAIin, SCLIin, SDAOin, SCLOin, DebugEnable, RESETn)
	begin
--	if PCLK'event and PCLK='1' then
		if RESETn='0' or DebugEnable='0' or I2CErrEn='0' then 
				SDAIout <= SDAIin;  SDAOout <= SDAOin;
				SCLIout <= SCLIin;  SCLOout <= SCLOin;
		else
            case I2CErr is
            when cDT_NoAnsw =>
				SDAIout <= SDAOin;  SDAOout <= SDAOin;
				SCLIout <= SCLIin;  SCLOout <= SCLOin;
			when cDT_SDAto0 =>
				SDAIout <= '0';     SDAOout <= SDAOin;
				SCLIout <= SCLIin;  SCLOout <= SCLOin;
			when cDT_SCLto0 =>
				SDAIout <= SDAIin;  SDAOout <= SDAOin;
				SCLIout <= '0'   ;  SCLOout <= SCLOin;
			when cDT_SDAto1 =>
				SDAIout <= '1';     SDAOout <= SDAOin;
				SCLIout <= SCLIin;  SCLOout <= SCLOin;
			when cDT_SCLto1 =>
				SDAIout <= SDAIin;  SDAOout <= SDAOin;
				SCLIout <= '1'   ;  SCLOout <= SCLOin;
			when others =>
				SDAIout <= SDAIin;  SDAOout <= SDAOin;
				SCLIout <= SCLIin;  SCLOout <= SCLOin;
			end case;
--		end if;
	end if;
	end process;

end architecture_ErrorDebugI2C;
