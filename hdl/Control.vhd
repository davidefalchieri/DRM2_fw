----------------------------------------------------------------------
-- Created by SmartDesign Tue Apr 28 21:28:23 2015
-- Version: v11.5 11.5.0.26
--      1.20171104.1515: Modificata sequenza: GBTX wWR1, GBTX WR20, GBTX WR366...
--      1.20170802.1515: Modificata sequenza: GBTX wWR1, GBTX WR20, GBTX WR366...
--      1.20170713.1641: Aggiornato
--      1.20170404.1641: Aggiornato
--      1.20150909.1535: corrette varie parti
--      1.20150911.1356: aggiunta scrittura tregistri di controllo gbtx 
----------------------------------------------------------------------
--- **** Write one GBTX registers - SIM 01 *************************************
--- **** Read one GBTX registers - SIM 02 **************************************
--- **** Write 20 GBTX registers - SIM 03 **************************************
--- **** Read 20 GBTX registers - SIM 04 ***************************************
--- **** Write 366 GBTX registers - SIM 05 *************************************
--- **** Read 366 GBTX registers  - SIM 06 *************************************
--- **** Errors test SIM 07 ****************************************************
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
        --
        DataIn_1       : in    std_logic_vector(7 downto 0);
        DataIn_2       : in    std_logic_vector(7 downto 0);
        Control_1    : in    std_logic;

-----------------------------------------------------------------
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
--      SYSCLK2     : out std_logic;
-----------------------------------------------------------------
        FiDATA      : out std_logic_vector(7 downto 0);
        FiWE        : out std_logic;
        FoRE        : out std_logic;
        I2CRUN      : out std_logic;
        RESETn      : out std_logic;

-----------------------------------------------------------------
        PXL_OFF	    :	in	std_logic;
        PXL_SDN	    :	out	std_logic;
        SERDES_SDN	:	in	std_logic;
        PSM_SP0	    :	out	std_logic;
        PSM_SP1	    :	out	std_logic;
        PSM_SI	    :	in	std_logic;
        PSM_SO	    :	out	std_logic;
        PSM_SCK	    :	out	std_logic;
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

constant CHAR_b : std_logic_vector(7 downto 0) := x"62";
constant CHAR_d : std_logic_vector(7 downto 0) := x"64";
constant CHAR_e : std_logic_vector(7 downto 0) := x"65";
constant CHAR_p : std_logic_vector(7 downto 0) := x"70";
constant CHAR_q : std_logic_vector(7 downto 0) := x"71";
constant CHAR_r : std_logic_vector(7 downto 0) := x"72";
constant CHAR_s : std_logic_vector(7 downto 0) := x"73";
constant CHAR_w : std_logic_vector(7 downto 0) := x"77";
constant CHAR_x : std_logic_vector(7 downto 0) := x"78";

signal   SYSCLKd       : std_logic := '0';
--gnal   SYSCLK2d      : std_logic := '0';
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
signal  GBTXC_DataOut : std_logic_vector(7 downto 0); 

type REGarray_type is array (0 to 6) of std_logic_vector(15 downto 0);
type INAarray_type is array (0 to 12) of REGarray_type;
signal INAarray : INAarray_type; -- := 

constant FileLoopIDLE   : std_logic_vector(3 downto 0) := "0000";
constant FileLoopSEND   : std_logic_vector(3 downto 0) := "0001";
constant FileLoopGET    : std_logic_vector(3 downto 0) := "0010";
constant FileloopREGW   : std_logic_vector(3 downto 0) := "1000";
constant FileloopREGR   : std_logic_vector(3 downto 0) := "1001";

constant cGI2C_DSEL : std_logic_vector(7 downto 0) :=x"20"; 
constant cGI2C_CMHZ : std_logic_vector(7 downto 0) :=x"21"; 
constant cDebugTest : std_logic_vector(7 downto 0) :=x"2F";

constant cGI2C_DATA : std_logic_vector(7 downto 0) :=x"30"; 
constant cGI2C_ERRN : std_logic_vector(7 downto 0) :=x"31"; 
constant cGI2C_RUN  : std_logic_vector(7 downto 0) :=x"32"; 
constant cGI2C_FLAG : std_logic_vector(7 downto 0) :=x"33";
constant cGI2C_ADDL : std_logic_vector(7 downto 0) :=x"34";
constant cGI2C_ADDH : std_logic_vector(7 downto 0) :=x"35";
constant cGI2C_NUML : std_logic_vector(7 downto 0) :=x"36";
constant cGI2C_NUMH : std_logic_vector(7 downto 0) :=x"37";

constant cGBTX_CTRL : std_logic_vector(7 downto 0) := X"40";
constant cGBTX_MODE : std_logic_vector(7 downto 0) := X"41";
constant cGBTX_TXRX : std_logic_vector(7 downto 0) := X"42";
constant cGBTX_SADD : std_logic_vector(7 downto 0) := X"43";
constant cGBTX_RSTB : std_logic_vector(7 downto 0) := X"44";
constant cGBTX_RXLK : std_logic_vector(7 downto 0) := X"45";
constant cEFUSECTRL : std_logic_vector(7 downto 0) := X"48"; 
constant cATMEGAPIN : std_logic_vector(7 downto 0) := X"49";
constant cATMEGAPTR : std_logic_vector(7 downto 0) := X"4A";
constant cATMEGARGL : std_logic_vector(7 downto 0) := X"4B";
constant cATMEGARGH : std_logic_vector(7 downto 0) := X"4C";

constant cSFPData     : std_logic_vector(7 downto 0) := X"50";
constant cSFPDataPtr  : std_logic_vector(7 downto 0) := X"51";
constant cTempGBT     : std_logic_vector(7 downto 0) := X"52";
constant cTempLDOGBT  : std_logic_vector(7 downto 0) := X"53";
constant cTempLDOSDES : std_logic_vector(7 downto 0) := X"54";
constant cTempPXL     : std_logic_vector(7 downto 0) := X"55";
constant cTempLDOFPGA : std_logic_vector(7 downto 0) := X"56";
constant cTempIGLOO2  : std_logic_vector(7 downto 0) := X"57";
constant cTempVTRX    : std_logic_vector(7 downto 0) := X"58";
constant cSFPtemp     : std_logic_vector(7 downto 0) := X"59";
constant cSFPvolt     : std_logic_vector(7 downto 0) := X"5A";
constant cSFPbias     : std_logic_vector(7 downto 0) := X"5B";
constant cSFPtxpow    : std_logic_vector(7 downto 0) := X"5C";
constant cSFPrxpow    : std_logic_vector(7 downto 0) := X"5D";
constant cI2Cmonitor  : std_logic_vector(7 downto 0) := X"5E";
constant cSFPstatus   : std_logic_vector(7 downto 0) := X"5F";
 
constant I2CIGLOOaddW : std_logic_vector(7 downto 0):= X"C0";
constant I2CIGLOOaddR : std_logic_vector(7 downto 0):= X"C1";

signal   StringOut    : string(1 to 20) := "....................";

--function ReadWriteRegister(Add   : std_logic_vector(7 downto 0);
						   --Data  : std_logic_vector(7 downto 0);
----						   Len   : integer;
                           --Read  : std_logic; 
                           --StrID : string; 
                           --Pointer: integer)  return std_logic_vector(15 downto 0) is
--variable DataBack  : std_logic_vector(7 downto 0);
--variable AddBack   : std_logic_vector(7 downto 0);
--variable ErrorFlag : std_logic;
--variable ErrorCode : std_logic_vector(7 downto 0);
--begin
	--ErrorFlag := '1';
	--if Read='1' then
---------- Read from a register
        --wait until SYSCLKd'event and SYSCLKd='1'; wait for 20 ns; 
        --FiDATA <= vIGLOOaddI2C or X"00";       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        --FiDATA <= Add                  ;       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        --I2CRUN <= '1'; wait for 10 ns;
