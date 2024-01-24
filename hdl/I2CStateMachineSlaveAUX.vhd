--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File history:
--      1.20161231.1110: Aggiunto ripristino iniziale segnali
--      1.20150915.1610: Modificata sequenza GBTX control signal
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

entity I2CStateMachineSlaveAUX is
port (
--- APB COREI2C BUS ---------------------------------------------------------------------- 
    PRDATA  : in    std_logic_vector(7  downto 0);      --  APB DATA READ
    PWDATA  : out   std_logic_vector(7  downto 0);      --  APB DATA WRITE
    PADDR   : out   std_logic_vector(8  downto 0);      --  APB ADDRESS
    PSELx   : out   std_logic;                          --  APB PSELx
    PENABLE : out   std_logic;                          --  APB ENABLE
    PWRITE  : out   std_logic;                          --  APB WRITE
    PINT    : in    std_logic;                          --  APB READY
--- DECODER BUS --------------------------------------------------------------------------
    ENCMD  : out    std_logic; ENCMDi : in std_logic;   -- DECBUS: Command valid with feedback                     
    ENDATA : out    std_logic; ENDATAi: in std_logic;   -- DECBUS: Data valid with feedback
    ENWR   : out    std_logic;                          -- DECBUS: Write
    DIN    : in     std_logic_vector(7 downto 0);       -- DECBUS: Data from decoder
    DOUT   : out    std_logic_vector(7 downto 0);       -- DECBUS: Data to decoder
    FRDY   : in     std_logic;                          -- DECBUS: flag DATAREADY from decoder
    FERR   : in     std_logic;                          -- DECBUS: flag ERROR from decoder
    FEND   : in     std_logic;                          -- DECBUS: flag ENDOFDATA from decoder
--------------------------------------------------------------------------
    RESETn  : in    std_logic;
    CLK     : in    std_logic
);
end I2CStateMachineSlaveAUX;
architecture I2CStateMachineSlaveAUX_beh of    I2CStateMachineSlaveAUX    is
-- signal, component etc. declarations

-- type RAMblock_type is array (0 to 511) of std_logic_vector(7 downto 0);
-- signal RAMblock : RAMblock_type := (others => X"00");

signal    APBsm : integer range 0 to  15;
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

signal    INTsm     : integer range 0 to 7;
constant cINTsmREAD     : integer := 0;
constant cINTsmREADdly  : integer := 1;
constant cINTsmSTATUS   : integer := 2;
constant cINTsmWAITACK  : integer := 3;
constant cINTsmSETAPB   : integer := 4;
constant cINTsmAPBdly   : integer := 5;

Constant aI2C_addr0 : std_logic_vector(8 downto 0) := '0' & X"0C";
Constant aI2C_ctrl  : std_logic_vector(8 downto 0) := "000000000";
Constant aI2C_data  : std_logic_vector(8 downto 0) := '0' & X"08";
Constant aI2C_stat  : std_logic_vector(8 downto 0) := '0' & X"04";

Constant cSTmDRxA_50     : std_logic_vector(7 downto 0) := X"50";
Constant cSTmDRxNA_58    : std_logic_vector(7 downto 0) := X"58";
Constant cSTmDTxA_28     : std_logic_vector(7 downto 0) := X"28";
Constant cST_Idle_F8           : std_logic_vector(7 downto 0) := X"F8";
Constant cSTmReSta_10    : std_logic_vector(7 downto 0) := X"10";
Constant cSTmSLARA_40    : std_logic_vector(7 downto 0) := X"40";
Constant cSTmSLAWA_18    : std_logic_vector(7 downto 0) := X"18";
Constant cSTmStart_08      : std_logic_vector(7 downto 0) := X"08";
Constant cSTmStop_E0  : std_logic_vector(7 downto 0) := X"E0";
Constant cSTsSLAWA_60     : std_logic_vector(7 downto 0) := X"60";
Constant cSTsSLARA_A8     : std_logic_vector(7 downto 0) := X"A8";
Constant cSTsStop_A0        : std_logic_vector(7 downto 0) := X"A0";
Constant cSTsDRxA_80     : std_logic_vector(7 downto 0) := X"80";
Constant cSTsDRxNA_88    : std_logic_vector(7 downto 0) := X"88";
Constant cSTsDTxA_B8     : std_logic_vector(7 downto 0) := X"B8";
Constant cSTsDTxNA_C0    : std_logic_vector(7 downto 0) := X"C0";
Constant cSTsDTxLA_C8    : std_logic_vector(7 downto 0) := X"C8";

