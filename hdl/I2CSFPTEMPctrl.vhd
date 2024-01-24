----------------------------------------------------------------------
-- Created by SmartDesign Tue Apr 28 21:28:23 2015
-- Version:
--      1.20180130.2300: Blocco con errore attivo 
--      1.20180125.1700: Aggiunto registro SFPvolt, spostato DebugTest in AUX_CTRL 
--      1.20180119.1026: Correzioni
--      1.20180118.1448: Modificati REFRESHDONE, aggiunto timing I2C SFPTEMP 
--      1.20180111.1210: Nuovo codice errori
--      1.20171122.1139: Blocco e errore TimeOut
--      1.20171121.1311: Modifiche varie su errore, timeout e generazione errore
--      1.20170518.1720: Error generator debug register I2C   
--      1.20170517.1404: Error generator debug register   
--      1.20170404.1540: Aggiunto reset in lista variabili
--      1.20170222.1606: Modifiche varie 22 febbraio
--      1.20170210.1139: Modifiche RefreshDone,
--      1.20170126.1744: Correzione Diag Test, OK
--      1.20170126.1444: Correzione Diag Test
--      1.20170125.1805: Correzione per scrittura ram da due processi diversi
--      1.20170125.1305: Finito modulo
--      1.20170113.1443: Correzioni varie
--      1.20170112.1128: Changes on registers
--      1.20170110.1609: Debug
--      1.20161228.1154: Aggiunti vari elementi
--      1.20161223.2027: Modifiche accesso esterno
--      1.20161222.2345: Inserito accesso esterno
--      1.20161220.2359: Inserito accesso esterno
--      1.20161220.1726: Correzione errori e aggiunta RAM I/O (RIO...) signals
--      1.20161220.1613: Aggiunti sensori di temperatura
--      1.20161217.2232: Prima versione senza errori
--      1.20161215.1101: Startup
----------------------------------------------------------------------
----------------------------------------------------------------------
-- Transfert:
-- x"00" -> 00:15   Vendor Name   0xA0   @20-x"14"   16-x"10"   n
-- x"10" -> 16:31   Vendor PN     0xA0   @40-x"28"   16-x"10"   n
-- x"20" -> 32:47   Vendor SN     0xA0   @68-x"44"   16-x"10"   n
-- x"30" -> 48:55   Date Code     0xA0   @84-x"54"    8-x"08"   n
-- x"38" -> 56:65   Diag          0XA2   @96-x"60"   10-x"0A"   n
-- x"42" -> 66:75   Diag mean     0x00   -           -          n
-- Other registers:
-- x"4C" -> 76      Status  I2C
-- x"4D" -> 77      Status SFP
-- Checksum:
-- x"00" -> 00:63   Test CRC      0xA0   @00-x"00"   63-x"40"   y
-- x"40" -> 64:95   Test CRC      0xA0   @64         31-x"1F"   y
-- Temp read
-- x"50" -> 80      TempGBT_0     0x90   @00-x"00"    1-x"01"   n
-- x"51" -> 81      TempLDOGBT_1  0x91   @00-x"00"    1-x"01"   n
-- x"52" -> 82      TempLDOSDES_2 0x92   @00-x"00"    1-x"01"   n
-- x"53" -> 83      TempPXL_3     0x93   @00-x"00"    1-x"01"   n
-- x"54" -> 84      TempLDOFPGA_4 0x94   @00-x"00"    1-x"01"   n
-- x"55" -> 85      TempIGLOO2_5  0x95   @00-x"00"    1-x"01"   n
-- x"56" -> 86      TempVTRX_6    0x96   @00-x"00"    1-x"01"   n
----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 use IEEE.std_logic_arith.all;
 use std.textio.all;
 use ieee.numeric_std.all;
-- use ieee.std_logic_textio.all;

library smartfusion2;
 use smartfusion2.all;
----------------------------------------------------------------------
-- I2C_GBTX_tb entity declaration
----------------------------------------------------------------------
entity I2CSFPTEMPctrl is
	-- Port list
	port(
------- Standard interface --------------------------------------
		DO      : out std_logic_vector(7 downto 0);
		DI      : in  std_logic_vector(7 downto 0);
		ADD     : in  std_logic_vector(3 downto 0);
		WR      : in  std_logic;
		EN      : in  std_logic;
------- RAM interface from I2C ----------------------------------
		RAMdataWR : out std_logic_vector(7 downto 0);
		RAMdataRD : in  std_logic_vector(7 downto 0);
		RAMaddrWR : out  std_logic_vector(6 downto 0);
		RAMaddrRD : out  std_logic_vector(6 downto 0);
		RAMwrite  : out  std_logic;
--      RAMread   : out  std_logic;
------- RAM interface from I/O ----------------------------------
		RIOdataRD : in  std_logic_vector(7 downto 0);
		RIOaddrRD : out  std_logic_vector(6 downto 0);
------- I2C interface -------------------------------------------
		FiEMPTY     : in  std_logic;
		I2CERR      : in  std_logic;
		FiFULL      : in  std_logic;
		FiAEMPTY    : in  std_logic;
		FiAFULL     : in  std_logic;
		FoAEMPTY    : in  std_logic;
		FoAFULL     : in  std_logic;
		FoEMPTY     : in  std_logic;
		FoFULL      : in  std_logic;
		I2CBSY      : in  std_logic;
		FoDATA      : in  std_logic_vector(7 downto 0);
		FoERRM      : in  std_logic_vector(7 downto 0);
		SDAin       : in  std_logic;
		SCLin       : in  std_logic;
-----------------------------------------------------------------
        DebugErr    : in   std_logic_vector(3 downto 0);
        DebugErrEn  : in   std_logic;
-----------------------------------------------------------------
		FiDATA      : out std_logic_vector(7 downto 0);
		FiWE        : out std_logic;
		FoRE        : out std_logic;
		I2CRUN      : out std_logic;
        RDCOUNT     : out std_logic_vector(7 downto 0);
-----------------------------------------------------------------
        I2CLOOPtime : out std_logic;
        TimeOutFlag : out std_logic;
		P1mS        : in  std_logic;
		READY       : in  std_logic;
		RESETn      : in  std_logic;
		RESETOUTn   : out std_logic;
		CLK         : in  std_logic
		);
end I2CSFPTEMPctrl;
----------------------------------------------------------------------
architecture I2CSFPTEMPctrl_beh of I2CSFPTEMPctrl is
----------------------------------------------------------------------
constant CLK_PERIOD : time := 100 ns;

signal STARTUP  : std_logic;

signal DRMI2Cdata        : std_logic_vector(7 downto 0);
signal SFPI2Cadd         : std_logic_vector(7 downto 0);
signal SFPI2CID          : std_logic_vector(7 downto 0);
signal SFPI2CRegBase     : std_logic_vector(7 downto 0);
signal SFPI2CRegCnt      : std_logic_vector(7 downto 0);
signal DRMRAMptr         : std_logic_vector(6 downto 0) := "0000000";
signal DRMRAMcnt         : std_logic_vector(6 downto 0) := "0000000";
signal DRMI2Ccnt         : std_logic_vector(7 downto 0) := "00000000";
signal SFPI2Ccrc         : std_logic_vector(7 downto 0);
signal DRMI2Cactive      : std_logic;
signal DRMI2Cenab        : std_logic;
signal DRMI2CenabOK      : std_logic;
signal SFPDiagTestEnab   : std_logic;
signal SFPDiagTestEnabOK : std_logic;
signal DRMI2Cerr         : std_logic_vector(7 downto 0);
signal DRMI2CerrOK       : std_logic;

--gnal	RAMdataWRi : std_logic_vector(7 downto 0);
signal	RAMaddrWRi : std_logic_vector(6 downto 0);
signal	RAMaddrRDi : std_logic_vector(6 downto 0);
signal	RAMwrite_i : std_logic;
signal	RAMdataWRd : std_logic_vector(7 downto 0);
signal	RAMaddrWRd : std_logic_vector(6 downto 0);
signal	RAMaddrRDd : std_logic_vector(6 downto 0);
signal	RAMwrite_d : std_logic;

-- I2C handler mode control
signal SFPI2Cmode       : std_logic_vector(1 downto 0);
-- Action to perform in I2C handler;
constant cI2CmodeToRAM  : std_logic_vector(1 downto 0) := "01";
constant cI2CmodeCkSum  : std_logic_vector(1 downto 0) := "00";
constant cI2CmodeData   : std_logic_vector(1 downto 0) := "10";

signal clrDRMI2Cerror : std_logic;
signal clrI2Cerror    : std_logic;

signal RefreshDone    : std_logic;
signal RefreshDoneRST : std_logic;
signal RefreshDoneSET : std_logic;

signal TIMEOUTerror   : std_logic;
signal TIMEOUT_SDA    : std_logic;
signal TIMEOUT_SCL    : std_logic;

