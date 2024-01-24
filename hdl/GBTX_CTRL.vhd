

--------------------------------------------------------------------------------
-- Company: INFN
-- 
-- File: GBTX_CTRL.vhd
-- File history:
--      1.20180205.1107: Tolto version da questo ambito
--      1.20170523.1107: Correzioni
--      1.20170517.1046: Aggiunti Registri x"49" e x"4A" per lettura ATMEGA
--      1.20170407.1140: Aggiunti Registri x"48" per EFUSE
--      1.20170404.1540: Validazione
--      1.20160114.1200: Versioning
--      1.20151210.1200: Modifiche su indirizzamento Power
--      1.20151110.1200: Aggiunta versione
--      1.20150909.1200: Corretti registri e pinout
--      1.20150630.1200: Prima release
--
-- Description:
--
-- Il modulo è una interfaccia tra un semplice bus e i pin di controllo del GBTX.
-- L'interfaccia che trasferisce i segnali al GBTX ha un circuito temporizzato per
-- generare impulsi di reset sul pin GBTX_RESETB. In mancanza di alimentazione GBTX
-- il pin è settato a '0', quando viene alimentato il pin di reset viene mantenuto
-- a 0 per circa 2 secondi e poi rilasciato. È anche possibile bloccare a '0' il
-- pin scrivendo "11111" su GBTX_RSTB. Il contenuto di questo registro viene
-- trasferito immediatamente al contatore, dove un valore diverso da "11111"
-- provoca un conteggio fino a "00000". Se il contatore non è azzerato il
-- GBTX_RESETB è a '0', quando il contatore raggiunge "00000" il GBTX_RESETB viene
-- rilasciato. La lettura di GBTX_RESETB riporta il valore del contatore.
-- L'interfaccia è un semplice bus con un selettore (ADD) del registro, un data
-- bus di ingresso (DI) , un data bus di uscita (DO) e due segnali di controllo,
-- uno di abilitazione generale (EN) e uno di abilitazione alla scrittura (WR),
-- entrambi attivi a '1'.
--
-- Targeted device: VHDL base dev. system
-- Author: Casimiro Baldanza
--
--------------------------------------------------------------------------------

