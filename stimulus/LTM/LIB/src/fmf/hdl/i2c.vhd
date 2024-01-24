---------------------------------------------------------------------------
---------------------------------------------------------------------------
--
--  Copyright (C) 2004 Free Model Foundry; http://www.FreeModelFoundry.com/
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License version 2 as
--  published by the Free Software Foundation.
--
---------------------------------------------------------------------------    
-- 
--  Company  : HDL Design House, Serbia and Montenegro
--  Project  : I2C
--  Module   :
--
--  Date     : 05.03.2004
--  Ver.     : 1.0
--
--  Author   : J.Bogosavljevic
--  Email    : J-Bogosavljevic@hdl-dh.com
--  Phone    : +381 11 344 23 59
--
--  Customer :
--
---------------------------------------------------------------------------
--
-- Functional description of the module:
-- I2C bus VITAL model
--
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

LIBRARY IEEE;
    USE IEEE.std_logic_1164.ALL;
    USE IEEE.VITAL_timing.ALL;   
    USE IEEE.VITAL_primitives.ALL;
    USE STD.textio.ALL;

LIBRARY FMF;    USE FMF.gen_utils.all;
                USE FMF.conversions.all;
LIBRARY work;
USE work.i2c_drive_ms_pkg.all;

-------------------------------------------------------------------------------
-- ENTITY DECLARATION
-------------------------------------------------------------------------------
ENTITY i2c_device IS
    GENERIC (
        -- tipd delays: interconnect path delays
        tipd_SDA         : VitalDelayType01 := VitalZeroDelay01;
        tipd_SCL         : VitalDelayType01 := VitalZeroDelay01;

        --tpd, tsetup, thold delays
        -- tHD;STA 4us, 0.6us, 160ns
        thold_scl_sda            : VitalDelayType := UnitDelay;
        -- tSU;STA 4.7us, 0.6us, 160ns
        tsetup_scl_sda_noedge_negedge   : VitalDelayType := UnitDelay;
        -- tHD;DAT 300ns, 300ns,
        -->20 ns (3mA current source and 400 pF load)
        --> 10 ns (load 10-100 pF)
        thold_sda_scl            : VitalDelayType := UnitDelay;
        -- tSU;DAT 250ns, 100ns, 10ns
        tsetup_sda_scl           : VitalDelayType := UnitDelay;
        -- tSU;STO 4.0us, 0.6us, 160ns
        tsetup_scl_sda_noedge_posedge   : VitalDelayType := UnitDelay;

        tpw_SCL_negedge: VitalDelayType := UnitDelay;
        tpw_SCL_posedge: VitalDelayType := UnitDelay;

        -- tdevice values: values for internal delays
        -- 1.3 us for fast mode
        -- 4.7 us for fast mode
        tdevice_tbuff             : VitalDelayType    := 1.3 us;
        -- glitch suppresion
        tdevice_tgsp              : VitalDelayType    := 1.3 us;

        -- generic control parameters
        InstancePath        : STRING    := DefaultInstancePath;
        TimingChecksOn      : BOOLEAN   := DefaultTimingChecks;
        MsgOn               : BOOLEAN   := DefaultMsgOn;
        XOn                 : BOOLEAN   := DefaultXon;
        -- For FMF SDF technology file usage
        TimingModel         : STRING    := DefaultTimingModel;

        --i2c specific generics
        Device_id           : STRING    := "none";
        -- if device can be master
        MASTER_gen          : BOOLEAN   := TRUE;
        -- true if device can be slave
        SLAVE_gen           : BOOLEAN   := TRUE;
        -- if device is hadrware master
        HARD_MASTER_gen     : BOOLEAN   := TRUE;
        -- true if device will response on general call procedure
        GENERAL_CALL_gen    : BOOLEAN   := TRUE;
        -- slave addresse
        SLAVE_ADDR_gen      : std_logic_vector(9 downto 0):= (OTHERS => 'U');
        -- zero if slave address is not programable
        -- else number of programable bits
        PROGRAMABLE_S_A_gen : INTEGER   := 0;
        -- programable part of slave address
        PPART_SLAVE_ADDR_gen: std_logic_vector(9 downto 0) := (OTHERS => 'U');
        Listen_hard_master_gen : BOOLEAN := FALSE;
        -- CLK high pulse width
        T_high_gen          : time := 4 us ;
        -- CLK low pulse width
        T_low_gen           : time := 4.7 us;
        -- true if device can work in HS mode
        HS_mode_gen         : BOOLEAN   := TRUE;
        -- true if device can work in CBUS mode
        CBUS_mode_gen       : BOOLEAN   := FALSE;
        -- master code if device can work in HS mode
        MASTER_CODE_gen     : std_logic_vector(7 downto 0) := "00001XXX";
        --RESET signal pulse width, general call proc
        t_reset             : time  := 1 ns
    );
    PORT (
        SDA            : INOUT std_ulogic := 'U';
        SCL            : INOUT std_ulogic := 'U'
    );
    ATTRIBUTE VITAL_LEVEL0 of i2c_device : ENTITY IS TRUE;
END i2c_device;

-------------------------------------------------------------------------------
-- ARCHITECTURE DECLARATION
-------------------------------------------------------------------------------
ARCHITECTURE vhdl_behavioral of i2c_device IS
    ATTRIBUTE VITAL_LEVEL0 of vhdl_behavioral : ARCHITECTURE IS TRUE;

    CONSTANT PartID           : STRING  := "i2c";--and SLAVE_ADDR

    --other CONSTANTS
    CONSTANT GEN_CALL        : std_logic_vector(7 downto 0) := "00000000";
    CONSTANT START_BYTE      : std_logic_vector(7 downto 0) := "00000001";
    CONSTANT CBUS_MODE       : std_logic_vector(6 downto 0) := "0000001";
    CONSTANT HS_MODE_C       : std_logic_vector(4 downto 0) := "00001";
    CONSTANT BIT10_ADDR_C    : std_logic_vector(4 downto 0) := "11110";

    --size of slave memory
    CONSTANT MemSize         : INTEGER := 15;
    -- interconnect path delay signals
    SIGNAL SDA_ipd           : std_ulogic := 'U';
    SIGNAL SCL_ipd           : std_ulogic := 'U';

    ---  internal delays
    SIGNAL tbuff_in          : std_ulogic := '0';
    SIGNAL tbuff_out         : std_ulogic := '0';
BEGIN

    ---------------------------------------------------------------------------
    -- Internal Delays
    ---------------------------------------------------------------------------
    -- Artificial VITAL primitives to incorporate internal delays
    TBUFF : VitalBuf(tbuff_out, tbuff_in, (tdevice_tbuff, UnitDelay));
    ---------------------------------------------------------------------------
    -- Wire Delays
    ---------------------------------------------------------------------------
    WireDelay : BLOCK
    BEGIN
        w_0  : VitalWireDelay (SDA_ipd, SDA, tipd_SDA);
        w_1  : VitalWireDelay (SCL_ipd, SCL, tipd_SCL);
    END BLOCK;

    ---------------------------------------------------------------------------
    -- Main Behavior Block
    ---------------------------------------------------------------------------
    Behavior: BLOCK

        PORT (
            SDAin   : IN    std_logic  := 'U';
            SCLin   : IN    std_logic  := 'U';
            SDAout  : OUT   std_ulogic := 'Z';
            SCLout  : OUT   std_ulogic := 'Z'
        );
        PORT MAP (
            SDAin    => SDA_ipd,
            SCLin    => SCL_ipd,
            SDAout   => SDA,
            SCLout   => SCL
        );
    -- State Machine for master : State_Type_m
    TYPE state_type_m IS (
                            IDLE,
                            M_INIT,
                            M_SECOND,-- second byte for general call
                            M_BIT10_ADDR,-- second byte for 10 bit addressing
                            --M_CBUS,-- device in CBUS mode
                            M_WRITE,-- write slave
                            M_READ--read slave
                            );
    -- State Machine for slave: State_Type_s
    TYPE state_type_s IS (
                            IDLE,
                            S_INIT,-- init slave
                            S_BIT10_ADDR,
                            S_SECOND,-- general call proc
                            S_WRITTEN,-- slave is written by master
                            S_READ-- slave is written by master
                            );
    --other types
    TYPE MemArray IS ARRAY (0 TO MemSize) OF
                           INTEGER RANGE 0 TO 16#FF#;

    -- states
    SIGNAL current_state_m    : state_type_m;
    SIGNAL next_state_m       : state_type_m;
    SIGNAL current_state_s    : state_type_s;
    SIGNAL next_state_s       : state_type_s;

    --zero delay signals
    SIGNAL SDA_zd          : std_logic := 'Z';
    SIGNAL SDA_zd_m          : std_logic := 'Z';
    SIGNAL SDA_zd_s          : std_logic := 'Z';
    SIGNAL SCL_zd          : std_logic := 'Z';
    SIGNAL SDA_z           : std_logic := 'Z';
    SIGNAL SCL_z           : std_logic := 'Z';
    -- delayed SDA
    SIGNAL SDA_d : std_logic := 'Z';
    SIGNAL SDA_in : std_logic := '1';
    SIGNAL SCL_in : std_logic := '1';

    --FSM and device control signals
    SIGNAL bit10_addr_m      : std_logic := '0';
    SIGNAL hs_mode_m         : std_logic := '0';
    SIGNAL bit10_addr_s      : std_logic := '0';
    SIGNAL hs_mode_s         : std_logic := '0';

    SIGNAL cs                : std_logic := '0';

    SIGNAL start             : std_logic := '0';
    SIGNAL stop              : std_logic := '0';
    SIGNAL my_bus            : std_logic := '0';
    SIGNAL arb_lost          : std_logic := '0';
    SIGNAL busy              : std_logic := '0';
    SIGNAL slave_addr        : std_logic_vector(9 downto 0) := (OTHERS => 'U');
    SIGNAL RESET             : std_logic := '0';
    --SIGNAL t_RESET           : time := ;
    -- control signals to restore slave address (hardware, software or dump)
    SIGNAL hard_addr         : std_logic := '0';
    SIGNAL soft_addr         : std_logic := '0';
    SIGNAL load_addr         : std_logic := '0';

    SIGNAL mode              : CHARACTER := 's';
    SIGNAL hs_mode           : std_logic := '0';

    -- if device is hardware master that is in slave-receiver mode
    -- after power-up, signal hard_mast_addressed is set to '1' after
    -- writting dump address to this hardware master. After hard_mast_addressed
    -- is set to '1' this hardware master can not be programmed
    SIGNAL hard_mast_addressed: std_logic := '0';

    --set from input file
    -- true if MASTER addresses a slave
    SIGNAL address_some_slave : BOOLEAN := FALSE;
    -- TRUE if slave is enabled to response
    SIGNAL en_sl_resp         : std_logic := '1';
    -- Master ends write, buffer is empty
    SIGNAL end_of_write       : std_logic := '1';
    -- initiate new bus request
    SIGNAL next_req           : std_logic := '0';
    --hs mode must be rejected if HS_NODE_GEN = FALSE
    -- number of bytes to read
    SIGNAL rd_cnt             : NATURAL   := 1;

    -- value to output on bus
    SIGNAL buff               : std_logic_vector(7 downto 0) := (OTHERS => '0');


    -- control signal to load rd_cnt
    SIGNAL load_rd_cnt        : std_logic := '0';
    -- load rd_cnt with rd_value
    SIGNAL rd_value           : NATURAL := 0;
    -- slave delays CLK for delay_value
    SIGNAL delay_value        : time := 0 ns;
    -- control signal: decrements rd_cnt
    SIGNAL decr_rd_cnt        : std_logic := '0';
    -- MASTER is ready to accept new command
    SIGNAL rdy                : std_logic := '1';
    SHARED VARIABLE out_buff : std_logic_vector(7 downto 0);
    SHARED VARIABLE out_num : INTEGER;
    SHARED VARIABLE SDA_tmp    : std_logic := '1';
    SIGNAL not_first_byte    : BOOLEAN:= FALSE;
    -- clock counter
    SIGNAL clk_cnt        : INTEGER := 0;
    -- active during acknowladge clk
    --SIGNAL ACK            : std_logic := '0';
    -- timing check violation
    SIGNAL Viol                : X01 := '0';

    --timeout signal after T_HIGH, used for clk synchronization
    SIGNAL timeout_high : std_logic := '0';

    SHARED VARIABLE ts_cnt     :   NATURAL RANGE 1 TO 30:= 1;
    SHARED VARIABLE tc_cnt     :   NATURAL RANGE 0 TO 30:= 0;

    ----------------------------------------------
    -- shared variables used in MASTER/SLAVE FSMs
    ----------------------------------------------
    -- buffers initial byte (slave address, general cal,...)
    SIGNAL first_byte_m     : std_logic_vector(9 downto 0) :=
                                                      (OTHERS => '0');
    SIGNAL first_byte_s     : std_logic_vector(9 downto 0) :=
                                                      (OTHERS => '0');

    -- buffers second byte for genereal call procedure
    SIGNAL second_byte_s    : std_logic_vector(7 downto 0) :=
                                                      (OTHERS => '0');
    SIGNAL buf_loaded       : std_logic := '0';
    -- buffers data written to master/slave

    -- read or write operation in progress
    SHARED VARIABLE rnw_m            : std_logic := 'U';

    -- 7th bit of second byte in general call procedure
    SHARED VARIABLE B_bit_m          : std_logic := 'U';
