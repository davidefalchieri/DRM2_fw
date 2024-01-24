--------------------------------------------------------------------------------
-- Company:	<Name>
--
-- File: I2CState Machine.vhd
-- File	history:
--		1.20150424.2330: Inizio
--
-- Description:
--
-- <Description	here>
--
-- Targeted	device:	<Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library	ieee;
use	ieee.std_logic_1164.all;
use	IEEE.std_logic_unsigned.all; 
use	IEEE.std_logic_arith.all;

entity I2CStateMachine is
port (
		PRDATA	: in	std_logic_vector(7	downto 0);	--	APB	DATA READ
		PWDATA	: out	std_logic_vector(7	downto 0);	--	APB	DATA WRITE
		PADDR	: out	std_logic_vector(7	downto 0);	--	APB	ADDRESS
		PSELx	: out	std_logic;						--	APB	PSELx
		PENABLE	: out	std_logic;						--	APB	ENABLE
		PWRITE	: out	std_logic;						--	APB	WRITE
		PREADY	: in	std_logic;						--	APB	READY
		PINT	: in	std_logic;						--	APB	READY
		FiDATA	: in	std_logic_vector(7	downto 0);
		FoDATA	: out	std_logic_vector(7	downto 0);
		FiFULL	: in	std_logic;
		FoFULL	: in	std_logic;
		ERROR	: out	std_logic;
		FiEPTY	: in	std_logic;
		FoEPTY	: in	std_logic;
		I2CRUN	: in	std_logic;
		I2CBSY	: out	std_logic;
		FREAD	: out	std_logic;
		FWRITE	: out	std_logic;
		RESETn	: in	std_logic;
		CLK		: in	std_logic
);
end	I2CStateMachine;
architecture I2CStateMachine_beh of	I2CStateMachine	is
   -- signal, component	etc. declarations

signal APBsm_idx  :	integer range 0 to	13;
constant cAPBsmGETDAT	: integer := 00;
constant cAPBsmGETDATp	: integer := 01;
constant cAPBsmGETDATx	: integer := 02;
constant cAPBsmGETSTA	: integer := 03;
constant cAPBsmGETSTAp	: integer := 04;
constant cAPBsmGETSTAx	: integer := 05;
constant cAPBsmIDLE		: integer := 06;
constant cAPBsmSETCTR 	: integer := 07;
constant cAPBsmSETCTRp 	: integer := 08;
constant cAPBsmSETCTRx 	: integer := 09;
constant cAPBsmSETDWR 	: integer := 10;
constant cAPBsmSETDWRp 	: integer := 11;
constant cAPBsmSETDWRx 	: integer := 12;
constant cAPBsmWAIT_I	: integer := 13;

signal   I2Csm_idx    :	integer range 0 to 20 := 0;
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
constant cI2CsmWAIT   : integer := 18;


Constant aI2C_addr0	: std_logic_vector(7 downto	0) := X"0C";
Constant aI2C_ctrl	: std_logic_vector(7 downto	0) := X"00";
Constant aI2C_data	: std_logic_vector(7 downto	0) := X"08";
Constant aI2C_stat	: std_logic_vector(7 downto	0) := X"04";

Constant cSTmDRxA_50	    : std_logic_vector(7 downto	0) := X"50";
Constant cSTmDRxNA_58	: std_logic_vector(7 downto	0) := X"58";
Constant cSTmDTxA_28	    : std_logic_vector(7 downto	0) := X"28";
Constant cST_Idle_F8			: std_logic_vector(7 downto	0) := X"F8";
Constant cSTmReSta_10	: std_logic_vector(7 downto	0) := X"10";
Constant cSTmSLARA_40	: std_logic_vector(7 downto	0) := X"40";
Constant cSTmSLAWA_18	: std_logic_vector(7 downto	0) := X"18";
Constant cSTmStart_08		: std_logic_vector(7 downto	0) := X"08";
Constant cSTmStop_E0	: std_logic_vector(7 downto	0) := X"E0";