library IEEE;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity GBTX_CTRL is
port (
--      GBTX_ARST       : out std_logic;                    -- CTRL-R0B0 GBTX autoreset function, '1' active
        GBTX_CONFIG     : out std_logic;                    -- CTRL-R0B1 Configuratio register access: '1'=I2C, '0'=IC
--      REFCLKSELECT    : out std_logic;                    -- CTRL-R0B2 GBTX Reference clock selector
--      STATEOVERRIDE   : out std_logic;                    -- CTRL-R0B3 GBTX State Override selector
        GBTX_TESTOUT    : in  std_logic;                    -- CTRL-R0B4 GBTX testout pin sample
-----------------------------------------------------------------------------------------------------------------------------
--      GBTX_MODE       : out std_logic_vector(3 downto 0); -- MODE-R1B3:0 Transceiver mode selection:
                                                            --    Encoding/Bus mode    Transceiver mode    MODE[3:0]
                                                            --    FEC                  Simplex TX         0000
                                                            --    FEC                  Simplex RX         0001
                                                            --    FEC                  Transceiver        0010
                                                            --    FEC                  Test               0011
                                                            --    WideBus              Simplex TX         0100
                                                            --    WideBus              Simplex RX         0101
                                                            --    WideBus              Transceiver        0110
                                                            --    WideBus              Test               0111
                                                            --    8b/10b               Simplex TX         1000
                                                            --    8b/10b               Simplex RX         1001
                                                            --    8b/10b               Transceiver        1010
                                                            --    8b/10b               Test               1011
                                                            --    (reserved)           (reserved)         1100
                                                            --    (reserved)           (reserved)         1101
                                                            --    (reserved)           (reserved)         1110
                                                            --    (reserved)           (reserved)         1111
-----------------------------------------------------------------------------------------------------------------------------
--      GBPS_TX_DISAB   : out std_logic;                    -- TXRX-R2B0 VTRx TX disable signal
        GBTX_TXDVALID   : out std_logic;                    -- TXRX-R2B1 TX data valid signal to GBTX
        GBTX_RXDVALID   : in  std_logic;                    -- TXRX-R2B2 GBTX data valid received from VTRx
        GBTX_RXRDY      : in  std_logic;                    -- TXRX-R2B3 RX is ready from GBTX
        GBTX_TXRDY      : in  std_logic;                    -- TXRX-R2B4 TX is ready from GBTX
        CONET_DISAB     : out std_logic;                    -- CONET-R2B5 CONET TX disable signal
-----------------------------------------------------------------------------------------------------------------------------
--      GBTX_SADD       : out std_logic_vector(3 downto 0); -- SADD-R3B3:0 GBTX I2C address
-----------------------------------------------------------------------------------------------------------------------------
        GBTX_RESETB     : out std_logic;                    -- RSTB-R4B4:0 GBTX Main Reset
-----------------------------------------------------------------------------------------------------------------------------
--      GBTX_RXLOCKM    : out std_logic_vector(1 downto 0); -- RXLK-R5B1:0 GBTX RX lock mode selection
                                                            -- RXLOCKMODE[1:0]      Receiver lock mode
                                                            --  00              I2C frequency calibration
                                                            --  01              Automatic DAC frequency calibration
                                                            --  10              Automatic Reference PLL frequency calibration
                                                            --  11              (reserved)
-----------------------------------------------------------------------------------------------------------------------------
        GBTX_POW        : in  std_logic;
-----------------------------------------------------------------------------------------------------------------------------
        DO      : out std_logic_vector(7 downto 0);
        DI      : in  std_logic_vector(7 downto 0);
        ADD     : in  std_logic_vector(3 downto 0);
        WR      : in  std_logic;
        EN      : in  std_logic;
-----------------------------------------------------------------------------------------------------------------------------
        EFUSEENAB : out  std_logic;
        EFUSESYNC : out  std_logic;
-----------------------------------------------------------------------------------------------------------------------------
        PXL_OFF	    :	out	std_logic;
        PXL_SDN	    :	in	std_logic;
        SERDES_SDN	:	out	std_logic;
        PSM_SP0	    :	in	std_logic;
        PSM_SP1	    :	in	std_logic;
        PSM_SI	    :	out	std_logic;
        PSM_SO	    :	in	std_logic;
        PSM_SCK	    :	in	std_logic;
-----------------------------------------------------------------------------------------------------------------------------
        Debug1   : out  std_logic;
        fbDebug1 : in   std_logic;
        Debug2   : out  std_logic;
        fbDebug2 : in   std_logic;
        DebugS   : out  std_logic;
--      TestSignal :  out  std_logic_vector(7 downto 0); -- 180205
--      fbTestSignal : in  std_logic_vector(7 downto 0); -- 180205
-----------------------------------------------------------------------------------------------------------------------------
        RESETn  : in    std_logic;
        P100mS  : in    std_logic;
        P1uS    : in    std_logic;
        P100uS  : in    std_logic;
        CLK     : in    std_logic
);
end GBTX_CTRL;
architecture GBTX_CTRL_beh of GBTX_CTRL is
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ******************************** FIRMWARE VERSION **********************************************************************************************************************
-- 16 bit version number YEAR,MONTH.DAY.TAG -------- year  | month  |   day   | number ------------------------------------------------------------------------------------
-- ************************************************************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Constant aI2C_addr0 : std_logic_vector(8 downto 0) := '0' & X"0C";
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
---------------------- Register -------------------------------|   Bit7    |   Bit6    |   Bit5    |   Bit4    |   Bit3    |   Bit2    |   Bit1    |   Bit0    |  Default   |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGBTX_CTRL : std_logic_vector(3 downto 0):="0000"; ---| Non usati.........................|  TESTOUT  | STATEOVER | REFCLKSEL |  CONFIG   |    ARST   | "xxxxxx1x" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aGBTX_MODE : std_logic_vector(3 downto 0):="0001"; ---| Non usati.................................... |                   GBTX_MODE                   | "xxxx0010" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGBTX_TXRX : std_logic_vector(3 downto 0):="0010"; ---| Non usati.............| CONET_DIS |  TXREADY  |  RXREADY  |  RXVALID  | TXDVALID  |  TX_DISAB | "xx0xxx0x" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aGBTX_SADD : std_logic_vector(3 downto 0):="0011"; ---| Non usati.................................... |                   GBTX_SADD                   | "xxxx1000" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGBTX_RSTB : std_logic_vector(3 downto 0):="0100"; ---| Non usati........................ |                       Reset Counter                       | "xxx11110" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aGBTX_RXLK : std_logic_vector(3 downto 0):="0101"; ---| Non usati............................................................ |     GBTX_RXLOCKM      | "xxxxxx10" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aVERSIONP1 : std_logic_vector(3 downto 0):="0110"; ---|           |                YEAR               |                    MONTH                      |  Version H | -- 180205
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aVERSIONP2 : std_logic_vector(3 downto 0):="0111"; ---|                            DAY                            |                 TAG               |  Version L | -- 180205
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aEFUSECTRL : std_logic_vector(3 downto 0):="1000"; ---|                                     COMMAND ('p';'d';'v')                                     |     'd'    |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aATMEGAPIN : std_logic_vector(3 downto 0):="1001"; ---|   PSM_SI  |   PSM_SO  |   PSM_SCK |  PSM_SP1  |  PSM_SP0  |  PXL_SDN  |  PXL_OFF  | SERDES_SDN| "0xxxxx00" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aATMEGAPTR : std_logic_vector(3 downto 0):="1010"; ---|                                  ATMEGA voltage data pointer                                  | "00000000" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aATMEGDATL : std_logic_vector(3 downto 0):="1011"; ---|                                        ATMEGA data read LSB                                   | "xxxxxxxx" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aATMEGDATH : std_logic_vector(3 downto 0):="1100"; ---| Non usati............................................................ | ATMEGA data read MSB  | "xxxxxxxx" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aATMEGRAWL : std_logic_vector(3 downto 0):="1101"; ---|                                        ATMEGA raw data read LSB                               | "xxxxxxxx" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aATMEGRAWH : std_logic_vector(3 downto 0):="1110"; ---| Non usati.............|                ATMEGA raw data read MSB                               | "xxxxxxxx" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aTESTSIGNL : std_logic_vector(3 downto 0):="1111"; ---|                                        TEST signal selector code                              | "xxxxxxxx" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--- STATEOVER, REFCLKSEL, ARST, GBTX_MODE GBTX_SADD, TX_DISAB, GBTX_RXLOCKM has been cut on DRM2
---
signal rGBTX_CTRL : std_logic_vector(7 downto 0);
--gnal rGBTX_MODE : std_logic_vector(7 downto 0);
signal rGBTX_TXRX : std_logic_vector(7 downto 0);
--gnal rGBTX_SADD : std_logic_vector(7 downto 0);
signal rGBTX_RSTB : std_logic_vector(7 downto 0);
--gnal rGBTX_RXLK : std_logic_vector(7 downto 0);
signal wEFUSECTRL : std_logic_vector(7 downto 0); -- Write side of the EFUSECTRL register
signal rEFUSECTRL : std_logic_vector(7 downto 0); -- Read side of the EFUSECTRL register
signal rATMEGAPIN : std_logic_vector(7 downto 0);
signal pATMEGAPTR : std_logic_vector(3 downto 0);
--------------------------------------------------------------
signal GBTX_RSTBcnt : std_logic_vector(4 downto 0);
signal GBTX_RSTBset : std_logic;
--gnal GBTX_RSTBdly : std_logic;
--gnal GBTX_RSTBpls : std_logic;
--------------------------------------------------------------
signal smATMEGAdata : integer range 0 to 15;
signal ATMEGAdataIN  : std_logic_vector(13 downto 0);
--signal ATMEGAOUdata  : std_logic_vector(13 downto 0);
signal rATMEGASO     : std_logic_vector(13 downto 0);
signal rATMEGASOadd  : std_logic_vector(3 downto 0);
signal rATMEGASOdat  : std_logic_vector(9 downto 0);
signal fATMEGASO     : std_logic;
signal cntATMEGAtime : integer range 0 to 1000;
signal cntATMEGAdata : integer range 0 to 20;
constant ccntATMEGAtime : integer := 100;
type ATMEGAdata_array is array (15 downto 0) of std_logic_vector(9 downto 0);
signal ATMEGAdata : ATMEGAdata_array;
--------------------------------------------------------------
constant CHAR_p : std_logic_vector(7 downto 0) := x"70";
constant CHAR_v : std_logic_vector(7 downto 0) := x"76";
constant CHAR_d : std_logic_vector(7 downto 0) := x"64";
constant EFUSESYNCTIME : integer := 200; -- uS
begin

    GBTX_CTRL_RW_handler : process (CLK)
    begin
    if CLK'event and CLK='1' then       
       if RESETn='0' then
            rGBTX_CTRL <="00000010";
