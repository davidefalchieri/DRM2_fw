--
-- VHDL Architecture vx1392_trig.test1.rtl
--
-- Created:
--          by - daprato.UNKNOWN (LUCA-FE)
--          at - 10:02:43 29/11/2005
--
-- using Mentor Graphics HDL Designer(TM) 2003.2 (Build 28)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY test_sram IS
   PORT( 
      -- Cyclone Configuration Port
      CONFIG      : OUT    std_logic;
      nCYC_RELOAD : IN     std_logic;
      FCS         : OUT    std_logic;
      F_SCK       : OUT    std_logic;
      F_SI        : OUT    std_logic;
      F_SO        : IN     std_logic;
      -- Clock Port
      DPCLK       : IN     std_logic_vector (7 DOWNTO 0);
      DPCLK0      : IN     std_logic;
      DPCLK1      : IN     std_logic;
      LCLK        : IN     std_logic;
      SCLK        : IN     std_logic;
      -- Trigger Port
      OR_DEL      : IN     std_logic_vector (47 DOWNTO 0);
      TRD         : OUT    std_logic_vector ( 7 DOWNTO 0);
      TRM         : OUT    std_logic_vector (23 DOWNTO 0);
      CLK_CTTM    : IN     std_logic;
      D_CTTM      : OUT    std_logic_vector (23 DOWNTO 0);
      SP_CTTM     : OUT    std_logic_vector ( 6 DOWNTO 0);
      -- SRAM Interface
      nCSRAM      : OUT    std_logic;
      nOERAM      : OUT    std_logic;
      nWRRAM      : OUT    std_logic;
      RAMDT       : INOUT  std_logic_vector (47 DOWNTO 0);
      RAMAD       : OUT    std_logic_vector (17 DOWNTO 0);
      -- Local Bus Interface
      nLBAS       : IN     std_logic;
      nLBCLR      : IN     std_logic;
      nLBCS       : IN     std_logic;
      nLBLAST     : INOUT  std_logic;
      nLBRD       : IN     std_logic;
      nLBRES      : IN     std_logic;
      nLBWAIT     : IN     std_logic;
      nLBRDY      : OUT    std_logic;
      nLBPCKE     : OUT    std_logic;
      nLBPCKR     : OUT    std_logic;
      LB          : INOUT  std_logic_vector (31 DOWNTO 0);
      LBSP        : INOUT  std_logic_vector (31 DOWNTO 0);
      -- Test Port
      TST         : OUT    std_logic_vector (7 DOWNTO 0)
   );

-- Declarations

END test_sram ;

--
ARCHITECTURE rtl OF test_sram IS

signal LBSPCLK    : std_logic;
signal CNT24      : std_logic_vector(23 downto 0);

BEGIN
   

--nLBAS   => Unused
--nLBCLR  => RAMAD(16)
--nLBCS   => RAM CS
--nLBLAST => RAMDT[39]
--nLBRD   => RAM OE
--nLBRES  => RAMAD(17)
--nLBWAIT => Unsed  (Test)
--nLBRDY  => Unsed
--LBSP(7) => Pulse CTTM

nLBRDY   <= '1';

RAMAD    <= nLBRES & nLBCLR & LBSP(31 downto 16);
RAMDT    <= (LBSP(15 downto 8) & nLBLAST & LBSP(6 downto 0) & LB(31 downto 0)) when nLBRD = '1' else (others => 'Z');
nCSRAM   <= nLBCS;
nOERAM   <= nLBRD;
nWRRAM   <= not(nLBRD);


-- Flash Driver
F_SCK    <= 'Z';
F_SI     <= 'Z';
FCS      <= 'Z';
CONFIG   <= 'Z';--nCYC_RELOAD;


TRD      <= (others => '0');
TRM      <= (others => '0');
nLBPCKE  <= '0';
nLBPCKR  <= '1';

LB                 <= RAMDT(31 downto 0) when nLBRD = '0' else (others => 'Z');
LBSP(15 downto 8)  <= RAMDT(47 downto 40) when nLBRD = '0' else (others => 'Z');
nLBLAST            <= RAMDT(39) when nLBRD = '0' else 'Z'; 
LBSP( 6 downto 0)  <= RAMDT(38 downto 32) when nLBRD = '0' else (others => 'Z');


-- LVDS (CTTM -> PDL) LOOP TEST
SP_CTTM  <= (others => '0');

process(CLK_CTTM)
begin
  if CLK_CTTM'event and CLK_CTTM = '1' then
    CNT24 <= CNT24 + 1;
    if CNT24 = X"FFFFFF" then
      D_CTTM <= X"FFFFFF";
    else
      D_CTTM <= X"000000";
    end if;
  end if;
end process;

            
TST      <= ( 0 => nLBAS,
              1 => nLBCLR,
              2 => nLBCS,
              3 => nLBLAST,
              4 => nLBRD,
              5 => nLBRES,
              6 => '0',
              7 => CLK_CTTM);

END rtl;

