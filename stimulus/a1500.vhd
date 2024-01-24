
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use std.textio.all;
USE work.io_utils.ALL;
use work.caenlinkpkg.all;
use work.DRM2pkg.all;

entity A1500 is
   port(
      PXL_D     : inout  STD_LOGIC_VECTOR (15 downto 0);  -- Data
      PXL_A     : out    STD_LOGIC_VECTOR (7 downto 0);   -- Address
      PXL_WR    : out    STD_LOGIC;                       -- Write
      PXL_RD    : out    STD_LOGIC;                       -- Read
      PXL_CS    : out    STD_LOGIC;                       -- Chip Select
      PXL_IRQ   : in     STD_LOGIC;                       -- Interrupt Request
      PXL_RESET : in     STD_LOGIC;                       -- Reset
      RMT_RESET : out    STD_LOGIC;                       -- Reset generato da A1500
      PXL_IO    : inout  STD_LOGIC_VECTOR (7 downto 0)    -- Spare I/Os
   );

end A1500 ;


architecture BEHAV of A1500 is

  subtype WORD16  is std_logic_vector(15 downto 0);
  subtype LWORD32 is std_logic_vector(31 downto 0);

  type packet_type   is array (0 to 1023) of WORD16;


  constant STAT_DTACK : integer := 4;
  constant STAT_BERR  : integer := 5;


  -- messaggi
  type DSTRING is array (0 to 3) of string (1 to 3);

  file LLOG : TEXT open WRITE_MODE is "a1500.log";
  file VLOG : TEXT open WRITE_MODE is "a1500_vme.log";
  --file INFILE : TEXT open READ_MODE is "sim_cmd.txt";


  signal packet       : packet_type;


  -- ****************************************************************************************


  begin

  process

  variable DTYPE   : DSTRING := ("D08","D16","D32","D64");
  variable nwr     : integer;
  variable rdata   : integer;
  variable rpacket : packet_type;

  variable data         : integer;
  variable addr         : integer;
  variable slot         : integer;
  variable nw           : integer;
  variable random_seed  : integer;
  variable s_id         : string (1 downto 1);
  variable stim         : string (1 downto 1);
  variable stim_subtype : string (1 downto 1);
  variable dw           : string (2 downto 1);
  variable inline       : LINE;
  variable time_ns      : integer := 0;
  variable tmp          : integer;
  variable run_stim     : std_logic := '1';
  variable random_mode  : std_logic := '0';



  -- **************************************************************************
  -- Funzioni per emulare gli accessi da PCI attraverso il PLX
  -- **************************************************************************

    procedure a1500_init is
    begin
      PXL_D  <= (others => 'Z');
      PXL_A  <= (others => 'X');
      PXL_RD <= '1';
      PXL_WR <= '1';
      PXL_CS <= '1';
      PXL_IO(7 downto 1) <= (others => 'Z');
      PXL_IO(0) <= '0'; -- A0 nella versione con accessi a byte
      wait for 200 ns;
    end;

    -- Scrittura di una word
    procedure a1500_write (A : in integer;
                           D : in integer ) is
    begin

      PXL_A  <= conv_std_logic_vector(A, 8);

      -- Byte alto
      PXL_IO(0) <= '1';
      PXL_CS <= '0';
      wait for 10 ns;
      PXL_D(7 downto 0)  <= conv_std_logic_vector(D, 16)(15 downto 8);
      PXL_WR <= '0';
      wait for 50 ns;  -- ipotizzando 3 wait states sulla A1500
      PXL_WR <= '1';
      wait for 7 ns;
      PXL_D  <= (others => 'Z');
      wait for 8 ns;
      PXL_CS <= '1';
      wait for 100 ns;

      -- Byte basso
      PXL_IO(0) <= '0';
      PXL_CS <= '0';
      wait for 10 ns;
      PXL_D(7 downto 0)  <= conv_std_logic_vector(D, 16)(7 downto 0);
      PXL_WR <= '0';
      wait for 50 ns;  -- ipotizzando 3 wait states sulla A1500
      PXL_WR <= '1';
      wait for 7 ns;
      PXL_D  <= (others => 'Z');
      wait for 8 ns;
      PXL_CS <= '1';
      PXL_A  <= (others => 'X');
      wait for 100 ns;

    end;

    -- Lettura di una word
    procedure a1500_read  (A : in integer;
                           D : out integer ) is
    variable TEMP : integer;
    begin

      PXL_A  <= conv_std_logic_vector(A, 8);

      -- Byte alto
      PXL_IO(0) <= '1';
      PXL_CS <= '0';
      wait for 10 ns;
      PXL_RD <= '0';
      wait for 52 ns;  -- ipotizzando 3 wait states sulla A1500
      TEMP := conv_integer(PXL_D(7 downto 0)) * 256;
      PXL_RD <= '1';
      wait for 8 ns;
      PXL_CS <= '1';
      wait for 100 ns;

      -- Byte basso
      PXL_IO(0) <= '0';
      PXL_CS <= '0';
      wait for 10 ns;
      PXL_RD <= '0';
      wait for 52 ns;  -- ipotizzando 3 wait states sulla A1500
      D := TEMP + conv_integer(PXL_D(7 downto 0));
      PXL_RD <= '1';
      wait for 8 ns;
      PXL_CS <= '1';
      wait for 100 ns;
      PXL_A  <= (others => 'X');

    end;


