--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File history:
--      1.20170404.1651: versioning
--      1.20170117.1655: Corretto
--      1.20170116.1534: Inseriti caratteri per SFP
--      1.20150428.1139: SFP emulator
--      1.20150428.1139: tolto PREADY
--      1.20150424.2330: Inizio
-- Description:
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all; 

entity I2CStateMachineSlaveExtAdd is
port (
        PRDATA  : in    std_logic_vector(7  downto 0);  --  APB DATA READ 
        PWDATA  : out   std_logic_vector(7  downto 0);  --  APB DATA WRITE
        PADDR   : out   std_logic_vector(8  downto 0);  --  APB ADDRESS
        PSELx   : out   std_logic;                      --  APB PSELx
        PENABLE : out   std_logic;                      --  APB ENABLE
        PWRITE  : out   std_logic;                      --  APB WRITE
--      PREADY  : in    std_logic;                      --  APB READY
        PINT    : in    std_logic;                      --  APB READY
        SLV0add: in    std_logic_vector(7  downto 0);  --  SLAVE ADDRESS
        I2CBSY  : out   std_logic;
        RESETn  : in    std_logic;
        CLK     : in    std_logic
);
end I2CStateMachineSlaveExtAdd;
architecture I2CStateMachineSlaveExtAdd_beh of    I2CStateMachineSlaveExtAdd    is
-- signal, component etc. declarations

type RAMblock_type is array (0 to 255) of std_logic_vector(7 downto 0);
signal RAMblock : RAMblock_type := (others => X"00");

signal MemAddress : integer range 0 to 255;

signal   APBsm_idx  : integer range 0 to  15;
constant cAPBsmIDLE : integer := 00;
constant cAPBsmRDDs : integer := 01;
constant cAPBsmRDDe : integer := 02;
constant cAPBsmRDDx : integer := 03;
constant cAPBsmRDSs : integer := 04;
constant cAPBsmRDSe : integer := 05;
constant cAPBsmRDSx : integer := 06;
constant cAPBsmWRDs : integer := 07;
constant cAPBsmWRDe : integer := 08;
constant cAPBsmWRDx : integer := 09;
constant cAPBsmWRCs : integer := 10;
constant cAPBsmWRCe : integer := 11;
constant cAPBsmWRCx : integer := 12;
constant cAPBsmDEBG : integer := 13;

signal    INTsm_idx   : integer range 0 to 3 := 0;
constant cINTsmREAD   : integer := 00;
constant cINTsmREADW  : integer := 01;
constant cINTsmSTATUS : integer := 02;
constant cINTsmWRITEw : integer := 03;

Constant aI2C_addr0 : std_logic_vector(8 downto 0) := '0' & X"0C";
Constant aI2C_ctrl  : std_logic_vector(8 downto 0) := "000000000";
Constant aI2C_data  : std_logic_vector(8 downto 0) := '0' & X"08";
Constant aI2C_stat  : std_logic_vector(8 downto 0) := '0' & X"04";

Constant cSTmDRxA_50	: std_logic_vector(7 downto 0) := X"50";
Constant cSTmDRxNA_58	: std_logic_vector(7 downto 0) := X"58";
Constant cSTmDTxA_28	: std_logic_vector(7 downto 0) := X"28";
Constant cST_Idle_F8	: std_logic_vector(7 downto 0) := X"F8";
Constant cSTmReSta_10	: std_logic_vector(7 downto 0) := X"10";
Constant cSTmSLARA_40	: std_logic_vector(7 downto 0) := X"40";
Constant cSTmSLAWA_18	: std_logic_vector(7 downto 0) := X"18";
Constant cSTmStart_08	: std_logic_vector(7 downto 0) := X"08";
Constant cSTmStop_E0  	: std_logic_vector(7 downto 0) := X"E0";
Constant cSTsSLAWA_60	: std_logic_vector(7 downto 0) := X"60";
Constant cSTsSLARA_A8	: std_logic_vector(7 downto 0) := X"A8";
Constant cSTsStop_A0	: std_logic_vector(7 downto 0) := X"A0";
Constant cSTsDRxA_80	: std_logic_vector(7 downto 0) := X"80";
Constant cSTsDRxNA_88	: std_logic_vector(7 downto 0) := X"88";
Constant cSTsDTxA_B8	: std_logic_vector(7 downto 0) := X"B8";
Constant cSTsDTxNA_C0	: std_logic_vector(7 downto 0) := X"C0";

