--------------------------------------------------------------------------------
-- Company: INFN
--
-- File: I2CState Machine2.vhd
-- File history:
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

entity I2CStateMachineINAv2 is 
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
        FREAD   : out   std_logic;
        FWRITE  : out   std_logic;
        FiRESET : out   std_logic;
        FoRESET : out   std_logic;
--      I2Cflg  : out   std_logic;
--      I2CRXflg: out   std_logic;
        RESETn  : in    std_logic;
        CLK     : in    std_logic
);
end I2CStateMachineINAv2;
architecture I2CStateMachineINAv2_beh of    I2CStateMachineINAv2    is
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

signal    INTsm_idx   : integer range 0 to 3 := 0;
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
signal FREADd  : std_logic;
signal FREADo  : std_logic;
--
signal FWRITEd : std_logic;
signal FWRITEo : std_logic;
--
signal ERRORo  : std_logic;
--
signal I2CBSYo : std_logic;
--
signal I2CEND  : std_logic;
--
signal I2CABORT: std_logic;
--
signal I2CRUNd : std_logic;
--gnal I2CRUNoff : std_logic;
--
signal FiEPTYd : std_logic;
--
signal DataCnt : std_logic_vector(2 downto 0);
--gnal DataNum : std_logic_vector(2 downto 0);

--gnal I2CRXo  : std_logic;

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
--          I2CRXflg <= '0';
        else
            I2CBSY   <= I2CBSYo;
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
            if I2CABORT='1' then                  
                I2CABORT <= not I2CEND;
            elsif I2CRUN='0' and I2CBSYo='1' then 
                I2CABORT <= '1';
            end if;
        end if;
    end if;
    end process;

    I2C_StateMachine : process(CLK)
--  variable vBlkAddr : std_logic_vector(7 downto 0); -- Original GBTX address
--  variable vCounter : integer range 0 to 3;
--  variable DataNum : std_logic_vector(15 downto 0); -- Number    of data to send, byte 2 & 3 of data group
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
--          I2Csm_idx <= cI2CsmCLR;
            INTsm_idx <= cINTsmREAD;
--          APBsm_idx <= cAPBsmIDLE;
            DataCnt <= "000"; -- DataNum <= "000000000";
            FREADo  <= '0'; FWRITEo  <= '0';
            PREADen <= '0'; PWRITEen <= '0';
            PDATAW  <= X"00";
            I2CCLEAR <= '1';
            ERRORo  <= '0';
            FiEPTYd <= '0';
            I2CBSYo <= '0';
--          I2Cflg  <= '0';
            I2CEND  <= '0';
            PCTRL   <= X"00";
            FoDATA  <= X"00";
            FoERRM  <= X"00";
        else
            if PWRITEen='1' and PBUSY='1' then PWRITEen <= '0'; end if;
            if PREADen='1'  and PBUSY='1' then PREADen  <= '0'; end if;
-- G1  -------------------------------------------------------------------------------------------------------------------------------
            if I2CCLEAR='1' then
                PCTRL <= cI2C_ClearI2C_00;
                PWRITEen <= '1';
                I2CCLEAR <= '0';
-- G2  -------------------------------------------------------------------------------------------------------------------------------
            elsif I2CEND='1' then
                if I2CRUN='0' then I2CEND <= I2CABORT; ERRORo <= '0'; end if;
-- G3  -------------------------------------------------------------------------------------------------------------------------------
            elsif I2CRUN='1' and I2CBSYo='0' then
                PCTRL <= cI2C_StarcST60;
                PWRITEen <= '1';
                I2CBSYo  <= '1';
                FREADo   <= '1';
                FiEPTYd  <= '0';
--              I2CRXo <= '0';
--------------------------------------------------------------------------------------------------------------------------------------
-- G4  -------------------------------------------------------------------------------------------------------------------------------
            elsif PINT='1' and PBUSY = '0' and I2CBSYo='1' then
                case INTsm_idx is
-- G41 -------------------------------------------------------------------------------------------------------------------------------
                when cINTsmREAD   =>
                    PREADen <= '1';
                    INTsm_idx <= cINTsmREADW;
                    FREADo  <= '0';
                    FWRITEo <= '0';
