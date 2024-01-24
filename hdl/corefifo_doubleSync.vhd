-- ********************************************************************/
-- Actel Corporation Proprietary and Confidential
--  Copyright 2011 Actel Corporation.  All rights reserved.
--
-- ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN
-- ACCORDANCE WITH THE ACTEL LICENSE AGREEMENT AND MUST BE APPROVED
-- IN ADVANCE IN WRITING.
--
-- Description: doubleSync.v
--               
--
--
-- Revision Information:
-- Date     Description
--
-- SVN Revision Information:
-- SVN $Revision: 4805 $
-- SVN $Date: 2012-06-21 17:48:48 +0530 (Thu, 21 Jun 2012) $
--
-- Resolved SARs
-- SAR      Date     Who   Description
--
-- Notes:
--
-- ********************************************************************/
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;
use     ieee.std_logic_misc.all;

ENTITY I2C_Master_test_FIFO_OUT_corefifo_doubleSync IS
   GENERIC (
      -- --------------------------------------------------------------------------
      -- PARAMETER Declaration
      -- --------------------------------------------------------------------------
      SYNC_RESET                     :  integer := 0;    
      ADDRWIDTH                      :  integer := 3);    
   PORT (
      clk                     : IN std_logic;   
      rstn                    : IN std_logic;   
-- --------------------------------------------------------------------------
-- I/O Declaration
-- --------------------------------------------------------------------------
----------
-- Inputs
----------

      inp                     : IN std_logic_vector(ADDRWIDTH DOWNTO 0);   
----------
-- Outputs
----------

      sync_out                : OUT std_logic_vector(ADDRWIDTH DOWNTO 0));   
END ENTITY I2C_Master_test_FIFO_OUT_corefifo_doubleSync;

ARCHITECTURE translated OF I2C_Master_test_FIFO_OUT_corefifo_doubleSync IS


   -- --------------------------------------------------------------------------
   -- Internal signals
   -- --------------------------------------------------------------------------
   SIGNAL sync_int                 :  std_logic_vector(ADDRWIDTH DOWNTO 0);   
   SIGNAL sync_out_xhdl1           :  std_logic_vector(ADDRWIDTH DOWNTO 0);   
   SIGNAL aresetn                  :  std_logic;   
   SIGNAL sresetn                  :  std_logic;   
   SIGNAL temp_xhdl1              :  std_logic;   
   SIGNAL temp_xhdl2              :  std_logic;   
BEGIN
   temp_xhdl1 <= '1' WHEN (SYNC_RESET = 1) ELSE rstn;
   aresetn <= temp_xhdl1 ;
   temp_xhdl2 <= rstn WHEN (SYNC_RESET = 1) ELSE '1';
   sresetn <= temp_xhdl2 ;

   -- --------------------------------------------------------------------------
   --                               Start - of - Code
   -- --------------------------------------------------------------------------   
   sync_out <= sync_out_xhdl1;

   -- Double synchronization FFs
   
   PROCESS (clk, aresetn)
   BEGIN
      --IF (((NOT aresetn) OR (NOT sresetn)) = '1') THEN
      IF (((NOT aresetn)) = '1') THEN  -- v2.4 -- Removed illegal sresetn, which caused DRC failure for RTG4
         sync_int <= (OTHERS => '0');    
         sync_out_xhdl1 <= (OTHERS => '0');    
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (NOT sresetn = '1') THEN
            sync_int <= (OTHERS => '0');    
            sync_out_xhdl1 <= (OTHERS => '0');    
         ELSE 
            sync_int <= inp;    
            sync_out_xhdl1 <= sync_int;    
      END IF;
      END IF;
   END PROCESS;

END ARCHITECTURE translated;
