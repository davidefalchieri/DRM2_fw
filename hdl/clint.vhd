--!------------------------------------------------------------------------
--! @author       Annalisa Mati  (a.mati@caen.it)               
--! Contact       support.frontend@caen.it
--! @file         clint.vhd
--!------------------------------------------------------------------------
--! @brief        Caen Links Interface
--!------------------------------------------------------------------------               
--! $Id: $ 
--!------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.DRM2pkg.all;
USE work.caenlinkpkg.all;

entity CLINT is
    port(
        ----------------------------------------------------------
        -- Clocks + Reset
        ----------------------------------------------------------
        clk           : in     std_logic;  -- System clock: 50 MHz
        reset         : in     std_logic;  
        clear         : in     std_logic;  
		soft_clear    : in     std_logic; 
		regs          : inout  REGS_RECORD; 
        
        -- ************************************************************************************
        -- SCL (CONET - A3818/A2818)
        -- ************************************************************************************
        -- SCL RX FIFO (from CONET)
        sclif_dto     : in     std_logic_vector (16 downto 0);  -- rx fifo data; if_dto(16)= last packet data
        sclif_rd      : buffer std_logic;                       -- rx fifo read
        sclif_empty   : in     std_logic;                       -- rx fifo empty
        
        -- SCL TX FIFO (to CONET)
        sclof_dti     : out    std_logic_vector (16 downto 0);  -- tx fifo data; of_dti(16)= last packet data
        sclof_wr      : buffer std_logic;                       -- tx fifo write
        sclof_full    : in     std_logic;                       -- tx fifo full  
      
        -- handshake (HACK: TODO)
        scl_pckw      : out    std_logic;                       -- Packet Written
        scl_pckrdy    : in     std_logic;                       -- Packet Ready
      
        -- ************************************************************************************
        -- PXL (Ethernet - A1500)
        -- ************************************************************************************
        -- PXL RX FIFO (from A1500)
        pxlif_dto     : in     std_logic_vector (16 downto 0);  -- Data
        pxlif_rd      : buffer std_logic;                       -- Read Enable
        pxlif_empty   : in     std_logic;                       -- Empty

        -- PXL TX FIFO (to A1500)
        pxlof_dti     : out    std_logic_vector (16 downto 0);  -- Data
        pxlof_wr      : out    std_logic;                       -- Write Enable
        pxlof_full    : in     std_logic;                       -- Almost Full
    
        -- handshake
        pxl_pckw      : out    std_logic;                       -- Packet Written
        pxl_pckrdy    : in     std_logic;                       -- Packet Ready                  

        -- ************************************************************************************
        -- LOCAL BUS 
        -- ************************************************************************************
        -- Output Data FIFO 
        odf_dto       : in    std_logic_vector (32 downto 0);  -- data bus: bit 32 = END EVENT
        odf_rd        : out   std_logic;                       -- read
        odf_empty     : in    std_logic;                       -- empty                      
        evwritten     : in    std_logic;                       -- event written   ???   
        
        lb_address    : out std_logic_vector (31 downto 0);  -- Local Bus Address
        lb_wdata      : out std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_wr)
        lb_rdata      : in  std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_rd)
        lb_wr         : out std_logic;                       -- Local Bus Write
        lb_rd         : buffer std_logic;                    -- Local Bus Read                
        lb_rdy        : in  std_logic;                       -- Local Bus Ready                        
        vme_info      : inout VMEINFO_RECORD;        
        
        gpio          : inout std_logic_vector(7 downto 0)        
    );
end CLINT;

