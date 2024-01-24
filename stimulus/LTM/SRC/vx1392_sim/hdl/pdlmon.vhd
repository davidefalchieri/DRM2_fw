--
-- Monitor dei segnali di accesso alle PDL.
-- File per la simulazione funzionale della FPGA della LTM (VX1392). 
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
--use STD.textio.all;
USE work.txt_util.all;

ENTITY pdlmon IS
  PORT ( 
     AE_PDL       : IN std_logic_vector(47 DOWNTO 0);
     MD_PDL       : IN std_logic; 
     P_PDL        : IN std_logic_vector(7 DOWNTO 1);
     SC_PDL       : IN std_logic;
     SI_PDL       : IN std_logic;
     SP_PDL       : IN std_logic_vector(47 DOWNTO 0)
  );
END ENTITY pdlmon;

--
ARCHITECTURE behav OF pdlmon IS
 type pdl_values is array(0 to 47) of std_logic_vector(7 DOWNTO 0);
 signal PDL_VALUE : pdl_values;
BEGIN

PDL_Value_Loop: for i in 0 to 47 generate
  PDL_VALUE(i) <= std_logic_vector'(P_PDL & SP_PDL(i));
  print((AE_PDL(i)'event and AE_PDL(i) = '0' and AE_PDL(i)'last_value = '1'), "Parallel write access to PDL" & integer'image(i) & ": Value = " & hstr(PDL_VALUE(i)));
end generate;

END ARCHITECTURE behav;