signal SLAVE0sm : integer range 0 to 3;
constant cSLVADDs : integer range 0 to 3 := 0; 
constant cSLVADDe : integer range 0 to 3 := 1;
constant cSLVADDx : integer range 0 to 3 := 2;
constant cSLVADDi : integer range 0 to 3 := 3; -- Idle, end of SLVADD setup 

---+----------------------------------------------------------------------------------+
-- |                                     CONSTANTS                                    |
---+------------------------------------------------------------------+-+-+-+-+-+-+-+-+
-- |                                                                  |c|e|s|s|s|a|c|c|
-- |                                                                  |r|n|t|t|i|a|r|r|
-- |                                                                  |2|s|a|o| | |1|0|
---+------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_ClearI2C_00 : std_logic_vector(7 downto 0) := X"00";  --|0|0|0|0|0|0|0|0| 
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_StarcST60 : std_logic_vector(7 downto 0)   := X"60";  --|0|1|1|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_ReStart_60  : std_logic_vector(7 downto 0) := X"60";  --|0|1|1|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxAddW_40   : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxAddR_40   : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxDATA_40   : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxDAck_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxEnab_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxWait_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxDAckN_40  : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_StopI2C_50  : std_logic_vector(7 downto 0) := X"50";  --|0|1|0|1|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
signal PCTRL    : std_logic_vector(7 downto 0);
signal PDATAW   : std_logic_vector(7 downto 0);
signal PDATAR   : std_logic_vector(7 downto 0);
signal PSTATUS  : std_logic_vector(7 downto 0);
signal PREADen  : std_logic;
signal PWRITEen : std_logic;
signal I2CCLEAR   : std_logic;
--
signal PBUSY : std_logic;
--
--xnal FREADd  : std_logic;
--xnal FREADo  : std_logic;
--x
--xnal FWRITEd : std_logic;
--xnal FWRITEo : std_logic;
--x
--xnal ERRORo  : std_logic;
--
signal I2CBSYo : std_logic;
--
signal I2CRUN  : std_logic;
--
signal I2CRUNd : std_logic;
signal I2CRUNoff : std_logic;
--
signal FiEPTYd : std_logic;
--
signal DataCnt : std_logic_vector(8 downto 0);
--xnal DataNum : std_logic_vector(8 downto 0);
--
signal DataMod : std_logic_vector(7 downto 0);

begin

    OutPinHandler : process(CLK)
    begin
        if RESETn='0' then
--x         FREAD   <= '0';
--x         FREADd  <= '0';
            I2CBSY  <= '0';
--x         ERROR   <= '0';
--x         FWRITE  <= '0';
--x         FWRITEd <= '0';
        elsif CLK'event and CLK='1' then
            I2CBSY <= I2CBSYo;
--x         ERROR  <= ERRORo;
--x         FREADd <= FREADo;
--x         FREAD  <= FREADo and not FREADd;
--x         FWRITEd <= FWRITEo;
--x         FWRITE  <= FWRITEo and not FWRITEd;
        end if;
    end process;

