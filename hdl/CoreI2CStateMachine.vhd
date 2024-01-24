--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Company: INFN
--
-- File: I2CState Machine2.vhd
-- File history:
--      1.20171013.1456: Correzione. PBUSY blocca la sequenza principale
--      1.20170804.1433: Modifica in ricezione, corretto momento in cio va insrito ultimo dato[2]
--      1.20170801.1612: Modifica in ricezione, inserito ultimo read con NACK subito dopo address, con DATANUM=1 [1]
--      1.20170404.1530: Validato                    
--      1.20151231.1120: Aggiunti ripristini iniziali
--      1.20151210.1159: Versione iniziale
--      1.20150731.1159: inserito messaggio errore separato da FoDATA
--      1.20150604.1418: corretta funzione con status=0x58
--      1.20150428.1139: tolto PREADY
--      1.20150424.2330: Inizio
-- Description:
--
-- Controller per CoreI2C ottimizzato per comunicazione con GBTX
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity CoreI2CStateMachine is 
port (
        PRDATA  : in    std_logic_vector(7  downto 0);  --  APB DATA READ
        PWDATA  : out   std_logic_vector(7  downto 0);  --  APB DATA WRITE
        PADDR   : out   std_logic_vector(8  downto 0);  --  APB ADDRESS
        PSELx   : out   std_logic;                      --  APB PSELx
        PENABLE : out   std_logic;                      --  APB ENABLE
        PWRITE  : out   std_logic;                      --  APB WRITE
--      PREADY  : in    std_logic;                      --  APB READY
        PINT    : in    std_logic;                      --  APB READY
        FiDATA  : in    std_logic_vector(7  downto 0);
        FoDATA  : out   std_logic_vector(7  downto 0);
        FoERRM  : out   std_logic_vector(7  downto 0);
        FiFULL  : in    std_logic;
        FoFULL  : in    std_logic;
        ERROR   : out   std_logic;
        FiEPTY  : in    std_logic;
        FoEPTY  : in    std_logic;
        I2CRUN  : in    std_logic;
        I2CBSY  : out   std_logic;
        I2CWRT  : in    std_logic;
        I2CRADD : in    std_logic_vector(8  downto 0);  --  GBTX register aggress
        I2CRNUM : in    std_logic_vector(8  downto 0);  --  GBTX number of register to read
        FREAD   : out   std_logic;
        FWRITE  : out   std_logic;
        FiRESET : out   std_logic;
        FoRESET : out   std_logic;
        READY   : out   std_logic;
        GBTXRST : out   std_logic;
        GBTX_RESETB 
                : in    std_logic;
        I2Cflg  : out   std_logic;
        I2CRXflg: out   std_logic;
        DEbugFlag
                : out   std_logic;
        RESETn  : in    std_logic;
        CLK     : in    std_logic
);
end CoreI2CStateMachine;
architecture CoreI2CStateMachine_beh of CoreI2CStateMachine is
   -- signal, component etc. declarations

signal    APBsm_idx : integer range 0 to  15;
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

signal    INTsm_idx   : integer range 0 to 3;
constant cINTsmREAD   : integer := 00;
constant cINTsmREADW  : integer := 01;
constant cINTsmSTATUS : integer := 02;
constant cINTsmWRITEw : integer := 03;

Constant aI2C_addr0 : std_logic_vector(8 downto 0) := '0' & X"0C";
Constant aI2C_ctrl  : std_logic_vector(8 downto 0) := "000000000";
Constant aI2C_data  : std_logic_vector(8 downto 0) := '0' & X"08";
Constant aI2C_stat  : std_logic_vector(8 downto 0) := '0' & X"04";

