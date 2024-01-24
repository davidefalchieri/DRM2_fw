-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           VX1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            26/08/04
-- --------------------------------------------------------------------------
-- Module:          VINTERF
-- Description:     RTL module: VME Interface
--                  (based on v1390trm vinter (08-07-2005) by Annalisa Mati)
-- **************************************************************************

-- ##########################################################################
-- Revision History:
--    Modifiche introdotte rispetto a VINTERF della TRM
--       04/08/05 - Aggiunta porta DEBUG e LED in sostituzione degli SPARE e
--                  di LED_G, LED_R
--       23/08/05 - Rimossa porta BA (non usata): board sel tramite GEO
--                - GEO a 4 bit
--                - Cambiata interfaccia verso Compensation RAM (256Kx14):
--                  interfaccia verso Scratch SRAM interna (256x16)
--                - Interfaccia verso L2 FIFO diventa interfaccia verso MEB
--                  (Multi Event Buffer)
--       28/06/06 - Aggiunta gestione del Local Bus a 32 bit (clock = ALICLK)
--       24/11/06 - Aggiunte porte per l'invio degli OR RATE verso il ROC32
--       30/11/07 - Corretto funzionamento processo di accesso al LB: rispri
--                  stinato come su 2806. Dovrà essere modificato per l'accesso
--                  interno e non da VME.
--       05/12/07 - Corretta la sincronizzazione tra processo VME e processo
--                  di accesso al LBUS.
--       07/12/07 - Aggiunta rilettura Configuration RAM.
--       15/01/08 - RImosso pilotaggio LED
--       10/06/08 - Aggiunta porta FWIMG2LOAD; gestione nuovi registi di attività
--       16/06/08 - Aggiunto timeout sul accessi LBUS
--                - Agggiunto flag di timeout nel registro di stato.
--                - Corretta macchina a stati per accesso in scrittura alla flash.
--       18/06/08 - Esteso contatore Watchdog da 4 a 6 bit.
--                - Uso costanti definite nel package.
--                - Aggiunto flag di watchdog nello status. Può essere cancellato
--                  con il software clear.
--       22/04/09 - Rev. 6: Allungati timeout su accessei VME alla flash
--                  per tenere conto dell'allungamento dei cicli di accesso
--                  in spi_interf.
--       24/04/09 - Rev. 6: Anticipata la presentazione del dato sul bus VME
--                   per la rilettura della Configuration RAM e della Flash.
-- ##########################################################################
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1392pkg.all;

ENTITY VINTERF IS
   PORT(
       CLK       : IN    std_logic;
       ALICLK    : IN    std_logic;
       HWRES     : IN    std_logic;
       CLEAR     : IN    std_logic;
       HWCLEAR   : IN    std_logic;
       WDOGTO    : OUT   std_logic;

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
       GA        : IN    std_logic_vector ( 3 downto 0); -- GEO Address (su connettore a 5 file)

       INTR1     : OUT   std_logic;  -- Interrupt Request 1
       INTR2     : OUT   std_logic;  -- Interrupt Request 2

       ADLTC     : OUT   std_logic;  -- Latch degli indirizzi (sempre a 0)
       NOE16R    : OUT   std_logic;  -- OE dati bassi Scheda -> VME
       NOE16W    : OUT   std_logic;  -- OE dati bassi VME -> Scheda
       NOE32R    : OUT   std_logic;  -- OE dati alti Scheda -> VME
       NOE32W    : OUT   std_logic;  -- OE dati alti VME -> Scheda
       NOE64R    : OUT   std_logic;  -- OE dei dati verso il VME nel BLT64
       NOEAD     : OUT   std_logic;  -- OE indirizzi Scheda -> VME nel D64

       -- Interfaccia lettura MEB (Multi Event Buffer)
       DPR       : IN    std_logic_vector (31 downto 0);
       DPR_P     : IN    std_logic_vector ( 3 downto 0);
       NRDMEB    : OUT   std_logic;  -- read MEB
       PAF       : IN    std_logic;
       PAE       : IN    std_logic;
       EF        : IN    std_logic;
       FF        : IN    std_logic;

       -- INtervaccia verso il ROC32 per la lettura
       -- di OR RATES
       OR_RDATA    : OUT  std_logic_vector(9 downto 0);
       OR_RADDR    : IN   std_logic_vector(5 downto 0);
       OR_RREQ     : IN   std_logic;
       OR_RACK     : OUT  std_logic;

       -- Scratch SRAM (internal) signals
       RAMDT     : IN    std_logic_vector(7 downto 0); -- LUT data
       RAMAD_VME : OUT   std_logic_vector(8 downto 0);  -- LUT address
       RAMRD     : OUT   std_logic;                     -- LUT read (active low)
       -- Segnali scambiati con il SLC
       EVRDY     : IN    std_logic;  -- almeno un evento pronto nel MEB (dal SLC)
       EVREAD    : OUT   std_logic;  -- segnala che è stato riletto un evento dal EB
       DTEST_FIFO: IN    std_logic;  -- segnala che è stato scrito un dato di test nella FIFO

       -- BUS verso Cyclone (TC)
       nLBAS   : OUT     std_logic;
       nLBCLR  : OUT     std_logic;
       nLBCS   : OUT     std_logic;
       nLBLAST : OUT     std_logic;
       nLBRD   : OUT     std_logic;
       nLBRES  : OUT     std_logic;
       nLBWAIT : OUT     std_logic;
       nLBPCKE : IN      std_logic;
       nLBPCKR : IN      std_logic;
       nLBRDY  : IN      std_logic;
       LB      : INOUT   std_logic_vector (31 DOWNTO 0);
       LBSP    : IN      std_logic_vector(31 downto 0); -- Ingresso spare per
                                                        -- rilettura da registro.
       
       -- SuperModule Side (West/East)
       SM_SIDE : OUT     std_logic;
        
       -- Flash Byte Out
       FBOUT     : IN    std_logic_vector (7 DOWNTO 0);

       -- Debug
       DEBUG     : INOUT debug_stream;
       
       -- SPI INterface
       FWIMG2LOAD: OUT std_logic;

       REG       : INOUT reg_stream;
       PULSE     : OUT   reg_pulse;
       TICK      : IN    tick_pulses
       );

END VINTERF ;


ARCHITECTURE RTL OF VINTERF IS

