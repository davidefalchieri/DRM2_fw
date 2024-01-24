-- ****************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Author:          Carlo Tintori
-- Date:            04/08/2005
-- ----------------------------------------------------------------------------
-- Description:     VME Master able to emulate the following VME cycles:
--                  - vme_read
--                  - vme_write
--                  - vme_blt_read
--                  - vme_blt_write
--                  - vme_int_ack
--
--
-- Note: bus arbitration is not implemented!
-- ****************************************************************************


library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use STD.textio.all;
use work.io_utils.all;

entity VME_MASTER is
   port(
      A       : inout  std_logic_vector (31 downto 1);
      AM      : buffer std_logic_vector (5 downto 0);
      D       : inout  std_logic_vector (31 downto 0);
      DS0     : out    std_logic;
      DS1     : out    std_logic;
      AS      : out    std_logic;
      DTACK   : in     std_logic;
      BERR    : inout  std_logic;
      LWORD   : inout  std_logic;
      WRITE   : out    std_logic;
      IACK    : out    std_logic;
      IACKIN  : in     std_logic;
      IACKOUT : out    std_logic;
      SYSRES  : out    std_logic;
      BR      : inout  std_logic_vector (3 downto 0);
      BGI     : in     std_logic;
      BGO     : out    std_logic;
      BBSY    : inout  std_logic;
      BCLR    : inout  std_logic
   );

end VME_MASTER;