-- Error messages: sfp status

-- Address space in SFP memory 
-------- Name -------------------------------------------- Mem address      (hex/dec) - Size
constant maSFPVendorName : std_logic_vector(6 downto 0) := "0000000"; --<-- x"00"-d00    16
constant maSFPVendorPN   : std_logic_vector(6 downto 0) := "0010000"; --<-- x"10"-d16    16
constant maSFPVendorSN   : std_logic_vector(6 downto 0) := "0100000"; --<-- x"20"-d32    16
constant maSFPProdDate   : std_logic_vector(6 downto 0) := "0110000"; --<-- x"30"-d48    8
constant maSFPdiagData   : std_logic_vector(6 downto 0) := "0111000"; --<-- x"38"-d56    10
constant maSFPdiagTEMPH  : std_logic_vector(6 downto 0) := "0111000"; --<-- x"38"-d56    X
constant maSFPdiagTEMPL  : std_logic_vector(6 downto 0) := "0111001"; --<-- x"39"-d57    X
constant maSFPdiagVOLTH  : std_logic_vector(6 downto 0) := "0111010"; --<-- x"3A"-d58    X
constant maSFPdiagVOLTL  : std_logic_vector(6 downto 0) := "0111011"; --<-- x"3B"-d59    X
constant maSFPdiagBIASH  : std_logic_vector(6 downto 0) := "0111100"; --<-- x"3C"-d60    X
constant maSFPdiagBIASL  : std_logic_vector(6 downto 0) := "0111101"; --<-- x"3D"-d61    X
constant maSFPdiagTXPWH  : std_logic_vector(6 downto 0) := "0111110"; --<-- x"3E"-d62    X
constant maSFPdiagTXPWL  : std_logic_vector(6 downto 0) := "0111111"; --<-- x"3F"-d63    X
constant maSFPdiagRXPWH  : std_logic_vector(6 downto 0) := "1000000"; --<-- x"40"-d64    X
constant maSFPdiagRXPWL  : std_logic_vector(6 downto 0) := "1000001"; --<-- x"41"-d65    X
constant maSFPdiagLast   : std_logic_vector(6 downto 0) := "1000010"; --<-- x"42"-d66    10
constant maDRMI2Cerror   : std_logic_vector(6 downto 0) := "1001100"; --<-- x"4C"-d76    1
constant maDebugTest     : std_logic_vector(6 downto 0) := "1001101"; --<-- x"4D"-d77    1
--nstant ...             : std_logic_vector(6 downto 0) := "1001110"; --<-- x"4E"-d78    1
--nstant ...             : std_logic_vector(6 downto 0) := "1001111"; --<-- x"4F"-d79    1
constant maTempGBT_0     : std_logic_vector(6 downto 0) := "1010000"; --<-- x"50"-d80    1
constant maTempLDOGBT_1  : std_logic_vector(6 downto 0) := "1010001"; --<-- x"51"-d81    1
constant maTempLDOSDES_2 : std_logic_vector(6 downto 0) := "1010010"; --<-- x"52"-d82    1
constant maTempPXL_3     : std_logic_vector(6 downto 0) := "1010011"; --<-- x"53"-d83    1
constant maTempLDOFPGA_4 : std_logic_vector(6 downto 0) := "1010100"; --<-- x"54"-d84    1
constant maTempIGLOO2_5  : std_logic_vector(6 downto 0) := "1010101"; --<-- x"55"-d85    1
constant maTempVTRX_6    : std_logic_vector(6 downto 0) := "1010110"; --<-- x"56"-d86    1
--nstant ...             : std_logic_vector(6 downto 0) := "1010111"; --<-- x"57"-d87    1

-- Address space in IGLOO memory
-------- Name ----------------------------------------- Mem address (hex/dec) - Size - Page
constant regSFPVendorName : std_logic_vector(7 downto 0) := x"14"; --<-- d00     16     0
constant regSFPVendorPN   : std_logic_vector(7 downto 0) := x"28"; --<-- d16     16     0
constant regSFPVendorSN   : std_logic_vector(7 downto 0) := x"44"; --<-- d32     16     0
constant regSFPProdDate   : std_logic_vector(7 downto 0) := x"54"; --<-- d48     8      0
constant regSFPdiagData   : std_logic_vector(7 downto 0) := x"60"; --<-- d56     10     1
constant regSFPtestCRC1   : std_logic_vector(7 downto 0) := x"00"; --<-- d00     64     0
constant regSFPtestCRC2   : std_logic_vector(7 downto 0) := x"40"; --<-- d00     31     0
constant regTEMPdata      : std_logic_vector(7 downto 0) := x"00"; --<-- d00     3      0

-- Size of data to read from SFP to space memory
constant dimSFPVendorName : std_logic_vector(7 downto 0) := x"10"; -- 16 data
constant dimSFPVendorPN   : std_logic_vector(7 downto 0) := x"10"; -- 16 data
constant dimSFPVendorSN   : std_logic_vector(7 downto 0) := x"10"; -- 16 data
constant dimSFPProdDate   : std_logic_vector(7 downto 0) := x"08"; -- 8  data
constant dimSFPdiagData   : std_logic_vector(7 downto 0) := x"0A"; -- 10 data
constant dimSFPtestCRC1   : std_logic_vector(7 downto 0) := x"40"; -- 64 data plus checksum
constant dimSFPtestCRC2   : std_logic_vector(7 downto 0) := x"20"; -- 31 data plus checksum
constant dimI2CTEMPdata   : std_logic_vector(7 downto 0) := x"03"; -- 3, 2 bytes of data plus activation

-- I2C Addresses, SFP and temp
constant I2CTempGBT_0     : std_logic_vector(7 downto 0) := x"90";
constant I2CTempLDOGBT_1  : std_logic_vector(7 downto 0) := x"92";
constant I2CTempLDOSDES_2 : std_logic_vector(7 downto 0) := x"94";
constant I2CTempPXL_3     : std_logic_vector(7 downto 0) := x"96";
constant I2CTempLDOFPGA_4 : std_logic_vector(7 downto 0) := x"98";
constant I2CTempIGLOO2_5  : std_logic_vector(7 downto 0) := x"9A";
constant I2CTempVTRX_6    : std_logic_vector(7 downto 0) := x"9C";
constant I2CSFPpage0      : std_logic_vector(7 downto 0) := x"A0";
constant I2CSFPpage1      : std_logic_vector(7 downto 0) := x"A2";

-- Error ID, SFP and TEMP
constant ErrI2CTempGBT_0     : std_logic_vector(3 downto 0) := x"0"; 
constant ErrI2CTempLDOGBT_1  : std_logic_vector(3 downto 0) := x"1";
constant ErrI2CTempLDOSDES_2 : std_logic_vector(3 downto 0) := x"2";
constant ErrI2CTempPXL_3     : std_logic_vector(3 downto 0) := x"3";
constant ErrI2CTempLDOFPGA_4 : std_logic_vector(3 downto 0) := x"4";
constant ErrI2CTempIGLOO2_5  : std_logic_vector(3 downto 0) := x"5";
constant ErrI2CTempVTRX_6    : std_logic_vector(3 downto 0) := x"6";
constant ErrI2CSFPpage0      : std_logic_vector(3 downto 0) := x"7";
constant ErrI2CSFPpage1      : std_logic_vector(3 downto 0) := x"7";

constant CHAR_x : std_logic_vector(7 downto 0) := x"78";

