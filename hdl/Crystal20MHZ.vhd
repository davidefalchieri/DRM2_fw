--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: Crystal20MHZ.vhd
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

entity Crystal20MHZ is
    port ( SYSCLK : OUT std_logic );
end Crystal20MHZ;

architecture architecture_Crystal20MHZ of Crystal20MHZ is
constant SYSCLK_PERIOD : time := 50 ns; 
signal   SYSCLKd       : std_logic := '0';

begin
    SYSCLK   <= SYSCLKd;
    SYSCLKd  <= not SYSCLKd  after (SYSCLK_PERIOD / 2.0 ); 
end architecture_Crystal20MHZ;