--          rGBTX_MODE <="00000010";
            rGBTX_TXRX <="00000001";
--          rGBTX_SADD <="00001000";
            rGBTX_RSTB <="00010100";
--          rGBTX_RXLK <="00000010";
            rATMEGAPIN <="00000000";
            pATMEGAPTR <="0000";
            GBTX_RSTBset <= '1';
            wEFUSECTRL <=CHAR_d;
            DO <= X"00";
            fATMEGASO <= '0';
        else
            if EN='1' and WR='1' then
                case ADD is
                    when aGBTX_CTRL => rGBTX_CTRL <= DI;
--                  when aGBTX_MODE => rGBTX_MODE <= DI;
                    when aGBTX_TXRX => rGBTX_TXRX <= DI;
--                  when aGBTX_SADD => rGBTX_SADD <= DI;
                    when aGBTX_RSTB => rGBTX_RSTB <= DI;
                                       GBTX_RSTBset <= '1';
--                  when aGBTX_RXLK => rGBTX_RXLK <= DI;
                    when aEFUSECTRL => wEFUSECTRL <= DI;
                    when aATMEGAPIN => rATMEGAPIN <= DI;
---                 when aATMEGAREG => rATMEGAREG <= DI;
                    when aATMEGAPTR => pATMEGAPTR <= DI(3 downto 0);
