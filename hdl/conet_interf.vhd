--!------------------------------------------------------------------------
--! @author       Annalisa Mati  (a.mati@caen.it)               
--! Contact       support.frontend@caen.it
--! @file         conet_interf.vhd
--!------------------------------------------------------------------------
--! @brief        CONET2 INTERFACE
--!------------------------------------------------------------------------               
--! $Id: $ 
--!------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
USE work.caenlinkpkg.all;

entity CONET_INTERF is
port(
    sys_clk             : in  std_logic;   

    linkres_n           : out std_logic;
    
    rx_start            : out std_logic;                                                         
    rx_comma            : out std_logic;                                                         
    
    -- TX
    tx_reset_n          : in  std_logic;
    tclk                : in  std_logic;
    tx_data             : out std_logic_vector( 7 downto 0);
    tx_charisk          : out std_logic_vector( 0 downto 0);
    -- RX
    rx_reset_n          : in  std_logic;
    rclk                : in  std_logic;                       
    rx_data             : in  std_logic_vector( 7 downto 0);
    rx_charisk          : in  std_logic_vector( 0 downto 0);    

    rx_syncstatus       : in  std_logic;                       -- CorePCS ALIGNED 

    -- ************************************************************************************
    -- RX local Pipe (dati da CONET)
    rl_dto              : buffer std_logic_vector(16 downto 0);
    rl_rd               : in     std_logic;
    rl_empty            : buffer std_logic;
    
    -- TX local Pipe (dati verso CONET)
    tl_dti              : in     std_logic_vector (16 downto 0);  
    tl_wr               : in     std_logic;                       
    tl_full             : out    std_logic;                       
    
    -- handshake con clint : HACK TODO
    scl_pckw            : in     std_logic;                       -- Packet Written (HACK: da usare al posto di pckw valutato dentro la conet_interf?)
    scl_pckrdy          : out    std_logic;                       -- Packet Ready (RX)
    
    -- ************************************************************************************
    irq                 : in     std_logic;                       -- interrupt request (attivo alto)
                        
    tick                : in     std_logic;                       -- almeno 2 ms                      
    gpio                : out    std_logic_vector(7 downto 0);
    led_opt             : out    std_logic                        -- led TX/RX (attivo basso)
  );

end CONET_INTERF ;

