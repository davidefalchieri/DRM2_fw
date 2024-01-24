--------------------------------------------------------------------------------
-- Company: <Name>
--
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

entity I2CStateMachineINAEMU is
port (
        PRDATA  : in    std_logic_vector(7  downto 0);  --  APB DATA READ 
        PWDATA  : out   std_logic_vector(7  downto 0);  --  APB DATA WRITE
        PADDR   : out   std_logic_vector(8  downto 0);  --  APB ADDRESS
        PSELx   : out   std_logic;                      --  APB PSELx
        PENABLE : out   std_logic;                      --  APB ENABLE
        PWRITE  : out   std_logic;                      --  APB WRITE
--      PREADY  : in    std_logic;                      --  APB READY
        PINT    : in    std_logic;                      --  APB READY
        SLV0add: in    std_logic_vector(7  downto 0);  --  SLAVE ADDRESS
        I2CBSY  : out   std_logic;
        RESETn  : in    std_logic;
        CLK     : in    std_logic
);
end I2CStateMachineINAEMU;
architecture I2CStateMachineINAEMU_beh of    I2CStateMachineINAEMU    is
-- signal, component etc. declarations

type RAMblock_type is array (0 to 15) of std_logic_vector(7 downto 0);
signal RAMblock : RAMblock_type := (others => X"00");

signal MemAddress : integer range 0 to 15;

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

signal SLAVE0sm : integer range 0 to 3;
constant cSLVADDs : integer range 0 to 3 := 0; 
constant cSLVADDe : integer range 0 to 3 := 1;
constant cSLVADDx : integer range 0 to 3 := 2;
constant cSLVADDi : integer range 0 to 3 := 3; -- Idle, end of SLVADD setup 

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
Constant cI2C_RxDAck_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxEnab_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxWait_44   : std_logic_vector(7 downto 0) := X"44";  --|0|1|0|0|0|1|0|0|
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
--xnal FREADd  : std_logic;
--xnal FREADo  : std_logic;
--x
--xnal FWRITEd : std_logic;
--xnal FWRITEo : std_logic;
--x
--xnal ERRORo  : std_logic;
--
signal I2CBSYo : std_logic;
--
signal I2CRUN  : std_logic;
--
signal I2CRUNd : std_logic;
signal I2CRUNoff : std_logic;
--
signal FiEPTYd : std_logic;
--
signal DataCnt : std_logic_vector(8 downto 0);
--xnal DataNum : std_logic_vector(8 downto 0);
--
begin

    OutPinHandler : process(CLK)
    begin
        if RESETn='0' then
--x         FREAD   <= '0';
--x         FREADd  <= '0';
            I2CBSY  <= '0';
--x         ERROR   <= '0';
--x         FWRITE  <= '0';
--x         FWRITEd <= '0';
        elsif CLK'event and CLK='1' then
            I2CBSY <= I2CBSYo;
--x         ERROR  <= ERRORo;
--x         FREADd <= FREADo;
--x         FREAD  <= FREADo and not FREADd;
--x         FWRITEd <= FWRITEo;
--x         FWRITE  <= FWRITEo and not FWRITEd;
        end if;
    end process;

--x I2CRUNHandler : process(CLK)
--x begin
--x     if RESETn='0' then
--x         FiRESET   <= '1';
--x         FoRESET   <= '1';
--x         I2CRUNd   <= '0';
--x         I2CRUNoff <= '0';
--x     elsif CLK'event and CLK='1' then
--x         if I2CRUN='0' and I2CRUNd='1' then FiRESET <= '1'; else FiRESET <= '0'; end if; -- I2CRUN va a 0 RESET FIFO IN
--x         if I2CRUN='1' and I2CRUNd='0' then FoRESET <= '1'; else FoRESET <= '0'; end if; -- I2CRUN va a 1 RESET FIFO OUT
--x         I2CRUNd <= I2CRUN;
--x         I2CRUNoff <= I2CRUNd and not I2CRUN and I2CBSYo and not ERRORo; -- I2CRUNoff attiva lo stop sul fronte di discesa di I2CRUN SE I2CBSYo='1' e non ERRORoe.
--x     end if;
--x end process;

    I2C_StateMachine : process(CLK)
    variable vRDflag  : std_logic;
    variable vBlkAddr : std_logic_vector(7 downto 0); -- Original GBTX address