Constant cSTmDRxA_50     : std_logic_vector(7 downto 0) := X"50";        
Constant cSTmDRxNA_58    : std_logic_vector(7 downto 0) := X"58";        
Constant cSTmDTxA_28     : std_logic_vector(7 downto 0) := X"28";        
Constant cSTmDTxNA_30    : std_logic_vector(7 downto 0) := X"30";        
Constant cSTIdle_F8      : std_logic_vector(7 downto 0) := X"F8";   
Constant cSTmReSta_10    : std_logic_vector(7 downto 0) := X"10";        
Constant cSTmSLARA_40    : std_logic_vector(7 downto 0) := X"40";        
Constant cSTmSLAWA_18    : std_logic_vector(7 downto 0) := X"18";        
Constant cSTmSLAWNA_20   : std_logic_vector(7 downto 0) := X"20";        
Constant cSTmStart_08    : std_logic_vector(7 downto 0) := X"08";      
Constant cSTmStop_E0     : std_logic_vector(7 downto 0) := X"E0";   
Constant cSTmTOUT_D8    : std_logic_vector(7 downto 0) := X"D8";   
        

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
Constant cI2C_Dummy_40    : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxDAck_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxDAckN_40  : std_logic_vector(7 downto 0) := X"40";  --|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_StopI2C_50  : std_logic_vector(7 downto 0) := X"50";  --|0|1|0|1|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+

signal PCTRL    : std_logic_vector(7 downto 0) := x"00";
signal PDATAW   : std_logic_vector(7 downto 0) := x"00";
signal PDATAR   : std_logic_vector(7 downto 0) := x"00";
signal PSTATUS  : std_logic_vector(7 downto 0) := x"00";
signal PREADen  : std_logic := '0';
signal PWRITEen : std_logic := '0';
signal I2CCLEAR   : std_logic := '0';

signal I2C1stCMD  : std_logic := '0';
--
signal PBUSY : std_logic := '0';
--
signal FREADd  : std_logic := '0';
signal FREADo  : std_logic := '0';
--
signal FWRITEd : std_logic := '0';
signal FWRITEo : std_logic := '0';
--
signal ERRORo  : std_logic := '0';
--
signal I2CBSYo : std_logic := '0';
--
signal I2CEND    : std_logic := '0';
signal I2CENDflg : std_logic := '0';
--
signal I2CABORT: std_logic := '0';
--
signal I2CRUNd : std_logic := '0';
--gnal I2CRUNoff : std_logic := '0';
--
signal FiEPTYd : std_logic := '0';
--
signal DataCnt : std_logic_vector(8 downto 0);
signal DataNum : std_logic_vector(8 downto 0);

signal I2CRXo  : std_logic := '0';

--
begin

    OutPinHandler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            FREAD    <= '0';
            FREADd   <= '0';
            I2CBSY   <= '0';
            ERROR    <= '0';
            FWRITE   <= '0';
            FWRITEd  <= '0';
            I2CRXflg <= '0';
        else
            I2CBSY   <= I2CBSYo;
            I2CRXflg <= I2CRXo;
            ERROR    <= ERRORo;
            FREADd   <= FREADo;
            FREAD    <= FREADo and not FREADd;
            FWRITEd  <= FWRITEo;
            FWRITE   <= FWRITEo and not FWRITEd;
        end if;
    end if;
    end process;

    I2CRUNHandler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            FiRESET   <= '1';
            FoRESET   <= '1';
            I2CRUNd   <= '0';
--          I2CRUNoff <= '0';
        else
            if I2CRUN='0' and I2CRUNd='1' then FiRESET <= '1'; else FiRESET <= '0'; end if; -- I2CRUN va a 0 RESET FIFO IN
            if I2CRUN='1' and I2CRUNd='0' then FoRESET <= '1'; else FoRESET <= '0'; end if; -- I2CRUN va a 1 RESET FIFO OUT
            I2CRUNd <= I2CRUN;
--          I2CRUNoff <= I2CRUNd and not I2CRUN and I2CBSYo and not ERRORo; -- I2CRUNoff attiva lo stop sul fronte di discesa di I2CRUN SE I2CBSYo='1' e non ERRORoe.
        end if;
    end if;
    end process;

    I2CABORTHandler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            I2CABORT <= '0';
        else
            if I2CRUN='0' and I2CBSYo='1' then 
                I2CABORT <= '1';
            else
                I2CABORT <= '0';
            end if;
        end if;
    end if;
    end process;
