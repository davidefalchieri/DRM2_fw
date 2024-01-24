--------------------------------------------------------------------------------
--      1.20151210.1159: Versione iniziale

library IEEE;

use IEEE.std_logic_1164.all;

entity COREI2C_Bit2Bus is
port (
    SLV : out std_logic_vector(0 downto 0);
    SL0 : in  std_logic
);
end COREI2C_Bit2Bus;
architecture COREI2C_Bit2Bus_beh of COREI2C_Bit2Bus is

begin
    process(SL0)
    begin
        SLV(0) <= SL0;
    end process;
end COREI2C_Bit2Bus_beh;