-------------------------------------------------------------------| Bit | Signal --+ Notes ----------------------+------------+
-------------------------------------------------------------------| 7:0 | DEBUG    | x"0" No errors                          |
constant cDT_SFPI2C1 : std_logic_vector(3 downto 0) := x"0"; ------|     | DEBUG    | x"0" I2C no answer SFP                  |
constant cDT_SFPSDA0 : std_logic_vector(3 downto 0) := x"1"; ------|     | DEBUG    | x"1" I2C SFP SDA hold to '0'            |
constant cDT_SFPSCL0 : std_logic_vector(3 downto 0) := x"2"; ------|     | DEBUG    | x"2" I2C SFP SCL hold to '0'            |
constant cDT_SFPSDA1 : std_logic_vector(3 downto 0) := x"3"; ------|     | DEBUG    | x"3" I2C SFP SDA hold to '1'            |
constant cDT_SFPSCL1 : std_logic_vector(3 downto 0) := x"4"; ------|     | DEBUG    | x"4" I2C SFP SCL hold to '1'            |
constant cDT_SFPCRC  : std_logic_vector(3 downto 0) := x"C"; ------|     | DEBUG    | x"C" CRC error set                      |
constant cDT_SFPDAC  : std_logic_vector(3 downto 0) := x"D"; ------|     | DEBUG    | x"D" DAC error set                      |
constant cDT_SFP0xFF : std_logic_vector(3 downto 0) := x"F"; ------|     | DEBUG    | x"F" 0xFF error set                     |c
-------------------------------------------------------------------+----------------------------------------------+------------+
--------------------------- Register ------------------------------|                                              |  Default   |
-------------------------------------------------------------------+----------------------------------------------+------------+
constant aSFPData        : std_logic_vector(3 downto 0):="0000"; --| Data extracted from buffer RAM               | "xxxxxxxx" |
--gnal   rSFPData        : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aSFPDataPtr     : std_logic_vector(3 downto 0):="0001"; --| Pointer for RAM data extraction              | "00000000" |
signal   rSFPDataPtr     : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aTempGBT        : std_logic_vector(3 downto 0):="0010"; --| Board temperature sensor GBT                 | "xxxxxxxx" |
signal   rTempGBT        : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aTempLDOGBT     : std_logic_vector(3 downto 0):="0011"; --| Board temperature sensor LDOGBT              | "xxxxxxxx" |
signal   rTempLDOGBT     : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aTempLDOSDES    : std_logic_vector(3 downto 0):="0100"; --| Board temperature sensor LDOSDES             | "xxxxxxxx" |
signal   rTempLDOSDES    : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aTempPXL        : std_logic_vector(3 downto 0):="0101"; --| Board temperature sensor PXL                 | "xxxxxxxx" |
signal   rTempPXL        : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aTempLDOFPGA    : std_logic_vector(3 downto 0):="0110"; --| Board temperature sensor LDOFPGA             | "xxxxxxxx" |
signal   rTempLDOFPGA    : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aTempIGLOO2     : std_logic_vector(3 downto 0):="0111"; --| Board temperature sensor IGLOO2              | "xxxxxxxx" |
signal   rTempIGLOO2     : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aTempVTRX       : std_logic_vector(3 downto 0):="1000"; --| Board temperature sensor VTRX                | "xxxxxxxx" |
signal   rTempVTRX       : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aSFPtemp        : std_logic_vector(3 downto 0):="1001"; --| SFP internal temperature                     | "xxxxxxxx" |
signal   rSFPtemp        : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aSFPvolt        : std_logic_vector(3 downto 0):="1010"; --| SFP internal voltage                         | "xxxxxxxx" |
signal   rSFPvolt        : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aSFPbias        : std_logic_vector(3 downto 0):="1011"; --| SFP TX bias                                  | "xxxxxxxx" |
signal   rSFPbias        : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aSFPtxpow       : std_logic_vector(3 downto 0):="1100"; --| SFP TX optical power                         | "xxxxxxxx" |
signal   rSFPtxpow       : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aSFPrxpow       : std_logic_vector(3 downto 0):="1101"; --| SFP TX optical power                         | "xxxxxxxx" |
signal   rSFPrxpow       : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aI2Cmonitor     : std_logic_vector(3 downto 0):="1110"; --| I2C status                                   | "00000000" |
signal   rI2Ccontrol     : std_logic_vector(7 downto 0);         --|                                              |            |
-------------------------------------------------------------------| Bit | Signal --+ Notes ----------------------+------------+
signal   SFPLOOP         : std_logic_vector(2 downto 0):= "000"; --| 2:0 | SFPLOOP  | New data in register after last read     | --<- 180115
signal   SFPLOOPpls      : std_logic; -----------------------------|     |          | -----------------------------------------|
constant cSFPTIME0       : integer range 0 to 4010 := 10; ---------|     |          | 000: Quite continuous                    |
constant cSFPTIME1       : integer range 0 to 4010 := 100; --------|     |          | 001: 100ms                               |
constant cSFPTIME2       : integer range 0 to 4010 := 200; --------|     |          | 010: 200ms                               |
constant cSFPTIME3       : integer range 0 to 4010 := 500; --------|     |          | 011: 500ms                               |
constant cSFPTIME4       : integer range 0 to 4010 := 1000; -------|     |          | 100: 1000ms                              |
constant cSFPTIME5       : integer range 0 to 4010 := 2000; -------|     |          | 101: 2000ms                              |
constant cSFPTIME6       : integer range 0 to 4010 := 4000; -------|     |          | 110: 4000ms                              |
constant cSFPTIME7       : integer range 0 to 4010 := 4001; -------|     |          | 111: disabled                            |
-------------------------------------------------------------------|     |          |                                          |
signal SFPI2Cdis : STD_LOGIC := '0'; ------------------------------| 3   | NO SFP   | Blocco SFP                               | --<- 180115
-------------------------------------------------------------------| 4   | REFRESH  | New data in register after last read     |
-------------------------------------------------------------------| 5   | SDACHNG  | SDA line switch after last read          |
-------------------------------------------------------------------| 6   | SCLCHNG  | SCL line switch after last read          |
-------------------------------------------------------------------| 7   | DebugFlag| Error Debug enable                       |
-------------------------------------------------------------------+----------------+-----------------------------+------------+
-------------------------------------------------------------------+----------------+-----------------------------+------------+
constant aI2Cstatus     : std_logic_vector(3 downto 0):="1111"; ---| I2C status                                   | "00000000" |
signal   rI2Cerror      : std_logic_vector(7 downto 0);         ---|                                              |            |
-------------------------------------------------------------------| Bit | Signal --+ Notes ----------------------+------------+
-------------------------------------------------------------------| 7:0 | I2CERROR | Modified core I2C error Status           |
constant eSFPOK       : std_logic_vector(7 downto 0) := x"00"; ----| 7:0 | SFPERROR | x"00" No errors                          |
constant eTimeOutI2C  : std_logic_vector(7 downto 0) := x"A0"; ----|     |          | x"A0" SCL low for more than 5ms          |
constant eSFPBadCrc   : std_logic_vector(7 downto 0) := x"A1"; ----|     |          | x"A1" CRC error                          |
constant eSFPDataHang : std_logic_vector(7 downto 0) := x"A2"; ----|     |          | x"A2" DAC error                          |
constant eSFPData0xFF : std_logic_vector(7 downto 0) := x"A3"; ----|     |          | x"A3" 0xFFFF in data                     |
-------------------------------------------------------------------+----------------+-----------------------------+------------+

--
signal   SFPErrorCRCflg : std_logic;
signal   SFPErrorXFFflg : std_logic;
signal   SFPErrorDACflg : std_logic;
signal   SFPDiagErrorCnt : integer range 0 to 7 := 0;

signal   dI2Cerror      : std_logic_vector(7 downto 0);

signal   dEN            : std_logic;
signal   ENpulse        : std_logic;
signal   dWR            : std_logic;
signal   dADD           : std_logic_vector(3 downto 0);
signal   dSDAin         : std_logic;
signal   pSDAin         : std_logic;
signal   dSCLin         : std_logic;
signal   pSCLin         : std_logic;

--gnal   TimeLapseflag  : std_logic := '0';

---------------------------------------------------------------------------------------
begin

	EN_delay_handler : process(CLK)
	begin
	if CLK'event and CLK='1' then
		if RESETn='0' then 
                dEN <= '0'; dWR <= '0'; dADD <= x"0"; dSDAin <= SDAin; dSCLin <= SCLin;
		else    dEN <= EN ; dWR <= WR ; dADD <= ADD;  dSDAin <= SDAin; dSCLin <= SCLin;
		end if;
	end if;
	end process;

	EN_pulse_handler : process(dEN, EN, RESETn)
	begin
		ENpulse <= not EN and dEN and RESETn;
	end process;

	DataBusAccess_handler : process(CLK)
	begin
	if CLK'event and CLK='1' then
        
		if RESETn='0' then
			clrDRMI2Cerror <= '0';
			clrI2Cerror <= '0';
			rSFPDataPtr <= x"00";
			RIOaddrRD   <= "0000000";
			RefreshDoneRST <= '0';
			DO <= x"00";
--          rDebugTest <= x"00";
            rI2Cerror  <= x"00";
            RESETOUTn  <= '1';
			pSDAin <= '0';
			pSCLin <= '0';
            SFPLOOP <= "000";  --<- 180115
            SFPI2Cdis  <= '0'; --<- 180115
		elsif WR='1' and EN='1' then
			case ADD is
			when aSFPDataPtr   => rSFPDataPtr <= DI; -----------------------------<-- 1
            when aI2Cmonitor   => SFPLOOP <= DI(2 downto 0); --<- 180115
                                  SFPI2Cdis  <= DI(3);       --<- 180115
			when aI2Cstatus    => if DI=CHAR_x then 
								  	  RESETOUTn <= '0'; 
                                  else 
                                  	  null; 
                                  end if;
