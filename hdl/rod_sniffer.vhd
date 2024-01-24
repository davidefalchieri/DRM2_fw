-------------------------------------------------------------------------------------------------------------------------------------------
-- Created by Davide Falchieri (INFN Bologna)
-------------------------------------------------------------------------------------------------------------------------------------------
-- Notes:
--
--
-------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.DRM2pkg.all;
USE work.caenlinkpkg.all;

entity rod_sniffer is
   port
	(
      active_high_reset: 	in     	std_logic;                      			-- reset (active HIGH)
	  clear: 				in      std_logic;
	  soft_clear:			in	 	std_logic;
	  FPGACK_40MHz: 		in    	std_logic;                      			-- FPGACK_40MHz
	  regs: 				inout  	REGS_RECORD; 
	  WPULSE: 				in      reg_wpulse;
	  acq_on:				in		std_logic;

	  -- data from vme_int
	  sniff_data: 			in	    std_logic_vector(32 downto 0);  			-- data to GBTx + endPCK
	  sniff_valid:			in   	std_logic;                      			-- FIFO write enable
	  sniff_ctrl:			in		std_logic;
	  
	  -- SROF interface
	  srof_dto: 			out    std_logic_vector(32 downto 0);  				-- data
	  srof_rd: 				in     std_logic;                      				-- read enable
	  srof_empty: 			buffer std_logic;                      				-- empty
	  evwritten: 			out    std_logic;                      				-- event written
	  ssram_interrupt:		out	   std_logic;

	  -- SSRAM interface
	  ssram_D:	 			inout  std_logic_vector(35 downto 0);   			-- data
	  ssram_A:	 			out    std_logic_vector(19 downto 0);   			-- address
	  ssram_WE: 			out    std_logic;
	  ssram_OE: 			out    std_logic;
	  ssram_LD: 			out    std_logic;
	  ssram_CE: 			out    std_logic
   );
end rod_sniffer;


architecture RTL of rod_sniffer is

	-- Segnali per la SSRAM
	signal r_page: 				std_logic;  									-- Read Page Pointer
	signal w_page: 				std_logic;  									-- Write Page Pointer
	signal XOR8: 				std_logic_vector(3 downto 0);        			-- XOR 8 a 8 (in uscita)
	signal ssram_almost_full: 	std_logic;                           			-- SR Almost Full
	signal running: 			std_logic;                           			-- sniffing in corso

	function XOR_N (A: std_logic_vector) return std_logic is
		variable i: 	integer;
		variable res: 	std_logic := '0';
	begin
		for i in A'range loop
			res := res xor A(i);
		end loop;
		return res;
	end XOR_N;
	
	signal fifo_clear:				std_logic;
		-- SROF signals
	signal srof_dti: 				std_logic_vector(32 downto 0);
    signal srof_we: 				std_logic;
	signal srof_full: 				std_logic;
	signal srof_empty_i: 			std_logic;
	signal srof_rd_i: 				std_logic;
		-- just for debug
	-- signal srof_dti_delay:			std_logic_vector(32 downto 0);
	-- signal flag_conet:				std_logic;
	-- signal sniff_data_delay:		std_logic_vector(32 downto 0);
	-- signal flag_sniff:				std_logic;
	-- signal ssram_Di_delay:			std_logic_vector(34 downto 0);
	-- signal flag_ssram:				std_logic;
	
    signal srof_wrusedw: 			std_logic_vector(10 downto 0);
    signal srof_almfull: 			std_logic;
	
		-- SSRAM signals ------------------------------------------------------------------------------------------------------------------
	constant ssram_SIZE: 			integer := 20;  							-- ssram SRAM Size = 2^ssram_SIZE
	constant ssram_AFLEV: 			integer := 2**(ssram_SIZE-1)-(45*1024);		-- 478208 32-bit words

	signal w_pnt: 					std_logic_vector(ssram_SIZE-2 downto 0);  	-- Write Pointer
	signal r_pnt: 					std_logic_vector(ssram_SIZE-2 downto 0);  	-- Read Pointer

	signal ssram_Ai: 				std_logic_vector(ssram_SIZE-1 downto 0);  	-- internal addresses
	signal ssram_Di: 				std_logic_vector(34 downto 0);         		-- internal data
	signal ssram_WEi: 				std_logic;                             		-- internal Write Enable
	signal ssram_READ: 				std_logic;                             		-- valid read cycle from ssram
	signal ssramO_VALID: 			std_logic;                            		-- valid data from ssram (1 clock cycle after ssram_READ)

  -----------------------------------------------------------------------------------------------------------------------------------------
  -- Signals use for Pipelined SRAM  CY7C1370 or CY7C1350 or CY7C1460
  -----------------------------------------------------------------------------------------------------------------------------------------
	signal ssram_D1: 				std_logic_vector(35 downto 0);         		-- ssram_Di delayed by 1 clock cycle
	signal ssram_D2: 				std_logic_vector(35 downto 0);         		-- ssram_Di delayed by 2 clock cycles
	signal ssram_Dz: 				std_logic_vector(35 downto 0);         		-- ssram_D with OE
	signal ssram_Ds: 				std_logic_vector(35 downto 0);         		-- ssram_D synced (in input)
	signal ssram_WE1: 				std_logic;                             		-- ssram_WEi delayed by 1 clock cycle
	signal ssram_D_OE: 				std_logic;                             		-- OE of data to ssram
	signal ssram_READ1: 			std_logic;                             		-- ssram_READ delayed by 1 clock cycle
	signal ssram_READ2: 			std_logic;                             		-- ssram_READ delayed by 2 clock cycles
  -----------------------------------------------------------------------------------------------------------------------------------------

	component srof_fifo is
    port(
        -- Inputs
        CLK   : in  std_logic;
        DATA  : in  std_logic_vector(32 downto 0);
        RE    : in  std_logic;
        RESET : in  std_logic;
        WE    : in  std_logic;
        -- Outputs
        EMPTY : out std_logic;
        FULL  : out std_logic;
        Q     : out std_logic_vector(32 downto 0);
        WRCNT : out std_logic_vector(10 downto 0)
        );
	end component srof_fifo;

