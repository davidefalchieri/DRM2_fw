-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA750
-- Author:          Annalisa Mati
-- Date:            21/06/13
-- --------------------------------------------------------------------------
-- Module:          SPI_INTERF
-- Description:     RTL module: serial port interface for read/write FLASH
-- ****************************************************************************

-- ############################################################################
-- Revision History:
-- 30.05: Release rilasciata
-- 00.05: - PULSE(LOAD_LUT) è usato come reset sincrono anzichè asincrono
--        - Spezzato il contatore PAGECNT
--        - semplificato il mux per la scrittura degli OFFSET
-- NUOVA RELEASE 2013:
-- eliminata la rilettura degli OFFSET per la sottrazione TRAILING-LEADING-OFFSET
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1390pkg.all;

ENTITY SPI_INTERF IS
	GENERIC( 
		SIM_MODE     : boolean := FALSE     -- Enable simulation mode 
	);
   PORT(
       CLK       : IN    std_logic;
       HWRES     : IN    std_logic;
       FCS       : OUT   std_logic;                     -- Flash /CS
       -- Bus SPI
       F_SI      : OUT   std_logic;
       F_SO      : IN    std_logic;
       F_SCK     : OUT   std_logic;

       FBOUT     : OUT   std_logic_vector (7 DOWNTO 0); -- SPI Output Byte

       -- Compensation SRAM signals
       RAMAD_SPI : OUT   std_logic_vector(17 downto 0); -- LUT address
       RAMDT_SPI : OUT   std_logic_vector(13 downto 0); -- LUT data
       NWRLUT    : OUT   std_logic; -- Write enable
       NOELUT    : OUT   std_logic; -- Write enable

       LOAD_RES  : OUT   std_logic; -- mentre leggo la flash e carico la SRAM
                                    -- con la tabella di compensazione tengo tutto in RESET
                                    -- (attivo basso)
       REGS      : INOUT VME_REG_RECORD;
	   
       PULSE     : IN    reg_pulse;

       SP0       : INOUT std_logic; -- Spare
       SP1       : INOUT std_logic;
       SP2       : INOUT std_logic;
       SP3       : INOUT std_logic;
       SP4       : INOUT std_logic;
       SP5       : INOUT std_logic
   );

-- Declarations

END SPI_INTERF ;


ARCHITECTURE RTL OF SPI_INTERF IS

  --------------------------------------------------------------------
  -- FSM
  attribute syn_encoding : string;

  type  TSTATE1  is (S1_COUNT, S1_WAIT_CSS, S1_WAIT_CSH, S1_WAIT_CS,
                     S1_NEWCOMM,S1_WAITLUT,S1_NEWLUT,S1_WROFFSET,
                     S1_IDLE,S1_SPI0,S1_SPI1,S1_SPI2);

  signal  sstate  : TSTATE1;
  attribute syn_encoding of sstate : signal is "onehot";

  --------------------------------------------------------------------
  signal   SBYTE     : std_logic_vector(7 downto 0);   -- byte SPI
  signal   ISI       : std_logic;                      -- SPI SI dalla FSM
  signal   ISCK      : std_logic;                      -- SPI SCK dalla FSM

  signal   LOAD_RESi : std_logic;                      -- LOAD_RES dalla FSM
  signal   NWRLUTi   : std_logic;
  signal   NOELUTi   : std_logic;

  signal   NCS0      : std_logic;                      -- NCS gestito dalla FSM al power ON

  constant CMD_SR    : std_logic_vector (7 downto 0) := "11101000"; -- stream di command 0xE8

  signal   BITCNT    : std_logic_vector (2 downto 0);  -- conta i bit durante lo shift
  signal   BYTECNT   : std_logic_vector (8 downto 0);  -- conta i byte durante la rilettura di una pagina (264 byte x pagina)
  signal   PAGECNT   : std_logic_vector (9 downto 0);  -- conta le pagine (leggo 1024 pagine di 2048)

  signal   OFFSET_FL : std_logic_vector (29 downto 0); -- FLAG che selezionano quale registro OFFSET deve essere caricato

  signal   nbyte     : std_logic_vector (8 downto 0); 
  signal   npage     : std_logic_vector (9 downto 0); 

  constant nbyte_syn : std_logic_vector (8 downto 0) := "100000111";   -- 263  
  
  constant npage_syn : std_logic_vector (9 downto 0) := "1111111111";  -- 1023 -- **** da usare in sintesi ****
  constant npage_sim : std_logic_vector (9 downto 0) := "0000000001";  -- **** da usare in simulazione ****

  signal   page  : integer range 0 to 1023;

  signal   COMMAND     : std_logic;
  signal   LUT         : std_logic;
  signal   NORMAL      : std_logic;

  --------------------------------------------------------------------


