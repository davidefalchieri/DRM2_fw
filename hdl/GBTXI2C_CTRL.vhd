--------------------------------------------------------------------------------
-- Company: INFN
--
-- File: GBTX_HANDLER.vhd
-- File history:
--      1.20171122.1541: TimeOut         
--      1.20171030.1057: Correzioni 1030x
--      1.20171019.1707: Nuova versione
--      1.20170920.1753: Debug error in corso
--      1.20170804.1136: Modifiche su FoEPTY in FIFO OUT
--      1.20170801.1646: Inseriti handler flag FIFO
--      1.20170621.1447: Aggiunti flags
--      1.20170606.1123: Prima release
--
-- Description:
--
-- <Description here>
--
-- Targeted device: VHDL base dev. system
-- Author: Casimiro Baldanza--
--------------------------------------------------------------------------------



library IEEE;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity GBTXI2C_CTRL is
port (
        DO      : out std_logic_vector(7 downto 0);
        DI      : in  std_logic_vector(7 downto 0);
        ADD     : in  std_logic_vector(3 downto 0);
        WR      : in  std_logic;
        EN      : in  std_logic;
-----------------------------------------------------------------------------------------------------------------------------
        I2CWRT  : out   std_logic;                    --  GBTX I2C run command
        I2CRUN  : out   std_logic;                      --  GBTX I2C run command
        I2CRUNfb: in   std_logic;                       --  GBTX I2C run command
        I2CRST  : out   std_logic;                      --  GBTX I2C run command
        I2CBSY  : in    std_logic;                      --  GBTX I2C busy flag
        FoDATA  : in    std_logic_vector(7  downto 0);  --  FIFO out di I2C_GBTX, input in questo modulo
        FiDATA  : out   std_logic_vector(7  downto 0);  --  FIFO in di I2C_GBTX, output in questo modulo
        ErDATA  : in    std_logic_vector(7  downto 0);  --  Errore da I2C GBTX
        FoEPTY  : in    std_logic;
        FoFULL  : in    std_logic;
        FiEPTY  : in    std_logic;
        FiFULL  : in    std_logic;
        FIFOR   : out   std_logic;
        FIFORfb : in    std_logic;
        FIFOW   : out   std_logic;
        FIFOWfb : in    std_logic;
        I2CERR  : in    std_logic;
		SDAin   : in  std_logic;
		SCLin   : in  std_logic;
------------------------------------------------------------------------------------------------------------------------------
        I2CRADD : out   std_logic_vector(8 downto 0);   
        I2CRNUM : out   std_logic_vector(8 downto 0);   
-----------------------------------------------------------------------------------------------------------------------------
        FiWRCNT  : in    std_logic_vector(9  downto 0);  --
        FiRDCNT  : in    std_logic_vector(9  downto 0);  --
        FoWRCNT  : in    std_logic_vector(9  downto 0);  --
        FoRDCNT  : in    std_logic_vector(9  downto 0);  --
-----------------------------------------------------------------------------------------------------------------------------
        SCLi    : in    std_logic;
        P1mS    : in    std_logic;
-----------------------------------------------------------------------------------------------------------------------------
        RESETn  : in    std_logic;
        CLK     : in    std_logic
);
end GBTXI2C_CTRL;
architecture GBTXI2C_CTRL_beh of GBTXI2C_CTRL is
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--nstant aI2C_addr0 : std_logic_vector(8 downto 0) := '0' & X"0C";
-----------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
---------------------- Register ---------------------------------|   Bit7    |   Bit6    |   Bit5    |   Bit4    |   Bit3    |   Bit2    |   Bit1    |   Bit0    |  Default   |
-----------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGI2C_DATA : std_logic_vector(3 downto 0):="0000"; ---- |                      Data to FIFO IN when WRITE, Data to FIFO OUT when READ                   | "00000000" |
-----------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGI2C_ERRN : std_logic_vector(3 downto 0):="0001"; --RD |                                           Error code                                          | "00000000" |
-----------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGI2C_STAT : std_logic_vector(3 downto 0):="0010"; ---- |                                 Read [e|d|b|q|x] - Write [r|w|x]                              |     'e'    |
-----------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
constant aGI2C_FLAG : std_logic_vector(3 downto 0):="0011"; --RD |   I2CBSY  |TimeOutErr |   FoFULL  |   FiFULL  |   FoEPTY  |   FiEPTY  |    ...    |   I2CERR  | "00001100" |
-----------------------------------------------------------------+-----------------------------------------------------------------------------------------------+------------+
constant aGI2C_RADL : std_logic_vector(3 downto 0):="0100"; ---- |                                   GBTX register address bit low                               | "00000000" |
-----------------------------------------------------------------+-----------------------------------------------------------------------------------------------+------------+
constant aGI2C_RADH : std_logic_vector(3 downto 0):="0101"; ---- |                                   GBTX register address bit hi                                | "00000000" |
-----------------------------------------------------------------+-----------------------------------------------------------------------------------------------+------------+
constant aGI2C_RNML : std_logic_vector(3 downto 0):="0110"; ---- |                     GBTX number of register to read during read operation bit low             | "00000000" |
-----------------------------------------------------------------+-----------------------------------------------------------------------------------------------+------------+
constant aGI2C_RNMH : std_logic_vector(3 downto 0):="0111"; ---- |                     GBTX number of register to read during read operation bit hi              | "00000000" |
-----------------------------------------------------------------+-----------------------------------------------------------------------------------------------+------------+
-----------------------------------------------------------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+------------+
--- STATEOVER, REFCLKSEL, ARST, GBTX_MODE GBTX_SADD, TX_DISAB, GBTX_RXLOCKM has been cut on DRM2
--------------------------------------------------------------
--nstant cERR_BUS00 : std_logic_vector(7 downto 0):= x"00"; -- flag errore
--nstant cERR_BUS  : std_logic_vector(7 downto 0) := x"20"; -- flag errore
constant cERR_TOUT : std_logic_vector(7 downto 0) := x"90"; -- flag errore
constant cERR_BUSY : std_logic_vector(7 downto 0) := x"91"; -- flag errore
constant cERR_FULL : std_logic_vector(7 downto 0) := x"92"; -- flag errore
constant cERR_EPTY : std_logic_vector(7 downto 0) := x"93"; -- flag errore
--------------------------------------------------------------
signal ERRORcode : std_logic_vector(7 downto 0); -- flag errore
signal ERRORflag : std_logic;                    -- flag errore
signal ERRORclr  : std_logic;                    -- flag errore
--------------------------------------------------------------
signal I2CRUNson           : std_logic; -- Flag for I2CRUN on
signal I2CRUNsoff          : std_logic; -- Flag for I2CRUN off
signal I2CRUNpls           : std_logic; -- Flag for I2CBSY
signal I2CBSYrd            : std_logic; -- Flag for I2CBSY
signal I2CBSYend           : std_logic; -- Flag for I2CBSY
--------------------------------------------------------------
signal TIMEOUTerror        : std_logic; --<- 171122
signal TIMEOUTflag         : std_logic;
signal TIMEOUT_SDA    : std_logic;
signal TIMEOUT_SCL    : std_logic;
--------------------------------------------------------------
--signal ENdly : std_logic;
signal FiFULLdly : std_logic;
signal FoEPTYdly : std_logic;
--------------------------------------------------------------
signal  rI2CRADD : std_logic_vector(8 downto 0);   
signal  rI2CRNUM : std_logic_vector(8 downto 0);   
--------------------------------------------------------------
signal I2C_STATUS : std_logic_vector(3 downto 0);