-- 180205           when aTESTSIGNL => TestSignal <= DI;
                    when others     => NULL;
                end case;
            else
                case ADD is
                    when aGBTX_CTRL => DO <= '0'           &   -- Bit 7
                                             '0'           &   -- Bit 6
                                             '0'           &   -- Bit 5
                                             GBTX_TESTOUT  &   -- Bit 4
                                             rGBTX_CTRL(3) &   -- Bit 3
                                             rGBTX_CTRL(2) &   -- Bit 2
                                             rGBTX_CTRL(1) &   -- Bit 1 - CONFIG
                                             rGBTX_CTRL(0) ;   -- Bit 0
--                  when aGBTX_MODE => DO <= '0'           &   -- Bit 7
--                                           '0'           &   -- Bit 6
--                                           '0'           &   -- Bit 5
--                                           '0'           &   -- Bit 4
--                                           rGBTX_MODE(3) &   -- Bit 3
--                                           rGBTX_MODE(2) &   -- Bit 2
--                                           rGBTX_MODE(1) &   -- Bit 1
--                                           rGBTX_MODE(0) ;   -- Bit 0
                    when aGBTX_TXRX => DO <= '0'           &   -- Bit 7
                                             '0'           &   -- Bit 6
                                             rGBTX_TXRX(5) &   -- Bit 5
                                             GBTX_TXRDY    &   -- Bit 4
                                             GBTX_RXRDY    &   -- Bit 3
                                             GBTX_RXDVALID &   -- Bit 2
                                             rGBTX_TXRX(1) &   -- Bit 1
                                             '0'           ;   -- Bit 0
--                  when aGBTX_SADD => DO <= '0'           &   -- Bit 7
--                                           '0'           &   -- Bit 6
--                                           '0'           &   -- Bit 5
--                                           '0'           &   -- Bit 4
--                                           '0'           &   -- Bit 3
--                                           '0'           &   -- Bit 2
--                                           rGBTX_SADD(1) &   -- Bit 1
--                                           rGBTX_SADD(0) ;   -- Bit 0
                    when aGBTX_RSTB => DO <= "000" & GBTX_RSTBcnt;
