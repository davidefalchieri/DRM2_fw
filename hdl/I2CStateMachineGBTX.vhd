--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: I2CState Machine2.vhd
-- File history:
--      1.20150424.2330: Inizio
--      1.20150428.1139: tolto PREADY
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

entity I2CStateMachineGBTX is
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
        I2Cflg  : out   std_logic;
        RESETn  : in    std_logic;
        CLK     : in    std_logic
);
end I2CStateMachineGBTX;
architecture I2CStateMachineGBTX_beh of    I2CStateMachineGBTX    is
   -- signal, component etc. declarations

signal APBsm_idx  : integer range 0 to  14;

constant cAPBsmGETDAT   : integer := 00;
constant cAPBsmGETDATp  : integer := 01;
constant cAPBsmGETDATx  : integer := 02;
constant cAPBsmGETSTA   : integer := 03;
constant cAPBsmGETSTAp  : integer := 04;
constant cAPBsmGETSTAx  : integer := 05;
constant cAPBsmIDLE     : integer := 06;
constant cAPBsmSETCTR   : integer := 07;
constant cAPBsmSETCTRp  : integer := 08;
constant cAPBsmSETCTRx  : integer := 09;
constant cAPBsmSETDWR   : integer := 10;
constant cAPBsmSETDWRp  : integer := 11;
constant cAPBsmSETDWRx  : integer := 12;
constant cAPBsmWAIT_I   : integer := 13;
constant cAPBsmNORUN    : integer := 14;

signal   I2Csm_idx    : integer range 0 to 20 := 0;
constant cI2CsmBEGIN  : integer := 00;
constant cI2CsmBEGIN2 : integer := 01;
constant cI2CsmADDR   : integer := 02;
constant cI2CsmADDR2  : integer := 03;
constant cI2CsmADDW   : integer := 04;
constant cI2CsmADDW2  : integer := 05;
constant cI2CsmDATAR  : integer := 06;
constant cI2CsmDATAR2 : integer := 07;
constant cI2CsmDATAW  : integer := 08;
constant cI2CsmDATAW2 : integer := 09;
constant cI2CsmERROR  : integer := 10;
constant cI2CsmERROR2 : integer := 11;
constant cI2CsmREST   : integer := 12;
constant cI2CsmREST2  : integer := 13;
constant cI2CsmSTART  : integer := 14;
constant cI2CsmSTART2 : integer := 15;
constant cI2CsmSTOP   : integer := 16;
constant cI2CsmSTOP2  : integer := 17;
constant cI2CsmSTOP3  : integer := 18;
constant cI2CsmWAIT   : integer := 19;