-- G42 -------------------------------------------------------------------------------------------------------------------------------
                when cINTsmREADW  =>
                    INTsm_idx <= cINTsmSTATUS; --<-- Delay
                when cINTsmSTATUS =>
                    case PSTATUS is
--------------------------------------------------------------------------------------------------------------------------------------
-- G43 ------------ Send ADD+W write I2C ---------------------------------------------------------------------------------------------
                    when cSTmStart_08 | cSTmReSta_10    
------ G431 ------------------------------------------------------------------------------------------------------------------------------
                                               =>   NULL;
                                                    PDATAW <= FiDATA; FREADo <= '1';  ----- Read I2C ADDR(R/W=0) from FIFOIN
                                                    PCTRL <= cI2C_TxAddW_40;                    ----- Set I2C ADDW_40 and write
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= "001";                     --<C> Set data counter
--------------------------------------------------------------------------------------------------------------------------------------
------ G432 ------- Send Data after ADDW or PDATAW -*ST---------------------------------------------------------------------------------
                    when cSTmSLAWA_18 | cSTmDTxA_28 =>   
----------- G4326 -----------------------------------------------------------------------------------------------------------------------------
                                                    if I2CABORT='1'                   then      ----- FIFOIN empty, Write to I2C
                                                    PCTRL <= cI2C_StopI2C_50;                   ----- Set I2C STOP_50
                                                    PWRITEen <='1';                             ----- Write and wait
----------- G4321 -----------------------------------------------------------------------------------------------------------------------------
--                                                  elsif FiEPTYd='1' and I2CRXo='1' then       ----- FIFOIN empty, READ from I2C
--                                                  PCTRL <= cI2C_ReStart_60;                   ----- Set I2C REST_60
--                                                  PWRITEen <='1';                             ----- Write and wait
----------- G4322 -----------------------------------------------------------------------------------------------------------------------------
--                                                  elsif FiEPTYd='1' and I2CRXo='0' then       ----- FIFOIN empty, Write to I2C
                                                    elsif FiEPTYd='1' then                      ----- FIFOIN empty, Write to I2C
                                                    PCTRL <= cI2C_StopI2C_50;                   ----- Set I2C STOP_50
                                                    PWRITEen <='1';                             ----- Write and wait
----------- G4323 -----------------------------------------------------------------------------------------------------------------------------
--                                                  elsif DataCnt = '0' & X"03" and I2CRXo='1' then
--                                                  DataNum(7 downto 0)
--                                                        <= FiDATA; FREADo <= '1';             --<C> if READ set DataNum low byte
--                                                  DataCnt <= DataCnt + "000000001";           --<C> Increment data counter
----------- G4324 -----------------------------------------------------------------------------------------------------------------------------
--                                                  elsif DataCnt = '0' & X"04" and I2CRXo='1' then
--                                                  DataNum(8)
--                                                        <= FiDATA(0); FREADo <= '1';          --<C> if READ set DataNum high byte
--                                                  DataCnt <= DataCnt + "000000001";           --<C> Increment data counter
----------- G4325 -----------------------------------------------------------------------------------------------------------------------------
                                                    else                                        ----- Write data
                                                    PDATAW <= FiDATA; FREADo <= '1';            ----- Read I2C DATA from FIFOIN
                                                    PCTRL <= cI2C_TxDATA_40;                    ----- Set I2C PDATAW_40
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= DataCnt + "001";           --<C> Increment data counter
                                                    end if;
--------------------------------------------------------------------------------------------------------------------------------------
                                                    FiEPTYd <= FiEPTY;                          
--------------------------------------------------------------------------------------------------------------------------------------
------ G433 ------- ADD+R done, data read start --------------------------------------------------------------------------------------
                    when cSTmSLARA_40   =>          PCTRL <= cI2C_RxDAck_44;                    ----- Set I2C PDATAR_40 and write
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= "000";                     --<C> Set data counter
-------------------------------------------------------------------------------------------------------------------------------
------ G434 ------- Get data answer ACK -*NA---------------------------------------------------------------------------------------------
                    when cSTmDRxA_50    =>          if FoFULL='0' then                          ----- If FIFO OUT not full...
                                                    FWRITEo <= '1';  FoDATA <= PDATAR;          ----- ...save data in FIFO OUT
