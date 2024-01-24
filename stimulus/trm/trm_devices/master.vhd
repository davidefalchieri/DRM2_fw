-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- ----------------------------------------------------------------------------
-- Module:          MASTER
-- Description:     VME Master (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
USE work.io_utils.ALL;
USE work.V1390pkg.all;


ENTITY MASTER IS
   PORT(
      CLK_in   : IN    std_logic;  -- la DRM è sincrona con la TRM

      ADDR     : INOUT  std_logic_vector (31 DOWNTO 0);
      AMOD     : OUT    std_logic_vector (5 DOWNTO 0);
      DATA     : INOUT  std_logic_vector (31 DOWNTO 0);
      GEO      : BUFFER std_logic_vector (4 DOWNTO 0);
      BA       : BUFFER std_logic_vector (3 DOWNTO 0);
      DS0      : BUFFER std_logic;
      DS1      : BUFFER std_logic;
      AS       : OUT    std_logic;
      DTACK    : IN     std_logic;
      BERR_IN  : IN     std_logic;
      IACKOUT  : IN     std_logic;
      LWORD    : INOUT  std_logic;
      VWRITE   : OUT    std_logic;
      IACK     : OUT    std_logic;
      IACKIN   : OUT    std_logic;
      BERR_OUT : OUT    std_logic;
      SYSRES   : OUT    std_logic;
      -- Segnala la fine della simulazione
      Finished : BUFFER std_logic

      );

END MASTER ;

ARCHITECTURE BEHAV OF MASTER IS

  subtype WORD16  is std_logic_vector(15 downto 0);
  subtype LWORD32 is std_logic_vector(31 downto 0);

  type     DSTRING is array (0 to 3) of string (1 to 3);
  constant D8          : std_logic_vector(1 downto 0) := "00";
  constant D16         : std_logic_vector(1 downto 0) := "01";
  constant D32         : std_logic_vector(1 downto 0) := "10";
  constant D64         : std_logic_vector(1 downto 0) := "11";


  signal  NUMOP        : integer := 0;
  signal  RESULT       : std_logic;

  type amset  is (A16, A24, A32, A40, A64, ACR_CSR);

  file LOG : TEXT is OUT "vme.log";


  signal  CLK           : std_logic;
  signal  TIMEOUT       : std_logic;
  signal  TIMECNT       : std_logic_vector(4 downto 0);

  constant PERIOD  : time := 25 ns;

  SIGNAL ena     : std_logic;

  -- ************************************************************************
  -- DEFINIZIONE DEI PARAMETRI
  -- ************************************************************************
  -- ritardi dei segnali di controllo
  constant   Tas     : time := 20 ns;  -- indirizzi pronti -> as down
  constant   Tds     : time := 5 ns;   -- as down -> ds down
  constant   Tend    : time := 40 ns;  -- dtack down -> as,ds up
  constant   Thiz    : time := 50 ns;  -- as,ds up -> addr,data HiZ
  constant   Tblt    : time := 35 ns;  -- spazio fra due cicli di BLT
  constant   Tres    : time := 25 ns;  -- durata impulso di reset
  constant   Tiackin : time := 99 ns; -- inizio ciclo MCST/CBLT -> IACKIN down

  -- tipi di ciclo
  constant   READCYC   : std_logic := '1';
  constant   WRITECYC  : std_logic := '0';

  constant   FIRST_BOARD     : integer   := 0;
  constant   LAST_BOARD      : integer   := 1;
  constant   ACTIVE_BOARD    : integer   := 2;
  constant   INACTIVE_BOARD  : integer   := 2;


  function my_conv_integer (datain: in std_logic_vector) return integer is
    variable forced : std_logic_vector(datain'high downto datain'low);
    begin
      for I in datain'range loop
        if datain(I)='X' or datain(I)='Z' or datain(I)='U' then
          forced(I) := '0';
        else
          forced(I) := datain(I);
        end if;
      end loop;
      return(conv_integer(forced));
    end;

  begin

    BERR_OUT <= BERR_IN;

    -- TIME OUT
    process begin
      wait for 1 ns;
      while Finished = '0' loop
        CLK <= '0';
        wait for PERIOD/2;
        CLK <= '1';
        wait for PERIOD/2;
      end loop;

      wait;
    end process;

    process(DS0,DS1,CLK)
    begin
      if DS0='1' and DS1='1' then
        TIMEOUT <= '0';
        TIMECNT <= (others => '0');
      elsif CLK'event and CLK = '1' then
        TIMECNT <= TIMECNT+1;
        if TIMECNT = "11111" then
          TIMEOUT <= '1';
        end if;
      end if;
    end process;


    process

    -- ****************************************************************
    -- Scittura nel file di LOG
    -- ****************************************************************
    variable DTYPE : DSTRING := ("D08","D16","D32","D64");

    procedure write_numop is
      variable outline : line;
      begin
        write_string(outline, "-> Oper n. ");
        write_num(outline,NUMOP, field => 2, base => decimal);
        writeline(LOG, outline);
        NUMOP <= NUMOP + 1;
      end;


    -- ****************************************************************
    -- INIZIALIZZAZIONE E RESET
    -- ****************************************************************
    procedure vme_init is
    variable MSG : LINE;
      begin
        VWRITE   <= '1';
        LWORD    <= '0';
        DS0      <= '1';
        DS1      <= '1';
        AS       <= '1';
        IACK     <= '1';
        IACKIN   <= '1';
        GEO      <= "00101";  -- SCHEDA con JAUX
        BA       <= "1110";   -- tamburino
        ADDR     <= (others => 'Z');
        DATA     <= (others => 'Z');

        SYSRES <= '0';
        wait for Tres;
        SYSRES <= '1';
      end;


    -- ****************************************************************
    -- CICLO DI LETTURA
    -- ****************************************************************
    procedure vme_read(addr_vme:  in  integer;
                       amod_vme:  in  amset;
                       dtsize  :  in  std_logic_vector(1 downto 0);
                       rdata   :  out integer) is

      variable dt      : integer;
      variable outline : line;
      variable AMODi   : std_logic_vector (5 DOWNTO 0);

      begin

        -- preparo AD, LWORD, WRITE e AM
        ADDR   <= conv_std_logic_vector(addr_vme,32);
        if    amod_vme=A32 then AMOD <= A32_U_DATA; AMODi := A32_U_DATA;
        elsif amod_vme=A24 then AMOD <= A24_U_DATA; AMODi := A24_U_DATA;
        elsif amod_vme=ACR_CSR then AMOD <= CR_CSR; AMODi := CR_CSR;
        end if;

        case dtsize is
          when D32    => LWORD  <= '0';
          when D16    => LWORD  <= '1';
          when others => null;
        end case;
        VWRITE <= READCYC;

        IACK   <= '1';
        IACKIN <= '1';

        -- scrivo l'operazione nel LOG file
        wait for 1 ns;
        write_numop;
        write_string(outline, "  VME READ  ");
        write_string(outline, DTYPE(conv_integer(dtsize)));
        write_string(outline, " at address 0x");
        write_num(outline, to_Bitvector(ADDR), field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, to_Bitvector(AMODi),field => 2, base => hex);

        wait for Tas;
        AS  <= '0';
        wait for Tds;
        DS0 <= '0';
        DS1 <= '0';
        wait until ((DTACK'event and DTACK='0') or (BERR_IN'event and BERR_IN='0') or (TIMEOUT'event and TIMEOUT='1'));
        rdata := my_conv_integer(DATA(30 downto 0));                      -- prendo il dato
        dt := my_conv_integer(DATA(30 downto 0));

        write_string(outline, "   Data=0x");
        write_num(outline, to_Bitvector(DATA), field => 8, base => hex);  -- scrivo il dato nel LOG file

        wait for Tend;
        AS  <= '1';
        DS0 <= '1';
        DS1 <= '1';
        wait for Thiz;

        ADDR <= (others => 'Z');
        AMOD <= (others => 'Z');

        writeline(LOG, outline);

      end;


    -- ****************************************************************
    -- CICLO DI SCRITTURA
    -- ****************************************************************
    procedure vme_write(addr_vme:  in  integer;
                        amod_vme:  in  amset;
                        dtsize  :  in  std_logic_vector(1 downto 0);
                        data_vme:  in  integer ) is

      variable outline : line;
      variable AMODi   : std_logic_vector (5 DOWNTO 0);

      begin


        -- preparo AD, LWORD, WRITE, AM e dato da scrivere
        ADDR   <= conv_std_logic_vector(addr_vme,32);
        if    amod_vme=A32 then AMOD <= A32_U_DATA; AMODi := A32_U_DATA;
        elsif amod_vme=A24 then AMOD <= A24_U_DATA; AMODi := A24_U_DATA;
        end if;
        case dtsize is
          when D32    => LWORD  <= '0';
          when D16    => LWORD  <= '1';
          when others => null;
        end case;
        VWRITE <= WRITECYC;

        DATA   <= conv_std_logic_vector(data_vme,32);
        IACK   <= '1';
        IACKIN <= '1';

        -- scrivo l'operazione nel LOG file
        wait for 1 ns;
        write_numop;
        write_string(outline, "  VME WRITE  ");
        write_string(outline, DTYPE(conv_integer(dtsize)));
        write_string(outline, " at address 0x");
        write_num(outline, to_Bitvector(ADDR), field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, to_Bitvector(AMODi),field => 2, base => hex);
        write_string(outline, "   Data=0x");
        write_num(outline, to_Bitvector(DATA), field => 8, base => hex);

        wait for Tas;
        AS  <= '0';
        wait for Tds;
        DS0 <= '0';
        DS1 <= '0';
        wait until ((DTACK'event and DTACK='0') or (BERR_IN'event and BERR_IN='0'));

        wait for Tend;
        AS   <= '1';
        DS0  <= '1';
        DS1  <= '1';
        wait for Thiz;

        DATA <= (others => 'Z');
        ADDR <= (others => 'Z');
        AMOD <= (others => 'Z');

        writeline(LOG, outline);

      end;


    -- ****************************************************************
    -- CICLO DI BLOCK TRANSFER D32 (lettura)
    -- ****************************************************************
    procedure vme_blt_read(addr_vme:  in  integer;
                           amod_vme:  in  amset;
                           dtsize  :  in  std_logic_vector(1 downto 0);
                           bytes   :  in  integer ) is


      variable outline : line;
      variable AMODi   : std_logic_vector (5 DOWNTO 0);
      variable cycles  : integer;
      variable dt      : integer;
      variable I       : integer;
      variable CONT    : boolean := TRUE;

      begin

        cycles := bytes/4;
        -- preparo AD, LWORD, WRITE e AM
        ADDR   <= conv_std_logic_vector(addr_vme,32);
        if    amod_vme=A32 then AMOD <= A32_U_BLT; AMODi := A32_U_BLT;
        elsif amod_vme=A24 then AMOD <= A24_U_BLT; AMODi := A24_U_BLT;
        end if;
        VWRITE <= READCYC;

        LWORD  <= '0';
        IACK   <= '1';
        IACKIN <= '1';

        -- scrivo l'operazione nel LOG file
        wait for 1 ns;
        write_numop;
        write_string(outline, "  VME BLT READ ");
        write_string(outline, DTYPE(conv_integer(dtsize)));
        write_string(outline, " at address 0x");
        write_num(outline, to_Bitvector(ADDR), field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, to_Bitvector(AMODi), field => 2, base => hex);
        write_string(outline, "    Size(bytes)=");
        write_num(outline, bytes, base => decimal);
        writeline(LOG, outline);

        write_string(outline, "  Data: ");
        writeline(LOG, outline);

        I := 0;
        while CONT loop
          if I = 0 then
            wait for Tas;
            AS  <= '0';
          end if;

          wait for Tds;
          DS0 <= '0';
          DS1 <= '0';

          wait until ((DTACK'event and DTACK='0') or (BERR_IN'event and BERR_IN='0'));

          I := I + 1;

          if BERR_IN = '0' or I = cycles then
            CONT := FALSE;
          end if;

          dt := my_conv_integer(DATA(30 downto 0));                                     -- prendo il dato

          if BERR_IN /= '0' then
            write_num(outline, i-1, field => 3, base => hex); write_string(outline, "  ");  -- scrivo il dato nel LOG file
            write_num(outline, to_Bitvector(DATA), field => 8, base => hex);
            writeline(LOG, outline);
		  end if;
          wait for Tend;

          DS0 <= '1';
          DS1 <= '1';

          if I = 0 then
            wait for Thiz;
            ADDR <= (others => 'Z');
            AMOD <= (others => 'Z');
          end if;
          wait for Tblt;

        end loop;

        AS  <= '1';

      end;

    -- ****************************************************************
    -- CICLO DI BLOCK TRANSFER D64 (lettura)
    -- ****************************************************************
    procedure vme_mblt_read(addr_vme:  in  integer;
                            amod_vme:  in  amset;
                            dtsize  :  in  std_logic_vector(1 downto 0);
                            bytes   :  in  integer) is


      variable outline   : line;
      variable AMODi     : std_logic_vector (5 DOWNTO 0);
      variable cycles    : integer;
      variable datah     : std_logic_vector(31 downto 0);
      variable dth,dtl   : integer;
      variable I         : integer;
      variable CONT      : boolean := TRUE;

      begin

        cycles := bytes/8;
        -- preparo AD, LWORD, WRITE e AM
        ADDR   <= conv_std_logic_vector(addr_vme,32);
        if    amod_vme=A32 then AMOD <= A32_U_MBLT; AMODi := A32_U_MBLT;
        elsif amod_vme=A24 then AMOD <= A24_U_MBLT; AMODi := A24_U_MBLT;
        end if;
        VWRITE <= READCYC;

        LWORD  <= '0';
        IACK   <= '1';
        IACKIN <= '1';

        -- scrivo l'operazione nel LOG file
        wait for 1 ns;
        write_numop;
        write_string(outline, "  VME BLT READ ");
        write_string(outline, DTYPE(conv_integer(dtsize)));
        write_string(outline, " at address 0x");
        write_num(outline, to_Bitvector(ADDR), field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, to_Bitvector(AMODi), field => 2, base => hex);
        write_string(outline, "    Size(bytes)=");
        write_num(outline, bytes, base => decimal);
        writeline(LOG, outline);

        write_string(outline, "  Data: ");
        writeline(LOG, outline);

        -- esegue il primo ciclo (ciclo indirizzi)
        wait for Tas;
        AS  <= '0';
        wait for Tds;
        DS0 <= '0';
        DS1 <= '0';


        wait until ((DTACK'event and DTACK='0') or (BERR_IN'event and BERR_IN='0'));
        wait for Tend;
        DS0  <= '1';
        DS1  <= '1';
        wait for Thiz;
        ADDR <= (others => 'Z');
        AMOD <= (others => 'Z');
        LWORD <= 'Z';

        I := 0;
        while CONT loop
          wait for Tds;
          DS0 <= '0';
          DS1 <= '0';

          wait until ((DTACK'event and DTACK='0') or (BERR_IN'event and BERR_IN='0'));

          I := I + 1;

          if BERR_IN = '0' or I = cycles then
            CONT := FALSE;
          end if;

          dth := my_conv_integer(DATA(30 downto 0));
          datah(31 downto 1) := ADDR(31 downto 1);
          datah(0) := LWORD;
          dtl := my_conv_integer(datah);                                                -- prendo i dati

		  if BERR_IN /= '0' then
            write_num(outline, (i-1)*2, field => 3, base => hex); write_string(outline, "  ");  -- li scrivo nel LOG file
            write_num(outline, to_Bitvector(ADDR(31 downto 1) & LWORD), field => 8, base => hex);
            writeline(LOG, outline);

            write_num(outline, (i-1)*2+1, field => 3, base => hex); write_string(outline, "  ");
            write_num(outline, to_Bitvector(DATA), field => 8, base => hex);
            writeline(LOG, outline);
          end if;
			
          wait for Tend;
          DS0 <= '1';
          DS1 <= '1';
          wait for Tblt;

        end loop;

        AS  <= '1';

      end;

	  
    -- ****************************************************************
    -- CICLO 2eSST ALICE STYLE D64 (lettura)
    -- ****************************************************************
    procedure vme_2esst_read(addr_vme:  in  integer;
                             amod_vme:  in  amset;
                             dtsize  :  in  std_logic_vector(1 downto 0);
                             bytes   :  in  integer) is


      variable outline   : line;
      variable AMODi     : std_logic_vector (5 DOWNTO 0);
      variable cycles    : integer;
      variable datah     : std_logic_vector(31 downto 0);
      variable dth,dtl   : integer;
      variable I         : integer;
      variable CONT      : boolean := TRUE;

      begin
        -- NB: QUESTO ACCESSO E' SINCRONO COL CLOCK DELLA TRM, IN QUANTO ESEGUITO SOLO DALLA DRM E CON STESSO CLOCK DELLA TRM
        cycles := bytes/8;

        -- preparo AD, LWORD, WRITE e AM
        wait until (CLK_in'event and CLK_in='1');
        ADDR   <= conv_std_logic_vector(addr_vme,32);
        AMOD   <= A32_2eSST; AMODi := A32_2eSST;
        VWRITE <= READCYC;

        LWORD  <= '0';
        IACK   <= '1';
        IACKIN <= '1';

        -- scrivo l'operazione nel LOG file
        wait for 1 ns;
        write_numop;
        write_string(outline, "  VME 2eSST READ ");
        write_string(outline, DTYPE(conv_integer(dtsize)));
        write_string(outline, " at address 0x");
        write_num(outline, to_Bitvector(ADDR), field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, to_Bitvector(AMODi), field => 2, base => hex);
        write_string(outline, "    Size(bytes)=");
        write_num(outline, bytes, base => decimal);
        writeline(LOG, outline);

        write_string(outline, "  Data: ");
        writeline(LOG, outline);

        wait until (CLK_in'event and CLK_in='1');
        -- metto gli indirizzi sul BUS e tiro giù AS e DS
        AS  <= '0';
        DS0 <= '0';
        DS1 <= '0';
		-- aspetto 3 cicli di clock e rilascio il bus
        wait until (CLK_in'event and CLK_in='1');
        wait until (CLK_in'event and CLK_in='1');
        wait until (CLK_in'event and CLK_in='1');
        wait until (CLK_in'event and CLK_in='1');
        wait until (CLK_in'event and CLK_in='1');

        ADDR  <= (others => 'Z');
        LWORD <= 'Z';
        AMOD <= (others => 'Z');

		
        I := 0;
        while CONT loop
 
          wait until (rising_edge(DTACK) or falling_edge(DTACK) or falling_edge(BERR_IN));
--    write(outline,NOW);
--    writeline(LOG, outline);

		  wait for 1 ns;
          I := I + 1;

          if BERR_IN = '0' then-- or I = cycles then
            CONT := FALSE;
          end if;

          dth := my_conv_integer(DATA(30 downto 0));
          datah(31 downto 1) := ADDR(31 downto 1);
          datah(0) := LWORD;
          dtl := my_conv_integer(datah);                                                -- prendo i dati

          write_num(outline, (i-1)*2, field => 3, base => hex); write_string(outline, "  ");  -- li scrivo nel LOG file
          write_num(outline, to_Bitvector(ADDR(31 downto 1) & LWORD), field => 8, base => hex);
          writeline(LOG, outline);

          write_num(outline, (i-1)*2+1, field => 3, base => hex); write_string(outline, "  ");
          write_num(outline, to_Bitvector(DATA), field => 8, base => hex);
          writeline(LOG, outline);
		 
       end loop;
	   
       DS0 <= '1';
       DS1 <= '1';
       AS  <= '1';

      end;
	  
	  
	  
-- da qui in poi devo implementare la scrittura nel log file

    -- ****************************************************************
    -- CICLO DI SCRITTURA in MCST
    -- ****************************************************************
    procedure vme_mcst_write(addr_vme:  in  integer;
                             amod_vme:  in  amset;
                             dtsize  :  in  std_logic_vector(1 downto 0);
                             data_vme:  in  integer;
                             position:  in  integer ) is

      variable outline : line;
      variable AMODi   : std_logic_vector (5 DOWNTO 0);
      begin

        ADDR   <= conv_std_logic_vector(addr_vme,32);
        if    amod_vme=A32 then AMOD <= A32_U_DATA; AMODi := A32_U_DATA;
        elsif amod_vme=A24 then AMOD <= A24_U_DATA; AMODi := A24_U_DATA;
        end if;
        case dtsize is
          when D32    => LWORD  <= '0';
          when D16    => LWORD  <= '1';
          when others => null;
        end case;
        VWRITE <= WRITECYC;

        DATA   <= conv_std_logic_vector(data_vme,32);
        IACK   <= '1';
        IACKIN <= '1';

        wait for Tas;
        AS  <= '0';
        wait for Tds;
        DS0 <= '0';
        DS1 <= '0';
        if(position /= FIRST_BOARD) then
          wait for Tiackin;
          IACKIN <= '0';
        end if;
        if(position = LAST_BOARD) then
          wait until ((DTACK'event and DTACK='0') or (BERR_IN'event and BERR_IN='0'));
        else
          wait until (IACKOUT'event and IACKOUT='0');
        end if;

        wait for Tend;
        AS     <= '1';
        DS0    <= '1';
        DS1    <= '1';
        IACKIN <= '1';
        wait for Thiz;
        DATA <= (others => 'Z');
        ADDR <= (others => 'Z');
        AMOD <= (others => 'Z');

--        write(MSG,S_DATA);
--        write(MSG,data_vme);
--        writeline(LOG,MSG);

      end;



    -- ****************************************************************
    -- CICLO DI CHAINED BLOCK TRANSFER D32 (lettura)
    -- ****************************************************************
    procedure vme_cblt_read(addr_vme:  in  integer;
                            amod_vme:  in  amset;
                            dtsize  :  in  std_logic_vector(1 downto 0);
                            cycles:    in  integer;
                            position:  in  integer ) is


      variable outline : line;
      variable AMODi   : std_logic_vector (5 DOWNTO 0);
      variable dt   : integer;
      variable I    : integer;
      variable CONT : boolean := TRUE;

      begin

        ADDR   <= conv_std_logic_vector(addr_vme,32);
        if    amod_vme=A32 then AMOD <= A32_U_BLT; AMODi := A32_U_BLT;
        elsif amod_vme=A24 then AMOD <= A24_U_BLT; AMODi := A24_U_BLT;
        end if;

        LWORD  <= '0';
        IACK   <= '1';
        IACKIN <= '1';
        VWRITE <= READCYC;

        I := 0;
        while CONT loop
          if I = 0 then
            wait for Tas;
            AS  <= '0';
          end if;
          wait for Tds;
          DS0 <= '0';
          DS1 <= '0';

          if((position /= FIRST_BOARD) and (I=0)) then
            wait for Tiackin;
            IACKIN <= '0';
          end if;


          if position /= LAST_BOARD then
            wait until (DTACK'event and DTACK='0') or
                       (BERR_IN'event and BERR_IN='0') or
                       (IACKOUT='0');
          else
            wait until (DTACK'event and DTACK='0') or
                       (BERR_IN'event and BERR_IN='0');

          end if;

          I := I + 1;
          if (position /= LAST_BOARD and IACKOUT = '0') or BERR_IN = '0' or I = cycles then
            CONT := FALSE;
          end if;

          dt := my_conv_integer(DATA(30 downto 0));
          wait for Tend;
          DS0 <= '1';
          DS1 <= '1';
          if I = 0 then
            wait for Thiz;
            ADDR <= (others => 'Z');
            AMOD <= (others => 'Z');
          end if;
          wait for Tblt;

          if CONT then
--            write(MSG,I);
--            write(MSG,S_DATA);
--            write(MSG,dt);
--            writeline(LOG,MSG);
          end if;

        end loop;

        AS  <= '1';

      end;

    -- ****************************************************************
    -- CICLO DI CHAINED BLOCK TRANSFER D64 (lettura)
    -- ****************************************************************
    procedure vme_mcblt_read(addr_vme:  in  integer;
                             amod_vme:  in  amset;
                             dtsize  :  in  std_logic_vector(1 downto 0);
                             cycles:    in  integer;
                             position:  in  integer ) is


      variable outline : line;
      variable AMODi   : std_logic_vector (5 DOWNTO 0);
      variable datah     : std_logic_vector(31 downto 0);
      variable dth,dtl   : integer;
      variable I         : integer;
      variable CONT      : boolean := TRUE;

      begin

        ADDR   <= conv_std_logic_vector(addr_vme,32);
        if    amod_vme=A32 then AMOD <= A32_U_MBLT; AMODi := A32_U_MBLT;
        elsif amod_vme=A24 then AMOD <= A24_U_MBLT; AMODi := A24_U_MBLT;
        end if;
        VWRITE <= READCYC;

        LWORD  <= '0';
        IACK   <= '1';
        IACKIN <= '1';

        -- esegue il primo ciclo (ciclo indirizzi)
        wait for Tas;
        AS  <= '0';
        wait for Tds;
        DS0 <= '0';
        DS1 <= '0';

        if(position = LAST_BOARD) then
          wait until ((DTACK'event and DTACK='0') or (BERR_IN'event and BERR_IN='0'));
        else
          wait for 200 ns;
        end if;

        wait for Tend;
        DS0  <= '1';
        DS1  <= '1';
        wait for Thiz;
        ADDR <= (others => 'Z');
        AMOD <= (others => 'Z');
        LWORD <= 'Z';

        I := 0;
        while CONT loop
          wait for Tds;
          DS0 <= '0';
          DS1 <= '0';

          if((position /= FIRST_BOARD) and (I=0)) then
            wait for Tiackin;
            IACKIN <= '0';
          end if;


          if position /= LAST_BOARD then
            wait until (DTACK'event and DTACK='0') or
                       (BERR_IN'event and BERR_IN='0') or
                       (IACKOUT='0');
          else
            wait until (DTACK'event and DTACK='0') or
                       (BERR_IN'event and BERR_IN='0');

          end if;

          I := I + 1;
          if (position /= LAST_BOARD and IACKOUT = '0') or BERR_IN = '0' or I = cycles then
            CONT := FALSE;
          end if;

          dth := my_conv_integer(DATA(30 downto 0));
          datah(31 downto 1) := ADDR(31 downto 1);
          datah(0) := LWORD;
          dtl := my_conv_integer(datah);

          wait for Tend;
          DS0 <= '1';
          DS1 <= '1';
          wait for Tblt;

          if CONT then
--            write(MSG,I*2);
--            write(MSG,S_DATA);
--            write(MSG,dtl);
--            writeline(LOG,MSG);
--            write(MSG,I*2+1);
--            write(MSG,S_DATA);
--            write(MSG,dth);
--            writeline(LOG,MSG);
          end if;

        end loop;

        AS  <= '1';

      end;


    -- ****************************************************************
    -- CICLO DI INTERRUPT ACKNOWLEDGE
    -- ****************************************************************
    procedure vme_int_ack(lev:       in  integer;
                          status_id: out integer ) is

      variable outline : line;
      variable dt  : integer;


      begin

        ADDR(3 downto 1)   <= conv_std_logic_vector(lev,3);
        ADDR(31 downto 4)  <= (others => 'X');
        VWRITE <= READCYC;
        LWORD  <= '1';
        IACK   <= '0';
        IACKIN <= '0';

        wait for Tas;
        AS  <= '0';
        wait for Tds;
        DS0 <= '0';
        DS1 <= '0';
        wait until ((DTACK'event and DTACK='0') or (BERR_IN'event and BERR_IN='0'));
        status_id := my_conv_integer(DATA(7 downto 0));
        dt := my_conv_integer(DATA(7 downto 0));
        wait for Tend;
        AS     <= '1';
        DS0    <= '1';
        DS1    <= '1';
        IACK   <= '1';
        IACKIN <= '1';
        wait for Thiz;
        ADDR <= (others => 'Z');
        AMOD <= (others => 'Z');

--        write(MSG,S_DATA);
--        write(MSG,dt);
--        writeline(LOG,MSG);

      end;


    -- ****************************************************************
    -- STIMOLI
    -- ****************************************************************
    variable rdata,num_ev,word_to_read: integer;
    variable i : integer;
    variable STATUS,CONTROL,PROGHS,I2CSTAT: std_logic_vector(15 downto 0);
    variable BUF : std_logic_vector(31 downto 0);
    variable data : integer;
    variable BASE_ADD : integer := 16#A0000000#;
    variable BASE_ADD1: integer := 16#10000000#;
    variable GEO_ADD  : integer := 16#00280000#;

    variable MCST_BASE_ADD : integer := 16#F0000000#;

    begin

      Finished <= '0';

      vme_init;
      wait for 1 us;
      vme_read(BASE_ADD+A_FIRM_REV,A32,D16,rdata);

      STATUS := (others => '1');
      while STATUS(9) = '1' loop
        vme_read(BASE_ADD+A_STATUS,A32,D16,rdata);
        STATUS := conv_std_logic_vector(rdata,16);
      end loop;

      wait for 40 us;  -- dovrebbe essere un wait micro ready

      -------------------------------------------------
      -- Setting per l'acquisizione
      vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
      wait for 40 ns;
      vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
      wait for 40 ns;
      vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
      wait for 40 ns;


      --vme_write(BASE_ADD+A_SW_TRIGGER,A32,D16,16#0000#); 
	  
	  
     for i in 0 to 100 loop		-- DAV (was commented)
        -------------------------------------------------
        -- Aspetto il data ready
        STATUS := (others => '0');
        while STATUS(0) = '0' loop
          vme_read(BASE_ADD+A_STATUS,A32,D16,rdata);
          wait for 40 ns;
          STATUS := conv_std_logic_vector(rdata,16);
        end loop;

        wait for 100 ns;

--        vme_mblt_read(BASE_ADD+A_OUTBUF,A32,D64,2048);
        vme_2esst_read(BASE_ADD+A_OUTBUF,A32,D64,128);
     end loop;					-- DAV (was commented)


--      -------------------------------------------------
--      -- Aspetto che vada Full
--      STATUS := (others => '0');
--      while STATUS(1) = '0' loop
--        vme_read(BASE_ADD+A_STATUS,A32,D16,rdata);
--        wait for 40 ns;
--        STATUS := conv_std_logic_vector(rdata,16);
--      end loop;
--
--      wait for 10 us;
--
--
--
--      -------------------------------------------------
--      -- READOUT della FIFO
--      -- rileggo finchè non va empty
--      STATUS := (others => '1');
--      while STATUS(0) = '1' loop
--        vme_mblt_read(BASE_ADD+A_OUTBUF,A32,D64,1024);
--        wait for 40 ns;
--        vme_read(BASE_ADD+A_STATUS,A32,D16,rdata);
--        STATUS := conv_std_logic_vector(rdata,16);
--      end loop;



      wait for 10 us;
      Finished <= '1';
      wait;
    end process;


END BEHAV;

