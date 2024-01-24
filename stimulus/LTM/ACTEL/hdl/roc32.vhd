-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - TRM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            06/12/05
-- --------------------------------------------------------------------------
-- Module:          ROC32
-- Description:     RTL module: Readout Controller
-- **************************************************************************

-- ##########################################################################
-- Revision History:
--    LCOL  15/01/08 Corretto indirizzamento ADC per la rilettura di VLV12 e
--                   VLV13.
--    LCOL  16/06/08 Rimossi BNCRES_CNT e BNC_NUMBER. Tolto BNC_NUMBER da header.
--                   BNC_NUMBER non era previsto dalle specifiche del formato
--                   di evento ed era inserito solo per debug.
-- ##########################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1392pkg.all;

ENTITY ROC32 IS
  generic(
       SimCfg_NoADCEvent : boolean := FALSE
       );
  port (
       CLK       : IN    std_logic; -- LOCAL CLOCK
       ACLK      : IN    std_logic; -- ALICE CLOCK

       HWRES     : IN    std_logic;
       CLEAR     : IN    std_logic;
       GA        : IN    std_logic_vector ( 3 downto 0);

       -- Signals from/to P2
       L0        : IN    std_logic; -- level 0 trigger
       L1A       : IN    std_logic; -- level 1 trigger, accept
       L1R       : IN    std_logic; -- level 1 trigger, reject
       L2A       : IN    std_logic; -- level 2 trigger, accept
       L2R       : IN    std_logic; -- level 2 trigger, reject
       BNC_RES   : IN    std_logic; -- BNC Reset (sincrono con CLK)

       -- Pulse from DRM
       SPULSE0   : IN    std_logic;
       SPULSE1   : IN    std_logic;
       SPULSE2   : IN    std_logic;

       LTM_DRDY  : OUT   std_logic; -- LTM data ready = Event ready
       LTM_BUSY  : OUT   std_logic; -- LTM busy       = Mem Full

       -- Segnali da I2C Controller
       I2C_RDATA  : IN   std_logic_vector(9 downto 0);
       I2C_RREQ   : OUT  std_logic;
       I2C_RACK   : IN   std_logic;
       I2C_CHAIN  : OUT  std_logic;
       CHIP_ADDR  : OUT  std_logic_vector(2 downto 0);
       CHANNEL    : OUT  std_logic_vector(2 downto 0);


       -- Segnali da PDL Controller
       PDL_RDATA   : IN   std_logic_vector(7 downto 0);
       PDL_RADDR   : OUT  std_logic_vector(5 downto 0);
       PDL_RREQ    : OUT  std_logic;
       PDL_RACK    : IN   std_logic;

       -- Segnali da OR RATE Controller
       OR_RDATA    : IN   std_logic_vector(9 downto 0);
       OR_RADDR    : OUT  std_logic_vector(5 downto 0);
       OR_RREQ     : OUT  std_logic;
       OR_RACK     : IN   std_logic;

       -- DAC Periodic update
       DAC_REFRESH : OUT    std_logic; -- Enable refresh from CRAM (active high)

       -- Interfaccia micro per lettura status
       PSM_SP0     : IN  std_logic;
       PSM_SP1     : IN  std_logic;
       PSM_SP2     : IN  std_logic;
       PSM_SP3     : IN  std_logic;  -- Used as Cyclone configuration status flag
       PSM_SP4     : IN  std_logic;  -- Used as Supply Fault flag (0 = accensione normale;
                                     ---      1 = accensione dopo un partial fault)
       PSM_SP5     : IN  std_logic;  -- Usato come Supply Fault Status

       -- Interfaccia lettura MEB (Multi Event Buffer)
       DPR       : OUT   std_logic_vector (31 downto 0);
       DPR_P     : OUT   std_logic_vector ( 3 downto 0);
       NRDMEB    : IN    std_logic;  -- read MEB
       PAF       : OUT   std_logic;
       PAE       : OUT   std_logic;
       EF        : OUT   std_logic;
       FF        : OUT   std_logic;

       EVRDY     : OUT   std_logic; -- almeno un evento pronto nel MEB
       EVREAD    : IN    std_logic;  -- segnala che � stato riletto un evento dal MEB

       -- DEBUG
       TRIGLED   : OUT   std_logic; -- Trigger LED driver
       DEBUG     : INOUT debug_stream;
       DTEST_FIFO: OUT   std_logic; -- segnala che � stato scrito un dato di test nella FIFO

       REG       : INOUT reg_stream;
       TICK      : IN    tick_pulses;
       PULSE     : IN    reg_pulse
       );

END ROC32 ;