constant CHAR_b : std_logic_vector(7 downto 0) := x"62";
constant CHAR_d : std_logic_vector(7 downto 0) := x"64";
constant CHAR_e : std_logic_vector(7 downto 0) := x"65";
constant CHAR_q : std_logic_vector(7 downto 0) := x"71";
constant CHAR_r : std_logic_vector(7 downto 0) := x"72";
constant CHAR_w : std_logic_vector(7 downto 0) := x"77";
constant CHAR_x : std_logic_vector(7 downto 0) := x"78";
--------------------------------------------------------------
begin

    IO_handler : process(rI2CRADD, rI2CRNUM)
    begin
        I2CRADD <= rI2CRADD;   
        I2CRNUM <= rI2CRNUM;   
    end process;

    FIFO_RW_handler : process(CLK) -- COMBINATORIO
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            FIFOR <= '0';
            FIFOW <= '0';
        elsif ADD=aGI2C_DATA then
            FIFOR <= (EN and not WR) or I2CBSYend;
            FIFOW <=  EN and     WR;
        else
            FIFOR <= I2CBSYend; -- Se fine I2CBSY, impulso di read per allineare FIFO out, altrimenti non attivo
            FIFOW <= '0';
        end if;
	end if;
    end process;


    FIFO_flag_handler : process(CLK)
    variable FoEPTYd : std_logic;
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
		FiFULLdly <= FiFULL;
		FoEPTYdly <= FoEPTY;
        FoEPTYd   := FoEPTY;
        else
			if EN='0' then 	FiFULLdly <= FiFULL; FoEPTYdly <= FoEPTYd; end if;
            if FoEPTYd='0' then FoEPTYd := FoEPTY and FIFOR;
            else                FoEPTYd := FoEPTY;
            end if;
        end if;
    end if;
    end process;

    ERROR_handler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            ERRORcode <= x"00";
            ERRORflag <= '0';
            ERRORclr <= '0';
        elsif EN='1' and WR='0' and ADD=aGI2C_ERRN                       then ERRORclr <= '1';
        elsif EN='0' and ERRORclr='1'                                    then ERRORcode <= x"00";           ERRORflag <= '0';  ERRORclr <= '0';
        elsif ERRORflag='0' then
            if    I2CERR='1'                                             then ERRORcode <= ErDATA or x"80"; ERRORflag <= '1';
            elsif TimeOutError='1'                                       then ERRORcode <= cERR_TOUT;       ERRORflag <= '1'; --<- 171122
            elsif EN='1'            and ADD=aGI2C_DATA and I2CBSYrd='1'  then ERRORcode <= cERR_BUSY;       ERRORflag <= '1';
            elsif EN='1' and WR='1' and ADD=aGI2C_DATA and FiFULLdly='1' then ERRORcode <= cERR_FULL;       ERRORflag <= '1';
            elsif EN='1' and WR='0' and ADD=aGI2C_DATA and FoEPTYdly='1' then ERRORcode <= cERR_EPTY;       ERRORflag <= '1';
            end if;
        end if;
    end if;
    end process;

	STATUS_handler : process(I2CBSYrd, FoEPTYdly, FiEPTY, ERRORflag)
	begin
		I2C_STATUS <= FiEPTY & FoEPTYdly & I2CBSYrd & ERRORflag;
	end process;

    GBTX_I2C_RW_handler : process (CLK)
    begin
    if CLK'event and CLK='1' then
       if RESETn='0' then
            FiDATA    <= x"00";
            I2CRUNpls <= '0';
            I2CRST <= '0';
            I2CWRT <= '0';
            rI2CRADD <= "000000000";
            rI2CRNUM <= "000000000";
        else
            if EN='1' and WR='1' then
                case ADD is
					when aGI2C_DATA => FiDATA <= DI;
					when aGI2C_ERRN => null;
					when aGI2C_STAT => if    DI=CHAR_x then I2CRST    <= '0';
                                       elsif DI=CHAR_r then I2CRUNpls <= not ERRORflag; I2CWRT <= '0'; -- 171117
                                       elsif DI=CHAR_w then I2CRUNpls <= not Errorflag; I2CWRT <= '1'; -- 171117
                                       end if;
					when aGI2C_RADL => rI2CRADD(7 downto 0) <= DI;
					when aGI2C_RADH => rI2CRADD(8)          <= DI(0);
					when aGI2C_RNML => rI2CRNUM(7 downto 0) <= DI;    
					when aGI2C_RNMH => rI2CRNUM(8)          <= DI(0); 
					when others     => null;
                end case;
            else