--  variable vCounter : integer range 0 to 3;
--  variable DataNum : std_logic_vector(15 downto 0); -- Number    of data to send, byte 2 & 3 of data group
    begin
        if RESETn='0' then
            INTsm_idx <= cINTsmREAD;
            DataCnt <= "000000000"; 
--x         DataNum <= "000000000";
--x         FREADo  <= '0'; FWRITEo  <= '0';
            PREADen <= '0'; PWRITEen <= '0';
            PDATAW  <= X"00";
            I2CCLEAR <= '1';
--x         ERRORo  <= '0';
--x         FiEPTYd <= '0';
            I2CBSYo <= '0';
--x         I2Cflg  <= '0';
            I2CRUN  <= '0';
            PCTRL   <= X"00";
            RamBlock(0)  <= SLV0add(3 downto 0) & X"0";
            RamBlock(1)  <= SLV0add(3 downto 0) & X"1";
            RamBlock(2)  <= SLV0add(3 downto 0) & X"2";
            RamBlock(3)  <= SLV0add(3 downto 0) & X"3";
            RamBlock(4)  <= SLV0add(3 downto 0) & X"4";
            RamBlock(5)  <= SLV0add(3 downto 0) & X"5";
            RamBlock(6)  <= SLV0add(3 downto 0) & X"6";
            RamBlock(7)  <= SLV0add(3 downto 0) & X"7";
            RamBlock(8)  <= SLV0add(3 downto 0) & X"8";
            RamBlock(9)  <= SLV0add(3 downto 0) & X"9";
            RamBlock(10) <= SLV0add(3 downto 0) & X"A";
            RamBlock(11) <= SLV0add(3 downto 0) & X"B";
            RamBlock(12) <= SLV0add(3 downto 0) & X"C";
            RamBlock(13) <= SLV0add(3 downto 0) & X"D";
            RamBlock(14) <= SLV0add(3 downto 0) & X"E";
            RamBlock(15) <= SLV0add(3 downto 0) & X"F";
        elsif CLK'event and CLK='1' then
            if PWRITEen='1' and PBUSY='1' then PWRITEen <= '0'; end if;
            if PREADen='1'  and PBUSY='1' then PREADen  <= '0'; end if;
--------------------------------------------------------------------------------------------------------------------------------------
            if I2CCLEAR='1' then
                PCTRL <= cI2C_ClearI2C_00;
                PWRITEen <= '1';
                I2CCLEAR <= '0';
                I2CRUN   <= '1'; 
--------------------------------------------------------------------------------------------------------------------------------------
            elsif I2CRUN='1' then
--x             I2CEND <= I2CRUN;
                PCTRL <= cI2C_RxEnab_44;
                PWRITEen <= '1';
                I2CRUN <= '0';
--x-----------------------------------------------------------------------------------------------------------------------------------
--x         elsif I2CRUN='1' and I2CBSYo='0' then
--x             PCTRL <= cI2C_StarcST60;
--x             PWRITEen <= '1';
--x             I2CBSYo  <= '1';
--x             FREADo   <= '1';
--x             FiEPTYd  <= '0';
--x             vRDflag  := '0';
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
            elsif PINT='1' and PBUSY='0' then -- and I2CBSYo='1' then
                case INTsm_idx is
                when cINTsmREAD   =>
                    PREADen <= '1';
                    INTsm_idx <= cINTsmREADW;
--x                 FREADo  <= '0';
--x                 FWRITEo <= '0';
                when cINTsmREADW  =>
                    INTsm_idx <= cINTsmSTATUS; --<-- Delay
                when cINTsmSTATUS =>
                    case PSTATUS is
