--==========================================================================================================--
--  File name: I2C_ADC.vhd                                                                                  --
--  Designer : L. Colombini                                                                                 --
--  Description:  Simulation of a AD7416, AD7417, AD7418 ADC and Temperature Sensors                        --
--                                                                                                          --
--==========================================================================================================--

--==========================================================================================================--
--                                                                                                          --
--                         Copyright (c) 2002 by IBM , Inc.   All rights reserved.                          --
--                                                                                                          --
--                      Martin Neumann mneumann@de.ibm.com - IBM EF Boeblingen GERMANY                      --
--                                                                                                          --
--==========================================================================================================--
--  File name: I2C_EEPROM.vhd                                                                               --
--  Designer : M. Neumann                                                                                   --
--  Description:  Simulation of a series 24Cxx I2C EEPROM (24C01, 24C02, 24C04, 24C08 and 24C16)            --
--                                                                                                          --
--==========================================================================================================--

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.std_logic_unsigned.all;   -- function conv_integer

entity I2C_ADC is
 generic ( stretch : time           := 1 ns;      --pull SCL low for this time-value;
           temperature              : std_logic_vector(15 downto 0) := "0000000000000001";
           adc_value                : std_logic_vector(15 downto 0) := "1111111111111110";
           device  : string(1 to 6) := "AD7417"); --AD7416 ID = "1001"; 
                                                  --AD7417 ID = "0101"; 
                                                  --AD7418 ID = "0101"; 
                                          
 port (
  A0                 : IN    std_logic := 'L';  --Chip Address in I2C chain
  A1                 : IN    std_logic := 'L';  --Chip Address in I2C chain
  A2                 : IN    std_logic := 'L';  --Chip Address in I2C chain
  SCL                : INOUT std_logic;
  SDA                : INOUT std_logic
);
END I2C_ADC;


--==========================================================================================================--

architecture SIM of I2C_ADC is

   type      I2C_STATE     is (IDLE, ID_CODE, ID_ACK, WR_ADDR, AR_ACK, WR_DATA, WR_ACK, RD_DATA, RD_ACK);

   signal    BIT_PTR       : natural;
   signal    THIS_STATE    : I2C_STATE;
   signal    NEXT_STATE    : I2C_STATE;
   signal    SCL_IN        : std_logic;
   signal    SCL_OLD       : std_logic;
   signal    SCL_OUT       : std_logic;
   signal    SDA_IN        : std_logic;
   signal    SDA_OUT       : std_logic;
   signal    START_DET     : std_logic;
   signal    STOP_DET      : std_logic;
   signal    DEVICE_SEL    : std_logic;
   signal    RD_MODE       : std_logic;
   signal    WRITE_EN      : std_logic;
   signal    RECV_BYTE     : std_logic_vector(7 downto 0);
   signal    XMIT_BYTE     : std_logic_vector(7 downto 0);
   
   signal    AP_REG        : std_logic_vector(7 downto 0); -- Address Pointer Register
   signal    TEMP_REG      : std_logic_vector(15 downto 0); -- Temperature Register
   signal    CFG_REG       : std_logic_vector(7 downto 0); -- Configuration Register
   signal    THYST_REG     : std_logic_vector(15 downto 0); -- Temp Hysteresis Register
   signal    TOTI_REG      : std_logic_vector(15 downto 0); -- Temp OverThreshold Register
   signal    ADC_REG       : std_logic_vector(15 downto 0); -- ADC register
   signal    CFG2_REG      : std_logic_vector(7 downto 0); -- Config2 Register
   
   signal    BYTE_PTR      : std_logic;
   

