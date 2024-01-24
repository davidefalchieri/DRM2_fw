--------------------------------------------------------------------------------
-- Company: INFN
-- 
-- File: uCTRL_Interface.vhd
-- File history:
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

entity uCTRL_Interface is
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
        EFUSEPLS : out  std_logic;
-----------------------------------------------------------------------------------------------------------------------------
        Version : in    std_logic_vector(15 downto 0);
        RESETn  : in    std_logic;
        P100mS  : in    std_logic;
        P1uS    : in    std_logic;
        CLK     : in    std_logic
);
end uCTRL_Interface;
architecture uCTRL_Interface_beh of uCTRL_Interface is
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ******************************** FIRMWARE VERSION **********************************************************************************************************************
-- 16 bit version number YEAR,MONTH.DAY.TAG -------- year  | month  |   day   | number ------------------------------------------------------------------------------------
--nstant Version : std_logic_vector(15 downto 0) := "0101" & "1100" & "01001" & "000"; -- A1500 modifications
--nstant Version : std_logic_vector(15 downto 0) := "0101" & "1011" & "10111" & "000"; -- INA rearrange
--nstant Version : std_logic_vector(15 downto 0) := "0101" & "1011" & "01001" & "000"; -- Correction on RESET GBTX
--nstant Version : std_logic_vector(15 downto 0) := "0101" & "1011" & "01001" & "000"; -- First release       
-- ************************************************************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Constant aI2C_addr0 : std_logic_vector(8 downto 0) := '0' & X"0C";
--------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
---------------------- Register -------------------------------|   Bit7    |   Bit6    |   Bit5    |   Bit4    |   Bit3    |   Bit2    |   Bit1    |   Bit0    |  Default   |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant auCTRL_Interface : std_logic_vector(3 downto 0):="0000"; ---| Non usati.........................|  TESTOUT  | STATEOVER | REFCLKSEL |  CONFIG   |    ARST   | "00000010" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aGBTX_MODE : std_logic_vector(3 downto 0):="0001"; ---| Non usati.................................... |                   GBTX_MODE                   | "xxxx0010" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGBTX_TXRX : std_logic_vector(3 downto 0):="0010"; ---| Non usati.............| CONET_DIS |  TXREADY  |  RXREADY  |  RXVALID  | TXDVALID  |  TX_DISAB | "xxx...01" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aGBTX_SADD : std_logic_vector(3 downto 0):="0011"; ---| Non usati.................................... |                   GBTX_SADD                   | "xxxx1000" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGBTX_RSTB : std_logic_vector(3 downto 0):="0100"; ---| Non usati........................ |                       Reset Counter                       | "xxx11110" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--nstant aGBTX_RXLK : std_logic_vector(3 downto 0):="0101"; ---| Non usati............................................................ |     GBTX_RXLOCKM      | "xxxxxx10" |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGBTX_VERH : std_logic_vector(3 downto 0):="0110"; ---|           |                YEAR               |                    MONTH                      |  Version H |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGBTX_VERL : std_logic_vector(3 downto 0):="0111"; ---|                            DAY                            |                 TAG               |  Version L |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aEFUSECTRL : std_logic_vector(3 downto 0):="1000"; ---|                                     COMMAND ('p';'d';'v')                                     |     'd'    |
---------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--- STATEOVER, REFCLKSEL, ARST, GBTX_MODE GBTX_SADD, TX_DISAB, GBTX_RXLOCKM has been cut on DRM2
---
signal ruCTRL_Interface : std_logic_vector(7 downto 0);
--gnal rGBTX_MODE : std_logic_vector(7 downto 0);
signal rGBTX_TXRX : std_logic_vector(7 downto 0);
--gnal rGBTX_SADD : std_logic_vector(7 downto 0);
signal rGBTX_RSTB : std_logic_vector(7 downto 0);
--gnal rGBTX_RXLK : std_logic_vector(7 downto 0);
signal wEFUSECTRL : std_logic_vector(7 downto 0); -- Write side of the EFUSECTRL register
signal rEFUSECTRL : std_logic_vector(7 downto 0); -- Read side of the EFUSECTRL register
--------------------------------------------------------------
signal GBTX_RSTBcnt : std_logic_vector(4 downto 0);
signal GBTX_RSTBset : std_logic;
--gnal GBTX_RSTBdly : std_logic;
--gnal GBTX_RSTBpls : std_logic;
--------------------------------------------------------------
constant CHAR_p : std_logic_vector(7 downto 0) := x"70";
constant CHAR_v : std_logic_vector(7 downto 0) := x"76";
constant CHAR_d : std_logic_vector(7 downto 0) := x"64";
constant EFUSEPLSTIME : integer := 200; -- uS
begin

    uCTRL_Interface_RW_handler : process (CLK)
    begin
    if CLK'event and CLK='1' then       
       if RESETn='0' then
            ruCTRL_Interface <="00000010";
--          rGBTX_MODE <="00000010";
            rGBTX_TXRX <="00000001";