-- @@@@@@@@@@@  VERSIONE CON ACCESSO IN D16 DA A1500 @@@@@@@@@@@@@@@@@@@@@@@@
--    -- Scrittura di una word
--    procedure a1500_write (A : in integer;
--                           D : in integer ) is
--    begin
--
--      PXL_A  <= conv_std_logic_vector(A, 8);
--      PXL_CS <= '0';
--      wait for 10 ns;
--      PXL_D  <= conv_std_logic_vector(D, 16);
--      PXL_WR <= '0';
--      wait for 50 ns;  -- ipotizzando 3 wait states sulla A1500
--      PXL_WR <= '1';
--      wait for 7 ns;
--      PXL_D  <= (others => 'Z');
--      wait for 8 ns;
--      PXL_CS <= '1';
--      PXL_A  <= (others => 'X');
--      wait for 33 ns;
--
--    end;
--
--    -- Lettura di una word
--    procedure a1500_read  (A : in integer;
--                           D : out integer ) is
--    begin
--
--      PXL_A  <= conv_std_logic_vector(A, 8);
--      PXL_CS <= '0';
--      wait for 10 ns;
--      PXL_RD <= '0';
--      wait for 52 ns;  -- ipotizzando 3 wait states sulla A1500
--      D := conv_integer(PXL_D);
--      PXL_RD <= '1';
--      wait for 8 ns;
--      PXL_CS <= '1';
--      wait for 33 ns;
--
--    end;
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


  -- *********************************************************************
  -- SEND PACKET
  -- *********************************************************************
  procedure send_packet(data  :  in  packet_type;
                        nword :  in  integer) is
  variable i   : integer;
  variable outline : LINE;

  begin
    write_string(outline,"Sending Packet of ");
    write_num(outline,nword, field => 2, base => decimal);
    write_string(outline," words");
    writeline(LLOG, outline);

    a1500_write(2, nword);

    for i in 0 to nword - 1 loop
      write_num(outline, i, field => 4, base => decimal);
      write_string(outline,"  ");
      write_num(outline, to_Bitvector(data(i)), field => 4, base => hex);
      writeline(LLOG, outline);
      a1500_write(0, conv_integer(data(i)));
    end loop;

  end;


  -- *********************************************************************
  -- READ PACKET
  -- *********************************************************************
  procedure read_packet(data   : inout  packet_type;
                        nword  : inout  integer ) is
  variable i, j     : integer;
  variable nw, d    : integer;
  variable timeout  : integer;
  variable endrx    : std_logic;
  variable d16      : WORD16;
  variable outline  : LINE;

  begin
    timeout := 0;
    j := 0;
    endrx := '0';

    write_string(outline,"Reading Packet");
    writeline(LLOG, outline);

    while endrx = '0' and timeout < 500 loop

      -- legge il numero di word pronte per la lettura
      nw := 0;
      timeout := 0;
      while  nw = 0 and timeout < 500 loop
        a1500_read(2, nw);
        d16 := conv_std_logic_vector(nw, 16);
        nw := conv_integer(d16(14 downto 0));
        endrx := d16(15);
        timeout := timeout + 1;
      end loop;
