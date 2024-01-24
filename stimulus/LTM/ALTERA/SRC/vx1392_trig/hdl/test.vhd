--
-- VHDL Architecture vx1392_trig.test1.rtl
--
-- Created:
--          by - daprato.UNKNOWN (LUCA-FE)
--          at - 10:02:43 29/11/2005
--
-- using Mentor Graphics HDL Designer(TM) 2003.2 (Build 28)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY test IS
   PORT( 
      CLK_TEST    : IN     std_logic;
      -- Cyclone Configuration Port
      CONFIG      : OUT    std_logic;
      FCS         : OUT    std_logic;
      F_SCK       : OUT    std_logic;
      F_SI        : OUT    std_logic;
      F_SO        : IN     std_logic;
      -- Clock Port
      DPCLK       : IN     std_logic_vector (7 DOWNTO 0);
      SCLK        : IN     std_logic;                      -- Selectable CLock (ALICLK or Local CLOCK)
      -- Trigger Port
      OR_DEL      : IN     std_logic_vector (47 DOWNTO 0);
      TRD         : OUT    std_logic_vector ( 7 DOWNTO 0);
      TRM         : OUT    std_logic_vector (23 DOWNTO 0);
      D_CTTM      : OUT    std_logic_vector (23 DOWNTO 0);
      SP_CTTM     : OUT    std_logic_vector ( 6 DOWNTO 0);
      -- SRAM Interface
      nCSRAM      : OUT    std_logic;
      nOERAM      : OUT    std_logic;
      nWRRAM      : OUT    std_logic;
      RAMDT       : INOUT  std_logic_vector (47 DOWNTO 0);
      RAMAD       : OUT    std_logic_vector (17 DOWNTO 0);
      -- LTM local triggers
      LTM_LOCAL_TRG : OUT  std_logic;
      PULSE_TOGGLE  : IN   std_logic;
      -- Local Bus Interface
      nLBAS       : IN     std_logic;
      nLBCLR      : IN     std_logic;
      nLBCS       : IN     std_logic;
      nLBLAST     : IN     std_logic;
      nLBRD       : IN     std_logic;
      nLBRES      : IN     std_logic;
      nLBWAIT     : IN     std_logic;
      nLBRDY      : OUT    std_logic;
      nLBPCKE     : OUT    std_logic;
      nLBPCKR     : OUT    std_logic;
      LB          : INOUT  std_logic_vector (31 DOWNTO 0);
      LBSP        : INOUT  std_logic_vector (31 DOWNTO 0);
      -- Test Port
      TST         : OUT    std_logic_vector (7 DOWNTO 0)
   );

-- Declarations

END test ;

--
ARCHITECTURE rtl OF test IS

constant PDL_TEST_IDX : natural := 0;
constant RAM_TEST_IDX : natural := 1;
constant CLK_TEST_IDX : natural := 2;
constant BRES_TEST_IDX : natural := 3;


constant REVISION     : std_logic_vector(31 downto 0) := X"FFFF0002";

signal DELAY_CNT      : std_logic_vector(7 downto 0);

-- Local BUS support signals
type   LBSTATE_TYPE is (S_LBIDLE, S_LBWRITE, S_LBREAD, S_LBREAD1, S_LBDONE);
signal LBSTATE : LBSTATE_TYPE;

signal nLBRDY_s  : std_logic;
signal WREN      : std_logic;
signal WREN_s    : std_logic;
signal RDEN      : std_logic;
signal RDEN_s    : std_logic;
signal WREN_r    : std_logic;
signal RDEN_r    : std_logic;
signal ADDR      : std_logic_vector( 8 downto 0);
signal ADDR_s    : std_logic_vector( 8 downto 0);
signal DATAOUT   : std_logic_vector(31 downto 0);
signal DATAIN    : std_logic_vector(31 downto 0);
signal ADDRESS   : std_logic_vector(11 downto 0);


-- 
signal CTTM_TEST_DATA : std_logic_vector (23 DOWNTO 0);

