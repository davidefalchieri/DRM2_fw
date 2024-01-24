--/////////////////////////////////////////////////////////////////////////////////////////////////
-- Company: <Name>
--
-- File: epcs_tx_intf.v
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


entity epcs_tx_intf is 
    port(
        clk          : in     std_logic;                       -- Clock
        rstn         : in     std_logic;                       -- Reset attivo basso
        txdin        : in     std_logic_vector (9 downto 0);   
        txvali       : in     std_logic;
        txvalo       : out    std_logic;
        txdout       : out    std_logic_vector (9 downto 0) 
    );
end epcs_tx_intf;

architecture rtl of epcs_tx_intf is

    signal txdin_p : std_logic_vector(9 downto 0);
    signal txval_p : std_logic;

begin

    process(clk, rstn)  
    begin
        if rstn = '0' then
            txdin_p <= (others => '0');    
            txval_p <= '0';
        elsif rising_edge(clk) then
            txdin_p <= txdin;
            txval_p <= txvali;
        end if;
    end process;    

    process(clk, rstn)  
    begin
        if rstn = '0' then
            txdout <= (others => '0');    
            txvalo <= '0';
        elsif rising_edge(clk) then
            txdout <= txdin_p;
            txvalo <= txval_p;
        end if;
    end process;    
    
end rtl;