---------------------------------------------------------------------------------------
    I2C_StateMachine : process(CLK)
    variable vBlkAddr : std_logic_vector(7 downto 0) := x"00"; -- Original GBTX address
--  variable vCounter : integer range 0 to 3;
--  variable DataNum : std_logic_vector(15 downto 0); -- Number    of data to send, byte 2 & 3 of data group
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' or GBTX_RESETB='0' then
--          I2Csm_idx <= cI2CsmCLR;
            INTsm_idx <= cINTsmREAD;
--          APBsm_idx <= cAPBsmIDLE;
            DataCnt <= "000000000"; DataNum <= "000000000";
            FREADo  <= '0'; FWRITEo  <= '0';
            PREADen <= '0'; PWRITEen <= '0'; 
            PDATAW  <= X"00";
            I2CCLEAR <= '0';
            ERRORo  <= '0';
            FiEPTYd <= '0';
            I2CBSYo <= '0';
            I2Cflg  <= '0';
            I2CEND  <= '0';
            I2CENDflg <= '0';
            PCTRL   <= X"00";
            FoERRM  <= X"00";
            FoDATA  <= X"00";
            DEbugFlag <= '0';
            GBTXRST <= '0';
            READY <= '0';
        else
            READY  <= I2C1stCMD;
            if PBUSY='1' or PWRITEen='1' or PREADen='1' then 
                if PBUSY='1' then PWRITEen <= '0'; PREADen  <= '0'; end if;
            elsif (I2C1stCMD='0' or I2CCLEAR='1') and PBUSY='0' then
                PCTRL <= cI2C_ClearI2C_00;
                PWRITEen <= '1';
                I2CCLEAR <= '0'; 
-- G2  -------------------------------------------------------------------------------------------------------------------------------
            elsif I2CEND='1' then
                GBTXRST <= '0';
                I2CBSYo <= '0'; -- Azzera I2CBSY
--              if I2CRUN='0' and I2CBSYo='0' then I2CEND <= '0'; ERRORo <= '0'; end if;
                if I2CRUN='0' then 
                    I2CEND <= '0'; 
                    I2CCLEAR <= '1'; 
                    ERRORo <= '0'; 
                    I2CRXo <= '0';
                    INTsm_idx <= cINTsmREAD;
DEbugFlag <= '1';                           ----- DEBUG
                end if;
-- G3  -------------------------------------------------------------------------------------------------------------------------------
            elsif I2CRUN='1' and I2CBSYo='0' then
                PCTRL <= cI2C_StarcST60;
                PWRITEen <= '1';
                I2CBSYo  <= '1';
                FREADo   <= '1';
                FiEPTYd  <= '0';
                I2CRXo <= '0';
                INTsm_idx <= cINTsmREAD;
--------------------------------------------------------------------------------------------------------------------------------------
-- G4  -------------------------------------------------------------------------------------------------------------------------------
            elsif PINT='1' then -- and I2CBSYo='1' then
                case INTsm_idx is
-- G41 -------------------------------------------------------------------------------------------------------------------------------
                when cINTsmREAD   =>
                    PREADen <= '1';
                    FREADo  <= '0';
                    FWRITEo <= '0';
                    INTsm_idx <= cINTsmSTATUS;
-- G42 -------------------------------------------------------------------------------------------------------------------------------
                when cINTsmREADW  =>
                    INTsm_idx <= cINTsmSTATUS; --<-- Delay
                when cINTsmSTATUS =>
                    case PSTATUS is
--------------------------------------------------------------------------------------------------------------------------------------
-- G43 ------------ Send ADD+W write I2C ---------------------------------------------------------------------------------------------
                    when cSTmStart_08 | cSTmReSta_10    
