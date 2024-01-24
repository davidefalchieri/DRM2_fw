--------------------------------------------------------------------------------
--      1.20151210.1159: Versione iniziale

library IEEE;

use IEEE.std_logic_1164.all;

entity COREI2C_Bus2Bit is
port (
    SLV : in  std_logic_vector(0 downto 0);
    SL0 : out std_logic
);
end COREI2C_Bus2Bit;
architecture COREI2C_Bus2Bit_beh of COREI2C_Bus2Bit is

begin
    process(SLV)
    begin
        SL0 <= SLV(0);
    end process;
end COREI2C_Bus2Bit_beh;