-------- I2C STATUS constant
Constant cGI2CBSY	: std_logic_vector(7 downto 0) := X"91";
Constant cGI2CEPTY	: std_logic_vector(7 downto 0) := X"92";
Constant cGI2CERR	: std_logic_vector(7 downto 0) := X"A0"; --- ORed with I2C error/8

Constant cGCRERRO	: std_logic_vector(7 downto 0) := X"C0"; --- Overflow error GBTX controller

Constant cCMDERR	: std_logic_vector(7 downto 0) := X"FF";

Constant cI2CNXT	: std_logic_vector(7 downto 0) := X"00";
Constant cI2CEND	: std_logic_vector(7 downto 0) := X"FF";

-------- I2C COMMAND constant
Constant cGI2CWR	: std_logic_vector(7 downto 0) := X"10";
Constant cGI2CRD	: std_logic_vector(7 downto 0) := X"11";
Constant cGI2CABORT	: std_logic_vector(7 downto 0) := X"12";

Constant cGCRCTRL	: std_logic_vector(7 downto 0) := x"40";
Constant cGCRMODE	: std_logic_vector(7 downto 0) := x"41";
Constant cGCRTXRX	: std_logic_vector(7 downto 0) := x"42";
Constant cGCRSADD	: std_logic_vector(7 downto 0) := x"43";
Constant cGCRRSTB	: std_logic_vector(7 downto 0) := x"44";
Constant cGCRRXLK	: std_logic_vector(7 downto 0) := x"45";

constant GPOWCTRL	: std_logic_vector(7 downto 0) := X"20";
constant GPOWCONF	: std_logic_vector(7 downto 0) := X"21";
constant GPOWVSHN	: std_logic_vector(7 downto 0) := X"22";
constant GPOWVBUS	: std_logic_vector(7 downto 0) := X"23";
constant GPOWPOWR	: std_logic_vector(7 downto 0) := X"24";
constant GPOWCURR	: std_logic_vector(7 downto 0) := X"25";
constant GPOWPCAL	: std_logic_vector(7 downto 0) := X"26";

-------- Phase 2 status
Constant cRXBEGIN : std_logic_vector(7 downto 0) := X"B0"; --> RXDAK44             
Constant cTXTEST  : std_logic_vector(7 downto 0) := X"A0"; --> TXDAK40 or TXDAK44  
Constant cRXNEXT  : std_logic_vector(7 downto 0) := X"C0"; --> RXDAK44             
Constant cTXNEXT  : std_logic_vector(7 downto 0) := X"C1"; --> TXDAK44             
Constant cTXEND   : std_logic_vector(7 downto 0) := X"E0"; --> TXEND44             
Constant cRXEND   : std_logic_vector(7 downto 0) := X"E1"; --> RXDAK44             

--nstant cGCRCTRL      : std_logic_vector(7 downto 0) := X"40"; Uguale a status