------ G431 ------------------------------------------------------------------------------------------------------------------------------
                                               =>   if I2CRXo='0' then
                                                        PDATAW <= X"10"; --FREADo <= '1';       ----- Set I2C ADDR(R/W=0), X"10"
                                                        I2CRXo <= not I2CWRT;                   ----- Save I2C ADDR and R/W flag from FIFOIN
                                                        PCTRL <= cI2C_TxAddW_40;                ----- Set I2C ADDW_40 and write
                                                        PWRITEen <='1';                         ----- Write and wait
                                                        DataCnt <= "000000001";                 --<C> Set data counter
                                                        if I2CRNUM>"000000000" then             --<C> Set number of data
                                                            DataNum <= I2CRNUM;
                                                        else 
                                                            DataNum <= "000000001"; 
                                                        end if;
                                                    else
                                                        PDATAW <= X"11";                        ----- Set I2C ADDR(R/W=0), X"10"
                                                        PCTRL <= cI2C_TxAddR_40;                ----- Set I2C ADDR_40 and write
                                                        PWRITEen <='1';                         ----- Write and wait
                                                        I2CRXo <= '0';                          ----- Disable RX loop
                                                    end if; 
--------------------------------------------------------------------------------------------------------------------------------------
------ G432 ------- Send Data after ADDW or PDATAW -*ST---------------------------------------------------------------------------------
                    when cSTmSLAWA_18 | cSTmDTxA_28 =>   
----------- G4326 -----------------------------------------------------------------------------------------------------------------------------
                                                    if I2CABORT='1'                   then      ----- FIFOIN empty, Write to I2C
                                                    PCTRL <= cI2C_StopI2C_50;                   ----- Set I2C STOP_50
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    I2CRXo <= '0';                              ----- Disable RX loop
----------- G4321 -----------------------------------------------------------------------------------------------------------------------------
                                                    elsif DataCnt='0' & X"01" then              ----- First data to write is register address LOW
                                                    PDATAW <= I2CRADD(7 downto 0);              ----- Read register address low
                                                    PCTRL <= cI2C_TxDATA_40;                    ----- Set I2C PDATAW_40
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= DataCnt + "000000001";           --<C> Increment data counter                                                    
----------- G4321 -----------------------------------------------------------------------------------------------------------------------------
                                                    elsif DataCnt='0' & X"02" then              ----- second data to write is register address HI
                                                    PDATAW <= "0000000" & I2CRADD(8);           ----- Read register address hihg
                                                    PCTRL <= cI2C_TxDATA_40;                    ----- Set I2C PDATAW_40
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= DataCnt + "000000001";           --<C> Increment data counter                                                    
----------- G4321 -----------------------------------------------------------------------------------------------------------------------------
                                                    elsif FiEPTYd='1' then        ----- FIFOIN empty
                                                    DEbugFlag <= '0';
                                                    PCTRL <= cI2C_StopI2C_50;                   ----- Set I2C STOP_50
                                                    PWRITEen <='1';                             ----- Write and wait
----------- G4323 -----------------------------------------------------------------------------------------------------------------------------
                                                    else                                        ----- Write data
                                                    PDATAW <= FiDATA; FREADo <= '1';            ----- Read I2C DATA from FIFOIN
                                                    PCTRL <= cI2C_TxDATA_40;                    ----- Set I2C PDATAW_40
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= DataCnt + "000000001";           --<C> Increment data counter
DEbugFlag <= '1';                           ----- DEBUG
                                                    end if;
--------------------------------------------------------------------------------------------------------------------------------------
                                                    FiEPTYd <= FiEPTY;                          
