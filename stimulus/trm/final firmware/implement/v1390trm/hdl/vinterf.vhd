-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA750
-- Author:          Annalisa Mati
-- Date:            21/06/13
-- --------------------------------------------------------------------------
-- Module:          VINTERF
-- Description:     RTL module: VME Interface
-- **************************************************************************

-- ##########################################################################
-- Revision History:
-- 30.05: Release rilasciata
-- 00.00: - tolto il registro SRAM EVENT (addr 0x100; era stato inserito per
--          debug)
--        - aggiunto il registro BNCID OFFSET (addr 0x2000)
--          per l'inizializzazione del BNC ID
--        - cambiato il significato del LED bicolore
--        - timout del watchdog = 10ms
--        - aggiunto il registro TEST TOKEN TIMOUT
-- 00.01: - Aggiunti i registri TEMPA e TEMPB
-- 00.03  - risolto un baco nella rilettura del BNCID_OFF
-- 00.05  - tolto il WATCH DOG del VME (la FSM è dichiarata "safe")
--        - il registro CONTROL è stato dichiarato su 8 bit anzichè 16 (gli 8
--          più significativi erano non usati)
-- NUOVA RELEASE 2013:
-- eliminati i registri per gli OFFSET per la sottrazione TRAILING-LEADING-OFFSET
-- implementato il 2eSST Alice style
-- ##########################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1390pkg.all;

ENTITY VINTERF IS
   PORT(
       CLK       : IN    std_logic;
       HWRES     : IN    std_logic;
       CLEAR_STAT: IN    std_logic;
       HWCLEAR   : IN    std_logic;

       -- VME interface signals
       ASB       : IN    std_logic;
       DS0B      : IN    std_logic;
       DS1B      : IN    std_logic;
       WRITEB    : IN    std_logic;
       IACKB     : IN    std_logic;
       IACKINB   : IN    std_logic;
       IACKOUTB  : OUT   std_logic;
       NDTKIN    : OUT   std_logic;
       NOEDTK    : OUT   std_logic;  -- DTACK OE
       BERRVME   : IN    std_logic;
       MYBERR    : OUT   std_logic;
       LWORDB    : INOUT std_logic;
       VAD       : INOUT std_logic_vector (31 downto 1);
       VDB       : INOUT std_logic_vector (31 downto 0);
       AMB       : IN    std_logic_vector ( 5 downto 0);
       GA        : IN    std_logic_vector ( 4 downto 0); -- GEO Address (su connettore a 5 file)

       INTR1     : OUT   std_logic;  -- Interrupt Request 1
       INTR2     : OUT   std_logic;  -- Interrupt Request 2

       ADLTC     : OUT   std_logic;  -- Latch degli indirizzi (sempre a 0)
       NOE16R    : OUT   std_logic;  -- OE dati bassi Scheda -> VME
       NOE16W    : OUT   std_logic;  -- OE dati bassi VME -> Scheda
       NOE32R    : OUT   std_logic;  -- OE dati alti Scheda -> VME
       NOE32W    : OUT   std_logic;  -- OE dati alti VME -> Scheda
       NOE64R    : OUT   std_logic;  -- OE dei dati verso il VME nel BLT64
       NOEAD     : OUT   std_logic;  -- OE indirizzi Scheda -> VME nel D64

       NOEMIC    : OUT   std_logic;  -- data OE, dal micro al VME
       STBMIC    : OUT   std_logic;  -- data strobe, dal VME al micro

       -- FIFO signals (memoria di secondo livello)
       DPR       : IN    std_logic_vector (31 downto 0);
       DPR_P     : IN    std_logic;
       NRDMEB    : OUT   std_logic;  -- read MEB
       PAF       : IN    std_logic;
       PAE       : IN    std_logic;
       EF        : IN    std_logic;  -- FIFO output ready (/OR)
       FF        : IN    std_logic;

       -- Compensation SRAM signals
       RAMDT     : IN    std_logic_vector(13 downto 0); -- LUT data
       RAMAD_VME : OUT   std_logic_vector(17 downto 0); -- LUT address

       -- Segnali scambiati con il ROC
       EVRDY     : IN    std_logic;  -- almeno un evento pronto nel MEB (dal ROC)
       EVREAD    : OUT   std_logic;  -- segnala che è stato riletto un evento dal MEB
       DTEST_FIFO: IN    std_logic;  -- segnala che è stato scrito un dato di test nella FIFO

       -- Flash Byte Out
       FBOUT     : IN    std_logic_vector (7 DOWNTO 0);

       -- Spare
       SP0       : INOUT std_logic;
       SP1       : INOUT std_logic;
       SP2       : INOUT std_logic;
       SP3       : INOUT std_logic;
       SP4       : INOUT std_logic;
       SP5       : INOUT std_logic;


       LED_R     : OUT   std_logic;
       LED_G     : OUT   std_logic;
	   
       REGS      : INOUT VME_REG_RECORD;
	   
       PULSE     : OUT   reg_pulse;
       TICK      : OUT   tick_pulses
       );

END VINTERF ;


ARCHITECTURE RTL OF VINTERF IS

