--------------------------------------------------------------------------------
-- Company: INFN Bologna Section
--
-- File: bus_extender.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- bus_extender
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL090T> <Package::676 FBGA>
-- Author: Davide Falchieri
--
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity bus_extender is
	port 
	(
		FPGACK_40MHz:			in		std_logic;
		clear:					in		std_logic;
		drm_data:				in		std_logic_vector(32 downto 0);
		drm_valid:				in		std_logic;
		GBTx_data_fifo_dti:		out		std_logic_vector(64 downto 0);
		GBTx_fifo_wr:			out		std_logic
	);
end bus_extender;

architecture architecture_bus_extender of bus_extender is

	signal lsb:						std_logic;
	signal buffer64b:				std_logic_vector(63 downto 0);
	signal buffer64b_valid:			std_logic;
	signal buffer64b_last:			std_logic;

begin
	
	pipe_out_process: process(FPGACK_40MHz, clear)
	begin	
		if(clear = '1') then
			GBTx_data_fifo_dti				<= (others => '0');
			GBTx_fifo_wr					<= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
			GBTx_data_fifo_dti(63 downto 0)	<= buffer64b;
			GBTx_data_fifo_dti(64)			<= buffer64b_last;
			GBTx_fifo_wr					<= buffer64b_valid;
		end if;
	end process pipe_out_process;
	
	buffer64b_process: process(FPGACK_40MHz, clear)
	begin	
		if(clear = '1') then
			lsb				<= '1';
			buffer64b 		<= (others => '0');
			buffer64b_valid	<= '0';
			buffer64b_last	<= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
			if(drm_valid = '1' and drm_data(32) = '1') then
				if(lsb = '1') then
					buffer64b(31 downto 0)	<= drm_data(31 downto 0);
					buffer64b(63 downto 32)	<= x"70000000";
				else
					buffer64b(63 downto 32)	<= drm_data(31 downto 0);
				end if;
				buffer64b_valid	<= '1';
				buffer64b_last	<= '1';
				lsb				<= '1';
			elsif(drm_valid = '1') then
				if(lsb = '1') then
					buffer64b(31 downto 0)	<= drm_data(31 downto 0);
					buffer64b_valid			<= '0';
				else
					buffer64b(63 downto 32)	<= drm_data(31 downto 0);
					buffer64b_valid			<= '1';
				end if;
				buffer64b_last	<= '0';
				lsb				<= not(lsb);
			else
				buffer64b_valid	<= '0';
				buffer64b_last	<= '0';
			end if;	
		end if;
	end process buffer64b_process;	
	
end architecture_bus_extender;
