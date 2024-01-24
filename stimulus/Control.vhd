----------------------------------------------------------------------
-- Created by SmartDesign Tue Apr 28 21:28:23 2015
-- Version: v11.5 11.5.0.26
--      1.20150909.1535: corrette varie parti
--      1.20150911.1356: aggiunta scrittura tregistri di controllo gbtx 
--      1.20151020.1142: aggiunta procedura ShowGBTX_CTRL e altro
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;  
 use ieee.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;  
 use IEEE.std_logic_arith.all;
 use std.textio.all;
-- use ieee.std_logic_textio.all;

library smartfusion2;
 use smartfusion2.all;
----------------------------------------------------------------------
-- I2C_GBTX_tb entity declaration
----------------------------------------------------------------------
entity I2C_Control is
    -- Port list
    port(
        -- GBTX
        GBTX_ARST      : in    std_logic;
        GBTX_CONFIG    : in    std_logic;
        REFCLKSELECT   : in    std_logic; 
        STATEOVERRIDE  : in    std_logic;
        GBTX_TESTOUTf  : in    std_logic;
        GBTX_TESTOUT   : out   std_logic;
-----------------------------------------------------------------
        GBTX_MODE      : in    std_logic_vector(3 downto 0);
-----------------------------------------------------------------
        GBPS_TX_DISAB  : in    std_logic; 
        GBTX_TXDVALID  : in    std_logic;
        GBTX_RXDVALIDf : in    std_logic;
        GBTX_RXDVALID  : out   std_logic;
        GBTX_RXRDYf    : in    std_logic;
        GBTX_RXRDY     : out   std_logic;
        GBTX_TXRDYf    : in    std_logic;
        GBTX_TXRDY     : out   std_logic;
-----------------------------------------------------------------
        GBTX_SADD      : in    std_logic_vector(3 downto 0);
-----------------------------------------------------------------
        GBTX_RESETB    : in    std_logic;
-----------------------------------------------------------------
        GBTX_RXLOCKM   : in    std_logic_vector(1 downto 0);
-----------------------------------------------------------------
        GBTX_POW       : out   std_logic;
-----------------------------------------------------------------
        SYSCLK      : out std_logic;
-----------------------------------------------------------------
        FiDATA      : out std_logic_vector(7 downto 0);
        FiWE        : out std_logic;
        FoRE        : out std_logic;
        I2CRUN      : out std_logic;
        RESETn      : out std_logic;
-----------------------------------------------------------------
        FiEMPTY       : in  std_logic;
        ENVGD       : in  std_logic;
        ERROR       : in  std_logic;
        FiFULL        : in  std_logic;
        FiAEMPTY    : in  std_logic;
        FiAFULL     : in  std_logic;
        FoAEMPTY    : in  std_logic;
        FoAFULL     : in  std_logic;
        FoEMPTY     : in  std_logic;
        FoFULL      : in  std_logic;
        I2CBSY_GBTX : in  std_logic;
        I2CBSY_AUX  : in  std_logic;
        FoDATA      : in  std_logic_vector(7 downto 0)
        );
end I2C_Control;
----------------------------------------------------------------------
architecture I2C_Control_beh of I2C_Control is
----------------------------------------------------------------------
constant SYSCLK_PERIOD : time := 100 ns;

signal   SYSCLKd       : std_logic := '0';
signal   wDataByte     : std_logic_vector(7 downto 0);
signal   rDataByte     : std_logic_vector(7 downto 0);
signal   wMemAddr   : std_logic_vector(15 downto 0);
signal   rMemAddr   : std_logic_vector(15 downto 0);

signal   Filename : string(1 to 32);

signal FileLoopCmd : std_logic_vector(3 downto 0);
signal FileLoopBsy  : std_logic;

signal   GBTXCmd : std_logic_vector(7 downto 0)  := X"00";

signal  GBTXC_RegAdd  : std_logic_vector(7 downto 0);
type    GBTXC_RegDatWArray is array (0 to 30) of std_logic_vector(7 downto 0); 
signal  GBTXC_RegDatW : GBTXC_RegDatWArray;
signal  GBTXC_RegDatR : GBTXC_RegDatWArray;
signal  GBTXC_RegDNum : integer;
signal  GBTXC_String  : string (1 to 30); 

