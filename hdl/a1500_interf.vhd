--!------------------------------------------------------------------------
--! @author       Annalisa Mati  (a.mati@caen.it)               
--! Contact       support.frontend@caen.it
--! @file         A1500_interf.vhd
--!------------------------------------------------------------------------
--! @brief        Interface with A1500 (PXL)
--!------------------------------------------------------------------------               
--! $Id: $ 
--!------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.DRM2pkg.all;

entity A1500_INTERF is
   port(
      clk          : in     std_logic;                       -- Clock
      reset        : in     std_logic;                       -- Reset
      a1500_reset  : in     std_logic;

      -- ************************************************************************************
      -- A1500
      rmt_reset    : in     std_logic;                       -- reset dalla a1500 verso la drm
      pxl_reset    : out    std_logic;                       -- reset per la a1500
      pxl_d        : inout  std_logic_vector (15 downto 0);  -- data
      pxl_a        : in     std_logic_vector (7 downto 0);   -- address
      pxl_wr       : in     std_logic;                       -- write
      pxl_rd       : in     std_logic;                       -- read
      pxl_cs       : in     std_logic;                       -- chip select
      pxl_irq      : out    std_logic;                       -- interrupt request
      pxl_io       : inout  std_logic;   -- spare i/os

   	  pxl_off	   : out	std_logic;   -- out: controllo da registro(?)->spegnere la A1500

      -- ************************************************************************************
      -- Input FIFO
      pxlif_dto    : buffer std_logic_vector (16 downto 0);
      pxlif_rd     : in     std_logic;
      pxlif_empty  : buffer std_logic;

      -- Output FIFO
      pxlof_dti    : in     std_logic_vector (16 downto 0);
      pxlof_wr     : in     std_logic;
      pxlof_full   : out    std_logic;  -- in realta' e' un almost full (full-8)
      
      pxl_pckrdy   : out    std_logic;                     -- packet ready (in ingresso)
      pxl_pckw     : in     std_logic;                     -- packet written (in uscita)

      regs         : in     REGS_RECORD;                     -- per ora non usato
	  
      -- ************************************************************************************
      -- Spare
      gpio         : out   std_logic_vector (31 downto 0)
   );

end A1500_INTERF ;

