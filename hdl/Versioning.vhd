--------------------------------------------------------------------------------        
-- Company: <Name>                                                                      
--                                                                                      
-- File: Versioning.vhd                                                                 
-- File history:                      
--      1.20160404.1500: Version updated                                                  
--      1.20160114.1200: Prima release                                                  
--                                                                                      
-- Description:                                                                         
--                                                                                      
-- Version handler                                                                      
--                                                                                      
-- Targeted device: <Family::IGLOO2> <Die::M2GL090T> <Package::676 FBGA>                
-- Author: <Name>                                                                       
--                                                                                      
--------------------------------------------------------------------------------        
                                                                                        
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;                                                        
                                                                                        
entity Versioning is                                                                    
port (                                          
    CLK : IN std_logic;
    Version : OUT std_logic_vector(15 downto 0)                                        
);                                                                                      
end Versioning;                                                                         
architecture architectureVersionContanting of Versioning is 
---------------------------------------------------------------------------------------                                  
---------------------------- Firmware version setting ---------------------------------                                
---------------------------------------------------------------------------------------                                
constant    VersionContant : std_logic_vector(27 downto 0):= x"1802081"; -- Modificato TIMEOUT GBTX e CONET-TEMP
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1802080"; -- Aggiornati tempi LOOP CONET-TEMP
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1802070"; -- Tolto DebugTest da I2CSFPTEMPctrl e VERSION e TESTSIGNL da GBTX_CTRL  
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1802062"; -- Tolto DebugTest da I2CSFPTEMPctrl e VERSION e TESTSIGNL da GBTX_CTRL  
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1802061"; -- Aggiunto blocco selettivo con errore (ripristino funzioni cancellate)
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1801250"; -- Aggiunto registro SFPvolt, spostato DebugTest in AUX_CTRL         
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1801230"; -- Correzione messaggio di errore errato                               
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1801190"; -- Correzioni precedente versione                               
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1801182"; -- Nuovi codici errore e loop SFPTEMP temporizzato correttamente
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1801151"; -- Nuovi codici errore       
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1712271"; -- Controllo clock           
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1712051"; -- 12mA SDA SCL SFP Test. Tolta linea POWER definitivamente           
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1711231"; -- 4mA SDA SCL SFP Test           
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1711222"; -- Timeout completo in SFP        
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1711221"; -- Timeout completo in SFP        
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1711212"; -- Modifiche alla gestione errore in SFP        
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1711131"; -- Correzione segnale non nella sensitivity list
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1709281"; -- Correzione segnale non nella sensitivity list
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1709210"; -- More modifications
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1708280"; -- More modifications
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1707030"; -- Registers for GBTX I2C modifications
--nstant    VersionContant : std_logic_vector(27 downto 0):= x"1705240"; 
-------------------------------------------------------------- yymmddn ----------------                                     
---------------------------------------------------------------------------------------                                  
-- 16 bit number YEAR,MONTH.DAY.TAG ---------- year  | month  |   day   | number 
-- Version : std_logic_vector(15 downto 0) := "0111" & "0011" & "01111" & "000";
---------------------------------------------------------------------------------------
begin                                                                                   
    Version_handler : process(CLK)
	variable vYear :  std_logic_vector(7 downto 0);                                        
	variable vMonth : std_logic_vector(7 downto 0);                                        
	variable vDay :   std_logic_vector(7 downto 0);                                        
	variable vNum :   std_logic_vector(3 downto 0);                                         
    begin
        if CLK'event and CLK='1' then
            case VersionContant(11 downto 8) is
            when X"0" => vDay := (VersionContant(11 downto 4) and X"0F");
            when X"1" => vDay := (VersionContant(11 downto 4) and X"0F") + x"0A";                                                                                    
            when X"2" => vDay := (VersionContant(11 downto 4) and X"0F") + x"14";                                                                                    
            when X"3" => vDay := (VersionContant(11 downto 4) and X"0F") + x"1E";   
            when others => vDay := x"FF";
            end case;                                                                                 
    ---------------------------------------------------------
            case VersionContant(19 downto 16) is
            when X"0" => vMonth := (VersionContant(19 downto 12) and X"0F");
            when X"1" => vMonth := (VersionContant(19 downto 12) and X"0F") + x"0A";                                                                                    
            when others => vMonth := x"FF";
            end case;                                                                                 
    ---------------------------------------------------------
            case VersionContant(27 downto 24) is
            when X"1" => vYear := (VersionContant(27 downto 20) and X"0F") - x"04";  -- 2015=1, 2016=2, 2017=3...                                                                                  
            when X"2" => vYear := (VersionContant(27 downto 20) and X"0F") - x"1A";                                                                                    
            when others => vYear := x"FF";
            end case;
    ---------------------------------------------------------
            vNum := VersionContant(3 downto 0) and x"7";
---------------------------------------------------------
            Version <= vYear(3 downto 0) & vMonth(3 downto 0) & vDay(4 downto 0) & vNum(2 downto 0);
        end if;
    end process;                                                                                    
end architectureVersionContanting;                                                            