-- **************************************************************************
  signal D32,D16,RONLY,WONLY: boolean;
  signal REGMAP   : std_logic_vector (S_REG32 downto 0);

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
  signal IACKINS  : std_logic;                      -- IACKIN del VME cloccato
  signal VAS      : std_logic_vector(15 downto 0);  -- VAD[15:0] cloccati
  signal REG_ADS  : integer range 0 to LAST_ADDRESS;-- = VAS

  signal PURGED   : std_logic;                      -- segnale di PURGED per il BLT

  signal CLOSEDTK : std_logic; -- segnale per la chiusura del DTACK: si attiva quando il DS torna a 1
                               -- e si disattiva quando il NOEDTKi (uscita della FSM) va a 1

  signal VDBi     : std_logic_vector(31 downto 0);  -- VDB interni (pilotati dalla FSM nel caso di ciclo singolo)
  signal VDBm     : std_logic_vector(31 downto 0);  -- VDB interni (Uscita del MUX)
  signal VADm     : std_logic_vector(31 downto 0);  -- VAD interni (Uscita del MUX)

  signal ANYCYC   : std_logic; -- è il corso un qualunque ciclo VME su di me

  signal SINGCYC  : std_logic; -- è il corso un ciclo singolo
  signal BLTCYC   : std_logic; -- è il corso un ciclo BLT32
  signal MBLTCYC  : std_logic; -- è il corso un ciclo BLT64
  signal ADACKCYC : std_logic; -- è il corso un ciclo di address ack.

  signal SELBASE32: std_logic; -- indirizzamento mediante Base address su tamburino
  signal SELGEO   : std_logic; -- indirizzamento geografico

  signal RAMDTS   : std_logic_vector(7 downto 0); -- dati dalla Configuration RAM sincronizzati

  -- segnali buffer
  signal NOEDTKi  : std_logic;
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

  -- watchdog
  signal WDOG        : std_logic_vector(5 downto 0) := (others => '0');  -- contatore watchdog
  signal WDOGRES     : std_logic;  -- reset watchdog generato dalla FSM del VME
  signal WDOGRES1    : std_logic;  -- reset watchdog ritardato di 1 ciclo di clock
  signal WDOGRES1CYC : std_logic;  -- reset watchdog (dura 1 ciclo di clock)
  signal WDOGTOi     : std_logic;  -- watchdog timeout

  -- Local Bus signals
  signal LB_REQ      : std_logic; -- Local Bus Access Request from VME
  signal LB_REQ_sync : std_logic; -- LB Access Request syncronous with destination clock
  signal LB_ACK      : std_logic; -- Local Bus Access Acknowledge to VME
  signal LB_ACK_sync : std_logic; -- LB Access Acknowledge syncronous with destination clock

  signal LB_WRITE         : std_logic; -- Local Bus Write Access
  signal LB_WRITE_sync    : std_logic; -- Local Bus Write Access (syncronous with destination clock)

  signal LB_ADDR   : std_logic_vector(11 downto 0);
  signal LB_DOUT   : std_logic_vector(31 downto 0);

  signal LB_s      : std_logic_vector(31 downto 0); -- Sampled Local Bus Data
  signal LB_nOE    : std_logic;                     -- Local Bus Output Enable
  signal LB_i      : std_logic_vector(31 downto 0); -- Internal Output Local Bus Data
  signal nLBASi    : std_logic;                     -- INternal LOcal Bus Address Strobe

  -- contatore per generare attese di varia lunghezza
  signal TCNT     : std_logic_vector(7 downto 0) := (others => '0');
  signal LBUSTMO  : std_logic_vector(4 downto 0) := (others => '0');


  -- Per fare i registri in triplice copia:
  -- il registro CONTROL è in triplice copia
  signal REG1     : reg_stream;
  signal REG2     : reg_stream;
  signal REG3     : reg_stream;

  -- Segnali per la sincronizzazione delle richieste di accesso al LB da ROC32
  signal OR_RREQ_sync : std_logic;

  signal REQUESTER    : std_logic; -- COdifica chi ha fatto la richiesta di accesso al LBUS. 0=VME; 1=ROC
  
  -- watchdog clear
  signal WDOGCLEAR : std_logic;

  -- ************************************************************************

  -- Definizione degli stati
  attribute syn_encoding : string;

  -- FSM1 che gestisce gli accessi VME
  type   TSTATE1 is (S1_IDLE,  S1_START, S1_SNGDTK, S1_ENDCYC,
                     S1_ADDACK,S1_BIDLE, S1_ENDBCYC, S1_WSPI,
                     S1_RSPI,  S1_RLUT, S1_DLYDTK);
  signal STATE1 : TSTATE1;
  attribute syn_encoding of TSTATE1 : type is "onehot";

  -- FSM2 che gestisce la rilettura della FIFO
  type   TSTATE2 is (S2_READ1, S2_WAIT, S2_READ2, S2_WAITCYC, S2_ENDDS, S2_DUMMY);
  signal STATE2 : TSTATE2;
  attribute syn_encoding of TSTATE2 : type is "onehot";

  -- ************************************************************************

  -- FSM5 che gestisce il Local Bus
  type   TSTATE5 is (S5_IDLE,  S5_VMESTART, S5_ROCSTART,  S5_AS, S5_ENDCYC, S5_VMEHSHAKE, S5_ROCHSHAKE, S5_VMEND);
  signal STATE5 : TSTATE5;
  attribute syn_encoding of TSTATE5 : type is "onehot";
  
  