Constant aI2C_addr0 : std_logic_vector(8 downto 0) := '0' & X"0C";
Constant aI2C_ctrl  : std_logic_vector(8 downto 0) := '0' & X"00";
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
-------------------------------------------------- 1_1   1__0   0__0
-------------------------------------------------- 7 6   5  8   7  0
signal PCTRL   : std_logic_vector(10 downto  0); -- SEL  & CTRL
---------------------------------------------------- SEL----| dataW | wr ctrl | wait int |  dataR | get stat +-------------
constant cAPBwcixs : std_logic_vector(2 downto 0) :="000";--|  YES  |   YES   |   YES    |   NOT  |   YES    | ADDW, ADDR
constant cAPBxcixs : std_logic_vector(2 downto 0) :="010";--|  NOT  |   YES   |   YES    |   NOT  |   YES    | START, STOP
constant cAPBxcxxx : std_logic_vector(2 downto 0) :="001";--|  NOT  |   YES   |   NOT    |   NOT  |   NOT    | CLEAR
constant cAPBxxxxs : std_logic_vector(2 downto 0) :="011";--|  NOT  |   NOT   |   NOT    |   NOT  |   YES    | Read Status
constant cAPBxcirs : std_logic_vector(2 downto 0) :="100";--|  NOT  |   YES   |   YES    |   YES  |   YES    | Read Data
constant cAPBxxixs : std_logic_vector(2 downto 0) :="111";--|  NOT  |   NOT   |   YES    |   NOT  |   YES    | Read Status with INT
------------------------------------------------------------+-------+---------+----------+--------+----------+-------------
signal PDATAW   : std_logic_vector(7 downto 0);
signal PDATAR   : std_logic_vector(7 downto 0);
signal PSTATUS  : std_logic_vector(7 downto 0); 
signal PSTATUSd : std_logic_vector(7 downto 0);
signal PRUN     : std_logic;
--
signal PBSY : std_logic;
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
signal FiEPTYd : std_logic;
--
signal I2CRUNd : std_logic;
signal I2CRUNoff : std_logic;
--
signal DataCnt : std_logic_vector(8 downto 0);
signal DataNum : std_logic_vector(8 downto 0);
--
begin

    OutPinHandler : process(CLK)
    begin
		if RESETn='0' then
        	FREAD   <= '0';
        	FREADd  <= '0';
        	I2CBSY  <= '0';
        	ERROR   <= '0';
        	FWRITE  <= '0';
        	FWRITEd <= '0';
        elsif CLK'event and CLK='1' then
        	I2CBSY <= I2CBSYo;
            ERROR  <= ERRORo;
            FREADd <= FREADo;
        	FREAD  <= FREADo and not FREADd;
        	FWRITEd <= FWRITEo;
        	FWRITE  <= FWRITEo and not FWRITEd;
		end if;
    end process;

    I2CRUNHandler : process(CLK)
    begin
		if RESETn='0' then
        	FiRESET   <= '1';
        	FoRESET   <= '1';
        	I2CRUNd   <= '0';
        elsif CLK'event and CLK='1' then
        	if I2CRUN='0' and I2CRUNd='1' then FiRESET <= '1'; else FiRESET <= '0'; end if; -- I2CRUN va a 0 RESET FIFO IN
        	if I2CRUN='1' and I2CRUNd='0' then FoRESET <= '1'; else FoRESET <= '0'; end if; -- I2CRUN va a 1 RESET FIFO OUT
            I2CRUNd <= I2CRUN;
            I2CRUNoff <= I2CRUNd and not I2CRUN and I2CBSYo and not ERRORo; -- I2CRUNoff attiva lo stop sul fronte di discesa di I2CRUN SE I2CBSYo='1' e non ERRORoe.
		end if;
    end process;

    I2C_StateMachine : process(CLK)
    variable vRDflag  : std_logic;
    variable vBlkAddr : std_logic_vector(7 downto 0); -- Original GBTX address
--  variable vCounter : integer range 0 to 3;
--  variable DataNum : std_logic_vector(15 downto 0); -- Number    of data to send, byte 2 & 3 of data group
    begin
        if RESETn='0' then
            I2CRUNoff <= '0';
            I2Csm_idx <= cI2CsmBEGIN;
            DataCnt <= '0' & X"00"; DataNum <= '0' & X"00";
