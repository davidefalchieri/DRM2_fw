-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA750
-- Author:          Annalisa Mati
-- Date:            21/06/13
-- --------------------------------------------------------------------------
-- Module:          RESET
-- Description:     RTL module: reset and clear manager
-- **************************************************************************

-- ##########################################################################
-- Revision History:
-- 30.05: Release rilasciata
-- 00.00: - modificati i RESET, per la gestione degli errori su HPTDC
--        - eliminato STOP_ACQ perchè nel caso di FAULT la scheda viene spenta da uC
-- ##########################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1390pkg.all;

ENTITY RESET_MOD IS
  PORT (
       CLK       : IN    std_logic;
       NPWON     : IN    std_logic;
       SYSRESB   : IN    std_logic;
       COM_SER   : IN    std_logic; -- è in corso la programmazione dei TDC
       COM_SERS  : OUT   std_logic;
       LOAD_RES  : IN    std_logic; -- è in corso il caricamento delle
                                    -- tabelle di compensazione
       PLL_LOCK  : IN    std_logic;

       HWRES     : OUT   std_logic; -- Reset HW

       CLEAR_STAT: OUT   std_logic; -- Clear Status: tiene in CLEAR le FSM del ROC
                                    -- e fa il clear delle memorie
       HWCLEAR   : OUT   std_logic; -- resetta il registro ACQUISITION (PLL non loccate)

       BNC_RESIN : IN    std_logic; -- TDCs counters reset da P2
       EV_RESIN  : IN    std_logic; -- TDCs event reset da P2

       BNC_RES   : OUT   std_logic; -- TDCs counters reset        (durata 1 ciclo di clock)
       BNC_RES_E : OUT   std_logic; -- arriva 2 cicli di CLK prima del BNC_RES inviato su P2:
                                    -- fa uscire le catene dalla condizione di errore
                                    -- (durata 1 ciclo di clock)
       EV_RES    : OUT   std_logic; -- TDCs event reset           (durata 1 ciclo di clock)
       TDC_RES   : OUT   std_logic; -- TDCs master reset al ROC32 (durata 1 ciclo di clock)
       TDC_RESA  : OUT   std_logic; -- TDCs chainA master reset   (durata 1 ciclo di clock)
       TDC_RESB  : OUT   std_logic; -- TDCs chainB master reset   (durata 1 ciclo di clock)
       TDC_RES_ERR: IN  std_logic;


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

END RESET_MOD ;


ARCHITECTURE RTL OF RESET_MOD IS

signal  HWRESi     : std_logic;
signal  HWCLEARi   : std_logic;
signal  CLEAR_STATi: std_logic;

signal  COM_SERF1  : std_logic;
signal  COM_SERSi   : std_logic;

signal  CLEAR       : std_logic;
signal  CLEARF1     : std_logic;
signal  CLEARF2     : std_logic;
signal  CLEAR_PULSE1: std_logic;
signal  CLEAR_PULSE2: std_logic;

signal  TDC_RESi   : std_logic;

signal  BNC_RESF1  : std_logic;
signal  BNC_RESF2  : std_logic;
signal  BNC_RESerr : std_logic;
signal  BNC_RESF3  : std_logic;
signal  BNC_RESi   : std_logic;

signal  EV_RESF1   : std_logic;
signal  EV_RESF2   : std_logic;
signal  EV_RESi    : std_logic;

begin


  process(NPWON, CLK)
  begin
    if NPWON = '0' then
      REGS.STATUS(S_PWON) <= '0';
    elsif CLK'event and CLK = '1' then
      if TICK(T64) = '1' then
        REGS.STATUS(S_PWON) <=  '1';
      end if;
    end if;
  end process;


  -- ******************************************************************
  -- CLEAR e RESET ATTIVI BASSI;
  -- ******************************************************************
  -- Reset hardware
  HWRESi  <= NPWON and SYSRESB;

  -- Clear Hardware: resetta il registro ACQUISITION
  -- Se il registro ACQUISITION = 0 il modulo non acquisisce (è in CLEAR STATUS)
  -- Acquisition si resetta se le PLL non sono loccate
  process(HWRESi, CLK)
  begin
    if HWRESi = '0' then
      HWCLEARi <= '0';
    elsif CLK'event and CLK = '1' then
      HWCLEARi <= PLL_LOCK;
    end if;
  end process;

  -- CLEAR STATUS (CLEAR_STATi = 0):

  -- * c'è un HWRES o un HWCLEAR                                |
  -- * sto caricando le tabelle di compensazione (LOAD_RES = 0) | => CLEAR = 0
  -- * non sono in acquisizione (REG(ACQUISITION) = 0)          |
  -- * viene dato un Clear SW                                   |
  -- oppure
  -- * C'è una comunicazione seriale da uC (COM_SER = 1)

  -- In CLEAR STATUS le FSM del ROC e le memorie sono tenute in clear.
  -- Prima di uscire dal CLEAR STATUS (CLEAR_STATi = 1) do un TDC_RES.

  -- CLK       |    |    |    |    |    |    |    |    |    |    |    |
  --        __________                 ________________________________
  -- CLEAR            |_______________|
  --        _____________                ______________________________
  -- CLEARF1             |______________|
  --        __________________                _________________________
  -- CLEARF2                  |______________|
  --             _______________________      _________________________
  -- CLEAR_PULSE1                       |____|
  --                                          ____
  -- TDC_RES  _______________________________|    |____________________
  --            ______                             ____________________
  -- CLEAR_STATi      |___________________________|
  --                  <-   non acquisisco   ->

  -- se il CLEAR è attivo (per esempio non sono in acquisizione) ma c'è un
  -- COM_SER, alla fine del COM_SER do un TDC_RES anche se resto in CLEAR STATUS

  -- CLK       |    |    |    |    |    |    |    |    |    |    |    |
  --                                                               ____
  -- CLEAR  ______________________________________________________|
  --                    ____________________
  -- COM_SER___________|                    |__________________________
  --                      ___________________
  -- COM_SERF1___________|                   |_________________________
  --                           ___________________
  -- COM_SERF2________________|                   |____________________
  --             ____________________________      ____________________
  -- CLEAR_PULSE2                            |____|
  --                                               ____
  -- TDC_RES  ____________________________________|    |_______________



  CLEAR   <= HWRESi and HWCLEARi and LOAD_RES and
            (not PULSE(SW_CLEAR)) and REGS.ACQUISITION(0);

  process(HWRESi, CLK)
  begin
    if HWRESi = '0' then
      CLEARF1   <= '0';
      CLEARF2   <= '0';
      COM_SERF1 <= '0';
      COM_SERSi <= '0';
    elsif CLK'event and CLK = '1' then
      CLEARF1   <= CLEAR;
      CLEARF2   <= CLEARF1;
      COM_SERF1 <= COM_SER;
      COM_SERSi <= COM_SERF1;
    end if;
  end process;

  -- con un clear pulse viene dato un TDC_RES
  CLEAR_PULSE1 <= not(CLEARF1 and not CLEARF2);

  CLEAR_PULSE2 <= not (not COM_SERF1 and COM_SERSi);


  process(CLK,CLEAR,COM_SER)
  begin
    if CLEAR = '0' or COM_SER = '1' then
      CLEAR_STATi <= '0';
    elsif CLK'event and CLK = '1' then
      if TDC_RESi = '1' then
        CLEAR_STATi <= '1';
      end if;
    end if;
  end process;


  -- ******************************************************************
  -- Segnali di RESET per i TDC
  -- ******************************************************************
  -- BNC_RESIN e EV_RESIN arrivano da P2 e dovrebbero essere sincroni
  -- col CLOCK. Sono comunque cloccati perchè non si abbia metastabilità
  -- nel caso che in debug si inviino segnali non sincroni.
  -- I segnali inviati ai TDC devono durare 1 ciclo di CLOCK.
  -- EV_RES  è ritardato di 2 cicli di CLOCK rispetto a quello da P2
  -- BNC_RES è ritardato di 4 cicli di CLOCK rispetto a quello da P2
  -- (per la gestione degli errori dei tdc)

  -- CLK       |    |    |    |    |    |    |    |    |    |    |    |
  --              _________
  -- EV_RESIN ___|         |___________________________________________
  --                 _________
  -- EV_RESF1 ______|         |________________________________________
  --                      _________
  -- EV_RESF2 ___________|         |___________________________________
  --                      ____
  -- EV_RES   ___________|    |________________________________________


  -- CLK       |    |    |    |    |    |    |    |    |    |    |    |
  --              _________
  -- BNC_RESIN __|         |___________________________________________
  --                 _________
  -- BNC_RESF1 _____|         |________________________________________
  --                      _________
  -- BNC_RESF2 __________|         |___________________________________
  --                      ____
  -- BNC_RESerr__________|    |________________________________________
  --                           ____
  -- BNC_RESF3 _______________|    |___________________________________
  --                                ____
  -- BNC_RES   ____________________|    |______________________________

  process(CLK,HWRESi,CLEAR_STATi)
  begin
    if HWRESi ='0' or CLEAR_STATi = '0' then

      EV_RESF1   <= '0';
      EV_RESF2   <= '0';
      EV_RESi    <= '0';

      BNC_RESF1  <= '0';
      BNC_RESF2  <= '0';
      BNC_RESerr <= '0';
      BNC_RESF3  <= '0';
      BNC_RESi   <= '0';

    elsif CLK'event and CLK = '1' then
      EV_RESF1   <= EV_RESIN;
      EV_RESF2   <= EV_RESF1;
      EV_RESi    <= (EV_RESF1 and not EV_RESF2);

      BNC_RESF1  <= BNC_RESIN;
      BNC_RESF2  <= BNC_RESF1;
      BNC_RESerr <= (BNC_RESF1 and not BNC_RESF2);
      BNC_RESF3  <= BNC_RESerr;
--      if TDC_RES_ERR = '0' then  -- in caso di errore dò solo il TDC_RES e non il BNC_RES
      BNC_RESi   <= BNC_RESF3;
--      end if;
    end if;
  end process;


  -- TDC_RES è sincronizzato per non avere un segnale combinatorio in uscita
  -- (TDC_RES_ERR è dato dalla FSM del ROC per la gestione degli errori: non usato)
  process(CLK,HWRESi)
  begin
    if HWRESi ='0' then
      TDC_RESi  <= '0';
    elsif CLK'event and CLK = '1' then
      TDC_RESi  <= not CLEAR_PULSE1 or not CLEAR_PULSE2; -- or TDC_RES_ERR;
    end if;
  end process;


  TDC_RESA   <= TDC_RESi;    -- ai TDC
  TDC_RESB   <= TDC_RESi;
  TDC_RES    <= TDC_RESi;    -- al ROC

  HWRES      <= HWRESi;
  HWCLEAR    <= HWCLEARi;
  BNC_RES_E  <= BNC_RESerr;
  BNC_RES    <= BNC_RESi;
  EV_RES     <= EV_RESi;

  COM_SERS   <= COM_SERSi;
  CLEAR_STAT <= CLEAR_STATi;

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