--------------------------------------------------------------------------------------------------------------------------------------
------ G433 ------- ADD+R done, data read start --------------------------------------------------------------------------------------
                    when cSTmSLARA_40   =>          if DATANUM="000000001" then                 ----- Modifica [1]
                                                     PCTRL <= cI2C_RxDAckN_40;                  ----- Get next but No ack 
                                                    else
                                                     PCTRL <= cI2C_RxDAck_44;                   ----- Set I2C PDATAR_40 and write
                                                    end if;
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= "000000001";                     --<C> Set data counter
-------------------------------------------------------------------------------------------------------------------------------
------ G434 ------- Get data answer ACK -*NA---------------------------------------------------------------------------------------------
                    when cSTmDRxA_50    =>          if FoFULL='0' then                          ----- If FIFO OUT not full...
                                                     FWRITEo <= '1';  FoDATA <= PDATAR;         ----- ...save data in FIFO OUT
                                                     if DataCnt=DataNum-1 or I2CABORT='1' then  ----- If last data [2] 
                                                      PCTRL <= cI2C_RxDAckN_40;                 ----- Get next but No ack
--                                                    PCTRL <= cI2C_StopI2C_50;                 
                                                      PWRITEen <='1';                           ----- Write and wait
                                                     else                                        
                                                      PCTRL <= cI2C_RxDAck_44;                  ----- Set I2C PDATAR_40 and write
                                                      PWRITEen <='1';                           ----- Write and wait
                                                     end if;
                                                     DataCnt <= DataCnt + "000000001";          --<C> Increment data counter
                                                    end if;
--------------------------------------------------------------------------------------------------------------------------------------
------ G436 ------- Get data NO ACK -*ST----------------------------------------------------------------------------------------------
                    when cSTmDRxNA_58   =>          if FoFULL= '0' then                         ----- If FIFO OUT not full...
                                                    FWRITEo <= '1';  FoDATA <= PDATAR;          ----- ...save data in FIFO OUT
                                                    PCTRL <= cI2C_StopI2C_50;                   ----- Set I2C PDATAR_40 and write
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= DataCnt + "000000001";           --<C> Increment data counter
                                                    end if;
--------------------------------------------------------------------------------------------------------------------------------------
------ G435 ------- STOP done   --------------------------------------------------------------------------------------------------------
                    when cSTmStop_E0    =>          if (I2CRXo='0') or (ERRORo='1') then
                                                    I2CEND <= '1';                            ----- ...then clear
                                                    else
                                                    PCTRL <= cI2C_StarcST60;
                                                    PWRITEen <= '1';
                                                    end if;
--------------------------------------------------------------------------------------------------------------------------------------
------ G437 ------- ZERO answer ------------------------------------------------------------------------------------------------------
                    when cSTIdle_F8     =>        --I2CBSYo  <= '0'; 
                                                  --I2CCLEAR <= '1'; 
                                                    I2CEND <= '1';                   ----- To next step (dummy)
--------------------------------------------------------------------------------------------------------------------------------------
------ G437 ------- No ACK -----------------------------------------------------------------------------------------------------------
                    when cSTmDTxNA_30 | cSTmSLAWNA_20
                                        =>          GBTXRST  <= '1';                              -----
                                                    ERRORo   <= '1';                              -----
                                                    FoERRM   <= PSTATUS;                          -----
                                                    PCTRL <= cI2C_StopI2C_50;                     ----- Set I2C PDATAR_40 and write
                                                    PWRITEen <='1';                               ----- Write and wait
--------------------------------------------------------------------------------------------------------------------------------------
------ G437 ------- TIMEOUT ------------------------------------------------------------------------------------------------------
                    when cSTmTOUT_D8   =>           GBTXRST  <= '1';                              -----
                                                    ERRORo   <= '1';                              -----
                                                    FoERRM   <= PSTATUS;                          -----
                                                    I2CEND <= '1';     
--                                                  PCTRL <= cI2C_StopI2C_50;                     ----- Set I2C PDATAR_40 and write
--                                                  PWRITEen <='1';                               ----- Write and wait
--------------------------------------------------------------------------------------------------------------------------------------
------ G438 ------- ERRORS  -----------------------------------------------------------------------------------------------------------
                    when others                =>   ERRORo   <= '1';                              -----
                                                    FoERRM   <= PSTATUS;                          -----
                                                  --I2CCLEAR <= '1'; 
                                                    I2CEND <= '1';     
                    end case;