architecture RTL of A1500_INTERF is

    -----------------------------------------------------------------------------------------   
    -- Signal Declarations
    -----------------------------------------------------------------------------------------   
    
    -- Memory Mapping: indirizzi allineati al byte
    constant A_DATA       : std_logic_vector(7 downto 0) := "00000000";  -- Dati
    constant A_CTRL       : std_logic_vector(7 downto 0) := "00000100";  -- Control

    -- Segnali per le FIFO
    signal fifo_clear  : std_logic;

    -------------------------------------   
    -- RX local Pipe     
    signal pxlif_dti      : std_logic_vector(16 downto 0);
    signal pxlif_wr       : std_logic;
    signal pxlif_full     : std_logic;
    
    signal pxlif_rd_i     : std_logic;  -- segnali per trasformare la fifo da tipo Legacy a ShowAhead 
    signal pxlif_empty_i  : std_logic; 

    signal pxlif_wrusedw  : std_logic_vector(10 downto 0);
    -- signal pxlif_almfull  : std_logic;
    
    -------------------------------------   
    -- TX local Pipe         
    signal pxlof_dto      : std_logic_vector(16 downto 0);
    signal pxlof_rd       : std_logic;
    signal pxlof_empty    : std_logic;
    signal pxlof_rdusedw  : std_logic_vector(10 downto 0);

    signal pxlof_myusedw  : std_logic_vector(10 downto 0);

    signal pxlof_rd_i     : std_logic;  -- segnali per trasformare la fifo da tipo Legacy a ShowAhead 
    signal pxlof_empty_i  : std_logic; 

    signal pxlof_wrusedw  : std_logic_vector(10 downto 0);
    signal pxlof_almfull  : std_logic;
        
    signal pck_pend       : std_logic_vector(3 downto 0);    -- Contatore di pacchetti pronti in attesa
    signal inc_pck        : std_logic;                       -- Incrementa pck_pend
    
    signal wr_s           : std_logic;                       -- Write sincrono (dura 1 ciclo di clock)
    signal rd_s           : std_logic;                       -- Read sincrono
    signal addr           : std_logic_vector(7 downto 0);    -- Indirizzi sincroni
    signal pxl_di         : std_logic_vector (15 downto 0);  -- Dati interni
    signal pxl_d_oe       : std_logic;                       -- OE dei dati
                          
    signal ep_flag        : std_logic;                       -- End Packet Flag (segnala la fine dei dati in uscita)
    signal wcnt           : std_logic_vector(15 downto 0);   -- Word counter del pacchetto in ingresso
    signal status         : std_logic_vector(15 downto 0);   -- status Register
    signal status_l       : std_logic_vector( 7 downto 0);   -- status Register (parte bassa)

    -----------------------------------------------------------------------------------------   
    -- Component Declarations
    -----------------------------------------------------------------------------------------  
    -- FIFO LEGACY, SINGLE CLOCK, WIDTH 17, DEPTH 1024, RESET active low
    component PXLIF
    port
    (
        RESET  : IN  STD_LOGIC;
        CLK    : IN  STD_LOGIC;

        DATA   : IN  STD_LOGIC_VECTOR(16 downto 0);
        WE     : IN  STD_LOGIC;
        FULL   : OUT STD_LOGIC;  
        WRCNT  : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);

        Q      : OUT STD_LOGIC_VECTOR(16 downto 0);
        RE     : IN  STD_LOGIC;
        EMPTY  : OUT STD_LOGIC
    );
    end component;  -- 1024
    
    -- FIFO LEGACY, SINGLE CLOCK, WIDTH 17, DEPTH 1024, RESET active low
    component PXLOF
    port
    (
        RESET  : IN  STD_LOGIC;
        CLK    : IN  STD_LOGIC;

        DATA   : IN  STD_LOGIC_VECTOR(16 downto 0);
        WE     : IN  STD_LOGIC;
        FULL   : OUT STD_LOGIC;  
        WRCNT  : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);

        Q      : OUT STD_LOGIC_VECTOR(16 downto 0);
        RE     : IN  STD_LOGIC;
        EMPTY  : OUT STD_LOGIC;
        RDCNT  : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)        
    );
    end component;  -- 1024
    
     -----------------------------------------------------------------------------------------   
    -- FSMs Declarations
    -----------------------------------------------------------------------------------------   
    type   TSTATE1 is (S1_IDLE, S1_WR, S1_RD);
    signal fsm_a1500 : TSTATE1;
   