--			when aDebugTest    => if DebugFlag='1' then --------------------------<-- F <- 180125
--                                   rDebugTest <= DI;
--                                else
--                                   rDebugTest <= x"00";
--                                end if;
			when others => null;
			end case;
			DO <= x"00";
		elsif dWR='0' and ENpulse='1' then
			case dADD is
			when aSFPData     => rSFPDataPtr <= rSFPDataPtr+x"01"; ---------------<-- 0
			when aI2Cmonitor  => pSCLin <= '0'; ----------------------------------<-- D
			                     pSDAin <= '0'; 
			                     RefreshDoneRST <= '1'; 
			when aI2Cstatus   => rI2Cerror <= x"00"; RESETOUTn <= '1'; -----------<-- E
			when others       => null;
            end case;
		else
			case ADD is
			when aSFPData     => DO <= RIOdataRD; --------------------------------<-- 0
			when aSFPDataPtr  => DO <= rSFPDataPtr; ------------------------------<-- 1
			when aTempGBT     => DO <= rTempGBT; ---------------------------------<-- 2
			when aTempLDOGBT  => DO <= rTempLDOGBT; ------------------------------<-- 3
			when aTempLDOSDES => DO <= rTempLDOSDES; -----------------------------<-- 4
			when aTempPXL     => DO <= rTempPXL; ---------------------------------<-- 5
			when aTempLDOFPGA => DO <= rTempLDOFPGA; -----------------------------<-- 6
			when aTempIGLOO2  => DO <= rTempIGLOO2; ------------------------------<-- 7
			when aTempVTRX    => DO <= rTempVTRX; --------------------------------<-- 8
			when aSFPtemp     => DO <= rSFPtemp ; --------------------------------<-- 9
			when aSFPvolt     => DO <= rSFPvolt ; --------------------------------<-- A
			when aSFPbias     => DO <= rSFPbias ; --------------------------------<-- B
			when aSFPtxpow    => DO <= rSFPtxpow; --------------------------------<-- C
			when aSFPrxpow    => DO <= rSFPrxpow; --------------------------------<-- D
--			when aI2Cmonitor  => DO <= DebugFlag     & --- bit 7 -----------------<-- E
			when aI2Cmonitor  => DO <= '0'           & --- bit 7 -----------------<-- E
                                       pSCLin        & --- bit 6
                                       pSDAin        & --- bit 5
			                           RefreshDone   & --- bit 4
                                       SFPI2Cdis     & --- bit 3   <- 180115
                                       SFPLOOP ;       --- bit 2:0 <- 180115
			when aI2Cstatus   => DO <= rI2Cerror;  -------------------------------<-- E <- 171121 <- 180111 <- 180125
--			when aDebugTest   => DO <= rDebugTest; -------------------------------<-- F <- 180125
			when others       => null;
			end case;

			RIOaddrRD <= rSFPDataPtr(6 downto 0);

			if rI2Cerror =x"00" then 
                if dI2Cerror/=x"00"      then 
                    rI2CError <= dI2Cerror;
                elsif TimeOutError='1'   then 
                    rI2Cerror <= eTimeOutI2C ; --<- 171122 
                elsif SFPErrorCRCflg='1' then 
                    rI2Cerror <= eSFPBadCrc  ; 
			    elsif SFPErrorXFFflg='1' then 
                    rI2Cerror <= eSFPData0xFF; 
				elsif SFPErrorDACflg='1' then 
                    rI2Cerror <= eSFPDataHang; 
                end if; 
            end if;

            if SDAin/=dSDAin then pSDAin <= '1'; end if;
            if SCLin/=dSCLin then pSCLin <= '1'; end if;

            if RefreshDone='0' then RefreshDoneRST <= '0'; end if;

		end if;
	end if;

	end process;

--  TimeLapse_handler : process(CLK)
--  variable Timelapse_mS  : integer range 0 to 251 := 0;
--  begin
--	if CLK'event and CLK='1' then
--	  if RESETn='0' then 
--          TimeLapseflag <= '0';
--          Timelapse_mS  := 0;
--      elsif P1mS='1' then
--          if Timelapse_mS=50 then 
--              TimeLapseflag <= '1'; Timelapse_mS := 0;              
--          else 
--              TimeLapseflag <= '0'; Timelapse_mS := Timelapse_mS+1; 
--          end if;
--      end if;
--  end if;
--  end process;

	STARTUPhandler : process(CLK)
	begin
	if CLK'event and CLK='1' then
		if RESETn='0'  or READY='0'   then STARTUP <= '0';
		elsif P1mS='1' or STARTUP='1' then STARTUP <= '1';
		end if;
	end if;
	end process;

	SFPI2Ccontrol : process(CLK)
    -- State Machine controls
    variable smSFPI2Cctrl    : std_logic_vector(7 downto 0);
    -- Define state reading TEMP SFP I2C
    constant smi2cWAITTIM80  : std_logic_vector(7 downto 0) := x"80";
    constant smi2cTpGBTX_00  : std_logic_vector(7 downto 0) := x"00";
    constant smi2cTpGBTX_00b : std_logic_vector(7 downto 0) := x"01";
    constant smi2cRVendPN01  : std_logic_vector(7 downto 0) := x"02";
    constant smi2cRVendPN01b : std_logic_vector(7 downto 0) := x"03";
    constant smi2cRVendSN02  : std_logic_vector(7 downto 0) := x"04";
    constant smi2cRVendSN02b : std_logic_vector(7 downto 0) := x"05";
    constant smi2cRVendPD03  : std_logic_vector(7 downto 0) := x"06";
    constant smi2cRVendPD03b : std_logic_vector(7 downto 0) := x"07";
    constant smi2cDiagRD_04  : std_logic_vector(7 downto 0) := x"08";
    constant smi2cDiagRD_04b : std_logic_vector(7 downto 0) := x"09";
    constant smi2cSFPCRCa05  : std_logic_vector(7 downto 0) := x"10";
    constant smi2cSFPCRCa05b : std_logic_vector(7 downto 0) := x"11";
    constant smi2cSFPCRCb06  : std_logic_vector(7 downto 0) := x"12";
    constant smi2cSFPCRCb06b : std_logic_vector(7 downto 0) := x"13";
    constant smi2cRVendOR07  : std_logic_vector(7 downto 0) := x"14";
    constant smi2cRVendOR07b : std_logic_vector(7 downto 0) := x"15";
    constant smi2cTLDOGBT08  : std_logic_vector(7 downto 0) := x"16";
    constant smi2cTLDOGBT08b : std_logic_vector(7 downto 0) := x"17";
    constant smi2cLDOSERD09  : std_logic_vector(7 downto 0) := x"18";
    constant smi2cLDOSERD09b : std_logic_vector(7 downto 0) := x"19";
    constant smi2cPXLArea10  : std_logic_vector(7 downto 0) := x"20";
    constant smi2cPXLArea10b : std_logic_vector(7 downto 0) := x"21";
    constant smi2cLDOFPGA11  : std_logic_vector(7 downto 0) := x"22";
    constant smi2cLDOFPGA11b : std_logic_vector(7 downto 0) := x"23";
    constant smi2cTmpFPGA12  : std_logic_vector(7 downto 0) := x"24";
    constant smi2cTmpFPGA12b : std_logic_vector(7 downto 0) := x"25";
    constant smi2cTmpVTRX13  : std_logic_vector(7 downto 0) := x"26";
    constant smi2cTmpVTRX13b : std_logic_vector(7 downto 0) := x"27";
    constant smi2cDiagTST14  : std_logic_vector(7 downto 0) := x"28";
    constant smi2cDiagTST14b : std_logic_vector(7 downto 0) := x"29";
    constant smi2cOthers_15  : std_logic_vector(7 downto 0) := x"30";
    constant smi2cOthers_15b : std_logic_vector(7 downto 0) := x"31";
----constant smSFPI1Cctrl16  : std_logic_vector(7 downto 0) := x"32";
----constant smSFPI1Cctrl16b : std_logic_vector(7 downto 0) := x"33";
----constant smSFPI1Cctrl17  : std_logic_vector(7 downto 0) := x"34";
----constant smSFPI1Cctrl17b : std_logic_vector(7 downto 0) := x"35";
----constant smSFPI1Cctrl18  : std_logic_vector(7 downto 0) := x"36";
----constant smSFPI1Cctrl18b : std_logic_vector(7 downto 0) := x"37";
	begin
	if CLK'event and CLK='1' then
		if RESETn='0' or STARTUP='0' or TimeOutError='1' then --<- 171121
			smSFPI2Cctrl := smi2cWAITTIM80;
			DRMI2Cenab   <= '0';
--			RefreshDone  <= '0';
            SFPI2Cmode <= "00";
            SFPI2CRegCnt <= x"00";
			rTempGBT    <=  x"00";
			rTempLDOGBT <= x"00";
			rTempLDOSDES <= x"00";
			rTempPXL <= x"00";
			rTempLDOFPGA <= x"00";
			rTempIGLOO2 <= x"00";
			rTempVTRX <= x"00";
            SFPDiagTestEnab <= '0';
            I2CLOOPtime <= '0';
            RefreshDoneSET <= '0';