--x I2CRUNHandler : process(CLK)
--x begin
--x     if RESETn='0' then
--x         FiRESET   <= '1';
--x         FoRESET   <= '1';
--x         I2CRUNd   <= '0';
--x         I2CRUNoff <= '0';
--x     elsif CLK'event and CLK='1' then
--x         if I2CRUN='0' and I2CRUNd='1' then FiRESET <= '1'; else FiRESET <= '0'; end if; -- I2CRUN va a 0 RESET FIFO IN
--x         if I2CRUN='1' and I2CRUNd='0' then FoRESET <= '1'; else FoRESET <= '0'; end if; -- I2CRUN va a 1 RESET FIFO OUT
--x         I2CRUNd <= I2CRUN;
--x         I2CRUNoff <= I2CRUNd and not I2CRUN and I2CBSYo and not ERRORo; -- I2CRUNoff attiva lo stop sul fronte di discesa di I2CRUN SE I2CBSYo='1' e non ERRORoe.
--x     end if;
--x end process;

    I2C_StateMachine : process(CLK)
    variable vRDflag  : std_logic;
    variable vBlkAddr : std_logic_vector(7 downto 0); -- Original GBTX address
--  variable vCounter : integer range 0 to 3;
--  variable DataNum : std_logic_vector(15 downto 0); -- Number    of data to send, byte 2 & 3 of data group
    begin
        if RESETn='0' then
            INTsm_idx <= cINTsmREAD;
            DataCnt <= "000000000"; 
--x         DataNum <= "000000000";
--x         FREADo  <= '0'; FWRITEo  <= '0';
            PREADen <= '0'; PWRITEen <= '0';
            PDATAW  <= X"00";
            I2CCLEAR <= '1';
--x         ERRORo  <= '0';
--x         FiEPTYd <= '0';
            I2CBSYo <= '0';
--x         I2Cflg  <= '0';
            I2CRUN  <= '0';
            PCTRL   <= X"00";
			DataMod <= X"00";