--------------------------------------------------------------------------------------------------------------------------------------
--                  if I2CRUNoff='1' then
--                  PCTRL <= cI2C_StopI2C_50;   PWRITEen <= '1';
--                  end if;
                    INTsm_idx <= cINTsmREAD;        --<-- Delay
--------------------------------------------------------------------------------------------------- -----------------------------------
-- G44 -------------------------------------------------------------------------------------------------------------------------------
                when cINTsmWRITEw =>                INTsm_idx <= cINTsmREAD;
                                                    I2CEND <= I2CENDflg; I2CENDflg <= '0';
                when others =>                      INTsm_idx <= cINTsmREAD;
                end case;
            end if;
        end if;
    end if;
    end process;
----------------------------------------------------------------------------------------------------------------
    APB_StateMachine : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            APBsm_idx <= cAPBsmIDLE;
            PSELx     <= '0';
            PENABLE   <= '0';
            PWRITE    <= '0';
            PWDATA    <= X"00";
            PDATAR    <= X"00";
            PBUSY     <= '0';
            I2C1stCMD <= '0';
			PADDR     <= "000000000";
        else
            case APBsm_idx is
            when cAPBsmIDLE     =>  if    PREADen ='1' then PBUSY <= '1'; APBsm_idx <= cAPBsmRDDs;
                                    elsif PWRITEen='1' then PBUSY <= '1'; APBsm_idx <= cAPBsmWRDs;
                                    else                    PBUSY <= '0'; end if;
            when cAPBsmRDDs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_data;
                                    APBsm_idx <= cAPBsmRDDe;
            when cAPBsmRDDe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '0'; PADDR <= aI2C_data; 
                                    APBsm_idx <= cAPBsmRDDx;
            when cAPBsmRDDx     =>  PSELx <= '0'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_data; 
                                    APBsm_idx <= cAPBsmRDSs;
                                    PDATAR  <= PRDATA;
            when cAPBsmRDSs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_stat; 
                                    APBsm_idx <= cAPBsmRDSe;
            when cAPBsmRDSe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '0'; PADDR <= aI2C_stat; 
                                    APBsm_idx <= cAPBsmRDSx;
            when cAPBsmRDSx     =>  PSELx <= '0'; PENABLE <= '0'; PWRITE <= '0'; PADDR <= aI2C_stat; 
                                    APBsm_idx <= cAPBsmDEBG;
                                    PSTATUS <= PRDATA;
            when cAPBsmWRDs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_data; 
                                    APBsm_idx <= cAPBsmWRDe;
                                    PWDATA <= PDATAW;
            when cAPBsmWRDe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '1'; PADDR <= aI2C_data; 
                                    APBsm_idx <= cAPBsmWRDx;
            when cAPBsmWRDx     =>  PSELx <= '0'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_data; 
                                    APBsm_idx <= cAPBsmWRCs;
            when cAPBsmWRCs     =>  PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_ctrl; 
                                    APBsm_idx <= cAPBsmWRCe;
                                    PWDATA <= PCTRL;
            when cAPBsmWRCe     =>  PSELx <= '1'; PENABLE <= '1'; PWRITE <= '1'; PADDR <= aI2C_ctrl; 
                                    APBsm_idx <= cAPBsmWRCx;
            when cAPBsmWRCx     =>  PSELx <= '0'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_ctrl; 
                                    APBsm_idx <= cAPBsmDEBG;
            when cAPBsmDEBG     =>  I2C1stCMD <= '1';                                                
                                    APBsm_idx <= cAPBsmIDLE;
            when others         =>  APBsm_idx <= cAPBsmIDLE;
            end case;
        end if;
    end if;
    end process;
end CoreI2CStateMachine_beh;