architecture RTL of CONET_INTERF is

    -----------------------------------------------------------------------------------------   
    -- Signal Declarations
    -----------------------------------------------------------------------------------------   
    signal linkres_i_n : std_logic;
    signal rx_commadetect : std_logic;
    signal rescnt         : std_logic_vector(5 downto 0);   -- Reset Counter
    
    signal fifo_clear  : std_logic;
    -------------------------------------   
    -- RX local Pipe (dati da CONET a LocalBus)
    signal rl_dti      : std_logic_vector(16 downto 0);
    signal rl_wr       : std_logic;

    signal rl_rd_i     : std_logic;  -- segnali per trasformare la fifo da tipo Legacy a ShowAhead 
    signal rl_empty_i  : std_logic; 

    signal rl_wrusedw  : std_logic_vector(10 downto 0);
    signal rl_almfull  : std_logic;
    
    -------------------------------------   
    -- TX local Pipe (dati da LocalBus a CONET)
    signal tl_dto      : std_logic_vector(17 downto 0);  
    signal tl_rd       : std_logic;
    signal tl_empty    : std_logic;

    signal tl_rd_i     : std_logic;  -- segnali per trasformare la fifo da tipo Legacy a ShowAhead 
    signal tl_empty_i  : std_logic;
    
    signal tl_wrusedw  : std_logic_vector(10 downto 0);
    signal tl_almfull  : std_logic;

    signal tl_dti_i    : std_logic_vector(17 downto 0);
    signal tl_wr_i     : std_logic;

    -------------------------------------   
    -- fsm_rx signals
    signal rx_res      : std_logic;
    signal bl          : std_logic_vector (7  downto 0); -- bit 7-0 della word
    signal bh          : std_logic_vector (7  downto 0); -- bit 15-8 della word
    signal word_rdy    : std_logic;                      -- bl e bh pronti
    signal token       : std_logic;                      -- Token ricevuto da FSM-RX
    signal irqrx       : std_logic;                      -- segnala che sto ricevendo un IRQ Stat di un modulo precedente
    signal rx_faili    : std_logic;                      -- errore di ricezione dalla FSM_R
    signal rx_header   : std_logic;                      -- ricevo una header di pacchetto
    signal endpck      : std_logic;
    
    signal endpck_s    : std_logic;                      -- Set Asincrono di endpck
    signal prcnt       : std_logic_vector(2 downto 0);   -- contatore per ritardare scl_pckrdy
    signal pck_pend    : std_logic_vector(3 downto 0);   -- contatore di pacchetti pronti in attesa
    signal inc_pck     : std_logic;                      -- incrementa pck_pend
    
    -------------------------------------   
    -- fsm_tx signals
    signal cnt_tx      : std_logic_vector(23 downto 0);    
    signal bsync       : std_logic;
    
    signal tx_res      : std_logic;
    signal endspt      : std_logic;
    signal eot         : std_logic;
    signal dec_pcnt    : std_logic;
    signal irqsend     : std_logic;
    signal irqtx       : std_logic;
    signal temp        : std_logic_vector(15 downto 0);
    signal daddr       : std_logic_vector(3 downto 0);   -- Address Dinamico       
       
    -------------------------------------   
    -- segnali per gestire il conteggio dei pacchetti pronti per la spedizione
    signal pckw        : std_logic;    -- segnala che e' stato scritto un pacchetto in tl
    signal pckw_d      : std_logic;                       -- pckw ritardato
    signal wcnt        : std_logic_vector(7 downto 0);    -- word counter
    signal inc         : std_logic_vector(5 downto 0);
    signal inc_pcnt    : std_logic;
    signal pck_rdy     : std_logic;
    signal pcnt        : std_logic_vector(3 downto 0);

    -------------------------------------   
    -- Interrupt
    signal irq1        : std_logic;  -- irq risincronizzato con tclk
    signal irq2        : std_logic;  -- irq1 ritardato
    signal irqsreq     : std_logic;  -- segnala che deve essere inviato un irq stat mio

    -------------------------------------   
    signal toksr       : std_logic;  -- Set/Reset
    signal tok         : std_logic_vector(15 downto 0);  -- Token intermedi per ritardare
    signal tokent      : std_logic;  -- Token risincronizzato con TCLK per la FSM-TX
       
    -----------------------------------------------------------------------------------------   
    -- Component Declarations
    -----------------------------------------------------------------------------------------      
    -- FIFO LEGACY, DUAL CLOCK, WIDTH 17, DEPTH 1024, RESET active low
    COMPONENT RL
    PORT
    (
        RESET   : IN  STD_LOGIC;

        WCLOCK  : IN  STD_LOGIC;
        DATA    : IN  STD_LOGIC_VECTOR (16 DOWNTO 0);
        WE      : IN  STD_LOGIC;
        FULL    : OUT STD_LOGIC;
        WRCNT   : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);

        RCLOCK  : IN  STD_LOGIC;
        Q       : OUT STD_LOGIC_VECTOR (16 DOWNTO 0);
        RE      : IN  STD_LOGIC;
        EMPTY   : OUT STD_LOGIC
    );
    END COMPONENT;  -- 1024
    
    -- FIFO LEGACY, DUAL CLOCK, WIDTH 18, DEPTH 1024, RESET active low
    COMPONENT TL
    PORT
    (
        RESET   : IN  STD_LOGIC;

        WCLOCK  : IN  STD_LOGIC;
        DATA    : IN  STD_LOGIC_VECTOR (17 DOWNTO 0);
        WE      : IN  STD_LOGIC;
        FULL    : OUT STD_LOGIC;
        WRCNT   : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);

        RCLOCK  : IN  STD_LOGIC;
        Q       : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
        RE      : IN  STD_LOGIC;
        EMPTY   : OUT STD_LOGIC
    );
    END COMPONENT;  -- 1024  
	
	-- DAV
	---------------------------------------------------------------------------------------------------------------------------------------------
	component trigger_fifo is
	---------------------------------------------------------------------------------------------------------------------------------------------
    port(
        -- Inputs
        DATA   : in  std_logic_vector(0 to 0);
        RCLOCK : in  std_logic;
        RE     : in  std_logic;
        RESET  : in  std_logic;
        WCLOCK : in  std_logic;
        WE     : in  std_logic;
        -- Outputs
        EMPTY  : out std_logic;
        FULL   : out std_logic;
        Q      : out std_logic_vector(0 to 0)
        );
	end component trigger_fifo;
    
    -----------------------------------------------------------------------------------------   
    -- FSMs Declarations
    -----------------------------------------------------------------------------------------   
    attribute syn_encoding : string;
    ---------------
    -- rclk domain fsm
    type   TSTATRES is (SRES_RES, SRES_BSYNC, SRES_GO);
    attribute syn_encoding of TSTATRES : type is "onehot";
    signal fsm_res : TSTATRES;   

    
    type   TSTATRX is (SRX_IDLE, SRX_BYTEL, SRX_BYTEH, SRX_WLAST, SRX_FAIL);
    attribute syn_encoding of TSTATRX : type is "onehot";
    signal fsm_rx : TSTATRX;
        
    -- tclk domain fsm
    type   Tfsm_tx is (STX_COMMA, STX_IDLE, STX_START, STX_IRQST, STX_BYTEL, STX_BYTEH, STX_STOP);
    attribute syn_encoding of Tfsm_tx : type is "onehot";
    signal fsm_tx : Tfsm_tx;
	
	signal irq_tclk:	std_logic;		-- DAV
    