-- **************************************************************************
  signal D32,D16,RONLY,WONLY: boolean;
  signal REGMAP   : std_logic_vector (26 downto 0);

  signal ASBS     : std_logic;
  signal DSS      : std_logic;                      -- DS0/1 cloccato

  signal CYCS     : std_logic;
  signal CYCS1    : std_logic;
  signal VSEL     : std_logic; -- impulso di 1 clk in corrispondenza del primo DS0/1

  signal ASBSF1   : std_logic;
  signal DSSF1    : std_logic;
  signal CYCSF1   : std_logic;

  signal DS       : std_logic;                      -- OR dei DS

  signal WRITES   : std_logic;                      -- WRITE del VME cloccato
  signal LWORDS   : std_logic;                      -- LWORD del VME cloccato
  signal VAS      : std_logic_vector(15 downto 0);  -- VAD[15:0] cloccati
  signal REG_ADS  : integer range 0 to LAST_ADDRESS;-- = VAS

  signal PURGED   : std_logic;                      -- segnale di PURGED per il BLT

    -- segnali per il DTACK
  signal CLOSEDTK : std_logic; -- segnale per la chiusura del DTACK: si attiva quando il DS torna a 1
                               -- e si disattiva quando il MYDTACKi (uscita della FSM) va a 1
  signal MYDTACKi : std_logic; -- DTACK uscita della FSM (usato solo internamente)
  signal NDTKINi  : std_logic; -- DTACK sul bus VME
  signal NOEDTKi  : std_logic; -- DTACK OE

  signal VDBi     : std_logic_vector(31 downto 0);  -- VDB interni (pilotati dalla FSM nel caso di ciclo singolo)
  signal VDBm     : std_logic_vector(31 downto 0);  -- VDB interni (Uscita del MUX)
  signal VADm     : std_logic_vector(31 downto 0);  -- VAD interni (Uscita del MUX)

  signal ANYCYC   : std_logic; -- è il corso un qualunque ciclo VME su di me

  signal SINGCYC  : std_logic; -- è il corso un ciclo singolo
  signal BLTCYC   : std_logic; -- è il corso un ciclo BLT32
  signal MBLTCYC  : std_logic; -- è il corso un ciclo BLT64
  signal ADACKCYC : std_logic; -- è il corso un ciclo di address ack.
  signal V2eSSTCYC: std_logic; -- è il corso un ciclo 2eSST 
  signal BEAT_CNT : std_logic_vector( 8 downto 0);
  signal START_2eSSTCYC : std_logic; -- da FSM1 a FSM2
  signal END_2eSSTCYC : std_logic;

  signal SELBASE32: std_logic; -- indirizzamento mediante Base address su tamburino

  signal RAMDTS   : std_logic_vector(13 downto 0); -- dati dalla LUT sincronizzati

  -- segnali buffer
  signal NOE16Ri  : std_logic;
  signal NOE32Ri  : std_logic;
  signal NOE64Ri  : std_logic;
  signal NOE16Wi  : std_logic;
  signal NOE32Wi  : std_logic;
  signal NRDMEBi  : std_logic;
  signal EVREADi  : std_logic;   -- Si setta quando da VME è stato riletto un evento (dura 1 ciclo di clock)
  signal EVREAD_DS: std_logic;   -- Si setta quando da VME è stato riletto un evento (si resetta solo alla fine del ciclo VME)
  signal MYBERRi  : std_logic;


  -- registri di PIPE per la rilettura della FIFO
  signal PIPEA1   : std_logic_vector(31 downto 0);
  signal PIPEA    : std_logic_vector(31 downto 0);
  signal PIPEB    : std_logic_vector(31 downto 0);
  signal END_PK   : std_logic;   -- Si setta quando è stato riletto un evento dalla FIFO
  signal EFS      : std_logic;


  signal TCNT1 : std_logic_vector(5 downto 0) := (others => '0');
  signal TCNT2 : std_logic_vector(7 downto 0) := (others => '0');
  signal TCNT3 : std_logic_vector(7 downto 0) := (others => '0');
  signal TCNT4 : std_logic_vector(3 downto 0) := (others => '0');
  signal TICKi : tick_pulses;


  -- contatore per generare attese di varia lunghezza
  signal TCNT     : std_logic_vector(4 downto 0) := (others => '0');


  -- Per fare i registri in triplice copia:
  -- il registro CONTROL e il segistro ACQUISITION sono in triplice copia
  signal CONTROL1 : std_logic_vector(D_CONTROL'high downto D_CONTROL'low);
  signal CONTROL2 : std_logic_vector(D_CONTROL'high downto D_CONTROL'low);
  signal CONTROL3 : std_logic_vector(D_CONTROL'high downto D_CONTROL'low);
  signal ACQUISITION1 : std_logic_vector(D_ACQUISITION'high downto D_ACQUISITION'low);
  signal ACQUISITION2 : std_logic_vector(D_ACQUISITION'high downto D_ACQUISITION'low);
  signal ACQUISITION3 : std_logic_vector(D_ACQUISITION'high downto D_ACQUISITION'low);

  attribute syn_preserve : boolean;
  attribute syn_preserve of CONTROL1 : signal is true;
  attribute syn_preserve of CONTROL2 : signal is true;
  attribute syn_preserve of CONTROL3 : signal is true;
  attribute syn_preserve of ACQUISITION1 : signal is true;
  attribute syn_preserve of ACQUISITION2 : signal is true;
  attribute syn_preserve of ACQUISITION3 : signal is true;
  
  -- ************************************************************************

  -- Definizione degli stati
  attribute syn_encoding : string;

  -- FSM1 che gestisce gli accessi VME
  type   TSTATE1 is (S1_IDLE,  S1_START, S1_SNGDTK,  S1_ENDCYC,
                     S1_ADDACK,S1_BIDLE, S1_ENDBCYC, 
					 S1_2eCYC1, S1_2eCYC2, S1_2eENDCYC,
                     S1_RSPI,  S1_RLUT);
  signal VME_SLAVE_FSM : TSTATE1;
  attribute syn_encoding of VME_SLAVE_FSM : signal is "safe,onehot";

  -- FSM2 che gestisce la rilettura della FIFO
  type   TSTATE2 is (S2_READ1, S2_WAIT, S2_READ2, S2_WAITCYC, S2_ENDDS,
                     S2_2eREAD1, S2_2eREAD2);
  signal READ_FIFO_FSM : TSTATE2;
  attribute syn_encoding of READ_FIFO_FSM : signal is "onehot";

  -- ************************************************************************