architecture rtl of CLINT is

    -----------------------------------------------------------------------------------------   
    -- Signal Declarations
    -----------------------------------------------------------------------------------------   
    signal scl_cyc   : std_logic;                       -- indica che c'e' un ciclo di SCL in corso
    signal pxl_cyc   : std_logic;                       -- indica che c'e' un ciclo di PXL in corso

    signal if_get    : std_logic;
    signal if_dto    : std_logic_vector (16 downto 0);  -- rx fifo data; if_dto(16)= last packet data
    signal if_rd     : std_logic;                       -- rx fifo read
    signal if_empty  : std_logic;                       -- rx fifo empty

    signal of_dti    : std_logic_vector (16 downto 0);  -- tx fifo data; of_dti(16)= last packet data
    signal of_wr     : std_logic;                       -- tx fifo write
    signal of_full   : std_logic;                       -- tx fifo full  
        
    signal pckwi     : std_logic;                       -- PCKW interno
        
    signal nodata    : std_logic;
    signal rdnwr     : std_logic;
    signal lastcmd   : std_logic;
    signal dsize     : std_logic_vector(1 downto 0);
    signal swap      : std_logic;
    signal dataspace_drm : std_logic;
    signal dataspace_trm : std_logic;
    signal dataspace : std_logic;
    signal breakblt  : std_logic;
    signal invaddr   : std_logic;
    signal bltcyc    : std_logic;
    signal pbltcyc   : std_logic;
    signal reg_cyc   : std_logic;
    signal slot      : std_logic_vector( 3 downto 0);

    signal ncyc      : std_logic_vector(15 downto 0);
    signal blt_size  : std_logic_vector(15 downto 0);
    signal regdata   : std_logic_vector(31 downto 0);
    signal wdata     : std_logic_vector(31 downto 0);
    signal addr      : std_logic_vector(31 downto 0);
    
    signal evreadr   : std_logic;
    signal evreadrr  : std_logic;
    signal evrdyr    : std_logic;
    signal evcnt     : std_logic_vector(15 downto 0);  -- Event Counter
    signal nevstored : std_logic_vector(15 downto 0);  -- evcnt risincronizzato
    signal evrcnt    : std_logic_vector(15 downto 0);  -- Event Read Counter
    
    signal evrdy     : std_logic:= '1';
    signal evread    : std_logic;   
    
    
    -----------------------------------------------------------------------------------------   
    -- FSMs Declarations
    -----------------------------------------------------------------------------------------   
    attribute syn_encoding : string;
    ---------------
    type   TSTATCLINT is (CLINT_IDLE, CLINT_OPCODE, CLINT_GETSIZE, CLINT_GETAD0, CLINT_GETAD1, CLINT_GETDT0, CLINT_GETDT1, CLINT_FAKE_READ,
                          CLINT_STARTCYC, CLINT_WREG, CLINT_RREG, CLINT_RBLT, CLINT_TXDATA_L, CLINT_TXDATA_H, CLINT_TX_NODATA, CLINT_WRSTAT,
                          CLINT_RES_CYC);
    attribute syn_encoding of TSTATCLINT : type is "onehot";
    signal fsm_clint : TSTATCLINT;
    