--          elsif EN='1' then -- 1030a EN aggiunto
                case ADD is
                    when aGI2C_DATA => DO <= FoDATA;
                    when aGI2C_ERRN => DO <= ERRORcode;
                    when aGI2C_STAT => case I2C_STATUS is
-------------------------------------------- IOBE
                                       when "1100" => DO <= CHAR_e;
                                       when "0100" => DO <= CHAR_d;
                                       when "0110" => DO <= CHAR_b;
                                       when "1010" => DO <= CHAR_b;
                                       when "0010" => DO <= CHAR_b;
                                       when "1110" => DO <= CHAR_b;
                                       when "0000" => DO <= CHAR_q;
                                       when "1000" => DO <= CHAR_q;
                                       when others => DO <= CHAR_x;
                                       end case;
                    when aGI2C_FLAG => DO <= I2CBSYrd      &   -- Bit 7
                                             TimeOutError  &   -- Bit 6  --<- 171122
                                             FoFULL        &   -- Bit 5
                                             FiFULL        &   -- Bit 4
                                             FoEPTY        &   -- Bit 3
                                             FiEPTY        &   -- Bit 2
											 I2CERR        &   -- Bit 1
											 ERRORflag     ;   -- Bit 0
					when aGI2C_RADL => DO <= rI2CRADD(7 downto 0);
					when aGI2C_RADH => DO <= "0000000" & rI2CRADD(8);
					when aGI2C_RNML => DO <= rI2CRNUM(7 downto 0);
					when aGI2C_RNMH => DO <= "0000000" & rI2CRNUM(8);
                    when others     => DO <= x"00";
                end case;