--      elsif rI2Cerror<x"A0" and rI2Cerror>x"00" then 
--          null;
        elsif SFPDiagTestEnab='1' or SFPDiagTestEnabOK='1' then
--          if TimeLapseflag='1' then 
                if SFPDiagTestEnabOK ='1' then 
                    SFPDiagTestEnab <= '0'; 
                end if;
--          end if;
        elsif DRMI2Cenab='1' or DRMI2CenabOK='1' then
--          if TimeLapseflag='1' then 
                if DRMI2CenabOK ='1'   then 
                    DRMI2Cenab <= '0';      
                end if;
--          end if;
		else
			case smSFPI2Cctrl is
----------- Timing
			when smi2cWAITTIM80  => if SFPLOOPpls='1' then
                                        smSFPI2Cctrl := smi2cTpGBTX_00; 
                                        I2CLOOPtime <= '1';
                                    end if;
----------- Temperature sensor GBT area reading
			when smi2cTpGBTX_00 =>  if rI2Cerror(7 downto 4)=ErrI2CTempGBT_0 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cTLDOGBT08; -----<-- Set next state
                                    else
                                        SFPI2Cadd <= I2CTempGBT_0; ----------<-- Page selection
                                        SFPI2CRegBase <= regTEMPdata; -------<-- SFP page base register address
                                        SFPI2CRegCnt <= dimI2CTEMPdata; -----<-- SFP page regiter to read
                                        SFPI2Cmode <= cI2CmodeData; ---------<-- Get data only
--                                      DRMRAMptr <= maTempGBT_0; -----------<-- RAM register pointer
                                        DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
                                        smSFPI2Cctrl := smi2cTpGBTX_00b; ----<-- Wait data
                                    end if;
			when smi2cTpGBTX_00b => rTempGBT     <= DRMI2Cdata; -------------<-- Save data
									smSFPI2Cctrl := smi2cTLDOGBT08; ---------<-- Set next state
----------- Temperature sensor LDO GBT area reading
			when smi2cTLDOGBT08 =>  if rI2Cerror(7 downto 4)=ErrI2CTempLDOGBT_1 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cLDOSERD09; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CTempLDOGBT_1; -------<-- Page selection
										SFPI2CRegBase <= regTEMPdata; -------<-- SFP page base register address
										SFPI2CRegCnt <= dimI2CTEMPdata; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeData; ---------<-- Get data only
--                                  	DRMRAMptr <= maTempLDOGBT_1; --------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cTLDOGBT08b; ----<-- Wait data 
									end if;
			when smi2cTLDOGBT08b=>  rTempLDOGBT  <= DRMI2Cdata; ---------<-- Save data
									smSFPI2Cctrl := smi2cLDOSERD09; -----<-- Set next state
----------- Temperature sensor LDO SERDES area reading
			when smi2cLDOSERD09 =>  if rI2Cerror(7 downto 4)=ErrI2CTempLDOSDES_2 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cPXLArea10; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CTempLDOSDES_2; ------<-- Page selection
										SFPI2CRegBase <= regTEMPdata; -------<-- SFP page base register address
										SFPI2CRegCnt <= dimI2CTEMPdata; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeData; ---------<-- Get data only
--                                  	DRMRAMptr <= maTempLDOSDES_2; -------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cLDOSERD09b; ----<-- Wait data 
									end if;
			when smi2cLDOSERD09b => rTempLDOSDES <= DRMI2Cdata; ---------<-- Save data
									smSFPI2Cctrl := smi2cPXLArea10; -----<-- Set next state
----------- Temperature sensor PXL area reading
			when smi2cPXLArea10 =>  if rI2Cerror(7 downto 4)=ErrI2CTempPXL_3 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cLDOFPGA11; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CTempPXL_3; ----------<-- Page selection
										SFPI2CRegBase <= regTEMPdata; -------<-- SFP page base register address
										SFPI2CRegCnt <= dimI2CTEMPdata; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeData; ---------<-- Get data only
--                                  	DRMRAMptr <= maTempPXL_3; -----------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cPXLArea10b; ----<-- Wait data
									end if;
			when smi2cPXLArea10b => rTempPXL     <= DRMI2Cdata; ---------<-- Save data
									smSFPI2Cctrl := smi2cLDOFPGA11; -----<-- Set next state
----------- Temperature sensor LDO FPGA area reading
			when smi2cLDOFPGA11 =>  if rI2Cerror(7 downto 4)=ErrI2CTempLDOFPGA_4 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cTmpFPGA12; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CTempLDOFPGA_4; ------<-- Page selection
										SFPI2CRegBase <= regTEMPdata; -------<-- SFP page base register address
										SFPI2CRegCnt <= dimI2CTEMPdata; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeData; ---------<-- Get data only
--                                  	DRMRAMptr <= maTempLDOFPGA_4; -------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cLDOFPGA11b; ----<-- Wait data
									end if;
			when smi2cLDOFPGA11b => rTempLDOFPGA <= DRMI2Cdata; ---------<-- Save data
									smSFPI2Cctrl := smi2cTmpFPGA12; -----<-- Set next state
----------- Temperature sensor IGLOO2 area reading
			when smi2cTmpFPGA12 =>  if rI2Cerror(7 downto 4)=ErrI2CTempIGLOO2_5 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cTmpVTRX13; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CTempIGLOO2_5; -------<-- Page selection
										SFPI2CRegBase <= regTEMPdata; -------<-- SFP page base register address
										SFPI2CRegCnt <= dimI2CTEMPdata; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeData; ---------<-- Get data only
--                                  	DRMRAMptr <= maTempIGLOO2_5; --------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cTmpFPGA12b; ----<-- Wait data 
									end if;
			when smi2cTmpFPGA12b => rTempIGLOO2  <= DRMI2Cdata; ---------<-- Save data
									smSFPI2Cctrl := smi2cTmpVTRX13; -----<-- Set next state
----------- Temperature sensor VTRX area reading
			when smi2cTmpVTRX13 =>  if rI2Cerror(7 downto 4)=ErrI2CTempVTRX_6 and rI2Cerror/="00" then 
                                    	if SFPI2Cdis='0' then              --<- 180115
                                    	  smSFPI2Cctrl := smi2cSFPCRCa05; ---<-- Set next state SFP
                                    	else
                                    	  smSFPI2Cctrl := smi2cOthers_15;  --<-- Set next state NOSFP
                                    	end if;
                                    else
                                    	SFPI2Cadd <= I2CTempVTRX_6; ---------<-- Page selection
										SFPI2CRegBase <= regTEMPdata; -------<-- SFP page base register address
										SFPI2CRegCnt <= dimI2CTEMPdata; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeData; ---------<-- Get data only
--                                  	DRMRAMptr <= maTempVTRX_6; ----------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cTmpVTRX13b; ----<-- Wait data 
									end if;
			when smi2cTmpVTRX13b => rTempVTRX    <= DRMI2Cdata; ---------<-- Save data
                                    if SFPI2Cdis='0' then              --<- 180115
                                      smSFPI2Cctrl := smi2cSFPCRCa05; ---<-- Set next state SFP
                                    else
                                      smSFPI2Cctrl := smi2cOthers_15;  --<-- Set next state NOSFP
                                    end if;
----------- SFP CRC test 1
			when smi2cSFPCRCa05 =>  if rI2Cerror(7 downto 4)=ErrI2CSFPpage0 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cOthers_15; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CSFPpage0; -----------<-- Page selection
										SFPI2CRegBase <= regSFPtestCRC1; ----<-- SFP page base register address
										SFPI2CRegCnt <= dimSFPtestCRC1; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeCkSum; --------<-- Checksum data
--                                  	DRMRAMptr <= x"00"; -----------------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cSFPCRCb06; -----<-- Set next state
									end if;
----------- SFP CRC test 2
			when smi2cSFPCRCb06 =>  if rI2Cerror(7 downto 4)=ErrI2CSFPpage0 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cOthers_15; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CSFPpage0; -----------<-- Page selection
										SFPI2CRegBase <= regSFPtestCRC2; ----<-- SFP page base register address
										SFPI2CRegCnt <= dimSFPtestCRC2; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeCkSum; --------<-- Checksum data
--                                  	DRMRAMptr <= x"00"; -----------------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cDiagRD_04; -----<-- Set next state
									end if;
----------- SFP Vendor diagnostic data reading
			when smi2cDiagRD_04 =>  if rI2Cerror(7 downto 4)=ErrI2CSFPpage1 and rI2Cerror/="00" then 
                                        smSFPI2Cctrl := smi2cOthers_15; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CSFPpage1; -----------<-- Page selection
										SFPI2CRegBase <= regSFPdiagData; ----<-- SFP page base register address
										SFPI2CRegCnt <= dimSFPdiagData; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeToRAM; --------<-- Save to RAM
										DRMRAMptr <= maSFPdiagData; ---------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cDiagTST14; -----<-- Set next state
									end if;