---+----------------------------------------------------------------------------------+
-- |									 CONSTANTS									  |
---+------------------------------------------------------------------+-+-+-+-+-+-+-+-+
-- |																  |c|e|s|s|s|a|c|c|
-- |																  |r|n|t|t|i|a|r|r|
-- |																  |2|s|a|o|	| |1|0|
---+------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_ClearI2C_00 :	std_logic_vector(7 downto 0) :=	X"00";	--|0|0|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_StarcST60 :	std_logic_vector(7 downto 0) :=	X"60";	--|0|1|1|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_ReStart_60  :	std_logic_vector(7 downto 0) :=	X"60";	--|0|1|1|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxAddW_40	  :	std_logic_vector(7 downto 0) :=	X"40";	--|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxAddR_40	  :	std_logic_vector(7 downto 0) :=	X"40";	--|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_TxDATA_40	  :	std_logic_vector(7 downto 0) :=	X"40";	--|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxDAck_44	  :	std_logic_vector(7 downto 0) :=	X"44";	--|0|1|0|0|0|1|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_RxDAckN_40  :	std_logic_vector(7 downto 0) :=	X"40";	--|0|1|0|0|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
Constant cI2C_StopI2C_50  :	std_logic_vector(7 downto 0) :=	X"50";	--|0|1|0|1|0|0|0|0|
----------------------------------------------------------------------+-+-+-+-+-+-+-+-+
-------------------------------------------------- 1_1	 1__0	0__0
-------------------------------------------------- 7 6	 5	8	7  0
signal PWORD   : std_logic_vector(17 downto	0);	-- SEL & CTRL &	DATA
-------------------------------------------------- SEL  | wr ctrl |  data   | wait int | get stat |
-------------------------------------------------- "00" |   YES   |   WR    |   YES    |   YES    | ADDW, ADDR
-------------------------------------------------- "10" |   YES   |   NOT   |   YES    |   YES    | START, STOP
-------------------------------------------------- "01" |   YES   |   RD    |   YES    |   YES    | RDATA
-------------------------------------------------- "11" |   NOT   |   NOT   |   NOT    |   YES    |
signal PSTATUS : std_logic_vector(7	downto 0);
signal PRUN    : std_logic;
--
begin

	I2C_StateMachine : process(CLK)
	variable vWRflag  :	std_logic;
	variable vBlkAddr :	std_logic_vector(7 downto 0); -- Original GBTX address
	variable vCounter :	integer	range 0	to 3;
	variable vDataCnt :	std_logic_vector(15 downto 0); -- Data sent or received counter
	variable vDataNum :	std_logic_vector(15 downto 0); -- Number	of data	to send, byte 2	& 3	of data	group
	begin
		if RESETn='0' then
			I2Csm_idx <= cI2CsmBEGIN;
			vDataCnt :=	X"0000"; vDataNum := X"0000";
			vCounter := 0;
			FREAD <= '0'; FWRITE <= '0';
			I2Csm_idx <= cI2CsmBEGIN;
			PRUN <= '0';
		elsif CLK'event	and	CLK='1'	then
			if vCounter=3 then
			case I2Csm_idx is
			when cI2CsmBEGIN	=>	PWORD <= "01" & cI2C_ClearI2C_00 & "00000000"; 	PRUN <='1';	I2Csm_idx <= cI2CsmBEGIN2;
			when cI2CsmBEGIN2	=>	if PWORD(0)='1'	then										I2Csm_idx <= cI2CsmWAIT;   end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Wait I2CRUN	command	--------------------------------------------------------------------------------------------------
			when cI2CsmWAIT		=>	if I2CRUN='1'	then										I2Csm_idx <= cI2CsmSTART;  end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Start I2C cycle	------------------------------------------------------------------------------------------------------
			when cI2CsmSTART	=>	PWORD <= "00" & cI2C_StarcST60 & "00000000";	PRUN <='1';	I2Csm_idx <= cI2CsmSTART2;
			when cI2CsmSTART2	=>	if		PSTATUS	= cSTmStart_08		then				I2Csm_idx <= cI2CsmADDW;
									elsif	PSTATUS/= "00000000"	 then						I2Csm_idx <= cI2CsmERROR;  end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Send ADD+W -----------------------------------------------------------------------------------------------------------
			when cI2CsmADDW		=>	PWORD <= "00" & cI2C_TxAddW_40	& 
																(FiDATA and X"7F");	PRUN <='1';
									vBlkAddr :=	FiDATA;	vWRflag	:= FiDATA(0);
									vDataCnt :=	X"0000";  										I2Csm_idx <= cI2CsmADDW2;
			when cI2CsmADDW2	=>	FREAD <= '1'; 
									if		PSTATUS	= cSTmSLAWA_18 then					I2Csm_idx <= cI2CsmDATAW;
									elsif	PSTATUS/= "00000000" then							I2Csm_idx <= cI2CsmERROR;   end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Send Data ------------------------------------------------------------------------------------------------------------
			when cI2CsmDATAW	=>	if	  FiEPTY='1' and vWRflag='0'then						I2Csm_idx <= cI2CsmREST;
									elsif FiEPTY='1' and vWRflag='1'then						I2Csm_idx <= cI2CsmSTOP;    else
									PWORD <= "00" & cI2C_TxDATA_40	& FiDATA; 		PRUN <='1';	
									if vDataCnt	= X"0002" then vDataNum(7 downto 0) := FiDATA; end if;
									if vDataCnt	= X"0003" then vDataNum(15 downto 8):= FiDATA; end if;
									vDataCnt :=	vDataCnt+X"0001";
									vWRflag := FiDATA(0);										I2Csm_idx <= cI2CsmDATAW2;  end if;
			when cI2CsmDATAW2	=>	FREAD <= '1'; 
									if		PSTATUS	= cSTmDTxA_28 then					I2Csm_idx <= cI2CsmDATAW;
									elsif	PSTATUS/= "00000000" then							I2Csm_idx <= cI2CsmERROR;   end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Send Restart ---------------------------------------------------------------------------------------------------------
			when cI2CsmREST		=>	PWORD <= "01" & cI2C_ReStart_60	& "00000000"; 	PRUN <='1';	I2Csm_idx <= cI2CsmREST2;
			when cI2CsmREST2	=>	if		PSTATUS	= cSTmReSta_10 then					I2Csm_idx <= cI2CsmADDR;
									elsif	PSTATUS/= "00000000"	 then						I2Csm_idx <= cI2CsmERROR;   end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Send ADD+R -----------------------------------------------------------------------------------------------------------
			when cI2CsmADDR		=>	PWORD <= "00" & cI2C_TxAddR_40	& vBlkAddr; 	PRUN <='1';
									vDataCnt :=	X"0000";										I2Csm_idx <= cI2CsmADDR2;
			when cI2CsmADDR2	=>	if		PSTATUS	= cSTmSLARA_40 then					I2Csm_idx <= cI2CsmDATAR;
									elsif	PSTATUS/= "00000000" then							I2Csm_idx <= cI2CsmERROR;   end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Get	data -------------------------------------------------------------------------------------------------------------
			when cI2CsmDATAR	=>	PWORD <= "10" & cI2C_RxDAck_44	& X"00"; 		PRUN <='1';
									vDataCnt :=	vDataCnt + X"0001";								I2Csm_idx <= cI2CsmDATAR2;
			when cI2CsmDATAR2	=>	FWRITE <= '1';
									FoDATA <= PWORD(15 downto 8); 
									if		PSTATUS	= cSTmDRxA_50 then
											if vDataCnt=vDataNum then							I2Csm_idx <= cI2CsmSTOP;    end if;
									elsif	PSTATUS/= "00000000" then							I2Csm_idx <= cI2CsmERROR;   end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Get	data -------------------------------------------------------------------------------------------------------------
			when cI2CsmSTOP		=>	PWORD <= "01" & cI2C_StopI2C_50	& X"00"; 		PRUN <='1';
									vDataCnt :=	vDataCnt+X"0001";
			when cI2CsmSTOP2	=>	FWRITE <= '1';
									FoDATA <= PWORD(15 downto 8); 
									if		PSTATUS	= cSTmStop_E0	then				I2Csm_idx <= cI2CsmBEGIN;
									elsif	PSTATUS/= "00000000" then							I2Csm_idx <= cI2CsmERROR;   end if;
