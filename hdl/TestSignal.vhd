--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: TestSignal.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description:
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL090T> <Package::676 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity TestSignal is
port (
-------------------------------------------
	Data       : IN std_logic_vector(31 downto 1);
-------------------------------------------
	Debug1in   : IN  std_logic; -- example
	Debug2in   : IN  std_logic; -- example
	DebugSin   : IN  std_logic; -- example
	Debug1out  : OUT  std_logic; -- example
	Debug2out  : OUT  std_logic; -- example
	DebugSout  : OUT  std_logic; -- example
-------------------------------------------
    TestSignalSel : IN std_logic_vector(7 downto 0); -- PORT bit 7:6, signal bit 5:0. 01 Debug1out; 10 Debug2out; 11 DebugSout;
	nRESET : in std_logic;
	CLK    : in std_logic
);
end TestSignal;
architecture architecture_TestSignal of TestSignal is
signal Debug1Sel : std_logic_vector(5 downto 0);
signal Debug2Sel : std_logic_vector(5 downto 0);
signal DebugSSel : std_logic_vector(5 downto 0);

begin
	Selector_handler : process (CLK)
	begin
	if clk'event and clk='1' then
		if nRESET='0' then
			Debug1Sel <= "000000";
			Debug2Sel <= "000000";
			DebugSSel <= "000000";
		else
			case TestSignalSel(7 downto 6) is
			when "01" => Debug1Sel <= TestSignalSel(5 downto 0);
			when "10" => Debug2Sel <= TestSignalSel(5 downto 0);
			when "11" => DebugSSel <= TestSignalSel(5 downto 0);
			when others => null;
            end case;
		end if;
	end if;
	end process;

	DataSelector_handler : process (nRESET, Debug1in, Debug2in, DebugSin, Data)
	begin
--	if clk'event and clk='1' then
		if nRESET='0' then
			Debug1out <= Debug1in;
			Debug2out <= Debug2in;
			DebugSout <= DebugSin;
		else
			case Debug1Sel is
			when "000000" => Debug1out <= Debug1in;
			when "000001" => Debug1out <= Data(1);
			when "000010" => Debug1out <= Data(2);
			when "000011" => Debug1out <= Data(3);
			when "000100" => Debug1out <= Data(4);
			when "000101" => Debug1out <= Data(5);
			when "000110" => Debug1out <= Data(6);
			when "000111" => Debug1out <= Data(7);
			when "001000" => Debug1out <= Data(8);
			when "001001" => Debug1out <= Data(9);
			when "001010" => Debug1out <= Data(10);
			when "001011" => Debug1out <= Data(11);
			when "001100" => Debug1out <= Data(12);
			when "001101" => Debug1out <= Data(13);
			when "001110" => Debug1out <= Data(14);
			when "001111" => Debug1out <= Data(15);
			when "010000" => Debug1out <= Data(16);
			when "010001" => Debug1out <= Data(17);
			when "010010" => Debug1out <= Data(18);
			when "010011" => Debug1out <= Data(19);
			when "010100" => Debug1out <= Data(20);
			when "010101" => Debug1out <= Data(21);
			when "010110" => Debug1out <= Data(22);
			when "010111" => Debug1out <= Data(23);
			when "011000" => Debug1out <= Data(24);
			when "011001" => Debug1out <= Data(25);
			when "011010" => Debug1out <= Data(26);
			when "011011" => Debug1out <= Data(27);
			when "011100" => Debug1out <= Data(28);
			when "011101" => Debug1out <= Data(29);
			when "011110" => Debug1out <= Data(30);