wait for 100 ns;
      if timeout < 100 then
        for i in 0 to nw - 1 loop
          a1500_read(0, d);
          data(j) := conv_std_logic_vector(d, 16);
          write_num(outline, j, field => 4, base => decimal);
          write_string(outline,"  ");
          write_num(outline, to_Bitvector(data(j)), field => 4, base => hex);
          writeline(LLOG, outline);
          j := j + 1;
        end loop;
      end if;

    end loop;

    if timeout = 500 then
      write_string(outline,"Timeout in Read Packet ");
      writeline(LLOG, outline);
      nword := 0;
    else
      nword := j;
      write_string(outline,"  N lwords = ");
      write_num(outline, nword, base => decimal);
      writeline(LLOG, outline);
    end if;

  end;




  -- **************************************************************************
  -- Funzioni di I/O VME
  -- **************************************************************************

    -- ########################################################################
    -- VME READ
    -- ########################################################################
    procedure vme_read (SLOT    : in    integer;
                        ADDRESS : in    integer;
                        DSIZE   : in    std_logic_vector(1 downto 0);
                        DATA    : inout integer  ) is

    variable stat : WORD16;
    variable ADDR, DT : LWORD32;
    variable outline : line;

    begin

      ADDR := conv_std_logic_vector(SLOT,4) & "000000000000" & conv_std_logic_vector(ADDRESS,16);

      packet(0) <= "11" & A32_U_DATA & "10" & DSIZE & SINGLERW;
      packet(1) <= ADDR(15 downto 0);
      packet(2) <= ADDR(31 downto 16);

      send_packet(packet, 3);
      read_packet(rpacket, nwr);

      if DSIZE = D32 then
        DT(15 downto 0)  := rpacket(0);
        DT(31 downto 16) := rpacket(1);
        stat := rpacket(2);
      else
        DT(15 downto 0)  := rpacket(0);
        DT(31 downto 16) := (others => '0');
        stat := rpacket(1);
      end if;
      DATA := conv_integer(DT);
      wait for 10 ns;

      write_string(outline, "VME READ  ");
      write_string(outline, DTYPE(conv_integer(DSIZE)));
      write_string(outline, " : Slot ");
      write_num(outline, SLOT, field => 2, base => decimal);
      write_string(outline, " - Address 0x");
      write_num(outline, to_Bitvector(ADDR(15 downto 0)), field => 4, base => hex);

      write_string(outline, " - status 0x");
      write_num(outline, to_Bitvector(stat(15 downto 0)), field => 4, base => hex);
      
      if stat(STAT_DTACK) = '1' then
        write_string(outline, " =>  Data = 0x");
        if DSIZE = D32 then
          write_num(outline, to_Bitvector(DT), field => 8, base => hex);
        else
          write_num(outline, to_Bitvector(DT(15 downto 0)), field => 4, base => hex);
        end if;
      else
        write_string(outline, " =>  Bus Error!");
      end if;

      writeline(VLOG, outline);

    end;

    -- ########################################################################
    -- VME WRITE
    -- ########################################################################
    procedure vme_write(SLOT    : in  integer;
                        ADDRESS : in  integer;
                        DSIZE   : in  std_logic_vector(1 downto 0);
                        DATA    : in  integer  ) is

    variable stat : WORD16;
    variable ADDR : LWORD32;
    variable DT   : LWORD32;
    variable outline : line;

    begin

      ADDR := conv_std_logic_vector(SLOT,4) & "000000000000" & conv_std_logic_vector(ADDRESS,16);
      DT   := conv_std_logic_vector(DATA,32);

      packet(0) <= "10" & A32_U_DATA & "10" & DSIZE & SINGLERW;
      packet(1) <= ADDR(15 downto 0);
      packet(2) <= ADDR(31 downto 16);
      if DSIZE = D32 then
        packet(3) <= DT(15 downto 0);
        packet(4) <= DT(31 downto 16);
        send_packet(packet, 5);
      else
        packet(3) <= DT(15 downto 0);
        send_packet(packet, 4);
      end if;

      read_packet(rpacket, nwr);
      stat := rpacket(0);

      write_string(outline, "VME WRITE ");
      write_string(outline, DTYPE(conv_integer(DSIZE)));
      write_string(outline, " : Slot ");
      write_num(outline, SLOT, field => 2, base => decimal);
      write_string(outline, " - Address 0x");
      write_num(outline, to_Bitvector(ADDR(15 downto 0)), field => 4, base => hex);

      if stat(STAT_DTACK) = '1' then
        write_string(outline, " =>  Data = 0x");
        if DSIZE = D32 then
          write_num(outline, to_Bitvector(DT), field => 8, base => hex);
        else
          write_num(outline, to_Bitvector(DT(15 downto 0)), field => 4, base => hex);
        end if;
      else
        write_string(outline, " =>  Bus Error!");
      end if;

      writeline(VLOG, outline);

    end;



    -- ########################################################################
    -- VME BLT READ
    -- ########################################################################
    procedure vme_read_blt(SLOT      : in  integer;
                           ADDRESS   : in  integer;
                           DSIZE     : in  std_logic_vector(1 downto 0);
                           NBYTE     : in  integer
                           ) is

    variable stat  : WORD16;
    variable ADDR  : LWORD32;
    variable i,nlw : integer;
    variable NCYC  : integer;
    variable outline : line;
    variable AM : std_logic_vector(5 downto 0) := (others => '0');

    begin
      if DSIZE = D64 then NCYC := NBYTE/8;
      elsif DSIZE = D32 then NCYC := NBYTE/4;
      else NCYC := NBYTE/2;
      end if;

      ADDR := conv_std_logic_vector(SLOT,4) & "000000000000" & conv_std_logic_vector(ADDRESS,16);

      if DSIZE=D64 then
        AM := A32_U_MBLT;
      else
        AM := A32_U_BLT;
      end if;

      packet(0) <= "11" & AM & "10" & DSIZE & BLT;
      packet(1) <= conv_std_logic_vector(NCYC,16);      -- scrive il size
      packet(2) <= ADDR(15 downto 0);                   -- scrive l'address
      packet(3) <= ADDR(31 downto 16);

      send_packet(packet, 4);
      --wait for 50 us;
      read_packet(rpacket, nlw);

      write_string(outline, "VME BLT READ ");
      write_string(outline, DTYPE(conv_integer(DSIZE)));
      write_string(outline, " : Slot ");
      write_num(outline, SLOT, field => 2, base => decimal);
      write_string(outline, " - Address 0x");
      write_num(outline, to_Bitvector(ADDR(15 downto 0)), field => 4, base => hex);
      write_string(outline, "   Size(bytes)=");
      write_num(outline, NBYTE, base => decimal);
      writeline(VLOG, outline);

      write_string(outline, "  Data: ");
      writeline(VLOG, outline);

    end;



    -- ########################################################################
    -- READ REG
    -- ########################################################################

    procedure read_reg(ADDRESS   : in  integer;
                       DATA      : inout integer) is

    variable outline : line;

    begin
      packet(0) <= "010000001" & conv_std_logic_vector(ADDRESS,7);

      send_packet(packet, 1);
      read_packet(rpacket, nwr);

      DATA := conv_integer(rpacket(0));

      wait for 10 ns;
      write_string(outline, "REG READ  - Address 0x");
      write_num(outline, conv_std_logic_vector(ADDRESS,8), field => 2, base => hex);
      write_string(outline, " =>  Data = 0x");
      write_num(outline, rpacket(0), field => 4, base => hex);
      writeline(VLOG, outline);
      wait for 200 ns;
    end;


    -- ########################################################################
    -- WRITE REG
    -- ########################################################################
    procedure write_reg(ADDRESS   : in  integer;
                        DATA      : in  integer) is
    variable outline : line;
    begin
      packet(0) <= "000000001" & conv_std_logic_vector(ADDRESS,7);
      packet(1) <= conv_std_logic_vector(DATA,16);

      send_packet(packet, 2);

      wait for 10 ns;
      write_string(outline, "REG WRITE - Address 0x");
      write_num(outline, conv_std_logic_vector(ADDRESS,8), field => 2, base => hex);
      write_string(outline, " =>  Data = 0x");
      write_num(outline, packet(1), field => 4, base => hex);
      writeline(VLOG, outline);

      wait for 200 ns;
    end;



    -- ########################################################################
    -- RANDOM
    -- ########################################################################
    -- funzione che ritorna un real random fra 0.0 e 1.0
    procedure random(seed       : inout  integer;
                     ran        : out    real )    is
    constant M : integer := 259200;
    constant A : integer := 7141;
    constant C : integer := 54773;
    begin
      seed := (seed * A + C) mod M;
      ran  := real(seed) / real(M);
    end;

    -- funzione che aspetta un tempo T random fra 0 e Tmax (in ns)
    procedure wait_random(seed       : inout integer;
                          tmax       : in    integer ) is
    variable tt : integer;
    variable tr : real;
    variable outline : line;
    begin
      random(seed, tr);
      tt := integer(tr * real(tmax));
      wait for tt * 1 ns;
    end;



  -- **************************************************************************
  -- Stimoli
  -- **************************************************************************
  begin


    a1500_init;
    
      
    wait for 600 us;
      
    --Vme_Read(0, 16#0000#, D32, data);
    
    wait for 5000 ns;
    


    wait;

  end process;

end BEHAV;


