-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            04/08/05
-- --------------------------------------------------------------------------
-- Module:          RESET
-- Description:     RTL module: reset and clear manager
--                  (based on RESET_MOD (30-06-2005) by Annalisa Mati)
-- **************************************************************************

-- ##########################################################################
-- Revision History:
--    Modifiche introdotte rispetto a RESET_MOD della TRM
--       04/08/05 - Aggiunta porta DEBUG al posto di SP0-5
--       23/08/05 - Rimosse porte non utili per LTM: COM_SER,
--                  STOP_ACQ, TDC_*, SPAREM  
--       10/06/08 - Aggiunto contatore di attività pilotato da Aliclock   
-- ##########################################################################

-- %Company%

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1392pkg.all;

ENTITY RESET_MOD IS
   GENERIC(
     G_SIM_ON       : boolean := FALSE  -- TRUE=Fast simulation
   );
  PORT (
       CLK       : IN    std_logic;
       ACLK      : IN    std_logic; -- ALICLK dopo il PLL
       NPWON     : IN    std_logic;
       SYSRESB   : IN    std_logic;
       LOAD_RES  : IN    std_logic; -- è in corso il caricamento della Scratch RAM
       WDOGTO    : IN    std_logic;

       HWRES     : OUT   std_logic; -- Reset HW
       CLEAR     : OUT   std_logic; -- CLEAR delle FSM del ROC e delle memorie
       HWCLEAR   : OUT   std_logic; -- resetta il registro ACQUISITION (PLL non loccate)
       
       RUN       : OUT   std_logic; -- RUn 
       PON_LOAD  : OUT   std_logic; -- Request of Power-On Configuration Load
       
       BNC_RESIN : IN    std_logic; -- TDCs counters reset da P2
       EV_RESIN  : IN    std_logic; -- TDCs event reset da P2

       BNC_RES   : OUT   std_logic; -- TDCs counters reset (durata 1 ciclo di clock)
       EV_RES    : OUT   std_logic; -- TDCs event reset    (durata 1 ciclo di clock)

       DEBUG     : INOUT debug_stream;

       PULSE     : IN    reg_pulse;
       REG       : INOUT reg_stream;
       TICK      : OUT   tick_pulses

   );

END RESET_MOD ;


ARCHITECTURE RTL OF RESET_MOD IS

signal  HWRESi    : std_logic;
signal  RUN_ACQi : std_logic;

signal  CLEARi    : std_logic;
signal  HWCLEARi  : std_logic;

signal  BNC_RESi  : std_logic;
signal  EV_RESi   : std_logic;
signal  BNC_RES1   : std_logic;    -- per ottenere CNT_RES che dura 1 ciclo di CLK
signal  EV_RES1    : std_logic;    -- per ottenere EV_RES che dura 1 ciclo di CLK

signal TICKi : tick_pulses;

signal TCNT1 : std_logic_vector(5 downto 0) := (others => '0');
signal TCNT2 : std_logic_vector(7 downto 0) := (others => '0');
signal TCNT3 : std_logic_vector(7 downto 0) := (others => '0');
signal TCNT4 : std_logic_vector(3 downto 0) := (others => '0');

signal SoftPON, SoftPON1, LongSoftPON : std_logic;

signal ACTIVITY : std_logic_vector(15 downto 0);

