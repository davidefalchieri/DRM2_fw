--------------------------------------------------------------------------------
-- Company: INFN
-- 
-- File: AUX_CTRL.vhd
-- File history:
--      1.20180201.1200: Aggiunto registro SFPvolt, spostato DebugTest in AUX_CTRL. Modificata la struttura dei segnali
--      1.20171227.1025: Aggiunta selezione clock
--      1.20170810.1204: Prima release
--
--------------------------------------------------------------------------------

library IEEE;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity AUX_CTRL is
port (
-----------------------------------------------------------------------------------------------------------------------------
        DO      : out std_logic_vector(7 downto 0);
        DI      : in  std_logic_vector(7 downto 0);
        ADD     : in  std_logic_vector(3 downto 0);
        WR      : in  std_logic;
        EN      : in  std_logic;
-----------------------------------------------------------------------------------------------------------------------------
        CMHZdef : in    std_logic_vector(7 downto 0);
        CMHZout : out   std_logic_vector(7 downto 0);
-----------------------------------------------------------------------------------------------------------------------------
        CLOCKSEL1 : out   std_logic;
        CLOCKSEL2 : out   std_logic;
-----------------------------------------------------------------
		DebugTestEnab   : in  std_logic;
		SFPI2CErrEn : out  std_logic;
		SFPI2CERR   : out  std_logic_vector(3 downto 0);
		GBTI2CErrEn : out  std_logic;
		GBTI2CERR   : out  std_logic_vector(3 downto 0);
-----------------------------------------------------------------------------------------------------------------------------
        TestSignal   : out std_logic_vector(7 downto 0); --<-- 180205
        fbTestSignal : in  std_logic_vector(7 downto 0); --<-- 180205
-----------------------------------------------------------------------------------------------------------------------------
        Version : in   std_logic_vector(15 downto 0); --<-- 180205
        RESETn  : in    std_logic;
        CLK     : in    std_logic
);
end AUX_CTRL;
architecture AUX_CTRL_beh of AUX_CTRL is
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
---------------------- Register -------------------------------|   Bit7    |   Bit6    |   Bit5    |   Bit4    |   Bit3    |   Bit2    |   Bit1    |   Bit0    |  Default   |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aI2CSEL    : std_logic_vector(3 downto 0):="0000"; ---|            Address space used for switch selector in GBTX_SWITCHr for I2C and subsystem       |            |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aAUX_CMHZ  : std_logic_vector(3 downto 0):="0001"; ---|                                 Main clock divider for I2C and subsystem                      |   CMHZdef  |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aCLOCKSEL  : std_logic_vector(3 downto 0):="0010"; ---|                                        Clock Selector ('p','g','o')                                        |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aTESTSIGNL : std_logic_vector(3 downto 0):="1100"; ---|                                        TEST signal selector code                              | "xxxxxxxx" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aDebugTest : std_logic_vector(3 downto 0):="1101"; ---|                                           Debug TEST                                          |            | --<-- 180125
signal   rDebugTest : std_logic_vector(7 downto 0);         ---|-----------------------------------------------------------------------------------------------+------------+
---------------------------------------------------------------| Bit | Signal --+ Notes -----------------------------------------------------------------------+------------+
---------------------------------------------------------------| 7:0 | DEBUG    | x"00" No errors                                                              |            |
constant cDT_SFPCRC  : std_logic_vector(7 downto 0):= x"1C"; --|     | DEBUG    | x"1C" CRC error set                                                          |            |
constant cDT_SFPDAC  : std_logic_vector(7 downto 0):= x"1D"; --|     | DEBUG    | x"1D" DAC error set                                                          |            |
constant cDT_SFP0xFF : std_logic_vector(7 downto 0):= x"1F"; --|     | DEBUG    | x"1F" 0xFF error set                                                         |            |
constant cDT_SFPI2C1 : std_logic_vector(7 downto 0):= x"10"; --|     | DEBUG    | x"10" I2C no answer SFP                                                      |            |
constant cDT_SFPSDA0 : std_logic_vector(7 downto 0):= x"11"; --|     | DEBUG    | x"11" I2C SFP SDA hold to '0'                                                |            |
constant cDT_SFPSCL0 : std_logic_vector(7 downto 0):= x"12"; --|     | DEBUG    | x"12" I2C SFP SCL hold to '0'                                                |            |
constant cDT_SFPSDA1 : std_logic_vector(7 downto 0):= x"13"; --|     | DEBUG    | x"13" I2C SFP SDA hold to '1'                                                |            |
constant cDT_SFPSCL1 : std_logic_vector(7 downto 0):= x"14"; --|     | DEBUG    | x"14" I2C SFP SCL hold to '1'                                                |            |
constant cDT_GBTI2C1 : std_logic_vector(7 downto 0):= x"20"; --|     | DEBUG    | x"20" I2C no answer Gbt                                                      |            |
constant cDT_GBTSDA0 : std_logic_vector(7 downto 0):= x"21"; --|     | DEBUG    | x"21" I2C GBT SDA hold to '0'                                                |            |
constant cDT_GBTSCL0 : std_logic_vector(7 downto 0):= x"22"; --|     | DEBUG    | x"22" I2C GBT SCL hold to '0'                                                |            |
constant cDT_GBTSDA1 : std_logic_vector(7 downto 0):= x"23"; --|     | DEBUG    | x"23" I2C GBT SDA hold to '1'                                                |            |
constant cDT_GBTSCL1 : std_logic_vector(7 downto 0):= x"24"; --|     | DEBUG    | x"24" I2C GBT SCL hold to '1'                                                |            |
---------------------------------------------------------------+----------------+------------------------------------------------------------------------------+------------+
constant aVERSIONP1 : std_logic_vector(3 downto 0):="1110"; ---|           |                YEAR               |                    MONTH                      |  Version H | --<-- 180205
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aVERSIONP2 : std_logic_vector(3 downto 0):="1111"; ---|                            DAY                            |                 TAG               |  Version L | --<-- 180205
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
---------------------------------------------------------------+----------------+------------------------------------------------------------------------------+------------+
---
constant CHAR_p    : std_logic_vector(7 downto 0) := x"70";
constant CHAR_o    : std_logic_vector(7 downto 0) := x"6F";
constant CHAR_g    : std_logic_vector(7 downto 0) := x"67";

