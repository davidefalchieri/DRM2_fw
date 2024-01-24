-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA750
-- Author:          Annalisa Mati
-- Date:            21/06/13
-- --------------------------------------------------------------------------
-- Module:          I2C_INTERF
-- Description:     RTL module: I2C interface to read AD7416
-- ****************************************************************************

-- ############################################################################
-- Revision History:
-- 30.05: Release rilasciata
-- 00.01: Aggiunto processo per rilettura automatica (by Luca Colombini)
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1390pkg.all;

ENTITY I2C_INTERF IS
	GENERIC( 
		SIM_MODE     : boolean := FALSE     -- Enable simulation mode 
	);
   PORT(
       CLK       : IN    std_logic;
       HWRES     : IN    std_logic;

       -- Bus I2C
       SDAA      : INOUT std_logic;
       SCLA      : OUT   std_logic;

       SDAB      : INOUT std_logic;
       SCLB      : OUT   std_logic;

       REGS      : INOUT VME_REG_RECORD;
	   
       PULSE     : IN    reg_pulse;
       TICK      : IN    tick_pulses;

       SP0       : INOUT std_logic; -- Spare
       SP1       : INOUT std_logic;
       SP2       : INOUT std_logic;
       SP3       : INOUT std_logic;
       SP4       : INOUT std_logic;
       SP5       : INOUT std_logic

   );

END I2C_INTERF ;


ARCHITECTURE RTL OF I2C_INTERF IS

  signal  SDAin        : std_logic;
  signal  SDAout       : std_logic;
  signal  SDAnoe       : std_logic;
  signal  SCL          : std_logic;

  signal  BITCNT       : std_logic_vector(2 downto 0);   -- conta i bit durante lo shift
  signal  SBYTE        : std_logic_vector(7 downto 0);   -- shift register

  signal  PULSE_I2C    : std_logic; -- scrittura nel registro I2CCOM o AIR attivo: comanda lo start della FSM1
  signal  PULSE_FL     : std_logic;

  signal  CHAIN_SELECT : std_logic; -- seleziona la catena I2C (A o B)
  signal  COMMAND      : std_logic_vector(D_I2CCOM'high downto D_I2CCOM'low);
  signal  DATA         : std_logic_vector(D_I2CDAT'high downto D_I2CDAT'low);

  -- Segnali per l'automatic I2C readout (AIR):
  signal  AIR_START : std_logic; -- Automatic I2C Readout start pulse: comanda lo start della FSM2
  signal  AIR_PULSE : std_logic; -- comanda lo start automatico della FSM1

  signal  AIR_WDATA : std_logic_vector(D_I2CCOM'high downto D_I2CCOM'low);
  signal  TEMPDATA  : std_logic_vector(7 downto 0);  -- memorizz. primo byte e primo ack. della rilettura automatica
  signal  TEMP_ACK  : std_logic;
  signal  AIR_CHAIN : std_logic;
  signal  SENS_ADDR : std_logic_vector(2 downto 0);


  constant C_SENS_MAX_ADDR : std_logic_vector(2 downto 0) := "100";


  -- ************************************************************************
  -- Definizione degli stati delle FSM
  attribute syn_encoding : string;

  type  TSTATE1  is (S1_IDLE,S1_START1,S1_START2,S1_STOP1,S1_STOP2,
                     S1_WR0,S1_WR1,S1_WR2,S1_RD0,S1_RD1,S1_RD2,
                     S1_ACK1,S1_ACK2,S1_ACK3);

  signal  sstate1 : TSTATE1;
  attribute syn_encoding of sstate1 : signal is "onehot";


  type  TSTATE2  is (S2_IDLE,S2_FRAME1,S2_FRAME2,S2_FRAME3, S2_WRREG);

  signal  sstate2 : TSTATE2;
  attribute syn_encoding of sstate2 : signal is "onehot";

  -- ************************************************************************