--          vCounter := 0;
            FREADo <= '0'; FWRITEo <= '0';
            I2Csm_idx <= cI2CsmBEGIN;
            PRUN    <= '0';
            PDATAW  <= X"00";
            ERRORo  <= '0';
            FiEPTYd <= '0';
            I2CBSYo <= '0';
            I2Cflg  <= '0';
            PCTRL <= cAPBwcixs & X"00";
        elsif CLK'event and CLK='1' then
            if PINT='1' then
                --APBREAD <= '1';
                case I2Csm_idx is
                when cI2CsmBEGIN    =>  PCTRL <= cAPBxcxxx & cI2C_ClearI2C_00; PRUN <='1'; I2CBSYo <= '0'; 
                                        DataCnt <= '0' & X"00"; DataNum <= '0' & X"00"; FiEPTYd <= '0';
                                        ERRORo <= '0';
                                                                                                    I2Csm_idx <= cI2CsmWAIT;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- Wait I2CRUN command --------------------------------------------------------------------------------------------------
                when cI2CsmWAIT     =>  if I2CRUN='0' then   I2CBSYo <= '0';
                                        else FREADo <= '1';  I2CBSYo <= '1';                         I2Csm_idx <= cI2CsmSTART;  end if;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- Start I2C cycle ------------------------------------------------------------------------------------------------------
                when cI2CsmSTART    =>  PCTRL <= cAPBxcixs & cI2C_StarcST60; PRUN <='1';          I2Csm_idx <= cI2CsmSTART2;
                when cI2CsmSTART2   =>  if      PSTATUS = cSTmStart_08 then                    I2Csm_idx <= cI2CsmADDW;   
                                        else                                                        I2Csm_idx <= cI2CsmERROR;   end if;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- Send ADD+W -----------------------------------------------------------------------------------------------------------
                when cI2CsmADDW     =>  I2CFLG <= '1';
                                        PCTRL <= cAPBwcixs & cI2C_TxAddW_40; 
                                        PDATAW <= FiDATA and X"FE"; PRUN <='1';
                                        vBlkAddr := FiDATA; FREADo <= '1'; vRDflag := FiDATA(0);
                                        DataCnt <= '0' & X"01";                                     I2Csm_idx <= cI2CsmADDW2;
                when cI2CsmADDW2    =>  I2CFLG <= '0';
                                        if      PSTATUS = cSTmSLAWA_18 then                  I2Csm_idx <= cI2CsmDATAW;   
                                        else                                                        I2Csm_idx <= cI2CsmERROR;   end if;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- Send Data ------------------------------------------------------------------------------------------------------------
                when cI2CsmDATAW    =>  I2CFLG <= '1';
                                        PDATAW <= FiDATA; FREADo <= '1'; 
                                        if    DataCnt = '0' & X"03" and vRDflag='1' then DataNum(7 downto 0) <= FiDATA;
                                              PCTRL <= cAPBxxxxs & cI2C_Dummy_40;  PRUN <='1';      I2Csm_idx <= cI2CsmDATAW2; 
                                        elsif DataCnt = '0' & X"04" and vRDflag='1' then DataNum(8)          <= FiDATA(0); 
                                              PCTRL <= cAPBxxxxs & cI2C_Dummy_40;  PRUN <='1';      I2Csm_idx <= cI2CsmDATAW2; 
                                        else  PCTRL <= cAPBwcixs & cI2C_TxDATA_40; PRUN <='1';      I2Csm_idx <= cI2CsmDATAW2;  end if;
                                        DataCnt <= DataCnt + "000000001";                                 
                when cI2CsmDATAW2   =>  I2CFLG <= '0';
                                        FiEPTYd <= FiEPTY; 
                                        if      PSTATUS = cSTmDTxA_28 then                   
                                            if    FiEPTYd='1' and vRDflag='0'then                   I2Csm_idx <= cI2CsmSTOP;    
                                            elsif FiEPTYd='1' and vRDflag='1'then                   I2Csm_idx <= cI2CsmREST; 
                                            elsif FiEPTYd='0' then                                  I2Csm_idx <= cI2CsmDATAW;   end if;   
                                        else                                                        I2Csm_idx <= cI2CsmERROR;   end if;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- Send Restart ---------------------------------------------------------------------------------------------------------
                when cI2CsmREST     =>  I2CFLG <= '0';
                                        PCTRL <= cAPBxcixs & cI2C_ReStart_60;           PRUN <='1'; I2Csm_idx <= cI2CsmREST2;
                when cI2CsmREST2    =>  if      PSTATUS = cSTmReSta_10 then                  I2Csm_idx <= cI2CsmADDR;    
                                        else                                                        I2Csm_idx <= cI2CsmERROR;   end if;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- Send ADD+R -----------------------------------------------------------------------------------------------------------
                when cI2CsmADDR     =>  I2CFLG <= '1';
                                        PCTRL <= cAPBwcixs & cI2C_TxAddR_40;  
                                        PDATAW <= vBlkAddr;         
                                        DataCnt <= '0' & X"00";                         PRUN <='1'; I2Csm_idx <= cI2CsmADDR2;
                when cI2CsmADDR2    =>  I2CFLG <= '0';
                                        if      PSTATUS = cSTmSLARA_40 then                  I2Csm_idx <= cI2CsmDATAR;   
                                        else                                                        I2Csm_idx <= cI2CsmERROR;   end if;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- Get data -------------------------------------------------------------------------------------------------------------
                when cI2CsmDATAR    =>  I2CFLG <= '1';
                                        PCTRL <= cAPBxcirs & cI2C_RxDAck_44;             
                                        DataCnt <= DataCnt + "000000001";               PRUN <='1'; I2Csm_idx <= cI2CsmDATAR2;
                when cI2CsmDATAR2   =>  I2CFLG <= '0';
                                        if FoFULL= '0' then
                                            FWRITEo <= '1';  FoDATA <= PDATAR;
                                            if      PSTATUS = cSTmDRxA_50 then
                                                if DataCnt=DataNum then                             I2Csm_idx <= cI2CsmSTOP;    
                                                else                                                I2Csm_idx <= cI2CsmDATAR;    end if;
                                            else                                                    I2Csm_idx <= cI2CsmERROR;    end if;
                                        else
                                            NULL;
                                        end if;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- STOP -----------------------------------------------------------------------------------------------------------------
                when cI2CsmSTOP     =>  PCTRL <= cAPBxcixs & cI2C_StopI2C_50;           PRUN <='1'; I2Csm_idx <= cI2CsmSTOP2;
                when cI2CsmSTOP2    =>  if      PSTATUS = cSTmStop_E0 then  
                                                                                                    I2Csm_idx <= cI2CsmSTOP3;   
                                        elsif   PSTATUS=X"00" then                                  I2Csm_idx <= cI2CsmERROR;
                                        elsif   ERRORo='1' then                                     I2Csm_idx <= cI2CsmSTOP3;    end if;
                when cI2CsmSTOP3    =>  I2CBSYo <= '0';
                                        if I2CRUN='0' then ERRORo <= '0';                           I2Csm_idx <= cI2CsmBEGIN;    end if;
    ----------------------------------------------------------------------------------------------------------------------------------
    ----------- ERRORo ----------------------------------------------------------------------------------------------------------------
                when cI2CsmERROR    =>  if FoFULL= '0' then
                                            FWRITEo <= '1';
                                            FoDATA <= PSTATUSd;
                                            ERRORo <= '1';                                          I2Csm_idx <= cI2CsmERROR2;   end if;
               when cI2CsmERROR2    =>                                                              I2Csm_idx <= cI2CsmSTOP;
    ----------------------------------------------------------------------------------------------------------------------------------
                when others         =>                                                              I2Csm_idx <= cI2CsmBEGIN;   
    ----------------------------------------------------------------------------------------------------------------------------------
                end case;