-- Data are the SLV0 address or-ed with the register address... Reg(0) contains the actual I2C SLV0 address
			RAMblock(0)   <= x"00";
			RAMblock(1)   <= x"01";
			RAMblock(2)   <= x"02";
			RAMblock(3)   <= x"03";
			RAMblock(4)   <= x"04";
			RAMblock(5)   <= x"05";
			RAMblock(6)   <= x"06";
			RAMblock(7)   <= x"07";
			RAMblock(8)   <= x"08";
			RAMblock(9)   <= x"09";
			RAMblock(10)  <= x"0A";
			RAMblock(11)  <= x"0B";
			RAMblock(12)  <= x"0C";
			RAMblock(13)  <= x"0D";
			RAMblock(14)  <= x"0E";
			RAMblock(15)  <= x"0F";
			RAMblock(16)  <= x"10";
			RAMblock(17)  <= x"11";
			RAMblock(18)  <= x"12";
			RAMblock(19)  <= x"13"; --------------------- Vendor name ------------
			RAMblock(20)  <= x"46"; --- 'F' -- Carattere 01
			RAMblock(21)  <= x"69"; --- 'i' -- Carattere 02
			RAMblock(22)  <= x"6E"; --- 'n' -- Carattere 03
			RAMblock(23)  <= x"69"; --- 'i' -- Carattere 04
			RAMblock(24)  <= x"53"; --- 'S' -- Carattere 05
			RAMblock(25)  <= x"61"; --- 'a' -- Carattere 06
			RAMblock(26)  <= x"72"; --- 'r' -- Carattere 07
			RAMblock(27)  <= x"2E"; --- '.' -- Carattere 08
			RAMblock(28)  <= x"2E"; --- '.' -- Carattere 09
			RAMblock(29)  <= x"2E"; --- '.' -- Carattere 10
			RAMblock(30)  <= x"2E"; --- '.' -- Carattere 11
			RAMblock(31)  <= x"2E"; --- '.' -- Carattere 12
			RAMblock(32)  <= x"2E"; --- '.' -- Carattere 13
			RAMblock(33)  <= x"2E"; --- '.' -- Carattere 14
			RAMblock(34)  <= x"79"; --- 'y' -- Carattere 15
			RAMblock(35)  <= x"78"; --- 'x' -- Carattere 16
			RAMblock(36)  <= x"24";
			RAMblock(37)  <= x"25";
			RAMblock(38)  <= x"26";
			RAMblock(39)  <= x"27"; --------------------- Vendor part number -----
			RAMblock(40)  <= x"46"; --- 'F' -- Carattere 01
			RAMblock(41)  <= x"54"; --- 'T' -- Carattere 02
			RAMblock(42)  <= x"4C"; --- 'L' -- Carattere 03
			RAMblock(43)  <= x"46"; --- 'F' -- Carattere 04
			RAMblock(44)  <= x"38"; --- '8' -- Carattere 05
			RAMblock(45)  <= x"35"; --- '5' -- Carattere 06
			RAMblock(46)  <= x"32"; --- '2' -- Carattere 07
			RAMblock(47)  <= x"34"; --- '4' -- Carattere 08
			RAMblock(48)  <= x"50"; --- 'P' -- Carattere 09
			RAMblock(49)  <= x"32"; --- '2' -- Carattere 10
			RAMblock(50)  <= x"42"; --- 'B' -- Carattere 11
			RAMblock(51)  <= x"4E"; --- 'N' -- Carattere 12
			RAMblock(52)  <= x"4C"; --- 'L' -- Carattere 13
			RAMblock(53)  <= x"2E"; --- '.' -- Carattere 14
			RAMblock(54)  <= x"79"; --- 'y' -- Carattere 15
			RAMblock(55)  <= x"78"; --- 'x' -- Carattere 16
			RAMblock(56)  <= x"38";
			RAMblock(57)  <= x"39";
			RAMblock(58)  <= x"3A";
			RAMblock(59)  <= x"3B";
			RAMblock(60)  <= x"3C";
			RAMblock(61)  <= x"3D";
			RAMblock(62)  <= x"3E";
			RAMblock(63)  <= x"4C";  --- Checksum base
			RAMblock(64)  <= x"40";
			RAMblock(65)  <= x"41";
			RAMblock(66)  <= x"42";
			RAMblock(67)  <= x"43"; --------------------- Vendor serial number----
			RAMblock(68)  <= x"41"; --- 'A' --- Carattere 01
			RAMblock(69)  <= x"42"; --- 'B' --- Carattere 02
			RAMblock(70)  <= x"43"; --- 'C' --- Carattere 03
			RAMblock(71)  <= x"44"; --- 'D' --- Carattere 04
			RAMblock(72)  <= x"45"; --- 'E' --- Carattere 05
			RAMblock(73)  <= x"46"; --- 'F' --- Carattere 06
			RAMblock(74)  <= x"31"; --- '1' --- Carattere 07
			RAMblock(75)  <= x"32"; --- '2' --- Carattere 08
			RAMblock(76)  <= x"33"; --- '3' --- Carattere 09
			RAMblock(77)  <= x"34"; --- '4' --- Carattere 10
			RAMblock(78)  <= x"35"; --- '5' --- Carattere 11
			RAMblock(79)  <= x"2E"; --- '.' --- Carattere 12
			RAMblock(80)  <= x"2E"; --- '.' --- Carattere 13
			RAMblock(81)  <= x"2E"; --- '.' --- Carattere 14
			RAMblock(82)  <= x"79"; --- 'y' --- Carattere 15
			RAMblock(83)  <= x"78"; --- 'x' --- Carattere 16
			RAMblock(84)  <= x"32"; --- '2' --- Carattere 01 -- Manuf. data
			RAMblock(85)  <= x"30"; --- '0' --- Carattere 02
			RAMblock(86)  <= x"31"; --- '1' --- Carattere 03
			RAMblock(87)  <= x"31"; --- '1' --- Carattere 04
			RAMblock(88)  <= x"30"; --- '0' --- Carattere 05
			RAMblock(89)  <= x"31"; --- '1' --- Carattere 06
			RAMblock(90)  <= x"32"; --- '2' --- Carattere 07
			RAMblock(91)  <= x"33"; --- '3' --- Carattere 08
			RAMblock(92)  <= x"5C";
			RAMblock(93)  <= x"5D";
			RAMblock(94)  <= x"5E";
			RAMblock(95)  <= x"B6"; --- Checksum Ext
			RAMblock(96)  <= x"10";
			RAMblock(97)  <= x"10";
			RAMblock(98)  <= x"20";
			RAMblock(99)  <= x"30";
			RAMblock(100) <= x"30";
			RAMblock(101) <= x"30";
			RAMblock(102) <= x"40";
			RAMblock(103) <= x"40";
			RAMblock(104) <= x"50";
			RAMblock(105) <= x"50";
			RAMblock(106) <= x"6A";
			RAMblock(107) <= x"6B";
			RAMblock(108) <= x"6C";
			RAMblock(109) <= x"6D";
			RAMblock(110) <= x"6E";
			RAMblock(111) <= x"6F";
			RAMblock(112) <= x"70";
			RAMblock(113) <= x"71";
			RAMblock(114) <= x"72";
			RAMblock(115) <= x"73";
			RAMblock(116) <= x"74";
			RAMblock(117) <= x"75";
			RAMblock(118) <= x"76";
			RAMblock(119) <= x"77";
			RAMblock(120) <= x"78";
			RAMblock(121) <= x"79";
			RAMblock(122) <= x"7A";
			RAMblock(123) <= x"7B";
			RAMblock(124) <= x"7C";
			RAMblock(125) <= x"7D";
			RAMblock(126) <= x"7E";
			RAMblock(127) <= x"7F";
			RAMblock(128) <= x"80";
			RAMblock(129) <= x"81";
			RAMblock(130) <= x"82";
			RAMblock(131) <= x"83";
			RAMblock(132) <= x"84";
			RAMblock(133) <= x"85";
			RAMblock(134) <= x"86";
			RAMblock(135) <= x"87";
			RAMblock(136) <= x"88";
			RAMblock(137) <= x"89";
			RAMblock(138) <= x"8A";
			RAMblock(139) <= x"8B";
			RAMblock(140) <= x"8C";
			RAMblock(141) <= x"8D";
			RAMblock(142) <= x"8E";
			RAMblock(143) <= x"8F";
			RAMblock(144) <= x"90";
			RAMblock(145) <= x"91";
			RAMblock(146) <= x"92";
			RAMblock(147) <= x"93";
			RAMblock(148) <= x"94";
			RAMblock(149) <= x"95";
			RAMblock(150) <= x"96";
			RAMblock(151) <= x"97";
			RAMblock(152) <= x"98";
			RAMblock(153) <= x"99";
			RAMblock(154) <= x"9A";
			RAMblock(155) <= x"9B";
			RAMblock(156) <= x"9C";
			RAMblock(157) <= x"9D";
			RAMblock(158) <= x"9E";
			RAMblock(159) <= x"9F";
			RAMblock(160) <= x"A0";
			RAMblock(161) <= x"A1";
			RAMblock(162) <= x"A2";
			RAMblock(163) <= x"A3";
			RAMblock(164) <= x"A4";
			RAMblock(165) <= x"A5";
			RAMblock(166) <= x"A6";
			RAMblock(167) <= x"A7";
			RAMblock(168) <= x"A8";
			RAMblock(169) <= x"A9";
			RAMblock(170) <= x"AA";
			RAMblock(171) <= x"AB";
			RAMblock(172) <= x"AC";
			RAMblock(173) <= x"AD";
			RAMblock(174) <= x"AE";
			RAMblock(175) <= x"AF";
			RAMblock(176) <= x"B0";
			RAMblock(177) <= x"B1";
			RAMblock(178) <= x"B2";
			RAMblock(179) <= x"B3";
			RAMblock(180) <= x"B4";
			RAMblock(181) <= x"B5";
			RAMblock(182) <= x"B6";
			RAMblock(183) <= x"B7";
			RAMblock(184) <= x"B8";
			RAMblock(185) <= x"B9";
			RAMblock(186) <= x"BA";
			RAMblock(187) <= x"BB";
			RAMblock(188) <= x"BC";
			RAMblock(189) <= x"BD";
			RAMblock(190) <= x"BE";
			RAMblock(191) <= x"BF";
			RAMblock(192) <= x"C0";
			RAMblock(193) <= x"C1";
			RAMblock(194) <= x"C2";
			RAMblock(195) <= x"C3";
			RAMblock(196) <= x"C4";
			RAMblock(197) <= x"C5";
			RAMblock(198) <= x"C6";
			RAMblock(199) <= x"C7";
			RAMblock(200) <= x"C8";
			RAMblock(201) <= x"C9";
			RAMblock(202) <= x"CA";
			RAMblock(203) <= x"CB";
			RAMblock(204) <= x"CC";
			RAMblock(205) <= x"CD";
			RAMblock(206) <= x"CE";
			RAMblock(207) <= x"CF";
			RAMblock(208) <= x"D0";
			RAMblock(209) <= x"D1";
			RAMblock(210) <= x"D2";
			RAMblock(211) <= x"D3";
			RAMblock(212) <= x"D4";
			RAMblock(213) <= x"D5";
			RAMblock(214) <= x"D6";
			RAMblock(215) <= x"D7";
			RAMblock(216) <= x"D8";
			RAMblock(217) <= x"D9";
			RAMblock(218) <= x"DA";
			RAMblock(219) <= x"DB";
			RAMblock(220) <= x"DC";
			RAMblock(221) <= x"DD";
			RAMblock(222) <= x"DE";
			RAMblock(223) <= x"DF";
			RAMblock(224) <= x"E0";
			RAMblock(225) <= x"E1";
			RAMblock(226) <= x"E2";
			RAMblock(227) <= x"E3";
			RAMblock(228) <= x"E4";
			RAMblock(229) <= x"E5";
			RAMblock(230) <= x"E6";
			RAMblock(231) <= x"E7";
			RAMblock(232) <= x"E8";
			RAMblock(233) <= x"E9";
			RAMblock(234) <= x"EA";
			RAMblock(235) <= x"EB";
			RAMblock(236) <= x"EC";
			RAMblock(237) <= x"ED";
			RAMblock(238) <= x"EE";
			RAMblock(239) <= x"EF";
			RAMblock(240) <= x"F0";
			RAMblock(241) <= x"F1";
			RAMblock(242) <= x"F2";
			RAMblock(243) <= x"F3";
			RAMblock(244) <= x"F4";
			RAMblock(245) <= x"F5";
			RAMblock(246) <= x"F6";
			RAMblock(247) <= x"F7";
			RAMblock(248) <= x"F8";
			RAMblock(249) <= x"F9";
			RAMblock(250) <= x"FA";
			RAMblock(251) <= x"FB";
			RAMblock(252) <= x"FC";
			RAMblock(253) <= x"FD";
			RAMblock(254) <= x"FE";
			RAMblock(255) <= x"FF";
		elsif CLK'event and CLK='1' then
            if PWRITEen='1' and PBUSY='1' then PWRITEen <= '0'; end if;
            if PREADen='1'  and PBUSY='1' then PREADen  <= '0'; end if;
