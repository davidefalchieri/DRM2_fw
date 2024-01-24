-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA600
-- Author:          Annalisa Mati
-- Date:            26/08/04
-- --------------------------------------------------------------------------
-- Module:          ATMEGA16
-- Description:     Microcontroller (behavioural model)
-- ****************************************************************************

-- ############################################################################
-- Revision History:
--
-- ############################################################################

-- MODELLO SEMPLIFICATO DEL MICROCONTROLLORE ATMEGA16
-- NB: si può simulare solo la scrittura di alcuni OPCODE (v. sotto) e la comunicazione
-- seriale con la PAL
-- Nel caso di OPCODE "set LSB of leading/trailing edge" la word che deve essere
-- scritta da VME sarà direttamente il formato dati da comunicare al ROC
-- Il micro non effettua operazioni sui TDC

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_Logic_unsigned.all;

ENTITY ATMEGA16 IS
   PORT(
       MRES      : IN    std_logic;                    -- RESET del MICRO (dalla PAL)
       MICD      : INOUT std_logic_vector (7 DOWNTO 0);-- diventano i VDB
       MROK      : OUT   std_logic;                    -- segnali di handshake con la PAL per la lettura/scrittura
       WMIC      : IN    std_logic;
       MWOK      : OUT   std_logic;
       RMIC      : IN    std_logic;
       NOEABL    : OUT   std_logic;                    -- output enable dei 543 (scrittura PAL -> MICRO)
       NOEABH    : OUT   std_logic;                    -- output enable dei 543 (scrittura PAL -> MICRO)
       STRBAL    : OUT   std_logic;                    -- strobe dei 543 (lettura PAL -> MICRO)
       STRBAH    : OUT   std_logic;                    -- strobe dei 543 (lettura PAL -> MICRO)
       COM_SER   : OUT   std_logic;                    -- attivo quando é in corso una comunicazione seriale
       -- dal MICRO alla PAL
       MSERCLK   : OUT   std_logic;                    -- clock della comunicazione seriale
       MTDI      : OUT   std_logic;                    -- dato della comunicazione seriale
       Finished  : IN    std_logic;
       INT_ERRA  : OUT   std_logic; -- Chain A error (from I2C)
       CHAINA_ERR: OUT   std_logic; -- Chain A error (from uC)
       INT_ERRB  : OUT   std_logic; -- Chain B error (from I2C)
       CHAINB_ERR: OUT   std_logic  -- Chain B error (from uC)
   );
END ATMEGA16 ;

ARCHITECTURE BEHAV OF ATMEGA16 IS

  signal OPC,WIN : std_logic_vector(15 downto 0);


--********************************************************************************
-- OPCODE CHE SI POSSONO SIMULARE
--********** acquisition mode ****************************************************          |OPERAZIONI DA FARE SEGUITO DELL'OPCODE:
constant O_TRG_MATCH       : integer := 16#0000#;  -- set trigger matching                    |COM SER
constant O_CONT_STOR       : integer := 16#0001#;  -- set continuous storage                  |COM SER
constant O_READ_ACQ_MOD    : integer := 16#0002#;  -- read acquisition mode                   |VME READ
--********** trigger *************************************************************          |
constant O_SET_WIN_WIDTH   : integer := 16#0010#;  -- set window width                      |VME WRITE
--********** tdc edge detection & resolution *************************************          |
constant O_SET_TR_LEAD_LSB : integer := 16#0024#;  -- set LSB of leading/trailing edge        |VME WRITE + COM SER
                                                   -- per semplicità la parola che deve essere|
                           -- scritta corrisponde al formato dati da  |
                           -- trasmettere alla PAL (DT_FORM)      |
--********** tdc readout *********************************************************        |
constant O_EN_HEAD_EOB     : integer := 16#0030#;  -- enable TDC header and EOB in readout    |COM SER
constant O_DIS_HEAD_EOB    : integer := 16#0031#;  -- disable TDC header and EOB in readout   |COM SER
constant O_READ_HEAD_EOB   : integer := 16#0032#;  -- read status TDC header and EOB      |VME READ
--********** miscellaneous *******************************************************        |
constant O_READ_TDC_IDCODE : integer := 16#0060#;  -- read IDCODE of TDC nn                 |4 ID CODE DAI TDC (4 VME READ)