--                  when aGBTX_RXLK => DO <= rGBTX_RXLK; -- Registro senza input esterni
-- 180205           when aVERSIONP1 => DO <= Version(15 downto 8);
-- 180205           when aVERSIONP2 => DO <= Version(7 downto 0);
                    when aEFUSECTRL => DO <= rEFUSECTRL;
                    when aATMEGAPIN => DO <= rATMEGAPIN(7)&   -- Bit 7
                                             PSM_SO       &   -- Bit 6
                                             PSM_SCK      &   -- Bit 5
                                             PSM_SP1      &   -- Bit 4
                                             PSM_SP0      &   -- Bit 3
                                             PXL_SDN      &   -- Bit 2
                                             rATMEGAPIN(1)&   -- Bit 1
                                             rATMEGAPIN(0);   -- Bit 0                    
                    when aATMEGDATL =>	case pATMEGAPTR is
                    					when "0000" => DO <= ATMEGAdata(0) (7 downto 0);
                    					when "0001" => DO <= ATMEGAdata(1) (7 downto 0);
                    					when "0010" => DO <= ATMEGAdata(2) (7 downto 0);
                    					when "0011" => DO <= ATMEGAdata(3) (7 downto 0);
                    					when "0100" => DO <= ATMEGAdata(4) (7 downto 0);
                    					when "0101" => DO <= ATMEGAdata(5) (7 downto 0);
                    					when "0110" => DO <= ATMEGAdata(6) (7 downto 0);
                    					when "0111" => DO <= ATMEGAdata(7) (7 downto 0);
                    					when "1000" => DO <= ATMEGAdata(8) (7 downto 0); 
                    					when "1001" => DO <= ATMEGAdata(9) (7 downto 0); 
                    					when "1010" => DO <= ATMEGAdata(10)(7 downto 0);
                    					when "1011" => DO <= ATMEGAdata(11)(7 downto 0);
                    					when "1100" => DO <= ATMEGAdata(12)(7 downto 0);
                    					when "1101" => DO <= ATMEGAdata(13)(7 downto 0);
                    					when "1110" => DO <= ATMEGAdata(14)(7 downto 0);
                    					when "1111" => DO <= ATMEGAdata(15)(7 downto 0);
										when others => null;
										end case;
                    when aATMEGDATH =>	case pATMEGAPTR is
                    					when "0000" => DO <= "000000" & ATMEGAdata(0) (9 downto 8);
                    					when "0001" => DO <= "000000" & ATMEGAdata(1) (9 downto 8);
                    					when "0010" => DO <= "000000" & ATMEGAdata(2) (9 downto 8);
                    					when "0011" => DO <= "000000" & ATMEGAdata(3) (9 downto 8);
                    					when "0100" => DO <= "000000" & ATMEGAdata(4) (9 downto 8);
                    					when "0101" => DO <= "000000" & ATMEGAdata(5) (9 downto 8);
                    					when "0110" => DO <= "000000" & ATMEGAdata(6) (9 downto 8);
                    					when "0111" => DO <= "000000" & ATMEGAdata(7) (9 downto 8);
                    					when "1000" => DO <= "000000" & ATMEGAdata(8) (9 downto 8);
                    					when "1001" => DO <= "000000" & ATMEGAdata(8) (9 downto 8);
                    					when "1010" => DO <= "000000" & ATMEGAdata(10)(9 downto 8);
                    					when "1011" => DO <= "000000" & ATMEGAdata(11)(9 downto 8);
                    					when "1100" => DO <= "000000" & ATMEGAdata(12)(9 downto 8);
                    					when "1101" => DO <= "000000" & ATMEGAdata(13)(9 downto 8);
                    					when "1110" => DO <= "000000" & ATMEGAdata(14)(9 downto 8);
                    					when "1111" => DO <= "000000" & ATMEGAdata(15)(9 downto 8);
   										when others => null;
										end case;
                    when aATMEGAPTR => DO <= "0000" & pATMEGAPTR; 
                    when aATMEGRAWL => DO <= rATMEGASO(7 downto 0); fATMEGASO <= '1';
                    when aATMEGRAWH => DO <= rATMEGASO(13 downto 10) & "00" & rATMEGASO(9 downto 8); fATMEGASO <= '0';
-- 180205           when aTESTSIGNL => DO <= fbTestSignal;
                    when others     => DO <= x"00";
                end case;
                GBTX_RSTBset <= '0';
                if rEFUSECTRL=CHAR_p then 
                    wEFUSECTRL <= CHAR_v;
