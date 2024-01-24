-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - LTM Alice TOF
-- FPGA Proj. Name: V1392ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            30/08/05
-- --------------------------------------------------------------------------
-- Module:          PDL
-- Description:     RTL module: PDL programming and readback 
--                             (in Serial mode only).
--                  Target Programmable Delay Line is 
--                  Model 3D3418 from Data Delay Devices.
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1392pkg.all;

ENTITY PDL_INTERF IS
      PORT(
          CLK       : IN    std_logic;
          HWRES     : IN    std_logic;
          CLEAR     : IN    std_logic;
          LOAD_RES  : IN    std_logic;
          
          -- PDL control
          SP0       : INOUT std_logic_vector(47 downto 0);   -- Serial Out (MD=0) / PO (MD=1)  
          AE        : OUT   std_logic_vector(47 downto 0);   -- Address Enable
          SI        : OUT   std_logic;                       -- Serial In
          SC        : OUT   std_logic;                       -- Serial Clock
          MD        : OUT   std_logic;                       -- programming Mode(0=Serial;1=Parallel)
          P         : OUT   std_logic_vector(7 downto 1);    -- Parallel Out
          
          -- Data & Control
          PDL_RDATA  : OUT  std_logic_vector(7 downto 0);
          PDL_RADDR  : IN   std_logic_vector(5 downto 0);
          PDL_RREQ   : IN   std_logic;
          PDL_RACK   : OUT  std_logic;

          -- Accessi alla PDL CONFIGURATION ROM
          PDLCFG_nRD: OUT   std_logic;
          PDLCFG_DT : IN    std_logic_vector(7 downto 0);
          PDLCFG_RAD: OUT   std_logic_vector(5 downto 0);
       
          -- Debug
          DEBUG     : INOUT debug_stream;
                    
          REG       : INOUT reg_stream;
          PULSE     : IN    reg_pulse;
          TICK      : IN    tick_pulses
      );
END PDL_INTERF;

ARCHITECTURE RTL OF PDL_INTERF IS

  --------------------------------------------------------------------
  -- FSM
  type  TSTATE1  is (S1_CFG0,S1_CFG1, S1_CFG2, S1_CFG3, S1_CFG4, S1_CFG5, S1_IDLE,
                     S1_READ0, S1_READ1, S1_SPI0,S1_SPI1,S1_SPI2, S1_WAIT);


  attribute syn_encoding : string;
  attribute syn_encoding of TSTATE1 : type is "onehot";

  signal  sstate  : TSTATE1;


  --------------------------------------------------------------------
  signal SBYTE     : std_logic_vector(7 downto 0);   -- byte SPI
  signal ISI       : std_logic;                      -- SPI SI dalla FSM
  signal ISCK      : std_logic;                      -- SPI SCK dalla FSM

  signal MODE      : std_logic;
  signal SEL       : std_logic_vector(5 downto 0);
  signal P0        : std_logic_vector(47 downto 0);
  signal SO        : std_logic;
  signal BYTE      : std_logic_vector(7 downto 0);
  
  
  signal BITCNT    : std_logic_vector (2 downto 0);  -- conta i bit durante lo shift
  
  signal VALID     : std_logic;
  signal CNT       : std_logic_vector(5 downto 0);