--------------------------------------------------------------------------------------------------------------------------------------
            if I2CCLEAR='1' then
                PCTRL <= cI2C_ClearI2C_00;
                PWRITEen <= '1';
                I2CCLEAR <= '0';
                I2CRUN   <= '1'; 
--------------------------------------------------------------------------------------------------------------------------------------
            elsif I2CRUN='1' then
--x             I2CEND <= I2CRUN;
                PCTRL <= cI2C_RxEnab_44;
                PWRITEen <= '1';
                I2CRUN <= '0';
--x-----------------------------------------------------------------------------------------------------------------------------------
--x         elsif I2CRUN='1' and I2CBSYo='0' then
--x             PCTRL <= cI2C_StarcST60;
--x             PWRITEen <= '1';
--x             I2CBSYo  <= '1';
--x             FREADo   <= '1';
--x             FiEPTYd  <= '0';
--x             vRDflag  := '0';
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
            elsif PINT='1' and PBUSY='0' then -- and I2CBSYo='1' then
                case INTsm_idx is
                when cINTsmREAD   =>
                    PREADen <= '1';
                    INTsm_idx <= cINTsmREADW;
--x                 FREADo  <= '0';
--x                 FWRITEo <= '0';
                when cINTsmREADW  =>
                    INTsm_idx <= cINTsmSTATUS; --<-- Delay
                when cINTsmSTATUS =>
                    case PSTATUS is
