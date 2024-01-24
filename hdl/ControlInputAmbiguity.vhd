--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: ControlInputAmbiguity.vhd
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

entity ControlInputAmbiguity is
port (
    --<port_name> : <direction> <type>;
	Control_1_In  : IN   std_logic; -- example
	Control_1_Out : OUT  std_logic; -- example
	Control_2_In  : IN   std_logic; -- example
	Control_2_Out : OUT  std_logic; -- example
    Data_1_In     : IN   std_logic_vector(7 downto 0);  -- example
    Data_2_In     : IN   std_logic_vector(7 downto 0);  -- example
    Data_1_Out    : OUT  std_logic_vector(7 downto 0);  -- example
    Data_2_Out    : OUT  std_logic_vector(7 downto 0);
	CLK           : IN   std_logic -- example
);
end ControlInputAmbiguity;
architecture architecture_ControlInputAmbiguity of ControlInputAmbiguity is

begin
    Signal_handler : process(CLK)
    begin
    if CLK'event and CLK='0' then
        if Data_1_In(0)='1' then Data_1_Out(0) <= '1'; else Data_1_Out(0) <= '0'; end if; 
        if Data_1_In(1)='1' then Data_1_Out(1) <= '1'; else Data_1_Out(1) <= '0'; end if; 
        if Data_1_In(2)='1' then Data_1_Out(2) <= '1'; else Data_1_Out(2) <= '0'; end if; 
        if Data_1_In(3)='1' then Data_1_Out(3) <= '1'; else Data_1_Out(3) <= '0'; end if; 
        if Data_1_In(4)='1' then Data_1_Out(4) <= '1'; else Data_1_Out(4) <= '0'; end if; 
        if Data_1_In(5)='1' then Data_1_Out(5) <= '1'; else Data_1_Out(5) <= '0'; end if; 
        if Data_1_In(6)='1' then Data_1_Out(6) <= '1'; else Data_1_Out(6) <= '0'; end if; 
        if Data_1_In(7)='1' then Data_1_Out(7) <= '1'; else Data_1_Out(7) <= '0'; end if; 
        if Data_2_In(0)='1' then Data_2_Out(0) <= '1'; else Data_2_Out(0) <= '0'; end if; 
        if Data_2_In(1)='1' then Data_2_Out(1) <= '1'; else Data_2_Out(1) <= '0'; end if; 
        if Data_2_In(2)='1' then Data_2_Out(2) <= '1'; else Data_2_Out(2) <= '0'; end if; 
        if Data_2_In(3)='1' then Data_2_Out(3) <= '1'; else Data_2_Out(3) <= '0'; end if; 
        if Data_2_In(4)='1' then Data_2_Out(4) <= '1'; else Data_2_Out(4) <= '0'; end if; 
        if Data_2_In(5)='1' then Data_2_Out(5) <= '1'; else Data_2_Out(5) <= '0'; end if; 
        if Data_2_In(6)='1' then Data_2_Out(6) <= '1'; else Data_2_Out(6) <= '0'; end if; 
        if Data_2_In(7)='1' then Data_2_Out(7) <= '1'; else Data_2_Out(7) <= '0'; end if; 
        if Control_1_In='1' then Control_1_Out <= '1'; else Control_1_Out <= '0'; end if; 
        if Control_2_In='1' then Control_2_Out <= '1'; else Control_2_Out <= '0'; end if; 
    end if;
    end process;
end architecture_ControlInputAmbiguity;
