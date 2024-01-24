-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            04/08/05
-- --------------------------------------------------------------------------
-- Module:          I2C_INTERF
-- Description:     RTL module: I2C interface to read AD7416
--                  (based on I2C_INTER (29-06-2005) by Annalisa Mati)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--    Modifiche introdotte rispetto a I2C_INTER della TRM
--       04/08/05 Aggiunta porta DEBUG al posto di SP0-5
--       19/09/05 Aggiunto processo per rilettura automatica.
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1392pkg.all;

ENTITY I2C_INTERF_LTM IS
   PORT(
       CLK       : IN    std_logic;
       HWRES     : IN    std_logic;

       -- Bus I2C
       SDAA      : INOUT std_logic;
       SCLA      : OUT   std_logic;

       SDAB      : INOUT std_logic;
       SCLB      : OUT   std_logic;

       -- Data & Control
       I2C_RDATA   : OUT  std_logic_vector(9 downto 0);
       I2C_RREQ    : IN   std_logic;
       I2C_RACK    : OUT  std_logic;
       I2C_CHAIN  : IN   std_logic;
       CHIP_ADDR  : IN   std_logic_vector(2 downto 0);
       CHANNEL    : IN   std_logic_vector(2 downto 0);
       
       -- REG & PULSE & TICK & DEBUG bus
       REG       : INOUT reg_stream;
       PULSE     : IN    reg_pulse;
       TICK      : IN    tick_pulses;
       DEBUG     : INOUT debug_stream
   );

END I2C_INTERF_LTM ;


ARCHITECTURE RTL OF I2C_INTERF_LTM IS

  --------------------------------------------------------------------
  -- FSM
  type  TSTATE1  is (S1_IDLE,S1_START1,S1_START2,S1_STOP1,S1_STOP2,
                     S1_WR0,S1_WR1,S1_WR2,S1_RD0,S1_RD1,S1_RD2,
                     S1_ACK1,S1_ACK2,S1_ACK3);

  attribute syn_encoding : string;
  attribute syn_encoding of TSTATE1 : type is "onehot";

  type  TSTATE2  is (S2_IDLE,S2_FRAME1,S2_FRAME2,S2_FRAME3,S2_FRAME4,S2_FRAME5,S2_FRAME6, 
                     S2_FRAME7, S2_FRAME8, S2_WRREG);
  attribute syn_encoding of TSTATE2 : type is "onehot";
     
  signal  sstate  : TSTATE1;
  signal  sstate2 : TSTATE2;

  signal  BITCNT    : std_logic_vector(2 downto 0);   -- conta i bit durante lo shift
  signal  SBYTE     : std_logic_vector(7 downto 0);   -- shift register

  signal  PULSE_FL   : std_logic;
  signal  SDAin      : std_logic;
  signal  SDAout     : std_logic;
  signal  SDAout_del : std_logic;
  signal  SDAout_del1: std_logic;
  signal  SDAout_del2: std_logic;
  signal  SDAnoe     : std_logic;
  signal  SDAnoe_del : std_logic;
  signal  SDAnoe_del1: std_logic;
  signal  SDAnoe_del2: std_logic;
  signal  SCL       : std_logic;

  signal  PULSE_I2C : std_logic;
  signal  AIR_COMMAND  : std_logic_vector(D_I2CCOM'high downto D_I2CCOM'low);
  signal  AIR_CHAIN : std_logic; 

  
  signal  CHAIN_SELECT : std_logic;
  signal  COMMAND   : std_logic_vector(D_I2CCOM'high downto D_I2CCOM'low);
  signal  DATA      : std_logic_vector(D_I2CDAT'high downto D_I2CDAT'low);
  signal  START_I2C : std_logic;
    
  ------------------------------------------------------------------