--          rGBTX_SADD <="00001000";
            rGBTX_RSTB <="00010100";
--          rGBTX_RXLK <="00000010";
            GBTX_RSTBset <= '1';
            wEFUSECTRL <=CHAR_d;
            DO <= X"00";
        else
            if EN='1' and WR='1' then
                case ADD is
                    when auCTRL_Interface => ruCTRL_Interface <= DI;
--                  when aGBTX_MODE => rGBTX_MODE <= DI;
                    when aGBTX_TXRX => rGBTX_TXRX <= DI;
--                  when aGBTX_SADD => rGBTX_SADD <= DI;
                    when aGBTX_RSTB => rGBTX_RSTB <= DI;
                                       GBTX_RSTBset <= '1';
--                  when aGBTX_RXLK => rGBTX_RXLK <= DI;
                    when aEFUSECTRL => rEFUSECTRL <= DI;
                    when others     => NULL;
                end case;
            else
                case ADD is
                    when auCTRL_Interface => DO <= '0'           &   -- Bit 7
                                             '0'           &   -- Bit 6
                                             '0'           &   -- Bit 5
                                             GBTX_TESTOUT  &   -- Bit 4
                                             ruCTRL_Interface(3) &   -- Bit 3
                                             ruCTRL_Interface(2) &   -- Bit 2
                                             ruCTRL_Interface(1) &   -- Bit 1
                                             ruCTRL_Interface(0) ;   -- Bit 0
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
                    when aGBTX_RSTB => DO <= rGBTX_RSTB(7) & "00" & GBTX_RSTBcnt;
--                  when aGBTX_RXLK => DO <= rGBTX_RXLK; -- Registro senza input esterni
                    when aGBTX_VERH => DO <= Version(15 downto 8);
                    when aGBTX_VERL => DO <= Version(7 downto 0);
                    when aEFUSECTRL => DO <= rEFUSECTRL;
                    when others     => NULL;
                end case;
                GBTX_RSTBset <= '0';
                if rEFUSECTRL=CHAR_p then 
                    wEFUSECTRL <= CHAR_v;
                else 
                    wEFUSECTRL <= rEFUSECTRL;
                end if;
            end if;
        end if;
    end if;
    end process;

    EFUSEpulse_handler : process(CLK)
    variable PULSECNT : integer range 0 to 200 := 0;
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            EFUSEENAB <= '0'; -- Active at '1'
            EFUSEPLS <= '0'; -- Active at '1'
            rEFUSECTRL <= CHAR_d;
            PULSECNT := 0;
        else
            if PULSECNT=0 then
                EFUSEPLS <= '0';
                case wEFUSECTRL is
                when CHAR_v => rEFUSECTRL <= CHAR_v; EFUSEENAB <= '1';   
                when CHAR_p => rEFUSECTRL <= CHAR_v;
                               if EFUSEENAB='1' then 
                                    PULSECNT := EFUSEPLSTIME; 
                               end if;
                when others => rEFUSECTRL <= CHAR_d; EFUSEENAB <= '0';
                end case;
             else
                PULSECNT := PULSECNT-1;
                EFUSEPLS <= '1';
                rEFUSECTRL <= CHAR_p;
             end if;
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
        elsif EN='0' then
--              GBTX_ARST     <= ruCTRL_Interface(0); -- CTRL-R0B0 GBTX autoreset function, '1' active
                GBTX_CONFIG   <= ruCTRL_Interface(1); -- CTRL-R0B1 Configuratio register access: '1'=I2C, '0'=IC
--              REFCLKSELECT  <= ruCTRL_Interface(2); -- CTRL-R0B2 GBTX Reference clock selector
--              STATEOVERRIDE <= ruCTRL_Interface(3); -- CTRL-R0B3 GBTX State Override selector
--              ruCTRL_Interface(4) <= GBTX_TESTOUT ; -- CTRL-R0B4 GBTX testout pin sample
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
                --ruCTRL_Interface(4)  <= GBTX_TESTOUT; -- GBTX testout pin sample
-----------------------------------------------------------------------------------------------------
                --rGBTX_TXRX(2)  <= GBTX_RXDVALID;-- GBTX data valid received from VTRx
                --rGBTX_TXRX(3)  <= GBTX_RXRDY  ; -- RX is ready from GBTX
                --rGBTX_TXRX(4)  <= GBTX_TXRDY  ; -- TX is ready from GBTX
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
            if GBTX_RSTBset='1' then             	
                GBTX_RSTBcnt <= rGBTX_RSTB(4 downto 0);
            elsif P100mS='1' or rGBTX_RSTB(7)='1' then --- SOSTITUIRE CON elsif P100mS='1' then
                if    GBTX_RSTBcnt = "00000" then   
                    GBTX_RSTBcnt <= "00000";
            	elsif GBTX_RSTBcnt = "11111" then   
                    GBTX_RSTBcnt <= "11111";
            	else                                
                    GBTX_RSTBcnt <= GBTX_RSTBcnt - "00001";
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
end uCTRL_Interface_beh;