----------- SFP diag test
			when smi2cDiagTST14 =>  null;
                                    SFPDiagTestEnab <= '1';
									smSFPI2Cctrl := smi2cDiagTST14b; ----<-- Set next state
----------- Error skip
			when smi2cDiagTST14b => if (SFPErrorXFFflg or SFPErrorDACflg or SFPErrorCRCflg)='1' then
										smSFPI2Cctrl := smi2cOthers_15;--<-- Skip if error
									else
										smSFPI2Cctrl := smi2cRVendOR07;--<-- Set next state
									end if;
----------- SFP Vendor name extraction
			when smi2cRVendOR07 =>  if rI2Cerror(7 downto 4)=ErrI2CSFPpage0 then 
                                        smSFPI2Cctrl := smi2cOthers_15; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CSFPpage0; -----------<-- Page selection
										SFPI2CRegBase <= regSFPVendorName; --<-- SFP page base register address
										SFPI2CRegCnt <= dimSFPVendorName; ---<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeToRAM; --------<-- Save to RAM
										DRMRAMptr <= maSFPVendorName; -------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cRVendPN01; -----<-- Set next state
									end if;
----------- SFP Vendor part number extraction
			when smi2cRVendPN01 =>  if rI2Cerror(7 downto 4)=ErrI2CSFPpage0 then 
                                        smSFPI2Cctrl := smi2cOthers_15; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CSFPpage0; -----------<-- Page selection
										SFPI2CRegBase <= regSFPVendorPN; ----<-- SFP page base register address
										SFPI2CRegCnt <= dimSFPVendorPN; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeToRAM; --------<-- Save to RAM
										DRMRAMptr <= maSFPVendorPN; ---------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cRVendSN02; -----<-- Set next state
									end if;
----------- SFP Vendor serial number extraction
			when smi2cRVendSN02 =>  if rI2Cerror(7 downto 4)=ErrI2CSFPpage0 then 
                                        smSFPI2Cctrl := smi2cOthers_15; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CSFPpage0; -----------<-- Page selection
										SFPI2CRegBase <= regSFPVendorSN; ----<-- SFP page base register address
										SFPI2CRegCnt <= dimSFPVendorSN; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeToRAM; --------<-- Save to RAM
										DRMRAMptr <= maSFPVendorSN; ---------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cRVendPD03; -----<-- Set next state
									end if;
----------- SFP Vendor production date extraction
			when smi2cRVendPD03 =>  if rI2Cerror(7 downto 4)=ErrI2CSFPpage0 then 
                                        smSFPI2Cctrl := smi2cOthers_15; -----<-- Set next state
                                    else
                                    	SFPI2Cadd <= I2CSFPpage0; -----------<-- Page selection
										SFPI2CRegBase <= regSFPProdDate; ----<-- SFP page base register address
										SFPI2CRegCnt <= dimSFPProdDate; -----<-- SFP page regiter to read
										SFPI2Cmode <= cI2CmodeToRAM; --------<-- Save to RAM
										DRMRAMptr <= maSFPProdDate; ---------<-- RAM register pointer
										DRMI2Cenab <= '1'; ------------------<-- Enable DRMI2Cread
										smSFPI2Cctrl := smi2cOthers_15; -----<-- Set next state
									end if;
----------- Others
			when others          => if RefreshDone='0' then 
                                        RefreshDoneSet <= '1';
                                    else                          
                                        smSFPI2Cctrl := smi2cWAITTIM80;
                                        I2CLOOPtime <= '0';
                                        RefreshDoneSet <= '0';
                                    end if;
--									smSFPI2Cctrl := smi2cDiagRD_04; --< togliere questo
			end case;
		end if;
	end if; --<-- If of the clock variations
	end process;

	SFPI2Cread : process(CLK)
    -- State Machine SFPI2C - Lettura I2C orientata al SFP
    variable smSFPI2Cread     : std_logic_vector(7 downto 0);
    -- Define state
    constant sSI2CStart_00      : std_logic_vector(7 downto 0) := x"00";
    constant sSI2CLoopW_01      : std_logic_vector(7 downto 0) := x"01";
    constant sSI2CI2CRunW_02    : std_logic_vector(7 downto 0) := x"02";
    constant sSI2CI2CRunR_03    : std_logic_vector(7 downto 0) := x"03";
    constant sSI2CLoopR_04      : std_logic_vector(7 downto 0) := x"04";
    constant sSI2CReadData_05   : std_logic_vector(7 downto 0) := x"05";
    constant sSI2CError_06      : std_logic_vector(7 downto 0) := x"06";
    constant sSI2CEndRead_07    : std_logic_vector(7 downto 0) := x"07";

    variable DRMI2Csequence : integer range 0 to 7;
	begin
	if CLK'event and CLK='1' then
		if RESETn='0' then
			smSFPI2Cread := sSI2CStart_00;
			I2CRUN <= '0';
			DRMI2CenabOK  <= '0';
			DRMI2CerrOK   <= '0';
			FiWE <= '0';
			FoRE <= '0';
--			RAMdataWRi  <= "00000000";
			RAMaddrWRi  <= "0000000";
			RAMaddrRDi  <= "0000000";
			RAMwrite_i   <= '0';
			DRMI2Cdata <= x"00";
			DRMI2Csequence := 0;
			dI2Cerror <= x"00";
			SFPErrorCRCflg <= '0';
			RDCOUNT <= x"00";
			DRMI2Ccnt <= x"00";
		else
			case smSFPI2Cread is
			when sSI2CStart_00 =>
				I2CRUN <= '0';
				FiWE <= '0';
				FoRE <= '0';
				DRMI2CenabOK <= '0';
				DRMI2CerrOK <= '0';
				SFPI2Ccrc   <= x"00";
				DRMI2Csequence := 0;
				if DRMI2Cenab = '1' then
					smSFPI2Cread := sSI2CLoopW_01;
					DRMRAMcnt    <= DRMRAMptr;
				end if;
----------- Send SFP/TEMP register address
			when sSI2CLoopW_01 =>
				case DRMI2Csequence is
				when 0 => DRMI2Csequence := 1; FiWE <= '1'; FiDATA <= SFPI2Cadd; -------------- Send I2C address plus W
				when 1 => DRMI2Csequence := 2; FiWE <= '1'; FiDATA <= SFPI2CRegBase; ---------- Send SFP register address
				when 2 => DRMI2Csequence := 3; FiWE <= '0'; I2CRUN <= '1'; -------------------- I2CRUN active
				when 3 => if DRMI2Cactive='1' then DRMI2Csequence := 4; end if;
				when 4 =>
					if DRMI2Cactive='0' then
						if DRMI2Cerr=x"00" then
							smSFPI2Cread := sSI2CI2CRunW_02; DRMI2Csequence := 0; dI2Cerror <= x"00";
						else
							smSFPI2Cread := sSI2CError_06;   DRMI2Csequence := 0; dI2Cerror <= DRMI2Cerr;
						end if;
					end if;
				when others => DRMI2Csequence := 0;
				end case;
			when sSI2CI2CRunW_02 =>
--				dI2Cerror <= x"00";
				I2CRUN <= '0';
				smSFPI2Cread := sSI2CLoopR_04;
			when sSI2CLoopR_04 =>
				case DRMI2Csequence is
				when 0 => DRMI2Csequence := 1; RDCOUNT <= SFPI2CRegCnt; DRMI2Ccnt <= SFPI2CRegCnt;
				when 1 => DRMI2Csequence := 2; FiWE <= '0'; FiDATA <= SFPI2Cadd or x"01";
				when 2 => DRMI2Csequence := 3; FiWE <= '1'; FiDATA <= SFPI2Cadd or x"01";
				when 3 => DRMI2Csequence := 4; FiWE <= '0'; FiDATA <= SFPI2Cadd or x"01";
				when 4 => DRMI2Csequence := 5; FiWE <= '0'; I2CRUN <= '1'; -------------------- I2CRUN active
				when 5 => DRMI2Csequence := 6; FiWE <= '0'; ----------------------------------- Delay
				when 6 =>
					if DRMI2Cactive='0' then
						if DRMI2Cerr=x"00" then
							smSFPI2Cread := sSI2CI2CRunR_03; DRMI2Csequence := 0; dI2Cerror <= x"00";
						else
							smSFPI2Cread := sSI2CError_06;   DRMI2Csequence := 0; dI2Cerror <= DRMI2Cerr;
						end if;
					end if;
				when others => DRMI2Csequence := 0;
				end case;
			when sSI2CI2CRunR_03 =>
