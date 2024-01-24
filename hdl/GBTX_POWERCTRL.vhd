--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: GBTX_POWERCTRL.vhd
-- File history:
--      1.20151210.1200: Modifiche su indirizzamento Power
--      1.20151117.1200: Correzioni INAOOP
--      1.20151110.1200: INALOOP active from reset
--      1.20150730.1200: Prima release (*)
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: <Name>
--
-------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity GBTX_POWERCTRL is
port (
        I2CDI  : in  std_logic_vector(7 downto 0); -- read I2C_INA data out here
        I2CDE  : in  std_logic_vector(7 downto 0); -- read I2C_INA error code here when I2CERR='1'
        I2CDO  : out std_logic_vector(7 downto 0); -- to I2C_INA data input
        I2CERR : in std_logic;    -- I2C_INA error flag
        I2CRD  : out std_logic;   -- I2C_INA FIFO read
        I2CWR  : out std_logic;   -- I2C_INA FIFO write
        I2CRDf : in  std_logic;   -- I2C_INA FIFO read feedback
        I2CWRf : in  std_logic;   -- I2C_INA FIFO write feedback
        I2CRUN : out std_logic;   -- I2C_INA run cycle
        I2CBSY : in std_logic;    -- I2C_INA is running
-------------------------------------------------------------------------------------------------
        DI  : in  std_logic_vector(7 downto 0); -- Register data in
        DO  : out std_logic_vector(7 downto 0); -- Register data out
        WR  : in  std_logic; -- Write signal
        EN  : in  std_logic; -- Enable signal
        ADD  : in  std_logic_vector(3 downto 0); -- Address in: bit3:1=COMMAND(2:0), 
                                                 -------------- bit0='0' Even=LSB=2nd I2C byte
                                                 -------------- bit0='1' Odd =MSB=1st I2C byte
-------------------------------------------------------------------------------------------------
TESTpls : out std_logic_vector(3 downto 0);
        POWER  : out std_logic;  -- Power Enable
        DELAYpls : in  std_logic;  -- 100us pulse
        CLK    : in  std_logic;  -- clock
        RESETn : in  std_logic); -- reset
end GBTX_POWERCTRL;

architecture GBTX_POWERCTRL_arch of GBTX_POWERCTRL is
-------------------------------------------------------------------------------------------------
   -- signal, component etc. declarations
signal   INALOOPcnt    : std_logic_vector(3 downto 0); --------- INA LOOP read/write counter for error
constant cINALOOPerror : std_logic_vector(7 downto 0):=X"E8"; -- INA LOOP error

