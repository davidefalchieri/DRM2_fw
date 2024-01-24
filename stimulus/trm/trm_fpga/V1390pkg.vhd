-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA750
-- Author:          Annalisa Mati
-- Date:            21/06/13
-- --------------------------------------------------------------------------
-- Module:          V1390pkg
-- Description:     RTL module: Register MAP and bit field definitions
-- **************************************************************************

-- ##########################################################################
-- Revision History:
-- 30.05: Release rilasciata
-- 00.00: - tolto il registro SRAM EVENT (addr 0x100; era stato inserito per
--          debug)
--        - aggiunto il registro BNCID OFFSET (addr 0x2000)
--          per l'inizializzazione del BNC ID
--        - cambiato il valore di default del CONTROL (da 0x08 a 0x0B)
--        - aggiunto il registro TEST TOKEN TIMOUT
-- 00.01  - aggiunta rilettura automatica dei sensori di temperatura
-- NUOVA RELEASE 2013:
-- eliminati i registri per gli OFFSET per la sottrazione TRAILING-LEADING-OFFSET
-- eliminato lo stream di bit per i registri (sostituito con un record)
-- ##########################################################################
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


PACKAGE V1390pkg IS


-- **************************************************************************
-- REGISTERS ADRRESSES: sono gli stessi del V1290
-- **************************************************************************
constant A_OUTBUF     : integer := 16#0000#; -- D32 - R   - Output Buffer
constant A_CONTROL    : integer := 16#0004#; --       R/W - Control Reg   - clear
constant A_STATUS     : integer := 16#0006#; --       R   - Status Reg
constant A_GEO_AD     : integer := 16#0008#; --       R   - Geo Address
constant A_LOAD_LUT   : integer := 16#000A#; --       W   - Load LUT
constant A_SW_CLEAR   : integer := 16#000C#; --       W   - SW Clear      - clear
constant A_SW_TRIGGER : integer := 16#000E#; --       W   - SW Trigger
constant A_EVNT_STOR  : integer := 16#0010#; --       R   - Event Stor
constant A_FIRM_REV   : integer := 16#0012#; --       R   - Firmware Rev
constant A_TESTREG    : integer := 16#0014#; -- D32   R/W - Test register
constant A_MICRO      : integer := 16#0018#; --       R/W - Micro
constant A_PROGHS     : integer := 16#001A#; --       R   - Micro HS
constant A_FLEN       : integer := 16#001C#; --       R/W - Flash Enable
constant A_FLASH      : integer := 16#001E#; --       R/W - Flash Memory
constant A_SRAM_PAGE  : integer := 16#0020#; --       R/W - Sram Page
constant A_I2CCOM     : integer := 16#0022#; --       W   - I2C command
constant A_I2CDAT     : integer := 16#0024#; --       R   - I2C data
constant A_ACQUISITION: integer := 16#0026#; --       R/W - start acquisition
constant A_DUMMY32    : integer := 16#0028#; -- D32 - R/W - Dummy32 Reg
constant A_BNCID_OFF  : integer := 16#002C#; --       R/W - Bunch ID offset
constant A_TST_TIMOUT : integer := 16#002E#; --       W   - token timout test
constant A_TEMPA      : integer := 16#0036#; --       R   - Temperature Readout (Chain A)
constant A_TEMPB      : integer := 16#0038#; --       R   - Temperature Readout (Chain A)
constant A_SRAM       : integer := 16#8000#; --       R   - LUT SRAM

constant LAST_ADDRESS : integer := 16#FFFC#;


-- REGISTERS SELECTION
constant S_OUTBUF     : integer := 0;
constant S_CONTROL    : integer := 1;
constant S_STATUS     : integer := 2;
constant S_GEO_AD     : integer := 3;
constant S_LOAD_LUT   : integer := 4;
constant S_SW_CLEAR   : integer := 5;
constant S_SW_TRIGGER : integer := 6;
constant S_EVNT_STOR  : integer := 7;
constant S_FIRM_REV   : integer := 8;
constant S_TESTREG    : integer := 9;
constant S_MICRO      : integer := 10;
constant S_PROGHS     : integer := 11;
constant S_FLEN       : integer := 12;
constant S_FLASH      : integer := 13;
constant S_SRAM_PAGE  : integer := 14;
constant S_I2CCOM     : integer := 15;
constant S_I2CDAT     : integer := 16;
constant S_DUMMY32    : integer := 17;
constant S_ACQUISITION: integer := 18;
constant S_SRAM       : integer := 19;
constant S_ANY        : integer := 20;  -- tutte le selezioni
constant S_REG16      : integer := 21;  -- tutti i registri D16
constant S_REG32      : integer := 22;  -- tutti i registri D32
constant S_BNCID_OFF  : integer := 23;
constant S_TST_TIMOUT : integer := 24;
constant S_TEMPA      : integer := 25;
constant S_TEMPB      : integer := 26;