--------------------------------------------------------------------------------------------------------------------------------------
------------------- Own SLA + W has been received; ACK has been returned. Address valid, Write flag (data receiver) ------------------
                    when cSTsSLAWA_60 =>  PCTRL <= cI2C_RxDAck_44;                    ----- Set data byte will be received
                                                    PWRITEen <= '1';                  ----- ACK will be returned
                                                    I2CBSYo   <= '1';
                                                    DataCnt <= "000000001";           --<C> Set data counter
--------------------------------------------------------------------------------------------------------------------------------------
------------------- Previously addressed with own SLV address; DATA has been received; ACK returned Data received to put in memory ---
                    when cSTsDRxA_80  =>  case DataCnt is
                                                    when "000000001" => MemAddress <= conv_integer(PDATAR);
                                                    when "000000010" => RAMblock(MemAddress+1) <= PDATAR; -- MSB in MEMaddress+1
                                                    when "000000011" => RAMblock(MemAddress)   <= PDATAR; -- LSB in MEMaddress
                                                    when others      => RAMblock(MemAddress)   <= PDATAR; -- LSB in MEMaddress
                                                    end case;
                                                    PCTRL <= cI2C_RxDAck_44;                    ----- Set data byte will be received
                                                    PWRITEen <= '1';                            ----- ACK will be returned 
                                                    DataCnt <= DataCnt + "000000001";