ARCHITECTURE RTL OF ROC32 IS

  -- segnali per la gestione del TRIGGER e la rilettura dell'evento
  signal L2ASS      : std_logic; -- level 2 trigger accept lungo (almeno 3 cicli) e sincrono con CLK

  signal L1AS      : std_logic; -- level 1 trigger accept lungo (almeno 3 cicli)
  signal L2AS      : std_logic; -- level 2 trigger accept lungo (almeno 3 cicli)
  signal L2RS      : std_logic; -- level 2 trigger reject lungo (almeno 3 cicli)

  signal L1AF1     : std_logic; -- level 1 trigger accept, primo FF di sincronizzazione
  signal L2AF1     : std_logic; -- level 2 trigger accept, primo FF di sincronizzazione
  signal L2RF1     : std_logic; -- level 2 trigger reject, primo FF di sincronizzazione

  signal L1AF2     : std_logic; -- level 1 trigger accept, primo FF di sincronizzazione
  signal L2AF2     : std_logic; -- level 2 trigger accept, primo FF di sincronizzazione
  signal L2RF2     : std_logic; -- level 2 trigger reject, primo FF di sincronizzazione

  signal L1AF3     : std_logic; -- level 1 trigger accept, primo FF di sincronizzazione
  signal L2AF3     : std_logic; -- level 2 trigger accept, primo FF di sincronizzazione
  signal L2RF3     : std_logic; -- level 2 trigger reject, primo FF di sincronizzazione

  signal LTM_TRIGGER   : std_logic; -- Trigger
  signal TRIGGER_sync  : std_logic; -- Trigger sincronizzato
  signal EVNT_TRG      : std_logic; -- Impulso della durata di 1 coclo di CLK quando si raggiunge la condizione di trigger

  -- segnali per il Bunch Reset
  signal BNC_CNT    : std_logic_vector(31 downto 0);-- Contatore per il Bunch Reset
  signal BNC_LIMIT    : std_logic;
  signal BNC_LIMIT_r  : std_logic;
  signal BNC_LIMIT_stretched  : std_logic;

  signal BNCRES_CNT : std_logic_vector( 8 downto 0); -- Contatore di Bounce Reset
  signal BNC_NUMBER : std_logic_vector( 8 downto 0); -- Numero di Bounce Reset tra un trigger e l'altro


  signal EVNT_NUM   : std_logic_vector(11 downto 0);-- event number scritto nelle parole di formattazione di catena


  signal CRC32      : std_logic_vector(31 downto 0);    -- CRC dei dati dell'evento, su 31 bit (XOR bit a bit
                                                        -- di tutti i dati, esclusa la Header e il Trailer globali)
  signal EVRDYi     : std_logic;

  signal EVENT_DWORD : std_logic_vector(31 downto 0);
  signal CNT         : std_logic_vector(5 downto 0);    -- Conta le richieste di letture
  signal RDY_CNT     : std_logic_vector(1 downto 0);    -- Conta il numero di dati validi per decidere se  �
                                                        -- stata completata una DWORD per il MEB
  signal READ_ADC_FLAG: std_logic;                      -- Flag che indica che � in corso la rilettura degli ADC per
                                                        -- la costrizione dell'evento
  signal READ_PDL_FLAG: std_logic;                      -- Flag che indica che � in corso la rilettura delle PDL per
                                                        -- la costrizione dell'evento
  signal READ_OR_FLAG: std_logic;                       -- Flag che indica che � in corso la rilettura degli OR per
                                                        -- la costrizione dell'evento

  -- signals for Micro Flag Management
  signal CYC_STAT        : std_logic;                   -- Riflette lo stato del flag passato dall'ATMEGA16
  signal CYC_STAT_0      : std_logic;                   -- Riflette lo stato del flag passato dall'ATMEGA16
  signal CYC_STAT_1      : std_logic;                   -- Riflette lo stato del flag passato dall'ATMEGA16
  signal FAULT_STAT      : std_logic;                   -- Riflette lo stato del flag passato dall'ATMEGA16
  signal FAULT_STROBE_0   : std_logic;                   -- Riflette lo stato del flag passato dall'ATMEGA16
  signal FAULT_STROBE    : std_logic;                   -- Riflette lo stato del flag passato dall'ATMEGA16
  signal CLEAR_PSM_FLAGS : std_logic;                   -- Attivo alto:clear dei flag inviati dal micro


  signal OR_RACK_sync  : std_logic;                   -- Sincronizzazione acknowledge da LBUS
  signal PDL_RACK_sync : std_logic;                   -- Sincronizzazione acknowledge da I2C interface


  -- Costanti per la costruzione dell'evento LTM
  constant EVNT_NWORD  : std_logic_vector(12 downto 0) := "0000000110010";  -- Numero di word di un evento (50)
  constant EVNT_FILL   : std_logic_vector( 1 downto 0) := "00";


  type     T_ADC_CHANNEL is
           record
             i2c_chain : std_logic;
             chip_addr : std_logic_vector(2 downto 0);
             channel   : std_logic_vector(2 downto 0);
           end record;

  type     T_ADC_MAP     is array (0 to 59) of T_ADC_CHANNEL ;

  --*****************************************
  -- MAPPA DEI CANALI DEGLI ADC SULLA SCHEDA
  --*****************************************
  --
  --               _____________________________________________________________
  --  I2C CHAIN    |              0              |              1               |
  --               ------------------------------------------------------------
  --  ADC CHANNEL  |  4  |  3  |  2  |  1  |  0  |  4  |  3  |  2  |  1  |  0   |
  --               -------------------------------------------------------------
  --  CHIP ADDRESS ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  --       0       |VTH5 |VTH1 |VTH0 |VTH4 |TADC0|VLV2 |VLV3 |VLV7 |VLV6 |TADC6 |
  --       ---------------------------------------------------------------------
  --       1       |VTH7 |VTH3 |VTH2 |VTH6 |TADC1|VLV4 |VLV0 |VLV5 |VLV1 |TADC7 |
  --       ---------------------------------------------------------------------
  --       2       |VTH13|VTH9 |VTH8 |VTH12|TADC2|VLV10|VLV11|VLV15|VLV14|TADC8 |
  --       ---------------------------------------------------------------------
  --       3       |VTH15|VTH11|VTH10|VTH14|TADC3|VLV12|VLV8 |VLV13|VLV9 |TADC9 |
  --       ---------------------------------------------------------------------
  --       4       |GFEA5|GFEA7|GFEA6|GFEA4|TADC4|TFEA0|TFEA2|TFEA1|TFEA3|TADC10|
  --       ---------------------------------------------------------------------
  --       5       |GFEA2|GFEA0|GFEA3|GFEA1|TADC5|TFEA7|TFEA6|TFEA5|TFEA4|TADC11|
  --       ---------------------------------------------------------------------
  --
  --                                      ________________________ CHAIN
  --                                      |     __________________ ADDR
  --                                      |     |      ___________ CHANNEL
  --                                      |     |      |
  constant ADC_MAP     : T_ADC_MAP := ( ('1', "001", "011"),  -- VLV0
                                        ('1', "001", "001"),  -- VLV1
                                        ('1', "000", "100"),  -- VLV2
                                        ('1', "000", "011"),  -- VLV3
                                        ('1', "001", "100"),  -- VLV4
                                        ('1', "001", "010"),  -- VLV5
                                        ('1', "000", "001"),  -- VLV6
                                        ('1', "000", "010"),  -- VLV7
                                        ('1', "011", "011"),  -- VLV8
                                        ('1', "011", "001"),  -- VLV9
                                        ('1', "010", "100"),  -- VLV10
                                        ('1', "010", "011"),  -- VLV11
                                        ('1', "011", "100"),  -- VLV12
                                        ('1', "011", "010"),  -- VLV13
                                        ('1', "010", "001"),  -- VLV14
                                        ('1', "010", "010"),  -- VLV15
                                        ('0', "000", "010"),  -- VTH0
                                        ('0', "101", "011"),  -- GND FEAC 0
                                        ('0', "000", "011"),  -- VTH1
                                        ('0', "001", "010"),  -- VTH2
                                        ('0', "101", "001"),  -- GND FEAC 1
                                        ('0', "001", "011"),  -- VTH3
                                        ('0', "000", "001"),  -- VTH4
                                        ('0', "101", "100"),  -- GND FEAC 2
                                        ('0', "000", "100"),  -- VTH5
                                        ('0', "001", "001"),  -- VTH6
                                        ('0', "101", "010"),  -- GND FEAC 3
                                        ('0', "001", "100"),  -- VTH7
                                        ('0', "010", "010"),  -- VTH8
                                        ('0', "100", "001"),  -- GND FEAC 4
                                        ('0', "010", "011"),  -- VTH9
                                        ('0', "011", "010"),  -- VTH10
                                        ('0', "100", "100"),  -- GND FEAC 5
                                        ('0', "011", "011"),  -- VTH11
                                        ('0', "010", "001"),  -- VTH12
                                        ('0', "100", "010"),  -- GND FEAC 6
                                        ('0', "010", "100"),  -- VTH13
                                        ('0', "011", "001"),  -- VTH14
                                        ('0', "100", "011"),  -- GND FEAC 7
                                        ('0', "011", "100"),  -- VTH15
                                        ('1', "100", "100"),  -- TFEA0
                                        ('1', "100", "010"),  -- TFEA1
                                        ('1', "100", "011"),  -- TFEA2
                                        ('1', "100", "001"),  -- TFEA3
                                        ('1', "101", "001"),  -- TFEA4
                                        ('1', "101", "010"),  -- TFEA5
                                        ('1', "101", "011"),  -- TFEA6
                                        ('1', "101", "100"),  -- TFEA7
                                        ('0', "000", "000"),  -- TADC0
                                        ('0', "001", "000"),  -- TADC1
                                        ('0', "010", "000"),  -- TADC2
                                        ('0', "011", "000"),  -- TADC3
                                        ('0', "100", "000"),  -- TADC4
                                        ('0', "101", "000"),  -- TADC5
                                        ('1', "000", "000"),  -- TADC6
                                        ('1', "001", "000"),  -- TADC7
                                        ('1', "010", "000"),  -- TADC8
                                        ('1', "011", "000"),  -- TADC9
                                        ('1', "100", "000"),  -- TADC10
                                        ('1', "101", "000")   -- TADC11
                                      );

  -- ************************************************************************
  -- EVENT FIFO
  component event_fifo is
   port(
      DO : out std_logic_vector (31 downto 0);
      RCLOCK : in std_logic;
      WCLOCK : in std_logic;
      DI : in std_logic_vector (31 downto 0);
      WRB : in std_logic;
      RDB : in std_logic;
      RESET : in std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic);
  end component;


  -- FIFO
  signal FID       : std_logic_vector(31 downto 0); -- Data input
  signal WRB       : std_logic;
  signal RDB       : std_logic;
  signal FIFO_EMPTY: std_logic;
  signal FIFO_FULL  : std_logic;   -- FULL delle memoria FIFO
  signal FIFO_END_EVNT: std_logic; -- impulso che indica la scrittura di un evento nella FIFO (si setta durante la
                                   -- scrittura del Global Trailer)

  signal FIFO_RES  : std_logic;


  -- contatore per timeout sul local bus
  signal ORATETMO     : std_logic_vector(4 downto 0);

  -- ************************************************************************
  -- Definizione degli stati delle FSM
  attribute syn_encoding : string;

  -- FSM la sequenza di readout
  type TSTATE1 is (S1_IDLE,S1_TESTFIFO,S1_TESTFIFO1, S1_WaitL2A, S1_HEAD,
                   S1_PDL, S1_ADC, S1_ADC_RACK, S1_PDL_RACK, S1_OR_RACK,
                   S1_ORATE, S1_TRAIL, S1_WMEB, S1_END);
  attribute syn_encoding of TSTATE1 : type is "onehot";
  signal STATE1: TSTATE1;

  -- FSM per la generazione del trigger di evento (1 ciclo di clock)
  type TSTATE2 is (S2_M0,S2_M1,S2_M2);
  signal STATE2: TSTATE2;
  attribute syn_encoding of STATE2: signal is "onehot";

  -- ************************************************************************


