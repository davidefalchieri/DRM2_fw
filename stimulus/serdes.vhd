-- ********************************************************
-- Emulazione del SerDes SERDES usato per i link ottici
-- ********************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SERDES IS
   PORT(
      OPTRX : IN     std_logic;
      OPTTX : OUT    std_logic;

      RCLK  : BUFFER std_logic := '0';
      TCLK  : IN     std_logic;

      RX    : BUFFER std_logic_vector (9 DOWNTO 0);
      TX    : IN     std_logic_vector (9 DOWNTO 0);

      BSYNC : BUFFER std_logic
   );
END SERDES ;


ARCHITECTURE BEHAV OF SERDES IS

constant T_valid_before : time := 2.5 ns; 

signal i,j : integer;
signal TOG : std_logic := '0';

BEGIN

  -- Emulazione della trasmissione seriale dei dati sulla fibra ottica
  P_TX_proc: process
  variable txi : std_logic_vector (9 downto 0);
  begin
    OPTTX <= '0';
    loop
      wait until TCLK'event and TCLK = '1';
      txi := TX;
      for i in 0 to 9 loop
        OPTTX <= txi(0);
        txi   := '0' & txi(9 downto 1);
        if i<9 then
            wait for 800 ps;
        end if;
      end loop;
    end loop;
  end process;


  
  
  -- Emulazione della ricezione seriale dei dati sulla fibra ottica
  P_RX_proc: process
  variable rxi : std_logic_vector (9  downto 0) := "0000000000";
  variable j: integer;
  begin
        RCLK  <= '0';
        BSYNC <= '0';
        j     := 0;
        -- aspetto un 1 in ricezione
        wait until OPTRX'event and OPTRX = '1';
        
        L_comma: loop 
            rxi := OPTRX & rxi(9 downto 1);
            -- mi aggancio sul primo comma
            if rxi = "0101111100" then 
                BSYNC <= '1';
                RX    <= rxi;
                RCLK  <= '1';
                wait for 800 ps;                
                exit L_comma;
            end if;
            wait for 800 ps;
        end loop L_comma; 
        
        L_data: loop
            for j in 0 to 9 loop 
                rxi := OPTRX & rxi(9 downto 1);
                if j = 9 then 
                    RX   <= rxi;
                    RCLK <= not RCLK;
                elsif j = 4 then 
                    RCLK <= not RCLK;
                end if;
                wait for 800 ps;
            end loop; 
        end loop L_data; 
      
  end process;

END BEHAV;