---+----------------------------------------------------------------------------------+
-- |                                     CONSTANTS                                    |
---+------------------------------------------------------------------+-+-+-+-+-+-+-+-+
-- |                                                                  |c|e|s|s|s|a|c|c|
-- |                                                                  |r|n|t|t|i|a|r|r|
-- |                                                                  |2|s|a|o| | |1|0|
---+------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_ClearI2C_00 : std_logic_vector(7 downto 0) := X"00";  --|0|0|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_StarcST60 : std_logic_vector(7 downto 0) := X"60";  --|0|1|1|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_ReStart_60  : std_logic_vector(7 downto 0) := X"60";  --|0|1|1|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxAddW_40   : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxAddR_40   : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxDATA_40   : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxLAST_40   : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxDAck_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
Constant cI2C_RxDAck_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
Constant cI2C_TxEnab_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
Constant cI2C_RxEnab_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxWait_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxDAckN_40  : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_StopI2C_50  : std_logic_vector(7 downto 0) := X"50";  --|0|1|0|1|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
signal DAPBWsm    : std_logic_vector(7 downto 0) := x"00";
signal PCTRL    : std_logic_vector(7 downto 0) := x"00";
signal PDATAW   : std_logic_vector(7 downto 0) := x"00";
signal PDATAR   : std_logic_vector(7 downto 0) := x"00";
signal PSTATUS  : std_logic_vector(7 downto 0) := x"00";
signal PREADen  : std_logic := '0';
signal PWRITEen : std_logic := '0';
signal PBUSY    : std_logic := '0';
--
signal FirstDATA : std_logic := '0';
--
--gnal I2CEND    : std_logic_vector(2 downto 0);
signal I2CENDset : std_logic := '0';
--
signal I2CCLRflg : std_logic := '0'; -- Flag clear COREI2C when unknow condition §
signal I2CSTAflg : std_logic  := '0'; -- Flag START COREI2C slave mode §
--
signal I2CCMD      : std_logic_vector(7 downto 0) := x"00";
--
-- signal GI2CERRcode : std_logic_vector(7 downto 0) := x"00";
--
signal FiEPTYd : std_logic := '0';
--
signal I2CRX  : std_logic := '0';
--
begin

    I2C_StateMachine : process(CLK)
    variable vI2CRX  : std_logic;
    variable vBlkAddr : std_logic_vector(7 downto 0); -- Original GBTX address
    begin
--- I00 ------------------------------------------------------------------------------------------------------------------------------------------
    if CLK'event and CLK='1' then
        if RESETn='0' then
            INTsm <= cINTsmREAD;
            DOUT <= X"FF";
            PREADen <= '0'; PWRITEen <= '0';
            PDATAW  <= X"00";
            I2CCMD  <= X"00";
            I2CCLRflg <= '1';
            FiEPTYd <= '0';
--          GFIDATA <= X"00";
            I2CRX   <= '0';
            I2CSTAflg <= '0';
--          GI2CERRcode <= X"00";
            I2CENDset <= '0';
--          I2CABORTset <= '0';
            PCTRL   <= X"00";
            ENWR <= '0'; ENDATA <= '0'; ENCMD <= '0';
        else
--- I01-------------------------------------------------------------------------------------------------------------------------------------------
            if    PBUSY='1' or PWRITEen='1' or PREADen='1' then 
            	if PWRITEen ='1' then PWRITEen <= not PBUSY; end if;
            	if PREADen  ='1' then PREADen  <= not PBUSY; end if;
--- I02 ----------------------------------------------------------------------------------------------------------------------------------------
            elsif I2CCLRflg='1' then
                PCTRL <= cI2C_ClearI2C_00;
                PWRITEen <= '1';
                I2CCLRflg <= '0';
                I2CSTAflg <= '1';
--- I03 ------------------------------------------------------------------------------------------------------------------------------------------
            elsif I2CSTAflg='1' then
                PCTRL <= cI2C_RxEnab_44;
                PWRITEen <= '1';
                I2CSTAflg <= '0';
--- I04 ------------------------------------------------------------------------------------------------------------------------------------------
            elsif PINT='1' and PBUSY='0' then
--- I04a -----------------------------------------------------------------------------------------------------------------------------------------
                case INTsm is
                when cINTsmREAD   =>
                    PREADen <= '1';
                    INTsm <= cINTsmREADdly;
--- I04b -----------------------------------------------------------------------------------------------------------------------------------------
                when cINTsmREADdly  =>
                    INTsm <= cINTsmSTATUS; --<-- Delay
--- I04c -----------------------------------------------------------------------------------------------------------------------------------------
                when cINTsmSTATUS =>
                    case PSTATUS is
--------------------------------------------------------------------------------------------------------------------------------------------------
--- I04ca: Own SLA + W has been received; ACK has been returned. -- This is a MASTER WRITE operation ----------------------------------------------
                    when cSTsSLAWA_60         =>    NULL;
                                                    DAPBWsm <= cRXBEGIN;                    
                                                    DOUT <= PDATAR;
                                                    I2CRX <= '0';
                                                    FirstDATA <= '1';              
                                                    ENWR <= '0'; ENDATA <= '0'; ENCMD <= '0';
--------------------------------------------------------------------------------------------------------------------------------------------------
--- I04cb: Previously addressed with own SLV address; DATA has been received; ACK returned. -------------------------------------------------------
                    when cSTsDRxA_80          =>    NULL;
