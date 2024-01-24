-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           Scheda test sotto radiazione a PSI
-- FPGA Proj. Name: PSIstratix
-- Device:          Altera STRATIX EP1S20FC780-7
-- Author:          Annalisa Mati
-- Date:            17/05/04
-- ----------------------------------------------------------------------------
-- Module:          FLASH
-- Description:     Flash memory (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY FLASH IS
   PORT(
      NCS    : IN     std_logic;   -- chip select
      SCK    : IN     std_logic;   -- Serial clock -> 20MHz max
      si     : IN     std_logic;   -- Serial Input
      so     : OUT    std_logic;   -- Serial Output
      RDY    : OUT    std_logic    -- Ready/Busy
   );


END FLASH ;

ARCHITECTURE BEHAV OF FLASH IS

  constant CONTINUOUS_ARRAY_RD_I: std_logic_vector (7  downto 0):= "01101000";  -- 0X68
  constant CONTINUOUS_ARRAY_RD_S: std_logic_vector (7  downto 0):= "11101000";  -- 0XE8
  constant MEM_PAGE_RD_I        : std_logic_vector (7  downto 0):= "01010010";  -- 0x52
  constant MEM_PAGE_RD_S        : std_logic_vector (7  downto 0):= "11010010";  -- 0xD2
  constant BUFFER1_RD_I         : std_logic_vector (7  downto 0):= "00000000";
  constant BUFFER1_RD_S         : std_logic_vector (7  downto 0):= "00000000";
  constant BUFFER2_RD_I         : std_logic_vector (7  downto 0):= "00000000";
  constant BUFFER2_RD_S         : std_logic_vector (7  downto 0):= "00000000";
  constant STATUS_RD_I          : std_logic_vector (7  downto 0):= "00000000";
  constant STATUS_RD_S          : std_logic_vector (7  downto 0):= "00000000";
  constant MEMPROG_throughBUF1  : std_logic_vector (7  downto 0):= "00000000";
  constant MEMPROG_throughBUF2  : std_logic_vector (7  downto 0):= "00000000";


--------------------------------------------------------------------
-- Definizione della memoria (2 pagine di 264 byte)
  constant PAGES : integer := 64;  -- IN REALTA' 2048 pagine   = 11 bit di indirizzo PA[10:0]
  constant DEPTH : integer := 264; -- dimensioni di una pagina =  9 bit di indirizzo BA[8:0]

  type page is array (0 to DEPTH-1) of std_logic_vector (7 downto 0);

  type memory is array (0 to PAGES-1) of page;  -- MEMORIA

  signal mem   : memory;
  signal rpp   : integer;          -- puntatore di pagina (read)
  signal rbp   : integer;          -- puntatore di byte nella pagina (read)
  signal wpp   : integer;          -- puntatore di pagina (write)
  signal wbp   : integer;          -- puntatore di byte nella pagina (write)

  signal BUFFER1, BUFFER2 : page;  -- SRAM data buffers        =  9 bit di indirizzo BA[8:0]


--------------------------------------------------------------------
  signal OPC      : std_logic_vector (7  downto 0);  -- Opcode
  signal PA       : std_logic_vector (10 downto 0);  -- Indirizzo di pagina (2048 pagine)
  signal BA       : std_logic_vector (8  downto 0);  -- Indirizzo di un byte in una pagina (264 byte x pagina)
  signal DATA     : std_logic_vector (7  downto 0);  -- Dato letto o scritto

  signal EXECO    : std_logic;                       -- Comanda l'esecuzione dell'opcode
  signal READMEM  : std_logic;                       -- Comanda una lettura
  signal WRITEMEM : std_logic;                       -- Comanda una scrittura
  signal INCR     : std_logic;                       -- Comanda l'incremento dell'indirizzo

BEGIN


  --****************************************************************--
  -- TRASMISSIONE DELL'OPCODE
  process
  begin
    EXECO <= '0';
    wait until NCS = '0';                             -- attende l'inizio della trasmissione
    for I in 0 to OPC'length-1 loop
      wait until (SCK'event and SCK='1');
      OPC   <= OPC(OPC'high-1 downto OPC'low) & SI;   -- legge l'opcode
    end loop;
    EXECO <= '1';                                     -- comanda l'esecuzione dell'opcode

    wait until NCS = '1';                             -- attende la fine della trasmissione
  end process;


  --****************************************************************--
  -- DECODIFICA DELL'OPCODE
  process
  begin

    READMEM  <= '0';
    WRITEMEM <= '0';

    wait until EXECO = '1';                            -- attende che sia stato letto l'opcode

    --------------------------------------------------------------------
    -- Continuous Array Read o Main Memory page read
    if (OPC = CONTINUOUS_ARRAY_RD_I or OPC = CONTINUOUS_ARRAY_RD_S or
        OPC = MEM_PAGE_RD_I         or OPC = MEM_PAGE_RD_S)        then

      for I in 0 to 3 loop                            -- 4 bit reserved
        wait until (SCK'event and SCK='1');
      end loop;

      for I in 0 to PA'length-1 loop
        wait until (SCK'event and SCK='1');
        PA   <= PA(PA'high-1 downto PA'low) & SI;     -- legge l'indirizzo di pagina
      end loop;

      for I in 0 to BA'length-1 loop
        wait until (SCK'event and SCK='1');
        BA   <= BA(BA'high-1 downto BA'low) & SI;     -- legge l'indirizzo del byte nella pagina
      end loop;

      for I in 0 to 31 loop                           -- 32 bit don't care
        wait until (SCK'event and SCK='1');
      end loop;

      READMEM <= '1';                                 -- comanda la lettura

    --------------------------------------------------------------------
    -- Buffer read
    elsif (OPC = BUFFER1_RD_I or OPC = BUFFER1_RD_S  or
           OPC = BUFFER2_RD_I or OPC = BUFFER2_RD_S) then

      for I in 0 to 3 loop                            -- 4 bit reserved
        wait until (SCK'event and SCK='1');
      end loop;

      for I in 0 to PA'length-1 loop                  -- 11 bit reserved
        wait until (SCK'event and SCK='1');
      end loop;

      for I in 0 to BA'length-1 loop
        wait until (SCK'event and SCK='1');
        BA   <= BA(BA'high-1 downto BA'low) & SI;     -- legge l'indirizzo del byte nel buffer
      end loop;

      for I in 0 to 7 loop                            -- 8 bit don't care
        wait until (SCK'event and SCK='1');
      end loop;

      READMEM <= '1';                                 -- comanda la lettura

    --------------------------------------------------------------------
    -- Status register read
    elsif (OPC = STATUS_RD_I or OPC = STATUS_RD_S) then

      READMEM <= '1';                                 -- comanda la lettura

    --------------------------------------------------------------------
    --------------------------------------------------------------------
    -- Main Memory Program through Buffer 1 o 2
    elsif (OPC = MEMPROG_throughBUF1 or OPC = MEMPROG_throughBUF2) then

      for I in 0 to 3 loop                            -- 4 bit reserved
        wait until (SCK'event and SCK='1');
      end loop;

      for I in 0 to PA'length-1 loop
        wait until (SCK'event and SCK='1');
        PA   <= PA(PA'high-1 downto PA'low) & SI;     -- legge l'indirizzo di pagina
      end loop;

      for I in 0 to BA'length-1 loop
        wait until (SCK'event and SCK='1');
        BA   <= BA(BA'high-1 downto BA'low) & SI;     -- legge l'indirizzo del byte nella pagina
      end loop;

      WRITEMEM <= '1';                                -- comanda la scrittura


    end if;

    wait until NCS = '1';                             -- attende la fine della trasmissione
  end process;


  --****************************************************************--
  -- LETTURA
  process

    --------------------------------------------------------------------
    -- procedura per incrementare l'indirizzo della memoria principale
    -- o dei buffer
    procedure inc_addr is
      begin
       -- incrementa il puntatore di byte
      if rbp < DEPTH-1 then
        rbp <= rbp + 1;
      else
        rbp <= 0;
        -- incrementa il puntatore di pagina solo in continuous array read
        if (OPC = CONTINUOUS_ARRAY_RD_I or OPC = CONTINUOUS_ARRAY_RD_S ) and rpp < PAGES-1 then
          rpp <= rpp + 1;
        else
          rpp <= 0;
        end if;
      end if;
      wait for 1 ns; -- attendo che sia assegnato l'indirizzo :(
    end;
    --------------------------------------------------------------------

  begin


    wait until READMEM = '1';                       -- attende il comando di lettura

    rpp <= conv_integer(PA);
    rbp <= conv_integer(BA);
    wait for 1 ns;   -- attendo che sia assegnato l'indirizzo :(

    --------------------------------------------------------------------
    -- Continuous Array Read o Main Memory page read
    if (OPC = CONTINUOUS_ARRAY_RD_I or OPC = CONTINUOUS_ARRAY_RD_S or
        OPC = MEM_PAGE_RD_I         or OPC = MEM_PAGE_RD_S)        then

      -- trasferimento dati fino a che NCS non torna a 1
      while NCS = '0' loop

        DATA <= mem(rpp)(rbp);
        for I in 0 to DATA'length-1 loop
          -- trasmette il dato: fronte in discesa di SCK; termina se NCS va a 1 (fine della trasmissione)
          wait until (SCK'event and SCK='0') or (NCS'event and NCS = '1');
          if NCS = '0' then
            SO   <= DATA(DATA'high);
            DATA <= DATA(DATA'high-1 downto DATA'low) & '0';
          end if;
        exit when NCS = '1';
        end loop;

        if NCS = '0' then
          inc_addr;
        end if;
      end loop;

    --------------------------------------------------------------------
    -- Buffer read
    elsif (OPC = BUFFER1_RD_I or OPC = BUFFER1_RD_S  or
           OPC = BUFFER2_RD_I or OPC = BUFFER2_RD_S) then

      -- trasferimento dati fino a che NCS non torna a 1
      while NCS = '0' loop

        if (OPC = BUFFER1_RD_I or OPC = BUFFER1_RD_S) then
          DATA <= BUFFER1(rbp);
        else
          DATA <= BUFFER2(rbp);
        end if;
        for I in 0 to DATA'length-1 loop
          -- trasmette il dato: fronte in discesa di SCK; termina se NCS va a 1 (fine della trasmissione)
          wait until (SCK'event and SCK='0') or (NCS'event and NCS = '1');
          if NCS = '0' then
            SO   <= DATA(DATA'high);
            DATA <= DATA(DATA'high-1 downto DATA'low) & '0';
          end if;
        exit when NCS = '1';
        end loop;

        if NCS = '0' then
          inc_addr;
        end if;
      end loop;

    end if;

  end process;


--****************************************************************--
  -- SCRITTURA : non implementata

  process
  begin


--    for J in 0 to 63 loop  -- scrivo 64 pagine (2 chip)
--      for I in 0 to 263 loop
--        mem(J)(I)   <= conv_std_logic_vector(J,8);
--
--
--        BUFFER1(I)<= "11110000";
--        BUFFER2(I)<= "00001111";
--      end loop;
--    end loop;

    for J in 0 to 63 loop  -- scrivo 64 pagine (2 chip)
      mem(J)(0)    <= "00000001";
      mem(J)(1)    <= "11000001";
      mem(J)(2)    <= "01000001";
      mem(J)(3)    <= "01000001";
      mem(J)(4)    <= "01000001";
      mem(J)(5)    <= "01000001";
      mem(J)(6)    <= "01000001";
      mem(J)(7)    <= "01000001";
      mem(J)(8)    <= "01000001";
      mem(J)(9)    <= "01000001";
      mem(J)(10)   <= "01000001";
      mem(J)(11)   <= "01000001";
      mem(J)(12)   <= "01000001";
      mem(J)(13)   <= "01000001";
      mem(J)(14)   <= "01000001";
      mem(J)(15)   <= "01000001";
      mem(J)(16)   <= "01000001";
      mem(J)(17)   <= "01000001";
      mem(J)(18)   <= "01000001";
      mem(J)(19)   <= "01000001";
      mem(J)(20)   <= "01000001";
      mem(J)(21)   <= "01000001";
      mem(J)(22)   <= "01000001";
      mem(J)(23)   <= "01000001";
      mem(J)(24)   <= "01000001";
      mem(J)(25)   <= "01000001";
      mem(J)(26)   <= "01000001";
      mem(J)(27)   <= "01000001";
      mem(J)(28)   <= "01000001";
      mem(J)(29)   <= "01000001";
      mem(J)(30)   <= "01000001";
      mem(J)(31)   <= "01000001";
      mem(J)(32)   <= "01000001";
      mem(J)(33)   <= "01000001";
      mem(J)(34)   <= "01000001";
      mem(J)(35)   <= "01000001";
      mem(J)(36)   <= "01000001";
      mem(J)(37)   <= "01000001";
      mem(J)(38)   <= "01000001";
      mem(J)(39)   <= "01000001";
      mem(J)(40)   <= "01000001";
      mem(J)(41)   <= "01000001";
      mem(J)(42)   <= "01000001";
      mem(J)(43)   <= "01000001";
      mem(J)(44)   <= "01000001";
      mem(J)(45)   <= "01000001";
      mem(J)(46)   <= "01000001";
      mem(J)(47)   <= "01000001";
      mem(J)(48)   <= "01000001";
      mem(J)(49)   <= "01000001";
      mem(J)(50)   <= "01000001";
      mem(J)(51)   <= "01000001";
      mem(J)(52)   <= "01000001";
      mem(J)(53)   <= "01000001";
      mem(J)(54)   <= "01000001";
      mem(J)(55)   <= "01000001";
      mem(J)(56)   <= "01000001";
      mem(J)(57)   <= "01000001";
      mem(J)(58)   <= "01000001";
      mem(J)(59)   <= "01000001";
      mem(J)(50)   <= "01000001";
      mem(J)(51)   <= "01000001";
      mem(J)(52)   <= "01000001";
      mem(J)(53)   <= "01000001";
      mem(J)(54)   <= "01000001";
      mem(J)(55)   <= "01000001";
      mem(J)(56)   <= "01000001";
      mem(J)(57)   <= "01000001";
      mem(J)(58)   <= "01000001";
      mem(J)(59)   <= "01000001";
      for I in 60 to 255 loop
        mem(J)(I)   <= "00000000";
      end loop;

    end loop;

    mem(0)(256)  <= "10101010";  -- OFFSET
    mem(32)(256) <= "01010101";

    wait until WRITEMEM = '1';  -- attende il comando di scrittura

    wpp <= conv_integer(PA);
    wbp <= conv_integer(BA);
    wait for 1 ns;   -- attendo che sia assegnato l'indirizzo :(

    --------------------------------------------------------------------
    -- Main Memory Program through Buffer 1 o 2
    if (OPC = MEMPROG_throughBUF1 or OPC = MEMPROG_throughBUF2) then

    end if;

  end process;


--  FLASH SEMPLIFICATA

--  signal DATA     : std_logic_vector (7 downto 0):="10101010";  -- Dato letto o scritto


--BEGIN


--  process
--  begin

--    wait until NCS = '0';

--    SO   <= DATA(DATA'high);

--    for I in 0 to DATA'length-1 loop

--      wait until (SCK'event and SCK='1');
--      DATA <= DATA(DATA'high-1 downto DATA'low) & SI;

--      wait until (SCK'event and SCK='0');
--      SO   <= DATA(DATA'high);

--    end loop;

--    wait until NCS = '1' or NCS = 'H';

--  end process;



END BEHAV;








