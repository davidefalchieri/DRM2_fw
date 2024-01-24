--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2C_ZTEST.vhd
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

entity I2C_ZTEST is
port (
    DZi: in std_logic;
    DZx: out std_logic;
    DI : in  std_logic;
    DO : out std_logic
);
end I2C_ZTEST;
architecture I2C_ZTEST_arch of I2C_ZTEST is
   -- signal, component etc. declarations
begin
    DO_handler : process(DI, DZi)
    begin
        if    DI='0'  then DO <= '0';
        elsif DZi='0' then DO <= '0';
        else               DO <= '1'; 
        end if;
    end process;
    DZ_handler : process(DI)
    begin
        if    DI='0' then DZx <= '0';
        else              DZx <= 'H'; 
        end if;
    end process;
   -- architecture body
end I2C_ZTEST_arch;