--				dI2Cerror <= x"00";
				I2CRUN <= '0';
				smSFPI2Cread := sSI2CReadData_05;
			when sSI2CReadData_05 =>
				if DRMI2Ccnt=x"00" then
					RAMwrite_i <= '0';
					FoRE     <= '0';
					DRMI2CenabOK <= '1';
					if SFPI2Cmode=cI2CmodeCkSum then
						if FoDATA=SFPI2Ccrc then 
                            if DebugErr=cDT_SFPCRC and DebugErrEn='1' then
                                SFPErrorCRCflg <= '1';
                            else
                                SFPErrorCRCflg <= '0';
                            end if;
                        else
                            SFPErrorCRCflg <= '1';
                        end if;
					end if;
					smSFPI2Cread := sSI2CEndRead_07;
--				elsif FoEMPTY='1' then -- Not necessary
--					FoRE   <= '0';
--					RAMwrite_i <= '0';
				else
					case SFPI2Cmode is
					when cI2CmodeToRAM =>
--						RAMdataWRi <= FoDATA;
						RAMaddrWRi <= DRMRAMcnt;
						RAMwrite_i <= '1';
						DRMRAMcnt  <= DRMRAMcnt + "0000001";
					when cI2CmodeCkSum =>
						if DRMI2Ccnt<SFPI2CRegCnt then SFPI2Ccrc <= SFPI2Ccrc + FoDATA; end if;
					when cI2CmodeData =>
                        case DRMI2Ccnt is
                        when x"02"  => DRMI2Cdata(7 downto 1) <= FoDATA(6 downto 0);
                        when x"01"  => DRMI2Cdata(0)          <= FoDATA(7);
                        when others => null;
                        end case;
					when others       => null;
					end case;
		 			FoRE      <= '1';
					DRMI2Ccnt <= DRMI2Ccnt-x"01";
				end if;
----------- Error handling
			when sSI2CError_06 =>
--				dI2Cerror <= DRMI2Cerr;
				DRMI2CenabOK <= '1';
				DRMI2CerrOK <= '1';
				smSFPI2Cread := sSI2CEndRead_07;
			when sSI2CEndRead_07 =>
				if DRMI2Cenab='0' then
					smSFPI2Cread := sSI2CStart_00;
				end if;
			when others => smSFPI2Cread := sSI2CStart_00;
			end case;
		end if; --<-- 'end if' of the reset/error/case
	end if; ------<-- 'end if' of the clock variations
	end process;

	SFPDiagTest_handler : process(CLK)
    -- State Machine SFPDiagTest - Controllo valori diagnostica SFP
    variable smSFPDT : integer range 0 to 7;
    -- Define state
    constant sSFPDTsta_0 		: integer := 0;
    constant sSFPDTrdm_1 		: integer := 1;
    constant sSFPDTrdd_2 		: integer := 2;
    constant sSFPDTcmp_3 		: integer := 3;
    constant sSFPDTlop_4 		: integer := 4;
    constant sSFPDTerr_5 		: integer := 5;
    constant sSFPDTwai_6 		: integer := 6;
    constant sSFPDTsav_7 		: integer := 7;
--  variable SFPDiagErrorCnt : integer range 0 to 7 := 0;
    variable SFPDiagFlag     : std_logic_vector(4 downto 0) := "00000";
    variable SFPDiagLoopCnt  : integer range 0 to 4 := 0;
    variable SFPDiagDataAdd  : std_logic_vector(6 downto 0) := "0000000";
    variable SFPDiagLastAdd  : std_logic_vector(6 downto 0) := "0000000";
    variable SFPDiagData     : std_logic_vector(15 downto 0) := x"0000";
    variable SFPDiagLast     : std_logic_vector(15 downto 0) := x"0000";
    variable DRMI2Csequence  : integer range 0 to 6;
	begin
	if CLK'event and CLK='1' then
		if RESETn='0' then
			smSFPDT := sSFPDTsta_0;    SFPDiagFlag     := "00000";
			SFPDiagTestEnabOK <= '0';  SFPDiagLoopCnt  := 0;
			SFPDiagErrorCnt <= 0;      SFPDiagDataAdd  := "0000000";
			DRMI2Csequence := 0;       SFPDiagLastAdd  := "0000000";
			SFPErrorXFFflg <= '0';     SFPDiagData     := x"0000";
			SFPErrorDACflg <= '0';     SFPDiagLast     := x"0000";
			RAMdataWRd <= x"00";
			RAMaddrWRd <= "0000000";
			RAMaddrRDd <= "0000000";
			RAMwrite_d <= '0';
		else
			case smSFPDT is
			when sSFPDTsta_0 => null; ----------------------------------------------- Startup test state machine
								if SFPDiagTestEnab='1' then
--									SFPDiagErrorCnt <= 0;
									SFPDiagFlag     := "00000";
									SFPDiagLoopCnt  := 0;
									SFPDiagDataAdd  := maSFPdiagData;
									SFPDiagLastAdd  := maSFPdiagLast;
									smSFPDT := sSFPDTrdm_1;
									SFPErrorXFFflg <= '0';
									SFPErrorDACflg <= '0';
								end if;
			when sSFPDTrdm_1 => null; ---------------------------------------------- Read Last Data
								case DRMI2Csequence is
								when 0 => 	RAMaddrRDd <= SFPDiagLastAdd;
											SFPDiagLastAdd := SFPDiagLastAdd+"0000001";
											DRMI2Csequence := 1;
								when 1 => 	SFPDiagLast(15 downto 8) := RAMdataRD;
											RAMaddrRDd <= SFPDiagLastAdd;
											SFPDiagLastAdd := SFPDiagLastAdd-"0000001";
											DRMI2Csequence := 2;
								when 2 => 	SFPDiagLast(7 downto 0) := RAMdataRD;
											RAMaddrRDd <= SFPDiagLastAdd;
											DRMI2Csequence := 3;
								when 3=>	smSFPDT := sSFPDTrdd_2;
											DRMI2Csequence := 0;
								when others => DRMI2Csequence := 0;
                                end case;
			when sSFPDTrdd_2 => null; ----- Read New Data
								case DRMI2Csequence is
								when 0 => 	RAMaddrRDd <= SFPDiagDataAdd;
											SFPDiagDataAdd := SFPDiagDataAdd+"0000001";
											DRMI2Csequence := 1;
								when 1 => 	SFPDiagData(15 downto 8) := RAMdataRD;
											RAMaddrRDd <= SFPDiagDataAdd;
											SFPDiagDataAdd := SFPDiagDataAdd+"0000001";
											DRMI2Csequence := 2;
								when 2 => 	SFPDiagData(7 downto 0) := RAMdataRD;
											RAMaddrRDd <= SFPDiagDataAdd;