--------------------------------------------------------------------------------------------------------------------------------------------------
                                                    if FirstDATA='1' then
--------------------------------------------------------------------------------------------------------------------------------------------------
                                                    DAPBWsm <= cRXNEXT;                     
                                                    DOUT <= PDATAR;
                                                    FirstDATA <= '0';                
                                                    ENWR <= '1'; ENDATA <= '0'; ENCMD <= '1';
--------------------------------------------------------------------------------------------------------------------------------------------------
                                                    else
                                                    DAPBWsm <= cRXNEXT;                     
                                                    DOUT <= PDATAR;
                                                    FirstDATA <= '0';                
                                                    ENWR <= '1'; ENDATA <= '1'; ENCMD <= '0';
                                                    end if;

--------------------------------------------------------------------------------------------------------------------------------------------------
--- I04cc: Own SLA + R has been received; ACK has been returned -----------------------------------------------------------------------------------
                    when cSTsSLARA_A8         =>    NULL;
                                                    DAPBWsm <= cTXTEST;                    
                                                    I2CRX <= '1';
                                                    ENWR <= '0'; ENDATA <= '0'; ENCMD <= '1';
--------------------------------------------------------------------------------------------------------------------------------------------------
--- I04cd: Data byte has been transmitted; ACK has been received. ---------------------------------------------------------------------------------
                    when cSTsDTxA_B8            =>  NULL;
                                                    DAPBWsm <= cTXTEST;                    
                                                    ENWR <= '0'; ENDATA <= '1'; ENCMD <= '0';
--------------------------------------------------------------------------------------------------------------------------------------------------
--- I04ce: ---------- A STOP condition or repeated START condition has been received. -------------------------------------------------------------
                    when cSTsStop_A0            =>  NULL;
                                                    if I2CRX='1' then DAPBWsm <= cRXEND; else DAPBWsm <= cTXEND; end if;                    
--                                                  DOUT <= X"00";
--                                                  ENWR <= '0'; ENDATA <= '0'; ENCMD <= '0';
--- I04cf: ---------- Data byte has been transmitted; NACK has been received. ---------------------------------------------------------------------
-------------------- Last data byte has transmitted; ACK has received. ---------------------------------------------------------------------------
                    when cSTsDTxNA_C0 | cSTsDTxLA_C8 =>  NULL;
                                                    DAPBWsm <= cTXEND;                    
--                                                  DOUT <= X"00";
--                                                  ENWR <= '0'; ENDATA <= '0'; ENCMD <= '0';
--- I04cg: ---------- Previously addressed with own SLA; DATA byte has been received; NACK returned -----------------------------------------------
                    when cSTsDRxNA_88 =>  NULL;
                                                    DAPBWsm <= cRXEND;                    
--                                                  DOUT <= X"00";
--                                                  ENWR <= '0'; ENDATA <= '0'; ENCMD <= '0';
--------------------------------------------------------------------------------------------------------------------------------------------------
--- I04ch: Error condition ------------------------------------------------------------------------------------------------------------------------
                    when others                 =>  I2CCLRflg <= '1';
                    end case;
--------------------------------------------------------------------------------------------------------------------------------------------------
                    INTsm <= cINTsmWAITACK; 
--- I04d: ------------------------------------------------------------------------------------------------------------------------------------------
                when cINTsmWAITACK =>               NULL;
						    if FRDY='1' or FERR='1' or FEND='1' or (ENCMDi='0' and ENDATAi='0') then 
                                                        INTsm <= cINTsmSETAPB; --<-- Delay
                                                    end if;
--- I04e: ------------------------------------------------------------------------------------------------------------------------------------------
                when cINTsmSETAPB =>
                    case DAPBWsm is
--- I04ea: ----------------------------------------------------------------------------------------------------------------------------------------
                    when cRXBEGIN =>                NULL;
                                                    PCTRL <= cI2C_RxDAck_44;                    ----- Set data byte will be received
                                                    PWRITEen  <= '1';                           ----- ACK will be returned
--- I04eb: ----------------------------------------------------------------------------------------------------------------------------------------
                    when cRXNEXT  =>                NULL;
                                                    PCTRL <= cI2C_RxDAck_44;                    ----- Set data byte will be received
                                                    PWRITEen  <= '1';                           ----- ACK will be returned
