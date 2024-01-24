--------------------------------------------------------------------------------
-- Company: INFN Bologna
--
-- File: fake_gbt.vhd
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
-- Author: Davide Falchieri
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
USE work.caenlinkpkg.all;
use work.DRM2pkg.all;

entity fake_gbt is
port 
	(
	clear:					in		std_logic;
	soft_clear:				in	 	std_logic;
	FPGACK_40MHz:			in  	std_logic;
	regs: 					in  	REGS_RECORD;
	-- fake gbt interface
	l1a_ttc:				out		std_logic;
	bunch_reset:			out		std_logic;
	l1msg_dto:				out		std_logic_vector(79 downto 0);
	l1msg_rd:				in		std_logic;
	l1msg_empty:			out		std_logic
	);
end fake_gbt;

architecture behavioral of fake_gbt is

component fake_l1msg_fifo is
    port(
        CLK   : in  std_logic;
        DATA  : in  std_logic_vector(79 downto 0);
        RE    : in  std_logic;
        RESET : in  std_logic;
        WE    : in  std_logic;
        EMPTY : out std_logic;
        FULL  : out std_logic;
        Q     : out std_logic_vector(79 downto 0)
        );
end component fake_l1msg_fifo;

signal fake_gbt_data:			std_logic_vector(79 downto 0);
signal fake_gbt_valid:			std_logic;

signal bunch_counter:			unsigned(11 downto 0);
signal orbit_counter:			unsigned(31 downto 0);
signal state_tb_acq:			std_logic_vector(1 downto 0);
signal orbit_with_trg:          std_logic;
signal fifo_reset:				std_logic;

constant fixed_bcid_0:			unsigned(11 downto 0) := x"064";	-- 100
constant fixed_bcid_1:			unsigned(11 downto 0) := x"508";	-- 1288
constant fixed_bcid_2:			unsigned(11 downto 0) := x"9AC";	-- 2476
   
begin

fifo_reset	<= clear or soft_clear;

fake_l1msg_fifo_instance: fake_l1msg_fifo
    port map
		(
        CLK   		=> FPGACK_40MHz,
        DATA  		=> fake_gbt_data,
		WE    		=> fake_gbt_valid,
        RE   		=> l1msg_rd,
        RESET 		=> fifo_reset,
        EMPTY 		=> l1msg_empty,
        FULL  		=> open,
        Q     		=> l1msg_dto
        );

triggers_from_gbt_process: process(clear, soft_clear, FPGACK_40MHz) 
   begin                                      
     if(fifo_reset = '1') then                          
         bunch_counter                              <= (others => '0');
         orbit_counter                              <= (others => '0');
         fake_gbt_data                              <= (others => '0');
		 fake_gbt_valid								<= '0';
		 bunch_reset								<= '0';
		 l1a_ttc									<= '0';
         orbit_with_trg                             <= '0';
		 state_tb_acq								<= "00";
      elsif(rising_edge(FPGACK_40MHz)) then 
	  
         if(bunch_counter = x"0") then       -- counting from 0 to 3563
             bunch_counter   		<= bunch_counter + 1;
			 bunch_reset			<= '1';
         elsif(bunch_counter = x"DEB") then
             bunch_counter   		<= (others => '0');
			 bunch_reset			<= '0';
         else
             bunch_counter   		<= bunch_counter + 1;
			 bunch_reset			<= '0';
         end if;
         if(bunch_counter = x"DEB") then
             orbit_counter      <= orbit_counter + 1;
             if(((unsigned(orbit_counter(7 downto 0)) and unsigned(regs.orbit_mandrake(7 downto 0))) = unsigned(regs.orbit_mandrake(7 downto 0)))) then
                orbit_with_trg     <= '1';
             else
                orbit_with_trg     <= '0';
             end if;
         end if;
         
		fake_gbt_data(31 downto 1)      <= (others => '0');
		fake_gbt_data(47 downto 32)     <= "0000" & std_logic_vector(bunch_counter);
		fake_gbt_data(79 downto 48)     <= std_logic_vector(orbit_counter);
		
		if(state_tb_acq = "00") then				-- waiting for acq_on
			if(regs.ctrl2(CTRL2_MANDRAKE_GO) = '1') then
				state_tb_acq			<= "01";
			else
				state_tb_acq			<= "00";
			end if;
			fake_gbt_valid          <= '0';	
			l1a_ttc					<= '0';
		elsif(state_tb_acq = "01") then				-- providing TOF special triggers
			-----------------------------------------------------------------------------------
			-- fixed-BC triggers --------------------------------------------------------------  
			-----------------------------------------------------------------------------------
			if(orbit_with_trg = '1') then
				if(bunch_counter = fixed_bcid_0 or bunch_counter = fixed_bcid_1 or bunch_counter = fixed_bcid_2) then  -- fixed-BC encoded values
					fake_gbt_data(TOF_TT)             <= '1';      -- special TOF trigger
					fake_gbt_data(HB_TT)              <= '0';      -- HB
					fake_gbt_data(ORBIT_TT)           <= '0';      -- BCR
					fake_gbt_valid                    <= '1';  
					l1a_ttc							  <= '1';
				else                             
					fake_gbt_data(TOF_TT)             <= '0';     -- special TOF trigger
					fake_gbt_data(HB_TT)              <= '0';     -- HB
					fake_gbt_data(ORBIT_TT)           <= '0';     -- BCR
					fake_gbt_valid                    <= '0';
					l1a_ttc							  <= '0';
				end if;
			else	
				fake_gbt_data(TOF_TT)             <= '0';     -- special TOF trigger
				fake_gbt_data(HB_TT)              <= '0';     -- HB
				fake_gbt_data(ORBIT_TT)           <= '0';     -- BCR
				fake_gbt_valid                    <= '0';
				l1a_ttc							  <= '0';
			end if;
		
			if(regs.ctrl2(CTRL2_MANDRAKE_GO) = '0') then
				state_tb_acq			<= "10";
			else
				state_tb_acq			<= "01";
			end if;
		else									
			fake_gbt_data(TOF_TT)       <= '0';     -- special TOF trigger
			fake_gbt_data(HB_TT)        <= '0';     -- HB
			fake_gbt_data(ORBIT_TT)     <= '0';     -- BCR
			fake_gbt_valid              <= '0';
			l1a_ttc						<= '0';
			state_tb_acq				<= "00";
		end if;
         
      end if;
   end process triggers_from_gbt_process;

end behavioral;