begin

  SCL_IN <= '1' when SCL='1' or SCL='H' else
            '0' when SCL='0' else 'X';

  SDA_IN <= '1' when SDA='1' or SDA='H' else
            '0' when SDa='0' else 'X';

  SCL_OLD <= SCL_IN after 10 ns;

  p_START_DET :
  process (SDA_IN, SCL_IN)
  begin
    if SDA_IN'event and SDA_IN ='0' and SCL_IN ='1' and SCL_OLD ='1' then
      START_DET <= '1';
    elsif SCL_IN'event and SCL_IN ='1' and THIS_STATE=ID_CODE then
      START_DET <='0';
    end if;
  end process;

  p_STOP_DET :
  process (SDA_IN, THIS_STATE)
  begin
    if SDA_IN'event and SDA_IN ='1' and SCL_IN ='1' and SCL_OLD ='1' then
      STOP_DET  <= '1';
    elsif THIS_STATE =IDLE then
      STOP_DET  <='0' after 30 ns;
    end if;
  end process;

  p_THIS_STATE :
  process (STOP_DET, SCL_IN)
  begin
    if (STOP_DET ='1') then
      THIS_STATE <= IDLE;
    elsif SCL_IN'event and SCL_IN='0' then
      THIS_STATE <= NEXT_STATE;
    end if;
  end process;

  p_NEXT_STATE :
  process(START_DET, THIS_STATE, BIT_PTR, SDA_IN, DEVICE_SEL, RD_MODE)
  begin
    if START_DET ='1'                         then NEXT_STATE <= ID_CODE;
    else
      case THIS_STATE is
        when ID_CODE => if    (BIT_PTR > 0)   then NEXT_STATE <= ID_CODE;
                        else                       NEXT_STATE <= ID_ACK;
                        end if;
        when ID_ACK  => if    (DEVICE_SEL='1'
                           and RD_MODE='1')   then NEXT_STATE <= RD_DATA;
                        elsif (DEVICE_SEL='1'
                           and RD_MODE='0')   then NEXT_STATE <= WR_ADDR;
                        else                       NEXT_STATE <= IDLE;
                        end if;
        when WR_ADDR => if    (BIT_PTR > 0)   then NEXT_STATE <= WR_ADDR;
                        else                       NEXT_STATE <= AR_ACK;
                        end if;
        when AR_ACK  =>                            NEXT_STATE <= WR_DATA;
        when WR_DATA => if    (BIT_PTR > 0)   then NEXT_STATE <= WR_DATA;
                        else                       NEXT_STATE <= WR_ACK;
                        end if;
        when WR_ACK  =>                            NEXT_STATE <= WR_DATA;
        when RD_DATA => if    (BIT_PTR > 0)   then NEXT_STATE <= RD_DATA;
                        else                       NEXT_STATE <= RD_ACK;
                        end if;
        when RD_ACK  => if    (SDA_IN ='0')   then NEXT_STATE <= RD_DATA;
                        else                       NEXT_STATE <= IDLE;
                        end if;
        when others  =>                            NEXT_STATE <= IDLE;
      end case;
    end if;
  end process;

  RECV_BYTE(0) <= SDA_IN;

  p_RECV_BYTE :
  process begin wait until SCL_IN'event and SCL_IN ='0';
    RECV_BYTE(7 downto 1) <= RECV_BYTE(6 downto 0);
  end process;

  p_RD_MODE :
  process begin wait until SCL_IN'event and SCL_IN ='0';
    if NEXT_STATE=ID_ACK then
      RD_MODE <= RECV_BYTE(0);
    end if;
  end process;

  p_DEVICE_SEL :
  process begin wait until SCL_IN'event and SCL_IN ='0';
    if NEXT_STATE=ID_ACK then
      if (device="AD7416" and RECV_BYTE(7 downto 4)="1001" and A2&A1&A0=RECV_BYTE(3 downto 1)) 
      or (device="AD7417" and RECV_BYTE(7 downto 4)="0101" and A2&A1&A0=RECV_BYTE(3 downto 1))
      or (device="AD7418" and RECV_BYTE(7 downto 4)="0101" and A2&A1&A0=RECV_BYTE(3 downto 1)) then
        DEVICE_SEL <= '1';
      end if;
    else
      DEVICE_SEL <= '0';
    end if;
  end process;

  WRITE_EN <= '1'; -- Scrittura sempre abilitata

  with THIS_STATE select
    SDA_OUT <= XMIT_BYTE(BIT_PTR) after 30 ns when RD_DATA,
               not DEVICE_SEL     after 30 ns when ID_ACK,
               '0'                after 30 ns when AR_ACK,
               not WRITE_EN       after 30 ns when WR_ACK,
               'Z'                after 30 ns when others;

  SDA <= SDA_OUT;

  p_SCL_OUT :
  process begin
  SCL_OUT <= 'Z';
  wait until SCL_IN'event and SCL_IN ='0';
    SCL_OUT <= '0';
    wait for stretch;
    SCL_OUT <= 'Z';
  end process;

  SCL <= SCL_OUT;

  p_BIT_PTR :
  process(SCL_IN, THIS_STATE, START_DET)
  begin
    if START_DET ='1' then
      BIT_PTR <= 7;
    elsif SCL_IN'event and SCL_IN ='0' then
      if    NEXT_STATE=ID_ACK  or NEXT_STATE=AR_ACK  or NEXT_STATE=WR_ACK  or NEXT_STATE=RD_ACK  then
        BIT_PTR <= 8;  
      elsif NEXT_STATE=ID_CODE or NEXT_STATE=WR_ADDR or NEXT_STATE=WR_DATA or NEXT_STATE=RD_DATA then
        BIT_PTR <= BIT_PTR -1;
      end if;
    end if;
  end process;
  
  p_BYTE_PTR :
  process(SCL_IN, THIS_STATE, START_DET)
  begin
    if START_DET ='1' then
      BYTE_PTR <= '0';
    elsif SCL_IN'event and SCL_IN ='0' then
      if NEXT_STATE=RD_ACK or NEXT_STATE=WR_ACK then
        BYTE_PTR <= '1';
      end if;
    end if;
  end process;  
  
  p_REG_ADDR :
    process
     constant ADDR_MAX : positive := 6;
    begin
      wait until SCL_IN'event and SCL_IN='0';
      if NEXT_STATE = AR_ACK then
        AP_REG <= RECV_BYTE;
      end if;
  end process;


  TEMP_REG <= temperature;
  ADC_REG  <= adc_value;
  
  
  p_REG_WR :
  process 
  begin 
    wait until SCL_IN'event and SCL_IN='0';
    if  NEXT_STATE=WR_ACK and WRITE_EN='1' then
      case AP_REG is
        when "00000000" => null; -- temp is read-only
        when "00000001" => CFG_REG  (7 downto 0) <= RECV_BYTE;
        when "00000010" => if BYTE_PTR = '0' then
                             THYST_REG(15 downto 8) <= RECV_BYTE;
                           else
                             THYST_REG( 7 downto 0) <= RECV_BYTE;
                           end if;
        when "00000011" => if BYTE_PTR = '0' then
                             TOTI_REG (15 downto 8) <= RECV_BYTE;
                           else
                             TOTI_REG ( 7 downto 0) <= RECV_BYTE;
                           end if;
        when "00000100" => null; -- adc is read-only
        when "00000101" => CFG2_REG <= RECV_BYTE;
        when others     => null;
      end case;
    end if;
  end process;

  p_REG_RD :
  process
  begin
    wait until SCL_IN'event and SCL_IN='0';
    if  NEXT_STATE=RD_DATA then
      case AP_REG is
        when "00000000" => if BYTE_PTR = '0' then
                             XMIT_BYTE <= TEMP_REG (15 downto 8);
                           else
                             XMIT_BYTE <= TEMP_REG (7 downto 0);
                           end if;
        when "00000001" => XMIT_BYTE <= CFG_REG;
        when "00000010" => if BYTE_PTR = '0' then
                              XMIT_BYTE <= THYST_REG(15 downto 8);
                           else
                              XMIT_BYTE <= THYST_REG( 7 downto 0);
                           end if;
        when "00000011" => if BYTE_PTR = '0' then
                              XMIT_BYTE <= TOTI_REG (15 downto 8);
                           else
                              XMIT_BYTE <= TOTI_REG ( 7 downto 0);
                           end if;
        when "00000100" => if BYTE_PTR = '0' then
                             XMIT_BYTE <= ADC_REG  (15 downto 8);
                           else
                             XMIT_BYTE <= ADC_REG  (7  downto 0);
                           end if;
        when "00000101" => XMIT_BYTE <= CFG2_REG;
        when others     => XMIT_BYTE <= "XXXXXXXX";
      end case;
    end if;
  end process;
      

--==========================================================================================================--

end SIM;
--========================================= END OF I2C_ADC ===============================================--