--- I04ec: ----------------------------------------------------------------------------------------------------------------------------------------
                    when cTXTEST  =>                NULL;
                                                    if     FERR='1' then
                                                    PDATAW <= DIN;
                                                    PCTRL <= cI2C_TxLAST_40;                    ----- Last data byte will be transmitted;
                                                    PWRITEen  <= '1';                           ----- ACK will be returned
                                                    elsif  FEND='1' then
                                                    PDATAW <= DIN;
                                                    PCTRL <= cI2C_TxLAST_40;                    ----- Last data byte will be transmitted
                                                    PWRITEen  <= '1';                           ----- ACK will be returned
                                                    else
                                                    PDATAW <= DIN;
                                                    PCTRL <= cI2C_TxDAck_44;                    ----- Data byte will be transmitted
                                                    PWRITEen  <= '1';                           ----- ACK will be returned
                                                    end if;
--- I04ed: ----------------------------------------------------------------------------------------------------------------------------------------
                    when cTXEND | cRXEND   =>       NULL;
                                                    PDATAW <= DIN;
                                                    PCTRL <= cI2C_RxEnab_44;                    ----- Switched to not-addressed SLV mode
                                                    PWRITEen  <= '1';                           ----- Own SLA or general call address 
                                                                                                ----- will be recognized.
                    when others            =>       NULL;
                    end case;
--------------------------------------------------------------------------------------------------------------------------------------------------
                    INTsm <= cINTsmAPBdly; 
                    ENWR <= '0'; ENDATA <= '0'; ENCMD <= '0';
--- I04f ------------------------------------------------------------------------------------------------------------------------------------------
                when cINTsmAPBdly =>                
                    if FRDY='1' or FERR='1' or FEND='1' then
                        NULL; 
                    else 
                        INTsm <= cINTsmREAD; 
                    end if;
                when others       =>                
                        INTsm <= cINTsmREAD; 
                end case;
            end if;
        end if;
    end if;
    end process;
--------------------------------------------------------------------------------------------------------------------------------------------------
    APB_StateMachine : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            APBsm <= cAPBsmIDLE;
            PSELx     <= '1';
            PENABLE   <= '0';
            PWRITE    <= '0';
            PWDATA    <= X"00";
            PDATAR    <= X"00";
            PBUSY     <= '0';
        else
            case APBsm is
-- A01 -------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmIDLE     =>  if    PREADen ='1' then PBUSY <= '1'; APBsm <= cAPBsmRDDs;
                                    elsif PWRITEen='1' then PBUSY <= '1'; APBsm <= cAPBsmWRDs;
                                    else                    PBUSY <= '0'; end if;
-- A02 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmRDDs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_data; APBsm <= cAPBsmRDDe;
-- A03 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmRDDe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '0'; PADDR <= aI2C_data; APBsm <= cAPBsmRDDx;
-- A04 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmRDDx     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_data; APBsm <= cAPBsmRDSs; PDATAR  <= PRDATA;
-- A05 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmRDSs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_stat; APBsm <= cAPBsmRDSe;
-- A06 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmRDSe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '0'; PADDR <= aI2C_stat; APBsm <= cAPBsmRDSx;
-- A07 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmRDSx     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_stat; APBsm <= cAPBsmDEBG; PSTATUS <= PRDATA;
-- A08 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmWRDs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_data; APBsm <= cAPBsmWRDe; PWDATA <= PDATAW;
-- A09 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmWRDe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '1'; PADDR <= aI2C_data; APBsm <= cAPBsmWRDx;
-- A10 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmWRDx     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_data; APBsm <= cAPBsmWRCs;
-- A11 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmWRCs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_ctrl; APBsm <= cAPBsmWRCe; PWDATA <= PCTRL;
-- A12 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmWRCe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '1'; PADDR <= aI2C_ctrl; APBsm <= cAPBsmWRCx;
-- A13 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmWRCx     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_ctrl; APBsm <= cAPBsmDEBG;
-- A14 ------------------------------------------------------------------------------------------------------------------------------------------------
            when cAPBsmDEBG     =>                                                                   APBsm <= cAPBsmIDLE;
-------------------------------------------------------------------------------------------------------------------------------------------------------
            when others         =>                                                                   APBsm <= cAPBsmIDLE;
            end case;
        end if;
    end if;
    end process;


end I2CStateMachineSlaveAUX_beh;