constant   T   : time := 250 ns; -- Clock period

  ---------------------------------------------------------------------
  -- Comunicazione seriale della programmazione dei TDC alla PAL
  -- (MIC_REGS è lo shift reg. nella PAL)
  -- Durante questa comunicazione COM_SER = 1
  ---------------------------------------------------------------------
  --            __________________________________________________________________________________________________
  -- COM_SER __|                                                                                                  |__
  --             _____       _____       _____       _____       _____       _____       _____       _____
  -- MSERCLK____|     |_____|     |_____|     |_____|     |_____|     |_____|     |_____|     |_____|     |__________
  --             ___________ ___________ ___________ ___________ ___________ ___________ ___________ ___________
  -- MTDIA  ----|_TRG_MATCH_|_CHAINA_EN_|_CHAINB_EN_|_RAW_DATA__|_CHAINA_BP_|_CHAINB_BP_|__LEADING__|__TRAILING_|----
  --             ___________ ___________ ___________ ___________ ___________ ___________ ___________ ___________
  -- MIC_REG    |_____0_____|_____1_____|_____2_____|_____3_____|_____4_____|_____5_____|_____6_____|_____7_____|

  ---------------------------------------------------------------------


-- informazioni inviate alla FPGA nella comunicazione seriale
signal CHAINA_EN: std_logic := '0';
signal CHAINB_EN: std_logic := '0';
signal CHAINA_BP: std_logic := '0';
signal CHAINB_BP: std_logic := '0';
signal TRG_MATCH: std_logic := '1';
signal ROW_DATA : std_logic := '0';
signal LEADING  : std_logic := '1';
signal TRAILING : std_logic := '1';

signal DT_FORM  : std_logic_vector(1 downto 0) := "10"; -- default 100ps
signal PAIR     : std_logic := '0';
signal HEADER_EN: std_logic := '1';                     -- default header abilitata
signal TRG_RIT  : std_logic := '0';

signal OP_PROG  : std_logic;      -- si setta quando viene scritto un OPCODE che
                                  -- cambia la programmazione dei TDC che interessa la PAL

constant PERIOD : time := 250 ns;

signal MCLK     : std_logic;      -- CLOCK per il micro (autogenerato)