--
signal MODE      : std_logic; -- '0' => TEST; '1' => I/O

-- REGISTERS
signal MODE_REG        : std_logic_vector(31 downto 0);
signal TEST_CTRL_REG   : std_logic_vector(31 downto 0);
signal TEST_STAT_REG   : std_logic_vector(31 downto 0);
signal RAM_ADDR_REG    : std_logic_vector(31 downto 0);
signal RAM_DATA_REG    : std_logic_vector(63 downto 0);
signal CTTM_DATA_REG   : std_logic_vector(31 downto 0);
signal TRM_DATA_REG    : std_logic_vector(31 downto 0);
signal TRD_DATA_REG    : std_logic_vector(31 downto 0);
signal PDL_SEL_REG     : std_logic_vector(31 downto 0);
signal SPARE_CTTM_REG  : std_logic_vector(31 downto 0);
signal OR_DATA_REG     : std_logic_vector(63 downto 0);
signal PDL_DELAY_REG   : std_logic_vector( 7 downto 0);
signal SCLK_CNT_REG    : std_logic_vector(31 downto 0);

type   DPCLK_COUNTER   is array(0 to 7) of std_logic_vector(31 downto 0);
signal DPCLK_CNT_REG   : DPCLK_COUNTER;

signal DUMMY_REG       : std_logic_vector(31 downto 0);

-- TEST STROBES
signal PDL_TEST_START   : std_logic;
signal PDL_TEST_START_S : std_logic; -- Syncronizzato
signal PDL_TEST_START_S1: std_logic; -- Syncronizzato

signal RAM_TEST_START  : std_logic;
signal CLK_TEST_START  : std_logic;


-- ACCESS DECODE
signal RAM_ACCESS  : std_logic;


signal OR_UNDER_TEST   : std_logic;
signal OR_UNDER_TEST_S : std_logic;
signal COUNT_ENABLE    : std_logic;
signal COUNT_RESET     : std_logic;

signal SCLK_ON       : std_logic;
signal DPCLK_ON      : std_logic_vector(7 downto 0);

signal BNCRES        : std_logic;

-- Definizione degli stati
attribute syn_encoding : string;

-- FSM1 che gestisce il test delle PDL
type   TSTATE1 is (S0PDL,  S1PDL, S2PDL);
attribute syn_encoding of TSTATE1 : type is "onehot";
signal STATE1 : TSTATE1;


BEGIN

-- TESTS
PDL_TEST_START <= TEST_CTRL_REG(PDL_TEST_IDX);
RAM_TEST_START <= TEST_CTRL_REG(RAM_TEST_IDX);
CLK_TEST_START <= TEST_CTRL_REG(CLK_TEST_IDX);

