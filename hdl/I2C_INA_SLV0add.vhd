--------------------------------------------------------------------------------
-- Company: INFN
--
-- File: I2C_INA_SLV0add.vhd
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

entity I2C_INA_SLV0add is
port (
		INAadd00 : out std_logic_vector(7 downto 0);
		INAadd01 : out std_logic_vector(7 downto 0);
		INAadd02 : out std_logic_vector(7 downto 0);
		INAadd03 : out std_logic_vector(7 downto 0);
		INAadd04 : out std_logic_vector(7 downto 0);
		INAadd05 : out std_logic_vector(7 downto 0);
		INAadd06 : out std_logic_vector(7 downto 0));
end I2C_INA_SLV0add;
architecture I2C_INA_SLV0add_arch of I2C_INA_SLV0add is
begin
		INAadd00 <= "10010000"; -- 90";
		INAadd01 <= "10010000"; -- 92";
		INAadd02 <= "10010010"; -- 94";
		INAadd03 <= "10010010"; -- 96";
		INAadd04 <= "10010100"; -- 98";
		INAadd05 <= "10010100"; -- 9A";
		INAadd06 <= "10010110"; -- 9C";
end I2C_INA_SLV0add_arch;
