-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1392 - LTM Alice TOF
-- FPGA Proj. Name: V1390ltm
-- Device:          ACTEL APA600
-- Author:          Luca Colombini
-- Date:            04/08/05
-- --------------------------------------------------------------------------
-- Module:          V1392pkg
-- Description:     RTL module: Register MAP and bit field definitions
-- **************************************************************************

-- ##########################################################################
-- Revision History:
--    2 29Gen08  LCOL    Invertito il valore di default di PDL_PROG da 0 a 1:
--                       Le PDL partono in modalit� programmazione parallela.
--    5 05Giu08  LCOL    Aggiunto bit8 al registro di controllo: permette
--                       di innibire il sensing del SYSRES da backplane.
--                       E' stato fatto per poter tenere in reset l'ATMEGA16
--                       e contemporaneamente programmare la flash che 
--                       contiene il firmware della Cyclone.
--                       Se si verifica un problema e la flash viene 
--                       programmata con un bitstream corrotto, il firmware
--                       dell'ATMEGA16 pilota  periodicamente il pin nCONFIG
--                       della Cylone (comune con il reset del Tiny) fino
--                       a che non sente il CONF_DONE attivo: se il bitstream
--                       � corrotto, questa procedura va avantio all'infinito
--                       e la continua attivit� di rilettura della flash ne
--                       inibisce la riprogrammazione.
--   5 16Giu08  LCOL     Aggiunti tieout su accessi LBUS.
--                       Aggiunti PSM flags al registro di stato.
--   5 18Giu08  LCOL     Aggiunte costanti per Vme watchdog timeout.
--   6 09Apr09  LCOL     Rilassato l'accesso alla flash SPI per tenere conto
--                       della R295 su F_SO tra flash dout e APA pin che 
--                       rallenta notevolmente il fronte del segnale.
-- ##########################################################################

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


PACKAGE V1392pkg IS

-- **************************************************************************
-- REGISTERS ADRRESSES
-- **************************************************************************
constant A_OUTBUF     : integer := 16#0000#; -- D32 - R   - Output Buffer
constant A_CONTROL    : integer := 16#0004#; --       R/W - Control Reg   - clear
constant A_STATUS     : integer := 16#0006#; --       R   - Status Reg
--
constant A_LOAD_LUT   : integer := 16#000A#; --       W   - Load LUT
constant A_SW_CLEAR   : integer := 16#000C#; --       W   - SW Clear      - clear
constant A_SW_TRIGGER : integer := 16#000E#; --       W   - SW Trigger
constant A_EVNT_STOR  : integer := 16#0010#; --       R   - Event Stor
constant A_FIRM_REV   : integer := 16#0012#; --       R   - Firmware Rev
constant A_TESTREG    : integer := 16#0014#; -- D32   R/W - Test register
--
constant A_FLEN       : integer := 16#001C#; --       R/W - Flash Enable
constant A_FLASH      : integer := 16#001E#; --       R/W - Flash Memory
--
constant A_I2CCOM     : integer := 16#0022#; --       W   - I2C command
constant A_I2CDAT     : integer := 16#0024#; --       R   - I2C data
constant A_ACQUISITION: integer := 16#0026#; --       R/W - start acquisition
constant A_DUMMY32    : integer := 16#0028#; -- D32 - R/W - Dummy32 Reg
constant A_PDL_PROG   : integer := 16#002C#; --       R/W - PDL Program Data
constant A_PDL_DATA   : integer := 16#002E#; --       R   - PDL Data/Status
constant A_PDL_AE_L   : integer := 16#0030#; --       R/W - AE(15:0) (Low)
constant A_PDL_AE_M   : integer := 16#0032#; --       R/W - AE(31:16)(Medium)
constant A_PDL_AE_H   : integer := 16#0034#; --       R/W - AE(47:32)(High)
constant A_TEMPA      : integer := 16#0036#; --       R   - Temperature Readout (Chain A)
constant A_TEMPB      : integer := 16#0038#; --       R   - Temperature Readout (Chain B)
constant A_DSYNC      : integer := 16#003A#; --       R/W   - DAC Chip Selects
constant A_DDATA      : integer := 16#003C#; --       R/W   - DAC Data
constant A_LBSPDIR    : integer := 16#0040#; -- D32 - W     - LBSP port direction sel ('0' = OUT; '1' = IN)
constant A_LBSPCTRL   : integer := 16#0044#; -- D32 - R/W   - LOCAL BUS Spare signal Control 
constant A_SPULSE     : integer := 16#0048#; -- D32 - R     - SPULSE signals status
constant A_TRIGSTAT   : integer := 16#004C#; -- D16 - R     - STatus dei trigger su backplane