--              else 
--                  wEFUSECTRL <= rEFUSECTRL;
                end if; 
            end if;
        end if;
    end if;
    end process;

    EFUSEpulse_handler : process(CLK)
    variable PULSECNT : integer  := 0;
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            EFUSEENAB <= '0'; -- Active at '1'
            EFUSESYNC <= '0'; -- Active at '1'
            rEFUSECTRL <= CHAR_d;
            PULSECNT := 0;
        else
            if PULSECNT=0 then
                EFUSESYNC <= '0';
                case wEFUSECTRL is
                when CHAR_v => rEFUSECTRL <= CHAR_v; EFUSEENAB <= '1';   
                when CHAR_p => if EFUSEENAB='1' then 
                               	   rEFUSECTRL <= CHAR_p;
                               	   PULSECNT := EFUSESYNCTIME; 
                               end if;
                when others => rEFUSECTRL <= CHAR_d; EFUSEENAB <= '0';
                end case;
             else
                if P1uS='1' then PULSECNT := PULSECNT-1; end if;
                EFUSESYNC <= '1';
                rEFUSECTRL <= CHAR_p;
             end if;
        end if;
    end if;
    end process;

    addressDEBUG : process(CLK)
    variable PULSECNT : integer  := 0;
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            DebugS <= '0';
            PULSECNT := 0;
        else
            case PULSECNT is
            when  0 => DebugS <= '1';
            when  1 => DebugS <= ATMEGAdataIN(0);
            when  2 => DebugS <= ATMEGAdataIN(1);
            when  3 => DebugS <= ATMEGAdataIN(2);
            when  4 => DebugS <= ATMEGAdataIN(3);
            when  5 => DebugS <= ATMEGAdataIN(4);
            when  6 => DebugS <= ATMEGAdataIN(5);
            when  7 => DebugS <= ATMEGAdataIN(6);
            when  8 => DebugS <= ATMEGAdataIN(7);
            when  9 => DebugS <= ATMEGAdataIN(8);
            when 10 => DebugS <= ATMEGAdataIN(9);
            when 11 => DebugS <= ATMEGAdataIN(10);
            when 12 => DebugS <= ATMEGAdataIN(11);
            when 13 => DebugS <= ATMEGAdataIN(12);
            when 14 => DebugS <= ATMEGAdataIN(13);
            when 15 => DebugS <= '1';
            when others => DebugS <= '0';
            end case;
            if PULSECNT=40 then 
                if fbDebug1='1' then 
                    PULSECNT := 0;
                else 
                    PULSECNT := PULSECNT; 
                end if;
            else 
                PULSECNT := PULSECNT+1;
            end if;
        end if;
    end if;
    end process;

    ATMEGAdata_handler : process(CLK)