--------------------------------------------------------------------------------------------------------------------------------------
------------------- Address valid, Write flag (data receiver) ---------------------------------------------------------------------------
                    when cSTsSLAWA_60 =>  PCTRL <= cI2C_RxDAck_44;                    ----- Set data byte will be received
                                                    PWRITEen <= '1';                             ----- ACK will be returned
                                                    I2CBSYo   <= '1';
                                                    DataCnt <= "000000001";                     --<C> Set data counter
--------------------------------------------------------------------------------------------------------------------------------------
------------------- Data received to put in memory -----------------------------------------------------------------------------------
                    when cSTsDRxA_80  =>  case DataCnt is
                                                    when "000000001" => MemAddress <= conv_integer(PDATAR)*2;
                                                    when "000000010" => RAMblock(MemAddress+1) <= PDATAR; -- MSB in MEMaddress+1
                                                    when "000000011" => RAMblock(MemAddress)   <= PDATAR; -- LSB in MEMaddress
                                                    when others      => RAMblock(MemAddress)   <= PDATAR; -- LSB in MEMaddress
                                                    end case;
                                                    PCTRL <= cI2C_RxDAck_44;                    ----- Set data byte will be received
                                                    PWRITEen <= '1';                            ----- ACK will be returned 
                                                    DataCnt <= DataCnt + "000000001";
--------------------------------------------------------------------------------------------------------------------------------------
------------------ Address valid (data trasmitter) -----------------------------------------------------------------------------------
                    when cSTsSLARA_A8 =>  PDATAW <= RAMblock(MemAddress+1);
                                                    PCTRL <= cI2C_RxEnab_44;                    ----- Set data byte trasmitting phase
                                                    PWRITEen <= '1';                            ----- With ACK
                                                    I2CBSYo   <= '1';
                                                    DataCnt <= "000000001"; 
--------------------------------------------------------------------------------------------------------------------------------------
------------------ Address valid, Read flag (data trasmitter) ------------------------------------------------------------------------
                    when cSTsDTxA_B8 =>  PDATAW <= RAMblock(MemAddress);
                                                    PCTRL <= cI2C_RxEnab_44;                    ----- Set data byte trasmitting phase
                                                    PWRITEen <= '1';                            ----- With ACK
                                                    I2CBSYo   <= '1';
                                                    DataCnt <= DataCnt + "000000001";
--------------------------------------------------------------------------------------------------------------------------------------
------------------- STOP condition ---------------------------------------------------------------------------------------------------
                    when cSTsStop_A0 | cSTsDTxNA_C0
                                                =>  NULL; -- I2CCLEAR <= '1';
                                                    PCTRL <= cI2C_RxEnab_44;                    ----- Set data byte restarting
                                                    PWRITEen <= '1';                            ----- With ACK
                                                    I2CBSYo   <= '0';
--------------------------------------------------------------------------------------------------------------------------------------
------------------- Error condition --------------------------------------------------------------------------------------------------
                    when others                 =>  I2CCLEAR <= '1';
                                                    I2CBSYo   <= '0';
                    end case;
--------------------------------------------------------------------------------------------------------------------------------------
                    INTsm_idx <= cINTsmWRITEw; --<-- Delay
--------------------------------------------------------------------------------------------------- -----------------------------------
                when others       =>                INTsm_idx <= cINTsmREAD;
                end case;
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
            PWRITE    <= '0';
            PWDATA    <= X"00";
            PDATAR    <= X"00";
            PBUSY     <= '0';
            SLAVE0sm   <= cSLVADDs;
        elsif CLK'event and CLK='1' then
            case SLAVE0sm is
            when cSLVADDs => PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_addr0; SLAVE0sm <= cSLVADDe; PWDATA <= SLV0add; 
            when cSLVADDe => PSELx <= '1'; PENABLE <= '1'; PWRITE <= '1'; PADDR <= aI2C_addr0; SLAVE0sm <= cSLVADDx; PWDATA <= SLV0add; 
            when cSLVADDx => PSELx <= '1'; PENABLE <= '0'; PWRITE <= '1'; PADDR <= aI2C_addr0; SLAVE0sm <= cSLVADDi; PWDATA <= SLV0add; 
            when others => 
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
            end case;
        end if;
    end process;
end I2CStateMachineINAEMU_beh;
