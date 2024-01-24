--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2CErrorConv.vhd
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

entity I2CErrorConv is
port (
    ErrorIn  : IN   std_logic_vector(7 downto 0); 
    ErrorOut : OUT  std_logic_vector(7 downto 0)
);
end I2CErrorConv;
architecture architecture_I2CErrorConv of I2CErrorConv is

begin
	Error_handler : process(ErrorIn)
	begin
        case ErrorIn is
        when x"00"	=> ErrorOut <= x"01"; -- Bus error during MST or selected slave modes
		when x"08"	=> ErrorOut <= x"02"; -- A START condition has been transmitted.
		when x"10"	=> ErrorOut <= x"02"; -- A repeated START condition has been transmitted.
		when x"18"	=> ErrorOut <= x"02"; -- SLA + W has been transmitted; ACK has been received.
		when x"20"	=> ErrorOut <= x"03"; -- SLA + W has been transmitted; NACK has been received.
		when x"28"	=> ErrorOut <= x"02"; -- Data byte in Data Register has been transmitted; ACK has been received.
		when x"30"	=> ErrorOut <= x"04"; -- Data byte in Data Register has been transmitted; NACK has been received.
		when x"38"	=> ErrorOut <= x"05"; -- Arbitration lost in SLA + R/W or data bytes.
		when x"40"	=> ErrorOut <= x"02"; -- SLA + R has been transmitted; ACK has been received.
		when x"48"	=> ErrorOut <= x"06"; -- SLA + R has been transmitted; NACK has been received.
		when x"50"	=> ErrorOut <= x"02"; -- Data byte has been received; ACK has been returned.
		when x"58"	=> ErrorOut <= x"02"; -- Data byte has been received; NACK has been returned.
		when x"60"	=> ErrorOut <= x"07"; -- Own SLA + W has been received; ACK has been returned.
		when x"68"	=> ErrorOut <= x"05"; -- Arbitration lost in SLA + R/W as master; own SLA + W has been received, ACK returned.
		when x"70"	=> ErrorOut <= x"08"; -- General call address    has been received; ACK has been returned.
		when x"78"	=> ErrorOut <= x"05"; -- Arbitration lost in SLA + R/W as master; general call address has been received, ACK returned.
		when x"80"	=> ErrorOut <= x"07"; -- Previously addressed with own SLV address; DATA has been received; ACK returned.
		when x"88"	=> ErrorOut <= x"07"; -- Previously addressed with own SLA; DATA byte has been received; NACK returned
		when x"90"	=> ErrorOut <= x"08"; -- Previously addressed with general call address; DATA has been received; ACK returned.
		when x"98"	=> ErrorOut <= x"08"; -- Previously addressed with general call address; DATA has been received; NACK returned.
		when x"A0"	=> ErrorOut <= x"07"; -- A STOP condition or repeated START condition has been received.
		when x"A8"	=> ErrorOut <= x"07"; -- Own SLA + R has been received; ACK has been returned
		when x"B0"	=> ErrorOut <= x"05"; -- Arbitration lost in SLA + R/W as master; own SLA + R has been received; ACK has been returned.
		when x"B8"	=> ErrorOut <= x"07"; -- Data byte has been transmitted; ACK has been received.
		when x"C0"	=> ErrorOut <= x"07"; -- Data byte has been transmitted; NACK has been received.
		when x"C8"	=> ErrorOut <= x"07"; -- Last data byte has transmitted; ACK has received.
		when x"D0"	=> ErrorOut <= x"09"; -- SMB_EN = 1 SMBus Master Reset has been activated.
		when x"D8"	=> ErrorOut <= x"09"; -- SMB_EN = 1 25 ms SCL low time has been reached; device must be reset.
		when x"E0"	=> ErrorOut <= x"02"; -- A STOP Condition has been transmitted
		when x"E8"	=> ErrorOut <= x"0A"; -- Unespected status
		when x"F0"	=> ErrorOut <= x"0A"; -- Unexpected status
		when x"F8"	=> ErrorOut <= x"00"; -- No relevant state information available
		when others => ErrorOut <= x"00"; -- No error
        end case;
    end process;

end architecture_I2CErrorConv;