--------------------------------------------------------------------------------------------------------------------------------------
------------------ Own SLA + R has been received; ACK has been returned. Address valid (data trasmitter) -----------------------------
                    when cSTsSLARA_A8 =>  if MemAddress > 95 then PDATAW <= RAMblock(MemAddress) or DataMod; 
                                          else                    PDATAW <= RAMblock(MemAddress); 
                                          end if;
                                                    PCTRL <= cI2C_RxEnab_44;                    ----- Set data byte trasmitting phase
                                                    PWRITEen <= '1';                            ----- With ACK
                                                    I2CBSYo   <= '1';
													MemAddress <= MemAddress+1;
                                                    DataCnt <= "000000001"; 
													if DataMod=x"0F" then DataMod <= x"00";
													else                  DataMod <= DataMod + x"01";
													end if;
--------------------------------------------------------------------------------------------------------------------------------------
------------------ Data byte has been transmitted; ACK has been received. Address valid, Read flag (data trasmitter) -----------------
                    when cSTsDTxA_B8  =>  if MemAddress > 95 then PDATAW <= RAMblock(MemAddress) or DataMod; 
                                          else                    PDATAW <= RAMblock(MemAddress); 
                                          end if;
                                                    PCTRL <= cI2C_RxEnab_44;                    ----- Set data byte trasmitting phase
                                                    PWRITEen <= '1';                            ----- With ACK
                                                    I2CBSYo   <= '1';
													MemAddress <= MemAddress+1;
                                                    DataCnt <= DataCnt + "000000001";
													if DataMod=x"0F" then DataMod <= x"00";
													else                  DataMod <= DataMod + x"01";
													end if;
