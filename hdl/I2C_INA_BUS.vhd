--------------------------------------------------------------------------------
-- Company: INFN
--
-- File: I2C_INA_BUS.vhd
-- File history:
--      20150930:15.00: Start version
--
-- Description: 
--
-- I2C SDA aggregator for INA I2C groups
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: Baldus
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity I2C_INA_BUS is
port (
	SDA0_out : in  std_logic;
	SDA1_out : in  std_logic;
	SDA2_out : in  std_logic;
	SDA3_out : in  std_logic;
	SDA4_out : in  std_logic;
	SDA5_out : in  std_logic;
	SDA6_out : in  std_logic;
	SDA7_out : in  std_logic;
	SDA8_out : in  std_logic;
	SDA9_out : in  std_logic;
	SDAa_out : in  std_logic;
	SDAb_out : in  std_logic;
	SDAc_out : in  std_logic;
	SDAd_out : in  std_logic;
	SDAe_out : in  std_logic;
	SDAf_out : in  std_logic;
	SDAi    : in  std_logic; -- External SDA input
	SDAo    : out std_logic);-- External SDA output
end I2C_INA_BUS;
architecture I2C_INA_BUS_arch of I2C_INA_BUS is
begin
	SDAo_handler : process(SDA0_out, SDA1_out, SDA2_out, SDA3_out, 
	                       SDA4_out, SDA5_out, SDA6_out, SDA7_out, 
	                       SDA8_out, SDA9_out, SDAa_out, SDAb_out, 
	                       SDAc_out, SDAd_out, SDAe_out, SDAf_out, SDAi)
	begin
		SDAO <=   SDA0_out and SDA1_out and SDA2_out and SDA3_out and        
                  SDA4_out and SDA5_out and SDA6_out and SDA7_out and     
                  SDA8_out and SDA9_out and SDAa_out and SDAb_out and     
                  SDAc_out and SDAd_out and SDAe_out and SDAf_out and SDAi;
	end process;
end I2C_INA_BUS_arch;     
                          