begin       
    
    ---------------------------------------------------------------------------
    -- Event Stored Counter
    ---------------------------------------------------------------------------               
    process(clk, clear, soft_clear)
    begin
        if(clear = '1' or soft_clear = '1') then
            evreadr  <= '0';
            evreadrr <= '0';
            evrdyr   <= '0';
            evcnt    <= (others => '0');
        elsif(clk'event and clk = '1') then
            evreadr  <= evread;
            evreadrr <= evreadr;
            if evwritten = '1' and not (evreadr = '1' and evreadrr = '0') then
                evcnt <= evcnt + 1;
            elsif evwritten = '0' and (evreadr = '1' and evreadrr = '0') then
                evcnt <= evcnt - 1;
            end if;
            if evcnt = fill0(evcnt'length) then
                evrdyr <= '0';
            else
                evrdyr <= '1';
            end if;
        end if;
    end process;
                
    -- Re-sync
    process(clk)
    variable e1, e2, e3, e4, e5 : std_logic;
    begin
        if clk'event and clk = '1' then
        -- EVRDY deve avere una pipeline per compensare la latenza della FIFO ODF
            evrdy     <= e5;
            --evrdy     <= '1';
            e5        := e4;
            e4        := e3;
            e3        := e2;
            e2        := e1;
            e1        := evrdyr;
            nevstored <= evcnt;
        end if;
    end process;

    regs.status(STATUS_EVREADY) <= evrdy;
    --regs.nevstored           <= ZEROS(31 downto 16) & nevstored;
    
    ---------------------------------------------------------------------------
    -- FSM: che gestisce gli accessi da link ottico e la rilettura della FIFO di acquisizione
    ---------------------------------------------------------------------------
    --   Prima parola dalla INPUT PIPE = OPCODE               
    --   |   15  |   14   |                 |     7    |   6   |5       4|3       0|
    --   |IP_TYPE|IP_WRITE|      .....      |IP_LASTCMD|IP_SWAP|IP_DTSIZE|IP_OPCODE| 

    -- Mux da/verso le FIFO di SCL e PXL
    -- INPUT FIFO
    if_dto      <= sclif_dto when scl_cyc = '1' else pxlif_dto;
    sclif_rd    <= if_get and not sclif_empty when scl_cyc = '1' else '0';
    pxlif_rd    <= if_get and not pxlif_empty when pxl_cyc = '1' else '0';
    
    if_empty    <= sclif_empty when scl_cyc = '1' else pxlif_empty; -- non lo uso
    
    if_rd       <= sclif_rd or pxlif_rd;  
    
    -- OUTPUT FIFO
    sclof_dti   <= of_dti;   
    pxlof_dti   <= of_dti;
    
    sclof_wr    <= of_wr when scl_cyc = '1' else '0';
    pxlof_wr    <= of_wr when pxl_cyc = '1' else '0';
    
    of_full     <= sclof_full when scl_cyc = '1' else pxlof_full;

    process(reset, clk)
    begin
        if reset = '1' then
            scl_pckw <= '0';
            pxl_pckw <= '0';
        elsif clk'event and clk='1' then
            scl_pckw <= '0';
            pxl_pckw <= '0';
            if pckwi = '1' then
                if scl_cyc = '1' then
                    scl_pckw <= '1';
                end if;
                if pxl_cyc = '1' then
                    pxl_pckw <= '1';
                end if;
            end if;
        end if;
    end process;
    
    
    F_fsm_clint : process(clk, reset)
        variable stop_blt   : std_logic;
        variable data_ready : std_logic;
        variable berr_flag  : std_logic;
        variable opcode     : std_logic_vector(15 downto 0);
    begin
        if reset = '1' then  -- PWON o LINKRES
    
--            fsm_clint  <= CLINT_OPCODE;
            fsm_clint  <= CLINT_IDLE;

            scl_cyc    <= '0';
            pxl_cyc    <= '0';
            
            if_get     <= '0';
            of_wr      <= '0';
            of_dti     <= (others => '0');
            odf_rd     <= '0';
            pckwi      <= '0';

            opcode     := (others => '0');
            evread     <= '0';
            evrcnt     <= X"0001";

            dsize      <= "00";
            rdnwr      <= '0';
            swap       <= '0';
            dataspace  <= '0';
            dataspace_trm  <= '0';
            dataspace_drm  <= '0';
            breakblt   <= '0';
            invaddr    <= '0';
            stop_blt   := '0';
            data_ready := '0';
            lastcmd    <= '0';

            bltcyc     <= '0';
            pbltcyc    <= '0';
            reg_cyc    <= '0';  -- accessi con le funzioni ReadREG e WriteREG
            slot       <= "0001";
            
            vme_info.cyctype <= SINGLERW;
            vme_info.dtsize  <= D16;
            vme_info.am      <= A32_U_DATA;

            ncyc       <= (others => '0');
            blt_size   <= (others => '0');
            regdata    <= (others => '0');
            wdata      <= (others => '0');
            nodata     <= '0';
                        
            lb_address <= (others => '0');
            lb_wdata(31 downto 0)   <= (others => '0');
            lb_wdata(32)            <= '0';
            lb_wr      <= '0';        
            lb_rd      <= '0';   

			berr_flag  := '0';
            
        elsif rising_edge(clk) then  
    
            -- default
            of_wr     <= '0';
            odf_rd    <= '0';
            evread    <= '0';
                        
            case fsm_clint is

            -----------------------------        
            when CLINT_IDLE =>  

                bltcyc    <= '0';
                pbltcyc   <= '0';
                reg_cyc   <= '0';
                lastcmd   <= '1';
                invaddr   <= '0';
                pckwi     <= '0';
                if_get    <= '0';  
                stop_blt  := '0';
				
				dataspace_trm  <= '0';		-- DAV 27/06/2017
				dataspace_drm  <= '0';		-- DAV 27/06/2017
				dataspace	   <= '0';		-- DAV 27/06/2017

                -- se ho dati da una FIFO di ingresso e non c'è un ciclo in corso sull'altro
                -- canale, allora vado a leggere l'opcode
                if scl_pckrdy = '1' and pxl_cyc = '0' then  -- priorità al CONET
                    scl_cyc   <= '1';
                    if_get    <= '1';  -- chiedo dati da conet
                    fsm_clint <= CLINT_OPCODE;                    
                elsif pxl_pckrdy = '1' and scl_cyc = '0' then
                    pxl_cyc   <= '1';
                    if_get    <= '1';  -- chiedo dati da a1500
                    fsm_clint <= CLINT_OPCODE;                    
                end if;
                                            
            -----------------------------        
            when CLINT_OPCODE =>

                bltcyc    <= '0';
                pbltcyc   <= '0';
                reg_cyc   <= '0';
                lastcmd   <= '1';
                invaddr   <= '0';
                if_get    <= '1';  -- chiedo dati da conet o da a1500
                stop_blt  := '0';
                                
                if if_rd = '1' then  -- arrivano dati (opcode pronto)
    
                    opcode:= if_dto(15 downto 0);
    
                    -- la DRM risponde a
                    -- 1) accessi CAENVME_ReadRegister e CAENVME_WriteRegister: vengono interpretati come accessi ai suoi registri interni (in questo caso 
                    --    gli accessi sono solo in D16 e non si possono fare accessi in BLT)
                    -- NOTA: i registri interni alla DRM hanno comunque al massimo 16 bit significativi.
                    
                    -- 2) accessi CAENVME_ReadCycle    e CAENVME_WriteCycle: in questo caso conta la parte alta dell'indirizzo, che definisce lo SLOT VME.
                    -- se lo SLOT=1 stiamo accedendo ai registri della DRM
                    -- se lo SLOT>1 stiamo accedendo alle TRM tramite il VME  
                    
                    ---------------------------------------------------------------------------
                    --   Prima parola dalla INPUT PIPE = OPCODE               
                    --   |   15  |   14   |                 |     7    |6         0|
                    --   |IP_TYPE|IP_WRITE|      .....      |IP_LASTCMD|  ADDRESS  | 
                    --    IP_TYPE = 0    
                    if if_dto(IP_TYPE) = '0' then                                                               -- CASO 1)
                        reg_cyc      <= '1';
                        slot         <= "0001";
                        rdnwr        <= if_dto(IP_WRITE);  -- Read/Write
                        addr         <= "0001" & ZEROS(27 downto 7) & if_dto(6 downto 0); -- address nell'opcode su 7 bit
                        if if_dto(IP_WRITE) = '0' then  -- scrittura registro
                            fsm_clint <= CLINT_GETDT0;
                        else                            -- lettura registro
                            if_get    <= '0';
                            fsm_clint <= CLINT_STARTCYC;
                        end if;
                    ---------------------------------------------------------------------------
                    --   Prima parola dalla INPUT PIPE = OPCODE               
                    --   |   15  |   14   |13   8|     7    |   6   |5       4|3       0|
                    --   |IP_TYPE|IP_WRITE|  AM  |IP_LASTCMD|IP_SWAP|IP_DTSIZE|IP_OPCODE| 
                    --    IP_TYPE = 1    
                    else                                                                                        -- CASO 2)
                        rdnwr        <= if_dto(IP_WRITE);  -- Read/Write
                        -- decodifico il tipo di ciclo (bit 3..0 dell'opcode)
                        if    if_dto(IP_OPCODE'range) = BLT  or if_dto(IP_OPCODE'range) = BLT_FIFO then
                            bltcyc    <= '1';
                        elsif if_dto(IP_OPCODE'range) = PBLT or if_dto(IP_OPCODE'range) = PBLT_FIFO then
                            bltcyc    <= '1';
                            pbltcyc   <= '1';
                        end if;
    
                        -- memorizza gli altri parametri dell'opcode
                        dsize    <= if_dto(IP_DTSIZE'range);
                        lastcmd  <= if_dto(IP_LASTCMD);  -- ultimo comando => do ENDPCK
                        swap     <= if_dto(IP_SWAP);     -- Byte Swap
                        ncyc     <= "0000000000000001";  -- numero di cicli eseguiti
    
                        vme_info.cyctype <= if_dto(IP_OPCODE'range);
                        vme_info.dtsize  <= if_dto(IP_DTSIZE'range);
                        vme_info.am      <= if_dto(IP_AM'range);
                        
                        -- Decido lo stato a cui saltare
                        if (if_dto(IP_OPCODE'range) = BLT)      or (if_dto(IP_OPCODE'range) = PBLT) or
                           (if_dto(IP_OPCODE'range) = BLT_FIFO) or (if_dto(IP_OPCODE'range) = PBLT_FIFO) then
        
                            fsm_clint <= CLINT_GETSIZE;
                        else -- OPCODE = SINGLERW
                            fsm_clint <= CLINT_GETAD0;    -- vado a leggere l'indirizzo
                        end if;
                    end if;
                end if;

            -----------------------------        
            when CLINT_GETSIZE =>
                if if_rd = '1' then
                    blt_size  <= if_dto(15 downto 0);
                    fsm_clint <= CLINT_GETAD0;    -- vado a leggere l'indirizzo   
                end if;

            -----------------------------      
            -- parte bassa dell'indirizzo
            when CLINT_GETAD0 =>
                if if_rd = '1' then                
                    addr(15 downto 0) <= if_dto(15 downto 0);
					-- accesso diretto alla SROF o ciclo BLT sul VME
                    if if_dto(15 downto 0) = A_OUTBUF then
                        dataspace_drm <= '1';
                    else
                        dataspace_drm <= '0';
                    end if;
                    if if_dto(15 downto 0) = ZEROS(15 downto 0) then
                        dataspace_trm <= '1';
                    else
                        dataspace_trm <= '0';
                    end if;

                    fsm_clint <= CLINT_GETAD1;
                end if;

            -----------------------------        
            -- parte alta dell'indirizzo: definisce lo slot
            -- se accedo allo slot 1, si tratta di un accesso ai registri interni della DRM 
            when CLINT_GETAD1 =>  
                if if_rd = '1' then
                    addr(31 downto 16) <= if_dto(15 downto 0);
                    slot               <= if_dto(15 downto 12);
					if if_dto(15 downto 12) = "0001" and dataspace_drm = '1' then  -- accesso diretto al DATASPACE della DRM
						dataspace <= '1';
					elsif if_dto(15 downto 12) > "0001" and dataspace_trm = '1' then -- accesso al DATASPACE delle TRM (BLT sul VME)
						dataspace <= '1';
					else
						dataspace_drm <= '0';
						dataspace_trm <= '0';
						dataspace     <= '0';
					end if;
                    if rdnwr = '0' then   -- vado a leggere i dati per la scrittura
                        fsm_clint <= CLINT_GETDT0;
                    else
                        if_get    <= '0'; -- parto con il ciclo
                        fsm_clint <= CLINT_STARTCYC;
                    end if;
                end if;

            -----------------------------        
            -- parte bassa del dato da scrivere
            when CLINT_GETDT0 =>
                if if_rd = '1' then
                
                    if reg_cyc = '1' then
                        wdata(15 downto 0) <= if_dto(15 downto 0);  -- reg_cyc: solo 16 bit di dato significativi i registri interni della DRM sono a 16 bit
                        if_get             <= '0';
                        fsm_clint          <= CLINT_STARTCYC;
                    
                    elsif (dsize = D8) or (dsize = D16) then
                        if swap = '0' then
                            wdata(15 downto 0) <= if_dto(15 downto 0);
                        else
                            wdata(15 downto 0) <= if_dto(7 downto 0) & if_dto(15 downto 8);
                        end if;
                        if_get             <= '0';
                        fsm_clint          <= CLINT_STARTCYC;
                    else -- dsize = D32
                        if swap = '0' then
                            wdata(15 downto 0)  <= if_dto(15 downto 0);
                        else
                            wdata(31 downto 16) <= if_dto(7 downto 0) & if_dto(15 downto 8);
                        end if;
                        fsm_clint  <= CLINT_GETDT1;
                    end if;
                end if;

            -----------------------------        
            -- parte alta del dato da scrivere
            when CLINT_GETDT1 =>
                if if_rd = '1' then
                    if swap = '0' then
                        wdata(31 downto 16) <= if_dto(15 downto 0);
                    else
                        wdata(15 downto 0)  <= if_dto(7 downto 0) & if_dto(15 downto 8);
                    end if;
                    if_get     <= '0';
                    fsm_clint  <= CLINT_STARTCYC;
                end if;

            -----------------------------        
            when CLINT_STARTCYC =>
            
                if breakblt = '1' then    -- c'e' stato un BREAK durante un BLT
                    if pbltcyc = '1' then   -- se era un PBLT, leggo il prossimo comando
                        if_get    <= '1';
                        fsm_clint <= CLINT_OPCODE;     -- HACK: non ritorno in IDLE... rimango su SCL o PXL
                    else                    -- altrimenti chiudo con la parola di stato
                        fsm_clint <= CLINT_WRSTAT;
                    end if;
                    
                -- Accesso ad un registro    
                elsif dataspace = '0' then  
                    lb_address <= addr;

                    if rdnwr = '1' then     -- read
                        lb_rd     <= '1';
                        fsm_clint <= CLINT_RREG;
                    else                    -- write
                        lb_wr     <= '1';
                        lb_wdata(31 downto 0)  <= wdata;
                        lb_wdata(32)           <= '1';
                        fsm_clint <= CLINT_WREG;
                    end if;
                -- Accesso ai dati (solo lettura)
                else  
                    -- DATI ORGANIZZATI AD EVENTI
					if dataspace_drm = '1' then
						-- ho eventi da leggere
						if evrdy = '1' then -- and odf_empty = '0' then  
							fsm_clint  <= CLINT_TXDATA_L;
						-- non ho eventi in ODF

						else
							if bltcyc = '0' then        -- accessi singoli => do un FILLER

								nodata     <= '1';
								fsm_clint  <= CLINT_TXDATA_L;

							else                 
								breakblt  <= '1';       -- BLT => interrompo il ciclo
								if pbltcyc = '1' then   -- se era un PBLT, leggo il prossimo comando

									if_get    <= '1';
									fsm_clint <= CLINT_OPCODE;  -- HACK: non ritorno in IDLE... rimango su SCL o PXL
								else                    -- altrimenti chiudo con la parola di stato
									fsm_clint <= CLINT_WRSTAT;



								end if;
							end if;
						end if;
					elsif dataspace_trm = '1' then  -- faccio una richiesta su local bus di un ciclo BLT sul VME
						lb_address <= addr;
						lb_rd     <= '1';
                        fsm_clint <= CLINT_RBLT;					
					end if;					
                end if;

            -----------------------------        
            when CLINT_RBLT  =>
                if lb_rdy = '1' then  -- è finito il ciclo BLT. HACK: mettere un timeout
                    lb_rd      <= '0';
					-- ho dati da leggere in ODF
					if odf_empty = '0' then  -- evrdy = '1' 
						fsm_clint  <= CLINT_TXDATA_L;
					-- non ho dati in ODF
					else
						breakblt  <= '1';       -- BLT => interrompo il ciclo
						if pbltcyc = '1' then   -- se era un PBLT, leggo il prossimo comando
							if_get    <= '1';
							fsm_clint <= CLINT_OPCODE;  -- HACK: non ritorno in IDLE... rimango su SCL o PXL
						else                    -- altrimenti chiudo con la parola di stato
							fsm_clint <= CLINT_WRSTAT;
						end if;
					end if;

				end if;
				
            -----------------------------        
            when CLINT_RREG  =>
                if lb_rdy = '1' then  -- HACK: mettere un timeout
                    lb_rd      <= '0';
                    regdata    <= lb_rdata(31 downto 0);
                    fsm_clint  <= CLINT_TXDATA_L;
					--bltcyc	   <= '0';	-- DAV hack to avoid filling OF with regdata (and blocking everything)!!
                end if;

            -----------------------------        
            when CLINT_WREG  =>  
                if lb_rdy = '1' then -- HACK: mettere un timeout
                    lb_wr      <= '0';
                    lb_wdata(31 downto 0)   <= wdata;   
                    lb_wdata(32)            <= '1';
                    if reg_cyc = '1' then
                        fsm_clint  <= CLINT_RES_CYC;  -- nel caso di CAENVME_WriteRegister non si risponde con la parola di stato
                    else
                        fsm_clint  <= CLINT_WRSTAT;
                    end if;
                end if;

                                                
            -----------------------------        
            when CLINT_TXDATA_L =>
                if of_full = '0' then  -- se tl è full => aspetto
                    if dataspace = '0' then
                        of_dti <= '0' & regdata(15 downto 0);
                        of_wr     <= '1';
                        if reg_cyc = '1' then
                            fsm_clint  <= CLINT_WRSTAT;   -- reg_cyc: solo 16 bit di dato significativi (la richiesta D32 da SW viene ignorata)
                        elsif (dsize = D8) or (dsize = D16) then
                           fsm_clint   <= CLINT_WRSTAT;
                        else -- dsize = D32
                           fsm_clint   <= CLINT_TXDATA_H;
                        end if;
                    else
                        if nodata = '0' then  -- HACK: accessi singoli?
                            of_dti <= '0' & odf_dto(15 downto 0);
                            odf_rd <= '1';
                        else
                            of_dti <= '0' & FILLER(15 downto 0);
                        end if;
                        of_wr     <= '1';
                        fsm_clint <= CLINT_TXDATA_H;
                    end if;
--                    of_wr     <= '1';
--                    fsm_clint <= CLINT_TXDATA_H;
                end if;

            -----------------------------        
            when CLINT_TXDATA_H =>
                if dataspace = '0' then
                    of_dti <= '0' & regdata(31 downto 16);
                else
                    if nodata = '0' then
                        of_dti <= '0' & odf_dto(31 downto 16);
                    else
                        of_dti <= '0' & FILLER(31 downto 16);
                    end if;
                end if;
                of_wr  <= '1';
                ncyc   <= ncyc + 1;  -- incremento il contatore di cicli per il blt

                -- BLT: verifico se ho finito i dati oppure se ho terminato i cicli previsti
                if bltcyc = '1' then
                    if odf_dto(32) = '1' then      -- fine evento
                        evread <= '1';
                        evrcnt <= evrcnt + 1;
                        --if evrcnt = reg(nevread'range) or nevstored = 1 then --HACK: aggiungere il readout di più eventi allineati
						if nevstored = 1 then		-- DAV 12/07/2018
                            stop_blt := '1';
                        end if;
                    end if;
                    if ncyc = blt_size  then      -- ho terminato i cicli previsti
                        stop_blt := '1';
                    end if;
                    
                    if stop_blt = '1' then
                        if ncyc /= blt_size then  -- uscita prematura perché ho finito i dati:  BREAK durante un BLT
                            breakblt <= '1';
                        end if;
                        if pbltcyc = '1' then    	
                            if_get     <= '1';
                            fsm_clint  <= CLINT_OPCODE;  -- HACK: non ritorno in IDLE... rimango su SCL o PXL
                        else
                            fsm_clint  <= CLINT_WRSTAT;
                        end if;
                    elsif odf_empty = '0' then
                        fsm_clint  <= CLINT_TXDATA_L;
                    else
                        fsm_clint  <= CLINT_TX_NODATA;
                    end if;

                -- Singolo ciclo
                else
                    fsm_clint  <= CLINT_WRSTAT;
                end if;

            -----------------------------        
            when CLINT_TX_NODATA =>
                if odf_empty = '0' then
                    fsm_clint  <= CLINT_TXDATA_L;
                end if;

            -----------------------------        
            when CLINT_WRSTAT =>
				berr_flag  := breakblt or vme_info.berrflag;
                of_dti <= lastcmd & "0000000000" & berr_flag & not invaddr & "0000";
                if lastcmd = '1' then
                    pckwi <= '1';  -- HACK ??? 
                end if;
                of_wr     <= '1';
                breakblt  <= '0';
                invaddr   <= '0';
                nodata    <= '0';
                --evrcnt    <= X"0001";
                lb_rd     <= '0';
                lb_wr     <= '0';
                lb_wdata(32)  <= '0';

                fsm_clint <= CLINT_RES_CYC;
            
            -----------------------------        
            when CLINT_RES_CYC   =>

                pxl_cyc    <= '0';
                scl_cyc    <= '0';
                pckwi      <= '0';
--                fsm_clint  <= CLINT_OPCODE;
                fsm_clint  <= CLINT_IDLE;
                
                
            -----------------------------        
            when CLINT_FAKE_READ =>
                of_dti    <= (others => '0');
                of_wr     <= '1';
                fsm_clint <= CLINT_WRSTAT;
                      
            end case;
        end if;
    end process;


end rtl;





