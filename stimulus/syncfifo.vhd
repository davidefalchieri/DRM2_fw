-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- ----------------------------------------------------------------------------
-- Module:          SYNCFIFO
-- Description:     Simplified model of synchronous FIFO (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY SYNCFIFO IS
  port (
         DIN      : in std_logic_vector (31 downto 0);
         WCLK     : in std_logic;
         RCLK     : in std_logic;
         NWEN     : in std_logic;
         NREN     : in std_logic;
         NOE      : in std_logic;
         NRES     : in std_logic;
         NLD      : in std_logic;

         DOUT     : out std_logic_vector (31 downto 0);
         EF      : out std_logic;
         FF      : out std_logic;
         PAF     : out std_logic;
         PAE     : out std_logic
       );

END SYNCFIFO ;



ARCHITECTURE BEHAV OF SYNCFIFO IS

  -- Livelli per l'almost full e almost empty

  constant PAF_LEV : integer := 7;
  constant PAE_LEV : integer := 7;
  constant DEPTH   : integer := 32768;
  -- constant DEPTH   : integer := 1024;  -- c'entrano 16 eventi da 54 word
--  constant DEPTH   : integer := 59;  -- c'entrano 16 eventi da 54 word

  type memory is array (0 to DEPTH-1) of std_logic_vector (31 downto 0);
  signal mem : memory;
  signal rp  : integer;
  signal wp  : integer;
  signal nword : integer;

  signal EF1     : std_logic;
  signal EF2     : std_logic;
  signal EF3     : std_logic;
  signal EFi     : std_logic;

  begin
      -- uso solo 1 clock per semplicità
      process (NRES,RCLK)
      begin

        -- ***************************************************************
        -- Reset
        -- ***************************************************************
        if (NRES = '0') then
          rp  <= 0;
          wp  <= 0;

          EF1 <= '1';
          EF2 <= '1';
          EF3 <= '1';

          nword  <= 0;
          mem(0) <= (others => 'X');

        elsif RCLK'event and RCLK='1' then

          -- ***************************************************************
          -- Scrittura
          -- ***************************************************************
          if NWEN ='0' and nword < DEPTH and NLD ='1' then
            nword   <= nword + 1;
            mem(wp) <= DIN;
            wp      <= (wp + 1) mod DEPTH;
          end if;

          -- ***************************************************************
          -- Lettura
          -- ***************************************************************
          if NREN ='0' and nword > 0     and NLD ='1' and EF3 = '0' then
            nword <= nword - 1;
            rp    <= (rp + 1) mod DEPTH;
          end if;

          -- ***************************************************************
          -- Lettura e scrittura contemporaneamente (vale l'ultimo assegnamento)
          -- di nword)
          -- ***************************************************************
          if (NWEN ='0' and nword < DEPTH and NLD='1') and
             (NREN ='0' and nword > 0     and NLD='1') then
            nword <= nword;
          end if;

          if nword = 0 then
            EF1 <= '1';
          else
            EF1 <= '0';
          end if;
          EF2 <= EF1;
          EF3 <= EF2;

        end if;
      end process;


      -- funzione da OR (output ready)
      process(nword,EF3)
      begin
        if nword = 0 then
          EF <= '1';
        elsif EF3'event and EF3 = '0' then
          EF <= '0';
        end if;
      end process;

      --DOUT <= mem(rp) when NOE = '0' and NRES = '1' and NLD ='1' and EF3 = '0' else (others => 'Z');
      process(NOE,NRES,NLD,EF3,mem,rp)
      begin
        if NOE = '0' and NRES = '1' and NLD ='1' then
          if EF3 = '0' then
            DOUT <= mem(rp);
          end if;
        else
          DOUT <= (others => 'Z');
        end if;
      end process;


      FF   <= '1' when nword = DEPTH else '0';  -- funziona da IR (input ready)

      PAE  <= '0' when nword < PAE_LEV else '1';

      PAF  <= '0' when nword > DEPTH - PAF_LEV else '1';


END BEHAV;