begin


  -- Mux per i segnali dei 2 bus I2C
  SCLA  <= SCL    when CHAIN_SELECT = '0' else '1';
  SCLB  <= SCL    when CHAIN_SELECT = '1' else '1';

  SDAA  <= SDAout when CHAIN_SELECT = '0' and SDAnoe = '0' else 'Z';
  SDAB  <= SDAout when CHAIN_SELECT = '1' and SDAnoe = '0' else 'Z';

  SDAin <= SDAA   when CHAIN_SELECT = '0' else SDAB;


  -- selezione della catena e command: scritti da VME se AIR è disabilitato,
  -- altrimenti generati da FSM2
  process (HWRES,CLK)
  begin
    if HWRES = '0' then
      CHAIN_SELECT <= '0';
      COMMAND      <= (others => '0');
    elsif CLK'event and CLK = '1' then
      if sstate1 = S1_IDLE then
        if (REGS.CONTROL(C_AIR_ENA) = '0') then  -- AIR disabilitato
          CHAIN_SELECT <= REGS.CONTROL(C_TEMP_CHAIN);
          COMMAND      <= REGS.I2CCOM;
        else                            -- AIR abilitato
          CHAIN_SELECT <= AIR_CHAIN;
          COMMAND      <= AIR_WDATA;
        end if;
      end if;
    end if;
  end process;


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM1 per l'accesso al bus I2C
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- scrittura nel registro I2CCOM (PULSE(WP_I2C)) o
  -- AIR attivo (AIR_PULSE): comanda lo start della FSM1
  PULSE_I2C <= PULSE(WP_I2C) when REGS.CONTROL(C_AIR_ENA) = '0' else AIR_PULSE;

  process (HWRES,CLK)
  begin
    if HWRES = '0' then
      PULSE_FL <= '0';
    elsif CLK'event and CLK = '1' then
      if PULSE_I2C = '1' then
        PULSE_FL <= '1';
      elsif sstate1 /= S1_IDLE then
        PULSE_FL <= '0';
      end if;
    end if;
  end process;

  -- evoluzione degli stati
 U_I2C_acc_fsm : process (HWRES,CLK)
  begin

    if HWRES = '0' then

      SDAout <= '1';
      SDAnoe <= '1';
      SCL    <= '1';  -- master I2C -> piloto sempre il clock

      BITCNT <= (others => '0');
      SBYTE  <= (others => '0');

      DATA(D_I2CDAT'high downto (D_I2CDAT'low+1)) <= D_I2CDAT(D_I2CDAT'high downto (D_I2CDAT'low+1));

      sstate1 <= S1_IDLE;

    elsif CLK'event and CLK = '1' then

      if TICK(T64) = '1' then  -- la FSM evolve con periodo TICK(T64)

        case sstate1 is

          when S1_IDLE   => if PULSE_FL = '1' then   -- scrittura in I2CCOM o AIR attivo

                              if COMMAND(I2C_RX) = '1' then -- è stata comandata una lettura (master receiver)
                                SDAout  <= '1';
                                SDAnoe  <= '1';
                                BITCNT  <= "000";
                                sstate1 <= S1_RD0;

                              else                                     -- è stata comandata una scrittura (slave receiver)
                                if COMMAND(I2C_START) = '1' then -- devo dare lo start
                                  SDAout  <= '0';
                                  SDAnoe  <= '0';
                                  sstate1 <= S1_START1;
                                else                                        -- non devo dare lo start (non è la prima scrittura)
                                  SBYTE   <= COMMAND(D_I2CCOM'high downto (D_I2CCOM'low+8)); -- carico lo shift register
                                  SDAout  <= COMMAND(D_I2CCOM'high);                         -- preparo il primo bit
                                  SDAnoe  <= '0';
                                  BITCNT  <= "000";
                                  sstate1 <= S1_WR0;
                                end if;
                              end if;
                            end if;

          --------------------------------------------------------------------
          -- start
          --------------------------------------------------------------------
          when S1_START1 => SCL     <= '0';                                            -- posso muovere SDA solo se SCL = 0
                            sstate1 <= S1_START2;

          when S1_START2 => SBYTE   <= COMMAND(D_I2CCOM'high downto (D_I2CCOM'low+8)); -- carico lo shift register
                            SDAout  <= COMMAND(D_I2CCOM'high);                         -- preparo il primo bit
                            SDAnoe  <= '0';
                            BITCNT  <= "000";
                            sstate1 <= S1_WR0;

          --------------------------------------------------------------------
          -- stop
          --------------------------------------------------------------------
          when S1_STOP1  => SCL     <= '1';
                            sstate1 <= S1_STOP2;

          when S1_STOP2  => SDAout  <= '1';
                            SDAnoe  <= '0';
                            sstate1 <= S1_IDLE;

          --------------------------------------------------------------------
          -- serializzazione dato in scrittura
          --------------------------------------------------------------------
          when S1_WR0    => SCL     <= '1';
                            SBYTE   <= SBYTE(SBYTE'high-1 downto SBYTE'low) & '0';
                            sstate1 <= S1_WR1;

          when S1_WR1    => SCL      <= '0';
                            if BITCNT = "111" then -- nel caso che lo slave debba dare l'ack. devo rilasciare SDA
                              SDAout <= '1';       -- sul fronte in discesa di SCL
                              SDAnoe <= '1';
                            end if;
                            sstate1  <= S1_WR2;

          when S1_WR2    => SCL       <= '0';
                            if BITCNT = "111" then
                              SDAout  <= '1';
                              SDAnoe  <= '1';
                              sstate1 <= S1_ACK1;  -- Lo slave è receiver -> deve dare l'ACK.
                            else
                              BITCNT  <= BITCNT + 1;
                              SDAout  <= SBYTE(SBYTE'high);
                              SDAnoe  <= '0';
                              sstate1 <= S1_WR0;
                            end if;

          --------------------------------------------------------------------
          -- serializzazione dato in lettura
          --------------------------------------------------------------------
          when S1_RD0    => SCL       <= '1';
                            SBYTE     <= SBYTE(SBYTE'high-1 downto SBYTE'low) & SDAin;
                            sstate1   <= S1_RD1;

          when S1_RD1    => SCL       <= '0';
                            sstate1   <= S1_RD2;

          when S1_RD2    => SCL       <= '0';
                            if BITCNT = "111" then
                              DATA(D_I2CDAT'high downto (D_I2CDAT'low+8)) <= SBYTE;
                              if COMMAND(I2C_STOP) = '1' then  -- il master è receiver; deve dare lo stop e non l'ACK.
                                SDAout <= '1';
                              else
                                SDAout <= '0';                            -- il master è receiver; deve dare l'ACK.
                              end if;
                              SDAnoe  <= '0';
                              sstate1 <= S1_ACK1;
                            else
                              BITCNT  <= BITCNT + 1;
                              sstate1 <= S1_RD0;
                            end if;

          --------------------------------------------------------------------
          -- Acknowledge
          --------------------------------------------------------------------
          when S1_ACK1   => SCL     <= '1';
                            sstate1 <= S1_ACK2;

          when S1_ACK2   => SCL     <= '0';
                            if COMMAND(I2C_RX) = '0' then         -- lo slave è receiver  -> metto ACK = not SDA
                              DATA(I2C_ACK) <= not SDAin;
                            else
                              DATA(I2C_ACK) <= '1';    -- il master è receiver -> metto ACK = 1
                            end if;
                            sstate1 <= S1_ACK3;

          when S1_ACK3   => if COMMAND(I2C_STOP) = '1' then       -- devo dare lo stop
                              SDAout  <= '0';
                              SDAnoe  <= '0';
                              sstate1 <= S1_STOP1;
                            else
                              sstate1 <= S1_IDLE;
                            end if;

        end case;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------
  -- REGISTRO I2C DAT
  ---------------------------------------------------------------------
  REGS.I2CDAT(D_I2CDAT'high downto (D_I2CDAT'low+1)) <= DATA(D_I2CDAT'high downto (D_I2CDAT'low+1));

  -- bit READY del registro I2C DAT
  process (HWRES,CLK)
  begin
    if HWRES = '0' then
      REGS.I2CDAT(I2C_RDY) <= '1';
    elsif CLK'event and CLK = '1' then
      if PULSE_I2C = '1' then
        REGS.I2CDAT(I2C_RDY) <= '0';
      elsif sstate1 = S1_IDLE and PULSE_FL = '0' then
        REGS.I2CDAT(I2C_RDY) <= '1';
      end if;
    end if;
  end process;


  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- FSM2 per l'Automatic I2C readout
  -- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -- Start AIR ogni TICK(T64M): comanda lo start della FSM2
  process (HWRES,CLK)
  begin
    if HWRES = '0' then
      AIR_START <= '0';
    elsif CLK'event and CLK = '1' then
      if (TICK(T64M) = '1' and SIM_MODE = FALSE) or 
         (TICK(T16K) = '1' and SIM_MODE = TRUE )then
        AIR_START <= '1';
      elsif sstate2 /= S2_FRAME1 then
        AIR_START <= '0';
      end if;
    end if;
  end process;


  process (HWRES,CLK)
  begin

    if HWRES = '0' then

      AIR_WDATA  <= (others => '0');
      TEMPDATA   <= (others => '0');
      TEMP_ACK   <= '0';
      AIR_CHAIN  <= '0';
      SENS_ADDR  <= "000";
      AIR_PULSE  <= '0';
	  
      REGS.TEMPA  <= D_TEMPA;
      REGS.TEMPB  <= D_TEMPB;

      sstate2    <= S2_IDLE;

    elsif CLK'event and CLK = '1' then

      if TICK(T64) = '1' then  -- la FSM evolve con periodo TICK(T64)

        case sstate2 is

          when S2_IDLE   => if REGS.CONTROL(C_AIR_ENA) = '1' then                           -- Readout automatico abilitato
                              sstate2   <=  S2_FRAME1;
                            end if;


          when S2_FRAME1 => if AIR_START = '1' and REGS.I2CDAT(I2C_RDY) = '1' then
                              AIR_PULSE <= '1';
                              AIR_WDATA <= CHIP_ID & SENS_ADDR & '1' & "00000010"; -- Read + Master TX + START
                              sstate2   <=  S2_FRAME2;
                            end if;

          when S2_FRAME2 => AIR_PULSE <= '0';
                            if REGS.I2CDAT(I2C_RDY) = '1' then
                              AIR_PULSE <= '1';
                              AIR_WDATA <= "0000000000000001";                     -- Master RX (comando 1° lettura)
                              sstate2   <=  S2_FRAME3;
                            end if;

          when S2_FRAME3 => AIR_PULSE <= '0';
                            if REGS.I2CDAT(I2C_RDY) = '1' then
                              -- memorizzo il primo byte letto e l'ACK della prima rilettura
                              TEMPDATA <= REGS.I2CDAT(D_I2CDAT'high downto (D_I2CDAT'low+8));
                              TEMP_ACK <= REGS.I2CDAT(D_I2CDAT'low+1);

                              AIR_WDATA <= "0000000000000101";                     -- Master RX + STOP (comando 2° lettura)
                              AIR_PULSE <= '1';
                              sstate2   <=  S2_WRREG;
                            end if;

          when S2_WRREG  => AIR_PULSE <= '0';
                            -- è pronto il secondo byte letto
                            if REGS.I2CDAT(I2C_RDY) = '1' then

                              -- cambio catena I2C
                              AIR_CHAIN <= not (AIR_CHAIN);

                              -- incremento l'indirizzo del sensore (ogni 2 cicli)
                              if AIR_CHAIN = '1' then
                                if SENS_ADDR = C_SENS_MAX_ADDR then
                                  SENS_ADDR <= "000";
                                else
                                  SENS_ADDR <= SENS_ADDR + 1;
                                end if;
                              end if;

                              if AIR_CHAIN = '0' then
                                REGS.TEMPA      <="00" &
                                                  (TEMP_ACK and REGS.I2CDAT(D_I2CDAT'low+1)) &  -- Ack delle due riletture
                                                  SENS_ADDR &                                   -- n° del sensore
                                                  TEMPDATA &                                    -- temp su 10 bit: 1° byte letto
                                                  REGS.I2CDAT(D_I2CDAT'high downto(D_I2CDAT'high-1));           -- 2° byte letto
                              else
                                REGS.TEMPB      <="00" &
                                                  (TEMP_ACK and REGS.I2CDAT(D_I2CDAT'low+1)) &  -- Ack delle due riletture
                                                  SENS_ADDR &                                   -- n° del sensore
                                                  TEMPDATA &                                    -- temp su 10 bit: 1° byte letto
                                                  REGS.I2CDAT(D_I2CDAT'high downto (D_I2CDAT'high-1));          -- 2° byte letto
                              end if;

                              sstate2 <=  S2_IDLE;

                            end if;


        end case;
      end if;
    end if;
  end process;

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