begin

  REG <= (others => 'Z');

  DEBUG <= (others => 'Z');
  DEBUG(15) <= LongSoftPON;
  DEBUG(14) <= SoftPON;
  DEBUG(13) <= SoftPON1;
  
  RUN_ACQi <= REG(ACQUISITION'low);
  
  REG(ACLK_ACT'range) <= ACTIVITY;
  
  RUN      <= RUN_ACQi;
  
  process(CLEARi, ACLK)
  begin
    if CLEARi = '0' then
      ACTIVITY <= (others => '0');
    elsif ACLK'event and ACLK = '1' then
      ACTIVITY <= ACTIVITY + 1;
    end if;
  end process;


  -- ******************************************************************
  -- CLEAR e HWRES ATTIVI BASSI; RUN_ACQ ATTIVO ALTO
  -- Se il registro ACQUISITION = 0 il modulo non acquisisce (è in clear)
  -- Acquisition si resetta (con HWCLEAR) se le PLL non sono loccate o
  -- se il Watchdog del VME va in time out o se c'è un software clear.
  -- ******************************************************************
  -- Reset hardware
  HWRESi  <= NPWON and  LongSoftPON and (SYSRESB or REG(C_SYSRES_INHIBIT));

  -- Clear del ROC e delle memorie
  CLEARi  <= HWRESi and HWCLEARi and LOAD_RES and RUN_ACQi;

  -- Resetta il registro ACQUISITION (PLL non loccate o WATCHDOG in time out)
  process(HWRESi, CLK)
  begin
    if HWRESi = '0' then
      HWCLEARi <= '0';
    elsif CLK'event and CLK = '1' then
      HWCLEARi <= (not WDOGTO) and (not PULSE(SW_CLEAR));
    end if;
  end process;

  
  -- ******************************************************************
  -- Segnali di RESET da P2
  -- ******************************************************************
  -- BNCRES e EVRES arrivano da P2 e sono sincroni col ALICLK.
  -- I segnali devono durare 1 ciclo di ALICLK e sono
  -- ritardati di 1 ciclo di ALICLK rispetto a quelli da P2
  process(ACLK,HWRESi,RUN_ACQi)
  begin
    if HWRESi ='0' or RUN_ACQi = '0' then
      BNC_RES1 <= '0';
      EV_RES1  <= '0';
      BNC_RESi <= '0';
      EV_RESi  <= '0';
    elsif ACLK'event and ACLK = '1' then
      BNC_RES1 <= BNC_RESIN;
      EV_RES1  <= EV_RESIN;
      BNC_RESi <= (BNC_RESIN and not BNC_RES1);
      EV_RESi  <= (EV_RESIN  and not EV_RES1);
    end if;
  end process;


SIM_PON : if G_SIM_ON = TRUE generate
  LongSoftPON <= '1'; -- HACK x simulazione veloce
end generate;

SOFT_PON_GENERATE : if G_SIM_ON = FALSE generate
  -- Soft Power-On reset
  P_SoftPON: process(CLK)
   variable cnt1 : std_logic_vector(3 downto 0)  := (others => '0'); -- Simulation init
   variable cnt2 : std_logic_vector(31 downto 0) := (others => '0'); -- Simulation init
   variable stop1 : std_logic := '0'; 
   variable stop2 : std_logic := '0';
  begin
    if CLK'event and CLK = '1' then
      SoftPON1    <= SoftPON;
      LongSoftPON <= SoftPON1 and SoftPON; 
        if (stop2 = '0') then
          cnt2 := cnt2 + 1;
          if (stop1 = '0') then
            SoftPON <= '1';          
            cnt1 := cnt1 + 1;
            if (cnt1 = X"F") then
              stop1 := '1';
              SoftPON <= '0';
            end if;
          end if;
          --if (cnt2 = X"01FFFFFF") then -- 0.8 sec
          if (cnt2 = X"00000FFF") then -- ~100 us
            SoftPON <= '0';
            stop2 := '1';
          end if;
        else
          SoftPON <= '1';
        end if;
	end if;
  end process;
end generate;  
  
  -- Confuration ROM reload
  process(HWRESi, CLK)
   variable cnt2 : std_logic_vector(1 downto 0);
   variable stop : std_logic; 
  begin
    if HWRESi = '0' then
      PON_LOAD <= '0';
      cnt2 := (others => '0');
      stop := '0';
    elsif CLK'event and CLK = '1' then
      PON_LOAD <= '0';
      if G_SIM_ON = TRUE then -- Simulation
        if TICKi(T64) = '1' and (stop = '0') then
          cnt2 := cnt2 + 1;
          if cnt2 = "10" then
            stop := '1';
            PON_LOAD <= '1';
          end if;
        end if;
      else                    -- Synthesis
        if TICKi(T64M) = '1' and (stop = '0') then
          cnt2 := cnt2 + 1;
          if cnt2 = "10" then
            stop := '1';
            PON_LOAD <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;
  
  -- ########################################################################
  -- TICK
  -- Un Tick e' un impulso che dura 1 periodo di CLK e viene ripetuto ogni N periodi
  -- ########################################################################
  -- T64:  Periodo=Tclk*64  (circa 1.6us a 40MHz)
  -- T16K: Periodo=Tclk*16K (circa 410us a 40MHz)
  -- T4M:  Periodo=Tclk*4M  (circa 104ms a 40MHz)
  -- T64M: Periodo=Tclk*64M (circa 1.6s  a 40MHz)
  process(CLK)
  begin
    if CLK'event and CLK='1' then

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

  HWRES    <= HWRESi;
  CLEAR    <= CLEARi;
  HWCLEAR  <= HWCLEARi;
  BNC_RES  <= BNC_RESi;
  EV_RES   <= EV_RESi;


END RTL;
