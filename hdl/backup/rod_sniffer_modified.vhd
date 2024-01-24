---------------------------------------------------------------------------------------------------------------------------------------------
-- Created by Davide Falchieri (INFN Bologna)
---------------------------------------------------------------------------------------------------------------------------------------------
-- Notes:
--
--
---------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.DRM2pkg.all;
USE work.caenlinkpkg.all;

entity rod_sniffer is
   port
	(
      active_high_reset: 	in     	std_logic;                      -- Reset (active HIGH)
	  clear: 				in      std_logic;
	  FPGACK_40MHz: 		in    	std_logic;                      -- FPGACK_40MHz
	  regs: 				inout  	REGS_RECORD; 
	  WPULSE: 				in      reg_wpulse;
	  acq_on:				in		std_logic;
      ---------------------------------------------------------------------------------------------------------------------------------------
	  -- data from vme_int
	  vme_to_gbt_DTI: 		in	    std_logic_vector(32 downto 0);  -- Data to GBTx + EndPCK
	  vme_to_gbt_valid:		in   	std_logic;                      -- FIFO Write Enable
	  
	  -- SROF interface
	  srof_dto: 			out    std_logic_vector(32 downto 0);  	-- data
	  srof_rd: 				in     std_logic;                      	-- read enable
	  srof_empty: 			buffer std_logic;                      	-- empty
	  evwritten: 			out    std_logic;                      	-- event written
	  ssram_interrupt:		out	   std_logic;

	  -- SSRAM interface
	  ssram_D:	 			inout  std_logic_vector(35 downto 0);   -- Data
	  ssram_A:	 			out    std_logic_vector(19 downto 0);   -- Address
	  ssram_WE: 			out    std_logic;
	  ssram_OE: 			out    std_logic;
	  ssram_LD: 			out    std_logic;
	  ssram_CE: 			out    std_logic
   );
end rod_sniffer;