--------------------------------------------------------------------------------------------------------------------------------------
------------------- A STOP condition or repeated START condition has been received. --------------------------------------------------
                    when cSTsStop_A0 | cSTsDTxNA_C0
                                                =>  NULL; -- I2CCLEAR <= '1';
                                                    PCTRL <= cI2C_RxEnab_44;                    ----- Set data byte restarting
                                                    PWRITEen <= '1';                            ----- With ACK
                                                    I2CBSYo   <= '0';
--------------------------------------------------------------------------------------------------------------------------------------
------------------- Error condition --------------------------------------------------------------------------------------------------
                    when others                 =>  I2CCLEAR <= '1';
                                                    I2CBSYo   <= '0';
                    end case;
--------------------------------------------------------------------------------------------------------------------------------------
                    INTsm_idx <= cINTsmWRITEw; --<-- Delay
--------------------------------------------------------------------------------------------------- -----------------------------------
                when others       =>                INTsm_idx <= cINTsmREAD;
                end case;
            end if;
        end if;
    end process;

----------------------------------------------------------------------------------------------------------------
    APB_StateMachine : process(CLK)
    begin
        if RESETn='0' then
            APBsm_idx <= cAPBsmIDLE;
            PSELx     <= '1';
            PENABLE   <= '0';
            PWRITE    <= '0';
            PWDATA    <= X"00";
            PDATAR    <= X"00";
            PBUSY     <= '0';
            SLAVE0sm   <= cSLVADDs;
        elsif CLK'event and CLK='1' then
            case SLAVE0sm is
            when cSLVADDs => PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_addr0; SLAVE0sm <= cSLVADDe; PWDATA <= SLV0add; 
            when cSLVADDe => PSELx <= '1'; PENABLE <= '1'; PWRITE <= '1'; PADDR <= aI2C_addr0; SLAVE0sm <= cSLVADDx; PWDATA <= SLV0add; 
            when cSLVADDx => PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_addr0; SLAVE0sm <= cSLVADDi; PWDATA <= SLV0add; 
            when others => 
                case APBsm_idx is
                when cAPBsmIDLE     =>  if    PREADen ='1' then PBUSY <= '1'; APBsm_idx <= cAPBsmRDDs; 
                                        elsif PWRITEen='1' then PBUSY <= '1'; APBsm_idx <= cAPBsmWRDs; 
                                        else                    PBUSY <= '0'; end if;
                when cAPBsmRDDs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_data; APBsm_idx <= cAPBsmRDDe;
                when cAPBsmRDDe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '0'; PADDR <= aI2C_data; APBsm_idx <= cAPBsmRDDx;
                when cAPBsmRDDx     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_data; APBsm_idx <= cAPBsmRDSs; PDATAR  <= PRDATA;
                when cAPBsmRDSs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_stat; APBsm_idx <= cAPBsmRDSe;
                when cAPBsmRDSe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '0'; PADDR <= aI2C_stat; APBsm_idx <= cAPBsmRDSx;
                when cAPBsmRDSx     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_stat; APBsm_idx <= cAPBsmDEBG; PSTATUS <= PRDATA;
                when cAPBsmWRDs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_data; APBsm_idx <= cAPBsmWRDe; PWDATA <= PDATAW;
                when cAPBsmWRDe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '1'; PADDR <= aI2C_data; APBsm_idx <= cAPBsmWRDx;
                when cAPBsmWRDx     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_data; APBsm_idx <= cAPBsmWRCs;
                when cAPBsmWRCs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_ctrl; APBsm_idx <= cAPBsmWRCe; PWDATA <= PCTRL;
                when cAPBsmWRCe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '1'; PADDR <= aI2C_ctrl; APBsm_idx <= cAPBsmWRCx;
                when cAPBsmWRCx     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_ctrl; APBsm_idx <= cAPBsmDEBG;
                when cAPBsmDEBG     =>                                                                   APBsm_idx <= cAPBsmIDLE;
                when others         =>                                                                   APBsm_idx <= cAPBsmIDLE;
                end case;
            end case;
        end if;
    end process;
end I2CStateMachineSlaveExtAdd_beh;