--			when "011111" => Debug1out <= Data(31);
--			when "100000" => Debug1out <= Data(32);
--			when "100001" => Debug1out <= Data(33);
--			when "100010" => Debug1out <= Data(34);
--			when "100011" => Debug1out <= Data(35);
--			when "100100" => Debug1out <= Data(36);
--			when "100101" => Debug1out <= Data(37);
--			when "100110" => Debug1out <= Data(38);
--			when "100111" => Debug1out <= Data(39);
--			when "101000" => Debug1out <= Data(40);
--			when "101001" => Debug1out <= Data(41);
--			when "101010" => Debug1out <= Data(42);
--			when "101011" => Debug1out <= Data(43);
--			when "101100" => Debug1out <= Data(44);
--			when "101101" => Debug1out <= Data(45);
--			when "101110" => Debug1out <= Data(46);
--			when "101111" => Debug1out <= Data(47);
--			when "110000" => Debug1out <= Data(48);
--			when "110001" => Debug1out <= Data(49);
--			when "110010" => Debug1out <= Data(50);
--			when "110011" => Debug1out <= Data(51);
--			when "110100" => Debug1out <= Data(52);
--			when "110101" => Debug1out <= Data(53);
--			when "110110" => Debug1out <= Data(54);
--			when "110111" => Debug1out <= Data(55);
--			when "111000" => Debug1out <= Data(56);
--			when "111001" => Debug1out <= Data(57);
--			when "111010" => Debug1out <= Data(58);
--			when "111011" => Debug1out <= Data(59);
--			when "111100" => Debug1out <= Data(60);
--			when "111101" => Debug1out <= Data(61);
--			when "111110" => Debug1out <= Data(62);
--			when "111111" => Debug1out <= Data(63);
			when others   => Debug1out <= Debug1in;
			end case;
			case Debug2Sel is
			when "000000" => Debug2out <= Debug2in;
			when "000001" => Debug2out <= Data(1);
			when "000010" => Debug2out <= Data(2);
			when "000011" => Debug2out <= Data(3);
			when "000100" => Debug2out <= Data(4);
			when "000101" => Debug2out <= Data(5);
			when "000110" => Debug2out <= Data(6);
			when "000111" => Debug2out <= Data(7);
			when "001000" => Debug2out <= Data(8);
			when "001001" => Debug2out <= Data(9);
			when "001010" => Debug2out <= Data(10);
			when "001011" => Debug2out <= Data(11);
			when "001100" => Debug2out <= Data(12);
			when "001101" => Debug2out <= Data(13);
			when "001110" => Debug2out <= Data(14);
			when "001111" => Debug2out <= Data(15);
			when "010000" => Debug2out <= Data(16);
			when "010001" => Debug2out <= Data(17);
			when "010010" => Debug2out <= Data(18);
			when "010011" => Debug2out <= Data(19);
			when "010100" => Debug2out <= Data(20);
			when "010101" => Debug2out <= Data(21);
			when "010110" => Debug2out <= Data(22);
			when "010111" => Debug2out <= Data(23);
			when "011000" => Debug2out <= Data(24);
			when "011001" => Debug2out <= Data(25);
			when "011010" => Debug2out <= Data(26);
			when "011011" => Debug2out <= Data(27);
			when "011100" => Debug2out <= Data(28);
			when "011101" => Debug2out <= Data(29);
			when "011110" => Debug2out <= Data(30);