begin


  -- New in rev. 3
  SM_SIDE <= REG(C_SM_SIDE); -- Super Module Side information for Cyclone

  nLBCLR   <= HWCLEAR;
  nLBAS    <= nLBASi;

  REG   <= (others => 'Z');

  DEBUG <= (others => 'Z');
  DEBUG(0) <= ASBS;
  DEBUG(1) <= VSEL;
  DEBUG(2) <= DSS;
  DEBUG(3) <= NOEDTKi;
  DEBUG(4) <= SELBASE32;
  DEBUG(5) <= REGMAP(S_TESTREG);
  DEBUG(6) <= NOE16Ri;
  DEBUG(7) <= NOE32Ri;
  DEBUG(8) <= 'Z'; -- Reserved for GA(3)
  DEBUG(9) <= 'Z'; -- Reserved for GA(2)
  DEBUG(10) <= 'Z'; -- Reserved for GA(1)
  DEBUG(11) <= 'Z'; -- Reserved for GA(0)
  DEBUG(12) <= 'Z';
  DEBUG(13) <= 'Z';
  DEBUG(14) <= 'Z';
  DEBUG(15) <= 'Z';

   

  INTR1 <= '1';
  INTR2 <= '1';

  -- ************************************************************************
  --
  -- CLK        |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
  --         _____                                                         _____________
  -- ASB(#)       |_______________________________________________________|
  --         ______                         _______         _______             ________
  -- DSnB(#)       |_______________________|       |_______|       |___________|
  --         _______                                                         ___________
  -- ASBS           |_______________________________________________________|
  --                     ___________________________________________________
  -- CYCS    ___________|                                                   |___________
  --                         ___________________________________________________
  -- CYCS1   _______________|                                                   |_______
  --                     ___
  -- VSEL(*) ___________|   |___________________________________________________________
  --                        |<---- I segnali VME (ad,am,write,iack...) vengono letti qui
  --                         ___________________________________________________________
  -- VAS     ||||||||||||||||___________________________________________________________
  --                             _______________________________________________________
  -- REGMAP  ||||||||||||||||||||____________valid register selection___________________
  --         _______________                 _______         _______             _______
  -- DSS                    |_______________|       |_______|       |___________|
  --         ___________________________    ____________    ____________        ________
  -- NDTKIN                             |__|            |__|            |______|
  --         ___________________________         _______         _______             ___
  -- NOEDTK                             |_______|       |_______|       |___________|

  -- (#) = segnali asincroni
  -- (*) = segnali ottenuti da logica combinatoria di segnali sincroni
  -- ************************************************************************


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
  -- A partire da CYCS e DSS, genero due segnali ASTB e DSTB che durano
  -- un solo ciclo di clock
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
  -- selezione del modulo tramite GEO
  -- ########################################################################
  -- Processo per lecciare gli indirizzi. ATTENZIONE: qui genero volutamente un latch
  process(ASB,VAD,GA)
  begin
    if ASB = '1' then
      if VAD(31 downto 28) = not GA then -- indirizzamento geografico
        SELGEO    <= '1';
        SELBASE32 <= '1';
      else
        SELGEO    <= '0';
        SELBASE32 <= '0';
      end if;
    end if;
  end process;


  -- ########################################################################
  -- processo per stabilire il tipo di ciclo in corso (singolo, blt, mblt) e
  -- strobare gli indirizzi (selezione)
  -- ########################################################################
  -- ANYCYC = '1' -> è in corso un qualunque ciclo VME su di me
  ANYCYC <= SINGCYC or BLTCYC or MBLTCYC;

  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      SINGCYC  <= '0';
      BLTCYC   <= '0';
      MBLTCYC  <= '0';
      ADACKCYC <= '0';
      VAS      <= (others => '0');
    elsif CLK'event and CLK = '1' then

      if ASBS = '1' then
        SINGCYC  <= '0';
        BLTCYC   <= '0';
        MBLTCYC  <= '0';
        ADACKCYC <= '0';

      elsif VSEL='1' then

        VAS <= VAD(15 downto 1) & '0';

        if IACKB = '1' then

          -- CICLO SINGOLO
          if((AMB=A32_U_DATA and SELBASE32 = '1') or
             (AMB=CR_CSR     and SELGEO = '1'))  then
            SINGCYC <= '1';
          end if;
          -- CICLO BLT
          if  AMB=A32_U_BLT  and SELBASE32 = '1' then
            BLTCYC <= '1';
          end if;
          -- CICLO MBLT
          if  AMB=A32_U_MBLT and SELBASE32 = '1' then
            MBLTCYC  <= '1';
            ADACKCYC <= '1';
          end if;

        end if;

      elsif STATE1 = S1_BIDLE then
        ADACKCYC <= '0'; -- terminato il ciclo di address ack
      end if;
    end if;
  end process;


  -- sincronizzazioni segnali dal VME per la FSM
  process(CLK,HWRES)
  begin
    if HWRES = '0' then
      WRITES   <= '0';
      LWORDS   <= '0';
      IACKINS  <= '1';
      RAMDTS   <= (others =>'0');
    elsif CLK'event and CLK = '1' then

      if VSEL='1' then
        WRITES  <= WRITEB;
        LWORDS  <= LWORDB;
      end if;

      IACKINS <= IACKINB;
      RAMDTS  <= RAMDT;

    end if;
  end process;


  -- ########################################################################
  -- MAJORITY DEI REGISTRI IN TRIPLICE COPIA
  -- ########################################################################
  REG(CONTROL'range)     <= majority(REG1,REG2,REG3,REG'length)(CONTROL'high downto CONTROL'low);
  REG(ACQUISITION'range) <= majority(REG1,REG2,REG3,REG'length)(ACQUISITION'high downto ACQUISITION'low);


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM1 che gestisce gli accessi VME
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- il registro CONTROL è in triplice copia

  process(CLK, HWRES, WDOGTOi)

    procedure triplica (h_index:  in  integer;
                        l_index:  in  integer;
                        data   :  in  std_logic_vector) is

    begin
      REG1(h_index downto l_index) <= data;
      REG2(h_index downto l_index) <= data;
      REG3(h_index downto l_index) <= data;
    end;

  begin

    if HWRES ='0' or WDOGTOi = '1' then

      STATE1     <= S1_IDLE;
      NOEDTKi    <= '1';
      MYBERRi    <= '1';
      IACKOUTB   <= '1';
      VDBi       <= (others => '0');

      PULSE     <= (others => '0');
      WDOGCLEAR <= '0';

      RAMAD_VME  <= (others => '0');
      RAMRD      <= '1';

      TCNT       <= (others => '0');

      WDOGRES    <= '0';

      triplica(CONTROL'high, CONTROL'low,D_CONTROL);
      triplica(ACQUISITION'high, ACQUISITION'low, D_ACQUISITION);
      REG(TESTREG'range)    <= D_TESTREG;
      REG(FLASH'range)      <= D_FLASH;
      REG(FLEN'range)       <= D_FLEN;
      REG(I2CCOM'range)     <= D_I2CCOM;
      REG(DUMMY32'range)    <= D_DUMMY32;
      REG(PDL_PROG'range)   <= D_PDL_PROG;
      REG(PDL_AE_L'range)   <= D_PDL_AE_L;
      REG(PDL_AE_M'range)   <= D_PDL_AE_M;
      REG(PDL_AE_H'range)   <= D_PDL_AE_H;
      REG(DSYNC'range)      <= D_DSYNC;
      REG(DDATA'range)      <= D_DDATA;

      REG(LBSPDIR'range)    <= D_LBSPDIR;
      REG(LBSPCTRL'range)   <= D_LBSPCTRL;
      REG(CLKSEL'range)     <= D_CLKSEL;
      REG(CLKHIZ'range)     <= D_CLKHIZ;

      REG(BNCRESN'range)    <= D_BNCRESN;
      REG(LEDCTRL'range)    <= D_LEDCTRL;
      REG(CONFIG'range)     <= D_CONFIG;

      LB_REQ      <= '0';
      LB_ACK_sync <= '0';
      LB_WRITE    <= '0';
      LB_DOUT     <= (others => '0');
      LB_ADDR     <= (others => '0');

	  FWIMG2LOAD  <= '1';
    elsif CLK'event and CLK='1' then

      LB_ACK_sync <= LB_ACK; -- Sincronizzazione acknowledge da Local Bus
      RAMRD       <= '1';

      if HWCLEAR = '0' then
        triplica(ACQUISITION'high, ACQUISITION'low, D_ACQUISITION);
      end if;

      case STATE1 is
        when S1_IDLE   => PULSE(WP_CONFIG) <= '0';
                          LB_REQ    <= '0';
                          LB_WRITE    <= '0';

                          if WDOG = WDOGTMORES then  -- resetto il WD periodicamente: se da IDLE salto in uno stato
                            WDOGRES <= '1';      -- non valido il WD non è più resettato e resetta la FSM del VME
                          else
                            WDOGRES <= '0';
                          end if;

                          if DSS ='0' and ANYCYC = '1' then  -- apetto l'inizio del ciclo
                            WDOGRES <= '1';      -- resetto il WD (WDOGRES dura 1 ciclo di clock)
                            STATE1  <= S1_START;
                          end if;

        when S1_START  => -- CICLO SINGOLO
                          WDOGRES   <= '0';
                          if SINGCYC='1' then

                            if REGMAP(S_ANY) = '1' then -- accesso ad un registro della scheda

                              STATE1    <= S1_DLYDTK;
                              if WRITES ='1' then      -- ACCESSO IN LETTURA
                                -- metto i dati sul bus
                                VDBi <= (others => '0');
                                if REGMAP(S_CONTROL)   = '1' then VDBi(D_CONTROL'range)   <= REG(CONTROL'range);   end if;
                                if REGMAP(S_ACQUISITION)='1' then VDBi(D_ACQUISITION'range)<=REG(ACQUISITION'range);end if;
                                if REGMAP(S_STATUS)    = '1' then VDBi(D_STATUS'range)    <= REG(STATUS'range);    end if;
                                if REGMAP(S_EVNT_STOR) = '1' then VDBi(D_EVNT_STOR'range) <= REG(EVNT_STOR'range); end if;
                                if REGMAP(S_FIRM_REV)  = '1' then VDBi(D_FIRM_REV'range)  <= D_FIRM_REV;           end if;
                                if REGMAP(S_TESTREG)   = '1' then VDBi(D_TESTREG'range)   <= REG(TESTREG'range);   end if;
                                if REGMAP(S_FLEN)      = '1' then VDBi(D_FLEN'range)      <= REG(FLEN'range);      end if;
                                if REGMAP(S_DUMMY32)   = '1' then VDBi(D_DUMMY32'range)   <= REG(DUMMY32'range);   end if;
                                if REGMAP(S_I2CDAT)    = '1' then VDBi(D_I2CDAT'range)    <= REG(I2CDAT'range);    end if;
                                if REGMAP(S_PDL_PROG)  = '1' then VDBi(D_PDL_PROG'range)  <= REG(PDL_PROG'range);  end if;
                                if REGMAP(S_PDL_DATA)  = '1' then VDBi(D_PDL_DATA'range)  <= REG(PDL_DATA'range);  end if;
                                if REGMAP(S_PDL_AE_L)  = '1' then VDBi(D_PDL_AE_L'range)  <= REG(PDL_AE_L'range);  end if;
                                if REGMAP(S_PDL_AE_M)  = '1' then VDBi(D_PDL_AE_M'range)  <= REG(PDL_AE_M'range);  end if;
                                if REGMAP(S_PDL_AE_H)  = '1' then VDBi(D_PDL_AE_H'range)  <= REG(PDL_AE_H'range);  end if;

                                if REGMAP(S_TEMPA)     = '1' then VDBi(D_TEMPA'range)     <= REG(TEMPA'range);     end if;
                                if REGMAP(S_TEMPB)     = '1' then VDBi(D_TEMPB'range)     <= REG(TEMPB'range);     end if;

                                if REGMAP(S_DSYNC)     = '1' then VDBi(D_DSYNC'range)     <= REG(DSYNC'range);     end if;
                                if REGMAP(S_DDATA)     = '1' then VDBi(D_DDATA'range)     <= REG(DDATA'range);     end if;
                                if REGMAP(S_SPULSE)    = '1' then VDBi(D_SPULSE'range)    <= REG(SPULSE'range);    end if;
                                if REGMAP(S_TRIGSTAT)  = '1' then VDBi(D_TRIGSTAT'range)  <= REG(TRIGSTAT'range);  end if;
                                if REGMAP(S_LBSPCTRL)  = '1' then VDBi(D_LBSPCTRL'range)  <= LBSP;   end if;

                                if REGMAP(S_CLKSEL)    = '1' then VDBi(D_CLKSEL'range)    <= REG(CLKSEL'range);    end if;
                                if REGMAP(S_CLKHIZ)    = '1' then VDBi(D_CLKHIZ'range)    <= REG(CLKHIZ'range);    end if;
                                if REGMAP(S_CONFIG)    = '1' then VDBi(D_CONFIG'range)    <= REG(CONFIG'range);    end if;
                                if REGMAP(S_BNCRESN)   = '1' then VDBi(D_BNCRESN'range)   <= REG(BNCRESN'range);   end if;
                                if REGMAP(S_LEDCTRL)   = '1' then VDBi(D_LEDCTRL'range)   <= REG(LEDCTRL'range);   end if;
                                if REGMAP(S_ACLK_ACT)  = '1' then VDBi(D_ACLK_ACT'range)   <= REG(ACLK_ACT'range);   end if;
                                if REGMAP(S_LOAD_ACT)  = '1' then VDBi(D_LOAD_ACT'range)   <= REG(LOAD_ACT'range);   end if;


                                if REGMAP(S_FLASH)  = '1' then      -- lettura dalla FLASH
                                  REG(FLASH'range) <= (others => '0');
                                  PULSE(WP_SPI)    <= '1';
                                  TCNT   <= X"A0"; -- Attesa di 160 cicli (4 us @ 40 MHz clock): dall rev. 6 è allungato il ciclo di lettura di un byte dalla flash (spi_interf)
                                                   -- La lettura di un bit dalla flash impiega 16 colpi di clk. 
                                  STATE1 <= S1_RSPI;
                                end if;

                                if REGMAP(S_SRAM)  = '1' then       -- lettura dalla Config RAM
                                  RAMAD_VME  <= VAS(9 downto 1);    -- 8-bit aligned address
                                  RAMRD      <= '0';
                                  TCNT   <= X"04";
                                  STATE1 <= S1_RLUT;
                                end if;

                                if REGMAP(S_OUTBUF) = '1' then      -- LETTURA IN D32 DEL MEB
                                  VDBi(D_OUTBUF'range) <= PIPEA;
                                end if;

                                if REGMAP(S_LB) = '1' then          -- Local Bus access
                                  LB_REQ      <= '1';
                                  LB_WRITE    <= '0';
                                  LB_ADDR     <= VAS(11 downto 0);   -- LB address space mapped onto lower 12 bit VME space

                                  if LB_ACK_sync = '1' then
                                     STATE1  <= S1_DLYDTK; 
                                     VDBi    <= LB_s;
                                  else
                                     STATE1  <= S1_START;
                                  end if;
                                end if;

                              end if;
                            else
                              STATE1  <= S1_ENDCYC;     -- accesso ad un indrizzo non riconosciuto
                            end if;

                          -- BLT32: il primo dato è già pronto
                          elsif BLTCYC='1' and REGMAP(S_OUTBUF) = '1' then
                            STATE1 <= S1_BIDLE;

                          -- BLT64: devo eseguire il ciclo di address acknowledge
                          elsif MBLTCYC='1' and REGMAP(S_OUTBUF) = '1' then
                            NOEDTKi <= '0';
                            STATE1 <= S1_ADDACK;

                          end if;

        when S1_DLYDTK => NOEDTKi    <= '1';
                          STATE1     <= S1_SNGDTK;

        -- ACCESSI SINGOLI --------------------------------------------------
        when S1_SNGDTK => NOEDTKi    <= '0';
                          STATE1     <= S1_ENDCYC;

                          if WRITES ='0' then      -- ACCESSO IN SCRITTURA: strobe dei dati
                            if REGMAP(S_CONTROL)    = '1' then triplica(CONTROL'high,CONTROL'low,VDB(D_CONTROL'range)); end if;
                            if REGMAP(S_ACQUISITION)= '1' then triplica(ACQUISITION'high,ACQUISITION'low,VDB(D_ACQUISITION'range)); end if;
                            if REGMAP(S_FLEN)       = '1' then REG(FLEN'range)       <= VDB(D_FLEN'range);      end if;
                            if REGMAP(S_DUMMY32)    = '1' then REG(DUMMY32'range)    <= VDB(D_DUMMY32'range);   end if;


                            if REGMAP(S_PDL_AE_L)   = '1' then REG(PDL_AE_L'range)   <= VDB(D_PDL_AE_L'range);   end if;
                            if REGMAP(S_PDL_AE_M)   = '1' then REG(PDL_AE_M'range)   <= VDB(D_PDL_AE_M'range);   end if;
                            if REGMAP(S_PDL_AE_H)   = '1' then REG(PDL_AE_H'range)   <= VDB(D_PDL_AE_H'range);   end if;

                            if REGMAP(S_DSYNC)      = '1' then REG(DSYNC'range)   <= VDB(D_DSYNC'range);   end if;


                            if REGMAP(S_LBSPDIR)    = '1' then REG(LBSPDIR'range)   <= VDB(D_LBSPDIR'range);   end if;

                            -- Local Bus SPares
                            if REGMAP(S_LBSPCTRL)   = '1' then REG(LBSPCTRL'range)   <= VDB(D_LBSPCTRL'range);   end if;

                            -- CLOCK SELECTION
                            if REGMAP(S_CLKSEL)      = '1' then REG(CLKSEL'range)   <= VDB(D_CLKSEL'range);   end if;
                            if REGMAP(S_CLKHIZ)      = '1' then REG(CLKHIZ'range)   <= VDB(D_CLKHIZ'range);   end if;

                            if REGMAP(S_BNCRESN)     = '1' then REG(BNCRESN'range)   <= VDB(D_BNCRESN'range);   end if;
                            if REGMAP(S_LEDCTRL)     = '1' then REG(LEDCTRL'range)   <= VDB(D_LEDCTRL'range);   end if;

                            -- CYCLONE CONFIGURATION RELOAD
                            if REGMAP(S_CONFIG)     = '1' then REG(CONFIG'range)     <= VDB(D_CONFIG'range);    end if;


                            if REGMAP(S_DDATA) = '1'  then
                              REG(DDATA'range) <= VDB(D_DDATA'range);
                              PULSE(WP_DAC)    <= '1';  -- scrittura DAC
                            end if;

                            if REGMAP(S_FLASH) = '1'  then
                              REG(FLASH'range) <= VDB(D_FLASH'range);
                              PULSE(WP_SPI)    <= '1';  -- scrittura FLASH
                              TCNT             <= X"A0"; -- Attesa lunga (4 us)
                              NOEDTKi          <= '1';
                              STATE1           <= S1_WSPI;                              
                            end if;

                            if REGMAP(S_I2CCOM) = '1'  then
                              REG(I2CCOM'range)<= VDB(D_I2CCOM'range);
                              PULSE(WP_I2C)    <= '1';  -- scrittura I2C
                            end if;

                            if REGMAP(S_TESTREG)    = '1' then
                              REG(TESTREG'range)    <= VDB(D_TESTREG'range);
                              PULSE(WP_FIFO)        <= '1';  -- la scrittura in TESTREG determina la scrittura nella FIFO
                            end if;

                            if REGMAP(S_LOAD_LUT )  = '1' then
                              PULSE(LOAD_LUT)       <= '1';  -- Load LUT
                            end if;

                            if REGMAP(S_SW_CLEAR)   = '1' then
                              PULSE(SW_CLEAR)       <= '1';  -- Clear software
                              WDOGCLEAR             <= '1';
                            end if;

                            if REGMAP(S_SW_TRIGGER) = '1' then
                              PULSE(SW_TRIGGER)     <= '1';  -- Trigger software
                            end if;

                            if REGMAP(S_PDL_PROG) = '1' then
                              PULSE(WP_PDL)          <= '1';      -- Start PDL Programming
                              REG(PDL_PROG'range)    <= VDB(D_PDL_PROG'range);
                            end if;

                            if (REGMAP(S_CONFIG)  = '1') then -- Generate a pulse to reload User Fpga
                               PULSE(WP_CONFIG)       <= '1';
                               FWIMG2LOAD             <= VDB(CFG_IMAGE_SELECT-CONFIG'low); -- 
                            end if;

                            if (REGMAP(S_LB) = '1') then -- accesso al Local Bus
                               STATE1     <= S1_SNGDTK;
                               NOEDTKi    <= '1';
                               LB_REQ     <= '1';           -- Richiede accesso al Local Bus e si ferma in attesa dell'ack
                               LB_WRITE   <= '1';           -- RIchiede una scrittura
                               LB_ADDR    <= VAS(11 downto 0);
                               LB_DOUT    <= VDB;
                               if LB_ACK_sync = '1' then    -- Attende fine del ciclo Local Bus singolo
                                 LB_REQ  <= '0';
                                 STATE1  <= S1_ENDCYC;
                                 NOEDTKi <= '0';
                               end if;
                            end if;

                          end if;

        when S1_ENDCYC => PULSE      <= (others => '0');
                          WDOGCLEAR  <= '0';
                          if DSS='1' then                 -- apetto la fine del ciclo DS
                            STATE1   <= S1_IDLE;
                            NOEDTKi  <= '1';
                            IACKOUTB <= '1';
                            VDBi     <= (others => '0');
                          end if;

        -- ACCESSI BLT e MBLT -----------------------------------------------
        when S1_ADDACK => if DSS='1' then                 -- BLT64 address acknowledge
                            STATE1  <= S1_BIDLE;
                            NOEDTKi <= '1';
                          end if;

        when S1_BIDLE  => if ASBS = '1' then              -- fine del Block Transfer
                            NOEDTKi <= '1';
                            STATE1  <= S1_IDLE;
                          elsif DSS='0' then              -- apetto l'inizio del ciclo DS
                            STATE1  <= S1_ENDBCYC;
                            if PURGED = '0' then          -- non sono PURGED (ci sono dati da trasferire):
                              NOEDTKi <= '0';             -- do il DTACK
                            else                          -- non ci sono dati da trasferire
                              MYBERRi <= '0';             -- do il BERR
                            end if;
                          end if;

        when S1_ENDBCYC=> if DSS='1' then                 -- aspetto la fine del ciclo DS
                            STATE1  <= S1_BIDLE;
                            NOEDTKi <= '1';
                            MYBERRi <= '1';
                          end if;

        -- Scrittura nella FLASH seriale
        when S1_WSPI      => TCNT <= TCNT - 1;
                             PULSE(WP_SPI) <= '0';
                             if TCNT = X"00" then
                               NOEDTKi    <= '0';
                               STATE1     <= S1_ENDCYC;
                             end if;


        -- lettura dalla FLASH
        when S1_RSPI      => TCNT <= TCNT - 1;
                             PULSE(WP_SPI) <= '0';
                             VDBi(D_FLASH'range) <= FBOUT;
                             if TCNT = X"00" then
                               NOEDTKi    <= '0';       -- Valida il dato
                               STATE1     <= S1_ENDCYC;
                             end if;

        -- lettura dalla LUT
        when S1_RLUT      => TCNT <= TCNT - 1;
                             VDBi       <= X"000000" & RAMDTS; -- 8 bit LUT ram
                             if TCNT = "00000" then                        
                               NOEDTKi    <= '0';         -- Valida il dato
                               STATE1     <= S1_ENDCYC;
                             end if;

      end case;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- il DTACK si attiva con la macchina a stati e si disattiva quando DS torna alto
  ---------------------------------------------------------------------------
  NDTKIN <= NOEDTKi or CLOSEDTK;
  NOEDTK <= NOEDTKi;

  MYBERR <= MYBERRi;

  DS <= (DS0B or DS1B);

  process(DS,NOEDTKi)
  begin
    if NOEDTKi = '1' then
      CLOSEDTK <= '0';
    elsif DS'event and DS ='1' then
      CLOSEDTK <= '1';
    end if;
  end process;



  -- ########################################################################
  -- WatchDog
  -- ########################################################################
  -- WDOGRES ritardato di 1 ciclo di clock
  process(HWRES,CLK)
  begin
    if HWRES = '0' then
      WDOGRES1 <= '0';
    elsif CLK'event and CLK = '1' then
      WDOGRES1 <= WDOGRES;
    end if;
  end process;

  -- il reset del WD dura 1 ciclo di clock: se la FSM del VME salta tenendo WDOGRES ='1'
  -- WDOGRES1CYC va a zero e il WD può contare e resettare la FSM del VME
  WDOGRES1CYC <= WDOGRES and not WDOGRES1;

  process(HWRES,WDOGRES1CYC,CLK)
  begin
    if HWRES = '0' or WDOGRES1CYC ='1' then
      WDOG   <= (others => '0');
      WDOGTOi <= '0';
      REG(S_WDOGTIMEOUT) <= '0';
    elsif CLK'event and CLK = '1' then
      WDOGTOi <= '0';
      
      -- The Watchdog timeout is clearable with sw clear
      if WDOGCLEAR = '1' then
        REG(S_WDOGTIMEOUT) <= '0';
      end if;
      
      if TICK(T4M)='1' then
        WDOG <= WDOG + 1;
      end if;

      if WDOG = WDOGTMOVAL then
        WDOGTOi <= '1';  -- Watchdog time out
        REG(S_WDOGTIMEOUT) <= '1';
      end if;

    end if;
  end process;

 WDOGTO <= WDOGTOi;


 -- Processo che ricampiona l'Empty flag
 -- della FIFO sul fronte in salita.
 -- Le FIFO dell'APA (FIFO256x9SST) generano
 -- il flag sul fronte in discesa del clock.
 -- Serve per evitare violazioni di timing su questo path.
 process(CLK,CLEAR)
   begin
     if CLEAR = '0' then
       EFS <= '1';
     elsif CLK'event and CLK='1' then
       EFS <= EF;
    end if;
 end process;


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM2 che gestisce la rilettura della MEB
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- NON POSSO RILEGGERE SE NON C'E' ALMENO 1 EVENTO IN MEMORIA!!!

  NRDMEB <= NRDMEBi;

  process(CLK, CLEAR)
  begin
    if CLEAR ='0' then

      STATE2    <= S2_READ1;
      NRDMEBi   <= '1';
      PIPEA1    <= D_OUTBUF;
      PIPEA     <= D_OUTBUF;
      PIPEB     <= D_OUTBUF;
      EVREADi   <= '0';  -- Si setta quando da VME è stato riletto un evento (dura 1 ciclo di clock)
      EVREAD_DS <= '0';  -- Si setta quando da VME è stato riletto un evento (si resetta solo alla fine del ciclo VME)
      END_PK    <= '0';  -- Si setta quando è stato riletto un evento dalla FIFO

    elsif CLK'event and CLK='1' then

      case STATE2 is

        -- se c'è un ciclo VME in corso e arrivano dati non mi muovo
        -- altrimenti carico il primo livello di PIPE
        when S2_READ1   => if REG(C_TST_FIFO) = '1' then
                             if DTEST_FIFO = '1' then
                               NRDMEBi<= '0';
                               PIPEA  <= DPR;
                             else
                               NRDMEBi<= '1';
                             end if;
                           else
                             if (EVRDY ='1') and (EFS = '0') and (ANYCYC ='0' or REGMAP(S_OUTBUF) = '0') then
                               NRDMEBi<= '0';
                               STATE2 <= S2_DUMMY;
                             end if;
                           end if;

        -- Stato dummy introdotto poichè la EVENT FIFO sulla Actel non è di tipo
        -- LookAhead (coem su Altera).
        -- Senza questo stato leggo il primo dato sbagliato.
        -- Quando c'è un nuovo evento e salto da READ1, non carico subito la pipe,
        -- ma faccio una lettura dummy.
        when S2_DUMMY   => NRDMEBi<= '0';
                           STATE2 <= S2_WAIT;


        when S2_WAIT    => NRDMEBi<= '1';
                           PIPEA1 <= DPR;
                           PIPEA  <= DPR;
                           STATE2 <= S2_READ2;

        -- carico il secondo livello di PIPE
        when S2_READ2   => NRDMEBi<= '0';
                           PIPEA  <= PIPEA1;
                           PIPEA1 <= DPR;
                           PIPEB  <= DPR;
                           if DPR(31 downto 28) = G_TRAIL then         -- è stato riletto un evento dalla FIFO
                             END_PK <= '1';
                           end if;
                           STATE2 <= S2_WAITCYC;

        -- attendo l'inizio di un ciclo VME
        when S2_WAITCYC => NRDMEBi<= '1';
						   --if REGMAP(S_OUTBUF)='1' and DSS = '0' then
                           if REGMAP(S_OUTBUF)='1' and DSS = '0' and (BLTCYC = '1' or MBLTCYC = '1') then		-- DAV
                             if ADACKCYC = '1' then                    -- ciclo di address ack.
                               STATE2 <= S2_WAITCYC;
                             else
                               STATE2 <= S2_ENDDS;
                               if (PIPEA(31 downto 28) = G_TRAIL or (MBLTCYC = '1' and PIPEB(31 downto 28) = G_TRAIL)) then
                                 EVREAD_DS <= '1';                     -- è stato riletto un evento da VME
                                 EVREADi   <= '1';
                               else
                                 if MBLTCYC = '1' and END_PK = '0' then -- BLT64: carico il primo livello di PIPE
                                   NRDMEBi<= '0';
                                   PIPEA1 <= DPR;
                                   if DPR(31 downto 28) = G_TRAIL then -- è stato riletto un evento dalla FIFO
                                     END_PK <= '1';
                                     --NRDMEBi<= '1'; -- LCOL DEBUG: evito di dare un read alla fine dell'evento
                                   end if;
                                 end if;
                               end if;
                             end if;
                           end if;

        -- attendo la fine di un ciclo VME
        when S2_ENDDS   => EVREADi <= '0';
                           NRDMEBi <= '1';
                           if DSS = '1' then
                             if EVREAD_DS = '0' then -- deve terminare la rilettura di un evento da VME
                               STATE2 <= S2_WAITCYC;
                               PIPEA  <= PIPEA1;     -- faccio scorrere la PIPE
                               if END_PK = '0' then  -- deve terminare la rilettura di un evento dalla FIFO: rileggo la FIFO
                                 NRDMEBi<= '0';
                                 PIPEA1 <= DPR;
                                 PIPEB  <= DPR;
                                 if DPR(31 downto 28) = G_TRAIL then   -- è stato riletto un evento dalla FIFO
                                   END_PK <= '1';
                                   NRDMEBi<= '1'; -- LCOL DEBUG: evito di dare un read alla fine dell'evento
                                 end if;
                               else
                                 PIPEB  <= D_OUTBUF;
                               end if;
                             else
                               EVREAD_DS<= '0';      -- è terminata la rilettura di un evento da VME
                               END_PK <= '0';
                               PIPEA1 <= D_OUTBUF;
                               PIPEA  <= D_OUTBUF;
                               PIPEB  <= D_OUTBUF;
                               STATE2 <= S2_READ1;
                             end if;
                           end if;
      end case;
    end if;
  end process;

  EVREAD  <= EVREADi;

  -- ########################################################################
  -- REGISTRO DI STATO
  -- ########################################################################
  REG(S_DATA_READY) <= EVRDY;

  -- ########################################################################
  -- SEGNALE DI PURGED PER LA LETTURA A EVENTI ALLINEATI
  -- ########################################################################
  process(CLK,CLEAR,EVRDY)
  begin
    if CLEAR ='0' or EVRDY = '0' then
      PURGED <= '1';
    elsif CLK'event and CLK='1' then
      if (BLTCYC = '0' and MBLTCYC = '0') then
        PURGED <= '0';
      elsif EVREADi = '1' then
        PURGED <= '1';
      end if;
    end if;
  end process;


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM del LOCAL BUS
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  -- CAEN Synchronous Local Bus Interface (Master Side)
  --     LB        : OUT   std_logic_vector(15 downto 0);  -- Data/Address Bus
  --     nLBAS     : OUT   std_logic;                      -- Addess Strobe
  --     nLBCS     : OUT   std_logic_vector( 3 downto 0);  -- Chip Select (Application dependent)
  --     nLBRD     : OUT   std_logic;                      -- Read Cycle
  --     nLBWAIT   : OUT   std_logic;                      -- Wait
  --     nLBLAST   : OUT   std_logic;                      -- Last Data Transfer
  --     nLBRDY    : IN    std_logic;                      -- Ready
  --     nLBPCKE   : IN    std_logic;                      -- Packet End
  --     nLBPCKR   : IN    std_logic;                      -- Packet Ready
  --     nLBRES    : OUT   std_logic;                      -- Local Reset
  --     nLBCLR    : OUT   std_logic;                      -- Clear

  nLBCS    <= '0'; -- Local Bus always selected
  nLBRES   <= HWRES;

  -- Local Bus Addr/Data Output Enable
  LB <= LB_i when LB_nOE = '0' else (others => 'Z');


  -- Local Bus Access process
  -- It uses ALICLK as communication clock with Cyclone
  process(ALICLK, HWRES)
  begin
    if HWRES ='0' then
      STATE5      <= S5_IDLE;
      nLBASi      <= '1';
      nLBRD       <= '1';
      nLBWAIT     <= '1';
      nLBLAST     <= '1';
      LB_i        <= (others => '0');
	  LB_s        <= (others => '0');
      LB_nOE      <= '0';
      LB_REQ_sync <= '0';
      LB_ACK      <= '0';
      LB_WRITE_sync <= '0';
      OR_RREQ_sync  <= '0';
      OR_RACK     <= '0';
      REQUESTER   <= '0';
      OR_RDATA    <= (others => '0');
      LBUSTMO     <= LBUSTMOVAL;
      REG(S_LBUSTMO) <= '0';
    elsif ALICLK'event and ALICLK='1' then
      LB_REQ_sync   <= LB_REQ;            -- Sincronizzazione della richiesta da VME
      LB_WRITE_sync <= LB_WRITE;          -- Sincronizzazione del tipo di accesso da VME
      OR_RREQ_sync  <= OR_RREQ;
      LB_ACK        <= '0';
      OR_RACK       <= '0';

      case STATE5 is
        when S5_IDLE   =>  nLBASi    <= '1';
                           nLBRD     <= '1';
                           nLBWAIT   <= '1';
                           nLBLAST   <= '1';
                           REQUESTER <= '0';
                           LB_i      <= (others => '0');
                           OR_RDATA  <= (others => '0');
                           LB_nOE    <= '0';
                           LBUSTMO   <= LBUSTMOVAL;
                           if (LB_REQ_sync = '1') then   -- Accesso VME
                            REQUESTER <= '0';
                            REG(S_LBUSTMO) <= '0';
                            STATE5    <= S5_VMESTART;
                           end if;
                           if (OR_RREQ_sync = '1')  then  -- Accesso ROC
                            REQUESTER <= '1';
                            REG(S_LBUSTMO) <= '0';
                            STATE5    <= S5_ROCSTART;
                           end if;

        when S5_VMESTART  => -- CICLO SINGOLO
                              STATE5  <= S5_AS;
                              nLBASi  <= '0';
                              LB_i    <= X"00000" & LB_ADDR;
                              if LB_WRITE_sync='0' then -- ACCESSO IN LETTURA
                                nLBRD  <= '0';
                              end if;

        -- Inizia un nuovo accesso su Local Bus per una richiesta di
        -- rilettura da ROC.
        -- L'indirizzo di lettura è allineato a 32 bit.
        when S5_ROCSTART  => -- CICLO SINGOLO
                              STATE5  <= S5_AS;
                              nLBASi  <= '0';
                              LB_i    <= X"000001" & OR_RADDR & "00";
                              nLBRD   <= '0'; -- ACCESSO SEMPRE IN LETTURA

        -- ACCESSI SINGOLI --------------------------------------------------
        when S5_AS => nLBASi     <= '1';
                      nLBLAST    <= '0';
                      STATE5  <= S5_ENDCYC;
                      if LB_WRITE_sync='1' then          -- ACCESSO IN SCRITTURA
                        LB_i       <= LB_DOUT;
                        LB_nOE     <= '0';
                      else
                        LB_nOE     <= '1';
                      end if;

        when S5_ENDCYC =>

		              LBUSTMO <= LBUSTMO - 1;

                      -- ACCESSO IN SCRITTURA
                      if LB_WRITE_sync='1' then          
                        LB_i       <= VDB;
                        LB_nOE     <= '0';
                      end if;

                      if ( (nLBRDY = '0') or (LBUSTMO = "00000") ) then
                        nLBLAST     <= '1';
                        nLBRD       <= '1';
                        
                        if LBUSTMO = "00000" then
                          REG(S_LBUSTMO) <= '1'; -- Set Timeout flag in status reg
                        end if;
                        if REQUESTER = '0' then          -- Gestisco l'ack al VME
                          LB_s        <= LB;
                          STATE5      <= S5_VMEHSHAKE;
                        else                             -- Gestisco l'ack al ROC
                          OR_RDATA    <= LB(9 downto 0);
                          STATE5      <= S5_ROCHSHAKE;
                        end if;
                      end if;

        when S5_VMEHSHAKE =>
                      LB_ACK <= '1';
                      if LB_REQ_sync = '0' then           -- Attende la fine del ciclo VME in corso
                         LB_ACK <= '0';
                         STATE5  <= S5_IDLE;
                      end if;

        when S5_ROCHSHAKE =>
                      OR_RACK <= '1';
                      if OR_RREQ_sync = '0' then          -- Attende la fine del ciclo ROC in corso
                         OR_RACK <= '0';
                         STATE5    <= S5_IDLE;
                      end if;

        ---------------------------------------------------------------------
        when others  => null;
      end case;
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

  -- Generazione di NOE64R: i dati devono uscire durante il ciclo BLT64
  -- tranne che per il primo ciclo (acquisizione degli indirizzi)
  NOE64Ri  <= '0' when (MBLTCYC = '1' and ADACKCYC = '0') else
              '1';

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
  --NOEMIC <=  '1';


  -- ########################################################################
  -- VDB e VAD MUX (asincrono)
  -- ########################################################################
  process (SINGCYC,BLTCYC,MBLTCYC,VDBi,PIPEA,PIPEB)
  begin
    VDBm     <= (others => '0'); -- LC dbg 21/11
    VADm     <= (others => '0'); -- LC dbg 21/11
    -- D32
    if SINGCYC = '1'   then
      VDBm   <= VDBi;
    -- BLT32
    elsif BLTCYC ='1' then
      VDBm <= PIPEA;
    -- BLT64
    elsif MBLTCYC ='1' then
      VADm <= PIPEA;
      VDBm <= PIPEB;
    end if;
  end process;


  VDB(15 downto  0)   <= VDBm(15 downto  0) when NOE16Ri = '0' else (others => 'Z');
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
      if REG_ADS=A_LOAD_LUT   and D16 and WONLY then REGMAP(S_LOAD_LUT)  <= '1'; else REGMAP(S_LOAD_LUT)  <= '0'; end if;
      if REG_ADS=A_SW_CLEAR   and D16 and WONLY then REGMAP(S_SW_CLEAR)  <= '1'; else REGMAP(S_SW_CLEAR)  <= '0'; end if;
      if REG_ADS=A_SW_TRIGGER and D16 and WONLY then REGMAP(S_SW_TRIGGER)<= '1'; else REGMAP(S_SW_TRIGGER)<= '0'; end if;
      if REG_ADS=A_EVNT_STOR  and D16 and RONLY then REGMAP(S_EVNT_STOR) <= '1'; else REGMAP(S_EVNT_STOR) <= '0'; end if;
      if REG_ADS=A_FIRM_REV   and D16 and RONLY then REGMAP(S_FIRM_REV ) <= '1'; else REGMAP(S_FIRM_REV ) <= '0'; end if;
      if REG_ADS=A_TESTREG    and D32           then REGMAP(S_TESTREG)   <= '1'; else REGMAP(S_TESTREG)   <= '0'; end if;
      if REG_ADS=A_FLEN       and D16           then REGMAP(S_FLEN)      <= '1'; else REGMAP(S_FLEN)      <= '0'; end if;
      if REG_ADS=A_FLASH      and D16           then REGMAP(S_FLASH)     <= '1'; else REGMAP(S_FLASH)     <= '0'; end if;

      if REG_ADS=A_I2CCOM     and D16 and WONLY then REGMAP(S_I2CCOM)    <= '1'; else REGMAP(S_I2CCOM)    <= '0'; end if;
      if REG_ADS=A_I2CDAT     and D16 and RONLY then REGMAP(S_I2CDAT)    <= '1'; else REGMAP(S_I2CDAT)    <= '0'; end if;

      if REG_ADS=A_PDL_PROG   and D16           then REGMAP(S_PDL_PROG)  <= '1'; else REGMAP(S_PDL_PROG)  <= '0'; end if;
      if REG_ADS=A_PDL_DATA   and D16 and RONLY then REGMAP(S_PDL_DATA)  <= '1'; else REGMAP(S_PDL_DATA)  <= '0'; end if;
      if REG_ADS=A_PDL_AE_L   and D16           then REGMAP(S_PDL_AE_L)  <= '1'; else REGMAP(S_PDL_AE_L)  <= '0'; end if;
      if REG_ADS=A_PDL_AE_M   and D16           then REGMAP(S_PDL_AE_M)  <= '1'; else REGMAP(S_PDL_AE_M)  <= '0'; end if;
      if REG_ADS=A_PDL_AE_H   and D16           then REGMAP(S_PDL_AE_H)  <= '1'; else REGMAP(S_PDL_AE_H)  <= '0'; end if;

      if REG_ADS=A_TEMPA      and D16 and RONLY then REGMAP(S_TEMPA)     <= '1'; else REGMAP(S_TEMPA)     <= '0'; end if;
      if REG_ADS=A_TEMPB      and D16 and RONLY then REGMAP(S_TEMPB)     <= '1'; else REGMAP(S_TEMPB)     <= '0'; end if;

      if REG_ADS=A_DSYNC      and D16           then REGMAP(S_DSYNC)     <= '1'; else REGMAP(S_DSYNC)     <= '0'; end if;
      if REG_ADS=A_DDATA      and D16           then REGMAP(S_DDATA)     <= '1'; else REGMAP(S_DDATA)     <= '0'; end if;

      if REG_ADS=A_DUMMY32    and D32           then REGMAP(S_DUMMY32)   <= '1'; else REGMAP(S_DUMMY32)   <= '0'; end if;

      if REG_ADS=A_ACQUISITION and D16          then REGMAP(S_ACQUISITION)<= '1';else REGMAP(S_ACQUISITION)<= '0';end if;

      if REG_ADS=A_LBSPDIR    and D32 and WONLY then REGMAP(S_LBSPDIR)    <= '1';else REGMAP(S_LBSPDIR)   <= '0';end if;
      if REG_ADS=A_SPULSE     and D32 and RONLY then REGMAP(S_SPULSE)     <= '1';else REGMAP(S_SPULSE)    <= '0';end if;
      if REG_ADS=A_TRIGSTAT   and D16 and RONLY then REGMAP(S_TRIGSTAT)   <= '1';else REGMAP(S_TRIGSTAT)  <= '0';end if;
      if REG_ADS=A_LBSPCTRL   and D32           then REGMAP(S_LBSPCTRL)   <= '1';else REGMAP(S_LBSPCTRL)  <= '0';end if;
      if REG_ADS=A_CLKSEL     and D16           then REGMAP(S_CLKSEL)     <= '1';else REGMAP(S_CLKSEL)    <= '0';end if;
      if REG_ADS=A_CLKHIZ     and D16           then REGMAP(S_CLKHIZ)     <= '1';else REGMAP(S_CLKHIZ)    <= '0';end if;
      if REG_ADS=A_BNCRESN    and D32           then REGMAP(S_BNCRESN)    <= '1';else REGMAP(S_BNCRESN)   <= '0';end if;
      if REG_ADS=A_LEDCTRL    and D16           then REGMAP(S_LEDCTRL)    <= '1';else REGMAP(S_LEDCTRL)   <= '0';end if;
      if REG_ADS=A_CONFIG     and D16           then REGMAP(S_CONFIG)     <= '1'; else REGMAP(S_CONFIG)   <= '0'; end if;
      if REG_ADS=A_ACLK_ACT   and D16           then REGMAP(S_ACLK_ACT)   <= '1'; else REGMAP(S_ACLK_ACT) <= '0'; end if;
      if REG_ADS=A_LOAD_ACT   and D16           then REGMAP(S_LOAD_ACT)   <= '1'; else REGMAP(S_LOAD_ACT) <= '0'; end if;

      -- indirizzi della SRAM a cui si può accedere all'interno di ciascuna pagina di 256 word a 16 bit
      if REG_ADS >= A_SRAM    and REG_ADS < A_SRAM + 512
                              and D16 and RONLY then
        REGMAP(S_SRAM)      <= '1';
      else
        REGMAP(S_SRAM)   <= '0';
      end if;

      if REG_ADS >= A_LB  and REG_ADS < A_LB + A_LBSIZ
                          and D32 then
        REGMAP(S_LB)      <= '1';
      else
        REGMAP(S_LB)      <= '0';
      end if;
    end if;
  end process;

  REGMAP(S_REG16)    <= REGMAP(S_CONTROL)   or REGMAP(S_STATUS)   or
                        REGMAP(S_LOAD_LUT)  or REGMAP(S_SW_CLEAR) or REGMAP(S_SW_TRIGGER) or
                        REGMAP(S_EVNT_STOR) or
                        REGMAP(S_FIRM_REV ) or
                        REGMAP(S_FLEN)      or REGMAP(S_FLASH)    or
                        REGMAP(S_SRAM)      or
                        REGMAP(S_I2CCOM)    or REGMAP(S_I2CDAT)   or
                        REGMAP(S_PDL_PROG)  or REGMAP(S_PDL_DATA) or REGMAP(S_PDL_AE_L)   or REGMAP(S_PDL_AE_M)   or REGMAP(S_PDL_AE_H)    or
                        REGMAP(S_TEMPA)     or REGMAP(S_TEMPB)    or REGMAP(S_DSYNC)      or REGMAP(S_DDATA)      or
                        REGMAP(S_ACQUISITION) or
                        REGMAP(S_TRIGSTAT)  or REGMAP(S_CLKSEL) or REGMAP(S_CLKHIZ) or REGMAP(S_CONFIG) or
                        REGMAP(S_LEDCTRL) or REGMAP(S_ACLK_ACT) or REGMAP(S_LOAD_ACT);

  REGMAP(S_REG32)    <= REGMAP(S_OUTBUF)    or REGMAP(S_TESTREG)  or REGMAP(S_DUMMY32) or
                        REGMAP(S_LBSPDIR)   or REGMAP(S_SPULSE)   or REGMAP(S_LBSPCTRL)
                        or REGMAP(S_BNCRESN);

  REGMAP(S_ANY)      <= REGMAP(S_REG16)     or REGMAP(S_REG32) or REGMAP(S_LB) or REGMAP(S_SRAM);



END RTL;

