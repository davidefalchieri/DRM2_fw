-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            05/08/05
-- --------------------------------------------------------------------------
-- Module:          SPI_INTERF
-- Description:     RTL module: serial port interface for read/write FLASH
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--   10/06/08 - nCYC_RELOAD bidirezionale; cambiata logica di pilotaggio FCS;
--              Aggiunto contatore di attività su nCYC_RELOAD.
--              Aggiunta porta FWIMG2LOAD per selezione immagine firmware da
--              ricaricare con comando software.
--
--   26/03/09 - Aggiunta istanza del buffer Actel OTB33LL per capire se il bug
--              di lettura dalla flash su 6 LTM in ALICE possa essere legata
--              all'integrità di segnale su F_SCK. Se non si indica niente
--              Libero instanzia un driver OTB33PH (PCI strength (alta) +
--              Slew rate alto). L'unica maniera di foirzarlo ad usare un buffer
--              diverso è di instnziarlo nel codice.
--   09/04/09 - Rimossa istanza buffer OTB33LL ed aumentata la latenza tra
--              fronte in discesa di F_SCK (la flash fa uscire il dato su quel
--              fronte) e campionamento del dato di uscita.
--   22/04/09 - Aggiunta majority su F_SO: per evitare problemi
--              con la metastabilità (F_SO entra nella macchina a stati
--              ma è da considerarsi asincrona rispetto a CLK (viene generato
--              dalla flash con un tco rispetto al fronte in discesa
--              di F_SCK). Maggiooranza su 3 valori di una pipe su F_SO.
--              Aumentata anche la lunghezza del ciclo di accesso alla flash,
--              per rileggere bene il dato di uscita dalla flash anche nel caso
--              di fronte in salita lungo 30-60 ns, dovuto alla R295 da 1 kohm in serie
--              a F_SO sullo stampato.
--   26/04/0926/04/09 - Corretta rilettura SPI. Il campionamento del primo bit del byte
--                     di uscita dalla flash durante il load della LUT avviene con la latenza
--                     lunga come nel caso del campionamento dei bit successivi.
-- ############################################################################
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1392pkg.all;

ENTITY SPI_INTERF IS
   GENERIC(
     G_SIM_ON       : boolean := FALSE;  -- Fast SPI
     G_LOAD_DISABLE : boolean := FALSE   -- Disable CRAM load
   );
   PORT(
       CLK       : IN    std_logic;
       HWRES     : IN    std_logic;
       HWCLEAR   : IN    std_logic;      -- Clear Hw
       FCS       : OUT   std_logic;      -- Flash /CS
       nCYC_RELOAD : INOUT std_logic;      -- Micro Reset to reload Cyclone configuration
       -- Bus SPI
       F_SI      : OUT   std_logic;
       F_SO      : IN    std_logic;
       F_SCK     : OUT   std_logic;
       FBOUT     : OUT   std_logic_vector (7 DOWNTO 0); -- SPI Output Byte

       -- LOad phase signals
       LOAD_RES  : OUT   std_logic; -- mentre leggo la flash e carico la SRAM
                                    -- con la tabella di compensazione tengo tutto in RESET
                                    -- (attivo basso)

       PON_LOAD  : IN    std_logic; -- Request of Power-On Configuration Load

       -- ROC Interface
       FWIMG2LOAD: IN std_logic;

       -- Accessi alla C-ROM
       CROMWAD   : OUT   std_logic_vector (8 downto 0);
       CROMWDT   : OUT   std_logic_vector (7 downto 0);
       WRCROM    : OUT   std_logic;

       -- Accessi alla PDL CONFIGURATION ROM
       PDLCFG_nWR: OUT   std_logic;
       PDLCFG_WAD: OUT   std_logic_vector(5 downto 0);
       PDLCFG_WDT: OUT   std_logic_vector(7 downto 0);

       -- Accessi alla DAC CONFIGURATION ROM
       DACCFG_nWR: OUT   std_logic;
       DACCFG_WAD: OUT   std_logic_vector( 3 downto 0);
       DACCFG_WDT: OUT   std_logic_vector(15 downto 0);


       REG       : INOUT reg_stream;
       PULSE     : IN    reg_pulse;
       DEBUG     : INOUT debug_stream;
       TICK      : IN    tick_pulses
   );

-- Declarations

END SPI_INTERF ;


ARCHITECTURE RTL OF SPI_INTERF IS

  --------------------------------------------------------------------
  -- FSM
  type  TSTATE1  is (S1_COUNT, S1_WAIT_CSS, S1_WAIT_CSH, S1_WAIT_CS,
                     S1_NEWCOMM,S1_WAITLUT,S1_NEWLUT,
                     S1_IDLE, S1_SPISTART,
                     S1_SPI0,S1_SPI1,S1_SPI2,
                     S1_SPI3,S1_SPI4,S1_SPI5,
                     S1_SPI6,S1_SPI7,S1_SPI8,
                     S1_SPI9,S1_SPI10,S1_SPI11,
                     S1_SPI12,S1_SPI13, S1_SPI14, S1_SPI15,
                     S1_MICRES, S1_RELOAD);


  attribute syn_encoding : string;
  attribute syn_encoding of TSTATE1 : type is "onehot";

  signal  sstate  : TSTATE1;


  --------------------------------------------------------------------
  signal   SBYTE     : std_logic_vector(7 downto 0);   -- byte SPI
  signal   ISI       : std_logic;                      -- SPI SI dalla FSM
  signal   ISCK      : std_logic;                      -- SPI SCK dalla FSM

  signal   LOAD_RESi : std_logic;                      -- LOAD_RES dalla FSM


  signal   DRIVECS   : std_logic;                      -- NCS gestito dalla FSM al power ON

  --------------------------------------------------------------------


  signal DRIVE_RELOAD : std_logic; -- abilita il pilotaggio di FCS per la selezione
                                   -- dell'immagine da caricare.

  signal RESCNT       : std_logic_vector (15 downto 0);  -- Fissa la durata del micres

  signal   COMMAND   : std_logic;
  signal   LUT       : std_logic;
  signal   WRCROMi   : std_logic;                      -- write della RAM contenente la C-ROM (ATTIVO BASSO)
  signal   WRPDLi    : std_logic;                      -- write della RAM contenente la C-ROM (ATTIVO BASSO)
  signal   WRDACi    : std_logic;                      -- write della RAM contenente la C-ROM (ATTIVO BASSO)

  signal   NCS0      : std_logic;                      -- NCS gestito dalla FSM al power ON
  constant CMD_SR    : std_logic_vector (7 downto 0) := "11101000"; -- stream di command 0xE8

  signal   BITCNT    : std_logic_vector (2 downto 0);  -- conta i bit durante lo shift
  signal   BYTECNT   : std_logic_vector (8 downto 0);  -- conta i byte durante la rilettura di una pagina (264 byte x pagina)
  signal   PAGECNT   : std_logic_vector (8 downto 0);  -- conta le pagine (leggo 1 pagina)
  signal   DACCFG_PNT : std_logic_vector (5 downto 0);  -- Puntatore di scrittura della DACCFG ram

  constant nbyte     : std_logic_vector (8 downto 0) := "100000111";  -- 263
  constant npage     : std_logic_vector (8 downto 0) := "000000000";  -- 0 (per contare 1 pagina)

  signal   FCS_SEL   : std_logic;    -- Select Flash Chip Select driver mode


  signal DACCfgValue : std_logic_vector(15 downto 0);

  signal RELOAD_EDGE, RELOAD_EDGE_r : std_logic;
  signal RELOAD_CNT  : std_logic_vector(7 downto 0);

  -- HACK
  signal DRIVE_SPI    : std_logic;
   
  signal F_SO_sync, F_SO_sync1, F_SO_sync2, F_SO_maj : std_logic; 

  component OTB33LL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;


begin


  REG <= (others => 'Z');

  DEBUG <= (others => 'Z');

  REG(LOAD_ACT'range) <= RELOAD_CNT;

  -- nCYC_RELOAD è attivo basso se
  -- è montato il MAX6315, altrimenti è attivo alto.
  nCYC_RELOAD   <= '1' when DRIVE_RELOAD = '1' else 'Z';



  -- Pilotaggio FLASH Chip Select
  with FCS_SEL select
      FCS   <= not(REG(FLENA_FCS))   when '0',          -- Reg-controlled CS
               NCS0                  when others;       -- Config LOad mode

  DRIVECS <= REG(FLENA_FCS); -- Se la flash è abilitata da software
                             -- SI ed SCK della flash sono pilotati
                             -- dalla macchina a stati che gestisce
                             -- la programmazione della flash.

  DRIVE_SPI <= '1' when ((DRIVECS='1') or (LOAD_RESi='0')) else '0';

  -- Pilotaggio FLASH Serial IN
  F_SI  <= ISI   when ( DRIVE_SPI = '1' ) else 'Z'; -- TODO: gestione situazioni concorrenti?

  -- Pilotaggio FLASH Clock
  F_SCK <= ISCK  when ( (DRIVECS='1') or (LOAD_RESi='0') ) else 'Z';

  --F_SCK_BUF: OTB33LL port map (
  --    PAD => F_SCK,
  --    A   => ISCK,
  --    EN  => DRIVE_SPI
  --  );

  FBOUT <= SBYTE;  -- Byte in uscita dalla Flash SPI


  LOAD_RES <= LOAD_RESi;

 -- RELOAD pulse counter
 P_RELOAD_COUNT: process (HWRES, CLK) is
      -- type file function constant variable subtype alias procedure
 begin
      if HWRES = '0' then
        RELOAD_EDGE <= '0';
        RELOAD_EDGE_r <= '0';
        RELOAD_CNT <= (others => '0');
      elsif CLK'event and CLK = '1' then
        RELOAD_EDGE  <= nCYC_RELOAD;
        RELOAD_EDGE_r <= RELOAD_EDGE;
        if RELOAD_EDGE = '0' and RELOAD_EDGE_r = '1' then -- Falling edge detect
           RELOAD_CNT <= RELOAD_CNT + 1;
        end if;
      end if;
 end process P_RELOAD_COUNT;

 -- Macchina a stati che gestisce:
 --  .) Caricamento al power-on o su comando software della configuration rom
 --     (pagina della flash contentente il valore iniziale delle PDL e dei DAC).
 --  .) Accesso in scrittura allaflash per aggiornamento firmware
  process (HWRES,PULSE,CLK)
  
      function majority3 (val: std_logic_vector(2 downto 0)) return std_logic is
        variable conta_zeri : natural range 0 to 3;
        variable conta_uni  : natural range 0 to 3;
      begin
        for i in 0 to val'length-1 loop

          if (val(i) = '0') then
            conta_zeri := conta_zeri + 1;
          elsif (val(i) = '1') then
            conta_uni := conta_uni + 1;
          end if;

        end loop;

        if conta_zeri >= conta_uni then
          return '0';
        else
          return '1';
        end if;  

      end majority3;
  
  begin

    if HWRES = '0'  then

      ISCK      <= '0';
      ISI       <= '0';
      SBYTE     <= (others => '0');

      LOAD_RESi <= '1'; -- HACK: deve stare a 1 altrimenti c'è coinfiltto al power-on su F_SI e FSCK
      NCS0      <= '1';

      PAGECNT   <= (others => '0');
      BYTECNT   <= (others => '0');
      BITCNT    <= (others => '0');

      WRCROMi    <= '1';
      WRPDLi     <= '1';
      WRDACi     <= '1';

      COMMAND   <= '0';
      LUT       <= '0';

      RESCNT    <= (others => '0');
      DRIVE_RELOAD <= '0';

	  DACCfgValue <= (others => '0');

      F_SO_sync  <= '0';
      F_SO_sync1 <= '0';
      F_SO_sync2 <= '0';
      F_SO_maj   <= '0';
      
      FCS_SEL   <= '1'; -- Flash chip-select driven by this state machine
      sstate    <= S1_IDLE;

    elsif CLK'event and CLK = '1' then

    if (PULSE(LOAD_LUT) = '1') or (PON_LOAD = '1') then
      ISCK      <= '0';
      ISI       <= '0';
      SBYTE     <= (others => '0');

      LOAD_RESi <= '0';
      NCS0      <= '1';

      PAGECNT   <= (others => '0');
      BYTECNT   <= (others => '0');
      BITCNT    <= (others => '0');
      DACCfgValue <= (others => '0');

      WRCROMi   <= '1';
      WRPDLi    <= '1';
      WRDACi     <= '1';

      COMMAND   <= '1';
      LUT       <= '0';

      RESCNT    <= (others => '0');
      DRIVE_RELOAD <= '0';

      FCS_SEL   <= '1'; -- Flash chip-select driven by this state machine

      F_SO_sync  <= '0';
      F_SO_sync1 <= '0';
      F_SO_sync2 <= '0';
      F_SO_maj   <= '0';
      
      sstate    <= S1_COUNT;

    else

      F_SO_sync  <= F_SO;
      F_SO_sync1 <= F_SO_sync;
      F_SO_sync2 <= F_SO_sync1;
      
      F_SO_maj   <= majority3(std_logic_vector'(F_SO_sync2 & F_SO_sync1 & F_SO_sync));
    
      case sstate is
     --------------------------------------------------------------------
          -- ATTESA AL POWER ON: uso PAGECNT per attendere 16K*30 cicli di clock (~10ms)
          --------------------------------------------------------------------
          when S1_COUNT   =>
                             NCS0      <= '1';
                             if conv_integer(PAGECNT) = 30 then
                               PAGECNT <= (others => '0');
                               NCS0     <= '0';               -- attivo il chip select
                               ISCK     <= '0';
                               ISI      <= '0';
                               BYTECNT  <= "000000000";
                               sstate   <= S1_WAIT_CSS;
                             else
                               if G_SIM_ON then
                                 PAGECNT <= PAGECNT + 1;
                                 sstate  <= S1_COUNT;
                               else
                                 if TICK(1) = '1' then
                                   PAGECNT <= PAGECNT + 1;
                                   sstate  <= S1_COUNT;
                                 end if;
                               end if;
                             end if;

                             -- Si può disabilitare il caricamento
                             -- della LUT con un generic: SOLO PER SIMULAZIONE
                             if G_LOAD_DISABLE then
                               sstate      <= S1_IDLE;
                             end if;
          --------------------------------------------------------------------
          -- CARICAMENTO DELLA CROM: modalità POWER ON
          --------------------------------------------------------------------
          -- devo aspettare almeno 250 ns da quando attivo NCS al primo fronte di SCK (NCS setup time)
          when S1_WAIT_CSS=> if BYTECNT = "000001001" then
                               SBYTE  <= CMD_SR;              -- carico lo shift register con il command
                               ISI    <= CMD_SR(CMD_SR'high); -- preparo il primo bit
                               BITCNT <= "000";
                               BYTECNT<= (others => '0');
                               sstate <= S1_SPISTART;             -- vado a serializzare
                             else
                               BYTECNT<= BYTECNT + 1;
                               sstate <= S1_WAIT_CSS;
                             end if;

          --------------------------------------------------------------------
          -- serializzazione del command: devo scrivere l'opcode + 7 byte a 0
          when S1_NEWCOMM => SBYTE   <= "00000000";           -- carico lo shift register con 0
                             ISI     <= '0';                  -- preparo il primo bit
                             BITCNT  <= "000";
                             sstate  <= S1_SPI0;              -- vado a serializzare

                             if BYTECNT = "000000111" then    -- ho finito il command:
                               PAGECNT <= (others => '0');      -- vado a rileggere i dati della LUT
                               BYTECNT <= (others => '0');
                               BITCNT  <= "000";
                               COMMAND <= '0';
                               LUT     <= '1';
                             else                             -- non ho finito il command:
                               BYTECNT <= BYTECNT + 1;
                             end if;

          --------------------------------------------------------------------
          -- lettura 1 pagina di 256 byte
          when S1_WAITLUT => WRCROMi    <= '1';
                             WRPDLi     <= '1';
                             WRDACi     <= '1';
                             sstate   <= S1_NEWLUT;  -- attesa prima di cambiare gli indirizzi della LUT

          when S1_NEWLUT  => BITCNT  <= "000";
                             if BYTECNT = nbyte then          -- ho finito i byte:
                               if PAGECNT = npage then          -- ho finito le pagine: vado in modalità NORMAL
                                 LUT     <= '0';
                                 BYTECNT <= (others => '0');
                                 sstate  <= S1_WAIT_CSH;
                               else
                                 ISCK    <= '0';               -- non ho finito le pagine:
                                 PAGECNT <= PAGECNT + 1;         -- incremento il contatore di pagina
                                 BYTECNT <= (others => '0');
                                 sstate  <= S1_SPI0;             -- vado a serializzare
                               end if;
                             else                            -- non ho finito i byte:
                               ISCK    <= '0';
                               BYTECNT <= BYTECNT + 1;         -- incremento il contatore di byte
                               sstate  <= S1_SPI0;             -- vado a serializzare
                             end if;


          --------------------------------------------------------------------
          -- devo aspettare almeno 250 ns dall'ultimo fronte di SCK a quando disattivo NCS (NCS hold time)
          when S1_WAIT_CSH=> WRCROMi  <= '1';
                             WRPDLi   <= '1';
                             WRDACi   <= '1';
                             if BYTECNT = "000001001" then
                               NCS0   <= '1';
                               BYTECNT <= "000000000";
                               sstate <= S1_WAIT_CS;
                             else
                               BYTECNT<= BYTECNT + 1;
                               sstate <= S1_WAIT_CSH;
                             end if;

          -- devo aspettare almeno 250 ns con (NCS high time)
          when S1_WAIT_CS => if BYTECNT = "000001001" then
                               FCS_SEL   <= '0'; -- FCS driven by FLEN register
                               sstate    <= S1_IDLE;
                             else
                               BYTECNT   <= BYTECNT + 1;
                               sstate    <= S1_WAIT_CS;
                             end if;


        --------------------------------------------------------------------
        -- LETTURA/SCRITTURA DA VME: modalità NORMAL
        --------------------------------------------------------------------
        when S1_IDLE  => LOAD_RESi<= '1';
                         ISI      <= '0';
                         ISCK     <= '0';
                         DRIVE_RELOAD <= '0';

                         if PULSE(WP_CONFIG) = '1' then
                         -- Quando si comanda una nuova configurazione della
                         -- Cyclone, il CS della Flash è pilotato con
                         -- il selettore della pagina da ricaricare
                           NCS0         <= FWIMG2LOAD; -- Image to load
                           FCS_SEL      <= '1'; -- Drive Flash /cs by state machine
                           DRIVE_RELOAD <= '1'; -- Force nCYC_RELOAD
                           RESCNT       <= (others => '0');
                           SSTATE       <= S1_MICRES;
                         end if;
                         if PULSE(WP_SPI) = '1' then
                           FCS_SEL   <= '0'; -- FCS driven by FLEN register
                           SBYTE     <= REG(FLASH'range);   -- carico lo shift register
                           ISI       <= REG(FLASH'high);    -- preparo il primo bit
                           BITCNT    <= "000";
                           sstate    <= S1_SPISTART;
                         end if;

        --------------------------------------------------------------------
        -- serializzazione dato
        --------------------------------------------------------------------
        when S1_SPISTART => sstate    <= S1_SPI0; -- 

        when S1_SPI0    => sstate    <= S1_SPI1;
        when S1_SPI1    => sstate    <= S1_SPI2;
        when S1_SPI2    => sstate    <= S1_SPI3;
        when S1_SPI3    => sstate    <= S1_SPI4;
        when S1_SPI4    => sstate    <= S1_SPI5;
        when S1_SPI5    => sstate    <= S1_SPI6;        
        when S1_SPI6    => sstate    <= S1_SPI7;
        when S1_SPI7    => sstate    <= S1_SPI8;

        when S1_SPI8    => ISCK      <= '1';
                           SBYTE     <= SBYTE(SBYTE'high-1 downto SBYTE'low) & F_SO_maj;
                           sstate    <= S1_SPI9;

        when S1_SPI9     => sstate    <= S1_SPI10;
        when S1_SPI10    => sstate    <= S1_SPI11;
        when S1_SPI11    => sstate    <= S1_SPI12;


        when S1_SPI12    => ISCK      <= '0';
                            sstate    <= S1_SPI13;

        when S1_SPI13    => sstate    <= S1_SPI14;
        when S1_SPI14    => sstate    <= S1_SPI15;


        when S1_SPI15    => ISCK      <= '0';
                           if BITCNT = "111" then
                               if COMMAND = '1' then
                                 sstate  <= S1_NEWCOMM;
                               elsif LUT = '1' then
                                 sstate  <= S1_WAITLUT;

                                 -- per la CONF. ROM sono significativi solo 263 byte per pagina
                                 if (PAGECNT = "000000000" and BYTECNT <= "100000111") then
                                   -- lettura della CONF. ROM:
                                   -- scrivo il byte letto nella RAM contenente la C-ROM
                                   WRCROMi    <= '0';
                                   if BYTECNT <= "101111" then -- 48 bytes for PDL configuration
                                     WRPDLi <= '0';
                                   elsif BYTECNT <= "1001111" then -- tra 47 e 79 ci sono i valori dei DAC
                                     if BYTECNT(0) = '0' then
                                       WRDACi <= '1'; -- Attende a scrivere perchè i valori del DAC devono
                                                      -- essere scritti su 16 bit nel buffer di appoggio.
                                       DACCfgValue <= X"0" & SBYTE & X"0"; -- Allinea il dato per inviare i 10 bit
                                                                           -- significativi per il DAC
                                     else
                                       WRDACi <= '0'; -- Attende a scrivere perchè i valori del DAC devono
                                                      -- essere scritti su 16 bit nel buffer di appoggio.
                                       DACCfgValue <= DACCfgValue or ("00" & SBYTE(1 downto 0) & X"000");

                                     end if;
                                   end if;
                                 end if;

                               else
                                 sstate  <= S1_IDLE;
                               end if;
                           else
                             BITCNT  <= BITCNT + 1;
                             ISI     <= SBYTE(SBYTE'high);
                             sstate  <= S1_SPISTART;
                           end if;

        -- Mantiene il pin nCYC_RELOAD
        when S1_MICRES    => if RESCNT = X"FFFF" then
                               sstate    <= S1_RELOAD;
                             else
                               RESCNT <= RESCNT + 1;
                             end if;

        -- Continua a pilotare il CS della Flash anche alla
        -- fine dell'impulso di reset del micro
        when S1_RELOAD    => sstate       <= S1_IDLE;

        when others    => sstate    <= S1_IDLE;

      end case;
    end if;
    end if;
  end process;

  -- ******************************************************************
  -- SCRITTURA DELLA C-ROM
  -- La CROM è scritta dall'interfaccia SPI al power on
  -- (dalla pagina 0 della flash)
  -- E' riletta da VME
  -- ******************************************************************
  CROMWAD <= BYTECNT;

  -- ******************************************************************
  -- SCRITTURA DELLA PDL Configuration RAM
  -- Contiene i 48 valori (8 bit) per la configurazione delle PDL
  -- ******************************************************************
  PDLCFG_WAD <= BYTECNT(5 downto 0);

  -- ******************************************************************
  -- SCRITTURA DELLA DAC Configuration RAM
  -- Contiene i 16 valori (10 bit) per l'impostazione dei DAC.
  -- L'indirizzo di scrittura è allineato a 16 bit.
  -- ******************************************************************
  DACCFG_PNT <= (unsigned(BYTECNT(5 downto 0)) - conv_unsigned(48,6));
  DACCFG_WAD <= DACCFG_PNT(4 downto 1);

  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      WRCROM     <= '1';
      PDLCFG_nWR <= '1';
      CROMWDT    <= (others => '0');
      DACCFG_nWR <= '1';
      DACCFG_WDT <= (others => '0');
      PDLCFG_WDT <= (others => '0');
     elsif CLK'event and CLK = '1' then
      WRCROM     <= WRCROMi;
      PDLCFG_nWR <= WRPDLi;
      DACCFG_nWR <= WRDACi;
      CROMWDT    <= SBYTE;
      PDLCFG_WDT <= SBYTE;
      DACCFG_WDT <= DACCfgValue; --
    end if;
  end process;
END RTL;