--											SFPDiagDataAdd := SFPDiagDataAdd+"0000001";
											DRMI2Csequence := 3;
								when 3=>	smSFPDT := sSFPDTcmp_3;
											DRMI2Csequence := 0;
								when others => DRMI2Csequence := 0;
                                end case;
			when sSFPDTcmp_3 => null; ----- Test and compare new and old data
								-- case SFPDiagLoopCnt is
								-- when 0 => rSFPtemp  <= SFPDiagData(14 downto 7);
								-- when 1 => rSFPvolt  <= SFPDiagData(14 downto 7);
								-- when 2 => rSFPbias  <= SFPDiagData(14 downto 7);
								-- when 3 => rSFPtxpow <= SFPDiagData(14 downto 7);
								-- when 4 => rSFPrxpow <= SFPDiagData(14 downto 7);
								-- when others => null;
								-- end case;
								case SFPDiagLoopCnt is
									when 0 => rSFPtemp  <= SFPDiagData(15 downto 8);
									when 1 => rSFPvolt  <= SFPDiagData(15 downto 8);
									when 2 => if(SFPDiagData>x"7FFF") then rSFPbias  <= X"FF"; 
											  else rSFPbias  <= SFPDiagData(14 downto 7); 
											  end if;
									when 3 => if(SFPDiagData>x"7FFF") then rSFPtxpow <= X"FF"; 
											  else rSFPtxpow <= SFPDiagData(14 downto 7); 
											  end if;
									when 4 => if(SFPDiagData>x"7FFF") then rSFPrxpow <= X"FF"; 
											  else rSFPrxpow <= SFPDiagData(14 downto 7); 
											  end if;
									when others => null;
								end case;

								if SFPDiagData=x"FFFF" then
									SFPErrorXFFflg <= '1';
									SFPDiagTestEnabOk <= '1';
									smSFPDT := sSFPDTwai_6;
								elsif SFPDiagLast/=x"0000" then
									if SFPDiagLast=SFPDiagData then
										SFPDiagFlag(SFPDiagLoopCnt) := '1';
									else
										SFPDiagFlag(SFPDiagLoopCnt) := '0';
									end if;
									smSFPDT := sSFPDTsav_7;
								else
									smSFPDT := sSFPDTsav_7;
								end if;
			when sSFPDTsav_7 => null; ----- Save new data
								case DRMI2Csequence is
								when 0 => 	RAMdataWRd <= SFPDiagData(15 downto 8);
											RAMaddrWRd <= SFPDiagLastAdd;
											RAMwrite_d <= '1';
											SFPDiagLastAdd := SFPDiagLastAdd+"0000001";
											DRMI2Csequence := 1;
								when 1 => 	RAMdataWRd <= SFPDiagData(7 downto 0);
											RAMaddrWRd <= SFPDiagLastAdd;
											RAMwrite_d <= '1';
											SFPDiagLastAdd := SFPDiagLastAdd+"0000001";
											DRMI2Csequence := 2;
								when 2 => 	RAMwrite_d <= '0';
											smSFPDT := sSFPDTlop_4;
											DRMI2Csequence := 0;
								when others => DRMI2Csequence := 0;
                                end case;
			when sSFPDTlop_4 => null; ----- Check error in loop, increase error counter, start another loop
								if SFPDiagLoopCnt=4 then
									if SFPDiagFlag="11111" then
										SFPDiagErrorCnt <= SFPDiagErrorCnt+1;
									else
										SFPDiagErrorCnt <= 0;
									end if;
									smSFPDT := sSFPDTerr_5;
								else
									SFPDiagLoopCnt := SFPDiagLoopCnt+1;
									smSFPDT := sSFPDTrdm_1;
								end if;
			when sSFPDTerr_5 => null;
								if SFPDiagErrorCnt=7 then
									SFPErrorDACflg <= '1';
									SFPDiagErrorCnt <= 0;
								end if;
								SFPDiagTestEnabOk <= '1';
								smSFPDT := sSFPDTwai_6;
			when sSFPDTwai_6 => null;
								if SFPDiagTestEnab='0' then
									SFPDiagTestEnabOk <= '0';
									smSFPDT := sSFPDTsta_0;
								end if;
			when others      => null;
			end case;
		end if;
	end if;
	end process;

	I2CRUNhandler : process(CLK)
	variable smI2CRUNhandler : integer range 0 to 6;
	begin
	if CLK'event and CLK='1' then
		if RESETn='0' then
			DRMI2Cerr       <= x"00";
			DRMI2Cactive    <=   '0';
			smI2CRUNhandler :=  0;
	else
		case smI2CRUNhandler is
		when 0 =>   if  I2CRUN='1' then ----------------------<-- Waiting I2CRUN
						smI2CRUNhandler := 1;
						DRMI2Cactive    <= '1';
					end if;
		when 1 =>   if  I2CBSY='1' then ----------------------<-- Waiting I2CBSY
						smI2CRUNhandler := 2;
					end if;
		when 2 =>   if  I2CBSY='0' then
						smI2CRUNhandler := 3;
					end if;
		when 3 =>   DRMI2Cactive     <= '0';
					if I2CERR='0' then
						smI2CRUNhandler := 5; DRMI2Cerr <= x"00";
					else
						smI2CRUNhandler := 4; DRMI2Cerr <= SFPI2Cid or FoERRM;
					end if;
		when 4 =>   if  DRMI2CerrOK='1' then
						smI2CRUNhandler := 5;
					end if;
		when 5 =>   if  I2CRUN='0' then
						smI2CRUNhandler := 0; DRMI2Cerr <= x"00";
					end if;
		when others =>  smI2CRUNhandler := 0;
		end case;
		end if;
	end if; --<-- If of the clock variations
	end process;

	RAMsignal_handler : process(FoDATA,     RAMaddrWRi, RAMaddrRDi, RAMwrite_i,
	                            RAMdataWRd, RAMaddrWRd, RAMaddrRDd, RAMwrite_d,
	                            SFPDiagTestEnab, DebugErrEn, DebugErr)
	begin
	if SFPDiagTestEnab='1' then
		RAMdataWR <= RAMdataWRd;
		RAMaddrWR <= RAMaddrWRd;
		RAMaddrRD <= RAMaddrRDd;
		RAMwrite  <= RAMwrite_d;
	else
        if DebugErrEn='1' then
            case DebugErr is
            when cDT_SFP0xFF => RAMdataWR <= x"FF";
            when cDT_SFPDAC  => if RAMaddrWRi<maSFPdiagData then 
                                    RAMdataWR <= FoDATA;
                                else    
                                    RAMdataWR <= '0' & (RAMaddrWRi and "0011111");
                                end if;
            when others      => RAMdataWR <= FoDATA;
            end case;
        else
            RAMdataWR <= FoDATA;
        end if;
		RAMaddrWR <= RAMaddrWRi;
		RAMaddrRD <= RAMaddrRDi;
		RAMwrite  <= RAMwrite_i;
	end if;
	end process;

--- 171117 --->
    SDA_Timeout_handler : process(CLK)
    variable Time_mS : integer range 0 to 1001 := 0;
    begin
    if CLK'event and CLK='1' then
        if    RESETn='0' or SCLin='1' then 
                TIMEOUT_SDA <= '0'; Time_mS := 0; 
        elsif P1mS='1' then 
            if Time_mS = 1000 then
                TIMEOUT_SDA <= '1'; Time_mS := 1000;
            else 
                TIMEOUT_SDA <= '0'; Time_mS := Time_mS+1; 
            end if;
        end if;
--        TimeOutFlag <= TIMEOUT_SDA;
    end if;
    end process;
--- 171117 <---
--- 171117 --->
    SCL_Timeout_handler : process(CLK)
    variable Time_mS : integer range 0 to 1001 := 0;
    begin
    if CLK'event and CLK='1' then
        if    RESETn='0' or SCLin='1' then 
                TIMEOUT_SCL <= '0'; Time_mS := 0; 
        elsif P1mS='1' then 
            if Time_mS = 1000 then
                TIMEOUT_SCL <= '1'; Time_mS := 1000;
            else 
                TIMEOUT_SCL <= '0'; Time_mS := Time_mS+1; 
            end if;
        end if;
--        TimeOutFlag <= TIMEOUT_SCL;
    end if;
    end process;
--- 171117 <---
--- 171117 --->
    TIMEOUTerro_handler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if    RESETn='0' or SCLin='1' then 
                TIMEOUTerror <= '0';
                TIMEOUTflag  <= '0';
        else
                TIMEOUTerror <= TIMEOUT_SCL or TIMEOUT_SDA;
                TIMEOUTflag  <= TIMEOUT_SCL or TIMEOUT_SDA;
        end if;
--        TimeOutFlag <= TIMEOUT_SCL;
    end if;
    end process;
--- 171117 <---

--- 171228 --->
    SFPI2Cid_handler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if    RESETn='0' then 
            SFPI2Cid <= x"00"; 
        else 
            case SFPI2Cadd is
			when I2CTempGBT_0     => SFPI2Cid <= x"00"; 
			when I2CTempLDOGBT_1  => SFPI2Cid <= x"10";
			when I2CTempLDOSDES_2 => SFPI2Cid <= x"20";
			when I2CTempPXL_3     => SFPI2Cid <= x"30";
			when I2CTempLDOFPGA_4 => SFPI2Cid <= x"40";
			when I2CTempIGLOO2_5  => SFPI2Cid <= x"50";
			when I2CTempVTRX_6    => SFPI2Cid <= x"60";
			when I2CSFPpage0      => SFPI2Cid <= x"70";
			when I2CSFPpage1      => SFPI2Cid <= x"70";
            when others           => null;
            end case;
        end if;
    end if;
    end process;
--- 1711228 <---

    RefreshDone_handler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if    RESETn='0' then 
             RefreshDone <= '0';
        else 
            if  RefreshDoneRST='1' then RefreshDone <= '0';
            elsif 
                RefreshDoneSET='1' then RefreshDone <= '1';
            else
                RefreshDone <= RefreshDone;
            end if;
        end if;
    end if;
    end process;

    SFPLOOP_handler : process(CLK)
    variable SFPLOOPcnt      : integer range 0 to 4010;
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then 
            SFPLOOPcnt := 0;
            SFPLOOPpls <= '0';
        else
            if P1ms='1' then
                if SFPLOOPcnt=0 then 
                    case SFPLOOP is 
                    when "000" => SFPLOOPcnt := cSFPTIME0;
                    when "001" => SFPLOOPcnt := cSFPTIME1;
                    when "010" => SFPLOOPcnt := cSFPTIME2;
                    when "011" => SFPLOOPcnt := cSFPTIME3;
                    when "100" => SFPLOOPcnt := cSFPTIME4;
                    when "101" => SFPLOOPcnt := cSFPTIME5;
                    when "110" => SFPLOOPcnt := cSFPTIME6;
                    when others=> SFPLOOPcnt := cSFPTIME7;
                    end case;
                    SFPLOOPpls <= '1'; 
                else
                    if SFPLOOP /= "111" then 
                        SFPLOOPcnt := SFPLOOPcnt-1; 
                    end if;
                end if;
            else 
                SFPLOOPpls <= '0';
            end if;
        end if;
    end if;
    end process;

end I2CSFPTEMPctrl_beh;