--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: GBTX_SWITCH.vhd
-- File history:
--      1.20171026:1102: Correzione ENDATA
--      1.20170707:1244: Aggiunto controllo switch da A e S
--      1.20170404.1540: Validazione
--      1.20151210.1200: Modifiche su indirizzamento Power
--
-- Description:
--
-- <Description here>
--
-- Targeted device: <Family::IGLOO2> <Die::M2GL060T> <Package::676 FBGA>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity GBTX_SWITCH is
port (
        GDOa    : out   std_logic_vector(7  downto 0); -- Data out to PARALLEL BUS
        GDIa    : in    std_logic_vector(7  downto 0); -- Data in from PARALLEL BUS
        GADDa   : in    std_logic_vector(7  downto 0); -- Address bus from PARALLEL BUS
        GWRa    : in    std_logic;                     -- Write enable from PARALLEL BUS
        GENa    : in    std_logic;                     -- Bus enable from PARALLEL BUS
---------------------------------------------------------
        GDOs    : out   std_logic_vector(7  downto 0); -- Data out to I2CAUX BUS
        GDIs    : in    std_logic_vector(7  downto 0); -- Data in from I2CAUX BUS
        GADDs   : in    std_logic_vector(7  downto 0); -- Address bus from I2CAUX BUS
        GWRs    : in    std_logic;                     -- Write enable from I2CAUX BUS
        GENs    : in    std_logic;                     -- Bus enable from I2CAUX BUS
---------------------------------------------------------
        GDOx    : in    std_logic_vector(7  downto 0); -- Data in from AUX controller
        GENx    : out   std_logic;                     -- Bus enable to AUX controller
---------------------------------------------------------
        GDOi    : in    std_logic_vector(7  downto 0); -- Data in from GBTXI2C Controller
        GENi    : out   std_logic;                     -- Bus enable to GBTXI2C Controller
---------------------------------------------------------
        GDOc    : in    std_logic_vector(7  downto 0); -- Data in from GBTX Controller
        GENc    : out   std_logic;                     -- Bus enable to GBTX Controller
---------------------------------------------------------
        GDOp    : in    std_logic_vector(7  downto 0); -- Data in from SFPTEMP handler
        GENp    : out   std_logic;                     -- Bus enable to SFPTEMP handler
---------------------------------------------------------
        GDIout  : out   std_logic_vector(7  downto 0); -- Data out 
        GWRout  : out   std_logic;                     -- Write enable out
        GADDout : out   std_logic_vector(3  downto 0); -- Address bus out
---------------------------------------------------------
		GSELH   : in    std_logic;                     -- Selettore byte alto in registro 16 bit di GBTX Power Handler
----------------------------------------------------------------------------------------------------------
--      ENDATA    : in  std_logic; 
        SELI2Cdef : in  std_logic;
        SELI2Cout : out  std_logic;
        CLK       : in  std_logic;
        RESETn    : in  std_logic);
end GBTX_SWITCH;

architecture GBTX_SWITCH_arch of GBTX_SWITCH is
-- Internal BUS (x)
signal GADDsel   : std_logic_vector(3 downto 0) := x"0";  -- Internal high nibble address bus for the device selector case 
signal GDOint    : std_logic_vector(7 downto 0) := x"00"; -- Internal DO bus
signal GDOsint   : std_logic_vector(7 downto 0) := x"00"; -- Internal DO bus for I2CAUX when no register x20 access
signal GDOaint   : std_logic_vector(7 downto 0) := x"00"; -- Internal DO bus for parallel when no register x20 access
signal GENint    : std_logic := '0';                      -- Internal EN signal
signal SELI2C    : std_logic;                             -- Bus I2CAUX (1) or parallel (0) selector
constant CHAR_P : std_logic_vector(7 downto 0) := x"70";  
constant CHAR_S : std_logic_vector(7 downto 0) := x"73";  
begin

    SELI2Cout <= SELI2C;

	SELI2C_handler : process(CLK)
	begin
		if CLK'event and CLK='1' then
            if RESETn='0' then
                SELI2C <= SELI2Cdef;
            else
                if       (GWRa='1') and (GENa='1') and (GADDa=x"20") and (GDIa=CHAR_s) then SELI2C <= '1';
                elsif    (GWRa='1') and (GENa='1') and (GADDa=x"20") and (GDIa=CHAR_p) then SELI2C <= '0';
                elsif    (GWRs='1') and (GENs='1') and (GADDs=x"20") and (GDIs=CHAR_s) then SELI2C <= '1';
                elsif    (GWRs='1') and (GENs='1') and (GADDs=x"20") and (GDIs=CHAR_p) then SELI2C <= '0';
                end if;
            end if;
		end if;
	end process;

    SELI2C_reader : process(GDOsint, GDOaint, GENs, GENa, GADDs, GADDa, SELI2C)
    begin
                if    (GENs='1') and (GADDs=x"20") and (SELI2C='1') then GDOs <= CHAR_S; 
                elsif (GENs='1') and (GADDs=x"20") and (SELI2C='0') then GDOs <= CHAR_P;
                else                                                     GDOs <= GDOsint; 
                end if;
                if    (GENa='1') and (GADDa=x"20") and (SELI2C='1') then GDOa <= CHAR_S; 
                elsif (GENa='1') and (GADDa=x"20") and (SELI2C='0') then GDOa <= CHAR_P;
                else                                                     GDOa <= GDOaint; 
                end if;
    end process;

	GSignalMUX_handler : process(SELI2C, GDOint, GADDs, GWRs, GDIs, GENs, GADDa, GWRa, GDIa, GENa) -- , ENDATA)
	begin
		if SELI2C='1' then
            GDOsint   <= GDOint;
            GDOaint   <= X"00";
			GADDout <= GADDs(3 downto 0);
			GADDsel <= GADDs(7 downto 4);
            GWRout  <= GWRs;
            GDIout  <= GDIs;
            GENint  <= GENs; -- and ENDATA;
		else
            GDOaint   <= GDOint;
            GDOsint   <= X"00";
			GADDout <= GADDa(3 downto 0);
			GADDsel <= GADDa(7 downto 4);
            GWRout  <= GWRa;
            GDIout  <= GDIa;
            GENint  <= GENa;
		end if;
	end process;

    DataInputMUX_handler : process(GADDsel, GDOi, GDOp, GDOc, GDOx)
    begin
        case GADDsel is
        when "0010" => GDOint <= GDOx;
        when "0011" => GDOint <= GDOi;
        when "0100" => GDOint <= GDOc;
        when "0101" => GDOint <= GDOp;
        when others => GDOint <= X"00";
        end case;
    end process;


    ControlSignalMUX_handler : process(GADDsel, GENint)
    begin
        case GADDsel is
        when "0010" => GENx <= GENint; GENi <= '0';    GENc <= '0';    GENp <= '0';
        when "0011" => GENx <= '0';    GENi <= GENint; GENc <= '0';    GENp <= '0';
        when "0100" => GENx <= '0';    GENi <= '0';    GENc <= GENint; GENp <= '0';
        when "0101" => GENx <= '0';    GENi <= '0';    GENc <= '0';    GENp <= GENint;
        when others => GENx <= '0';    GENi <= '0';    GENc <= '0';    GENp <= '0';
        end case;
    end process;

end GBTX_SWITCH_arch;