architecture RTL of rod_sniffer is

	-- Segnali per la SSRAM
	signal r_page: 				std_logic;  -- Read Page Pointer
	signal w_page: 				std_logic;  -- Write Page Pointer
	signal XOR8: 				std_logic_vector(3 downto 0);        -- XOR 8 a 8 (in uscita)
	signal ssram_almost_full: 	std_logic;                           -- SR Almost Full
	signal running: 			std_logic;                           -- sniffing in corso

	function XOR_N (A: std_logic_vector) return std_logic is
		variable i: 	integer;
		variable res: 	std_logic := '0';
	begin
		for i in A'range loop
			res := res xor A(i);
		end loop;
		return res;
	end XOR_N;
	
	-- SROF signals
	signal srof_dti: 				std_logic_vector(32 downto 0);
    signal srof_we: 				std_logic;
	signal srof_full: 				std_logic;
	signal srof_empty_i: 			std_logic;
	signal srof_rd_i: 				std_logic;
	
    signal srof_wrusedw: 			std_logic_vector(10 downto 0);
    signal srof_almfull: 			std_logic;
	
		-- SSRAM signals --------------------------------------------------------------------------
	constant ssram_SIZE: 			integer := 20;  							-- ssram SRAM Size = 2^ssram_SIZE
	constant ssram_AFLEV: 			integer := 2**(ssram_SIZE-2)-(45*1024);		-- 216.064 KB 
	--constant ssram_NEV_AFLEV: 		integer := 230;  						-- Almost Full level (max number of events)

	signal w_pnt: 					std_logic_vector(ssram_SIZE-3 downto 0);  	-- Write Pointer
	signal r_pnt: 					std_logic_vector(ssram_SIZE-3 downto 0);  	-- Read Pointer
	signal w_jump: 					std_logic_vector(ssram_SIZE-3 downto 0);  	-- Write Pointer to jump to for the new event

	signal ssram_Ai: 				std_logic_vector(ssram_SIZE-2 downto 0);  	-- internal addresses
	signal ssram_Di: 				std_logic_vector(34 downto 0);         		-- internal data
	signal ssram_WEi: 				std_logic;                             		-- internal Write Enable
	signal ssram_READ: 				std_logic;                             		-- valid read cycle from ssram
	signal ssramO_VALID: 			std_logic;                            		-- valid data from ssram (1 clock cycle after ssram_READ)
	signal ssram_READ_FIRST: 		std_logic;                             		-- first word of an event being read out from ssram
	signal ssramO_VALID_FIRST: 		std_logic;                             		-- first valid data (clocked ssram_READ_FIRST)

  -- =====================================================================================
  -- Signals use for Pipelined SRAM  CY7C1370 or CY7C1350 or CY7C1460
  -- =====================================================================================
	signal ssram_D1: 				std_logic_vector(35 downto 0);         		-- ssram_Di delayed by 1 clock cycle
	signal ssram_D2: 				std_logic_vector(35 downto 0);         		-- ssram_Di delayed by 2 clock cycles
	signal ssram_Dz: 				std_logic_vector(35 downto 0);         		-- ssram_D with OE
	signal ssram_Ds: 				std_logic_vector(35 downto 0);         		-- ssram_D synced (in input)
	signal ssram_WE1: 				std_logic;                             		-- ssram_WEi delayed by 1 clock cycle
	signal ssram_D_OE: 				std_logic;                             		-- OE of data to ssram
	signal ssram_READ1: 			std_logic;                             		-- ssram_READ delayed by 1 clock cycle
	signal ssram_READ_FIRST1: 		std_logic;                             		-- ssram_READ_FIRST delayed by 1 clock cycle
	signal ssram_READ2: 			std_logic;                             		-- ssram_READ delayed by 2 clock cycles
	signal ssram_READ_FIRST2: 		std_logic;                             		-- ssram_READ_FIRST delayed by 2 clock cycles
  -- =====================================================================================

	signal ssram_NEV: 				std_logic_vector(7 downto 0);        		-- number of events in ssram ready to be sent to GBTx
	signal rwcnt: 					std_logic_vector(17 downto 0);       		-- counts the words of an event while reading ssram
	signal evhead_cnt: 				std_logic_vector(3 downto 0);        		-- counts the header words while being written
	signal wr_evhead: 				std_logic;                           		-- asserted while writing the header
	signal ne_af: 					std_logic;                           		-- Almost Full due to too many events in ssram
	signal nw_af: 					std_logic;                           		-- Almost Full due to too many words in ssram

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
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- SROF FIFO ----------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	-- Logica per trasformare la fifo da tipo Legacy (RDREQ=richiesta di lettura) a tipo
    -- ShowAhead (RDREQ=read acknowledge)
	
	srof_fifo_instance: srof_fifo
	port map(
       RESET    => clear,
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
	
	process(FPGACK_40MHz, clear)  -- read clock
    begin
        if(clear = '1') then
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
    process(FPGACK_40MHz, clear) 
    begin
        if(clear = '1') then
            srof_almfull <= '0';
        elsif(rising_edge(FPGACK_40MHz)) then
            if(conv_integer(srof_wrusedw) > SROF_ALMOST_FULL_LEVEL) then
                srof_almfull <= '1';
            else
                srof_almfull <= '0';
            end if;
        end if;
    end process;	

	process(FPGACK_40MHz, clear)      
    begin
		if(clear = '1') then
			evwritten	<= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
			if(srof_we = '1') then
				evwritten	<= srof_dti(32); 
			else	
				evwritten	<= '0';
			end if;
		end if;
	end process;
	-----------------------------------------------------------------------------------------------------------------------------------------  
	  
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- Managing external SSRAM
	-----------------------------------------------------------------------------------------------------------------------------------------
	  
	  -- I dati provengono da VME_INT che scrive come se ci fosse una FIFO vme_to_gbt. L'ordine con cui i
	  -- dati vengono scritti da VME_INT non è quello giusto (la header viene scritta per ultima);
	  -- l'ordine viene ripristinato in fase di scrittura in ssram gestendo l'indirizzo di scrittura
	  -- in modo opportuno. La lettura da ssram avviene invece in modo sequenziale.
	  
	  ssram_OE <= '0';
	  ssram_CE <= '0';
	  ssram_LD <= '0';
	  
	  --- inizio aggiunta
	  
	  process(clear, FPGACK_40MHz)
		begin
		if(clear = '1') then
		  r_page    			<= '0';
		  w_page    			<= '0';
		  r_pnt     			<= (others => '0');
		  w_pnt     			<= conv_std_logic_vector(NW_DRM_HT - 1, W_PNT'high + 1);  -- the header is being written in the end
		  w_jump          		<= (others => '0');
		  ssram_WEi    			<= '1';
		  ssram_READ   			<= '0';
		  ssram_READ1  			<= '0';
		  ssram_READ2        	<= '0';
		  ssramO_VALID 			<= '0';
		  ssram_READ_FIRST   	<= '0';
		  ssram_READ_FIRST1  	<= '0';
		  ssram_READ_FIRST2  	<= '0';
		  ssramO_VALID_FIRST 	<= '0';
		  ssram_Di 				<= (others => '0');
		  XOR8  				<= (others => '0');
		  ssram_Ai 				<= (others => '0');
		  ssram_NEV          	<= (others => '0');
		  EVHEAD_CNT      		<= (others => '0');
		  WR_EVHEAD       		<= '0';
		  rwcnt           		<= "000000000000000001";
		  srof_dti  			<= (others => '0');
		  srof_we 				<= '0';
		  ssram_almost_full   	<= '0';
		  running 				<= '1';

		elsif(rising_edge(FPGACK_40MHz)) then
		
			if(acq_on = '0') then

				if(regs.status(CTRL_SR_TEST) = '1') then
					ssram_Di 	<= "000" & regs.roc_tdata & regs.roc_tdata;
					ssram_Ai 	<= regs.ssram_adl(2 downto 0) & regs.ssram_adl(15 downto 0); 
					ssram_WEi 	<= not WPULSE(WP_WRR);
				else
					ssram_Ai	<= (others => '0');
					ssram_Di 	<= (others => '0');
					ssram_WEi 	<= '0';
				end if;

			else
				-- di defaut, non scrivo e non leggo
				ssram_READ 			<= '0';
				ssram_READ_FIRST  	<= '0';
				ssram_WEi  			<= '1';

				-- La scrittura riparte (dopo un almost full della SR) quando c'è un buffer
				-- libero ed è appena passato un trailer (quindi riparto a scrivere dall'header successivo)
				if(vme_to_gbt_valid = '1' and r_page = w_page and vme_to_gbt_DTI(32) = '1') then
				  running 			  <= '1';
				  ssram_almost_full   <= '0';
				end if;

				-- Scrittura da vme_int a SR (ha priorità sulla lettura)
				if(vme_to_gbt_valid = '1' and running = '1') then
				  ssram_WEi <= '0';
				  ssram_Ai  <= w_page & w_pnt;
				  ssram_Di  <= "00" & vme_to_gbt_DTI;
				  XOR8   	<= XOR_N(vme_to_gbt_DTI(31 downto 24)) & XOR_N(vme_to_gbt_DTI(23 downto 16)) &
							   XOR_N(vme_to_gbt_DTI(15 downto  8)) & XOR_N(vme_to_gbt_DTI(7  downto  0));

				  if(w_page = r_page and w_pnt = ALL_ONE(w_pnt'range)) then  -- raggiunta la fine del primo buffer
					w_page 				<= not w_page;
					w_pnt 				<= conv_std_logic_vector(NW_DRM_HT - 1, W_PNT'high + 1);
					w_jump          	<= (others => '0');
				  else
					if(vme_to_gbt_DTI(32) = '1') then 		-- last word of an event
						w_pnt  		<= w_jump; 				-- going back to write the header words
						w_jump 		<= w_pnt + NW_DRM_HT;  	-- pointing to the initial offset to write the next event
						wr_evhead 	<= '1';
					elsif(conv_integer(evhead_cnt) = NW_DRM_HT-2) then
						w_pnt  		<= w_jump;
						w_jump 		<= w_jump - NW_DRM_HT + 1;
						ssram_NEV 	<= ssram_NEV + 1;
						wr_evhead 	<= '0';
						evhead_cnt 	<= (others => '0');  	-- resetting the counter of the header words
					else
						w_pnt 		<= w_pnt + 1;
						if(wr_evhead = '1') then
						  evhead_cnt <= evhead_cnt + 1;
						end if;
					end if;
				  end if;

				  -- La SR va prima almost full (e c'è ancora spazio per scrivere un evento); quando è
				  -- almost full, il processo di scrittura si blocca quando ho finito di scrivere l'evento in
				  -- corso (ovvero quando passa il trailer)
				  if(w_page /= r_page and conv_integer(w_pnt) = ssram_AFLEV) then 	-- SR Almost Full
					ssram_almost_full 	<= '1';
				  end if;
				  if(ssram_almost_full = '1' and vme_to_gbt_DTI(32) = '1') then  	-- mettere majority
					running 			<= '0';
				  end if;

				--reading SSRAM towards SROF (data are OK in the next clock cycle)
				elsif(srof_almfull = '0') then
					ssram_WEi 	<= '1';
					ssram_Ai 	<= r_page & r_pnt;  -- read address
					if(r_page = w_page) then
						if(ssram_NEV /= "00000000" and srof_almfull = '0' and ssram_READ_FIRST = '0' and ssram_READ_FIRST1 = '0' and ssram_READ_FIRST2 = '0' and ssramO_VALID_FIRST = '0') then
							ssram_READ 	<= '1';
							r_pnt 		<= r_pnt + 1;
							if(conv_integer(rwcnt) = 1) then
								ssram_READ_FIRST <= '1';
							end if;
							if(conv_integer(rwcnt) = 2) then
								ssram_NEV <= ssram_NEV - 1;
							end if;
							rwcnt <= rwcnt - 1;
						end if;
					else
						if(r_pnt = ALL_ONE(r_pnt'range)) then
							r_pnt 		<= (others => '0');
							r_page 		<= not(r_page);
						else
							r_pnt 		<= r_pnt + 1;
						end if;
						ssram_READ 	<= '1';
						if(conv_integer(rwcnt) = 1) then
							ssram_READ_FIRST <= '1';
						end if;
						if(conv_integer(rwcnt) = 2) then
							ssram_NEV <= ssram_NEV - 1;
						end if;	
						rwcnt <= rwcnt - 1;
					end if;
					
				end if;
				
				ssram_READ1 		<= ssram_READ;
				ssram_READ2  		<= ssram_READ1;
				ssramO_VALID 		<= ssram_READ2;
				ssram_READ_FIRST1 	<= ssram_READ_FIRST;
				ssram_READ_FIRST2 	<= ssram_READ_FIRST1;
				ssramO_VALID_FIRST 	<= ssram_READ_FIRST2;
				-- leggo i dati da SR (il ciclo di lettura è avvenuto al ciclo di CLK precedente)
				if(ssramO_VALID = '1') then
				  srof_dti 	<= ssram_Ds(32 downto 0);   -- mettere bit 32 = majority dei bit 32,33,34 di SR
				  srof_we 	<= '1';
				  if(ssramO_VALID_FIRST = '1') then
					RWCNT 	<= ssram_Ds(RWCNT'high+2 downto 2);  -- reading event size (in bytes => divided by 4)
				  end if;
				else
				  srof_we 	<= '0';
				end if;
			end if;

		end if;
	  end process;
  
    -- Interrupt Request verso SCL
	  process(clear, FPGACK_40MHz)
	  begin
		if(clear = '1') then
		  ssram_interrupt <= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
		  if (w_page /= r_page and regs.ctrl2(CTRL2_SR_IRQEN) = '1') then 			
			ssram_interrupt <= '1';
		  else
			ssram_interrupt <= '0';
		  end if;
		end if;
	  end process;
  
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- ACCESSO A 40MHz
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
---- uscita dati verso SR (pipeline di 2 clock come previsto dalla SRAM Pipelined)
	 process(clear, FPGACK_40MHz)
	 begin
	   if(clear = '1') then
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
	 ssram_D  	<= transport ssram_Dz        after 1 ns;
	 ssram_A	<= transport '0' & ssram_Ai  after 1 ns;
	 ssram_WE	<= transport ssram_WEi       after 1 ns;

	 -- TEST read
	  regs.ssram_dtl <= ssram_Ds(15 downto 0);
	  regs.ssram_dth <= ssram_Ds(31 downto 16);
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

end RTL;