TEST_STAT_REG(TEST_STAT_REG'high downto BRES_TEST_IDX+1) <= (others => '0');

--============================================================
-- I/O MODE
--============================================================
MODE     <= MODE_REG(0);
TRD      <= TRD_DATA_REG(7 downto 0)   when MODE = '1' else (others => 'Z');
TRM      <= TRM_DATA_REG(23 downto 0)  when MODE = '1' else (others => 'Z');
SP_CTTM  <= SPARE_CTTM_REG(6 downto 0) when MODE = '1' else (others => 'Z');
D_CTTM   <= CTTM_DATA_REG(23 downto 0) when MODE = '1' else CTTM_TEST_DATA;

--============================================================
-- OR DATA BUS
--============================================================
OR_DATA_REG(31 downto 0)  <= "00000000" & OR_DEL(23 downto 0);
OR_DATA_REG(63 downto 32) <= "00000000" & OR_DEL(47 downto 24);

--============================================================
-- LOCAL BUS (APA<->CYCLONE INTEFACE)
--============================================================
-- Signal    Description      Direction
-- Name
--nLBAS   => Address Strobe       I
--nLBCLR  => Clear                I
--nLBCS   => Chip Select          I
--nLBLAST => Last Transfer        I
--nLBRD   => Read Request         I
--nLBRES  => Reset                I
--nLBWAIT => Wait cycle           I
--nLBRDY  => Slave ready          O
-- nLBPCKE => Unused              O
-- nLBPCKR => Unused              O
-- LB      => Address and Data Bus IO
-- LBSP    => Spare Auxiliary Data IO

-- LBSP(0) used as SRAM Chip Select
-- LBSP(1) used as SRAM Output ENable
-- LBSP(2) is a copy of BNCRES signal from P2 Connector
-- Directly controlled by APA.

LB       <= DATAOUT(31 downto  0) when (RDEN_r   = '1') else (others => 'Z');
LBSP     <= (others => 'Z');

ADDRESS  <= ("000" & ADDR) when ((nLBAS = '0') and (nLBCS = '0'))  else ("000" & ADDR_s);
ADDR     <= LB(8 downto 0);

DATAIN   <= LB;
WREN     <= WREN_s and nLBWAIT;
RDEN     <= RDEN_s and nLBWAIT;

WREN_s   <= WREN_r;
RDEN_s   <= '1' when ((nLBAS = '0') and (nLBCS = '0') and (nLBRD = '0')) else RDEN_r;
nLBRDY   <= nLBRDY_s;
nLBPCKE  <= '1';
nLBPCKR  <= '1';
 
-- SRAM INTERFACE
-- I segnali di controllo della ram sono gestiti da una macchina a stati
RAM_ACCESS <= '1' when ((ADDRESS = X"014" ) or (ADDRESS = X"010" )) else '0';

RAMAD    <= RAM_ADDR_REG(17 downto 0);
RAMDT    <= RAM_DATA_REG(47 downto 0) when LBSP(1) = '1' else (others => 'Z');

-- Uso alcuni Spare per il pilotaggio diretto dei segnali della SRAM
nCSRAM   <= LBSP(0); 
nOERAM   <= LBSP(1) ;
nWRRAM   <= not(LBSP(1));

-- Flash Driver
F_SCK    <= 'Z';
F_SI     <= 'Z';
FCS      <= 'Z';
CONFIG   <= 'Z';--nCYC_RELOAD;

BNCRES   <= LBSP(2);
TEST_STAT_REG(BRES_TEST_IDX) <= BNCRES;

-- ############### 
-- LOCAL BUS FSM
-- ###############
process(DPCLK(0), nLBRES)
begin
  if (nLBRES = '0') then
    WREN_r   <= '0';
    RDEN_r   <= '0';
    nLBRDY_s <= '1';
    LBSTATE  <= S_LBIDLE;
    ADDR_s   <= (others => '0');
    PDL_TEST_START_S <= '0'; 
  elsif rising_edge(DPCLK(0)) then
    if (nLBCLR = '0') then
      WREN_r   <= '0';
      RDEN_r   <= '0';
      nLBRDY_s <= '1';
      LBSTATE  <= S_LBIDLE;
      ADDR_s   <= (others => '0');
    else
      PDL_TEST_START_S <= PDL_TEST_START ; -- Sincronizzatore 
      case LBSTATE is
        when S_LBIDLE  => if ((nLBAS = '0') and (nLBCS = '0')) then
                          ADDR_s   <= ADDR;        -- Address Sampling
                          if (nLBRD = '1') then
                            nLBRDY_s <= '0';
                            WREN_r   <= '1'; 
                            LBSTATE  <= S_LBWRITE; -- Write Selection
                          else 
                            nLBRDY_s <= '1';       -- HACK: introduco uno stato di attesa in pi� ed attendo a dare il ready
                            RDEN_r   <= '1';
                            LBSTATE  <= S_LBREAD;  -- Read Selection
                          end if;
                        else
                          LBSTATE <= S_LBIDLE;
                        end if;
          when S_LBWRITE => 
                        nLBRDY_s <= '0';
                        if ((nLBLAST = '0') and (nLBRDY_s = '0')) then
                          WREN_r   <= '0';
                          nLBRDY_s <= '1';
                          LBSTATE  <= S_LBDONE;
                        end if;
          when S_LBREAD  => 
                        LBSTATE  <= S_LBREAD1;  -- Read Selection
          
          when S_LBREAD1 => 
                        nLBRDY_s <= '0';
                        if ((nLBLAST = '0') and (nLBRDY_s = '0') and (nLBWAIT = '1')) then
                          RDEN_r   <= '0';
                          nLBRDY_s <= '1';
                          LBSTATE  <= S_LBDONE;
                        end if;
         when S_LBDONE  => LBSTATE <= S_LBIDLE;
        end case;
      end if;
    end if;
  end process;
  
  
  -- WRITE AND READ REGISTERS
  process(DPCLK(0), nLBRES)
  begin
    if (nLBRES = '0') then
      DATAOUT             <= (others => '0');
      MODE_REG            <= (others => '0');
      TEST_CTRL_REG       <= (others => '0');
      RAM_ADDR_REG        <= (others => '0');
      RAM_DATA_REG        <= (others => '0');
      CTTM_DATA_REG       <= (others => '0');
      TRM_DATA_REG        <= (others => '0');
      TRD_DATA_REG        <= (others => '0');
      PDL_SEL_REG         <= (others => '0');
      SPARE_CTTM_REG      <= (others => '0');
      DUMMY_REG           <= (others => '0');
      LTM_LOCAL_TRG       <= '0';
    elsif rising_edge(DPCLK(0)) then
      -- ##################################
      -- Write on Configuration Registers 
      -- ##################################
      if (WREN = '1') then
        case ADDRESS is
          when X"000" => MODE_REG                   <= DATAIN;
          when X"004" => TEST_CTRL_REG              <= DATAIN;
          when X"00C" => RAM_ADDR_REG               <= DATAIN;
          when X"010" => RAM_DATA_REG(31 downto 0)  <= DATAIN;
          when X"014" => RAM_DATA_REG(63 downto 32) <= DATAIN;
          when X"018" => CTTM_DATA_REG              <= DATAIN;
          when X"01C" => TRM_DATA_REG               <= DATAIN;
          when X"020" => TRD_DATA_REG               <= DATAIN;
          when X"02C" => PDL_SEL_REG                <= DATAIN;
          when X"038" => SPARE_CTTM_REG             <= DATAIN;
          when X"060" => LTM_LOCAL_TRG              <= DATAIN(0); 
          when X"064"   => DUMMY_REG                  <= DATAIN;
          when others      => null;
        end case;
      end if;
      -- ##################################
      -- Read Configuration Registers 
      -- ##################################
      if (RDEN = '1') then
        case ADDRESS is
          when X"000" => DATAOUT <= MODE_REG;
          when X"004" => DATAOUT <= TEST_CTRL_REG;                   
          when X"008" => DATAOUT <= TEST_STAT_REG;
          when X"010" => DATAOUT <= RAMDT(31 downto 0);
          when X"014" => DATAOUT <= X"0000" & RAMDT(47 downto 32);
          when X"024" => DATAOUT <= OR_DATA_REG(31 downto 0);
          when X"028" => DATAOUT <= OR_DATA_REG(63 downto 32);                  
          when X"030" => DATAOUT <= X"000000" & PDL_DELAY_REG;
          when X"034" => DATAOUT <= SCLK_CNT_REG;
          when X"038" => DATAOUT <= SPARE_CTTM_REG;
          when X"03C" => DATAOUT <= DPCLK_CNT_REG(0);
          when X"040" => DATAOUT <= DPCLK_CNT_REG(1);
          when X"044" => DATAOUT <= DPCLK_CNT_REG(2);
          when X"048" => DATAOUT <= DPCLK_CNT_REG(3);
          when X"04C" => DATAOUT <= DPCLK_CNT_REG(4);
          when X"050" => DATAOUT <= DPCLK_CNT_REG(5);
          when X"054" => DATAOUT <= DPCLK_CNT_REG(6);
          when X"058" => DATAOUT <= DPCLK_CNT_REG(7);
          when X"05C" => DATAOUT <= REVISION;
          when X"060" => DATAOUT <= X"0000000" & "000" & PULSE_TOGGLE;
          when X"064" => DATAOUT <= DUMMY_REG;
          when X"100" => DATAOUT <= X"00000000"; -- HACK
          when X"104" => DATAOUT <= X"00000000"; -- HACK
          when X"108" => DATAOUT <= X"00000000"; -- HACK
          when X"10C" => DATAOUT <= X"00000001"; -- HACK
          when X"110" => DATAOUT <= X"00000000"; -- HACK
          when X"114" => DATAOUT <= X"00000000"; -- HACK
          when X"118" => DATAOUT <= X"00000002"; -- HACK
          when X"11C" => DATAOUT <= X"00000000"; -- HACK
          when X"120" => DATAOUT <= X"00000000"; -- HACK
          when X"124" => DATAOUT <= X"00000003"; -- HACK
          when X"128" => DATAOUT <= X"00000000"; -- HACK
          when X"12C" => DATAOUT <= X"00000000"; -- HACK
          when X"130" => DATAOUT <= X"00000004"; -- HACK
          when X"134" => DATAOUT <= X"00000000"; -- HACK
          when X"138" => DATAOUT <= X"00000000"; -- HACK
          when X"13C" => DATAOUT <= X"00000005"; -- HACK
          when X"140" => DATAOUT <= X"00000000"; -- HACK
          when X"144" => DATAOUT <= X"00000000"; -- HACK
          when X"148" => DATAOUT <= X"00000006"; -- HACK
          when X"14C" => DATAOUT <= X"00000000"; -- HACK
          when X"150" => DATAOUT <= X"00000000"; -- HACK
          when X"154" => DATAOUT <= X"00000007"; -- HACK
          when X"158" => DATAOUT <= X"00000000"; -- HACK
          when X"15C" => DATAOUT <= X"00000000"; -- HACK
          when X"160" => DATAOUT <= X"00000008"; -- HACK
          when X"164" => DATAOUT <= X"00000000"; -- HACK
          when X"168" => DATAOUT <= X"00000000"; -- HACK
          when X"16C" => DATAOUT <= X"00000009"; -- HACK
          when X"170" => DATAOUT <= X"00000000"; -- HACK
          when X"174" => DATAOUT <= X"00000000"; -- HACK
          when X"178" => DATAOUT <= X"0000000A"; -- HACK
          when X"17C" => DATAOUT <= X"00000000"; -- HACK
          when X"180" => DATAOUT <= X"00000000"; -- HACK
          when X"184" => DATAOUT <= X"0000000B"; -- HACK
          when X"188" => DATAOUT <= X"00000000"; -- HACK
          when X"18C" => DATAOUT <= X"00000000"; -- HACK
          when X"190" => DATAOUT <= X"0000000C"; -- HACK
          when X"194" => DATAOUT <= X"00000000"; -- HACK
          when X"198" => DATAOUT <= X"00000000"; -- HACK
          when X"19C" => DATAOUT <= X"0000000D"; -- HACK
          when X"1A0" => DATAOUT <= X"00000000"; -- HACK
          when X"1A4" => DATAOUT <= X"00000000"; -- HACK
          when X"1A8" => DATAOUT <= X"0000000E"; -- HACK
          when X"1AC" => DATAOUT <= X"00000000"; -- HACK
          when X"1B0" => DATAOUT <= X"00000000"; -- HACK
          when X"1B4" => DATAOUT <= X"0000000F"; -- HACK
          when X"1B8" => DATAOUT <= X"0000000F"; -- HACK
          when X"1BC" => DATAOUT <= X"0000000F"; -- HACK
          when others      => DATAOUT <= X"00000000";
        end case;
      end if;
    end if;
  end process;

OR_UNDER_TEST <= OR_DEL(conv_integer(PDL_SEL_REG(5 downto 0)));

-- ********************************************************
-- LVDS (CTTM -> PDL) LOOP TEST
-- ********************************************************
process(nLBRES,CLK_TEST)
begin
  if (nLBRES = '0') then
    STATE1                      <= S0PDL;
    CTTM_TEST_DATA              <= (others => '0');
    PDL_DELAY_REG               <= (others => '0');
    DELAY_CNT                   <= (others => '0');
    TEST_STAT_REG(PDL_TEST_IDX) <= '0';
    PDL_TEST_START_S1           <= '0';
  elsif CLK_TEST'event and CLK_TEST = '1' then
    PDL_TEST_START_S1 <= PDL_TEST_START_S; 
    OR_UNDER_TEST_S   <= OR_UNDER_TEST;
    case STATE1 is
      -- Attende lo start del test
      -- e pilota i dati del cavo CTTM
      -- generando un fronte 0->1
      -- Il segnale torna a 0 solo
      -- quando si porta a 0 il segnale PDL_TEST_START
      when S0PDL =>
         DELAY_CNT      <= (others => '0');
         CTTM_TEST_DATA <= (others => '0');
         PDL_DELAY_REG <= (others => '0');
         TEST_STAT_REG(PDL_TEST_IDX) <= '0';
         if PDL_TEST_START_S1 = '1' then
           STATE1 <= S1PDL;
           TEST_STAT_REG(PDL_TEST_IDX) <= '1';
           CTTM_TEST_DATA <= (others => '1');
         end if;
      
      -- Campiona OR_DEL
      when S1PDL =>
         if OR_UNDER_TEST_S = '1' then
            STATE1 <= S2PDL;
            TEST_STAT_REG(PDL_TEST_IDX) <= '0';
         else
            DELAY_CNT <= DELAY_CNT + 1;
            STATE1 <= S1PDL;
         end if;
      
      -- Attende che venga tolto lo start
      when S2PDL =>
         if PDL_TEST_START_S1 = '0' then
            STATE1 <= S0PDL;
            CTTM_TEST_DATA <= (others => '0');
         end if;
         
         PDL_DELAY_REG <= DELAY_CNT;
      when others => null;
    end case;
  end if;
end process;

-- SCLK COUNTER
process(nLBRES,SCLK)
begin
  if (nLBRES = '0') then
    SCLK_CNT_REG  <= (others => '0');
    SCLK_ON       <= '0';
    TEST_STAT_REG(CLK_TEST_IDX) <= '0';
  elsif SCLK'event and SCLK = '1' then
     if CLK_TEST_START  = '1' then 
       TEST_STAT_REG(CLK_TEST_IDX) <= '1';
       if SCLK_ON = '0' then
         SCLK_CNT_REG <= (others => '0');
         SCLK_ON      <= '1';
       else
         SCLK_CNT_REG <= SCLK_CNT_REG + 1;
       end if; 
     else
       SCLK_ON      <= '0';
       TEST_STAT_REG(CLK_TEST_IDX) <= '0';
     end if;
  end if;
end process;


DPCLK_CNT : for i in 0 to 7 generate
  -- DPCLK COUNTER
  process(nLBRES,DPCLK(i))
  begin
    if (nLBRES = '0') then
      DPCLK_CNT_REG(i)  <= (others => '0');
      DPCLK_ON(i)       <= '0';
    elsif DPCLK(i)'event and DPCLK(i) = '1' then
       if CLK_TEST_START  = '1' then
         if DPCLK_ON(i) = '0' then
            DPCLK_CNT_REG(i) <= (others => '0');
            DPCLK_ON(i)      <= '1';
         else
            DPCLK_CNT_REG(i) <= DPCLK_CNT_REG(i) + 1;
         end if;
       else
         DPCLK_ON(i)       <= '0';
       end if;
    end if;
  end process;  
end generate;

TST      <= ( 0 => OR_UNDER_TEST,
              1 => MODE,
              2 => nLBAS,
              3 => WREN,
              4 => RDEN,
              5 => nLBRD,
              6 => DPCLK(0),
              7 => PDL_TEST_START);

END rtl;

