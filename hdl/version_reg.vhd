library ieee; 
use ieee.std_logic_1164.all; 
entity version_reg is 
port ( 
    data_out : out std_logic_vector(31 downto 0)
);
end entity version_reg;
architecture rtl of version_reg is
begin
  data_out <= X"20231003";
end rtl;