----------------------------------------------------------------------------------------------------------------------------------
-----------	Error ----------------------------------------------------------------------------------------------------------------
			when cI2CsmERROR	=>	FWRITE <= '1';
									FoDATA <= PWORD(15 downto 8); 
									ERROR <= '1';												I2Csm_idx <= cI2CsmERROR2;
			when cI2CsmERROR2	=>	If FoEPTY='0' then											I2Csm_idx <= cI2CsmBEGIN;   end if;
----------------------------------------------------------------------------------------------------------------------------------
			when others			=>																I2Csm_idx <= cI2CsmBEGIN;
----------------------------------------------------------------------------------------------------------------------------------
			end	case;
			vCounter	:= 0;
			else
			vCounter	:= vCounter+1;
            end if;
		else
			-- Pulse reset
			FREAD  <= '0';
			FWRITE <= '0';
			PRUN   <= '0';
		end	if;
	end	process;
----------------------------------------------------------------------------------------------------------------
-------------------------------------------------- SEL  | wr ctrl |  data   | wait int | get stat |
-------------------------------------------------- "00" |   YES   |   WR    |   YES    |   YES    | ADDW, ADDR
-------------------------------------------------- "10" |   YES   |   NOT   |   YES    |   YES    | START, STOP
-------------------------------------------------- "01" |   YES   |   RD    |   YES    |   YES    | RDATA
-------------------------------------------------- "11" |   NOT   |   NOT   |   NOT    |   YES    |
----------------------------------------------------------------------------------------------------------------
	APB_StateMachine : process(CLK)
	begin
		if RESETn='0' then
			APBsm_idx <= cAPBsmIDLE;
			PSELx	<= '1';
			PENABLE	<= '0';
			PWRITE	<= '0';
			PWDATA	<= X"00";
			I2CBSY <= '0';
		elsif CLK'event	and	CLK='1'	then
			case APBsm_idx is
			when cAPBsmIDLE		=>	PSELx	<= '1'; PENABLE	<= '0'; PWRITE	<= '0'; PADDR <= aI2C_ctrl; I2CBSY <= '0';
									PWDATA	<= X"00";
									PSTATUS <= X"00";
									if PRUN='1' then
										case PWORD(17 downto 16) is
										when "00"   => APBsm_idx <= cAPBsmSETDWR;
										when "11"   => APBsm_idx <= cAPBsmGETSTA;
										when others => APBsm_idx <= cAPBsmSETCTR;
										end case;
									end	if;
			when cAPBsmSETDWR 	=>	PSELx	<= '1'; PENABLE	<= '0'; PWRITE	<= '1'; PADDR <= aI2C_data; I2CBSY <= '1';
									PWDATA	<= PWORD(7 downto 0);
									APBsm_idx <= cAPBsmSETDWRP;
			when cAPBsmSETDWRp 	=>	PSELx	<= '1'; PENABLE	<= '1'; PWRITE	<= '1'; PADDR <= aI2C_data; I2CBSY <= '1';
									PWDATA	<= PWORD(7 downto 0);
									if PREADY='1' then APBsm_idx <= cAPBsmSETDWRx; end if;
			when cAPBsmSETDWRx 	=>	PSELx	<= '1'; PENABLE	<= '0'; PWRITE	<= '1'; PADDR <= aI2C_data; I2CBSY <= '1';
									PWDATA	<= PWORD(7 downto 0);
									if PREADY='0' then APBsm_idx <= cAPBsmSETCTR; end if;
			when cAPBsmSETCTR 	=>	PSELx	<= '1'; PENABLE	<= '0'; PWRITE	<= '1'; PADDR <= aI2C_ctrl; I2CBSY <= '1';
									PWDATA	<= PWORD(15 downto 8);
									APBsm_idx <= cAPBsmSETCTRp;
			when cAPBsmSETCTRp 	=>	PSELx	<= '1'; PENABLE	<= '1'; PWRITE	<= '1'; PADDR <= aI2C_ctrl; I2CBSY <= '1';
									PWDATA	<= PWORD(15 downto 8);
									if PREADY='1' then APBsm_idx <= cAPBsmSETCTRx; end if;
			when cAPBsmSETCTRx 	=>	PSELx	<= '1'; PENABLE	<= '0'; PWRITE	<= '1'; PADDR <= aI2C_ctrl; I2CBSY <= '1';
									PWDATA	<= PWORD(15 downto 8);
									if PREADY='0' then APBsm_idx <= cAPBsmWAIT_I; end if;
			when cAPBsmWAIT_I	=>  if PINT='1' then
										case PWORD(17 downto 16) is
										when "01"   => APBsm_idx <= cAPBsmGETDAT;
										when others => APBsm_idx <= cAPBsmGETSTA;
										end case;
									end	if;
			when cAPBsmGETDAT	=>	PSELx	<= '1'; PENABLE	<= '0'; PWRITE	<= '0'; PADDR <= aI2C_stat; I2CBSY <= '1';
