-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            28/09/05
-- --------------------------------------------------------------------------
-- Module:          DAC_INTERF
-- Description:     RTL module: DAC Interface.
--                  It allows configuration of AD5611 on-board DACs
-- ****************************************************************************

-- ############################################################################
-- Revision History:
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1392pkg.all;

ENTITY DAC_INTERF IS
     GENERIC(
        G_SIM_ON       : boolean := FALSE  -- Fast SPI
    );

   PORT(
       CLK       : IN    std_logic;
       HWRES     : IN    std_logic;
       SYNC      : OUT   std_logic_vector(15 downto 0);    -- AD5601 /CS (/SYNC)
       -- Bus SPI
       SDIN_DAC  : OUT   std_logic;
       SCLK_DAC  : OUT   std_logic;

       -- DAC Periodic update
       DAC_REFRESH : IN    std_logic;                    -- Enable refresh from CRAM (active high)
       
       -- Accessi alla DAC CONFIGURATION ROM
       DACCFG_nRD: OUT   std_logic;
       DACCFG_DT : IN    std_logic_vector(15 downto 0);
       DACCFG_RAD: OUT   std_logic_vector( 3 downto 0);

       REG       : INOUT reg_stream;
       PULSE     : IN    reg_pulse;
       TICK      : IN    tick_pulses;

       DEBUG     : INOUT debug_stream
   );

END DAC_INTERF ;


ARCHITECTURE RTL OF DAC_INTERF IS

  --------------------------------------------------------------------
  -- FSM
  type  TSTATE1  is (S1_IDLE,S1_SPI0,S1_SPI1,S1_SPI2, S1_REFRESH,
                     S1_READ0, S1_READ1);


  attribute syn_encoding : string;
  attribute syn_encoding of TSTATE1 : type is "onehot";

  signal  sstate  : TSTATE1;


  --------------------------------------------------------------------
  signal   SWORD     : std_logic_vector(15 downto 0);   -- byte SPI
  signal   ISI       : std_logic;                      -- SPI SI dalla FSM
  signal   ISCK      : std_logic;                      -- SPI SCK dalla FSM

  signal   BITCNT    : std_logic_vector (3 downto 0);  -- conta i bit durante lo shift

  signal   RefreshCycle : std_logic;                   -- Segnala che è in corso
                                                       -- un aggiornamento dei DAC
                                                       
  signal   DACRdPnt  : std_logic_vector(3 downto 0);     
  signal   LastDac   : std_logic;                      -- Segnala ciclo di 
                                                       -- aggiornamento dei DAC                                                   
  --------------------------------------------------------------------

begin


  REG   <= (others => 'Z');

  DEBUG <= (others => 'Z');
  
  SDIN_DAC  <= ISI;
  SCLK_DAC  <= ISCK;
 
  DACCFG_RAD   <= DACRdPnt;

  process (HWRES,PULSE,CLK)
  begin

    if HWRES = '0' then

      ISCK      <= '0';
      ISI       <= '0';
      SWORD     <= (others => '0');

      BITCNT    <= (others => '0');
      RefreshCycle <= '0';
      DACCFG_nRD   <= '1';

      DACRdPnt  <= (others => '0');
      LastDac   <= '0';
      sstate    <= S1_IDLE;

     SYNC      <= REG(DSYNC'range);

    elsif CLK'event and CLK = '1' then

      case sstate is

        when S1_IDLE  => 
                         ISI          <= '0';
                         ISCK         <= '0';
                         RefreshCycle <= '0';
                         DACCFG_nRD   <= '1';
                         LastDac      <= '0';
                         DACRdPnt     <= (others => '0');
                         SYNC         <= REG(DSYNC'range);
                         
                         if PULSE(WP_DAC) = '1' then
                           SWORD  <= REG(DDATA'range);   -- carico lo shift register
                           ISI    <= REG(DDATA'high);    -- preparo il primo bit
                           BITCNT <= "0000";
                           sstate <= S1_SPI0;
                         end if;
                         
                         if G_SIM_ON = FALSE then
                           if ((TICK(T4M) = '1')  and (DAC_REFRESH = '1')) then
                             sstate       <= S1_REFRESH;
                             SYNC         <= (others => '1'); -- Disabilita tutti i DAC
                             RefreshCycle <= '1';
                           end if;
                         else -- Faster update for simulation only
                           if ((TICK(T64) = '1')  and (DAC_REFRESH = '1')) then
                             sstate       <= S1_REFRESH;
                             SYNC         <= (others => '1'); -- Disabilita tutti i DAC
                             RefreshCycle <= '1';
                           end if;                         
                         end if;

        --------------------------------------------------------------------
        -- Refresh periodico delle memorie analogiche
        --------------------------------------------------------------------
        when S1_REFRESH    =>  if DACRdPnt = "1111" then 
                                 LastDac      <= '1';
                               end if;
                               DACCFG_nRD   <= '0';
                               sstate       <= S1_READ0;
                               
        when S1_READ0      =>  DACCFG_nRD   <= '1';
                               sstate       <= S1_READ1;
        
        when S1_READ1      =>  DACCFG_nRD   <= '1';
                               SWORD  <= DACCFG_DT;          -- carico lo shift register
                               ISI    <= DACCFG_DT(DACCFG_DT'high);    -- preparo il primo bit
                               BITCNT <= "0000";
                               SYNC   <= (others => '1'); -- Disabilita tutti i DAC
                               SYNC(conv_integer(DACRdPnt)) <= '0'; -- Abilita solo il DAC
                                                                    -- da aggiornare
                               DACRdPnt <= DACRdPnt + 1; 
                               sstate <= S1_SPI0;
        --------------------------------------------------------------------
        -- serializzazione dato
        --------------------------------------------------------------------
        when S1_SPI0    => ISCK      <= '1';
                           SWORD     <= SWORD(SWORD'high-1 downto SWORD'low) & '0';
                           sstate    <= S1_SPI1;

        when S1_SPI1    => ISCK      <= '0';
                           sstate    <= S1_SPI2;

        when S1_SPI2    => ISCK      <= '0';
                           if BITCNT = "1111" then
                             if  ( (RefreshCycle = '1') and (LastDac = '0') ) then
                              sstate    <= S1_REFRESH;
                             else
                              sstate    <= S1_IDLE;
                             end if;
                           else
                             BITCNT  <= BITCNT + 1;
                             ISI     <= SWORD(SWORD'high);
                             sstate  <= S1_SPI0;
                           end if;
        when others    =>  sstate    <= S1_IDLE;

      end case;
    end if;
  end process;  

END RTL;