constant A_CLKSEL     : integer := 16#0050#; -- D16 - R/W   - CLOCK SELECTION 
constant A_CLKHIZ     : integer := 16#0052#; -- D16 - R/W   - CLOCK THREE-STATE CONTROL

constant A_CONFIG     : integer := 16#0056#; -- D16 - W     - Cyclone Reconfiguration
constant A_BNCRESN    : integer := 16#005C#; -- D32 - R/W   - Number of Bunch Reset before event readout
constant A_LEDCTRL    : integer := 16#0060#; -- D16 - R/W   - LED Control
constant A_ACLK_ACT   : integer := 16#0064#; -- D16 - R     - Aliclk pin acr�tivity
constant A_LOAD_ACT   : integer := 16#0068#; -- D16 - R     - Tiny reload (nCYC_RELOAD pin) activity
constant A_LB         : integer := 16#1000#; --       Local Bus Space Base Address
constant A_LBSIZ      : integer := 16#1000#; --
constant A_SRAM       : integer := 16#8000#; -- D16 - R     - LUT SRAM

constant LAST_ADDRESS : integer := 16#FFFC#;


-- REGISTERS SELECTION
constant S_OUTBUF     : integer := 0;
constant S_CONTROL    : integer := 1;
constant S_STATUS     : integer := 2;
constant S_LOAD_LUT   : integer := 3;
constant S_SW_CLEAR   : integer := 4;
constant S_SW_TRIGGER : integer := 5;
constant S_EVNT_STOR  : integer := 6;
constant S_FIRM_REV   : integer := 7;
constant S_TESTREG    : integer := 8;
constant S_FLEN       : integer := 9;
constant S_FLASH      : integer := 10;
constant S_I2CCOM     : integer := 11;
constant S_I2CDAT     : integer := 12;
constant S_DUMMY32    : integer := 13;
constant S_ACQUISITION: integer := 14;
constant S_SRAM       : integer := 15;
constant S_PDL_PROG   : integer := 16;
constant S_PDL_DATA   : integer := 17;
constant S_PDL_AE_L   : integer := 18;
constant S_PDL_AE_M   : integer := 19;
constant S_PDL_AE_H   : integer := 20;
constant S_TEMPA      : integer := 21;
constant S_TEMPB      : integer := 22;
constant S_DSYNC      : integer := 23;
constant S_DDATA      : integer := 24;
constant S_LBSPDIR    : integer := 25;
constant S_SPULSE     : integer := 26;
constant S_TRIGSTAT   : integer := 27;
constant S_LBSPCTRL   : integer := 28;
constant S_CLKSEL     : integer := 29;
constant S_CLKHIZ     : integer := 30;
constant S_BNCRESN    : integer := 31;
constant S_CONFIG     : integer := 32;
constant S_LEDCTRL    : integer := 33;
constant S_ACLK_ACT   : integer := 34;
constant S_LOAD_ACT   : integer := 35;
constant S_LB         : integer := 36;  -- Local Bus Access 


constant S_ANY        : integer := 37;  -- tutte le selezioni

constant S_REG16      : integer := 38;  -- tutti i registri D16
constant S_REG32      : integer := 39;  -- tutti i registri D32