--									PWDATA	<= PWORD(15 downto 8);
									APBsm_idx <= cAPBsmGETDATp;
			when cAPBsmGETDATp	=>	PSELx	<= '1'; PENABLE	<= '1'; PWRITE	<= '0'; PADDR <= aI2C_stat; I2CBSY <= '1';
--									PWDATA	<= PWORD(15 downto 8);
									if PREADY='1' then APBsm_idx <= cAPBsmGETDATx; end if;
			when cAPBsmGETDATx	=>	PSELx	<= '1'; PENABLE	<= '1'; PWRITE	<= '0'; PADDR <= aI2C_stat; I2CBSY <= '1';
--									PWDATA	<= PWORD(15 downto 8);
									PWORD(7 downto 0) <= PRDATA;
									if PREADY='0' then APBsm_idx <= cAPBsmGETSTA; end if;
			when cAPBsmGETSTA	=>	PSELx	<= '1'; PENABLE	<= '0'; PWRITE	<= '0'; PADDR <= aI2C_stat; I2CBSY <= '1';
--									PWDATA	<= PWORD(15 downto 8);
									APBsm_idx <= cAPBsmGETSTAp;
			when cAPBsmGETSTAp	=>	PSELx	<= '1'; PENABLE	<= '1'; PWRITE	<= '0'; PADDR <= aI2C_stat; I2CBSY <= '1';
--									PWDATA	<= PWORD(15 downto 8);
									if PREADY='1' then APBsm_idx <= cAPBsmGETSTAx; end if;
			when cAPBsmGETSTAx	=>	PSELx	<= '1'; PENABLE	<= '1'; PWRITE	<= '0'; PADDR <= aI2C_stat; I2CBSY <= '1';
--									PWDATA	<= PWORD(15 downto 8);
									PSTATUS <= PRDATA;
									if PREADY='0' then APBsm_idx <= cAPBsmIDLE; end if;
			when others		  	=>	APBsm_idx <= cAPBsmIDLE;
			end	case;
		end	if;
	end	process;
end	I2CStateMachine_beh;
