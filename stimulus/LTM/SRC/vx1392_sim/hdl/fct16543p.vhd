LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FCT16543P IS
   PORT( 
      NCEAB : IN     std_logic;
      NCEBA : IN     std_logic;
      NLEAB : IN     std_logic;
      NLEBA : IN     std_logic;
      NOEAB : IN     std_logic;
      NOEBA : IN     std_logic;
      A     : INOUT  std_logic_vector;
      B     : INOUT  std_logic_vector
   );

-- Declarations

END FCT16543P ;


ARCHITECTURE BEHAV OF FCT16543P IS

  signal AL : std_logic_vector (A'range);
  signal BL : std_logic_vector (B'range);
  signal CKAB, CKBA, OEAB, OEBA : std_logic;

  begin

  OEAB <= not NOEAB and not NCEAB;
  OEBA <= not NOEBA and not NCEBA;

  CKAB <=  not NLEAB and not NCEAB;
  CKBA <=  not NLEBA and not NCEBA;

  process(OEBA,BL)
  variable i : integer;
  begin
    for i in A'range loop
      if OEBA = '1' then
        if BL(i)='1' or BL(i)='H' then
          A(i) <= '1';
        elsif BL(i)='0' or BL(i)='L' then
          A(i) <= '0';
        else
          A(i) <= '1';   -- DAV !!! A(i) <= 'X';
        end if;
      else
        A(i) <= 'Z';
      end if;
    end loop;
  end process;

  process(OEAB,AL)
  variable i : integer;
  begin
    for i in B'range loop
      if OEAB = '1' then
        if AL(i)='1' or AL(i)='H' then
          B(i) <= '1';
        elsif AL(i)='0' or AL(i)='L' then
          B(i) <= '0';
        else
          B(i) <= '1';	-- DAV !!! B(i) <= 'X';
        end if;
      else
        B(i) <= 'Z';
      end if;
    end loop;
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