--    SHARED VARIABLE B_bit_s          : std_logic := 'U';
    --slave and master memories, written/read data are stored here
    SHARED VARIABLE slv_mem          : MemArray := (OTHERS=> 0);
    SHARED VARIABLE mast_mem         : MemArray := (OTHERS=> 0);
    -- write pointer
    SHARED VARIABLE s_p              : INTEGER RANGE 0 TO MemSize := 0;
    -- read pointer
    SHARED VARIABLE s_p_rd           : INTEGER RANGE 0 TO MemSize := 0;
    SHARED VARIABLE m_p              : INTEGER RANGE 0 TO MemSize := 0;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--FUNCTIONS AND PROCEDURES
-------------------------------------------------------------------------------
    PROCEDURE Drive(
                           SIGNAL SDA_zd : INOUT std_logic;
                           VARIABLE num  : INOUT NATURAL
                   ) IS
    BEGIN
        SDA_zd <= buff(num);
        --i := ((i-1)+8) MOD 8;
        num := (num+7) MOD 8;
    END Drive;

    PROCEDURE Drive_slave_addr(
                           SIGNAL SDA_zd     : INOUT std_logic;
                           SIGNAL slave_addr : IN std_logic_vector(9 downto 0);
                           VARIABLE num      : INOUT NATURAL
                   ) IS
    VARIABLE num_local : INTEGER := 0;
    BEGIN
    num_local := num - 1;
    -- only slave_addr(7 downto 0) are output
        IF num_local < 0 THEN
        -- B bit
            SDA_zd <= '1';
        ELSE
            SDA_zd <= slave_addr(num_local);
        END IF;
        num := (num+7) MOD 8;
    END Drive_slave_addr;


    PROCEDURE Drive_slave(
                           SIGNAL SDA_zd : INOUT std_logic;
                           VARIABLE num  : INOUT NATURAL
                   ) IS
    VARIABLE tmp_buff : std_logic_vector(7 downto 0);
    BEGIN
        tmp_buff := to_slv(slv_mem(s_p_rd), 8);
        out_num := num;
        out_buff := tmp_buff;
        SDA_zd <= tmp_buff(num);
        --i := ((i-1)+8) MOD 8;
        IF num = 0 THEN
            s_p_rd := (s_p_rd +1) MOD (MemSize+1);
        END IF;
        num := (num+7) MOD 8;
    END Drive_slave;

    PROCEDURE Drive_rdy(
                           SIGNAL rdy       : INOUT std_logic;
                           SIGNAL clk_cnt   : IN INTEGER
                   ) IS
    BEGIN
        IF clk_cnt = 8 THEN
            rdy <= '1';
        ELSE
            rdy <= '0';
        END IF;
    END Drive_rdy;


    PROCEDURE Store(
                  VARIABLE Load_buf  : INOUT std_logic_vector(7 downto 0);
                  CONSTANT master    : BOOLEAN
--                  SIGNAL load_addr_l : INOUT std_logic
                   ) IS
    BEGIN
        IF master = TRUE THEN
            mast_mem(m_p) := to_nat(Load_buf);
            m_p := (m_p+1) MOD (MemSize+1);
        ELSE
            slv_mem(s_p) := to_nat(Load_buf);
            s_p := (s_p+1) MOD (MemSize+1);
        END IF;
    END Store;
    PROCEDURE SetSDA(
                     SIGNAL SDA_zd : INOUT std_logic
                   ) IS
    BEGIN
        IF next_req = '1' THEN
        -- prepare for RESTART
            SDA_zd <= '1';
        ELSE
        -- prepare for STOP
            SDA_zd <= '0';
        END IF;
    END SetSDA;

    --------------------------------------------------------------------------
    -- PROCEDURE to select TC
    --------------------------------------------------------------------------
    PROCEDURE   Pick_TC
        (
         VARIABLE ts_cnt   :  INOUT NATURAL RANGE 1 TO 30;
         VARIABLE tc_cnt   :  INOUT NATURAL RANGE 0 TO 30 )
    IS
    BEGIN
        IF TC_cnt < tc(TS_cnt) THEN
            TC_cnt := TC_cnt+1;
        ELSE
            TC_cnt:=1;
            IF TS_cnt < 30 THEN
                TS_cnt := TS_cnt+1;
            ELSE
                -- end test
                WAIT;
            END IF;
        END IF;
    END PROCEDURE Pick_TC;

   ---------------------------------------------------------------------------
    --procedure to decode commands into specific MASTER/SLAVE command sequence
    ---------------------------------------------------------------------------
    PROCEDURE command_decode
        (   command                   :   IN  cmd_rec;
            VARIABLE current_time     : IN TIME;
            SIGNAL buff               : INOUT std_logic_vector(7 downto 0);
            SIGNAL end_of_write       : INOUT std_logic;
            SIGNAL next_req           : INOUT std_logic;
            SIGNAL load_rd_cnt        : INOUT std_logic;
            SIGNAL rd_value           : INOUT NATURAL;
            SIGNAL delay_value        : INOUT time;
            SIGNAL en_sl_resp         : INOUT std_logic;
            SIGNAL address_some_slave : INOUT BOOLEAN

            )
    IS
    VARIABLE tmp      :std_logic_vector(7 downto 0) := (OTHERS => '0');
    VARIABLE tmp_time : TIME;
    VARIABLE i        : NATURAL := 0;
    BEGIN

            IF command.cmd = idle AND
               (command.device_id(7 downto 1) = "all_dev" OR
                command.device_id = Device_id)
                THEN
                --IF my_bus = '1' THEN
                --    WAIT UNTIL rdy = '1' OR my_bus = '0';--AND rdy'EVENT;
                --END IF;
                tmp_time := NOW;
                next_req <= '0';
                end_of_write <= '1';
                en_sl_resp <= '1';
                WAIT FOR (command.wtime - tmp_time);--current_time);
            END IF;

        IF  command.device_id = Device_id THEN
            rd_value <= 1;
            delay_value <= 0 ns;
                next_req <= '0';
            CASE command.cmd IS
            WHEN    none        =>
                IF my_bus = '1' THEN
                    WAIT UNTIL rdy = '1' OR my_bus = '0';--AND rdy'EVENT;
                END IF;

                next_req <= '1';
                end_of_write <= '1';
                IF my_bus = '1' THEN
                    WAIT UNTIL rdy = '1' OR my_bus = '0';--AND rdy'EVENT;
                END IF;

            WHEN    req_bus        =>
            IF my_bus = '1' OR busy = '0' THEN
                --IF my_bus = '1' THEN
                --    WAIT UNTIL rdy = '1' OR my_bus = '0';--AND rdy'EVENT;
                --END IF;

                tmp := to_slv(command.wr_byte,8);
                -- not HS mode request
                IF  (tmp(7 downto 3) /= HS_MODE_C) THEN
                    address_some_slave <= (
                        (tmp(7 downto 4)) /= "0000" AND
                        (tmp(7 downto 4)) /= "1111"
                        );
                    next_req <= '1';
                    IF HARD_MASTER_gen = TRUE THEN
                    -- general call procedure
                        buff <= "00000000";
                    ELSE
                        buff <= to_slv(command.wr_byte,8);
                    END IF;
                    end_of_write <= '1';
                load_rd_cnt <= '1', '0' AFTER 1 ns;
                rd_value <= 1;--command.rd_byte_num;

                -- HS mode request
                ELSIF HS_MODE_gen = TRUE THEN
                    address_some_slave <= NOT(
                        (buff(7 downto 4)) = "0000" OR
                        (buff(7 downto 4)) = "1111"
                        );
                    next_req <= '1';
                    buff <= MASTER_CODE_gen;
                    end_of_write <= '0';

                END IF;
                wait for command.wtime;
                WAIT UNTIL ((rdy = '1' AND rdy'EVENT) OR my_bus = '0');
                IF command.rd_byte_num = 1 THEN
                    WAIT UNTIL ((rdy = '1' AND rdy'EVENT) OR my_bus = '0');
                END IF;
            END IF;

            WHEN    write        =>
            IF my_bus = '1' OR busy = '0' THEN
                IF (
                    (buff(7 downto 4)) = "0000" OR
                    (buff(7 downto 4)) = "1111"
                    ) THEN
                    address_some_slave <= FALSE;
                ELSE
                    address_some_slave <= TRUE;
                END IF;
                buff <= to_slv(command.wr_byte,8);
                next_req <= '0';
                end_of_write <= '0';
                WAIT UNTIL ((rdy = '1' AND rdy'EVENT) OR my_bus = '0');
            END IF;
            WHEN    read        =>
            IF my_bus = '1' OR busy = '0' THEN
                --buff <= to_slv(command.wr_byte,8);
                next_req <= '0';
                load_rd_cnt <= '1', '0' AFTER 1 ns;
                rd_value <= command.rd_byte_num;
                end_of_write <= '1';
                FOR i IN 0 TO command.rd_byte_num-1 LOOP
                --WHILE i < (command.rd_byte_num) LOOP
                    WAIT UNTIL ((rdy = '1' AND rdy'EVENT) OR my_bus = '0');
                  --  i := i+1;
                END LOOP;
            END IF;
            WHEN    delay_clk        =>
                --buff <= to_slv(command.wr_byte,8);
                next_req <= '0';
                load_rd_cnt <= '1', '0' AFTER 1 ns;
                rd_value <= command.rd_byte_num;
                delay_value <= command.wtime;
                end_of_write <= '1';

            WHEN    dis_sl_resp        =>
                tmp := to_slv(command.wr_byte, 8);
                --tmp_time := NOW;
                --WAIT FOR (command.wtime - tmp_time);--current_time);
                en_sl_resp <= tmp(0);
                end_of_write <= '1';
                WAIT FOR command.wtime;

            WHEN OTHERS => null;

           END CASE;
        END IF;
    END PROCEDURE command_decode;

    BEGIN
        hard_addr <= '1', '0' AFTER 1 ns;--WHEN GENERAL_CALL_gen = FALSE ELSE
                     --'0';
        hs_mode <= hs_mode_m OR hs_mode_s;
        mode <= 's' WHEN (T_LOW_gen >= 4.7 us AND T_HIGH_gen >= 4.0 us) ELSE
                'f' WHEN (T_LOW_gen >= 1.3 us AND T_HIGH_gen >= 0.6 us) ELSE
                --Cp = 100 pF
                'h';-- WHEN (T_LOW_gen >= 160 ns AND T_HIGH_gen >= 60 ns)
        SDA_in <= '1' AFTER tdevice_tgsp WHEN SDA /= '0' ELSE
                  '0' AFTER tdevice_tgsp;
        SCL_in <= '1' AFTER tdevice_tgsp WHEN SCL /= '0' ELSE
                  '0' AFTER tdevice_tgsp;

   ----------------------------------------------------------------------------
    --Power Up time 100 ns;
    ---------------------------------------------------------------------------
--    PoweredUp <= '1' AFTER 100 ns;

--    RST <= RESETNeg AFTER 500 ns;

    ---------------------------------------------------------------------------
    -- VITAL Timing Checks Procedures
    ---------------------------------------------------------------------------
    VITALTimingCheck: PROCESS(SDA, SCL)
         -- Timing Check Variables

        VARIABLE TD_SCL_SDA               : VitalTimingDataType;
        VARIABLE Tviol_SLC_SDA            : X01 := '0';
        VARIABLE TD_SCL_SDA_negedge       : VitalTimingDataType;
        VARIABLE Tviol_SCL_SDA_negedge    : X01 := '0';
        VARIABLE TD_SDA_SCL_negedge       : VitalTimingDataType;
        VARIABLE Tviol_SDA_SCL_negedge    : X01 := '0';
        VARIABLE TD_SDA_SCL_posedge       : VitalTimingDataType;
        VARIABLE Tviol_SDA_SCL_posedge    : X01 := '0';
        VARIABLE TD_SCL_SDA_posedge       : VitalTimingDataType;
        VARIABLE Tviol_SCL_SDA_posedge    : X01 := '0';
        VARIABLE PD_SCL      : VitalPeriodDataType := VitalPeriodDataInit;
        VARIABLE Pviol_SCL                : X01 := '0';
        VARIABLE Violation                : X01 := '0';

    BEGIN
    ----------------------------------------------------------
    -- Timing Check Section
    ---------------------------------------------------------------------------
    IF (TimingChecksOn) THEN

        -- tHD;STA 4us, 0.6us, 160ns
        VitalSetupHoldCheck (
            TestSignal      => SCL,
            TestSignalName  => "SCL",
            RefSignal       => SDA,
            RefSignalName   => "SDA",
            HoldHigh        => thold_SCL_SDA,
            -- always enabled in HS mode
            CheckEnabled    => mode = 'h' OR
            -- in s/f mode enabled only if hs-mode is not active
                              ((mode = 's' OR mode = 'f') AND hs_mode = '0'),
            RefTransition   => '\',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_SCL_SDA,
            Violation       => Tviol_SLC_SDA
        );

        -- tSU;STA 4.7us, 0.6us, 160ns
        VitalSetupHoldCheck (
            TestSignal      => SCL,
            TestSignalName  => "SCL",
            RefSignal       => SDA,
            RefSignalName   => "SDA",
            SetupHigh       => tsetup_scl_sda_noedge_negedge,
            -- always enabled in HS mode
            CheckEnabled    => mode = 'h' OR
            -- in s/f mode enabled only if hs-mode is not active
                              ((mode = 's' OR mode = 'f') AND hs_mode = '0'),
            RefTransition   => '\',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_SCL_SDA_negedge,
            Violation       => Tviol_SCL_SDA_negedge
        );
        -- tHD;DAT 300ns, 300ns,
        -->20 ns (3mA current source and 400 pF load)
        --> 10 ns (load 10-100 pF)
        VitalSetupHoldCheck (
            TestSignal      => SDA,
            TestSignalName  => "SDA",
            RefSignal       => SCL,
            RefSignalName   => "SCL",
            HoldHigh        => thold_SDA_SCL,
            HoldLow         => thold_SDA_SCL,
            CheckEnabled    => TRUE,-- current_state = S_INIT OR cs = '1'
            RefTransition   => '\',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_SDA_SCL_negedge,
            Violation       => Tviol_SDA_SCL_negedge
        );

        -- tSU;DAT 250ns, 100ns, 10ns
        VitalSetupHoldCheck (
            TestSignal      => SDA,
            TestSignalName  => "SDA",
            RefSignal       => SCL,
            RefSignalName   => "SCL",
            SetupHigh       => tsetup_SDA_SCL,
            SetupLow        => tsetup_SDA_SCL,
            CheckEnabled    => TRUE,-- current_state = S_INIT OR cs = '1'
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_SDA_SCL_posedge,
            Violation       => Tviol_SDA_SCL_posedge
        );
        -- tSU;STO 4.0us, 0.6us, 160ns
        VitalSetupHoldCheck (
            TestSignal      => SCL,
            TestSignalName  => "SCL",
            RefSignal       => SDA,
            RefSignalName   => "SDA",
            SetupHigh       => tsetup_scl_sda_noedge_posedge,
            CheckEnabled    => TRUE,-- current_state = S_INIT OR cs = '1'
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_SCL_SDA_posedge,
            Violation       => Tviol_SCL_SDA_posedge
        );

-----------------------
--pulse width checkers
------------------------
        -- PulseWidth Check for REset
        VitalPeriodPulseCheck (
            TestSignal        => SCL,
            TestSignalName    => "SCL",
            PulseWidthLow     => tpw_SCL_negedge,
            PulseWidthHigh    => tpw_SCL_posedge,
            CheckEnabled      => TRUE,
            HeaderMsg         => InstancePath & PartID,
            PeriodData        => PD_SCL,
            Violation         => Pviol_SCL
        );

        Violation :=
            Tviol_SLC_SDA OR
            Tviol_SCL_SDA_negedge OR
            Tviol_SDA_SCL_negedge OR
            Tviol_SDA_SCL_posedge OR
            Tviol_SCL_SDA_posedge OR
            Pviol_SCL;
        Viol <= Violation;

        ASSERT Violation = '0'
            REPORT InstancePath & partID & ": simulation may be" &
                    " inaccurate due to timing violations"
            SEVERITY WARNING;
    END IF;
    END PROCESS VITALTimingCheck;

    ---------------------------------------------------------------------------
    --Spike Protection: Inertial Delay does not propagate pulses <
    ---------------------------------------------------------------------------
    --gWE_n   <= WENeg   AFTER 5 ns;

    ---------------------------------------------------------------------------
    --Process that reports warning when changes on signals WE#, CE#, OE# are
    --discarded
    ---------------------------------------------------------------------------
--    PulseWatch : PROCESS (WENeg, CENeg, OENeg, gWE_n, gCE_n, gOE_n)
--    BEGIN
--        IF (WENeg'EVENT AND WENeg = gWE_n) THEN
--            ASSERT false
--                REPORT "Glitch detected on write control signals"
--                SEVERITY warning;
--        END IF;

--    END PROCESS PulseWatch;

    Restore_slave_addr: PROCESS(hard_addr, soft_addr, load_addr)
    VARIABLE tmp : std_logic_vector(7 downto 0);
    BEGIN
        IF rising_edge(hard_addr) THEN
            slave_addr <= SLAVE_ADDR_gen;
        ELSIF rising_edge(soft_addr) THEN
            FOR i IN 0 TO 9 LOOP
                IF SLAVE_ADDR_gen(i) /= 'U' THEN
                    slave_addr(i) <= SLAVE_ADDR_gen(i);
                ELSIF PPART_SLAVE_ADDR_gen(i) /= 'U' THEN
                    slave_addr(i) <= PPART_SLAVE_ADDR_gen(i);
                END IF;
            END LOOP;
            -- if hardware master is intitialized through general call
            hard_mast_addressed <= '1';
        -- writting dump address to hardware master
        ELSIF rising_edge(load_addr) THEN
            tmp := to_slv(slv_mem(0), 8);
            slave_addr(9 downto 0) <= "UUU" & tmp(7 downto 1);
            hard_mast_addressed <= '1';
        END IF;
    END PROCESS;


    ---------------------------------------------------------------------------
    --Latch SDA on falling edge of SCL
    ---------------------------------------------------------------------------
    BusCycleDecode : PROCESS(SCL_in)
    BEGIN
        IF falling_edge(SCL_in) THEN
            SDA_tmp := SDA_in;
        END IF;
        --IF rising_edge(SCL_in) THEN -- LCOL DEBUG
        --    SDA_tmp := SDA_in;
        --END IF;
    END PROCESS BusCycleDecode;

    ---------------------------------
    -- detects START condition
    ---------------------------------
    start_proc: PROCESS(SDA_in, SCL_in)
    BEGIN
        IF falling_edge(SDA_in) AND SCL_in /= '0' THEN
            start <= '1', '0' AFTER 1 ns;
        --ELSIF falling_edge(SCL_in) THEN
        --    start <= '0';
        END IF;
    END PROCESS start_proc;

    ---------------------------------
    -- detects STOP condition
    ---------------------------------
    stop_proc: PROCESS(SDA_in, SCL_in)
    BEGIN
        IF rising_edge(SDA_in) AND SCL_in /= '0' THEN
            stop <= '1' AFTER tdevice_tbuff,
                    '0' AFTER tdevice_tbuff + 1 ns;
            --IF (start = '1') THEN
            --    Report("Void command is illegal");
            --END IF;
        --ELSIF falling_edge(SCL_in) THEN
            --stop <= '0';
        END IF;
    END PROCESS stop_proc;

    ----------------------------------------
    -- if START is asserted by this device
    ---------------------------------------
    my_bus_proc: PROCESS(start, SDA_zd, stop, SDA_in, SCL_in, arb_lost)
    BEGIN
        IF start = '1' AND SDA_zd = '0' THEN
            my_bus <= '1';
        -- stop condition detected
        ELSIF stop = '1' THEN
            my_bus <= '0';
        --or lost arbitration
        ELSIF arb_lost = '1' THEN
            my_bus <= '0';
        -- local stop, this device ends transfer
        ELSIF my_bus = '1' AND SCL_in /= '0' AND
              SDA_in = '0' AND rising_edge(SDA_zd) THEN
            my_bus <= '0';
        END IF;
    END PROCESS my_bus_proc;

    ---------------------------------
    -- bus busy
    ---------------------------------
    bus_busy_proc: PROCESS(start, stop)
    BEGIN
--        IF falling_edge(start) THEN
--            -- stop and start are not genereted during same SCL high period
--            IF (stop = '0') THEN
--                busy <= '1';
--            ELSE
--            -- stop and start are genereted during same SCL high period
--                IF SDA_in = '0' THEN
--                -- restart condition is last
--                    busy <= '1';
--                ELSE
--                -- stop condition is last, this is illegal
--                    busy <= '0';
--                END IF;
--            END IF;
        IF start = '1' THEN
            busy <= '1';
        ELSIF stop = '1' THEN
            busy <= '0';
        END IF;
    END PROCESS bus_busy_proc;

    clk_cnt_proc: PROCESS(start, stop, SCL_in)
    BEGIN
        IF (start = '1' )--AND busy = '0')-- not restart
         OR stop = '1' THEN
            clk_cnt <= 0 AFTER 1 ns;
--            ACK <= '0';
        ELSIF falling_edge(SCL_in) THEN
            clk_cnt <= (clk_cnt + 1) MOD 9 AFTER 1 ns;
--            IF clk_cnt = 8 THEN
--                ACK <= '1';
--            ELSE
--                ACK <= '0';
--            END IF;
        END IF;
    END PROCESS clk_cnt_proc;

--    ACK_gen:PROCESS(clk_cnt)
--    BEGIN
--            IF clk_cnt = 0 THEN
--                ACK <= '1';
--            ELSE
--                ACK <= '0';
--            END IF;
--     END PROCESS;

    clk_synchro: PROCESS(SCL_in, timeout_high, my_bus)
    VARIABLE t_new_timeout_high : TIME := 0 ns;
    BEGIN
        IF (rising_edge(my_bus)) THEN
                SCL_zd <= '0' AFTER 2 us,
                          '1' AFTER T_LOW_gen + 2 us;--tsetup_scl_sda_negedge;
        ELSIF busy = '1' THEN
            IF (cs = '1' OR my_bus = '1') THEN
                t_new_timeout_high := -SCL_in'LAST_EVENT + T_HIGH_gen;
                IF falling_edge(SCL_in) THEN
                    SCL_zd <= '0', '1' AFTER T_LOW_gen;
                ELSIF rising_edge(SCL_in) THEN
                    timeout_high <= '1' AFTER T_HIGH_gen - 1 ns,
                                    '0' AFTER T_HIGH_gen;
                END IF;
                IF (falling_edge(timeout_high)) THEN
                    IF (t_new_timeout_high <= 0 ns) THEN
                        SCL_zd <= '0', '1' AFTER T_LOW_gen;
                    ELSE
                        timeout_high <= '1' AFTER t_new_timeout_high - 1 ns,
                                    '0' AFTER t_new_timeout_high;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    ---------------------------------------------------------------------------
    --rd_cnt: number of words to be read from slave
    ---------------------------------------------------------------------------
    rd_cnt_proc: PROCESS(load_rd_cnt, decr_rd_cnt)
    BEGIN
        IF load_rd_cnt = '1' THEN
            rd_cnt <= rd_value;
        ELSIF decr_rd_cnt = '1' THEN
            rd_cnt <= rd_cnt - 1;
        END IF;
    END PROCESS rd_cnt_proc;

    ---------------------------------------------------------------------------
    --FSM
    ---------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- sequential process for reset control and FSM state transition
    ----------------------------------------------------------------------------
    StateTransition_slave : PROCESS(SCL_in, stop)
    BEGIN
        IF stop = '1' THEN
            current_state_s <= IDLE;
        ELSIF rising_edge(SCL_in) THEN
            current_state_s <= next_state_s;
        END IF;
    END PROCESS StateTransition_slave;

    StateTransition_master : PROCESS(SCL_in, stop)
    BEGIN
        IF stop = '1' THEN
            current_state_m <= IDLE;
        ELSIF rising_edge(SCL_in) THEN
            current_state_m <= next_state_m;
        END IF;
    END PROCESS StateTransition_master;

    ---------------------------------------------------------------------------
    -- Main Behavior Process for slave
    -- combinational process for next state generation
    ---------------------------------------------------------------------------
    StateGen_slave :PROCESS(current_state_s, stop, start, clk_cnt, buf_loaded)
    BEGIN

    IF (rising_edge(stop)) THEN
       next_state_s <= IDLE;

    ELSE
        CASE current_state_s IS
            WHEN IDLE          =>
                IF (-- if device can be slave, and start cond detected
                      SLAVE_gen = TRUE AND start = '1' AND
                    -- if device can work in hs mode, or hs mode is not active
                      (hs_mode_s = '0' OR HS_mode_gen = TRUE) AND
                    -- if device is hardware master that should be written
                      (HARD_MASTER_gen = FALSE OR (hard_mast_addressed = '0'))
                      ) THEN
                    next_state_s <= S_INIT;
                END IF;

            WHEN S_INIT          =>
                IF (clk_cnt = 0 AND buf_loaded = '1') THEN
                --ACK CLK
                    --rnw_s := SDA_tmp;
                    IF (first_byte_s(7 downto 3) = BIT10_ADDR_C) THEN
                        -- read or write req
                        IF (SDA_tmp = '0') THEN
                            IF (slave_addr(9 downto 8) = first_byte_s(2 downto 1)) THEN
                                next_state_s <= S_BIT10_ADDR;
                            ELSE
                                next_state_s <= IDLE;
                            END IF;
                        ELSE
                            IF (cs = '1' AND bit10_addr_s = '1' AND
                               first_byte_s(2 downto 1) =
                               slave_addr(9 downto 8) AND
                               en_sl_resp = '1' AND HARD_MASTER_gen = FALSE) THEN
                                next_state_s <= S_READ;
                            ELSE
                                next_state_s <= IDLE;
                            END IF;
                        END IF;
                    ELSE
                    -- if device was selected for 10 bit addressing, but
                    -- none of previous conditions were matched then MASTER
                    -- is not addressing 10 bit addressable device
                        --7 bit slave is addressed
                        IF (first_byte_s(7 downto 1) = slave_addr(6 downto 0) AND
                           slave_addr(9 downto 7) = "UUU") THEN
                            IF (en_sl_resp = '1') THEN
                                IF SDA_tmp = '0' THEN
                                    next_state_s <= S_WRITTEN;
                                ELSIF (HARD_MASTER_gen = FALSE) THEN
                                    next_state_s <= S_READ;
                                ELSE
                                -- read request for hardware master is not allowed
                                    next_state_s <= IDLE;
                                END IF;
                            ELSE
                                next_state_s <= IDLE;
                            END IF;
                        ELSIF hs_mode_s = '0' THEN
                            --general call procedure
                            IF (first_byte_s(7 downto 0) = GEN_CALL) AND
                                  (GENERAL_CALL_gen = TRUE) AND
                                  (en_sl_resp = '1') THEN
                                next_state_s <= S_SECOND;
                            -- hs mode request
                            ELSIF (first_byte_s(7 downto 3) = HS_MODE_C) THEN
                                next_state_s <= IDLE;
                            ELSE
                                next_state_s <= IDLE;
                            END IF;
                        END IF;
                    END IF;
                END IF;

            WHEN S_BIT10_ADDR          =>
                IF (clk_cnt = 0 AND buf_loaded = '1') THEN
                --ACK CLK
                    --slave is addressed
                    IF first_byte_s(9 downto 0) = slave_addr(9 downto 0) AND
                       en_sl_resp = '1'  THEN
                        next_state_s <= S_WRITTEN;
                    ELSE
                        next_state_s <= IDLE;
                    END IF;
                END IF;

            WHEN S_SECOND          =>
                IF (clk_cnt = 0 AND buf_loaded = '1') THEN
                    --ACK CLK
                    --B_bit_s := SDA_tmp;
                    IF SDA_tmp = '0' THEN
                        next_state_s <= IDLE;
                    ELSE -- B_bit = '1'
                        IF ( en_sl_resp = '1' AND
                            (Listen_hard_master_gen = TRUE OR
                            --AND hard_master_to_listen_to = second_byte
                            (slave_addr(6 downto 0) = second_byte_s(7 downto 1)
                            AND slave_addr(9 downto 7) = "UUU"))
                            ) THEN
                            next_state_s <= S_WRITTEN;
                        ELSE
                            next_state_s <= IDLE;
                        END IF;
                    END IF;
                END IF;

            WHEN S_READ          =>
                IF (clk_cnt'EVENT ) THEN
                    --fist bit after ACK
                    IF (clk_cnt = 1) THEN
                        --not acknowladge from MASTER
                        IF SDA_tmp = '1' THEN
                            next_state_s <= IDLE;
                        END IF;
                    END IF;
                END IF;

            WHEN S_WRITTEN          =>
                IF (rising_edge(stop)) THEN
                    next_state_s <= IDLE;
                ELSIF start'EVENT THEN
                    IF start = '1' THEN
                        next_state_s <= S_INIT;
                    END IF;
                ELSIF (clk_cnt'EVENT) THEN
                    IF (clk_cnt = 0) THEN
                        IF en_sl_resp = '1' THEN
                            next_state_s <= S_WRITTEN;
                        ELSE
                            next_state_s <= IDLE;
                        END IF;
                    END IF;
                END IF;
            END CASE;
    END IF;
    END PROCESS StateGen_slave;
    ---------------------------------------------------------------------------
    -- Main Behavior Process for master
    -- combinational process for next state generation
    ---------------------------------------------------------------------------
    StateGen_master :PROCESS(current_state_m, my_bus, stop, clk_cnt)
    BEGIN
    IF (rising_edge(stop)) THEN
        next_state_m <= IDLE;
    ELSE
        CASE current_state_m IS
            WHEN IDLE          =>
                IF (my_bus = '1' AND clk_cnt'EVENT AND
                     -- hardware master
                    ((HARD_MASTER_gen = TRUE AND SLAVE_gen = FALSE) OR
                    -- programmed hardware master
                    (HARD_MASTER_gen = TRUE AND SLAVE_gen = TRUE AND
                               hard_mast_addressed = '1') OR
                     -- or master
                     (MASTER_gen))
                    ) THEN
                    next_state_m <= M_INIT;
                ELSE
                    next_state_m <= IDLE;
                END IF;

            WHEN M_INIT          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt /= 1 AND SDA_tmp /= SDA_zd_m) THEN
                        next_state_m <= IDLE;
                    -- device still acts as master
                    ELSE
                        -- if first byte
                        IF (not_first_byte = FALSE) THEN
                            null;
                        -- first bit of second byte
                        -- analyze response
                        ELSE
                            IF (first_byte_m(7 downto 3) = BIT10_ADDR_C) THEN
                                IF SDA_tmp = '0' THEN
                                --acknowladge bit reseived
                                    IF rnw_m = '0' THEN
                                        next_state_m <= M_BIT10_ADDR;
                                    ELSE
                                        IF bit10_addr_m = '1' THEN
                                        -- if 10 bit addressable device is
                                        -- already addressed
                                            next_state_m <= M_READ;
                                        ELSE
                                            next_state_m <= IDLE;
                                        END IF;
                                    END IF;
                                ELSE
                                --not acknowladge bit reseived
                                    next_state_m <= IDLE;
                                END IF;
                            ELSE

                                IF address_some_slave = TRUE THEN
                                    IF SDA_tmp = '0' THEN
                                        --acknowladge bit received
                                        IF rnw_m = '1' THEN
                                            next_state_m <= M_READ;
                                        ELSE
                                            IF end_of_write = '1' THEN
                                                next_state_m <= IDLE;
                                            ELSE
                                                next_state_m <= M_WRITE;
                                            END IF;
                                        END IF;
                                    ELSE
                                        --not acknowladge bit received
                                        next_state_m <= IDLE;
                                    END IF;
                                ELSIF hs_mode_m = '0' THEN
                                    IF first_byte_m(7 downto 0) = GEN_CALL THEN
                                        IF SDA_tmp = '0' THEN
                                        --acknowladge bit received
                                            next_state_m <= M_SECOND;
                                        ELSE
                                        --not acknowladge bit received
                                            next_state_m <= IDLE;
                                        END IF;
                                    ELSE
                                        next_state_m <= IDLE;
                                    END IF;
                                ELSE
                                    next_state_m <= IDLE;
                                END IF;
                            END IF;
                        END IF;
                     END IF;
                END IF;

            WHEN M_BIT10_ADDR          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt /= 1 AND SDA_tmp /= SDA_zd_m) THEN
                        next_state_m <= IDLE;
                    --still master
                    ELSE
                        --fist bit after ACK
                        IF (clk_cnt = 1) THEN
                            --not acknowladge from SLAVE
                            IF SDA_tmp = '1' THEN
                                next_state_m <= IDLE;
                            ELSE
                                IF (next_req= '1') THEN -- orend_of_write
                                    next_state_m <= IDLE;
                                ELSE
                                    next_state_m <= M_WRITE;
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                END IF;

            WHEN M_READ          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt = 1 AND SDA_in /= SDA_zd_m) THEN
                        next_state_m <= IDLE;
                    --still master
                    ELSE
                        IF rd_cnt = 0 THEN
                            --not acknowladge
                            next_state_m <= IDLE;
                        END IF;
                    END IF;
                END IF;

            WHEN M_WRITE          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt /= 1 AND SDA_in /= SDA_zd_m) THEN
                        next_state_m <= IDLE;
                    --still master
                    ELSE
                        --fist bit after ACK
                        IF (clk_cnt = 1) THEN
                            --not acknowladge from SLAVE
                            IF SDA_tmp = '1' OR end_of_write = '1' THEN
                                next_state_m <= IDLE;
                            END IF;
                        END IF;
                    END IF;
                END IF;

            WHEN M_SECOND          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt /= 1 AND SDA_tmp /= SDA_zd_m) THEN
                        next_state_m <= IDLE;
                    --still master
                    ELSE
                        -- check slave response after ACK clk
                        IF (clk_cnt = 1) THEN
                            IF B_bit_m = '1' AND SDA_tmp = '0' THEN
                                next_state_m <= M_WRITE;
                            ELSE
                                next_state_m <= IDLE;
                            END IF;
                        END IF;
                   END IF;
                END IF;

        END CASE;
    END IF;

    END PROCESS StateGen_master;

    ---------------------------------------------------------------------------
    --FSM Output generation and general funcionality
    ---------------------------------------------------------------------------
    Functional_slave : PROCESS(current_state_s, stop, start, clk_cnt, buf_loaded)--,next_req
    VARIABLE num : INTEGER := 7;
    VARIABLE load_buf_s       : std_logic_vector(7 downto 0) :=
                                                      (OTHERS => '0');
    variable BOOL : boolean := true;
    BEGIN

    IF (rising_edge(stop)) THEN
        hs_mode_s <= '0';
        cs <= '0';
        bit10_addr_s <= '0';
        num := 7;
        --next_state_s <= IDLE;

    ELSE
        CASE current_state_s IS
            WHEN IDLE          =>
                IF clk_cnt'EVENT THEN
                    SDA_zd_s <= '1';
                END IF;
                first_byte_s <= (OTHERS =>'0');
                second_byte_s <= (OTHERS =>'0');
                load_buf_s := (OTHERS => '0');
                IF (bit10_addr_s = '0') THEN
                    cs <= '0';
                END IF;
--                IF (SLAVE_gen = TRUE AND start = '1' AND
--                      (hs_mode_s = '0' OR HS_mode_gen = TRUE)) THEN
--                    next_state_s <= S_INIT;
--                END IF;

            WHEN S_INIT          =>
                    IF (clk_cnt /= 1 AND clk_cnt'EVENT) THEN
                        first_byte_s <= first_byte_s(8 downto 0)&SDA_tmp;
                        buf_loaded <= '1', '0' AFTER 1 ns;
                    END IF;
                    IF (clk_cnt = 0 AND buf_loaded = '1') THEN
                    --ACK CLK
                        --rnw_s := SDA_tmp;
                        SDA_zd_s <= '1';
                        IF (first_byte_s(7 downto 3) = BIT10_ADDR_C) THEN
                            -- read or write req
                            IF (SDA_tmp = '0') THEN
                                IF (slave_addr(9 downto 8) = first_byte_s(2 downto 1)) THEN
                                    --next_state_s <= S_BIT10_ADDR;
                                    SDA_zd_s <= '0';
                                   -- remember 2 and 1 bits
                                    first_byte_s(1 downto 0) <= first_byte_s(2 downto 1);
                                    bit10_addr_s <= '1';
                                    cs <= '0';
                                ELSE
                                    --next_state_s <= IDLE;
                                    cs <= '0';
                                    bit10_addr_s <= '0';
                                END IF;
                            ELSE
                                IF (cs = '1' AND bit10_addr_s = '1' AND
                                   first_byte_s(2 downto 1) =
                                   slave_addr(9 downto 8) AND
                                   en_sl_resp = '1' AND HARD_MASTER_gen = FALSE
                                   ) THEN
                                    --next_state_s <= S_READ;
                                    SDA_zd_s <= '0';
                                ELSE
                                    --next_state_s <= IDLE;
                                    cs <= '0';
                                    bit10_addr_s <= '0';
                                END IF;
                            END IF;
                        ELSE
                        -- if device was selected for 10 bit addressing, but
                        -- none of previous conditions were matched then MASTER
                        -- is not addressing 10 bit addressable device
                            cs <= '0';
                            bit10_addr_s <= '0';
                            --7 bit slave is addressed
                            IF (first_byte_s(7 downto 1) = slave_addr(6 downto 0) AND
                                slave_addr(9 downto 7) = "UUU") THEN
                                IF en_sl_resp = '1' THEN
                                    IF (HARD_MASTER_gen = FALSE OR
                                        SDA_tmp = '0') THEN
                                        SDA_zd_s <= '0';
                                        cs <= '1';
                                    END IF;
                                    --IF SDA_tmp = '1' THEN
                                    --    next_state_s <= S_READ;
                                    --ELSE
                                    --    next_state_s <= S_WRITTEN;
                                    --END IF;
                                ELSE
                                    SDA_zd_s <= '1';
                                    --next_state_s <= IDLE;
                                END IF;
                            ELSIF hs_mode_s = '0' THEN
                                --general call procedure
                                IF (first_byte_s(7 downto 0) = GEN_CALL) AND
                                      (GENERAL_CALL_gen = TRUE) AND
                                      (en_sl_resp = '1') THEN
                                    --next_state_s <= S_SECOND;
                                    --acknowladge
                                    SDA_zd_s <= '0';
                                    cs <= '1';
                                -- hs mode request
                                ELSIF (first_byte_s(7 downto 3) = HS_MODE_C) THEN
                                    --next_state_s <= IDLE;
                                    --not acknowladge
                                    SDA_zd_s <= '1';
                                    hs_mode_s <= '1';
                                --ELSE
                                    --next_state_s <= IDLE;
                                END IF;
                            END IF;
                        END IF;
                    END IF;

                WHEN S_BIT10_ADDR          =>
                    IF (clk_cnt'EVENT) THEN
                        IF clk_cnt /= 1 THEN
                            first_byte_s <= first_byte_s(8 downto 0)&SDA_tmp;
                            buf_loaded <= '1', '0' AFTER 1 ns;
                            SDA_zd_s <= '1';
                        ELSE
                            SDA_zd_s <= '1';
                        END IF;
                    END IF;

                    IF (clk_cnt = 0 AND buf_loaded = '1') THEN
                    --ACK CLK
                        --slave is addressed
                        IF first_byte_s(9 downto 0) = slave_addr(9 downto 0) AND
                           en_sl_resp = '1'  THEN
                            --next_state_s <= S_WRITTEN;
                            cs <= '1';
                            SDA_zd_s <= '0';
                            bit10_addr_s <= '1';
                        ELSE
                            --next_state_s <= IDLE;
                            cs <= '0';
                            bit10_addr_s <= '0';
                            SDA_zd_s <= '1';
                        END IF;
                    END IF;

                WHEN S_SECOND          =>
                    IF clk_cnt'EVENT THEN
                        IF (clk_cnt /= 1)  THEN
                            second_byte_s <= second_byte_s(6 downto 0)&SDA_tmp;
                            buf_loaded <= '1', '0' AFTER 1 ns;
                            SDA_zd_s <= '1';
                        ELSE
                            SDA_zd_s <= '1';
                        END IF;
                    END IF;
                    IF (clk_cnt = 0 AND buf_loaded = '1') THEN
                        --ACK CLK
                        --B_bit_s := SDA_tmp;
                        SDA_zd_s <= '1';
                        IF SDA_tmp = '0' THEN
                            --next_state_s <= IDLE;
                            IF en_sl_resp = '1' THEN
                                --slave is addressed
                                IF to_nat(second_byte_s) = 16#06# THEN
                                    soft_addr <= '1', '0' AFTER 1 ns;
                                    --RestoreSlaveAddr(slave_addr, bool);
                                    RESET <= '1', '0' AFTER t_reset;--assert reset
                                    SDA_zd_s <= '0';
                                ELSIF to_nat(second_byte_s) = 16#04# THEN
                                    --RestoreSlaveAddr(slave_addr, bool);
                                    soft_addr <= '1', '0' AFTER 1 ns;
                                    SDA_zd_s <= '0';
                                --ELSIF to_nat(second_byte) = 16#00# THEN
                                    --Report("Code not allowed");
                                END IF;
                            END IF;
                        ELSE -- B_bit = '1'
                            IF ( en_sl_resp = '1' AND
                                (Listen_hard_master_gen = TRUE OR
                                --AND hard_master_to_listen_to = second_byte
                                (slave_addr(6 downto 0) = second_byte_s(7 downto 1)
                                AND slave_addr(9 downto 7) = "UUU"))
                                ) THEN
                                --next_state_s <= S_WRITTEN;
                                SDA_zd_s <= '0';
                                cs <= '1';
                            ELSE
                                --next_state_s <= IDLE;
                                SDA_zd_s <= '1';
                            END IF;
                        END IF;
                    END IF;

                WHEN S_READ          =>
                    IF (clk_cnt'EVENT ) THEN
                        --fist bit after ACK
                        IF (clk_cnt = 1) THEN
                            --not acknowladge from MASTER
                            IF SDA_tmp = '1' THEN
                                --next_state_s <= IDLE;
                                SDA_zd_s <= '1'; -- release SDA
                                IF bit10_addr_s = '0' THEN
                                    cs <= '0';
                                END IF;
                            ELSE
                                Drive_slave(SDA_zd_s, num);
                            END IF;
                        ELSIF (clk_cnt /= 0) THEN
                            Drive_slave(SDA_zd_s, num);
                        ELSE
                            SDA_zd_s <= '1';
                        END IF;
                    END IF;


                WHEN S_WRITTEN          =>
                    IF (rising_edge(stop)) THEN
                        --next_state_s <= IDLE;
                        cs <= '0';
                        bit10_addr_s <= '0';
                        hs_mode_s <= '0';
                    ELSIF start'EVENT THEN
                        IF start = '1' THEN
                            --next_state_s <= S_INIT;
                            SDA_zd_s <= '1';
                            -- load first data
                            first_byte_s <= "00"&load_buf_s;
                            second_byte_s <= (OTHERS =>'0');
                            load_buf_s := (OTHERS => '0');
                            IF bit10_addr_s = '0' THEN
                                cs <= '0';
                            END IF;
                        END IF;
                    ELSIF (clk_cnt'EVENT) THEN
                        IF (clk_cnt /= 1 AND clk_cnt'EVENT) THEN
                            Load_buf_s := Load_buf_s(6 downto 0)&SDA_tmp;
                            SDA_zd_s <= '1';
                        END IF;
                        IF (clk_cnt = 0) THEN
                            Store(Load_buf_s, FALSE);
                            IF (HARD_MASTER_gen AND hard_mast_addressed = '0') THEN
                                load_addr <= '1', '0' AFTER 1 ns;
                            END IF;
                            Load_buf_s := (OTHERS => '0');
                            IF en_sl_resp = '1' THEN
                                --next_state_s <= S_WRITTEN;
                                --acknowladge
                                SDA_zd_s <= '0';
                            ELSE
                                --next_state_s <= IDLE;
                                --not acknowladge
                                SDA_zd_s <= '1';
                                IF bit10_addr_s = '0' THEN
                                    cs <= '0';
                                END IF;
                            END IF;
                        ELSE
                            SDA_zd_s <= '1';
                        END IF;
                    END IF;

                    IF ((rising_edge(stop) OR rising_edge(start)) AND
                        clk_cnt /= 1) THEN
                        Report("Invalid timming for STOP/RESTART condition");
                    END IF;
                END CASE;
    END IF;
    END PROCESS Functional_slave;

    Functional_master : PROCESS(current_state_m,    next_req, stop, clk_cnt)
    VARIABLE num : INTEGER := 7;
    VARIABLE load_buf_m       : std_logic_vector(7 downto 0) :=
                                                      (OTHERS => '0');
    BEGIN

    IF (rising_edge(stop)) THEN
        --next_state_m <= IDLE;
        hs_mode_m <= '0';
        bit10_addr_m <= '0';
        num := 7;
    ELSE
        CASE current_state_m IS
            WHEN IDLE          =>
                first_byte_m <= (OTHERS =>'0');
                --second_byte_m <= (OTHERS =>'0');
                Load_buf_m := (OTHERS => '0');
                not_first_byte <= FALSE;
                --only if device is master
                IF ( (hard_mast_addressed = '1') OR
                     (HARD_MASTER_gen = TRUE AND SLAVE_gen = FALSE) OR
                     (MASTER_gen = TRUE AND HARD_MASTER_gen = FALSE)) THEN
                    IF (my_bus = '1' AND clk_cnt'EVENT AND SCL_in = '0') THEN
                    --    next_state_m <= M_INIT;
                        Drive(SDA_zd_m, num);
                    -- initiate new request for bus
                    -- bus is free
                    ELSE
                        IF (SCL_in /= '0') THEN-- only if master
                            IF (busy = '0' AND next_req = '1') THEN
                                SDA_zd_m <= '0';
                            -- restart
                            ELSIF (my_bus = '1' AND next_req = '1') THEN
                                SDA_zd_m <= '0';
                            -- end transfer
                            ELSIF NOT(next_req'EVENT) THEN
                                SDA_zd_m <= '1';
                            END IF;
                        END IF;
                    END IF;
                END IF;


            WHEN M_INIT          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt /= 1 AND SDA_tmp /= SDA_zd_m) THEN
                        --next_state_m <= IDLE;
                        SDA_zd_m <= '1';
                        hs_mode_m <= '0';
                        bit10_addr_m <= '0';
                        arb_lost <= '1', '0' AFTER 1 ns;
                    -- device still acts as master
                    ELSE
                        -- if first byte
                        IF (not_first_byte = FALSE) THEN
                            first_byte_m <= first_byte_m(8 downto 0)&SDA_tmp;
                            IF (clk_cnt /= 0) THEN
                                Drive(SDA_zd_m, num);
                            ELSE
                                SDA_zd_m <= '1';
                                not_first_byte <= TRUE;
                                rnw_m := SDA_tmp;
                            END IF;
                        -- first bit of second byte
                        -- analyze response
                        ELSE
                            IF (first_byte_m(7 downto 3) = BIT10_ADDR_C) THEN
                                IF SDA_tmp = '0' THEN
                                --acknowladge bit reseived
                                    IF rnw_m = '0' THEN
                                        --next_state_m <= M_BIT10_ADDR;
                                        Drive(SDA_zd_m, num);
                                    ELSE
                                        --IF bit10_addr_m = '1' THEN
                                        -- if 10 bit addressable device is
                                        -- already addressed
                                            --next_state_m <= M_READ;
                                            SDA_zd_m <= '1';
                                        --ELSE
                                            --next_state_m <= IDLE;
                                        --END IF;
                                    END IF;
                                ELSE
                                --not acknowladge bit reseived
                                    --next_state_m <= IDLE;
                                    bit10_addr_m <= '0';-- for master
                                    SetSDA(SDA_zd_m);
                                END IF;
                            ELSE
                                bit10_addr_m <= '0';
                                IF address_some_slave = TRUE THEN
                                    IF SDA_tmp = '0' THEN
                                        --acknowladge bit received
                                        IF rnw_m = '1' THEN
                                            --next_state_m <= M_READ;
                                            -- release SDA
                                            SDA_zd_m <= '1';
                                        ELSE
                                            IF end_of_write = '1' THEN
                                                --next_state_m <= IDLE;
                                                SetSDA(SDA_zd_m);
                                            ELSE
                                                --next_state_m <= M_WRITE;
                                                Drive(SDA_zd_m, num);
                                            END IF;
                                        END IF;
                                    ELSE
                                        --not acknowladge bit received
                                            --next_state_m <= IDLE;
                                            SetSDA(SDA_zd_m);
                                    END IF;
                                ELSIF hs_mode_m = '0' THEN
                                    IF first_byte_m(7 downto 0) = GEN_CALL THEN
                                    -- hardware master
                                        IF SDA_tmp = '0' THEN
                                        --acknowladge bit received
                                            --next_state_m <= M_SECOND;
                                            IF HARD_MASTER_gen = TRUE THEN
                                                Drive_slave_addr(SDA_zd_m, slave_addr, num);
                                            ELSE
                                                Drive(SDA_zd_m, num);
                                            END IF;
                                        ELSE
                                        --not acknowladge bit received
                                            --next_state_m <= IDLE;
                                            SetSDA(SDA_zd_m);
                                        END IF;
                                    ELSIF (first_byte_m(7 downto 3) = HS_MODE_C) THEN
                                        --next_state_m <= IDLE;
                                        hs_mode_m <= '1';
                                        IF SDA_tmp = '0' THEN
                                            -- no device may ackonwladge
                                            Report("illegal response");
                                        END IF;
                                        SetSDA(SDA_zd_m);
                                    ELSIF first_byte_m(7 downto 0) = START_BYTE THEN
                                        --next_state_m <= IDLE;
                                        IF SDA_tmp = '0' THEN
                                            --acknowladge bit received
                                            Report("No device is allowed to acknowladge");
                                        END IF;
                                        SetSDA(SDA_zd_m);-- SDA_zd must be 1
                                               -- next_req must be 1
                                    --ELSE
                                        --next_state_m <= IDLE;
                                    END IF;
                                --ELSE
                                    --next_state_m <= IDLE;
                                END IF;
                            END IF;
                        END IF;
                        Drive_rdy(rdy, clk_cnt);
                    END IF;
                END IF;

            WHEN M_BIT10_ADDR          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt /= 1 AND SDA_tmp /= SDA_zd_m) THEN
                        --next_state_m <= IDLE;
                        SDA_zd_m <= '1';
                        bit10_addr_m <= '0';
                        hs_mode_m <= '0';
                        arb_lost <= '1', '0' AFTER 1 ns;
                    --still master
                    ELSE
                        SDA_zd_m <= '1';
                        --fist bit after ACK
                        IF (clk_cnt = 1) THEN
                            --not acknowladge from SLAVE
                            IF SDA_tmp = '1' THEN
                                --next_state_m <= IDLE;
                                SetSDA(SDA_zd_m);
                                bit10_addr_m <= '0';
                            ELSE
                                IF (next_req= '1') THEN -- orend_of_write
                                    --next_state_m <= IDLE;
                                    SetSDA(SDA_zd_m);
                                ELSE
                                    --next_state_m <= M_WRITE;
                                    Drive(SDA_zd_m, num);
                                END IF;
                                bit10_addr_m <= '1';
                            END IF;
                        ELSIF (clk_cnt = 0) THEN
                        -- release SDA so slave can response
                            SDA_zd_m <= '1';
                        ELSE
                            Drive(SDA_zd_m, num);
                        END IF;
                        Drive_rdy(rdy, clk_cnt);
                    END IF;
                END IF;

            WHEN M_READ          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt = 1 AND SDA_in /= SDA_zd_m) THEN
                        --next_state_m <= IDLE;
                        SDA_zd_m <= '1';
                        bit10_addr_m <= '0';
                        hs_mode_m <= '0';
                        arb_lost <= '1', '0' AFTER 1 ns;
                    --still master
                    ELSE
                        SDA_zd_m <= '1';
                        Drive_rdy(rdy, clk_cnt);
                        -- load data from slave
                        IF (clk_cnt /= 1) THEN
                            Load_buf_m := Load_buf_m(6 downto 0)&SDA_in;
                        END IF;
                        IF (clk_cnt = 0) THEN
                            Store(Load_buf_m, TRUE);
                            Load_buf_m := (OTHERS => '0');
                            IF rd_cnt = 1 THEN
                                --not acknowladge
                                SDA_zd_m <= '1';
                            ELSE
                                --acknowladge
                                SDA_zd_m <= '0';
                            END IF;
                            decr_rd_cnt <= '1', '0' AFTER 1 ns;
                        ELSIF rd_cnt = 0 THEN
                                --not acknowladge
                                --next_state_m <= IDLE;
                                SetSDA(SDA_zd_m);
                        END IF;
                    END IF;
                END IF;

            WHEN M_WRITE          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt /= 1 AND SDA_in /= SDA_zd_m) THEN
                        --next_state_m <= IDLE;
                        SDA_zd_m <= '1';
                        bit10_addr_m <= '0';
                        hs_mode_m <= '0';
                        arb_lost <= '1', '0' AFTER 1 ns;
                    --still master
                    ELSE
                        SDA_zd_m <= '1';
                        --fist bit after ACK
                        IF (clk_cnt = 1) THEN
                            --not acknowladge from SLAVE
                            IF SDA_tmp = '1' OR end_of_write = '1' THEN
                                --next_state_m <= IDLE;
                                SetSDA(SDA_zd_m);
                            ELSE
                                Drive(SDA_zd_m, num);
                            END IF;
                        ELSIF (clk_cnt = 0) THEN
                        -- release SDA so slave can response
                            SDA_zd_m <= '1';
                        ELSE
                            Drive(SDA_zd_m, num);
                        END IF;
                        Drive_rdy(rdy, clk_cnt);
                    END IF;
                END IF;

            WHEN M_SECOND          =>
                IF clk_cnt'EVENT THEN
                    -- arbitration is lost
                    IF (clk_cnt /= 1 AND SDA_tmp /= SDA_zd_m) THEN
                        --next_state_m <= IDLE;
                        SDA_zd_m <= '1';
                        arb_lost <= '1', '0' AFTER 1 ns;
                    --still master
                    ELSE
                        -- check slave response after ACK clk
                        IF (clk_cnt = 1) THEN
                            IF B_bit_m = '1' AND SDA_tmp = '0' THEN
                                --next_state_m <= M_WRITE;
                                IF HARD_MASTER_gen = TRUE THEN
                                    Drive_slave_addr(SDA_zd_m, slave_addr, num);
                                ELSE
                                    Drive(SDA_zd_m, num);
                                END IF;
                            ELSE
                                --next_state_m <= IDLE;
                                SetSDA(SDA_zd_m);
                            END IF;
                        ELSIF (clk_cnt = 0) THEN
                            B_bit_m := SDA_tmp;
                            SDA_zd_m <= '1';
                        ELSE
                            IF HARD_MASTER_gen = TRUE THEN
                                Drive_slave_addr(SDA_zd_m, slave_addr, num);
                            ELSE
                                Drive(SDA_zd_m, num);
                            END IF;
                        END IF;
                        Drive_rdy(rdy, clk_cnt);
                   END IF;
                END IF;

        END CASE;
    END IF;
    END PROCESS Functional_master;

    ---------------------------------------------------------------------------
    --DRIVE MASTER/SLAVE FROM i2c_drive_ms_pkg PROCESS
    ---------------------------------------------------------------------------
--    drive_ms  :PROCESS
--        VARIABLE cmd_cnt    :   NATURAL;
--        VARIABLE command    :   cmd_rec;
--        VARIABLE cmd_seq    : cmd_seq_type;
--        VARIABLE current_time : TIME := 0 ns;
--    BEGIN
--        Pick_TC (ts_cnt, tc_cnt);
--            current_time := NOW;
--        Generate_TC
--            (   Device_id   => device_id,
--                Series      => ts_cnt,
--                TestCase    => tc_cnt,
--                curr_time   => current_time,
--                command_seq => cmd_seq);
--        cmd_cnt := 1;
--        WHILE cmd_seq(cmd_cnt).cmd/=done LOOP
--            command:= cmd_seq(cmd_cnt);
--    --        IF my_bus = '1' THEN
--  --              WAIT UNTIL rdy = '1' ;--AND rdy'EVENT;
----                END IF;
--
--            command_decode(command, current_time, buff, end_of_write,
--                           next_req, load_rd_cnt, rd_value,
--                           delay_value, en_sl_resp, address_some_slave);
--            cmd_cnt :=cmd_cnt +1;
--        END LOOP;
--    END PROCESS drive_ms;

    ---------------------------------------------------------------------------
    --open buffer and delay signals processes
    ---------------------------------------------------------------------------
    SCL_open_buffer: PROCESS(SCL_zd, SCL_in)
    BEGIN
        --MASTER
        -- (current source)
        -- pulls up SCL during HS mode and not ackonwladge bit
        IF (hs_mode_m = '1' AND ACK = '0' AND SCL_in = '0') OR
        -- pulls SCL down
        (SCL_zd = '0' AND my_bus = '1') OR
        -- SLAVE
        -- not hs mode
        (SCL_zd = '0' AND cs = '1' AND hs_mode_s = '0')  OR
        -- hs mode
        -- during ACK bit
        (SCL_zd = '0' AND cs = '1' AND hs_mode_s = '1' AND ACK = '1') THEN
            SCL_z <= SCL_zd;
        ELSE
            SCL_z <= 'Z';
        END IF;
    END PROCESS SCL_open_buffer;
    SDA_zd <= SDA_zd_m AND SDA_zd_s;
    SDA_open_buffer: PROCESS(SDA_zd)
    BEGIN
        IF (SDA_zd = '0')THEN
            SDA_z <= SDA_zd;
        ELSE
            SDA_z <= 'Z';
        END IF;
    END PROCESS SDA_open_buffer;

    delay_SDA: PROCESS(SDA_z, SCL_in)
    VARIABLE t_delay : TIME := 0 ns;-- tHD;DAT
    BEGIN
        t_delay := thold_sda_scl;
--        IF hs_mode = '0' THEN
--            t_delay := 250 ns;
--        ELSE
--            t_delay := 10 ns;
--        END IF;
        IF (SCL_in = '0')THEN
            SDA_d <= SDA_z AFTER t_delay;
        ELSE
            SDA_d <= SDA_z;
        END IF;
    END PROCESS delay_SDA;

    -----------------------------------------------------------------------
    -- Path Delay Section
    -----------------------------------------------------------------------
    SDAout <= SDA_d;
    SCLout <= SCL_z;

    END BLOCK behavior;
END vhdl_behavioral;


LIBRARY IEEE;
    USE IEEE.std_logic_1164.ALL;
    USE IEEE.VITAL_timing.ALL;     --  Uncoment this lines for usage
    USE IEEE.VITAL_primitives.ALL; -- in NC-Sim

    USE STD.textio.ALL;

-- LIBRARY vital2000;
--    USE vital2000.VITAL_timing.ALL;     -- Uncoment this lines for usage
--    USE vital2000.VITAL_primitives.ALL; -- in Modelsim and comment lines for NCSim

LIBRARY FMF;    USE FMF.gen_utils.all;
                USE FMF.conversions.all;
--LIBRARY work;
--USE work.i2c_tc_pkg.all;

-------------------------------------------------------------------------------
-- ENTITY DECLARATION
-- i2c BUS
-------------------------------------------------------------------------------
ENTITY i2c IS
    GENERIC (
        -- tipd delays: interconnect path delays
        tipd_SDA            : VitalDelayType01 := VitalZeroDelay01;
        tipd_SCL            : VitalDelayType01 := VitalZeroDelay01;
        -- number of i2c devices connected to i2c bus
        i2c_num             : NATURAL   := 23;
        -- generic control parameters
        InstancePath        : STRING    := DefaultInstancePath;
        TimingChecksOn      : BOOLEAN   := DefaultTimingChecks;
        MsgOn               : BOOLEAN   := DefaultMsgOn;
        XOn                 : BOOLEAN   := DefaultXon;
        -- For FMF SDF technology file usage
        TimingModel         : STRING    := DefaultTimingModel
    );
    PORT (
        SDA            : INOUT std_logic := 'U';
        SCL            : INOUT std_logic := 'U'
    );
    ATTRIBUTE VITAL_LEVEL0 of i2c : ENTITY IS TRUE;
END i2c;
------------------------------------------------------------------------------
-- ARCHITECTURE DECLARATION
-- I2C BUS
-------------------------------------------------------------------------------
ARCHITECTURE vhdl_behavioral of i2c IS
    ATTRIBUTE VITAL_LEVEL0 of vhdl_behavioral : ARCHITECTURE IS TRUE;

    COMPONENT i2c_device
    GENERIC (
        -- tipd delays: interconnect path delays
        tipd_SDA         : VitalDelayType01 := VitalZeroDelay01;
        tipd_SCL         : VitalDelayType01 := VitalZeroDelay01;

        --tpd, tsetup, thold delays
        -- tHD;STA 4us, 0.6us, 160ns
        thold_scl_sda            : VitalDelayType := 4 us;--UnitDelay;
        -- tSU;STA 4.7us, 0.6us, 160ns
        tsetup_scl_sda_noedge_negedge   : VitalDelayType := 4.7 us;--UnitDelay;
        -- tHD;DAT 300ns, 300ns,
        -->20 ns (3mA current source and 400 pF load)
        --> 10 ns (load 10-100 pF)
        thold_sda_scl            : VitalDelayType := 300 ns;-- UnitDelay;
        -- tSU;DAT 250ns, 100ns, 10ns
        tsetup_sda_scl           : VitalDelayType := 250 ns;-- UnitDelay;
        -- tSU;STO 4.0us, 0.6us, 160ns
        tsetup_scl_sda_noedge_posedge   : VitalDelayType := 4 us;--UnitDelay;

--------------
--pulse width
-------------
        tpw_SCL_negedge: VitalDelayType := 4.7 us;-- UnitDelay;
        tpw_SCL_posedge: VitalDelayType := 4 us;--;UnitDelay;


        -- tdevice values: values for internal delays
        -- 1.3 us for fast mode
        -- 4.7 us for fast mode
        tdevice_tbuff             : VitalDelayType    := 4.7 us;--1.3 us;
        -- glitch suppresion
        tdevice_tgsp              : VitalDelayType    := 50 ns; --1.3 us

        -- generic control parameters
        InstancePath        : STRING    := DefaultInstancePath;
        TimingChecksOn      : BOOLEAN   := DefaultTimingChecks;
        MsgOn               : BOOLEAN   := DefaultMsgOn;
        XOn                 : BOOLEAN   := DefaultXon;
        -- For FMF SDF technology file usage
        TimingModel         : STRING    := DefaultTimingModel;

        --i2c specific generics
        Device_id           : STRING    := "none";
        -- if device can be master
        MASTER_gen          : BOOLEAN   := FALSE;
        -- true if device can be slave
        SLAVE_gen           : BOOLEAN   := TRUE;
        -- if device is hadrware master
        HARD_MASTER_gen     : BOOLEAN   := TRUE;
        -- true if device will response on general call procedure
        GENERAL_CALL_gen    : BOOLEAN   := TRUE;
        -- slave addresse
        SLAVE_ADDR_gen      : std_logic_vector(9 downto 0):= (OTHERS => 'U');
        -- zero if slave address is not programable
        -- else number of programable bits
        PROGRAMABLE_S_A_gen : INTEGER   := 7;
        -- programable part of slave address
        PPART_SLAVE_ADDR_gen: std_logic_vector(9 downto 0) := (OTHERS => 'U');
        Listen_hard_master_gen : BOOLEAN := FALSE;
        -- CLK high pulse width
        T_high_gen          : time := 4 us ;
        -- CLK low pulse width
        T_low_gen           : time := 4.7 us;
        -- true if device can work in HS mode
        HS_mode_gen         : BOOLEAN   := TRUE;
        -- true if device can work in CBUS mode
        CBUS_mode_gen       : BOOLEAN   := FALSE;
        -- master code if device can work in HS mode
        MASTER_CODE_gen     : std_logic_vector(7 downto 0) := "00001XXX";
        --RESET signal pulse width, general call proc
        t_reset             : time  := 1 ns

    );
    PORT (
        SDA            : INOUT std_ulogic := 'U';
        SCL            : INOUT std_ulogic := 'U'
    );
    END COMPONENT;

    --FOR all: i2c_device USE ENTITY WORK.i2c_device(VHDL_BEHAVIORAL);
        SHARED VARIABLE array_size : INTEGER := 25;
        TYPE  STRINGS       IS ARRAY (0 TO array_size) OF STRING(11 downto 1);
        TYPE  INTEGERS      IS ARRAY (0 TO array_size) OF INTEGER RANGE 0 TO 10;
        TYPE  BOOLEANS      IS ARRAY (0 TO array_size) OF BOOLEAN;
        TYPE  PERIODS       IS ARRAY (0 TO array_size) OF TIME;
        TYPE  STD_VECTORS_9 IS ARRAY (0 TO array_size) OF
                                            std_logic_vector(9 downto 0);
        TYPE  STD_VECTORS_7 IS ARRAY (0 TO array_size) OF
                                            std_logic_vector(7 downto 0);
        SHARED VARIABLE Device_id              : STRINGS       :=
                                               (0 => "U00_i2c_dev",
                                                1 => "U01_i2c_dev",
                                                2 => "U02_i2c_dev",
                                                3 => "U03_i2c_dev",
                                                4 => "U04_i2c_dev",
                                                5 => "Uxx_i2c_dev",
                                                6 => "Uxx_i2c_dev",
                                                7 => "Uxx_i2c_dev",
                                                8 => "Uxx_i2c_dev",
                                                9 => "Uxx_i2c_dev",
                                                10 => "Uxx_i2c_dev",
                                                11 => "Uxx_i2c_dev",
                                                12 => "Uxx_i2c_dev",
                                                13 => "Uxx_i2c_dev",
                                                14 => "Uxx_i2c_dev",
                                                15 => "Uxx_i2c_dev",
                                                16 => "Uxx_i2c_dev",
                                                17 => "Uxx_i2c_dev",
                                                18 => "Uxx_i2c_dev",
                                                19 => "Uxx_i2c_dev",
                                                --hardware masters
                                                20 => "U20_i2c_dev",-- hardware master, can not be slave
                                                21 => "U21_i2c_dev",-- hardware master, is slave
                                                22 => "U22_i2c_dev",-- hardware master, is slave, 10 bit address
                                                23 => "U23_i2c_dev",-- hardware master, is slave, listens for general call
                                                24 => "Uxx_i2c_dev",
                                                25 => "Uxx_i2c_dev"
--                                              26 => "Uxx_i2c_dev"
--                                              27 => "Uxx_i2c_dev"
--                                              28 => "Uxx_i2c_dev"
--                                              29 => "Uxx_i2c_dev"

                                                );
        -- MASTER_gen field is ignored if device is HARDWARE MASTER
        SHARED VARIABLE MASTER_gen             : BOOLEANS      := (OTHERS => FALSE);
        SHARED VARIABLE SLAVE_gen              : BOOLEANS      := (
                                                0 => TRUE,
                                                1 => TRUE,
                                                2 => TRUE,
                                                3 => TRUE,
                                                4 => TRUE,
                                                5 => TRUE,
                                                6 => TRUE,
                                                7 => TRUE,
                                                8 => TRUE,
                                                9 => TRUE,
                                                10=> TRUE,
                                                11=> TRUE,
                                                12=> TRUE,
                                                13=> TRUE,
                                                14=> TRUE,
                                                15=> TRUE,
                                                16=> TRUE,
                                                17=> TRUE,
                                                18=> TRUE,
                                                19=> TRUE,

                                                20 => FALSE,
                                                21 => TRUE,
                                                22 => TRUE,
                                                23 => TRUE,
                                                24 => TRUE,
                                                25 => TRUE);
        SHARED VARIABLE HARD_MASTER_gen         : BOOLEANS      := (
                                                0 => FALSE,
                                                1 => FALSE,
                                                2 => FALSE,
                                                3 => FALSE,

                                                4 => FALSE,
                                                5 => FALSE,
                                                6 => FALSE,
                                                7 => FALSE,
                                                8 => FALSE,
                                                9 => FALSE,
                                                10 => FALSE,
                                                11 => FALSE,
                                                12 => FALSE,
                                                13 => FALSE,
                                                14 => FALSE,
                                                15 => FALSE,
                                                16 => FALSE,
                                                17 => FALSE,
                                                18 => FALSE,
                                                19 => FALSE,

                                                20 => TRUE,
                                                21 => TRUE,
                                                22 => TRUE,
                                                23 => TRUE,
                                                24 => FALSE,
                                                25 => FALSE);

        SHARED VARIABLE GENERAL_CALL_gen       : BOOLEANS      :=(
                                                0 => FALSE,
                                                1 => TRUE,
                                                2 => TRUE,
                                                3 => TRUE,
                                                4 => TRUE,
                                                5 => TRUE,
                                                6 => TRUE,
                                                7 => TRUE,
                                                8 => TRUE,
                                                9 => TRUE,
                                                10=> TRUE,
                                                11=> TRUE,
                                                12=> TRUE,
                                                13=> TRUE,
                                                14=> TRUE,
                                                15=> TRUE,
                                                16=> TRUE,
                                                17=> TRUE,
                                                18=> TRUE,
                                                19=> TRUE,

                                                20 => TRUE,
                                                21 => TRUE,
                                                22 => TRUE,
                                                23 => TRUE,
                                                24 => TRUE,
                                                25 => TRUE);

        SHARED VARIABLE SLAVE_ADDR_gen         : STD_VECTORS_9 :=
                                               (0 => "UUU1001000",--0 
                                                1 => "UUU1001001",--1 
                                                2 => "UUU1001010",--2 
                                                3 => "UUU1001011",--3
                                                4 => "UUU1001100",
                                                5 => "UUU1001101",
                                                6 => "UUU1001110",
                                                7 => "UUUUUUUUUU",
                                                8 => "UUUUUUUUUU",
                                                9 => "UUUUUUUUUU",
                                                10=> "UUUUUUUUUU",
                                                11 => "UUUUUUUUUU",
                                                12 => "UUUUUUUUUU",
                                                13 => "UUUUUUUUUU",
                                                14 => "UUUUUUUUUU",
                                                15 => "UUUUUUUUUU",
                                                16 => "UUUUUUUUUU",
                                                17 => "UUUUUUUUUU",
                                                18 => "UUUUUUUUUU",
                                                19 => "UUUUUUUUUU",

                                                20 => "UUU0101011",-- 4 hard master
                                                21 => "UUU0101100",-- 5 hard master
                                                22 => "1100100010",-- h/w master
                                                23 => "UUUUUUUUUU",
                                                24 => "UUUUUUUUUU",
                                                25 => "UUUUUUUUUU"

                                                );
        SHARED VARIABLE PROGRAMABLE_S_A_gen    : INTEGERS      := (OTHERS => 0);
        SHARED VARIABLE PPART_SLAVE_ADDR_gen   : STD_VECTORS_9 := (
                                                0 => "UUUUUUUUUU",
                                                1 => "UUUUUUUUUU",
                                                2 => "UUUUUUUUUU",
                                                3 => "UUUUUUUUUU",
                                                4 => "UUUUUUUUUU",
                                                5 => "UUUUUUUUUU",
                                                6 => "UUUUUUUUUU",
                                                7 => "UUUUUUUUUU",
                                                8 => "UUUUUUUUUU",
                                                9 => "UUUUUUUUUU",
                                                10 => "UUUUUUUUUU",
                                                11 => "UUUUUUUUUU",
                                                12 => "UUUUUUUUUU",
                                                13 => "UUUUUUUUUU",
                                                14 => "UUUUUUUUUU",
                                                15 => "UUUUUUUUUU",
                                                16 => "UUUUUUUUUU",
                                                17 => "UUUUUUUUUU",
                                                18 => "UUUUUUUUUU",
                                                19 => "UUUUUUUUUU",
                                                20 => "UUUUUUUUUU",
                                                21 => "UUUUUUUUUU",
                                                22 => "UUUUUUUUUU",
                                                23 => "UUU0101000",-- general call proc sets dump addr for hw master,
                                                                   -- dev1
                                                24 => "UUUUUUUUUU",
                                                25 => "UUUUUUUUUU");
        SHARED VARIABLE Listen_hard_master_gen : BOOLEANS      := (
                                                0 => FALSE,
                                                1 => FALSE,
                                                2 => FALSE,
                                                3 => FALSE,
                                                4 => FALSE,
                                                5 => FALSE,
                                                6 => FALSE,
                                                7 => FALSE,
                                                8 => FALSE,
                                                9 => FALSE,
                                                10 => FALSE,
                                                11 => FALSE,
                                                12 => FALSE,
                                                13 => FALSE,
                                                14 => FALSE,
                                                15 => FALSE,
                                                16 => FALSE,
                                                17 => FALSE,
                                                18 => FALSE,
                                                19 => FALSE,
                                                20 => FALSE,
                                                21 => FALSE,
                                                22 => FALSE,
                                                23 => FALSE,
                                                24 => FALSE,
                                                25 => FALSE);
        SHARED VARIABLE T_high_gen             : PERIODS       := (OTHERS => 4 us) ;
        SHARED VARIABLE T_low_gen              : PERIODS       := (OTHERS => 4.7 us);
        SHARED VARIABLE HS_mode_gen            : BOOLEANS      := (OTHERS => TRUE);
        SHARED VARIABLE CBUS_mode_gen          : BOOLEANS      := (OTHERS => FALSE);
        SHARED VARIABLE MASTER_CODE_gen        : STD_VECTORS_7 := (OTHERS =>"00001XXX");


    BEGIN


        generate_instances: FOR i IN 0 TO i2c_num GENERATE
            U_i2c_dev: i2c_device
            GENERIC MAP(
                -- tipd delays: interconnect path delays
                tipd_SDA                => tipd_SDA,
                tipd_SCL                => tipd_SCL,

                -- generic control parameters
                InstancePath            => InstancePath,
                TimingChecksOn          => TimingChecksOn,
                MsgOn                   => MsgOn,
                XOn                     => XOn,
                -- For FMF SDF technology file usage
                TimingModel             => TimingModel,

                --i2c specific generics
                Device_id               => Device_id(i),
                MASTER_gen              => MASTER_gen(i),
                SLAVE_gen               => SLAVE_gen(i),
                HARD_MASTER_gen         => HARD_MASTER_gen(i),
                GENERAL_CALL_gen        => GENERAL_CALL_gen(i),
                SLAVE_ADDR_gen          => SLAVE_ADDR_gen(i),
                PROGRAMABLE_S_A_gen     => PROGRAMABLE_S_A_gen(i),
                PPART_SLAVE_ADDR_gen    => PPART_SLAVE_ADDR_gen(i),
                Listen_hard_master_gen  => Listen_hard_master_gen(i),
                T_high_gen              => T_high_gen(i),
                T_low_gen               => T_low_gen(i),
                HS_mode_gen             => HS_mode_gen(i),
                CBUS_mode_gen           => CBUS_mode_gen(i),
                MASTER_CODE_gen         => MASTER_CODE_gen(i),
                t_reset                 => 1 ns
            )
            PORT MAP (
                SDA                     => SDA,
                SCL                     => SCL
            );

        END GENERATE generate_instances;

    END vhdl_behavioral;