signal   rAUX_CMHZ : std_logic_vector(7 downto 0);
signal   rCLOCKSEL : std_logic_vector(7 downto 0);

begin

    AUX_CTRL_RW_handler : process (CLK)
    begin
    if CLK'event and CLK='1' then       
       	if RESETn='0' then
       		rDebugTest <= x"00";
			rAUX_CMHZ  <= CMHZdef;
			rCLOCKSEL  <= CHAR_o;
            TestSignal <= x"00";
		else
            if EN='1' and WR='1' then
                case ADD is
                    when aAUX_CMHZ  => rAUX_CMHZ  <= DI;
                    when aCLOCKSEL  => if DI=CHAR_o or DI=CHAR_p or DI=CHAR_g then rCLOCKSEL <= DI; end if;
                    when aTESTSIGNL => TestSignal <= DI; ------------<-- 180205
                    when aDebugTest	=> if   DebugTestEnab='1' then --<-- 180125
                                            rDebugTest <= DI;
                                       else 
                                            rDebugTest <= x"00";
                                       end if;
                    when others     => NULL;
                end case;
            else
                case ADD is
                    when aAUX_CMHZ  => DO <= rAUX_CMHZ;
                    when aCLOCKSEL  => DO <= rCLOCKSEL;
                    when aTESTSIGNL => DO <= fbTestSignal; -------------------------------<-- 180205
                    when aDebugTest => DO <= rDebugTest or (DebugTestEnab & "0000000"); --<-- 180125
                    when aVERSIONP1 => DO <= Version(15 downto 8); -----------------------<-- 180205
                    when aVERSIONP2 => DO <= Version(7 downto 0);  -----------------------<-- 180205
                    when others     => DO <= x"00";
                end case; 
            end if;
        end if;
    end if;
    end process;

--<-- 180125
    ErrorDebug_handler : process(CLK)
 	begin
	if CLK'event and CLK='1' then
		if RESETn='0' then
 			SFPI2CErrEn  <= '0'; 
            GBTI2CErrEn  <= '0'; 
		else
            case rDebugTest(7 downto 4) is
			when x"1"    => NULL;
							SFPI2CErrEn  <= '1'; 
			when x"2"    => NULL;
							GBTI2CErrEn  <= '1'; 
            when others  =>	SFPI2CErrEn  <= '0'; 
                            GBTI2CErrEn  <= '0'; 
            end case;
		end if;
        SFPI2CErr <= rDebugTest(3 downto 0);
        GBTI2CErr <= rDebugTest(3 downto 0);
	end if;
	end process;
-->-- 180125

    CLOCK_handling : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            CLOCKSEL1 <= '0';
            CLOCKSEL2 <= '1';
        elsif EN='0' then
            case RCLOCKSEL is
            when CHAR_p => CLOCKSEL2 <= '1'; CLOCKSEL1 <= '0';
            when CHAR_o => CLOCKSEL2 <= '0'; CLOCKSEL1 <= '1';
            when CHAR_g => CLOCKSEL2 <= '0'; CLOCKSEL1 <= '0';
            when others => null;
            end case;
        end if;
    end if;
    end process;

    IO_handling : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            CMHZout <= rAUX_CMHZ;
        elsif EN='0' then
            CMHZout <= rAUX_CMHZ;
        end if;
    end if;
    end process;
end AUX_CTRL_beh;