--          else ------------------------------------------------- 1030
                I2CRST <= '1';                                  -- 1030
				if I2CRUNson='1' then I2CRUNpls <= '0'; end if; -- 1030
            end if;
        end if;
    end if;
    end process;

    I2CRUN_pin_handler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if RESETn='0' then
            I2CRUN     <= '0';
            I2CRUNson  <= '0';
            I2CRUNsoff <= '0';
            I2CBSYrd   <= '0';
			I2CBSYend  <= '0';
        else
            if    I2CERR='1'                                                        then I2CRUN <= '0'; I2CRUNson <= '0'; I2CRUNsoff <= '0'; I2CBSYrd <= '0'; I2CBSYend <= '0';
            elsif TimeOutError='1'                                                  then I2CRUN <= '0'; I2CRUNson <= '0'; I2CRUNsoff <= '0'; I2CBSYrd <= '0'; I2CBSYend <= '0'; --<- 171122
			elsif I2CRUNpls='0' and I2CRUNson='0' and I2CRUNsoff='0' and I2CBSY='0' then I2CRUN <= '0'; I2CRUNson <= '0'; I2CRUNsoff <= '0'; I2CBSYrd <= '0'; I2CBSYend <= '0'; -- 1 to 2
            elsif I2CRUNpls='1' and I2CRUNson='0' and I2CRUNsoff='0' and I2CBSY='0' then I2CRUN <= '1'; I2CRUNson <= '1'; I2CRUNsoff <= '0'; I2CBSYrd <= '1'; I2CBSYend <= '0'; -- 2 to 3
            elsif I2CRUNpls='1' and I2CRUNson='1' and I2CRUNsoff='0' and I2CBSY='0' then I2CRUN <= '1'; I2CRUNson <= '1'; I2CRUNsoff <= '0'; I2CBSYrd <= '1'; I2CBSYend <= '0'; -- 3 to 4
            elsif I2CRUNpls='0' and I2CRUNson='1' and I2CRUNsoff='0' and I2CBSY='0' then I2CRUN <= '1'; I2CRUNson <= '1'; I2CRUNsoff <= '0'; I2CBSYrd <= '1'; I2CBSYend <= '0'; -- 3 to 4
            elsif                   I2CRUNson='1' and I2CRUNsoff='0' and I2CBSY='1' then I2CRUN <= '1'; I2CRUNson <= '0'; I2CRUNsoff <= '1'; I2CBSYrd <= '1'; I2CBSYend <= '0'; -- 4 to 5
            elsif                   I2CRUNson='0' and I2CRUNsoff='1' and I2CBSY='1' then I2CRUN <= '1'; I2CRUNson <= '0'; I2CRUNsoff <= '1'; I2CBSYrd <= '1'; I2CBSYend <= '0'; -- 5 to 6
            elsif                   I2CRUNson='0' and I2CRUNsoff='1' and I2CBSY='0' then I2CRUN <= '0'; I2CRUNson <= '0'; I2CRUNsoff <= '0'; I2CBSYrd <= '0'; I2CBSYend <= '1'; -- 6 to 7
            end if;
        end if;
    end if;
    end process;

    SDA_Timeout_handler : process(CLK)
    variable Time_mS : integer range 0 to 1001 := 0;
    begin
    if CLK'event and CLK='1' then
        if    RESETn='0' or SCLin='1' then 
                TIMEOUT_SDA <= '0'; Time_mS := 0; 
        elsif P1mS='1' then 
            if Time_mS = 1000 then
                TIMEOUT_SDA <= '1'; Time_mS := 1000;
            else 
                TIMEOUT_SDA <= '0'; Time_mS := Time_mS+1; 
            end if;
        end if;
    end if;
    end process;

    SCL_Timeout_handler : process(CLK)
    variable Time_mS : integer range 0 to 1001 := 0;
    begin
    if CLK'event and CLK='1' then
        if    RESETn='0' or SCLin='1' then 
                TIMEOUT_SCL <= '0'; Time_mS := 0; 
        elsif P1mS='1' then 
            if Time_mS = 1000 then
                TIMEOUT_SCL <= '1'; Time_mS := 1000;
            else 
                TIMEOUT_SCL <= '0'; Time_mS := Time_mS+1; 
            end if;
        end if;
    end if;
    end process;

    TIMEOUTerro_handler : process(CLK)
    begin
    if CLK'event and CLK='1' then
        if    RESETn='0' or SCLin='1' then 
                TIMEOUTerror <= '0';
                TIMEOUTflag  <= '0';
        else
                TIMEOUTerror <= TIMEOUT_SCL or TIMEOUT_SDA;
                TIMEOUTflag  <= TIMEOUT_SCL or TIMEOUT_SDA;
        end if;
    end if;
    end process;


end GBTXI2C_CTRL_beh;