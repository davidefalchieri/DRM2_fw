--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: ATMEGA.vhd
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

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity ATMEGA is
port (
	PSM_SI  : IN  std_logic; 
	PSM_SO  : OUT std_logic; 
	PSM_SCK : OUT std_logic; 
	RESETn  : IN  std_logic
);
end ATMEGA;
architecture architecture_ATMEGA of ATMEGA is
begin
    PSM_OUTPUT_HANDLER : process
    variable PSM_SOdata : std_logic_vector(13 downto 0);
    variable PSM_SOadd_n : std_logic_vector(3 downto 0);
    variable PSM_SOadd     : integer := 0;
    variable cntVoltage : integer := 0;
	variable SfigaCounter : integer := 5;
    begin
        if RESETn/='1' then
            PSM_SOadd   := 0;
            PSM_SO   <= '0';
            PSM_SCK  <= '1';
            wait for 2 ms;
        else
            for PSM_SOadd in 0 to 8 loop
				
                PSM_SOadd_n:=   conv_std_logic_vector(PSM_SOadd, 4) xor "1111";
				wait for 10 ns;
			
				if PSM_SOadd=8 then
             		PSM_SOdata :=   conv_std_logic_vector(PSM_SOadd  , 4) & 
                	                "00" & x"D1" ;
				else
             		PSM_SOdata :=   conv_std_logic_vector(PSM_SOadd  , 4) & 
                	                PSM_SOadd_n & 
                	                conv_std_logic_vector(cntVoltage, 6) ;
				end if;
				wait for 10 ns;

            	cntVoltage := cntVoltage+1;
				wait for 10 ns;
      
                for PSM_SObit in 0 to 13 loop
                    PSM_SO  <= PSM_SOdata(13);
                    PSM_SOdata := PSM_SOdata sll 1;
                    wait for 1 us;                    
                    PSM_SCK <= '0'; 
                    wait for 10 us;
                    PSM_SCK <= '1'; 
                    wait for 2 us;               
                end loop;
				if SfigaCounter=0 then
					SfigaCounter := 5;
					wait for 10us;
				else 
					SfigaCounter := SfigaCounter-1; 
		        	wait for 1 ms;
				end if;
            end loop;
	    wait for 15 ms;
        end if;
    end process;
end architecture_ATMEGA;
