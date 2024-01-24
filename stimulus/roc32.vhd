-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA750
-- Author:          Annalisa Mati
-- Date:            21/06/13
-- --------------------------------------------------------------------------
-- Module:          ROC32
-- Description:     RTL module: Readout Controller
-- **************************************************************************

-- ##########################################################################
-- Revision History:
-- 30.05: Release rilasciata
-- 00.00: - tolto il registro SRAM EVENT (addr 0x100; era stato inserito per
--          debug)
--        - aggiunto il registro BNCID OFFSET (addr 0x2000) per
--          l'inizializzazione del BNC_ID
--        - eliminato STOP_ACQ perchè nel caso di FAULT la scheda viene spenta da uC
--        - inserita la gestione degli errori degli HPTCD e il timeout di attesa del TOKOUT:
--          nel caso di errore in una catena o se non ritorna il TOKEN, vengono disabilitate
--          entrambe le catene. Il ROC continua a servire i trigger facendo finti giri di TOKEN
--          per non disallineare gli eventi.
--          Quando ha risolto l'errore il uC comunica 3 parole di errore che verranno
--          introdotte nel flusso dei dati nel primo evento disponibile.
--        - cambiato l'LSB dell'offset (sottrazione trailing-leading-offset):
--          200ps anzichè 50ps
--        - aggiunto il registro TEST TOKEN TIMOUT
--        - corretto un baco: con EV_RES non resettavo il contatore degli eventi nelle
--          parole di formattazone di catena
-- 00.01  - aggiunta rilettura automatica dei sensori di temperatura
--          (inserita nelle header di catena)
--        - aggiunto il bit L (LUT SEU) nella HEADER globale
-- 00.02  - risolto un baco nella sincronizzazione dei segnali di errore per la FSMe
-- 00.04  - risolto un baco: al posto della HEADER di catena A talvolta veniva scritto
--          il TRAILER di catena B dell'evento precedente; il baco sembrava un problema di timing
--          su TEMPF e DT_TEMP nella FSM2 (non diagnosticato da Designer).
--          Risolto con una piccola modifica per fare un fitting diverso
--          (quando metto TEMPF = 0 assegno anche DT_TEMP = 0).
--          Modificati anche i segnali in ingresso alla FSM2 (WR_SRAM, DT_SRAM, END_EVNT):
--          nel caso REGS.STATUS(S_RAW_DATA) = 1 prendo i dati dal secondo livello di pipe perchè
--          sono risincronizzati con CLK (anzichè dal primo perchè sono sincroni con CLK_tdc)
-- 00.05  - spostata la selezione dell'offset per la sottrazione trailing-leading
--          dal livello 9 al livello 8 di pipe
--        - modificata la PLL per la scrittura nelle SRAM di primo livello:
--          CLK_sram non è più sfasato rispetto a CLK ma è a frequenza doppia
-- NUOVA RELEASE 2013:
-- eliminati livelli di PIPE da 6 a 10, per la sottrazione TRAILING-LEADING-OFFSET
-- eliminata la memoria di LEADING
-- cambiato il formato dei dati
-- ##########################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1390pkg.all;

ENTITY ROC32 IS
  port (
       CLK       : IN    std_logic; -- CLOCK
       PLL_LOCK  : OUT   std_logic;

       HWRES     : IN    std_logic;
       CLEAR_STAT: IN    std_logic; -- tiene in CLEAR il ROC
       GA        : IN    std_logic_vector (4 downto 0);

       -- Signals from/to P2
       L0        : IN    std_logic; -- level 0 trigger
       L1A       : IN    std_logic; -- level 1 trigger, accept
       L1R       : IN    std_logic; -- level 1 trigger, reject
       L2A       : IN    std_logic; -- level 2 trigger, accept
       L2R       : IN    std_logic; -- level 2 trigger, reject
       BNC_RES_E : IN    std_logic; -- arriva 2 cicli di clock prima del BNC_RES inviato su P2:
                                    -- fa uscire le catene dalla condizione di errore
       BNC_RES   : IN    std_logic; -- TDCs counters reset (to TDCs)
       TDC_RES   : IN    std_logic; -- TDCs master reset
       EV_RES    : IN    std_logic; -- TDCs event reset

       TRM_DRDY  : OUT   std_logic; -- TRM data ready = Event ready
       TRM_BUSY  : OUT   std_logic; -- TRM busy       = Mem Full

       -- Firs level SRAM signals
       -- Sram EVEN
       ADE       : OUT   std_logic_vector(15 downto 0); -- SRAM address
       DTE       : INOUT std_logic_vector(31 downto 0); -- SRAM data
       NWRSRAME  : OUT   std_logic; -- Write enable
       NOESRAME  : OUT   std_logic; -- Output enable
       -- Sram ODD
       ADO       : OUT   std_logic_vector(15 downto 0); -- SRAM address
       DTO       : INOUT std_logic_vector(31 downto 0); -- SRAM data
       NWRSRAMO  : OUT   std_logic; -- Write enable
       NOESRAMO  : OUT   std_logic; -- Output enable

       -- Second level FIFO signals
       FID       : OUT   std_logic_vector(31 downto 0); -- Data input
       FID_P     : OUT   std_logic; -- Parity bit (not used)
       NWEN      : OUT   std_logic; -- Write enable
       NLD       : OUT   std_logic; -- Load
       NPRSFIF   : OUT   std_logic; -- Partial reset
       NMRSFIF   : OUT   std_logic; -- Master reset
       PAF       : IN    std_logic;

       EVRDY     : OUT   std_logic; -- almeno un evento pronto nel MEB
       EVREAD    : IN    std_logic; -- segnala che è stato riletto un evento dal MEB

       DTEST_FIFO: OUT   std_logic; -- segnala che è stato scritto un dato di test nella FIFO

       -- Compensation SRAM signals
       RAMAD     : OUT   std_logic_vector(17 downto 0); -- LUT address
       RAMDT     : IN    std_logic_vector(13 downto 0); -- LUT data

       RAMAD_SPI : IN    std_logic_vector(17 downto 0); -- LUT address from SPI interf.
       RAMAD_VME : IN    std_logic_vector(17 downto 0); -- LUT address from VME interf.

       LOAD_RES  : IN    std_logic;

       -- TDC signals
       TDCTRG    : OUT   std_logic; -- TDCs trigger
       -- chain A
       CHAINA_EN244 : OUT   std_logic; -- TDCs chain A enable
       TDCDA     : IN    std_logic_vector (31 downto 0); -- TDC Data
       TDCDRYA   : IN    std_logic; -- TDCs data ready
       TDCGDA    : OUT   std_logic; -- TDCs get data
       TOKINA    : OUT   std_logic; -- TDCs Token input
       TOKOUTA   : IN    std_logic; -- TDCs Token output
       TOKOUTA_BP: IN    std_logic; -- TDCs Token output Bypass
       INT_ERRA  : IN    std_logic; -- Chain A error (from I2C)
       CHAINA_ERR: IN    std_logic; -- Chain A error (from uC)
       -- chain B
       CHAINB_EN244 : OUT   std_logic; -- TDCs chain B enable
       TDCDB     : IN    std_logic_vector (31 downto 0); -- TDC Data
       TDCDRYB   : IN    std_logic; -- TDCs data ready
       TDCGDB    : OUT   std_logic; -- TDCs get data
       TOKINB    : OUT   std_logic; -- TDCs Token input
       TOKOUTB   : IN    std_logic; -- TDCs Token output
       TOKOUTB_BP: IN    std_logic; -- TDCs Token output Bypass
       INT_ERRB  : IN    std_logic; -- Chain B error (from I2C)
       CHAINB_ERR: IN    std_logic; -- Chain B error (from uC)

       TDC_RES_ERR: OUT std_logic; -- TDC_RES che deve essere dato quando le catene escono dall'errore

       -- MICRO signals
       COM_SERS  : IN    std_logic; -- COM_SER sincronizzato (in RESET_MOD)
       MSERCLK   : IN    std_logic; -- serial communication with the MICRO,
       MTDIA     : IN    std_logic; -- (to know TDC progr.)

       RMIC      : OUT   std_logic; -- HS signals for VME accesses
       MROK      : IN    std_logic;
       WMIC      : OUT   std_logic;
       MWOK      : IN    std_logic;

       MTDCRESA  : OUT   std_logic; -- avverte il uC che c'è stato un timout per TOKOUTA
       MTDCRESB  : OUT   std_logic; -- avverte il uC che c'è stato un timout per TOKOUTB

       -- SPARE
       SP0       : INOUT std_logic;
       SP1       : INOUT std_logic;
       SP2       : INOUT std_logic;
       SP3       : INOUT std_logic;
       SP4       : INOUT std_logic;
       SP5       : INOUT std_logic;

       REGS      : INOUT VME_REG_RECORD;

       PULSE     : IN    reg_pulse;
       TICK      : IN    tick_pulses
       );

END ROC32 ;

ARCHITECTURE RTL OF ROC32 IS