begin

  INTR1 <= '0';
  INTR2 <= '0';


  -- ########################################################################
  -- Flip Flip con possibile violazione di setup time:
  -- ########################################################################
  -- CYCS e DSS sono gli unici flip flop che ricevono in ingresso i segnali asincroni
  -- del VME con la possibilita' di violare il setup time.
  -- Non ci sono corse critiche perche' DSS dipende da CYCS e si setta sempre un ciclo dopo
  -- rispetto ad esso. Quindi non si ha mai una situazione di incertezza di un ciclo di
  -- clock dell'uno rispetto all'altro.
  -- Il resto della logica si attiva come conseguenza di CYCS e DSS e riceve in ingresso
  -- segnali sincroni oppure asincroni dal VME ma gia' stabili da piu' di un periodo di clock.

  -- coppia adi FF per sincronizzare AS
  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      ASBSF1 <= '1';
      ASBS   <= '1';
    elsif CLK'event and CLK = '1' then
      ASBSF1 <= ASB;
      ASBS   <= ASBSF1;
    end if;
  end process;

  -- CYCS e' un segnale sincrono che si attiva in corrispondenza del primo fronte di clock
  -- dopo che AS (cloccato) e DS0/1 sono andati bassi e si disattiva al primo fronte di clock
  -- dopo che AS (cloccato) e' tornato alto.
  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      CYCSF1 <= '0';
    elsif CLK'event and CLK = '1' then
      if ASBS = '1' then
        CYCSF1 <= '0';
      elsif ASBS='0' and (DS0B = '0' or DS1B = '0') then
        CYCSF1 <= '1';
      end if;
    end if;
  end process;

  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      CYCS <= '0';
    elsif CLK'event and CLK = '1' then
      CYCS <= CYCSF1;
    end if;
  end process;


  -- DSS e' un segnale sincrono che nel caso di accesso singolo o al primo DS di un BLT
  -- si attiva un ciclo di clock dopo CYCS (ovvero due fronti di clock dopo AS e/o DS0/1);
  -- ai successivi DS di un BLT si attiva al primo fronte di clock dopo il fronte dei DS0/1
  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      DSSF1  <= '1';
    elsif CLK'event and CLK = '1' then
      if ASBS = '1' then
        DSSF1  <= '1';
      elsif CYCS='1' then
        DSSF1 <= DS0B and DS1B;
      end if;
    end if;
  end process;

  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      DSS <= '1';
    elsif CLK'event and CLK = '1' then
      DSS <= DSSF1;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- A partire da CYCS e nDSS, genero un segnale VSEL che dura
  -- un solo ciclo di clock.
  ---------------------------------------------------------------------------
  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      CYCS1 <= '0';
    elsif CLK'event and CLK = '1' then
      if ASBS = '1' then
        CYCS1 <= '0';
      else
        CYCS1 <= CYCS;
      end if;
    end if;
  end process;
  VSEL <= (CYCS and not CYCS1) and not ASBS;


  -- ########################################################################
  -- Selezione del modulo
  -- ########################################################################
  -- Processo per lecciare gli indirizzi. ATTENZIONE: qui genero volutamente un latch
  process(ASB,VAD,GA)
  begin
    if ASB = '1' then
      if VAD(31 downto 28) = not GA(3 downto 0) then     -- indirizzamento mediante Geo address
        SELBASE32 <= '1';
      else
        SELBASE32 <= '0';
      end if;
    end if;
  end process;


  -- ########################################################################
  -- processo per stabilire il tipo di ciclo in corso (singolo, BLT, MBLT, 2eSST) e
  -- strobare gli indirizzi (selezione)
  -- ########################################################################
  -- ANYCYC = '1' -> è in corso un qualunque ciclo VME su di me
  ANYCYC <= SINGCYC or BLTCYC or MBLTCYC; -- or V2eSSTCYC;

  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      SINGCYC  <= '0';
      BLTCYC   <= '0';
      MBLTCYC  <= '0';
      ADACKCYC <= '0';
      V2eSSTCYC<= '0';
      VAS      <= (others => '0');
    elsif CLK'event and CLK = '1' then

      if ASBS = '1' then
        SINGCYC  <= '0';
        BLTCYC   <= '0';
        MBLTCYC  <= '0';
        ADACKCYC <= '0';
        V2eSSTCYC<= '0';

      elsif VSEL='1' then

        VAS <= VAD(15 downto 1) & '0';

        if IACKB = '1' then

          -- CICLO SINGOLO
          if AMB=A32_U_DATA and SELBASE32 = '1' then
            SINGCYC <= '1';
          end if;
          -- CICLO BLT
          if AMB=A32_U_BLT  and SELBASE32 = '1' then
            BLTCYC <= '1';
          end if;
          -- CICLO MBLT
          if AMB=A32_U_MBLT and SELBASE32 = '1' then
            MBLTCYC  <= '1';
            ADACKCYC <= '1';
          end if;
          -- CICLO 2eSST (A32/D64)
          if AMB=A32_2eSST and SELBASE32 = '1' then
            V2eSSTCYC <= '1';  -- nel 2eSST non faccio il ciclo di Address ACK.
          end if;

        end if;

      elsif VME_SLAVE_FSM = S1_BIDLE then
        ADACKCYC <= '0'; -- terminato il ciclo di address ack
      end if;
    end if;
  end process;


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM che gestisce gli accessi VME
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  ---------------------------------------------------------------------------
  -- sincronizzazioni segnali dal VME per la FSM
  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      WRITES   <= '0';
      LWORDS   <= '0';
      RAMDTS   <= (others =>'0');
    elsif CLK'event and CLK = '1' then
      if VSEL='1' then
        WRITES  <= WRITEB;
        LWORDS  <= LWORDB;
      end if;
      RAMDTS  <= RAMDT;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- MAJORITY DEI REGISTRI IN TRIPLICE COPIA
  REGS.CONTROL           <= majority(CONTROL1,CONTROL2,CONTROL3,D_CONTROL'length);
  REGS.ACQUISITION       <= majority(ACQUISITION1,ACQUISITION2,ACQUISITION3,D_ACQUISITION'length);

  
  U_vme_acc_fsm : process(CLK, HWRES)
    procedure triplica_control (data   :  in  std_logic_vector) is
    begin
      CONTROL1 <= data;
      CONTROL2 <= data;
      CONTROL3 <= data;
    end;
    procedure triplica_acq (data   :  in  std_logic_vector) is
    begin
      ACQUISITION1 <= data;
      ACQUISITION2 <= data;
      ACQUISITION3 <= data;
    end;

  begin
    if HWRES ='0' then

      VME_SLAVE_FSM  <= S1_IDLE;
      MYDTACKi   <= '1';
      NDTKINi    <= '1';
      NOEDTKi    <= '1';
      MYBERRi    <= '1';
      IACKOUTB   <= '1';
      VDBi       <= (others => '0');

      PULSE      <= (others => '0');
      -- strobe dei dati nei tranceiver VME al micro
      STBMIC     <= '1';

      RAMAD_VME  <= (others => '0');

      TCNT       <= (others => '0');

      BEAT_CNT   <= (others => '0');
	  START_2eSSTCYC <= '0';

      triplica_acq(D_ACQUISITION);
      triplica_control(D_CONTROL);

	  REGS.TESTREG    <= D_TESTREG;
      REGS.FLASH      <= D_FLASH;
      REGS.FLEN       <= D_FLEN;
      REGS.I2CCOM     <= D_I2CCOM;
      REGS.SRAM_PAGE  <= D_SRAM_PAGE;
      REGS.DUMMY32    <= D_DUMMY32;
      REGS.BNCID_OFF  <= D_BNCID_OFF;
	  
    elsif CLK'event and CLK='1' then

      if HWCLEAR = '0' then
        triplica_acq(D_ACQUISITION);
      end if;

      case VME_SLAVE_FSM is
	  
        when S1_IDLE   => MYDTACKi <= '1';
                          NDTKINi  <= '1';

		                  if (DSS ='0' and ANYCYC = '1') then     -- apetto l'inizio del ciclo VME (tutti i cicli escluso il 2ESST)
						    VME_SLAVE_FSM  <= S1_START;
						  elsif V2eSSTCYC = '1' then
							VME_SLAVE_FSM  <= S1_2eCYC1;
                          end if;

        when S1_START  => -- CICLO SINGOLO
                          if SINGCYC='1' then

                            if REGMAP(S_ANY) = '1' then -- accesso ad un registro della scheda

                              VME_SLAVE_FSM  <= S1_SNGDTK;

                              if REGMAP(S_MICRO) = '1' and WRITES='0' then
                                STBMIC  <= '0';
                              end if;

                              if WRITES ='1' then      -- ACCESSO IN LETTURA
                                -- metto i dati sul bus
                                VDBi <= (others => '0');
                                if REGMAP(S_CONTROL)   = '1' then VDBi(D_CONTROL'range)    <= REGS.CONTROL;    end if;
                                if REGMAP(S_ACQUISITION)='1' then VDBi(D_ACQUISITION'range)<= REGS.ACQUISITION;end if;
                                if REGMAP(S_STATUS)    = '1' then VDBi(D_STATUS'range)     <= REGS.STATUS;     end if;
                                if REGMAP(S_GEO_AD)    = '1' then VDBi(GA'range)           <= '0' & (not GA(3 downto 0)); end if;
                                if REGMAP(S_EVNT_STOR) = '1' then VDBi(D_EVNT_STOR'range)  <= REGS.EVNT_STOR;  end if;
                                if REGMAP(S_FIRM_REV)  = '1' then VDBi(D_FIRM_REV'range)   <= D_FIRM_REV;      end if;
                                if REGMAP(S_TESTREG)   = '1' then VDBi(D_TESTREG'range)    <= REGS.TESTREG;    end if;
                                if REGMAP(S_PROGHS)    = '1' then VDBi(D_PROGHS'range)     <= REGS.PROGHS;     end if;
                                if REGMAP(S_FLEN)      = '1' then VDBi(D_FLEN'range)       <= REGS.FLEN;       end if;
                                if REGMAP(S_SRAM_PAGE) = '1' then VDBi(D_SRAM_PAGE'range)  <= REGS.SRAM_PAGE;  end if;
                                if REGMAP(S_DUMMY32)   = '1' then VDBi(D_DUMMY32'range)    <= REGS.DUMMY32;    end if;
                                if REGMAP(S_I2CDAT)    = '1' then VDBi(D_I2CDAT'range)     <= REGS.I2CDAT;     end if;
                                if REGMAP(S_TEMPA)     = '1' then VDBi(D_TEMPA'range)      <= REGS.TEMPA;      end if;
                                if REGMAP(S_TEMPB)     = '1' then VDBi(D_TEMPB'range)      <= REGS.TEMPB;      end if;
                                if REGMAP(S_BNCID_OFF) = '1' then VDBi(D_BNCID_OFF'range)  <= REGS.BNCID_OFF;  end if;

                                if REGMAP(S_MICRO)  = '1' then
                                  PULSE(RP_MICRO) <= '1';           -- lettura MICRO
                                end if;

                                if REGMAP(S_FLASH)  = '1' then      -- lettura dalla FLASH
                                  REGS.FLASH       <= (others => '0');
                                  PULSE(WP_SPI)    <= '1';
                                  TCNT   <= "11111";
                                  VME_SLAVE_FSM <= S1_RSPI;
                                end if;

                                if REGMAP(S_SRAM)  = '1' then       -- lettura dalla LUT
                                  RAMAD_VME  <= REGS.SRAM_PAGE & VAS(8 downto 1);
                                  TCNT   <= "00100";
                                  VME_SLAVE_FSM <= S1_RLUT;
                                end if;

                                if REGMAP(S_OUTBUF) = '1' then      -- LETTURA IN D32 DEL MEB
                                  VDBi(D_OUTBUF'range) <= PIPEA;
                                end if;
                              end if;
                            else
                              VME_SLAVE_FSM  <= S1_ENDCYC;     -- accesso ad un indrizzo non riconosciuto
                            end if;

                          -- BLT32: il primo dato è già pronto
                          elsif BLTCYC='1' and REGMAP(S_OUTBUF) = '1' then
                            VME_SLAVE_FSM <= S1_BIDLE;

                          -- BLT64: devo eseguire il ciclo di address acknowledge
                          elsif MBLTCYC = '1' and REGMAP(S_OUTBUF) = '1' then
						    MYDTACKi<= '0';
                            NDTKINi <= '0';
                            NOEDTKi <= '0';
                            VME_SLAVE_FSM <= S1_ADDACK;
                          end if;

        -- ACCESSI SINGOLI --------------------------------------------------
        when S1_SNGDTK => MYDTACKi   <= '0';
                          NDTKINi    <= '0';
                          NOEDTKi    <= '0';
                          STBMIC     <= '1';

                          VME_SLAVE_FSM     <= S1_ENDCYC;

                          if WRITES ='0' then      -- ACCESSO IN SCRITTURA: strobe dei dati
                            if REGMAP(S_CONTROL)    = '1' then triplica_control(VDB(D_CONTROL'range)); end if;
                            if REGMAP(S_ACQUISITION)= '1' then triplica_acq(VDB(D_ACQUISITION'range)); end if;
                            if REGMAP(S_FLEN)       = '1' then REGS.FLEN        <= VDB(D_FLEN'range);      end if;
                            if REGMAP(S_SRAM_PAGE)  = '1' then REGS.SRAM_PAGE   <= VDB(D_SRAM_PAGE'range); end if;
                            if REGMAP(S_DUMMY32)    = '1' then REGS.DUMMY32     <= VDB(D_DUMMY32'range);   end if;
                            if REGMAP(S_BNCID_OFF)  = '1' then REGS.BNCID_OFF   <= VDB(D_BNCID_OFF'range); end if;

                            if REGMAP(S_MICRO) = '1' then
                              PULSE(WP_MICRO)  <= '1';  -- scrittura MICRO
                            end if;

                            if REGMAP(S_FLASH) = '1'  then
							  REGS.FLASH       <= VDB(D_FLASH'range);
                              PULSE(WP_SPI)    <= '1';  -- scrittura FLASH
                            end if;

                            if REGMAP(S_I2CCOM) = '1'  then
                              REGS.I2CCOM      <= VDB(D_I2CCOM'range);
                              PULSE(WP_I2C)    <= '1';  -- scrittura I2C
                            end if;

                            if REGMAP(S_TESTREG)    = '1' then
                              REGS.TESTREG          <= VDB(D_TESTREG'range);
                              PULSE(WP_FIFO)        <= '1';  -- la scrittura in TESTREG determina la scrittura nella FIFO
                            end if;

                            if REGMAP(S_LOAD_LUT )  = '1' then
                              PULSE(LOAD_LUT)       <= '1';  -- Load LUT
                            end if;

                            if REGMAP(S_SW_CLEAR)   = '1' then
                              PULSE(SW_CLEAR)       <= '1';  -- Clear software
                            end if;

                            if REGMAP(S_SW_TRIGGER) = '1' then
                              PULSE(SW_TRIGGER)     <= '1';  -- Trigger software
                            end if;

                            if REGMAP(S_TST_TIMOUT) = '1' then  -- token timout test pulses
                              if VDB(T_TIMOUTA) = '1' then
                                PULSE(M_TIMOUTA) <= '1';
                              end if;
                              if VDB(T_TIMOUTB) = '1' then
                                PULSE(M_TIMOUTB) <= '1';
                              end if;
                            end if;

                          end if;

        when S1_ENDCYC => PULSE      <= (others => '0');
                          if DSS='1' then                 -- apetto la fine del ciclo DS
                            VME_SLAVE_FSM   <= S1_IDLE;
                            MYDTACKi <= '1';
                            NDTKINi  <= '1';
                            NOEDTKi  <= '1';
                            IACKOUTB <= '1';
                            VDBi     <= (others => '0');
                          end if;

        -- ACCESSI BLT e MBLT -----------------------------------------------
        when S1_ADDACK => if DSS='1' then                 -- BLT64 address acknowledge
		                    MYDTACKi  <= '1';
                            NDTKINi   <= '1';
                            NOEDTKi   <= '1';
                            VME_SLAVE_FSM  <= S1_BIDLE;
                          end if;

        when S1_BIDLE  => if ASBS = '1' then              -- fine del Block Transfer
		                    MYDTACKi  <= '1';
                            NDTKINi   <= '1';
                            NOEDTKi   <= '1';
                            VME_SLAVE_FSM  <= S1_IDLE;
                          elsif DSS = '0'  then           -- apetto l'inizio del ciclo DS 
					        if PURGED = '0' then          -- non sono PURGED (ci sono dati da trasferire):
  		                      MYDTACKi<= '0';
                              NDTKINi <= '0';
                              NOEDTKi <= '0';             -- do il DTACK
                            else                          -- non ci sono dati da trasferire
                              MYBERRi <= '0';             -- do il BERR
                            end if;
							VME_SLAVE_FSM  <= S1_ENDBCYC;							
                          end if;

        when S1_ENDBCYC=> if DSS = '1'  then              -- aspetto la fine del ciclo DS (nel 2eSST non aspetto che si muova il DS)
                            VME_SLAVE_FSM  <= S1_BIDLE;
		                    MYDTACKi<= '1';
                            NDTKINi <= '1';
                            NOEDTKi <= '1';
                            MYBERRi <= '1';
                          end if;
						  
        -- ACCESSI 2eSST Alice Style ----------------------------------------
        when S1_2eCYC1   => START_2eSSTCYC <= '1';      -- chiedo alla FSM2 di fare avanzare la pipe dopo il primo dtack
                            NOEDTKi        <= '0';      -- tengo NOEDTKi abilitato fino alla fine del ciclo
							VME_SLAVE_FSM  <= S1_2eCYC2;							
                            
							
		                      
							
							  
        when S1_2eCYC2   => -- ho riletto un evento da VME (sniffo i dati che la fsm2 sta rileggendo dalla FIFO;
		                    -- nel caso di evento di 2 parole il trailer si trova anche in PIPEA1)
		                    if ((END_PK = '0' and ((DPR(31 downto 28) = G_TRAIL) or (PIPEA1(31 downto 28) = G_TRAIL))) or (END_PK = '1' and (PIPEA1(31 downto 28) = G_TRAIL))) then
						      --if (PIPEA(31 downto 28) = G_TRAIL or (PIPEB(31 downto 28) = G_TRAIL)) then 
			                  MYDTACKi  <= not MYDTACKi;
                              NDTKINi   <= not MYDTACKi;							  
                              MYBERRi   <= '0';           -- do il BERR
							  START_2eSSTCYC <= '0'; 
  							  VME_SLAVE_FSM  <= S1_2eENDCYC;							
		                    else                          -- non ho ancora riletto un evento
			                  MYDTACKi  <= not MYDTACKi;
                              NDTKINi   <= not MYDTACKi;							  
  							  VME_SLAVE_FSM  <= S1_2eCYC1;							
							end if;
						    
        when S1_2eENDCYC=>  if ASBS = '1' then            -- fine del Block Transfer
  		                      MYDTACKi<= '1';
                              NDTKINi <= '1';
                              NOEDTKi <= '1';
                              MYBERRi <= '1';
                              VME_SLAVE_FSM  <= S1_IDLE;
                            end if;
							
							
        ---------------------------------------------------------------------
        -- scrittura dalla FLASH
        when S1_RSPI      => TCNT <= TCNT - 1;
                             PULSE(WP_SPI) <= '0';
                             if TCNT = "00000" then
                               VDBi(D_FLASH'range) <= FBOUT;
                               VME_SLAVE_FSM <= S1_SNGDTK;
                             end if;

        -- lettura dalla LUT
        when S1_RLUT      => TCNT <= TCNT - 1;
                             if TCNT = "00000" then
                               VDBi(RAMDT'range) <= RAMDTS;
                               VME_SLAVE_FSM <= S1_SNGDTK;
                             end if;

      end case;
    end if;
  end process;



  ---------------------------------------------------------------------------
  -- il DTACK si attiva con la macchina a stati e si disattiva (con NOEDTK) 
  -- quando DS torna alto (escluso in 2eSST)
  ---------------------------------------------------------------------------
--  NDTKIN <= NOEDTKi or CLOSEDTK;
--  NOEDTK <= NOEDTKi;

  MYBERR <= MYBERRi;
  DS     <= (DS0B or DS1B);
  
  NDTKIN <= NDTKINi;


  -- il DTACK si attiva con la macchina a stati e si disattiva (con NOEDTK)
  -- quando DS torna alto (escluso in 2eVME/2eSST)
  process(DS,MYDTACKi)
  begin
    if MYDTACKi = '1' then
      CLOSEDTK <= '0';
    elsif DS'event and DS ='1' then
      CLOSEDTK <= '1';
    end if;
  end process;

  process(ANYCYC,V2eSSTCYC,NOEDTKi,CLOSEDTK)
  begin
    if V2eSSTCYC = '1' then
      NOEDTK <= NOEDTKi;
    elsif ANYCYC = '1' then
      NOEDTK <= CLOSEDTK;
    else
      NOEDTK <= '1';
    end if;
  end process;

  
  
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM che gestisce la rilettura della FIFO
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- NON POSSO RILEGGERE SE NON C'E' ALMENO 1 EVENTO IN MEMORIA!!!

  NRDMEB <= NRDMEBi;

  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      EFS <= '1';
    elsif CLK'event and CLK='1' then
      EFS <= EF;
    end if;
  end process;


  U_read_fifo_fsm : process(CLK, CLEAR_STAT)
    variable cnt_data : std_logic_vector(4 downto 0);
  begin
    if CLEAR_STAT ='0' then

      READ_FIFO_FSM  <= S2_READ1;
      NRDMEBi   <= '1';
      PIPEA1    <= D_OUTBUF;
      PIPEA     <= D_OUTBUF;
      PIPEB     <= D_OUTBUF;
      EVREADi   <= '0';  -- Si setta quando da VME è stato riletto un evento (dura 1 ciclo di clock)
      EVREAD_DS <= '0';  -- Si setta quando da VME è stato riletto un evento (si resetta solo alla fine del ciclo VME)
      END_PK    <= '0';  -- Si setta quando è stato riletto un evento dalla FIFO
	  cnt_data  := (others => '0');
      END_2eSSTCYC <= '0';

    elsif CLK'event and CLK='1' then

      case READ_FIFO_FSM is

        -- se c'è un ciclo VME in corso e arrivano dati non mi muovo
        -- altrimenti carico il primo livello di PIPE
        when S2_READ1   => END_2eSSTCYC <= '0';
		                   if REGS.CONTROL(C_TST_FIFO) = '1' then
                             if DTEST_FIFO = '1' then
                               NRDMEBi<= '0';
                               PIPEA  <= DPR;
                             else
                               NRDMEBi<= '1';
                             end if;
                           else
                             if EVRDY ='1' and EFS = '0' and (ANYCYC ='0' or REGMAP(S_OUTBUF) = '0') and V2eSSTCYC = '0' then
							   NRDMEBi<= '0';
                               PIPEA1 <= DPR;
                               PIPEA  <= DPR;
                               READ_FIFO_FSM <= S2_WAIT;
                             end if;
                           end if;

        when S2_WAIT    => NRDMEBi<= '1';
                           READ_FIFO_FSM <= S2_READ2;

        -- carico il secondo livello di PIPE
        when S2_READ2   => NRDMEBi<= '0';
                           PIPEA  <= PIPEA1;
                           PIPEA1 <= DPR;
                           PIPEB  <= DPR;
                           if DPR(31 downto 28) = G_TRAIL then         -- è stato riletto un evento dalla FIFO
                             END_PK <= '1';
                           end if;
                           READ_FIFO_FSM <= S2_WAITCYC;

        -- attendo l'inizio di un ciclo VME
        when S2_WAITCYC => NRDMEBi<= '1';
						   if ANYCYC = '1' then  
                             if REGMAP(S_OUTBUF)='1' and DSS = '0' then
                               if ADACKCYC = '1' then                     -- ciclo di address ack.
                                 READ_FIFO_FSM <= S2_WAITCYC;
                               else
                                 READ_FIFO_FSM <= S2_ENDDS;
                                 if (PIPEA(31 downto 28) = G_TRAIL or (MBLTCYC = '1' and PIPEB(31 downto 28) = G_TRAIL)) then
                                   EVREAD_DS <= '1';                      -- è stato riletto un evento da VME
                                   EVREADi   <= '1';
                                 else
                                   if MBLTCYC = '1' and END_PK = '0' then -- BLT64: carico il primo livello di PIPE
                                     NRDMEBi<= '0';
                                     PIPEA1 <= DPR;
                                     if DPR(31 downto 28) = G_TRAIL then  -- è stato riletto un evento dalla FIFO
                                       END_PK <= '1';
                                     end if;
                                   end if;
                                 end if;
                               end if;
                             end if;
						   elsif START_2eSSTCYC = '1' then
                             if END_PK = '0' then  -- devo terminare la rilettura di un evento -> comando la lettura della FIFO
                               NRDMEBi     <= '0';
                             end if;							 
                             READ_FIFO_FSM <= S2_2eREAD1;
                           end if;

        -- attendo la fine di un ciclo VME
        when S2_ENDDS   => EVREADi <= '0';
                           NRDMEBi <= '1';
                           if DSS = '1' then  -- nel 2eSST non aspetto che si muova il DS
                             if EVREAD_DS = '0' then -- deve terminare la rilettura di un evento da VME
                               READ_FIFO_FSM <= S2_WAITCYC;
                               PIPEA  <= PIPEA1;     -- faccio scorrere la PIPE
                               if END_PK = '0' then  -- deve terminare la rilettura di un evento dalla FIFO: rileggo la FIFO
                                 NRDMEBi<= '0';
                                 PIPEA1 <= DPR;
                                 PIPEB  <= DPR;
                                 if DPR(31 downto 28) = G_TRAIL then   -- è stato riletto un evento dalla FIFO
                                   END_PK <= '1';
                                 end if;
                               else
                                 PIPEB  <= D_OUTBUF;
                               end if;
                             else
                               EVREAD_DS <= '0';     -- è terminata la rilettura di un evento da VME
                               END_PK    <= '0';
                               PIPEA1    <= D_OUTBUF;
                               PIPEA     <= D_OUTBUF;
                               PIPEB     <= D_OUTBUF;
                               READ_FIFO_FSM <= S2_READ1;
                             end if;
                           end if;
						   
        -- ACCESSI 2eSST Alice Style ----------------------------------------
		-- quando arrivo qui ho già riletto due parole di un evento dal MEB;
		-- il ciclo di rilettura dati finisce sempre nello stato S2_2eREAD2. 
		when S2_2eREAD1  =>  -- nelle due pipe ho già il global trailer -> la lettura dell'evento da VME è terminata
		                      if (PIPEA(31 downto 28) = G_TRAIL or (PIPEB(31 downto 28) = G_TRAIL)) then
                                EVREAD_DS <= '1';                      -- è stato riletto un evento da VME
                                EVREADi   <= '1';
						    	NRDMEBi   <= '1';
                                READ_FIFO_FSM <= S2_2eREAD2;     
						      -- la lettura dell'evento da VME non è terminata
                              else                                 
  		                        if END_PK = '0' then
                                  PIPEA1    <= DPR;                    -- carico il primo livello di pipe
                                  if DPR(31 downto 28) = G_TRAIL then  -- è stato riletto un evento dalla FIFO
                                    END_PK  <= '1';
							    	NRDMEBi <= '1';                    -- smetto di rileggere la FIFO				   
							      else
							        NRDMEBi <= '0';			        
                                  end if;
                                end if;						   						   
                                READ_FIFO_FSM <= S2_2eREAD2;     
                              end if;						   						   
														 
        when S2_2eREAD2 =>    -- la lettura dell'evento da VME è terminata
		                      EVREADi <= '0';
                              if EVREAD_DS = '1' then 
                                 EVREAD_DS<= '0';      -- è terminata la rilettura di un evento da VME
                                 END_PK <= '0';
                                 PIPEA1 <= D_OUTBUF;
                                 PIPEA  <= D_OUTBUF;
                                 PIPEB  <= D_OUTBUF;
                                 READ_FIFO_FSM <= S2_READ1;
						      -- la lettura dell'evento da VME non è terminata
							  else
		                        if END_PK = '0' then
                                  PIPEA   <= PIPEA1;                   -- faccio scorrere la PIPE
                                  PIPEB   <= DPR;
                                  PIPEA1  <= DPR;
								  
                                  if DPR(31 downto 28) = G_TRAIL then  -- è stato riletto un evento dalla FIFO
                                    END_PK  <= '1';
								    NRDMEBi <= '1';                    -- smetto di rileggere la FIFO
							      else
							        NRDMEBi <= '0';							   
                                  end if;								  
                                  if (DPR(31 downto 28) = G_TRAIL) or (PIPEA1(31 downto 28) = G_TRAIL) then  -- avverto la FSM1 che darà il dtack sul G_TRAIL e quindi deve dare anche il BERR
                                    END_2eSSTCYC <= '1';
								  end if;
							    else								
                                  PIPEA  <= PIPEA1;                    -- faccio scorrere la PIPE
                                  PIPEB  <= D_OUTBUF;
                                  PIPEA1 <= D_OUTBUF;
                                  if (PIPEA1(31 downto 28) = G_TRAIL) then  -- avverto la FSM1 che darà il dtack sul G_TRAIL e quindi deve dare anche il BERR
                                    END_2eSSTCYC <= '1';
								  end if;
                                end if;
 						        READ_FIFO_FSM <= S2_2eREAD1;							 							 
                              end if;
                           
      end case;
    end if;
  end process;

  EVREAD  <= EVREADi;

  -- ########################################################################
  -- REGISTRO DI STATO
  -- ########################################################################
  REGS.STATUS(S_DATA_READY) <= EVRDY;
  REGS.STATUS(S_ACQ)        <= REGS.ACQUISITION(0);  -- Copio nel registro di stato il bit di acquisition


  -- ########################################################################
  -- SEGNALE DI PURGED PER LA LETTURA A EVENTI ALLINEATI
  -- ########################################################################
  process(CLK,CLEAR_STAT,EVRDY)
  begin
    if CLEAR_STAT ='0' or EVRDY = '0' then
      PURGED <= '1';
    elsif CLK'event and CLK='1' then
      if (BLTCYC = '0' and MBLTCYC = '0' and V2eSSTCYC = '0') then
        PURGED <= '0';
      elsif EVREADi = '1' then
        PURGED <= '1';
      end if;
    end if;
  end process;


  -- ########################################################################
  -- Gestione degli OE e dei LATCH dei transceiver del VME
  -- ########################################################################
  -- Latch degli indirizzi durante il ciclo
  ADLTC    <= '0'; -- tranceiver sempre in trasparenza (NON CAMBIARE!!!)

  NOE16Ri  <= '0' when ((WRITES = '1' and                  ANYCYC = '1') and DS ='0') or (NOE64Ri = '0') else '1';

  NOE32Ri  <= '0' when ((WRITES = '1' and LWORDS = '0' and ANYCYC = '1') and DS ='0') or (NOE64Ri = '0') else '1';

  NOE16Wi  <= '0' when ( WRITES = '0' and                  ANYCYC = '1')                                 else '1';

  NOE32Wi  <= '0' when ( WRITES = '0' and LWORDS = '0' and ANYCYC = '1')                                 else '1';

  -- Generazione di NOE64R: i dati devono uscire durante il ciclo BLT64 e 2eSST
  -- tranne che per il primo ciclo (acquisizione degli indirizzi)
  NOE64Ri  <= '0' when ((MBLTCYC = '1' or V2eSSTCYC = '1') and ADACKCYC = '0')                           else '1';

  NOE16R   <= NOE16Ri;
  NOE32R   <= NOE32Ri;
  NOE16W   <= NOE16Wi;
  NOE32W   <= NOE32Wi;

  NOE64R   <= NOE64Ri;
  NOEAD    <= not (NOE64Ri);

  ---------------------------------------------------------------------------
  -- ABILITAZIONI DEI TRANSCEIVER DEL MICRO
  ---------------------------------------------------------------------------
  -- abilito l'uscita dei dati dal micro al VME
  NOEMIC <= '0' when (WRITES = '1' and LWORDS = '1' and SINGCYC = '1' and REGMAP(S_MICRO) = '1') else '1';


  -- ########################################################################
  -- VDB e VAD MUX (asincrono)
  -- ########################################################################
  process (SINGCYC,BLTCYC,MBLTCYC,V2eSSTCYC,VDBi,PIPEA,PIPEB)
  begin
    VADm <= (others => '0');
    VDBm <= (others => '0');
    -- D32
    if SINGCYC = '1'   then
      VDBm   <= VDBi;
    -- BLT32
    elsif BLTCYC ='1' then
      VDBm <= PIPEA;
    -- BLT64
    elsif MBLTCYC ='1' or V2eSSTCYC = '1' then
      VADm <= PIPEA;
      VDBm <= PIPEB;
    end if;
  end process;


  VDB(15 downto  0)   <= VDBm(15 downto  0) when NOE16Ri = '0' and REGMAP(S_MICRO) = '0' else (others => 'Z');
  VDB(31 downto 16)   <= VDBm(31 downto 16) when NOE32Ri = '0' else (others => 'Z');

  VAD(31 downto 1)    <= VADm(31 downto 1)  when NOE64Ri = '0' else (others => 'Z');
  LWORDB              <= VADm(0)            when NOE64Ri = '0' else 'Z';


  -- ########################################################################
  -- Selezione dei registri
  -- ########################################################################
  D32     <= TRUE when LWORDS = '0' else FALSE;
  D16     <= TRUE when LWORDS = '1' else FALSE;
  WONLY   <= TRUE when WRITES = '0' else FALSE;
  RONLY   <= TRUE when WRITES = '1' else FALSE;

  REG_ADS <= conv_integer(VAS);

  process (CLK)
  begin
    if CLK'event and CLK='1' then

      if REG_ADS=A_OUTBUF     and VAS(1) ='0'
                              and D32 and RONLY then REGMAP(S_OUTBUF)    <= '1'; else REGMAP(S_OUTBUF)    <= '0'; end if;
      if REG_ADS=A_CONTROL    and D16           then REGMAP(S_CONTROL)   <= '1'; else REGMAP(S_CONTROL)   <= '0'; end if;
      if REG_ADS=A_STATUS     and D16 and RONLY then REGMAP(S_STATUS)    <= '1'; else REGMAP(S_STATUS)    <= '0'; end if;
      if REG_ADS=A_GEO_AD     and D16 and RONLY then REGMAP(S_GEO_AD)    <= '1'; else REGMAP(S_GEO_AD)    <= '0'; end if;
      if REG_ADS=A_LOAD_LUT   and D16 and WONLY then REGMAP(S_LOAD_LUT)  <= '1'; else REGMAP(S_LOAD_LUT)  <= '0'; end if;
      if REG_ADS=A_SW_CLEAR   and D16 and WONLY then REGMAP(S_SW_CLEAR)  <= '1'; else REGMAP(S_SW_CLEAR)  <= '0'; end if;
      if REG_ADS=A_SW_TRIGGER and D16 and WONLY then REGMAP(S_SW_TRIGGER)<= '1'; else REGMAP(S_SW_TRIGGER)<= '0'; end if;
      if REG_ADS=A_EVNT_STOR  and D16 and RONLY then REGMAP(S_EVNT_STOR) <= '1'; else REGMAP(S_EVNT_STOR) <= '0'; end if;
      if REG_ADS=A_FIRM_REV   and D16 and RONLY then REGMAP(S_FIRM_REV ) <= '1'; else REGMAP(S_FIRM_REV ) <= '0'; end if;
      if REG_ADS=A_TESTREG    and D32           then REGMAP(S_TESTREG)   <= '1'; else REGMAP(S_TESTREG)   <= '0'; end if;
      if REG_ADS=A_MICRO      and D16           then REGMAP(S_MICRO)     <= '1'; else REGMAP(S_MICRO)     <= '0'; end if;
      if REG_ADS=A_PROGHS     and D16 and RONLY then REGMAP(S_PROGHS)    <= '1'; else REGMAP(S_PROGHS)    <= '0'; end if;
      if REG_ADS=A_FLEN       and D16           then REGMAP(S_FLEN)      <= '1'; else REGMAP(S_FLEN)      <= '0'; end if;
      if REG_ADS=A_FLASH      and D16           then REGMAP(S_FLASH)     <= '1'; else REGMAP(S_FLASH)     <= '0'; end if;
      if REG_ADS=A_SRAM_PAGE  and D16           then REGMAP(S_SRAM_PAGE) <= '1'; else REGMAP(S_SRAM_PAGE) <= '0'; end if;

      if REG_ADS=A_I2CCOM     and D16 and WONLY then REGMAP(S_I2CCOM)    <= '1'; else REGMAP(S_I2CCOM)    <= '0'; end if;
      if REG_ADS=A_I2CDAT     and D16 and RONLY then REGMAP(S_I2CDAT)    <= '1'; else REGMAP(S_I2CDAT)    <= '0'; end if;

      if REG_ADS=A_DUMMY32    and D32           then REGMAP(S_DUMMY32)   <= '1'; else REGMAP(S_DUMMY32)   <= '0'; end if;

      if REG_ADS=A_ACQUISITION and D16          then REGMAP(S_ACQUISITION)<= '1';else REGMAP(S_ACQUISITION)<= '0';end if;

      if REG_ADS=A_BNCID_OFF  and D16           then REGMAP(S_BNCID_OFF) <= '1'; else REGMAP(S_BNCID_OFF)  <= '0';end if;

      if REG_ADS=A_TST_TIMOUT and D16 and WONLY then REGMAP(S_TST_TIMOUT)<= '1'; else REGMAP(S_TST_TIMOUT) <= '0';end if;

      if REG_ADS=A_TEMPA      and D16 and RONLY then REGMAP(S_TEMPA)     <= '1'; else REGMAP(S_TEMPA)      <= '0'; end if;
      if REG_ADS=A_TEMPB      and D16 and RONLY then REGMAP(S_TEMPB)     <= '1'; else REGMAP(S_TEMPB)      <= '0'; end if;

      -- indirizzi della SRAM a cui si può accedere all'interno di ciascuna pagina di 256 word a 16 bit
      if REG_ADS >= A_SRAM    and REG_ADS < A_SRAM + 512
                              and D16 and RONLY then REGMAP(S_SRAM)      <= '1'; else REGMAP(S_SRAM)      <= '0'; end if;

    end if;
  end process;

  REGMAP(S_REG16)    <= REGMAP(S_CONTROL)   or REGMAP(S_STATUS)   or REGMAP(S_GEO_AD)     or
                        REGMAP(S_LOAD_LUT)  or REGMAP(S_SW_CLEAR) or REGMAP(S_SW_TRIGGER) or
                        REGMAP(S_EVNT_STOR) or
                        REGMAP(S_FIRM_REV ) or REGMAP(S_SRAM_PAGE)or
                        REGMAP(S_MICRO)     or REGMAP(S_PROGHS)   or
                        REGMAP(S_FLEN)      or REGMAP(S_FLASH)    or
                        REGMAP(S_SRAM)      or 
                        REGMAP(S_I2CCOM)    or REGMAP(S_I2CDAT)   or
                        REGMAP(S_ACQUISITION) or REGMAP(S_BNCID_OFF) or
                        REGMAP(S_TST_TIMOUT)or REGMAP(S_TEMPA)    or REGMAP(S_TEMPB);

  REGMAP(S_REG32)    <= REGMAP(S_OUTBUF)    or REGMAP(S_TESTREG)  or REGMAP(S_DUMMY32);

  REGMAP(S_ANY)      <= REGMAP(S_REG16)     or REGMAP(S_REG32);


  -- ########################################################################
  -- TICK
  -- Un Tick e' un impulso che dura 1 periodo di CLK e viene ripetuto ogni N periodi
  -- ########################################################################
  -- T64:  Periodo=Tclk*64  (1.6us a 40MHz)
  -- T16K: Periodo=Tclk*16K (400us a 40MHz)
  -- T4M:  Periodo=Tclk*4M  (100ms a 40MHz)
  -- T64M: Periodo=Tclk*64M (1.6s  a 40MHz)

  process(HWRES,CLK)
  begin
    if HWRES = '0' then

      TCNT1 <= (others => '0');
      TCNT2 <= (others => '0');
      TCNT3 <= (others => '0');
      TCNT4 <= (others => '0');
      TICKi <= (others => '0');

    elsif CLK'event and CLK='1' then

      TCNT1 <= TCNT1 + 1;
      if TICKi(T64) = '1' then
        TCNT2 <= TCNT2 + 1;
      end if;
      if TICKi(T16K) = '1' then
        TCNT3 <= TCNT3 + 1;
      end if;
      if TICKi(T4M) = '1' then
        TCNT4 <= TCNT4 + 1;
      end if;

      if TCNT1 = "000000" then
        TICKi(T64) <= '1';
      else
        TICKi(T64) <= '0';
      end if;

      if TCNT2 = "00000000" and TCNT1 = "000000" then
        TICKi(T16K) <= '1';
      else
        TICKi(T16K) <= '0';
      end if;

      if TCNT3 = "00000000" and TCNT2 = "00000000" and TCNT1 = "000000" then
        TICKi(T4M) <= '1';
      else
        TICKi(T4M) <= '0';
      end if;

      if TCNT4 = "0000" and TCNT3 = "00000000" and TCNT2 = "00000000" and TCNT1 = "000000" then
        TICKi(T64M) <= '1';
      else
        TICKi(T64M) <= '0';
      end if;

    end if;
  end process;

  TICK <= TICKi;

  -- ########################################################################
  -- LED BICOLORE
  -- verde: power on + clock
  -- rosso: full
  -- verde + rosso : event ready
  -- ########################################################################

  LED_G <= REGS.STATUS(S_PWON) and not REGS.STATUS(S_FULL); -- green led
  LED_R <= EVRDY or REGS.STATUS(S_FULL);                    -- red led

  
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