--
        --while I2CBSY_AUX='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- Wait for I2C I2CBSY active
        --while I2CBSY_AUX='1' loop exit when ERROR='1'; wait for 10 us; end loop; -- Wait for I2C I2CBSY go down, end tra nsfert
		--if ERROR=1 then ErrorFlag := '1'; end if;
        --I2CRUN <= '0'; wait for 1 us;
        --
        --if ErrorFlag='0' then
--
	        --wait until SYSCLKd'event and SYSCLKd='1'; wait for 20 ns; 
	        --FiDATA <= vIGLOOaddI2C or X"01";       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
	        --I2CRUN <= '1'; wait for 10 ns;
--
	        --while I2CBSY_AUX='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- Wait for I2C I2CBSY active
	        --while I2CBSY_AUX='1' loop exit when ERROR='1'; wait for 10 us; end loop; -- Wait for I2C I2CBSY go down, end tra nsfert
			--if ERROR=1 then ErrorFlag := '1'; end if;
	        --I2CRUN <= '0'; wait for 1 us;
--
			--if ErrorFlag='0' then
--
				--wait until SYSCLKd'event and SYSCLKd='1';  wait for 20 ns;
                --FoRE <= '1'; wait for 100 ns; FoRE <= '0'; wait for 99 ns;
        		--AddBack  <= FoDATA; wait for 10 ns;
                --FoRE <= '1'; wait for 100 ns; FoRE <= '0'; wait for 99 ns;
        		--DataBack <= FoDATA; wait for 10 ns;
	        --end if;
        --end if;
		--
        --if ErrorFlag='1' then
			--WriteLOG("! Data read error from address " & slv2hstr(Add); wait for 10 ns; 
        	--return x"02" & AddBack; wait for 10 ns;
    	--elsif AddBack/=Add
			--WriteLOG("! Data read error code " & slv2hstr(AddBack); wait for 10 ns; 
        	--return x"01" & AddBack; wait for 10 ns;
    	--else
			--WriteLOG("< Data read:  " & slv2hstr(DataBack) & " from " & slv2hstr(AddBack); wait for 10 ns; 
        	--return x"00" & DataBack; wait for 10 ns;
    	--end if;
	--else
---------- Write from a register
        --wait until SYSCLKd'event and SYSCLKd='1'; wait for 20 ns; 
        --FiDATA <= vIGLOOaddI2C or X"00";       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        --FiDATA <= Add                  ;       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        --FiDATA <= Data                 ;       FiWE <= '1';  wait for 100 ns;  FiWE <= '0'; wait for 100 ns;
        --I2CRUN <= '1'; wait for 10 ns;
--
        --while I2CBSY_AUX='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- Wait for I2C I2CBSY active
        --while I2CBSY_AUX='1' loop exit when ERROR='1'; wait for 10 us; end loop; -- Wait for I2C I2CBSY go down, end tra nsfert
		--if ERROR=1 then ErrorFlag := '1'; end if;
        --I2CRUN <= '0'; wait for 1 us;
        --
	--
        --if ErrorFlag='1' then
			--WriteLOG("! Data write error from address " & slv2hstr(Add); wait for 10 ns; 
        	--return x"02" & AddBack; wait for 10 ns;
    	--else
			--WriteLOG("< Data write:  " & slv2hstr(Data) & " from " & slv2hstr(Add); wait for 10 ns; 
        	--return x"00" & DataBack; wait for 10 ns;
    	--end if;
    --end if;
        	--
--end ReadWriteRegister;

--procedure SetWriteReg(Add   : in std_logic_vector(7 downto 0);
				    --Data  : in std_logic_vector(7 downto 0);
                    --StrID : in string)  is
--begin                           
        --GBTXC_RegAdd <= Add;        
        --GBTXC_RegDatW(0) <= Data;
        --GBTXC_RegDNum <= 1; 
        --WriteLOG(string'("+ ") & StrID);
        --FileLoopCmd  <= FileloopREGW; 
        --wait for 10nS;
--end SetReadReg;
--
--procedure SetReadReg(Add   : std_logic_vector(7 downto 0);
				    --Data  : std_logic_vector(7 downto 0);
                    --StrID : string; 
                    --Pointer: integer)  is
--begin                           
        --GBTXC_RegAdd <= Add;        
        --GBTXC_RegDatW(0) <= Data;
        --GBTXC_RegDNum <= 1; 
        --WriteLOG(string'("+ ") & StrID);
        --FileLoopCmd  <= FileloopREGR; 
--end SetReadReg;

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
	sValue := "$ 0 0 0 0 0 0 0 0"; wait for 10 ns;
	if GBTX_ARST='1'      then sValue(((7-0)*2)+3) := '1'; end if;
	if GBTX_CONFIG='1'    then sValue(((7-1)*2)+3) := '1'; end if;
	if REFCLKSELECT='1'   then sValue(((7-2)*2)+3) := '1'; end if;
	if STATEOVERRIDE='1'  then sValue(((7-3)*2)+3) := '1'; end if;
	if GBTX_TESTOUTf='1' then sValue(((7-4)*2)+3) := '1'; end if;

	for i in 7 downto 5 loop
		if    Value(i)='0' then sValue(((7-i)*2)+3) := '0';  
		elsif Value(i)='1' then sValue(((7-i)*2)+3) := '1'; end if;
		wait for 10 ns;
	end loop;	
	wait for 10 ns;	
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
	sValue := "$ 0 0 0 0 0 0 0 0"; wait for 10 ns;

	for i in 7 downto 0 loop
		if    Value(i)='0' then sValue(((7-i)*2)+3) := '0';  
		elsif Value(i)='1' then sValue(((7-i)*2)+3) := '1'; end if;
		wait for 10 ns;
	end loop;	
	wait for 10 ns;	
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
	sValue := "$ 0 0 0 0 0 0 0 0"; wait for 10 ns;
	if GBPS_TX_DISAB='1'   then sValue(((7-0)*2)+3) := '1'; end if;
	if GBTX_TXDVALID='1'   then sValue(((7-1)*2)+3) := '1'; end if;
	if GBTX_RXDVALIDf='1'  then sValue(((7-2)*2)+3) := '1'; end if;
	if GBTX_RXRDYf='1'     then sValue(((7-3)*2)+3) := '1'; end if;
	if GBTX_TXRDYf='1'     then sValue(((7-4)*2)+3) := '1'; end if;

	for i in 7 downto 5 loop
		if    Value(i)='0' then sValue(((7-i)*2)+3) := '0';  
		elsif Value(i)='1' then sValue(((7-i)*2)+3) := '1'; end if;
		wait for 10 ns;
	end loop;	
	wait for 10 ns;	
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
	sValue := "$ 0 0 0 0 0 0 0 0"; wait for 10 ns;

	for i in 7 downto 0 loop
		if    Value(i)='0' then sValue(((7-i)*2)+3) := '0';  
		elsif Value(i)='1' then sValue(((7-i)*2)+3) := '1'; end if;
		wait for 10 ns;
	end loop;	
	wait for 10 ns;	
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
    SYSCLK   <= SYSCLKd;
--  SYSCLK2  <= SYSCLK2d;
    SYSCLKd  <= not SYSCLKd  after (SYSCLK_PERIOD / 2.0 ); 
--  SYSCLK2d <= not SYSCLK2d after (SYSCLK_PERIOD / 4.0 ); 

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
		variable ActualData : std_logic_vector(7 downto 0); 
        variable vRXstatus  : std_logic_vector(7 downto 0)  := X"00";
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
        wait for 10 ns;
        file_open(vInfile, Filename, READ_MODE); 
        wait for 10 ns;

-- S01: End Of File
        while not endfile(vInfile) loop

-- S02: Read line. Copy line in InString
            readline(vInfile, vInLine); wait for 10 ns;
            for i in 1 to 80 loop
                vIndex := i;
                read(vInLine, vInChar, good => vGoodNumber);
                exit when not vGoodNumber;
                vInString(i) := vInChar;
                wait for 10 ns;
            end loop;

            vInStringLen := vIndex; wait for 10 ns; -- Set string len
            
            for i in vIndex to 80 loop -- Clear the othe char of the string
                vInString(i) := character'val(0); wait for 10 ns;
                wait for 10 ns;
            end loop;

-- S03: Line begin with integer
            if vInString(1)<'0' then
                next; end if; wait for 10 ns;

            if vInString(1)>'9' then
                next; end if; wait for 10 ns;

-- S04: Get Data: 0802 11 @2300 Address R
-----------------               ^^^^^^^^^--< comment
-----------------         ^^^^^------------< timing 
-----------------      ^^------------------< DATA ***
----------------- ^^^^---------------------< line index
            vIndex := findspace(vInString, 1); wait for 10 ns;
            if vIndex=0 then NEXT; end if;  wait for 10 ns;

            vIndex := skipspace(vInString, vIndex); wait for 10 ns;
            if vIndex=0 then NEXT; end if;  wait for 10 ns;

            vDataNibble := hchar2slv(vInString(vIndex)); wait for 10 ns;
            if vDataNibble(4)='1' then next; end if;     wait for 10 ns;

            vDataByte(7 downto 4) := vDataNibble(3 downto 0);
            vIndex := vIndex+1;
            wait for 10 ns;

            vDataNibble := hchar2slv(vInString(vIndex)); wait for 10 ns;
            if vDataNibble(4)='1' then next; end if;     wait for 10 ns;

            vDataByte(3 downto 0) := vDataNibble(3 downto 0);
            wait for 10 ns;

            report "$ Incoming String: " & vInString; wait for 10 ns;

-- S05: Wait if FiFIFO is full            
            while FiFULL='1' loop exit when ERROR='1'; wait for 10 ns; end loop; -- Wait if FIFO FULL;

-- S06: Write in FiFIFO        
            FiDATA <= vDataByte; FiWE <= '1'; wait for 100 ns; FiWE <= '0'; wait for 10 ns;

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
            wait for 10 ns;

-- S08: Counter increment
            vCounter := vCounter+1; wait for 10 ns;

-- S09: Report
            wDataByte <= vDataByte;
            wMemAddr <= vMemAddr;
            wait for 10 ns;

			WriteLog("$ --> Send I2C-GBT data: " & integer'image(vCounter) & 
					 " Write: " & slv2hstr(wDataByte) & " to I2C FIFO");

--			WriteLog("$ --> Send I2C-GBT data: " & integer'image(vCounter) & 
--					 " Write: " & slv2hstr(rDataByte) & 
--                	 " @ "      & slv2hstr(wMemAddr(15 downto 8)) & slv2hstr(wMemAddr(7 downto 0)));

-- S10: I2C error
            exit when ERROR='1'; wait for 10 ns;  

        END LOOP;
        wait for 10 ns;
-- S11: Exit message, end procedure
        I2CRUN <= '1'; wait for 10 ns;
--  If ERROR='1' then  ASSERT false REPORT "Write complete, WITH ERRORS"; wait for 10 ns;
--      else               ASSERT false REPORT "Write complete, no errors"; wait for 10 ns; end if;
    If ERROR='1' then  REPORT "Write complete, WITH ERRORS"; wait for 10 ns;
    else               REPORT "Write complete, no errors";   wait for 10 ns; end if;
    
    file_close(vInfile); wait for 10 ns;
    
    while I2CBSY_AUX='0' loop exit when ERROR='1'; wait for 200 us; end loop; -- During Data TX;
    while I2CBSY_AUX='1' loop exit when ERROR='1'; wait for 200 us; end loop; -- During Data TX;
    
    I2CRUN <= '0';         wait for 1 us;
    FileLoopBsy <= '0';    wait for 1 us; 
------------------------------------------------------------------------------
    elsif FileLoopCmd=FileloopGET then
-- **************** RAM READ *****************************************
-- G01: LOOP based the complete read of a pack of data from IGLOO
        FileLoopBsy <= '1'; wait for 10 ns; 
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
					WriteLOG("& <-- Get I2C-GBT data: " & integer'image(vCounter) & 
                			 " Read: " & slv2hstr(rDataByte)); wait for 10 ns; 

                        if vRXstatus=GBTXCmd then 
                            NULL; wait for 10 ns; 
                        else 
                            exit; wait for 10 ns; 
                        end if;         
                        wait for 10 ns;
-- G08: OR get data.
             	else
-- G09: Report
					WriteLOG("& <-- Get I2C-GBT data: " & integer'image(vCounter) & 
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
        FileLoopBsy <= '0'; wait for 10 ns; 
    elsif FileLoopCmd=FileloopREGW then
-- **************** Register WRITE ***********************************

--      signal  GBTXC_RegAdd  : std_logic_vector(7 downto 0);
--      type    GBTXC_RegDatWArray is array (0 to 30) of std_logic_vector(7 downto 0); 
--      signal  GBTXC_RegDatW : GBTXC_RegDatWArray;
--      signal  GBTXC_RegDNum : integer;
--      signal  GBTXC_String  : string (1 to 30); 

        FileLoopBsy <= '1'; wait for 10 ns; 
        vPointer := 0; wait for 10 ns; 

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
        WriteLOG("> Data write: " & slv2hstr(GBTXC_RegDatW(0)) & " to " & slv2hstr(GBTXC_RegAdd)); wait for 10 ns; 
--	elsif GBTXC_RegAdd(7 downto 3)="01001" then 
--		WriteLOG("> Data write: " & slv2hstr(GBTXC_RegDatW(0)) 
--                                        & slv2hstr(GBTXC_RegDatW(1)) & " to " & slv2hstr(GBTXC_RegAdd)); wait for 10 ns; 
--      end if; 

    elsif FileLoopCmd=FileloopREGR then
-- **************** Register READ ***********************************

--      signal  GBTXC_RegAdd  : std_logic_vector(7 downto 0);
--      type    GBTXC_RegDatWArray is array (0 to 30) of std_logic_vector(7 downto 0); 
--      signal  GBTXC_RegDatW : GBTXC_RegDatWArray;
--      signal  GBTXC_RegDNum : integer;
--      signal  GBTXC_String  : string (1 to 30); 

        FileLoopBsy <= '1'; wait for 10 ns; 
        vPointer := 0; wait for 10 ns; 

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

        GBTXC_RegDatR <= (0 => "00000000", others => "00000000"); wait for 10 ns;
	vPointer:=0;                             wait for 10 ns;

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

	if    GBTXC_RegAdd(7 downto 5)="010" then 
		WriteLOG("< Data read:  " & slv2hstr(GBTXC_RegDatR(1)) & " from " & slv2hstr(GBTXC_RegDatR(0))); wait for 10 ns; 
    end if; 

	ActualData := GBTXC_RegDatR(1); wait for 10 nS;
    
    end if;
    wait for 10 ns;    
    end process;

----##################################################################################################################################
----######################## MAIN SIMUL PROCESS ######################################################################################
----##################################################################################################################################

    stimulus : process
    file vINfile : text; 
    file vOUTfile : text; 
    variable vInLine : line;
    variable vOutLine : line;
    variable vDataReadValid : std_logic_vector(7 downto 0)  := X"00";
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
	variable cnt : integer := 0;    
	variable ATMEGAREGPTR : integer range 0 to 15;
                    

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
        wait for 10 ns;
        
        wait for 1 us;
        
        RESETn <= '1';
        wait for 100us; -- Delay for I2C SFP TESTING
--		wait until RefreshDone='1';
-- Write LOG --------------------------------------------------------------
        file_open(vOutfile, "SessionLog.txt", WRITE_MODE); 
        write(vOutLine,string'("--------------- Session Log ---------------"));
        writeline(vOutfile, vOutLine);
        file_close(vOutfile);

--********************************************************************************************************
--********************************************************************************************************
--************************************ Test control register *********************************************
--********************************************************************************************************
--********************************************************************************************************
--- Delay iniziale -----------------------------------------------------------------------------
        wait for 5000 us;  --<<<<<<
-- _BRK_
--- "What's the frequency, Kenneth" ------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_CMHZ;   wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."----------------------------------------        
    	GBTXC_String <= "GBTX I2C read freq. divider   "; wait for 10 ns; 

       	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
    	wait for 20 us;
    	
    	WriteLog("$ --> Frequency divider: " & slv2hstr(GBTXC_RegDatR(1)));
 
--##################################################################################################
--------------------------------------------------------------------------------
--- **** Setup for continuous loop *********************************************
--------------------------------------------------------------------------------
            GBTXC_RegAdd <= cI2Cmonitor;  wait for 10 ns;
            GBTXC_RegDatW(0) <= x"00";    wait for 10 ns;
            GBTXC_RegDNum <= 1;           wait for 10 ns;
            ----------------".............................."------------------------------------------------------------
            GBTXC_String <= "Write ErrorDebug              "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

            FileLoopCmd  <= FileloopREGW; wait for 10 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;
--##################################################################################################
--------------------------------------------------------------------------------
--- **** Error reading loop ****************************************************
--------------------------------------------------------------------------------
--- Generate error and SFP error register if error ---------------------------------------------------------------

		while not Control_1 loop
            GBTXC_RegAdd <= cSFPstatus;   wait for 10 ns;
            GBTXC_RegDatW(0) <= DataIn_1;    wait for 10 ns;
            GBTXC_RegDNum <= 1;           wait for 10 ns;
            ----------------".............................."------------------------------------------------------------
            GBTXC_String <= "Write ErrorDebug              "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

            FileLoopCmd  <= FileloopREGW; wait for 10 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;

--- Read SFP Error -----------------------------------------------------------------------------            
 	        GBTXC_RegAdd <= cSFPstatus; wait for 10 ns;
        	GBTXC_RegDNum <= 1;         wait for 10 ns;
------------------------".............................."----------------------------------------        
    		GBTXC_String <= "Read SFP status for error     "; wait for 10 ns; 

     		FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    		while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    		FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    		while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
		    GBTXC_DataOut <= GBTXC_RegDatR(1); wait for 10 ns;
    		wait for 10 us;
		end loop;
--##################################################################################################
--------------------------------------------------------------------------------
--- **** Errors test SIM 07 ****************************************************
--------------------------------------------------------------------------------

--- Read from Debug test register if x00 -----------------------------------------------------------

        GBTXC_RegAdd <= cSFPstatus; wait for 10 ns;
        GBTXC_RegDNum <= 1;         wait for 10 ns;
------------------------".............................."----------------------------------------        
    	GBTXC_String <= "Read Debug Test register if 0 "; wait for 10 ns; 

     FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
    	wait for 20 us;
--- Set ERRORE NO ANSWER su SFP --------------------------------------------------------------------

        GBTXC_RegAdd <= cDebugTest;   wait for 10 ns;
        GBTXC_RegDatW(0) <= x"10";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "Set Debug Test SFP I2C noansw "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 5000 us;

--- Read SFP error register if error ---------------------------------------------------------------

        GBTXC_RegAdd <= cSFPstatus; wait for 10 ns;
        GBTXC_RegDNum <= 1;         wait for 10 ns;
------------------------".............................."----------------------------------------        
    	GBTXC_String <= "Read SFP status for error     "; wait for 10 ns; 

     	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
    	wait for 20 us;
    	
--- Reset ERRORE NO ANSWER su SFP ------------------------------------------------------------------

        GBTXC_RegAdd <= cDebugTest;   wait for 10 ns;
        GBTXC_RegDatW(0) <= x"00";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "Reset DebugTest register      "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 500 us;

--- Read SFP error register if not error -----------------------------------------------------------

        GBTXC_RegAdd <= cSFPstatus; wait for 10 ns;
        GBTXC_RegDNum <= 1;         wait for 10 ns;
------------------------".............................."----------------------------------------        
    	GBTXC_String <= "Read SFP status for no error  "; wait for 10 ns; 

     FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
    	wait for 20 us;
    	

--##################################################################################################
----------------------------------------------------------------------------------------------------
--- **** Write one GBTX registers - SIM 01 *********************************************************
----------------------------------------------------------------------------------------------------
        Filename <= "I2CvectW1new2.txt               "; wait for 10 ns;
---------------------00000000011111111112222222222333---
---------------------12345678901234567890123456789012--- Max 32 char
-- _BRK_    
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C1W cmd write one data  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String); --<<*>>

        FileLoopCmd  <= FileloopSEND; wait for 10 ns;

        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read end;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;

--- Send Address ---------------------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_ADDL;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"19";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C1W Address low         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

        GBTXC_RegAdd <= cGI2C_ADDH;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C1W Address high        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Send I2CRUN write -------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_w;    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C1W Start run           "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--      wait for 1 ms;  --<<<<<<

----------------------------------------------------------------------------------------------------
--- Test if end of run, preloop --------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."--------------------------------------------
	    GBTXC_String <= "GBTXI2C1W check end of run    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Test if end of run, loop -----------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_b loop
----------------------------".............................."----------------------------------------
	    	GBTXC_String <= "GBTXI2C1W end of run loop     "; wait for 10 ns;

        	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

			exit when ERROR='1';
		end loop;


        wait for 1 uS;  --<<<<<<
----------------------------------------------------------------------------------------------------
--- **** Read one GBTX registers - SIM 02 ***********************************************************
----- Send Address ------------------------------------------------------------------------------------
--
--      GBTXC_RegAdd <= cGI2C_ADDL;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= x"19";    wait for 10 ns;
--      GBTXC_RegDNum <= 1;           wait for 10 ns;
--   ----------------".............................."------------------------------------------------------------
--   GBTXC_String <= "GBTXI2C1R Address low         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
--
--      FileLoopCmd  <= FileloopREGW; wait for 10 ns;
--   while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
--   FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
--   while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
--   wait for 20 us;
--
--      GBTXC_RegAdd <= cGI2C_ADDH;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= x"01";    wait for 10 ns;
--      GBTXC_RegDNum <= 1;           wait for 10 ns;
--   ----------------".............................."------------------------------------------------------------
--   GBTXC_String <= "GBTXI2C1R Address high        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
--
--      FileLoopCmd  <= FileloopREGW; wait for 10 ns;
--   while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
--   FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
--   while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
--   wait for 20 us;
--
--- Send Number of Data --------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_NUML;   wait for 10 ns;
        GBTXC_RegDatW(0) <= x"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C1R num of data low     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

        GBTXC_RegAdd <= cGI2C_NUMH;   wait for 10 ns;
        GBTXC_RegDatW(0) <= x"00";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C1R num of data high    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Send I2CRUN ------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_r;    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------        
	    GBTXC_String <= "GBTXI2C1R cmd read data RUN   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--      wait for 1 ms;  --<<<<<<

----------------------------------------------------------------------------------------------------
--- Test if end of run, preloop --------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."--------------------------------------------
	    GBTXC_String <= "GBTXI2C1R cmd read data END   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Test if end of run, loop -----------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_b loop
----------------------------".............................."----------------------------------------        
	    	GBTXC_String <= "GBTXI2C1R cmd read data ENDL  "; wait for 10 ns; 

        	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

			exit when ERROR='1';  
		end loop;


        wait for 1 uS;  --<<<<<<
----------------------------------------------------------------------------------------------------
--- GET DATA ---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--- Check FIFO EMPTY -------------------------------------------------------------------------------

------------------------".............................."--------------------------------------------
		GBTXC_String <= "GBTXI2C1R test fifo noempty   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cGI2C_RUN; wait for 10 ns;
        GBTXC_RegDNum <= 1;        wait for 10 ns;

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;

		vCounter := 0; wait for 10 ns;

    	wait for 20 us;

--- Get data loop ----------------------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_q loop

----------------------------".............................."----------------------------------------
			GBTXC_String <= "GBTXI2C1R get data loop       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cGI2C_DATA;   wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;

	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
		    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
		    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
		    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
		    GBTXC_DataOut <= GBTXC_RegDatR(1); wait for 10 ns;
		    wait for 20 us;

			exit when ERROR='1'; 

			if vCounter>0 then vDataReadValid := GBTXC_RegDatR(1); end if; wait for 10 ns;

			vCounter := vCounter+1; wait for 10 ns;

--- Check FIFO empty ------------------------------------------------------------------------------
----------------------------".............................."--------------------------------------------
			GBTXC_String <= "GBTXI2C1R fifo empty loop     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cGI2C_RUN;   wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;

	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

		end loop;

        wait for 1 uS;  --<<O>>

--##################################################################################################
----------------------------------------------------------------------------------------------------
--- **** Write 20 GBTX registers - SIM 03 **********************************************************
----------------------------------------------------------------------------------------------------
        Filename <= "I2CvectW20new2.txt              "; wait for 10 ns;
---------------------00000000011111111112222222222333---
---------------------12345678901234567890123456789012--- Max 32 char
-- _BRK_    
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C20W cmd write 20 data  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String); --<<*>>

        FileLoopCmd  <= FileloopSEND; wait for 10 ns;

        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read end;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;

-- Send Address -----------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_ADDL;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"23";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C20W Address low        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

        GBTXC_RegAdd <= cGI2C_ADDH;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C20W Address high       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Send I2CRUN write -------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_w;    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C20W Start run          "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--      wait for 1 ms;  --<<<<<<

----------------------------------------------------------------------------------------------------
--- Test if end of run, preloop --------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."--------------------------------------------
	    GBTXC_String <= "GBTXI2C20W check end of run   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Test if end of run, loop -----------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_b loop
----------------------------".............................."----------------------------------------
	    	GBTXC_String <= "GBTXI2C20W end of run loop    "; wait for 10 ns;

        	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

			exit when ERROR='1';
		end loop;


        wait for 1 uS;  --<<<<<<
----------------------------------------------------------------------------------------------------
--- **** Read 20 GBTX registers - SIM 04 ***********************************************************
----------------------------------------------------------------------------------------------------
----- Send Address ------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_ADDL;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"23";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C20R Address low        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

        GBTXC_RegAdd <= cGI2C_ADDH;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C20R Address high       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Send Data --------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_NUML;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"0A";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C20R num of data low    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

        GBTXC_RegAdd <= cGI2C_NUMH;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"00";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C20R num of data high   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Send I2CRUN ------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_r;    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------        
	    GBTXC_String <= "GBTXI2C20R cmd read data RUN  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

----------------------------------------------------------------------------------------------------
--- Test if end of run, preloop --------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."--------------------------------------------
	    GBTXC_String <= "GBTXI2C20R check end of run   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Test if end of run, loop -----------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_b loop
----------------------------".............................."----------------------------------------
	    	GBTXC_String <= "GBTXI2C20R end of run loop    "; wait for 10 ns;

        	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

			exit when ERROR='1';
		end loop;


        wait for 1 uS;  --<<<<<<

----------------------------------------------------------------------------------------------------
--- GET DATA ---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--- Check FIFO EMPTY -------------------------------------------------------------------------------

------------------------".............................."--------------------------------------------
		GBTXC_String <= "GBTXI2C20R test fifo noempty  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cGI2C_RUN; wait for 10 ns;
        GBTXC_RegDNum <= 1;        wait for 10 ns;

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;

		vCounter := 0; wait for 10 ns;

    	wait for 20 us;

--- Get data loop ----------------------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_q loop

----------------------------".............................."----------------------------------------
			GBTXC_String <= "GBTXI2C20R get data loop      "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cGI2C_DATA;   wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;

	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
		    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
		    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
		    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
		    GBTXC_DataOut <= GBTXC_RegDatR(1); wait for 10 ns;
		    wait for 20 us;

			exit when ERROR='1'; 

			if vCounter>0 then vDataReadValid := GBTXC_RegDatR(1); end if; wait for 10 ns;

			vCounter := vCounter+1; wait for 10 ns;

--- Check FIFO empty ------------------------------------------------------------------------------
----------------------------".............................."--------------------------------------------
			GBTXC_String <= "GBTXI2C20R test fifo loop     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cGI2C_RUN;   wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;

	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

		end loop;

        wait for 1 uS;  --<<O>>

--##################################################################################################
----------------------------------------------------------------------------------------------------
--- **** Write 366 GBTX registers - SIM 05 *********************************************************
----------------------------------------------------------------------------------------------------
        Filename <= "I2CvectW366new2.txt             "; wait for 10 ns;
---------------------00000000011111111112222222222333---
---------------------12345678901234567890123456789012--- Max 32 char
-- _BRK_    
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C366W cmd write 366 data"; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String); --<<*>>

        FileLoopCmd  <= FileloopSEND; wait for 10 ns;

        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read end;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;

-- Send Address ----------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_ADDL;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"00";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C366W Address low       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 10 us;

        GBTXC_RegAdd <= cGI2C_ADDH;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"00";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C366W Address high      "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Send I2CRUN write -------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_w;    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C366W Start run         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--      wait for 1 ms;  --<<<<<<

----------------------------------------------------------------------------------------------------
--- Test if end of run, preloop --------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."--------------------------------------------
	    GBTXC_String <= "GBTXI2C366W check end of run  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Test if end of run, loop -----------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_b loop
----------------------------".............................."----------------------------------------
	    	GBTXC_String <= "GBTXI2C366W end of run loop   "; wait for 10 ns;

        	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

			exit when ERROR='1';
		end loop;

        wait for 1 uS;  --<<<<<<
----------------------------------------------------------------------------------------------------
--- **** Read 366 GBTX registers  - SIM 06 *********************************************************
----------------------------------------------------------------------------------------------------
--- Send Address ------------------------------------------------------------------------------------
---
---     GBTXC_RegAdd <= cGI2C_ADDL;    wait for 10 ns;
---     GBTXC_RegDatW(0) <= x"00";    wait for 10 ns;
---     GBTXC_RegDNum <= 1;           wait for 10 ns;
---  ----------------".............................."------------------------------------------------------------
---  GBTXC_String <= "GBTXI2C366R Address low       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
---
---     FileLoopCmd  <= FileloopREGW; wait for 10 ns;
---  while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
---  FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
---  while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
---  wait for 20 us;
---
---     GBTXC_RegAdd <= cGI2C_ADDH;    wait for 10 ns;
---     GBTXC_RegDatW(0) <= x"00";    wait for 10 ns;
---     GBTXC_RegDNum <= 1;           wait for 10 ns;
---  ----------------".............................."------------------------------------------------------------
---  GBTXC_String <= "GBTXI2C366R Address high      "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
---
---     FileLoopCmd  <= FileloopREGW; wait for 10 ns;
---  while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
---  FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
---  while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
---  wait for 20 us;
---
--- Send Data --------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_NUML;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"6E";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C366R num of data low   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

        GBTXC_RegAdd <= cGI2C_NUMH;    wait for 10 ns;
        GBTXC_RegDatW(0) <= x"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTXI2C366R num of data high  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Send I2CRUN ------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_r;    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------        
	    GBTXC_String <= "GBTXI2C366R RUN               "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

----------------------------------------------------------------------------------------------------
--- Test if end of run, preloop --------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."--------------------------------------------
	    GBTXC_String <= "GBTXI2C366R check end of run  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Test if end of run, loop -----------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_b loop
----------------------------".............................."----------------------------------------
	    	GBTXC_String <= "GBTXI2C366R end of run loop   "; wait for 10 ns;

        	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

			exit when ERROR='1';
		end loop;


        wait for 1 uS;  --<<<<<<

----------------------------------------------------------------------------------------------------
--- GET DATA ---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--- Check FIFO EMPTY -------------------------------------------------------------------------------

------------------------".............................."--------------------------------------------
		GBTXC_String <= "GBTXI2C366R test fifo noempty "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cGI2C_RUN; wait for 10 ns;
        GBTXC_RegDNum <= 1;        wait for 10 ns;

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;

		vCounter := 0; wait for 10 ns;

    	wait for 20 us;

--- Get data loop ----------------------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_q loop

----------------------------".............................."----------------------------------------
			GBTXC_String <= "GBTXI2C366R data loop         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cGI2C_DATA;   wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;

	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
		    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
		    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
		    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
		    GBTXC_DataOut <= GBTXC_RegDatR(1); wait for 10 ns;
		    wait for 20 us;

			exit when ERROR='1'; 

			if vCounter>0 then vDataReadValid := GBTXC_RegDatR(1); end if; wait for 10 ns;

			vCounter := vCounter+1; wait for 10 ns;

--- Check FIFO empty ------------------------------------------------------------------------------
----------------------------".............................."--------------------------------------------
			GBTXC_String <= "GBTXI2C366R FIFO empty loop   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cGI2C_RUN;   wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;

	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

		end loop;

        wait for 1 uS;  --<<O>>

--##################################################################################################
--- I2CSEL test --------------------------------------------------------------------------------

--- Read switch status -----------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_DSEL;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."----------------------------------------        
    	GBTXC_String <= "GBTX I2C read status I2CSEL   "; wait for 10 ns; 

       	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
    	wait for 20 us;
    	
    	if GBTXC_RegDatR(1)=CHAR_s then
    	    WriteLog("$ --> Switch to serial");
		else 
			WriteLog("$ --> Switch to parallel");
		end if;
 
--- Switch to parallel -----------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_DSEL;   wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_p;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "Set I2CSEL to parallel        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Read switch status -----------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_DSEL;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."----------------------------------------        
    	GBTXC_String <= "GBTX I2C read status I2CSEL   "; wait for 10 ns; 

       	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
    	wait for 20 us;
    	
    	if GBTXC_RegDatR(1)=CHAR_s then
    	    WriteLog("$ --> Switch to serial");
		else 
			WriteLog("$ --> Switch to parallel");
		end if;

--- Switch to serial -----------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_DSEL;   wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_s;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "Set I2CSEL to serial          "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

 
--- Read switch status -----------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_DSEL;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."----------------------------------------        
    	GBTXC_String <= "GBTX I2C read status I2CSEL   "; wait for 10 ns; 

       	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
    	wait for 20 us;
    	
    	if GBTXC_RegDatR(1)=CHAR_s then
    	    WriteLog("$ --> Switch to serial");
		else 
			WriteLog("$ --> Switch to parallel");
		end if;

--- Send I2CRESET ----------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_x;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTX I2C reset                "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

        wait for 1 ms;  --<<<<<<
----------------------------------------------------------------------------------------------------
--- **** Write 366 GBTX registers ******************************************************************
----------------------------------------------------------------------------------------------------
        Filename <= "I2CvectW366new.txt              "; wait for 10 ns;
---------------------00000000011111111112222222222333---
---------------------12345678901234567890123456789012--- Max 32 char
-- _BRK_    
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTX I2C cmd write 366 data   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String); --<<*>>

        FileLoopCmd  <= FileloopSEND; wait for 10 ns;

        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read end;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;

--- Send I2CRUN ------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_r;    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------
	    GBTXC_String <= "GBTX I2C Start run            "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--      wait for 1 ms;  --<<<<<<

----------------------------------------------------------------------------------------------------
--- Test if end of run, preloop --------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."--------------------------------------------
	    GBTXC_String <= "GBTXI2CW check end of run     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Test if end of run, loop -----------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_r loop
----------------------------".............................."----------------------------------------
	    	GBTXC_String <= "GBTXI2CW check end of run loop"; wait for 10 ns;

        	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

			exit when ERROR='1';
		end loop;


        wait for 1 uS;  --<<<<<<
----------------------------------------------------------------------------------------------------
--- **** Read 366 GBTX registers *******************************************************************
----------------------------------------------------------------------------------------------------
        Filename <= "I2CvectSetReadPH366new.txt      "; wait for 10 ns;
---------------------00000000011111111112222222222333---
---------------------12345678901234567890123456789012--- Max 32 char

	    ----------------".............................."------------------------------------------------------------        
	    GBTXC_String <= "GBTX I2C cmd read 366 data    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopSEND; wait for 10 ns;

        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 100 ns; end loop; -- During waiting file read end;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;

--- Send I2CRUN ------------------------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
        GBTXC_RegDatW(0) <= CHAR_r;    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	    ----------------".............................."------------------------------------------------------------        
	    GBTXC_String <= "GBTX I2C cmd read 366 data RUN"; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--      wait for 1 ms;  --<<<<<<

----------------------------------------------------------------------------------------------------
--- Test if end of run, preloop --------------------------------------------------------------------

        GBTXC_RegAdd <= cGI2C_RUN;    wait for 10 ns;
--      GBTXC_RegDatW(0) <= X"01";    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
------------------------".............................."--------------------------------------------
	    GBTXC_String <= "GBTX I2C cmd read 366 data END"; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    wait for 20 us;

--- Test if end of run, loop -----------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_r loop
----------------------------".............................."----------------------------------------        
	    	GBTXC_String <= "GBTX I2C cmd read 366 dat ENDL"; wait for 10 ns; 

        	FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

			exit when ERROR='1';  
		end loop;


        wait for 1 uS;  --<<<<<<
----------------------------------------------------------------------------------------------------
--- GET DATA ---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--- Check FIFO EMPTY -------------------------------------------------------------------------------

------------------------".............................."--------------------------------------------
		GBTXC_String <= "GBTX I2C read 366 fifo noempty"; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cGI2C_RUN; wait for 10 ns;
        GBTXC_RegDNum <= 1;        wait for 10 ns;

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;

		vCounter := 0; wait for 10 ns;

    	wait for 20 us;

--- Get data loop ----------------------------------------------------------------------------------

		while GBTXC_RegDatR(1)=CHAR_q loop

----------------------------".............................."----------------------------------------
			GBTXC_String <= "GBTX I2C get 366 data loop    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cGI2C_DATA;   wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;

	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
		    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
		    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
		    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
		    GBTXC_DataOut <= GBTXC_RegDatR(1); wait for 10 ns;
		    wait for 20 us;

			exit when ERROR='1'; 

			if vCounter>0 then vDataReadValid := GBTXC_RegDatR(1); end if; wait for 10 ns;

			vCounter := vCounter+1; wait for 10 ns;

--- Check FIFO empty ------------------------------------------------------------------------------
----------------------------".............................."--------------------------------------------
			GBTXC_String <= "GBTX I2C check fifo empty loop"; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cGI2C_RUN;   wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;

	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	    	wait for 20 us;

		end loop;

        wait for 1 uS;  --<<O>>

--##################################################################################################
---------------------------------------------------------------------------------------------------
-- *******************************************************************
-- **** Read all GBTX registers - Read registers *********************
-- *******************************************************************
-- _BRK_    
        FileLoopCmd  <= FileloopGET; wait for 10 ns;
        
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;

        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;

        while FileLoopBsy='1' loop exit when ERROR='1'; wait for 200 us; end loop; -- During waiting file read end;

        wait for 30 ms;
-- *******************************************************************
        WriteLOG(string'("# REGISTER ACCESS TEST"));
------- enable CONFIG signal settings, GBTX CONFIG selector '0' via Slow Control, '1' via I2C
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"02";    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "GBTX_CTRL: CONFIG write       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "GBTX_CTRL: CONFIG read        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		GBTXC_RegDatW(0) <= GBTXC_RegDatW(0) sll 1; wait for 10 ns;       
		wait for 20 us;
------- SFP status & error generator   
        GBTXC_RegAdd <= cSFPstatus;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"08";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus read                "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus write I2C block     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus read after          "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 5ms;
------- SFP status & error generator   
        GBTXC_RegAdd <= cSFPstatus;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"0A";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus read                "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus write I2C SDA to 0  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus read after          "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 5ms;
------- SFP status & error generator   
        GBTXC_RegAdd <= cSFPstatus;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"0C";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus read                "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus write I2C SCL to 0  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFPstatus read after          "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 5ms;
------- test EFUSE commands
        GBTXC_RegAdd <= cEFUSECTRL;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"76";    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "EFUSE read status 'd'         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "EFUSE write status  'v'       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);	
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "EFUSE read status 'v'         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "EFUSE write status  'p'       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);	
        GBTXC_RegDatW(0) <= X"70";    wait for 10 ns; 
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "EFUSE read status 'p'         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "EFUSE read status 'v'         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "EFUSE write status  'd'       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);	
        GBTXC_RegDatW(0) <= X"64";    wait for 10 ns; 
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "EFUSE read status 'd'         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		GBTXC_RegDatW(0) <= GBTXC_RegDatW(0) sll 1; wait for 10 ns;       
		wait for 10 ms;
------- ATMEGA Register Read
            PSM_SO  <= '0';
            PSM_SCK <= '0';
            PSM_SP1 <= '0';
            PSM_SP0 <= '0';
            PXL_SDN <= '0';
		FOR ATMEGAREGPTR in 0 to 15 LOOP
	        GBTXC_RegAdd <= cATMEGAPTR; wait for 10 ns;
        	GBTXC_RegDNum <= 1;         wait for 10 ns;
---------------------------- Set PRT
            GBTXC_RegDatW(0) <= conv_std_logic_vector(ATMEGAREGPTR, 8);    wait for 10 ns; 
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA PTR WRITE              "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);	
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA PTR READ               "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
			wait for 20 us;
			---------------
	        GBTXC_RegAdd <= cATMEGARGL; wait for 10 ns;
        	GBTXC_RegDNum <= 1;         wait for 10 ns;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA REGISTER LO read       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
			wait for 20 us;
			---------------
	        GBTXC_RegAdd <= cATMEGARGH; wait for 10 ns;
        	GBTXC_RegDNum <= 1;         wait for 10 ns;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA REGISTER HI read       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
			wait for 20 us;
		end loop;
------- ATMEGA SIGNAL TEST 
        GBTXC_RegAdd <= cATMEGAPIN; wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
---------------------------- Set bit 0
            PSM_SO  <= '0';
            PSM_SCK <= '0';
            PSM_SP1 <= '0';
            PSM_SP0 <= '0';
            PXL_SDN <= '0';
            GBTXC_RegDatW(0) <= X"01";    wait for 10 ns; 
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT WRITE '0xxxxx01'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);	
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT READ  '00000001'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		wait for 20 us;
---------------------------- Set bit 1
            PSM_SO  <= '0';
            PSM_SCK <= '0';
            PSM_SP1 <= '0';
            PSM_SP0 <= '0';
            PXL_SDN <= '0';
            GBTXC_RegDatW(0) <= X"02";    wait for 10 ns; 
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT WRITE '0xxxxx10'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);	
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT READ  '00000010'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		wait for 20 us;
---------------------------- Clear
            PSM_SO  <= '1';
            PSM_SCK <= '1';
            PSM_SP1 <= '1';
            PSM_SP0 <= '1';
            PXL_SDN <= '1';
            GBTXC_RegDatW(0) <= X"00";    wait for 10 ns; 
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT WRITE '0xxxxx00'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);	
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
---------------------------- Read bit 2 = 1
            PSM_SO  <= '0';
            PSM_SCK <= '0';
            PSM_SP1 <= '0';
            PSM_SP0 <= '0';
            PXL_SDN <= '1';
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT READ  '10000100'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		wait for 20 us;
---------------------------- Read bit 3 = 1
            PSM_SO  <= '0';
            PSM_SCK <= '0';
            PSM_SP1 <= '0';
            PSM_SP0 <= '1';
            PXL_SDN <= '0';
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT READ  '10001000'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		wait for 20 us;
---------------------------- Read bit 4 = 1
            PSM_SO  <= '0';
            PSM_SCK <= '0';
            PSM_SP1 <= '1';
            PSM_SP0 <= '0';
            PXL_SDN <= '0';
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT READ  '10010000'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		wait for 20 us;
---------------------------- Read bit 5 = 1
            PSM_SO  <= '0';
            PSM_SCK <= '1';
            PSM_SP1 <= '0';
            PSM_SP0 <= '0';
            PXL_SDN <= '0';
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT READ  '10100000'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		wait for 20 us;
---------------------------- Read bit 6 = 1
            PSM_SO  <= '1';
            PSM_SCK <= '0';
            PSM_SP1 <= '0';
            PSM_SP0 <= '0';
            PXL_SDN <= '0';
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "ATMEGA BIT READ  '11000000'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		wait for 20 us;
-- *******************************************************************
-- **************** TEMP/SFP ACCESS **********************************
-- *******************************************************************
------- CONFIG signal settings, GBTX CONFIG selector '0' via Slow Control, '1' via I2C
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"01";    wait for 10 ns; 
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	LCTRL : loop
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "GBTX_CTRL: CONFIG write       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "GBTX_CTRL: CONFIG read        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		GBTXC_RegDatW(0) <= GBTXC_RegDatW(0) sll 1; wait for 10 ns;       
		wait for 20 us;
		exit LCTRL when GBTXC_RegDatW(0)=x"00";
		wait for 1 us;  
	end loop;
-- *******************************************************************
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 10 ns; 
        GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
	LTXRX : loop 
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "GBTX_CTRL: CONFIG write       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        wait for 20 us;
	        ----------------".............................."------------------------------------------------------------        
	        GBTXC_String <= "GBTX_CTRL: CONFIG read        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
	        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
		GBTXC_RegDatW(0) <= GBTXC_RegDatW(0) sll 1; wait for 10 ns;       
		wait for 20 us;
		exit LTXRX when GBTXC_RegDatW(0)=x"00";
		wait for 1 us;  
	end loop;
-- *******************************************************************
        GBTXC_RegDatW(0) <= X"10";    wait for 10 ns;
        GBTXC_RegDNum    <= 1;        wait for 10 ns;
------- Test if data refresh done in SFP data read loop 
		L1: loop
        --------------------".............................."------------------------------------------------------------        
        	GBTXC_String <= "Data refresh test             "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
	        GBTXC_RegAdd <= cI2Cmonitor;  wait for 10 ns;
	        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
	        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
	        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
	        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
	        exit L1 when (GBTXC_RegDatR(1) and X"01")=X"01";
			wait for 1 ms;
		end loop;
-- *******************************************************************
        GBTXC_RegDatW(0) <= X"10";    wait for 10 ns;
        GBTXC_RegDNum    <= 1;        wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Read board temp. sensor GBT   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cTempGBT; wait for 10 ns;
        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Read board temp. sensor LDOGBT"; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cTempLDOGBT; wait for 10 ns;
        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Read board temp. sensor SERDES"; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cTempLDOSDES; wait for 10 ns;
        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Read board temp. sensor PXL   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cTempPXL; wait for 10 ns;
        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Read board temp. LDO FPGA     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cTempLDOFPGA; wait for 10 ns;
        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Read board temp. sensor IGLOO2"; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cTempIGLOO2; wait for 10 ns;
        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "Read board temp. sensor VTRX  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cTempVTRX; wait for 10 ns;
        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
-- *******************************************************************
-- **************** SFP/TEMP RAM read ********************************
------- SFPDataPtr RAM pointer write              
        GBTXC_RegAdd <= cSFPDataPtr;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"00";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFTP/TEMP RAM pointer write   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
------- SFPDataPtr RAM data read  
		for cnt in 0 to 127 loop             
	        GBTXC_RegAdd <= cSFPData;   wait for 10 ns;
	        GBTXC_RegDatW(0) <= X"00";    wait for 10 ns;
	        GBTXC_RegDNum <= 1;           wait for 10 ns;
		        ----------------".............................."------------------------------------------------------------        
		        GBTXC_String <= "SFTP/TEMP RAM data read       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
		        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
		        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
		        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
		        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
		        wait for 20 us;
		end loop;
------- SFPDataPtr RAM pointer read              
        GBTXC_RegAdd <= cSFPDataPtr;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"00";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "SFTP/TEMP RAM pointer read    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;-- *******************************************************************
-- **************** GBTX ACCESS **************************************
------- GBPS_TX_DISAB settings, VTRX disable if '1'   
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"00";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status read     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status write    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status read     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;

--
-- *******************************************************************
-- **************** GBTX control pin *****************************CTRL
-- *******************************************************************
-- **** GBTX_CTRL register **************************************************************************************************************
------- GBTX_CTRL register first reading     
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        GBTXC_String <= "------------------------------"; wait for 10 ns; WriteLOG(string'("--") & GBTXC_String);
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: test bit           "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
	wait for 20 us;
------- CONFIG signal settings, GBTX CONFIG selector '0' via Slow Control, '1' via I2C
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"02";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: CONFIG write       "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: CONFIG read        "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
	wait for 20 us;
------- Set GBTX_CTRL at default value
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"02";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: default re-setting "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
------- INPUTS 
------- GBTX_TESTOUT signal reading
        GBTXC_RegAdd <= cGBTX_CTRL;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: TESTOUT read '1'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_TESTOUT <= '1';

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_CTRL: TESTOUT read '0'   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_TESTOUT <= '0';

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_CTRL(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
-- **** GBTX_TXRX register **************************************************************************************************************
------- GBPS_TX_DISAB settings, VTRX disable if '1'   
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status read     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status write    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DISAB status read     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
------- GBPS_TX_DVALID settings, data ready to trasmission via VTRX if '1'   
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"02";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DVALID status write   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBPS_TX_DVALID status read    "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop; -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
------- Set GBTX_TXRX at default value
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 10 ns;
        GBTXC_RegDatW(0) <= X"01";    wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: default re-setting "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);

        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
------- INPUTS §§§ 
------- GBTX_RXDVALID signal reading
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: RXDVALID read '1'  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_RXDVALID <= '1';

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: RXDVALID read '0'  "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_RXDVALID <= '0';

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
------- GBTX_RXRDY signal reading
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: RXRDY read '1'     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_RXRDY <= '1';

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: RXRDY read '0'     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_RXRDY <= '0';

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
------- GBTX_TXRDY signal reading
        GBTXC_RegAdd <= cGBTX_TXRX;   wait for 10 ns;
        GBTXC_RegDNum <= 1;           wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: TXRDY read '1'     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_TXRDY <= '1';

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "GBTX_TXRX: TXRDY read '0'     "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        GBTX_TXRDY <= '0';

        FileLoopCmd  <= FileloopREGR; wait for 10 ns;
        while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
        FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
        while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
        ShowGBTX_TXRX(GBTXC_RegDatW(0)); wait for 10 ns;
        wait for 20 us;
--***** Register GBTX_RSTB **************************************************************************************************************
------- Register GBTX_RSTB test (SHORT)(CMD=X"44")
        GBTXC_RegAdd <= cGBTX_RSTB;   wait for 10 ns;
        ----------------".............................."------------------------------------------------------------        
        GBTXC_String <= "------------------------------"; wait for 10 ns; WriteLOG(string'("--") & GBTXC_String);
        GBTXC_String <= "GBTX_RSTB: RESET test         "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
        vIndex := 0; wait for 10 ns;
        while vIndex<7 loop
            if GBTX_RESETB='1' then
                case vIndex is 
                when 0 => GBTXC_RegDatW(0) <= "00000001";    wait for 10 ns;
                when 1 => GBTXC_RegDatW(0) <= "00000010";    wait for 10 ns;
                when 2 => GBTXC_RegDatW(0) <= "00000100";    wait for 10 ns;
                when 3 => GBTXC_RegDatW(0) <= "00001000";    wait for 10 ns;
                when 4 => GBTXC_RegDatW(0) <= "00010000";    wait for 10 ns;
                when 5 => GBTXC_RegDatW(0) <= "00010100";    wait for 10 ns;
                when others => 
                          GBTXC_RegDatW(0) <= "00000000";    wait for 10 ns;
                end case;
                vIndex := vIndex+1;
            else 
                GBTXC_RegDatW(0) <= "00000000"; wait for 10 us;
            end if;
            GBTXC_RegDNum <= 1;           wait for 10 ns;
            FileLoopCmd  <= FileloopREGW; wait for 10 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;
                    
            FileLoopCmd  <= FileloopREGR; wait for 10 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;        
        end loop;

------- Register GBTX_RSTB test --------------------------------------------        
------- Register GBTX_RSTB test --------------------------------------------        
------- GBTX_RSTB testing (FAST)   
        GBTXC_String <= "GBTX_RSTB: RESET test         "; wait for 10 ns;
                     ----123456789012345678901234567890-----------------
        WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cGBTX_RSTB;   wait for 10 ns;
	vIndex := 0; wait for 10 ns;
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
                GBTXC_RegDNum <= 1;           wait for 10 ns;
                FileLoopCmd  <= FileloopREGW; wait for 10 ns;
                while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
                FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
                while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
                wait for 20 us;
                vIndex := vIndex+1; wait for 10 ns;
            end if;
            wait for 10 us;        
            FileLoopCmd  <= FileloopREGR; wait for 10 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
            while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
            wait for 20 us;        
        end loop;
--------------------------------------------------------------------------------------------------------------------
--***** Register GBTX_RSTB **************************************************************************************************************
------- GBTX_RSTB testing (LONG)   
        GBTXC_String <= "GBTX_RSTB: RESET test         "; wait for 10 ns;
                     ----123456789012345678901234567890-----------------
        WriteLOG(string'("+ ") & GBTXC_String);
        GBTXC_RegAdd <= cGBTX_RSTB;   wait for 10 ns;
	vIndex := 0; wait for 10 ns;
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
                GBTXC_RegDNum <= 1;           wait for 10 ns;
                FileLoopCmd  <= FileloopREGW; wait for 10 ns;
                while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
                FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
                while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
                wait for 50 ms;
                vIndex := vIndex+1;
            end if;
            wait for 10 us;        
            FileLoopCmd  <= FileloopREGR; wait for 10 ns;
            while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
            FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
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

---|--- Write to register ------------------------------------------------------------------------------
---|
---|        GBTXC_RegAdd <= [address_constant] GI2C_DSEL;   wait for 10 ns;
---|        GBTXC_RegDatW(0) <= [data];                     wait for 10 ns;
---|        GBTXC_RegDNum <= [number_of_data];              wait for 10 ns;
---|	    ----------------".............................."------------------------------------------------------------
---|	    GBTXC_String <= "description                   "; wait for 10 ns; WriteLOG(string'("+ ") & GBTXC_String);
---|
---|        FileLoopCmd  <= FileloopREGW; wait for 10 ns;
---|	    while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
---|	    FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
---|	    while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
---|	    wait for 20 us;
---|
---|--- Read from register -----------------------------------------------------------------------------
---|
---|        GBTXC_RegAdd <= [address_constant]; wait for 10 ns;
---|        GBTXC_RegDNum <= [number_of_data];  wait for 10 ns;
---|------------------------".............................."----------------------------------------        
---|    	GBTXC_String <= "description                   "; wait for 10 ns; 
---|
---|     FileLoopCmd  <= FileloopREGR; wait for 10 ns;
---|    	while FileLoopBsy='0' loop exit when ERROR='1'; wait for 10 ns; end loop; -- During waiting file read start;
---|    	FileLoopCmd  <= FileloopIDLE; wait for 10 ns;
---|    	while FileLoopBsy='1' loop exit when ERROR='1'; wait for  2 us; end loop;  -- During waiting file read end;
---|    	wait for 20 us;
---|    	