-- HACK: togliere la memoria di leading

 signal pippolo    : std_logic; 

  -- ************************************************************************
  -- shift register per la memorizzazione dello stato dei TDC,
  -- comunicato dal MICRO
  signal MIC_REGS  : std_logic_vector(7 downto 0);
  signal MIC_REG1  : std_logic_vector(7 downto 0); -- il registro MIC_REGS è in triplice copia
  signal MIC_REG2  : std_logic_vector(7 downto 0);
  signal MIC_REG3  : std_logic_vector(7 downto 0);
  attribute syn_preserve : boolean;
  attribute syn_preserve of MIC_REG1, MIC_REG2, MIC_REG3 : signal is true;

  signal MSERCLKF1 : std_logic; -- primo FF di sincronizzazione di MSERCLK
  signal MSERCLKS  : std_logic; -- secondo FF di sincronizzazione di MSERCLK
  signal MTDIAF1   : std_logic; -- primo FF di sincronizzazione di MTDIA
  signal MTDIAS    : std_logic; -- secondo FF di sincronizzazione di MTDIA

  -- segnali per la gestione del TRIGGER e la rilettura dei TDC:
  -- i segnali da P2 sono cloccati 3 volte per ottenere segnali da inviare ai TDC
  -- che durano 1 ciclo di clock
  signal L1AS      : std_logic; -- level 1 trigger accept sincronizzato: 1 ciclo di clock
  signal L2AS      : std_logic; -- level 2 trigger accept sincronizzato: 1 ciclo di clock
  signal L2RS      : std_logic; -- level 2 trigger reject sincronizzato: 1 ciclo di clock

  signal L1AF1     : std_logic; -- level 1 trigger accept, primo FF di sincronizzazione
  signal L2AF1     : std_logic; -- level 2 trigger accept, primo FF di sincronizzazione
  signal L2RF1     : std_logic; -- level 2 trigger reject, primo FF di sincronizzazione

  signal L1AF2     : std_logic; -- level 1 trigger accept, secondo FF di sincronizzazione
  signal L2AF2     : std_logic; -- level 2 trigger accept, secondo FF di sincronizzazione
  signal L2RF2     : std_logic; -- level 2 trigger reject, secondo FF di sincronizzazione

  signal L1AF3     : std_logic; -- level 1 trigger accept, terzo FF di sincronizzazione
  signal L2AF3     : std_logic; -- level 2 trigger accept, terzo FF di sincronizzazione
  signal L2RF3     : std_logic; -- level 2 trigger reject, terzo FF di sincronizzazione

  signal TRIGGERS  : std_logic; -- Trigger sincronizzato
  signal TDCTRGi   : std_logic;
  signal GIROT     : std_logic; -- richiesta di un giro di token
  signal TRGCNT    : std_logic_vector(4 downto 0);  -- contatore dei trigger

  signal TDCDAS    : std_logic_vector(31 downto 0); -- TDCDA cloccati
  signal TDCDBS    : std_logic_vector(31 downto 0); -- TDCDB cloccati
  signal TOKOUTAS  : std_logic;                     -- TOKOUTA cloccato
  signal TOKOUTBS  : std_logic;                     -- TOKOUTB cloccato
  signal TDCDRYAS  : std_logic;                     -- TDCDRYA cloccato
  signal TDCDRYBS  : std_logic;                     -- TDCDRYB cloccato


  signal TOKOUT_FL : std_logic; -- flag del TOKOUT mentre la FSM1 fa attende il flush della memoria di leading

  signaL TOKINAi   : std_logic; -- TOKINA interno (dalla FSM)
  signaL TOKINBi   : std_logic; -- TOKINB interno (dalla FSM)
  signaL TDCGDAi   : std_logic; -- GET DATA interno (dalla FSM)
  signaL TDCGDBi   : std_logic; -- GET DATA interno (dalla FSM)

  signaL TDCGDA1   : std_logic; -- GET DATA ritardati di 1 ciclo di clock
  signaL TDCGDB1   : std_logic;

  -- segnali per il timeout dell'attesa di TOKOUT
  signal TOKENA_TIMOUT   : std_logic;
  signal TOKENTOA_RES    : std_logic;
  signal TOKENA_CNT      : std_logic_vector(1 downto 0);
  signal TOKENB_TIMOUT   : std_logic;
  signal TOKENTOB_RES    : std_logic;
  signal TOKENB_CNT      : std_logic_vector(1 downto 0);

  -- shift register che memorizza l'arrivo dei trigger di secondo livello:
  -- in L2TYPE il tipo di trigger (0=L2A, 1=L2R)
  constant L2DEPTH : integer := 16; -- posso avere in coda da processare al massimo 16 trigger di secondo livello
  signal L2TYPE    : std_logic_vector(L2DEPTH-1 downto 0);
  signal L2ARR     : std_logic_vector(3 downto 0);
  signal L2SERV    : std_logic_vector(3 downto 0);

  -- segnali per il Bunch ID
  signal BNC_ID     : std_logic_vector(11 downto 0);-- Contatore per il Bunch ID
  -- vettore di registri che memorizzano in BUNCH ID quando viene inviato un trigger ai TDC:
  -- posso avere in coda da processare al massimo 16 trigger
  type   VECT is array (0 to 15) of std_logic_vector (11 downto 0);
  signal BNCID_VECT : VECT;
  signal TRGARR     : std_logic_vector(3 downto 0);
  signal TRGSERV    : std_logic_vector(3 downto 0);

  -- PRIMO LIVELLO DI PIPE: DATI DAI TDC
  signal NWPIPE1   : std_logic;                    -- write
  signal PIPE1_DT  : std_logic_vector(31 downto 0);-- dato
  signal END_TDC1  : std_logic;                    -- sono terminati i dati da un TDC
  signal TDC       : std_logic_vector( 3 downto 0);
  signal FIRST_TDC : std_logic;

  signal END_CHAINA1: std_logic;                   -- sono terminati i dati dalla catena A
  signal END_CHAINB1: std_logic;                   -- sono terminati i dati dalla catena B

  signal END_EVNT1 : std_logic;                    -- impulso di fine evento

  signal RAMAD1    : std_logic_vector(17 downto 0);-- indirizzo della SRAM di compensazione, dalla FSM1 (=> RAMAD)

  signal EVNT_NUM  : std_logic_vector(11 downto 0); -- event number scritto nelle parole di formattazione di catena
  signal G_EVNT_NUM: std_logic_vector(11 downto 0); -- event number scritto nel global trailer (scritto datta FSM2)
  signal INC_EVNT_NUM : std_logic;

  signal START_GIRO   : std_logic;  -- è iniziato un giro di TOKEN

  constant RESERVED   : std_logic_vector(11 downto 0):= (others => '0');
  
  -- contatore per l'attesa della FSM1: dopo l'acquisizione dei dati da un TDC, la FSM1 attende che i dati
  -- siano arrivati al 6 livello di pipe per verificare se deve essere fatto un flush della LEAD_SRAM
  signal FCNT       : std_logic_vector(2 downto 0) := (others => '0');

  -- SECONDO-QUARTO LIVELLO DI PIPE: RILETTURA DELLA LUT
  signal NWPIPE2   : std_logic;                    -- write
  signal PIPE2_DT  : std_logic_vector(31 downto 0);-- dato
  signal END_EVNT2 : std_logic;                    -- impulso di fine evento

  signal NWPIPE3   : std_logic;                    -- write
  signal PIPE3_DT  : std_logic_vector(31 downto 0);-- dato
  signal END_EVNT3 : std_logic;                    -- impulso di fine evento

  signal NWPIPE4   : std_logic;                    -- write
  signal PIPE4_DT  : std_logic_vector(31 downto 0);-- dato
  signal END_EVNT4 : std_logic;                    -- impulso di fine evento

  signal RAMDT4    : std_logic_vector(13 downto 0);-- LUT data strobati

  -- QUINTO LIVELLO DI PIPE: COMPENSAZIONE
  signal NWPIPE5   : std_logic;                    -- write
  signal PIPE5_DT  : std_logic_vector(31 downto 0);-- dato
  signal END_EVNT5 : std_logic;                    -- impulso di fine evento
  signal L_LUT     : std_logic;                    -- errore di parità nella SRAM LUT (scritto nel Global TRAILER)

  -- SESTO-DECIMO LIVELLO DI PIPE: SOTTRAZIONE TRAILING-LEADING
  -- eliminati!
  signal FLUSH     : std_logic;                    


  -- SEGNALI PER L'ACCESSO ALLE SRAM EVEN E ODD e ALLA FIFO
  -- i dati da scrivere nelle SRAM vengono dal 10° livello di PIPE se è abilitata la sottrazione TRAILING-LEADING,
  -- altrimenti dal 5° livello di PIPE. Vengono dal 1° se sono abilitati i dati "formato Christiansen" (RAW DATA).
  signal WR_SRAM    : std_logic;
  signal DT_SRAM    : std_logic_vector(31 downto 0);
  signal END_EVNT   : std_logic;  -- indica che la FSM1 ha terminato un il giro di token su entrambe le catene

  signal TEMPF      : std_logic;  -- pipeline nel caso debba attendere a scrivere nella RAM perché la fase
                                  -- di scrittura è sbagliata
  signal DT_TEMP    : std_logic_vector(31 downto 0);

  signal ENDF       : std_logic;  -- Flag per memorizzare che è arrivato END_EVNT al ciclo di clock precedente

  constant RAM_PAGE : integer  := 12;

  signal WRPNT      : std_logic_vector(15 downto 0);           -- Puntatore di scrittura nelle RAM
  signal RDPNT      : std_logic_vector(15 downto 0);           -- Puntatore di lettura nelle RAM
  signal WPAGE      : std_logic_vector(15 downto RAM_PAGE);    -- Indirizzo di pagina in scrittura
  signal RPAGE      : std_logic_vector(15 downto RAM_PAGE);    -- Indirizzo di pagina in lettura
  signal WOFFSET    : std_logic_vector((RAM_PAGE) downto 0);   -- Indirizzo di parola nella pagina, in scrittura
  signal ROFFSET    : std_logic_vector((RAM_PAGE) downto 0);   -- Indirizzo di parola nella pagina, in lettura
  -- le SRAM hanno 16 bit di indirizzo: 4 sono l'indirizzo di pagina (16 pagine, metà pagina è nella memoria EVEN
  -- e metà nella ODD), 12 indirizzano la parola all'interno della pagina.

  signal PHASE      : std_logic;   -- PHASE toggla ad ogni ciclo di clock.
                                   -- Se PHASE = 0 la SRAM EVEN è predisposta in scrittura, la SRAM ODD in lettura
                                   -- Se PHASE = 1 la SRAM EVEN è predisposta in lettura, la SRAM ODD in scrittura

  signal WPH        : std_logic;   -- Indica in quale SRAM ho scritto:   0 = EVEN, 1 = ODD

  signal WREi       : std_logic;   -- Write enable della SRAM EVEN, dalla FSM2
  signal WROi       : std_logic;   -- Write enable della SRAM ODD, dalla FSM2

  signal NWRSRAMEi  : std_logic;
  signal NWRSRAMOi  : std_logic;

  signal EVNT_WORD  : std_logic_vector(12 downto 0);  -- Numero di word di un evento (scritto nella GLOBAL HAEDER)

  signal SRAM_EVNT  : std_logic_vector(4 downto 0);   -- Numero di eventi nelle SRAM di staging
  signal SRAM_FULL  : std_logic;   -- FULL delle memorie SRAM
  signal SRAM_EMPTY : std_logic;   -- EMPTY delle memorie SRAM

  signal STOP_RDSRAM: std_logic;   -- STOP della lettura delle memorie SRAM quando la memoria FIFO va FULL

  signal FIFO_FULL  : std_logic;   -- FULL delle memoria FIFO
  signal FIFO_END_EVNT: std_logic; -- impulso che indica la scrittura di un evento nella FIFO (si setta durante la
                                   -- scrittura del Global Trailer)
  signal EVNT_REJ   : std_logic;   -- è stato servito un L2R

  signal DTES       : std_logic_vector(31 downto 0);    -- DTE cloccato
  signal DTOS       : std_logic_vector(31 downto 0);    -- DTO cloccato

  signal CRC32      : std_logic_vector(31 downto 0);    -- CRC dei dati dell'evento, su 32 bit (XOR bit a bit
                                                        -- di tutti i dati, esclusa la Header e il Trailer globali)
														
  signal MEM_FULL   : std_logic;

  signal EVRDYi     : std_logic;
  
  signal NWEN_i     : std_logic;

  -- segnali per la gestione degli errori dai TDC
  signal INT_ERRAF1  : std_logic;      -- Chain A error (dal I2C) primo FF di sincronizzazione
  signal INT_ERRBF1  : std_logic;      -- Chain B error (dal I2C) primo FF di sincronizzazione
  signal INT_ERRAS   : std_logic;      -- Chain A error (dal I2C) secondo FF di sincronizzazione
  signal INT_ERRBS   : std_logic;      -- Chain B error (dal I2C) secondo FF di sincronizzazione

  signal INT_ERRS    : std_logic;      -- INT_ERRAS or INT_ERRBS

  signal CHAINA_ERRF1: std_logic;      -- Chain A error (dal micro) primo FF di sincronizzazione
  signal CHAINB_ERRF1: std_logic;      -- Chain B error (dal micro) primo FF di sincronizzazione
  signal CHAINA_ERRS : std_logic;      -- Chain A error (dal micro) secondo FF di sincronizzazione
  signal CHAINB_ERRS : std_logic;      -- Chain B error (dal micro) secondo FF di sincronizzazione

  signal CHAIN_ERRS  : std_logic;      -- CHAINA_ERRS or CHAINB_ERRS

  signal CHAIN_RDY : std_logic;        -- le catene non sono più in errore (attendo il BNC_RES_E per riabilitarle)
  signal CHAIN_ERR_DIS : std_logic;    -- disabilitazione delle catene se in errore

  signal CHAINA_EN  : std_logic;       -- la catena A è abilitata (comunicazione da uC + non in errore)
  signal CHAINB_EN  : std_logic;       -- la catena B è abilitata (comunicazione da uC + non in errore)
  signal EMPTY_EV   : std_logic;       -- se tutte e due le catene sono disabilitate il bit EMPTY_EV nella
                                       -- global HEADER è a 1

  signal MIC_ERR_REGS  : std_logic_vector(48 downto 0); -- shift register per la memorizzaz. delle parole
                                                        -- di errore (2 parole a 16 bit e 1 a 17 but)
                                                        -- comunicate dal uC
  signal BITCNT    : std_logic_vector (5 downto 0);     -- conta i bit durante lo shift in MIC_ERR_REGS
  signal ERR_WORDS_RDY: std_logic;     -- si setta quando sono pronte le 3 parole di errore;
                                       -- si resetta quando vengono inserite nel flusso dei dati
  signal W_ERR_WORDS  : std_logic;     -- le parole di errore sono state inserite nel flusso di dati

  -- parole di errore comunicate dal uC
  signal CHA_ERR_FLAGS: std_logic_vector(15 downto 0);  -- CHAIN A error flags, comunicati da uC
  signal CHB_ERR_FLAGS: std_logic_vector(15 downto 0);  -- CHAIN B error flags, comunicati da uC
  signal ERROR_CODE   : std_logic_vector(16 downto 0);  -- Error code, comunicato da uC


  -- ************************************************************************
  -- PLL per raddoppiare la frequenza del clock per generare gli impulsi per
  -- la scrittura nelle SRAM di primo livello
  component PLL_sram is
    port(GLB, LOCK : out std_logic;  CLK : in std_logic);
  end component;

  signal PLL_LOCK_sram :  std_logic;
  signal CLK_sram      : std_logic;

  -- ************************************************************************
  -- PLL per ritardare il CLK di 4 ns (per la rilettura dei TDC)
  component PLL_tdc is
    port(GLB, LOCK : out std_logic;  CLK : in std_logic);
  end component;

  signal PLL_LOCK_tdc :  std_logic;
  signal CLK_tdc      : std_logic;

  -- ************************************************************************
  -- FUNZIONI DI UTILITA'

  -- COMPENSAZIONE:

  -----  13  12            7  6  5             0
  -----  ___ _______________ ___ _______________
  ----- |_P_|___comp data___|_P_|___comp data___|

  -- Il dato è scritto in doppia copia nella SRAM LUT (7 bit + 7 bit).
  -- Il fattore di correzione comp_data è su 6 bit (il più significativo è il segno, che va esteso su 21 bit);
  -- il settimo bit (MSB) è il bit di parità (P) del fattore di correzione.
  -- Per compensare scelgo fra la parte bassa e la parte alta del dato scritto nella LUT:
  -- se è errata la parità del dato basso, uso comunque quello alto per la compensazione, anche se
  -- avesse parità errata. In questo caso viene però marcato il dato compensato ponendo a 1 il bit E
  -- (dato non compensato correttamente).
  -- Se viene trovata errata la parità anche di uno solo dei due comp_data viene posto a 1 il bit L nella
  -- global HEADER (la LUT deve essere ricaricata), anche se i dati fossero stati compensati correttamente.

  -- parità del dato di compensazione
  function parity_error (datain: in std_logic_vector(6 downto 0)) return std_logic is
    variable dataout : std_logic;
    begin
      if (datain(5) xor datain(4) xor datain(3) xor datain(2) xor datain(1) xor datain(0)) /= datain(6)  then
        dataout := '1';
      else
        dataout := '0';
      end if;
      return dataout;
    end parity_error;

  -- Dato per la compensazione
  function comp_data (datain: in std_logic_vector(13 downto 0)) return std_logic_vector is
    variable dataout : std_logic_vector(20 downto 0);
    begin
      if parity_error(datain(6 downto 0)) = '0' then
        dataout :=  datain(5) & datain(5) & datain(5) & datain(5) & datain(5) & datain(5) & datain(5) &
                    datain(5) & datain(5) & datain(5) & datain(5) & datain(5) & datain(5) & datain(5) &
                    datain(5) & datain(5) & datain(4 downto 0);
      else
        dataout :=  datain(12) & datain(12) & datain(12) & datain(12) & datain(12) & datain(12) & datain(12) &
                    datain(12) & datain(12) & datain(12) & datain(12) & datain(12) & datain(12) & datain(12) &
                    datain(12) & datain(12) & datain(11 downto 7);
      end if;
      return dataout;
    end comp_data;

  -- errore non recuperabile nel dato di compensazione
  function comp_error (datain: in std_logic_vector(13 downto 0)) return std_logic is
    variable dataout : std_logic;
    begin
      if parity_error(datain(6 downto 0)) = '1' and parity_error(datain(13 downto 7)) = '1' then
        dataout := '1';
      else
        dataout := '0';
      end if;
      return dataout;
    end comp_error;

  -- errore in una delle copie del dato per la compensazione: occorre ricaricare la LUT
  function reload_lut(datain: in std_logic_vector(13 downto 0)) return std_logic is
    variable dataout : std_logic;
    begin
      if parity_error(datain(6 downto 0)) = '1' or parity_error(datain(13 downto 7)) = '1' then
        dataout := '1';
      else
        dataout := '0';
      end if;
      return dataout;
    end reload_lut;


  -- calcolo del canale di un dato
  function channel (datain: in std_logic_vector(31 downto 0)) return std_logic_vector is
    variable dataout : std_logic_vector(2 downto 0);
    begin
      dataout := datain(23 downto 21);
      return dataout;
    end channel;

  -- riconoscimento del global trailer
  function glob_trail (datain: in std_logic_vector(31 downto 0)) return boolean is
    variable dataout : boolean;
    begin
      if datain(31 downto 28) = G_TRAIL then
        dataout := TRUE;
      else
        dataout := FALSE;
      end if;
      return dataout;
    end glob_trail;




  -- ************************************************************************
  -- Definizione degli stati delle FSM
  attribute syn_encoding : string;

  -- FSM per la rilettura dei TDC
  type TSTATE1 is (S1_IDLE,S1_FINE,S1_FINE1,S1_FINE2,S1_FINTOGIRO,
                   S1_WHEAD_A,S1_WAIT_A,S1_GETDATA_A,S1_WAITFL_A,S1_WTRAIL_A,
                   S1_WHEAD_B,S1_WAIT_B,S1_GETDATA_B,S1_WAITFL_B,S1_WTRAIL_B,
                   S1_CHA_ERR,S1_CHB_ERR,S1_ERR_CODE,S1_WAIT1C);
  signal STATE1: TSTATE1;
  attribute syn_encoding of STATE1 : signal is "onehot";


  -- FSM per la gestione delle SRAM di primo livello
  type TSTATE2 is (S2_IDLE,S2_WRE,S2_WRO,S2_TEMP,S2_WTRAILER,S2_WHEADER);
  signal STATE2: TSTATE2;
  attribute syn_encoding of STATE2 : signal is "onehot";

  -- FSM per la gestione della FIFO di secondo livello
  type TSTATE3 is (S3_STRT,S3_SETUP,S3_RESFSM1,S3_RESFSM2,
                   S3_PRGFIF1,S3_PRGFIF2,    -- progr. FIFO
                   S3_TESTFIFO,S3_TESTFIFO1, -- test FIFO
                   S3_IDLE,S3_WAITRDE,S3_RDE,S3_RDO,
                   S3_RDEFULL,S3_RDOFULL);   -- introdotti per non perdere dati quando si va full
  signal STATE3: TSTATE3;
  attribute syn_encoding of STATE3 : signal is "onehot";

  -- FSM per la generazione del trigger per i TDC (1 ciclo di clock)
  type TSTATE4 is (S4_M0,S4_M1,S4_M2);
  signal STATE4: TSTATE4;
  attribute syn_encoding of STATE4 : signal is "onehot";

  -- FSM per lo strobe dei dati comunicati dal MICRO via seriale su MTDA-MSERCLK
  type TSTATE5 is (S5_WAITH,S5_STROBE,S5_WAITL,S5_WAIT_EVNT);
  signal STATE5: TSTATE5;
  attribute syn_encoding of STATE5 : signal is "onehot";


  -- FSM per la gestione degli errori dei TDC
  type TSTATEe is (Se_WAIT,Se_I2C_ERR,Se_MICRO_ERR,Se_MICRO_ERR_UPS,Se_READY);
  signal STATEe: TSTATEe;
  attribute syn_encoding of STATEe : signal is "safe,onehot";


  -- ************************************************************************