--                                                  if DataCnt=X"000" or I2CABORT='1' then     ----- If last data
                                                    PCTRL <= cI2C_RxDAckN_40;                   ----- Get next but No ack
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    ----------------------------------------------------------------------------------
--                                                  else                                        
--                                                  PCTRL <= cI2C_RxDAck_44;                    ----- Set I2C PDATAR_40 and write
--                                                  PWRITEen <='1';                             ----- Write and wait
--                                                  end if;
                                                    DataCnt <= DataCnt + "001";           --<C> Increment data counter
                                                    end if;
--------------------------------------------------------------------------------------------------------------------------------------
------ G435 ------- STOP done   --------------------------------------------------------------------------------------------------------
                    when cSTmStop_E0    =>     --   if I2CRXo='0' then
                                               --   I2CCLEAR <= '1';
                                                    I2CBSYo  <= '0'; 
                                                    I2CEND   <= '1';                            ----- ...then clear
                                               --   else
                                               --   PCTRL <= cI2C_StarcST60;
                                               --   PWRITEen <= '1';
                                               --   end if;
--------------------------------------------------------------------------------------------------------------------------------------
------ G436 ------- Get data NO ACK -*ST----------------------------------------------------------------------------------------------
                    when cSTmDRxNA_58   =>          if FoFULL= '0' then                         ----- If FIFO OUT not full...
                                                    FWRITEo <= '1';  FoDATA <= PDATAR;          ----- ...save data in FIFO OUT
                                                    PCTRL <= cI2C_StopI2C_50;                    ----- Set I2C PDATAR_40 and write
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    DataCnt <= DataCnt + "001";           --<C> Increment data counter
                                                    end if;
--------------------------------------------------------------------------------------------------------------------------------------
------ G437 ------- ZERO answer ------------------------------------------------------------------------------------------------------
                    when cSTIdle_F8     =>          I2CBSYo  <= '0'; 
                                                    I2CCLEAR <= '1'; 
                                                    I2CEND   <= '1';                   ----- To next step (dummy)
--------------------------------------------------------------------------------------------------------------------------------------
------ G437 ------- ZERO answer ------------------------------------------------------------------------------------------------------
                    when cSTmDTxNA_30 | cSTmSLAWNA_20
                                        =>          ERRORo   <= '1';                              -----
                                                    FoERRM   <= PSTATUS; FWRITEo <= '1';          -----
                                                    PCTRL <= cI2C_StopI2C_50;                    ----- Set I2C PDATAR_40 and write
                                                    PWRITEen <='1';                             ----- Write and wait
                                                    --------------------------------------------------------------------------------------------------------------------------------------
------ G438 ------- ERRORS  -----------------------------------------------------------------------------------------------------------
                    when others                =>   ERRORo   <= '1';                              -----
                                                    FoERRM   <= PSTATUS; FWRITEo <= '1';          -----
                                                    I2CCLEAR <= '1'; 
                                                    I2CBSYo <= '0'; 
                                                    I2CEND <= '1';
                    end case;
--------------------------------------------------------------------------------------------------------------------------------------
--                  if I2CRUNoff='1' then
--                  PCTRL <= cI2C_StopI2C_50;   PWRITEen <= '1';
--                  end if;
                    INTsm_idx <= cINTsmWRITEw; --<-- Delay
--------------------------------------------------------------------------------------------------- -----------------------------------
-- G44 -------------------------------------------------------------------------------------------------------------------------------
                when cINTsmWRITEw =>                INTsm_idx <= cINTsmREAD;
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
            PSELx     <= '1';
            PENABLE   <= '0';
            PWRITE    <= '0';
            PWDATA    <= X"00";
            PDATAR    <= X"00";
            PBUSY     <= '0';
            PSTATUS   <= X"00"; 
        else
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
        end if;
    end if;
    end process;
end I2CStateMachineINAv2_beh;