begin

        
  REG <= (others => 'Z');

  DEBUG <= (others => 'Z');

  PULSE_I2C  <= PULSE(WP_I2C) when REG(ACQUISITION'low) = '0' else START_I2C; 
  REG(I2CDAT'high downto (I2CDAT'low+1)) <= DATA(D_I2CDAT'high downto (D_I2CDAT'low+1));
  
  SCLA <= SCL    when CHAIN_SELECT = '0' else '1';
  SCLB <= SCL    when CHAIN_SELECT = '1' else '1';

  SDAA <= SDAout_del2 when CHAIN_SELECT = '0' and SDAnoe_del2 = '0' else 'Z';
  SDAB <= SDAout_del2 when CHAIN_SELECT = '1' and SDAnoe_del2 = '0' else 'Z';

  SDAin<= SDAA   when CHAIN_SELECT = '0' else SDAB;

            
  P_SDA_HOLD: process (HWRES,CLK)
  begin
    if HWRES = '0' then
      SDAout_del  <= '0';
      SDAout_del1 <= '0';
      SDAout_del2 <= '0';
      SDAnoe_del  <= '0';
      SDAnoe_del1 <= '0';
      SDAnoe_del2 <= '0';
    elsif CLK'event and CLK = '1' then
      SDAout_del  <= SDAout;
      SDAout_del1 <= SDAout_del;
      SDAout_del2 <= SDAout_del1; 
      SDAnoe_del  <= SDAnoe;
      SDAnoe_del1 <= SDAnoe_del;
      SDAnoe_del2 <= SDAnoe_del1;
    end if;
  end process;
            
  process (HWRES,CLK)
  begin
    if HWRES = '0' then
      PULSE_FL <= '0';
    elsif CLK'event and CLK = '1' then
      if PULSE_I2C = '1' then
        PULSE_FL <= '1';
      elsif sstate /= S1_IDLE then
        PULSE_FL <= '0';
      end if;
    end if;
  end process;
    
  process (HWRES,CLK)
  begin
    if HWRES = '0' then
      REG(I2C_RDY) <= '1';
    elsif CLK'event and CLK = '1' then
      if PULSE_I2C = '1' then
        REG(I2C_RDY) <= '0';
      elsif sstate = S1_IDLE and PULSE_FL = '0' then
        REG(I2C_RDY) <= '1';
      end if;
    end if;
  end process;

  process (HWRES,CLK)
  begin

  if HWRES = '0' then
    SDAout <= '1';
    SDAnoe <= '1';
    SCL    <= '1';  -- master I2C -> piloto sempre il clock
    BITCNT <= (others => '0');
    SBYTE  <= (others => '0');
    DATA(D_I2CDAT'high downto (D_I2CDAT'low+1)) <= D_I2CDAT(D_I2CDAT'high downto (D_I2CDAT'low+1));
    sstate <= S1_IDLE;
  elsif CLK'event and CLK = '1' then
    if TICK(T64) = '1' then  -- la FSM evolve con periodo TICK(T64)
      case sstate is

        when S1_IDLE  =>   if PULSE_FL = '1' then   -- scrittura in I2CCOM o AIR attivo
                             if COMMAND(I2C_RX-I2CCOM'low) = '1' then       -- � stata comandata una lettura (master receiver)
                               SDAout <= '1';
                               SDAnoe <= '1';
                               BITCNT <= "000";
                               sstate <= S1_RD0;

                             else                            -- � stata comandata una scrittura (slave receiver)
                               if COMMAND(I2C_START-I2CCOM'low) = '1' then    -- devo dare lo start
                                 SDAout <= '0';
                                 SDAnoe <= '0';
                                 sstate <= S1_START1;
                               else                            -- non devo dare lo start (non � la prima scrittura)
                                 SBYTE  <= COMMAND(D_I2CCOM'high downto (D_I2CCOM'low+8)); -- carico lo shift register
                                 SDAout <= COMMAND(D_I2CCOM'high);                       -- preparo il primo bit
                                 SDAnoe <= '0';
                                 BITCNT <= "000";
                                 sstate <= S1_WR0;
                               end if;
                             end if;
                           end if;

        --------------------------------------------------------------------
        -- start
        --------------------------------------------------------------------
        when S1_START1  => SCL    <= '0';                                    -- posso muovere SDA solo se SCL = 0
                           sstate <= S1_START2;

        when S1_START2  => SBYTE  <= COMMAND(D_I2CCOM'high downto (D_I2CCOM'low+8)); -- carico lo shift register
                           SDAout <= COMMAND(D_I2CCOM'high);                       -- preparo il primo bit
                           SDAnoe <= '0';
                           BITCNT <= "000";
                           sstate <= S1_WR0;

        --------------------------------------------------------------------
        -- stop
        --------------------------------------------------------------------
        when S1_STOP1   => SCL    <= '1';
                           sstate <= S1_STOP2;

        when S1_STOP2   => SDAout <= '1';
                           SDAnoe <= '0';
                           sstate <= S1_IDLE;

        --------------------------------------------------------------------
        -- serializzazione dato in scrittura
        --------------------------------------------------------------------
        when S1_WR0     => SCL       <= '1';
                           SBYTE     <= SBYTE(SBYTE'high-1 downto SBYTE'low) & '0';
                           sstate    <= S1_WR1;

        when S1_WR1     => SCL       <= '0';
                           if BITCNT = "111" then -- nel caso che lo slave debba dare l'ack. devo rilasciare SDA
                             SDAout  <= '1';      -- sul fronte in discesa di SCL
                             SDAnoe  <= '1';
                           end if;
                           sstate    <= S1_WR2;

        when S1_WR2     => SCL       <= '0';
                           if BITCNT = "111" then
                             SDAout  <= '1';
                             SDAnoe  <= '1';
                             sstate  <= S1_ACK1;  -- Lo slave � receiver -> deve dare l'ACK.
                           else
                             BITCNT  <= BITCNT + 1;
                             SDAout  <= SBYTE(SBYTE'high);
                             SDAnoe <= '0';
                             sstate  <= S1_WR0;
                           end if;

        --------------------------------------------------------------------
        -- serializzazione dato in lettura
        --------------------------------------------------------------------
        when S1_RD0     => SCL       <= '1';
                           SBYTE     <= SBYTE(SBYTE'high-1 downto SBYTE'low) & SDAin;
                           sstate    <= S1_RD1;

        when S1_RD1     => SCL       <= '0';
                           sstate    <= S1_RD2;

        when S1_RD2     => SCL       <= '0';
                           if BITCNT = "111" then
                             DATA(D_I2CDAT'high downto (D_I2CDAT'low+8)) <= SBYTE;
                             if COMMAND(I2C_STOP-I2CCOM'low) = '1' then  -- il master � receiver; deve dare lo stop e non l'ACK.
                               SDAout <= '1';
                             else
                               SDAout <= '0';                -- il master � receiver; deve dare l'ACK.
                             end if;
                             SDAnoe <= '0';
                             sstate <= S1_ACK1;
                           else
                             BITCNT <= BITCNT + 1;
                             sstate <= S1_RD0;
                           end if;

        --------------------------------------------------------------------
        -- Acknowledge
        --------------------------------------------------------------------
        when S1_ACK1     => SCL    <= '1';
                            sstate <= S1_ACK2;

        when S1_ACK2     => SCL    <= '0';
                            if REG(I2C_RX) = '0' then      -- lo slave � receiver -> metto ACK = not SDA
                              DATA(I2C_ACK-I2CDAT'low) <= not SDAin;
                            else
                              DATA(I2C_ACK-I2CDAT'low) <= '1';         -- il master � receiver -> metto ACK = 1
                            end if;
                            sstate  <= S1_ACK3;

        when S1_ACK3     => if COMMAND(I2C_STOP-I2CCOM'low) = '1' then    -- devo dare lo stop
                              SDAout <= '0';
                              SDAnoe <= '0';
                              sstate <= S1_STOP1;
                            else
                              sstate <= S1_IDLE;
                            end if;

      end case;
    end if;
  end if;
  end process;
  
  
  process (HWRES,CLK)
  begin
    if HWRES = '0' then
      CHAIN_SELECT <= '0';
      COMMAND      <= (others => '0');
    elsif CLK'event and CLK = '1' then
      if sstate = S1_IDLE then
        if (REG(ACQUISITION'low) = '0') then
          CHAIN_SELECT <= REG(C_SENS_TEMP); 
          COMMAND      <= REG(I2CCOM'range);
        else
          COMMAND      <= AIR_COMMAND;
          if (I2C_RREQ = '1') then      
            CHAIN_SELECT <= AIR_CHAIN; -- Memorizzo la catena da usare quando arriva la richiesta di 
                                       -- acquisizione. Non viene cambiata dalla macchina stati durante
                                       -- l'invio dei diversi frame.
                                       -- Il valore di Command invece varia da frame a frame
          end if;
        end if;
      end if;
    end if;
  end process;

  process (HWRES,CLK)
  begin
   if HWRES = '0' then
     sstate2    <= S2_IDLE;
     START_I2C  <= '0';
     I2C_RDATA   <= (others => '0');
     I2C_RACK    <= '0';
     AIR_CHAIN <= '0';
     AIR_COMMAND      <= (others => '0');
   elsif CLK'event and CLK = '1' then
       I2C_RACK    <= '0'; -- Piazzata qui per avere un valid di un solo ciclo di clock
       if TICK(T64) = '1' then  -- la FSM evolve con periodo TICK(T64) 
          case sstate2 is
            when S2_IDLE       =>   I2C_RACK <= '0';
                                    if I2C_RREQ = '1' then   -- Richiesta di lettura
                                      sstate2 <=  S2_FRAME1;
                                      AIR_CHAIN <= I2C_CHAIN;
                                    else
                                      sstate2 <=  S2_IDLE;
                                      AIR_CHAIN <= REG(C_SENS_TEMP);
                                      AIR_COMMAND      <= REG(I2CCOM'range);
                                    end if;

            -- FRAME1 -> FRAME3 : Scrittura nel registro di configurazione 
            --                    per la selezione del canale
            --
            -- FRAME4 -> FRAME7 : Lettura dato convertito
            --
            --
            -- Serial Bus Address Byte
            -- Write Transfer + Master TX + START
            when S2_FRAME1    =>   START_I2C <= '1';
                                   AIR_COMMAND <= CHIP_ID & CHIP_ADDR & '0' & "00000010"; 
                                   sstate2 <=  S2_FRAME2;

            -- Address Pointer = CONFIG REGISTER
            -- Master TX                       
            when S2_FRAME2    =>   START_I2C <= '0';
                                   if REG(I2C_RDY) = '1' then
                                      START_I2C <= '1';
                                      AIR_COMMAND <= "00000001" & "00000000"; 
                                      sstate2 <=  S2_FRAME3;
                                   end if;

            -- WRITE CHANNEL SELECTION field in CONFIG register 
            -- Master TX + STOP                       
            when S2_FRAME3    =>   START_I2C <= '0';
                                   if REG(I2C_RDY) = '1' then
                                     START_I2C <= '1';
                                     AIR_COMMAND <= CHANNEL & "00000" & "00000100"; 
                                     sstate2 <=  S2_FRAME4;
                                   end if;

            -- Serial Bus Address Byte
            -- Write Transfer + Master TX + START
            when S2_FRAME4       => START_I2C <= '0';
                                    if REG(I2C_RDY) = '1' then        
                                      START_I2C <= '1';               
                                      AIR_COMMAND <= CHIP_ID & CHIP_ADDR & '0' & "00000010"; 
                                      sstate2 <=  S2_FRAME5;
                                    end if;
                                    
            -- Address Pointer = TEMPERATURE (0x00) or ADC (0x04) register 
            -- Master TX + STOP                      
            when S2_FRAME5    =>   START_I2C <= '0';
                                   if REG(I2C_RDY) = '1' then
                                     START_I2C <= '1';
                                     if CHANNEL = "000" then
                                       AIR_COMMAND <= "00000000" & "00000100"; -- TEMPERATURE READ
                                     else
                                       AIR_COMMAND <= "00000100" & "00000100"; -- ADC READ
                                     end if;
                                     sstate2 <=  S2_FRAME6;
                                   end if;
            
            -- Serial Bus Address Byte
            -- Read Transfer + Master TX + START
            when S2_FRAME6       => START_I2C <= '0';
                                    if REG(I2C_RDY) = '1' then        
                                      START_I2C <= '1';               
                                      AIR_COMMAND <= CHIP_ID & CHIP_ADDR & '1' & "00000010"; 
                                      sstate2 <=  S2_FRAME7;
                                    end if;
            
            
            -- Master RX 
            when S2_FRAME7     =>   START_I2C <= '0';
                                    if REG(I2C_RDY) = '1' then
                                       sstate2 <=  S2_FRAME8;
                                       START_I2C <= '1';
                                       AIR_COMMAND <= "0000000000000001"; 
                                    end if;

            -- Master RX + STOP
            when S2_FRAME8     =>   START_I2C <= '0';
                                    if REG(I2C_RDY) = '1' then
                                       I2C_RDATA(9 downto 2) <= REG(I2CDAT'high downto (I2CDAT'low+8));
                                       sstate2 <=  S2_WRREG;
                                       AIR_COMMAND <= "0000000000000101"; 
                                       START_I2C <= '1';
                                    end if;  

            when S2_WRREG     =>    START_I2C <= '0';
                                    if REG(I2C_RDY) = '1' then
                                       I2C_RDATA(1 downto 0) <= REG(I2CDAT'high downto (I2CDAT'high-1));
                                       I2C_RACK <= '1';
                                       sstate2 <=  S2_IDLE;
                                    end if;    

            when others        => sstate2 <= S2_IDLE;               

          end case;
     end if;
   end if;
  end process;
  

END RTL;