type REGarray_type is array (0 to 6) of std_logic_vector(15 downto 0);
type INAarray_type is array (0 to 12) of REGarray_type;
signal INAarray : INAarray_type; -- := 
     ---- INAR0   INAR1   INAR2   INAR3   INAR4   INAR5  I2CCTRL    ------------------------------------------
     --((X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 00  P2V5FS	Uvfs2	1000000	40	GND	GND
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 01  P1V2FS	Uvfx2	1000001	41	GND	Vs+
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 02  P2V5FE	Uvfe2	1000010	42	GND	SDA
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 03  P1V5FP	Uvfp2	1000011	43	GND	SCL
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 04  P1V5GRX	Ugr2	1000100	44	Vs+	GND
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 05  P1V5GTX	Ugt2	1000101	45	Vs+	Vs+
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 06  P1V5GD	Ugd2	1000110	46	VS+	SDA
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 07  P1V5GP	Ugp2	1000111	47	Vs+	SCL
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 08  P1V5GCK	Ugc2	1001000	48	SDA	GND
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 09  P2V5GLD	Ugl2	1001001	49	SDA	Vs+
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 10  P3V3HW	Uvh2	1001100	4C	SCL	GND
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD"),  -- 11  P3V3F	Uvf2	1001101	4D	SCL	Vs+
      --(X"AAAA",X"BBBB",X"CCCC",X"DDDD",X"EEEE",X"FFFF",X"ABCD")); -- 12  P1V2FD	Uvfd2	1001110	4E	SCL	SDA;

constant FileLoopIDLE   : std_logic_vector(3 downto 0) := "0000";
constant FileLoopSEND   : std_logic_vector(3 downto 0) := "0001";
constant FileLoopGET    : std_logic_vector(3 downto 0) := "0010";
constant FileloopREGW   : std_logic_vector(3 downto 0) := "1000";
constant FileloopREGR   : std_logic_vector(3 downto 0) := "1001";

constant cGBTX_CTRL : std_logic_vector(7 downto 0) := X"40";
constant cGBTX_MODE : std_logic_vector(7 downto 0) := X"41";
constant cGBTX_TXRX : std_logic_vector(7 downto 0) := X"42";
constant cGBTX_SADD : std_logic_vector(7 downto 0) := X"43";
constant cGBTX_RSTB : std_logic_vector(7 downto 0) := X"44";
constant cGBTX_RXLK : std_logic_vector(7 downto 0) := X"45";

constant cINA_CFGR0l : std_logic_vector(7 downto 0) := X"50"; constant cINA_CFGR0h : std_logic_vector(7 downto 0) := X"51"; -- In Out - X"0C67" INA219 CONFIG register
constant cINA_SHVR1l : std_logic_vector(7 downto 0) := X"52"; constant cINA_SHVR1h : std_logic_vector(7 downto 0) := X"53"; -- Out    -  ----   INA219 VSHUNT register
constant cINA_VBUR2l : std_logic_vector(7 downto 0) := X"54"; constant cINA_VBUR2h : std_logic_vector(7 downto 0) := X"55"; -- Out    -  ----   INA219 VBus register
constant cINA_POWR3l : std_logic_vector(7 downto 0) := X"56"; constant cINA_POWR3h : std_logic_vector(7 downto 0) := X"57"; -- Out    -  ----   INA219 POWER register
constant cINA_CURR4l : std_logic_vector(7 downto 0) := X"58"; constant cINA_CURR4h : std_logic_vector(7 downto 0) := X"59"; -- Out    -  ----   INA219 CURRENT register
constant cINA_CALR5l : std_logic_vector(7 downto 0) := X"5A"; constant cINA_CALR5h : std_logic_vector(7 downto 0) := X"5b"; -- In Out - X"1000" INA219 CALIBRATION register
constant cINA_unused : std_logic_vector(7 downto 0) := X"5C"; constant cINA_I2CERR : std_logic_vector(7 downto 0) := X"5d"; -- In Out - X"00xx" I²C read write bus
constant cINA_CTRLP  : std_logic_vector(7 downto 0) := X"5E"; constant cINA_POINT  : std_logic_vector(7 downto 0) := X"5f"; -- In Out - X"00"   INA pointer and Power Control
 
constant I2CIGLOOaddW : std_logic_vector(7 downto 0):= X"C0";
constant I2CIGLOOaddR : std_logic_vector(7 downto 0):= X"C1";

signal   StringOut    : string(1 to 20) := "....................";

function findspace(StringIn: string; Pointer: integer)  return integer is
variable Index : integer range 1 to 80;
begin

    for Index in Pointer to 80 loop
        if    StringIn(Index)=' ' then 
            return Index;
        elsif StringIn(Index)='/' then 
            return 0;   
        end if;
    end loop;

    return 0;   

end findspace;

function skipspace(StringIn: string; Pointer: integer)  return integer is
variable Index : integer range 1 to 80;
begin

    for Index in Pointer to 80 loop
        if   StringIn(Index)=' ' then 
            NULL;
        elsif StringIn(Index)='/' then 
            return 0;   
        else
            return Index;
        end if;
    end loop;

    return 0;   

end skipspace;

function slv2hstr(SIGNAL input: std_logic_vector(7 downto 0)) return string is
variable hexstring: string(1 to 2);
begin
    case input(7 downto 4) is
    when X"0"   => hexstring(1) := '0';
    when X"1"   => hexstring(1) := '1';
    when X"2"   => hexstring(1) := '2';
    when X"3"   => hexstring(1) := '3';
    when X"4"   => hexstring(1) := '4';
    when X"5"   => hexstring(1) := '5';
    when X"6"   => hexstring(1) := '6';
    when X"7"   => hexstring(1) := '7';
    when X"8"   => hexstring(1) := '8';
    when X"9"   => hexstring(1) := '9';
    when X"A"   => hexstring(1) := 'A';
    when X"B"   => hexstring(1) := 'B';
    when X"C"   => hexstring(1) := 'C';
    when X"D"   => hexstring(1) := 'D';
    when X"E"   => hexstring(1) := 'E';
    when OTHERS => hexstring(1) := 'F';
    end case;

    case input(3 downto 0) is
    when X"0"   => hexstring(2) := '0';
    when X"1"   => hexstring(2) := '1';
    when X"2"   => hexstring(2) := '2';
    when X"3"   => hexstring(2) := '3';
    when X"4"   => hexstring(2) := '4';
    when X"5"   => hexstring(2) := '5';
    when X"6"   => hexstring(2) := '6';
    when X"7"   => hexstring(2) := '7';
    when X"8"   => hexstring(2) := '8';
    when X"9"   => hexstring(2) := '9';
    when X"A"   => hexstring(2) := 'A';
    when X"B"   => hexstring(2) := 'B';
    when X"C"   => hexstring(2) := 'C';
    when X"D"   => hexstring(2) := 'D';
    when X"E"   => hexstring(2) := 'E';
    when OTHERS => hexstring(2) := 'F';
    end case;

    return hexstring;

end slv2hstr;

function hchar2slv
(input: character) 
return std_logic_vector is
variable slv_value: std_logic_vector(4 downto 0);
begin
    case input is
    when '0'    => slv_value := '0' & X"0";
    when '1'    => slv_value := '0' & X"1";
    when '2'    => slv_value := '0' & X"2";
    when '3'    => slv_value := '0' & X"3";
    when '4'    => slv_value := '0' & X"4";
    when '5'    => slv_value := '0' & X"5";
    when '6'    => slv_value := '0' & X"6";
    when '7'    => slv_value := '0' & X"7";
    when '8'    => slv_value := '0' & X"8";
    when '9'    => slv_value := '0' & X"9";
    when 'A'    => slv_value := '0' & X"A";
    when 'B'    => slv_value := '0' & X"B";
    when 'C'    => slv_value := '0' & X"C";
    when 'D'    => slv_value := '0' & X"D";
    when 'E'    => slv_value := '0' & X"E";
    when 'F'    => slv_value := '0' & X"F";
    when OTHERS => slv_value := '1' & X"0";
    end case;
    return slv_value;

end hchar2slv;

procedure WriteLOG(StringToLOG : in string) is --- 100 ns
    file vOUTfile : text;
    variable vOutLine : line;
begin
    file_open(vOutfile, "SessionLog.txt", APPEND_MODE); 
    write(vOutLine, StringToLOG);
    wait for 20 ns;
    writeline(vOutfile, vOutLine);
    wait for 20 ns;
    file_close(vOutfile);
    wait for 20 ns;
    report StringToLOG; 
    wait for 40 ns;
end WriteLOG;

procedure ShowGBTX_CTRL(Value : in std_logic_vector(7 downto 0)) is 
variable sValue : string(1 to 17);                               
begin                                                   
	sValue := "$ 0 0 0 0 0 0 0 0"; wait for 1 ns;
	if GBTX_ARST='1'      then sValue(((7-0)*2)+3) := '1'; end if;
	if GBTX_CONFIG='1'    then sValue(((7-1)*2)+3) := '1'; end if;
	if REFCLKSELECT='1'   then sValue(((7-2)*2)+3) := '1'; end if;
	if STATEOVERRIDE='1'  then sValue(((7-3)*2)+3) := '1'; end if;
	if GBTX_TESTOUTf='1' then sValue(((7-4)*2)+3) := '1'; end if;

	for i in 7 downto 5 loop
		if    Value(i)='0' then sValue(((7-i)*2)+3) := '0';  
		elsif Value(i)='1' then sValue(((7-i)*2)+3) := '1'; end if;
		wait for 1 ns;
	end loop;	
	wait for 1 ns;	
	WriteLOG("$ GBTX_CTRL, 0x40");
	WriteLOG(sValue);
	WriteLOG("$ B B B T S R C A");  
	WriteLOG("$ I I I S O E O R");  
	WriteLOG("$ T T T O V F N S");
	WriteLOG("$ 7 6 5 U E C F T");  
	WriteLOG("$       T R S I  "); 
	WriteLOG("-----------------");
	                                    
end ShowGBTX_CTRL;

procedure ShowGBTX_MODE(Value : in std_logic_vector(7 downto 0)) is 
variable sValue : string(1 to 17);                               
begin                                                   
	sValue := "$ 0 0 0 0 0 0 0 0"; wait for 1 ns;

	for i in 7 downto 0 loop
		if    Value(i)='0' then sValue(((7-i)*2)+3) := '0';  
		elsif Value(i)='1' then sValue(((7-i)*2)+3) := '1'; end if;
		wait for 1 ns;
	end loop;	
	wait for 1 ns;	
	WriteLOG("$ GBTX_MODE, 0x41");
	WriteLOG(sValue);
	WriteLOG("$ B B B B M M M M");
	WriteLOG("$ I I I I O O O O");
	WriteLOG("$ T T T T D D D D");
	WriteLOG("$ 7 6 5 4 E E E E");
	WriteLOG("$         3 2 1 0");
	WriteLOG("-----------------");
	                                    
end ShowGBTX_MODE;

procedure ShowGBTX_TXRX(Value : in std_logic_vector(7 downto 0)) is 
variable sValue : string(1 to 17);                               
begin                                                   
	sValue := "$ 0 0 0 0 0 0 0 0"; wait for 1 ns;
	if GBPS_TX_DISAB='1'   then sValue(((7-0)*2)+3) := '1'; end if;
	if GBTX_TXDVALID='1'   then sValue(((7-1)*2)+3) := '1'; end if;
	if GBTX_RXDVALIDf='1'  then sValue(((7-2)*2)+3) := '1'; end if;
	if GBTX_RXRDYf='1'     then sValue(((7-3)*2)+3) := '1'; end if;
	if GBTX_TXRDYf='1'     then sValue(((7-4)*2)+3) := '1'; end if;

	for i in 7 downto 5 loop
		if    Value(i)='0' then sValue(((7-i)*2)+3) := '0';  
		elsif Value(i)='1' then sValue(((7-i)*2)+3) := '1'; end if;
		wait for 1 ns;
	end loop;	
	wait for 1 ns;	
	WriteLOG("$ GBTX_txrx, 0x42");
	WriteLOG(sValue);
	WriteLOG("$ B B B T R R T T");
	WriteLOG("$ I I I X X X X X");
	WriteLOG("$ T T T R R D D D");
	WriteLOG("$ 7 6 5 D D V V I");
	WriteLOG("$       Y Y A A S");
	WriteLOG("-----------------");
	                                    
end ShowGBTX_TXRX;

procedure ShowGBTX_SADD(Value : in std_logic_vector(7 downto 0)) is 
variable sValue : string(1 to 17);                               
begin                                                   
	sValue := "$ 0 0 0 0 0 0 0 0"; wait for 1 ns;

	for i in 7 downto 0 loop
		if    Value(i)='0' then sValue(((7-i)*2)+3) := '0';  
		elsif Value(i)='1' then sValue(((7-i)*2)+3) := '1'; end if;
		wait for 1 ns;
	end loop;	
	wait for 1 ns;	
	WriteLOG("$ GBTX_SADD, 0x43");
	WriteLOG(sValue);
	WriteLOG("$ B B B B S S S S");
	WriteLOG("$ I I I I A A A A");
	WriteLOG("$ T T T T D D D D");
	WriteLOG("$ 7 6 5 4 D D D D");
	WriteLOG("$         3 2 1 0");
	WriteLOG("-----------------");
	                                    
end ShowGBTX_SADD;

begin
    SYSCLK <= SYSCLKd;
    SYSCLKd <= not SYSCLKd after (SYSCLK_PERIOD / 2.0 ); 

    FileLoop : process
        file vINfile : text;
        file vOUTfile : text;
        variable vInLine : line;
--      variable vOutLine : line;
        variable vInInteger : integer := 0;
        variable vInChar : character;
        variable vInString : string(1 to 80);
        variable vCounter : integer range 0 to 65535 := 1;
        variable vPointer : integer range 0 to 65535 := 1;
        variable vIndex : integer range 0 to 100 := 0;
        variable vInStringLen : integer range 0 to 100 := 0;
        variable vGoodNumber, vGoodVal : boolean;
        variable vIGLOOaddI2C : std_logic_vector(7 downto 0)  := X"C0";
        variable vParity  : integer range 0 to 255 := 0;
        variable vDataNum : integer range 0 to 65535 := 0;
        variable vMemAddr : std_logic_vector(15 downto 0) := X"FFFF";
        variable vDataByte: std_logic_vector(7 downto 0)  := X"00";
        variable vDataNibble: std_logic_vector(4 downto 0):= "00000";
        variable vWriteFlag: std_logic := '0';
        variable vFoEMPTYd: std_logic := '0';
        variable vReadDone: std_logic := '0';
        variable vRXstatus : std_logic_vector(7 downto 0)  := X"00";
    begin

    FileLoopBsy <= '0'; 
    FiDATA  <= X"00";
    FiWE    <= '0';
    FoRE    <= '0';
    I2CRUN  <= '0';
    vRXstatus   := X"FF";
    wait for 1 us;

    if FileLoopCmd=FileloopSEND then
-- S00: Open file <Filename>
        vCounter := 0;
        FileLoopBsy <= '1'; 
        wait for 1 ns;
        file_open(vInfile, Filename, READ_MODE); 
        wait for 1 ns;

-- S01: End Of File
        while not endfile(vInfile) loop

-- S02: Read line. Copy line in InString
            readline(vInfile, vInLine); wait for 1 ns;
            for i in 1 to 80 loop
                vIndex := i;
                read(vInLine, vInChar, good => vGoodNumber);
                exit when not vGoodNumber;
                vInString(i) := vInChar;
                wait for 1 ns;
            end loop;

            vInStringLen := vIndex; wait for 1 ns; -- Set string len
            
            for i in vIndex to 80 loop -- Clear the othe char of the string
                vInString(i) := character'val(0); wait for 1 ns;
                wait for 1 ns;
            end loop;

-- S03: Line begin with integer
            if vInString(1)<'0' then
                next; end if; wait for 1 ns;

            if vInString(1)>'9' then
                next; end if; wait for 1 ns;

-- S04: Get Data: 0802 11 @2300 Address R
-----------------               ^^^^^^^^^--< comment
-----------------         ^^^^^------------< timing 
-----------------      ^^------------------< DATA ***
----------------- ^^^^---------------------< line index
            vIndex := findspace(vInString, 1); wait for 1 ns;
            if vIndex=0 then NEXT; end if;  wait for 1 ns;

            vIndex := skipspace(vInString, vIndex); wait for 1 ns;
            if vIndex=0 then NEXT; end if;  wait for 1 ns;

            vDataNibble := hchar2slv(vInString(vIndex)); wait for 1 ns;
            if vDataNibble(4)='1' then next; end if;     wait for 1 ns;

            vDataByte(7 downto 4) := vDataNibble(3 downto 0);
            vIndex := vIndex+1;
            wait for 1 ns;

            vDataNibble := hchar2slv(vInString(vIndex)); wait for 1 ns;
            if vDataNibble(4)='1' then next; end if;     wait for 1 ns;

            vDataByte(3 downto 0) := vDataNibble(3 downto 0);
            wait for 1 ns;

            report "$ Incoming String: " & vInString; wait for 1 ns;

-- S05: Wait if FiFIFO is full            
            while FiFULL='1' loop exit when ERROR='1'; wait for 1 ns; end loop; -- Wait if FIFO FULL;

-- S06: Write in FiFIFO        
            FiDATA <= vDataByte; FiWE <= '1'; wait for 100 ns; FiWE <= '0'; wait for 1 ns;

-- S07: Set data stream variable
            case vCounter is
            when 0 => vIGLOOaddI2C := vDataByte;
            when 1 => GBTXCmd      <= vDataByte;
            when 2 => NULL;
            when 3 => vMemAddr(7  downto 0) := vDataByte;
            when 4 => vMemAddr(15 downto 8) := vDataByte;
            when 5 => vDataNum := conv_integer(unsigned(vDataByte));
            when 6 => vDataNum :=(conv_integer(unsigned(vDataByte))*256) + vDataNum;
            when others =>
                      vMemAddr := vMemAddr+X"0001"; 
            end case;
            wait for 1 ns;

-- S08: Counter increment
            vCounter := vCounter+1; wait for 1 ns;

-- S09: Report
            wDataByte <= vDataByte;
            wMemAddr <= vMemAddr;
            wait for 1 ns;

			WriteLog("$ --> Send I2C-GBT data: " & integer'image(vCounter) & 
					 " Write: " & slv2hstr(rDataByte) & 
                	 " @ "      & slv2hstr(wMemAddr(15 downto 8)) & slv2hstr(wMemAddr(7 downto 0)));

-- S10: I2C error
            exit when ERROR='1'; wait for 1 ns;

        END LOOP;
        wait for 1 ns;
-- S11: Exit message, end procedure
        I2CRUN <= '1'; wait for 10 ns;
--  If ERROR='1' then  ASSERT false REPORT "Write complete, WITH ERRORS"; wait for 1 ns;
--      else               ASSERT false REPORT "Write complete, no errors"; wait for 1 ns; end if;
    If ERROR='1' then  REPORT "Write complete, WITH ERRORS"; wait for 1 ns;
        else               REPORT "Write complete, no errors";   wait for 1 ns; end if;
        file_close(vInfile); wait for 1 ns;
        while FiEMPTY='0' loop exit when ERROR='1'; wait for 200 us; end loop; -- During Data TX;
        I2CRUN <= '0'; wait for 1 us;
        FileLoopBsy <= '0';    wait for 1 us; 
    elsif FileLoopCmd=FileloopGET then
-- **************** RAM READ *****************************************
-- G01: LOOP based the complete read of a pack of data from IGLOO
        FileLoopBsy <= '1'; wait for 1 ns; 
    vReadDone := '0'; wait for 10 ns;        
    while vReadDone='0' loop 
-- G02: Send Address+R
            FiDATA <= vIGLOOaddI2C or X"01"; 
            FiWE <= '1'; 
                wait for 100 ns; 
            FiWE <= '0';     
                wait for 100 ns; 
-- G03: Start load
            I2CRUN <= '1'; wait for 10 ns;
-- G04: Wait data in MASTER AUX TEST
            while I2CBSY_AUX='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- Wait for I2C I2CBSY active
            while I2CBSY_AUX='1' loop exit when ERROR='1'; wait for 10 us; end loop; -- Wait for I2C I2CBSY go down, end tra nsfert
            I2CRUN <= '0'; wait for 1 us;
-- G05: Open INCOMING file
            vCounter := 1; wait for 10 ns;
-- G06: Load data when FIFO has.
            vFoEMPTYd := FoEMPTY;
            while (vFoEMPTYd='0') loop  -- Looping I2C active;
                
            	exit when ERROR='1'; wait for 100 us; 
                    
            	wait until SYSCLKd'event and SYSCLKd='1'; wait for 20 ns;

                FoRE <= '1'; wait for 100 ns; FoRE <= '0'; wait for 100 ns;
                rDataByte <= FoDATA; wait for 10 ns;
    
-- G07: Get RXstatus.
                if  vCounter=1 then
                	vRXstatus := rDataByte; wait for 10 ns;
                    vCounter := vCounter+1; wait for 10 ns;
-- G09b: Report
					WriteLOG("& Get I2C-GBT data: " & integer'image(vCounter) & 
                			 " Read: " & slv2hstr(rDataByte) & 
                			" @ "     & slv2hstr(wMemAddr(15 downto 8)) & slv2hstr(wMemAddr(7 downto 0))); 
                        if vRXstatus=GBTXCmd then 
                            NULL; wait for 10 ns; 
                        else 
                            exit; wait for 10 ns; 
                        end if;         
                        wait for 10 ns;
-- G08: OR get data.
             	else
-- G09: Report
					WriteLOG("& Get I2C-GBT data: " & integer'image(vCounter) & 
                			 " Read: " & slv2hstr(rDataByte) & 
                			 " @ "     & slv2hstr(wMemAddr(15 downto 8)) & slv2hstr(wMemAddr(7 downto 0))); 
                   	vMemAddr := vMemAddr+X"0001"; wait for 10 ns;
                end if;
                vCounter := vCounter+1; wait for 10 ns; 
                vFoEMPTYd := FoEMPTY;   wait for 10 ns;
                vReadDone := '1'; wait for 10 ns;        
            end loop;
-- G10: Close file            
            wait for 100 us; 
        end loop;
        FileLoopBsy <= '0'; wait for 1 ns; 
    elsif FileLoopCmd=FileloopREGW then
-- **************** Register WRITE ***********************************

--      signal  GBTXC_RegAdd  : std_logic_vector(7 downto 0);
--      type    GBTXC_RegDatWArray is array (0 to 30) of std_logic_vector(7 downto 0); 
--      signal  GBTXC_RegDatW : GBTXC_RegDatWArray;
--      signal  GBTXC_RegDNum : integer;
--      signal  GBTXC_String  : string (1 to 30); 

        FileLoopBsy <= '1'; wait for 1 ns; 
        vPointer := 0; wait for 1 ns; 

        wait until SYSCLKd'event and SYSCLKd='1'; wait for 20 ns; 
        
        FiDATA <= vIGLOOaddI2C or X"00";       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        FiDATA <= GBTXC_RegAdd         ;       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;

        while vPointer<GBTXC_RegDNum loop
            FiDATA <= GBTXC_RegDatW(vPointer); FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
            vPointer := vPointer+1; wait for 100 ns;
        end loop;

        I2CRUN <= '1'; wait for 10 ns;
        while I2CBSY_AUX='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- Wait for I2C I2CBSY active
        while I2CBSY_AUX='1' loop exit when ERROR='1'; wait for 10 us; end loop; -- Wait for I2C I2CBSY go down, end tra nsfert
        I2CRUN <= '0'; wait for 1 us;

--	if    GBTXC_RegAdd(7 downto 3)="01000" then 
        WriteLOG("> Data write: " & slv2hstr(GBTXC_RegDatW(0)) & " to " & slv2hstr(GBTXC_RegAdd)); wait for 1 ns; 
--	elsif GBTXC_RegAdd(7 downto 3)="01001" then 
--		WriteLOG("> Data write: " & slv2hstr(GBTXC_RegDatW(0)) 
--                                        & slv2hstr(GBTXC_RegDatW(1)) & " to " & slv2hstr(GBTXC_RegAdd)); wait for 1 ns; 
--      end if; 

    elsif FileLoopCmd=FileloopREGR then
-- **************** Register READ ***********************************

--      signal  GBTXC_RegAdd  : std_logic_vector(7 downto 0);
--      type    GBTXC_RegDatWArray is array (0 to 30) of std_logic_vector(7 downto 0); 
--      signal  GBTXC_RegDatW : GBTXC_RegDatWArray;
--      signal  GBTXC_RegDNum : integer;
--      signal  GBTXC_String  : string (1 to 30); 

        FileLoopBsy <= '1'; wait for 1 ns; 
        vPointer := 0; wait for 1 ns; 

        wait until SYSCLKd'event and SYSCLKd='1'; wait for 20 ns; 
        FiDATA <= vIGLOOaddI2C or X"00";       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        FiDATA <= GBTXC_RegAdd         ;       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        I2CRUN <= '1'; wait for 10 ns;

        while I2CBSY_AUX='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- Wait for I2C I2CBSY active
        while I2CBSY_AUX='1' loop exit when ERROR='1'; wait for 10 us; end loop; -- Wait for I2C I2CBSY go down, end tra nsfert
        I2CRUN <= '0'; wait for 1 us;

        FiDATA <= vIGLOOaddI2C or X"01";       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        I2CRUN <= '1'; wait for 10 ns;

        wait until SYSCLKd'event and SYSCLKd='1'; wait for 20 ns; 
        while I2CBSY_AUX='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- Wait for I2C I2CBSY active
        while I2CBSY_AUX='1' loop exit when ERROR='1'; wait for 10 us; end loop; -- Wait for I2C I2CBSY go down, end tra nsfert
        I2CRUN <= '0'; wait for 1 us;

        GBTXC_RegDatR <= (0 => "00000000", others => "00000000"); wait for 1 ns;
	vPointer:=0;                             wait for 1 ns;

	while FoEMPTY='0' loop
            	wait until SYSCLKd'event and SYSCLKd='1';  wait for 20 ns;
                FoRE <= '1'; wait for 100 ns; FoRE <= '0'; wait for 100 ns;
                case vpointer is
		when 0 => GBTXC_RegDatR(0) <= FoDATA; wait for 10 ns;
		when 1 => GBTXC_RegDatR(1) <= FoDATA; wait for 10 ns;
		when others => GBTXC_RegDatR(2) <= FoDATA; wait for 10 ns;
		end case;
                vPointer := vPointer+1; wait for 10 ns;
   	end loop; wait for 10 ns;

	if    GBTXC_RegAdd(7 downto 3)="01000" then 
		WriteLOG("< Data read:  " & slv2hstr(GBTXC_RegDatR(1)) & " from " & slv2hstr(GBTXC_RegDatR(0))); wait for 1 ns; 
	elsif GBTXC_RegAdd(7 downto 3)="01001" then 
		WriteLOG("< Data read:  " & slv2hstr(GBTXC_RegDatR(1)) 
                                             & slv2hstr(GBTXC_RegDatR(2)) & " from " & slv2hstr(GBTXC_RegDatR(0))); wait for 1 ns; 
        end if; 
        
    end if;
    wait for 1 ns;    
    end process;


----##################################################################################################################################
----##################################################################################################################################

    stimulus : process
    file vINfile : text; 
    file vOUTfile : text; 
    variable vInLine : line;
    variable vOutLine : line;
    variable vCounter : integer range 0 to 65535 := 1;
--  variable vGBTXaddI2C : integer range 0 to 255 := 0;
--  variable vParity  : integer range 0 to 255 := 0;
--  variable vDataNum : integer range 0 to 65535 := 0;
    variable vMemAddr : std_logic_vector(15 downto 0) := X"FFFF";
    variable vIndexSLV: std_logic_vector(7 downto 0)  := X"00";
--  variable vDataNibble: std_logic_vector(4 downto 0):= "00000";
--  variable vWriteFlag: std_logic := '0';
--
    variable vIndex   : integer := 0;
    variable vEndLoop : integer := 0;
    variable vPTRidx  : integer := 0;
    variable vINAidx  : integer := 0;
--  variable vInStringLen : integer := 0;
--
--  variable vInLine : line;
--  variable vInInteger : integer := 0;
--  variable vInChar : character;
--  variable vInString : string(1 to 80);
--  variable vGoodNumber, vGoodVal : boolean;
--  variable vSpace : character;
    variable vReadingAddress : std_logic_vector(7 downto 0)  := X"00";
    variable sValue : string(1 to 17);                               

    begin
        RESETn  <= '0';
--      FiDATA  <= X"00";
--      FiWE    <= '0';
--      FoRE    <= '0';
--      I2CRUN  <= '0';
------------------------------
        GBTX_POW       <= '0';    
        GBTX_RXDVALID  <= '0';    
        GBTX_RXRDY     <= '0';    
        GBTX_TESTOUT   <= '0';    
        GBTX_TXRDY     <= '0';    
        Filename(1) <= ' ';
        FileLoopCmd <= FileloopIDLE;
        wait for 1 ns;
        
        wait for 1 us;
        
        RESETn <= '1';
        wait for 100us; -- Delay for INA I2C TESTING

-- Write LOG --------------------------------------------------------------
        file_open(vOutfile, "SessionLog.txt", WRITE_MODE); 
        write(vOutLine,string'("--------------- Session Log ---------------"));
        writeline(vOutfile, vOutLine);
        file_close(vOutfile);

--***************** Test control register ************
 
        WriteLOG(string'("# REGISTER ACCESS TEST"));
---------------------------------------------------------------------------
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
---- Name ---| Add.  | M/L |   Bit7    |   Bit6    |   Bit5    |   Bit4    |   Bit3    |   Bit2    |   Bit1    |   Bit0    |  Default   |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- GBTX_CTRL | X"40" | MSB | Non usati.........................|  TESTOUT  | STATEOVER | REFCLKSEL |  CONFIG   |    ARST   | "00000010" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- GBTX_MODE | X"41" | MSB | Non usati.................................... |                   GBTX_MODE                   | "xxxx0010" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- GBTX_TXRX | X"42" | MSB | Non usati........................ |  TXREADY  |  RXREADY  |  RXVALID  | TXDVALID  |  TX_DISAB | "xxx...01" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- GBTX_SADD | X"43" | MSB | Non usati.................................... |                   GBTX_SADD                   | "xxxx1000" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- GBTX_RSTB | X"44" | MSB | Non usati........................ |                       Reset Counter                       | "xxx11110" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- GBTX_RXLK | X"45" | MSB | Non usati............................................................ |     GBTX_RXLOCKM      | "xxxxxx00" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- INA_CFGR0 | X"48" | MSB |    RST    |    ...    |   BRNG    |    PG1    |    PG0    |   BADC4   |   BADC3   |   BADC2   | "00001100" |
-- INA_CFGR0 | X"48" | LSB |   BADC1   |   SADC4   |   SADC3   |   SADC2   |   SADC1   |   MODE3   |   MODE2   |   MODE1   | "01100111" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- INA_SHVR1 | X"49" | MSB |   SIGN    |   SD14    |   SD13    |   SD12    |   SD11    |   SD10    |   SD19    |   SD08    | "........" |
-- INA_SHVR1 | X"49" | LSB |   SD07    |   SD06    |   SD05    |   SD04    |   SD03    |   SD02    |   SD01    |   SD00    | "........" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- INA_VBUR2 | X"4A" | MSB |   BD12    |   BD11    |   BD10    |   BD09    |   BD08    |   BD07    |   BD06    |   BD05    | "........" |
-- INA_VBUR2 | X"4A" | LSB |   BD04    |   BD03    |   BD02    |   BD01    |   BD00    |    ...    |   CNVR    |    OVF    | "........" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- INA_POWR3 | X"4B" | MSB |   PD15    |   PD14    |   PD13    |   PD12    |   PD11    |   PD10    |   PD19    |   PD08    | "........" |
-- INA_POWR3 | X"4B" | LSB |   PD07    |   PD06    |   PD05    |   PD04    |   PD03    |   PD02    |   PD01    |   PD00    | "........" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- INA_CURR4 | X"4C" | MSB |   SIGN    |   CD14    |   CD13    |   CD12    |   CD11    |   CD10    |   CD19    |   CD08    | "........" |
-- INA_CURR4 | X"4C" | LSB |   CD07    |   CD06    |   CD05    |   CD04    |   CD03    |   CD02    |   CD01    |   CD00    | "........" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- INA_CALR5 | X"4D" | MSB |   FS14    |   FS14    |   FS13    |   FS12    |   FS11    |   FS10    |   FS19    |   FS08    | "........" |
-- INA_CALR5 | X"4D" | LSB |   FS07    |   FS06    |   FS05    |   FS04    |   FS03    |   FS02    |   FS01    |   FS00    | "........" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- INA_I2CR6 | X"4E" | MSB |                                  INAI2CERR: INA COREI2C Error                                 | "........" |
-- INA_I2CR6 | X"4E" | LSB |                                           Non usato                                           | "xxxxxxxx" |
-------------+-------+-----+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
-- INA_CTRLP | X"4F" | MSB |                                         INAPTR: INA pointer                                   | "00000000" |
-- INA_CTRLP | X"4F" | LSB |                              INAPOW: Power ON command ("O" or "S")                            | "01001111" |
-------------+-------+-----+-----------------------------------------------------------------------------------------------+------------+
--      signal  GBTXC_RegAdd  : std_logic_vector(7 downto 0);
--      type    GBTXC_RegDatWArray is array (0 to 30) of std_logic_vector(7 downto 0); 
--      signal  GBTXC_RegDatW : GBTXC_RegDatWArray;
--      signal  GBTXC_RegDNum : integer;
--      signal  GBTXC_String  : string (1 to 30); 
--
------- Register INA_CTRLP reading and power setting (CMD=X"4F")
        GBTXC_RegAdd <= cINA_CTRLP;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"EE";    wait for 1 ns; --- "S"= set power
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "------------------------------"; wait for 1 ns; WriteLOG(string'("--") & GBTXC_String);
        GBTXC_String <= "Read status of POWER          "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Enable POWER: write CTRLP     "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Check POWER: read CTRLP       "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
	wait for 180 us;
 	wait for 3 ms;
-- *******************************************************************
-- **************** POWER control *********************************POW
-- *******************************************************************
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX power reading & setting.."; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
		vEndLoop := 10;
	    while vEndLoop>0 loop
	        for vINAidx in 0 to 12 loop
			        GBTXC_RegAdd <= cINA_POINT;   wait for 1 ns;
			        GBTXC_RegDatW(0) <= conv_std_logic_vector(vINAidx, 8);   wait for 1 ns; --- Set INA pointer
			        GBTXC_RegDNum <= 1;           wait for 1 ns;
		
		            FileLoopCmd  <= FileloopREGW; wait for 1 ns;
		            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
		            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
		            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
		            wait for 20 us;
	
	        	for vPTRidx in 0 to 6 loop
			        GBTXC_RegAdd <= X"50" or conv_std_logic_vector(vPTRidx*2, 8);   wait for 1 ns; --- Set REG address pointer
			        GBTXC_RegDNum <= 1;           wait for 1 ns;
		
		            FileLoopCmd  <= FileloopREGR; wait for 1 ns;
		            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
		            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
		            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	
  			        INAarray(vINAidx)(vPTRidx)(7 downto 0) <= GBTXC_RegDatR(1); wait for 5 us;

			        GBTXC_RegAdd <= X"50" or conv_std_logic_vector((vPTRidx*2)+1, 8);   wait for 1 ns; --- Set REG address pointer
			        GBTXC_RegDNum <= 1;           wait for 1 ns;
		
		            FileLoopCmd  <= FileloopREGR; wait for 1 ns;
		            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
		            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
		            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	
  			        INAarray(vINAidx)(vPTRidx)(15 downto 8) <= GBTXC_RegDatR(1); wait for 5 us;
	        
		         end loop;
	         end loop;
	         vEndLoop := 0;

	     end loop;
--
-- *******************************************************************
-- **************** GBTX control pin *****************************CTRL
-- *******************************************************************
-- **** GBTX_CTRL register **************************************************************************************************************
------- GBTX_CTRL register first reading     
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"01";    wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        GBTXC_String <= "------------------------------"; wait for 1 ns; WriteLOG(string'("--") & GBTXC_String);
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: test bit           "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 1 ns;
	wait for 20 us;
------- AUTORESET signal settings, GBTX ARST active if '1'
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: ARTS write         "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: ARTS read          "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 1 ns;
	wait for 20 us;
------- CONFIG signal settings, GBTX CONFIG selector '0' via Slow Control, '1' via I2C
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"02";    wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: CONFIG write       "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: CONFIG read        "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 1 ns;
	wait for 20 us;
------- REFCLKSEL signal settings, '0' selects the Piggy Back crystal on the GBTX, '1 the REFCLK differential input
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"04";    wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: REFCLKSEL write    "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: REFCLKSEL read     "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 1 ns;
	wait for 20 us;
------- STATEOVERRIDE signal settings, GBTX StateOverride setting
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"08";    wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: STATEOVERRIDE write"; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: STATEOVERRIDE read "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
------- Set GBTX_CTRL at default value
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"02";    wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: default re-setting "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
------- INPUTS 
------- GBTX_TESTOUT signal reading
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: TESTOUT read '1'   "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_TESTOUT <= '1';

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: TESTOUT read '0'   "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_TESTOUT <= '0';

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
-- **** GBTX_MODE register **************************************************************************************************************
------- MODE signal settings, GBTX mode setting 
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "------------------------------"; wait for 1 ns; WriteLOG(string'("--") & GBTXC_String);
        GBTXC_String <= "GBTX_MODE: MODE write & read  "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        for vIndex in 0 to 6 loop
            GBTXC_RegAdd <= cGBTX_MODE;   wait for 1 ns;
            case vIndex is 
            when 0 => GBTXC_RegDatW(0) <= "00000000";    wait for 1 ns;
            when 1 => GBTXC_RegDatW(0) <= "00000001";    wait for 1 ns;
            when 2 => GBTXC_RegDatW(0) <= "00000010";    wait for 1 ns;
            when 3 => GBTXC_RegDatW(0) <= "00000100";    wait for 1 ns;
            when 4 => GBTXC_RegDatW(0) <= "00001000";    wait for 1 ns;
            when 5 => GBTXC_RegDatW(0) <= "00001111";    wait for 1 ns;
            when others => GBTXC_RegDatW(0) <= "00000010";    wait for 1 ns;
            end case;
            GBTXC_RegDNum <= 1;           wait for 1 ns;

            FileLoopCmd  <= FileloopREGW; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;
--------------------------------------------------------------------------        
            FileLoopCmd  <= FileloopREGR; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            ShowGBTX_MODE(GBTXC_RegDatW(0)); wait for 1 ns;
            wait for 20 us;        
        end loop;
-- **** GBTX_TXRX register **************************************************************************************************************
------- GBPS_TX_DISAB settings, VTRX disable if '1'   
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"01";    wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status read     "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status write    "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status read     "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
------- GBPS_TX_DVALID settings, data ready to trasmission via VTRX if '1'   
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"02";    wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DVALID status write   "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DVALID status read    "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
------- Set GBTX_TXRX at default value
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 1 ns;
        GBTXC_RegDatW(0) <= X"01";    wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: default re-setting "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
------- INPUTS §§§ 
------- GBTX_RXDVALID signal reading
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: RXDVALID read '1'  "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_RXDVALID <= '1';

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: RXDVALID read '0'  "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_RXDVALID <= '0';

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
------- GBTX_RXRDY signal reading
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: RXRDY read '1'     "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_RXRDY <= '1';

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: RXRDY read '0'     "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_RXRDY <= '0';

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
------- GBTX_TXRDY signal reading
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 1 ns;
        GBTXC_RegDNum <= 1;           wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: TXRDY read '1'     "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_TXRDY <= '1';

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: TXRDY read '0'     "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_TXRDY <= '0';

        FileLoopCmd  <= FileloopREGR; wait for 1 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 1 ns;
        wait for 20 us;
-- **** GBTX_SADD register **************************************************************************************************************
------- GBTX_SADD settings, this register set the GBTX I2C address   
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_SADD: GBTX I2C address RW"; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        for vIndex in 0 to 6 loop
            GBTXC_RegAdd <= cGBTX_SADD;   wait for 1 ns;
            case vIndex is 
            when 0 => GBTXC_RegDatW(0) <= "00000000";    wait for 1 ns;
            when 1 => GBTXC_RegDatW(0) <= "00000001";    wait for 1 ns;
            when 2 => GBTXC_RegDatW(0) <= "00000010";    wait for 1 ns;
            when 3 => GBTXC_RegDatW(0) <= "00000100";    wait for 1 ns;
            when 4 => GBTXC_RegDatW(0) <= "00001000";    wait for 1 ns;
            when 5 => GBTXC_RegDatW(0) <= "00001111";    wait for 1 ns;
            when others => GBTXC_RegDatW(0) <= "00001000";    wait for 1 ns;
            end case;
            GBTXC_RegDNum <= 1;           wait for 1 ns;

            FileLoopCmd  <= FileloopREGW; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;

            FileLoopCmd  <= FileloopREGR; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;        
        end loop;
-- **** GBTX_RXLK register **************************************************************************************************************
------- GBTX_RXLOCKM settings, this register sets the lock mode of the receiver
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_RXLOCKM: RX lock mode    "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
        for vIndex in 0 to 2 loop
            GBTXC_RegAdd <= cGBTX_RXLK;   wait for 1 ns;
            case vIndex is 
            when 0 => GBTXC_RegDatW(0) <= "00000000";    wait for 1 ns;
            when 1 => GBTXC_RegDatW(0) <= "00000001";    wait for 1 ns;
            when others => GBTXC_RegDatW(0) <= "00000010";    wait for 1 ns;
            end case;
            GBTXC_RegDNum <= 1;           wait for 1 ns;

            FileLoopCmd  <= FileloopREGW; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;
--------------------------------------------------------------------------        
            FileLoopCmd  <= FileloopREGR; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;        
        end loop;
--
--***** Register GBTX_RSTB **************************************************************************************************************
------- Register GBTX_RSTB test (SHORT)(CMD=X"44")
        GBTXC_RegAdd <= cGBTX_RSTB;   wait for 1 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "------------------------------"; wait for 1 ns; WriteLOG(string'("--") & GBTXC_String);
        GBTXC_String <= "GBTX_RSTB: RESET test         "; wait for 1 ns; WriteLOG(string'("+ ") & GBTXC_String);
	vIndex := 0; wait for 1 ns;
        while vIndex<7 loop
            if GBTX_RESETB='1' then
                case vIndex is 
                when 0 => GBTXC_RegDatW(0) <= "00000001";    wait for 1 ns;
                when 1 => GBTXC_RegDatW(0) <= "00000010";    wait for 1 ns;
                when 2 => GBTXC_RegDatW(0) <= "00000100";    wait for 1 ns;
                when 3 => GBTXC_RegDatW(0) <= "00001000";    wait for 1 ns;
                when 4 => GBTXC_RegDatW(0) <= "00010000";    wait for 1 ns;
                when 5 => GBTXC_RegDatW(0) <= "00010100";    wait for 1 ns;
                when others => 
                          GBTXC_RegDatW(0) <= "00000000";    wait for 1 ns;
                end case;
		vIndex := vIndex+1;
            else GBTXC_RegDatW(0) <= "00000000"; wait for 10 us;
            end if;
            GBTXC_RegDNum <= 1;           wait for 1 ns;
            FileLoopCmd  <= FileloopREGW; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;
                    
            FileLoopCmd  <= FileloopREGR; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;        
        end loop;

------- Register GBTX_RSTB test --------------------------------------------        
------- Register GBTX_RSTB test --------------------------------------------        
------- GBTX_RSTB testing (FAST)   
        GBTXC_String <= "GBTX_RSTB: RESET test         "; wait for 1 ns;
                     ----123456789012345678901234567890-----------------
        WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cGBTX_RSTB;   wait for 1 ns;
	vIndex := 0; wait for 1 ns;
        while vIndex<8 loop
            if GBTX_RESETB='1' or GBTXC_RegDatW(0)(4 downto 0)="11111" then
                case vIndex is 
                when 0 => GBTXC_RegDatW(0) <= "10000001";    wait for 1 ms;
                when 1 => GBTXC_RegDatW(0) <= "10000010";    wait for 1 ms;
                when 2 => GBTXC_RegDatW(0) <= "10000100";    wait for 1 ms;
                when 3 => GBTXC_RegDatW(0) <= "10001000";    wait for 1 ms;
                when 4 => GBTXC_RegDatW(0) <= "10010000";    wait for 1 ms;
                when 5 => GBTXC_RegDatW(0) <= "10010100";    wait for 1 ms;
                when 6 => GBTXC_RegDatW(0) <= "10011111";    
				wait for 1 ms;
                when others => 
                          GBTXC_RegDatW(0) <= "10000000";    wait for 1 ms;
                end case;
                GBTXC_RegDNum <= 1;           wait for 1 ns;
                FileLoopCmd  <= FileloopREGW; wait for 1 ns;
                while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
                FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
                while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
                wait for 20 us;
                vIndex := vIndex+1; wait for 1 ns;
            end if;
            wait for 10 us;        
            FileLoopCmd  <= FileloopREGR; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;        
        end loop;
--------------------------------------------------------------------------------------------------------------------
-- *******************************************************************
-- **************** RAM WRITE ****************************************
-- *******************************************************************
		
		wait for 10000 ms;		-- visto che i seguenti file non esistono ...
		
        Filename <= "I2CvectorsW366.txt              "; wait for 10 ns;
---------------------00000000011111111112222222222333---
---------------------12345678901234567890123456789012--- Max 32 char
        FileLoopCmd  <= FileloopSEND; wait for 1 ns;

        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read start;

        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;

        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read end;

        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;

        wait for 30 ms;

-- **************** RAM WRITE for reading **************************

        Filename <= "I2CvectorsTestSetReadPh366.txt  "; wait for 10 ns;
---------------------00000000011111111112222222222333---
---------------------12345678901234567890123456789012--- Max 32 char

        FileLoopCmd  <= FileloopSEND; wait for 1 ns;

        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read start;

        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;

        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read end;

        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;

        wait for 1 ms;  

--      while I2CBSY_GBTX='1' loop exit when ERROR='1'; 
--          wait for 250 us; 
--      end loop; -- Wait for I2C active;

-- **************** RAM READ *****************************************
    
        FileLoopCmd  <= FileloopGET; wait for 1 ns;
        
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;

        FileLoopCmd  <= FileloopIDLE; wait for 1 ns;

        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 200 us; end loop; -- During waiting file read end;

        wait for 30 ms;

--***** Register GBTX_RSTB **************************************************************************************************************
------- GBTX_RSTB testing (LONG)   
        GBTXC_String <= "GBTX_RSTB: RESET test         "; wait for 1 ns;
                     ----123456789012345678901234567890-----------------
        WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cGBTX_RSTB;   wait for 1 ns;
	vIndex := 0; wait for 1 ns;
        while vIndex<7 loop
            if GBTX_RESETB='1' and GBTXC_RegDatW(0)/="00011111" then
                case vIndex is 
                when 0 => GBTXC_RegDatW(0) <= "00000001";    wait for 1 ms;
                when 1 => GBTXC_RegDatW(0) <= "00000010";    wait for 1 ms;
                when 2 => GBTXC_RegDatW(0) <= "00000100";    wait for 1 ms;
                when 3 => GBTXC_RegDatW(0) <= "00001000";    wait for 1 ms;
                when 4 => GBTXC_RegDatW(0) <= "00010000";    wait for 1 ms;
                when 5 => GBTXC_RegDatW(0) <= "00010100";    wait for 1 ms;
                when 6 => GBTXC_RegDatW(0) <= "00011111";    
				wait for 1 ms;
                when others => 
                          GBTXC_RegDatW(0) <= "00000000";    wait for 1 ms;
                end case;
                GBTXC_RegDNum <= 1;           wait for 1 ns;
                FileLoopCmd  <= FileloopREGW; wait for 1 ns;
                while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
                FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
                while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
                wait for 50 ms;
                vIndex := vIndex+1;
            end if;
            wait for 10 us;        
            FileLoopCmd  <= FileloopREGR; wait for 1 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 1 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;        
        end loop;
------------------------------------------------------------------------------------------------------------
        if ERROR='0' then report  "END OF PROCESS"; 
        else              report  "****ERROR****"; 
        end if;


        WAIT; --- End @ 8.8 ms ~ 45S di elaborazione
    end process;
end I2C_Control_beh;
