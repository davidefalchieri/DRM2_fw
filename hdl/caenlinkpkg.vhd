--!------------------------------------------------------------------------
--! @author       Annalisa Mati  (a.mati@caen.it)               
--! Contact       support.frontend@caen.it
--! @file         caenlinkpkg.vhd
--!------------------------------------------------------------------------
--! @brief        CaenOpticalLink Package
--!------------------------------------------------------------------------               
--! $Id: $ 
--!------------------------------------------------------------------------


Library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


package CAENLINKPKG is

  -- #######################################################################################
  -- Formato dati protocollo ottico
  -- #######################################################################################

  -- ***************************************************************************************
  -- Dati dalla Input PIPE
  -- ***************************************************************************************
  constant IP_TYPE          : integer := 15;
  constant IP_WRITE         : integer := 14;
  subtype  IP_AM            is std_logic_vector(13 downto  8);
  constant IP_LASTCMD       : integer := 7;
  constant IP_SWAP          : integer := 6;
  subtype  IP_DTSIZE        is std_logic_vector( 5 downto  4);
  subtype  IP_OPCODE        is std_logic_vector( 3 downto  0);

  subtype  IP_REGAD         is std_logic_vector( 7 downto  0); -- serve ???

  -- ***************************************************************************************
  -- OPCODE
  -- ***************************************************************************************  
  
  -- OPCODE[3:0] : codifica il tipo di ciclo
  constant NULLCYC     : std_logic_vector(3 downto 0) := "0000";  -- 0
  constant SINGLERW    : std_logic_vector(3 downto 0) := "0001";  -- 1
  constant RMW         : std_logic_vector(3 downto 0) := "0010";  -- 2
  constant BLT         : std_logic_vector(3 downto 0) := "0100";  -- 4
  constant PBLT        : std_logic_vector(3 downto 0) := "0111";  -- 7
  constant BLT_FIFO    : std_logic_vector(3 downto 0) := "1100";  -- C
  constant PBLT_FIFO   : std_logic_vector(3 downto 0) := "1111";  -- F
  constant INTACK      : std_logic_vector(3 downto 0) := "1000";  -- 8
  constant ADO         : std_logic_vector(3 downto 0) := "0101";  -- 5
  constant ADOH        : std_logic_vector(3 downto 0) := "0011";  -- 3

  -- OPCODE[5:4] : data size
  constant D8            : std_logic_vector(1 downto 0) := "00";
  constant D16           : std_logic_vector(1 downto 0) := "01";
  constant D32           : std_logic_vector(1 downto 0) := "10";
  constant D64           : std_logic_vector(1 downto 0) := "11";

  -- OPCODE[6] : byte Swap

  -- OPCODE[7] : last command
  constant LAST_COMMAND  : std_logic := '1';
  constant CONTINUE      : std_logic := '0';

  -- OPCODE [14] : read/write
  constant READCYC       : std_logic := '1';
  constant WRITECYC      : std_logic := '0';

  -- OPCODE [15] : vme access/registers access
  constant OPVME    : std_logic := '1';
  constant OPREG    : std_logic := '0';

  
  -- ***************************************************************************************
  -- Codici di Comando del protocollo CONET (prima della codifica 8b/10b).
  -- La codifica nel commento va dal bit j al bit a, al contrario di quello che si trova in letteratura.
  -- I codici per i quali è indicato D=0 sono quelli a disparità nulla.
  -- ***************************************************************************************
  constant L_COMMA: std_logic_vector(7 downto 0):="10111100"; -- K.28.5 =0xBC - cod. in 0101111100=0x17C o 
                                                              --                       1010000011=0x283
                                                              
  constant L_NULL : std_logic_vector(7 downto 0):="00011100"; -- K.28.0 =0x1C - cod. in 0010111100=0x0BC o 
                                                              --                       1101000011=0x343 (D=0)
                                                              
  constant L_START: std_logic_vector(7 downto 0):="11111011"; -- K.27.7 =0xFB - cod. in 0001011011=0x05B o 
                                                              --                       1110100100=0x3A4 (D=0)
                                                              
  constant L_STOP : std_logic_vector(7 downto 0):="11111101"; -- K.29.7 =0xFD - cod. in 0001011101=0x05D o 
                                                              --                       1110100010=0x3A2 (D=0)
                                                              
  constant L_EOT  : std_logic_vector(7 downto 0):="11111110"; -- K.30.7 =0xFE - cod. in 0001011110=0x05E o 
                                                              --                       1110100001=0x3A1 (D=0)
                                                              
  constant L_TOKEN: std_logic_vector(7 downto 0):="11110111"; -- K.23.7 =0xF7 - cod. in 0001010111=0x057 o 
                                                              --                       1110101000=0x3A8 (D=0)
                                                              
  constant L_VINT : std_logic_vector(7 downto 0):="10011100"; -- K.28.4 =0x9C - cod. in 0100111100=0x13C o 
                                                              --                       1011000011=0x2C3 (D=0)
                                                              
  constant L_SERV : std_logic_vector(7 downto 0):="01011100"; -- K.28.2 =0x5C - cod. in 1010111100=0x2BC o 
                                                              --                       0101000011=0x183

  constant L_RESET : std_logic_vector(7 downto 0):="01111100"; -- K.28.3 =0x7C - cod. in 1100111100=0x33C o 
                                                              --                       0011000011=0x0C3
  constant MAX_PCK_SIZE  : integer := 256;
  
  
  
  function to_01 (din: in std_logic_vector) return std_logic_vector;


end CAENLINKPKG;

package body CAENLINKPKG is

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

end CAENLINKPKG;