signal   INALOOPsm     : std_logic_vector(7 downto 0); --------- INA LOOP STATE MACHINE
constant cINAsmIdle    : std_logic_vector(7 downto 0):=X"00";
constant cINAsmRdSet   : std_logic_vector(7 downto 0):=X"10";
constant cINAsmRead    : std_logic_vector(7 downto 0):=X"20";
constant cINAsmRdDat   : std_logic_vector(7 downto 0):=X"30";
constant cINAsmWrite   : std_logic_vector(7 downto 0):=X"40";
constant cINAsmWwait   : std_logic_vector(7 downto 0):=X"41";
constant cINAsmInc     : std_logic_vector(7 downto 0):=X"50";
constant cINAsmTest    : std_logic_vector(7 downto 0):=X"60";
-----------------------------------------------------------------------------------------------------------
signal REGptr      : std_logic_vector(7 downto 0); -- Register pointer in INAarray
signal INAptr      : std_logic_vector(7 downto 0); -- INA pointer in INAarray
--signal INActrl     : std_logic_vector(7 downto 0);
signal INALOOPen   : std_logic_vector(3 downto 0);
-----------------------------------------------------------------------------------------------------------
signal STARTdly : std_logic; -- 100uS delay for INALOOP startup
-----------------------------------------------------------------------------------------------------------
signal INADI  : std_logic_vector(15 downto 0); -- Register data in
--gnal INADIh : std_logic_vector(7 downto 0); -- Register data out
--gnal INADIl : std_logic_vector(7 downto 0); -- Register data out
signal INADO  : std_logic_vector(15 downto 0); -- Register data out
signal INADOh : std_logic_vector(7 downto 0); -- Register data out
signal INADOl : std_logic_vector(7 downto 0); -- Register data out
signal INAWR  : std_logic; -- Write signal
--gnal INAEN  : std_logic; -- Enable signal
signal INAWE  : std_logic; -- Enable signal
--gnal INAAD  : std_logic_vector(2 downto 0); -- Address in: bit3:1=COMMAND(2:0), 
-----------------------------------------------------------------------------------------------------------
signal I2CDRh : std_logic_vector(7 downto 0); -- Buffer for FIFOLOOO
signal I2CDRl : std_logic_vector(7 downto 0); -- Buffer for FIFOLOOP
-----------------------------------------------------------------------------------------------------------
type REGarray_type is array (0 to 6) of std_logic_vector(15 downto 0);
type INAarray_type is array (0 to 12) of REGarray_type;
signal INAarray : INAarray_type := 
     -- INAR0   INAR1   INAR2   INAR3   INAR4   INAR5  I2CCTRL    ------------------------------------------
     ((X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 00  P2V5FS	Uvfs2	1000000	40	GND	GND
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 01  P1V2FS	Uvfx2	1000001	41	GND	Vs+
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 02  P2V5FE	Uvfe2	1000010	42	GND	SDA
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 03  P1V5FP	Uvfp2	1000011	43	GND	SCL
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 04  P1V5GRX	Ugr2	1000100	44	Vs+	GND
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 05  P1V5GTX	Ugt2	1000101	45	Vs+	Vs+
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 06  P1V5GD	Ugd2	1000110	46	VS+	SDA
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 07  P1V5GP	Ugp2	1000111	47	Vs+	SCL
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 08  P1V5GCK	Ugc2	1001000	48	SDA	GND
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 09  P2V5GLD	Ugl2	1001001	49	SDA	Vs+
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 10  P3V3HW	Uvh2	1001100	4C	SCL	GND
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000"),  -- 11  P3V3F	Uvf2	1001101	4D	SCL	Vs+
      (X"0D57",X"0000",X"0000",X"0000",X"0000",X"0800",X"0000")); -- 12  P1V2FD	Uvfd2	1001110	4E	SCL	SDA;
 
-- The composition of the INAarray and contro registers follows
-- REGptr ->   0   |   1   |   2   |   3   |   4   |   5   |   6    || Common Reg.
-- ADD ----> 0   1 | 2   3 | 4   5 | 6   7 | 8   9 | A   B | C   D  ||  E  |  F   || label   | ref.  | board i2c address| I2C set
-------------------+-------+-------+-------+-------+-------+--------++-----+------++---------+-------+------------------+---------
-- 0 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P2V5FS  | Uvfs2 | "1000000" (X"40) | GND GND
-- 1 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P1V2FS  | Uvfx2 | "1000001" (X"41) | GND Vs+
-- 2 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P2V5FE  | Uvfe2 | "1000010" (X"42) | GND SDA
-- 3 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P1V5FP  | Uvfp2 | "1000011" (X"43) | GND SCL
-- 4 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P1V5GRX | Ugr2  | "1000100" (X"44) | Vs+ GND
-- 5 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P1V5GTX | Ugt2  | "1000101" (X"45) | Vs+ Vs+
-- 6 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P1V5GD  | Ugd2  | "1000110" (X"46) | VS+ SDA
-- 7 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P1V5GP  | Ugp2  | "1000111" (X"47) | Vs+ SCL
-- 8 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P1V5GCK | Ugc2  | "1001000" (X"48) | SDA GND
-- 9 -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P2V5GLD | Ugl2  | "1001001" (X"49) | SDA Vs+
-- A -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P3V3HW  | Uvh2  | "1001100" (X"4C) | SCL GND
-- B -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P3V3F   | Uvf2  | "1001101" (X"4D) | SCL Vs+
-- C -----> R0l R0h|R1l R1h|R2l R2h|R3l R3h|R4l R4h|R5l R5h| . I2CER||POWON|INAPTR|| P1V2FD  | Uvfd2 | "1001110" (X"4E) | SCL SDA
-- ^INAptr --------+-------+-------+-------+-------+-------+--------++-----+------++---------+-------+------------------+---------
-------------------+-------+-------+-------+-------+-------+--------++-----+------++---------+-------+------------------+---------
-- INAPTR and POWON are single register with ADD respectively X"E" and X"F". I2CER are the I2C status for every INA219. 
-- Access of single cell is: INAarray(INAptr)(REGptr)
-----------------------------------------------------------------------------------------------------------
type INAIDXarray_type is array (0 to 12) of std_logic_vector(7 downto 0);
constant INAIDXarray : INAIDXarray_type := (X"40", X"41", X"42", X"43", X"44", -- I2C address of INA219 
                                            X"45", X"46", X"47", X"48", X"49", 
                                            X"4C", X"4D", X"4E");
-----------------------------------------------------------------------------------------------------------
signal   I2Csm 	: std_logic_vector(3 downto 0); -- I2C set and control state machine
-- I2Csm: State Machine steps ------------------------------------------------------------------------------------------
constant cI2Csm01in 	: std_logic_vector(3 downto 0) := X"0"; --- cI2Cread: send INA I2C address plus R to I2C FIFO in, to cI2Csm01dly
------------------------------------------------------------------- cI2Cwrit: send INA I2C address plus W to I2C FIFO in, to cI2Csm01dly
------------------------------------------------------------------- cI2Cwrrd: send INA I2C address plus W to I2C FIFO in, to cI2Csm01dly
------------------------------------------------------------------------------------------------------------------------
--nstant cI2Csm01dly 	: std_logic_vector(3 downto 0) := X"1"; --- cI2Cread: delay; to cI2Csm02in
------------------------------------------------------------------- cI2Cwrit: delay; to cI2Csm02in
------------------------------------------------------------------- cI2Cwrrd: delay; to cI2Csm02in
------------------------------------------------------------------------------------------------------------------------
constant cI2Csm02in 	: std_logic_vector(3 downto 0) := X"2"; --- to cI2Csmrun
------------------------------------------------------------------- cI2Cwrit: send REGptr to I2C FIFO in; to cI2Csm02dly
------------------------------------------------------------------- cI2Cwrrd: send REGptr to I2C FIFO in; to cI2Csm02dly
------------------------------------------------------------------------------------------------------------------------
--nstant cI2Csm02dly 	: std_logic_vector(3 downto 0) := X"3"; --- cI2Cwrit: delay; to cI2Csm03in
------------------------------------------------------------------- cI2Cwrrd: delay; to cI2Csm03in
------------------------------------------------------------------------------------------------------------------------
constant cI2Csm03in 	: std_logic_vector(3 downto 0) := X"4"; --- cI2Cwrit: send MSB data to I2C FIFO in; to cI2Csm03dly
------------------------------------------------------------------- cI2Cwrrd: to cI2Csmrun
------------------------------------------------------------------------------------------------------------------------
--nstant cI2Csm03dly 	: std_logic_vector(3 downto 0) := X"5"; --- cI2Cwrit: delay; to cI2Csm04in
constant cI2Csm04in 	: std_logic_vector(3 downto 0) := X"6"; --- cI2Cwrit: send MSB data to I2C FIFO in; to cI2Csm04dly
--nstant cI2Csm04dly 	: std_logic_vector(3 downto 0) := X"7"; --- cI2Cwrrd: to cI2Csmrun
constant cI2Csmrun      : std_logic_vector(3 downto 0) := X"8"; --  set I2CRUN; to cI2Csmwbsy
constant cI2Csmwbsy 	: std_logic_vector(3 downto 0) := X"E"; --  Wait for BUSY active
constant cI2Csmbusy 	: std_logic_vector(3 downto 0) := X"9"; --- if I2CERR set flag, save error code in data MSB and reset I2CRUN;
------------------------------------------------------------------- if I2CBSY reset I2CRUN then:
------------------------------------------------------------------- cI2Cwrit: to cI2Csmwait
------------------------------------------------------------------- cI2Cwrit: to cI2Csmwait
------------------------------------------------------------------- cI2Cwrrd: to cI2Csmread1
constant cI2Csmread1 	: std_logic_vector(3 downto 0) := X"A"; -- cI2Cwrrd: read FIFO out, save to data MSB; to cI2Csmread2
constant cI2Csmread2 	: std_logic_vector(3 downto 0) := X"B"; -- cI2Cwrrd: read FIFO out, save to data LSB; to cI2Csmwait
constant cI2Csmwait 	: std_logic_vector(3 downto 0) := X"C"; -- end of cycle
-----------------------------------------------------------------------------------------------------------
signal   I2Ccmd  : std_logic_vector(1 downto 0); -- I2C state machine command and controls
constant cI2Cidle  : std_logic_vector(1 downto 0) := "00"; -- I2C wait for commands
constant cI2Cread  : std_logic_vector(1 downto 0) := "01"; -- read cycle
constant cI2Cwrit  : std_logic_vector(1 downto 0) := "10"; -- write cycle
constant cI2Cwrrd  : std_logic_vector(1 downto 0) := "11"; -- write cycle before read cycle

signal   I2CERRd  : std_logic;
signal   I2Crdy   : std_logic;

signal   POWINAptr  : std_logic_vector(3 downto 0);
signal   POWCTRL    : std_logic_vector(3 downto 0);

signal   RSTclear   : std_logic_vector(2 downto 0);

begin

    RegisterDualPort_handler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            DO <= X"00";
            POWINAptr <= X"0";
            POWCTRL   <= X"D";
            INALOOPen <= X"E"; 
---------------------------------------
            INAArray(0)(0)  <= X"0D57";
            INAArray(1)(0)  <= X"0D57";
            INAArray(2)(0)  <= X"0D57";
            INAArray(3)(0)  <= X"0D57";
            INAArray(4)(0)  <= X"0D57";
            INAArray(5)(0)  <= X"0D57";
            INAArray(6)(0)  <= X"0D57";
            INAArray(7)(0)  <= X"0D57";
            INAArray(8)(0)  <= X"0D57";
            INAArray(9)(0)  <= X"0D57";
            INAArray(10)(0) <= X"1D57";
            INAArray(11)(0) <= X"1D57";
            INAArray(12)(0) <= X"0D57";
---------------------------------------
            INAArray(0)(5)  <= X"0800";
            INAArray(1)(5)  <= X"0800";
            INAArray(2)(5)  <= X"0800";
            INAArray(3)(5)  <= X"0800";
            INAArray(4)(5)  <= X"0800";
            INAArray(5)(5)  <= X"0800";
            INAArray(6)(5)  <= X"0800";
            INAArray(7)(5)  <= X"0800";
            INAArray(8)(5)  <= X"0800";
            INAArray(9)(5)  <= X"0800";
            INAArray(10)(5) <= X"0800";
            INAArray(11)(5) <= X"0800";
            INAArray(12)(5) <= X"0800";
---------------------------------------
            INAArray(0)(6)  <= X"0000";
            INAArray(1)(6)  <= X"0000";
            INAArray(2)(6)  <= X"0000";
            INAArray(3)(6)  <= X"0000";
            INAArray(4)(6)  <= X"0000";
            INAArray(5)(6)  <= X"0000";
            INAArray(6)(6)  <= X"0000";
            INAArray(7)(6)  <= X"0000";
            INAArray(8)(6)  <= X"0000";
            INAArray(9)(6)  <= X"0000";
            INAArray(10)(6) <= X"0000";
            INAArray(11)(6) <= X"0000";
            INAArray(12)(6) <= X"0000";
---------------------------------------
        elsif WR='1' and EN='1' then
            case ADD is
            when X"F" => POWINAptr <= DI(3 downto 0); 
            when X"E" => if (DI(3 downto 0)=X"D" or DI(3 downto 0)=X"E") then POWCTRL   <= DI(3 downto 0); end if; --- X'D' o X'E' solamente
                         if (DI(7 downto 4)=X"D" or DI(7 downto 4)=X"E") then INALOOPen <= DI(7 downto 4); end if; --- X'D' o X'E' solamente
            when X"0" => INAarray(conv_integer(POWINAptr))(0)(7  downto 0) <= DI; 
            when X"1" => INAarray(conv_integer(POWINAptr))(0)(15 downto 8) <= DI and X"3F"; 
            when X"A" => INAarray(conv_integer(POWINAptr))(5)(7  downto 0) <= DI; 
            when X"B" => INAarray(conv_integer(POWINAptr))(5)(15 downto 8) <= DI; 
            when others => NULL;
            end case;
        elsif WR='0' and EN='1' then
            case ADD is
            when X"F"   => DO <= X"0" & POWINAptr;
            when X"E"   => DO <= INALOOPen & POWCTRL;
            when X"D"   => DO <= INAarray(conv_integer(POWINAptr))(conv_integer(ADD(3 downto 1)))(15 downto 8);
                                 INAarray(conv_integer(POWINAptr))(conv_integer(ADD(3 downto 1)))(15 downto 8) <= X"00";
            when others => 
                if ADD(0)='0' then DO <= INAarray(conv_integer(POWINAptr))(conv_integer(ADD(3 downto 1)))(7  downto 0);  
                else               DO <= INAarray(conv_integer(POWINAptr))(conv_integer(ADD(3 downto 1)))(15 downto 8); end if;
            end case;
        elsif INAWE='1' then
            INAarray(conv_integer(INAptr))(6) <= INADI;
        elsif INAWR='1' then
            INAarray(conv_integer(INAptr))(conv_integer(REGptr)) <= INADI;
        else
            INADO <= INAarray(conv_integer(INAptr))(conv_integer(REGptr));
        end if;
    end if;
    end process;

    INAdata_aliases : process (INADO)
    begin
        INADOl <= INADO(7  downto 0);
        INADOh <= INADO(15 downto 8);
--      INADI  <= INADIh & INADIl;
    end process;

    INA_LOOP_StateMachine : process (CLK)
    begin
    if CLK'event and CLK='1' then
-- L1 -------------------------------------------------------------------------------------------------------------------------
        if RESETn='0' or INALOOPen=X"D" or STARTdly='0' then
            I2Ccmd     <= cI2Cidle;
TESTpls(3) <= '0';
TESTpls(2) <= '0';
TESTpls(0) <= '0';
TESTpls(1) <= '0';
            REGptr     <= X"00";
            INAptr     <= X"00";
            INADI      <= X"0000";
            INALOOPsm  <= cINAsmRdSet;
            INALOOPcnt <= X"0";
            INAWR <= '0'; INAWE <= '0';
-- L5 -------------------------------------------------------------------------------------------------------------------------
       elsif INAWR='1' or INAWE='1' then 
            INAWR <= '0'; INAWE <= '0';
-- L2 -------------------------------------------------------------------------------------------------------------------------
       elsif I2CERRd='1' then 
            I2Ccmd <= cI2Cidle;
            REGptr <= X"00";
            INALOOPsm  <= cINAsmInc;
            INADI      <= I2CDRh & INADOl; INAWE <= '1';
-- L3 -------------------------------------------------------------------------------------------------------------------------
        elsif I2Crdy='1' then
            I2Ccmd <= cI2Cidle;
-- L4 -------------------------------------------------------------------------------------------------------------------------
        elsif I2Ccmd=cI2Cidle then
            case INALOOPsm is
-- L41 ------------------------------------------------------------------------------------------------------------------------
            when cINAsmRdSet => -- Set register pointer in INA
                I2Ccmd    <= cI2Cwrrd;   
                INALOOPsm <= cINAsmRead;
                INALOOPcnt <= X"0";
TESTpls(0) <= '1';
-- L45 ------------------------------------------------------------------------------------------------------------------------
            when cINAsmRead => -- Read INA register
                I2Ccmd    <= cI2Cread;   
                INALOOPsm <= cINAsmTest;
TESTpls(1) <= '0';
TESTpls(0) <= '0';
TESTpls(3) <= '0';
TESTpls(2) <= '0';
-- L42 ------------------------------------------------------------------------------------------------------------------------
            when cINAsmTest => -- Test data from INA register
                case REGptr is
                when X"05" => NULL; --- Calibration register
                    if (I2CDRh=INADOh) and (I2CDRl=INADOl)  then               
                        INALOOPsm <= cINAsmInc; ------ No change goto next INA register
                    	INADI     <= I2CDRh & I2CDRl; INAWR <= '1';
                    else
                        if INALOOPcnt=X"F" then ------ Max loop reached, exit from loop with error
                            INADI     <= cINALOOPerror & INADOl; INAWE <= '1';
                            INALOOPsm <= cINAsmInc; -- No change goto next INA register
                        else
                            INALOOPcnt <= INALOOPcnt + X"1"; 
                            INALOOPsm  <= cINAsmWrite; ---- Changed, write last in INAarray
                        end if;
                    end if;
                when X"00" => NULL; --- Option register
                    if (I2CDRh=INADOh) and (I2CDRl=INADOl) then               
                        INALOOPsm <= cINAsmInc; ------ No change goto next INA register
                    	INADI     <= (I2CDRh & I2CDRl) and X"3FFF"; INAWR <= '1';
                    else
                        if INALOOPcnt=X"F" then ------ Max loop reached, exit from loop with error
                            INADI     <= cINALOOPerror & INADOl; INAWE <= '1';
                            INALOOPsm <= cINAsmInc; -- No change goto next INA register
                        else
                            INALOOPcnt <= INALOOPcnt + X"1"; 
                            INALOOPsm  <= cINAsmWrite; ---- Changed, write last in INAarray
                        end if;
                    end if;
                when others => NULL;
                    INALOOPsm <= cINAsmInc;
                    INADI     <= I2CDRh & I2CDRl; INAWR <= '1';
                end case;
-- L43 ------------------------------------------------------------------------------------------------------------------------
            when cINAsmWrite =>
                I2Ccmd    <= cI2Cwrit;    -- Write INAarry out to INA register 
                INALOOPsm <= cINAsmRead;  -- Readback to test.
TESTpls(1) <= '1';
-- L44 ------------------------------------------------------------------------------------------------------------------------
            when cINAsmInc => 
                if REGptr=X"05" then 
                    if INAptr=X"0C" then 
                        INAptr <= X"00";
                        REGptr <= X"00";
TESTpls(3) <='1';
                    else
                        INAptr <= INAptr + X"01";   
                        REGptr <= X"00";
TESTpls(2) <='1';
                    end if;
                else
                    REGptr <= REGptr+X"01";
                end if;
                INALOOPsm <= cINAsmRdSet;  -- Readback to test.
            when others      =>
            end case;
        end if;
    end if;
    end process;

    PowerEnable_handler : process (CLK)
    begin
    if clk'event and clk='1' then
        if RESETn='0'        then POWER <= '0';
        elsif POWCTRL = X"D" then POWER <= '0'; 
        elsif POWCTRL = X"E" then POWER <= '1';
        end if;
    end if;
    end process;

    LoopSMEnable_handler : process (CLK)
    begin
    if clk'event and clk='1' then
        if RESETn='0'                       then STARTdly <= '0';
        elsif DELAYpls='0' and STARTdly='0' then STARTdly <= '0'; 
        elsif DELAYpls='1' or  STARTdly='1' then STARTdly <= '1';
        end if;
    end if;
    end process;

    FIFO_handler : process (CLK)
    begin
        if CLK'event and CLK='1' then
-- P1 -------------------------------------------------------------------------------------------------------------------
            if RESETn='0' then
                I2Csm <= cI2Csm01in;
                I2CRD <= '0';
                I2CWR <= '0';
                I2Crun <= '0';
                I2Crdy <= '0';
                I2CERRd <= '0';
                I2CDRh <= X"00"; 
                I2CDRl <= X"00"; 
                I2CDO  <= X"00"; 
            elsif I2Ccmd=cI2Cidle then
                I2Csm <= cI2Csm01in;
                I2CRD <= '0';
                I2CWR <= '0';
                I2Crun <= '0';
                I2Crdy <= '0';
                I2CERRd <= '0';
-- P2 --------- FIFO WR or RD reset
            elsif I2CRDf='1' then I2CRD <= '0'; 
            elsif I2CWRf='1' then I2CWR <= '0'; 
            else
                case I2Csm is
-- P21 -------- Set write for I2C ADD+W/R
                when cI2Csm01in =>  NULL;
                                    I2CWR <= '1';
                                    I2Csm <= cI2Csm02in;
-- P211 ------- Set ADD+W or ADD+R function of I2Ccmd read or write in FIFO IN
                                    if I2Ccmd=cI2Cread then
                                        I2CDO <= INAIDXarray(conv_integer(INAptr))(6 downto 0) & '1';
                                    else
                                        I2CDO <= INAIDXarray(conv_integer(INAptr))(6 downto 0) & '0';
                                    end if;
-- P23 -------- If Write send Register pointer in FIFO
                when cI2Csm02in =>  NULL;
                                    if I2Ccmd=cI2Cread then
                                        I2Csm <= cI2Csmrun;
                                    else
                                        I2CDO <= REGptr;
                                        I2CWR <= '1';
                                        I2Csm <= cI2Csm03in;
                                    end if;
-- P25 -------- If write for read goto run, otherwise send data MSB to FIFO IN
                when cI2Csm03in =>  NULL;
                                    if I2Ccmd=cI2Cwrrd then
                                        I2Csm <= cI2Csmrun;
                                    else
                                        I2CDO <= INADOh;
                                        I2CWR <= '1';
                                        I2Csm <= cI2Csm04in;
                                    end if;
-- P27 -------- Send data LSB
                when cI2Csm04in =>  NULL;
                                    I2CDO <= INADOl;
                                    I2CWR <= '1';
                                    I2Csm <= cI2Csmrun;
-- P29 -------- Run cycle in FIFO
                when cI2Csmrun 	=>  NULL;
                                    I2CRUN <= '1';
                                    I2Csm <= cI2Csmwbsy;
-- P2E -------- Wait for busy active or error
                when cI2Csmwbsy =>  NULL;
-- P2E1 -----------------------------------------------------------------------------------------------------------------
                                    if I2CERR='1' then
                                        I2CRUN  <= '0';
                                        I2CERRd <= '1';
                                        I2CDRh <= I2CDE;
                                        I2Csm <= cI2Csmwait;
-- P2E2 -----------------------------------------------------------------------------------------------------------------
                                    elsif I2CBSY='1' then
                                        I2Csm <= cI2Csmbusy;
                                    end if;
-- P2A -------- Check for busy reset or error
                when cI2Csmbusy =>  NULL;
-- P2A1 -----------------------------------------------------------------------------------------------------------------
                                    if I2CERR='1' then
                                        I2CRUN  <= '0';
                                        I2CERRd <= '1';
                                        I2CDRh <= I2CDE;
                                        I2Csm <= cI2Csmwait;
-- P2A2 -----------------------------------------------------------------------------------------------------------------
                                    elsif I2CBSY='0' then
                                        I2CRUN <= '0';
                                        if I2Ccmd=cI2Cread then 
                                            I2Csm <= cI2Csmread1;
                                            I2CRD <= '1';
                                        else
                                            I2Csm <= cI2Csmwait;
                                        end if;
                                    end if;
-- P2B ------------------------------------------------------------------------------------------------------------------
                when cI2Csmwait =>  NULL;
                                    I2Crdy <= '1';
-- P2C ------------------------------------------------------------------------------------------------------------------
                when cI2Csmread1 => NULL;
                                    I2CRD  <= '1';
                                    I2CDRh <= I2CDI;
                                    I2Csm  <= cI2Csmread2;
-- P2D ------------------------------------------------------------------------------------------------------------------
                when cI2Csmread2 => NULL;
                                    I2CRD  <= '1';
                                    I2CDRl <= I2CDI;
                                    I2Csm  <= cI2Csmwait;
                when others 	=>  NULL;
                                    I2Crdy <= '1';
                end case;
            end if;
        end if;
    end process;
    
   -- architecture body
end GBTX_POWERCTRL_arch;