begin

  -- HACK: assegnamento necessario per la simulazione
  --REGS.STATUS(S_RES1) <= '0';

  nbyte <= nbyte_syn;
  npage <= npage_syn when SIM_MODE = FALSE else npage_sim;


  REGS.STATUS(S_LUT) <= not LOAD_RESi;


  FCS   <= REGS.FLEN(FLEN_FCS) and NCS0;
  F_SI  <= ISI;
  F_SCK <= ISCK;

  FBOUT <= SBYTE;  -- Byte in uscita dalla Flash SPI


  LOAD_RES <= LOAD_RESi;

  page     <= conv_integer(PAGECNT);

  U_SPI_acc_fsm : process (HWRES,CLK)
  begin

    if HWRES = '0' then

      ISCK      <= '0';
      ISI       <= '0';
      SBYTE     <= (others => '0');

      LOAD_RESi <= '0';

      NCS0      <= '1';

      PAGECNT   <= (others => '0'); -- leggo 1024 pagine
      BYTECNT   <= (others => '0'); -- di ciascuna pagina leggo 264 byte (scrivo nella LUT solo 256 byte)
      BITCNT    <= (others => '0');

      NWRLUTi   <= '1';
      NOELUTi   <= '1';
      COMMAND   <= '1';
      LUT       <= '0';
      NORMAL    <= '0';
      OFFSET_FL <= (others => '0');

      sstate    <= S1_COUNT;

    elsif CLK'event and CLK = '1' then

      if PULSE(LOAD_LUT) ='1' then  -- reset SINCRONO

        ISCK      <= '0';
        ISI       <= '0';
        SBYTE     <= (others => '0');

        LOAD_RESi <= '0';

        NCS0      <= '1';

        PAGECNT   <= (others => '0'); -- leggo 1024 pagine
        BYTECNT   <= (others => '0'); -- di ciascuna pagina leggo 264 byte (scrivo nella LUT solo 256 byte)
        BITCNT    <= (others => '0');

        NWRLUTi   <= '1';
        NOELUTi   <= '1';
        COMMAND   <= '1';
        LUT       <= '0';
        NORMAL    <= '0';
        OFFSET_FL <= (others => '0');

        sstate    <= S1_COUNT;

      else

        case sstate is

          --------------------------------------------------------------------
          -- ATTESA AL POWER ON: uso PAGECNT per attendere 1024 cicli di clock
          --------------------------------------------------------------------
          when S1_COUNT   => if PAGECNT = npage then
                               PAGECNT <= (others => '0');
                               NCS0     <= '0';               -- attivo il chip select
                               BYTECNT  <= "000000000";
                               sstate   <= S1_WAIT_CSS;
                             else
                               --PAGECNT <= PAGECNT + 1;
                               PAGECNT(7 downto 0) <= PAGECNT(7 downto 0) + 1;
                               if PAGECNT(7 downto 0) = 16#FF# then
                                 PAGECNT(9 downto 8) <= PAGECNT(9 downto 8) + 1;
                               end if;
                               sstate  <= S1_COUNT;
                             end if;

          --------------------------------------------------------------------
          -- CARICAMENTO TABELLA DI COMPENSAZIONE: modalità POWER ON
          --------------------------------------------------------------------
          -- devo aspettare almeno 250 ns da quando attivo NCS al primo fronte di SCK (NCS setup time)
          when S1_WAIT_CSS=> if BYTECNT = "000001001" then
                               SBYTE  <= CMD_SR;              -- carico lo shift register con il command
                               ISI    <= CMD_SR(CMD_SR'high); -- preparo il primo bit
                               BITCNT <= "000";
                               BYTECNT<= (others => '0');
                               sstate <= S1_SPI0;             -- vado a serializzare
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
          -- lettura 1023 pagine di 264 byte ciascuna
          when S1_WAITLUT => NWRLUTi <= '1';
                             sstate  <= S1_NEWLUT;  -- attesa prima di cambiare gli indirizzi della LUT

          when S1_NEWLUT  => BITCNT  <= "000";
                             if BYTECNT = nbyte then          -- ho finito i byte:
                               if PAGECNT = npage then          -- ho finito le pagine: vado in modalità NORMAL
                                 LUT     <= '0';
                                 NORMAL  <= '1';
                                 BYTECNT <= (others => '0');
                                 sstate  <= S1_WAIT_CSH;
                               else
                                 ISCK    <= '0';               -- non ho finito le pagine:
                                 --PAGECNT <= PAGECNT + 1;       -- incremento il contatore di pagina
                                 PAGECNT(7 downto 0) <= PAGECNT(7 downto 0) + 1;
                                 if PAGECNT(7 downto 0) = 16#FF# then
                                   PAGECNT(9 downto 8) <= PAGECNT(9 downto 8) + 1;
                                 end if;

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
          when S1_WAIT_CSH=> NWRLUTi  <= '1';
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
                               sstate <= S1_IDLE;
                             else
                               BYTECNT<= BYTECNT + 1;
                               sstate <= S1_WAIT_CS;
                             end if;


          --------------------------------------------------------------------
          -- LETTURA/SCRITTURA DA VME: modalità NORMAL
          --------------------------------------------------------------------
          when S1_IDLE  => LOAD_RESi<= '1';
                           NOELUTi  <= '0';
                           ISI      <= '0';
                           ISCK     <= '0';
                           if PULSE(WP_SPI) = '1' then
                             SBYTE  <= REGS.FLASH;                   -- carico lo shift register
                             ISI    <= REGS.FLASH(REGS.FLASH'high);  -- preparo il primo bit
                             BITCNT <= "000";
                             sstate <= S1_SPI0;
                           end if;

          --------------------------------------------------------------------
          -- serializzazione dato
          --------------------------------------------------------------------
          when S1_SPI0    => ISCK      <= '1';
                             SBYTE     <= SBYTE(SBYTE'high-1 downto SBYTE'low) & F_SO;
                             sstate    <= S1_SPI1;

          when S1_SPI1    => ISCK      <= '0';
                             sstate    <= S1_SPI2;

          when S1_SPI2    => ISCK      <= '0';
                             if BITCNT = "111" then
                               if COMMAND = '1' then
                                 sstate  <= S1_NEWCOMM;
                               elsif LUT = '1' then

                                 sstate  <= S1_WAITLUT;

                                 if BYTECNT <= "011111111" then
                                   NWRLUTi   <= '0';            -- scrivo il byte letto nella SRAM
                                 end if;
                                 -- per ogni chip ci sono a disposizione 32 pagine della flash
                                 -- (4 pagine a canale x 8 canali).
                                 -- Scrivo l'OFFSET al 257° byte della pagina 0 di ogni chip.
                                 if BYTECNT = "100000000" then  -- scrivo l'OFFSET
                                   case page is
                                     -- catena A
                                     when 0   => OFFSET_FL( 0) <= '1';
                                     when 32  => OFFSET_FL( 1) <= '1';
                                     when 64  => OFFSET_FL( 2) <= '1';
                                     when 96  => OFFSET_FL( 3) <= '1';
                                     when 128 => OFFSET_FL( 4) <= '1';
                                     when 160 => OFFSET_FL( 5) <= '1';
                                     when 192 => OFFSET_FL( 6) <= '1';
                                     when 224 => OFFSET_FL( 7) <= '1';
                                     when 256 => OFFSET_FL( 8) <= '1';
                                     when 288 => OFFSET_FL( 9) <= '1';
                                     when 320 => OFFSET_FL(10) <= '1';
                                     when 352 => OFFSET_FL(11) <= '1';
                                     when 384 => OFFSET_FL(12) <= '1';
                                     when 416 => OFFSET_FL(13) <= '1';
                                     when 448 => OFFSET_FL(14) <= '1';
                                     -- catena B
                                     when 512 => OFFSET_FL(15) <= '1';
                                     when 544 => OFFSET_FL(16) <= '1';
                                     when 576 => OFFSET_FL(17) <= '1';
                                     when 608 => OFFSET_FL(18) <= '1';
                                     when 640 => OFFSET_FL(19) <= '1';
                                     when 672 => OFFSET_FL(20) <= '1';
                                     when 704 => OFFSET_FL(21) <= '1';
                                     when 736 => OFFSET_FL(22) <= '1';
                                     when 768 => OFFSET_FL(23) <= '1';
                                     when 800 => OFFSET_FL(24) <= '1';
                                     when 832 => OFFSET_FL(25) <= '1';
                                     when 864 => OFFSET_FL(26) <= '1';
                                     when 896 => OFFSET_FL(27) <= '1';
                                     when 928 => OFFSET_FL(28) <= '1';
                                     when 960 => OFFSET_FL(29) <= '1';
                                     when others => null;
                                   end case;
                                   sstate  <= S1_WROFFSET;
                                 end if;

                               else
                                 sstate  <= S1_IDLE;
                               end if;
                             else
                               BITCNT  <= BITCNT + 1;
                               ISI     <= SBYTE(SBYTE'high);
                               sstate  <= S1_SPI0;
                             end if;

          when S1_WROFFSET=> sstate    <= S1_WAITLUT;
                             OFFSET_FL <= (others =>'0');
                             -- eliminati!


        end case;
      end if;
    end if;
  end process;


  -- ******************************************************************
  -- ACCESSO ALLA SRAM DI COMPENSAZIONE
  -- La SRAM è scritta dall'interfaccia SPI
  -- Il ROC rilegge la SRAM per la compensazione.
  -- ******************************************************************
  RAMAD_SPI <= PAGECNT & BYTECNT(7 downto 0) when LOAD_RESi = '0' else (others => 'Z');

  -- NWRLUT e RAMDT sono ritardate di un ciclo di clock (pipeline nel ROC)
  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      RAMDT_SPI <= (others => 'Z');
      NWRLUT    <= '1';
    elsif CLK'event and CLK = '1' then
      if LOAD_RESi = '0' then
        RAMDT_SPI <= SBYTE(6 downto 0) & SBYTE(6 downto 0);
      else
        RAMDT_SPI <= (others => 'Z');
      end if;
      NWRLUT    <= NWRLUTi;
    end if;
  end process;

  NOELUT <= NOELUTi;

  -------------------------------------------
  -- debugging section
  -------------------------------------------
  SP0 <= 'Z';
  SP1 <= 'Z';
  SP2 <= 'Z';
  SP3 <= 'Z';
  SP4 <= 'Z';
  SP5 <= 'Z';

END RTL;