begin

	-- DAV
	trigger_fifo_irq_instance: trigger_fifo
    port map(
        DATA(0)	=> irq,
		RESET  	=> '0', 
		WCLOCK 	=> sys_clk,
		WE     	=> '1',
		RE     	=> '1',
        RCLOCK 	=> tclk, 		
		Q(0)   	=> irq_tclk,
        EMPTY 	=> open,
        FULL   	=> open
        );

    -------------------------------------------------------------------------------------------    
    -- RESET & CLEAR:
    fifo_clear <= linkres_i_n;
    
    -- *****************************************************************************************************************
    -- FIFO
    -- *****************************************************************************************************************
    -------------------------------------------------------------------------------------------
    -- RX FIFO (dati da CONET a LocalBus)    
    I_RX : RL
    port map (
        RESET   => fifo_clear,

        WCLOCK  => rclk,
        DATA    => rl_dti,
        WE      => rl_wr,
        FULL    => open,
        WRCNT   => rl_wrusedw,
        
        RCLOCK  => sys_clk,
        Q       => rl_dto,
        RE      => rl_rd_i,
        EMPTY   => rl_empty_i
    );
  
    -- Logica per trasformare la fifo da tipo Legacy (RDREQ=richiesta di lettura) a tipo
    -- ShowAhead (RDREQ=read acknowledge)
    rl_rd_i <= not rl_empty_i and (rl_empty or rl_rd);

    process(sys_clk, fifo_clear)  -- read clock
    begin
        if fifo_clear = '0' then
            rl_empty <= '1';
        elsif rising_edge(sys_clk) then
            if rl_rd_i = '1' and rl_rd = '0' then
                rl_empty <= '0';
            elsif rl_rd_i = '0' and rl_rd = '1' then
                rl_empty <= '1';
            end if;
        end if;
    end process;    
    
    -- FIFO Almost Full
    process(tclk, fifo_clear)  -- write clock
    begin
        if fifo_clear = '0' then
            rl_almfull <= '0';
        elsif rising_edge(tclk) then
            if conv_integer('0' & rl_wrusedw) > 1000 then  -- HACK: vedi il numero: was 500!
                rl_almfull <= '1';
            else
                rl_almfull <= '0';
            end if;
        end if;
    end process;
  
    -------------------------------------------------------------------------------------------
    -- TX FIFO (dati da LocalBus a CONET)
    I_TX : TL 
    port map (
        RESET   => fifo_clear,

        WCLOCK  => sys_clk,
        DATA    => tl_dti_i,
        WE      => tl_wr_i,
        FULL    => open,
        WRCNT   => tl_wrusedw,

        RCLOCK  => tclk,
        Q       => tl_dto,
        RE      => tl_rd_i,
        EMPTY   => tl_empty_i
    );

    -- Logica per trasformare la fifo da tipo Legacy (RDREQ=richiesta di lettura) a tipo
    -- ShowAhead (RDREQ=read acknowledge)
    tl_rd_i <= not tl_empty_i and (tl_empty or tl_rd);

    process(tclk, fifo_clear)  -- read clock
    begin
        if fifo_clear = '0' then
            tl_empty <= '1';
        elsif rising_edge(tclk) then
            if tl_rd_i = '1' and tl_rd = '0' then
                tl_empty <= '0';
            elsif tl_rd_i = '0' and tl_rd = '1' then
                tl_empty <= '1';
            end if;
        end if;
    end process;    
    
    -- FIFO Almost Full
    process(sys_clk, fifo_clear)  -- write clock
    begin
        if fifo_clear = '0' then
            tl_almfull <= '0';
        elsif rising_edge(sys_clk) then
            if conv_integer('0' & tl_wrusedw) > 1000 then  -- HACK: vedi il numero: was 500!
                tl_almfull <= '1';
            else
                tl_almfull <= '0';
            end if;
        end if;
    end process;
    
    tl_full <= tl_almfull;
    
    
    -- ##################################################################################
    -- ##################################################################################
    --                        dominio di sys_clk
    -- ##################################################################################
    -- ##################################################################################
    -- **********************************************************************************
    -- Packet Ready in Ricezione (per CLINT)
    -- **********************************************************************************
    -- HACK: DA VEDERE
    -- SCL_PCKRDY segnala che c'è almeno un pacchetto completo pronto per
    -- essere letto in SCLIF. A causa della pipeline interna della FIFO, devo ritardare
    -- di qualche ciclo di clock il segnale SCL_PCKRDY.
    -- Per la DRM posso avere anche più di 1 pacchetto in coda (infatti il comando Write_Reg
    -- non prevede nessuna risposta, quindi potrebbe essere seguito subito da un altro comando
    -- prima che la Write Reg sia stata eseguita dalla DRM). E' quindi necessario contare i
    -- pacchetti arrivati (uso PCK_PEND che si incrementa quando ho ricevuto un pacchetto e si
    -- decrementa quando ho letto l'utlimo dato)
    -- Nota: il segnale ENDPCK che viene dalla FSM2 segnala che e' stato ricevuto un pacchetto;
    -- tale segnale, poiche' dura 1 ciclo di RCLK, viene usato come Set Asincrono di ENDPCK_S;

    process (sys_clk, linkres_i_n)
    begin
        if linkres_i_n = '0' then
            prcnt   <= "000";
            inc_pck <= '0';
        elsif rising_edge(sys_clk) then            
            if endpck_s = '1' then
                prcnt <= "110";
            elsif prcnt /= "000" then
                prcnt <= prcnt - 1;
            end if;
            if prcnt = "001" then
                inc_pck <= '1';
            else
                inc_pck <= '0';
            end if;
        end if;
    end process;

    process (sys_clk, linkres_i_n, endpck)
    begin
        if linkres_i_n = '0' then
            endpck_s <= '0';
        elsif endpck = '1' then
            endpck_s <= '1';
        elsif rising_edge(sys_clk) then            
            if prcnt /= "000" then
                endpck_s <= '0';
            end if;
        end if;
    end process;

    process (sys_clk, linkres_i_n)--, LOCRES) -- HACK
    begin
        if linkres_i_n = '0' then --or LOCRES = '0' then
            pck_pend   <= (others => '0');
            scl_pckrdy <= '0';
        elsif rising_edge(sys_clk) then            
            if inc_pck = '1' and not (rl_rd = '1' and rl_dto(16) = '1') then
                pck_pend <= pck_pend + 1;
            elsif inc_pck = '0' and (rl_rd = '1' and rl_dto(16) = '1') then
                pck_pend <= pck_pend - 1;
            end if;
            if pck_pend /= "0000" then
                scl_pckrdy <= '1';
            else
                scl_pckrdy <= '0';
            end if;
        end if;
    end process;

 
    -- **********************************************************************************
    -- gestione pacchetti CONET da 256 word e formattazione dati nella TL fifo
    -- (pacchetti in trasmissione)
    -- **********************************************************************************
    process(sys_clk, linkres_i_n) 
    begin
    if linkres_i_n = '0' then
        pckw    <= '0';  -- segnala che è stato scritto un pacchetto in TL
        pckw_d  <= '0';
        tl_wr_i <= '0';
        tl_dti_i<= (others => '0');
        wcnt    <= (others => '0');
    elsif rising_edge(sys_clk) then            
        pckw    <= '0';
        tl_wr_i <= '0';
        if pckw_d = '1' then
            pckw   <= '1';
            pckw_d <= '0';
        end if;        
        if tl_wr = '1' then
            tl_wr_i <= '1';
            if tl_dti(16) = '1' then  -- fine pacchetto
                tl_dti_i <= "11" & tl_dti(15 downto 0);
                wcnt     <= (others => '0');
                -- se c'e' gia' un pckw attivo (max_pck_size raggiunto al ciclo precedente)
                -- allora setto pckw_d e do il vero pckw al ciclo dopo (per non avere mai
                -- due pckw attaccati)
                if pckw = '1' then
                    pckw_d <= '1';
                else
                    pckw   <= '1';
                end if;
            elsif conv_integer(wcnt) = max_pck_size-1 then  -- raggiunto il sub-packet size
                wcnt     <= (others => '0');
                tl_dti_i <= "01" & tl_dti(15 downto 0);
                pckw     <= '1';
            else
                wcnt     <= wcnt + 1;  -- conto le parole scritte
                tl_dti_i <= "00" & tl_dti(15 downto 0);
            end if;
        end if;
    end if;
    end process;
    
    -- **********************************************************************************
    -- LED_OPT con monostabile
    -- **********************************************************************************
    process(sys_clk, rl_wr, tl_rd)
        variable tmonos : std_logic;
    begin
        if rl_wr = '1' or tl_rd = '1' then
            led_opt <= '1';
            tmonos  := '1';
        elsif rising_edge(sys_clk) then
            if tick = '1' then
                if tmonos = '1' then
                    tmonos  := '0';
                else
                    led_opt <= '0';
                end if;
            end if;
        end if;
    end process;

    -- ##################################################################################
    -- ##################################################################################
    --                        Trasmissione (dominio di TCLK)
    -- ##################################################################################
    -- ##################################################################################
    -- RESET DELLA LOGICA DI TRASMISSIONE
    tx_res  <= '1' when tx_reset_n = '0' or linkres_i_n = '0' else '0';
    
    -- **********************************************************************************
    -- Contatore dei pacchetti pronti per essere inviati
    -- **********************************************************************************
    -- PCKW segnala che e' stato scritto un pacchetto completo nella FIFO TL; siccome la
    -- FIFO ha una pipeline interna di alcuni sys_clk (credo 6), devo generare il segnale
    -- INC_PCNT con lo stesso ritardo (altrimenti inizio a leggere i dati quando non sono
    -- ancora tutti pronti all'uscita). Quindi uso una pipeline di 6 anche per INC.
    -- INC_PCNT e' ottenuto dalla combinazione di INC4 e INC5 in modo da farlo durare
    -- un solo ciclo di sys_clk
    process (tclk, tx_res)
    begin
        if tx_res = '1' then
            inc      <= (others => '0');
            inc_pcnt <= '0';
        elsif rising_edge(tclk) then
            inc      <= inc(4 downto 0) & pckw;
            inc_pcnt <= inc(4) and not inc(5);
        end if;
    end process;

    -- Il contatore viene incrementato quando arriva il segnale PCKW (pacchetto scritto)
    -- e decrementato quando si setta PCKS (pacchetto inviato)
    process (tclk, tx_res)
    begin
        if tx_res = '1' then
            pcnt  <= (others => '0');
        elsif rising_edge(tclk) then
            if inc_pcnt ='1' and dec_pcnt ='0' then
                pcnt <= pcnt+1;
            elsif dec_pcnt = '1' and inc_pcnt = '0' then
                pcnt <= pcnt-1;
            end if;
        end if;
    end process;

    -- Flag di Packet Ready
    process (tclk, tx_res)
    begin
        if tx_res = '1' then
            pck_rdy  <= '0';
        elsif rising_edge(tclk) then
            if conv_integer(pcnt) /= 0 and tl_empty = '0' then  -- HACK: da verificare
                pck_rdy <= '1';
            else
                pck_rdy <= '0';
            end if;
        end if;
    end process;

    -- **********************************************************************************
    -- Gestione del Token
    -- **********************************************************************************
    -- Il TOKEN in ingresso viene rilevato dalla FSM di RX che genera un impulso di durata 1 RCLK;
    -- per avere la certezza che il token sia sentito correttamente dalla FSM di TX (che va con TCLK)
    -- si usa un flip flop SR e poi si risoncronizza il segnale con un paio di flip flop per evitare
    -- la metastabilita'.
    
    -- flip flop SR
    process (token, tok(0), tx_res)
    begin
        if tx_res = '1' or tok(0) = '1' then
            toksr <= '0';
        elsif token = '1' then
            toksr <='1';
        end if;
    end process;
    
    process (tclk, tx_res)
    begin
        if tx_res = '1' then
            tok     <= (others => '0');
            tokent  <= '0';
        elsif rising_edge(tclk) then
            tok     <= tok(tok'high-1 downto 0) & toksr;
            tokent  <= tok(tok'high);
        end if;
    end process;   

    -- **********************************************************************************
    -- Interrupt
    -- **********************************************************************************
    -- IRQSREQ segnala che deve essere inviato un interrupt sul CONET; si attiva quando IRQ cambia di stato
    -- quindi manda l'informazione sia quando si attiva che quando si disattiva
    process(tclk, tx_res)
    begin
        if tx_res = '1' then
            irq1 <= '0';
            irq2 <= '0';
            irqsreq <= '0';
        elsif rising_edge(tclk) then
            irq1 <= irq_tclk;
            irq2 <= irq1;
            if irq1 /= irq2 then
                irqsreq <= '1';
            elsif irqsend = '1' then
                irqsreq <= '0';
            end if;
        end if;
    end process;  
    
    -- **********************************************************************************
    -- fsm_tx
    -- **********************************************************************************       
    F_fsm_tx: process (tclk, tx_res)
    begin
        if tx_res = '1' then
        
            cnt_tx     <= (others => '0');

            tl_rd      <= '0';
            endspt     <= '0';
            eot        <= '0';
            dec_pcnt   <= '0';
            irqsend    <= '0';
            irqtx      <= '0';
            temp       <= (others => '0');
            daddr      <= (others => '0');  -- Per la DRM esiste un solo conet_slave (=0)
            tx_data    <= L_COMMA;    
            tx_charisk <= "1";
            fsm_tx     <= STX_IDLE;
        
        elsif rising_edge(tclk) then
                
            case fsm_tx is

            -----------------------------        
            when STX_COMMA    =>          

                tx_data     <= L_COMMA;
                tx_charisk  <= "1";

                if (cnt_tx = X"FFFFFF") then
                    fsm_tx <= STX_IDLE;
                    cnt_tx <= (others => '0');
                else
                    cnt_tx <= cnt_tx + 1;
                end if;
            
            -----------------------------        
            when STX_IDLE    =>          

                tx_data       <= L_NULL;
                tx_charisk    <= "1";
                dec_pcnt      <= '0';
                tl_rd         <= '0';
                irqtx         <= '0';
                irqsend       <= '0';
                
                if tokent = '1' then
                  if pck_rdy = '1' then -- spedisco un pacchetto mio
                    temp    <= "0000" & daddr & "11111111";
                    fsm_tx  <= STX_START;
                  elsif irqsreq = '1' then    -- spedisco irq stat mio
                    temp    <= "1000" & daddr & '0' & "111111" & not irq1; -- uso solo irq1 HACK: attenzione al livello di irq1
                    irqsend <= '1';
                    fsm_tx  <= STX_IRQST;
                  else
                    tx_data    <= L_TOKEN;       -- non ho dati => propago il token
                    tx_charisk <= "1";
                  end if;
                end if;
    
            -----------------------------        
            when STX_IRQST   =>  
                tx_data      <= L_VINT;
                tx_charisk   <= "1";
                irqtx        <= '1';
                fsm_tx       <= STX_BYTEL;
    
            -----------------------------        
            when STX_START   =>  
                tx_data      <= L_START;
                tx_charisk   <= "1";
                tl_rd        <= '0';
                fsm_tx       <= STX_BYTEL;
    
            -----------------------------        
            when STX_BYTEL   =>  
                tx_data      <= temp(7 downto 0);
                tx_charisk   <= "0";                
                tl_rd        <= '0';
                fsm_tx       <= STX_BYTEH;
                    
            -----------------------------        
            when STX_BYTEH   =>  
                tx_data      <= temp(15 downto 8);
                tx_charisk   <= "0";                
                if irqtx = '1' then
                    fsm_tx <=  STX_IDLE;
                elsif endspt = '1' then
                    dec_pcnt <= '1';
                    fsm_tx   <= STX_STOP;
                else
                    temp     <= tl_dto(15 downto 0); -- prendo il dato alla fine del Read
                    endspt   <= tl_dto(16);
                    eot      <= tl_dto(17);
                    tl_rd    <= '1';
                    fsm_tx   <= STX_BYTEL;
                end if;
    
            -----------------------------        
            when STX_STOP    =>  
                if eot = '1' then
                    tx_data  <= L_EOT;    -- end of transaction                
                    tx_charisk <= "1";                
                else
                    tx_data  <= L_STOP;   -- Fine subpacket
                    tx_charisk <= "1";                
                end if;
                endspt   <= '0';
                eot      <= '0';
                dec_pcnt <= '0';
                if irqsreq = '1' then    -- spedisco irq mio
                    temp    <= "1000" & daddr & '0' & "111111" & not irq1;  -- uso solo irq1
                    irqsend <= '1';
                    fsm_tx  <= STX_IRQST;
                else
                    fsm_tx  <= STX_IDLE;
                end if;
            
            end case;        
        end if;
    end process;   
    
    
    -- ##################################################################################
    -- ##################################################################################
    --                              Ricezione (dominio di RCLK)
    -- ##################################################################################
    -- ##################################################################################
    -- RESET DELLA LOGICA DI RICEZIONE
    rx_res   <= '1' when rx_reset_n = '0' else '0';
    
	rx_comma <= rx_commadetect;
	
    -- **********************************************************************************
    -- fsm_rx
    -- **********************************************************************************
    F_fsm_rx: process (rclk, rx_res)
    begin
        if rx_res = '1' then
    
            rx_commadetect  <= '0';
            rx_start        <= '0';
            
            rl_dti   <= (others => '0');
            rl_wr    <= '0';
            bl       <= (others => '0');
            bh       <= (others => '0');
            word_rdy <= '0';
            rx_header<= '0';
            endpck   <= '0';            
            token    <= '0';
            irqrx    <= '0';
            rx_faili <= '0';
            fsm_rx   <= SRX_IDLE;
            
        elsif rising_edge(rclk) then

            if rx_data = L_COMMA and rx_charisk = "1" then   -- ricevuto un  COMMA
                rx_commadetect   <= '1';
            else
                rx_commadetect   <= '0';
            end if;

            case fsm_rx is
            
            -----------------------------        
            when SRX_IDLE    => 
                rl_wr    <= '0';
                token    <= '0';
                word_rdy <= '0';
                irqrx    <= '0';
                rx_header<= '1';
                endpck   <= '0';
                
                if rx_data = L_START    and rx_charisk =  "1" then   -- ricevuto uno START
                    fsm_rx    <= SRX_BYTEL;                             -- inizio la ricezione
                    rx_start  <= '1';
                    rx_commadetect  <= '0';
                elsif rx_data = L_VINT  and rx_charisk =  "1" then   -- arriva un irq stat
                    irqrx     <= '1';
                    fsm_rx    <= SRX_BYTEL;
                elsif rx_data = L_TOKEN and rx_charisk =  "1" then   -- ricevuto il TOKEN; lo segnalo
                    token     <= '1';
                end if;
        
            -----------------------------        
            when SRX_BYTEL   => 
                bl <= rx_data;
                
                if word_rdy = '1' then    -- word pronta -> la scrivo nella fifo
                    if rx_header = '0' then  -- non scrivo la header
                        rl_dti(15 downto 0) <= bh & bl;
                        rl_wr <= '1';
                    else
                        rx_header <= '0';                    
                    end if;
                end if;
                
                if bsync = '1' then       -- Se arriva un COMMA => mi blocco
                    fsm_rx <= SRX_FAIL;               
                elsif irqrx = '0' then
                    if rx_data = L_STOP   and rx_charisk =  "1" then  -- fine sub-packet
                        rl_dti(16)  <= '1';
                        endpck      <= '1';                        
                        fsm_rx      <= SRX_WLAST;
                    elsif rx_data = L_EOT and rx_charisk = "1" then   -- fine pacchetto
                        rl_dti(16)  <= '1';
                        endpck      <= '1';                        
                        fsm_rx      <= SRX_WLAST;
                    else
                        rl_dti(16)  <= '0';
                        fsm_rx      <= SRX_BYTEH;
                    end if;
                else   -- IRQRX = '1'
                    if word_rdy = '1' then
                        fsm_rx <= SRX_WLAST;
                    else
                        fsm_rx <= SRX_BYTEH;
                    end if;
                end if;
        
            -----------------------------        
            when SRX_BYTEH   => 
                bh <= rx_data;
            
                rl_wr    <= '0';
                word_rdy <= '1';
                fsm_rx   <= SRX_BYTEL;
                if bsync = '1' then      -- se arriva un comma => mi blocco
                    fsm_rx <= SRX_FAIL;
                end if;
        
            -----------------------------        
            when SRX_WLAST   => -- devo prendere in considerazione il caso che qui arrivi un IRQ stat (L_VINT)
                rl_wr <= '0';

                if rx_data = L_VINT  and rx_charisk = "1" then   -- arriva un IRQ stat 
                    irqrx   <= '1';                               
                    token   <= '0';
                    word_rdy<= '0';
                    fsm_rx  <= SRX_BYTEL;
                else        
                    fsm_rx  <= SRX_IDLE;
                end if;														
                if bsync = '1' then      -- se arriva un comma => mi blocco
                    fsm_rx <= SRX_FAIL;
                end if;
                            
            -----------------------------        
            when SRX_FAIL    => 
                rl_wr     <= '0';
                rx_faili  <= '1';        -- mi blocco qui fino a quando non arriva un linkres
                    
            end case;
        end if;
    end process;   

    -- **********************************************************************************
    -- linkres_i_n:
    F_fsm_res: process (rclk, rx_reset_n)
        variable cnt : std_logic_vector(21 downto 0);
    begin
        if rx_reset_n = '0' then
            fsm_res     <= SRES_RES;
            linkres_i_n <= '0';
            rescnt      <= (others => '0');
            
        elsif rising_edge(rclk) then
        
            case fsm_res is
            
                when SRES_RES   =>
                    rescnt <= (others => '0');
                    if rx_commadetect = '1' then
                        fsm_res  <= SRES_BSYNC;
                    elsif rx_syncstatus = '1' then
                        rescnt <= rescnt + 1;
                        if rescnt = "111111" then
                            fsm_res  <= SRES_GO;
                        end if;
                    end if;
            
                when SRES_GO  =>
                    rescnt       <= (others => '0');
                    linkres_i_n  <= '1';
                    if rx_commadetect = '1' then
                        fsm_res  <= SRES_BSYNC;
                    end if;
            
                when SRES_BSYNC =>
                    linkres_i_n  <= '0';
                    if rx_commadetect = '1' then
                        if rescnt /= "111111" then
                            rescnt <= rescnt + 1;
                        end if;
                    else
                        if rescnt = "111111" then
                            rescnt  <= (others => '0');
                            fsm_res <= SRES_RES;
                        end if;
                        rescnt <= (others => '0');
                    end if;
                            
            end case;
        end if;
    end process;
    
    
    bsync     <= '0';          -- HACK: da fare
    linkres_n <= linkres_i_n;  -- HACK: da capire
    
    -------------------------------------------
    -- Debugging section
    -------------------------------------------
    gpio <= (others => 'Z');
    
    gpio(0) <= sys_clk;
    gpio(1) <= rl_wr;
    gpio(2) <= tl_rd;
    
end RTL;

