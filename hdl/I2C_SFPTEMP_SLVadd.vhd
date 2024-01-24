--------------------------------------------------------------------------------
-- Company: INFN
--
-- File: I2C_SFPTEMP_SLVadd.vhd
-- File history:
--      20150930:15.00: Start version
--
-- Description: 
--
-- Address definition for simulation
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: Baldus
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity I2C_SFPTEMP_SLVadd is
port (
		TEMPadd00 : out std_logic_vector(7 downto 0);
		TEMPadd01 : out std_logic_vector(7 downto 0);
		TEMPadd02 : out std_logic_vector(7 downto 0);
		TEMPadd03 : out std_logic_vector(7 downto 0);
		TEMPadd04 : out std_logic_vector(7 downto 0);
		TEMPadd05 : out std_logic_vector(7 downto 0);
		TEMPadd06 : out std_logic_vector(7 downto 0);
		SFPp0add  : out std_logic_vector(7 downto 0);
		SFPp1add  : out std_logic_vector(7 downto 0));
end I2C_SFPTEMP_SLVadd;
architecture I2C_SFPTEMP_SLVadd_arch of I2C_SFPTEMP_SLVadd is
begin
		TEMPadd00 <= "10010000"; -- 90";
		TEMPadd01 <= "10010010"; -- 92";
		TEMPadd02 <= "10010100"; -- 94";
		TEMPadd03 <= "10010110"; -- 96";
		TEMPadd04 <= "10011000"; -- 98";
		TEMPadd05 <= "10011010"; -- 9A";
		TEMPadd06 <= "10011100"; -- 9C";
		SFPp0add  <= "10100000"; -- A0";
		SFPp1add  <= "10100010"; -- A2";
end I2C_SFPTEMP_SLVadd_arch;
