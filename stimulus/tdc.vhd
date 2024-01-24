-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- --------------------------------------------------------------------------
-- Module:          TDC
-- Description:     HPTDC chip (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;
USE work.io_utils.ALL;


ENTITY TDC IS
  generic (tdc_id      : integer;
           chain       : integer;
           num_test_dt : integer:= 32);

  port (
       CLK       : in     std_logic; -- Master clock del TDC

       -- segnali di controllo
       RESET     : in     std_logic; -- Master dei buffer
       BNC_RES   : in     std_logic; -- Reset del contatore
       EV_RES    : in     std_logic; -- Reset dell'event count
       TRIGGER   : in     std_logic;

       -- segnali per il readout dei dati
       GET_DATA  : in     std_logic; -- Get parallel data
       DATA_RDY  : out    std_logic; -- Data ready per il readout
       ERROR     : out    std_logic; -- Global error output
       DOUT      : out    std_logic_vector (31 downto 0); -- Parallel Data

       -- segnali per il passaggio della palla
       TOKEN_IN  : in     std_logic; -- Token input
       TOKEN_OUT : out    std_logic; -- Token output

       -- HIT input
       HIT       : in     std_logic_vector (7 downto 0);

       Finished  : in     std_logic

       );

END TDC ;

ARCHITECTURE BEHAV OF TDC IS

  file LOG0 : TEXT is OUT "tdc0.log";
  file LOG1 : TEXT is OUT "tdc1.log";
  file LOG2 : TEXT is OUT "tdc2.log";
  file LOG3 : TEXT is OUT "tdc3.log";

  constant   Tmw   : integer := 8;  -- Match window
  constant   Tclk  : time := 25 ns; -- Clock period
  constant   Td    : time := 10 ns; -- delay massimi del TDC
  constant   Twr   : time := 1 ns;  -- durata di un ciclo di scrittura
  constant   Trd   : time := 1 ns;  -- durata di un ciclo di lettura

  -- Contatore: il numero di bit disponibili per le misure di tempo è limitato a 19
  signal CNT     : std_logic_vector(20 downto 0);

  -- HIT register
  type HIT_REGS is array (0 to 31) of std_logic_vector (31 downto 0);
  signal L1_BUF  : HIT_REGS; -- buffer di primo livello

  -- flag settati la prima volta che un canale viene colpito da un HIT
  signal CH_FLAG : std_logic_vector(31 downto 0);

  -- Readout FIFO
  constant DEPTH   : integer := 264;
  type memory is array (0 to DEPTH-1) of std_logic_vector (31 downto 0);
  signal mem : memory;
  signal rp  : integer;
  signal wp  : integer;
  signal nword : integer;

  -- conta le word in un evento (Trigger Matching abilitato)
  signal nch : integer:= 0;

  -- Event ID e Bunch ID
  signal EV_ID   : std_logic_vector(11 downto 0);
  signal BNC_ID  : std_logic_vector(11 downto 0);

  -- segnale per l'abilitazione del Trigger Matching
  signal TRG_MATCH  : std_logic;

  -- segnale per l'abilitazione di TDC header/EOB
  signal EN_HEADER  : std_logic;

  -- segnale per l'abilitazione della modalità di TEST
  signal TESTMODE  : std_logic;

  -- segnali per la scrittura e la lettura nella FIFO
  signal DIN  : std_logic_vector(31 downto 0);
  signal RD  : std_logic;
  signal WR  : std_logic;
  signal MEM_FULL  : std_logic;

  signal NUMEV     : integer := 0;


begin

  ERROR <= '0';


  -- ***************************************************************
  -- PROGRAMMAZIONE DEL TDC
  -- ***************************************************************
  -- Trigger matching
  ------------------------------------------------------------------
  TRG_MATCH <= '1';
  EN_HEADER <= '0';
  TESTMODE  <= '1';


  -- ***************************************************************
  -- Bunch ID
  -- ***************************************************************
  BNC_ID <= "000000000000";


  -- ***************************************************************
  -- CONTATORE
  -- ***************************************************************
  -- conta sul fronte in salita del CLK
--  process (BNC_RES,RESET,CLK)
--   begin
--    if (BNC_RES = '1') or (RESET = '1') then
--      CNT <= (others => '0');
--    elsif (CLK'event and CLK ='1') then
--      CNT <= CNT + 1;
--    end if;
--  end process;
  process begin
    CNT <= (others => '0');
    wait for 1 ns;
    while Finished = '0' loop
      CNT <= CNT+1;
      wait for 1 ns;
    end loop;

    wait;
  end process;



  -- ***************************************************************
  -- FIFO: processo per la lettura e la scrittura
  -- ***************************************************************
  process (RESET,WR,RD)
    variable outline : line;

    begin

    -- Reset
    ------------------------------------------------------------------
      if (RESET = '1') then
        rp <= 0;
        wp <= 0;
        nword <= 0;
        mem(0) <= (others => 'X');

      else

      -- Scrittura
      ------------------------------------------------------------------
        if (WR'event and WR='1' and nword<DEPTH) then
          mem(wp) <= DIN;
          wp <= (wp + 1) mod DEPTH;
          nword <= nword + 1;
          write(outline, now, left, 10);
          write_string(outline, " TDC0 DataW = 0x ");
          write_num(outline, to_Bitvector(DIN), field => 8, base => hex);  -- scrivo il dato nel LOG file
          case tdc_id is
            when 0 => writeline(LOG0, outline);
            when 1 => writeline(LOG1, outline);
            when 2 => writeline(LOG2, outline);
            when 3 => writeline(LOG3, outline);
            when others => null;
          end case;

        end if;

      -- Lettura
      ------------------------------------------------------------------
        if (RD'event and RD='1' and nword>0) then
          nword <= nword - 1;
          rp <= (rp + 1) mod DEPTH;
        end if;


      -- Lettura e scrittura contemporaneamente (vale l'ultimo assegnamento)
      -- di nword)
      ------------------------------------------------------------------
        if (WR'event and WR='1' and nword<DEPTH) and
           (RD'event and RD='1' and nword>0) then
          nword <= nword;
        end if;

      end if;

  end process;

  MEM_FULL <= '1' when nword = DEPTH else '0';


  -- ***************************************************************
  -- SCRITTURA nella FIFO
  -- ***************************************************************
  process
    variable i           : integer;
    variable outline     : line;
    begin

      WR <= '0';


      wait until(TRIGGER'event and TRIGGER = '1');

      wait for 1 ns;

      -- Scrittura con trigger matching abilitato: all'arrivo di un
      -- trigger trasferisco nella FIFO 8 parole (1 per ciascun canale)
      ------------------------------------------------------------------
      write_string(outline, "-> EVENT n. ");
      write_num(outline,NUMEV, field => 2, base => decimal);
      case tdc_id is
        when 0 => writeline(LOG0, outline);
        when 1 => writeline(LOG1, outline);
        when 2 => writeline(LOG2, outline);
        when 3 => writeline(LOG3, outline);
        when others => null;
      end case;
      NUMEV <= NUMEV + 1;


--      if tdc_id = 3 then
------------------------------------------------------------------------
      if chain = 0 or chain = 1 then

----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------		
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
		
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------		
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
		
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------		
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
		
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------		
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
                 conv_std_logic_vector(2,3) & "000000000000000000000"; --0X00000A
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(2,3) & "000000000000000000001"; --0X0001B0
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;
----------------------------------------------------------------------
		if MEM_FULL = '1' then
		  wait until MEM_FULL = '0';
		end if;
		DIN  <= "0100" & conv_std_logic_vector(tdc_id,4) &  -- leading
			   conv_std_logic_vector(6,3) & "000000000000000000010";
		nch <= nch + 1;
		WR  <= '1';
		wait for Twr;
	    WR  <= '0';
		wait for Twr;
----------------------------------------------------------------------
        if MEM_FULL = '1' then
          wait until MEM_FULL = '0';
        end if;
        DIN  <= "0101" & conv_std_logic_vector(tdc_id,4) &  -- trailing
                 conv_std_logic_vector(6,3) & "000000000000000000001"; 
        nch <= nch + 1;
        WR  <= '1';
        wait for Twr;
        WR  <= '0';
        wait for Twr;		
		  
      end if;
----------------------------------------------------------------------

  end process;


  -- ******************************************************************
  -- READOUT di un evento nella FIFO
  -- (handshake Data_ready/Get_data)
  -- ******************************************************************
  --             _   _   _   _   _   _   _   _   _   _   _   _   _
  --CLK        _| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |
  --             ___
  --TOK ROC    _|   |______________________________________________
  --                     ___ ___
  --DATA_RDY A _________|   |   |__________________________________
  --                             ___
  --TOK A      _________________|   |______________________________
  --                                     _______________
  --DATA_RDY B _________________________|   |   |   |   |__________
  --                                                     ___
  --TOK B      _________________________________________|   |______
  --                         ___             ___     ___
  --GET_DATA   _____________|   |___________|   |___|   |__________
  --           ____________________________________________________
  --DATA       _________|__DA0__|_______|__DB0__|__DB1__|__________
  --
  --*******************************************************************
  process
  variable num: integer;
    begin

      RD <= '0';
      TOKEN_OUT <= '0';
      DATA_RDY <= 'Z';
      DOUT <= (others => 'Z'); -- Parallel data in alta impedenza

      wait until(CLK'event and CLK = '1');

      wait until (TOKEN_IN'event and TOKEN_IN = '1');

      wait until(CLK'event and CLK = '1');

      if nword = 0 then        -- la FIFO è vuota
        wait until (CLK'event and CLK='1');
        wait for Td;
        TOKEN_OUT <= '1';
        wait until (CLK'event and CLK='1');
        wait for Td;
        TOKEN_OUT <= '0';

      else                     -- la FIFO ha dati

        -- Trigger matching abilitato: trasferisce un evento e passa la palla
        wait for Td;
        DOUT <= (others => 'U'); -- esco dal tristate
        wait until (CLK'event and CLK='1');
        wait for Td;
        DATA_RDY <= '1';
        DOUT <= mem (rp);        -- esce il primo dato
        RD <= '1';
        wait for Trd;
        RD <= '0';

        wait until (CLK'event and CLK='1' and GET_DATA = '1');
        wait for Td;

--        num := nch-1;
        if chain = 0 then
          num := 128; --7; -- DAV 15Oct2021 (128) to test large events on TRMs
        else
          num := 128; --7; -- DAV 15Oct2021 (128) to test large events on TRMs
        end if;

--      if tdc_id /= 3 then

        for i in 1 to num loop
          DOUT <= mem (rp);
          RD <= '1';
          wait for Trd;
          RD <= '0';
          wait until (CLK'event and CLK='1' and GET_DATA = '1');
          wait for Td;
        end loop;

--      else
--        DOUT <= mem (rp);
--        RD <= '1';
--        wait for Trd;
--        RD <= '0';
--        wait until (CLK'event and CLK='1' and GET_DATA = '1');
--        wait for Td;
--      end if;

        DATA_RDY <= 'Z';
        DOUT <= (others => 'U'); -- torno in tristate
        wait until (CLK'event and CLK='1');
        wait for Td;
        DOUT <= (others => 'Z'); -- torno in alta impedenza

 --       wait for 7 us; -- simulazione del timout del token

        TOKEN_OUT <= '1';
        wait until (CLK'event and CLK='1');
        wait for Td;
        TOKEN_OUT <= '0';
      end if;

  end process;

END BEHAV;