begin


  -- ************************************************************************
  -- CONCURRENT ASSIGNMENTS
  REG              <= (others => 'Z');
  DEBUG            <= (others => 'Z');
  TRIGLED          <= PULSE(SW_TRIGGER) or EVNT_TRG;

  REG(SPULSE'range) <= X"0000000" & '0' & SPULSE2 & SPULSE1 & SPULSE0;
  REG(TRIGSTAT'range) <= "0000000" &
                         BNC_RES   &
                         '0'       &
                         L2RS      &
                         L2AS      &
                         L1AS      &
                         L2A       &
                         L1R       &
                         L1A       &
                         L0;

  REG(S_FULL)      <= FIFO_FULL;
  EVRDY            <= EVRDYi;
  LTM_DRDY         <= EVRDYi;
  LTM_BUSY         <= FIFO_FULL;
  FF               <= FIFO_FULL;
  EF               <= FIFO_EMPTY;
  PAF              <= '0';
  PAE              <= '0';
  RDB              <= NRDMEB;


  -- La FIFO eventi viene ripulita :
  --   * Su comando di clear da VME
  --   * Al power-on
  --   * Al caricamento iniziale della configurazione della scheda
  --   * Quando non si � in RUN di acquisizione.
  FIFO_RES         <= CLEAR;

  DAC_REFRESH      <= REG(ACQUISITION'low);


  -- Processo per la sincronizzazione dei flag provenienti dal micro
  --
  --
  -- Vengono usati alcuni segnali spare tra micro e actel:
  -- Solo su release 2 del firmware dell'ATMEGA16.
  -- PSM_SP3 = STATO DI CONDIGURAZIONE DELLA CYCLONE (1= NON CONFIGURATA)
  -- PSM_SP4 = STATO DEI FAULT (1=La scheda � stata spenta localmente per un fault)
  --           N.B.Questo segnale � valido sulla transazione 0->1 dello STROBE.
  -- PSM_SP5 = STROBE DEL FLAG DEI FAULT. Valida PASM_SP4 sulla transizione 0->1.
  --
  --             _____    FAULT_STROBE_0     _____
  -- PSM_SP5  --|     |---------------------|     |------ FAULT_STROBE
  --            |     |                     |     |
  --      CLK --|>    |                CLK--|>    |
  --            |_____|                     |_____|
  --
  --                                 _______________
  -- PSM_SP5 XXXXXXXXXXXX___________|               |__________________
  --                                  _______________
  -- FAULT_STOBE_0 XXXXXXX___________|               |_________________
  --                                   _______________
  -- FAULT_STOBE    XXXXXXX___________|               |_________________
  --
  
  REG(S_PSM_CYC_STAT)    <= PSM_SP3;
  REG(S_PSM_FAULT_STAT)  <= PSM_SP4;
  REG(S_PSM_STROBE_STAT) <= PSM_SP5;

  process(HWRES,CLK)
    begin
      if HWRES = '0' then
        FAULT_STROBE_0 <= '0';
        FAULT_STROBE   <= '0';
        CYC_STAT_0     <= '0';
        CYC_STAT_1     <= '0';
        FAULT_STAT     <= '0';
      elsif CLK'event and CLK = '1' then
        if CLEAR_PSM_FLAGS = '1' then
          FAULT_STAT     <= '0';
          FAULT_STROBE_0 <= '0';
          FAULT_STROBE   <= '0';
          CYC_STAT_0     <= '0';
          CYC_STAT_1     <= '0';
        else
          -- Doppio campionamento dello strobe proveniente dal micro ATMEGA16
          FAULT_STROBE_0 <= PSM_SP5;
          FAULT_STROBE   <= FAULT_STROBE_0;

          -- Se c'� un leading edge sullo strobe,
          -- campiona lo status dei fault (PSM_SP4)
          if ( (FAULT_STROBE_0 = '1') and (FAULT_STROBE = '0')) then -- Leading edge
            FAULT_STAT   <= PSM_SP4;
          end if;

          -- Campionamento continuo dello stato della Cyclone
          CYC_STAT_0    <= PSM_SP3;
          CYC_STAT_1    <= CYC_STAT_0;
        end if;
      end if;
    end process;


  -- Gestione del flag di stato di configurazione della FPGA CYCLONE
  -- Il flag memorizza l'eventuale passaggio ad '1' del pin del micro
  -- che indica lo stato di configurazione della Cyclone.
  -- Il flag viene riportato a '0' solo dopo la scrittura di un evento.
  -- In pratica il flag indica se tra un evento e l'altro � avvenuata la
  -- sprogrammazione della fpga (sia per CRC_ERROR che per recupero di un fault).
  process(CLK, CLEAR)
  begin
    if CLEAR ='0' then
      CYC_STAT <= '0';
    elsif CLK'event and CLK = '1' then

      -- Subito dopo la scrittura dell'header di un evento,
      -- Il flag viene azzerato e si riparte a controllare lo stato
      -- del flag dal micro.
      if CLEAR_PSM_FLAGS = '1' then
        CYC_STAT <= '0';
      else
        if CYC_STAT_1 = '1' then
          CYC_STAT <= '1'; -- Latch della condizione di Non configurazione
        end if;
      end if;

    end if;
  end process;


  -- EVENT FIFO
  event_meb: event_fifo
   port map(
      DO         => DPR,
      RCLOCK     => CLK,
      WCLOCK     => CLK,
      DI         => FID,
      WRB        => WRB,
      RDB        => RDB,
      RESET      => FIFO_RES,
      FULL       => FIFO_FULL, -- out
      EMPTY      => FIFO_EMPTY, -- out
      EQTH       => open, -- out
      GEQTH      => open);  -- out


  -- ########################################################################
  -- INIZIO DOMINIO DI ALICLOCK
  -- ########################################################################

  -- ########################################################################
  -- Segnale di TRIGGER
  -- ########################################################################
  process(HWRES,ACLK)
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

      L1AS  <= '0';
      L2AS  <= '0';
      L2RS  <= '0';

    elsif ACLK'event and ACLK = '1' then

      L1AF1 <= L1A;
      L2AF1 <= L2A;
      L2RF1 <= L2R;

      L1AF2 <= L1AF1;
      L2AF2 <= L2AF1;
      L2RF2 <= L2RF1;

      L1AF3 <= L1AF2;
      L2AF3 <= L2AF2;
      L2RF3 <= L2RF2;

      L1AS  <= L1AF1 or L1AF2 or L1AF3;
      L2AS  <= L2AF1 or L2AF2 or L2AF3;
      L2RS  <= L2RF1 or L2RF2 or L2RF3;

    end if;
  end process;



  -- New in rev.2:
  -- Trigger will generate a new event write when
  -- the Bunch reset limit is exceeded and a L2A is received
  LTM_TRIGGER <= BNC_LIMIT_stretched;

  -- contatore per il BUNCH ID
  process (CLEAR,ACLK)
   begin
    if CLEAR = '0' then
      BNC_CNT    <= (others => '0');
      BNC_LIMIT    <= '0';
      BNC_LIMIT_r  <= '0';
      BNC_LIMIT_stretched  <= '0';
    elsif (ACLK'event and ACLK='1') then
      BNC_LIMIT <= '0';
      BNC_LIMIT_r <= BNC_LIMIT;
      -- Strecther del segnale BNC_LIMIT in modo che sia sicuramente
      -- campionato dal dominio di CLK (che � circa alla stessa frequenza ma
      -- completamente scorrelato).
      BNC_LIMIT_stretched <= BNC_LIMIT or BNC_LIMIT_r; -- Dura 2 cicli ACLK

      if BNC_RES = '1' then
        if BNC_CNT = REG(BNCRESN'range) then
          BNC_CNT   <= (others => '0');
          BNC_LIMIT <= '1';
        else
          BNC_CNT    <= BNC_CNT + 1;
        end if;
      end if;
    end if;
  end process;

  -- ########################################################################
  -- FINE DOMINIO DI ALICLOCK
  -- ########################################################################


  ---------------------------------------------------------------------
  -- TRIGGER PULSE GENERATOR
  -- Questa FSM serve per generare trigger che durano 1 periodo di clock
  -- indipendentemente dalla durata del segnale di trigger esterno
  process(CLK, CLEAR)
  begin
    if CLEAR ='0' then
      EVNT_TRG <= '0';
      STATE2   <= S2_M0;
      TRIGGER_sync <= '0';
    elsif CLK'event and CLK = '1' then
      TRIGGER_sync <= LTM_TRIGGER;
      case STATE2 is

        -- aspetto l'arrivo del trigger
        when S2_M0     => if TRIGGER_sync = '0' then
                            STATE2 <= S2_M0;
                          else
                            STATE2 <= S2_M1;
                          end if;

        -- genero un impulso di 1 ciclo
        -- I trigger non sono mai disabilitati
        when S2_M1     => EVNT_TRG <= '1';
                          STATE2   <= S2_M2;

        -- aspetto che trigger torni basso
        when S2_M2     => EVNT_TRG <= '0';
                          if TRIGGER_sync = '0' then
                            STATE2 <= S2_M0;
                          else
                            STATE2 <= S2_M2;
                          end if;
      end case;
    end if;
  end process;

--**********************************************************************************************************************
-- FSM1 : Macchina a stati che gestisce la sequenza di letture da fare
--        per memorizzare in FIFO l'evento.
--**********************************************************************************************************************

--
-- Le informazioni da inserire nell'evento richiedono
--   * accessi all'I2C bus per la lettura dei canali ADC,
--   * accessi all bus seriale delle PDL per la rilettura
--   * accessi alla Cyclone tramite Local Bus per la lettura
--     dei RATE dei segnali di OR provenienti dalle FEA
--
-- ATTENZIONE:
--  Per la lettura delle PDL, essa pu� essere fatta solo in modalit� seriale.
--  Per� la lettura � distruttiva: bisogna fare una scrittura per rileggere!!
--  Infatti il bus � un SPI in cui mentre si rilegge Serial Oout bisogna dare il
--  Serial In.
--  Quindi ci devono essere 48 registri a 8 bit che mantengono il valore corrente
--  delle PDL e lo reimpostano ad ogni lettura.
--

  process(CLK, CLEAR)
    variable crc12 : std_logic_vector(11 downto 0);
  begin
    if CLEAR ='0' then
      STATE1        <= S1_IDLE;
      EVENT_DWORD   <= (others => '0');
      DTEST_FIFO    <= '0';
      WRB           <= '1';
      FID           <= (others => '0');
      CNT           <= (others => '0');
      RDY_CNT       <= (others => '0');
      READ_ADC_FLAG <= '0';
      READ_PDL_FLAG <= '0';
      READ_OR_FLAG  <= '0';
      I2C_RREQ      <= '0';
      PDL_RREQ      <= '0';
      OR_RREQ       <= '0';
      PDL_RADDR     <= (others => '0');
      CRC32         <= (others => '0');
      crc12         := (others => '0');
      OR_RACK_sync  <= '0';
      PDL_RACK_sync <= '0';
      CLEAR_PSM_FLAGS <= '0';
      OR_RADDR      <= (others => '0');
      EVNT_NUM      <= (others => '0');
      L2ASS         <= '0';
      ORATETMO      <= ORATETMOVAL;
      REG(S_ORATETMO) <= '0';
	  FIFO_END_EVNT <= '0';
	  I2C_CHAIN	    <= '0';
	  CHANNEL	    <= (others => '0');
	  CHIP_ADDR	    <= (others => '0');
    elsif CLK'event and CLK='1' then
      CLEAR_PSM_FLAGS <= '0';

      OR_RACK_sync  <= OR_RACK;  -- Sincronizzazione acknowledge da LBUS
      PDL_RACK_sync <= PDL_RACK; -- Sincronizzazione acknowledge da PDL Iinterface

      L2ASS         <= L2AS;     -- L2A allungato e sincronizzato.

      case STATE1 is
        when S1_IDLE     => DTEST_FIFO <= '0';
                            FIFO_END_EVNT <= '0';
                            FID         <= (others => '0');
                            CNT         <= (others => '0');
                            EVENT_DWORD <= (others => '0');
                            RDY_CNT     <= (others => '0');
                            WRB         <= '1';
                            READ_ADC_FLAG <= '0';
                            READ_PDL_FLAG <= '0';
                            READ_OR_FLAG  <= '0';
                            I2C_RREQ   <= '0';
                            PDL_RREQ   <= '0';
                            OR_RREQ    <= '0';
                            OR_RADDR   <= (others => '0');
                            CRC32      <= (others => '0');
                            crc12      := (others => '0');
                            ORATETMO   <= ORATETMOVAL;
                            if (REG(C_TST_FIFO) = '1') then
                              STATE1 <= S1_TESTFIFO;    -- vado in modalit� TEST FIFO
                            -- Ho raggiunto il numero impostato di Bunch reset
                            elsif EVNT_TRG = '1' then
                              STATE1 <= S1_WaitL2A;
                            elsif PULSE(SW_TRIGGER) = '1' then
                              STATE1 <= S1_HEAD;
                            else
                              STATE1 <= S1_IDLE;
                            end if;

        -- Attende il primo L2A prima di scrivere l'evento
        when S1_WaitL2A   => if (L2ASS = '1') or (PULSE(SW_TRIGGER) = '1') then
                                STATE1 <= S1_HEAD;
                             end if;
        -- Inserisce l'header
                                   --   4    +     9        +    1       +    1     +    13      +   4       = 32 bit
        when S1_HEAD     => FID    <= G_HEAD & "000000000"  & FAULT_STAT & CYC_STAT & EVNT_NWORD & not(GA);
                            WRB             <= '0';
                            CLEAR_PSM_FLAGS <= '1';
                            STATE1          <= S1_PDL;

        -- Comanda la rilettura delle 48 PDL tramite rilettura seriale.
        -- aspetta l'ACK dell'operazione per procedere.
        -- LCOL TODO: deve scrivere 12 DWORD in FIFO
        when S1_PDL      => WRB           <= '1';
                            READ_ADC_FLAG <= '0';
                            READ_PDL_FLAG <= '1';
                            READ_OR_FLAG  <= '0';

                            if CNT = "110000" then
                              if SimCfg_NoADCEvent = TRUE then
                                STATE1  <= S1_ORATE;
                                CNT     <= (others => '0');
                              else
                                STATE1  <= S1_ADC;
                                CNT     <= (others => '0');
                              end if;
                            else
                              if PDL_RACK_sync = '0' then -- Aspetta che la PDL interface abbia completato l'handshake
                                PDL_RADDR  <= CNT;
                                PDL_RREQ   <= '1';
                                STATE1     <= S1_PDL_RACK;
                              end if;
                            end if;


        -- Comanda la rilettura dei canali ADC da inserire nell'evento
        -- tramite bus I2C
        -- Comanda una lettura I2C ed aspetta l'ACK dell'operazione per procedere
        -- Ogni tre letture si scrive in FIFO la DWORD completata con il FILL.
        when S1_ADC     => WRB       <= '1';
                           READ_ADC_FLAG <= '1';
                           READ_PDL_FLAG <= '0';
                           READ_OR_FLAG  <= '0';

                           if CNT = "111100" then
                             STATE1  <= S1_ORATE;
                             CNT     <= (others => '0');
                           else
                             I2C_CHAIN <= ADC_MAP(conv_integer(CNT)).I2C_CHAIN;
                             CHIP_ADDR <= ADC_MAP(conv_integer(CNT)).CHIP_ADDR;
                             CHANNEL   <= ADC_MAP(conv_integer(CNT)).CHANNEL;

                             I2C_RREQ   <= '1';
                             STATE1    <= S1_ADC_RACK;
                           end if;

        -- Comanda la rilettura del rate degli OR
        -- ed aspetta l'ACK dell'operazione per procedere
        -- tramite Local Bus
        -- I valori di OR_RATE sono 48 valori a 10 bit riletti
        -- dalla Cyclone tramite LBUS.
        -- Vengono compattati in FIFO su 16 DWORD.
        when S1_ORATE    => WRB    <= '1';
                            READ_ADC_FLAG <= '0';
                            READ_PDL_FLAG <= '0';
                            READ_OR_FLAG  <= '1';

                            if CNT = "110000" then
                              STATE1  <= S1_TRAIL;
                              CNT     <= (others => '0');
                            else
                              ORATETMO <= ORATETMO - 1;
                              -- Aspetta che il Local Bus sia libero
                              if ( (OR_RACK_sync = '0') or (ORATETMO = "00000") ) then
                                OR_RADDR   <= CNT;
                                OR_RREQ    <= '1';
                                if (ORATETMO = "00000") then
                                  REG(S_ORATETMO) <= '1';
                                end if;
                                STATE1     <= S1_OR_RACK;
                              end if;
                            end if;

        -- Inserisce il trailer
        when S1_TRAIL    => crc12  := (("0000" & CRC32(31 downto 24)) xor CRC32(23 downto 12) xor CRC32(11 downto 0));
                            --   4     +    12    +  12          + 4  = 32 bit
                            FID    <= G_TRAIL & EVNT_NUM & crc12 & not(GA);
                            WRB    <= '0';
                            STATE1 <= S1_END;

        when S1_END      => WRB    <= '1';
                            FIFO_END_EVNT <= '1';
                            EVNT_NUM      <= EVNT_NUM + 1;
                            STATE1        <= S1_IDLE;

        -- Scrive una nuova parola nella MEB
        -- Quando sono stati letti un nuomero di dati sucficienti a comlpetare una DWORD
        -- si comanda la scrittura nel MEB.
        -- Se il MEB � pieno, si attende lo svuotamento.
        -- I segnali di FLAG servono per saper a quale stato ritornare.
        when S1_WMEB     => WRB    <= '0';
                            FID    <= EVENT_DWORD;
                            CRC32  <= CRC32 xor EVENT_DWORD;
                            if READ_ADC_FLAG = '1' then
                              STATE1 <= S1_ADC;
                            elsif READ_PDL_FLAG = '1' then
                              STATE1 <= S1_PDL;
                            elsif READ_OR_FLAG = '1' then
                              STATE1 <= S1_ORATE;
                              ORATETMO   <= ORATETMOVAL;
                            else
                              STATE1 <= S1_TRAIL;
                            end if;

        -- Controlla il numero di letture e se:
        --  - Sono state fatte 3 letture ADC (10 bitx3)
        --  - Sono state fatte 4 letture PDL (8 bit x4)
        --  - Sono state fatte 3 letture OR  (10 bitx3)
        -- passa nello stato WMEB e comanda la scrittura
        when S1_ADC_RACK  => EVENT_DWORD(31 downto  30) <= EVNT_FILL;
                             if I2C_RACK = '1' then
                                I2C_RREQ <= '0';
                                RDY_CNT <= RDY_CNT + 1;
                                CNT     <= CNT + 1;
                                EVENT_DWORD(31 downto  30) <= EVNT_FILL;
                                EVENT_DWORD(29 downto 20)  <= I2C_RDATA;
                                EVENT_DWORD(19 downto 10)  <= EVENT_DWORD(29 downto 20);
                                EVENT_DWORD( 9 downto  0)  <= EVENT_DWORD(19 downto 10);
                                if RDY_CNT = "10" then
                                  STATE1   <= S1_WMEB;
                                  RDY_CNT  <= (others => '0');
                                else
                                  STATE1 <= S1_ADC;
                                end if;
                              end if;

        when S1_PDL_RACK  => if PDL_RACK_sync = '1' then
                                  PDL_RREQ <= '0';
                                  RDY_CNT <= RDY_CNT + 1;
                                  CNT     <= CNT + 1;
                                  EVENT_DWORD(31 downto 24) <= PDL_RDATA;
                                  EVENT_DWORD(23 downto 16) <= EVENT_DWORD(31 downto 24);
                                  EVENT_DWORD(15 downto  8) <= EVENT_DWORD(23 downto 16);
                                  EVENT_DWORD( 7 downto  0) <= EVENT_DWORD(15 downto  8);
                                if RDY_CNT = "11" then
                                  STATE1   <= S1_WMEB;
                                  RDY_CNT  <= (others => '0');
                                else
                                  STATE1 <= S1_PDL;
                                end if;
                              end if;

        when S1_OR_RACK   => EVENT_DWORD(31 downto 30) <= EVNT_FILL;
                             if OR_RACK_sync = '1' then
                                OR_RREQ   <= '0';
                                RDY_CNT  <= RDY_CNT + 1;
                                CNT      <= CNT  + 1;
                                EVENT_DWORD(31 downto 30) <= EVNT_FILL;
                                EVENT_DWORD(29 downto 20) <= OR_RDATA;
                                EVENT_DWORD(19 downto 10) <= EVENT_DWORD(29 downto 20);
                                EVENT_DWORD( 9 downto  0) <= EVENT_DWORD(19 downto 10);
                                if RDY_CNT = "10" then
                                  STATE1   <= S1_WMEB;
                                  RDY_CNT  <= (others => '0');
                                else
                                  ORATETMO  <= ORATETMOVAL; -- Restart Timeout counter
                                  STATE1    <= S1_ORATE;
                                end if;
                              end if;


        -- MODALITA' DI TEST DELLA FIFO -------------------------------------
        -- Aspetta la scrittura nel registro TESTREG
        when S1_TESTFIFO => if PULSE(WP_FIFO) = '1' then
                        FID        <= REG(TESTREG'range);
                        WRB        <= '0';
                        STATE1     <= S1_TESTFIFO1;
                       end if;

        when S1_TESTFIFO1=> WRB        <= '1';
                            DTEST_FIFO <= '1';
                            STATE1     <= S1_IDLE;

        when others      => STATE1 <= S1_IDLE;
      end case;
    end if;
  end process;


  -- ******************************************************************
  -- Event ready e Event Store
  -- ******************************************************************
  -- EVRDY dice se c'� almeno un evento intero in memoria; il
  -- contatore EVNT_STOR viene incrementato quando � stato scritto un evento e
  -- decrementato quando ne � stato letto uno (EVREAD da vinterf.).
  -- EVNT_STOR quindi contiene il numero di eventi nella FIFO
  process (CLEAR,CLK)
  begin
    if CLEAR = '0' then
      REG(EVNT_STOR'range) <= (others => '0');
      EVRDYi <= '0';
    elsif CLK'event and CLK = '1' then
        if EVREAD = '1' and FIFO_END_EVNT = '0' then
          REG(EVNT_STOR'range) <= REG(EVNT_STOR'range) - 1; -- lettura di un evento
          if REG(EVNT_STOR'range) = "0000000000000001" then
            EVRDYi <= '0';
          end if;
        elsif EVREAD = '0' and FIFO_END_EVNT = '1' then
          REG(EVNT_STOR'range) <= REG(EVNT_STOR'range) + 1; -- scrittura di un evento
          EVRDYi <= '1';
        else
          REG(EVNT_STOR'range) <= REG(EVNT_STOR'range);
        end if;
    end if;
  end process;



END RTL;