--  variable smATMEGAdata : integer := 0;
--  variable cntATMEGAdata : integer range 0 to 15 := 0;
    constant stATMEGAstrt : integer := 0;
    constant stATMEGAidle : integer := 1;
    constant stATMEGAclk0 : integer := 2;
    constant stATMEGAclkU : integer := 3;
    constant stATMEGAclk1 : integer := 4;
    constant stATMEGAlast : integer := 5;
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            smATMEGAdata <= stATMEGAstrt;
            ATMEGAdata <= (others=>"0000000000");
            cntATMEGAtime <= ccntATMEGAtime;
            cntATMEGAdata <= 0;
            Debug1 <= '0';
            Debug2 <= '0';
            rATMEGASO <= "00000000000000";
            rATMEGASOdat <= "0000000000";
            rATMEGASOadd <= "0000";
        else 
            Debug2 <= PSM_SCK; 
            case smATMEGAdata is
            when stATMEGAstrt =>
                Debug1 <= '0';
                if PSM_SCK='1' then 
                    if P1uS='1' then 
                        cntATMEGAtime <= cntATMEGAtime-1;
                    elsif cntATMEGAtime=0 then
                        smATMEGAdata <= stATMEGAidle;
                    end if;
                else
                    cntATMEGAtime <= ccntATMEGAtime;
                end if;
                cntATMEGAdata <= 0;
            when stATMEGAidle => 
                Debug1 <= '0';
                if PSM_SCK='0' then 
                    smATMEGAdata <= stATMEGAclk0;
                    cntATMEGAdata <= 0;
                    ATMEGAdataIN <= "00000000000000";                
                end if;
            when stATMEGAclk0 => 
                Debug1 <= '0';
                if PSM_SCK='1' then 
                    smATMEGAdata <= stATMEGAclkU;
                end if;
            when stATMEGAclkU => 
                Debug1 <= '0';
                ATMEGAdataIN <= (ATMEGAdataIN sll 1);
                ATMEGAdataIN(0) <= PSM_SO;
                smATMEGAdata <= stATMEGAclk1;
                cntATMEGAtime <= ccntATMEGAtime;
                cntATMEGAdata <= cntATMEGAdata+1;
            when stATMEGAclk1 => 
                if cntATMEGAdata>14 then
                        smATMEGAdata <= stATMEGAstrt;
                elsif PSM_SCK='0' then 
                    smATMEGAdata <= stATMEGAclk0;
                else
                    if P1uS='1' then
                        cntATMEGAtime <= cntATMEGAtime-1;
                    elsif cntATMEGAtime=0 then
                        smATMEGAdata <= stATMEGAlast;
                    end if;
                end if;
            when stATMEGAlast => 
                if cntATMEGAdata=14 then
                    Debug1 <= '1';
                    case ATMEGAdataIN(13 downto 10) is
                    when "0000" => ATMEGAdata(0)  <= ATMEGAdataIN(9 downto 0);
                    when "0001" => ATMEGAdata(1)  <= ATMEGAdataIN(9 downto 0);
                    when "0010" => ATMEGAdata(2)  <= ATMEGAdataIN(9 downto 0);
                    when "0011" => ATMEGAdata(3)  <= ATMEGAdataIN(9 downto 0);
                    when "0100" => ATMEGAdata(4)  <= ATMEGAdataIN(9 downto 0);
                    when "0101" => ATMEGAdata(5)  <= ATMEGAdataIN(9 downto 0);
                    when "0110" => ATMEGAdata(6)  <= ATMEGAdataIN(9 downto 0);
                    when "0111" => ATMEGAdata(7)  <= ATMEGAdataIN(9 downto 0);
                    when "1000" => ATMEGAdata(8)  <= ATMEGAdataIN(9 downto 0);
                    when "1001" => ATMEGAdata(9)  <= ATMEGAdataIN(9 downto 0); 
                    when "1010" => ATMEGAdata(10) <= ATMEGAdataIN(9 downto 0); 
                    when "1011" => ATMEGAdata(11) <= ATMEGAdataIN(9 downto 0); 
                    when "1100" => ATMEGAdata(12) <= ATMEGAdataIN(9 downto 0); 
                    when "1101" => ATMEGAdata(13) <= ATMEGAdataIN(9 downto 0); 
                    when "1110" => ATMEGAdata(14) <= ATMEGAdataIN(9 downto 0); 
                    when "1111" => ATMEGAdata(15) <= ATMEGAdataIN(9 downto 0);
                    when others => null;
                    end case;
                    if fATMEGASO='0' then 
                        rATMEGASO <= ATMEGAdataIN;
                        rATMEGASOadd <= ATMEGAdataIN(13 downto 10);
                        rATMEGASOdat <= ATMEGAdataIN(9 downto 0);
                    end if;
                    smATMEGAdata <= stATMEGAidle;
                else
                    smATMEGAdata <= stATMEGAstrt;
                    Debug1 <= '0';
                end if;
            when others => 
                Debug1 <= '0';
                smATMEGAdata <= stATMEGAstrt;
                cntATMEGAtime <= ccntATMEGAtime;
            end case;
        end if;
    end if;
    end process;

    IO_handling : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
--          GBTX_ARST       <= '0';
            GBTX_CONFIG     <= '0';
--          GBTX_MODE       <= x"0";
--          GBTX_RXLOCKM    <= "00";
--          GBPS_TX_DISAB   <= '0';
            GBTX_TXDVALID   <= '0';
--          GBTX_SADD       <= x"0";
            CONET_DISAB     <= '0';
            SERDES_SDN      <= '0';
            PXL_OFF         <= '0';
            PSM_SI          <= '0';
        elsif EN='0' then
--              GBTX_ARST     <= rGBTX_CTRL(0); -- CTRL-R0B0 GBTX autoreset function, '1' active
                GBTX_CONFIG   <= rGBTX_CTRL(1); -- CTRL-R0B1 Configuratio register access: '1'=I2C, '0'=IC