--			when "011111" => Debug2out <= Data(31);
--			when "100000" => Debug2out <= Data(32);
--			when "100001" => Debug2out <= Data(33);
--			when "100010" => Debug2out <= Data(34);
--			when "100011" => Debug2out <= Data(35);
--			when "100100" => Debug2out <= Data(36);
--			when "100101" => Debug2out <= Data(37);
--			when "100110" => Debug2out <= Data(38);
--			when "100111" => Debug2out <= Data(39);
--			when "101000" => Debug2out <= Data(40);
--			when "101001" => Debug2out <= Data(41);
--			when "101010" => Debug2out <= Data(42);
--			when "101011" => Debug2out <= Data(43);
--			when "101100" => Debug2out <= Data(44);
--			when "101101" => Debug2out <= Data(45);
--			when "101110" => Debug2out <= Data(46);
--			when "101111" => Debug2out <= Data(47);
--			when "110000" => Debug2out <= Data(48);
--			when "110001" => Debug2out <= Data(49);
--			when "110010" => Debug2out <= Data(50);
--			when "110011" => Debug2out <= Data(51);
--			when "110100" => Debug2out <= Data(52);
--			when "110101" => Debug2out <= Data(53);
--			when "110110" => Debug2out <= Data(54);
--			when "110111" => Debug2out <= Data(55);
--			when "111000" => Debug2out <= Data(56);
--			when "111001" => Debug2out <= Data(57);
--			when "111010" => Debug2out <= Data(58);
--			when "111011" => Debug2out <= Data(59);
--			when "111100" => Debug2out <= Data(60);
--			when "111101" => Debug2out <= Data(61);
--			when "111110" => Debug2out <= Data(62);
--			when "111111" => Debug2out <= Data(63);
			when others   => Debug2out <= Debug2in;
			end case;
			case DebugSSel is
			when "000000" => DebugSout <= DebugSin;
			when "000001" => DebugSout <= Data(1);
			when "000010" => DebugSout <= Data(2);
			when "000011" => DebugSout <= Data(3);
			when "000100" => DebugSout <= Data(4);
			when "000101" => DebugSout <= Data(5);
			when "000110" => DebugSout <= Data(6);
			when "000111" => DebugSout <= Data(7);
			when "001000" => DebugSout <= Data(8);
			when "001001" => DebugSout <= Data(9);
			when "001010" => DebugSout <= Data(10);
			when "001011" => DebugSout <= Data(11);
			when "001100" => DebugSout <= Data(12);
			when "001101" => DebugSout <= Data(13);
			when "001110" => DebugSout <= Data(14);
			when "001111" => DebugSout <= Data(15);
			when "010000" => DebugSout <= Data(16);
			when "010001" => DebugSout <= Data(17);
			when "010010" => DebugSout <= Data(18);
			when "010011" => DebugSout <= Data(19);
			when "010100" => DebugSout <= Data(20);
			when "010101" => DebugSout <= Data(21);
			when "010110" => DebugSout <= Data(22);
			when "010111" => DebugSout <= Data(23);
			when "011000" => DebugSout <= Data(24);
			when "011001" => DebugSout <= Data(25);
			when "011010" => DebugSout <= Data(26);
			when "011011" => DebugSout <= Data(27);
			when "011100" => DebugSout <= Data(28);
			when "011101" => DebugSout <= Data(29);
			when "011110" => DebugSout <= Data(30);
--			when "011111" => DebugSout <= Data(31);
--			when "100000" => DebugSout <= Data(32);
--			when "100001" => DebugSout <= Data(33);
--			when "100010" => DebugSout <= Data(34);
--			when "100011" => DebugSout <= Data(35);
--			when "100100" => DebugSout <= Data(36);
--			when "100101" => DebugSout <= Data(37);
--			when "100110" => DebugSout <= Data(38);
--			when "100111" => DebugSout <= Data(39);
--			when "101000" => DebugSout <= Data(40);
--			when "101001" => DebugSout <= Data(41);
--			when "101010" => DebugSout <= Data(42);
--			when "101011" => DebugSout <= Data(43);
--			when "101100" => DebugSout <= Data(44);
--			when "101101" => DebugSout <= Data(45);
--			when "101110" => DebugSout <= Data(46);
--			when "101111" => DebugSout <= Data(47);
--			when "110000" => DebugSout <= Data(48);
--			when "110001" => DebugSout <= Data(49);
--			when "110010" => DebugSout <= Data(50);
--			when "110011" => DebugSout <= Data(51);
--			when "110100" => DebugSout <= Data(52);
--			when "110101" => DebugSout <= Data(53);
--			when "110110" => DebugSout <= Data(54);
--			when "110111" => DebugSout <= Data(55);
--			when "111000" => DebugSout <= Data(56);
--			when "111001" => DebugSout <= Data(57);
--			when "111010" => DebugSout <= Data(58);
--			when "111011" => DebugSout <= Data(59);
--			when "111100" => DebugSout <= Data(60);
--			when "111101" => DebugSout <= Data(61);
--			when "111110" => DebugSout <= Data(62);
--			when "111111" => DebugSout <= Data(63);
			when others   => DebugSout <= DebugSin;
			end case;
		end if;
--	end if;
	end process;

end architecture_TestSignal;