--              end if;
--          vCounter    := 0;
            elsif PBSY='1' then 
            PRUN <= '0';
            else
            FREADo  <= '0';
            FWRITEo <= '0';
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
            PSTATUSd  <= X"FF";
            PWRITE    <= '0';
            PWDATA    <= X"00";
            PDATAR    <= X"00";
            PBSY      <= '0';
        elsif CLK'event and CLK='1' then
            case APBsm_idx is
            when cAPBsmIDLE     =>  PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '0'; PADDR <= aI2C_ctrl;
                                    PWDATA  <= X"00";
                                    PSTATUS <= X"FF";
                                    if PRUN='1' then
                                        PBSY  <= '1';
                                        case PCTRL(10 downto 8) is
                                        when cAPBwcixs   => APBsm_idx <= cAPBsmSETDWR;
                                        when cAPBxxxxs   => APBsm_idx <= cAPBsmGETSTA;
                                        when others => APBsm_idx <= cAPBsmSETCTR;
                                        end case;
                                    end if;
            when cAPBsmSETDWR   =>  PBSY  <= '1';
                                    PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '1'; PADDR <= aI2C_data;
                                    PWDATA  <= PDATAW;
                                    APBsm_idx <= cAPBsmSETDWRP;
            when cAPBsmSETDWRp  =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '1'; PWRITE  <= '1'; PADDR <= aI2C_data;
                                    PWDATA  <= PDATAW;
                                    APBsm_idx <= cAPBsmSETDWRx;
            when cAPBsmSETDWRx  =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '1'; PADDR <= aI2C_data;
                                    PWDATA  <= PDATAW;
                                    APBsm_idx <= cAPBsmSETCTR;
