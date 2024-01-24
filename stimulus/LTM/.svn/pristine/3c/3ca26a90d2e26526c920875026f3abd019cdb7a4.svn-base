LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FCT1BIT543 IS
   PORT( 
      NCEAB : IN     std_logic;
      NCEBA : IN     std_logic;
      NLEAB : IN     std_logic;
      NLEBA : IN     std_logic;
      NOEAB : IN     std_logic;
      NOEBA : IN     std_logic;
      A     : INOUT  std_logic;
      B     : INOUT  std_logic
   );

-- Declarations

END FCT1BIT543 ;


ARCHITECTURE BEHAV OF FCT1BIT543 IS

  signal AL : std_logic;
  signal BL : std_logic;
  signal CKAB, CKBA, OEAB, OEBA : std_logic;

  begin

  OEAB <= not NOEAB and not NCEAB;
  OEBA <= not NOEBA and not NCEBA;

  CKAB <=  not NLEAB and not NCEAB;
  CKBA <=  not NLEBA and not NCEBA;

  process(OEBA,BL)
  begin
    if OEBA = '1' then
      A <= BL;
    else
      A <= 'Z';
    end if;
  end process;

  process(OEAB,AL)
  begin
    if OEAB = '1' then
      B <= AL;
    else
      B <= 'Z';
    end if;
  end process;

  process (CKAB,A) 
  begin
    if CKAB = '1' then
      AL <= A;
    end if;
  end process;    

  process (CKBA,B) 
  begin
    if CKBA = '1' then
      BL <= B;
    end if;
  end process;    

END BEHAV;
