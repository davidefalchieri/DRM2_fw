--------------------------------------------------------------------------------
-- Company: INFN
--
-- File: GBTX_POWERCTRL_ctrl.vhd
-- File history:
--      20150930:14.50: Begin
--
-- Description: 
--
-- Controller for GBTX_POWERCTRL simulation
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: Baldus
--
--------------------------------------------------------------------------------

library ieee;  
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;  
use IEEE.std_logic_arith.all;
use std.textio.all;
--use ieee.std_logic_textio.all;

library smartfusion2;
use smartfusion2.all;

entity GBTX_POWERCTRL_ctrl is
port (
        I2CBSY : in std_logic;    -- I2C_INA is running
-------------------------------------------------------------------------------------------------
        POWDI  : out std_logic_vector(7 downto 0); -- Register data in
        POWDO  : in  std_logic_vector(7 downto 0); -- Register data out
        POWWR  : out std_logic; -- Write signal
        POWEN  : out std_logic; -- Enable signal
        POWAD  : out std_logic_vector(3 downto 0); -- Address in: bit3:1=COMMAND(2:0), 
                                                   -------------- bit0='0' Even=LSB=2nd I2C byte
                                                   -------------- bit0='1' Odd =MSB=1st I2C byte
-------------------------------------------------------------------------------------------------
        SYSCLK : out std_logic;   -- Clock
        RESETn : out  std_logic); -- Reset
end GBTX_POWERCTRL_ctrl;
architecture GBTX_POWERCTRL_ctrl_arch of GBTX_POWERCTRL_ctrl is
constant SYSCLK_PERIOD : time := 100 ns;

signal   SYSCLKd       : std_logic := '0';

begin

    SYSCLK <= SYSCLKd;
    SYSCLKd <= not SYSCLKd after (SYSCLK_PERIOD / 2.0 ); 

    stimulus : process
    file vINfile : text; 
    file vOUTfile : text; 
    variable vInLine : line;
    variable vOutLine : line;
    variable vCounter : integer range 0 to 65535 := 1;
    variable vMemAddr : std_logic_vector(15 downto 0) := X"FFFF";

    begin
        RESETn <= '0';
        POWDI  <= X"00";
        POWWR  <= '0';
        POWEN  <= '0';
        POWAD  <= "0000";
        wait for 1 ns;
        wait for 1 us;
        
        RESETn <= '1';
        wait for 100 ms;
        
        wait;
	end process;
end GBTX_POWERCTRL_ctrl_arch;