----------------------------------------------------------------------------------------------------------------------
            when cAPBsmSETCTR   =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '1'; PADDR <= aI2C_ctrl;
                                    PWDATA  <= PCTRL(7 downto 0);
                                    APBsm_idx <= cAPBsmSETCTRp;
            when cAPBsmSETCTRp  =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '1'; PWRITE  <= '1'; PADDR <= aI2C_ctrl;
                                    PWDATA  <= PCTRL(7 downto 0);
                                    APBsm_idx <= cAPBsmSETCTRx;
            when cAPBsmSETCTRx  =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '1'; PADDR <= aI2C_ctrl;
                                    PWDATA  <= PCTRL(7 downto 0);
                                    if PCTRL(10 downto 8)=cAPBxcxxx then
                                                                   APBsm_idx <= cAPBsmNORUN;
                                    else                           APBsm_idx <= cAPBsmWAIT_I; end if;
----------------------------------------------------------------------------------------------------------------------
            when cAPBsmWAIT_I   =>  PBSY <= '1';
                                    if PINT='1' then
                                        if PCTRL(10 downto 8)= cAPBxcirs then APBsm_idx <= cAPBsmGETDAT;
                                        else                                  APBsm_idx <= cAPBsmGETSTA; end if;
                                    end if;
----------------------------------------------------------------------------------------------------------------------
            when cAPBsmGETDAT   =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '0'; PADDR <= aI2C_data;
                                    APBsm_idx <= cAPBsmGETDATp;
            when cAPBsmGETDATp  =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '1'; PWRITE  <= '0'; PADDR <= aI2C_data;
                                    APBsm_idx <= cAPBsmGETDATx;
            when cAPBsmGETDATx  =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '0'; PADDR <= aI2C_data;
                                    PDATAR <= PRDATA;
                                    APBsm_idx <= cAPBsmGETSTA;
----------------------------------------------------------------------------------------------------------------------
            when cAPBsmGETSTA   =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '0'; PADDR <= aI2C_stat;
                                    APBsm_idx <= cAPBsmGETSTAp;
            when cAPBsmGETSTAp  =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '1'; PWRITE  <= '0'; PADDR <= aI2C_stat;
                                    APBsm_idx <= cAPBsmGETSTAx;
            when cAPBsmGETSTAx  =>  PBSY <= '1';
                                    PSELx   <= '1'; PENABLE <= '0'; PWRITE  <= '0'; PADDR <= aI2C_stat;
                                    PSTATUS  <= PRDATA;
                                    PSTATUSd <= PRDATA;
                                    APBsm_idx <= cAPBsmNORUN;
----------------------------------------------------------------------------------------------------------------------
            when cAPBsmNORUN    =>  if PRUN='0' then
                                        APBsm_idx <= cAPBsmIDLE; PBSY <= '0'; end if;
----------------------------------------------------------------------------------------------------------------------
            when others         =>  APBsm_idx <= cAPBsmIDLE;
            end case;
        end if;
    end process;
end I2CStateMachineGBTX_beh;