--              REFCLKSELECT  <= rGBTX_CTRL(2); -- CTRL-R0B2 GBTX Reference clock selector
--              STATEOVERRIDE <= rGBTX_CTRL(3); -- CTRL-R0B3 GBTX State Override selector
--              rGBTX_CTRL(4) <= GBTX_TESTOUT ; -- CTRL-R0B4 GBTX testout pin sample
---------------------------------------------------------------------------------------------------
--              GBTX_MODE     <=
--                      rGBTX_MODE(3 downto 0); -- MODE-R1B3:0 Transceiver mode selection
---------------------------------------------------------------------------------------------------
--              GBPS_TX_DISAB <= rGBTX_TXRX(0); -- TXRX-R2B0 VTRx TX disable signal
                GBTX_TXDVALID <= rGBTX_TXRX(1); -- TXRX-R2B1 TX data valid signal to GBTX
                CONET_DISAB   <= rGBTX_TXRX(5); -- Enable CONET if '0'
--              rGBTX_TXRX(2) <= GBTX_RXDVALID; -- TXRX-R2B2 GBTX data valid received from VTRx
--              rGBTX_TXRX(3) <= GBTX_RXRDY   ; -- TXRX-R2B3 RX is ready from GBTX
--              rGBTX_TXRX(4) <= GBTX_TXRDY   ; -- TXRX-R2B4 TX is ready from GBTX
---------------------------------------------------------------------------------------------------
--              GBTX_SADD     <=
--                      rGBTX_SADD(3 downto 0); -- SADD-R3B3:0 GBTX I2C address
---------------------------------------------------------------------------------------------------
--              GBTX_RXLOCKM  <=
--                      rGBTX_RXLK(1 downto 0); -- RXLK-R5B1:0 GBTX RX lock mode selection
-----------------------------------------------------------------------------------------------------
                --rGBTX_CTRL(4)  <= GBTX_TESTOUT; -- GBTX testout pin sample
-----------------------------------------------------------------------------------------------------
                --rGBTX_TXRX(2)  <= GBTX_RXDVALID;-- GBTX data valid received from VTRx
                --rGBTX_TXRX(3)  <= GBTX_RXRDY  ; -- RX is ready from GBTX
                --rGBTX_TXRX(4)  <= GBTX_TXRDY  ; -- TX is ready from GBTX
-----------------------------------------------------------------------------------------------------
                SERDES_SDN    <= rATMEGAPIN(0);
                PXL_OFF       <= rATMEGAPIN(1);
                PSM_SI        <= rATMEGAPIN(7);                
-----------------------------------------------------------------------------------------------------
            end if;
        end if;
    end process;
-- Handler del RESETB globale del GBTX
-- Il reset della FPGA è attivo:
--	- Dopo la disattivazione del reset della FPGA il reset GBTX rimane attivo per il valore di default (20 o X"14) 
--	  impostato nel registro GBTX_RSTB moltiplicato per 100ms.
--	- L'alimentazione GBTX è disabilitata. Dopo l'abilitazione  il reset GBTX rimane attivo per il valore
--	- impostato nel registro moltiplicato per 100ms.
--	- Dopo una scrittura nel registro GBTX_RSTB per il valore impostato moltiplicato per 100ms
--	- Bloccato attivo se nel registro rGBTX_RSTB viene scritto "11111"

-- La lettura del registro restituisce X"00" se il reset GBTX non è attivo, altrimenti restituisce il il tempo in decimi di secondo nel quale sarà ancora attivo.
--
    GBTX_RESETB_handler : process (CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            GBTX_RESETB  <= '0';		
            GBTX_RSTBcnt <= "11110";	
--          GBTX_RSTBdly <= '0';
        else
--          if GBTX_POW = '0'      then             
--              GBTX_RSTBcnt <= "10100";
--          elsif GBTX_RSTBset='1' then             	
            if GBTX_RSTBset='1' and EN='0' then             	
                GBTX_RSTBcnt <= rGBTX_RSTB(4 downto 0);
            elsif P100mS='1' then
                if    GBTX_RSTBcnt = "00000" then GBTX_RSTBcnt <= "00000";
            	elsif GBTX_RSTBcnt = "11111" then GBTX_RSTBcnt <= "11111";
            	else                              GBTX_RSTBcnt <= GBTX_RSTBcnt - "00001";
                end if;
            end if;
--          GBTX_RSTBdly <= GBTX_RSTBset;
            GBTX_RESETB  <= not(GBTX_RSTBcnt(4) or
                                GBTX_RSTBcnt(3) or
                                GBTX_RSTBcnt(2) or
                                GBTX_RSTBcnt(1) or
                                GBTX_RSTBcnt(0));
        end if;
    end if;
    end process;


   -- architecture body
end GBTX_CTRL_beh;