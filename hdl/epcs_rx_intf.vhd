--/////////////////////////////////////////////////////////////////////////////////////////////////
-- Company: <Name>
--
-- File: epcs_rx_intf.v
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL010T> <Package::400 VF>
-- Author: <Name>
--
--///////////////////////////////////////////////////////////////////////////////////////////////// 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity epcs_rx_intf is 
    port(
        clk          : in     std_logic;                       -- Clock
        rstn         : in     std_logic;                       -- Reset attivo basso
        rxdin        : in     std_logic_vector (9 downto 0);   
        rxvali       : in     std_logic;
        rxvalo       : out    std_logic;
        rxdout       : out     std_logic_vector (9 downto 0) 
    );
end epcs_rx_intf;

architecture rtl of epcs_rx_intf is

    signal rxdin_l, rxdin_l2 : std_logic_vector(9 downto 0);
    signal rxval_l, rxval_l2 : std_logic;

begin
    -- negedge clk
    process(clk, rstn)  
    begin
        if rstn = '0' then
            rxdin_l <= (others => '0');    
            rxval_l <= '0';
        elsif falling_edge(clk) then
            rxdin_l <= rxdin;
            rxval_l <= rxvali;
        end if;
    end process;    

    -- posedge clk
    process(clk, rstn)  
    begin
        if rstn = '0' then
            rxdin_l2 <= (others => '0');   
            rxval_l2 <= '0';
        elsif rising_edge(clk) then
            rxdin_l2 <= rxdin_l;
            rxval_l2 <= rxval_l;
        end if;
    end process;    

    -- posedge clk
    process(clk, rstn)  
    begin
        if rstn = '0' then
            rxdout <= (others => '0');   
            rxvalo <= '0';
        elsif rising_edge(clk) then
            rxdout <= rxdin_l2;
            rxvalo <= rxval_l2;
        end if;
    end process;    
    

end rtl;