begin

	pxl_off	    <= regs.pwr_ctrl(PC_A1500_OFF);       -- out: quando è 1 chiede lo spegnimento della A1500

    pxl_irq     <= '1' when regs.pwr_ctrl(PC_A1500_OFF) = '0' else 'Z';   -- è sempre stata tenuta fissa a '1'

    -------------------------------------------------------------------------------------------    
    -- RESET & CLEAR:
    fifo_clear  <= reset;
        
    pxl_reset   <= a1500_reset when regs.pwr_ctrl(PC_A1500_OFF) = '0' else 'Z';  

    -- **********************************************************************************
    -- FIFO
    -- **********************************************************************************
    -------------------------------------------------------------------------------------------
    -- RX FIFO (dati da A1500 a LocalBus)    
    I_PXLIF : PXLIF
    PORT MAP(
        RESET    => fifo_clear,
        CLK      => clk,

        DATA     => pxlif_dti,
        WE       => pxlif_wr,
        FULL     => pxlif_full,
        WRCNT    => pxlif_wrusedw,

        Q        => pxlif_dto,
        RE       => pxlif_rd_i,
        EMPTY    => pxlif_empty_i
        );

    -- Logica per trasformare la fifo da tipo Legacy (RDREQ=richiesta di lettura) a tipo
    -- ShowAhead (RDREQ=read acknowledge)
    pxlif_rd_i <= not pxlif_empty_i and (pxlif_empty or pxlif_rd);

    process(clk, fifo_clear)  -- read clock
    begin
        if fifo_clear = '1' then
            pxlif_empty <= '1';
        elsif rising_edge(clk) then
            if pxlif_rd_i = '1' and pxlif_rd = '0' then
                pxlif_empty <= '0';
            elsif pxlif_rd_i = '0' and pxlif_rd = '1' then
                pxlif_empty <= '1';
            end if;
        end if;
    end process;    
    
    -- FIFO Almost Full
    -- process(clk, fifo_clear)  -- write clock
    -- begin
        -- if fifo_clear = '0' then
            -- pxlif_almfull <= '0';
        -- elsif rising_edge(clk) then
            -- if conv_integer('0' & pxlif_wrusedw) > 500 then  -- HACK: vedi il numero
                -- pxlif_almfull <= '1';
            -- else
                -- pxlif_almfull <= '0';
            -- end if;
        -- end if;
    -- end process;
                
    -------------------------------------------------------------------------------------------
    -- TX FIFO (dati da LocalBus a A1500)
    I_PXLOF : PXLOF
    PORT MAP(
        RESET    => fifo_clear,
        CLK      => clk,

        DATA     => pxlof_dti,
        WE       => pxlof_wr,
        FULL     => open,
        WRCNT    => pxlof_wrusedw,

        Q        => pxlof_dto,
        RE       => pxlof_rd_i,
        EMPTY    => pxlof_empty_i,
        RDCNT    => pxlof_rdusedw
        );

    -- Logica per trasformare la fifo da tipo Legacy (RDREQ=richiesta di lettura) a tipo
    -- ShowAhead (RDREQ=read acknowledge)
    pxlof_rd_i <= not pxlof_empty_i and (pxlof_empty or pxlof_rd);

    pxlof_myusedw <= (pxlof_rdusedw  + 1) when pxlof_empty = '0' else (others => '0');
    
    process(clk, fifo_clear)  -- read clock
    begin
        if fifo_clear = '1' then
            pxlof_empty   <= '1';
        elsif rising_edge(clk) then
            if pxlof_rd_i = '1' and pxlof_rd = '0' then
                pxlof_empty   <= '0';
            elsif pxlof_rd_i = '0' and pxlof_rd = '1' then
                pxlof_empty   <= '1';
            end if;
        end if;
    end process;    
    
    -- FIFO Almost Full
    process(clk, fifo_clear)  -- write clock
    begin
        if fifo_clear = '1' then
            pxlof_almfull <= '0';
        elsif rising_edge(clk) then
            if conv_integer('0' & pxlof_wrusedw) > 500 then  -- HACK: vedi il numero
                pxlof_almfull <= '1';
            else
                pxlof_almfull <= '0';
            end if;
        end if;
    end process;

    pxlof_full <= pxlof_almfull;


    -- Gestione dei segnali asincroni provenienti dalla A1500
    P_sync : process(reset, clk)
    begin
        if reset = '1' then
            wr_s     <= '1';
            rd_s     <= '1';
            addr     <= (others => '0');
        elsif rising_edge(clk) then            
            wr_s     <= pxl_cs or pxl_wr;
            rd_s     <= pxl_cs or pxl_rd;
            addr     <= pxl_a(7 downto 0);
        end if;
    end process;
    

    status <= ep_flag & "0000" & pxlof_myusedw;

    pxl_d  <= pxl_di when (pxl_d_oe = '1' and regs.pwr_ctrl(PC_A1500_OFF) = '0') else (others => 'Z');

    -- FSM di Lettura e Scrittura da A1500
    F_fsm_a1500 : process(reset, clk)
    begin
        if reset = '1' then

            pxlif_wr   <= '0';
            pxlof_rd   <= '0';
            pxlif_dti  <= (others => '0');
            pxl_di     <= (others => '0');
            pxl_d_oe   <= '0';
            inc_pck    <= '0';
            wcnt       <= (others => '0');
            status_l   <= (others => '0');
            
            fsm_a1500  <= S1_IDLE;

        elsif rising_edge(clk) then
    
            case fsm_a1500 is
      
            -----------------------------        
            when S1_IDLE   =>

            -- Ciclo di Scrittura
            if wr_s = '0' then
                if addr(7 downto 1) = A_CTRL(7 downto 1) then
                    if addr(0) = '0' then                      -- byte meno significativo
                        wcnt( 7 downto 0) <= pxl_d(7 downto 0);
                    else                                       -- byte più significativo
                        wcnt(15 downto 8) <= pxl_d(7 downto 0);
                    end if;
                elsif addr(7 downto 1) = A_DATA(7 downto 1) then
                    if addr(0) = '0' then
                        pxlif_dti(7 downto 0) <= pxl_d(7 downto 0);   -- parte bassa: scrivo il dato nella FIFO, a 16 bit
                        if wcnt = "0000000000000001" then
                            pxlif_dti(16) <= '1';
                            inc_pck       <= '1';
                        else
                            pxlif_dti(16) <= '0';
                        end if;
                        pxlif_wr  <= '1';
                        wcnt      <= wcnt - 1;
                    else
                        pxlif_dti(15 downto 8) <= pxl_d(7 downto 0);  -- parte alta: strobe del dato
                    end if;
                end if;
                fsm_a1500 <= S1_WR;

            -- Ciclo di Lettura
            elsif rd_s = '0' then
                pxl_d_oe   <= '1';
                if addr(7 downto 1) = A_CTRL(7 downto 1) then
                    if addr(0) = '0' then
                        pxl_di(7 downto 0) <= status_l;
                    else
                        pxl_di(7 downto 0) <= status(15 downto 8);
                        status_l <= status(7 downto 0);  -- per non leggere le 2 parti in momenti diversi
                    end if;
                elsif addr(7 downto 1) = A_DATA(7 downto 1) then
                    if pxlof_empty = '0' then
                        if addr(0) = '0' then                             -- parte bassa
                            pxl_di(7 downto 0) <= pxlof_dto(7 downto 0);
                            pxlof_rd <= '1';
                        else                                              -- parte alta
                            pxl_di(7 downto 0) <= pxlof_dto(15 downto 8);
                        end if;
                    else
                        pxl_di(7 downto 0) <= (others => '1');
                    end if;
                end if;
                fsm_a1500 <= S1_RD;
                
            end if;

            -----------------------------        
            when S1_WR   =>      
                pxlif_wr  <= '0';
                inc_pck   <= '0';
                if wr_s = '1' then
                    fsm_a1500 <= S1_IDLE;
                end if;

            -----------------------------        
            when S1_RD   =>          
                pxlof_rd  <= '0';
                if rd_s = '1' then
                    pxl_d_oe  <= '0';
                    fsm_a1500 <= S1_IDLE;
                end if;

            end case;

        end if;
    end process;


    -- EP_FLAG si setta quando l'ultima parola di un pacchetto in uscita e' stata scritta in PXLOF
    -- e si resetta quando tale parola viene letta dalla A1500. Il Flag compare nel registro di
    -- controllo e serve alla A1500 a capire dove finisce il pacchetto di risposta.
    process(reset, clk)
    begin
        if reset = '1' then
            ep_flag <= '0';
        elsif clk'event and clk = '1' then
            if pxl_pckw = '1' then
                ep_flag <= '1';
            elsif pxlof_rd = '1' and pxlof_dto(16) = '1' then
                ep_flag <= '0';
            end if;
        end if;
    end process;


    -- **********************************************************************************
    -- Packet Ready
    -- **********************************************************************************
    -- pxl_pckrdy segnala che c'è almeno un pacchetto completo pronto per
    -- essere letto in PXLIF.
    -- Per la DRM posso avere anche più di 1 pacchetto in coda (infatti il comando Write_Reg
    -- non prevede nessuna risposta, quindi potrebbe essere seguito subito da un altro comando
    -- prima che la Write Reg sia stata eseguita dalla DRM). E' quindi necessario contare i
    -- pacchetti arrivati (uso pck_pend che si incrementa quando ho ricevuto un pacchetto e si
    -- decrementa quando ho letto l'ultimo dato)

    process (clk, reset)
    begin
        if reset = '1' then
            pck_pend   <= (others => '0');
            pxl_pckrdy <= '0';
        elsif clk'event and clk = '1' then
            if inc_pck = '1' and not (pxlif_rd = '1' and pxlif_dto(16) = '1') then
                pck_pend <= pck_pend + 1;
            elsif inc_pck = '0' and (pxlif_rd = '1' and pxlif_dto(16) = '1') then
                pck_pend <= pck_pend - 1;
            end if;
            if pck_pend /= "0000" then
                pxl_pckrdy <= '1';
            else
                pxl_pckrdy <= '0';
            end if;
        end if;
    end process;
    

    -------------------------------------------
    -- Debugging section
    -------------------------------------------
    -- Spare Interni
    gpio   <= (others => 'Z');

    -- Spare Esterni
    pxl_io <= 'Z';

end RTL;