-- **************************************************************************
-- REGISTER DEFAULT VALUES
-- **************************************************************************
constant D_OUTBUF     : std_logic_vector(31 downto 0) := "01110000000000000000000000000000"; --70000000


constant D_CONTROL    : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_STATUS     : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_EVNT_STOR  : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_FIRM_REV   : std_logic_vector(15 downto 0) := conv_std_logic_vector(16#0007#,16); 
constant D_TESTREG    : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
constant D_FLEN       : std_logic_vector( 0 downto 0) := "0"; 
constant D_FLASH      : std_logic_vector( 7 downto 0) := "00000000";
constant D_I2CCOM     : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_I2CDAT     : std_logic_vector(15 downto 0) := "0000000000000001";
constant D_PDL_PROG   : std_logic_vector(15 downto 0) := "0000000000000001";
constant D_PDL_DATA   : std_logic_vector(15 downto 0) := "0000000100000000";
constant D_PDL_AE_L   : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_PDL_AE_M   : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_PDL_AE_H   : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_TEMPA      : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_TEMPB      : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_DSYNC      : std_logic_vector(15 downto 0) := "1111111111111111";
constant D_DDATA      : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_LBSPDIR    : std_logic_vector(31 downto 0) := X"00000000"; 
constant D_SPULSE     : std_logic_vector(31 downto 0) := X"00000000"; 
constant D_TRIGSTAT   : std_logic_vector(15 downto 0) := X"0000";


constant D_LBSPCTRL   : std_logic_vector(31 downto 0) := X"00000002";
constant D_CLKSEL     : std_logic_vector(15 downto 0) := X"0100"; -- ALICLK drives SCLK by default
constant D_CLKHIZ     : std_logic_vector(15 downto 0) := X"0000";
constant D_BNCRESN    : std_logic_vector(31 downto 0) := X"00002710"; -- 10000 events
constant D_LEDCTRL    : std_logic_vector(15 downto 0) := X"0000"; 
constant D_ACLK_ACT   : std_logic_vector(15 downto 0) := X"0000";
constant D_LOAD_ACT   : std_logic_vector( 7 downto 0) := X"00"; 

constant D_CONFIG     : std_logic_vector( 0 downto 0) := "0"; 
constant D_DUMMY32    : std_logic_vector(31 downto 0) := "01010101010101010101010101010101"; --0x55555555
constant D_ACQUISITION: std_logic_vector( 0 downto 0) := "0";

-- **************************************************************************
-- REGISTER PACKING
-- **************************************************************************
subtype CONTROL    is std_logic_vector( 15 downto  0);   -- 16
subtype STATUS     is std_logic_vector( 31 downto 16);   -- 16

subtype EVNT_STOR  is std_logic_vector( 47 downto 32);   -- 16
subtype TESTREG    is std_logic_vector( 79 downto 48);   -- 32
subtype FLEN       is std_logic_vector( 80 downto 80);   -- 1
subtype FLASH      is std_logic_vector( 88 downto 81);   -- 8

subtype I2CCOM     is std_logic_vector(104 downto 89);  -- 16
subtype I2CDAT     is std_logic_vector(120 downto 105);  -- 16

subtype PDL_PROG   is std_logic_vector(136 downto 121);  -- 16
subtype PDL_DATA   is std_logic_vector(152 downto 137);  -- 16
subtype PDL_AE_L   is std_logic_vector(168 downto 153);  -- 16
subtype PDL_AE_M   is std_logic_vector(184 downto 169);  -- 16
subtype PDL_AE_H   is std_logic_vector(200 downto 185);  -- 16
subtype TEMPA      is std_logic_vector(216 downto 201);  -- 16
subtype TEMPB      is std_logic_vector(232 downto 217);  -- 16
subtype DSYNC      is std_logic_vector(248 downto 233);  -- 16
subtype DDATA      is std_logic_vector(264 downto 249);  -- 16

subtype LBSPDIR    is std_logic_vector(296 downto 265);  -- 32
subtype SPULSE     is std_logic_vector(328 downto 297);  -- 32
subtype TRIGSTAT   is std_logic_vector(344 downto 329);  -- 16

subtype LBSPCTRL   is std_logic_vector(376 downto 345);  -- 32
subtype CLKSEL     is std_logic_vector(392 downto 377);  -- 16
subtype CLKHIZ     is std_logic_vector(408 downto 393);  -- 16
subtype BNCRESN    is std_logic_vector(440 downto 409);  -- 32
subtype LEDCTRL    is std_logic_vector(456 downto 441);  -- 16
subtype ACLK_ACT   is std_logic_vector(472 downto 457);  -- 16
subtype LOAD_ACT   is std_logic_vector(480 downto 473);  -- 8

subtype CONFIG     is std_logic_vector(481 downto 481);  --  1

subtype DUMMY32    is std_logic_vector(513 downto 482);  -- 32

subtype ACQUISITION is std_logic_vector(514 downto 514); -- 1


-- Register Stream
subtype reg_stream is std_logic_vector(514 downto 0);


-- Debug Stream
subtype debug_stream is std_logic_vector(31 downto 0);

-- Display Stream (LEDs)
subtype display_stream is std_logic_vector(5 downto 0);


-- DICHIARAZIONE FUNZIONE PER LA MAJORITY DEI REGISTRI IN TRIPLICE COPIA
function majority (reg1: std_logic_vector;
                   reg2: std_logic_vector;
                   reg3: std_logic_vector;
                   length : integer) return std_logic_vector;


-- **************************************************************************
-- REGISTER BIT FIELD
-- **************************************************************************

-- CONTROL  
constant C_SM_SIDE         : integer :=  0+CONTROL'low;  -- 
constant C_TST_SRAM        : integer :=  4+CONTROL'low;  --  
constant C_TST_FIFO        : integer :=  5+CONTROL'low;  --  
constant C_SENS_TEMP       : integer :=  6+CONTROL'low;  --
constant C_SYSRES_INHIBIT  : integer :=  8+CONTROL'low;  --

-- STATUS
constant S_DATA_READY      : integer  :=  0+STATUS'low;  -- Data Ready in Output Buffer  
constant S_FULL            : integer  :=  1+STATUS'low;  -- Full flag
constant S_LOS             : integer  :=  2+STATUS'low;  -- LOS on ALICLK signal
constant S_LBUSTMO         : integer  :=  3+STATUS'low;  -- Local Bus Time Out
constant S_ORATETMO        : integer  :=  4+STATUS'low;  -- Timeout on Or Rates readout
constant S_PSM_CYC_STAT    : integer  :=  5+STATUS'low;  -- Cyclone configuration status (from Atmega16)
constant S_PSM_FAULT_STAT  : integer  :=  6+STATUS'low;  -- Fault status (from Atmega16)
constant S_PSM_STROBE_STAT : integer  :=  7+STATUS'low;  -- Strobe status (from Atmega16)
constant S_WDOGTIMEOUT     : integer  :=  8+STATUS'low;  -- VME watchdog timeout flag

-- I2C
constant I2C_RX       : integer :=  0+I2CCOM'low;
constant I2C_START    : integer :=  1+I2CCOM'low;
constant I2C_STOP     : integer :=  2+I2CCOM'low;

constant I2C_RDY      : integer :=  0+I2CDAT'low;
constant I2C_ACK      : integer :=  1+I2CDAT'low;

-- FLEN
constant FLENA_FCS     : integer :=  FLEN'low;

-- PDL
constant PDL_MODE     : integer :=  0+PDL_PROG'low;
constant PDL_SEL0     : integer :=  1+PDL_PROG'low;
constant PDL_SEL1     : integer :=  2+PDL_PROG'low;
constant PDL_SEL2     : integer :=  3+PDL_PROG'low;
constant PDL_SEL3     : integer :=  4+PDL_PROG'low;
constant PDL_SEL4     : integer :=  5+PDL_PROG'low;
constant PDL_SEL5     : integer :=  6+PDL_PROG'low;

-- PDL Programming Byte
constant PDL_P0       : integer :=  8+PDL_PROG'low;
constant PDL_P1       : integer :=  9+PDL_PROG'low;
constant PDL_P2       : integer :=  10+PDL_PROG'low;
constant PDL_P3       : integer :=  11+PDL_PROG'low;
constant PDL_P4       : integer :=  12+PDL_PROG'low;
constant PDL_P5       : integer :=  13+PDL_PROG'low;
constant PDL_P6       : integer :=  14+PDL_PROG'low;
constant PDL_P7       : integer :=  15+PDL_PROG'low;

constant PDL_VALID    : integer :=   8+PDL_DATA'low;

-- LOCAL BUS SPARES
constant LBSPCTRL0     : integer :=   0+LBSPCTRL'low;
constant LBSPCTRL1     : integer :=   1+LBSPCTRL'low;
constant LBSPCTRL2     : integer :=   2+LBSPCTRL'low;
constant LBSPCTRL3     : integer :=   3+LBSPCTRL'low;
constant LBSPCTRL4     : integer :=   4+LBSPCTRL'low;
constant LBSPCTRL5     : integer :=   5+LBSPCTRL'low;
constant LBSPCTRL6     : integer :=   6+LBSPCTRL'low;
constant LBSPCTRL7     : integer :=   7+LBSPCTRL'low;

-- LED CONTROL
constant LEDCTRL_FORCE : integer :=   15+LEDCTRL'low;


-- CLOCK SEL
constant CLK_SOURCE   : integer :=   8+CLKSEL'low;

-- CONFIG
constant CFG_IMAGE_SELECT : integer := 0+CONFIG'low; -- Firmware Image to load
                                                     -- after tiny reset


-- **************************************************************************
-- formato dei dati
-- **************************************************************************
constant PDL_SERIAL_MODE   : std_logic := '0';
constant PDL_PARALLEL_MODE : std_logic := '1';

constant G_HEAD     : std_logic_vector (3 downto 0) := "0100";
constant G_TRAIL    : std_logic_vector (3 downto 0) := "0101";

constant FILLER     : std_logic_vector (1 downto 0) := "00";
constant ZEROS       : std_logic_vector(7 downto 0) := (others => '0');

-- **************************************************************************
-- TIMEOUT
-- **************************************************************************
constant WDOGTMOVAL   : std_logic_vector(5 downto 0) := "111111"; 
constant WDOGTMORES   : std_logic_vector(5 downto 0) := "001110"; 
constant LBUSTMOVAL   : std_logic_vector(4 downto 0) := "11111"; 
constant ORATETMOVAL  : std_logic_vector(4 downto 0) := "11111"; 

-- **************************************************************************
-- I2C ADC
-- **************************************************************************
constant AD7416_ID    : std_logic_vector(3 downto 0) := "1001"; -- Target chip I2C ID
constant AD7417_ID    : std_logic_vector(3 downto 0) := "0101"; -- Target chip I2C ID
constant AD7418_ID    : std_logic_vector(3 downto 0) := "0101"; -- Target chip I2C ID

constant CHIP_ID    : std_logic_vector(3 downto 0) := AD7417_ID; -- Target chip I2C ID

-- **************************************************************************
-- PULSE SIGNALS (impulso di 1 ciclo di clk in corrispondenza di un accesso in
--                ad un particolare indirizzo)
-- **************************************************************************
constant LOAD_LUT   : integer := 0;
constant SW_CLEAR   : integer := 1;
constant SW_TRIGGER : integer := 2;
constant WP_FIFO    : integer := 3;
constant WP_MICRO   : integer := 4;
constant RP_MICRO   : integer := 5;
constant WP_SPI     : integer := 6;
constant WP_I2C     : integer := 7;
constant WP_PDL     : integer := 8;
constant WP_DAC     : integer := 9;
constant WP_CONFIG  : integer := 10;


subtype reg_pulse is std_logic_vector(WP_CONFIG downto 0);



-- ***************************************************************************************
-- TICK (segnali per dare la cadenza con varie temporizzazioni)
-- ***************************************************************************************
constant T64   : integer := 0;  -- Periodo=Tclk*64  (circa 1.6us a 40MHz)
constant T16K  : integer := 1;  -- Periodo=Tclk*16K (circa 410us a 40MHz)
constant T4M   : integer := 2;  -- Periodo=Tclk*4M  (circa 104ms a 40MHz)
constant T64M  : integer := 3;  -- Periodo=Tclk*4M  (circa 1.6 s a 40MHz)
subtype tick_pulses is std_logic_vector(T64M downto 0);

-- **************************************************************************
-- package VME_PACK
-- **************************************************************************
-- bus a 6 bit per gli address modifier
subtype U6 is std_logic_vector (5 downto 0);

-- address modifier riconosciuti
constant   A32_U_DATA  : U6 := "001001";  -- 09  A32 non privileged data access
constant   A32_U_PROG  : U6 := "001010";  -- 0A  A32 non privileged program access
constant   A32_S_DATA  : U6 := "001101";  -- 0D  A32 supervisory data access
constant   A32_S_PROG  : U6 := "001110";  -- 0E  A32 supervisory program access

constant   A32_U_BLT   : U6 := "001011";  -- 0B  A32 non privileged block transfer (BLT)
constant   A32_S_BLT   : U6 := "001111";  -- 0F  A32 supervisory block transfer (BLT)

constant   A32_U_MBLT  : U6 := "001000";  -- 08  A32 non privileged 64 bit block transfer (MBLT)
constant   A32_S_MBLT  : U6 := "001100";  -- 0C  A32 supervisory 64 bit block transfer (MBLT)

constant   CR_CSR      : U6 := "101111";  -- 2F  geographical address

-- address modifier non riconosciuti
constant   A24_U_DATA  : U6 := "111001";  -- 39  A24 non privileged data access
constant   A24_U_PROG  : U6 := "111010";  -- 3A  A24 non privileged program access
constant   A24_S_DATA  : U6 := "111101";  -- 3D  A24 supervisory data access
constant   A24_S_PROG  : U6 := "111110";  -- 3E  A24 supervisory program access

constant   A24_U_BLT   : U6 := "111011";  -- 3B  A24 non privileged block transfer (BLT)
constant   A24_S_BLT   : U6 := "111111";  -- 3F  A24 supervisory block transfer (BLT)

constant   A24_U_MBLT  : U6 := "111000";  -- 38  A24 non privileged 64 bit block transfer (MBLT)
constant   A24_S_MBLT  : U6 := "111100";  -- 3C  A24 supervisory 64 bit block transfer (MBLT)


subtype REG16 is std_logic_vector (15 downto 0);
subtype REG32 is std_logic_vector (31 downto 0);


END V1392pkg;


PACKAGE BODY V1392pkg is

  -- ************************************************************************
  -- FUNZIONE PER LA MAJORITY DEI REGISTRI IN TRIPLICE COPIA
  function majority (reg1: std_logic_vector;
                     reg2: std_logic_vector;
                     reg3: std_logic_vector;
                     length : integer) return std_logic_vector is
  variable reg : std_logic_vector((length-1) downto 0);
  begin
    for i in 0 to length-1 loop

      if (std_logic_vector'(reg1(i) & reg2(i)) = "00") then
        reg(i):= '0';
      elsif (std_logic_vector'(reg1(i) & reg2(i)) = "11") then
        reg(i):= '1';
      else
        reg(i):= reg3(i);
      end if;

    end loop;

    return reg;

  end majority;

END V1392pkg;

