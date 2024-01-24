----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library smartfusion2;
use smartfusion2.all;

entity bufd_bus is
    generic (
        BUS_WIDTH : integer := 20
    );
    port (
        out_data : out std_logic_vector(BUS_WIDTH-1 downto 0);
        in_data  : in  std_logic_vector(BUS_WIDTH-1 downto 0)
    );
end bufd_bus;

architecture rtl of bufd_bus is

component bufd
    port(
        A : in  STD_ULOGIC;
        Y : out STD_ULOGIC
        );
end component;

begin

G_bufd_bus:
	for i in 0 to BUS_WIDTH - 1 generate
		I_BUFD : bufd
		port map
		(Y => out_data(i), A => in_data(i));
	end generate G_bufd_bus;


end rtl;


----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



entity delay_line is
    generic (
        BUS_WIDTH : integer := 20;
        DELAY : integer := 5
    );
    port (
        in_data  : in  std_logic_vector(BUS_WIDTH-1 downto 0);
        out_data : out std_logic_vector(BUS_WIDTH-1 downto 0)
    );
end delay_line;

architecture rtl of delay_line is

    type YOUR_ARRAY_TYPE is array (DELAY-1 downto 0) of std_logic_vector (BUS_WIDTH-1 downto 0);
    
    signal data_d : YOUR_ARRAY_TYPE;

    component bufd_bus is
    generic (
        BUS_WIDTH : integer := 20
    );
    port (
        out_data : out std_logic_vector(BUS_WIDTH-1 downto 0);
        in_data  : in  std_logic_vector(BUS_WIDTH-1 downto 0)
    );
    end component bufd_bus;
    
    
    
begin

data_d(0) <= in_data;
out_data  <= data_d(DELAY-1);


G_DLY1:
	for i in 1 to DELAY - 1 generate
		I_BUFD_BUS : bufd_bus
        generic map(
            BUS_WIDTH => BUS_WIDTH
        )
		port map (
            out_data => data_d(i)(BUS_WIDTH-1 downto 0), 
            in_data => data_d(i-1)(BUS_WIDTH-1 downto 0)
        );
	end generate G_DLY1;


end rtl;