signal MDATA    : std_logic_vector(48 downto 0):= '0' & conv_std_logic_vector(16#AAAA#,16) & -- ERROR_CODE
                                                        conv_std_logic_vector(16#BBBB#,16) & -- CHB_ERR_FLAGS
                                                        conv_std_logic_vector(16#CCCC#,16);  -- CHA_ERR_FLAGS

begin

  -- ******************************************************************
  -- CLOCK
  -- ******************************************************************ì
  process begin
    wait for 1 ns;
    while Finished = '0' loop
      MCLK <= '0';
      wait for PERIOD/2;
      MCLK <= '1';
      wait for PERIOD/2;
    end loop;

    wait;
  end process;


  -- ******************************************************************
  -- Comunicazione seriale al ROC della programmazione dei TDC
  -- ******************************************************************
  process begin

    COM_SER <= '0';
    MSERCLK <= '0';
    MTDI    <= '0';

    INT_ERRA  <= '1';
    CHAINA_ERR<= '0';
    INT_ERRB  <= '1';
    CHAINB_ERR<= '0';

    wait for 1 ns;

    if MRES = '0' then      -- aspetta che la PAL abbia finito le operazioni di Power on
      wait until MRES = '1';
    end if;


    wait for 1110 ns;        -- programma i TDC

    COM_SER <= '1';         -- comunica al ROC la programmazione dei TDC

    wait until (MCLK'event  and  MCLK = '1');
    MTDI <= TRG_MATCH;
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';

    wait until (MCLK'event  and  MCLK = '1');
    MTDI <= CHAINA_EN;
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';

    wait until (MCLK'event  and  MCLK = '1');
    MTDI <= CHAINB_EN;
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';

    wait until (MCLK'event  and  MCLK = '1');
    MTDI <= ROW_DATA;
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';

    wait until (MCLK'event  and  MCLK = '1');
    MTDI <= CHAINA_BP;
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';

    wait until (MCLK'event  and  MCLK = '1');
    MTDI <= CHAINB_BP;
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';

    wait until (MCLK'event  and  MCLK = '1');
    MTDI <= LEADING;
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';

    wait until (MCLK'event  and  MCLK = '1');
    MTDI <= TRAILING;
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';

    wait until (MCLK'event  and  MCLK = '1');
    MSERCLK <= '0';
    MTDI    <= '0';
    COM_SER <= '0';


    -- simulazione dell'errore della catena A
    wait for 50 us;
--    INT_ERRA <= '0';
--    wait for 200 ns;
--    INT_ERRA <= '1';
--    wait for 50 ns;
--    CHAINA_ERR<= '1';
--    wait for 400 ns;
--    for I in 0 to 48 loop
--      wait until (MCLK'event  and  MCLK = '1');
--      MTDI <= MDATA(0);
--      MDATA<= '0' & MDATA(48 downto 1);
--      wait until (MCLK'event  and  MCLK = '1');
--      MSERCLK <= '1';
--      wait until (MCLK'event  and  MCLK = '1');
--      MSERCLK <= '0';
--    end loop;
--    wait for 100 ns;
--    CHAINA_ERR<= '0';

    wait for 50 us;
--    INT_ERRA <= '0';
--    wait for 200 ns;
--    INT_ERRA <= '1';
--    wait for 50 ns;
--    CHAINA_ERR<= '1';
--    wait for 400 ns;
--    for I in 0 to 48 loop
--      wait until (MCLK'event  and  MCLK = '1');
--      MTDI <= MDATA(0);
--      MDATA<= '0' & MDATA(48 downto 1);
--      wait until (MCLK'event  and  MCLK = '1');
--      MSERCLK <= '1';
--      wait until (MCLK'event  and  MCLK = '1');
--      MSERCLK <= '0';
--    end loop;
--    wait for 100 ns;
--    CHAINA_ERR<= '0';




    -- fa la comunicazione seriale se arriva un reset o un OPCODE che
    -- cambia la programmazione dei TDC che interessa la PAL

    wait until (MRES = '0' or OP_PROG = '1');
    -- (proseguo quando diventa vera MRES = '1' o OP_PROG = '1')

  end process;


  -- ******************************************************************
  -- HANDSHAKE  per la lettura/scrittura da VME
  -- ******************************************************************
  process
    ---------------------------------------------------------------------
    -- Scrittura di una word: vme -> micro
    procedure write(
                    DATA:  out  std_logic_vector (15 downto 0)
                   ) is
    begin
      NOEABH <= '0';  -- leggo la parte alta
      wait until (MCLK'event  and  MCLK = '1');
      DATA(15 downto 8):= MICD;
      wait until (MCLK'event  and  MCLK = '1');
      NOEABH <= '1';
      wait until (MCLK'event  and  MCLK = '1');

      NOEABL <= '0';  -- leggo la parte bassa
      wait until (MCLK'event  and  MCLK = '1');
      DATA(7 downto 0) := MICD;
      wait until (MCLK'event  and  MCLK = '1');
      NOEABL <= '1';
      MWOK   <= '1';  -- ho finito
      wait until (MCLK'event  and  MCLK = '1');
    end;

    ---------------------------------------------------------------------
    -- Lettura di una word: micro -> vme
    procedure read(
                    DATA:  in  std_logic_vector (15 downto 0)
                   ) is
    begin
      MICD   <= DATA(15 downto 8);
      wait until (MCLK'event  and  MCLK = '1');
      STRBAH <= '0'; -- scrivo la parte alta
      wait until (MCLK'event  and  MCLK = '1');
      STRBAH <= '1';
      wait until (MCLK'event  and  MCLK = '1');

      MICD   <= DATA(7 downto 0);
      wait until (MCLK'event  and  MCLK = '1');
      STRBAL <= '0'; -- scrivo la parte bassa
      wait until (MCLK'event  and  MCLK = '1');
      STRBAL <= '1';
      wait until (MCLK'event  and  MCLK = '1');
      MICD     <= (others => 'Z');
      MROK   <= '1'; -- ho finito
      wait until (MCLK'event  and  MCLK = '1');
    end;

  variable OPCODE     : std_logic_vector(15 downto 0);
  variable WINDOW     : std_logic_vector(15 downto 0);
  variable RESOLUTION : std_logic_vector(15 downto 0);

  begin
    -- inizializzazioni
    MICD     <= (others => 'Z');
    NOEABH   <= '1';
    NOEABL   <= '1';
    STRBAH   <= '1';
    STRBAL   <= '1';
    MWOK     <= '0';
    MROK     <= '0';
    OP_PROG  <= '0';

    wait for 3000 ns;
    wait until (MCLK'event  and  MCLK = '1');
    MWOK     <= '1';
    wait until (MCLK'event  and  MCLK = '1');
    MWOK     <= '0';


    -- Attendo la scrittura di una word: vme -> micro (WMIC sveglia il processo)
    wait until (WMIC'event  and  WMIC = '1');
    wait until (MCLK'event  and  MCLK = '1');

    write(OPCODE);

    OPC <= OPCODE;

    -- eseguo l'opcode
    case conv_integer(OPCODE)is
      when O_TRG_MATCH       => TRG_MATCH <= '1';
                                OP_PROG   <= '1';
                                wait until (MCLK'event  and  MCLK = '1');

      when O_CONT_STOR       => TRG_MATCH <= '0';
                                OP_PROG   <= '1';
                                wait until (MCLK'event  and  MCLK = '1');

      when O_READ_ACQ_MOD    => read("000000000000000" & TRG_MATCH);
                                wait until (RMIC'event  and  RMIC = '1');
                                wait until (MCLK'event  and  MCLK = '1');

      when O_SET_WIN_WIDTH   => MWOK <= '0';
                                wait until (MCLK'event  and  MCLK = '1');
                                wait until (WMIC'event  and  WMIC = '1');
                                wait until (MCLK'event  and  MCLK = '1');
                                write(WINDOW);
                                WIN <= WINDOW;

      when O_SET_TR_LEAD_LSB => MWOK <= '0';
                                wait until (MCLK'event  and  MCLK = '1');
                                wait until (WMIC'event  and  WMIC = '1');
                                wait until (MCLK'event  and  MCLK = '1');
                                write(RESOLUTION);
        DT_FORM   <= RESOLUTION(1 downto 0);
        OP_PROG   <= '1';
                          wait until (MCLK'event  and  MCLK = '1');

      when O_EN_HEAD_EOB     => HEADER_EN <= '1';
                          OP_PROG   <= '1';
                          wait until (MCLK'event  and  MCLK = '1');
      when O_DIS_HEAD_EOB    => HEADER_EN <= '0';
                          OP_PROG   <= '1';
                          wait until (MCLK'event  and  MCLK = '1');

      when O_READ_HEAD_EOB   => read("000000000000000" & HEADER_EN);
                          wait until (RMIC'event  and  RMIC = '1');
                          wait until (MCLK'event  and  MCLK = '1');

      when O_READ_TDC_IDCODE => read("0000000000000000");
                          wait until (RMIC'event  and  RMIC = '1');
                          wait until (MCLK'event  and  MCLK = '1');
                                MROK     <= '0';
                          read("0000000000000001");
                          wait until (RMIC'event  and  RMIC = '1');
                          wait until (MCLK'event  and  MCLK = '1');
                                MROK     <= '0';
        read("0000000000000010");
                          wait until (RMIC'event  and  RMIC = '1');
                          wait until (MCLK'event  and  MCLK = '1');
                                MROK     <= '0';
        read("0000000000000011");
                          wait until (RMIC'event  and  RMIC = '1');
                          wait until (MCLK'event  and  MCLK = '1');
      when others            => null;
    end case;

  end process;


END BEHAV;