architecture BEHAV of VME_MASTER is

  -- LOG file
  file VLOG : TEXT is OUT "vme_master.log";

  -- Cycle Parameters
  constant A16 : integer := 0;
  constant A24 : integer := 1;
  constant A32 : integer := 2;
  constant D8  : integer := 0;
  constant D16 : integer := 1;
  constant D32 : integer := 2;
  constant D64 : integer := 3;

  type DSTRING is array (0 to 3) of string (1 to 3);
  constant DTYPE : DSTRING := ("D08","D16","D32","D64");


  -- Address Modifier
  constant A24_U_DATA  : integer := 16#39#;
  constant A24_U_PROG  : integer := 16#3A#;
  constant A24_S_DATA  : integer := 16#3D#;
  constant A24_S_PROG  : integer := 16#3E#;

  constant A32_U_DATA  : integer := 16#09#;
  constant A32_U_PROG  : integer := 16#0A#;
  constant A32_S_DATA  : integer := 16#0D#;
  constant A32_S_PROG  : integer := 16#0E#;

  constant A24_U_BLT   : integer := 16#3B#;
  constant A24_S_BLT   : integer := 16#3F#;
  constant A32_U_BLT   : integer := 16#0B#;
  constant A32_S_BLT   : integer := 16#0F#;

  constant A24_U_MBLT  : integer := 16#38#;
  constant A24_S_MBLT  : integer := 16#3C#;
  constant A32_U_MBLT  : integer := 16#08#;
  constant A32_S_MBLT  : integer := 16#0C#;

  constant CR_CSR      : integer := 16#2F#;

  -- Data Buffer for BLT cycles
  type blt_data_array is array (0 to 256) of integer;  -- dati letti/scritti in BLT
  signal blt_data : blt_data_array;

  -- Timing Parameters
  constant   Tas     : time := 20 ns;  -- indirizzi pronti -> as down
  constant   Tds     : time := 1 ns;   -- as down -> ds down
  constant   Tend    : time := 10 ns;  -- dtack down -> as,ds up
  constant   Thiz    : time := 2 ns;   -- as,ds up -> addr,data HiZ
  constant   Tblt    : time := 40 ns;  -- spazio fra due cicli di BLT
  constant   Tres    : time := 50 ns;  -- durata SYSRES iniziale

  -- Funzione per forzare i bit a 0 o 1
  function to_01 (din: in std_logic_vector) return std_logic_vector is
    variable forced : std_logic_vector(din'range);
    begin
      for I in din'range loop
        if din(I)='1' or din(I)='H' then
          forced(I) := '1';
        else
          forced(I) := '0';
        end if;
      end loop;
      return(forced);
    end;


  begin process

    -- ****************************************************************
    -- Initialization and Reset
    -- ****************************************************************
    procedure vme_init is
      variable outline : LINE;
      begin
        WRITE    <= 'Z';
        LWORD    <= 'Z';
        DS0      <= 'Z';
        DS1      <= 'Z';
        AS       <= 'Z';
        BERR     <= 'Z';
        IACK     <= 'Z';
        A        <= (others => 'Z');
        AM       <= (others => 'Z');
        D        <= (others => 'Z');
        BR       <= (others => 'Z');
        BCLR     <= 'Z';
        BBSY     <= 'Z';
        BGO      <= '1';
        IACKOUT  <= '1';

        SYSRES   <= '0';
        wait for Tres;
        SYSRES   <= 'Z';
        write_string(outline, "Power-up SYSRES asserted");
        writeline(VLOG, outline);

      end;


    -- ****************************************************************
    -- Single Read Cycle
    -- ****************************************************************
    procedure vme_read(addr:      in  integer;
                       amode:     in  integer;
                       dsize:     in  integer;
                       rdata:     out integer) is
      variable outline : LINE;
      variable rd : integer;
      variable ack : boolean;

      begin
        A  <= conv_std_logic_vector(addr/2,31);
        WRITE  <= '1';
        if amode=A32 then AM <= conv_std_logic_vector(A32_U_DATA,6);
        elsif amode=A24 then AM <= conv_std_logic_vector(A24_U_DATA,6);
        end if;
        if dsize=conv_integer(D32) then LWORD  <= '0';
        else LWORD <= '1';
        end if;

        wait for Tas;
        AS  <= '0';
        wait for Tds;
        if (dsize/=D8 or (addr mod 1)=1) then  DS0 <= '0'; end if;
        if (dsize/=D8 or (addr mod 1)=0) then  DS1 <= '0'; end if;

        wait until ((DTACK'event and DTACK='0') or (BERR'event and BERR='0'));

        rd := conv_integer(to_01(D(31 downto 0)));
        rdata := rd;
        if DTACK = '0' then ack := true; else ack := false; end if;
        wait for Tend;
        AS  <= 'Z';
        DS0 <= 'Z';
        DS1 <= 'Z';
        wait for Thiz;
        A  <= (others => 'Z');
        AM <= (others => 'Z');
        WRITE  <= 'Z';
        LWORD  <= 'Z';

        write_string(outline, "VME READ   ");
        write_string(outline, DTYPE(conv_integer(DSIZE)));
        write_string(outline, " at address 0x");
        write_num(outline, addr, field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, amode, field => 2, base => hex);
        if ack then
          write_string(outline, "   Data=0x");
          write_num(outline, rd, field => 8, base => hex);
        else
          write_string(outline, "   Bus Error !!!");
        end if;
        writeline(VLOG, outline);

      end;


    -- ****************************************************************
    -- Single Write Cycle
    -- ****************************************************************
    procedure vme_write(addr    :  in  integer;
                        amode   :  in  integer;
                        dsize   :  in  integer;
                        wdata   :  in  integer ) is

      variable outline : LINE;
      variable ack : boolean;

      begin

        A  <= conv_std_logic_vector(addr/2,31);
        D  <= conv_std_logic_vector(wdata,32);
        WRITE  <= '0';
        if amode=A32 then AM <= conv_std_logic_vector(A32_U_DATA,6);
        elsif amode=A24 then AM <= conv_std_logic_vector(A24_U_DATA,6);
        end if;
        if dsize=D32 then LWORD  <= '0';
        else LWORD <= '1';
        end if;

        wait for Tas;
        AS  <= '0';
        wait for Tds;
        if (dsize/=D8 or (addr mod 1)=1) then  DS0 <= '0'; end if;
        if (dsize/=D8 or (addr mod 1)=0) then  DS1 <= '0'; end if;

        wait until ((DTACK'event and DTACK='0') or (BERR'event and BERR='0'));

        if DTACK = '0' then ack := true; else ack := false; end if;
        wait for Tend;
        AS   <= 'Z';
        DS0  <= 'Z';
        DS1  <= 'Z';
        wait for Thiz;
        D <= (others => 'Z');
        A <= (others => 'Z');
        AM <= (others => 'Z');
        WRITE <= 'Z';
        LWORD <= 'Z';

        write_string(outline, "VME WRITE  ");
        write_string(outline, DTYPE(conv_integer(DSIZE)));
        write_string(outline, " at address 0x");
        write_num(outline, addr, field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, to_Bitvector(AM), field => 2, base => hex);
        if ack then
          write_string(outline, "   Data=0x");
          write_num(outline, wdata, field => 8, base => hex);
        else
          write_string(outline, "   Bus Error !!!");
        end if;
        writeline(VLOG, outline);

      end;


    -- ****************************************************************
    -- Block Transfer Read Cycle
    -- ****************************************************************
    procedure vme_blt_read(addr:      in  integer;
                           amode:     in  integer;
                           dsize:     in  integer;
                           nbyte:     in  integer ) is


      variable outline  : LINE;
      variable i        : integer;
      variable addack   : std_logic;
      variable ncyc     : integer;
      variable break    : boolean := false;

      begin
        A  <= conv_std_logic_vector(addr/2,31);
        WRITE  <= '1';
        if dsize=D64 then
          if amode=A32 then AM <= conv_std_logic_vector(A32_U_MBLT,6); 
          elsif amode=A24 then AM <= conv_std_logic_vector(A24_U_MBLT,6);
          end if;
        else
          if amode=A32 then AM <= conv_std_logic_vector(A32_U_BLT,6); 
          elsif amode=A24 then AM <= conv_std_logic_vector(A24_U_BLT,6);
          end if;
        end if;
        if dsize = conv_integer(D64) then
          LWORD  <= '0';
          ncyc   := nbyte/8;
          addack := '1';
        elsif dsize = conv_integer(D32) then
          LWORD  <= '0';
          ncyc   := nbyte/4;
          addack := '0';
        elsif dsize = conv_integer(D16) then
          LWORD  <= '1';
          ncyc   := nbyte/2;
          addack := '1';
        else
          LWORD  <= '1';
          ncyc   := nbyte;
          addack := '1';
        end if;

        write_string(outline, "VME BLT READ ");
        write_string(outline, DTYPE(conv_integer(dsize)));
        write_string(outline, " at address 0x");
        write_num(outline, addr, field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, to_Bitvector(AM), field => 2, base => hex);
        write_string(outline, "    Size(bytes)=");
        write_num(outline, nbyte, base => decimal);
        writeline(VLOG, outline);

        i := 0;
        wait for Tas;
        AS  <= '0';
        wait for Tds;

        while not break loop
          DS0 <= '0';
          DS1 <= '0';
  
          wait until ((DTACK'event and DTACK='0') or (BERR'event and BERR='0'));

          if BERR = '0' or i = ncyc-1 then
            break := true;
          end if;

          if addack='0' and DTACK='0' then
            if dsize = conv_integer(D64) then
              blt_data(i*2+1) <= conv_integer(to_01(D(31 downto 0)));
              blt_data(i*2) <= conv_integer(to_01(A(31 downto 1) & LWORD));
              wait for 1 ns;
              write_num(outline, i*2, field => 3, base => hex); write_string(outline, "  ");
              write_num(outline, blt_data(i*2), field => 8, base => hex);
              writeline(VLOG, outline);
              write_num(outline, i*2+1, field => 3, base => hex); write_string(outline, "  ");
              write_num(outline, blt_data(i*2+1), field => 8, base => hex);
              writeline(VLOG, outline);
            else
              blt_data(i) <= conv_integer(to_01(D(31 downto 0)));
              wait for 1 ns;
              write_num(outline, i, field => 3, base => hex); write_string(outline, "  ");
              write_num(outline, blt_data(i), field => 8, base => hex);
              writeline(VLOG, outline);
            end if;
            i := i + 1;

          elsif BERR='0' then
            write_string(outline, "  Bus Error !!! ");
            writeline(VLOG, outline);
          end if;

          wait for Tend;
          if addack='1' then
            LWORD <= 'Z';
            A  <= (others => 'Z');
          end if;
          DS0 <= 'Z';
          DS1 <= 'Z';
          wait for Tblt;
          addack := '0';

        end loop;

        AS  <= 'Z';

        wait for Thiz;
        WRITE <= 'Z';
        LWORD <= 'Z';
        A  <= (others => 'Z');
        AM <= (others => 'Z');


      end;

    -- ****************************************************************
    -- Block Transfer Write Cycle
    -- ****************************************************************
    procedure vme_blt_write(addr:      in  integer;
                            amode:     in  integer;
                            dsize:     in  integer;
                            nbyte:     in  integer ) is


      variable outline  : LINE;
      variable i        : integer;
      variable addack   : std_logic;
      variable ncyc     : integer;
      variable break    : boolean := false;

      begin
        A  <= conv_std_logic_vector(addr/2,31);
        WRITE  <= '0';
        if dsize=D64 then
          if amode=A32 then AM <= conv_std_logic_vector(A32_U_MBLT,6);
          elsif amode=A24 then AM <= conv_std_logic_vector(A24_U_MBLT,6);
          end if;
        else
          if amode=A32 then AM <= conv_std_logic_vector(A32_U_BLT,6);
          elsif amode=A24 then AM <= conv_std_logic_vector(A24_U_BLT,6);
          end if;
        end if;
        if dsize = conv_integer(D64) then
          LWORD  <= '0';
          ncyc   := nbyte/8;
          addack := '1';
        elsif dsize = conv_integer(D32) then
          LWORD  <= '0';
          ncyc   := nbyte/4;
          addack := '0';
        elsif dsize = conv_integer(D16) then
          LWORD  <= '1';
          ncyc   := nbyte/2;
          addack := '1';
        else
          LWORD  <= '1';
          ncyc   := nbyte;
          addack := '1';
        end if;

        write_string(outline, "  VME BLT WRITE ");
        write_string(outline, DTYPE(conv_integer(dsize)));
        write_string(outline, " at address 0x");
        write_num(outline, addr, field => 8, base => hex);
        write_string(outline, " AM=0x");
        write_num(outline, to_Bitvector(AM), field => 2, base => hex);
        write_string(outline, "    Size(bytes)=");
        write_num(outline, nbyte, base => decimal);
        writeline(VLOG, outline);

        i := 0;
        wait for Tas;
        AS  <= '0';
        wait for Tds;

        while not break loop

          wait for 10 ns;
          DS0 <= '0';
          DS1 <= '0';

          wait until ((DTACK'event and DTACK='0') or (BERR'event and BERR='0'));

          if BERR = '0' or i = ncyc then
            break := true;
          end if;

          if addack='0' then
            if dsize = conv_integer(D64) then
              A  <= conv_std_logic_vector(blt_data(i*2)/2,31);
              if (blt_data(i*2) mod 1) = 1 then LWORD <= '1';
              else LWORD <= '0'; end if;
              D  <= conv_std_logic_vector(blt_data(i*2+1),32);
              write_num(outline, i*2, field => 3, base => hex); write_string(outline, "  ");
              write_num(outline, blt_data(i*2), field => 8, base => hex);
              writeline(VLOG, outline);
              write_num(outline, i*2+1, field => 3, base => hex); write_string(outline, "  ");
              write_num(outline, blt_data(i*2+1), field => 8, base => hex);
              writeline(VLOG, outline);
            else
              D  <= conv_std_logic_vector(blt_data(i),32);
              write_num(outline, i, field => 3, base => hex); write_string(outline, "  ");
              write_num(outline, blt_data(i), field => 8, base => hex);
              writeline(VLOG, outline);
            end if;
            i := i + 1;

          elsif BERR='0' then
            write_string(outline, "  Bus Error !!! ");
            writeline(VLOG, outline);
          end if;

          wait for Tend;
          DS0 <= 'Z';
          DS1 <= 'Z';
          wait for Tblt;
          addack := '0';

        end loop;

        AS  <= 'Z';

        wait for Thiz;
        WRITE <= 'Z';
        LWORD <= 'Z';
        A  <= (others => 'Z');
        AM <= (others => 'Z');
        D  <= (others => 'Z');

      end;



    -- ****************************************************************
    -- Interrupt Acknowledge Cycle
    -- ****************************************************************
    procedure vme_int_ack(lev:       in  integer;
                          dsize:     in  integer;
                          status_id: out integer ) is

      variable outline : LINE;
      variable vect : integer;
      variable ack : boolean;
      begin

        A  <= conv_std_logic_vector(lev,31);
        WRITE   <= '1';
        IACK    <= '0';
        IACKOUT <= '0';
        AM <= (others => '0');
        if dsize=conv_integer(D32) then LWORD  <= '0';
        else LWORD <= '1';
        end if;

        wait for Tas;
        AS  <= '0';
        wait for Tds;
        DS0 <= '0';
        DS1 <= '0';

        wait until ((DTACK'event and DTACK='0') or (BERR'event and BERR='0'));

        vect := conv_integer(to_01(D(31 downto 0)));
        status_id := vect;
        if DTACK = '0' then ack := true; else ack := false; end if;

        wait for Tend;
        AS      <= 'Z';
        DS0     <= 'Z';
        DS1     <= 'Z';
        IACK    <= 'Z';
        IACKOUT <= '1';
        wait for Thiz;
        A  <= (others => 'Z');
        AM <= (others => 'Z');

        write_string(outline, "  VME INTACK ");
        write_string(outline, DTYPE(conv_integer(DSIZE)));
        write_string(outline, " at level 0x");
        write_num(outline, lev, field => 1, base => decimal);
        if ack then
          write_string(outline, "   Status/ID=0x");
          write_num(outline, vect, field => 8, base => hex);
        else
          write_string(outline, "   Bus Error !!!");
        end if;
        writeline(VLOG, outline);

      end;




    -- ****************************************************************
    -- Write Stimula here...
    -- ****************************************************************

    variable rdata : integer;
    variable base_address : integer := 16#70000000#;
    
    procedure I2cTempReadoutProc is
    begin
        -- I2C TEMP readout
        --  // Scrittura CONFIG register
        --  command = (ushort)(I2C_AD | (chip_ad << 9) | (I2C_WR << 8)); /* address + scrittura*/
        --  command = (ushort)(CLEAR_BIT(I2C_RX,command)); /* master transmitter */
        --  command = SET_BIT(I2C_START,command);/* start */
        --
        --write_reg16(&v1392.i2ccom, command); /* start + scrittura AD */

        wait for 10 us;
        vme_write(base_address + 16#22#, A32, D16, 16#5002#);
        wait for 50 us;

        --
        --  while (!TEST_BIT(I2C_RDY,read_reg16(&v1392.i2cdat))); /* wait I2C ready */
        --
        --  command = 0x0100;
        --  write_reg16(&v1392.i2ccom, command);/* comando scrittura */

        wait for 10 us;
        vme_write(base_address + 16#22#, A32, D16, 16#0100#);
        wait for 50 us;

        --
        --  while (!TEST_BIT(I2C_RDY,read_reg16(&v1392.i2cdat))); /* wait I2C ready */
        --
        --  command = 0x0000;
        --  command = CLEAR_BIT(I2C_RX,command);/* master transmitter */
        --  command = SET_BIT(I2C_STOP,command);/* STOP*/
        --  write_reg16(&v1392.i2ccom, command);/* comando scrittura */

        wait for 10 us;
        vme_write(base_address + 16#22#, A32, D16, 16#0004#);
        wait for 50 us;

        --
        --  while (!TEST_BIT(I2C_RDY,read_reg16(&v1392.i2cdat))); /* wait I2C ready */
        --  // Fine scrittura CONFIG
        --
        --  // Scrittura ADDRESS POINTER register
        --  // ADDRESS POINTER = 000 (TEMPERATURE VALUE)
        --  command = I2C_AD | (chip_ad << 9) | (I2C_WR << 8); /* address + scrittura*/
        --  command = CLEAR_BIT(I2C_RX,command); /* master transmitter */
        --  command = SET_BIT(I2C_START,command);/* start */
        --
        --  write_reg16(&v1392.i2ccom, command); /* start + scrittura AD */

        wait for 10 us;
        vme_write(base_address + 16#22#, A32, D16, 16#5002#);
        wait for 50 us;

        --
        --  while (!TEST_BIT(I2C_RDY,read_reg16(&v1392.i2cdat))); /* wait I2C ready */
        --
        --  command = 0x0000;
        --  command = SET_BIT(I2C_STOP,command);/* master transmitter + STOP*/
        --
        --  write_reg16(&v1392.i2ccom, command);/* comando scrittura */

        wait for 10 us;
        vme_write(base_address + 16#22#, A32, D16, 16#0004#);
        wait for 50 us;

        --
        --  while (!TEST_BIT(I2C_RDY,read_reg16(&v1392.i2cdat))); /* wait I2C ready */
        --
        --
        --  command = I2C_AD | (chip_ad << 9) | (I2C_RD << 8); /* address + lettura*/
        --  command = CLEAR_BIT(I2C_RX,command); /* master transmitter */
        --  command = SET_BIT(I2C_START,command);/* start */
        --
        --  write_reg16(&v1392.i2ccom, command); /* start + scrittura AD */

        wait for 10 us;
        vme_write(base_address + 16#22#, A32, D16, 16#5102#);
        wait for 50 us;


        --
        --  while (!TEST_BIT(I2C_RDY,read_reg16(&v1392.i2cdat))); /* wait I2C ready */
        --
        --  command = 0;
        --  command = SET_BIT(I2C_RX,command);  /* master receiver */
        --
        --  write_reg16(&v1392.i2ccom, command);/* comando prima lettura */

        wait for 10 us;
        vme_write(base_address + 16#22#, A32, D16, 16#0001#);
        wait for 50 us;


        --
        --  while (!TEST_BIT(I2C_RDY,read_reg16(&v1392.i2cdat))); /* wait I2C ready */
        --  temp1 = v1392.i2cdat.reg;
        --
        --      vme_read(base_address + 16#24#, A32, D16, rdata);

        --  command = SET_BIT(I2C_STOP,command);/* master receiver + STOP*/
        --
        --  write_reg16(&v1392.i2ccom, command);/* comando seconda lettura + stop */

        wait for 10 us;
        vme_write(base_address + 16#22#, A32, D16, 16#0005#);
        wait for 50 us;

        --
        --  while (!TEST_BIT(I2C_RDY,read_reg16(&v1392.i2cdat))); /* wait I2C ready */
        --  temp2 = v1392.i2cdat.reg;
        --      vme_read(base_address + 16#24#, A32, D16, rdata);
        --
        --  temp = (((temp1 & 0xFF00) | ((temp2 & 0xC000) >> 8)) >> 6) * 0.25;
        --  return temp;
------------------------------------------------------------------------------------------
    end;

    procedure ReadFwRevisionProc is
    begin
      vme_read(base_address + 16#12#, A32, D16, rdata); -- Read Firmware Revision
      wait for 1 us;
      vme_read(base_address + 16#105C#, A32, D32, rdata);  -- Read Test FPGA revision  
      wait for 1 us;
    end;  

    procedure WestEastTestProc is
    begin
      -- West/East test
      vme_write(base_address + 16#0004#, A32, D16, 16#00000001#);
      wait for 1 us;
      -- West/East test
      vme_write(base_address + 16#0004#, A32, D16, 16#00000000#);
      wait for 1 us;
      -- West/East test
      vme_write(base_address + 16#0004#, A32, D16, 16#00000001#);
      wait for 1 us;
    end;  

    procedure CycloneDummyTestProc is
    begin
          -- SCrittura in Cyclone Dummy
      vme_write(base_address + 16#1064#, A32, D32, 16#00000002#);
      wait for 1 us;
      vme_read(base_address + 16#1064#, A32, D32, rdata);  -- Read Test FPGA revision        
      wait for 1 us;
      --  write_reg32(&v1392.test_ramad, ramad);
      vme_write(base_address + 16#1064#, A32, D32, 16#00000000#);
      wait for 1 us;
      vme_read(base_address + 16#1064#, A32, D32, rdata);  -- Read Test FPGA revision        
      wait for 1 us;
      --  write_reg32(&v1392.test_ramdtl, v);
      vme_write(base_address + 16#1064#, A32, D32, 16#A5A5A5A5#);
      wait for 1 us;
      vme_read(base_address + 16#1064#, A32, D32, rdata);  -- Read Test FPGA revision        
      wait for 1 us;
      -- Fine  SCrittura in Cyclone Dummy
    end;  

    procedure LUT_TestProc is
    begin
          -- Read LUT
      vme_read(base_address + 16#8000#, A32, D16, rdata);  -- Read LUT
      wait for 1 us;           
      vme_read(base_address + 16#8002#, A32, D16, rdata);  -- Read LUT      
      wait for 1 us;
      vme_read(base_address + 16#8004#, A32, D16, rdata);  -- Read LUT      
      wait for 1 us;
      vme_read(base_address + 16#8006#, A32, D16, rdata);  -- Read LUT      
      wait for 1 us;
      vme_read(base_address + 16#8008#, A32, D16, rdata);  -- Read LUT      
      wait for 1 us;
      
      --  LOad LUT COmmand
      vme_write(base_address + 16#0A#, A32, D16, 16#A5A5A5A5#);
      wait for 200 us;
      
      -- Read LUT
      vme_read(base_address + 16#8000#, A32, D16, rdata);  -- Read LUT
      wait for 1 us;           
      vme_read(base_address + 16#8002#, A32, D16, rdata);  -- Read LUT      
      wait for 1 us;
      vme_read(base_address + 16#8004#, A32, D16, rdata);  -- Read LUT      
      wait for 1 us;
      vme_read(base_address + 16#8006#, A32, D16, rdata);  -- Read LUT      
      wait for 1 us;
      vme_read(base_address + 16#8008#, A32, D16, rdata);  -- Read LUT      
      wait for 1 us;
    end;  

    procedure ROC_DummyTestProc is
    begin
       vme_write(base_address + 16#28#, A32, D32, 16#00000040#); -- Write Dummy32
       wait for 1000 ns;
       vme_read(base_address + 16#28#, A32, D32, rdata); -- Read Dummy32
       wait for 1000 ns;
    end;

    procedure CycloneRAMTestProc is
    begin
      -- SCrittura in RAM
      --  // Select Ram for Write
      --  // CS = 0
      --  // RD = 1
      --  write_reg32(&v1392.lbspctrl,0x0002);
      vme_write(base_address + 16#44#, A32, D32, 16#00000002#);
      wait for 1 us;
      --  write_reg32(&v1392.test_ramad, ramad);
      vme_write(base_address + 16#110C#, A32, D32, 16#00000000#);
      wait for 1 us;
      --  write_reg32(&v1392.test_ramdtl, v);
      vme_write(base_address + 16#1110#, A32, D32, 16#A5A5A5A5#);
      wait for 1 us;
      --
      --  // UnSelect Ram for Write
      --  // CS = 1
      --  // RD = 1
      -- write_reg32(&v1392.lbspctrl,0x0003);
      vme_write(base_address + 16#44#, A32, D32, 16#00000003#);
      wait for 1 us;
      
      -- Lettura in RAM
      -- // Select Ram for Read
      --  // CS = 0
      --  // RD = 0
      --  write_reg32(&v1392.lbspctrl,0x0000);
      vme_write(base_address + 16#44#, A32, D32, 16#00000000#);
      wait for 1 us;
      --  write_reg32(&v1392.test_ramad, ramad);
      vme_write(base_address + 16#110C#, A32, D32, 16#00000000#);
      wait for 1 us;
      --  rdata32 = read_reg32(&v1392.test_ramdtl);
      vme_read(base_address + 16#1010#, A32, D32, rdata);      
      wait for 1 us;
      --
      --  // UnSelect Ram for Write
      --  // CS = 1
      --  // RD = 1
      --  write_reg32(&v1392.lbspctrl,0x0003);
      vme_write(base_address + 16#44#, A32, D32, 16#00000003#);
      wait for 1 us;
    
    end;    
    
    procedure FlashTestProc is
    begin
      -- Flash Test
--      vme_write(base_address + 16#1C#, A32, D16, 16#00000001#); -- Write Flash sel
--      wait for 1000 ns;
--      vme_write(base_address + 16#1E#, A32, D16, 16#000000A5#); -- Write Flash sel
--      wait for 1000 ns;
--      vme_write(base_address + 16#1E#,  A32, D16, 16#0000005A#); -- Write Flash sel
--      wait for 1000 ns;
--      vme_write(base_address + 16#1C#, A32, D16, 16#00000000#); -- Write Flash sel
--      wait for 1000 ns;
      
--      vme_write(base_address + 16#14#, A32, D32, 16#00000040#); -- Write TestReg
--      wait for 1000 ns;
      
--      vme_read(base_address + 16#14#, A32, D32, rdata); -- Read TestReg   
--      wait for 1000 ns;
      
--      vme_read(base_address + 16#12#, A32, D16, rdata); -- Read Firmware Revision
      
--      wait for 1000 ns;

--   wait for 1000 ns;
    end;

    procedure RunTestProc is
    begin
       -- Read Event 
       -- Lettura a vuoto per verificare che ci sia BERR senza dati
       vme_blt_read(base_address+16#00#, A32, D64, 200); -- 50 DWORD

       -- Abilita la lettura automatica (x la costrizione del'evento) dell'I2C
       --vme_write(base_address + 16#04#, A32, D16, 16#00000080#); --
       
       wait for 1 us;
       
       -- Abilita l'acquisizione
       vme_write(base_address + 16#26#, A32, D16, 16#00000001#); --
       
       wait for 1 us;
       
       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;
       
       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;
       
       
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200); -- 50 DWORD

       wait for 1 us;
       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       
       
       wait for 100 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);

    end; -- RunTestProc

    --! Porta Full il MEB con trigger software
    procedure RunMEBFullTestProc is
    begin
       -- Read Event 
       -- Lettura a vuoto per verificare che ci sia BERR senza dati
       vme_blt_read(base_address+16#00#, A32, D64, 200); -- 50 DWORD
      
       wait for 1 us;
       
       -- Abilita l'acquisizione
       vme_write(base_address + 16#26#, A32, D16, 16#00000001#); --
       
       wait for 1 us;
       
       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;
       
       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;
       
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 4 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 10 us;
      -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;
       -- Read Event 
       vme_blt_read(base_address+16#00#, A32, D64, 200);
       wait for 5 us;

        -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;

       -- Dà un software trigger per abilitare il caricamento del MEB
       vme_write(base_address + 16#0E#, A32, D16, 16#00000001#); --
       wait for 50 us;
             

       
       
       wait;
    end; -- RunMEBFullTestProc
    
    procedure GenericTestProc is
    begin
    -- Set Cyclone I/O Mode
--   vme_write(base_address + 16#100#, A32, D32, 16#00000001#); -- Write LB MODE register
--   wait for 1000 ns;
--   vme_read(base_address + 16#100#, A32, D32, rdata);         -- Read  LB MODE register
--   wait for 1000 ns;
   
--   vme_write(base_address + 16#118#, A32, D32, 16#A5A5A5A5#); -- Write CTTM_DATA
--   wait for 1000 ns;
--   vme_write(base_address + 16#138#, A32, D32, 16#5A5A5A5A#); -- Write SPARE_DATA
--   wait for 1000 ns;
   
--   vme_write(base_address + 16#104#, A32, D32, 16#00000037#); -- Write TEST_CTRL Trgister
--   wait for 1000 ns;
--   vme_read(base_address + 16#104#, A32, D32, rdata);         -- Read  TEST_CTRL Trgister
--   wait for 1000 ns;

--   vme_write(base_address + 16#100#, A32, D32, 16#00000001#); -- Write LB MODE register
--   wait for 1000 ns;
--   vme_read(base_address + 16#100#, A32, D32, rdata);         -- Read  LB MODE register
--   wait for 1000 ns;


--      vme_write(base_address + 16#04#, A32, D16, 16#0080#); -- Enable Auto I2C Readout
--      wait for 5 ms;
--      vme_write(base_address + 16#04#, A32, D16, 16#0000#); -- Disable Auto I2C Readout


--      wait for 1 ms;
--      vme_write(base_address + 16#3A#, A32, D16, 16#0000#); -- Select DACs

--      wait for 1 ms;
--      vme_write(base_address + 16#3C#, A32, D16, 16#A55A#); -- Write on DAC
      
--      wait for 1 ms;
--      vme_write(base_address + 16#3A#, A32, D16, 16#FFFF#); -- UnSelect DACs
      
--      vme_write(base_address + 16#26#, A32, D16, 16#00000001#); -- Enable ACQUISITION
--      wait for 1000 ns; 
--      vme_write(base_address + 16#04#, A32, D16, 16#00000020#); -- Write CONFIG to enable FIFO TEST
--      wait for 1000 ns; 
      -- Write into TESTREG to test READOUT FIFO
--      vme_write(base_address + 16#14#, A32, D32, 16#00000040#); -- Write TestReg
--      wait for 1000 ns;
--      vme_write(base_address + 16#14#, A32, D32, 16#00000041#); -- Write TestReg
--      wait for 1000 ns;
--      vme_write(base_address + 16#14#, A32, D32, 16#00000042#); -- Write TestReg
--      wait for 1000 ns;
--      vme_write(base_address + 16#14#, A32, D32, 16#00000043#); -- Write TestReg
--      wait for 1000 ns;
--      vme_write(base_address + 16#14#, A32, D32, 16#00000044#); -- Write TestReg
--      wait for 1000 ns;
--      vme_write(base_address + 16#14#, A32, D32, 16#00000045#); -- Write TestReg
--      wait for 1000 ns;
--      vme_write(base_address + 16#14#, A32, D32, 16#00000046#); -- Write TestReg
--      wait for 1000 ns;

--      vme_write(base_address + 16#04#, A32, D16, 16#0000#); -- Select I2C Chain A
--      vme_write(base_address + 16#22#, A32, D16, 16#9002#); -- Write I2CCOM
--      
--      wait for 50 us;
--      
--      vme_write(base_address + 16#22#, A32, D16, 16#5A04#); -- Write I2CCOM
--
--      wait for 50 us;
--
--      vme_write(base_address + 16#04#, A32, D16, 16#0040#); -- Select I2C Chain B
--      vme_write(base_address + 16#22#, A32, D16, 16#9002#); -- Write I2CCOM
--      
--      wait for 50 us;
--      
--      vme_write(base_address + 16#22#, A32, D16, 16#A504#); -- Write I2CCOM
--      
--      wait for 50 us;
--      
--      vme_write(base_address + 16#14#, A32, D32, 16#AA55#); -- Write TESTREG
--      vme_read (base_address + 16#14#, A32, D32, rdata);    -- Read  TESTREG
--      
--      wait for 50 us;
--      vme_write(base_address + 16#2C#, A32, D16, 16#A504#); -- Write PDL_PROG
--      
--      wait for 50 us;
--      vme_read (base_address + 16#2E#, A32, D16, rdata);    -- Read  PDL_DATA
--      
--      wait for 50 us;
--      vme_write(base_address + 16#2C#, A32, D16, 16#5A2A#); -- Write PDL_PROG
--      
--      wait for 50 us;
--      vme_read (base_address + 16#2E#, A32, D16, rdata);    -- Read  PDL_DATA
       
      --vme_blt_write(base_address, A24, D32, 32);
      --vme_blt_read(base_address, A24, D64, 32);

    end; -- GenericTestProc
    
    begin

      vme_init;
      
      RunMEBFullTestProc;
      
      wait;

    end process;

 end BEHAV;