begin

  
  PLL_LOCK <= PLL_LOCK_sram and PLL_LOCK_tdc;

  -- ########################################################################
  -- COMUNICAZIONE CON IL MICRO
  -- ########################################################################

  ---------------------------------------------------------------------
  -- Comunicazione seriale dal micro con COM_SER = 1
  -- Lo stato di programmazione dei TDC è strobato nel registro MIC_REGS (in triplice copia)
  -- (vedi bit del registro STATUS).
  ---------------------------------------------------------------------
  --            __________________________________________________________________________________________________
  -- COM_SER __|                                                                                                  |__
  --             _____       _____       _____       _____       _____       _____       _____       _____
  -- MSERCLK____|     |_____|     |_____|     |_____|     |_____|     |_____|     |_____|     |_____|     |__________
  --             ___________ ___________ ___________ ___________ ___________ ___________ ___________ ___________
  -- MTDIA  ----|_TRG_MATCH_|_CHAINA_EN_|_CHAINB_EN_|_RAW_DATA__|_CHAINA_BP_|_CHAINB_BP_|__LEADING__|__TRAILING_|----
  --             ___________ ___________ ___________ ___________ ___________ ___________ ___________ ___________
  -- MIC_REG    |_____0_____|_____1_____|_____2_____|_____3_____|_____4_____|_____5_____|_____6_____|_____7_____|

  ---------------------------------------------------------------------
  -- Comunicazione seriale dal micro con CHAIN_ERR = 1
  -- Il micro comunica due parole a 16 bit e una a 17 bit per conoscere lo stato
  -- di errore dei TDC (strobate nel registro MIC_ERR_REGS)
  -- CHAIN A ERROR FLAGS   (CHA_ERR_FLAGS)
  -- CHAIN B ERROR FLAGS   (CHB_ERR_FLAGS)
  -- HPTDC ERROR CODE      (ERROR_CODE)
  -- Queste parole vengono inserite nel primo evento dopo la loro trasmissione,
  -- prima del GLOBAL TRAILER
  ---------------------------------------------------------------------
  CHA_ERR_FLAGS <= MIC_ERR_REGS(15 downto 0);
  CHB_ERR_FLAGS <= MIC_ERR_REGS(31 downto 16);
  ERROR_CODE    <= MIC_ERR_REGS(48 downto 32);

  ---------------------------------------------------------------------
  -- FSM per lo strobe dei dati comunicati dal MICRO via seriale su MTDIA-MSERCLK

  -- sincronizzazione dei segnali dal uC
  process(HWRES,CLK)
  begin
    if HWRES = '0' then
      MSERCLKF1 <= '0';
      MSERCLKS  <= '0';
      MTDIAF1   <= '0';
      MTDIAS    <= '0';
    elsif CLK'event  and  CLK = '1' then
      MSERCLKF1 <= MSERCLK;
      MSERCLKS  <= MSERCLKF1;
      MTDIAF1   <= MTDIA;
      MTDIAS    <= MTDIAF1;
    end if;
  end process;


  -- evoluzione degli stati
  process(CLK, HWRES)
  begin
    if HWRES ='0' then

      MIC_REG1     <= (others => '0');
      MIC_REG2     <= (others => '0');
      MIC_REG3     <= (others => '0');
      MIC_ERR_REGS <= (others => '0');
      BITCNT       <= (others => '0');
      ERR_WORDS_RDY<='0';
      STATE5       <= S5_WAITH;

    elsif CLK'event and CLK = '1' then
      case STATE5 is

        -- aspetto l'inizio della comunicazione seriale (COM_SER = 1 o CHAIN_ERRS = 1)
        -- e l'arrivo del clock MSERCLK
        when S5_WAITH  =>   if COM_SERS = '1' or CHAIN_ERRS = '1' then
                              if MSERCLKS = '1' then
                                STATE5 <= S5_STROBE;
                              end if;
                            end if;

        -- strobe del dato in MIC_REG o in MIC_ERR_REGS
        when S5_STROBE =>   if COM_SERS = '1' then     -- Comunicazione seriale con COM_SER = 1
                              for I in 0 to 6 loop
                                MIC_REG1(I)<= MIC_REG1(I+1);
                                MIC_REG2(I)<= MIC_REG2(I+1);
                                MIC_REG3(I)<= MIC_REG3(I+1);
                              end loop;
                              MIC_REG1(7) <= MTDIAS;
                              MIC_REG2(7) <= MTDIAS;
                              MIC_REG3(7) <= MTDIAS;

                            else                       -- Comunicazione seriale con CHAIN_ERRS = 1

                              for I in 0 to 47 loop
                                MIC_ERR_REGS(I)<= MIC_ERR_REGS(I+1);
                              end loop;
                              MIC_ERR_REGS(48) <= MTDIAS;
                              BITCNT  <= BITCNT + 1;     -- conto i bit per sapere quando è terminata
                            end if;                      -- la comunicazione delle 3 parole d'errore

                            STATE5      <= S5_WAITL;

        -- aspetto che MSERCLK torni basso
        when S5_WAITL  =>   if BITCNT = "110001" then  -- è terminata la comunicazione
                              ERR_WORDS_RDY <= '1';    -- delle parole di errore
                              if MSERCLKS = '0' then
                                STATE5 <= S5_WAIT_EVNT;
                              end if;
                            else
                              if MSERCLKS = '0' then
                                STATE5 <= S5_WAITH;
                              end if;
                            end if;

        -- aspetto che le parole di errore siano inserite nel flusso dei dati dalla FSM1
        when S5_WAIT_EVNT=> if W_ERR_WORDS = '1' then
                              ERR_WORDS_RDY <= '0';
                              BITCNT <= (others => '0');
                              STATE5 <= S5_WAITH;
                            end if;
      end case;
    end if;
  end process;

  MIC_REGS <= majority(MIC_REG1,MIC_REG2,MIC_REG3,MIC_REGS'length)(MIC_REGS'high downto MIC_REGS'low);


  ---------------------------------------------------------------------
  -- HANDSHAKE COL MICRO
  ---------------------------------------------------------------------
  -- REGISTRO DI HANDSHAKE PROGHS (default 0x01)
  -- il bit ROK si setta quando il MICRO dà il READ OK (MROK)
  -- e si resetta con una lettura da VME all'indirizzo del MICRO (RP_MICRO)
  process(HWRES,PULSE,MROK)
  begin
    if HWRES = '0' or PULSE(RP_MICRO) = '1' then
      REGS.PROGHS(MICRO_ROK) <= '0';
    elsif MROK'event and MROK = '1' then
      REGS.PROGHS(MICRO_ROK) <= '1';
    end if;
  end process;

  -- il bit WOK si resetta con un RESET e con una scrittura da VME
  -- all'indirizzo del MICRO (WP_MICRO);
  -- si setta quando il MICRO dà il WRITE OK (MWOK)
  process(HWRES,PULSE,MWOK)
  begin
    if HWRES = '0' or PULSE(WP_MICRO) = '1' then
      REGS.PROGHS(MICRO_WOK) <= '0';
    elsif MWOK'event and MWOK = '1' then
      REGS.PROGHS(MICRO_WOK) <= '1';
    end if;
  end process;

  ---------------------------------------------------------------------
  -- SEGNALI DI HANDSHAKE
  -- RMIC va alto quando il vme chiede di leggere un dato (lettura da VME
  -- all'indirizzo del MICRO) e torna basso quando il micro ha messo il dato
  -- sul bus (MROK va a 0)
  -- Prevedo che l'utente possa erroneamente fare un accesso in lettura prima
  -- di una scrittura di un opcode: in questo caso RMIC si resetta con la
  -- scrittura di un opcode.
  process(HWRES,PULSE,MROK)
  begin
    if HWRES = '0' or PULSE(WP_MICRO) = '1' then
      RMIC <= '0';
    elsif PULSE(RP_MICRO) = '1' then
      RMIC <= '1';
    elsif MROK'event and MROK = '0' then
      RMIC <= '0';
    end if;
  end process;

  -- WMIC va alto quando il vme chiede di scrivere un dato (scrittura da VME
  -- all'indirizzo del MICRO) e torna basso quando il micro ha letto il dato
  -- (MWOK va a 1)
  process(HWRES,PULSE,MWOK)
  begin
    if HWRES = '0' then
      WMIC <= '0';
    elsif PULSE(WP_MICRO) = '1' then
      WMIC <= '1';
    elsif MWOK'event and MWOK = '1' then
      WMIC <= '0';
    end if;
  end process;


  -- ########################################################################
  -- Segnale di TRIGGER per i TDC e gestione del giro di TOKEN
  -- ########################################################################
  process(HWRES,CLK)
  begin
    if HWRES = '0' then
      L1AF1 <= '0';
      L2AF1 <= '0';
      L2RF1 <= '0';

      L1AF2 <= '0';
      L2AF2 <= '0';
      L2RF2 <= '0';

      L1AF3 <= '0';
      L2AF3 <= '0';
      L2RF3 <= '0';

    elsif CLK'event and CLK = '1' then

      L1AF1 <= L1A;  -- sono cloccati 3 volte per ottenere segnali da inviare
      L2AF1 <= L2A;  -- ai TDC che durano 1 ciclo di clock
      L2RF1 <= L2R;

      L1AF2 <= L1AF1;
      L2AF2 <= L2AF1;
      L2RF2 <= L2RF1;

      L1AF3 <= L1AF2;
      L2AF3 <= L2AF2;
      L2RF3 <= L2RF2;

    end if;
  end process;

  L1AS  <= L1AF2 and not L1AF3;
  L2AS  <= L2AF2 and not L2AF3;
  L2RS  <= L2RF2 and not L2RF3;

  TRIGGERS <= (PULSE(SW_TRIGGER) or L2AS) when REGS.CONTROL(C_TRG_EN1 downto C_TRG_EN0) = "00" else
               L1AS                       when REGS.CONTROL(C_TRG_EN1 downto C_TRG_EN0) = "01" else
              '0';


  ---------------------------------------------------------------------
  -- TRIGGER PULSE GENERATOR
  -- Questa FSM serve per generare trigger che durano 1 periodo di clock
  -- indipendentemente dalla durata del segnale di trigger esterno.
  -- I trigger sono generati anche se le catene sono disabilitate (i 244 sono
  -- disabilitati). In questo caso FSM1 fa dei finti giri di Token per
  -- non disallineare gli eventi

  -- evoluzione degli stati
  process(CLK, CLEAR_STAT)
  begin
    if CLEAR_STAT ='0' then
      TDCTRGi <= '0';
      STATE4  <= S4_M0;
    elsif CLK'event and CLK = '1' then
      case STATE4 is

        -- aspetto l'arrivo del trigger
        when S4_M0     => if TRIGGERS = '0' then
                            STATE4 <= S4_M0;
                          else
                            STATE4 <= S4_M1;
                          end if;

        -- genero un impulso di 1 ciclo e scrivo il BUNCH ID nelle BNCID_FIFO.
        -- I trigger non sono mai disabilitati, anche nel caso di full delle memorie
        when S4_M1     => TDCTRGi <= '1';
                          STATE4  <= S4_M2;

        -- aspetto che trigger torni basso
        when S4_M2     => TDCTRGi <= '0';
                          if TRIGGERS = '0' then
                            STATE4 <= S4_M0;
                          else
                            STATE4 <= S4_M2;
                          end if;

      end case;
    end if;
  end process;

  TDCTRG <= TDCTRGi;

  ---------------------------------------------------------------------
  -- conto i trigger presenti nel buffer del TDC.
  -- TRGCNT viene incrementato dal trigger e decrementato ogni volta che parte
  -- un giro di token per leggere un evento
  -- GIROT -> se ci sono trigger nel buffer dei TDC chiedo un giro di token alla FSM1
  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT ='0' then
      TRGCNT <= "00000";
      GIROT  <= '0';
    elsif CLK'event and CLK = '1' then
      if TDCTRGi ='1' and STATE1 /= S1_FINE then
        TRGCNT <= TRGCNT+1;
        GIROT  <='1';
      elsif TDCTRGi = '0' and STATE1 = S1_FINE then
        TRGCNT <= TRGCNT-1;
        if TRGCNT = "00001" then
          GIROT <='0';
        end if;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------
  -- vettore di registri che memorizzano in BUNCH ID quando viene inviato un trigger ai TDC:
  -- posso avere in coda da processare al massimo 16 trigger
  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      for i in 0 to 15 loop
        BNCID_VECT(i)  <= (others => '0');
      end loop;
      TRGARR   <= "0000";
    elsif CLK'event and CLK = '1' then
      if TDCTRGi = '1' then
        BNCID_VECT(conv_integer(TRGARR)) <= BNC_ID;
        TRGARR <= TRGARR + 1;
      end if;
    end if;
  end process;

  -- contatore per il BUNCH ID (inizializzabile da VME)
  --process (BNC_RES,TDC_RES,CLK)
  -- begin
  --  if BNC_RES = '1' or TDC_RES = '1' then
  --    BNC_ID <= REGS.BNCID_OFF;
  --  elsif (CLK'event and CLK ='1') then
  --    BNC_ID <= BNC_ID + 1;
  --  end if;
  --end process;

   process (BNC_RES,TDC_RES,CLK)
   begin
    if TDC_RES = '1' then
      BNC_ID <= REGS.BNCID_OFF;
    elsif(rising_edge(CLK)) then
        if(BNC_RES = '1') then
            BNC_ID <= REGS.BNCID_OFF + 1;
          else
            if(BNC_ID = x"DEB") then
                BNC_ID <= (others => '0');
            else
                BNC_ID <= BNC_ID + 1;
            end if;
          end if;
        end if;
      end process;


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM per la rilettura dei TDC (dati per il primo livello di PIPELINE)
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- i dati che escono da questa FSM (PIPE1_DT) sono i dati dai TDC in cui ho messo a
  -- posto i bit di interpolazione,TDC_ID e channel. Metto il bit di leading/trailing al bit 30 e
  -- il suo negato al bit 29: in questo modo nel caso sia abilitata la modalità RAW DATA si ha
  -- PS = 01 -> leading, PS = 10 -> trailing
  -- Se rileggo HEADER o TRAILER dei TDC o parole di errore, propago.
  -- Inserisco inoltre HEADER e TRAILER di catena.
  -- In caso di errore dei TDC (le catene vengono disabilitate dalla FMSe) la FSM1 chiude
  -- l'evento con un trailer di catena in cui indica lo stato di errore e fa dei finti giri di Token
  -- per non disallineare gli eventi finché le catene non escono dallo stato di errore.

  -- istanziazione della PLL per lo sfasamento del clock con cui vengono riletti i TDC
  -- CLK_del è ritardato di 4ns rispetto a CLK (in simulazione -> 2ns)

  PLL_tdc_del: PLL_tdc
    port map
      (GLB    =>  CLK_tdc,
       LOCK   =>  PLL_LOCK_tdc,
       CLK    =>  CLK
      );

  -- EVENT NUMBER per header e trailer di catena
  process(CLK_tdc,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      EVNT_NUM <= (others => '0');
    elsif CLK_tdc'event and CLK_tdc = '1' then
      if EV_RES = '1' then
        EVNT_NUM <= (others => '0');
      elsif STATE1 = S1_FINE then
        EVNT_NUM <= EVNT_NUM + 1;
      end if;
    end if;
  end process;


  -- sincronizzazione dei segnali dai TDC; questi segnali sono già sincroni:
  -- metto dei FF per ridurre l'input to register time.
  -- Il TDCDRYA/B non può essere usato cloccato nella FSM1, altrimenti la FSM1 sbaglia a
  -- rileggere nel caso che un TDC porti basso il TDCDRY per 1 ciclo di clock.
  -- Lo uso cloccato per resettare i contatori per il TIMOUT del TOKEN.
  process(CLK_tdc)
  begin
    if CLK_tdc'event and CLK_tdc = '1' then

      TDCDAS   <= TDCDA;
      TDCDBS   <= TDCDB;
      TDCDRYAS <= TDCDRYA;
      TDCDRYBS <= TDCDRYB;

      if REGS.STATUS(S_CHAINA_BP) = '0' then
        TOKOUTAS <= TOKOUTA;
      else
        TOKOUTAS <= TOKOUTA_BP;
      end if;

      if REGS.STATUS(S_CHAINB_BP) = '0' then
        TOKOUTBS <= TOKOUTB;
      else
        TOKOUTBS <= TOKOUTB_BP;
      end if;

    end if;
  end process;

  FLUSH <= '0';
  
  -- La FSM rilegge in sequenza le due catene.
  -- I TDC sono riletti a 20MHz.
  -- FSM1 cessa di leggere i TDC quando le SRAM sono FULL.
  U_tdc_read_fsm : process(CLK_tdc, CLEAR_STAT)
  begin
    if CLEAR_STAT ='0' then

      STATE1    <= S1_IDLE;

      TOKINAi   <= '0';
      TOKINBi   <= '0';
      TDCGDAi   <= '0';
      TDCGDBi   <= '0';
      TOKOUT_FL <= '0';

      NWPIPE1   <= '1';
      PIPE1_DT  <= (others => '0');
      END_EVNT1 <= '0';

      RAMAD1    <= (others => '0');

      TRGSERV   <= "0000";

      FCNT      <= "110";

      TDC       <= "0000";
      FIRST_TDC <= '1';
      END_TDC1  <= '0';

      END_CHAINA1  <= '0';
      END_CHAINB1  <= '0';

      START_GIRO   <= '0';

      W_ERR_WORDS  <= '0';
      TOKENTOA_RES <= '0';
      TOKENTOB_RES <= '0';
	  
    elsif CLK_tdc'event and CLK_tdc='1' then

      case STATE1 is
        -- Attende che si setti GIROT (ossia ci sono trigger nel buffer dei TDC) o
        -- se la scheda è FULL (= le SRAM sono FULL).
        -- Se entrambe le catene sono disabilitate (nel caso di errore dei TDC, di timeout
        -- nell'attesa del TOKEN o se sono disabilitate da software) fa dei finti giri di TOKEN.
        -- Se una catena in errore viene disabilitata durante un giro di TOKEN, chiude il giro
        -- scrivendo il trailer di catena con STAT_ERR.
        -- Questa FSM inserisce HEADER e TRAILER di catena.
        --             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
        --              _______________________________________________________________________________________________
        -- LOC. HEADER | 0000/0010 |        00..00                     |             BUNCH ID              |  SLOT ID  |
        --                          in questo campo viene messo il CHAIN_EVNT_WORD dalla FSM STATE2
        --              _______________________________________________________________________________________________
        -- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |             RESERVED              |  STATUS   |


        when S1_IDLE     => TOKENTOA_RES  <= '0';
                            TOKENTOB_RES  <= '0';
                            if GIROT = '1' and SRAM_FULL = '0' then
                              START_GIRO   <= '1';
                              if CHAINA_EN = '1' then   -- chainA en
                                NWPIPE1      <= '0';
                                PIPE1_DT     <= HEAD_A &
                                                "000000000000" &   
                                                BNCID_VECT(conv_integer(TRGSERV)) & not GA(3 downto 0);
                                STATE1       <= S1_WHEAD_A;
                              else
                                if CHAINB_EN = '1' then -- chainA dis - chainB en
                                  NWPIPE1    <= '0';
                                  PIPE1_DT   <= HEAD_B &
                                                "000000000000" &   
                                                BNCID_VECT(conv_integer(TRGSERV)) & not GA(3 downto 0);
                                  STATE1     <= S1_WHEAD_B;
                                else
                                -- nessuna delle due catene è abilitata: faccio dei finti giri di token
                                  STATE1     <= S1_FINTOGIRO;
                                end if;
                              end if;
                            end if;

        --------------------------------------------------------------
        -- CATENA A --------------------------------------------------
        --------------------------------------------------------------
        -- scrivo la header della catena A e invio il TOKINA
        when S1_WHEAD_A  => NWPIPE1      <= '1';
                            TOKINAi      <= '1';
                            TOKENTOA_RES <= '1'; -- tolgo il reset al contatore per il TIMOUT di TOKOUTAS
                            TOKOUT_FL    <= '0';
                            FCNT         <= "110";
                            START_GIRO   <= '0';
                            STATE1       <= S1_WAIT_A;

        -- ciclo di attesa in cui non do il GETDATA: attendo se TDCDRYA è in alta impedenza
        -- ma anche fra una lettura di un dato e la successiva
        when S1_WAIT_A   => NWPIPE1  <= '1';
                            TOKINAi  <= '0';
                            if CHAINA_EN = '0' then -- è stata dis. la catena: scrivo il trailer con STAT_ERR
                              END_CHAINA1 <= '1';
                              END_TDC1    <= '1';
                              PIPE1_DT    <= TRAIL_A & EVNT_NUM & RESERVED & STAT_ERR;
                              STATE1      <= S1_WAITFL_A;
                            else
                              if TOKOUTAS = '1' or TOKOUT_FL = '1' then  -- è tornato il TOKEN
                                END_CHAINA1 <= '1';
                                END_TDC1    <= '1';
                                TOKOUT_FL   <= '0';
                                PIPE1_DT    <= TRAIL_A & EVNT_NUM & RESERVED & STAT_OK;
                                STATE1      <= S1_WAITFL_A;
                              else                     -- DATA READY è attivo

                                if TDCDRYA = '1' then
                                  TDCGDAi <= '1';
                                  STATE1  <= S1_GETDATA_A;
                                end if;

                                if TDCGDA1 = '1' then
                                  NWPIPE1  <= '0';

                                  -- TDC DATA: nel 1° livello di PIPE metto a posto i bit di interpolazione,
                                  -- TDC_ID e channel. Metto il bit di leading/trailing al bit 30 e il suo negato al bit 29
                                  if TDCDAS(31 downto 29) = "010" then
                                    PIPE1_DT <= '1' & TDCDAS(28) & not TDCDAS(28) & '0' & TDCDAS(27 downto 21) & TDCDAS(18 downto 0) & TDCDAS(20 downto 19);
                                    TDC      <= TDCDAS(27 downto 24);
                                    FIRST_TDC<= '0';
                                    if TDCDAS(27 downto 24) /= TDC and FIRST_TDC = '0' then
                                      TDCGDAi  <= '0';
                                      END_TDC1 <= '1';                    -- è arrivato un dato di un nuovo TDC:
                                      NWPIPE1  <= '1';                    -- prima di scriverlo aspetto che sia stato
                                      STATE1   <= S1_WAITFL_A;            -- fatto un eventuale flush della LEAD_SRAM
                                    end if;
                                    -- rileggo la LUT
                                    RAMAD1  <= '0' & TDCDAS(27 downto 21) & TDCDAS(7 downto 0) & TDCDAS(20 downto 19);
                                  -- TDC ERROR, HEADER e TRAILER
                                  else
                                    PIPE1_DT <= TDCDAS;
                                  end if;

                                end if;

                              end if;
                            end if;

        -- invia il GET DATA
        when S1_GETDATA_A=> NWPIPE1  <= '1';
                            if CHAINA_EN = '0' then -- è stata dis. la catena: scrivo il trailer con STAT_ERR
                              TDCGDAi     <= '0';
                              END_CHAINA1 <= '1';
                              END_TDC1    <= '1';
                              PIPE1_DT    <= TRAIL_A & EVNT_NUM & RESERVED & STAT_ERR;
                              STATE1      <= S1_WAITFL_A;
                            else
                              if TOKOUTAS = '1' then  -- è tornato il TOKEN
                                TDCGDAi     <= '0';
                                END_CHAINA1 <= '1';
                                END_TDC1    <= '1';
                                PIPE1_DT    <= TRAIL_A & EVNT_NUM & RESERVED & STAT_OK;
                                STATE1      <= S1_WAITFL_A;
                              else                    -- DATA READY è attivo
                                TDCGDAi  <= '0';
                                STATE1   <= S1_WAIT_A;
                              end if;
                            end if;

        -- attendo la fine dell'eventuale flush della catena A
        when S1_WAITFL_A => END_TDC1     <= '0';
                            TOKENTOA_RES <= '0'; -- metto in reset il contatore per il TIMOUT di TOKOUTAS

                            if TOKOUTAS = '1' then  -- memorizzo che è tornato il TOKEN
                              TOKOUT_FL <= '1';
                            end if;

--                            if FCNT /= "000" then
--                              FCNT  <= FCNT - 1;    -- attendo 6 cicli di clock che parta la FSM del Flush
--                            else
--                              if FLUSH = '0' then   -- attendo che la FSM abbia finito il Flush della LEAD_SRAM
--                                FCNT    <= "110";
                                NWPIPE1 <= '0';     -- scrivo il dato dal nuovo TDC o il trailer di catena
                                if END_CHAINA1 = '1' then
                                  STATE1      <= S1_WTRAIL_A;
                                  END_CHAINA1 <= '0';
                                else
                                  if CHAINA_EN = '1' then   -- chainA en
                                    TOKENTOA_RES <= '1';    -- tolgo il reset al contatore per il TIMOUT di TOKOUTAS
                                    STATE1       <= S1_WAIT_A;
                                  else                      -- è stata dis. la catena: scrivo il trailer con STAT_ERR
                                    PIPE1_DT     <= TRAIL_A & EVNT_NUM & RESERVED & STAT_ERR;
                                    STATE1       <= S1_WTRAIL_A;
                                  end if;
                                end if;
--                              end if;
--                            end if;

        -- scrittura del TRAILER della catena A.
        -- controllo se è abilitata la catena B.
        when S1_WTRAIL_A => FIRST_TDC  <= '1';
                            NWPIPE1    <= '1';
                            if CHAINB_EN = '1' then -- chainB en
                              NWPIPE1  <= '0';
                              PIPE1_DT <= HEAD_B &
                                          "000000000000" &   -- RESERVED: questo campo diventerà chainb_evnt_word quando l'evento verrà scritto nelle sram di staging
                                          BNCID_VECT(conv_integer(TRGSERV)) & not GA(3 downto 0);
                              STATE1   <= S1_WHEAD_B;
                            else                    -- chainB dis
                              if ERR_WORDS_RDY = '1' then  -- sono pronte le parole di errore da uC
                                NWPIPE1   <= '0';
                                PIPE1_DT  <= G_ERR & "00000000" & CHA_ERR_FLAGS;
                                STATE1    <= S1_CHA_ERR;
                              else
                                END_EVNT1 <= '1';
                                STATE1    <= S1_FINE;
                              end if;
                            end if;

        --------------------------------------------------------------
        -- CATENA B --------------------------------------------------
        --------------------------------------------------------------
        -- scrivo la header della catena B e invio il TOKINB
        when S1_WHEAD_B  => NWPIPE1      <= '1';
                            TOKINBi      <= '1';
                            TOKENTOB_RES <= '1'; -- tolgo il reset al contatore per il TIMOUT di TOKOUTBS
                            TOKOUT_FL    <= '0';
                            START_GIRO   <= '0';
                            STATE1       <= S1_WAIT_B;

        -- ciclo di attesa in cui non do il GETDATA: attendo se TDCDRYA è in alta impedenza
        -- ma anche fra una lettura di un dato e la successiva
        when S1_WAIT_B   => NWPIPE1  <= '1';

                            TOKINBi  <= '0';
                            if CHAINB_EN = '0' then -- è stata dis. la catena: scrivo il trailer con STAT_ERR
                              END_CHAINB1 <= '1';
                              END_TDC1    <= '1';
                              PIPE1_DT    <= TRAIL_B & EVNT_NUM & RESERVED & STAT_ERR;
                              STATE1      <= S1_WAITFL_B;
                            else
                              if TOKOUTBS = '1' or TOKOUT_FL = '1' then   -- è tornato il TOKEN
                                END_CHAINB1 <= '1';
                                END_TDC1    <= '1';
                                TOKOUT_FL   <= '0';
                                PIPE1_DT    <= TRAIL_B & EVNT_NUM & RESERVED & STAT_OK;
                                STATE1      <= S1_WAITFL_B;
                              else                     -- DATA READY è attivo

                                if TDCDRYB = '1' then
                                  TDCGDBi <= '1';
                                  STATE1  <= S1_GETDATA_B;
                                end if;

                                if TDCGDB1 = '1' then
                                  NWPIPE1  <= '0';

                                  -- TDC DATA: nel 1° livello di PIPE metto a posto i bit di interpolazione,
                                  -- TDC_ID e channel. Metto il bit di leading/trailing al bit 30 e il suo negato al bit 29
                                  if TDCDBS(31 downto 29) = "010" then
                                    PIPE1_DT <= '1' & TDCDBS(28) & not TDCDBS(28) & '0' & TDCDBS(27 downto 21) & TDCDBS(18 downto 0) & TDCDBS(20 downto 19);
                                    TDC      <= TDCDBS(27 downto 24);
                                    FIRST_TDC<= '0';
                                    if TDCDBS(27 downto 24) /= TDC and FIRST_TDC = '0' then
                                      TDCGDBi  <= '0';
                                      END_TDC1 <= '1';                    -- è arrivato un dato di un nuovo TDC:
                                      NWPIPE1  <= '1';                    -- prima di scriverlo aspetto che sia stato
                                      STATE1   <= S1_WAITFL_B;            -- fatto un eventuale flush della LEAD_SRAM
                                    end if;
                                    -- rileggo la LUT
                                    RAMAD1  <= '1' & TDCDBS(27 downto 21) & TDCDBS(7 downto 0) & TDCDBS(20 downto 19);
                                  -- TDC ERROR, HEADER e TRAILER
                                  else
                                    PIPE1_DT <= TDCDBS;
                                  end if;

                                end if;

                              end if;
                            end if;

        -- invia il GET DATA
        when S1_GETDATA_B=> NWPIPE1  <= '1';
                            if CHAINB_EN = '0' then -- è stata dis. la catena: scrivo il trailer con STAT_ERR
                              TDCGDBi     <= '0';
                              END_CHAINB1 <= '1';
                              END_TDC1    <= '1';
                              PIPE1_DT    <= TRAIL_B & EVNT_NUM & RESERVED & STAT_ERR;
                              STATE1      <= S1_WAITFL_B;
                            else
                              if TOKOUTBS = '1' then  -- è tornato il TOKEN
                                TDCGDBi     <= '0';
                                END_CHAINB1 <= '1';
                                END_TDC1    <= '1';
                                PIPE1_DT    <= TRAIL_B & EVNT_NUM & RESERVED & STAT_OK;
                                STATE1      <= S1_WAITFL_B;
                              else                    -- DATA READY è attivo
                                TDCGDBi  <= '0';
                                STATE1   <= S1_WAIT_B;
                              end if;
                            end if;

        -- attendo la fine dell'eventuale flush della catena B
        when S1_WAITFL_B => END_TDC1     <= '0';
                            TOKENTOB_RES <= '0';    -- metto in reset il contatore per il TIMOUT di TOKOUTBS
                            if TOKOUTBS = '1' then  -- memorizzo che è tornato il TOKEN
                              TOKOUT_FL <= '1';
                            end if;

--                            if FCNT /= "000" then
--                              FCNT  <= FCNT - 1;    -- attendo 6 cicli di clock che parta la FSM del Flush
--                            else
--                              if FLUSH = '0' then   -- attendo che la FSM abbia finito il Flush della LEAD_SRAM
                                FCNT    <= "110";
                                NWPIPE1 <= '0';     -- scrivo il dato dal nuovo TDC o il trailer di catena
                                if END_CHAINB1 = '1' then
                                  STATE1      <= S1_WTRAIL_B;
                                  END_CHAINB1 <= '0';
                                else
                                  if CHAINB_EN = '1' then   -- chainB en
                                    TOKENTOB_RES <= '1';    -- tolgo il reset al contatore per il TIMOUT di TOKOUTBS
                                    STATE1       <= S1_WAIT_B;
                                  else                      -- è stata dis. la catena: scrivo il trailer con STAT_ERR
                                    PIPE1_DT     <= TRAIL_B & EVNT_NUM & RESERVED & STAT_ERR;
                                    STATE1       <= S1_WTRAIL_B;
                                  end if;
                                end if;
--                              end if;
--                            end if;

        -- scrittura del TRAILER della catena B
        when S1_WTRAIL_B => FIRST_TDC <= '1';
                            NWPIPE1   <= '1';
                            if ERR_WORDS_RDY = '1' then -- sono pronte le parole di errore da uC
                              NWPIPE1   <= '0';
                              PIPE1_DT  <= G_ERR & "00000000" & CHA_ERR_FLAGS;
                              STATE1    <= S1_CHA_ERR;
                            else
                              END_EVNT1 <= '1';
                              STATE1    <= S1_FINE;
                            end if;

        --------------------------------------------------------------

        when S1_FINTOGIRO=> START_GIRO<= '0';
                            if ERR_WORDS_RDY = '1' then -- sono pronte le parole di errore da uC
                              NWPIPE1   <= '0';
                              PIPE1_DT  <= G_ERR & "00000000" & CHA_ERR_FLAGS;
                              STATE1    <= S1_CHA_ERR;
                            else
                              END_EVNT1 <= '1';
                              STATE1    <= S1_FINE;
                            end if;

        when S1_FINE     => END_EVNT1 <= '0';
                            W_ERR_WORDS <= '0';
                            STATE1    <= S1_FINE1;

        -- attesa di 2 cicli di clock perchè la FSM2 possa scrivere Header e Trailer globali
        when S1_FINE1    => STATE1    <= S1_FINE2;


        when S1_FINE2    => TRGSERV   <= TRGSERV + 1;
                            STATE1    <= S1_IDLE;

        --------------------------------------------------------------
        -- inserimento nel flusso dei dati delle 3 parole di errore comunicate da uC

        when S1_CHA_ERR  => NWPIPE1   <= '0';
                            PIPE1_DT  <= G_ERR & "00000000" & CHB_ERR_FLAGS;
                            STATE1    <= S1_CHB_ERR;

        when S1_CHB_ERR  => NWPIPE1   <= '1';
                            STATE1    <= S1_WAIT1C;

        -- l'evoluzione della FSM2 presuppone che fra la scrittura del penultimo e dell'ultimo dato
        -- di un evento dalla FSM1 ci sia 1 ciclo di clock per poter scrivere l'eventuale dato nella PIPE.
        -- Per questo motivo è stato introdotto S1_WAIT1C.
        when S1_WAIT1C   => NWPIPE1   <= '0';
                            PIPE1_DT  <= G_ERR & "0000000" & ERROR_CODE;
                            STATE1    <= S1_ERR_CODE;

        when S1_ERR_CODE => NWPIPE1   <= '1';
                            END_EVNT1 <= '1';
                            W_ERR_WORDS <= '1';
                            STATE1    <= S1_FINE;

      end case;
    end if;
  end process;

  -- TDCs TOKIN
  TOKINA <= TOKINAi;
  TOKINB <= TOKINBi;

  -- TDCs get data
  TDCGDA <= TDCGDAi;
  TDCGDB <= TDCGDBi;

  process(CLK_tdc,HWRES)
  begin
    if HWRES = '0' then
      TDCGDA1 <= '0';
      TDCGDB1 <= '0';
    elsif CLK_tdc'event and CLK_tdc = '1' then
      TDCGDA1 <= TDCGDAi;
      TDCGDB1 <= TDCGDBi;
    end if;
  end process;

  -- ########################################################################
  -- TOKEN TIMOUT: se i TDC non rispondono per 6.4us asserisco TIMOUT,
  -- disabilito entrambe le catene (come nel caso di INT_ERR) e avverto
  -- il uC asserendo MTDCRESA/B
  -- ########################################################################
  process(CLEAR_STAT,TOKENTOA_RES,CLK)
  begin
    if CLEAR_STAT = '0' or TOKENTOA_RES = '0' then
      TOKENA_CNT    <= (others => '0');
      TOKENA_TIMOUT <= '0';
    elsif CLK'event and CLK = '1' then
      if TOKOUTAS = '1' or TDCDRYAS = '1' then
        TOKENA_CNT    <= (others => '0');
        TOKENA_TIMOUT <= '0';
      else
        TOKENA_TIMOUT <= '0';
        if TICK(T64) ='1' then
          TOKENA_CNT  <= TOKENA_CNT + 1;
        end if;

        if TOKENA_CNT = "11" then
          TOKENA_TIMOUT <= '1';
        end if;

      end if;
    end if;
  end process;

  process(CLEAR_STAT, CHAINA_ERRS, CLK)
  begin
    if CLEAR_STAT = '0' or CHAINA_ERRS = '1' then
      MTDCRESA <= '0';
    elsif CLK'event and CLK = '1' then
      if TOKENA_TIMOUT = '1' or PULSE(M_TIMOUTA) = '1' then
        MTDCRESA <= '1';
      end if;
    end if;
  end process;


  process(CLEAR_STAT,TOKENTOB_RES,CLK)
  begin
    if CLEAR_STAT = '0' or TOKENTOB_RES = '0' then
      TOKENB_CNT    <= (others => '0');
      TOKENB_TIMOUT <= '0';
    elsif CLK'event and CLK = '1' then
      if TOKOUTBS = '1' or TDCDRYBS = '1' then
        TOKENB_CNT    <= (others => '0');
        TOKENB_TIMOUT <= '0';
      else
        TOKENB_TIMOUT <= '0';
        if TICK(T64) ='1' then
          TOKENB_CNT  <= TOKENB_CNT + 1;
        end if;

        if TOKENB_CNT = "11" then
          TOKENB_TIMOUT <= '1';
        end if;

      end if;
    end if;
  end process;

  process(CLEAR_STAT, CHAINB_ERRS, CLK)
  begin
    if CLEAR_STAT = '0' or CHAINB_ERRS = '1' then
      MTDCRESB <= '0';
    elsif CLK'event and CLK = '1' then
      if TOKENB_TIMOUT = '1' or PULSE(M_TIMOUTB) = '1' then
        MTDCRESB <= '1';
      end if;
    end if;
  end process;


  -- ########################################################################
  -- SECONDO-QUARTO livello di pipeline: LETTURA DELLA LUT.

  -- NOELUT è sempre attivo (è disattivo solo al power on quando l'interf. SPI
  -- scrive la LUT).
  -- La SRAM è riletta dal ROC per la compensazione dei dati dai TDC
  -- (RAMAD1 è un'uscita della FSM1).
  -- La SRAM è scritta dall'interfaccia SPI al power on: quando l'interfaccia
  -- SPI sta caricando le tabella di compensazione (LOAD_RES = 0),
  -- La SRAM può essere riletta anche da VME per test.
  -- ########################################################################
  -- Mux per gli indirizzi della SRAM
  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      RAMAD  <= (others => '0');
    elsif CLK'event and CLK = '1' then
      if LOAD_RES = '0' then
        RAMAD <= RAMAD_SPI;            -- accesso dell'interfaccia SPI (scrittura)
      elsif REGS.CONTROL(C_TST_SRAM) = '1' then
        RAMAD <= RAMAD_VME;            -- accesso del VME (lettura)
      else
        RAMAD <= RAMAD1;               -- accesso FSM1 del ROC per compensazione (lettura)
      end if;

    end if;
  end process;

  -- progagazione dei dati in attesa che venga riletta la LUT per la compensazione.
  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      NWPIPE2     <= '1';
      PIPE2_DT    <= (others => '0');
      END_EVNT2   <= '0';
    elsif CLK'event and CLK = '1' then
      NWPIPE2     <= NWPIPE1;
      PIPE2_DT    <= PIPE1_DT;
      END_EVNT2   <= END_EVNT1;
    end if;
  end process;

  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      NWPIPE3     <= '1';
      PIPE3_DT    <= (others => '0');
      END_EVNT3   <= '0';
    elsif CLK'event and CLK = '1' then
      NWPIPE3     <= NWPIPE2;
      PIPE3_DT    <= PIPE2_DT;
      END_EVNT3   <= END_EVNT2;
    end if;
  end process;

  -- strobe dei dati dalla LUT
  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      NWPIPE4     <= '1';
      PIPE4_DT    <= (others => '0');
      END_EVNT4   <= '0';
      RAMDT4      <= (others => '0');
    elsif CLK'event and CLK = '1' then
      NWPIPE4     <= NWPIPE3;
      PIPE4_DT    <= PIPE3_DT;
      END_EVNT4   <= END_EVNT3;
      RAMDT4      <= RAMDT;
    end if;
  end process;


  -- ########################################################################
  -- QUINTO livello di pipeline: COMPENSAZIONE
  -- ########################################################################
  -- nel caso il packing dei dati sia disabilitato nelle memorie vengono scritti i dati
  -- di questo livello di pipeline
  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then

      NWPIPE5     <= '1';
      PIPE5_DT    <= (others => '0');
      END_EVNT5   <= '0';

    elsif CLK'event and CLK = '1' then

      END_EVNT5   <= END_EVNT4;
      NWPIPE5     <= NWPIPE4;

      if NWPIPE4 = '0' then

        if PIPE4_DT(31) = '1' then  -- TDC DATA

          if REGS.CONTROL(C_COMP) = '1' then    -- compensazione abilitata: il dato è su 7 bit, il più significativo è il segno
            PIPE5_DT <= PIPE4_DT(31 downto 29) & comp_error(RAMDT4) & PIPE4_DT(27 downto 21) &
                       (PIPE4_DT(20 downto 0) + comp_data(RAMDT4(13 downto 0)));
          else                         -- compensazione disabilitata
            PIPE5_DT <= PIPE4_DT;
          end if;
        else                        -- TDC ERROR o parole di formattazione: propagazione
          PIPE5_DT <= PIPE4_DT;
        end if;
      end if;
    end if;
  end process;


  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      L_LUT <= '0';
    elsif CLK'event and CLK = '1' then
      -- quando compenso il dato se trovo un errore di parità nella SRAM LUT setto il bit L_LUT
      if NWPIPE4 = '0' and PIPE4_DT(31) = '1' and REGS.CONTROL(C_COMP) = '1' and reload_lut(RAMDT4) = '1' then
        L_LUT <= '1';
      -- quando scrivo la header resetto il bit L_LUT
      elsif STATE2 = S2_WHEADER then
        L_LUT <= '0';
      end if;
    end if;
  end process;

  -- ########################################################################
  -- SESTO-DECIMO livello di pipeline: SOTTRAZIONE TRAILING-LEADING
  -- ########################################################################
  -- eliminati!
  
  -- ########################################################################
  -- LETTURA-SCRITTURA NELLE SRAM (Scrittura-> FSM2, Lettura-> FSM3)
  -- ########################################################################
  -- PHASE toggla ad ogni ciclo di clock.
  -- quando PHASE = 0 la SRAM ODD è predisposta in scrittura, la SRAM EVEN in lettura
  -- quando PHASE = 1 la SRAM EVEN è predisposta in scrittura, la SRAM ODD in lettura
  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      PHASE    <='0';
      ADE      <= (others => '0');
      ADO      <= (others => '0');
      NOESRAME <='0';   -- READ EVEN
      NOESRAMO <='1';   -- WRITE ODD
    elsif CLK'event and CLK ='1' then
      if PHASE ='0' then
        PHASE    <='1';
        ADE      <= WRPNT;
        ADO      <= RDPNT ;
        NOESRAME <='1'; -- WRITE EVEN
        NOESRAMO <='0'; -- READ ODD
      else
        PHASE    <='0';
        ADE      <= RDPNT;
        ADO      <= WRPNT;
        NOESRAME <='0'; -- READ EVEN
        NOESRAMO <='1'; -- WRITE ODD
      end if;
    end if;
  end process;


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM per la SCRITTURA NELLE SRAM EVEN E ODD
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- I dati da scrivere nelle SRAM vengono dal 10° livello di PIPE se è abilitata la sottrazione TRAILING-LEADING,
  -- altrimenti dal 5° livello di PIPE.
  -- Nel caso che il micro comunichi REGS.STATUS(S_RAW_DATA) = 1 i dati sono direttamente quelli dai TDC (più le
  -- parole di formattazione): li prendo dal secondo livello di pipe perchè sono risincronizzati con CLK
  -- (i segnali dal primo livello di pipe vanno con CLK_tdc)
  WR_SRAM  <= NWPIPE2   when REGS.STATUS(S_RAW_DATA) = '1' else NWPIPE5;

  DT_SRAM  <= PIPE2_DT  when REGS.STATUS(S_RAW_DATA) = '1' else PIPE5_DT;

  END_EVNT <= END_EVNT2 when REGS.STATUS(S_RAW_DATA) = '1' else END_EVNT5;

  -- PUNTATORI DI SCRITTURA NELLE SRAM
  -- Il bit meno significativo di WOFFSET determina in quele memoria ho appena scritto (0= ODD, 1=EVEN).
  -- Il primo dato che arriva dalla FSM1 viene scritto nella memoria ODD, a indirizzo 0.
  -- La HEADER viene scritta per ultima nella memoria EVEN, a indirizzo 0.
  WRPNT <= WPAGE & WOFFSET(WOFFSET'high downto 1);

  WPH   <= WOFFSET(0);

  -- CONTATORE DEGLI EVENTI, scritto nella HEADER globale
  process(CLK, CLEAR_STAT)
  begin
    if CLEAR_STAT ='0' then
      G_EVNT_NUM <= (others => '0');
    elsif CLK'event and CLK = '1' then
      if EV_RES = '1' then
        G_EVNT_NUM <= (others => '0');
      elsif INC_EVNT_NUM = '1' then
        G_EVNT_NUM <= G_EVNT_NUM + 1;
      end if;
    end if;
  end process;


  -- CONTATORE DEGLI EVENTI NELLE SRAM DI STAGING:
  -- questo contatore viene incrementato quando parte un giro di token (START_GIRO) e
  -- decrementato quando viene riletto un evento intero dalle SRAM (FIFO_END_EVNT)
  -- (viene letto il global trailer) o quando arriva un L2R
  -- Con questo contatore genero il full delle SRAM, che blocca l'acquisizione e i trigger.
  process(CLK, CLEAR_STAT)
  begin
    if CLEAR_STAT ='0' then
      SRAM_EVNT <= (others => '0');
      SRAM_FULL <= '0';
    elsif CLK'event and CLK = '1' then
      -- è iniziato un giro di token -> verrà scritto un evento nelle SRAM
      if START_GIRO = '1' and (FIFO_END_EVNT = '0' and EVNT_REJ = '0') then
        SRAM_EVNT <= SRAM_EVNT + 1;
        if SRAM_EVNT = "01111" then
          SRAM_FULL <= '1';
        end if;
      -- è stato riletto o rigettato un evento dalle SRAM
      elsif START_GIRO = '0' and (FIFO_END_EVNT = '1' or EVNT_REJ = '1') then
        SRAM_EVNT <= SRAM_EVNT - 1;
        SRAM_FULL <= '0';
      end if;
    end if;
  end process;

  SRAM_EMPTY <= '1' when RPAGE = WPAGE and SRAM_FULL = '0'  else '0';


  -- La FSM scrive gli eventi nelle SRAM: prima scrive i dati che arrivano da FSM1,
  -- poi il Global TRAILER e infine la Global HEADER
  --             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
  --              _______________________________________________________________________________________________
  -- GLB. HEADER |   0100    | E|         EVENT NUMBER (10)   |             EVENT WORDS (13)         |  SLOT ID  |
  --                           |
  --                           |__ Empty event

  --             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
  --              _______________________________________________________________________________________________
  -- GLB. TRAILER|   0101    | L|TS|CN| SENS AD|        TEMP (8)       |     EVENT CRC (12)                | X| X|
  --                           |  |  |
  --                           |  |  |__ Chain
  --                           |  |__ TS bit
  --                           |__ Lut error
  
  U_sram_write_fsm : process(CLK, CLEAR_STAT)
  variable crc        : std_logic_vector(11 downto 0);
  variable temp_field : std_logic_vector(12 downto 0);
  variable data_to_write    : std_logic_vector(31 downto 0);
  variable chaina_dis : std_logic;
  variable chainb_dis : std_logic;
  variable chaina_empty : std_logic;
  variable chainb_empty : std_logic;
  variable chaina_data : std_logic;
  variable chainb_data : std_logic;
  variable chaina_evnt_word : std_logic_vector(11 downto 0);
  variable chainb_evnt_word : std_logic_vector(11 downto 0);

  begin
    if CLEAR_STAT ='0' then

      STATE2     <= S2_IDLE;
      DTE        <= (others => 'Z');
      DTO        <= (others => 'Z');
      WREi       <= '1';
      WROi       <= '1';
      TEMPF      <= '0';
      DT_TEMP    <= (others => '0');
      ENDF       <= '0';

      WPAGE      <= (others => '0');
      WOFFSET    <= "0000000000001";

      EVNT_WORD  <= (others => '0');
      data_to_write := (others => '0');
	  
      chaina_dis := '0';  -- = 1 -> non è arrivato nessun dato dalla catena A, neppure HEAD e TRAIL -> la catena è disabilitata da SW o da uC
	  chainb_dis := '0';  -- = 1 -> non è arrivato nessun dato dalla catena B, neppure HEAD e TRAIL -> la catena è disabilitata da SW o da uC

      chaina_empty := '0';  -- = 1 -> dalla catena A sono arrivati solo HEAD e TRAIL ma nessun HIT
	  chainb_empty := '0';  -- = 1 -> dalla catena B sono arrivati solo HEAD e TRAIL ma nessun HIT
	  
      chaina_data := '0'; -- = 1 -> è in corso l'arrivo di dati dalla catena A
	  chainb_data := '0'; -- = 1 -> è in corso l'arrivo di dati dalla catena A
	  
      chaina_evnt_word := (others => '0');
	  chainb_evnt_word := (others => '0');
	  
	  crc        := (others => '0');
	  temp_field := (others => '0');
      CRC32      <= (others => '0');
	  pippolo <= '0';

      INC_EVNT_NUM <= '0';

    elsif CLK'event and CLK = '1' then

	pippolo <= '0';

      case STATE2 is

        -- Attende una richiesta di scrittura nelle SRAM: se la fase di scrittura è corretta (WPH = PHASE)
        -- va in uno dei due stati di scrittura (S1_WRE => SRAM EVEN, S1_WRO => SRAM ODD)
        -- altrimenti stroba il dato in un livello di pipe (DT_TEMP) per attendere che la fase sia corretta.
        -- ATTENZIONE: l'evoluzione della FSM presuppone che fra la scrittura del penultimo e dell'ultimo dato
        -- di un evento dalla FSM1 ci sia 1 ciclo di clock per poter scrivere l'eventuale dato nella PIPE.
        -- Per questo motivo è stato introdotto S1_WAIT1C.
        when S2_IDLE   =>  if END_EVNT = '1' or ENDF = '1' then -- la FSM1 ha terminato di rileggere un evento dagli HPTDC
                             if PHASE = WPH then    -- La fase di scrittura è giusta
                               ENDF      <= '0';
                               EVNT_WORD <= WOFFSET + 1;
                               WOFFSET   <= (others => '0');
                               STATE2    <= S2_WTRAILER;
                               crc        := (("0000" & CRC32(31 downto 24)) xor CRC32(23 downto 12) xor CRC32(11 downto 0));
							   -- REGS.TEMP   13  12  11  10  9   ...   2 
							   --            |ack|  sens ad  |    temp   |
							   if G_EVNT_NUM(0) = '0' then
							     --            TS               CHAIN            3 bit sens add + 8 bit temp
					             temp_field := REGS.TEMPA(13) & '0'            & REGS.TEMPA(12 downto 2);  -- evento pari    catena A
							   else
					             temp_field := REGS.TEMPB(13) & REGS.TEMPB(13) & REGS.TEMPB(12 downto 2);  -- evento dispari catena B
							   end if;
							   if chaina_evnt_word = conv_std_logic_vector(0,chaina_evnt_word'length) then -- non sono arrivati dati dalla catena A (neppure HEADER/TRAILER) -> la catena è disabilitata (CHAINA_EN = 0)
							     chaina_dis := '1';
							   end if;
							   if chainb_evnt_word = conv_std_logic_vector(0,chainb_evnt_word'length) then -- non sono arrivati dati dalla catena B (neppure HEADER/TRAILER) -> la catena è disabilitata (CHAINB_EN = 0) 
							     chainb_dis := '1';
							   end if;							   
                               if WPH = '0' then    -- ho scritto la memoria ODD, devo scrivere la EVEN
    						     data_to_write := G_TRAIL & L_LUT & temp_field & crc & chainb_dis & chaina_dis;
                                 DTE  <= data_to_write;
								 pippolo <= '1';
	                             WREi <= '0';
                               else                 -- ho scritto la memoria EVEN, devo scrivere la ODD
    						     data_to_write := G_TRAIL & L_LUT & temp_field & crc & chainb_dis & chaina_dis;
                                 DTO  <= data_to_write;
								 pippolo <= '1';
                                 WROi <= '0';
                               end if;
                             else
                               ENDF <= '1';
                             end if;
                           else
                             ENDF    <= '0';
                             if WR_SRAM = '0' then
                               if PHASE = WPH then    -- La fase di scrittura è giusta
                                 if WPH = '0' then    -- ho scritto la memoria ODD, devo scrivere la EVEN
								   data_to_write := DT_SRAM;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |								   

WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1'then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   
                                   DTE     <= data_to_write;
                                   WREi    <= '0';
                                   CRC32   <= CRC32 xor DT_SRAM;
--                                   WOFFSET <= WOFFSET + 1;
                                   STATE2  <= S2_WRE;
                                 else                 -- ho scritto la memoria EVEN, devo scrivere la ODD
								   data_to_write := DT_SRAM;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |								   

WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   
                                   DTO     <= data_to_write;
                                   WROi    <= '0';
                                   CRC32   <= CRC32 xor DT_SRAM;
--                                   WOFFSET <= WOFFSET + 1;
                                   STATE2  <= S2_WRO;
                                 end if;
                               else                   -- La fase di scrittura non è giusta: scrivo il dato nella pipe
                                 DT_TEMP <= DT_SRAM;
                                 TEMPF   <= '1';
                                 STATE2  <= S2_TEMP;
                               end if;
                             end if;
                           end if;

        -- scrittura nella SRAM EVEN
        when S2_WRE    =>  ENDF <= '0';
                           WREi <= '1';
                           DTE  <= (others => 'Z');
                           if END_EVNT = '1' or ENDF = '1' then -- la FSM1 ha terminato di rileggere un evento dagli HPTDC
                             STATE2  <= S2_WTRAILER;
                             crc        := (("0000" & CRC32(31 downto 24)) xor CRC32(23 downto 12) xor CRC32(11 downto 0));
							 if G_EVNT_NUM(0) = '0' then
							   --            TS               CHAIN            3 bit sens add + 8 bit temp
					           temp_field := REGS.TEMPA(13) & '0'            & REGS.TEMPA(12 downto 2);
							 else
					           temp_field := REGS.TEMPB(13) & REGS.TEMPB(13) & REGS.TEMPB(12 downto 2);
							 end if;
							 if chaina_evnt_word = conv_std_logic_vector(0,chaina_evnt_word'length) then -- non sono arrivati dati dalla catena A (neppure HEADER/TRAILER) -> la catena è disabilitata (CHAINA_EN = 0)
							   chaina_dis := '1';                                                                                                                                                     
							 end if;                                                                                                                                                                    
							 if chainb_evnt_word = conv_std_logic_vector(0,chainb_evnt_word'length) then -- non sono arrivati dati dalla catena B (neppure HEADER/TRAILER) -> la catena è disabilitata (CHAINB_EN = 0) 
							   chainb_dis := '1';
							 end if;							   
							 data_to_write := G_TRAIL & L_LUT & temp_field & crc & chainb_dis & chaina_dis;
							 pippolo <= '1';
                             DTO     <= data_to_write;
                             WROi    <= '0';
                             EVNT_WORD <= WOFFSET + 1;
                             WOFFSET <= (others => '0');
                           else
                             if TEMPF = '1' then    -- devo scrivere il dato che si trova nella PIPE
							   data_to_write := DT_TEMP;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |
								   
WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   

                               DTO     <= data_to_write;
                               WROi    <= '0';
                               CRC32   <= CRC32 xor DT_TEMP;
--                               WOFFSET <= WOFFSET + 1;
                               STATE2  <= S2_WRO;
                               if WR_SRAM = '0' then
                                 DT_TEMP <= DT_SRAM;
                                 TEMPF   <= '1';
                               else
                                 DT_TEMP <= (others => '0');
                                 TEMPF   <= '0';
                               end if;
                             elsif WR_SRAM = '0' then
							   data_to_write := DT_SRAM;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |
								   
WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   
                               DTO     <= data_to_write;
                               WROi    <= '0';
                               CRC32   <= CRC32 xor DT_SRAM;
--                               WOFFSET <= WOFFSET + 1;
                               STATE2  <= S2_WRO;
                             else
                               STATE2 <= S2_IDLE;
                               DTE    <= (others => 'Z');
                               DTO    <= (others => 'Z');
                               WREi   <= '1';
                               WROi   <= '1';
                             end if;
                           end if;

        -- scrittura nella SRAM ODD
        when S2_WRO    =>  ENDF <= '0';
                           WROi <= '1';
                           DTO  <= (others => 'Z');
                           if END_EVNT = '1' or ENDF = '1' then -- la FSM1 ha terminato di rileggere un evento dagli HPTDC
                             STATE2  <= S2_WTRAILER;
                             crc        := (("0000" & CRC32(31 downto 24)) xor CRC32(23 downto 12) xor CRC32(11 downto 0));
							 if G_EVNT_NUM(0) = '0' then
							   --            TS               CHAIN            3 bit sens add + 8 bit temp
					           temp_field := REGS.TEMPA(13) & '0'            & REGS.TEMPA(12 downto 2);
							 else
					           temp_field := REGS.TEMPB(13) & REGS.TEMPB(13) & REGS.TEMPB(12 downto 2);
							 end if;
							 if chaina_evnt_word = conv_std_logic_vector(0,chaina_evnt_word'length) then -- non sono arrivati dati dalla catena A (neppure HEADER/TRAILER) -> la catena è disabilitata (CHAINA_EN = 0)
							   chaina_dis := '1';                                                                                                                                                    
							 end if;                                                                                                                                                                   
							 if chainb_evnt_word = conv_std_logic_vector(0,chainb_evnt_word'length) then -- non sono arrivati dati dalla catena B (neppure HEADER/TRAILER) -> la catena è disabilitata (CHAINB_EN = 0)  
							   chainb_dis := '1';
							 end if;							   							 
  						     data_to_write := G_TRAIL & L_LUT & temp_field & crc & chainb_dis & chaina_dis;
                             DTE     <= data_to_write;
                             WREi    <= '0';
								 pippolo <= '1';							 
                             EVNT_WORD <= WOFFSET + 1;
                             WOFFSET <= (others => '0');
                           else
                             if TEMPF = '1' then    -- devo scrivere il dato che si trova nella PIPE
							   data_to_write := DT_TEMP;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |
								   
WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   
                               DTE     <= data_to_write;
                               WREi    <= '0';
                               CRC32   <= CRC32 xor DT_TEMP;
--                               WOFFSET <= WOFFSET + 1;
                               STATE2  <= S2_WRE;
                               if WR_SRAM = '0' then
                                 DT_TEMP <= DT_SRAM;
                                 TEMPF   <= '1';
                               else
                                 DT_TEMP <= (others => '0');
                                 TEMPF   <= '0';
                               end if;
                             elsif WR_SRAM = '0' then
							   data_to_write := DT_SRAM;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |
								   
WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   

                               DTE     <= data_to_write;
                               WREi    <= '0';
                               CRC32   <= CRC32 xor DT_SRAM;
--                               WOFFSET <= WOFFSET + 1;
                               STATE2  <= S2_WRE;
                             else
                               STATE2 <= S2_IDLE;
                               DTE    <= (others => 'Z');
                               DTO    <= (others => 'Z');
                               WREi   <= '1';
                               WROi   <= '1';
                             end if;
                           end if;

        -- scrittura del dato nella PIPE in attesa che la fase di scrittura sia corretta
        when S2_TEMP   =>  if WR_SRAM = '0' then
                             DT_TEMP <= DT_SRAM;
                             TEMPF   <= '1';
                           else
                             DT_TEMP <= (others => '0');
                             TEMPF   <= '0';
                           end if;
                           if WPH = '0' then
  						     data_to_write := DT_TEMP;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |
								   
WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   
                             DTE     <= data_to_write;
                             WREi    <= '0';
                             CRC32   <= CRC32 xor DT_TEMP;
--                             WOFFSET <= WOFFSET + 1;
                             STATE2  <= S2_WRE;
                           else
						     data_to_write := DT_TEMP;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |
								   
WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   
                             DTO     <= data_to_write;
                             WROi    <= '0';
                             CRC32   <= CRC32 xor DT_TEMP;
--                             WOFFSET <= WOFFSET + 1;
                             STATE2  <= S2_WRO;
                           end if;
                           if END_EVNT = '1' then  -- se arriva END_EVNT lo devo memorizzare perché devo prima scrivere
                             ENDF <= '1';          -- il dato che ho nella PIPE
                           end if;

        -- scrittura del Global Trailer:
        when S2_WTRAILER=> DTO     <= (others => 'Z');
                           WROi    <= '1';
                           DTE     <= (others => 'Z');
                           WREi    <= '1';
                           if PHASE = '0' then
                             WPAGE   <= WPAGE + 1;       -- devo anticipare il reset dei puntatori di scrittura perchè gli
                             WOFFSET <= "0000000000001"; -- ADE/ADO sono pronti con un ritardo di 1 ciclo di clock
                             INC_EVNT_NUM <= '1';
						     STATE2  <= S2_WHEADER;
							 chaina_evnt_word := (others => '0');
							 chainb_evnt_word := (others => '0');
							 chaina_dis := '0';
							 chainb_dis := '0';
							 chaina_empty := '0';
							 chainb_empty := '0';
                             -- preparo la global header							 
                             data_to_write := G_HEAD & EMPTY_EV & G_EVNT_NUM(9 downto 0) & EVNT_WORD(12 downto 0) & not GA(3 downto 0);
                             DTE           <= data_to_write;
                             WREi          <= '0';
                           end if;

        -- scrittura della Global header
        when S2_WHEADER=>  INC_EVNT_NUM <= '0';
		                   CRC32  <= (others => '0');
                           if WR_SRAM = '0' then               -- già pronto primo dato di un evento in coda
							 data_to_write := DT_SRAM;
--             |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
--              _______________________________________________________________________________________________
-- LOC. TRAILER| 0001/0011 |        EVENT COUNTER              |          chain_evnt_word          |  STATUS   |
-- nota: qui in realtà possono arrivare solo header di catena								   

WOFFSET <= WOFFSET + 1;

--case data_to_write(31 downto 28) is
--  when HEAD_A  => chaina_data := '1';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--  when HEAD_B  => chainb_data := '1';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--  when TRAIL_A => chaina_data := '0';
--                  chaina_evnt_word := chaina_evnt_word + 1;
--                  if chaina_evnt_word = conv_std_logic_vector(2,chaina_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chaina_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chaina_evnt_word;
--				  end if;
--  when TRAIL_B => chainb_data := '0';
--                  chainb_evnt_word := chainb_evnt_word + 1;
--                  if chainb_evnt_word = conv_std_logic_vector(2,chainb_evnt_word'length) and REGS.CONTROL(C_CH_EMPTY_DIS) = '1' then  -- non sono arrivati HIT dalla catena ma non è disabilitata
--                    chainb_empty := '1';				  
--                    WOFFSET <= WOFFSET - 1;
--                  else
--				    data_to_write(15 downto 4) := chainb_evnt_word;
--				  end if;
--  when others  => if chaina_data = '1' then 
--                    chaina_evnt_word := chaina_evnt_word + 1;
--                  elsif chainb_data = '1' then 
--                    chainb_evnt_word := chainb_evnt_word + 1;
--                  end if;
--end case;									 								   
                             DTO     <= data_to_write;
                             WROi    <= '0';
                             CRC32   <= CRC32 xor DT_SRAM;
--                             WOFFSET <= WOFFSET + 1;
                             DTE     <= (others => 'Z');
                             WREi    <= '1';
                             STATE2  <= S2_WRO;
                           else
                             DTE    <= (others => 'Z');
                             DTO    <= (others => 'Z');
                             WREi   <= '1';
                             WROi   <= '1';
                             STATE2 <= S2_IDLE;
                           end if;
      end case;
    end if;
  end process;

  ---------------------------------------------------------------------
  -- istanziazione della PLL per CLK_sram a frequenza doppia rispetto a CLK,
  -- per generare i segnali di scrittura nelle SRAM di staging
  PLL_sram_del: PLL_sram
    port map
      (GLB    =>  CLK_sram,
       LOCK   =>  PLL_LOCK_sram,
       CLK    =>  CLK
      );

  --                _____       _____
  -- CLK         __|     |_____|     |_____
  --                __    __    __    __
  -- CLK_sram    __|  |__|  |__|  |__|  |__
  --             __             ___________
  -- WRE/O         |___________|
  --             _____       ______________
  -- NWRSRAME/O       |_____|
  --

  process(CLEAR_STAT,CLK_sram)
  begin
    if CLEAR_STAT = '0' then
      NWRSRAMEi <= '1';
      NWRSRAMOi <= '1';
    elsif CLK_sram'event and CLK_sram = '0' then

      if WREi = '0' and NWRSRAMEi = '1' then
        NWRSRAMEi <= '0';
      else
        NWRSRAMEi <= '1';
      end if;

      if WROi = '0' and NWRSRAMOi = '1' then
        NWRSRAMOi <= '0';
      else
        NWRSRAMOi <= '1';
      end if;

    end if;
  end process;

  NWRSRAME <= NWRSRAMEi;
  NWRSRAMO <= NWRSRAMOi;



  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM PER LA LETTURA DELLE SRAM E LA SCRITTURA NELLA FIFO DI SECONDO LIVELLO
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- PUNTATORI LETTURA NELLE SRAM
  -- Il bit meno significativo di ROFFSET determina da quale memoria devo leggere (0= ODD, 1=EVEN).
  RDPNT <= RPAGE & ROFFSET(ROFFSET'high downto 1);

  process(HWRES,CLK)
  begin
    if HWRES = '0' then
      FIFO_FULL <= '0';
    elsif CLK'event and CLK = '1' then
      FIFO_FULL <= not PAF;
    end if;
  end process;

  -- shift register che memorizza l'arrivo dei trigger di secondo livello
  -- in L2TYPE memorizzo il tipo di trigger che è arrivato (0=L2A, 1=L2R)
  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      L2TYPE  <= (others => '0');
      L2ARR   <= "0000";
    elsif CLK'event and CLK = '1' then
      if L2AS = '1' or L2RS = '1' then
        if L2AS = '1' then
          L2TYPE(conv_integer(L2ARR)) <= '0';
        else
          L2TYPE(conv_integer(L2ARR)) <= '1';
        end if;
        L2ARR <= L2ARR + 1;
      end if;
    end if;
  end process;

  -- sincronizzazione di DTE/DTO per ridurre l'input to register time
  process(CLK,CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      DTES <= (others => '0');
      DTOS <= (others => '0');
    elsif CLK'event and CLK = '1' then
      DTES <= DTE;
      DTOS <= DTO;
    end if;
  end process;


  -- La FSM rilegge le SRAM e scrive nella FIFO:
  -- se TRG_EN[1:0]="00" rilegge non appena ci sono dati nelle SRAM.
  -- se TRG_EN[1:0]="01" attende un trigger di secondo livello: se arriva L2A rilegge una pagina della SRAM
  -- e la scrive nella FIFO, se arriva L2R incrementa solo l'indirizzo di pagina di lettura.
  NWEN <= NWEN_i;
  
  U_sram_read_fsm : process(CLK, CLEAR_STAT)
  begin
    if CLEAR_STAT ='0' then

      STATE3  <= S3_STRT;

      NWEN_i    <= '1';
      NLD     <= '1';
      NMRSFIF <= '0';
      NPRSFIF <= '0';
      FID     <= (others => '0');
      STOP_RDSRAM   <= '0';
      FIFO_END_EVNT <= '0';
      EVNT_REJ      <= '0';

      RPAGE   <= (others => '0');
      ROFFSET <= (others => '0');

      L2SERV  <= "0000";

      DTEST_FIFO <= '0';

    elsif CLK'event and CLK='1' then
      case STATE3 is
        when S3_STRT     => NMRSFIF <= '0';
                            NPRSFIF <= '0';
                            NLD     <= '0';
                            STATE3  <= S3_SETUP;

        -- PROGRAMMAZIONE DELLA FIFO ----------------------------------------
        -- tempo di setup prima di resettare la FIFO
        when S3_SETUP    => STATE3  <= S3_RESFSM1;

        -- reset della FIFO
        when S3_RESFSM1  => STATE3  <= S3_RESFSM2;

        when S3_RESFSM2  => NMRSFIF <= '1';
                            NPRSFIF <= '1';
                            STATE3  <= S3_PRGFIF1;

        -- Scrive empty offset
        -- il PAE lev n si setta a ALMOST FULL - 2 perchè se la FIFO è
        -- programmata in modalità FWFT mode /PAE va LOW quando nella FIFO
        -- c'è un numero di word<=n+1
        when S3_PRGFIF1  => FID     <= "00000000000000000000000000111110"; -- PAE lev (almost full-2 = 64-2)
                            NWEN_i    <= '0';
                            STATE3  <= S3_PRGFIF2;

        -- Scrive full offset
        when S3_PRGFIF2  => FID     <= "00000000000000000000000000100010"; -- PAF lev (34-2)
                            NWEN_i    <= '0';
                            STATE3  <= S3_IDLE;

        ---------------------------------------------------------------------
        when S3_IDLE     => DTEST_FIFO <= '0';
                            NLD     <= '1';
                            NMRSFIF <= '1';
                            NPRSFIF <= '1';
                            NWEN_i    <= '1';
                            FIFO_END_EVNT <= '0';
                            EVNT_REJ      <= '0';
                            if (REGS.CONTROL(C_TST_FIFO) = '1') then
                              STATE3 <= S3_TESTFIFO;  -- vado in modalità TEST FIFO
                            else
                              -- rileggo se la SRAM non è EMPTY e la FIFO non è FULL
                              -- Se TRG_EN(1:0) = "00" rileggo sempre
                              -- Se TRG_EN(1:0) = "01" controllo se ci sono L2A o L2R da servire
                              if SRAM_EMPTY = '0' and FIFO_FULL = '0' then
                                if (REGS.CONTROL(C_TRG_EN1 downto C_TRG_EN0) = "00") then
                                  if PHASE = '1' then   -- aspetto che la prossima fase sia EVEN e poi comincio a leggere
                                    ROFFSET <= ROFFSET + 1;
                                    STATE3  <= S3_WAITRDE;
                                  end if;
                                elsif (REGS.CONTROL(C_TRG_EN1 downto C_TRG_EN0) = "01" and L2ARR/=L2SERV) then
                                  if L2TYPE(conv_integer(L2SERV)) = '0' then -- devo servire un L2A
                                    if PHASE = '1' then -- aspetto che la prossima fase sia EVEN e poi comincio a leggere
                                      ROFFSET <= ROFFSET + 1;
                                      STATE3  <= S3_WAITRDE;
                                    end if;                                  -- devo servire un L2R
                                  else
                                    RPAGE   <= RPAGE + 1;
                                    L2SERV  <= L2SERV + 1;
                                    EVNT_REJ<= '1';
                                  end if;
                                end if;
                              end if;
                            end if;

         when S3_WAITRDE => ROFFSET <= ROFFSET + 1;
                            STATE3  <= S3_RDE;

         when S3_RDE     => FID  <= DTES;
                            NWEN_i <= '0';
                            if STOP_RDSRAM = '0' then
                              if glob_trail(DTES) then  -- rileggo le SRAM finché non trovo il Global Trailer
                                RPAGE   <= RPAGE + 1;
                                L2SERV  <= L2SERV + 1;
                                FIFO_END_EVNT <= '1';
                                ROFFSET <= (others => '0');
                                STATE3  <= S3_IDLE;
                              else
                                if FIFO_FULL = '1' then
                                  STOP_RDSRAM <= '1';
                                else
                                  ROFFSET <= ROFFSET + 1;
                                end if;
                                STATE3  <= S3_RDO;
                              end if;
                            else
                              NWEN_i    <= '1';
                              STATE3  <= S3_RDEFULL;
                            end if;

         when S3_RDO     => FID  <= DTOS;
                            NWEN_i <= '0';
                            if glob_trail(DTOS) then  -- rileggo le SRAM finché non trovo il Global Trailer
                              RPAGE   <= RPAGE + 1;
                              L2SERV  <= L2SERV + 1;
                              FIFO_END_EVNT <= '1';
                              ROFFSET <= (others => '0');
                              STOP_RDSRAM <= '0';
                              STATE3  <= S3_IDLE;
                            else
                              if STOP_RDSRAM = '0' then
                                ROFFSET <= ROFFSET + 1;
                              end if;
                              STATE3 <= S3_RDE;
                            end if;

         when S3_RDEFULL => STOP_RDSRAM <= '0';
                            if FIFO_FULL = '0' then -- aspetto che la fifo esca dal full
                              if PHASE = '1' then   -- aspetto che la prossima fase sia EVEN e poi comincio a leggere
                                ROFFSET <= ROFFSET + 1;
                                STATE3  <= S3_RDOFULL;
                              end if;
                            end if;

         when S3_RDOFULL =>  ROFFSET <= ROFFSET + 1;
                             STATE3  <= S3_RDE;


        -- MODALITA' DI TEST DELLA FIFO -------------------------------------

        -- Aspetta la scrittura nel registro TESTREG
        when S3_TESTFIFO => if PULSE(WP_FIFO) = '1' then
                              FID        <= REGS.TESTREG;
                              NWEN_i       <= '0';
                              STATE3     <= S3_TESTFIFO1;
                            end if;

        when S3_TESTFIFO1=> NWEN_i       <= '1';
                            DTEST_FIFO <= '1';
                            STATE3     <= S3_IDLE;
      end case;
    end if;
  end process;

  FID_P <= '0';

  -- ******************************************************************
  -- Event ready e Event Store
  -- ******************************************************************
  -- EVRDY dice se c'è almeno un evento intero in memoria; il
  -- contatore EVNT_STOR viene incrementato quando è stato scritto un evento e
  -- decrementato quando ne è stato letto uno (EVREAD da vinterf.).
  -- EVNT_STOR quindi contiene il numero di eventi nella FIFO
  process (CLEAR_STAT,CLK)
  begin
    if CLEAR_STAT = '0' then
      REGS.EVNT_STOR <= (others => '0');
      EVRDYi <= '0';
    else
      if CLK'event and CLK = '1' then
        if EVREAD = '1' and FIFO_END_EVNT = '0' then
          REGS.EVNT_STOR <= REGS.EVNT_STOR - 1; -- lettura di un evento
          if REGS.EVNT_STOR = "0000000000000001" then
            EVRDYi <= '0';
          end if;
        elsif EVREAD = '0' and FIFO_END_EVNT = '1' then
          REGS.EVNT_STOR <= REGS.EVNT_STOR + 1; -- scrittura di un evento
          EVRDYi <= '1';
        else
          REGS.EVNT_STOR <= REGS.EVNT_STOR;
        end if;
      end if;
    end if;

  end process;


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM per la gestione degli errori delle catene
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- Sincronizzazione dei segnali di errore per la FSMe (INT_ERR da I2C e
  -- CHAIN_ERR da uC).
  -- I segnali di errore sono sentiti solo se la catena è abilitata da software
  -- (REGS.STATUS(S_CHAINA/B_EN) = 1) e se non sono nello stato di clear.
  -- Gli INT_ERR in ingresso sono attivi bassi, dentro l'FPGA li uso attivi alti
  process (CLEAR_STAT,CLK)
  begin
    if CLEAR_STAT = '0' then

      INT_ERRAF1  <= '0';
      INT_ERRAS   <= '0';
      CHAINA_ERRF1<= '0';
      CHAINA_ERRS <= '0';

      INT_ERRBF1  <= '0';
      INT_ERRBS   <= '0';
      CHAINB_ERRF1<= '0';
      CHAINB_ERRS <= '0';

    elsif (CLK'event  and  CLK = '1') then

      if REGS.STATUS(S_CHAINA_EN) = '1' then
        INT_ERRAF1  <= not INT_ERRA;
        INT_ERRAS   <= INT_ERRAF1;
        CHAINA_ERRF1<= CHAINA_ERR;
        CHAINA_ERRS <= CHAINA_ERRF1;
      end if;

      if REGS.STATUS(S_CHAINB_EN) = '1' then
        INT_ERRBF1  <= not INT_ERRB;
        INT_ERRBS   <= INT_ERRBF1;
        CHAINB_ERRF1<= CHAINB_ERR;
        CHAINB_ERRS <= CHAINB_ERRF1;
      end if;

    end if;
  end process;

  INT_ERRS   <= INT_ERRAS   or INT_ERRBS or TOKENA_TIMOUT or TOKENB_TIMOUT;
  CHAIN_ERRS <= CHAINA_ERRS or CHAINB_ERRS;

  ---------------------------------------------------------------------
  -- se una delle due catene va in errore vengono comunque disabilitate
  -- dal readout entrambe le catene
  U_error_fsm : process(CLK, CLEAR_STAT)
  begin
    if CLEAR_STAT = '0' then
      CHAIN_RDY    <= '1';
      TDC_RES_ERR  <= '0';  -- non usato
      STATEe       <= Se_WAIT;
    elsif CLK'event and CLK = '1' then
      case STATEe is

        -- Aspetto INT_ERR = '1' da I2C o CHAIN_ERR = '1' da micro.
        -- INT_ERR potrebbe durare meno di un ciclo di clock: in questo caso
        -- devo comunque sentire CHAIN_ERR.
        -- Un upset su INT_ERR disabilita le catene dal readout per sempre.
        -- Un upset su CHAIN_ERR non disabilita le catene dal readout:
        -- le disabilito solo se CHAIN_ERR dura più di 1 ciclo di clock
        -- (stato Se_MICRO_ERR_UPS).
        when Se_WAIT          => TDC_RES_ERR <= '0';
                                 if INT_ERRS = '1' then
                                   CHAIN_RDY <= '0';
                                   STATEe    <= Se_I2C_ERR;
                                 elsif CHAIN_ERRS = '1' then
                                   STATEe    <= Se_MICRO_ERR_UPS;
                                 end if;

        -- aspetto CHAIN_ERRS = '1' da micro
        when Se_I2C_ERR       => if CHAIN_ERRS = '1' then
                                   STATEe <= Se_MICRO_ERR;
                                 end if;

        -- disabilito le catene solo se CHAIN_ERRS dura più di 1 ciclo di clock
        when Se_MICRO_ERR_UPS => if CHAIN_ERRS = '1' then
                                   CHAIN_RDY <= '0';
                                   STATEe    <= Se_MICRO_ERR;
                                 end if;


        -- aspetto CHAIN_ERRS = '0' da micro: il uC ha risolto l'errore
        -- Se il micro non risolve l'errore mi fermo qui per sempre
        -- e le catene non si riabilitano più: il SW se ne accorge
        -- perché rilegge sempre eventi vuoti
        when Se_MICRO_ERR     => if CHAIN_ERRS = '0' then
                                   if INT_ERRS = '1' then
                                     CHAIN_RDY <= '0';
                                     STATEe    <= Se_I2C_ERR;
                                   else
                                     CHAIN_RDY <= '1';
                                     STATEe    <= Se_READY;
                                   end if;
                                 end if;

        -- aspetto il primo BNC_RES_E per poter riabilitare la catena
        when Se_READY         => if INT_ERRS = '1' then
                                   CHAIN_RDY <= '0';
                                   STATEe    <= Se_I2C_ERR;
                                 else
                                   if BNC_RES_E = '1' then
                                     TDC_RES_ERR <= '1';
                                     STATEe      <= Se_WAIT;
                                   end if;
                                 end if;
      end case;
    end if;
  end process;

  ---------------------------------------------------------------------
  -- Chain disable: nel caso di errore le catene vengono entrambe disabilitate
  -- Quando il uC ha risolto l'errore, vengono riabilitate
  -- al primo BNC_RES. Al reset le catene sono abilitate.

  process (CLK, CLEAR_STAT,BNC_RES_E,CHAIN_RDY)
  begin
    if CLEAR_STAT = '0' then
      CHAIN_ERR_DIS <= '0';
    elsif CLK'event and CLK = '1' then
      if INT_ERRS = '1' or CHAIN_ERRS = '1' then
        CHAIN_ERR_DIS <= '1';
      elsif BNC_RES_E = '1' and CHAIN_RDY = '1' then
        CHAIN_ERR_DIS <= '0';
      end if;
    end if;
  end process;

  -- TDCs chains enable: enable dei 244 per la gestione delle 2 catene
  -- di TDC (attivi bassi): i 244 sono disabilitati nel caso sia stato
  -- comunicata da uC la disabilitazione di una catena o nel caso di
  -- errore di una catena (in questo caso sono disabilitati entrambi).
  -- CHAINA_EN e CHAINB_EN vanno alla FSM1
  CHAINA_EN <= (REGS.STATUS(S_CHAINA_EN) and not CHAIN_ERR_DIS);
  CHAINB_EN <= (REGS.STATUS(S_CHAINB_EN) and not CHAIN_ERR_DIS);

  EMPTY_EV  <= not CHAINA_EN and not CHAINB_EN; -- bit scritto nella HEADER Globale

  CHAINA_EN244 <= not CHAINA_EN;
  CHAINB_EN244 <= not CHAINB_EN;


  -- ##################################################################
  -- STATO DELLA TRM
  -- ##################################################################
  -- Bit del registro di stato:

  REGS.STATUS(S_FULL)      <= MEM_FULL;    -- bit 1
  REGS.STATUS(S_RES0)      <= SRAM_FULL;    -- bit 14
  REGS.STATUS(S_RES1)      <= FIFO_FULL;    -- bit 15

  REGS.STATUS(S_TRG_MATCH) <= MIC_REGS(0); -- bit 3

  -- bit di abilitazione delle catene comunicati via seriale dal uC
  -- (MIC_REGS). Se una catena è disabilitata la FSM1 non fa giri di token
  -- su quella catena. Anche i 244 sono disabilitati.
  -- Al reset le catene sono disabilitate e lo rimangono fino alla comunicazione da uC.
  REGS.STATUS(S_CHAINA_EN) <= MIC_REGS(1); -- bit 4
  REGS.STATUS(S_CHAINB_EN) <= MIC_REGS(2); -- bit 5

  REGS.STATUS(S_CHAINA_BP) <= MIC_REGS(4); -- bit 6
  REGS.STATUS(S_CHAINB_BP) <= MIC_REGS(5); -- bit 7

  REGS.STATUS(S_RAW_DATA)  <= MIC_REGS(3); -- bit 8

  REGS.STATUS(S_CHAIN_ERR_DIS)  <= CHAIN_ERR_DIS;  -- bit 10

  REGS.STATUS(S_LEADING)   <= MIC_REGS(6); -- bit 12
  REGS.STATUS(S_TRAILING)  <= MIC_REGS(7); -- bit 13


  MEM_FULL         <= SRAM_FULL or FIFO_FULL;
  EVRDY            <= EVRDYi;

  TRM_DRDY         <= EVRDYi;
  TRM_BUSY         <= not MEM_FULL;

  -------------------------------------------
  -- debugging section
  -------------------------------------------
  SP0 <= pippolo;
  SP1 <= END_EVNT;
  SP2 <= WR_SRAM;
  SP3 <= WREi;
  SP4 <= WROi;
  SP5 <= NWEN_i;

  
END RTL;