BEGIN

   REG                 <= (others => 'Z');
   REG(PDL_DATA'range) <= "0000000" & VALID & SBYTE;
   
   DEBUG               <= (others => 'Z');
            
   BYTE  <= REG(PDL_P7) & REG(PDL_P6) & REG(PDL_P5) & REG(PDL_P4) & 
            REG(PDL_P3) & REG(PDL_P2) & REG(PDL_P1) & REG(PDL_P0);
           
  
   MD   <= MODE;
   SEL  <= REG(PDL_SEL5) & REG(PDL_SEL4) & REG(PDL_SEL3) & 
           REG(PDL_SEL2) & REG(PDL_SEL1) & REG(PDL_SEL0);
           
   SI  <= ISI;
   SC  <= ISCK;
              
   -- Serial Configuration State Machine
  process (HWRES, LOAD_RES, PULSE,CLK)
  begin

    if HWRES = '0' then

      ISCK      <= '0';
      ISI       <= '0';
      SBYTE     <= (others => '0');
      VALID     <= '1';

      PDLCFG_RAD <= (others => '0');
      PDLCFG_nRD <= '1';

      AE <= (others => '0');
      
      MODE      <= REG(PDL_MODE);
      sstate    <= S1_IDLE;
      CNT       <= (others => '0');
      PDL_RACK  <= '0';
      PDL_RDATA  <= (others => '0');

	  BITCNT    <= "000";
	  P0        <= (others => '0');
	  P         <= (others => '0');
      
    elsif LOAD_RES = '0' then

      ISCK      <= '0';
      ISI       <= '0';
      SBYTE     <= (others => '0');
      VALID     <= '1';

      PDLCFG_RAD <= (others => '0');
      PDLCFG_nRD <= '1';

      AE <= (others => '0');

      MODE      <= PDL_PARALLEL_MODE;
      CNT       <= (others => '0');
      PDL_RACK  <= '0';
      PDL_RDATA <= (others => '0');
	  BITCNT    <= "000";
	  P0        <= (others => '0');
	  P         <= (others => '0');

      sstate    <= S1_CFG0;
      

    elsif CLK'event and CLK = '1' then
      case sstate is

        --------------------------------------------------------------------
        -- SCRITTURA CONFIGURAZIONE PDL LETTA DA Configuration ROM
        --------------------------------------------------------------------
        when S1_CFG0  => ISI        <= '0';
                         ISCK       <= '0';
                         VALID      <= '1';
                         MODE       <= PDL_PARALLEL_MODE;                         
                         PDLCFG_nRD <= '1';
                         AE         <= (others => '0');
                         
                         sstate     <= S1_CFG1;
                         
        when S1_CFG1  => if CNT = "110000" then -- 48
                           sstate <= S1_CFG5;
                           AE     <= (others => '0');
                         else
                           AE         <= (others => '0');
                           PDLCFG_nRD <= '0';
                           PDLCFG_RAD <= CNT;
                           sstate     <= S1_CFG2;
                         end if;
                   
        when S1_CFG2  => PDLCFG_nRD   <= '1'; 
                         sstate       <= S1_CFG3;                         
                        
        when S1_CFG3  => PDLCFG_nRD               <= '1';
                         AE(conv_integer(CNT))    <= '1';
                         P                        <= PDLCFG_DT(7 downto 1);
                         P0(conv_integer(CNT))    <= PDLCFG_DT(0);
                         CNT                      <= CNT + 1;
                         sstate                   <= S1_CFG4;
                         
        when S1_CFG4  => sstate                   <= S1_CFG1;                         
                         
        when S1_CFG5  => sstate                   <= S1_IDLE;                 
                         

        --------------------------------------------------------------------
        -- LETTURA/SCRITTURA DA VME: modalità NORMAL
        --------------------------------------------------------------------
        when S1_IDLE  => ISI        <= '0';
                         ISCK       <= '0';
                         VALID      <= '1';
                         MODE       <= REG(PDL_MODE);
                         PDL_RACK   <= '0';
                         PDLCFG_RAD <= (others => '0');
                         PDLCFG_nRD <= '1';


                         case MODE is 
                           when PDL_PARALLEL_MODE =>
                              AE <= (REG(PDL_AE_H'range) & REG(PDL_AE_M'range) & REG(PDL_AE_L'range));
                           when others =>  
                              AE(conv_integer(SEL)) <= '1';
                         end case;

                         -- Parallel Configuration
                         P  <= REG(PDL_P7) & REG(PDL_P6) & REG(PDL_P5) & REG(PDL_P4) & 
                               REG(PDL_P3) & REG(PDL_P2) & REG(PDL_P1);
                        
                      
                         for i in 0 to (SP0'length-1) loop
                           P0(i) <=  REG(PDL_P0);
                         end loop;   

                         if PDL_RREQ = '1' then -- TODO: gestire concorrenza?
                           sstate     <= S1_READ0;
                           PDLCFG_RAD <= PDL_RADDR;
                           PDLCFG_nRD <= '0';
                         end if;
                         
                         if ((PULSE(WP_PDL) = '1') and 
                             (MODE = PDL_SERIAL_MODE)) then
                           SBYTE  <= BYTE;               -- carico lo shift register
                           ISI    <= BYTE(BYTE'high);    -- preparo il primo bit
                           BITCNT <= "000";
                           VALID     <= '0';
                           sstate <= S1_SPI0;
                         end if;

        --------------------------------------------------------------------
        -- Lettura valore PDL da RAM
        --------------------------------------------------------------------
        when S1_READ0    => PDLCFG_nRD  <= '1';
                            sstate      <= S1_READ1;
                           
        when S1_READ1    => PDLCFG_nRD  <= '1';
                            PDL_RACK    <= '1';
                            PDL_RDATA   <= PDLCFG_DT;
                            sstate      <= S1_WAIT;
                       
        -- Handshake                           
        -- Attende che il ROC tolga la richiesta per togliere l'ack
        when S1_WAIT   =>  if PDL_RREQ = '0' then
                             PDL_RACK   <= '0';
                             sstate     <= S1_IDLE;
                           end if;
        --------------------------------------------------------------------
        -- serializzazione dato
        --------------------------------------------------------------------
        when S1_SPI0    => ISCK      <= '1';
                           SBYTE     <= SBYTE(SBYTE'high-1 downto SBYTE'low) & SO;
                           sstate    <= S1_SPI1;

        when S1_SPI1    => ISCK      <= '0';
                           sstate    <= S1_SPI2;

        when S1_SPI2    => ISCK      <= '0';
                           if BITCNT = "111" then
                             sstate  <= S1_IDLE;
                           else
                             BITCNT  <= BITCNT + 1;
                             ISI     <= SBYTE(SBYTE'high);
                             sstate  <= S1_SPI0;
                           end if;
         when others    => sstate    <= S1_IDLE;

      end case;
    end if;
  end process;
   
   
   
   -- SP0 driver
   process(MODE, P0)
   begin
      SP0 <= (others => 'Z');
      case MODE is
         when PDL_PARALLEL_MODE => 
              SP0 <= P0;
         when others          =>
              SP0 <= (others => 'Z');
      end case;
   end process; 

   -- SO select (demux)
   -- When in SERIAL PROGRAMMING MODE, SP0 is selected using 
   -- SEL filed of control register.
   SO <= SP0(conv_integer(SEL)) and (not VALID); 
   
END rtl;