-- **************************************************************************
-- REGISTER DEFAULT VALUES
-- **************************************************************************
constant D_OUTBUF     : std_logic_vector(31 downto 0) := "01110000000000000000000000000000"; --70000000
constant D_CONTROL    : std_logic_vector( 7 downto 0) := "00001011";
constant D_STATUS     : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_EVNT_STOR  : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_FIRM_REV   : std_logic_vector(15 downto 0) := conv_std_logic_vector(16#268D#,16);
constant D_TESTREG    : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
constant D_PROGHS     : std_logic_vector( 1 downto 0) := "01";
constant D_FLEN       : std_logic_vector( 0 downto 0) := "1";
constant D_FLASH      : std_logic_vector( 7 downto 0) := "00000000";
constant D_SRAM_PAGE  : std_logic_vector( 9 downto 0) := "0000000000";
constant D_I2CCOM     : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_I2CDAT     : std_logic_vector(15 downto 0) := "0000000000000001";
constant D_DUMMY32    : std_logic_vector(31 downto 0) := "10101010101010101010101010101010"; --0xAAAAAAAA
constant D_ACQUISITION: std_logic_vector( 0 downto 0) := "0";
constant D_BNCID_OFF  : std_logic_vector(11 downto 0) := "000000000000";
constant D_TEMPA      : std_logic_vector(15 downto 0) := "0000000000000000";
constant D_TEMPB      : std_logic_vector(15 downto 0) := "0000000000000000";


-- **************************************************************************
-- DICHIARAZIONE FUNZIONE PER LA MAJORITY DEI REGISTRI IN TRIPLICE COPIA
-- **************************************************************************
function majority (reg1: std_logic_vector;
                   reg2: std_logic_vector;
                   reg3: std_logic_vector;
                   length : integer) return std_logic_vector;


-- **************************************************************************
-- REGISTER BIT FIELD
-- **************************************************************************
-- CONTROL
constant C_COMP         : integer :=  0;  --
constant C_TRG_EN0      : integer :=  1;  -- \ uso dei Trigger
constant C_TRG_EN1      : integer :=  2;  -- /
constant C_CH_EMPTY_DIS : integer :=  3;  

constant C_TST_FIFO     : integer :=  4;  --
constant C_TST_SRAM     : integer :=  5;  --

constant C_TEMP_CHAIN   : integer :=  6;  -- seleziona la catena I2C (AIR disabilitato)
constant C_AIR_ENA      : integer :=  7;  -- abilita Automatic readout I2C (AIR)

-- TRG_EN(1:0)
-- 00(def) -> L0,L1,L2R disab. L2A= HPTDC(trigger e rilettura) + FIFO (come V1290)
-- 01      -> L0,L1R disab.    L1A= HPTDC(trigger e rilettura) + SRAM, L2A/L2R(rej)= FIFO
-- 10      -> L0= HPTDC (trigger), L1A/L1R(rej)= HPTDC(rilettura) + SRAM, L2A/L2R(rej)= FIFO

-- CASO 0: L2A è inviato come trigger agli HPTDC: i dati degli HPTDC vengono riletti e scritti
-- direttamente nella FIFO (come nel V1290)
-- CASO 1: L1A è inviato come trigger agli HPTDC: i dati degli HPTDC vengono riletti e scritti
-- nelle SRAM di primo livello. All'arrivo di L2A o L2R i dati vengono scritti nella FIFO o
-- cancellati
-- CASO 2: L0 è inviato come trigger agli HPTDC; con L1A/L1R i dati degli HPTDC vengono riletti
-- nel caso di L1A vengono scritti nelle SRAM di primo livello e si procede come il CASO 1,
-- nel caso di L1R vengono cancellati.

-- STATUS
constant S_DATA_READY    : integer :=  0;
constant S_FULL          : integer :=  1;
constant S_ACQ           : integer :=  2;
constant S_TRG_MATCH     : integer :=  3;

constant S_CHAINA_EN     : integer :=  4;
constant S_CHAINB_EN     : integer :=  5;
constant S_CHAINA_BP     : integer :=  6;
constant S_CHAINB_BP     : integer :=  7;

constant S_RAW_DATA      : integer :=  8;
constant S_LUT           : integer :=  9;
constant S_CHAIN_ERR_DIS : integer := 10;
constant S_PWON          : integer := 11;

constant S_LEADING       : integer := 12;
constant S_TRAILING      : integer := 13;

constant S_RES0          : integer := 14;
constant S_RES1          : integer := 15;


-- I2C
constant I2C_RX       : integer :=  0;
constant I2C_START    : integer :=  1;
constant I2C_STOP     : integer :=  2;

constant I2C_RDY      : integer :=  0;
constant I2C_ACK      : integer :=  1;

constant AD7416_ID    : std_logic_vector(3 downto 0) := "1001"; -- Target chip I2C ID
constant CHIP_ID      : std_logic_vector(3 downto 0) := AD7416_ID;

-- FLEN
constant FLEN_FCS     : integer :=  0;


-- BIT del registro di handshake  micro <-> vme (PROGHS)
constant MICRO_WOK    : integer :=  0;
constant MICRO_ROK    : integer :=  1;

-- BIT del "registro" di TEST TOKEN TIMOUT
constant T_TIMOUTA    : integer := 0;
constant T_TIMOUTB    : integer := 1;


-- **************************************************************************
-- formato dei dati
-- **************************************************************************
constant G_HEAD     : std_logic_vector (3 downto 0) := "0100";
constant G_TRAIL    : std_logic_vector (3 downto 0) := "0101";

constant HEAD_A     : std_logic_vector (3 downto 0) := "0000";
constant TRAIL_A    : std_logic_vector (3 downto 0) := "0001";
constant HEAD_B     : std_logic_vector (3 downto 0) := "0010";
constant TRAIL_B    : std_logic_vector (3 downto 0) := "0011";

constant TDC_ERR    : std_logic_vector (3 downto 0) := "0110";
constant G_ERR      : std_logic_vector (7 downto 0) := "0110" & "1111";
constant FILLER     : std_logic_vector (3 downto 0) := "0111";

-- parola di stato da scrivere nei Trailer di catena
constant STAT_OK     : std_logic_vector(3 downto 0) := "0000";
constant STAT_ERR    : std_logic_vector(3 downto 0) := "0010";
constant STAT_TIMOUT : std_logic_vector(3 downto 0) := "0001";

-- parola di stato da scrivere nei DATI
constant PACK_OK     : std_logic_vector(1 downto 0) := "00";
constant TRAIL_MISS  : std_logic_vector(1 downto 0) := "01";
constant LEAD_MISS   : std_logic_vector(1 downto 0) := "10";
constant WIDTH_OF    : std_logic_vector(1 downto 0) := "11";

constant ZEROS       : std_logic_vector(7 downto 0) := (others => '0');


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
constant M_TIMOUTA  : integer := 8;
constant M_TIMOUTB  : integer := 9;

subtype reg_pulse is std_logic_vector(M_TIMOUTB downto 0);


-- ***************************************************************************************
-- TICK (segnali per dare la cadenza con varie temporizzazioni)
-- ***************************************************************************************
constant T64   : integer := 0;  -- Periodo=Tclk*64  (circa 1.6us a 40MHz)
constant T16K  : integer := 1;  -- Periodo=Tclk*16K (circa 410us a 40MHz)
constant T4M   : integer := 2;  -- Periodo=Tclk*4M  (circa 104ms a 40MHz)
constant T64M  : integer := 3;  -- Periodo=Tclk*64M (circa 1.6s  a 40MHz)

subtype tick_pulses is std_logic_vector(T64M downto 0);


type VME_REG_RECORD is record  	
  CONTROL    : std_logic_vector( 7 downto 0);  -- 8 (lascio il posto per altri bit)
  STATUS     : std_logic_vector(15 downto 0);  -- 16
  EVNT_STOR  : std_logic_vector(15 downto 0);  -- 16
  TESTREG    : std_logic_vector(31 downto 0);  -- 32
  PROGHS     : std_logic_vector( 1 downto 0);  -- 2
  FLEN       : std_logic_vector( 0 downto 0);  -- 1
  FLASH      : std_logic_vector( 7 downto 0);  -- 8
  SRAM_PAGE  : std_logic_vector( 9 downto 0);  -- 10
  I2CCOM     : std_logic_vector(15 downto 0);  -- 16
  I2CDAT     : std_logic_vector(15 downto 0);  -- 16
  DUMMY32    : std_logic_vector(31 downto 0);  -- 32
  ACQUISITION: std_logic_vector( 0 downto 0);  -- 1
  BNCID_OFF  : std_logic_vector(11 downto 0);  -- 12
  TEMPA      : std_logic_vector(15 downto 0);  -- 16
  TEMPB      : std_logic_vector(15 downto 0);  -- 16
end record;


-- **************************************************************************
-- package VME_PACK
-- **************************************************************************
-- bus a 6 bit per gli address modifier
subtype U6 is std_logic_vector (5 downto 0);

  -- data size
  constant D8          : integer := 1;
  constant D16         : integer := 2;
  constant D32         : integer := 4;
  constant D64         : integer := 8;
  
  constant BTYPE_2eVME : integer := 1;
  constant BTYPE_2eSST : integer := 2;

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

constant   A32_2eSST   : U6 := "100000";  -- 20  6U 2eSST ALICE transfert A32/D64

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


END V1390pkg;


PACKAGE BODY V1390pkg is

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

END V1390pkg;