begin

	fifo_clear	<= clear or soft_clear;
	
	---------------------------------------------------------------------------------------------------------------------------------------
	-- SROF FIFO --------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------
	
	-- logic used to transform the FIFO from standard to FWFT
	
	srof_fifo_instance: srof_fifo
	port map(
       RESET    => fifo_clear,
       CLK      => FPGACK_40MHz,

       DATA     => srof_dti,
       WE       => srof_we,
       FULL     => srof_full,
       WRCNT    => srof_wrusedw,

       Q        => srof_dto,
       RE       => srof_rd_i,       
       EMPTY    => srof_empty_i       
    );
	
	srof_rd_i	<= not srof_empty_i and (srof_empty or srof_rd);
	
	process(FPGACK_40MHz, clear, soft_clear)  -- read clock
    begin
        if(clear = '1' or soft_clear = '1') then
            srof_empty   <= '1';
        elsif(rising_edge(FPGACK_40MHz)) then
            if(srof_rd_i = '1' and srof_rd = '0') then
                srof_empty   <= '0';
            elsif(srof_rd_i = '0' and srof_rd = '1') then
                srof_empty   <= '1';
            end if;
        end if;
    end process; 
	
	    -- FIFO Almost Full
    process(FPGACK_40MHz, clear, soft_clear) 
    begin
        if(clear = '1' or soft_clear = '1') then
            srof_almfull <= '0';
        elsif(rising_edge(FPGACK_40MHz)) then
            if(conv_integer(srof_wrusedw) > SROF_ALMOST_FULL_LEVEL) then
                srof_almfull <= '1';
            else
                srof_almfull <= '0';
            end if;
        end if;
    end process;	
	
	process(FPGACK_40MHz, clear, soft_clear)      
    begin
		if(clear = '1' or soft_clear = '1') then
			evwritten	<= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
			if((sniff_valid = '1' and (running = '1' or sniff_ctrl = '1'))) then
				evwritten	<= sniff_data(32); 
			else	
				evwritten	<= '0';
			end if;
		end if;
	end process;
	
	---------------------------------------------------------------------------------------------------------------------------------------  
	  
	---------------------------------------------------------------------------------------------------------------------------------------
	-- Managing external SSRAM
	---------------------------------------------------------------------------------------------------------------------------------------
	  
	  -- I dati provengono da VME_INT che scrive come se ci fosse una FIFO vme_to_gbt. 
	  -- La lettura da ssram avviene in modo sequenziale.
	  
	  ssram_OE <= '0';
	  ssram_CE <= '0';
	  ssram_LD <= '0';
	  
	  --- inizio aggiunta
	  
	  process(clear, soft_clear, FPGACK_40MHz)
		begin
		if(clear = '1' or soft_clear = '1') then
		  r_page    			<= '0';
		  w_page    			<= '0';
		  r_pnt     			<= (others => '0');
		  w_pnt     			<= (others => '0');
		  ssram_WEi    			<= '1';
		  ssram_READ   			<= '0';
		  ssram_READ1  			<= '0';
		  ssram_READ2  			<= '0';
		  ssramO_VALID 			<= '0';
		  ssram_Di 				<= (others => '0');
		  XOR8  				<= (others => '0');
		  ssram_Ai 				<= (others => '0');
		  srof_dti  			<= (others => '0');
		  srof_we 				<= '0';
		  ssram_almost_full   	<= '0';
		  running 				<= '0';

		elsif(rising_edge(FPGACK_40MHz)) then
		
			if(acq_on = '0') then

				if(regs.ctrl(CTRL_SR_TEST) = '1') then
					ssram_Di 	<= "000" & regs.roc_tdata & regs.roc_tdata;
					ssram_Ai 	<= regs.ssram_adl(3 downto 0) & regs.ssram_adl(15 downto 0); 
					ssram_WEi 	<= not WPULSE(SHOT_WRR);
				else
					ssram_Ai	<= (others => '0');
					ssram_Di 	<= (others => '0');
					ssram_WEi 	<= '0';
				end if;
				r_page    			<= '0';
			    w_page    			<= '0';
			    r_pnt     			<= (others => '0');
			    w_pnt     			<= (others => '0');
			    ssram_READ   		<= '0';
			    ssram_READ1  		<= '0';
			    ssram_READ2  		<= '0';
			    ssramO_VALID 		<= '0';
			    XOR8  				<= (others => '0');
			    srof_dti  			<= (others => '0');
			    srof_we 			<= '0';
			    ssram_almost_full   <= '0';
			    running 			<= '0';
				
			else
		
				-- di defaut, non scrivo e non leggo
				ssram_READ 	<= '0';
				ssram_WEi  	<= '1';

				-- La scrittura riparte (dopo un almost full della SSRAM) quando c'è un buffer
				-- libero ed è appena passato un trailer (quindi riparto a scrivere dall'header successivo)
				if(sniff_valid = '1' and r_page = w_page and sniff_data(32) = '1') then
				  running 			  <= '1';
				  ssram_almost_full   <= '0';
				end if;

				-- scrittura da vme_int a SSRAM (ha priorità sulla lettura)
				if(sniff_valid = '1' and (running = '1' or sniff_ctrl = '1')) then
				  ssram_WEi <= '0';
				  ssram_Ai  <= w_page & w_pnt;
				  ssram_Di  <= "00" & sniff_data;
				  XOR8   	<= XOR_N(sniff_data(31 downto 24)) & XOR_N(sniff_data(23 downto 16)) &
							   XOR_N(sniff_data(15 downto  8)) & XOR_N(sniff_data(7  downto  0));

				  if(w_page = r_page and w_pnt = ALL_ONE(w_pnt'range)) then  -- raggiunta la fine del primo buffer
					w_page 				<= not w_page;
					w_pnt 				<= (others => '0');
				  else
					w_pnt 				<= w_pnt + 1;
				  end if;

				  -- La SR va prima almost full (e c'è ancora spazio per scrivere un evento); quando è
				  -- almost full, il processo di scrittura si blocca quando ho finito di scrivere l'evento in
				  -- corso (ovvero quando passa il trailer)
				  if(w_page /= r_page and conv_integer(w_pnt) = ssram_AFLEV) then 	-- SSRAM Almost Full
					ssram_almost_full 	<= '1';
				  end if;
				  if(ssram_almost_full = '1' and sniff_data(32) = '1') then  	-- mettere majority
					running 			<= '0';
				  end if;

				-- Ciclo di lettura da SSRAM verso SROF
				elsif(srof_almfull = '0') then
				  ssram_Ai <= r_page & r_pnt;  -- Indirizzo di lettura
				  if(r_page = w_page) then
					if(r_pnt /= w_pnt) then
					  r_pnt 		<= r_pnt + 1;
					  ssram_READ 	<= '1';
					end if;
				  else
					if(r_pnt = ALL_ONE(r_pnt'range)) then
					  r_pnt 		<= (others => '0');
					  r_page 		<= not r_page;
					else
					  r_pnt 		<= r_pnt + 1;
					end if;
					ssram_READ 		<= '1';
				  end if;
				end if;

				ssram_READ1  <= ssram_READ;
				ssram_READ2  <= ssram_READ1;
				ssramO_VALID <= ssram_READ2;
				-- leggo i dati da SR (il ciclo di lettura è avvenuto al ciclo di CLK precedente)
				if(ssramO_VALID = '1') then
				  srof_dti 	<= ssram_Ds(32 downto 0);   -- mettere bit 32 = majority dei bit 32,33,34 di SR
				  srof_we 	<= '1';
				else
				  srof_dti	<= (others => '0');
				  srof_we 	<= '0';
				end if;
			end if;

		end if;
	  end process;
  
    -- Interrupt Request verso SCL
	  process(clear, soft_clear, FPGACK_40MHz)
	  begin
		if(clear = '1' or soft_clear = '1') then
		  ssram_interrupt <= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
		  if (w_page /= r_page and regs.ctrl2(CTRL2_SR_IRQEN) = '1') then 			
			ssram_interrupt <= '1';
		  else
			ssram_interrupt <= '0';
		  end if;
		end if;
	  end process;
  
  -----------------------------------------------------------------------------------------------------------------------------------------
  -- ACCESSO A 40MHz
  -----------------------------------------------------------------------------------------------------------------------------------------
---- uscita dati verso SR (pipeline di 2 clock come previsto dalla SSRAM Pipelined)
	 process(clear, soft_clear, FPGACK_40MHz)
	 begin
	   if(clear = '1' or soft_clear = '1') then
		 ssram_D_OE  	<= '0';
		 ssram_D1   	<= (others => '0');
		 ssram_D2   	<= (others => '0');
		 ssram_WE1  	<= '1';
		 ssram_Ds	 	<= (others => '0');
	   elsif(rising_edge(FPGACK_40MHz)) then
		 ssram_WE1  	<= ssram_WEi;
		 ssram_D1   	<= XOR_N(XOR8) & ssram_Di;
		 ssram_D2   	<= ssram_D1;
		 ssram_D_OE 	<= not ssram_WE1;
		 ssram_Ds	 	<= ssram_D;  -- Dati ritardati compatibilita' con l'accesso a 80MHz
	   end if;
	 end process;
	 
	 ssram_Dz <= ssram_D2 when ssram_D_OE = '1' else (others => 'Z');

	 -- NOTA: le uscite verso la SR sono ritardate di 1ns (in simulazione) per rispettare
	 -- l'hold time della SRAM. Nella realtà, il ritardo è garantito dal Tco della FPGA
		ssram_D  	<= transport ssram_Dz       after 1 ns;
		ssram_A		<= transport ssram_Ai  		after 1 ns;
		ssram_WE	<= transport ssram_WEi      after 1 ns;

	 -- TEST read
	  regs.ssram_dtl <= ssram_Ds(15 downto 0);
	  regs.ssram_dth <= ssram_Ds(31 downto 16);
  -----------------------------------------------------------------------------------------------------------------------------------------

end RTL;
