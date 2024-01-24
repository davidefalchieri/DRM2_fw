-- Version: 7.0 SP1 7.0.1.14

library ieee;
use ieee.std_logic_1164.all;
library APA;

entity v1392ltm is

    port(AMB : in std_logic_vector(5 downto 0); GA : 
        in std_logic_vector(3 downto 0); ALICLK, ASB, BERRVME, 
        BNCRES, DS0B, DS1B, EVRES, F_SO, IACKB, IACKINB, L0, L1A, 
        L1R, L2A, L2R, LCLK, LOS, NLBPCKE, NLBPCKR, NLBRDY, NPWON, 
        PSM_SP0, PSM_SP1, PSM_SP2, PSM_SP3, PSM_SP4, PSM_SP5, 
        SPULSE0, SPULSE1, SPULSE2, SYSRESB, WRITEB : in std_logic; 
        AE_PDL : out std_logic_vector(47 downto 0); DIR_CTTM : 
        out std_logic_vector(7 downto 0); LED : 
        out std_logic_vector(5 downto 0); P_PDL : 
        out std_logic_vector(7 downto 1); SYNC : 
        out std_logic_vector(15 downto 0); TST : 
        out std_logic_vector(15 downto 0); ADLTC, FCS, F_SCK, 
        F_SI, IACKOUTB, INTR1, INTR2, LTM_BUSY, LTM_DRDY, MD_PDL, 
        MYBERR, NCYC_RELOAD, NDTKIN, NLBAS, NLBCLR, NLBCS, NLBRD, 
        NLBRES, NLBWAIT, NOE16R, NOE16W, NOE32R, NOE32W, NOE64R, 
        NOEAD, NOEDTK, NSELCLK, PSM_RES, RSELA0, RSELA1, RSELB0, 
        RSELB1, RSELC0, RSELC1, RSELD0, RSELD1, SCL0, SCL1, 
        SCLK_DAC, SCLK_PDL, SDIN_DAC, SELCLK, SI_PDL, NLBLAST : 
        out std_logic; LB : 
        inout std_logic_vector(31 downto 0) := (others => 'Z'); 
        LBSP : 
        inout std_logic_vector(31 downto 0) := (others => 'Z'); 
        SP_PDL : 
        inout std_logic_vector(47 downto 0) := (others => 'Z'); 
        VAD : 
        inout std_logic_vector(31 downto 1) := (others => 'Z'); 
        VDB : 
        inout std_logic_vector(31 downto 0) := (others => 'Z'); 
        LWORDB, SDA0, SDA1 : inout std_logic := 'Z');

end v1392ltm;

architecture DEF_ARCH of v1392ltm is 

  component NOR3
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component MUX2H
    port(A, B, S : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OR2
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component MUX2L
    port(A, B, S : in std_logic := 'U'; Y : out std_logic);
  end component;

  component DFFC
    port(CLK, D, CLR : in std_logic := 'U'; Q : out std_logic);
  end component;

  component OB33PH
    port(PAD : out std_logic; A : in std_logic := 'U');
  end component;

  component DFFS
    port(CLK, D, SET : in std_logic := 'U'; Q : out std_logic);
  end component;

  component AND2
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component NOR2
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OR2FT
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component XOR2
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AND2FT
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OAI21TTF
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AO21
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component NAND3FTT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AO21TTF
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component NAND2FT
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component IOB33PH
    port(PAD : inout std_logic; A, EN : in std_logic := 'U'; Y : 
        out std_logic);
  end component;

  component OA21FTT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AO21FTT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AOI21FTF
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component NOR2FT
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component NAND2
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component IB33
    port(PAD : in std_logic := 'U'; Y : out std_logic);
  end component;

  component XOR2FT
    port(A, B : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AOI21
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AOI21TTF
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component NAND3FFT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OA21TTF
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component NOR3FFT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OTB33PH
    port(PAD : out std_logic; A, EN : in std_logic := 'U');
  end component;

  component PLLCORE
    port(SDOUT : out std_logic; SCLK, SDIN, SSHIFT, SUPDATE : in
         std_logic := 'U'; GLB : out std_logic; CLK : in
         std_logic := 'U'; GLA : out std_logic; CLKA : in
         std_logic := 'U'; LOCK : out std_logic; MODE, FBDIV5, 
        EXTFB, FBSEL0, FBSEL1, FINDIV0, FINDIV1, FINDIV2, FINDIV3, 
        FINDIV4, FBDIV0, FBDIV1, FBDIV2, FBDIV3, FBDIV4, STATBSEL, 
        DLYB0, DLYB1, OBDIV0, OBDIV1, STATASEL, DLYA0, DLYA1, 
        OADIV0, OADIV1, OAMUX0, OAMUX1, OBMUX0, OBMUX1, OBMUX2, 
        FBDLY0, FBDLY1, FBDLY2, FBDLY3, XDLYSEL : in
         std_logic := 'U');
  end component;

  component OR3FTT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component INV
    port(A : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OR3
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OAI21FTF
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component DFF
    port(CLK, D : in std_logic := 'U'; Q : out std_logic);
  end component;

  component GND
    port(Y : out std_logic);
  end component;

  component NAND3
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OA21
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AND3
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OR3FFT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component NOR3FTT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AND3FTT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component BFR
    port(A : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OAI21FTT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AOI21FTT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OAI21
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component OA21FTF
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AO21FTF
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component AND3FFT
    port(A, B, C : in std_logic := 'U'; Y : out std_logic);
  end component;

  component FIFO256x9SST
    port(DO8, DO7, DO6, DO5, DO4, DO3, DO2, DO1, DO0, FULL, EMPTY, 
        EQTH, GEQTH, WPE, RPE, DOS : out std_logic; LGDEP2, 
        LGDEP1, LGDEP0, RESET, LEVEL7, LEVEL6, LEVEL5, LEVEL4, 
        LEVEL3, LEVEL2, LEVEL1, LEVEL0, DI8, DI7, DI6, DI5, DI4, 
        DI3, DI2, DI1, DI0, WRB, RDB, WBLKB, RBLKB, PARODD, WCLKS, 
        RCLKS, DIS : in std_logic := 'U');
  end component;

  component GL33
    port(PAD : in std_logic := 'U'; GL : out std_logic);
  end component;

  component PWR
    port(Y : out std_logic);
  end component;

  component LD
    port(EN, D : in std_logic := 'U'; Q : out std_logic);
  end component;

    signal CLKOUT, ACLKOUT, FULL, NPWON_c, SYSRESB_c, VDB_inl0r, 
        VDB_inl1r, VDB_inl2r, VDB_inl3r, VDB_inl4r, VDB_inl5r, 
        VDB_inl6r, VDB_inl7r, VDB_inl8r, VDB_inl9r, VDB_inl10r, 
        VDB_inl11r, VDB_inl12r, VDB_inl13r, VDB_inl14r, 
        VDB_inl15r, LCLK_c, ASB_c, ALICLK_c, \I2.N_2732_i_0\, 
        \I2.N_2732_0\, \I2.N_2768_i_0\, \I2.N_2768_0\, VDB_inl31r, 
        \I2.VDBml31r_net_1\, VDB_inl30r, \I2.VDBml30r_net_1\, 
        VDB_inl29r, \I2.VDBml29r_net_1\, VDB_inl28r, 
        \I2.VDBml28r_net_1\, VDB_inl27r, \I2.VDBml27r_net_1\, 
        VDB_inl26r, \I2.VDBml26r_net_1\, VDB_inl25r, 
        \I2.VDBml25r_net_1\, VDB_inl24r, \I2.VDBml24r_net_1\, 
        VDB_inl23r, \I2.VDBml23r_net_1\, VDB_inl22r, 
        \I2.VDBml22r_net_1\, VDB_inl21r, \I2.VDBml21r_net_1\, 
        VDB_inl20r, \I2.VDBml20r_net_1\, VDB_inl19r, 
        \I2.VDBml19r_net_1\, VDB_inl18r, \I2.VDBml18r_net_1\, 
        VDB_inl17r, \I2.VDBml17r_net_1\, VDB_inl16r, 
        \I2.VDBml16r_net_1\, \I2.VDBml15r_net_1\, 
        \I2.VDBml14r_net_1\, \I2.VDBml13r_net_1\, 
        \I2.VDBml12r_net_1\, \I2.VDBml11r_net_1\, 
        \I2.VDBml10r_net_1\, \I2.VDBml9r_net_1\, 
        \I2.VDBml8r_net_1\, \I2.VDBml7r_net_1\, 
        \I2.VDBml6r_net_1\, \I2.VDBml5r_net_1\, 
        \I2.VDBml4r_net_1\, \I2.VDBml3r_net_1\, 
        \I2.VDBml2r_net_1\, \I2.VDBml1r_net_1\, 
        \I2.VDBml0r_net_1\, VAD_inl31r, \I2.VADml31r_net_1\, 
        VAD_inl30r, \I2.VADml30r_net_1\, VAD_inl29r, 
        \I2.VADml29r_net_1\, VAD_inl28r, \I2.VADml28r_net_1\, 
        \I2.VADml27r_net_1\, \I2.VADml26r_net_1\, 
        \I2.VADml25r_net_1\, \I2.VADml24r_net_1\, 
        \I2.VADml23r_net_1\, \I2.VADml22r_net_1\, 
        \I2.VADml21r_net_1\, \I2.VADml20r_net_1\, 
        \I2.VADml19r_net_1\, \I2.VADml18r_net_1\, 
        \I2.VADml17r_net_1\, \I2.VADml16r_net_1\, VAD_inl15r, 
        \I2.VADml15r_net_1\, VAD_inl14r, \I2.VADml14r_net_1\, 
        VAD_inl13r, \I2.VADml13r_net_1\, VAD_inl12r, 
        \I2.VADml12r_net_1\, VAD_inl11r, \I2.VADml11r_net_1\, 
        VAD_inl10r, \I2.VADml10r_net_1\, VAD_inl9r, 
        \I2.VADml9r_net_1\, VAD_inl8r, \I2.VADml8r_net_1\, 
        VAD_inl7r, \I2.VADml7r_net_1\, VAD_inl6r, 
        \I2.VADml6r_net_1\, VAD_inl5r, \I2.VADml5r_net_1\, 
        VAD_inl4r, \I2.VADml4r_net_1\, VAD_inl3r, 
        \I2.VADml3r_net_1\, VAD_inl2r, \I2.VADml2r_net_1\, 
        VAD_inl1r, \I2.VADml1r_net_1\, SP_PDL_inl47r, REGl129r, 
        MD_PDL_c, SP_PDL_inl46r, SP_PDL_inl45r, SP_PDL_inl44r, 
        SP_PDL_inl43r, SP_PDL_inl42r, SP_PDL_inl41r, 
        SP_PDL_inl40r, SP_PDL_inl39r, SP_PDL_inl38r, 
        SP_PDL_inl37r, SP_PDL_inl36r, SP_PDL_inl35r, 
        SP_PDL_inl34r, SP_PDL_inl33r, SP_PDL_inl32r, 
        SP_PDL_inl31r, MD_PDL_C_0, SP_PDL_inl30r, SP_PDL_inl29r, 
        SP_PDL_inl28r, SP_PDL_inl27r, SP_PDL_inl26r, 
        SP_PDL_inl25r, SP_PDL_inl24r, SP_PDL_inl23r, 
        SP_PDL_inl22r, SP_PDL_inl21r, SP_PDL_inl20r, 
        SP_PDL_inl19r, SP_PDL_inl18r, SP_PDL_inl17r, 
        SP_PDL_inl16r, SP_PDL_inl15r, SP_PDL_inl14r, 
        SP_PDL_inl13r, SP_PDL_inl12r, SP_PDL_inl11r, 
        SP_PDL_inl10r, SP_PDL_inl9r, SP_PDL_inl8r, SP_PDL_inl7r, 
        REGL129R_1, SP_PDL_inl6r, SP_PDL_inl5r, SP_PDL_inl4r, 
        SP_PDL_inl3r, SP_PDL_inl2r, SP_PDL_inl1r, SP_PDL_inl0r, 
        SDA1_in, \I1.SDAout_del2_net_1\, SDA0_in, LWORDB_in, 
        \I2.VADml0r_net_1\, LBSP_inl31r, REGl424r, LBSP_inl30r, 
        REGl423r, LBSP_inl29r, REGl422r, LBSP_inl28r, REGl421r, 
        LBSP_inl27r, REGl420r, LBSP_inl26r, REGl419r, LBSP_inl25r, 
        REGl418r, LBSP_inl24r, REGl417r, LBSP_inl23r, REGl416r, 
        LBSP_inl22r, REGl415r, LBSP_inl21r, REGl414r, LBSP_inl20r, 
        REGl413r, LBSP_inl19r, REGl412r, LBSP_inl18r, REGl411r, 
        LBSP_inl17r, REGl410r, LBSP_inl16r, REGl409r, LBSP_inl15r, 
        REGl408r, LBSP_inl14r, REGl407r, LBSP_inl13r, REGl406r, 
        LBSP_inl12r, REGl405r, LBSP_inl11r, REGl404r, LBSP_inl10r, 
        REGl403r, LBSP_inl9r, REGl402r, LBSP_inl8r, REGl401r, 
        LBSP_inl7r, REGl400r, LBSP_inl6r, REGl399r, LBSP_inl5r, 
        REGl398r, LBSP_inl4r, REGl397r, LBSP_inl3r, REGl396r, 
        LBSP_inl2r, REGl395r, LBSP_inl1r, REGl394r, LBSP_inl0r, 
        REGl393r, LB_inl31r, LB_inl30r, LB_inl29r, LB_inl28r, 
        LB_inl27r, LB_inl26r, LB_inl25r, LB_inl24r, LB_inl23r, 
        LB_inl22r, LB_inl21r, LB_inl20r, LB_inl19r, LB_inl18r, 
        LB_inl17r, LB_inl16r, LB_inl15r, LB_inl14r, LB_inl13r, 
        LB_inl12r, LB_inl11r, LB_inl10r, LB_inl9r, LB_inl8r, 
        LB_inl7r, LB_inl6r, LB_inl5r, LB_inl4r, LB_inl3r, 
        LB_inl2r, LB_inl1r, LB_inl0r, \VCC\, \GND\, TST_cl5r, 
        TST_cl4r, TST_c_cl3r, TST_cl2r, TST_cl0r, REG_cl248r, 
        REG_cl247r, REG_cl246r, REG_cl245r, REG_cl244r, 
        REG_cl243r, SYNC_cl9r, SYNC_cl8r, SYNC_cl7r, SYNC_cl6r, 
        SYNC_cl5r, SYNC_cl4r, SYNC_cl3r, SYNC_cl2r, SYNC_cl1r, 
        SYNC_cl0r, SI_PDL_c, SDIN_DAC_c, SCLK_PDL_c, SCLK_DAC_c, 
        SCLB_i_a2, SCLA_i_a2, REGl425r, REGl426r, REGl427r, 
        REGl428r, REGl429r, REGl430r, REGl431r, REGl432r, 
        REG_cl136r, REG_cl135r, REG_cl134r, REG_cl133r, 
        REG_cl132r, REG_cl131r, REG_cl130r, NSELCLK_c, 
        HWRES_c_i_0, NLBCLR_c, NDTKIN_c, NCYC_RELOAD_c, MYBERR_c, 
        EVRDY_c, \I5.ISI_net_1\, \I5.DRIVECS_net_1\, 
        \I5.ISCK_net_1\, un1_reg_1, WRITEB_c, SPULSE2_c, 
        SPULSE1_c, SPULSE0_c, PSM_SP5_c, PSM_SP4_c, PSM_SP3_c, 
        NLBRDY_c, LOS_c, L2R_c, L2A_c, L1R_c, L1A_c, L0_c, 
        IACKB_c, GA_cl3r, GA_cl2r, GA_cl1r, GA_cl0r, F_SO_c, 
        DS1B_c, DS0B_c, BNCRES_c, AMB_cl5r, AMB_cl4r, AMB_cl3r, 
        AMB_cl2r, AMB_cl1r, AMB_cl0r, TICKl2r, PULSEl9r, REGl249r, 
        REGl250r, REGl251r, REGl252r, REGl253r, REGl254r, 
        REGl255r, REGl256r, REGl257r, REGl258r, REGl259r, 
        REGl260r, REGl261r, REGl262r, REGl263r, REGl264r, 
        PULSEl7r, I2C_RDATAl0r, I2C_RDATAl1r, I2C_RDATAl2r, 
        I2C_RDATAl3r, I2C_RDATAl4r, I2C_RDATAl5r, I2C_RDATAl6r, 
        I2C_RDATAl7r, I2C_RDATAl8r, I2C_RDATAl9r, REGl7r, 
        CHIP_ADDRl0r, CHIP_ADDRl1r, CHIP_ADDRl2r, CHANNELl0r, 
        CHANNELl1r, CHANNELl2r, TICKl0r, REGL7R_2, REGl113r, 
        REGl114r, REGl115r, REGl116r, REGl117r, REGl118r, 
        REGl119r, REGl120r, REGl6r, REGl105r, REGl90r, REGl91r, 
        REGl97r, REGl98r, REGl99r, REGl100r, REGl101r, REGl102r, 
        REGl103r, REGl104r, REGl89r, REGl106r, I2C_RVALID, 
        I2C_CHAIN, I2C_RREQ, PULSEl1r, REGl8r, REGl506r, BNC_RES, 
        \I10.PLL_LOCK_lclk\, \I10.PLL_LOCK_aclk\, WDOGTO_i_0, 
        CLEAR_i_0, HWRES_c_2_0, LOAD_RES, CLEAR_0_0, DPRl0r, 
        DPRl1r, DPRl2r, DPRl3r, DPRl4r, DPRl5r, DPRl6r, DPRl7r, 
        DPRl8r, DPRl9r, DPRl10r, DPRl11r, DPRl12r, DPRl13r, 
        DPRl14r, DPRl15r, DPRl16r, DPRl17r, DPRl18r, DPRl19r, 
        DPRl20r, DPRl21r, DPRl22r, DPRl23r, DPRl24r, DPRl25r, 
        DPRl26r, DPRl27r, DPRl28r, DPRl29r, DPRl30r, DPRl31r, 
        PULSEl2r, PULSEl3r, REG_i_0l38r, REG_i_0l43r, REG_i_0l44r, 
        REGl48r, REGl49r, REGl50r, REGl51r, REGl52r, REGl53r, 
        REGl54r, REGl55r, REGl56r, REGl57r, REGl58r, REGl59r, 
        REGl60r, REGl61r, REGl62r, REGl63r, REGl64r, REGl65r, 
        REGl66r, REGl67r, REGl68r, REGl69r, REGl70r, REGl71r, 
        REGl72r, REGl73r, REGl74r, REGl75r, REGl76r, REGl77r, 
        REGl78r, REGl79r, REGl32r, REGl45r, REGl34r, REGl47r, 
        REGl33r, REGl459r, REGl468r, REGl457r, REGl460r, REGl458r, 
        REGl465r, REGl466r, REGl461r, REGl463r, REGl464r, 
        REGl467r, REGl5r, REGl384r, REGl462r, REGl46r, NRDMEB, 
        DTEST_FIFO, EVREAD, REGl473r, REGl80r, REGl81r, REGl82r, 
        REGl83r, REGl84r, REGl85r, REGl86r, REGl87r, REGl88r, 
        FBOUTl0r, FBOUTl1r, FBOUTl2r, FBOUTl3r, FBOUTl4r, 
        FBOUTl5r, FBOUTl6r, FBOUTl7r, PULSEl6r, PULSEl0r, 
        PULSEl10r, PULSEl8r, REGl127r, REGl126r, REGl124r, 
        REGl123r, REGl137r, REGl153r, REGl169r, REGl185r, 
        REGl122r, REGl154r, REGl170r, REGl186r, REGl138r, 
        REGl155r, REGl171r, REGl139r, REGl187r, REGl156r, 
        REGl172r, REGl140r, REGl188r, REGl157r, REGl173r, 
        REGl125r, REGl141r, REGl189r, REGl158r, REGl174r, 
        REGl142r, REGl190r, REGl159r, REGl175r, REGl143r, 
        REGl191r, REGl160r, REGl176r, REGl144r, REGl192r, 
        REGl145r, REGl161r, REGl177r, REGl193r, REGl162r, 
        REGl178r, REGl194r, REGl163r, REGl179r, REGl195r, 
        REGl164r, REGl180r, REGl196r, REGl165r, REGl181r, 
        REGl197r, REGl166r, REGl182r, REGl198r, REGl167r, 
        REGl183r, REGl199r, REGl168r, REGl184r, REGl200r, 
        REGL127R_3, REGL126R_4, REGL124R_5, REGL123R_6, 
        MD_PDL_C_7, \I8.sstatel1r_net_1\, \I8.sstatel0r_net_1\, 
        \I8.N_198_0\, \I8.N_228\, 
        \I8.DWACT_ADD_CI_0_g_array_1l0r\, 
        \I8.DWACT_ADD_CI_0_TMPl0r\, \I8.BITCNTl1r_net_1\, 
        \I8.DWACT_ADD_CI_0_g_array_12l0r\, \I8.BITCNTl2r_net_1\, 
        \I8.sstate_ns_il0r_net_1\, \I8.N_209\, 
        \I8.BITCNTl0r_net_1\, \I8.BITCNTl3r_net_1\, 
        \I8.un1_ISI_1_sqmuxa_0_o2_net_1\, \I8.ISI_17_net_1\, 
        \I8.ISI_5\, \I8.SWORDl15r_net_1\, \I8.SWORD_0_sqmuxa\, 
        \I8.SWORD_16_net_1\, \I8.SWORD_5l15r_net_1\, 
        \I8.SWORDl14r_net_1\, \I8.SWORD_15_net_1\, 
        \I8.SWORD_5l14r_net_1\, \I8.SWORDl13r_net_1\, 
        \I8.SWORD_14_net_1\, \I8.SWORD_5l13r_net_1\, 
        \I8.SWORDl12r_net_1\, \I8.SWORD_13_net_1\, 
        \I8.SWORD_5l12r_net_1\, \I8.SWORDl11r_net_1\, 
        \I8.SWORD_12_net_1\, \I8.SWORD_5l11r_net_1\, 
        \I8.SWORDl10r_net_1\, \I8.SWORD_11_net_1\, 
        \I8.SWORD_5l10r_net_1\, \I8.SWORDl9r_net_1\, 
        \I8.SWORD_10_net_1\, \I8.SWORD_5l9r_net_1\, 
        \I8.SWORDl8r_net_1\, \I8.SWORD_9_net_1\, 
        \I8.SWORD_5l8r_net_1\, \I8.SWORDl7r_net_1\, 
        \I8.SWORD_8_net_1\, \I8.SWORD_5l7r_net_1\, 
        \I8.SWORDl6r_net_1\, \I8.SWORD_7_net_1\, 
        \I8.SWORD_5l6r_net_1\, \I8.SWORDl5r_net_1\, 
        \I8.SWORD_6_net_1\, \I8.SWORD_5l5r_net_1\, 
        \I8.SWORDl4r_net_1\, \I8.SWORD_5_net_1\, 
        \I8.SWORD_5l4r_net_1\, \I8.SWORDl3r_net_1\, 
        \I8.SWORD_4_net_1\, \I8.SWORD_5l3r_net_1\, 
        \I8.SWORDl2r_net_1\, \I8.SWORD_3_net_1\, 
        \I8.SWORD_5l2r_net_1\, \I8.SWORDl1r_net_1\, 
        \I8.SWORD_2_net_1\, \I8.SWORD_5l1r_net_1\, 
        \I8.SWORDl0r_net_1\, \I8.SWORD_1_net_1\, 
        \I8.SWORD_5l0r_net_1\, \I8.BITCNT_6l3r\, \I8.I_17\, 
        \I8.BITCNT_6l2r\, \I8.I_18\, \I8.BITCNT_6l1r\, \I8.I_15\, 
        \I8.BITCNT_6l0r\, \I8.DWACT_ADD_CI_0_partial_suml0r\, 
        \I1.REG_1_105_13_net_1\, \I1.sstate2_ns_el0r\, 
        \I1.sstatel13r_net_1\, \I1.sstate_ns_el0r\, 
        \I1.sstate2_0_sqmuxa_4_0\, \I1.sstate2l1r_net_1\, 
        \I1.N_625_0\, \I1.N_544\, \I1.sstatel11r_net_1\, 
        \I1.N_277_0\, \I1.DWACT_ADD_CI_0_g_array_1l0r\, 
        \I1.DWACT_ADD_CI_0_TMPl0r\, \I1.BITCNTl1r_net_1\, 
        \I1.CHAIN_SELECT_net_1\, \I1.SCL_net_1\, 
        \I1.DATA_12_ivl1r\, \I1.DATA_12_iv_0_a2_0_0_il1r\, 
        \I1.N_633\, \I1.sstatel1r_net_1\, \I1.N_630\, 
        \I1.sstatese_1_i_net_1\, \I1.sstatel12r_net_1\, 
        \I1.sstatese_3_i_0_net_1\, \I1.sstatel9r_net_1\, 
        \I1.sstatel10r_net_1\, \I1.sstatese_6_i_0_net_1\, 
        \I1.sstatel6r_net_1\, \I1.sstatel7r_net_1\, 
        \I1.sstatese_9_i_net_1\, \I1.sstate_i_0_il3r\, 
        \I1.sstatel4r_net_1\, \I1.sstatese_11_i_net_1\, 
        \I1.sstatel2r_net_1\, \I1.sstatese_12_i_0_net_1\, 
        \I1.sstatel0r_net_1\, \I1.sstate_ns_el11r\, 
        \I1.BITCNT_2_sqmuxa\, \I1.sstate_ns_el9r\, 
        \I1.sstatel5r_net_1\, \I1.sstate_ns_el8r\, \I1.N_467\, 
        \I1.sstatese_7_0_0_net_1\, \I1.N_435\, \I1.N_681_1\, 
        \I1.sstate_ns_el6r\, \I1.sstatel8r_net_1\, 
        \I1.sstate_ns_el5r\, \I1.sstate_ns_el3r\, 
        \I1.sstate_ns_el1r\, \I1.N_452\, \I1.N_453_i\, 
        \I1.N_455_i\, \I1.COMMANDl2r_net_1\, \I1.PULSE_FL_net_1\, 
        \I1.I2C_RVALID_2\, \I1.sstate2l0r_net_1\, 
        \I1.sstate2se_2_i_net_1\, \I1.sstate2l7r_net_1\, 
        \I1.sstate2l6r_net_1\, \I1.sstate2se_3_i_net_1\, 
        \I1.sstate2l5r_net_1\, \I1.sstate2se_4_i_net_1\, 
        \I1.sstate2l4r_net_1\, \I1.sstate2se_5_i_net_1\, 
        \I1.sstate2l3r_net_1\, \I1.sstate2se_6_i_net_1\, 
        \I1.sstate2l2r_net_1\, \I1.sstate2se_7_i_net_1\, 
        \I1.sstate2se_8_i_net_1\, \I1.sstate2_ns_el2r\, 
        \I1.sstate2l8r_net_1\, \I1.sstate2_ns_el1r\, \I1.N_279\, 
        \I1.SDAnoe_48_net_1\, \I1.SDAnoe_net_1\, \I1.SDAnoe_8\, 
        \I1.N_517_3\, \I1.SDAnoe_m_1_net_1\, \I1.N_408\, 
        \I1.AIR_COMMAND_47_net_1\, \I1.AIR_COMMAND_21l15r\, 
        \I1.AIR_COMMANDl15r_net_1\, \I1.un1_tick_12_net_1\, 
        \I1.AIR_COMMAND_46_net_1\, \I1.AIR_COMMAND_21l14r_net_1\, 
        \I1.AIR_COMMANDl14r_net_1\, \I1.N_565_i_i\, 
        \I1.REG_m_il103r\, \I1.AIR_COMMAND_45_net_1\, 
        \I1.AIR_COMMAND_21l13r\, \I1.AIR_COMMANDl13r_net_1\, 
        \I1.AIR_COMMAND_44_net_1\, \I1.AIR_COMMAND_21l12r\, 
        \I1.AIR_COMMANDl12r_net_1\, \I1.sstate2l9r_net_1\, 
        \I1.AIR_COMMAND_43_net_1\, \I1.AIR_COMMAND_21l11r\, 
        \I1.AIR_COMMANDl11r_net_1\, \I1.AIR_COMMAND_42_net_1\, 
        \I1.AIR_COMMAND_21l10r\, \I1.AIR_COMMANDl10r_net_1\, 
        \I1.AIR_COMMAND_cnstl10r\, \I1.N_256\, 
        \I1.AIR_COMMAND_21_0_iv_0l10r_net_1\, 
        \I1.CHIP_ADDR_ml1r_net_1\, \I1.AIR_COMMAND_41_net_1\, 
        \I1.AIR_COMMAND_21l9r\, \I1.AIR_COMMANDl9r_net_1\, 
        \I1.AIR_COMMAND_40_net_1\, \I1.AIR_COMMAND_21l8r\, 
        \I1.AIR_COMMANDl8r_net_1\, 
        \I1.AIR_COMMAND_21_0_iv_0l8r_net_1\, \I1.N_278\, 
        \I1.AIR_COMMAND_39_net_1\, \I1.AIR_COMMAND_21l2r_net_1\, 
        \I1.AIR_COMMANDl2r_net_1\, \I1.N_487\, 
        \I1.sstate2_0_sqmuxa\, \I1.sstate2_0_sqmuxa_3\, 
        \I1.AIR_COMMAND_38_net_1\, \I1.AIR_COMMAND_21l1r_net_1\, 
        \I1.AIR_COMMANDl1r_net_1\, \I1.AIR_COMMAND_cnstl1r\, 
        \I1.AIR_COMMAND_37_net_1\, \I1.AIR_COMMAND_21l0r_net_1\, 
        \I1.AIR_COMMANDl0r_net_1\, 
        \I1.un1_AIR_CHAIN_1_sqmuxa_5_net_1\, \I1.N_3146_i\, 
        \I1.SDAout_36_net_1\, \I1.SDAout_net_1\, \I1.SDAout_11\, 
        \I1.N_524\, \I1.COMMANDl0r_net_1\, \I1.COMMANDl15r_net_1\, 
        \I1.N_536\, \I1.SDAout_11_iv_0_net_1\, 
        \I1.COMMANDl1r_net_1\, \I1.SBYTEl7r_net_1\, 
        \I1.SDAout_m_net_1\, \I1.SBYTE_35_net_1\, \I1.N_610\, 
        \I1.un1_tick_8\, \I1.SBYTEl6r_net_1\, \I1.SBYTE_34_net_1\, 
        \I1.N_608\, \I1.COMMANDl14r_net_1\, \I1.SBYTEl5r_net_1\, 
        \I1.SBYTE_33_net_1\, \I1.N_606\, \I1.COMMANDl13r_net_1\, 
        \I1.SBYTEl4r_net_1\, \I1.SBYTE_32_net_1\, \I1.N_604\, 
        \I1.COMMANDl12r_net_1\, \I1.SBYTEl3r_net_1\, 
        \I1.SBYTE_31_net_1\, \I1.N_602\, \I1.COMMANDl11r_net_1\, 
        \I1.SBYTEl2r_net_1\, \I1.SBYTE_30_net_1\, \I1.N_600\, 
        \I1.COMMANDl10r_net_1\, \I1.SBYTEl1r_net_1\, 
        \I1.SBYTE_29_net_1\, \I1.N_598\, \I1.COMMANDl9r_net_1\, 
        \I1.SBYTEl0r_net_1\, \I1.SBYTE_28_net_1\, \I1.SBYTE_9l0r\, 
        \I1.COMMANDl8r_net_1\, \I1.SCL_27_net_1\, \I1.N_661\, 
        \I1.N_634\, \I1.START_I2C_26_net_1\, \I1.START_I2C_net_1\, 
        \I1.START_I2C_2\, \I1.START_I2C_2_iv_0_net_1\, 
        \I1.AIR_CHAIN_25_net_1\, \I1.AIR_CHAIN_net_1\, 
        \I1.AIR_CHAIN_3\, \I1.AIR_CHAIN_3_iv_0_net_1\, 
        \I1.I2C_CHAIN_m_net_1\, \I1.CHAIN_SELECT_24_net_1\, 
        \I1.CHAIN_SELECT_4\, \I1.CHAIN_SELECT_m_i\, 
        \I1.AIR_CHAIN_m_0_i\, \I1.I2C_RDATA_23_net_1\, \I1.N_592\, 
        \I1.N_276\, \I1.I2C_RDATA_22_net_1\, \I1.N_590\, 
        \I1.I2C_RDATA_21_net_1\, \I1.N_588\, 
        \I1.I2C_RDATA_20_net_1\, \I1.N_586\, 
        \I1.I2C_RDATA_19_net_1\, \I1.N_584\, 
        \I1.I2C_RDATA_18_net_1\, \I1.N_582\, 
        \I1.I2C_RDATA_17_net_1\, \I1.N_580\, 
        \I1.I2C_RDATA_16_net_1\, \I1.N_578\, 
        \I1.I2C_RDATA_15_net_1\, \I1.N_576\, \I1.N_631\, 
        \I1.I2C_RDATA_14_net_1\, \I1.N_574\, \I1.PULSE_I2C_net_1\, 
        \I1.PULSE_FL_12_net_1\, \I1.COMMAND_11_net_1\, 
        \I1.COMMAND_4l15r_net_1\, \I1.COMMAND_10_net_1\, 
        \I1.COMMAND_4l14r_net_1\, \I1.COMMAND_9_net_1\, 
        \I1.COMMAND_4l13r_net_1\, \I1.COMMAND_8_net_1\, 
        \I1.COMMAND_4l12r_net_1\, \I1.COMMAND_7_net_1\, 
        \I1.COMMAND_4l11r_net_1\, \I1.SSTATEL13R_8\, 
        \I1.COMMAND_6_net_1\, \I1.COMMAND_4l10r_net_1\, 
        \I1.COMMAND_5_net_1\, \I1.COMMAND_4l9r_net_1\, 
        \I1.COMMAND_4_net_1\, \I1.COMMAND_4l8r_net_1\, 
        \I1.COMMAND_3_net_1\, \I1.COMMAND_4l2r_net_1\, 
        \I1.COMMAND_2_net_1\, \I1.COMMAND_4l1r_net_1\, 
        \I1.COMMAND_1_net_1\, \I1.COMMAND_4l0r_net_1\, 
        \I1.BITCNT_10l2r\, \I1.I_14\, \I1.BITCNT_0_sqmuxa_2\, 
        \I1.BITCNT_10l1r\, \I1.I_13\, \I1.BITCNT_10l0r\, 
        \I1.DWACT_ADD_CI_0_partial_suml0r\, \I1.N_468\, 
        \I1.BITCNTl2r_net_1\, \I1.un1_tick_10_0_net_1\, 
        \I1.DATA_12l15r_net_1\, \I1.DATA_1_sqmuxa_2\, 
        \I1.DATA_12l14r_net_1\, \I1.DATA_12l13r_net_1\, 
        \I1.DATA_12l12r_net_1\, \I1.DATA_12l11r_net_1\, 
        \I1.DATA_12l10r_net_1\, \I1.DATA_12l9r_net_1\, 
        \I1.DATA_12l8r_net_1\, \I1.BITCNT_i_il0r\, 
        \I1.SDAnoe_del_net_1\, \I1.SDAnoe_del1_net_1\, 
        \I1.SDAout_del_net_1\, \I1.SDAout_del1_net_1\, 
        \I0.CLEAR_0_a2_0_net_1\, \I0.HWCLEARi_2_net_1\, 
        \I0.N_111_i_0\, \I0.BNC_RESi_1_net_1\, 
        \I0.BNC_RES1_net_1\, \I0.HWCLEARi_2_0_i\, 
        \I10.ADD_16x16_medium_I79_Y\, 
        \I10.ADD_16x16_medium_I58_Y\, 
        \I10.ADD_16x16_medium_I79_Y_0\, \I10.N_2519_1\, 
        \I10.ADD_16x16_medium_I58_un1_Y\, \I10.N300\, \I10.N292\, 
        \I10.ADD_16x16_medium_I51_un1_Y_2\, 
        \I10.ADD_16x16_medium_I51_Y_2\, \I10.N267\, \I10.N277\, 
        \I10.N264\, \I10.N265\, \I10.N263_i\, 
        \I10.un1_REG_1_1l36r\, \I10.un1_REG_1_1l37r\, 
        \I10.REGl36r\, \I10.FIFO_END_EVNT_net_1\, 
        \I10.STATE1l4r_net_1\, \I10.OR_RREQ_net_1\, \I10.N_2285\, 
        \I10.N_2357\, \I10.G_1_0_0_net_1\, \I10.G_0_net_1\, 
        \I10.un1_CNT_1_il6r\, \I10.N_2287\, \I10.CNTl5r_net_1\, 
        \I10.G_1_0_net_1\, \I10.CNTl1r_net_1\, \I10.CNTl4r_net_1\, 
        \I10.CNTl0r_net_1\, \I10.DWACT_ADD_CI_0_TMPl0r\, 
        \I10.DWACT_ADD_CI_0_g_array_1l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_2l0r\, 
        \I10.un6_bnc_res_NE_16_i\, \I10.G_3_i\, 
        \I10.un6_bnc_res_5_i_i_i_i\, \I10.un6_bnc_res_0_i_i\, 
        \I10.G_1_i\, \I10.un6_bnc_res_2_i_i\, 
        \I10.un6_bnc_res_11_i_i\, \I10.un6_bnc_res_3_i_i\, 
        \I10.BNCRES_CNT_4l7r\, \I10.BNCRES_CNTl7r_net_1\, 
        \I10.G_1_1_net_1\, \I10.G_1_1_3_i\, 
        \I10.un6_bnc_res_NE_0_net_1\, \I10.BNCRES_CNTl0r_net_1\, 
        \I10.G_1_1_0_net_1\, \I10.BNCRES_CNTl1r_net_1\, 
        \I10.BNCRES_CNTl6r_net_1\, \I10.BNC_NUMBER_1_sqmuxa\, 
        \I10.DWACT_ADD_CI_0_TMP_0l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_11l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_1_0l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_2_0l0r\, \I10.G_2_4_i\, 
        \I10.un6_bnc_res_NE_14_i\, \I10.un6_bnc_res_NE_15_i\, 
        \I10.BNC_CNTl5r_net_1\, \I10.N_557_i_0\, \I10.N_2351_0_0\, 
        \I10.STATE1l1r_net_1\, \I10.CNTL0R_9\, 
        \I10.CNT_10_i_0l0r_net_1\, \I10.CNT_10_i_0l1r_net_1\, 
        \I10.STATE1l12r_net_1\, \I10.STATE1L12R_10\, 
        \I10.CNTl2r_net_1\, \I10.CNT_10_i_0l2r_net_1\, 
        \I10.CNT_10_i_0l3r_net_1\, \I10.CNT_10_i_0l4r_net_1\, 
        \I10.STATE1_nsl11r\, \I10.STATE1_nsl1r\, 
        \I10.STATE1l11r_net_1\, \I10.STATE1_nsl3r\, 
        \I10.STATE1l2r_net_1\, \I10.un1_STATE1_15_1\, 
        \I10.STATE1_nsl2r\, \I10.un1_STATE1_14_1_0\, 
        \I10.STATE1l6r_net_1\, \I10.un1_STATE1_14_1\, 
        \I10.N_2275_i_1\, \I10.STATE1l5r_net_1\, \I10.N_2276_i_0\, 
        \I10.N_2639\, \I10.DWACT_ADD_CI_0_g_array_3_0l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_12l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_12_1l0r\, 
        \I10.BNCRES_CNTl4r_net_1\, 
        \I10.DWACT_ADD_CI_0_g_array_12_0l0r\, 
        \I10.BNCRES_CNTl2r_net_1\, \I10.EVNT_NUMl2r_net_1\, 
        \I10.FAULT_STROBE_2_i_net_1\, \I10.FAULT_STROBE_0_net_1\, 
        \I10.CLEAR_PSM_FLAGS_net_1\, \I10.un1_REG_1_il38r\, 
        \I10.ADD_16x16_medium_I70_Y_0\, \I10.un1_REG_1_il43r\, 
        \I10.N322\, \I10.ADD_16x16_medium_I75_Y_0\, \I10.N239\, 
        \I10.N304\, \I10.N238\, \I10.un1_REG_1_il44r\, \I10.N302\, 
        \I10.ADD_16x16_medium_I76_Y_0\, 
        \I10.STATE1_ns_i_0_0_0_4l0r_net_1\, \I10.N_2381\, 
        \I10.STATE1l3r_net_1\, \I10.STATE1_ns_1l3r\, 
        \I10.STATE2_nsl1r\, \I10.STATE2l2r_net_1\, 
        \I10.STATE2_nsl0r\, \I10.STATE2l1r_net_1\, 
        \I10.EVNT_TRG_net_1\, \I10.RDY_CNTl1r_net_1\, 
        \I10.RDY_CNTl0r_net_1\, \I10.I_24_0\, \I10.I_23\, 
        \I10.I_22\, \I10.I_21\, 
        \I10.DWACT_ADD_CI_0_partial_suml0r\, 
        \I10.STATE1l8r_net_1\, \I10.STATE1l7r_net_1\, 
        \I10.RDY_CNT_10_i_0l1r_net_1\, \I10.N_2308\, \I10.I_10\, 
        \I10.RDY_CNT_10_i_0l0r_net_1\, 
        \I10.DWACT_ADD_CI_0_partial_sum_0l0r\, 
        \I10.FAULT_STROBE_0_2\, \I10.CYC_STAT_1_2\, 
        \I10.CYC_STAT_0_net_1\, \I10.CYC_STAT_0_2\, 
        \I10.BNC_NUMBER_0_sqmuxa\, \I10.STATE2_nsl2r\, 
        \I10.READ_OR_FLAG_85_i_0_0_net_1\, 
        \I10.READ_PDL_FLAG_net_1\, \I10.PDL_RREQ_net_1\, 
        \I10.STATE1_nsl6r\, \I10.STATE1_nsl5r\, 
        \I10.STATE1_ns_0_0_0_il5r\, \I10.READ_ADC_FLAG_net_1\, 
        \I10.N_2382\, \I10.BNC_NUMBER_238_net_1\, 
        \I10.BNC_NUMBERl8r_net_1\, \I10.BNCRES_CNTl8r_net_1\, 
        \I10.BNC_NUMBER_237_net_1\, \I10.BNC_NUMBERl7r_net_1\, 
        \I10.BNC_NUMBER_236_net_1\, \I10.BNC_NUMBERl6r_net_1\, 
        \I10.BNC_NUMBER_235_net_1\, \I10.BNC_NUMBERl5r_net_1\, 
        \I10.BNCRES_CNTl5r_net_1\, \I10.BNC_NUMBER_234_net_1\, 
        \I10.BNC_NUMBERl4r_net_1\, \I10.BNC_NUMBER_233_net_1\, 
        \I10.BNC_NUMBERl3r_net_1\, \I10.BNCRES_CNTl3r_net_1\, 
        \I10.BNC_NUMBER_232_net_1\, \I10.BNC_NUMBERl2r_net_1\, 
        \I10.BNC_NUMBER_231_net_1\, \I10.BNC_NUMBERl1r_net_1\, 
        \I10.BNC_NUMBER_230_net_1\, \I10.BNC_NUMBERl0r_net_1\, 
        \I10.PDL_RADDRl5r_net_1\, \I10.PDL_RADDRl4r_net_1\, 
        \I10.CNTl3r_net_1\, \I10.PDL_RADDRl3r_net_1\, 
        \I10.CNTL2R_11\, \I10.PDL_RADDRl2r_net_1\, 
        \I10.PDL_RADDRl1r_net_1\, \I10.PDL_RADDRl0r_net_1\, 
        \I10.OR_RADDR_223_net_1\, \I10.OR_RADDRl5r_net_1\, 
        \I10.N_2126\, \I10.OR_RADDR_222_net_1\, 
        \I10.OR_RADDRl4r_net_1\, \I10.OR_RADDR_221_net_1\, 
        \I10.OR_RADDRl3r_net_1\, \I10.OR_RADDR_220_net_1\, 
        \I10.OR_RADDRl2r_net_1\, \I10.OR_RADDR_219_net_1\, 
        \I10.OR_RADDRl1r_net_1\, \I10.OR_RADDR_218_net_1\, 
        \I10.OR_RADDRl0r_net_1\, \I10.BNC_CNT_217_net_1\, 
        \I10.BNC_CNTl19r_net_1\, \I10.BNC_CNT_4l19r\, 
        \I10.BNC_CNT_216_net_1\, \I10.BNC_CNT_i_il18r\, 
        \I10.BNC_CNT_4l18r\, \I10.BNC_CNT_215_net_1\, 
        \I10.BNC_CNTl17r_net_1\, \I10.BNC_CNT_4l17r\, 
        \I10.BNC_CNT_214_net_1\, \I10.BNC_CNTl16r_net_1\, 
        \I10.BNC_CNT_4l16r\, \I10.BNC_CNT_213_net_1\, 
        \I10.BNC_CNTl15r_net_1\, \I10.BNC_CNT_4l15r\, 
        \I10.BNC_CNT_212_net_1\, \I10.BNC_CNT_i_il14r\, 
        \I10.BNC_CNT_4l14r\, \I10.BNC_CNT_211_net_1\, 
        \I10.BNC_CNT_i_il13r\, \I10.BNC_CNT_4l13r\, 
        \I10.BNC_CNT_210_net_1\, \I10.BNC_CNT_i_il12r\, 
        \I10.BNC_CNT_4l12r\, \I10.BNC_CNT_209_net_1\, 
        \I10.BNC_CNTl11r_net_1\, \I10.BNC_CNT_4l11r\, 
        \I10.BNC_CNT_208_net_1\, \I10.BNC_CNTl10r_net_1\, 
        \I10.BNC_CNT_4l10r\, \I10.un6_bnc_res_NE_net_1\, 
        \I10.BNC_CNT_207_net_1\, \I10.BNC_CNTl9r_net_1\, 
        \I10.BNC_CNT_4l9r\, \I10.BNC_CNT_206_net_1\, 
        \I10.BNC_CNTl8r_net_1\, \I10.BNC_CNT_4l8r\, 
        \I10.BNC_CNT_205_net_1\, \I10.BNC_CNTl7r_net_1\, 
        \I10.BNC_CNT_4l7r\, \I10.BNC_CNT_204_net_1\, 
        \I10.BNC_CNTl6r_net_1\, \I10.BNC_CNT_4l6r\, 
        \I10.BNC_CNT_203_net_1\, \I10.BNC_CNT_4l5r\, 
        \I10.BNC_CNT_202_net_1\, \I10.BNC_CNTl4r_net_1\, 
        \I10.BNC_CNT_4l4r\, \I10.BNC_CNT_201_net_1\, 
        \I10.BNC_CNTl3r_net_1\, \I10.BNC_CNT_4l3r\, 
        \I10.BNC_CNT_200_net_1\, \I10.BNC_CNTl2r_net_1\, 
        \I10.BNC_CNT_4l2r\, \I10.BNC_CNT_199_net_1\, 
        \I10.BNC_CNTl1r_net_1\, \I10.BNC_CNT_4l1r\, 
        \I10.BNC_CNT_198_net_1\, \I10.BNC_CNTl0r_net_1\, 
        \I10.BNC_CNT_4l0r\, \I10.un6_bnc_res_NE_10_i\, 
        \I10.un6_bnc_res_7_i_i\, \I10.un6_bnc_res_10_i_i\, 
        \I10.un6_bnc_res_4_i_i\, \I10.un6_bnc_res_6_i_i\, 
        \I10.un6_bnc_res_NE_11_i\, \I10.un6_bnc_res_8_i_i\, 
        \I10.un6_bnc_res_9_i_i\, \I10.un6_bnc_res_1_i_i\, 
        \I10.EVRDYi_197_net_1\, \I10.N_926\, 
        \I10.un2_evread_3_i_0_a2_0_14_net_1\, 
        \I10.un2_evread_3_i_0_a2_0_12_i\, 
        \I10.un2_evread_3_i_0_a2_0_9_i\, 
        \I10.un2_evread_3_i_0_a2_0_10_i\, 
        \I10.un2_evread_3_i_0_a2_0_4_net_1\, \I10.REGl41r\, 
        \I10.REGl40r\, \I10.REGl42r\, 
        \I10.un2_evread_3_i_0_a2_0_6_net_1\, \I10.REGl35r\, 
        \I10.REGl39r\, \I10.un2_evread_3_i_0_a2_0_11_i\, 
        \I10.REGl37r\, \I10.FID_196_net_1\, \I10.FIDl31r_net_1\, 
        \I10.FID_8l31r\, \I10.N_2505_i\, 
        \I10.EVENT_DWORDl31r_net_1\, \I10.FID_195_net_1\, 
        \I10.FIDl30r_net_1\, \I10.FID_8l30r\, 
        \I10.EVENT_DWORDl30r_net_1\, \I10.FID_194_net_1\, 
        \I10.FIDl29r_net_1\, \I10.FID_8l29r\, \I10.N_2503_i\, 
        \I10.EVENT_DWORDl29r_net_1\, \I10.FID_193_net_1\, 
        \I10.FIDl28r_net_1\, \I10.FID_8l28r\, 
        \I10.FID_8_iv_0_0_0_0_il28r\, \I10.EVENT_DWORDl28r_net_1\, 
        \I10.FID_192_net_1\, \I10.FIDl27r_net_1\, \I10.FID_8l27r\, 
        \I10.FID_8_iv_0_0_0_1_il27r\, \I10.EVENT_DWORDl27r_net_1\, 
        \I10.FID_191_net_1\, \I10.FIDl26r_net_1\, \I10.FID_8l26r\, 
        \I10.FID_8_iv_0_0_0_1_il26r\, \I10.EVENT_DWORDl26r_net_1\, 
        \I10.FID_190_net_1\, \I10.FIDl25r_net_1\, \I10.FID_8l25r\, 
        \I10.FID_8_iv_0_0_0_1_il25r\, \I10.EVENT_DWORDl25r_net_1\, 
        \I10.FID_189_net_1\, \I10.FIDl24r_net_1\, \I10.FID_8l24r\, 
        \I10.FID_8_iv_0_0_0_1_il24r\, \I10.EVENT_DWORDl24r_net_1\, 
        \I10.FID_188_net_1\, \I10.FIDl23r_net_1\, \I10.FID_8l23r\, 
        \I10.FID_8_iv_0_0_0_1_il23r\, \I10.EVENT_DWORDl23r_net_1\, 
        \I10.FID_187_net_1\, \I10.FIDl22r_net_1\, \I10.FID_8l22r\, 
        \I10.FID_8_iv_0_0_0_1_il22r\, \I10.EVENT_DWORDl22r_net_1\, 
        \I10.FID_186_net_1\, \I10.FIDl21r_net_1\, \I10.FID_8l21r\, 
        \I10.FID_8_iv_0_0_0_1_il21r\, \I10.EVENT_DWORDl21r_net_1\, 
        \I10.STATE1l9r_net_1\, \I10.FID_185_net_1\, 
        \I10.FIDl20r_net_1\, \I10.FID_8l20r\, 
        \I10.FID_8_iv_0_0_0_1_il20r\, \I10.EVENT_DWORDl20r_net_1\, 
        \I10.FID_184_net_1\, \I10.FIDl19r_net_1\, \I10.FID_8l19r\, 
        \I10.FID_8_iv_0_0_0_1_il19r\, \I10.EVENT_DWORDl19r_net_1\, 
        \I10.FID_183_net_1\, \I10.FIDl18r_net_1\, \I10.FID_8l18r\, 
        \I10.FID_8_iv_0_0_0_1_il18r\, 
        \I10.FID_8_iv_0_0_0_0_il18r\, \I10.EVENT_DWORDl18r_net_1\, 
        \I10.FAULT_STAT_net_1\, \I10.FID_182_net_1\, 
        \I10.FIDl17r_net_1\, \I10.FID_8l17r\, 
        \I10.FID_8_iv_0_0_0_1_il17r\, \I10.EVENT_DWORDl17r_net_1\, 
        \I10.CYC_STAT_net_1\, \I10.FID_181_net_1\, 
        \I10.FIDl16r_net_1\, \I10.FID_8l16r\, 
        \I10.FID_8_iv_0_0_0_0_il16r\, \I10.EVENT_DWORDl16r_net_1\, 
        \I10.FID_180_net_1\, \I10.FIDl15r_net_1\, \I10.FID_8l15r\, 
        \I10.FID_8_iv_0_0_0_0_il15r\, \I10.CRC32l11r_net_1\, 
        \I10.CRC32l23r_net_1\, \I10.EVENT_DWORDl15r_net_1\, 
        \I10.FID_179_net_1\, \I10.FIDl14r_net_1\, \I10.FID_8l14r\, 
        \I10.FID_8_iv_0_0_0_0_il14r\, \I10.CRC32l10r_net_1\, 
        \I10.CRC32l22r_net_1\, \I10.EVENT_DWORDl14r_net_1\, 
        \I10.FID_178_net_1\, \I10.FIDl13r_net_1\, \I10.FID_8l13r\, 
        \I10.FID_8_iv_0_0_0_0_il13r\, \I10.CRC32l9r_net_1\, 
        \I10.CRC32l21r_net_1\, \I10.STATE1L11R_12\, 
        \I10.EVENT_DWORDl13r_net_1\, \I10.FID_177_net_1\, 
        \I10.FIDl12r_net_1\, \I10.FID_8l12r\, 
        \I10.FID_8_iv_0_0_0_0_il12r\, \I10.STATE1L2R_13\, 
        \I10.CRC32l8r_net_1\, \I10.CRC32l20r_net_1\, 
        \I10.EVENT_DWORDl12r_net_1\, \I10.FID_176_net_1\, 
        \I10.FIDl11r_net_1\, \I10.FID_8l11r\, 
        \I10.FID_8_iv_0_0_0_0_il11r\, \I10.CRC32l7r_net_1\, 
        \I10.CRC32l19r_net_1\, \I10.CRC32l31r_net_1\, 
        \I10.EVENT_DWORDl11r_net_1\, \I10.FID_175_net_1\, 
        \I10.FIDl10r_net_1\, \I10.FID_8l10r\, 
        \I10.FID_8_iv_0_0_0_0_il10r\, \I10.CRC32l6r_net_1\, 
        \I10.CRC32l18r_net_1\, \I10.CRC32l30r_net_1\, 
        \I10.EVENT_DWORDl10r_net_1\, \I10.STATE1L1R_14\, 
        \I10.FID_174_net_1\, \I10.FIDl9r_net_1\, \I10.FID_8l9r\, 
        \I10.FID_8_iv_0_0_0_0l9r_net_1\, \I10.CRC32l5r_net_1\, 
        \I10.CRC32l17r_net_1\, \I10.CRC32l29r_net_1\, 
        \I10.EVENT_DWORDl9r_net_1\, \I10.FID_173_net_1\, 
        \I10.FIDl8r_net_1\, \I10.FID_8l8r\, 
        \I10.FID_8_iv_0_0_0_0l8r_net_1\, \I10.CRC32l4r_net_1\, 
        \I10.CRC32l16r_net_1\, \I10.CRC32l28r_net_1\, 
        \I10.EVENT_DWORDl8r_net_1\, \I10.FID_172_net_1\, 
        \I10.FIDl7r_net_1\, \I10.FID_8l7r\, 
        \I10.FID_8_iv_0_0_0_0_il7r\, \I10.CRC32l3r_net_1\, 
        \I10.CRC32l15r_net_1\, \I10.CRC32l27r_net_1\, 
        \I10.EVENT_DWORDl7r_net_1\, \I10.FID_171_net_1\, 
        \I10.FIDl6r_net_1\, \I10.FID_8l6r\, 
        \I10.FID_8_iv_0_0_0_0_il6r\, \I10.CRC32l2r_net_1\, 
        \I10.CRC32l14r_net_1\, \I10.CRC32l26r_net_1\, 
        \I10.EVENT_DWORDl6r_net_1\, \I10.FID_170_net_1\, 
        \I10.FIDl5r_net_1\, \I10.FID_8l5r\, 
        \I10.FID_8_iv_0_0_0_0l5r_net_1\, \I10.CRC32l1r_net_1\, 
        \I10.CRC32l13r_net_1\, \I10.CRC32l25r_net_1\, 
        \I10.EVENT_DWORDl5r_net_1\, \I10.FID_169_net_1\, 
        \I10.FIDl4r_net_1\, \I10.FID_8l4r\, 
        \I10.FID_8_iv_0_0_0_0_il4r\, \I10.CRC32l0r_net_1\, 
        \I10.CRC32l12r_net_1\, \I10.CRC32l24r_net_1\, 
        \I10.EVENT_DWORDl4r_net_1\, \I10.FID_168_net_1\, 
        \I10.FIDl3r_net_1\, \I10.FID_8l3r\, 
        \I10.FID_8_0_iv_0_0_0_0_il3r\, \I10.EVENT_DWORDl3r_net_1\, 
        \I10.FID_167_net_1\, \I10.FIDl2r_net_1\, \I10.FID_8l2r\, 
        \I10.FID_8_0_iv_0_0_0_0_il2r\, \I10.EVENT_DWORDl2r_net_1\, 
        \I10.FID_166_net_1\, \I10.FIDl1r_net_1\, \I10.FID_8l1r\, 
        \I10.FID_8_0_iv_0_0_0_0_il1r\, \I10.EVENT_DWORDl1r_net_1\, 
        \I10.FID_165_net_1\, \I10.FIDl0r_net_1\, \I10.FID_8l0r\, 
        \I10.FID_8_0_iv_0_0_0_0_il0r\, \I10.EVENT_DWORDl0r_net_1\, 
        \I10.EVENT_DWORD_164_net_1\, \I10.EVENT_DWORD_163_net_1\, 
        \I10.EVENT_DWORD_162_net_1\, \I10.EVENT_DWORD_18l29r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l29r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l29r_net_1\, 
        \I10.EVENT_DWORD_161_net_1\, \I10.EVENT_DWORD_18l28r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l28r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l28r_net_1\, 
        \I10.EVENT_DWORD_160_net_1\, \I10.EVENT_DWORD_18l27r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l27r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l27r_net_1\, 
        \I10.EVENT_DWORD_159_net_1\, \I10.EVENT_DWORD_18l26r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l26r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l26r_net_1\, 
        \I10.EVENT_DWORD_158_net_1\, \I10.EVENT_DWORD_18l25r\, 
        \I10.EVENT_DWORD_18_i_0_1l25r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0l25r_net_1\, 
        \I10.EVENT_DWORD_157_net_1\, \I10.EVENT_DWORD_18l24r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l24r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l24r_net_1\, 
        \I10.EVENT_DWORD_156_net_1\, \I10.EVENT_DWORD_18l23r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l23r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l23r_net_1\, 
        \I10.EVENT_DWORD_155_net_1\, \I10.EVENT_DWORD_18l22r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l22r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l22r_net_1\, 
        \I10.EVENT_DWORD_154_net_1\, \I10.EVENT_DWORD_18l21r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l21r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l21r_net_1\, 
        \I10.EVENT_DWORD_153_net_1\, \I10.EVENT_DWORD_18l20r\, 
        \I10.EVENT_DWORD_18_i_0_0_1l20r_net_1\, 
        \I10.EVENT_DWORD_18_i_0_0_0l20r_net_1\, 
        \I10.EVENT_DWORD_152_net_1\, \I10.EVENT_DWORD_18l19r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l19r_net_1\, 
        \I10.EVENT_DWORD_151_net_1\, \I10.EVENT_DWORD_18l18r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l18r_net_1\, 
        \I10.EVENT_DWORD_150_net_1\, \I10.EVENT_DWORD_18l17r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l17r_net_1\, 
        \I10.EVENT_DWORD_149_net_1\, \I10.EVENT_DWORD_18l16r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l16r_net_1\, 
        \I10.EVENT_DWORD_148_net_1\, \I10.EVENT_DWORD_18l15r\, 
        \I10.EVENT_DWORD_18_i_0_0l15r_net_1\, 
        \I10.EVENT_DWORD_147_net_1\, \I10.EVENT_DWORD_18l14r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l14r_net_1\, 
        \I10.EVENT_DWORD_146_net_1\, \I10.EVENT_DWORD_18l13r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l13r_net_1\, 
        \I10.EVENT_DWORD_145_net_1\, \I10.EVENT_DWORD_18l12r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l12r_net_1\, 
        \I10.EVENT_DWORD_144_net_1\, \I10.EVENT_DWORD_18l11r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l11r_net_1\, 
        \I10.EVENT_DWORD_143_net_1\, \I10.EVENT_DWORD_18l10r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l10r_net_1\, 
        \I10.EVENT_DWORD_142_net_1\, \I10.EVENT_DWORD_18l9r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l9r_net_1\, 
        \I10.EVENT_DWORD_141_net_1\, \I10.EVENT_DWORD_18l8r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l8r_net_1\, 
        \I10.EVENT_DWORD_140_net_1\, \I10.EVENT_DWORD_18l7r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l7r_net_1\, 
        \I10.EVENT_DWORD_139_net_1\, \I10.EVENT_DWORD_18l6r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l6r_net_1\, 
        \I10.EVENT_DWORD_138_net_1\, \I10.EVENT_DWORD_18l5r\, 
        \I10.EVENT_DWORD_18_i_0_0l5r_net_1\, 
        \I10.EVENT_DWORD_137_net_1\, \I10.EVENT_DWORD_18l4r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l4r_net_1\, 
        \I10.EVENT_DWORD_136_net_1\, \I10.EVENT_DWORD_18l3r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l3r_net_1\, 
        \I10.EVENT_DWORD_135_net_1\, \I10.EVENT_DWORD_18l2r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l2r_net_1\, 
        \I10.EVENT_DWORD_134_net_1\, \I10.EVENT_DWORD_18l1r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l1r_net_1\, 
        \I10.EVENT_DWORD_133_net_1\, \I10.EVENT_DWORD_18l0r\, 
        \I10.EVENT_DWORD_18_i_0_0_0l0r_net_1\, 
        \I10.I2C_RREQ_132_net_1\, \I10.un1_I2C_RREQ_1_sqmuxa\, 
        \I10.PDL_RREQ_131_net_1\, \I10.un1_PDL_RADDR_1_sqmuxa\, 
        \I10.OR_RREQ_130_net_1\, \I10.un1_OR_RREQ_1_sqmuxa\, 
        \I10.CHIP_ADDR_129_net_1\, \I10.N_1595\, 
        \I10.CHIP_ADDR_128_net_1\, \I10.CHIP_ADDR_127_net_1\, 
        \I10.CHANNEL_126_net_1\, \I10.CHANNEL_125_net_1\, 
        \I10.CHANNEL_124_net_1\, \I10.WRB_123_net_1\, 
        \I10.WRB_net_1\, \I10.N_577\, \I10.I2C_CHAIN_122_net_1\, 
        \I10.FAULT_STAT_121_net_1\, \I10.FAULT_STAT_3\, 
        \I10.N_1579\, \I10.FAULT_STROBE_i\, 
        \I10.EVNT_TRG_120_net_1\, \I10.FIFO_END_EVNT_119_net_1\, 
        \I10.un1_STATE1_10\, \I10.STATE1l0r_net_1\, 
        \I10.CRC32_118_net_1\, \I10.N_1365\, 
        \I10.CRC32_117_net_1\, \I10.N_1472\, 
        \I10.CRC32_116_net_1\, \I10.N_1220\, 
        \I10.CRC32_115_net_1\, \I10.N_1218\, 
        \I10.CRC32_114_net_1\, \I10.N_1216\, 
        \I10.CRC32_113_net_1\, \I10.N_1728\, 
        \I10.CRC32_112_net_1\, \I10.N_1592\, 
        \I10.CRC32_111_net_1\, \I10.N_1470\, 
        \I10.CRC32_110_net_1\, \I10.N_1362\, 
        \I10.CRC32_109_net_1\, \I10.N_1468\, 
        \I10.CRC32_108_net_1\, \I10.N_1360\, 
        \I10.CRC32_107_net_1\, \I10.N_1466\, 
        \I10.CRC32_106_net_1\, \I10.N_1039\, 
        \I10.CRC32_105_net_1\, \I10.N_1464\, 
        \I10.CRC32_104_net_1\, \I10.N_1037\, 
        \I10.CRC32_103_net_1\, \I10.N_1214\, 
        \I10.CRC32_102_net_1\, \I10.N_1590\, 
        \I10.CRC32_101_net_1\, \I10.N_1358\, 
        \I10.CRC32_100_net_1\, \I10.N_1356\, \I10.CRC32_99_net_1\, 
        \I10.N_1462\, \I10.CRC32_98_net_1\, \I10.N_1354\, 
        \I10.CRC32_97_net_1\, \I10.N_1352\, \I10.CRC32_96_net_1\, 
        \I10.N_1035\, \I10.CRC32_95_net_1\, \I10.N_1212\, 
        \I10.N_2351\, \I10.CRC32_94_net_1\, \I10.N_1460\, 
        \I10.CRC32_93_net_1\, \I10.N_1726\, \I10.CRC32_92_net_1\, 
        \I10.N_1724\, \I10.CRC32_91_net_1\, \I10.N_1348\, 
        \I10.CRC32_90_net_1\, \I10.N_1346\, \I10.CRC32_89_net_1\, 
        \I10.N_1458\, \I10.CRC32_88_net_1\, \I10.N_1679\, 
        \I10.CRC32_87_net_1\, \I10.N_1722\, 
        \I10.READ_PDL_FLAG_86_0_0_0_net_1\, \I10.N_2380_1\, 
        \I10.READ_ADC_FLAG_84_0_0_0_net_1\, 
        \I10.CYC_STAT_83_net_1\, \I10.CYC_STAT_1_net_1\, 
        \I10.DTEST_FIFO_82_net_1\, \I10.STATE1l10r_net_1\, 
        \I10.STATE1L12R_15\, \I10.ADD_16x16_medium_I78_Y\, 
        \I10.ADD_16x16_medium_I78_Y_0\, 
        \I10.ADD_16x16_medium_I51_un1_Y_0_i\, \I10.N274\, 
        \I10.N258\, \I10.N245\, \I10.ADD_16x16_medium_I51_Y_0_i\, 
        \I10.N273\, \I10.N257_i\, \I10.N_3114_i\, 
        \I10.ADD_16x16_medium_I77_Y\, \I10.N320_i\, 
        \I10.ADD_16x16_medium_I77_Y_0\, \I10.N279\, 
        \I10.ADD_16x16_medium_I52_un1_Y_1\, 
        \I10.ADD_16x16_medium_I52_Y_1\, \I10.N276\, \I10.N260\, 
        \I10.N275\, \I10.N259\, \I10.ADD_16x16_medium_I74_Y\, 
        \I10.ADD_16x16_medium_I74_Y_0\, \I10.I53_un1_Y\, 
        \I10.N261\, \I10.N232_i_i\, \I10.N262\, \I10.N233\, 
        \I10.ADD_16x16_medium_I73_Y\, \I10.N324_i\, 
        \I10.ADD_16x16_medium_I73_Y_0\, \I10.N290\, 
        \I10.ADD_16x16_medium_I72_Y\, 
        \I10.ADD_16x16_medium_I72_Y_0\, \I10.N227\, \I10.N226\, 
        \I10.ADD_16x16_medium_I71_Y\, \I10.N326_i\, 
        \I10.ADD_16x16_medium_I71_Y_0\, \I10.N266\, \I10.N220\, 
        \I10.ADD_16x16_medium_I69_Y\, \I10.N328\, 
        \I10.ADD_16x16_medium_I68_Y\, \I10.N215\, \I10.N_3032_i\, 
        \I10.ADD_16x16_medium_I67_Y\, \I10.N330_i\, 
        \I10.ADD_16x16_medium_I67_Y_0\, 
        \I10.ADD_16x16_medium_I66_Y\, 
        \I10.ADD_16x16_medium_I66_Y_0\, \I10.I28_un1_Y\, 
        \I10.N208\, \I10.ADD_16x16_medium_I65_Y\, 
        \I10.ADD_16x16_medium_I65_Y_0\, \I10.N_2313_i_0\, 
        \I10.ADD_16x16_medium_I0_S\, \I10.BNC_LIMIT_net_1\, 
        \I10.L1AF1_net_1\, \I10.L2AF1_net_1\, \I10.L2RF1_net_1\, 
        \I10.DWACT_ADD_CI_0_partial_sum_1l0r\, 
        \I10.BNCRES_CNT_4l1r\, \I10.BNCRES_CNT_4l2r\, 
        \I10.BNCRES_CNT_4l3r\, \I10.BNCRES_CNT_4l4r\, 
        \I10.BNCRES_CNT_4l5r\, \I10.BNCRES_CNT_4l6r\, 
        \I10.BNCRES_CNT_4l8r\, \I10.DWACT_ADD_CI_0_TMP_2l0r\, 
        \I5.N_211_0\, \I5.RESCNT_6l15r\, \I5.G_1_4\, 
        \I5.RESCNTl15r_net_1\, \I5.G_1_3\, \I5.G_net_1\, 
        \I5.RESCNTl0r_net_1\, \I5.RESCNTl1r_net_1\, 
        \I5.RESCNTl14r_net_1\, \I5.sstatel1r_net_1\, 
        \I5.DWACT_ADD_CI_0_TMPl0r\, 
        \I5.DWACT_ADD_CI_0_g_array_11_2l0r\, 
        \I5.DWACT_ADD_CI_0_g_array_1l0r\, 
        \I5.DWACT_ADD_CI_0_g_array_10l0r\, 
        \I5.DWACT_ADD_CI_0_g_array_3l0r\, \I5.sstate_nsl0r_net_1\, 
        \I5.un2_hwres_2_net_1\, 
        \I5.DWACT_ADD_CI_0_g_array_11_1l0r\, 
        \I5.DWACT_ADD_CI_0_g_array_11l0r\, 
        \I5.DWACT_ADD_CI_0_g_array_1_0l0r\, 
        \I5.DWACT_ADD_CI_0_TMP_0l0r\, \I5.BITCNTl1r_net_1\, 
        \I5.DWACT_ADD_CI_0_g_array_12l0r\, \I5.RESCNTl2r_net_1\, 
        \I5.DWACT_ADD_CI_0_g_array_12_2l0r\, \I5.RESCNTl6r_net_1\, 
        \I5.DWACT_ADD_CI_0_g_array_12_4l0r\, 
        \I5.RESCNTl10r_net_1\, 
        \I5.DWACT_ADD_CI_0_g_array_12_5l0r\, 
        \I5.RESCNTl12r_net_1\, 
        \I5.DWACT_ADD_CI_0_g_array_12_3l0r\, \I5.RESCNTl8r_net_1\, 
        \I5.DWACT_ADD_CI_0_g_array_12_1l0r\, \I5.RESCNTl4r_net_1\, 
        \I5.un1_sstate_13_i_a2_net_1\, \I5.N_212\, 
        \I5.sstatel2r_net_1\, \I5.sstate_ns_il4r_net_1\, 
        \I5.RESCNTl7r_net_1\, \I5.RESCNTl9r_net_1\, 
        \I5.RESCNTl3r_net_1\, \I5.RESCNTl5r_net_1\, 
        \I5.RESCNTl11r_net_1\, \I5.RESCNTl13r_net_1\, 
        \I5.sstate_ns_il1r_net_1\, \I5.N_210\, \I5.N_225\, 
        \I5.N_220_i\, \I5.sstatel0r_net_1\, 
        \I5.sstate_ns_a2_0_2l0r_net_1\, \I5.sstate_i_0_il4r\, 
        \I5.sstatel3r_net_1\, \I5.ISI_14_net_1\, \I5.ISI_5\, 
        \I5.SBYTE_13_net_1\, \I5.SBYTE_5l7r_net_1\, 
        \I5.un1_sstate_12\, \I5.SBYTE_12_net_1\, 
        \I5.SBYTE_5l6r_net_1\, \I5.SBYTE_11_net_1\, 
        \I5.SBYTE_5l5r_net_1\, \I5.SBYTE_10_net_1\, 
        \I5.SBYTE_5l4r_net_1\, \I5.SBYTE_9_net_1\, 
        \I5.SBYTE_5l3r_net_1\, \I5.SBYTE_8_net_1\, 
        \I5.SBYTE_5l2r_net_1\, \I5.SBYTE_7_net_1\, 
        \I5.SBYTE_5l1r_net_1\, \I5.sstatel5r_net_1\, 
        \I5.SBYTE_6_net_1\, \I5.SBYTE_5l0r_net_1\, 
        \I5.LOAD_RESi_5_net_1\, \I5.DRIVE_RELOAD_3_net_1\, 
        \I5.DRIVE_RELOAD_net_1\, \I5.DRIVECS_2_net_1\, 
        \I5.RELOAD_1_net_1\, \I5.RESCNT_6l14r\, \I5.I_65\, 
        \I5.RESCNT_6l13r\, \I5.I_60\, \I5.RESCNT_6l12r\, 
        \I5.I_58\, \I5.RESCNT_6l11r\, \I5.I_56_0\, 
        \I5.RESCNT_6l10r\, \I5.I_53\, \I5.RESCNT_6l9r\, 
        \I5.I_52_0\, \I5.RESCNT_6l8r\, \I5.I_63\, 
        \I5.RESCNT_6l7r\, \I5.I_61\, \I5.RESCNT_6l6r\, \I5.I_59\, 
        \I5.RESCNT_6l5r\, \I5.I_57\, \I5.RESCNT_6l4r\, \I5.I_55\, 
        \I5.RESCNT_6l3r\, \I5.I_54\, \I5.RESCNT_6l2r\, \I5.I_51\, 
        \I5.RESCNT_6l1r\, \I5.I_64\, \I5.RESCNT_6l0r\, 
        \I5.DWACT_ADD_CI_0_partial_suml0r\, \I5.BITCNT_6l2r\, 
        \I5.I_14_0\, \I5.BITCNT_6l1r\, \I5.I_13_1\, 
        \I5.BITCNT_6l0r\, \I5.DWACT_ADD_CI_0_partial_sum_0l0r\, 
        \I5.BITCNTl0r_net_1\, \I5.BITCNTl2r_net_1\, 
        \I2.WRITES_2_net_1\, \I2.STATE1_nsl1r\, 
        \I2.PULSE_0_sqmuxa_4_1_0\, \I2.REG3_506_141_net_1\, 
        \I2.N_2483_i_0_0_0\, \I2.STATE1_nsl2r_net_1\, 
        \I2.ASBSF1_net_1\, \I2.N_2821_0\, \I2.STATE2l1r_net_1\, 
        \I2.N_1730_0\, \I2.un17_hwres_i\, \I2.ADACKCYC_net_1\, 
        \I2.MBLTCYC_net_1\, \I2.REG3_114_net_1\, 
        \I2.REG_1_125_net_1\, \I2.REG_1_126_net_1\, 
        \I2.REG_1_127_net_1\, \I2.REG_1_128_net_1\, 
        \I2.REG_1_129_net_1\, \I2.REG_1_131_net_1\, 
        \I2.SINGCYC_140_net_1\, \I2.BLTCYC_105_net_1\, 
        \I2.BLTCYC_net_1\, \I2.STATE1_nsl3r_net_1\, 
        \I2.STATE1_nsl7r_net_1\, \I2.STATE1_i_il1r\, 
        \I2.N_2983_1\, \I2.LWORDS_net_1\, \I2.REG_1_123_net_1\, 
        \I2.TST_c_0l1r\, TST_CL2R_16, \I2.DSSF1_net_1\, 
        \I2.N_3021_1\, \I2.STATE5l1r_Rd1_\, \I2.N_2822_6\, 
        \I2.un1_STATE2_13_4_1\, \I2.STATE2l5r_net_1\, 
        \I2.un1_STATE2_13_1\, \I2.un1_STATE2_16_1\, \I2.N_2849\, 
        \I2.STATE2l2r_net_1\, \I2.N_1712_1\, \I2.N_1734_i\, 
        \I2.N_1762\, \I2.EVREAD_DS_net_1\, \I2.N_1707_i_0_1\, 
        \I2.N_1782\, \I2.N_2909_1\, \I2.N_1705_i_0_1_0\, 
        \I2.N_1705_i_0_1\, \I2.VDBi_1_sqmuxa_1_1\, 
        \I2.REGMAPl32r_net_1\, \I2.N_2847_1\, \I2.STATE2_i_0l3r\, 
        \I2.N_1826_0\, \I2.I_743_0_i\, \I2.PULSE_1_sqmuxa_6_0\, 
        \I2.REG1_0_sqmuxa_1_0\, \I2.un1_STATE5_9_0_1_i\, 
        \I2.N_2383\, \I2.LB_nOE_1_sqmuxa\, 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, \I2.N_3689_i_1\, 
        \I2.REG_1_sqmuxa_3_net_1\, \I2.STATE1_nsl8r_net_1\, 
        \I2.N_3527_i_0\, \I2.N_3303_i_1\, \I2.REGMAP_i_il25r\, 
        \I2.N_3143_i_0\, \I2.N_3175_i_0\, \I2.N_3463_i_1\, 
        \I2.N_3625_i_1\, \I2.N_3495_i_0\, \I2.N_3207_i_0\, 
        \I2.N_3111_i_0\, \I2.DWACT_ADD_CI_0_g_array_1_1l0r\, 
        \I2.DWACT_ADD_CI_0_TMP_1l0r\, \I2.WDOGl1r_net_1\, 
        \I2.DWACT_ADD_CI_0_g_array_12_3l0r\, \I2.WDOGl2r_net_1\, 
        \I2.WDOGl0r_net_1\, \I2.WDOGRES_net_1\, 
        \I2.STATE2l4r_net_1\, \I2.N_1679_i_0_i_net_1\, 
        \I2.STATE1_i_0l5r\, \I2.N_2860_i_0_i\, \I2.WDOGRES1_i\, 
        \I2.un2_clear_i\, \I2.REGl447r\, \I2.REGl446r\, 
        \I2.REGl445r\, \I2.REGl444r\, \I2.REGl443r\, 
        \I2.REGl442r\, \I2.REGl296r\, \I2.REGl295r\, 
        \I2.REGl294r\, \I2.REGl293r\, \I2.REGl292r\, 
        \I2.REGl291r\, \I2.REGl290r\, \I2.REGl289r\, 
        \I2.REGl288r\, \I2.REGl287r\, \I2.REGl286r\, 
        \I2.REGl285r\, \I2.REGl284r\, \I2.REGl283r\, 
        \I2.REGl282r\, \I2.REGl281r\, \I2.REGl280r\, 
        \I2.REGl279r\, \I2.REGl278r\, \I2.REGl277r\, 
        \I2.REGl276r\, \I2.REGl275r\, \I2.REGl274r\, 
        \I2.REGl273r\, \I2.REGl272r\, \I2.REGl271r\, 
        \I2.REGl270r\, \I2.REGl269r\, \I2.REGl268r\, 
        \I2.REGl267r\, \I2.REGl266r\, \I2.REGl265r\, 
        \I2.REGl441r\, \I2.REGl448r\, \I2.CLOSEDTK_net_1\, 
        \I2.VASl15r_net_1\, \I2.VASl2r_net_1\, \I2.VASl3r_net_1\, 
        \I2.VASl5r_net_1\, \I2.WRITES_net_1\, \I2.VASl4r_net_1\, 
        \I2.VASl1r_net_1\, \I2.VASl8r_net_1\, \I2.VASl6r_net_1\, 
        \I2.VASl7r_net_1\, \I2.VAS_i_0_il13r\, \I2.VASl14r_net_1\, 
        \I2.VAS_i_0_il9r\, \I2.VASl10r_net_1\, \I2.VAS_i_0_il11r\, 
        \I2.VASl12r_net_1\, \I2.un8_cycs_0_a2_net_1\, 
        \I2.CYCS_net_1\, \I2.DS_i_a2_net_1\, 
        \I2.STATE1_ns_il6r_net_1\, \I2.N_2854\, 
        \I2.STATE1l3r_net_1\, \I2.STATE5_ns_i_i_a2_0_0l0r\, 
        \I2.N_2389\, \I2.N_2310_1\, \I2.N_2072\, 
        \I2.VDBil31r_net_1\, \I2.PIPEBl31r_net_1\, 
        \I2.PIPEAl31r_net_1\, \I2.N_2071\, \I2.VDBil30r_net_1\, 
        \I2.PIPEBl30r_net_1\, \I2.PIPEAl30r_net_1\, \I2.N_2070\, 
        \I2.VDBil29r_net_1\, \I2.PIPEBl29r_net_1\, 
        \I2.PIPEA_i_0_il29r\, \I2.N_2069\, \I2.VDBil28r_net_1\, 
        \I2.PIPEB_i_il28r\, \I2.PIPEAl28r_net_1\, \I2.N_2068\, 
        \I2.VDBil27r_net_1\, \I2.PIPEBl27r_net_1\, 
        \I2.PIPEAl27r_net_1\, \I2.N_2067\, \I2.VDBil26r_net_1\, 
        \I2.PIPEBl26r_net_1\, \I2.PIPEAl26r_net_1\, \I2.N_2066\, 
        \I2.VDBil25r_net_1\, \I2.PIPEBl25r_net_1\, 
        \I2.PIPEAl25r_net_1\, \I2.N_2065\, \I2.VDBil24r_net_1\, 
        \I2.PIPEBl24r_net_1\, \I2.PIPEAl24r_net_1\, \I2.N_2064\, 
        \I2.VDBil23r_net_1\, \I2.PIPEBl23r_net_1\, 
        \I2.PIPEAl23r_net_1\, \I2.N_2063\, \I2.VDBil22r_net_1\, 
        \I2.PIPEBl22r_net_1\, \I2.PIPEAl22r_net_1\, \I2.N_2062\, 
        \I2.VDBil21r_net_1\, \I2.PIPEBl21r_net_1\, 
        \I2.PIPEAl21r_net_1\, \I2.N_2061\, \I2.VDBil20r_net_1\, 
        \I2.PIPEBl20r_net_1\, \I2.PIPEAl20r_net_1\, \I2.N_2060\, 
        \I2.VDBil19r_net_1\, \I2.PIPEBl19r_net_1\, 
        \I2.PIPEAl19r_net_1\, \I2.N_2059\, \I2.VDBil18r_net_1\, 
        \I2.PIPEBl18r_net_1\, \I2.PIPEAl18r_net_1\, \I2.N_2058\, 
        \I2.VDBil17r_net_1\, \I2.PIPEBl17r_net_1\, 
        \I2.PIPEAl17r_net_1\, \I2.N_2057\, \I2.VDBil16r_net_1\, 
        \I2.PIPEBl16r_net_1\, \I2.PIPEAl16r_net_1\, \I2.N_2056\, 
        \I2.VDBil15r_net_1\, \I2.PIPEBl15r_net_1\, 
        \I2.PIPEAl15r_net_1\, \I2.N_2055\, \I2.VDBil14r_net_1\, 
        \I2.PIPEBl14r_net_1\, \I2.PIPEAl14r_net_1\, \I2.N_2054\, 
        \I2.VDBil13r_net_1\, \I2.PIPEBl13r_net_1\, 
        \I2.PIPEAl13r_net_1\, \I2.N_2053\, \I2.VDBil12r_net_1\, 
        \I2.PIPEBl12r_net_1\, \I2.PIPEAl12r_net_1\, \I2.N_2052\, 
        \I2.VDBil11r_net_1\, \I2.PIPEBl11r_net_1\, 
        \I2.PIPEAl11r_net_1\, \I2.N_2051\, \I2.VDBil10r_net_1\, 
        \I2.PIPEBl10r_net_1\, \I2.PIPEAl10r_net_1\, \I2.N_2050\, 
        \I2.VDBil9r_net_1\, \I2.PIPEBl9r_net_1\, 
        \I2.PIPEAl9r_net_1\, \I2.N_2049\, \I2.VDBil8r_net_1\, 
        \I2.PIPEBl8r_net_1\, \I2.PIPEAl8r_net_1\, \I2.N_2048\, 
        \I2.VDBil7r_net_1\, \I2.PIPEBl7r_net_1\, 
        \I2.PIPEAl7r_net_1\, \I2.BLTCYC_17\, \I2.N_2047\, 
        \I2.VDBil6r_net_1\, \I2.PIPEBl6r_net_1\, 
        \I2.PIPEAl6r_net_1\, \I2.N_2046\, \I2.VDBil5r_net_1\, 
        \I2.PIPEBl5r_net_1\, \I2.PIPEAl5r_net_1\, \I2.N_2045\, 
        \I2.VDBil4r_net_1\, \I2.SINGCYC_net_1\, 
        \I2.PIPEBl4r_net_1\, \I2.PIPEAl4r_net_1\, \I2.N_2044\, 
        \I2.VDBil3r_net_1\, \I2.PIPEBl3r_net_1\, 
        \I2.PIPEAl3r_net_1\, \I2.N_2043\, \I2.VDBil2r_net_1\, 
        \I2.PIPEBl2r_net_1\, \I2.PIPEAl2r_net_1\, \I2.N_2042\, 
        \I2.VDBil1r_net_1\, \I2.PIPEBl1r_net_1\, 
        \I2.PIPEAl1r_net_1\, \I2.N_2041\, \I2.VDBil0r_net_1\, 
        \I2.PIPEBl0r_net_1\, \I2.PIPEAl0r_net_1\, 
        \I2.un3_asb_NE_net_1\, \I2.un3_asb_0_net_1\, 
        \I2.un3_asb_1_net_1\, \I2.un3_asb_NE_0_net_1\, 
        \I2.un3_asb_2_net_1\, \I2.un3_asb_3_net_1\, 
        \I2.STATE1_ns_il9r_net_1\, \I2.N_1714\, 
        \I2.STATE1_ns_i_0l9r_net_1\, \I2.REGMAP_i_0_il15r\, 
        \I2.TCNT_0_sqmuxa\, \I2.REGMAPl35r_net_1\, 
        \I2.REGMAPl10r_net_1\, \I2.STATE1_nsl5r\, \I2.N_2909\, 
        \I2.N_2907\, \I2.STATE1_ns_0l3r_net_1\, \I2.N_2981\, 
        \I2.STATE1_ns_1l2r_net_1\, \I2.N_1717\, 
        \I2.STATE1_ns_0l2r_net_1\, \I2.STATE1l0r_net_1\, 
        \I2.N_2981_1\, \I2.STATE1_ns_0_0_0_il1r\, \I2.N_2885\, 
        \I2.STATE1l8r_net_1\, \I2.NLBRDY_s_net_1\, 
        \I2.STATE1_nsl0r\, \I2.STATE1l9r_net_1\, 
        \I2.STATE1_ns_0_0_il0r\, \I2.N_2837\, \I2.STATE2_nsl5r\, 
        \I2.N_1568\, \I2.STATE2_nsl4r\, \I2.N_2894_3\, 
        \I2.N_2900\, \I2.STATE2_nsl3r_net_1\, \I2.N_2894_1\, 
        \I2.STATE2_ns_0l3r_net_1\, \I2.STATE2_nsl0r_net_1\, 
        \I2.un6_evrdy_i\, \I2.STATE5_nsl4r\, \I2.STATE5l0r_net_1\, 
        \I2.STATE5l3r_net_1\, \I2.VDBi_607_net_1\, 
        \I2.VDBi_86_0l31r\, \I2.VDBi_86_0_iv_0_il31r\, 
        \I2.VDBi_61l31r_net_1\, \I2.VDBi_56l31r_net_1\, 
        \I2.VDBi_24l31r_net_1\, \I2.VDBi_19l31r_net_1\, 
        \I2.REGl505r\, \I2.VDBi_606_net_1\, \I2.VDBi_86l30r\, 
        \I2.VDBi_86_0_iv_0_il30r\, \I2.VDBi_61l30r_net_1\, 
        \I2.VDBi_56l30r_net_1\, \I2.VDBi_24l30r_net_1\, 
        \I2.VDBi_19l30r_net_1\, \I2.REGl504r\, 
        \I2.VDBi_605_net_1\, \I2.VDBi_86l29r\, 
        \I2.VDBi_86_0_iv_0_il29r\, \I2.VDBi_61l29r_net_1\, 
        \I2.VDBi_56l29r_net_1\, \I2.VDBi_24l29r_net_1\, 
        \I2.VDBi_19l29r_net_1\, \I2.REGl503r\, 
        \I2.VDBi_604_net_1\, \I2.VDBi_86l28r\, 
        \I2.VDBi_86_0_iv_0_il28r\, \I2.VDBi_61l28r_net_1\, 
        \I2.VDBi_56l28r_net_1\, \I2.VDBi_24l28r_net_1\, 
        \I2.VDBi_19l28r_net_1\, \I2.REGl502r\, 
        \I2.VDBi_603_net_1\, \I2.VDBi_86l27r\, 
        \I2.VDBi_86_0_iv_0_il27r\, \I2.VDBi_61l27r_net_1\, 
        \I2.VDBi_56l27r_net_1\, \I2.VDBi_24l27r_net_1\, 
        \I2.VDBi_19l27r_net_1\, \I2.REGl501r\, 
        \I2.VDBi_602_net_1\, \I2.VDBi_86l26r\, 
        \I2.VDBi_86_0_iv_0_il26r\, \I2.VDBi_61l26r_net_1\, 
        \I2.VDBi_56l26r_net_1\, \I2.VDBi_24l26r_net_1\, 
        \I2.VDBi_19l26r_net_1\, \I2.REGl500r\, 
        \I2.VDBi_601_net_1\, \I2.VDBi_86l25r\, 
        \I2.VDBi_86_0_iv_0_il25r\, \I2.VDBi_61l25r_net_1\, 
        \I2.VDBi_56l25r_net_1\, \I2.VDBi_24l25r_net_1\, 
        \I2.VDBi_19l25r_net_1\, \I2.REGl499r\, 
        \I2.VDBi_600_net_1\, \I2.VDBi_86l24r\, 
        \I2.VDBi_86_0_iv_0_il24r\, \I2.VDBi_61l24r_net_1\, 
        \I2.VDBi_56l24r_net_1\, \I2.VDBi_24l24r_net_1\, 
        \I2.VDBi_19l24r_net_1\, \I2.REGl498r\, 
        \I2.VDBi_599_net_1\, \I2.VDBi_86l23r\, 
        \I2.VDBi_86_0_iv_0_il23r\, \I2.VDBi_61l23r_net_1\, 
        \I2.VDBi_56l23r_net_1\, \I2.VDBi_24l23r_net_1\, 
        \I2.VDBi_19l23r_net_1\, \I2.REGl497r\, 
        \I2.VDBi_598_net_1\, \I2.VDBi_86l22r\, 
        \I2.VDBi_86_0_iv_0_il22r\, \I2.VDBi_61l22r_net_1\, 
        \I2.VDBi_56l22r_net_1\, \I2.VDBi_24l22r_net_1\, 
        \I2.VDBi_19l22r_net_1\, \I2.REGl496r\, 
        \I2.VDBi_597_net_1\, \I2.VDBi_86l21r\, 
        \I2.VDBi_86_0_iv_0_il21r\, \I2.VDBi_61l21r_net_1\, 
        \I2.VDBi_56l21r_net_1\, \I2.VDBi_24l21r_net_1\, 
        \I2.VDBi_19l21r_net_1\, \I2.REGl495r\, 
        \I2.VDBi_596_net_1\, \I2.VDBi_86l20r\, 
        \I2.VDBi_86_0_iv_0_il20r\, \I2.VDBi_61l20r_net_1\, 
        \I2.VDBi_56l20r_net_1\, \I2.VDBi_24l20r_net_1\, 
        \I2.VDBi_19l20r_net_1\, \I2.REGl494r\, 
        \I2.VDBi_595_net_1\, \I2.VDBi_86l19r\, \I2.N_2898_i\, 
        \I2.N_2861\, \I2.N_2855\, \I2.REGMAPl0r_net_1\, 
        \I2.VDBi_56l19r_net_1\, \I2.VDBi_24l19r_net_1\, 
        \I2.VDBi_19l19r_net_1\, \I2.REGl493r\, 
        \I2.VDBi_594_net_1\, \I2.VDBi_86l18r\, 
        \I2.VDBi_86_0_iv_0_il18r\, \I2.VDBi_61l18r_net_1\, 
        \I2.VDBi_56l18r_net_1\, \I2.VDBi_24l18r_net_1\, 
        \I2.VDBi_19l18r_net_1\, \I2.REGl492r\, 
        \I2.VDBi_593_net_1\, \I2.VDBi_86l17r\, 
        \I2.VDBi_86_0_iv_0_il17r\, \I2.VDBi_61l17r_net_1\, 
        \I2.VDBi_56l17r_net_1\, \I2.VDBi_24l17r_net_1\, 
        \I2.VDBi_19l17r_net_1\, \I2.REGl491r\, 
        \I2.VDBi_592_net_1\, \I2.VDBi_86l16r\, 
        \I2.VDBi_86_0_iv_0_il16r\, \I2.VDBi_61l16r_net_1\, 
        \I2.VDBi_56l16r_net_1\, \I2.VDBi_24l16r_net_1\, 
        \I2.VDBi_19l16r_net_1\, \I2.REGl490r\, 
        \I2.VDBi_591_net_1\, \I2.VDBi_86l15r\, 
        \I2.VDBi_67l15r_net_1\, \I2.VDBi_86_iv_2l15r_net_1\, 
        \I2.N_1964\, \I2.VDBi_61l15r_net_1\, \I2.REGl456r\, 
        \I2.REGl440r\, \I2.VDBi_59l15r_net_1\, 
        \I2.VDBi_54_0_iv_5_il15r\, \I2.VDBi_54_0_iv_3_il15r\, 
        \I2.VDBi_54_0_iv_0_il15r\, \I2.VDBi_54_0_iv_1_il15r\, 
        \I2.REGMAP_i_il23r\, \I2.REGMAPl12r_net_1\, 
        \I2.VDBi_54_0_iv_2l15r_net_1\, \I2.REG_1_ml168r_net_1\, 
        \I2.VDBi_24l15r_net_1\, \I2.VDBi_19l15r_net_1\, 
        \I2.REGl489r\, \I2.VDBi_17l15r\, \I2.REGMAPl2r_net_1\, 
        \I2.REGMAP_i_il1r\, \I2.REGl15r\, 
        \I2.VDBi_86_iv_1l15r_net_1\, \I2.VDBi_590_net_1\, 
        \I2.VDBi_86l14r\, \I2.VDBi_67l14r_net_1\, 
        \I2.VDBi_86_iv_2l14r_net_1\, \I2.N_1963\, 
        \I2.VDBi_61l14r_net_1\, \I2.REGl455r\, \I2.REGl439r\, 
        \I2.VDBi_59l14r_net_1\, \I2.VDBi_54_0_iv_5_il14r\, 
        \I2.VDBi_54_0_iv_3_il14r\, \I2.VDBi_54_0_iv_0_il14r\, 
        \I2.VDBi_54_0_iv_1_il14r\, \I2.VDBi_54_0_iv_2l14r_net_1\, 
        \I2.REG_1_ml167r_net_1\, \I2.VDBi_24l14r_net_1\, 
        \I2.VDBi_19l14r_net_1\, \I2.REGl488r\, \I2.VDBi_17l14r\, 
        \I2.REGl14r\, \I2.VDBi_86_iv_1l14r_net_1\, 
        \I2.VDBi_589_net_1\, \I2.VDBi_86l13r\, 
        \I2.VDBi_67l13r_net_1\, \I2.VDBi_86_iv_2l13r_net_1\, 
        \I2.N_1962\, \I2.VDBi_61l13r_net_1\, \I2.REGl454r\, 
        \I2.REGl438r\, \I2.VDBi_59l13r_net_1\, 
        \I2.VDBi_54_0_iv_5_il13r\, \I2.VDBi_54_0_iv_3_il13r\, 
        \I2.VDBi_54_0_iv_0_il13r\, \I2.VDBi_54_0_iv_1_il13r\, 
        \I2.VDBi_54_0_iv_2l13r_net_1\, \I2.REG_1_ml166r_net_1\, 
        \I2.VDBi_24l13r_net_1\, \I2.VDBi_19l13r_net_1\, 
        \I2.REGl487r\, \I2.VDBi_17l13r\, \I2.REGl13r\, 
        \I2.VDBi_86_iv_1l13r_net_1\, \I2.VDBi_588_net_1\, 
        \I2.VDBi_86l12r\, \I2.VDBi_67l12r_net_1\, 
        \I2.VDBi_86_iv_2l12r_net_1\, \I2.N_1961\, 
        \I2.VDBi_61l12r_net_1\, \I2.REGl453r\, \I2.REGl437r\, 
        \I2.VDBi_59l12r_net_1\, \I2.VDBi_54_0_iv_5_il12r\, 
        \I2.VDBi_54_0_iv_3_il12r\, \I2.VDBi_54_0_iv_0_il12r\, 
        \I2.VDBi_54_0_iv_1_il12r\, \I2.VDBi_54_0_iv_2l12r_net_1\, 
        \I2.REG_1_ml165r_net_1\, \I2.VDBi_24l12r_net_1\, 
        \I2.VDBi_19l12r_net_1\, \I2.REGl486r\, \I2.VDBi_17l12r\, 
        \I2.REGMAPl7r_net_1\, \I2.REGl12r\, 
        \I2.VDBi_86_iv_1l12r_net_1\, \I2.VDBi_587_net_1\, 
        \I2.VDBi_86l11r\, \I2.VDBi_67l11r_net_1\, 
        \I2.VDBi_86_iv_2l11r_net_1\, \I2.N_1960\, 
        \I2.VDBi_61l11r_net_1\, \I2.REGl452r\, \I2.REGl436r\, 
        \I2.VDBi_59l11r_net_1\, \I2.VDBi_54_0_iv_5_il11r\, 
        \I2.VDBi_54_0_iv_3_il11r\, \I2.VDBi_54_0_iv_0_il11r\, 
        \I2.VDBi_54_0_iv_1_il11r\, \I2.VDBi_54_0_iv_2l11r_net_1\, 
        \I2.REG_1_ml164r_net_1\, \I2.VDBi_24l11r_net_1\, 
        \I2.VDBi_19l11r_net_1\, \I2.REGl485r\, \I2.VDBi_17l11r\, 
        \I2.REGl11r\, \I2.VDBi_86_iv_1l11r_net_1\, 
        \I2.VDBi_586_net_1\, \I2.VDBi_86l10r\, 
        \I2.VDBi_67l10r_net_1\, \I2.VDBi_86_iv_2l10r_net_1\, 
        \I2.N_1959\, \I2.VDBi_61l10r_net_1\, \I2.REGl451r\, 
        \I2.REGl435r\, \I2.VDBi_59l10r_net_1\, 
        \I2.VDBi_54_0_iv_5_il10r\, \I2.VDBi_54_0_iv_3_il10r\, 
        \I2.VDBi_54_0_iv_0_il10r\, \I2.VDBi_54_0_iv_1_il10r\, 
        \I2.VDBi_54_0_iv_2l10r_net_1\, \I2.REG_1_ml163r_net_1\, 
        \I2.VDBi_24l10r_net_1\, \I2.VDBi_19l10r_net_1\, 
        \I2.REGl484r\, \I2.VDBi_17l10r\, \I2.REGl10r\, 
        \I2.VDBi_86_iv_1l10r_net_1\, \I2.VDBi_585_net_1\, 
        \I2.VDBi_86l9r\, \I2.VDBi_67l9r_net_1\, 
        \I2.VDBi_86_iv_2l9r_net_1\, \I2.N_1958\, 
        \I2.VDBi_61l9r_net_1\, \I2.REGl450r\, \I2.REGl434r\, 
        \I2.VDBi_59l9r_net_1\, \I2.VDBi_54_0_iv_5_il9r\, 
        \I2.VDBi_54_0_iv_3_il9r\, \I2.VDBi_54_0_iv_0_il9r\, 
        \I2.VDBi_54_0_iv_1_il9r\, \I2.VDBi_54_0_iv_2l9r_net_1\, 
        \I2.REG_1_ml162r_net_1\, \I2.VDBi_24l9r_net_1\, 
        \I2.VDBi_19l9r_net_1\, \I2.REGl483r\, \I2.VDBi_17l9r\, 
        \I2.REGl9r\, \I2.VDBi_86_iv_1l9r_net_1\, 
        \I2.VDBi_584_net_1\, \I2.VDBi_86l8r\, 
        \I2.VDBi_67l8r_net_1\, \I2.VDBi_86_iv_2l8r_net_1\, 
        \I2.VDBi_67_dl8r_net_1\, \I2.VDBi_59l8r_net_1\, 
        \I2.N_1957\, \I2.REGl449r\, \I2.VDBi_56l8r_net_1\, 
        \I2.REGMAPl29r_net_1\, \I2.VDBi_24_m_il8r\, 
        \I2.VDBi_54_0_iv_6_il8r\, \I2.REGMAPl28r_net_1\, 
        \I2.VDBi_54_0_iv_5_il8r\, \I2.VDBi_54_0_iv_1_il8r\, 
        \I2.VDBi_54_0_iv_2_il8r\, \I2.VDBi_54_0_iv_3l8r_net_1\, 
        \I2.VDBi_54_0_iv_0l8r_net_1\, \I2.REGMAP_i_il17r\, 
        \I2.REG_ml113r_net_1\, \I2.VDBi_24l8r_net_1\, 
        \I2.VDBi_19l8r_net_1\, \I2.REGl482r\, \I2.VDBi_17l8r\, 
        \I2.VDBi_86_iv_1l8r_net_1\, \I2.STATE1l2r_net_1\, 
        \I2.VDBi_583_net_1\, \I2.VDBi_86l7r\, \I2.VDBi_67_m_il7r\, 
        \I2.VDBi_86_iv_1_il7r\, \I2.VDBi_86_iv_0_il7r\, 
        \I2.VDBi_82l7r_net_1\, \I2.N_1956\, \I2.REGMAPl31r_net_1\, 
        \I2.VDBi_61_dl7r_net_1\, \I2.VDBi_54_0_iv_5_il7r\, 
        \I2.VDBi_54_0_iv_3_il7r\, \I2.VDBi_54_0_iv_0_il7r\, 
        \I2.VDBi_54_0_iv_1_il7r\, \I2.REGMAPl20r_net_1\, 
        \I2.REGMAPl24r_net_1\, \I2.REGMAPl16r_net_1\, 
        \I2.REGl128r\, \I2.VDBi_54_0_iv_2l7r_net_1\, 
        \I2.REGMAPl19r_net_1\, \I2.REG_1_ml160r_net_1\, 
        \I2.REGMAPl18r_net_1\, \I2.VDBi_24l7r_net_1\, 
        \I2.VDBi_19l7r_net_1\, \I2.REGl481r\, \I2.VDBi_17l7r\, 
        \I2.VDBi_582_net_1\, \I2.VDBi_86l6r\, \I2.VDBi_67_m_il6r\, 
        \I2.VDBi_86_iv_1_il6r\, \I2.VDBi_86_iv_0_il6r\, 
        \I2.VDBi_82l6r_net_1\, \I2.N_1955\, 
        \I2.VDBi_61_dl6r_net_1\, \I2.VDBi_54_0_iv_5_il6r\, 
        \I2.VDBi_54_0_iv_3_il6r\, \I2.VDBi_54_0_iv_0_il6r\, 
        \I2.VDBi_54_0_iv_1_il6r\, \I2.VDBi_54_0_iv_2l6r_net_1\, 
        \I2.REG_1_ml159r_net_1\, \I2.VDBi_24l6r_net_1\, 
        \I2.VDBi_19l6r_net_1\, \I2.REGl480r\, \I2.VDBi_17l6r\, 
        \I2.REGMAPl6r_net_1\, \I2.VDBi_581_net_1\, 
        \I2.VDBi_86l5r\, \I2.VDBi_67_m_il5r\, 
        \I2.VDBi_86_iv_1_il5r\, \I2.VDBi_86_iv_0_il5r\, 
        \I2.VDBi_82l5r_net_1\, \I2.N_1954\, 
        \I2.VDBi_61_dl5r_net_1\, \I2.REGMAPl30r_net_1\, 
        \I2.VDBi_54_0_iv_5_il5r\, \I2.VDBi_54_0_iv_3_il5r\, 
        \I2.VDBi_54_0_iv_0_il5r\, \I2.VDBi_54_0_iv_1_il5r\, 
        \I2.VDBi_54_0_iv_2l5r_net_1\, \I2.REG_1_ml158r_net_1\, 
        \I2.VDBi_24l5r_net_1\, \I2.VDBi_19l5r_net_1\, 
        \I2.REGl479r\, \I2.REGMAPl13r_net_1\, \I2.VDBi_17l5r\, 
        \I2.VDBi_580_net_1\, \I2.VDBi_86l4r\, \I2.VDBi_67_m_il4r\, 
        \I2.VDBi_86_iv_1_il4r\, \I2.VDBi_86_iv_0_il4r\, 
        \I2.VDBi_82l4r_net_1\, \I2.N_1953\, 
        \I2.VDBi_61_dl4r_net_1\, \I2.VDBi_54_0_iv_5_il4r\, 
        \I2.VDBi_54_0_iv_3_il4r\, \I2.VDBi_54_0_iv_0_il4r\, 
        \I2.VDBi_54_0_iv_1_il4r\, \I2.VDBi_54_0_iv_2l4r_net_1\, 
        \I2.REG_1_ml157r_net_1\, \I2.VDBi_24l4r_net_1\, 
        \I2.VDBi_19l4r_net_1\, \I2.REGl478r\, \I2.VDBi_17l4r\, 
        \I2.REGl4r\, \I2.VDBi_579_net_1\, \I2.VDBi_86l3r\, 
        \I2.VDBi_67_m_il3r\, \I2.VDBi_86_iv_1_il3r\, 
        \I2.VDBi_86_iv_0_il3r\, \I2.VDBi_82l3r_net_1\, 
        \I2.N_1952\, \I2.VDBi_61_dl3r_net_1\, 
        \I2.VDBi_54_0_iv_5_il3r\, \I2.VDBi_54_0_iv_3_il3r\, 
        \I2.VDBi_54_0_iv_0_il3r\, \I2.VDBi_54_0_iv_1_il3r\, 
        \I2.VDBi_54_0_iv_2l3r_net_1\, \I2.REG_1_ml156r_net_1\, 
        \I2.VDBi_24l3r_net_1\, \I2.VDBi_19l3r_net_1\, 
        \I2.REGl477r\, \I2.VDBi_17l3r\, \I2.REGl3r\, 
        \I2.VDBi_578_net_1\, \I2.VDBi_86l2r\, 
        \I2.VDBi_86_iv_1_il2r\, \I2.VDBi_86_iv_0_il2r\, 
        \I2.VDBi_82l2r_net_1\, \I2.VDBi_67l2r_net_1\, \I2.N_1951\, 
        \I2.VDBi_61l2r_net_1\, \I2.VDBi_61_dl2r_net_1\, 
        \I2.VDBi_54l2r\, \I2.VDBi_59_dl2r_net_1\, 
        \I2.VDBi_24l2r_net_1\, \I2.VDBi_54_0_iv_5l2r_net_1\, 
        \I2.VDBi_17l2r_net_1\, \I2.VDBi_24_dl2r_net_1\, 
        \I2.REGl2r\, \I2.REGl476r\, \I2.VDBi_54_0_iv_3_il2r\, 
        \I2.VDBi_54_0_iv_0_il2r\, \I2.VDBi_54_0_iv_1_il2r\, 
        \I2.VDBi_54_0_iv_2l2r_net_1\, \I2.REG_1_ml155r_net_1\, 
        \I2.VDBi_577_net_1\, \I2.VDBi_86l1r\, \I2.VDBi_67_m_il1r\, 
        \I2.VDBi_86_iv_1_il1r\, \I2.VDBi_86_iv_0_il1r\, 
        \I2.VDBi_82l1r_net_1\, \I2.VDBi_67_dl1r_net_1\, 
        \I2.VDBi_54_0_iv_6l1r_net_1\, \I2.VDBi_24_dl1r_net_1\, 
        \I2.VDBi_5l1r_net_1\, \I2.REGl1r\, \I2.REGl475r\, 
        \I2.VDBi_54_0_iv_5_il1r\, \I2.VDBi_54_0_iv_2_il1r\, 
        \I2.VDBi_54_0_iv_0_il1r\, \I2.VDBi_54_0_iv_3_il1r\, 
        \I2.REG_1_m_il234r\, \I2.N_1950\, \I2.VDBi_61_dl1r_net_1\, 
        \I2.VDBi_576_net_1\, \I2.VDBi_86l0r\, 
        \I2.REGMAPl34r_net_1\, \I2.REGMAP_i_0_il9r\, 
        \I2.REGMAP_i_il4r\, \I2.REGMAPl5r_net_1\, 
        \I2.REGMAPl33r_net_1\, \I2.REGMAPl3r_net_1\, 
        \I2.REGMAP_i_il14r\, \I2.REGMAP_i_0_il11r\, 
        \I2.VDBi_70_m_il0r\, \I2.VDBi_86_iv_1_il0r\, 
        \I2.VDBi_86_iv_0_il0r\, \I2.VDBi_82l0r_net_1\, 
        \I2.VDBi_70_d_0l0r_net_1\, \I2.VDBi_70_dl0r_net_1\, 
        \I2.VDBi_67_dl0r_net_1\, \I2.N_1949\, 
        \I2.VDBi_61_dl0r_net_1\, \I2.VDBi_54_0_iv_6l0r_net_1\, 
        \I2.VDBi_24_dl0r_net_1\, \I2.VDBi_22_dl0r_net_1\, 
        \I2.REGl474r\, \I2.N_1915\, \I2.N_1897\, 
        \I2.VDBi_8l0r_net_1\, \I2.VDBi_5l0r_net_1\, \I2.REGl0r\, 
        \I2.VDBi_54_0_iv_5_il0r\, \I2.VDBi_54_0_iv_1_il0r\, 
        \I2.VDBi_54_0_iv_2_il0r\, \I2.VDBi_54_0_iv_3l0r_net_1\, 
        \I2.VDBi_54_0_iv_0l0r_net_1\, \I2.REG_ml105r_net_1\, 
        \I2.PIPEA_575_net_1\, \I2.PIPEA_8l31r\, 
        \I2.PIPEA1l31r_net_1\, \I2.PIPEA_574_net_1\, 
        \I2.PIPEA_8l30r\, \I2.PIPEA1l30r_net_1\, 
        \I2.PIPEA_573_net_1\, \I2.PIPEA_8l29r\, 
        \I2.PIPEA1l29r_net_1\, \I2.PIPEA_572_net_1\, 
        \I2.PIPEA_8l28r\, \I2.PIPEA1l28r_net_1\, 
        \I2.PIPEA_571_net_1\, \I2.PIPEA_8l27r\, 
        \I2.PIPEA1l27r_net_1\, \I2.PIPEA_570_net_1\, 
        \I2.PIPEA_8l26r\, \I2.PIPEA1l26r_net_1\, 
        \I2.PIPEA_569_net_1\, \I2.PIPEA_8l25r\, 
        \I2.PIPEA1l25r_net_1\, \I2.PIPEA_568_net_1\, 
        \I2.PIPEA_8l24r\, \I2.PIPEA1l24r_net_1\, 
        \I2.PIPEA_567_net_1\, \I2.PIPEA_8l23r\, 
        \I2.PIPEA1l23r_net_1\, \I2.PIPEA_566_net_1\, 
        \I2.PIPEA_8l22r\, \I2.PIPEA1l22r_net_1\, 
        \I2.PIPEA_565_net_1\, \I2.PIPEA_8l21r\, 
        \I2.PIPEA1l21r_net_1\, \I2.PIPEA_564_net_1\, 
        \I2.PIPEA_8l20r\, \I2.PIPEA1l20r_net_1\, 
        \I2.PIPEA_563_net_1\, \I2.PIPEA_8l19r\, 
        \I2.PIPEA1l19r_net_1\, \I2.PIPEA_562_net_1\, 
        \I2.PIPEA_8l18r\, \I2.PIPEA1l18r_net_1\, 
        \I2.PIPEA_561_net_1\, \I2.PIPEA_8l17r\, 
        \I2.PIPEA1l17r_net_1\, \I2.PIPEA_560_net_1\, 
        \I2.PIPEA_8l16r\, \I2.PIPEA1l16r_net_1\, 
        \I2.PIPEA_559_net_1\, \I2.PIPEA_8l15r\, 
        \I2.PIPEA1l15r_net_1\, \I2.PIPEA_558_net_1\, 
        \I2.PIPEA_8l14r\, \I2.PIPEA1l14r_net_1\, 
        \I2.PIPEA_557_net_1\, \I2.PIPEA_8l13r\, 
        \I2.PIPEA1l13r_net_1\, \I2.PIPEA_556_net_1\, 
        \I2.PIPEA_8l12r\, \I2.PIPEA1l12r_net_1\, 
        \I2.PIPEA_555_net_1\, \I2.PIPEA_8l11r\, 
        \I2.PIPEA1l11r_net_1\, \I2.PIPEA_554_net_1\, 
        \I2.PIPEA_8l10r\, \I2.PIPEA1l10r_net_1\, 
        \I2.PIPEA_553_net_1\, \I2.PIPEA_8l9r\, 
        \I2.PIPEA1l9r_net_1\, \I2.PIPEA_552_net_1\, 
        \I2.PIPEA_8l8r\, \I2.PIPEA1l8r_net_1\, 
        \I2.PIPEA_551_net_1\, \I2.PIPEA_8l7r\, 
        \I2.PIPEA1l7r_net_1\, \I2.PIPEA_550_net_1\, 
        \I2.PIPEA_8l6r\, \I2.PIPEA1l6r_net_1\, 
        \I2.PIPEA_549_net_1\, \I2.PIPEA_8l5r\, 
        \I2.PIPEA1l5r_net_1\, \I2.PIPEA_548_net_1\, 
        \I2.PIPEA_8l4r\, \I2.PIPEA1l4r_net_1\, 
        \I2.PIPEA_547_net_1\, \I2.PIPEA_8l3r\, 
        \I2.PIPEA1l3r_net_1\, \I2.PIPEA_546_net_1\, 
        \I2.PIPEA_8l2r\, \I2.PIPEA1l2r_net_1\, 
        \I2.PIPEA_545_net_1\, \I2.PIPEA_8l1r\, 
        \I2.PIPEA1l1r_net_1\, \I2.PIPEA_544_net_1\, 
        \I2.PIPEA_8l0r\, \I2.PIPEA1l0r_net_1\, 
        \I2.NRDMEBi_543_net_1\, \I2.N_2368\, 
        \I2.un1_NRDMEBi_2_sqmuxa_2_1_i\, \I2.STATE2l0r_net_1\, 
        \I2.NRDMEBi_0_sqmuxa_1_net_1\, \I2.N_2858\, \I2.N_2851\, 
        \I2.PIPEA1_542_net_1\, \I2.PIPEA1_9l31r\, 
        \I2.PIPEA1_541_net_1\, \I2.N_2871\, \I2.PIPEA1_540_net_1\, 
        \I2.PIPEA1_9l29r\, \I2.PIPEA1_539_net_1\, \I2.N_2870\, 
        \I2.PIPEA1_538_net_1\, \I2.N_2551\, \I2.PIPEA1_537_net_1\, 
        \I2.N_2549\, \I2.PIPEA1_536_net_1\, \I2.N_2547\, 
        \I2.PIPEA1_535_net_1\, \I2.N_2545\, \I2.PIPEA1_534_net_1\, 
        \I2.N_2543\, \I2.PIPEA1_533_net_1\, \I2.N_2541\, 
        \I2.PIPEA1_532_net_1\, \I2.N_2539\, \I2.PIPEA1_531_net_1\, 
        \I2.N_2537\, \I2.PIPEA1_530_net_1\, \I2.N_2535\, 
        \I2.PIPEA1_529_net_1\, \I2.N_2533\, \I2.PIPEA1_528_net_1\, 
        \I2.N_2531\, \I2.PIPEA1_527_net_1\, \I2.N_2529\, 
        \I2.PIPEA1_526_net_1\, \I2.N_2527\, \I2.PIPEA1_525_net_1\, 
        \I2.N_2525\, \I2.PIPEA1_524_net_1\, \I2.N_2523\, 
        \I2.PIPEA1_523_net_1\, \I2.N_2521\, \I2.PIPEA1_522_net_1\, 
        \I2.N_2519\, \I2.PIPEA1_521_net_1\, \I2.N_2517\, 
        \I2.PIPEA1_520_net_1\, \I2.N_2515\, \I2.PIPEA1_519_net_1\, 
        \I2.N_2513\, \I2.PIPEA1_518_net_1\, \I2.N_2511\, 
        \I2.PIPEA1_517_net_1\, \I2.N_2509\, \I2.PIPEA1_516_net_1\, 
        \I2.N_2507\, \I2.PIPEA1_515_net_1\, \I2.N_2505\, 
        \I2.PIPEA1_514_net_1\, \I2.N_2503\, \I2.PIPEA1_513_net_1\, 
        \I2.N_2501\, \I2.PIPEA1_512_net_1\, \I2.N_2499\, 
        \I2.PIPEA1_511_net_1\, \I2.N_2497\, \I2.END_PK_510_net_1\, 
        \I2.END_PK_net_1\, \I2.un1_STATE2_13_0_o3_0_net_1\, 
        \I2.N_3072\, \I2.N_2846\, 
        \I2.un1_STATE2_12_0_o3_2_o2_0_net_1\, \I2.N_2894_2\, 
        \I2.N_2895_2\, \I2.LB_i_7l31r_net_1\, 
        \I2.LB_i_7l30r_net_1\, \I2.LB_i_7l29r_net_1\, 
        \I2.LB_i_7l28r_net_1\, \I2.LB_i_7l27r_net_1\, 
        \I2.LB_i_7l26r_net_1\, \I2.LB_i_7l25r_net_1\, 
        \I2.LB_i_7l24r_net_1\, \I2.LB_i_7l23r_net_1\, 
        \I2.LB_i_7l22r_net_1\, \I2.LB_i_7l21r_net_1\, 
        \I2.LB_i_7l20r_net_1\, \I2.LB_i_7l19r_net_1\, 
        \I2.LB_i_7l18r_net_1\, \I2.LB_i_7l17r_net_1\, 
        \I2.LB_i_7l16r_net_1\, \I2.LB_i_7l15r_net_1\, 
        \I2.LB_i_7l14r_net_1\, \I2.LB_i_7l13r_net_1\, 
        \I2.LB_i_7l12r_net_1\, \I2.LB_i_7l11r_net_1\, 
        \I2.LB_i_7l10r_net_1\, \I2.LB_i_7l9r_net_1\, 
        \I2.LB_i_7l8r_net_1\, \I2.N_1894\, \I2.N_1893\, 
        \I2.N_1892\, \I2.LB_i_7l4r_Rd1__net_1\, \I2.N_1891\, 
        \I2.LB_i_7l3r_Rd1__net_1\, \I2.N_1890\, 
        \I2.LB_i_7l2r_Rd1__net_1\, \I2.N_1889\, 
        \I2.LB_i_7l1r_Rd1__net_1\, \I2.N_1888\, 
        \I2.LB_i_7l0r_Rd1__net_1\, \I2.REG_1_477_net_1\, 
        \I2.N_2225\, \I2.N_2265\, \I2.REG_1_476_net_1\, 
        \I2.N_3719_i\, \I2.REG_1_475_net_1\, \I2.REG_1_474_net_1\, 
        \I2.REG_1_473_net_1\, \I2.REG_1_472_net_1\, 
        \I2.REG_1_471_net_1\, \I2.REG_1_470_net_1\, 
        \I2.REG_1_464_net_1\, \I2.REG_1_463_net_1\, 
        \I2.REG_1_462_net_1\, \I2.REG_1_461_net_1\, 
        \I2.REG_92l88r_net_1\, \I2.N_1991\, \I2.REG_1_sqmuxa_1\, 
        \I2.REG_1_460_net_1\, \I2.REG_92l87r_net_1\, \I2.N_1990\, 
        \I2.REG_1_459_net_1\, \I2.REG_92l86r_net_1\, \I2.N_1989\, 
        \I2.REG_1_458_net_1\, \I2.REG_92l85r_net_1\, \I2.N_1988\, 
        \I2.REG_1_457_net_1\, \I2.REG_92l84r_net_1\, \I2.N_1987\, 
        \I2.REG_1_456_net_1\, \I2.REG_92l83r_net_1\, \I2.N_1986\, 
        \I2.REG_1_455_net_1\, \I2.REG_92l82r_net_1\, \I2.N_1985\, 
        \I2.REG_1_454_net_1\, \I2.REG_92l81r_net_1\, \I2.N_1984\, 
        \I2.STATE1l7r_net_1\, \I2.REG_1_453_net_1\, \I2.N_3691_i\, 
        \I2.REG_1_452_net_1\, \I2.REG_1_451_net_1\, 
        \I2.REG_1_450_net_1\, \I2.REG_1_449_net_1\, 
        \I2.REG_1_448_net_1\, \I2.REG_1_447_net_1\, 
        \I2.REG_1_446_net_1\, \I2.REG_1_445_net_1\, 
        \I2.REG_1_444_net_1\, \I2.REG_1_443_net_1\, 
        \I2.REG_1_442_net_1\, \I2.REG_1_441_net_1\, 
        \I2.REG_1_440_net_1\, \I2.REG_1_439_net_1\, 
        \I2.REG_1_438_net_1\, \I2.REG_1_437_net_1\, 
        \I2.REG_1_436_net_1\, \I2.REG_1_435_net_1\, 
        \I2.REG_1_434_net_1\, \I2.REG_1_433_net_1\, 
        \I2.REG_1_432_net_1\, \I2.REG_1_431_net_1\, 
        \I2.REG_1_430_net_1\, \I2.REG_1_429_net_1\, 
        \I2.REG_1_428_net_1\, \I2.REG_1_427_net_1\, 
        \I2.REG_1_426_net_1\, \I2.REG_1_425_net_1\, 
        \I2.REG_1_424_net_1\, \I2.REG_1_423_net_1\, 
        \I2.REG_1_422_net_1\, \I2.REG_1_421_net_1\, 
        \I2.REG_1_420_net_1\, \I2.REG_1_419_net_1\, 
        \I2.REG_1_418_net_1\, \I2.REG_1_417_net_1\, 
        \I2.REG_1_416_net_1\, \I2.REG_1_415_net_1\, 
        \I2.REG_1_414_net_1\, \I2.REG_1_413_net_1\, 
        \I2.REG_1_412_net_1\, \I2.REG_1_411_net_1\, 
        \I2.REG_1_410_net_1\, \I2.REG_1_409_net_1\, 
        \I2.REG_1_408_net_1\, \I2.REG_1_407_net_1\, 
        \I2.REG_1_406_net_1\, \I2.REG_1_405_net_1\, 
        \I2.REG_1_404_net_1\, \I2.REG_1_403_net_1\, 
        \I2.REG_1_402_net_1\, \I2.REG_1_401_net_1\, 
        \I2.REG_1_400_net_1\, \I2.REG_1_399_net_1\, 
        \I2.REG_1_398_net_1\, \I2.REG_1_397_net_1\, 
        \I2.REG_1_396_net_1\, \I2.REG_1_395_net_1\, 
        \I2.REG_1_394_net_1\, \I2.REG_1_393_net_1\, 
        \I2.REG_1_392_net_1\, \I2.REG_1_391_net_1\, 
        \I2.REG_1_390_net_1\, \I2.REG_1_389_net_1\, 
        \I2.REG_1_388_net_1\, \I2.PULSE_1_sqmuxa_5\, 
        \I2.REG_1_383_net_1\, \I2.N_3559_i\, \I2.REG_1_382_net_1\, 
        \I2.REG_1_381_net_1\, \I2.REG_1_380_net_1\, 
        \I2.REG_1_379_net_1\, \I2.REG_1_378_net_1\, 
        \I2.REG_1_377_net_1\, \I2.REG_1_376_net_1\, 
        \I2.REG_1_375_net_1\, \I2.REG_1_374_net_1\, 
        \I2.REG_1_373_net_1\, \I2.REG_1_372_net_1\, 
        \I2.REG_1_371_net_1\, \I2.REG_1_370_net_1\, 
        \I2.REG_1_369_net_1\, \I2.REG_1_368_net_1\, 
        \I2.REG_1_367_net_1\, \I2.REG_1_366_net_1\, 
        \I2.REG_1_365_net_1\, \I2.REG_1_364_net_1\, 
        \I2.REG_1_363_net_1\, \I2.REG_1_362_net_1\, 
        \I2.REG_1_361_net_1\, \I2.REG_1_360_net_1\, 
        \I2.REG_1_359_net_1\, \I2.REG_1_358_net_1\, 
        \I2.REG_1_357_net_1\, \I2.REG_1_356_net_1\, 
        \I2.REG_1_355_net_1\, \I2.REG_1_354_net_1\, 
        \I2.REG_1_353_net_1\, \I2.REG_1_352_net_1\, 
        \I2.REG_1_351_net_1\, \I2.REG_1_350_net_1\, 
        \I2.REG_1_349_net_1\, \I2.REG_1_348_net_1\, 
        \I2.REG_1_347_net_1\, \I2.REG_1_346_net_1\, 
        \I2.REG_1_345_net_1\, \I2.REG_1_344_net_1\, 
        \I2.REG_1_343_net_1\, \I2.REG_1_342_net_1\, 
        \I2.REG_1_341_net_1\, \I2.REG_1_340_net_1\, 
        \I2.REG_1_339_net_1\, \I2.REG_1_338_net_1\, 
        \I2.REG_1_337_net_1\, \I2.REG_1_336_net_1\, 
        \I2.REG_1_335_net_1\, \I2.REG_1_334_net_1\, 
        \I2.REG_1_333_net_1\, \I2.REG_1_332_net_1\, 
        \I2.REG_1_331_net_1\, \I2.REG_1_330_net_1\, 
        \I2.REG_1_329_net_1\, \I2.REG_1_328_net_1\, 
        \I2.REG_1_327_net_1\, \I2.REG_1_326_net_1\, 
        \I2.REG_1_325_net_1\, \I2.REG_1_324_net_1\, 
        \I2.REG_1_323_net_1\, \I2.REG_1_322_net_1\, 
        \I2.REG_1_321_net_1\, \I2.REG_1_320_net_1\, 
        \I2.REG_1_319_net_1\, \I2.REG_1_318_net_1\, 
        \I2.REG_1_317_net_1\, \I2.REG_1_316_net_1\, 
        \I2.REG_1_315_net_1\, \I2.REG_1_314_net_1\, 
        \I2.REG_1_313_net_1\, \I2.REG_1_312_net_1\, 
        \I2.REG_1_311_net_1\, \I2.REG_1_310_net_1\, 
        \I2.REG_1_309_net_1\, \I2.REG_1_308_net_1\, 
        \I2.REG_1_259_net_1\, \I2.REG_1_258_net_1\, 
        \I2.REG_1_257_net_1\, \I2.REG_1_256_net_1\, 
        \I2.REG_1_255_net_1\, \I2.REG_1_254_net_1\, 
        \I2.REG_1_253_net_1\, \I2.REG_1_252_net_1\, 
        \I2.REG_1_251_net_1\, \I2.REG_1_250_net_1\, 
        \I2.REG_1_249_net_1\, \I2.REG_1_248_net_1\, 
        \I2.REG_1_247_net_1\, \I2.REG_1_246_net_1\, 
        \I2.REG_1_245_net_1\, \I2.REG_1_244_net_1\, 
        \I2.REG_1_243_net_1\, \I2.REG_1_242_net_1\, 
        \I2.REG_1_241_net_1\, \I2.REG_1_240_net_1\, 
        \I2.REG_1_239_net_1\, \I2.REG_1_238_net_1\, 
        \I2.REG_1_237_net_1\, \I2.REG_1_236_net_1\, 
        \I2.REG_1_235_net_1\, \I2.REG_1_234_net_1\, 
        \I2.REG_1_233_net_1\, \I2.REG_1_232_net_1\, 
        \I2.REG_1_231_net_1\, \I2.REG_1_230_net_1\, 
        \I2.REG_1_229_net_1\, \I2.REG_1_228_net_1\, 
        \I2.REG_1_227_net_1\, \I2.REG_1_226_net_1\, 
        \I2.REG_1_225_net_1\, \I2.REG_1_224_net_1\, 
        \I2.REG_1_223_net_1\, \I2.REG_1_222_net_1\, 
        \I2.REG_1_221_net_1\, \I2.REG_1_220_net_1\, 
        \I2.REG_1_219_net_1\, \I2.REG_1_218_net_1\, 
        \I2.REG_1_217_net_1\, \I2.REG_1_216_net_1\, 
        \I2.REG_1_215_net_1\, \I2.REG_1_214_net_1\, 
        \I2.REG_1_213_net_1\, \I2.REG_1_212_net_1\, 
        \I2.REG_1_211_net_1\, \I2.REG_1_210_net_1\, 
        \I2.REG_1_209_net_1\, \I2.REG_1_208_net_1\, 
        \I2.REG_1_207_net_1\, \I2.REG_1_206_net_1\, 
        \I2.REG_1_205_net_1\, \I2.REG_1_204_net_1\, 
        \I2.REG_1_203_net_1\, \I2.REG_1_202_net_1\, 
        \I2.REG_1_201_net_1\, \I2.REG_1_200_net_1\, 
        \I2.REG_1_199_net_1\, \I2.REG_1_198_net_1\, 
        \I2.REG_1_197_net_1\, \I2.REG_1_196_net_1\, 
        \I2.PULSE_43_rl10r_net_1\, \I2.N_2913\, 
        \I2.STATE1l6r_net_1\, \I2.PULSE_43_f0l9r_net_1\, 
        \I2.PULSE_43_f0l8r_net_1\, \I2.PULSE_43_f0l7r_net_1\, 
        \I2.PULSE_43_f0l6r_net_1\, \I2.PULSE_43_f1l6r_net_1\, 
        \I2.REG_1_190_net_1\, \I2.REG_1_189_net_1\, 
        \I2.REG_1_188_net_1\, \I2.REG_1_187_net_1\, 
        \I2.REG_1_186_net_1\, \I2.REG_1_185_net_1\, 
        \I2.REG_1_184_net_1\, \I2.REG_1_183_net_1\, 
        \I2.REG_1_182_net_1\, \I2.REG_1_181_net_1\, 
        \I2.REG_1_180_net_1\, \I2.REG_1_179_net_1\, 
        \I2.REG_1_178_net_1\, \I2.REG_1_177_net_1\, 
        \I2.REG_1_176_net_1\, \I2.REG_1_175_net_1\, 
        \I2.REG_1_174_net_1\, \I2.REG_1_173_net_1\, 
        \I2.REG_1_172_net_1\, \I2.REG_1_171_net_1\, 
        \I2.REG_1_170_net_1\, \I2.REG_1_169_net_1\, 
        \I2.REG_1_168_net_1\, \I2.REG_1_167_net_1\, 
        \I2.REG_1_166_net_1\, \I2.REG_1_165_net_1\, 
        \I2.REG_1_164_net_1\, \I2.REG_1_163_net_1\, 
        \I2.REG_1_162_net_1\, \I2.REG_1_161_net_1\, 
        \I2.REG_1_160_net_1\, \I2.REG_1_159_net_1\, 
        \I2.REG_1_158_net_1\, \I2.REG_1_157_net_1\, 
        \I2.REG_1_156_net_1\, \I2.REG_1_155_net_1\, 
        \I2.REG_1_154_net_1\, \I2.REG_1_153_net_1\, 
        \I2.REG_1_152_net_1\, \I2.REG_1_151_net_1\, 
        \I2.REG_1_150_net_1\, \I2.REG_1_149_net_1\, 
        \I2.REG_1_148_net_1\, \I2.REG_1_147_net_1\, 
        \I2.REG_1_146_net_1\, \I2.REG_1_145_net_1\, 
        \I2.REG_1_144_net_1\, \I2.REG_1_143_net_1\, 
        \I2.EVREADi_142_net_1\, \I2.N_2645\, 
        \I2.un1_STATE2_10_i_0_i\, \I2.N_2895_i\, 
        \I2.REG1_0_sqmuxa\, \I2.N_2892_i\, \I2.N_2853_i\, 
        \I2.N_2892_4\, \I2.N_2889_1\, \I2.N_3074_i\, 
        \I2.EVREAD_DS_139_net_1\, 
        \I2.un1_EVREAD_DS_1_sqmuxa_1_net_1\, 
        \I2.EVREAD_DS_1_sqmuxa\, \I2.N_2883\, 
        \I2.EVREAD_DS_1_sqmuxa_0_a2_0_1_0_i\, \I2.N_2835\, 
        \I2.N_2836\, \I2.REG_1_138_net_1\, \I2.REG_1_137_net_1\, 
        \I2.REG_1_136_net_1\, \I2.REG_1_135_net_1\, 
        \I2.REG_1_134_net_1\, \I2.REG_1_133_net_1\, 
        \I2.REG_1_132_net_1\, \I2.REG_1_130_net_1\, 
        \I2.REG_1_124_net_1\, \I2.REG3_122_net_1\, 
        \I2.REG3_121_net_1\, \I2.REG3_120_net_1\, 
        \I2.REG3_119_net_1\, \I2.REG3_118_net_1\, 
        \I2.REG3_117_net_1\, \I2.REG3_116_net_1\, 
        \I2.REG3_115_net_1\, \I2.REG3_113_net_1\, 
        \I2.REG3_112_net_1\, \I2.REG3_111_net_1\, 
        \I2.REG3_110_net_1\, \I2.REG3_109_net_1\, 
        \I2.REG3_108_net_1\, \I2.REG3_107_net_1\, 
        \I2.MBLTCYC_106_net_1\, \I2.N_2639\, \I2.N_2887_i_i\, 
        \I2.un1_vsel_1_i_a2_1_i\, \I2.N_2892_2\, \I2.N_2892_1\, 
        \I2.ADACKCYC_104_net_1\, \I2.N_2637\, 
        \I2.STATE1l4r_net_1\, \I2.un1_state1_1_i_a2_0_1_net_1\, 
        \I2.NOEDTKi_103_net_1\, \I2.un1_STATE1_17\, 
        \I2.PURGED_net_1\, \I2.N_3062\, \I2.PULSE_1_102_net_1\, 
        \I2.PULSE_43l3r\, \I2.un1_STATE1_18\, 
        \I2.PULSE_1_101_net_1\, \I2.PULSE_43l2r\, 
        \I2.PULSE_1_100_net_1\, \I2.PULSE_43l1r\, 
        \I2.PULSE_1_99_net_1\, \I2.PULSE_43l0r\, 
        \I2.WDOGRES_98_net_1\, \I2.WDOGl3r_net_1\, 
        \I2.VAS_97_net_1\, \I2.VAS_96_net_1\, \I2.VAS_95_net_1\, 
        \I2.VAS_94_net_1\, \I2.VAS_93_net_1\, \I2.VAS_92_net_1\, 
        \I2.VAS_91_net_1\, \I2.VAS_90_net_1\, \I2.VAS_89_net_1\, 
        \I2.VAS_88_net_1\, \I2.VAS_87_net_1\, \I2.VAS_86_net_1\, 
        \I2.VAS_85_net_1\, \I2.VAS_84_net_1\, \I2.VAS_83_net_1\, 
        \I2.N_2215\, \I2.N_2271\, \I2.PIPEB_80_net_1\, 
        \I2.N_2631\, \I2.PIPEB_79_net_1\, \I2.N_2882\, 
        \I2.PIPEB_78_net_1\, \I2.N_2881\, \I2.PIPEB_77_net_1\, 
        \I2.N_2880\, \I2.PIPEB_76_net_1\, \I2.N_2623\, 
        \I2.PIPEB_75_net_1\, \I2.N_2621\, \I2.PIPEB_74_net_1\, 
        \I2.N_2619\, \I2.PIPEB_73_net_1\, \I2.N_2617\, 
        \I2.PIPEB_72_net_1\, \I2.N_2615\, \I2.PIPEB_71_net_1\, 
        \I2.N_2613\, \I2.PIPEB_70_net_1\, \I2.N_2611\, 
        \I2.PIPEB_69_net_1\, \I2.N_2609\, \I2.PIPEB_68_net_1\, 
        \I2.N_2607\, \I2.PIPEB_67_net_1\, \I2.N_2605\, 
        \I2.PIPEB_66_net_1\, \I2.N_2603\, \I2.PIPEB_65_net_1\, 
        \I2.N_2601\, \I2.PIPEB_64_net_1\, \I2.N_2599\, 
        \I2.PIPEB_63_net_1\, \I2.N_2597\, \I2.PIPEB_62_net_1\, 
        \I2.N_2595\, \I2.PIPEB_61_net_1\, \I2.N_2593\, 
        \I2.PIPEB_60_net_1\, \I2.N_2591\, \I2.PIPEB_59_net_1\, 
        \I2.N_2589\, \I2.PIPEB_58_net_1\, \I2.N_2587\, 
        \I2.PIPEB_57_net_1\, \I2.N_2585\, \I2.PIPEB_56_net_1\, 
        \I2.N_2583\, \I2.PIPEB_55_net_1\, \I2.N_2581\, 
        \I2.PIPEB_54_net_1\, \I2.N_2579\, \I2.PIPEB_53_net_1\, 
        \I2.N_2577\, \I2.PIPEB_52_net_1\, \I2.N_2575\, 
        \I2.PIPEB_51_net_1\, \I2.N_2573\, \I2.PIPEB_50_net_1\, 
        \I2.N_2571\, \I2.PIPEB_49_net_1\, \I2.N_2569\, 
        \I2.MYBERRi_48_net_1\, \I2.un1_MYBERRi_1_sqmuxa\, 
        \I2.N_2879\, \I2.LWORDS_47_net_1\, \I2.CYCSF1_46_net_1\, 
        \I2.CYCSF1_net_1\, \I2.N_2869\, \I2.N_3016\, \I2.N_3015\, 
        \I2.N_3014\, \I2.N_3037\, \I2.N_3036\, \I2.N_3035\, 
        \I2.N_3034\, \I2.N_3033\, \I2.N_3032\, \I2.N_3031\, 
        \I2.N_3030\, \I2.N_3029\, \I2.N_3028\, \I2.N_3027\, 
        \I2.N_3026\, \I2.N_3025\, \I2.N_3050\, \I2.N_3049\, 
        \I2.N_3048\, \I2.N_3047\, \I2.N_3046\, \I2.N_3045\, 
        \I2.N_3044\, \I2.N_3043\, \I2.N_3042\, \I2.N_3041\, 
        \I2.N_3040\, \I2.N_3039\, \I2.N_3038\, \I2.N_3024\, 
        \I2.N_3023\, \I2.N_3022\, \I2.PURGED_13_net_1\, 
        \I2.DSSF1_12_net_1\, \I2.N_2866\, \I2.TCNT_10l4r\, 
        \I2.TCNT_10l3r\, \I2.TCNT_10l2r_net_1\, 
        \I2.un1_STATE1_15_0_net_1\, \I2.TCNT_10l1r\, 
        \I2.TCNT_10l0r\, \I2.DWACT_ADD_CI_0_partial_sum_2l0r\, 
        \I2.WDOG_3l1r\, \I2.WDOG_3l2r\, \I2.WDOG_3l3r\, 
        \I3.sstate_ns_i_0l0r\, \I3.DWACT_ADD_CI_0_g_array_1l0r\, 
        \I3.DWACT_ADD_CI_0_TMPl0r\, \I3.BITCNTl1r_net_1\, 
        \I3.sstatel1r_net_1\, \I3.N_165\, \I3.N_186\, 
        \I3.SBYTE_10_0\, \I3.SBYTE_5l7r_net_1\, \I3.N_167\, 
        \I3.SBYTE_9_0\, \I3.SBYTE_5l6r_net_1\, \I3.SBYTE_8_0\, 
        \I3.SBYTE_5l5r_net_1\, \I3.SBYTE_7_0\, 
        \I3.SBYTE_5l4r_net_1\, \I3.SBYTE_6_0\, 
        \I3.SBYTE_5l3r_net_1\, \I3.sstatel0r_net_1\, 
        \I3.SBYTE_5_net_1\, \I3.SBYTE_5l2r_net_1\, 
        \I3.SBYTE_4_net_1\, \I3.SBYTE_5l1r_net_1\, 
        \I3.SBYTE_3_net_1\, \I3.SBYTE_5l0r_net_1\, \I3.SO_i\, 
        \I3.N_255\, \I3.N_251\, \I3.N_254\, \I3.N_249\, 
        \I3.N_250\, \I3.N_201\, \I3.N_206\, \I3.N_198\, 
        \I3.N_200\, \I3.N_197\, \I3.N_199\, \I3.N_202\, 
        \I3.N_204\, \I3.N_203\, \I3.N_205\, \I3.N_212\, 
        \I3.N_217\, \I3.N_209\, \I3.N_214\, \I3.N_208\, 
        \I3.N_213\, \I3.N_211\, \I3.N_216\, \I3.N_210\, 
        \I3.N_215\, \I3.N_252\, \I3.N_253\, \I3.N_224\, 
        \I3.N_235\, \I3.N_221\, \I3.N_232\, \I3.N_220\, 
        \I3.N_231\, \I3.N_226\, \I3.N_237\, \I3.N_225\, 
        \I3.N_236\, \I3.N_229\, \I3.N_240\, \I3.N_223\, 
        \I3.N_234\, \I3.N_222\, \I3.N_233\, \I3.N_228\, 
        \I3.N_239\, \I3.N_227\, \I3.N_238\, \I3.ISI_2_net_1\, 
        \I3.ISI_5\, \I3.ISI_0_sqmuxa\, \I3.VALID_1_net_1\, 
        \I3.un1_BITCNT_1_rl2r_net_1\, \I3.N_195\, \I3.I_14_1\, 
        \I3.un1_hwres_2_net_1\, \I3.un1_BITCNT_1_rl1r_net_1\, 
        \I3.I_13_3\, \I3.un1_BITCNT_1_rl0r_net_1\, 
        \I3.DWACT_ADD_CI_0_partial_suml0r\, \I3.I_42_1_net_1\, 
        \I3.BITCNTl0r_net_1\, \I3.BITCNTl2r_net_1\, 
        \I3.un1_hwres_3_net_1\, \I10.event_meb.net00006\, 
        \I10.event_meb.net00007\, \I10.event_meb.net00005\, 
        \I10.event_meb.net00004\, \I10.event_meb.net00003\, 
        \I2.N_2983_1_adt_net_2417_\, \un1_reg_1_adt_net_2497_\, 
        \I1.sstate_ns_el0r_adt_net_7201_\, 
        \I1.N_625_0_adt_net_7241_\, 
        \I1.BITCNT_0_sqmuxa_2_adt_net_7280_\, 
        \I1.sstate_ns_el5r_adt_net_7874_\, 
        \I1.sstate2_ns_el2r_adt_net_8301_\, 
        \I1.sstate2_ns_el1r_adt_net_8343_\, 
        \I1.sstate2_ns_el0r_adt_net_8385_\, 
        \I1.AIR_COMMAND_21l15r_adt_net_8646_\, 
        \I1.un1_AIR_CHAIN_1_sqmuxa_3_i_adt_net_8755_\, 
        \I1.un1_AIR_CHAIN_1_sqmuxa_5_adt_net_8909_\, 
        \I1.AIR_COMMAND_21l14r_adt_net_9030_\, 
        \I1.AIR_COMMAND_21l13r_adt_net_9112_\, 
        \I1.AIR_COMMAND_21l11r_adt_net_9280_\, 
        \I1.AIR_COMMAND_21l9r_adt_net_9514_\, 
        \I1.SBYTE_9l0r_adt_net_10933_\, 
        \I1.START_I2C_2_adt_net_11237_\, 
        \I1.CHAIN_SELECT_4_adt_net_11533_\, 
        \I1.REG_1_105_13_adt_net_12496_\, 
        \I10.N292_adt_net_15372_\, 
        \I10.un6_bnc_res_NE_16_i_adt_net_16189_\, 
        \I10.un6_bnc_res_NE_11_i_adt_net_16263_\, 
        \I10.G_2_i_adt_net_16541_\, 
        \I10.DWACT_ADD_CI_0_g_array_11l0r_adt_net_16569_\, 
        \I10.DWACT_ADD_CI_0_g_array_2_0l0r_adt_net_16625_\, 
        \I10.STATE1_nsl11r_adt_net_16793_\, 
        \I10.un1_STATE1_15_1_adt_net_16929_\, 
        \I10.STATE1_ns_0_0_0_il5r_adt_net_17702_\, 
        \I10.N_926_adt_net_20509_\, 
        \I10.EVRDYi_197_adt_net_20551_\, 
        \I10.FID_8l31r_adt_net_20590_\, 
        \I10.FID_8l30r_adt_net_20661_\, 
        \I10.FID_8l29r_adt_net_20740_\, 
        \I10.FID_8l28r_adt_net_20862_\, 
        \I10.FID_8_iv_0_0_0_1_il27r_adt_net_20945_\, 
        \I10.FID_8_iv_0_0_0_1_il26r_adt_net_21109_\, 
        \I10.FID_8_iv_0_0_0_1_il25r_adt_net_21273_\, 
        \I10.FID_8_iv_0_0_0_1_il24r_adt_net_21437_\, 
        \I10.FID_8_iv_0_0_0_1_il23r_adt_net_21601_\, 
        \I10.FID_8_iv_0_0_0_1_il22r_adt_net_21765_\, 
        \I10.FID_8_iv_0_0_0_1_il21r_adt_net_21929_\, 
        \I10.FID_8_iv_0_0_0_1_il20r_adt_net_22093_\, 
        \I10.FID_8_iv_0_0_0_1_il19r_adt_net_22257_\, 
        \I10.FID_8_iv_0_0_0_1_il18r_adt_net_22421_\, 
        \I10.FID_8_iv_0_0_0_0_il18r_adt_net_22463_\, 
        \I10.FID_8_iv_0_0_0_1_il17r_adt_net_22585_\, 
        \I10.FID_8l16r_adt_net_22788_\, 
        \I10.FID_8l15r_adt_net_22910_\, 
        \I10.FID_8l14r_adt_net_23032_\, 
        \I10.FID_8l13r_adt_net_23154_\, 
        \I10.FID_8l12r_adt_net_23276_\, 
        \I10.FID_8l11r_adt_net_23398_\, 
        \I10.FID_8l10r_adt_net_23520_\, 
        \I10.FID_8l9r_adt_net_23633_\, 
        \I10.FID_8l8r_adt_net_23782_\, 
        \I10.FID_8l7r_adt_net_23903_\, 
        \I10.FID_8l6r_adt_net_24025_\, 
        \I10.FID_8l5r_adt_net_24138_\, 
        \I10.FID_8l4r_adt_net_24259_\, 
        \I10.FID_8_0_iv_0_0_0_0_il3r_adt_net_24342_\, 
        \I10.FID_8l3r_adt_net_24381_\, 
        \I10.FID_8_0_iv_0_0_0_0_il2r_adt_net_24464_\, 
        \I10.FID_8l2r_adt_net_24503_\, 
        \I10.FID_8_0_iv_0_0_0_0_il1r_adt_net_24586_\, 
        \I10.FID_8l1r_adt_net_24625_\, 
        \I10.FID_8_0_iv_0_0_0_0_il0r_adt_net_24708_\, 
        \I10.FID_8l0r_adt_net_24747_\, 
        \I10.EVENT_DWORD_18l29r_adt_net_24986_\, 
        \I10.EVENT_DWORD_18l28r_adt_net_25140_\, 
        \I10.EVENT_DWORD_18l27r_adt_net_25294_\, 
        \I10.EVENT_DWORD_18l26r_adt_net_25448_\, 
        \I10.EVENT_DWORD_18_i_0_0l25r_adt_net_25530_\, 
        \I10.EVENT_DWORD_18l25r_adt_net_25602_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l24r_adt_net_25684_\, 
        \I10.EVENT_DWORD_18l24r_adt_net_25756_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l23r_adt_net_25838_\, 
        \I10.EVENT_DWORD_18l23r_adt_net_25910_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l22r_adt_net_25992_\, 
        \I10.EVENT_DWORD_18l22r_adt_net_26064_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l21r_adt_net_26146_\, 
        \I10.EVENT_DWORD_18l21r_adt_net_26218_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l20r_adt_net_26300_\, 
        \I10.EVENT_DWORD_18l20r_adt_net_26372_\, 
        \I10.EVENT_DWORD_18l19r_adt_net_26484_\, 
        \I10.EVENT_DWORD_18l18r_adt_net_26596_\, 
        \I10.EVENT_DWORD_18l17r_adt_net_26708_\, 
        \I10.EVENT_DWORD_18l16r_adt_net_26820_\, 
        \I10.EVENT_DWORD_18l15r_adt_net_26932_\, 
        \I10.EVENT_DWORD_18l14r_adt_net_27044_\, 
        \I10.EVENT_DWORD_18l13r_adt_net_27156_\, 
        \I10.EVENT_DWORD_18l12r_adt_net_27268_\, 
        \I10.EVENT_DWORD_18l11r_adt_net_27380_\, 
        \I10.EVENT_DWORD_18l10r_adt_net_27492_\, 
        \I10.EVENT_DWORD_18l9r_adt_net_27604_\, 
        \I10.EVENT_DWORD_18l8r_adt_net_27753_\, 
        \I10.EVENT_DWORD_18l7r_adt_net_27903_\, 
        \I10.EVENT_DWORD_18l6r_adt_net_28015_\, 
        \I10.EVENT_DWORD_18l5r_adt_net_28127_\, 
        \I10.EVENT_DWORD_18l4r_adt_net_28239_\, 
        \I10.EVENT_DWORD_18l3r_adt_net_28351_\, 
        \I10.EVENT_DWORD_18l2r_adt_net_28463_\, 
        \I10.EVENT_DWORD_18l1r_adt_net_28575_\, 
        \I10.EVENT_DWORD_18l0r_adt_net_28687_\, 
        \I10.READ_PDL_FLAG_86_0_0_0_adt_net_32635_\, 
        \I10.READ_ADC_FLAG_84_0_0_0_adt_net_32677_\, 
        \I5.G_1_3_adt_net_33101_\, 
        \I5.DWACT_ADD_CI_0_g_array_11_2l0r_adt_net_33417_\, 
        \I5.DWACT_ADD_CI_0_g_array_10l0r_adt_net_33510_\, 
        \I5.sstate_ns_il4r_adt_net_33659_\, 
        \I5.RELOAD_1_adt_net_34760_\, \I2.N_2897_adt_net_36076_\, 
        \I2.un1_STATE2_16_1_adt_net_36115_\, 
        \I2.N_1712_1_adt_net_36665_\, 
        \I2.STATE1_nsl8r_adt_net_37064_\, 
        \I2.N_2385_adt_net_38045_\, 
        \I2.STATE1_nsl5r_adt_net_38376_\, 
        \I2.STATE1_ns_0_0_0_il1r_adt_net_38622_\, 
        \I2.STATE1_nsl1r_adt_net_38698_\, 
        \I2.STATE2_nsl0r_adt_net_38978_\, 
        \I2.VDBi_86_0l31r_adt_net_39227_\, 
        \I2.VDBi_86l30r_adt_net_39432_\, 
        \I2.VDBi_86l29r_adt_net_39637_\, 
        \I2.VDBi_86l28r_adt_net_39842_\, 
        \I2.VDBi_86l27r_adt_net_40047_\, 
        \I2.VDBi_86l26r_adt_net_40252_\, 
        \I2.VDBi_86l25r_adt_net_40457_\, 
        \I2.VDBi_86l24r_adt_net_40662_\, 
        \I2.VDBi_86l23r_adt_net_40867_\, 
        \I2.VDBi_86l22r_adt_net_41072_\, 
        \I2.VDBi_86l21r_adt_net_41277_\, 
        \I2.VDBi_86l20r_adt_net_41482_\, 
        \I2.VDBi_86l19r_adt_net_41715_\, 
        \I2.VDBi_86l18r_adt_net_41920_\, 
        \I2.VDBi_86l17r_adt_net_42125_\, 
        \I2.VDBi_86l16r_adt_net_42330_\, 
        \I2.N_1912_adt_net_42452_\, \I2.N_1912_adt_net_42454_\, 
        \I2.VDBi_54_0_iv_0_il15r_adt_net_42688_\, 
        \I2.VDBi_54_0_iv_1_il15r_adt_net_42730_\, 
        \I2.VDBi_59l15r_adt_net_42806_\, 
        \I2.N_1911_adt_net_43206_\, \I2.N_1911_adt_net_43208_\, 
        \I2.VDBi_54_0_iv_0_il14r_adt_net_43442_\, 
        \I2.VDBi_54_0_iv_1_il14r_adt_net_43484_\, 
        \I2.VDBi_59l14r_adt_net_43560_\, 
        \I2.N_1910_adt_net_43960_\, \I2.N_1910_adt_net_43962_\, 
        \I2.VDBi_54_0_iv_0_il13r_adt_net_44196_\, 
        \I2.VDBi_54_0_iv_1_il13r_adt_net_44238_\, 
        \I2.VDBi_59l13r_adt_net_44314_\, 
        \I2.N_1909_adt_net_44714_\, \I2.N_1909_adt_net_44716_\, 
        \I2.VDBi_54_0_iv_0_il12r_adt_net_44950_\, 
        \I2.VDBi_54_0_iv_1_il12r_adt_net_44992_\, 
        \I2.VDBi_59l12r_adt_net_45068_\, 
        \I2.N_1908_adt_net_45468_\, \I2.N_1908_adt_net_45470_\, 
        \I2.VDBi_54_0_iv_0_il11r_adt_net_45704_\, 
        \I2.VDBi_54_0_iv_1_il11r_adt_net_45746_\, 
        \I2.VDBi_59l11r_adt_net_45822_\, 
        \I2.N_1907_adt_net_46222_\, \I2.N_1907_adt_net_46224_\, 
        \I2.VDBi_54_0_iv_0_il10r_adt_net_46458_\, 
        \I2.VDBi_54_0_iv_1_il10r_adt_net_46500_\, 
        \I2.VDBi_59l10r_adt_net_46576_\, 
        \I2.N_1906_adt_net_46976_\, \I2.N_1906_adt_net_46978_\, 
        \I2.VDBi_54_0_iv_0_il9r_adt_net_47212_\, 
        \I2.VDBi_54_0_iv_1_il9r_adt_net_47254_\, 
        \I2.VDBi_59l9r_adt_net_47330_\, 
        \I2.N_1905_adt_net_47814_\, \I2.N_1905_adt_net_47816_\, 
        \I2.VDBi_54_0_iv_1_il8r_adt_net_48088_\, 
        \I2.VDBi_54_0_iv_2_il8r_adt_net_48130_\, 
        \I2.N_1904_adt_net_48648_\, \I2.N_1904_adt_net_48650_\, 
        \I2.VDBi_54_0_iv_0_il7r_adt_net_48884_\, 
        \I2.VDBi_54_0_iv_1_il7r_adt_net_48926_\, 
        \I2.VDBi_56l7r_adt_net_49002_\, 
        \I2.VDBi_61l7r_adt_net_49041_\, 
        \I2.VDBi_61l7r_adt_net_49043_\, 
        \I2.VDBi_67l7r_adt_net_49083_\, 
        \I2.VDBi_67l7r_adt_net_49085_\, 
        \I2.VDBi_86_iv_1_il7r_adt_net_49127_\, 
        \I2.N_1903_adt_net_49479_\, \I2.N_1903_adt_net_49481_\, 
        \I2.VDBi_54_0_iv_0_il6r_adt_net_49715_\, 
        \I2.VDBi_54_0_iv_1_il6r_adt_net_49757_\, 
        \I2.VDBi_56l6r_adt_net_49833_\, 
        \I2.VDBi_61l6r_adt_net_49872_\, 
        \I2.VDBi_61l6r_adt_net_49874_\, 
        \I2.VDBi_67l6r_adt_net_49914_\, 
        \I2.VDBi_67l6r_adt_net_49916_\, 
        \I2.VDBi_86_iv_1_il6r_adt_net_49958_\, 
        \I2.N_1902_adt_net_50282_\, \I2.N_1902_adt_net_50284_\, 
        \I2.VDBi_54_0_iv_0_il5r_adt_net_50518_\, 
        \I2.VDBi_54_0_iv_1_il5r_adt_net_50560_\, 
        \I2.VDBi_56l5r_adt_net_50636_\, 
        \I2.VDBi_61l5r_adt_net_50675_\, 
        \I2.VDBi_61l5r_adt_net_50677_\, 
        \I2.VDBi_67l5r_adt_net_50717_\, 
        \I2.VDBi_67l5r_adt_net_50719_\, 
        \I2.VDBi_86_iv_1_il5r_adt_net_50761_\, 
        \I2.N_1901_adt_net_51085_\, \I2.N_1901_adt_net_51087_\, 
        \I2.VDBi_54_0_iv_0_il4r_adt_net_51321_\, 
        \I2.VDBi_54_0_iv_1_il4r_adt_net_51363_\, 
        \I2.VDBi_56l4r_adt_net_51439_\, 
        \I2.VDBi_61l4r_adt_net_51478_\, 
        \I2.VDBi_61l4r_adt_net_51480_\, 
        \I2.VDBi_67l4r_adt_net_51520_\, 
        \I2.VDBi_67l4r_adt_net_51522_\, 
        \I2.VDBi_86_iv_1_il4r_adt_net_51564_\, 
        \I2.N_1900_adt_net_51888_\, \I2.N_1900_adt_net_51890_\, 
        \I2.VDBi_54_0_iv_0_il3r_adt_net_52124_\, 
        \I2.VDBi_54_0_iv_1_il3r_adt_net_52166_\, 
        \I2.VDBi_56l3r_adt_net_52242_\, 
        \I2.VDBi_61l3r_adt_net_52281_\, 
        \I2.VDBi_61l3r_adt_net_52283_\, 
        \I2.VDBi_67l3r_adt_net_52323_\, 
        \I2.VDBi_67l3r_adt_net_52325_\, 
        \I2.VDBi_86_iv_1_il3r_adt_net_52367_\, 
        \I2.N_1899_adt_net_52770_\, \I2.N_1899_adt_net_52772_\, 
        \I2.N_1917_adt_net_52812_\, \I2.N_1917_adt_net_52814_\, 
        \I2.VDBi_54_0_iv_0_il2r_adt_net_53020_\, 
        \I2.VDBi_54_0_iv_1_il2r_adt_net_53062_\, 
        \I2.VDBi_86_iv_1_il2r_adt_net_53258_\, 
        \I2.VDBi_86l2r_adt_net_53418_\, 
        \I2.VDBi_54_0_iv_3_il1r_adt_net_53668_\, 
        \I2.VDBi_54_0_iv_5_il1r_adt_net_53707_\, 
        \I2.VDBi_54_0_iv_2_il1r_adt_net_53747_\, 
        \I2.VDBi_54_0_iv_0_il1r_adt_net_53789_\, 
        \I2.VDBi_56l1r_adt_net_53899_\, 
        \I2.VDBi_86_iv_1_il1r_adt_net_54111_\, 
        \I2.VDBi_24l0r_adt_net_54799_\, 
        \I2.VDBi_24l0r_adt_net_54801_\, 
        \I2.VDBi_54_0_iv_1_il0r_adt_net_54961_\, 
        \I2.VDBi_54_0_iv_2_il0r_adt_net_55003_\, 
        \I2.VDBi_54l0r_adt_net_55073_\, 
        \I2.VDBi_70l0r_adt_net_55113_\, 
        \I2.VDBi_70l0r_adt_net_55115_\, 
        \I2.VDBi_86_iv_1_il0r_adt_net_55157_\, 
        \I2.PIPEA_8l31r_adt_net_55425_\, 
        \I2.PIPEA_8l30r_adt_net_55507_\, 
        \I2.PIPEA_8l29r_adt_net_55591_\, 
        \I2.PIPEA_8l28r_adt_net_55675_\, 
        \I2.PIPEA_8l27r_adt_net_55747_\, 
        \I2.PIPEA_8l26r_adt_net_55817_\, 
        \I2.PIPEA_8l25r_adt_net_55887_\, 
        \I2.PIPEA_8l24r_adt_net_55957_\, 
        \I2.PIPEA_8l23r_adt_net_56027_\, 
        \I2.PIPEA_8l22r_adt_net_56097_\, 
        \I2.PIPEA_8l21r_adt_net_56167_\, 
        \I2.PIPEA_8l20r_adt_net_56237_\, 
        \I2.PIPEA_8l19r_adt_net_56307_\, 
        \I2.PIPEA_8l18r_adt_net_56377_\, 
        \I2.PIPEA_8l17r_adt_net_56447_\, 
        \I2.PIPEA_8l16r_adt_net_56517_\, 
        \I2.PIPEA_8l15r_adt_net_56587_\, 
        \I2.PIPEA_8l14r_adt_net_56657_\, 
        \I2.PIPEA_8l13r_adt_net_56727_\, 
        \I2.PIPEA_8l12r_adt_net_56797_\, 
        \I2.PIPEA_8l11r_adt_net_56867_\, 
        \I2.PIPEA_8l10r_adt_net_56937_\, 
        \I2.PIPEA_8l9r_adt_net_57007_\, 
        \I2.PIPEA_8l8r_adt_net_57114_\, 
        \I2.PIPEA_8l7r_adt_net_57184_\, 
        \I2.PIPEA_8l6r_adt_net_57254_\, 
        \I2.PIPEA_8l5r_adt_net_57324_\, 
        \I2.PIPEA_8l4r_adt_net_57394_\, 
        \I2.PIPEA_8l3r_adt_net_57464_\, 
        \I2.PIPEA_8l2r_adt_net_57534_\, 
        \I2.PIPEA_8l1r_adt_net_57604_\, 
        \I2.PIPEA_8l0r_adt_net_57674_\, 
        \I2.un1_NRDMEBi_2_sqmuxa_2_adt_net_57879_\, 
        \I2.NRDMEBi_543_adt_net_57947_\, 
        \I2.un1_STATE2_13_adt_net_59330_\, 
        \I2.END_PK_510_adt_net_59368_\, 
        \I2.END_PK_510_adt_net_59370_\, 
        \I2.PULSE_43_f0l7r_adt_net_71087_\, 
        \I2.PULSE_43_f1l6r_adt_net_71125_\, 
        \I2.REG3_506_141_adt_net_73367_\, 
        \I2.EVREAD_DS_139_adt_net_73658_\, 
        \I2.N_2639_adt_net_74747_\, 
        \I2.un1_STATE1_25_0_0_adt_net_74952_\, 
        \I2.un1_STATE1_25_adt_net_74991_\, 
        \I2.un1_WDOGRES_0_sqmuxa_adt_net_75393_\, 
        \I2.WDOGRES_98_adt_net_75433_\, 
        \I2.N_2310_i_adt_net_76095_\, 
        \I2.nLBAS_81_adt_net_76219_\, 
        \I2.DSSF1_12_adt_net_79192_\, 
        \I2.nLBLAST_3_adt_net_79232_\, \I3.N_165_adt_net_80145_\, 
        \I2.VDBi_24l1r_adt_net_91078_\, 
        \I2.VDBi_24l1r_adt_net_91121_\, 
        \I2.VDBi_24l1r_adt_net_91170_\, 
        \I2.VDBi_24l1r_adt_net_91174_\, 
        \I2.VDBi_56l1r_adt_net_93309_\, 
        \I2.VDBi_67l1r_adt_net_95714_\, 
        \I2.NRDMEBi_543_adt_net_100728_\, 
        \I2.VDBi_67_m_il1r_adt_net_103676_\, 
        \I2.VDBi_67_m_il1r_adt_net_103772_\, \I8.sstate_d_0l3r\, 
        \I8.N_207_i\, \I8.sstate_ns_i_a2_0_il0r\, 
        \I8.sstate_dl2r\, \I8.I_50_0_net_1\, un1_sdab_0_a2, 
        un1_sdaa_0_a2, \I1.un83_tick_net_1\, \I1.N_486\, 
        \I1.N_690\, \I1.I_192_3_0_net_1\, \I1.N_632\, 
        \I1.SCL_1_iv_i_a3_1_net_1\, \I1.N_402\, \I1.N_545_1\, 
        \I10.N_2642_0\, \I10.G_1_0_0_i\, \I10.N_2396\, 
        \I10.N_557_2\, \I10.N_2299\, \I10.N_2395_1\, 
        \I10.un6_bnc_res_NE_0_i\, \I10.un2_evread_3_i_0_a2_0_1_i\, 
        \I10.un2_evread_3_i_0_a2_0_2_net_1\, \I10.N_2312_i_0_i\, 
        \I10.N_2311_i_0_i\, \I10.N_2310_i_0_i\, 
        \I10.N_2309_i_0_i\, \I10.FID_4_0_a2_0l11r_net_1\, 
        \I10.FID_4_0_a2_0l10r_net_1\, \I10.FID_4_0_a2_0l9r_net_1\, 
        \I10.FID_4_0_a2_0l8r_net_1\, \I10.FID_4_0_a2_0l7r_net_1\, 
        \I10.FID_4_0_a2_0l6r_net_1\, \I10.FID_4_0_a2_0l5r_net_1\, 
        \I10.FID_4_0_a2_0l4r_net_1\, \I10.N_2390\, 
        \I10.N_2346_i_i_0\, \I10.N_2650\, \I10.N_2377_2\, 
        \I10.N_2649\, \I10.N_2284\, \I10.N_2302\, 
        \I10.N_2295_i_0\, \I10.N_2300\, \I10.N_2283_i_i_0\, 
        \I10.N_2524_1\, \I10.N_2296\, \I10.N_2303\, \I10.N_2298\, 
        \I10.N_2288\, \I10.N_2280\, \I10.N_2279\, \I10.N_2358\, 
        \I10.N_2290\, \I10.N_2406\, \I10.N_2294\, \I10.N_1041\, 
        \I10.N_2330_i_i_0\, \I10.N_2338_i_i_0\, 
        \I10.N_2321_i_i_0\, \I10.N_2320_i_i_0\, 
        \I10.N_2319_i_i_0\, \I10.N_2345_i_i_0\, 
        \I10.N_2340_i_i_0\, \I10.N_2337_i_i_0\, 
        \I10.N_2329_i_i_0\, \I10.N_2336_i_i_0\, 
        \I10.N_2328_i_i_0\, \I10.N_2335_i_i_0\, 
        \I10.N_2316_i_i_0\, \I10.N_2334_i_i_0\, 
        \I10.N_2315_i_i_0\, \I10.N_2318_i_i_0\, 
        \I10.N_2339_i_i_0\, \I10.N_2327_i_i_0\, 
        \I10.N_2326_i_i_0\, \I10.N_2333_i_i_0\, 
        \I10.N_2325_i_i_0\, \I10.N_2324_i_i_0\, 
        \I10.N_2314_i_i_0\, \I10.N_2317_i_i_0\, 
        \I10.N_2332_i_i_0\, \I10.N_2344_i_i_0\, 
        \I10.N_2343_i_i_0\, \I10.N_2323_i_i_0\, 
        \I10.N_2322_i_i_0\, \I10.N_2331_i_i_0\, 
        \I10.N_2341_i_i_0\, \I10.N_2342_i_i_0\, \I10.N_2647\, 
        \I10.DWACT_ADD_CI_0_pog_array_1_1l0r\, 
        \I10.DWACT_ADD_CI_0_pog_array_1_0l0r\, 
        \I10.DWACT_ADD_CI_0_pog_array_2_0l0r\, \I10.I_5\, 
        \I10.DWACT_ADD_CI_0_pog_array_1l0r\, 
        \I5.sstate_0_sqmuxa_1_0_a2_3_i\, 
        \I5.sstate_0_sqmuxa_1_0_a2_5_net_1\, 
        \I5.sstate_0_sqmuxa_1_0_a2_1_net_1\, \I5.N_218\, 
        \I5.ISI_0_sqmuxa_0_a2_0_net_1\, un6_fcs, 
        \I5.DWACT_ADD_CI_0_pog_array_1l0r\, 
        \I5.DWACT_ADD_CI_0_pog_array_1_5l0r\, 
        \I5.DWACT_ADD_CI_0_pog_array_1_1l0r\, 
        \I5.DWACT_ADD_CI_0_pog_array_2l0r\, 
        \I5.DWACT_ADD_CI_0_pog_array_1_3l0r\, NOEAD_c_0_0, 
        \I2.N_1885_1\, \I2.N_2830_4\, \I2.N_2319_1\, 
        \I2.WDOGRES_i_net_1\, NOEAD_c_i_0, NSELCLK_c_i_0, 
        REG_i_0l447r, REG_i_0l446r, REG_i_0l445r, REG_i_0l444r, 
        REG_i_0l443r, REG_i_0l442r, REG_i_0l296r, REG_i_0l295r, 
        REG_i_0l294r, REG_i_0l293r, REG_i_0l292r, REG_i_0l291r, 
        REG_i_0l290r, REG_i_0l289r, REG_i_0l288r, REG_i_0l287r, 
        REG_i_0l286r, REG_i_0l285r, REG_i_0l284r, REG_i_0l283r, 
        REG_i_0l282r, REG_i_0l281r, REG_i_0l280r, REG_i_0l279r, 
        REG_i_0l278r, REG_i_0l277r, REG_i_0l276r, REG_i_0l275r, 
        REG_i_0l274r, REG_i_0l273r, REG_i_0l272r, REG_i_0l271r, 
        REG_i_0l270r, REG_i_0l269r, REG_i_0l268r, REG_i_0l267r, 
        REG_i_0l266r, REG_i_0l265r, REG_i_0l441r, REG_i_0l448r, 
        \I2.N_2863\, \I2.N_3006_1\, \I2.N_3005_1\, \I2.N_3067\, 
        \I2.N_3065\, \I2.N_3064\, \I2.N_3068\, \I2.N_3069\, 
        \I2.N_3061\, \I2.N_3009_1\, 
        \I2.un7_ronly_0_a2_0_a2_2_1_i\, \I2.un25_tcnt_0_o3_2_i\, 
        \I2.N_3071_i\, \I2.N_3058_1_i_i\, \I2.N_2848\, 
        \I2.N_2886_1\, \I2.N_2823\, \I2.N_2829\, 
        \I2.un14_tcnt3_0_i\, \I2.un14_tcnt3_2_i\, 
        \I2.un11_tcnt2_0_i\, \I2.un11_tcnt2_2_i\, 
        \I2.un6_tcnt1_2_i\, \I2.N_15\, \I2.DWACT_FINC_El0r\, 
        \I2.I_13_2\, \I2.I_9_0\, \I2.I_5_0\, \I2.I_4\, 
        \I2.DWACT_ADD_CI_0_partial_sum_1l0r\, 
        \I2.DWACT_ADD_CI_0_TMP_0l0r\, 
        \I2.DWACT_ADD_CI_0_partial_sum_0l0r\, 
        \I2.DWACT_ADD_CI_0_TMPl0r\, 
        \I2.DWACT_ADD_CI_0_g_array_1_2l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_1_1_0l0r\, 
        \I2.DWACT_ADD_CI_0_partial_suml0r\, 
        \I2.DWACT_ADD_CI_0_partial_suml4r\, 
        \I2.DWACT_ADD_CI_0_pog_array_0_2l0r\, 
        \I2.DWACT_ADD_CI_0_pog_array_0_1l0r\, 
        \I2.DWACT_ADD_CI_0_pog_array_0l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_0_2l0r\, 
        \I2.DWACT_ADD_CI_0_TMP_2l0r\, \I3.un16_ae_3l47r\, 
        \I3.un16_ae_1l47r\, \I3.un16_ae_1l46r\, 
        \I3.un16_ae_1l39r\, \I3.un16_ae_2l31r\, 
        \I3.un16_ae_1l31r\, \I3.un16_ae_1l30r\, 
        \I3.un16_ae_1l23r\, \I3.un16_ae_2l15r\, 
        \I3.un16_ae_1l14r\, \I3.un16_ae_2l47r\, 
        \I3.un16_ae_1l45r\, \I3.un16_ae_1l43r\, \I3.un16_ae_1l7r\, 
        \I3.un16_ae_1l41r\, \I3.un16_ae_1l15r\, \I3.un16_ae_1l6r\, 
        \I3.N_184_i\, \I3.sstate_dl2r\, \I3.N_195_2\, 
        \I3.sstate_dl3r\, \I3.un4_pulse_net_1\, 
        \I8.sstate_ns_i_a2_1_il0r_adt_net_5385_\, 
        \I8.ISI_5_adt_net_5506_\, 
        \I1.un1_AIR_CHAIN_1_sqmuxa_0_adt_net_8716_\, 
        \I1.N_661_adt_net_11089_\, \I10.G_1_0_adt_net_15904_\, 
        \I10.CNT_10_i_0_o3_0l0r_adt_net_15944_\, 
        \I10.DWACT_ADD_CI_0_g_array_1l0r_adt_net_16050_\, 
        \I10.DWACT_FINC_El0r_adt_net_18772_\, 
        \I10.DWACT_FINC_El2r_adt_net_18800_\, 
        \I10.DWACT_FINC_El5r_adt_net_18828_\, 
        \I10.DWACT_FINC_El7r_adt_net_18884_\, 
        \I10.DWACT_FINC_El9r_adt_net_18912_\, 
        \I10.DWACT_FINC_El12r_adt_net_18940_\, 
        \I10.un2_evread_3_i_0_a2_0_12_i_adt_net_20367_\, 
        \I10.FID_8_iv_0_0_0_0_il27r_adt_net_20987_\, 
        \I10.FID_8_iv_0_0_0_0_il26r_adt_net_21151_\, 
        \I10.FID_8_iv_0_0_0_0_il25r_adt_net_21315_\, 
        \I10.FID_8_iv_0_0_0_0_il24r_adt_net_21479_\, 
        \I10.FID_8_iv_0_0_0_0_il23r_adt_net_21643_\, 
        \I10.FID_8_iv_0_0_0_0_il22r_adt_net_21807_\, 
        \I10.FID_8_iv_0_0_0_0_il21r_adt_net_21971_\, 
        \I10.FID_8_iv_0_0_0_0_il20r_adt_net_22135_\, 
        \I10.FID_8_iv_0_0_0_0_il19r_adt_net_22299_\, 
        \I10.FID_8_iv_0_0_0_0_il17r_adt_net_22627_\, 
        \I10.FID_8_iv_0_0_0_0_il15r_adt_net_22871_\, 
        \I10.FID_8_iv_0_0_0_0_il14r_adt_net_22993_\, 
        \I10.FID_8_iv_0_0_0_0_il13r_adt_net_23115_\, 
        \I10.FID_8_iv_0_0_0_0_il12r_adt_net_23237_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l19r_adt_net_26454_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l18r_adt_net_26566_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l17r_adt_net_26678_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l16r_adt_net_26790_\, 
        \I10.EVENT_DWORD_18_i_0_0l15r_adt_net_26902_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l14r_adt_net_27014_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l13r_adt_net_27126_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l12r_adt_net_27238_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l11r_adt_net_27350_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l10r_adt_net_27462_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l9r_adt_net_27574_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l8r_adt_net_27723_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l7r_adt_net_27873_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l6r_adt_net_27985_\, 
        \I10.EVENT_DWORD_18_i_0_0l5r_adt_net_28097_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l4r_adt_net_28209_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l3r_adt_net_28321_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l2r_adt_net_28433_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l1r_adt_net_28545_\, 
        \I10.EVENT_DWORD_18_i_0_0_0l0r_adt_net_28657_\, 
        \I10.N_2371_adt_net_28966_\, 
        \I10.un2_i2c_chain_0_i_0_0_0_il2r_adt_net_29501_\, 
        \I10.un2_i2c_chain_0_0_0_0_0_il1r_adt_net_29771_\, 
        \I10.N_2525_i_adt_net_30597_\, 
        \I10.un2_i2c_chain_0_i_i_i_3_il4r_adt_net_30702_\, 
        \I10.un2_i2c_chain_0_i_i_i_2_il4r_adt_net_30782_\, 
        \I5.G_1_3_4_i_adt_net_33036_\, 
        \I5.G_1_3_3_i_adt_net_33073_\, 
        \I5.sstate_0_sqmuxa_1_0_a2_13_i_adt_net_33240_\, 
        \I5.ISI_5_adt_net_33880_\, 
        \I2.un7_ronly_0_a2_0_a2_adt_net_37317_\, 
        \I2.un90_reg_ads_0_a2_0_a2_adt_net_37522_\, 
        \I2.VDBi_86_0_iv_0_il31r_adt_net_39188_\, 
        \I2.VDBi_86_0_iv_0_il30r_adt_net_39393_\, 
        \I2.VDBi_86_0_iv_0_il29r_adt_net_39598_\, 
        \I2.VDBi_86_0_iv_0_il28r_adt_net_39803_\, 
        \I2.VDBi_86_0_iv_0_il27r_adt_net_40008_\, 
        \I2.VDBi_86_0_iv_0_il26r_adt_net_40213_\, 
        \I2.VDBi_86_0_iv_0_il25r_adt_net_40418_\, 
        \I2.VDBi_86_0_iv_0_il24r_adt_net_40623_\, 
        \I2.VDBi_86_0_iv_0_il23r_adt_net_40828_\, 
        \I2.VDBi_86_0_iv_0_il22r_adt_net_41033_\, 
        \I2.VDBi_86_0_iv_0_il21r_adt_net_41238_\, 
        \I2.VDBi_86_0_iv_0_il20r_adt_net_41443_\, 
        \I2.VDBi_86_0_iv_0_il18r_adt_net_41881_\, 
        \I2.VDBi_86_0_iv_0_il17r_adt_net_42086_\, 
        \I2.VDBi_86_0_iv_0_il16r_adt_net_42291_\, 
        \I2.DWACT_ADD_CI_0_g_array_2_1l0r_adt_net_79444_\, 
        \I2.un6_tcnt1_adt_net_79937_\, \I3.ISI_5_adt_net_82913_\, 
        \I8.sstate_ns_i_a2_2_il0r\, \I8.I_50_3_net_1\, \I1.N_401\, 
        \I1.N_516\, \I10.G_1_1_2_i\, \I10.N_2640\, 
        \I10.CNT_10_i_0_o3_0l0r_net_1\, \I10.N_2395_i\, 
        \I10.N_2393\, \I10.N_2383\, \I10.N_2384\, 
        \I10.un6_bnc_res_NE_4_i\, \I10.FID_8_iv_0_0_0_0_il27r\, 
        \I10.FID_8_iv_0_0_0_0_il26r\, 
        \I10.FID_8_iv_0_0_0_0_il25r\, 
        \I10.FID_8_iv_0_0_0_0_il24r\, 
        \I10.FID_8_iv_0_0_0_0_il23r\, 
        \I10.FID_8_iv_0_0_0_0_il22r\, 
        \I10.FID_8_iv_0_0_0_0_il21r\, 
        \I10.FID_8_iv_0_0_0_0_il20r\, 
        \I10.FID_8_iv_0_0_0_0_il19r\, 
        \I10.FID_8_iv_0_0_0_0_il17r\, \I10.FID_4_il11r\, 
        \I10.FID_4_il10r\, \I10.FID_4l9r\, \I10.FID_4l8r\, 
        \I10.FID_4_il7r\, \I10.FID_4_il6r\, \I10.FID_4l5r\, 
        \I10.FID_4_il4r\, \I10.un2_i2c_chain_0_0_0_0_0_il3r\, 
        \I10.un2_i2c_chain_0_i_0_0_0_il2r\, \I10.N_3177_i\, 
        \I10.N_2401_i_i\, \I10.N_2400_1\, \I10.N_2645_i\, 
        \I10.un2_i2c_chain_0_0_0_0_0_il1r\, 
        \I10.un2_i2c_chain_0_0_0_0_a2_4l1r_net_1\, \I10.N_2305\, 
        \I10.N_2376_1\, \I10.N_2375_1\, \I10.N_2373\, 
        \I10.N_2727\, \I10.N_2409\, \I10.N_2404\, \I10.N_2411_i\, 
        \I10.un2_i2c_chain_0_i_0_a2_1l5r_net_1\, \I10.N_2374_1\, 
        \I10.un2_i2c_chain_0_i_i_i_0l4r_net_1\, \I10.N_2347_i_0\, 
        \I10.N_2521_i\, \I10.N_2377_1\, \I10.N_557_1\, 
        \I10.N_2627\, \I10.N_2282\, \I10.N_2359\, REGl383r, 
        REGl382r, REGl381r, \I10.DWACT_FINC_El7r\, 
        \I10.DWACT_FINC_El2r\, \I10.DWACT_FINC_El0r\, 
        \I10.I_13_0\, \I10.I_9\, \I5.G_1_1_0\, 
        \I5.sstate_0_sqmuxa_1_0_a2_9_i\, 
        \I5.sstate_0_sqmuxa_1_0_a2_11_net_1\, \I5.ISCK_4_net_1\, 
        \I5.ISI_0_sqmuxa\, \I5.DWACT_ADD_CI_0_pog_array_2_1l0r\, 
        \I2.N_1721_1\, \I2.DWACT_ADD_CI_0_g_array_1l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_2l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_11l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_12_1l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_12l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_12_2l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_1_0l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_2_0l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_11_0l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_12_1_0l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_12_0l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_12_2_0l0r\, 
        \I2.N_2980_i_net_1\, \I2.STATE2_il4r_net_1\, 
        \I2.un110_reg_ads_0_a2_0_a2_1_i\, \I2.N_3008_1\, 
        \I2.N_3013_2\, \I2.N_3012_1\, \I2.N_3010_1\, 
        \I2.un7_ronly_0_a2_0_a2_2_3_i\, \I2.VDBi_85_ml15r_net_1\, 
        \I2.VDBi_85_ml14r_net_1\, \I2.VDBi_85_ml13r_net_1\, 
        \I2.VDBi_85_ml12r_net_1\, \I2.VDBi_85_ml11r_net_1\, 
        \I2.VDBi_85_ml10r_net_1\, \I2.VDBi_85_ml9r_net_1\, 
        \I2.VDBi_85_ml8r_net_1\, \I2.VDBi_85_ml7r_net_1\, 
        \I2.VDBi_85_ml6r_net_1\, \I2.VDBi_85_ml5r_net_1\, 
        \I2.VDBi_85_ml4r_net_1\, \I2.VDBi_85_ml3r_net_1\, 
        \I2.VDBi_85_ml2r_net_1\, \I2.VDBi_85_ml1r_net_1\, 
        \I2.VDBi_85_ml0r_net_1\, \I2.N_2831\, \I2.un14_tcnt3_5_i\, 
        \I2.un14_tcnt3_4_i\, \I2.un11_tcnt2_5_i\, 
        \I2.un11_tcnt2_4_i\, \I2.un6_tcnt1_net_1\, \I2.N_7\, 
        \I2.N_4\, \I2.I_20_1\, \I2.TCNT3_2l7r\, \I2.TCNT3_2l5r\, 
        \I2.TCNT3_2l2r\, \I2.TCNT3_2l1r\, \I2.TCNT3_2l3r\, 
        \I2.TCNT3_2l4r\, \I2.TCNT3_2l6r\, \I2.TCNT2_2l7r\, 
        \I2.TCNT2_2l5r\, \I2.TCNT2_2l2r\, \I2.TCNT2_2l1r\, 
        \I2.TCNT2_2l3r\, \I2.TCNT2_2l4r\, \I2.TCNT2_2l6r\, 
        \I2.DWACT_ADD_CI_0_g_array_2_1l0r\, 
        \I2.DWACT_ADD_CI_0_g_array_12_4l0r\, \I2.I_22_0\, 
        \I2.I_21_0\, \I2.I_20_0\, \I2.I_19\, \I3.un16_ael45r\, 
        \I3.un16_ae_4l47r\, \I3.un16_ae_1l38r\, \I3.un16_ael37r\, 
        \I3.un16_ae_1l44r\, \I3.un16_ae_2l43r\, 
        \I3.un16_ae_1l42r\, \I3.un16_ae_1l33r\, 
        \I3.un16_ae_1l40r\, \I3.un16_ael30r\, \I3.un16_ae_3l31r\, 
        \I3.un16_ael22r\, \I3.un16_ae_1l29r\, \I3.un16_ae_1l28r\, 
        \I3.un16_ae_1l27r\, \I3.un16_ae_1l26r\, 
        \I3.un16_ae_1l25r\, \I3.un16_ae_1l24r\, \I3.un16_ael13r\, 
        \I3.un16_ael12r\, \I3.un16_ae_1l11r\, \I3.un16_ae_2l7r\, 
        \I3.un16_ae_1l5r\, \I3.un16_ae_1l4r\, \I3.un16_ae_1l1r\, 
        \I3.un16_ael0r\, \I1.N_408_adt_net_8520_\, 
        \I10.DWACT_FINC_El28r_adt_net_18856_\, 
        \I10.DWACT_FINC_El13r_adt_net_18968_\, 
        \I10.FID_8_iv_0_0_0_0_il11r_adt_net_23359_\, 
        \I10.FID_8_iv_0_0_0_0_il10r_adt_net_23481_\, 
        \I10.FID_8_iv_0_0_0_0l9r_adt_net_23603_\, 
        \I10.FID_8_iv_0_0_0_0l8r_adt_net_23752_\, 
        \I10.FID_8_iv_0_0_0_0_il7r_adt_net_23864_\, 
        \I10.FID_8_iv_0_0_0_0_il6r_adt_net_23986_\, 
        \I10.FID_8_iv_0_0_0_0l5r_adt_net_24108_\, 
        \I10.FID_8_iv_0_0_0_0_il4r_adt_net_24220_\, 
        \I10.un2_i2c_chain_0_i_0_0_i_1l2r_adt_net_29231_\, 
        \I10.un2_i2c_chain_0_i_0_0_3_il2r_adt_net_29431_\, 
        \I10.un2_i2c_chain_0_0_0_0_3_il1r_adt_net_29650_\, 
        \I10.un2_i2c_chain_0_0_0_0_1_il6r_adt_net_30046_\, 
        \I10.un2_i2c_chain_0_i_0_6_il5r_adt_net_30266_\, 
        \I10.un2_i2c_chain_0_i_i_i_4_il4r_adt_net_30634_\, 
        \I5.sstate_nsl0r_adt_net_33840_\, 
        \I2.un106_reg_ads_0_a2_0_a2_adt_net_37438_\, 
        \I2.un102_reg_ads_0_a2_0_a2_adt_net_37466_\, 
        \I2.un94_reg_ads_0_a2_0_a2_adt_net_37494_\, 
        \I2.un37_reg_ads_0_a2_0_a2_adt_net_37774_\, 
        \I2.un2_reg_ads_0_a2_adt_net_37970_\, 
        \I2.STATE1_nsl7r_adt_net_38258_\, \I8.N_219\, 
        \I1.un1_sstate_12_0_0_net_1\, 
        \I10.STATE1_ns_i_0_0_0_1l0r_net_1\, \I10.N_2278\, 
        \I10.STATE1_ns_0_0_0l9r_net_1\, \I10.STATE1_nsl4r\, 
        \I10.N_2286\, \I10.un2_i2c_chain_0_0_0_0_2_il3r\, 
        \I10.N_2366\, \I10.un2_i2c_chain_0_i_0_0_2_il2r\, 
        \I10.un2_i2c_chain_0_i_0_0_3_il2r\, 
        \I10.un2_i2c_chain_0_i_0_0_i_1l2r_net_1\, 
        \I10.un2_i2c_chain_0_0_0_0_1_il1r\, 
        \I10.un2_i2c_chain_0_0_0_0_3_il1r\, \I10.N_2376\, 
        \I10.un2_i2c_chain_0_0_0_0_0l6r_net_1\, \I10.N_2412_1\, 
        \I10.un2_i2c_chain_0_i_0_1_il5r\, 
        \I10.un2_i2c_chain_0_i_0_2_il5r\, \I10.N_2403\, 
        \I10.N_2520_i\, \I10.N_2297\, \I10.N_245\, \I10.N_77\, 
        \I10.DWACT_FINC_El13r\, \I10.DWACT_FINC_El28r\, 
        \I10.N_16\, \I10.N_21\, \I10.N_26\, \I10.N_31\, 
        \I10.N_36\, \I10.N_44\, \I10.DWACT_FINC_El4r\, \I10.I_45\, 
        \I10.N_64\, \I10.I_31\, \I10.N_74\, \I10.I_20\, 
        \I5.G_1_1_3_i\, \I5.sstate_0_sqmuxa_1_0_a2_12_i\, 
        NOE32W_c_c, NOE16W_c_c, \I2.N_3018_2_i\, 
        \I2.VDBi_86_iv_0l15r_net_1\, \I2.VDBi_86_iv_0l14r_net_1\, 
        \I2.VDBi_86_iv_0l13r_net_1\, \I2.VDBi_86_iv_0l12r_net_1\, 
        \I2.VDBi_86_iv_0l11r_net_1\, \I2.VDBi_86_iv_0l10r_net_1\, 
        \I2.VDBi_86_iv_0l9r_net_1\, \I2.VDBi_86_iv_0l8r_net_1\, 
        \I2.un11_tcnt2_net_1\, \I2.I_24_1\, \I3.un16_ael47r\, 
        \I3.un16_ael46r\, AE_PDL_cl45r, \I3.un16_ael44r\, 
        \I3.un16_ael43r\, \I3.un16_ael42r\, \I3.un16_ael41r\, 
        \I3.un16_ael40r\, \I3.un16_ael39r\, \I3.un16_ael38r\, 
        AE_PDL_cl37r, \I3.un16_ael36r\, \I3.un16_ael35r\, 
        \I3.un16_ael34r\, \I3.un16_ael33r\, \I3.un16_ael32r\, 
        \I3.un16_ael31r\, AE_PDL_cl30r, \I3.un16_ael29r\, 
        \I3.un16_ael28r\, \I3.un16_ael27r\, \I3.un16_ael26r\, 
        \I3.un16_ael25r\, \I3.un16_ael24r\, \I3.un16_ael23r\, 
        AE_PDL_cl22r, \I3.un16_ael21r\, \I3.un16_ael20r\, 
        \I3.un16_ael19r\, \I3.un16_ael18r\, \I3.un16_ael17r\, 
        \I3.un16_ael16r\, \I3.un16_ael15r\, \I3.un16_ael14r\, 
        AE_PDL_cl13r, AE_PDL_cl12r, \I3.un16_ael11r\, 
        \I3.un16_ael10r\, \I3.un16_ael9r\, \I3.un16_ael8r\, 
        \I3.un16_ael7r\, \I3.un16_ael6r\, \I3.un16_ael5r\, 
        \I3.un16_ael4r\, \I3.un16_ael3r\, \I3.un16_ael2r\, 
        \I3.un16_ael1r\, AE_PDL_cl0r, 
        \I5.sstate_nsl5r_adt_net_33314_\, \I8.N_180\, 
        \I10.STATE1_ns_i_0_0_0_3_il0r\, \I10.STATE1_nsl10r\, 
        \I10.STATE1_nsl9r\, \I10.N_2356\, 
        \I10.PDL_RADDR_1_sqmuxa\, \I10.N_2354\, 
        \I10.un2_i2c_chain_0_0_0_0_1l3r_net_1\, \I10.N_589_i_0\, 
        \I10.N_246\, \I10.N_3170_i\, 
        \I10.un2_i2c_chain_0_0_0_0_2_il6r\, 
        \I10.un2_i2c_chain_0_i_0_4_il5r\, 
        \I10.un2_i2c_chain_0_i_i_i_3_il4r\, 
        \I10.DWACT_ADD_CI_0_partial_sum_2l0r\, 
        \I10.DWACT_ADD_CI_0_TMP_1l0r\, \I10.N_54\, \I10.N_39\, 
        \I10.N_4\, \I10.N_9\, \I10.I_105\, \I10.I_98\, \I10.I_91\, 
        \I10.I_84\, \I10.I_77\, \I10.I_73\, \I10.I_66\, 
        \I10.N_51\, \I10.I_52\, \I10.I_38\, \I10.I_24\, 
        \I5.sstate_ns_i_0l5r\, \I5.sstate_nsl5r\, 
        \I2.un7_ronly_0_a2_0_a2_net_1\, \I2.N_3055\, 
        \I2.un14_tcnt3_net_1\, AE_PDL_cl47r, AE_PDL_cl46r, 
        AE_PDL_cl44r, AE_PDL_cl43r, AE_PDL_cl42r, AE_PDL_cl41r, 
        AE_PDL_cl40r, AE_PDL_cl39r, AE_PDL_cl38r, AE_PDL_cl36r, 
        AE_PDL_cl35r, AE_PDL_cl34r, AE_PDL_cl33r, AE_PDL_cl32r, 
        AE_PDL_cl31r, AE_PDL_cl29r, AE_PDL_cl28r, AE_PDL_cl27r, 
        AE_PDL_cl26r, AE_PDL_cl25r, AE_PDL_cl24r, AE_PDL_cl23r, 
        AE_PDL_cl21r, AE_PDL_cl20r, AE_PDL_cl19r, AE_PDL_cl18r, 
        AE_PDL_cl17r, AE_PDL_cl16r, AE_PDL_cl15r, AE_PDL_cl14r, 
        AE_PDL_cl11r, AE_PDL_cl10r, AE_PDL_cl9r, AE_PDL_cl8r, 
        AE_PDL_cl7r, AE_PDL_cl6r, AE_PDL_cl5r, AE_PDL_cl4r, 
        AE_PDL_cl3r, AE_PDL_cl2r, AE_PDL_cl1r, 
        \I10.FID_8_iv_0_0_0_0_il16r_adt_net_22749_\, 
        \I10.N_251_adt_net_30085_\, 
        \I10.N_2189_i_0_adt_net_30812_\, 
        \I10.DWACT_ADD_CI_0_g_array_1_1l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_12_5l0r\, \I10.STATE1_nsl8r\, 
        \I10.STATE1_nsl7r\, \I10.PDL_RADDR_229_net_1\, 
        \I10.PDL_RADDR_228_net_1\, \I10.PDL_RADDR_227_net_1\, 
        \I10.PDL_RADDR_226_net_1\, \I10.PDL_RADDR_225_net_1\, 
        \I10.PDL_RADDR_224_net_1\, 
        \I10.un2_i2c_chain_0_0_0_0_3l3r_net_1\, \I10.N_251\, 
        \I10.un2_i2c_chain_0_i_0_6_il5r\, \I10.N_2189_i_0\, 
        \I10.N_2349\, \I10.EVNT_NUM_3l3r\, \I10.EVNT_NUM_3l2r\, 
        \I10.EVNT_NUM_3l1r\, \I10.I_122\, \I10.I_115\, \I10.I_56\, 
        \I2.un8_d32_0_a2_net_1\, \I2.N_3056\, \I10.N_2635_i_1\, 
        \I10.DWACT_ADD_CI_0_g_array_2_1l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_11_0l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_12_1_0l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_12_2l0r\, \I10.N_248\, 
        \I10.un2_i2c_chain_0_i_0_7_il5r\, \I10.EVNT_NUM_3l4r\, 
        \I10.EVNT_NUM_3l6r\, \I10.EVNT_NUM_3l5r\, 
        \I10.EVNT_NUM_3l7r\, \I2.N_3154_i\, \I2.N_3006_2\, 
        \I10.DWACT_ADD_CI_0_g_array_3l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_11_1l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_12_3l0r\, 
        \I10.DWACT_ADD_CI_0_g_array_12_4l0r\, \I10.N_591_i_0\, 
        \I10.DWACT_ADD_CI_0_pog_array_1_1_0l0r\, 
        \I10.DWACT_ADD_CI_0_pog_array_2l0r\, \I10.EVNT_NUM_3l11r\, 
        \I10.EVNT_NUM_3l10r\, \I10.EVNT_NUM_3l8r\, 
        \I10.EVNT_NUM_3l9r\, \I2.un110_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un102_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un94_reg_ads_0_a2_0_a2_net_1\, \I2.N_3006_4\, 
        \I2.un37_reg_ads_0_a2_0_a2_net_1\, \I2.N_3013_1\, 
        \I2.N_3057\, \I2.un2_reg_ads_0_a2_net_1\, 
        \I2.un756_regmap_12_i_adt_net_36217_\, 
        \I2.un106_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un90_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un84_reg_ads_0_a2_0_a2_net_1\, \I2.N_3070\, 
        \I2.N_3013_3\, \I2.N_2875_1\, \I2.N_3060\, 
        \I2.VDBi_59_0l9r\, \I2.VDBi_24_sl1r_net_1\, 
        \I2.VDBi_61_sl0r_net_1\, 
        \I2.un122_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un113_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un98_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un87_reg_ads_0_a2_0_a2_net_1\, \I2.N_3002_1\, 
        \I2.un61_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un46_reg_ads_0_a2_0_a2_net_1\, \I2.N_3003_1\, 
        \I2.N_3001_1\, \I2.N_2987_1\, 
        \I2.un17_reg_ads_0_a2_0_a2_net_1\, \I2.N_3000_1\, 
        \I2.un119_reg_ads_0_a2_net_1\, 
        \I2.un116_reg_ads_0_a2_net_1\, \I2.N_2995_1\, 
        \I2.VDBi_61_sl2r_net_1\, \I2.un756_regmap_4_net_1\, 
        \I2.N_1965\, \I2.un756_regmap_11_0_i_adt_net_36347_\, 
        \I2.un81_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un78_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un74_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un70_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un67_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un64_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un57_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un54_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un50_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un43_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un40_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un33_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un29_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un25_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un21_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un13_reg_ads_0_a2_0_a2_net_1\, 
        \I2.un10_reg_ads_0_a2_net_1\, \I2.N_1729\, 
        \I2.VDBi_67_sl8r_net_1\, \I2.un756_regmap_6_i\, 
        \I2.un756_regmap_8_0_i\, \I2.VDBi_67_sl0r_net_1\, 
        \I2.VDBi_24_sl0r_net_1\, \I2.VDBi_9_sqmuxa_i_1_net_1\, 
        \I2.VDBi_9_sqmuxa_i_0_net_1\, 
        \I2.un756_regmap_22_0_net_1\, 
        \I2.un756_regmap_19_adt_net_36245_\, 
        \I2.un756_regmap_17_i_adt_net_36523_\, 
        \I2.VDBi_17l15r_adt_net_42484_\, 
        \I2.VDBi_24l1r_adt_net_90940_\, \I2.un756_regmap_10_i\, 
        \I2.un756_regmap_11_0_i\, \I2.un756_regmap_19_net_1\, 
        \I2.VDBi_70_sl0r_net_1\, \I2.VDBi_9_sqmuxa_1_net_1\, 
        \I2.un756_regmap_22_net_1\, \I2.VDBi_9_sqmuxa_0_net_1\, 
        \I2.un756_regmap_17_i\, \I2.un756_regmap_18_net_1\, 
        \I2.un756_regmap_23_net_1\, \I2.VDBi_70_s_0l0r_net_1\, 
        \I2.VDBi_67l1r_adt_net_94342_\, \I2.un756_regmap_24_i\, 
        \I2.un756_regmap_25_i\, \I2.un756_regmap_net_1\, 
        \I2.N_1783\, \I2.STATE5l2r_net_1\, 
        \I2.STATE5_nsl1r_net_1\, \NLBLAST_c\, \NLBRD_c\, 
        \I2.LB_i_7l5r_Rd1__net_1\, \I2.LB_i_7l6r_Rd1__net_1\, 
        \I2.LB_i_7l7r_Rd1__net_1\, \I2.STATE5l4r_net_1\, 
        \I2.un1_STATE5_9_1\, \I2.STATE5_nsl2r\, 
        \I2.nLBRD_82_net_1\, \NLBAS_c\, \I2.LB_nOE_net_1\, 
        \I2.nLBLAST_3_net_1\, \I2.LB_il0r\, \I2.LB_il1r\, 
        \I2.LB_il2r\, \I2.LB_il3r\, \I2.LB_il4r\, \I2.LB_il5r\, 
        \I2.LB_il6r\, \I2.LB_il7r\, \I2.LB_il8r\, \I2.LB_il9r\, 
        \I2.LB_il10r\, \I2.LB_il11r\, \I2.LB_il12r\, 
        \I2.LB_il13r\, \I2.LB_il14r\, \I2.LB_il15r\, 
        \I2.LB_il16r\, \I2.LB_il17r\, \I2.LB_il18r\, 
        \I2.LB_il19r\, \I2.LB_il20r\, \I2.LB_il21r\, 
        \I2.LB_il22r\, \I2.LB_il23r\, \I2.LB_il24r\, 
        \I2.LB_il25r\, \I2.LB_il26r\, \I2.LB_il27r\, 
        \I2.LB_il28r\, \I2.LB_il29r\, \I2.LB_il30r\, 
        \I2.LB_il31r\, \I2.LB_il31r_Rd1__net_1\, 
        \I2.LB_i_7l31r_Rd1__net_1\, \I2.LB_il30r_Rd1__net_1\, 
        \I2.LB_i_7l30r_Rd1__net_1\, \I2.LB_il29r_Rd1__net_1\, 
        \I2.LB_i_7l29r_Rd1__net_1\, \I2.LB_il28r_Rd1__net_1\, 
        \I2.LB_i_7l28r_Rd1__net_1\, \I2.LB_il27r_Rd1__net_1\, 
        \I2.LB_i_7l27r_Rd1__net_1\, \I2.LB_il26r_Rd1__net_1\, 
        \I2.LB_i_7l26r_Rd1__net_1\, \I2.LB_il25r_Rd1__net_1\, 
        \I2.LB_i_7l25r_Rd1__net_1\, \I2.LB_il24r_Rd1__net_1\, 
        \I2.LB_i_7l24r_Rd1__net_1\, \I2.LB_il23r_Rd1__net_1\, 
        \I2.LB_i_7l23r_Rd1__net_1\, \I2.LB_il22r_Rd1__net_1\, 
        \I2.LB_i_7l22r_Rd1__net_1\, \I2.LB_il21r_Rd1__net_1\, 
        \I2.LB_i_7l21r_Rd1__net_1\, \I2.LB_il20r_Rd1__net_1\, 
        \I2.LB_i_7l20r_Rd1__net_1\, \I2.LB_il19r_Rd1__net_1\, 
        \I2.LB_i_7l19r_Rd1__net_1\, \I2.LB_il18r_Rd1__net_1\, 
        \I2.LB_i_7l18r_Rd1__net_1\, \I2.LB_il17r_Rd1__net_1\, 
        \I2.LB_i_7l17r_Rd1__net_1\, \I2.LB_il16r_Rd1__net_1\, 
        \I2.LB_i_7l16r_Rd1__net_1\, \I2.LB_il15r_Rd1__net_1\, 
        \I2.LB_i_7l15r_Rd1__net_1\, \I2.LB_il14r_Rd1__net_1\, 
        \I2.LB_i_7l14r_Rd1__net_1\, \I2.LB_il13r_Rd1__net_1\, 
        \I2.LB_i_7l13r_Rd1__net_1\, \I2.LB_il12r_Rd1__net_1\, 
        \I2.LB_i_7l12r_Rd1__net_1\, \I2.LB_il11r_Rd1__net_1\, 
        \I2.LB_i_7l11r_Rd1__net_1\, \I2.LB_il10r_Rd1__net_1\, 
        \I2.LB_i_7l10r_Rd1__net_1\, \I2.LB_il9r_Rd1__net_1\, 
        \I2.LB_i_7l9r_Rd1__net_1\, \I2.LB_il8r_Rd1__net_1\, 
        \I2.LB_i_7l8r_Rd1__net_1\, \I2.LB_il7r_Rd1__net_1\, 
        \I2.LB_il6r_Rd1__net_1\, \I2.LB_il5r_Rd1__net_1\, 
        \I2.LB_il4r_Rd1__net_1\, \I2.LB_il3r_Rd1__net_1\, 
        \I2.LB_il2r_Rd1__net_1\, \I2.LB_il1r_Rd1__net_1\, 
        \I2.LB_il0r_Rd1__net_1\, \I2.LB_i_7l0r_net_1\, 
        \I2.LB_i_7l1r_net_1\, \I2.LB_i_7l2r_net_1\, 
        \I2.LB_i_7l3r_net_1\, \I2.LB_i_7l4r_net_1\, 
        \I2.LB_nOE_1_net_1\, \I2.nLBAS_81_net_1\, 
        \I2.LB_i_7l5r_net_1\, \I2.LB_i_7l6r_net_1\, 
        \I2.LB_i_7l7r_net_1\, \I2.STATE5_ns_i_il0r_net_1\, 
        \I2.STATE5l3r_adt_net_116444_Rd1__net_1\, \I2.N_2388\, 
        \I2.LB_nOE_i_0_1\, 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, 
        \I2.STATE5l1r_net_1\, \I2.N_2386_1\, \I2.LB_sl31r\, 
        \I2.LB_sl30r\, \I2.LB_sl29r\, \I2.LB_sl28r\, 
        \I2.LB_sl27r\, \I2.LB_sl26r\, \I2.LB_sl25r\, 
        \I2.LB_sl24r\, \I2.LB_sl23r\, \I2.LB_sl22r\, 
        \I2.LB_sl21r\, \I2.LB_sl20r\, \I2.LB_sl19r\, 
        \I2.LB_sl18r\, \I2.LB_sl17r\, \I2.LB_sl16r\, 
        \I2.LB_sl15r\, \I2.LB_sl14r\, \I2.LB_sl13r\, 
        \I2.LB_sl12r\, \I2.LB_sl11r\, \I2.LB_sl10r\, \I2.LB_sl9r\, 
        \I2.LB_sl8r\, \I2.LB_sl7r\, \I2.LB_sl6r\, \I2.LB_sl5r\, 
        \I2.LB_sl4r\, \I2.LB_sl3r\, \I2.LB_sl2r\, \I2.LB_sl1r\, 
        \I2.LB_sl0r\, \I2.LB_sl31r_Rd1__net_1\, 
        \I2.N_3016_Rd1__net_1\, 
        \I2.N_3021_1_adt_net_116344_Rd1__net_1\, 
        \I2.LB_sl30r_Rd1__net_1\, \I2.N_3015_Rd1__net_1\, 
        \I2.LB_sl29r_Rd1__net_1\, \I2.N_3014_Rd1__net_1\, 
        \I2.LB_sl28r_Rd1__net_1\, \I2.N_3037_Rd1__net_1\, 
        \I2.LB_sl27r_Rd1__net_1\, \I2.N_3036_Rd1__net_1\, 
        \I2.LB_sl26r_Rd1__net_1\, \I2.N_3035_Rd1__net_1\, 
        \I2.N_3021_1_adt_net_116348_Rd1__net_1\, 
        \I2.LB_sl25r_Rd1__net_1\, \I2.N_3034_Rd1__net_1\, 
        \I2.LB_sl24r_Rd1__net_1\, \I2.N_3033_Rd1__net_1\, 
        \I2.LB_sl23r_Rd1__net_1\, \I2.N_3032_Rd1__net_1\, 
        \I2.LB_sl22r_Rd1__net_1\, \I2.N_3031_Rd1__net_1\, 
        \I2.LB_sl21r_Rd1__net_1\, \I2.N_3030_Rd1__net_1\, 
        \I2.LB_sl20r_Rd1__net_1\, \I2.N_3029_Rd1__net_1\, 
        \I2.N_3021_1_adt_net_116352_Rd1__net_1\, 
        \I2.LB_sl19r_Rd1__net_1\, \I2.N_3028_Rd1__net_1\, 
        \I2.LB_sl18r_Rd1__net_1\, \I2.N_3027_Rd1__net_1\, 
        \I2.LB_sl17r_Rd1__net_1\, \I2.N_3026_Rd1__net_1\, 
        \I2.LB_sl16r_Rd1__net_1\, \I2.N_3025_Rd1__net_1\, 
        \I2.LB_sl15r_Rd1__net_1\, \I2.N_3050_Rd1__net_1\, 
        \I2.LB_sl14r_Rd1__net_1\, \I2.N_3049_Rd1__net_1\, 
        \I2.LB_sl13r_Rd1__net_1\, \I2.N_3048_Rd1__net_1\, 
        \I2.N_3021_1_adt_net_116356_Rd1__net_1\, 
        \I2.LB_sl12r_Rd1__net_1\, \I2.N_3047_Rd1__net_1\, 
        \I2.LB_sl11r_Rd1__net_1\, \I2.N_3046_Rd1__net_1\, 
        \I2.LB_sl10r_Rd1__net_1\, \I2.N_3045_Rd1__net_1\, 
        \I2.LB_sl9r_Rd1__net_1\, \I2.N_3044_Rd1__net_1\, 
        \I2.LB_sl8r_Rd1__net_1\, \I2.N_3043_Rd1__net_1\, 
        \I2.LB_sl7r_Rd1__net_1\, \I2.N_3042_Rd1__net_1\, 
        \I2.LB_sl6r_Rd1__net_1\, \I2.N_3041_Rd1__net_1\, 
        \I2.N_3021_1_adt_net_116360_Rd1__net_1\, 
        \I2.LB_sl5r_Rd1__net_1\, \I2.N_3040_Rd1__net_1\, 
        \I2.LB_sl4r_Rd1__net_1\, \I2.N_3039_Rd1__net_1\, 
        \I2.LB_sl3r_Rd1__net_1\, \I2.N_3038_Rd1__net_1\, 
        \I2.LB_sl2r_Rd1__net_1\, \I2.N_3024_Rd1__net_1\, 
        \I2.LB_sl1r_Rd1__net_1\, \I2.N_3023_Rd1__net_1\, 
        \I2.LB_sl0r_Rd1__net_1\, \I2.N_3022_Rd1__net_1\, 
        \I2.un1_STATE5_9_1_Rd1__net_1\, \I1.SDAnoe_del2_net_1\, 
        \I10.READ_OR_FLAG_net_1\, \I10.EVNT_NUMl11r_net_1\, 
        \I10.EVNT_NUMl10r_net_1\, \I10.EVNT_NUMl9r_net_1\, 
        \I10.EVNT_NUMl8r_net_1\, \I10.EVNT_NUMl7r_net_1\, 
        \I10.EVNT_NUMl6r_net_1\, \I10.EVNT_NUMl5r_net_1\, 
        \I10.EVNT_NUMl4r_net_1\, \I10.EVNT_NUMl3r_net_1\, 
        \I10.EVNT_NUMl1r_net_1\, \I10.STATE2l0r_net_1\, 
        \I10.L2RF2_net_1\, \I10.L2AF2_net_1\, \I10.L1AF2_net_1\, 
        \I2.CYCS1_net_1\, \I2.TCNT3_i_0_il4r_net_1\, 
        \I2.TCNT3l5r_net_1\, \I2.TCNT3_i_0_il6r_net_1\, 
        \I2.TCNT3l7r_net_1\, \I2.TCNT3_i_0_il0r_net_1\, 
        \I2.TCNT3l1r_net_1\, \I2.TCNT3_i_0_il2r_net_1\, 
        \I2.TCNT3l3r_net_1\, \I2.TCNT2_i_0_il4r_net_1\, 
        \I2.TCNT2l5r_net_1\, \I2.TCNT2_i_0_il6r_net_1\, 
        \I2.TCNT2l7r_net_1\, \I2.TCNT2_i_0_il0r_net_1\, 
        \I2.TCNT2l1r_net_1\, \I2.TCNT2_i_0_il2r_net_1\, 
        \I2.TCNT2l3r_net_1\, \I2.TCNT1l5r_net_1\, 
        \I2.TCNT1_i_0_il1r_net_1\, \I2.TCNT1_i_0_il4r_net_1\, 
        \I2.TCNT1l3r_net_1\, \I2.TCNT1_i_0_il2r_net_1\, 
        \I2.TCNT1l0r_net_1\, \I2.TICKl1r_net_1\, 
        \I2.TCNT_i_il0r_net_1\, \I2.TCNTl4r_net_1\, 
        \I2.TCNT_i_il1r_net_1\, 
        \I2.STATE5l4r_adt_net_116400_Rd1__net_1\, 
        \I2.STATE5l2r_adt_net_116440_Rd1__net_1\, 
        \I10.L2RF3_net_1\, \I10.L2AF3_net_1\, \I10.L1AF3_net_1\, 
        \I2.TCNT_i_il3r_net_1\, \I2.REGMAPl27r_net_1\, 
        \I2.REGMAP_i_il26r_net_1\, \I2.TCNTl2r_net_1\, 
        \I10.EVNT_NUMl0r_net_1\, \I2.REGMAPl21r_net_1\, 
        \I2.REGMAPl22r_net_1\, CLEAR_0_0_18, HWRES_C_2_0_19, 
        \I5.DRIVECS_20\, NOEAD_C_0_0_21, MD_PDL_C_22, 
        TST_C_CL3R_23, MD_PDL_C_24, \I2.REGL441R_25\, 
        \I2.REGL442R_26\, \I2.REGL443R_27\, \I2.REGL444R_28\, 
        \I2.REGL445R_29\, \I2.REGL446R_30\, \I2.REGL447R_31\, 
        \I2.REGL448R_32\, \I2.REGL265R_33\, \I2.REGL266R_34\, 
        \I2.REGL267R_35\, \I2.REGL268R_36\, \I2.REGL269R_37\, 
        \I2.REGL270R_38\, \I2.REGL271R_39\, \I2.REGL272R_40\, 
        \I2.REGL273R_41\, \I2.REGL274R_42\, \I2.REGL275R_43\, 
        \I2.REGL276R_44\, \I2.REGL277R_45\, \I2.REGL278R_46\, 
        \I2.REGL279R_47\, \I2.REGL280R_48\, \I2.REGL281R_49\, 
        \I2.REGL282R_50\, \I2.REGL283R_51\, \I2.REGL284R_52\, 
        \I2.REGL285R_53\, \I2.REGL286R_54\, \I2.REGL287R_55\, 
        \I2.REGL288R_56\, \I2.REGL289R_57\, \I2.REGL290R_58\, 
        \I2.REGL291R_59\, \I2.REGL292R_60\, \I2.REGL293R_61\, 
        \I2.REGL294R_62\, \I2.REGL295R_63\, \I2.REGL296R_64\, 
        \I2.LB_NOE_65\, \I2.STATE5L4R_ADT_NET_116400_RD1__66\, 
        \I2.STATE5L4R_ADT_NET_116400_RD1__67\, 
        \I2.STATE5L4R_ADT_NET_116400_RD1__68\, 
        \I2.STATE5L4R_ADT_NET_116400_RD1__69\, 
        \I2.STATE5L4R_ADT_NET_116400_RD1__70\, \I2.STATE5L2R_71\, 
        \I2.STATE5L2R_72\, \I2.STATE5L2R_73\, \I2.STATE5L2R_74\, 
        \I2.STATE5L2R_75\, \I2.UN1_STATE5_9_1_RD1__76\, 
        \I2.UN1_STATE5_9_1_RD1__77\, \I2.UN1_STATE5_9_1_RD1__78\, 
        \I2.UN1_STATE5_9_1_RD1__79\, \I2.UN1_STATE5_9_1_RD1__80\, 
        \I2.UN1_STATE5_9_1_RD1__81\, \I2.UN1_STATE5_9_1_RD1__82\, 
        \I2.UN1_STATE5_9_1_RD1__83\, \I2.UN1_STATE5_9_1_RD1__84\, 
        \I2.UN1_STATE5_9_1_RD1__85\, \I2.UN1_STATE5_9_1_RD1__86\, 
        \I2.UN1_STATE5_9_1_RD1__87\, \I2.UN1_STATE5_9_1_RD1__88\, 
        \I2.UN1_STATE5_9_1_RD1__89\, \I2.UN1_STATE5_9_1_RD1__90\, 
        \I2.UN1_STATE5_9_1_91\, \I2.UN1_STATE5_9_1_92\, 
        \I2.UN1_STATE5_9_0_1_I_93\, \I2.STATE5_NS_I_IL0R_94\, 
        \I2.STATE5_NS_I_IL0R_95\, \I2.N_2389_96\, \I2.N_2389_97\, 
        \I2.STATE5L3R_98\, \I2.N_2386_1_99\, 
        \I2.STATE5L1R_RD1__100\, 
        \I2.STATE5L4R_ADT_NET_116396_RD1__101\, 
        \I2.N_2385_ADT_NET_38045__102\, 
        \I2.STATE5_NS_I_I_A2_0_0L0R_103\, \I2.STATE5L1R_104\, 
        \I2.STATE5L1R_105\, \I2.STATE5_NSL2R_106\, 
        \I2.STATE5_NSL2R_107\, 
        \I2.STATE5L3R_ADT_NET_116444_RD1__108\, 
        \I2.STATE5L3R_ADT_NET_116444_RD1__109\, 
        \I2.STATE5L1R_RD1__110\, \I2.STATE5L0R_111\, 
        \I2.STATE5L1R_RD1__112\, \I2.STATE5L1R_RD1__113\, 
        \I2.STATE5L1R_114\, 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119373__net_1\, 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119377__net_1\, 
        \I2.LB_NOE_1_SQMUXA_115\, \I2.LB_NOE_1_SQMUXA_116\, 
        \I2.STATE5L2R_117\, \I2.STATE5L2R_118\ : std_logic;

begin 


    \I2.UN6_TCNT1_464\ : NOR3
      port map(A => \I2.TCNT1l0r_net_1\, B => 
        \I2.TCNT1_i_0_il2r_net_1\, C => \I2.TCNT1l3r_net_1\, Y
         => \I2.un6_tcnt1_adt_net_79937_\);
    
    \I2.REG_1_412\ : MUX2H
      port map(A => VDB_inl23r, B => \I2.REGl497r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_412_net_1\);
    
    \I2.un1_TCNT_1_I_27\ : OR2
      port map(A => 
        \I2.DWACT_ADD_CI_0_g_array_2_1l0r_adt_net_79444_\, B => 
        \I2.DWACT_ADD_CI_0_g_array_1_1_0l0r\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_2_1l0r\);
    
    \I2.MYBERRi_48\ : MUX2L
      port map(A => TST_cl2r, B => MYBERR_c, S => 
        \I2.un1_MYBERRi_1_sqmuxa\, Y => \I2.MYBERRi_48_net_1\);
    
    \I2.REG_1l400r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_315_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl400r);
    
    SYNC_padl12r : OB33PH
      port map(PAD => SYNC(12), A => REG_cl245r);
    
    \I2.VDBi_24_dl2r\ : MUX2H
      port map(A => REGl50r, B => \I2.REGl476r\, S => 
        \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24_dl2r_net_1\);
    
    \I2.REG_1_221\ : MUX2L
      port map(A => VDB_inl9r, B => REGl258r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_221_net_1\);
    
    \I2.REG_1l484r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_399_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl484r\);
    
    \I5.SBYTE_10\ : MUX2H
      port map(A => FBOUTl4r, B => \I5.SBYTE_5l4r_net_1\, S => 
        \I5.un1_sstate_12\, Y => \I5.SBYTE_10_net_1\);
    
    \I2.REG_1l246r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_209_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl246r);
    
    \I2.PIPEA1_9_il24r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl24r, Y => \I2.N_2545\);
    
    \I8.SWORD_12\ : MUX2H
      port map(A => \I8.SWORDl11r_net_1\, B => 
        \I8.SWORD_5l11r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_12_net_1\);
    
    \I2.REG_1l257r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_220_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl257r);
    
    \I10.CRC32_3_0_a2_i_0l6r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2344_i_i_0\, Y => \I10.N_1726\);
    
    \I5.sstate_nsl0r\ : OR2FT
      port map(A => \I5.N_220_i\, B => 
        \I5.sstate_nsl0r_adt_net_33840_\, Y => 
        \I5.sstate_nsl0r_net_1\);
    
    \I2.WDOG_3_I_17\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_12_3l0r\, B => 
        \I2.WDOGl3r_net_1\, Y => \I2.WDOG_3l3r\);
    
    \I2.LB_i_7l18r\ : AND2
      port map(A => VDB_inl18r, B => \I2.STATE5L2R_74\, Y => 
        \I2.LB_i_7l18r_net_1\);
    
    \I10.EVENT_DWORD_18_rl10r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l10r_net_1\, B => 
        \I10.EVENT_DWORD_18l10r_adt_net_27492_\, Y => 
        \I10.EVENT_DWORD_18l10r\);
    
    \I5.UN1_REG_1_120\ : AND2
      port map(A => REGl473r, B => \I5.DRIVE_RELOAD_net_1\, Y => 
        \un1_reg_1_adt_net_2497_\);
    
    \I10.un6_bnc_res_NE_10\ : OR2
      port map(A => \I10.un6_bnc_res_4_i_i\, B => 
        \I10.un6_bnc_res_6_i_i\, Y => \I10.un6_bnc_res_NE_10_i\);
    
    \I1.SBYTE_9_il7r\ : MUX2L
      port map(A => \I1.COMMANDl15r_net_1\, B => 
        \I1.SBYTEl6r_net_1\, S => \I1.N_625_0\, Y => \I1.N_610\);
    
    DIR_CTTM_padl5r : OB33PH
      port map(PAD => DIR_CTTM(5), A => \VCC\);
    
    \I2.REG3l8r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_115_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl8r);
    
    \I10.EVENT_DWORD_18_i_0_0_0l23r\ : OAI21TTF
      port map(A => I2C_RDATAl3r, B => \I10.N_2639\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l23r_adt_net_25838_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l23r_net_1\);
    
    \I2.VDBi_86_iv_1l3r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl3r\, C
         => \I2.VDBi_86_iv_1_il3r_adt_net_52367_\, Y => 
        \I2.VDBi_86_iv_1_il3r\);
    
    \I10.STATE1_ns_0_0l4r\ : NAND3FTT
      port map(A => \I10.STATE1l9r_net_1\, B => \I10.N_2384\, C
         => \I10.N_2383\, Y => \I10.STATE1_nsl4r\);
    
    \I2.REG_1_327\ : MUX2L
      port map(A => REGl412r, B => VDB_inl19r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_327_net_1\);
    
    \I2.VDBml10r\ : MUX2L
      port map(A => \I2.VDBil10r_net_1\, B => \I2.N_2051\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml10r_net_1\);
    
    \I2.REG_1l475r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_390_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl475r\);
    
    \I2.PIPEAl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_556_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl12r_net_1\);
    
    \I10.FID_8_rl8r\ : AND2FT
      port map(A => \I10.FID_8_iv_0_0_0_0l8r_net_1\, B => 
        \I10.FID_8l8r_adt_net_23782_\, Y => \I10.FID_8l8r\);
    
    \I2.VDBi_86_iv_0l0r\ : AO21TTF
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.VDBi_82l0r_net_1\, C => \I2.VDBi_85_ml0r_net_1\, Y
         => \I2.VDBi_86_iv_0_il0r\);
    
    \I2.VASl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_89_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl7r_net_1\);
    
    \I2.REG_1_211_e_0\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAP_i_il23r\, Y => \I2.N_3207_i_0\);
    
    \I2.REG_1l179r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_169_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl179r);
    
    \I10.FID_182\ : MUX2L
      port map(A => \I10.FID_8l17r\, B => \I10.FIDl17r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_182_net_1\);
    
    \I2.REG_1_383\ : MUX2H
      port map(A => VDB_inl11r, B => REGl468r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_383_net_1\);
    
    \I2.REG_1_352\ : MUX2H
      port map(A => VDB_inl12r, B => \I2.REGl437r\, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_352_net_1\);
    
    \I3.un16_ae_31_1\ : AND2FT
      port map(A => REGl127r, B => REGl122r, Y => 
        \I3.un16_ae_1l31r\);
    
    \I10.FID_8_iv_0_0_0_1l19r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl19r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il19r_adt_net_22257_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il19r\);
    
    \I2.LB_i_490\ : MUX2L
      port map(A => \I2.LB_il12r_Rd1__net_1\, B => 
        \I2.LB_i_7l12r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__85\, Y => \I2.LB_il12r\);
    
    \I2.VDBi_67_0l4r\ : MUX2L
      port map(A => REGl429r, B => \I2.REGL445R_29\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1953\);
    
    \I2.REG_1_416\ : MUX2H
      port map(A => VDB_inl27r, B => \I2.REGl501r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_416_net_1\);
    
    \I2.PIPEB_4_il2r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl2r, Y => \I2.N_2573\);
    
    \I2.VDBi_19l19r\ : AND2
      port map(A => TST_cl5r, B => REGl67r, Y => 
        \I2.VDBi_19l19r_net_1\);
    
    \I5.SBYTEl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.SBYTE_7_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => FBOUTl1r);
    
    AE_PDL_padl38r : OB33PH
      port map(PAD => AE_PDL(38), A => AE_PDL_cl38r);
    
    \I8.SWORD_5l6r\ : MUX2L
      port map(A => REGl255r, B => \I8.SWORDl5r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l6r_net_1\);
    
    \I2.REG_1l259r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_222_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl259r);
    
    \I3.AEl24r\ : MUX2L
      port map(A => REGl177r, B => \I3.un16_ael24r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl24r);
    
    \I5.un1_RESCNT_I_74\ : AND2
      port map(A => \I5.RESCNTl2r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_1l0r\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_12l0r\);
    
    \I3.AEl35r\ : MUX2L
      port map(A => REGl188r, B => \I3.un16_ael35r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl35r);
    
    \I1.sstatese_12_i_0\ : MUX2H
      port map(A => \I1.sstatel0r_net_1\, B => 
        \I1.sstatel1r_net_1\, S => TICKl0r, Y => 
        \I1.sstatese_12_i_0_net_1\);
    
    \I3.un16_ae_32\ : NOR2
      port map(A => \I3.un16_ae_1l40r\, B => \I3.un16_ae_1l39r\, 
        Y => \I3.un16_ael32r\);
    
    VDB_padl29r : IOB33PH
      port map(PAD => VDB(29), A => \I2.VDBml29r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl29r);
    
    NLBRD_c : DFFS
      port map(CLK => ALICLK_c, D => \I2.nLBRD_82_net_1\, SET => 
        HWRES_c_2_0, Q => \NLBRD_c\);
    
    \I2.REG3l9r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_116_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl9r\);
    
    \I2.REG1_0_sqmuxa_1_0_a2_0\ : AND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAP_i_il1r\, Y => \I2.REG1_0_sqmuxa_1_0\);
    
    \I2.PIPEA_8_RL31R_422\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l31r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l31r_adt_net_55425_\);
    
    \I2.VDBi_1_sqmuxa_2_i_a3\ : OR2FT
      port map(A => \I2.REGMAPl35r_net_1\, B => 
        \I2.NLBRDY_s_net_1\, Y => \I2.N_1782\);
    
    \I2.VADml13r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl13r_net_1\, Y
         => \I2.VADml13r_net_1\);
    
    \I2.REG_1l277r_61\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_240_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL277R_45\);
    
    \I3.SBYTEl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.SBYTE_9_0\, CLR => 
        HWRES_c_2_0, Q => REGl143r);
    
    \I10.CRC32_90\ : MUX2H
      port map(A => \I10.CRC32l3r_net_1\, B => \I10.N_1346\, S
         => \I10.N_2351\, Y => \I10.CRC32_90_net_1\);
    
    \I2.nLBLAST_3\ : AO21FTT
      port map(A => \I2.N_3021_1\, B => \I2.N_2388\, C => 
        \I2.nLBLAST_3_adt_net_79232_\, Y => \I2.nLBLAST_3_net_1\);
    
    \I5.RELOAD_1\ : OR2FT
      port map(A => \I5.N_211_0\, B => 
        \I5.RELOAD_1_adt_net_34760_\, Y => \I5.RELOAD_1_net_1\);
    
    \I5.G_3\ : AOI21FTF
      port map(A => \I5.G_1_4\, B => \I5.sstate_nsl5r\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l15r\);
    
    \I2.VDBi_56l28r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l28r_net_1\, Y => \I2.VDBi_56l28r_net_1\);
    
    \I2.un84_reg_ads_0_a2_0_a2_1\ : NOR2FT
      port map(A => \I2.N_3006_2\, B => \I2.N_3006_1\, Y => 
        \I2.N_3006_4\);
    
    \I2.PIPEA1_513\ : MUX2L
      port map(A => \I2.PIPEA1l2r_net_1\, B => \I2.N_2501\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_513_net_1\);
    
    \I10.FID_8_0_iv_0_0_0_0l1r\ : AO21
      port map(A => \I10.STATE1L1R_14\, B => 
        \I10.EVENT_DWORDl1r_net_1\, C => 
        \I10.FID_8_0_iv_0_0_0_0_il1r_adt_net_24586_\, Y => 
        \I10.FID_8_0_iv_0_0_0_0_il1r\);
    
    \I2.NRDMEBi\ : DFFS
      port map(CLK => CLKOUT, D => \I2.NRDMEBi_543_net_1\, SET
         => CLEAR_0_0, Q => NRDMEB);
    
    \I2.PIPEA1l16r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_527_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l16r_net_1\);
    
    \I2.REG_1_ml159r\ : NAND2
      port map(A => REGl159r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml159r_net_1\);
    
    AMB_padl0r : IB33
      port map(PAD => AMB(0), Y => AMB_cl0r);
    
    \I2.VDBI_24L1R_467\ : MUX2L
      port map(A => REGl33r, B => \I2.VDBi_5l1r_net_1\, S => 
        \I2.REGMAPl6r_net_1\, Y => \I2.VDBi_24l1r_adt_net_91078_\);
    
    \I2.REG_1_354\ : MUX2H
      port map(A => VDB_inl14r, B => \I2.REGl439r\, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_354_net_1\);
    
    \I2.REG_1l422r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_337_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl422r);
    
    \I2.VDBi_86_0_iv_0l22r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l22r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il22r_adt_net_41033_\, Y => 
        \I2.VDBi_86_0_iv_0_il22r\);
    
    \I2.TCNT2_2_I_27\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_11l0r\, B => 
        \I2.TCNT2_i_0_il6r_net_1\, Y => \I2.TCNT2_2l6r\);
    
    \I3.un16_ae_34\ : NOR2
      port map(A => \I3.un16_ae_1l42r\, B => \I3.un16_ae_1l39r\, 
        Y => \I3.un16_ael34r\);
    
    \I2.REG_1_323\ : MUX2L
      port map(A => REGl408r, B => VDB_inl15r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_323_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l30r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl30r_net_1\, B => 
        \I10.CRC32l30r_net_1\, Y => \I10.N_2338_i_i_0\);
    
    \I2.UN1_STATE5_9_1_RD1__491\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_91\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__76\);
    
    \I2.VDBI_86_0_IV_0L31R_313\ : AND2
      port map(A => \I2.VDBil31r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il31r_adt_net_39188_\);
    
    VDB_padl30r : IOB33PH
      port map(PAD => VDB(30), A => \I2.VDBml30r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl30r);
    
    VDB_padl15r : IOB33PH
      port map(PAD => VDB(15), A => \I2.VDBml15r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl15r);
    
    \I5.un2_hwres_2\ : OR2
      port map(A => HWRES_C_2_0_19, B => PULSEl0r, Y => 
        \I5.un2_hwres_2_net_1\);
    
    \I2.STATE5l4r\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_NS_I_IL0R_94\, 
        SET => HWRES_c_2_0, Q => \I2.STATE5l4r_net_1\);
    
    F_SO_pad : IB33
      port map(PAD => F_SO, Y => F_SO_c);
    
    NOE16R_pad : OB33PH
      port map(PAD => NOE16R, A => \I2.N_2768_i_0\);
    
    \I2.VDBI_17_0L6R_382\ : AOI21
      port map(A => REGl6r, B => \I2.REGMAP_i_il1r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1903_adt_net_49481_\);
    
    \I2.REG_1_163\ : MUX2L
      port map(A => REGl173r, B => VDB_inl4r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_163_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L7R_260\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl15r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l7r_adt_net_27873_\);
    
    \I2.TCNTl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.TCNT_10l2r_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.TCNTl2r_net_1\);
    
    \I2.LB_i_7l28r\ : AND2
      port map(A => VDB_inl28r, B => \I2.STATE5L2R_72\, Y => 
        \I2.LB_i_7l28r_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L19R_236\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl27r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l19r_adt_net_26454_\);
    
    \I2.STATE1_ns_0_0l1r\ : OR2
      port map(A => \I2.STATE1_ns_0_0_0_il1r\, B => 
        \I2.STATE1_nsl1r_adt_net_38698_\, Y => \I2.STATE1_nsl1r\);
    
    \I10.CRC32l6r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_93_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l6r_net_1\);
    
    \I5.un1_BITCNT_I_1\ : AND2
      port map(A => \I5.BITCNTl0r_net_1\, B => 
        \I5.un1_sstate_13_i_a2_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_TMP_0l0r\);
    
    \I2.REG_1l438r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_353_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl438r\);
    
    \I2.PULSE_1l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_1_99_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => PULSEl0r);
    
    \I3.un16_ae_8\ : NOR2
      port map(A => \I3.un16_ae_1l14r\, B => \I3.un16_ae_1l1r\, Y
         => \I3.un16_ael8r\);
    
    \I2.VDBi_86_iv_1l1r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl1r\, C
         => \I2.VDBi_86_iv_1_il1r_adt_net_54111_\, Y => 
        \I2.VDBi_86_iv_1_il1r\);
    
    \I2.VDBi_588\ : MUX2L
      port map(A => \I2.VDBil12r_net_1\, B => \I2.VDBi_86l12r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_588_net_1\);
    
    \I2.N_3034_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3034\, SET => 
        HWRES_c_2_0, Q => \I2.N_3034_Rd1__net_1\);
    
    \I2.REG_1_438\ : MUX2H
      port map(A => VDB_inl17r, B => REGl65r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_438_net_1\);
    
    \I2.PIPEA1_9_il15r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl15r, Y => \I2.N_2527\);
    
    LB_padl10r : IOB33PH
      port map(PAD => LB(10), A => \I2.LB_il10r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl10r);
    
    \I8.SWORD_0_sqmuxa_0_a2\ : OR2FT
      port map(A => \I8.sstate_d_0l3r\, B => \I8.N_228\, Y => 
        \I8.SWORD_0_sqmuxa\);
    
    \I10.FIDl25r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_190_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl25r_net_1\);
    
    \I1.DATAl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12_ivl1r\, CLR => 
        HWRES_c_2_0, Q => REGl106r);
    
    \I2.VDBi_86_iv_2l10r\ : AOI21TTF
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl10r\, C
         => \I2.VDBi_86_iv_1l10r_net_1\, Y => 
        \I2.VDBi_86_iv_2l10r_net_1\);
    
    \I2.PIPEA1l10r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_521_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l10r_net_1\);
    
    \I2.N_3048_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3048\, SET => 
        HWRES_c_2_0, Q => \I2.N_3048_Rd1__net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_o3_0_0l7r\ : AND2
      port map(A => \I10.N_2642_0\, B => \I10.N_2639\, Y => 
        \I10.N_2276_i_0\);
    
    \I10.BNCRES_CNTl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNCRES_CNT_4l1r\, CLR => 
        CLEAR_0_0, Q => \I10.BNCRES_CNTl1r_net_1\);
    
    \I3.un16_ae_6_2\ : OR2
      port map(A => \I3.un16_ae_2l47r\, B => \I3.un16_ae_1l15r\, 
        Y => \I3.un16_ae_2l7r\);
    
    \I5.sstate_ns_a2_0l0r\ : NAND3FFT
      port map(A => PULSEl10r, B => \I5.sstatel1r_net_1\, C => 
        \I5.sstate_ns_a2_0_2l0r_net_1\, Y => \I5.N_220_i\);
    
    \I3.un16_ae_36_1\ : OR2
      port map(A => \I3.un16_ae_1l46r\, B => \I3.un16_ae_1l45r\, 
        Y => \I3.un16_ae_1l44r\);
    
    \I5.RESCNT_6_rl8r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_63\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l8r\);
    
    \I1.DATAl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12l13r_net_1\, CLR
         => HWRES_c_2_0, Q => REGl118r);
    
    \I10.STATE2l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE2_nsl2r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE2l0r_net_1\);
    
    \I2.LB_i_7l22r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l22r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l22r_Rd1__net_1\);
    
    \I2.REG_1l465r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_380_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REGl465r);
    
    \I2.VDBi_86_iv_1l15r\ : AOI21TTF
      port map(A => \I2.PIPEAl15r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_iv_0l15r_net_1\, Y => 
        \I2.VDBi_86_iv_1l15r_net_1\);
    
    \I2.LB_i_7l6r\ : MUX2L
      port map(A => VDB_inl6r, B => \I2.VASl6r_net_1\, S => 
        \I2.STATE5L1R_105\, Y => \I2.N_1893\);
    
    \I2.REG_1l426r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_341_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl426r);
    
    \I2.PIPEA1_539\ : MUX2L
      port map(A => \I2.PIPEA1l28r_net_1\, B => \I2.N_2870\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_539_net_1\);
    
    \I10.WRB\ : DFFS
      port map(CLK => CLKOUT, D => \I10.WRB_123_net_1\, SET => 
        CLEAR_0_0, Q => \I10.WRB_net_1\);
    
    \I2.STATE1_ns_a3_0l3r\ : NAND2FT
      port map(A => TST_CL2R_16, B => \I2.STATE1l6r_net_1\, Y => 
        \I2.N_1762\);
    
    \I10.BNC_CNTl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_204_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl6r_net_1\);
    
    \I2.STATE2l3r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.STATE2_il4r_net_1\, SET
         => CLEAR_0_0, Q => \I2.STATE2_i_0l3r\);
    
    \I2.REG_1l169r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_159_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl169r);
    
    \I10.EVENT_DWORD_151\ : MUX2H
      port map(A => \I10.EVENT_DWORDl18r_net_1\, B => 
        \I10.EVENT_DWORD_18l18r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_151_net_1\);
    
    \I2.VDBI_17L2R_407\ : OA21TTF
      port map(A => \I2.N_1899_adt_net_52770_\, B => 
        \I2.N_1899_adt_net_52772_\, C => \I2.REGMAPl2r_net_1\, Y
         => \I2.N_1917_adt_net_52814_\);
    
    \I2.LB_i_505\ : MUX2L
      port map(A => \I2.LB_il27r_Rd1__net_1\, B => 
        \I2.LB_i_7l27r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__77\, Y => \I2.LB_il27r\);
    
    \I3.un16_ae_47_3\ : NAND2
      port map(A => REGl125r, B => REGl127r, Y => 
        \I3.un16_ae_3l47r\);
    
    \I10.CHIP_ADDR_127\ : MUX2L
      port map(A => CHIP_ADDRl0r, B => \I10.N_246\, S => 
        \I10.N_1595\, Y => \I10.CHIP_ADDR_127_net_1\);
    
    \I2.N_2980_i\ : NAND2
      port map(A => \I2.WDOGl0r_net_1\, B => \I2.N_2886_1\, Y => 
        \I2.N_2980_i_net_1\);
    
    \I2.un25_reg_ads_0_a2_0_a2\ : AND2
      port map(A => \I2.N_3008_1\, B => \I2.N_2987_1\, Y => 
        \I2.un25_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.REG_1l86r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_459_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl86r);
    
    \I2.REG_1l489r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_404_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl489r\);
    
    \I2.REG_1l448r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_363_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl448r\);
    
    \I10.un2_i2c_chain_0_0_0_0_x3l6r\ : XOR2FT
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTl0r_net_1\, 
        Y => \I10.N_2283_i_i_0\);
    
    \I5.un1_RESCNT_I_87\ : AND2
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_1_1l0r\, B => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r_adt_net_33510_\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_11l0r\);
    
    \I2.LB_i_7l28r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l28r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l28r_Rd1__net_1\);
    
    \I10.EVENT_DWORD_18_rl12r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l12r_net_1\, B => 
        \I10.EVENT_DWORD_18l12r_adt_net_27268_\, Y => 
        \I10.EVENT_DWORD_18l12r\);
    
    SI_PDL_pad : OB33PH
      port map(PAD => SI_PDL, A => SI_PDL_c);
    
    \I2.VDBi_54_0_iv_5l8r\ : AO21TTF
      port map(A => REGL129R_1, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_3l8r_net_1\, Y => 
        \I2.VDBi_54_0_iv_5_il8r\);
    
    \I2.STATE5L3R_ADT_NET_116444_RD1__511\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl1r_net_1\, CLR
         => HWRES_c_2_0, Q => 
        \I2.STATE5L3R_ADT_NET_116444_RD1__109\);
    
    \I2.un1_vsel_5_i_a2_1\ : NOR3FFT
      port map(A => TST_cl4r, B => AMB_cl3r, C => AMB_cl4r, Y => 
        \I2.N_2892_1\);
    
    SYNC_padl6r : OB33PH
      port map(PAD => SYNC(6), A => SYNC_cl6r);
    
    \I2.REG_1_248\ : MUX2L
      port map(A => \I2.REGL285R_53\, B => VDB_inl20r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_248_net_1\);
    
    \I10.FID_196\ : MUX2L
      port map(A => \I10.FID_8l31r\, B => \I10.FIDl31r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_196_net_1\);
    
    RSELB0_pad : OTB33PH
      port map(PAD => RSELB0, A => REGl430r, EN => REG_i_0l446r);
    
    \I10.un2_i2c_chain_0_0_0_0_o3_0l3r\ : NOR2FT
      port map(A => \I10.CNTl4r_net_1\, B => \I10.CNTl1r_net_1\, 
        Y => \I10.N_2279\);
    
    \I5.BITCNT_6_rl0r\ : OA21FTT
      port map(A => \I5.ISI_0_sqmuxa\, B => 
        \I5.DWACT_ADD_CI_0_partial_sum_0l0r\, C => \I5.N_212\, Y
         => \I5.BITCNT_6l0r\);
    
    \I10.PDL_RADDR_227\ : MUX2H
      port map(A => \I10.CNTl3r_net_1\, B => 
        \I10.PDL_RADDRl3r_net_1\, S => \I10.PDL_RADDR_1_sqmuxa\, 
        Y => \I10.PDL_RADDR_227_net_1\);
    
    \I2.VDBi_17_0l6r\ : AND2
      port map(A => REG_i_0l38r, B => \I2.REGMAPl6r_net_1\, Y => 
        \I2.N_1903_adt_net_49479_\);
    
    \I2.VDBi_54_0_iv_2l7r\ : AOI21TTF
      port map(A => REGl176r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml160r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l7r_net_1\);
    
    \I2.un1_noe64ri_0_a2_0_0_37\ : NOR2FT
      port map(A => \I2.MBLTCYC_net_1\, B => \I2.ADACKCYC_net_1\, 
        Y => NOEAD_C_0_0_21);
    
    \I10.BNC_CNT_198\ : MUX2H
      port map(A => \I10.BNC_CNTl0r_net_1\, B => 
        \I10.BNC_CNT_4l0r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_198_net_1\);
    
    \I2.REG_1l501r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_416_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl501r\);
    
    \I2.TCNT3_2_I_35\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_TMP_0l0r\, B => 
        \I2.TCNT3l1r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_1_0l0r\);
    
    \I10.un3_bnc_cnt_I_31\ : XOR2
      port map(A => \I10.BNC_CNTl6r_net_1\, B => 
        \I10.DWACT_FINC_El28r_adt_net_18856_\, Y => \I10.I_31\);
    
    \I10.un1_STATE1_15_0_0_0_0_o2\ : OR2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.STATE1L2R_13\, Y => \I10.N_2288\);
    
    \I1.COMMAND_6\ : MUX2H
      port map(A => \I1.COMMANDl10r_net_1\, B => 
        \I1.COMMAND_4l10r_net_1\, S => \I1.SSTATEL13R_8\, Y => 
        \I1.COMMAND_6_net_1\);
    
    \I10.GEN_ACLK_PLL_PLL_aclk_del.Core\ : PLLCORE
      port map(SDOUT => OPEN, SCLK => \GND\, SDIN => \GND\, 
        SSHIFT => \GND\, SUPDATE => \GND\, GLB => ACLKOUT, CLK
         => ALICLK_c, GLA => OPEN, CLKA => \GND\, LOCK => 
        \I10.PLL_LOCK_aclk\, MODE => \GND\, FBDIV5 => \GND\, 
        EXTFB => \GND\, FBSEL0 => \VCC\, FBSEL1 => \GND\, FINDIV0
         => \GND\, FINDIV1 => \GND\, FINDIV2 => \GND\, FINDIV3
         => \GND\, FINDIV4 => \GND\, FBDIV0 => \GND\, FBDIV1 => 
        \GND\, FBDIV2 => \GND\, FBDIV3 => \GND\, FBDIV4 => \GND\, 
        STATBSEL => \GND\, DLYB0 => \GND\, DLYB1 => \GND\, OBDIV0
         => \GND\, OBDIV1 => \GND\, STATASEL => \GND\, DLYA0 => 
        \GND\, DLYA1 => \GND\, OADIV0 => \GND\, OADIV1 => \GND\, 
        OAMUX0 => \GND\, OAMUX1 => \GND\, OBMUX0 => \GND\, OBMUX1
         => \GND\, OBMUX2 => \VCC\, FBDLY0 => \GND\, FBDLY1 => 
        \GND\, FBDLY2 => \GND\, FBDLY3 => \GND\, XDLYSEL => \GND\);
    
    \I10.EVENT_DWORD_135\ : MUX2H
      port map(A => \I10.EVENT_DWORDl2r_net_1\, B => 
        \I10.EVENT_DWORD_18l2r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_135_net_1\);
    
    SP_PDL_padl42r : IOB33PH
      port map(PAD => SP_PDL(42), A => REGl129r, EN => MD_PDL_C_0, 
        Y => SP_PDL_inl42r);
    
    \I2.PIPEA_8_RL19R_434\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l19r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l19r_adt_net_56307_\);
    
    \I10.CRC32_109\ : MUX2H
      port map(A => \I10.CRC32l22r_net_1\, B => \I10.N_1468\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_109_net_1\);
    
    \I2.REG_1_377\ : MUX2H
      port map(A => VDB_inl5r, B => REGl462r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_377_net_1\);
    
    \I8.sstate_ns_i_a2_0l0r\ : AND2FT
      port map(A => \I8.sstatel1r_net_1\, B => \I8.N_228\, Y => 
        \I8.N_209\);
    
    \I3.SBYTE_4\ : MUX2L
      port map(A => REGl138r, B => \I3.SBYTE_5l1r_net_1\, S => 
        \I3.N_167\, Y => \I3.SBYTE_4_net_1\);
    
    \I10.CHANNEL_126\ : MUX2L
      port map(A => CHANNELl2r, B => \I10.N_251\, S => 
        \I10.N_1595\, Y => \I10.CHANNEL_126_net_1\);
    
    \I2.REG_1l272r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_235_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl272r\);
    
    \I2.PIPEB_4_il22r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl22r, Y => \I2.N_2613\);
    
    \I2.WDOGRES_98\ : OR3FTT
      port map(A => \I2.N_2885\, B => 
        \I2.WDOGRES_98_adt_net_75433_\, C => 
        \I2.un1_WDOGRES_0_sqmuxa_adt_net_75393_\, Y => 
        \I2.WDOGRES_98_net_1\);
    
    \I2.REG_1l254r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_217_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl254r);
    
    \I2.REG_1l128r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_130_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl128r\);
    
    \I1.DATA_12l10r\ : MUX2H
      port map(A => \I1.SBYTEl2r_net_1\, B => REGl115r, S => 
        \I1.DATA_1_sqmuxa_2\, Y => \I1.DATA_12l10r_net_1\);
    
    \I10.CRC32_3_i_0_0l11r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2325_i_i_0\, Y => \I10.N_1354\);
    
    \I2.VDBI_61L6R_385\ : AND2FT
      port map(A => \I2.VDBi_61_sl0r_net_1\, B => 
        \I2.VDBi_61_dl6r_net_1\, Y => 
        \I2.VDBi_61l6r_adt_net_49874_\);
    
    \I2.REG_1_403\ : MUX2H
      port map(A => VDB_inl14r, B => \I2.REGl488r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_403_net_1\);
    
    AE_PDL_padl23r : OB33PH
      port map(PAD => AE_PDL(23), A => AE_PDL_cl23r);
    
    LB_pad_i_1l31r : INV
      port map(A => \I2.LB_nOE_net_1\, Y => \I2.LB_nOE_i_0_1\);
    
    \I2.un2_reg_ads_0_a2\ : AND2
      port map(A => \I2.N_3006_2\, B => 
        \I2.un2_reg_ads_0_a2_adt_net_37970_\, Y => 
        \I2.un2_reg_ads_0_a2_net_1\);
    
    \I10.EVENT_DWORDl28r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_161_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl28r_net_1\);
    
    VAD_padl17r : OTB33PH
      port map(PAD => VAD(17), A => \I2.VADml17r_net_1\, EN => 
        NOEAD_c_0_0);
    
    LB_padl29r : IOB33PH
      port map(PAD => LB(29), A => \I2.LB_il29r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl29r);
    
    \I2.VDBi_86_iv_2l8r\ : AOI21TTF
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl8r\, C
         => \I2.VDBi_86_iv_1l8r_net_1\, Y => 
        \I2.VDBi_86_iv_2l8r_net_1\);
    
    \I2.STATE5L1R_479\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_106\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5l1r_net_1\);
    
    \I2.PIPEB_4_il19r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl19r, Y => \I2.N_2607\);
    
    \I1.SBYTE_28\ : MUX2H
      port map(A => \I1.SBYTEl0r_net_1\, B => \I1.SBYTE_9l0r\, S
         => \I1.un1_tick_8\, Y => \I1.SBYTE_28_net_1\);
    
    \I2.LB_il13r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il13r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il13r_Rd1__net_1\);
    
    \I10.un2_evread_3_i_0_a2_0_14\ : NOR3
      port map(A => \I10.un2_evread_3_i_0_a2_0_12_i\, B => 
        \I10.un2_evread_3_i_0_a2_0_9_i\, C => 
        \I10.un2_evread_3_i_0_a2_0_10_i\, Y => 
        \I10.un2_evread_3_i_0_a2_0_14_net_1\);
    
    \I5.un1_RESCNT_I_54\ : XOR2
      port map(A => \I5.RESCNTl3r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_12l0r\, Y => \I5.I_54\);
    
    \I3.sstate_s0_0_a3\ : NOR2
      port map(A => \I3.sstatel1r_net_1\, B => 
        \I3.sstatel0r_net_1\, Y => \I3.sstate_dl3r\);
    
    \I3.SO\ : AND2FT
      port map(A => REGl145r, B => \I3.N_255\, Y => \I3.SO_i\);
    
    \I2.REG_1_407\ : MUX2H
      port map(A => VDB_inl18r, B => \I2.REGl492r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_407_net_1\);
    
    \I10.FID_4_0_a2l6r\ : XOR2FT
      port map(A => \I10.CRC32l2r_net_1\, B => 
        \I10.FID_4_0_a2_0l6r_net_1\, Y => \I10.FID_4_il6r\);
    
    \I10.BNC_CNT_4_0_a2l10r\ : AND2
      port map(A => \I10.I_56\, B => \I10.un6_bnc_res_NE_net_1\, 
        Y => \I10.BNC_CNT_4l10r\);
    
    \I1.AIR_COMMAND_21_0_IVL9R_135\ : AND2
      port map(A => \I1.sstate2l9r_net_1\, B => REGl98r, Y => 
        \I1.AIR_COMMAND_21l9r_adt_net_9514_\);
    
    \I2.VDBi_19l5r\ : MUX2L
      port map(A => REGl53r, B => \I2.VDBi_17l5r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l5r_net_1\);
    
    \I2.VADml9r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl9r_net_1\, Y
         => \I2.VADml9r_net_1\);
    
    \I2.un1_STATE5_11_0_0_a2_123\ : AND2
      port map(A => \I2.N_2310_1\, B => 
        \I2.STATE5l3r_adt_net_116444_Rd1__net_1\, Y => 
        \I2.STATE5_NSL2R_107\);
    
    \I2.PIPEBl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_57_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl8r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_1l20r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl28r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l20r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l20r_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_0_a2_2l2r\ : AND2
      port map(A => \I10.N_2280\, B => \I10.N_2294\, Y => 
        \I10.N_2401_i_i\);
    
    VAD_padl6r : IOB33PH
      port map(PAD => VAD(6), A => \I2.VADml6r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl6r);
    
    \I2.LB_i_7l10r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l10r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l10r_Rd1__net_1\);
    
    \I2.REG_1_205\ : MUX2L
      port map(A => SYNC_cl9r, B => VDB_inl9r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_205_net_1\);
    
    \I1.I2C_RDATA_9_il7r\ : MUX2L
      port map(A => I2C_RDATAl7r, B => REGl118r, S => 
        \I1.sstate2_0_sqmuxa_4_0\, Y => \I1.N_588\);
    
    \I10.FIDl23r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_188_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl23r_net_1\);
    
    \I10.BNC_CNTl17r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_215_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl17r_net_1\);
    
    \I10.FID_8_RL11R_197\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl11r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il11r\, Y => 
        \I10.FID_8l11r_adt_net_23398_\);
    
    \I2.VDBml17r\ : MUX2L
      port map(A => \I2.VDBil17r_net_1\, B => \I2.N_2058\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml17r_net_1\);
    
    \I10.FID_8_RL0R_219\ : AO21FTT
      port map(A => GA_cl0r, B => \I10.N_2288\, C => 
        \I10.FID_8_0_iv_0_0_0_0_il0r\, Y => 
        \I10.FID_8l0r_adt_net_24747_\);
    
    \I10.FIDl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_171_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl6r_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l3r\ : XOR2FT
      port map(A => \I10.CRC32l3r_net_1\, B => 
        \I10.EVENT_DWORDl3r_net_1\, Y => \I10.N_2322_i_i_0\);
    
    \I2.REG_1_231\ : MUX2L
      port map(A => \I2.REGL268R_36\, B => VDB_inl3r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_231_net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_4l4r\ : OA21TTF
      port map(A => \I10.N_2377_1\, B => 
        \I10.N_2525_i_adt_net_30597_\, C => \I10.N_2290\, Y => 
        \I10.un2_i2c_chain_0_i_i_i_4_il4r_adt_net_30634_\);
    
    \I2.VDBI_86_0_IVL25R_326\ : AO21
      port map(A => \I2.PIPEAl25r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il25r\, Y => 
        \I2.VDBi_86l25r_adt_net_40457_\);
    
    \I2.REG_1_373\ : MUX2H
      port map(A => VDB_inl1r, B => REGl458r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_373_net_1\);
    
    \I2.REG_1l175r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_165_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl175r);
    
    \I2.PIPEB_64\ : MUX2H
      port map(A => \I2.PIPEBl15r_net_1\, B => \I2.N_2599\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_64_net_1\);
    
    \I10.STATE1_ns_o9_0_a2_0_a2l11r\ : AND2
      port map(A => \I10.RDY_CNTl1r_net_1\, B => 
        \I10.STATE1_nsl11r_adt_net_16793_\, Y => 
        \I10.STATE1_nsl11r\);
    
    \I2.PIPEB_4_il18r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl18r, Y => \I2.N_2605\);
    
    \I2.LB_sl6r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl6r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl6r_Rd1__net_1\);
    
    \I10.EVRDYI_197_159\ : OA21TTF
      port map(A => \I10.FIFO_END_EVNT_net_1\, B => 
        \I10.N_926_adt_net_20509_\, C => EVREAD, Y => 
        \I10.EVRDYi_197_adt_net_20551_\);
    
    \I8.SWORDl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_6_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl5r_net_1\);
    
    \I10.EVENT_DWORD_18_rl5r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0l5r_net_1\, B => 
        \I10.EVENT_DWORD_18l5r_adt_net_28127_\, Y => 
        \I10.EVENT_DWORD_18l5r\);
    
    SYNC_padl3r : OB33PH
      port map(PAD => SYNC(3), A => SYNC_cl3r);
    
    \I2.un1_TCNT_1_I_9\ : XOR2
      port map(A => \I2.N_1885_1\, B => \I2.TCNT_i_il1r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_pog_array_0l0r\);
    
    \I2.VDBI_17_0L14R_349\ : NOR3FFT
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl14r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1911_adt_net_43208_\);
    
    \I2.REG_1_223\ : MUX2L
      port map(A => VDB_inl11r, B => REGl260r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_223_net_1\);
    
    \I2.REG_1l79r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_452_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl79r);
    
    \I2.REG_1_337\ : MUX2L
      port map(A => REGl422r, B => VDB_inl29r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_337_net_1\);
    
    \I2.PULSE_1_102\ : MUX2H
      port map(A => PULSEl3r, B => \I2.PULSE_43l3r\, S => 
        \I2.un1_STATE1_18\, Y => \I2.PULSE_1_102_net_1\);
    
    \I10.L1AF3\ : DFFC
      port map(CLK => ACLKOUT, D => \I10.L1AF2_net_1\, CLR => 
        HWRES_c_2_0, Q => \I10.L1AF3_net_1\);
    
    \I2.VAS_96\ : MUX2L
      port map(A => VAD_inl14r, B => \I2.VASl14r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_96_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_0_2l2r\ : OR3
      port map(A => \I10.N_2401_i_i\, B => 
        \I10.un2_i2c_chain_0_i_0_0_0_il2r\, C => \I10.N_3177_i\, 
        Y => \I10.un2_i2c_chain_0_i_0_0_2_il2r\);
    
    \I2.STATE5L2R_489\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_107\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L2R_74\);
    
    \I10.STATE1_ns_0_0l5r\ : OAI21FTF
      port map(A => \I10.STATE1l8r_net_1\, B => \I10.N_2286\, C
         => \I10.STATE1_ns_0_0_0_il5r\, Y => \I10.STATE1_nsl5r\);
    
    \I2.LB_sl2r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl2r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl2r_Rd1__net_1\);
    
    \I2.REG_1l272r_56\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_235_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL272R_40\);
    
    \I5.UN1_RESCNT_G_1_3_287\ : NOR3FFT
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_2_1l0r\, B => 
        \I5.G_net_1\, C => \I5.G_1_3_3_i_adt_net_33073_\, Y => 
        \I5.G_1_3_adt_net_33101_\);
    
    \I10.I2C_CHAIN\ : DFF
      port map(CLK => CLKOUT, D => \I10.I2C_CHAIN_122_net_1\, Q
         => I2C_CHAIN);
    
    \I10.FID_187\ : MUX2L
      port map(A => \I10.FID_8l22r\, B => \I10.FIDl22r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_187_net_1\);
    
    \I2.REG_1_143\ : MUX2L
      port map(A => REGl153r, B => VDB_inl0r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_143_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l14r\ : AO21
      port map(A => \I10.STATE1l11r_net_1\, B => REGl62r, C => 
        \I10.FID_8_iv_0_0_0_0_il14r_adt_net_22993_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il14r\);
    
    \I2.VDBi_54_0_iv_2l4r\ : AOI21TTF
      port map(A => REGl173r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml157r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l4r_net_1\);
    
    \I10.EVENT_DWORD_18_RL8R_259\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl18r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l8r_adt_net_27753_\);
    
    \I2.REG_1l241r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_204_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl8r);
    
    \I2.LB_s_4_i_a2_0_a2l20r\ : OR2
      port map(A => LB_inl20r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, Y => 
        \I2.N_3029\);
    
    \I5.un1_RESCNT_G_1_5\ : AND2
      port map(A => \I5.RESCNTl0r_net_1\, B => \I5.G_net_1\, Y
         => \I5.DWACT_ADD_CI_0_TMPl0r\);
    
    \I2.LB_i_502\ : MUX2L
      port map(A => \I2.LB_il24r_Rd1__net_1\, B => 
        \I2.LB_i_7l24r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__79\, Y => \I2.LB_il24r\);
    
    \I2.REG_1_161\ : MUX2L
      port map(A => REGl171r, B => VDB_inl2r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_161_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l26r\ : OR2
      port map(A => LB_inl26r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119377__net_1\, 
        Y => \I2.N_3035\);
    
    \I2.PIPEA1_9_il12r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl12r, Y => \I2.N_2521\);
    
    \I1.AIR_COMMAND_21l0r\ : MUX2L
      port map(A => REGl89r, B => \I1.N_486\, S => 
        \I1.sstate2l9r_net_1\, Y => \I1.AIR_COMMAND_21l0r_net_1\);
    
    \I2.un1_STATE5_9_1_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_91\, CLR
         => HWRES_c_2_0, Q => \I2.un1_STATE5_9_1_Rd1__net_1\);
    
    \I10.BNC_CNTl18r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_216_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNT_i_il18r\);
    
    \I2.REG3l10r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_117_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl10r\);
    
    \I2.PIPEA_8_RL18R_435\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l18r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l18r_adt_net_56377_\);
    
    \I2.PIPEA_555\ : MUX2L
      port map(A => \I2.PIPEAl11r_net_1\, B => \I2.PIPEA_8l11r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_555_net_1\);
    
    SP_PDL_padl43r : IOB33PH
      port map(PAD => SP_PDL(43), A => REGl129r, EN => MD_PDL_C_0, 
        Y => SP_PDL_inl43r);
    
    \I3.SBYTE_5l5r\ : MUX2H
      port map(A => REG_cl134r, B => REGl141r, S => 
        \I3.sstatel0r_net_1\, Y => \I3.SBYTE_5l5r_net_1\);
    
    \I10.un1_CNT_1_I_34\ : AND2
      port map(A => \I10.CNTL2R_11\, B => \I10.CNTl3r_net_1\, Y
         => \I10.DWACT_ADD_CI_0_pog_array_1l0r\);
    
    \I2.REG_1_397\ : MUX2H
      port map(A => VDB_inl8r, B => \I2.REGl482r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_397_net_1\);
    
    \I2.REG_1l70r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_443_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl70r);
    
    \I2.REG_1l262r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_225_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl262r);
    
    \I2.REG_1_361\ : MUX2L
      port map(A => \I2.REGL446R_30\, B => VDB_inl5r, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_361_net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_3l4r\ : OR2
      port map(A => 
        \I10.un2_i2c_chain_0_i_i_i_3_il4r_adt_net_30702_\, B => 
        \I10.N_2520_i\, Y => \I10.un2_i2c_chain_0_i_i_i_3_il4r\);
    
    \I2.REG_1_454\ : MUX2H
      port map(A => REGl81r, B => \I2.REG_92l81r_net_1\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_454_net_1\);
    
    \I2.LB_i_7l14r\ : AND2
      port map(A => VDB_inl14r, B => \I2.STATE5L2R_75\, Y => 
        \I2.LB_i_7l14r_net_1\);
    
    \I3.un4_so_7_0\ : MUX2L
      port map(A => SP_PDL_inl20r, B => SP_PDL_inl16r, S => 
        REGl124r, Y => \I3.N_203\);
    
    \I2.REGMAPl3r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un17_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl3r_net_1\);
    
    \I2.LB_i_486\ : MUX2L
      port map(A => \I2.LB_il8r_Rd1__net_1\, B => 
        \I2.LB_i_7l8r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__87\, Y => \I2.LB_il8r\);
    
    \I10.EVNT_NUMl0r\ : DFFC
      port map(CLK => CLKOUT, D => 
        \I10.DWACT_ADD_CI_0_partial_sum_2l0r\, CLR => CLEAR_0_0, 
        Q => \I10.EVNT_NUMl0r_net_1\);
    
    \I2.VDBi_86_0_iv_0l17r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l17r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il17r_adt_net_42086_\, Y => 
        \I2.VDBi_86_0_iv_0_il17r\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L6R_262\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl14r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l6r_adt_net_27985_\);
    
    \I10.EVENT_DWORDl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_141_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl8r_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L14R_246\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl22r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l14r_adt_net_27014_\);
    
    \I2.un1_WDOGRES_0_sqmuxa_0_0_o3\ : NOR2
      port map(A => \I2.N_2829\, B => \I2.SINGCYC_net_1\, Y => 
        \I2.N_2831\);
    
    \I8.SWORD_5l3r\ : MUX2L
      port map(A => REGl252r, B => \I8.SWORDl2r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l3r_net_1\);
    
    \I2.LB_i_7l1r\ : MUX2L
      port map(A => VDB_inl1r, B => \I2.VASl1r_net_1\, S => 
        \I2.STATE5l2r_adt_net_116440_Rd1__net_1\, Y => 
        \I2.N_1888\);
    
    \I10.un3_bnc_cnt_I_45\ : XOR2
      port map(A => \I10.BNC_CNTl8r_net_1\, B => 
        \I10.DWACT_FINC_El4r\, Y => \I10.I_45\);
    
    \I2.LB_il16r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il16r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il16r_Rd1__net_1\);
    
    \I2.VDBi_82l0r\ : MUX2L
      port map(A => \I2.VDBil0r_net_1\, B => FBOUTl0r, S => 
        \I2.N_1721_1\, Y => \I2.VDBi_82l0r_net_1\);
    
    \I10.BNC_CNT_212\ : MUX2H
      port map(A => \I10.BNC_CNT_i_il14r\, B => 
        \I10.BNC_CNT_4l14r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_212_net_1\);
    
    \I2.PIPEAl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_555_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl11r_net_1\);
    
    \I10.CRC32_3_i_0_0l19r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2316_i_i_0\, Y => \I10.N_1039\);
    
    \I1.DATAl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12l14r_net_1\, CLR
         => HWRES_c_2_0, Q => REGl119r);
    
    \I1.sstate2_0_sqmuxa_3_0_a3\ : NAND2
      port map(A => REGl105r, B => \I1.sstate2l4r_net_1\, Y => 
        \I1.sstate2_0_sqmuxa_3\);
    
    \I1.I2C_RDATA_14\ : MUX2L
      port map(A => I2C_RDATAl0r, B => \I1.N_574\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_14_net_1\);
    
    VAD_padl7r : IOB33PH
      port map(PAD => VAD(7), A => \I2.VADml7r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl7r);
    
    \I10.EVENT_DWORDl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_133_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl0r_net_1\);
    
    AE_PDL_padl20r : OB33PH
      port map(PAD => AE_PDL(20), A => AE_PDL_cl20r);
    
    \I10.EVENT_DWORD_18_i_0_0_1l26r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.PDL_RADDRl2r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l26r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l26r_net_1\);
    
    \I10.CRC32_111\ : MUX2H
      port map(A => \I10.CRC32l24r_net_1\, B => \I10.N_1470\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_111_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I51_un1_Y_2\ : NOR3FFT
      port map(A => \I10.N274\, B => \I10.N258\, C => 
        \I10.ADD_16x16_medium_I51_un1_Y_0_i\, Y => 
        \I10.ADD_16x16_medium_I51_un1_Y_2\);
    
    \I2.REG_il296r\ : INV
      port map(A => \I2.REGl296r\, Y => REG_i_0l296r);
    
    \I2.REG_1_180\ : MUX2L
      port map(A => REGl190r, B => VDB_inl5r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_180_net_1\);
    
    AMB_padl1r : IB33
      port map(PAD => AMB(1), Y => AMB_cl1r);
    
    \I3.AEl30r\ : MUX2L
      port map(A => REGl183r, B => \I3.un16_ael30r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl30r);
    
    \I2.REG_1_333\ : MUX2L
      port map(A => REGl418r, B => VDB_inl25r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_333_net_1\);
    
    \I1.COMMAND_4l12r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl12r_net_1\, B => REGl101r, S
         => REGl7r, Y => \I1.COMMAND_4l12r_net_1\);
    
    \I2.REG_1l124r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_126_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl124r);
    
    \I2.VDBI_86_0_IV_0L19R_337\ : AO21
      port map(A => \I2.VDBil19r_net_1\, B => \I2.N_1885_1\, C
         => \I2.N_2898_i\, Y => \I2.VDBi_86l19r_adt_net_41715_\);
    
    \I2.REG_1l444r_44\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_359_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL444R_28\);
    
    \I2.VDBi_54_0_iv_5l13r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il13r\, B => 
        \I2.VDBi_54_0_iv_0_il13r\, C => \I2.VDBi_54_0_iv_1_il13r\, 
        Y => \I2.VDBi_54_0_iv_5_il13r\);
    
    \I3.un4_so_33_0\ : MUX2L
      port map(A => \I3.N_234\, B => \I3.N_223\, S => REGl123r, Y
         => \I3.N_229\);
    
    \I2.VDBi_82l2r\ : MUX2L
      port map(A => \I2.VDBil2r_net_1\, B => FBOUTl2r, S => 
        \I2.N_1721_1\, Y => \I2.VDBi_82l2r_net_1\);
    
    \I2.PIPEBl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_53_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl4r_net_1\);
    
    \I2.un11_tcnt2_4\ : OR3
      port map(A => \I2.TCNT2_i_0_il0r_net_1\, B => 
        \I2.TCNT2l1r_net_1\, C => \I2.un11_tcnt2_2_i\, Y => 
        \I2.un11_tcnt2_4_i\);
    
    \I2.LB_il15r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il15r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il15r_Rd1__net_1\);
    
    SYNC_padl0r : OB33PH
      port map(PAD => SYNC(0), A => SYNC_cl0r);
    
    \I10.STATE1_ns_0_0l9r\ : AO21TTF
      port map(A => \I10.STATE1l7r_net_1\, B => \I10.N_2297\, C
         => \I10.STATE1_ns_0_0_0l9r_net_1\, Y => 
        \I10.STATE1_nsl9r\);
    
    \I10.FID_4_0_a2_0l11r\ : XOR2
      port map(A => \I10.CRC32l19r_net_1\, B => 
        \I10.CRC32l31r_net_1\, Y => \I10.FID_4_0_a2_0l11r_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0L5R_264\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl13r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0l5r_adt_net_28097_\);
    
    \I10.un2_i2c_chain_0_i_i_i_a2_3_1l4r\ : AND2
      port map(A => \I10.CNTl4r_net_1\, B => \I10.CNTl0r_net_1\, 
        Y => \I10.N_2524_1\);
    
    \I2.REG_1l403r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_318_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl403r);
    
    \I8.SWORD_14\ : MUX2H
      port map(A => \I8.SWORDl13r_net_1\, B => 
        \I8.SWORD_5l13r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_14_net_1\);
    
    GND_i : GND
      port map(Y => \GND\);
    
    \I2.REG_1l395r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_310_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl395r);
    
    \I2.REG_1l165r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_155_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl165r);
    
    \I2.VDBi_85_ml7r\ : NAND3
      port map(A => \I2.VDBil7r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml7r_net_1\);
    
    \I3.un16_ae_25\ : NOR2
      port map(A => \I3.un16_ae_2l31r\, B => \I3.un16_ae_1l25r\, 
        Y => \I3.un16_ael25r\);
    
    \I10.EVENT_DWORD_145\ : MUX2H
      port map(A => \I10.EVENT_DWORDl12r_net_1\, B => 
        \I10.EVENT_DWORD_18l12r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_145_net_1\);
    
    \I2.REG_1_319\ : MUX2L
      port map(A => REGl404r, B => VDB_inl11r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_319_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l3r\ : OR2
      port map(A => LB_inl3r, B => 
        \I2.STATE5l4r_adt_net_116400_Rd1__net_1\, Y => 
        \I2.N_3038\);
    
    \I1.SBYTE_9_il2r\ : MUX2H
      port map(A => \I1.SBYTEl1r_net_1\, B => 
        \I1.COMMANDl10r_net_1\, S => \I1.N_625_0\, Y => 
        \I1.N_600\);
    
    \I1.COMMAND_3\ : MUX2H
      port map(A => \I1.COMMANDl2r_net_1\, B => 
        \I1.COMMAND_4l2r_net_1\, S => \I1.SSTATEL13R_8\, Y => 
        \I1.COMMAND_3_net_1\);
    
    \I2.REG_1_393\ : MUX2H
      port map(A => VDB_inl4r, B => \I2.REGl478r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_393_net_1\);
    
    \I2.REG_1l64r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_437_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl64r);
    
    \I10.CRC32_3_0_a2_i_0_x3l1r\ : XOR2FT
      port map(A => \I10.CRC32l1r_net_1\, B => 
        \I10.EVENT_DWORDl1r_net_1\, Y => \I10.N_2341_i_i_0\);
    
    \I2.un1_TCNT_1_I_26\ : OA21
      port map(A => \I2.TCNT_i_il0r_net_1\, B => 
        \I2.TCNT_i_il1r_net_1\, C => \I2.N_1885_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_1_2l0r\);
    
    \I1.sstatel5r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el8r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstatel5r_net_1\);
    
    \I2.un87_reg_ads_0_a2_0_a2_1\ : OR2FT
      port map(A => \I2.VASl5r_net_1\, B => \I2.VASl3r_net_1\, Y
         => \I2.N_3005_1\);
    
    \I2.STATE5_ns_i_il0r_111\ : AOI21FTF
      port map(A => \I2.STATE5_ns_i_i_a2_0_0l0r\, B => 
        \I2.N_2385_adt_net_38045_\, C => \I2.N_2386_1\, Y => 
        \I2.STATE5_NS_I_IL0R_95\);
    
    \I2.REG_1l407r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_322_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl407r);
    
    \I8.sstate_ns_il0r\ : OA21TTF
      port map(A => \I8.sstate_ns_i_a2_0_il0r\, B => 
        \I8.sstate_ns_i_a2_2_il0r\, C => \I8.N_209\, Y => 
        \I8.sstate_ns_il0r_net_1\);
    
    \I2.VASl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_86_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl4r_net_1\);
    
    VAD_padl28r : IOB33PH
      port map(PAD => VAD(28), A => \I2.VADml28r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl28r);
    
    \I5.SBYTE_5l2r\ : MUX2L
      port map(A => REGl83r, B => FBOUTl1r, S => 
        \I5.sstatel5r_net_1\, Y => \I5.SBYTE_5l2r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I63_Y\ : AO21
      port map(A => \I10.un1_REG_1_1l36r\, B => \I10.N279\, C => 
        \I10.N220\, Y => \I10.N328\);
    
    \I2.LB_s_21\ : MUX2L
      port map(A => \I2.LB_sl7r_Rd1__net_1\, B => 
        \I2.N_3042_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116356_Rd1__net_1\, Y => 
        \I2.LB_sl7r\);
    
    LBSP_padl4r : IOB33PH
      port map(PAD => LBSP(4), A => REGl397r, EN => REG_i_0l269r, 
        Y => LBSP_inl4r);
    
    \I2.REG3_111\ : MUX2L
      port map(A => VDB_inl4r, B => \I2.REGl4r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_111_net_1\);
    
    \I2.VDBil21r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_597_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil21r_net_1\);
    
    \I2.PULSE_43_f0l6r\ : NOR3
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.STATE1l6r_net_1\, C => \I2.PULSE_43_f1l6r_net_1\, Y
         => \I2.PULSE_43_f0l6r_net_1\);
    
    \I2.VDBi_19l17r\ : AND2
      port map(A => TST_cl5r, B => REGl65r, Y => 
        \I2.VDBi_19l17r_net_1\);
    
    \I2.LB_sl18r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl18r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl18r_Rd1__net_1\);
    
    \I2.PIPEA_8_rl8r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl8r, C => 
        \I2.PIPEA_8l8r_adt_net_57114_\, Y => \I2.PIPEA_8l8r\);
    
    \I2.UN1_TCNT_1_I_27_463\ : AND3
      port map(A => \I2.DWACT_ADD_CI_0_pog_array_0_1l0r\, B => 
        \I2.DWACT_ADD_CI_0_pog_array_0_2l0r\, C => 
        \I2.DWACT_ADD_CI_0_g_array_1_2l0r\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_2_1l0r_adt_net_79444_\);
    
    \I2.LB_s_4_i_a2_0_a2l17r\ : OR2
      port map(A => LB_inl17r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__68\, Y => \I2.N_3026\);
    
    \I2.VDBi_86_iv_0l9r\ : AOI21TTF
      port map(A => \I2.VDBil9r_net_1\, B => \I2.STATE1l2r_net_1\, 
        C => \I2.VDBi_85_ml9r_net_1\, Y => 
        \I2.VDBi_86_iv_0l9r_net_1\);
    
    \I2.VDBi_59l15r\ : AND2FT
      port map(A => \I2.VDBi_59_0l9r\, B => 
        \I2.VDBi_59l15r_adt_net_42806_\, Y => 
        \I2.VDBi_59l15r_net_1\);
    
    \I1.COMMAND_4l9r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl9r_net_1\, B => REGl98r, S
         => REGL7R_2, Y => \I1.COMMAND_4l9r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l10r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl10r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l10r_adt_net_27462_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l10r_net_1\);
    
    \I10.EVNT_NUM_3_I_32\ : XOR2
      port map(A => \I10.EVNT_NUMl0r_net_1\, B => 
        \I10.STATE1l0r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_partial_sum_2l0r\);
    
    \I10.EVNT_NUMl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l11r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl11r_net_1\);
    
    \I2.STATE1l8r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE1_nsl1r\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.STATE1l8r_net_1\);
    
    \I10.OR_RADDRl1r\ : DFF
      port map(CLK => CLKOUT, D => \I10.OR_RADDR_219_net_1\, Q
         => \I10.OR_RADDRl1r_net_1\);
    
    \I2.VDBi_59l8r\ : MUX2L
      port map(A => BNC_RES, B => \I2.VDBi_56l8r_net_1\, S => 
        \I2.REGMAPl29r_net_1\, Y => \I2.VDBi_59l8r_net_1\);
    
    \I3.un16_ae_26\ : NOR2
      port map(A => \I3.un16_ae_2l31r\, B => \I3.un16_ae_1l26r\, 
        Y => \I3.un16_ael26r\);
    
    \I2.VDBi_86_ivl1r\ : OR3
      port map(A => \I2.VDBi_67_m_il1r\, B => 
        \I2.VDBi_86_iv_0_il1r\, C => \I2.VDBi_86_iv_1_il1r\, Y
         => \I2.VDBi_86l1r\);
    
    \I10.un1_OR_RREQ_1_sqmuxa_0_0\ : OR3FFT
      port map(A => \I10.N_2642_0\, B => \I10.N_2354\, C => 
        \I10.STATE1L12R_10\, Y => \I10.un1_OR_RREQ_1_sqmuxa\);
    
    \I2.LB_i_7l24r\ : AND2
      port map(A => VDB_inl24r, B => \I2.STATE5L2R_73\, Y => 
        \I2.LB_i_7l24r_net_1\);
    
    \I10.BNC_CNT_4_0_a2l0r\ : AND2FT
      port map(A => \I10.BNC_CNTl0r_net_1\, B => 
        \I10.un6_bnc_res_NE_0_net_1\, Y => \I10.BNC_CNT_4l0r\);
    
    \I2.REG_il448r\ : INV
      port map(A => \I2.REGl448r\, Y => REG_i_0l448r);
    
    LB_padl19r : IOB33PH
      port map(PAD => LB(19), A => \I2.LB_il19r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl19r);
    
    \I10.STATE1_0l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl11r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l1r_net_1\);
    
    \I10.BNC_CNT_4_0_a2l6r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_31\, 
        Y => \I10.BNC_CNT_4l6r\);
    
    \I2.un116_reg_ads_0_a2\ : NOR2
      port map(A => \I2.N_3068\, B => \I2.N_2875_1\, Y => 
        \I2.un116_reg_ads_0_a2_net_1\);
    
    \I2.PIPEA1_516\ : MUX2L
      port map(A => \I2.PIPEA1l5r_net_1\, B => \I2.N_2507\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_516_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I64_Y\ : AOI21
      port map(A => \I10.N267\, B => \I10.N215\, C => 
        \I10.N_3032_i\, Y => \I10.N330_i\);
    
    RSELD1_pad : OTB33PH
      port map(PAD => RSELD1, A => REGl425r, EN => REG_i_0l441r);
    
    \I2.REG_1_422\ : MUX2H
      port map(A => VDB_inl1r, B => REGl49r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_422_net_1\);
    
    \I2.REG_1l256r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_219_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl256r);
    
    \I1.sstatel13r\ : DFFS
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el0r\, SET => 
        HWRES_c_2_0, Q => \I1.SSTATEL13R_8\);
    
    \I2.REG_92l87r\ : AND2
      port map(A => \I2.N_1826_0\, B => \I2.N_1990\, Y => 
        \I2.REG_92l87r_net_1\);
    
    \I3.un4_so_26_0\ : MUX2L
      port map(A => SP_PDL_inl41r, B => SP_PDL_inl9r, S => 
        REGl127r, Y => \I3.N_222\);
    
    \I2.VDBi_54_0_iv_3l2r\ : AO21TTF
      port map(A => REGL123R_6, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l2r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il2r\);
    
    \I2.VDBi_17_rl5r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1902_adt_net_50282_\, C => 
        \I2.N_1902_adt_net_50284_\, Y => \I2.VDBi_17l5r\);
    
    P_PDL_padl7r : OB33PH
      port map(PAD => P_PDL(7), A => REG_cl136r);
    
    \I5.RESCNTl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l13r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl13r_net_1\);
    
    SP_PDL_padl7r : IOB33PH
      port map(PAD => SP_PDL(7), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl7r);
    
    \I2.LB_sl22r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl22r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl22r_Rd1__net_1\);
    
    \I10.FID_8_iv_0_0_0_0l7r\ : AO21
      port map(A => \I10.STATE1L11R_12\, B => REGl55r, C => 
        \I10.FID_8_iv_0_0_0_0_il7r_adt_net_23864_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il7r\);
    
    \I10.PDL_RADDRl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.PDL_RADDR_226_net_1\, CLR
         => CLEAR_0_0, Q => \I10.PDL_RADDRl2r_net_1\);
    
    \I2.un21_reg_ads_0_a2_0_a2\ : AND3FTT
      port map(A => \I2.WRITES_net_1\, B => \I2.N_3069\, C => 
        \I2.N_2987_1\, Y => \I2.un21_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.REG_92_il104r\ : MUX2L
      port map(A => VDB_inl15r, B => REGl104r, S => \I2.N_2265\, 
        Y => \I2.N_2225\);
    
    \I2.VDBi_54_0_iv_2l15r\ : AOI21TTF
      port map(A => REGl184r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml168r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l15r_net_1\);
    
    \I2.REG_1l126r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_128_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl126r);
    
    \I2.un29_reg_ads_0_a2_0_a2\ : NOR3
      port map(A => \I2.N_3061\, B => \I2.N_3064\, C => 
        \I2.N_3001_1\, Y => \I2.un29_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.N_3037_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3037\, SET => 
        HWRES_c_2_0, Q => \I2.N_3037_Rd1__net_1\);
    
    \I2.VDBi_24l30r\ : MUX2L
      port map(A => \I2.REGl504r\, B => \I2.VDBi_19l30r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l30r_net_1\);
    
    \I2.VDBi_576\ : MUX2L
      port map(A => \I2.VDBil0r_net_1\, B => \I2.VDBi_86l0r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_576_net_1\);
    
    \I3.BITCNTl1r\ : DFF
      port map(CLK => CLKOUT, D => \I3.un1_BITCNT_1_rl1r_net_1\, 
        Q => \I3.BITCNTl1r_net_1\);
    
    \I2.REG_1_459\ : MUX2H
      port map(A => REGl86r, B => \I2.REG_92l86r_net_1\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_459_net_1\);
    
    \I2.PIPEAl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_549_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl5r_net_1\);
    
    \I10.CHANNEL_125\ : MUX2L
      port map(A => CHANNELl1r, B => \I10.N_591_i_0\, S => 
        \I10.N_1595\, Y => \I10.CHANNEL_125_net_1\);
    
    \I10.FID_170\ : MUX2L
      port map(A => \I10.FID_8l5r\, B => \I10.FIDl5r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_170_net_1\);
    
    \I3.AEl29r\ : MUX2L
      port map(A => REGl182r, B => \I3.un16_ael29r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl29r);
    
    \I10.un3_bnc_cnt_I_69\ : AND2
      port map(A => \I10.BNC_CNTl11r_net_1\, B => 
        \I10.DWACT_FINC_El7r_adt_net_18884_\, Y => 
        \I10.DWACT_FINC_El7r\);
    
    \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119377_\ : BFR
      port map(A => \I2.STATE5L4R_ADT_NET_116396_RD1__101\, Y => 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119377__net_1\);
    
    \I1.sstate2l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2se_7_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstate2l1r_net_1\);
    
    \I2.VDBI_61L5R_391\ : AND2FT
      port map(A => \I2.VDBi_61_sl0r_net_1\, B => 
        \I2.VDBi_61_dl5r_net_1\, Y => 
        \I2.VDBi_61l5r_adt_net_50677_\);
    
    \I10.un3_bnc_cnt_I_16\ : AND2
      port map(A => \I10.BNC_CNTl2r_net_1\, B => 
        \I10.DWACT_FINC_El0r_adt_net_18772_\, Y => 
        \I10.DWACT_FINC_El0r\);
    
    \I2.STATE5l1r_116\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5l1r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L1R_RD1__100\);
    
    \I2.VDBi_17_0l15r\ : AND2
      port map(A => REGl47r, B => \I2.REGMAPl6r_net_1\, Y => 
        \I2.N_1912_adt_net_42452_\);
    
    \I2.REG_1_426\ : MUX2H
      port map(A => VDB_inl5r, B => REGl53r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_426_net_1\);
    
    \I2.REG_1_188\ : MUX2L
      port map(A => REGl198r, B => VDB_inl13r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_188_net_1\);
    
    \I2.VDBi_17_rl13r\ : OA21
      port map(A => \I2.N_1910_adt_net_43960_\, B => 
        \I2.N_1910_adt_net_43962_\, C => 
        \I2.VDBi_17l15r_adt_net_42484_\, Y => \I2.VDBi_17l13r\);
    
    \I2.REG_1_341\ : MUX2L
      port map(A => REGl426r, B => VDB_inl1r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_341_net_1\);
    
    \I2.N_3039_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3039\, SET => 
        HWRES_c_2_0, Q => \I2.N_3039_Rd1__net_1\);
    
    \I2.PIPEA_8_SL29R_424\ : MUX2H
      port map(A => DPRl29r, B => \I2.PIPEA1l29r_net_1\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEA_8l29r_adt_net_55591_\);
    
    \I2.PIPEA_8_rl11r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl11r, C => 
        \I2.PIPEA_8l11r_adt_net_56867_\, Y => \I2.PIPEA_8l11r\);
    
    \I2.LB_s_33\ : MUX2L
      port map(A => \I2.LB_sl19r_Rd1__net_1\, B => 
        \I2.N_3028_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116352_Rd1__net_1\, Y => 
        \I2.LB_sl19r\);
    
    \I2.LB_nOE_1\ : OAI21FTT
      port map(A => \I2.LB_NOE_65\, B => \I2.N_2271\, C => 
        \I2.LB_nOE_1_sqmuxa\, Y => \I2.LB_nOE_1_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I67_Y\ : XOR2FT
      port map(A => \I10.N330_i\, B => 
        \I10.ADD_16x16_medium_I67_Y_0\, Y => 
        \I10.ADD_16x16_medium_I67_Y\);
    
    \I2.PIPEB_4_il17r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl17r, Y => \I2.N_2603\);
    
    SP_PDL_padl38r : IOB33PH
      port map(PAD => SP_PDL(38), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl38r);
    
    \I10.BNC_NUMBER_234\ : MUX2L
      port map(A => \I10.BNCRES_CNTl4r_net_1\, B => 
        \I10.BNC_NUMBERl4r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_234_net_1\);
    
    \I10.CRC32_3_i_0_x3l15r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl15r_net_1\, B => 
        \I10.CRC32l15r_net_1\, Y => \I10.N_2339_i_i_0\);
    
    \I10.EVNT_NUM_3_I_59\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_11_1l0r\, B => 
        \I10.EVNT_NUMl10r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_12_4l0r\);
    
    \I0.BNC_RESi_1\ : NOR2FT
      port map(A => BNCRES_c, B => \I0.BNC_RES1_net_1\, Y => 
        \I0.BNC_RESi_1_net_1\);
    
    \I8.BITCNT_6_rl0r\ : OA21
      port map(A => \I8.N_219\, B => 
        \I8.DWACT_ADD_CI_0_partial_suml0r\, C => 
        \I8.SWORD_0_sqmuxa\, Y => \I8.BITCNT_6l0r\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l16r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl16r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l16r_adt_net_26790_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l16r_net_1\);
    
    \I2.PIPEB_4_il24r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl24r, Y => \I2.N_2617\);
    
    \I2.REG_1_460\ : MUX2H
      port map(A => REGl87r, B => \I2.REG_92l87r_net_1\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_460_net_1\);
    
    \I2.REG_1_339_e_1\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl30r_net_1\, Y => \I2.N_3463_i_1\);
    
    \I2.REG_1l270r_54\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_233_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL270R_38\);
    
    \I10.FID_8_IV_0_0_0_1L22R_174\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl70r, Y => 
        \I10.FID_8_iv_0_0_0_1_il22r_adt_net_21765_\);
    
    \I2.REGMAPl27r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un98_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl27r_net_1\);
    
    \I10.BNC_CNT_4_0_a2l9r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_52\, 
        Y => \I10.BNC_CNT_4l9r\);
    
    \I2.PIPEBl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_59_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl10r_net_1\);
    
    \I2.N_3044_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3044\, SET => 
        HWRES_c_2_0, Q => \I2.N_3044_Rd1__net_1\);
    
    \I10.CRC32l11r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_98_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l11r_net_1\);
    
    \I2.PIPEB_63\ : MUX2H
      port map(A => \I2.PIPEBl14r_net_1\, B => \I2.N_2597\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_63_net_1\);
    
    \I5.RESCNT_6_rl5r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_57\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l5r\);
    
    \I2.VDBi_9_sqmuxa_0\ : AND3
      port map(A => \I2.VDBi_9_sqmuxa_i_1_net_1\, B => 
        \I2.un756_regmap_22_net_1\, C => 
        \I2.VDBi_9_sqmuxa_1_net_1\, Y => 
        \I2.VDBi_9_sqmuxa_0_net_1\);
    
    \I10.FID_8_iv_0_0_0_1l27r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl27r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il27r_adt_net_20945_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il27r\);
    
    \I5.un1_RESCNT_G_1_3\ : NOR3FFT
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_2l0r\, B => 
        \I5.G_1_3_adt_net_33101_\, C => 
        \I5.G_1_3_4_i_adt_net_33036_\, Y => \I5.G_1_3\);
    
    \I2.VDBi_54_0_iv_3l9r\ : AO21TTF
      port map(A => REG_cl130r, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l9r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il9r\);
    
    \I2.REG_1l56r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_429_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl56r);
    
    \I2.REG_1l233r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_196_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl0r);
    
    \I2.PIPEBl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_49_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl0r_net_1\);
    
    \I10.CRC32_97\ : MUX2H
      port map(A => \I10.CRC32l10r_net_1\, B => \I10.N_1352\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_97_net_1\);
    
    SP_PDL_padl37r : IOB33PH
      port map(PAD => SP_PDL(37), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl37r);
    
    \I2.REG_1_233\ : MUX2L
      port map(A => \I2.REGL270R_38\, B => VDB_inl5r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_233_net_1\);
    
    \I10.FID_8_rl28r\ : AND2FT
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.FID_8l28r_adt_net_20862_\, Y => \I10.FID_8l28r\);
    
    \I5.un1_BITCNT_I_13\ : XOR2
      port map(A => \I5.DWACT_ADD_CI_0_TMP_0l0r\, B => 
        \I5.BITCNTl1r_net_1\, Y => \I5.I_13_1\);
    
    \I5.sstate_0_sqmuxa_1_0_a2_5\ : AND2
      port map(A => \I5.RESCNTl5r_net_1\, B => 
        \I5.RESCNTl6r_net_1\, Y => 
        \I5.sstate_0_sqmuxa_1_0_a2_5_net_1\);
    
    \I10.L1AS\ : AND2FT
      port map(A => \I10.L1AF3_net_1\, B => \I10.L1AF2_net_1\, Y
         => REGl381r);
    
    \I2.TICKil0r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un6_tcnt1_net_1\, Q => 
        TICKl0r);
    
    \I2.REG_92l81r\ : AND2
      port map(A => \I2.N_1826_0\, B => \I2.N_1984\, Y => 
        \I2.REG_92l81r_net_1\);
    
    \I8.SWORDl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_10_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl9r_net_1\);
    
    \I2.PIPEB_4_il5r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl5r, Y => \I2.N_2579\);
    
    TST_padl10r : OB33PH
      port map(PAD => TST(10), A => \GND\);
    
    \I3.un16_ae_19_1\ : NAND2FT
      port map(A => \I3.un16_ae_1l43r\, B => \I3.un16_ae_1l31r\, 
        Y => \I3.un16_ae_1l27r\);
    
    \I10.CYC_STAT_0_2_0_a3\ : NOR2FT
      port map(A => PSM_SP3_c, B => \I10.CLEAR_PSM_FLAGS_net_1\, 
        Y => \I10.CYC_STAT_0_2\);
    
    \I2.REG_1_128\ : MUX2H
      port map(A => REGL126R_4, B => VDB_inl5r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_128_net_1\);
    
    \I10.un1_CNT_1_G_1_1\ : XOR2FT
      port map(A => \I10.CNTl5r_net_1\, B => \I10.G_1_0_net_1\, Y
         => \I10.un1_CNT_1_il6r\);
    
    \I10.FID_8_RL3R_213\ : AO21FTT
      port map(A => GA_cl3r, B => \I10.N_2288\, C => 
        \I10.FID_8_0_iv_0_0_0_0_il3r\, Y => 
        \I10.FID_8l3r_adt_net_24381_\);
    
    \I2.VDBi_606\ : MUX2L
      port map(A => \I2.VDBil30r_net_1\, B => \I2.VDBi_86l30r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_606_net_1\);
    
    \I3.SBYTE_9\ : MUX2L
      port map(A => REGl143r, B => \I3.SBYTE_5l6r_net_1\, S => 
        \I3.N_167\, Y => \I3.SBYTE_9_0\);
    
    \I2.PIPEA_8_rl15r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl15r, C => 
        \I2.PIPEA_8l15r_adt_net_56587_\, Y => \I2.PIPEA_8l15r\);
    
    \I2.VDBi_86_iv_1l14r\ : AOI21TTF
      port map(A => \I2.PIPEAl14r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_iv_0l14r_net_1\, Y => 
        \I2.VDBi_86_iv_1l14r_net_1\);
    
    \I1.sstatel3r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstatese_9_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstate_i_0_il3r\);
    
    \I2.REG_1l243r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_206_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl243r);
    
    \I2.VDBi_86_iv_1l5r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl5r\, C
         => \I2.VDBi_86_iv_1_il5r_adt_net_50761_\, Y => 
        \I2.VDBi_86_iv_1_il5r\);
    
    \I10.un2_evread_3_i_0_a2_0_10\ : NAND3FFT
      port map(A => \I10.REGl40r\, B => \I10.REGl41r\, C => 
        \I10.un2_evread_3_i_0_a2_0_4_net_1\, Y => 
        \I10.un2_evread_3_i_0_a2_0_10_i\);
    
    \I10.STATE1_ns_0l8r\ : NAND2
      port map(A => \I10.N_2390\, B => \I10.N_2354\, Y => 
        \I10.STATE1_nsl8r\);
    
    \I1.SDAout_11_s\ : OR3
      port map(A => \I1.N_408\, B => \I1.N_524\, C => 
        \I1.un1_sstate_12_0_0_net_1\, Y => \I1.SDAout_11\);
    
    \I10.EVENT_DWORD_138\ : MUX2H
      port map(A => \I10.EVENT_DWORDl5r_net_1\, B => 
        \I10.EVENT_DWORD_18l5r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_138_net_1\);
    
    \I2.REGMAPl21r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un70_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl21r_net_1\);
    
    \I2.N_3030_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3030\, SET => 
        HWRES_c_2_0, Q => \I2.N_3030_Rd1__net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l2r\ : OR2
      port map(A => LB_inl2r, B => 
        \I2.STATE5l4r_adt_net_116400_Rd1__net_1\, Y => 
        \I2.N_3024\);
    
    \I10.EVNT_NUMl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l2r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl2r_net_1\);
    
    VAD_padl12r : IOB33PH
      port map(PAD => VAD(12), A => \I2.VADml12r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl12r);
    
    \I2.PIPEA1l5r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_516_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l5r_net_1\);
    
    \I2.REG_1_170\ : MUX2L
      port map(A => REGl180r, B => VDB_inl11r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_170_net_1\);
    
    \I5.un1_RESCNT_I_59\ : XOR2
      port map(A => \I5.RESCNTl6r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_11l0r\, Y => \I5.I_59\);
    
    \I2.REG_1l290r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_253_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl290r\);
    
    \I2.VDBi_19l29r\ : AND2
      port map(A => TST_cl5r, B => REGl77r, Y => 
        \I2.VDBi_19l29r_net_1\);
    
    \I2.REG_1l458r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_373_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl458r);
    
    \I10.un1_REG_1_ADD_16x16_medium_I79_Y\ : XOR2
      port map(A => \I10.ADD_16x16_medium_I58_Y\, B => 
        \I10.ADD_16x16_medium_I79_Y_0\, Y => 
        \I10.ADD_16x16_medium_I79_Y\);
    
    \I2.STATE5L3R_ADT_NET_116444_RD1__510\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl1r_net_1\, CLR
         => HWRES_c_2_0, Q => 
        \I2.STATE5L3R_ADT_NET_116444_RD1__108\);
    
    \I2.VDBI_54_0_IV_3L1R_412\ : AND2
      port map(A => REGl154r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il1r_adt_net_53668_\);
    
    \I10.CNT_10_i_0l3r\ : AND2
      port map(A => \I10.N_2287\, B => \I10.I_23\, Y => 
        \I10.CNT_10_i_0l3r_net_1\);
    
    \I2.REG_il291r\ : INV
      port map(A => \I2.REGl291r\, Y => REG_i_0l291r);
    
    \I2.REG_1_ml234r\ : AND2
      port map(A => SYNC_cl1r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.REG_1_m_il234r\);
    
    \I1.COMMANDl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_7_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl11r_net_1\);
    
    \I2.REG_1l75r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_448_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl75r);
    
    \I2.REG_1l398r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_313_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl398r);
    
    \I2.TCNT3l3r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT3_2l3r\, Q => 
        \I2.TCNT3l3r_net_1\);
    
    \I5.sstate_ns_i_a2_0l1r\ : NOR2
      port map(A => PULSEl6r, B => \I5.sstatel2r_net_1\, Y => 
        \I5.N_225\);
    
    \I2.VDBI_17_0L2R_406\ : NOR3FFT
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl2r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1899_adt_net_52772_\);
    
    \I5.SBYTE_5l4r\ : MUX2L
      port map(A => REGl85r, B => FBOUTl3r, S => 
        \I5.sstatel5r_net_1\, Y => \I5.SBYTE_5l4r_net_1\);
    
    \I2.REG_1_472\ : MUX2H
      port map(A => VDB_inl10r, B => REGl99r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_472_net_1\);
    
    F_SI_pad : OTB33PH
      port map(PAD => F_SI, A => \I5.ISI_net_1\, EN => 
        \I5.DRIVECS_net_1\);
    
    \I3.AEl36r\ : MUX2L
      port map(A => REGl189r, B => \I3.un16_ael36r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl36r);
    
    \I10.EVENT_DWORD_18_RL29R_220\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl29r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l29r_adt_net_24986_\);
    
    \I2.VDBi_54_0_iv_0l0r\ : AOI21TTF
      port map(A => \I2.REGMAP_i_il17r\, B => REGl137r, C => 
        \I2.REG_ml105r_net_1\, Y => \I2.VDBi_54_0_iv_0l0r_net_1\);
    
    \I2.TCNT2_i_0_il4r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT2_2l4r\, Q => 
        \I2.TCNT2_i_0_il4r_net_1\);
    
    \I1.I_220_1\ : AND2
      port map(A => \I1.BITCNT_i_il0r\, B => \I1.BITCNTl1r_net_1\, 
        Y => \I1.N_545_1\);
    
    \I10.EVENT_DWORD_156\ : MUX2H
      port map(A => \I10.EVENT_DWORDl23r_net_1\, B => 
        \I10.EVENT_DWORD_18l23r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_156_net_1\);
    
    \I2.WDOG_i_0l3r\ : AO21
      port map(A => \I2.WDOGRES_net_1\, B => \I2.WDOGRES1_i\, C
         => HWRES_C_2_0_19, Y => \I2.un17_hwres_i\);
    
    \I2.VDBi_24l5r\ : MUX2L
      port map(A => \I2.REGl479r\, B => \I2.VDBi_19l5r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l5r_net_1\);
    
    \I2.un11_tcnt2\ : NOR3FTT
      port map(A => \I2.un6_tcnt1_net_1\, B => 
        \I2.un11_tcnt2_4_i\, C => \I2.un11_tcnt2_5_i\, Y => 
        \I2.un11_tcnt2_net_1\);
    
    \I3.SBYTE_3\ : MUX2L
      port map(A => REGl137r, B => \I3.SBYTE_5l0r_net_1\, S => 
        \I3.N_167\, Y => \I3.SBYTE_3_net_1\);
    
    \I1.DATA_12l13r\ : MUX2H
      port map(A => \I1.SBYTEl5r_net_1\, B => REGl118r, S => 
        \I1.DATA_1_sqmuxa_2\, Y => \I1.DATA_12l13r_net_1\);
    
    \I2.REG_1l102r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_475_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl102r);
    
    \I3.AEl32r\ : MUX2L
      port map(A => REGl185r, B => \I3.un16_ael32r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl32r);
    
    \I5.sstate_0_sqmuxa_1_0_a2_9\ : NAND3
      port map(A => \I5.RESCNTl4r_net_1\, B => 
        \I5.RESCNTl3r_net_1\, C => 
        \I5.sstate_0_sqmuxa_1_0_a2_5_net_1\, Y => 
        \I5.sstate_0_sqmuxa_1_0_a2_9_i\);
    
    \I2.VDBi_86_iv_1l13r\ : AOI21TTF
      port map(A => \I2.PIPEAl13r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_iv_0l13r_net_1\, Y => 
        \I2.VDBi_86_iv_1l13r_net_1\);
    
    \I10.G_1_2\ : NAND2
      port map(A => \I10.STATE1l4r_net_1\, B => 
        \I10.OR_RREQ_net_1\, Y => \I10.N_2642_0\);
    
    \I10.un2_i2c_chain_0_0_0_0_o3_0l1r\ : AND2FT
      port map(A => \I10.CNTl0r_net_1\, B => \I10.CNTL2R_11\, Y
         => \I10.N_2302\);
    
    \I2.LB_s_40\ : MUX2L
      port map(A => \I2.LB_sl26r_Rd1__net_1\, B => 
        \I2.N_3035_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116348_Rd1__net_1\, Y => 
        \I2.LB_sl26r\);
    
    \I2.VDBi_86_0_iv_0l21r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l21r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il21r_adt_net_41238_\, Y => 
        \I2.VDBi_86_0_iv_0_il21r\);
    
    \I5.un1_RESCNT_I_53\ : XOR2
      port map(A => \I5.RESCNTl10r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_11_1l0r\, Y => \I5.I_53\);
    
    \I2.N_3028_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3028\, SET => 
        HWRES_c_2_0, Q => \I2.N_3028_Rd1__net_1\);
    
    \I10.STATE1l4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl8r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l4r_net_1\);
    
    \I10.CRC32_3_i_0_0l10r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2324_i_i_0\, Y => \I10.N_1352\);
    
    \I1.I2C_RDATAl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_18_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl4r);
    
    \I2.LB_i_7l6r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l6r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l6r_Rd1__net_1\);
    
    \I3.ISI_2\ : MUX2L
      port map(A => SI_PDL_c, B => \I3.ISI_5\, S => \I3.N_165\, Y
         => \I3.ISI_2_net_1\);
    
    \I3.un16_ae_6_1\ : OR2
      port map(A => REGl125r, B => REGl122r, Y => 
        \I3.un16_ae_1l6r\);
    
    \I10.FID_8_rl0r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l0r_adt_net_24747_\, Y => \I10.FID_8l0r\);
    
    \I10.un1_CNT_1_I_21\ : XOR2
      port map(A => \I10.CNTl1r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_TMPl0r\, Y => \I10.I_21\);
    
    \I10.BNC_NUMBERl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_232_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl2r_net_1\);
    
    \I2.PIPEB_60\ : MUX2H
      port map(A => \I2.PIPEBl11r_net_1\, B => \I2.N_2591\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_60_net_1\);
    
    \I2.PIPEA1_9_il0r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl0r, Y => \I2.N_2497\);
    
    TST_padl7r : OB33PH
      port map(PAD => TST(7), A => \I2.N_2732_i_0\);
    
    \I2.REG_1_184\ : MUX2L
      port map(A => REGl194r, B => VDB_inl9r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_184_net_1\);
    
    \I2.LB_il23r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il23r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il23r_Rd1__net_1\);
    
    \I1.COMMANDl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_5_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl9r_net_1\);
    
    \I2.TCNT_10l2r\ : OAI21FTF
      port map(A => \I2.N_1714\, B => \I2.un1_STATE1_15_0_net_1\, 
        C => \I2.I_20_0\, Y => \I2.TCNT_10l2r_net_1\);
    
    \I10.READ_OR_FLAG_85_i_0_0_a2\ : NOR2
      port map(A => \I10.STATE1l3r_net_1\, B => 
        \I10.READ_OR_FLAG_net_1\, Y => \I10.N_2396\);
    
    \I8.I_50_3\ : AND3
      port map(A => \I8.BITCNTl0r_net_1\, B => 
        \I8.BITCNTl1r_net_1\, C => \I8.I_50_0_net_1\, Y => 
        \I8.I_50_3_net_1\);
    
    \I8.BITCNTl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.BITCNT_6l2r\, CLR => 
        HWRES_c_2_0, Q => \I8.BITCNTl2r_net_1\);
    
    \I2.VDBml24r\ : MUX2L
      port map(A => \I2.VDBil24r_net_1\, B => \I2.N_2065\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml24r_net_1\);
    
    \I10.EVENT_DWORD_18_RL22R_231\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl22r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l22r_adt_net_26064_\);
    
    \I2.PURGED_13\ : OA21
      port map(A => EVREAD, B => \I2.PURGED_net_1\, C => 
        \I2.N_2829\, Y => \I2.PURGED_13_net_1\);
    
    \I2.STATE1_ns_il9r\ : NOR3FTT
      port map(A => \I2.N_1714\, B => \I2.N_1783\, C => 
        \I2.STATE1_ns_i_0l9r_net_1\, Y => 
        \I2.STATE1_ns_il9r_net_1\);
    
    \I2.REG_il294r\ : INV
      port map(A => \I2.REGl294r\, Y => REG_i_0l294r);
    
    \I2.REG_1_476\ : MUX2H
      port map(A => VDB_inl14r, B => REGl103r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_476_net_1\);
    
    \I2.ASBS\ : DFFS
      port map(CLK => CLKOUT, D => \I2.ASBSF1_net_1\, SET => 
        HWRES_c_2_0, Q => TST_cl0r);
    
    \I1.I_192_3_0\ : OR2
      port map(A => \I1.sstatel11r_net_1\, B => 
        \I1.sstatel6r_net_1\, Y => \I1.I_192_3_0_net_1\);
    
    \I3.AEl13r\ : MUX2L
      port map(A => REGl166r, B => \I3.un16_ael13r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl13r);
    
    LBSP_padl17r : IOB33PH
      port map(PAD => LBSP(17), A => REGl410r, EN => REG_i_0l282r, 
        Y => LBSP_inl17r);
    
    \I2.REG_1l130r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_132_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl130r);
    
    \I2.LB_i_7l31r\ : AND2
      port map(A => VDB_inl31r, B => \I2.STATE5L2R_72\, Y => 
        \I2.LB_i_7l31r_net_1\);
    
    \I8.un1_sstate_3_0_a2_0\ : AOI21FTT
      port map(A => \I8.sstatel0r_net_1\, B => \I8.N_228\, C => 
        \I8.sstatel1r_net_1\, Y => \I8.N_198_0\);
    
    \I2.VDBi_54_0_iv_2l5r\ : AOI21TTF
      port map(A => REGl174r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml158r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l5r_net_1\);
    
    \I2.REG_1_130\ : MUX2L
      port map(A => VDB_inl7r, B => \I2.REGl128r\, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_130_net_1\);
    
    \I5.BITCNTl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.BITCNT_6l1r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.BITCNTl1r_net_1\);
    
    \I1.SBYTE_9_il1r\ : MUX2H
      port map(A => \I1.SBYTEl0r_net_1\, B => 
        \I1.COMMANDl9r_net_1\, S => \I1.N_625_0\, Y => \I1.N_598\);
    
    \I10.un1_CNT_1_G_1_0\ : AND2
      port map(A => \I10.G_1_0_0_net_1\, B => 
        \I10.G_1_0_adt_net_15904_\, Y => \I10.G_1_0_net_1\);
    
    \I3.un16_ae_21\ : NOR2
      port map(A => \I3.un16_ae_1l29r\, B => \I3.un16_ae_1l23r\, 
        Y => \I3.un16_ael21r\);
    
    \I10.UN2_I2C_CHAIN_0_I_0_0_0L2R_278\ : NOR3FTT
      port map(A => \I10.CNTl4r_net_1\, B => \I10.CNTl5r_net_1\, 
        C => \I10.CNTL2R_11\, Y => 
        \I10.un2_i2c_chain_0_i_0_0_0_il2r_adt_net_29501_\);
    
    SP_PDL_padl25r : IOB33PH
      port map(PAD => SP_PDL(25), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl25r);
    
    \I10.un1_STATE1_14_0_0_1\ : OR2FT
      port map(A => \I10.N_2647\, B => \I10.STATE1L12R_10\, Y => 
        \I10.un1_STATE1_14_1\);
    
    SP_PDL_padl26r : IOB33PH
      port map(PAD => SP_PDL(26), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl26r);
    
    \I1.DATA_12_iv_0l1r\ : MUX2L
      port map(A => \I1.DATA_12_iv_0_a2_0_0_il1r\, B => REGl106r, 
        S => \I1.N_633\, Y => \I1.DATA_12_ivl1r\);
    
    \I10.FID_184\ : MUX2L
      port map(A => \I10.FID_8l19r\, B => \I10.FIDl19r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_184_net_1\);
    
    \I10.BNC_NUMBERl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_230_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl0r_net_1\);
    
    \I5.RESCNTl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l14r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl14r_net_1\);
    
    \I2.un756_regmap_18\ : NOR3
      port map(A => TST_cl5r, B => \I2.un756_regmap_11_0_i\, C
         => \I2.REGMAPl2r_net_1\, Y => \I2.un756_regmap_18_net_1\);
    
    \I2.LB_sl24r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl24r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl24r_Rd1__net_1\);
    
    \I2.VDBI_59L15R_348\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l15r_net_1\, C => \I2.VDBi_54_0_iv_5_il15r\, Y
         => \I2.VDBi_59l15r_adt_net_42806_\);
    
    \I2.REG_1l432r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_347_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl432r);
    
    \I10.CNTl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CNT_10_i_0l3r_net_1\, CLR
         => CLEAR_0_0, Q => \I10.CNTl3r_net_1\);
    
    \I8.SWORD_10\ : MUX2H
      port map(A => \I8.SWORDl9r_net_1\, B => 
        \I8.SWORD_5l9r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_10_net_1\);
    
    \I2.PIPEB_4_il31r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl31r, Y => \I2.N_2631\);
    
    \I5.un1_RESCNT_I_82\ : AND2
      port map(A => \I5.RESCNTl10r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_11_1l0r\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_12_4l0r\);
    
    \I2.REG_1_432\ : MUX2H
      port map(A => VDB_inl11r, B => REGl59r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_432_net_1\);
    
    \I2.REG_1l288r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_251_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl288r\);
    
    AE_PDL_padl29r : OB33PH
      port map(PAD => AE_PDL(29), A => AE_PDL_cl29r);
    
    \I2.REG_1_440\ : MUX2H
      port map(A => VDB_inl19r, B => REGl67r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_440_net_1\);
    
    \I2.REG_1_124\ : MUX2H
      port map(A => REGl122r, B => VDB_inl1r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_124_net_1\);
    
    \I2.VDBi_86_0_ivl20r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl20r\, C
         => \I2.VDBi_86l20r_adt_net_41482_\, Y => 
        \I2.VDBi_86l20r\);
    
    \I5.SBYTE_11\ : MUX2H
      port map(A => FBOUTl5r, B => \I5.SBYTE_5l5r_net_1\, S => 
        \I5.un1_sstate_12\, Y => \I5.SBYTE_11_net_1\);
    
    \I2.VDBi_86_0_iv_0_a2l19r\ : AND3
      port map(A => \I2.STATE1l8r_net_1\, B => \I2.N_1782\, C => 
        \I2.N_2861\, Y => \I2.N_2898_i\);
    
    \I2.REG_1_190\ : MUX2L
      port map(A => REGl200r, B => VDB_inl15r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_190_net_1\);
    
    \I1.sstate2l3r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2se_5_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstate2l3r_net_1\);
    
    AE_PDL_padl5r : OB33PH
      port map(PAD => AE_PDL(5), A => AE_PDL_cl5r);
    
    \I2.VDBi_85_ml12r\ : NAND3
      port map(A => \I2.VDBil12r_net_1\, B => \I2.STATE1_i_il1r\, 
        C => \I2.N_1721_1\, Y => \I2.VDBi_85_ml12r_net_1\);
    
    \I2.VDBi_17_0l9r\ : AOI21
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl9r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1906_adt_net_46976_\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I73_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl41r\, Y => 
        \I10.ADD_16x16_medium_I73_Y_0\);
    
    LBSP_padl30r : IOB33PH
      port map(PAD => LBSP(30), A => REGl423r, EN => REG_i_0l295r, 
        Y => LBSP_inl30r);
    
    \I10.BNCRES_CNT_4_G_1_1_2\ : NAND2
      port map(A => \I10.DWACT_ADD_CI_0_pog_array_1_1l0r\, B => 
        \I10.BNCRES_CNTl0r_net_1\, Y => \I10.G_1_1_2_i\);
    
    \I2.LB_i_493\ : MUX2L
      port map(A => \I2.LB_il15r_Rd1__net_1\, B => 
        \I2.LB_i_7l15r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__83\, Y => \I2.LB_il15r\);
    
    LBSP_padl27r : IOB33PH
      port map(PAD => LBSP(27), A => REGl420r, EN => REG_i_0l292r, 
        Y => LBSP_inl27r);
    
    \I3.SBYTE_10\ : MUX2L
      port map(A => REGl144r, B => \I3.SBYTE_5l7r_net_1\, S => 
        \I3.N_167\, Y => \I3.SBYTE_10_0\);
    
    AE_PDL_padl8r : OB33PH
      port map(PAD => AE_PDL(8), A => AE_PDL_cl8r);
    
    \I2.STATE1l6r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE1_nsl3r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => \I2.STATE1l6r_net_1\);
    
    \I2.VDBi_9_sqmuxa_i_0\ : NOR2
      port map(A => \I2.REGMAP_i_il23r\, B => 
        \I2.REGMAPl24r_net_1\, Y => \I2.VDBi_9_sqmuxa_i_0_net_1\);
    
    \I2.VAS_89\ : MUX2L
      port map(A => VAD_inl7r, B => \I2.VASl7r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_89_net_1\);
    
    \I2.VDBm_0l28r\ : MUX2L
      port map(A => \I2.PIPEAl28r_net_1\, B => \I2.PIPEB_i_il28r\, 
        S => \I2.BLTCYC_net_1\, Y => \I2.N_2069\);
    
    \I2.REG_1_178\ : MUX2L
      port map(A => REGl188r, B => VDB_inl3r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_178_net_1\);
    
    \I10.CRC32l16r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_103_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l16r_net_1\);
    
    \I2.REG_1l251r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_214_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl251r);
    
    \I10.BNCRES_CNTl0r\ : DFFC
      port map(CLK => CLKOUT, D => 
        \I10.DWACT_ADD_CI_0_partial_sum_1l0r\, CLR => CLEAR_0_0, 
        Q => \I10.BNCRES_CNTl0r_net_1\);
    
    \I2.REG_1l442r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_357_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl442r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I62_Y\ : AOI21
      port map(A => \I10.N292\, B => \I10.N227\, C => \I10.N226\, 
        Y => \I10.N326_i\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I59_Y\ : AOI21
      port map(A => \I10.N245\, B => \I10.N302\, C => 
        \I10.N_3114_i\, Y => \I10.N320_i\);
    
    \I2.REG_1l396r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_311_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl396r);
    
    \I10.OR_RADDR_1_sqmuxa_i_o3\ : OR2
      port map(A => \I10.N_2282\, B => \I10.N_2284\, Y => 
        \I10.N_2286\);
    
    \I2.PIPEAl18r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_562_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl18r_net_1\);
    
    \I2.LB_i_7l29r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l29r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l29r_Rd1__net_1\);
    
    \I2.LB_i_7l2r\ : MUX2L
      port map(A => VDB_inl2r, B => \I2.VASl2r_net_1\, S => 
        \I2.STATE5l2r_adt_net_116440_Rd1__net_1\, Y => 
        \I2.N_1889\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L16R_242\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl24r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l16r_adt_net_26790_\);
    
    \I2.VDBI_54_0_IV_1L7R_378\ : AND2
      port map(A => SYNC_cl7r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il7r_adt_net_48926_\);
    
    \I10.un2_i2c_chain_0_i_0_a2_2l5r\ : AND2
      port map(A => \I10.CNTl4r_net_1\, B => \I10.CNTl5r_net_1\, 
        Y => \I10.N_2406\);
    
    \I2.REG_1l436r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_351_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl436r\);
    
    \I10.un6_bnc_res_8\ : XOR2
      port map(A => \I10.BNC_CNTl8r_net_1\, B => REGl465r, Y => 
        \I10.un6_bnc_res_8_i_i\);
    
    \I10.BNC_CNT_4_0_a2l17r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => 
        \I10.I_105\, Y => \I10.BNC_CNT_4l17r\);
    
    \I2.REG_1_186\ : MUX2L
      port map(A => REGl196r, B => VDB_inl11r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_186_net_1\);
    
    \I2.PIPEAl26r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_570_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl26r_net_1\);
    
    \I1.SCL_1_iv_i_a3_1\ : OR3
      port map(A => \I1.sstatel0r_net_1\, B => 
        \I1.sstatel9r_net_1\, C => \I1.sstatel11r_net_1\, Y => 
        \I1.SCL_1_iv_i_a3_1_net_1\);
    
    \I2.REG_1_436\ : MUX2H
      port map(A => VDB_inl15r, B => REGl63r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_436_net_1\);
    
    \I2.LB_il26r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il26r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il26r_Rd1__net_1\);
    
    \I2.PIPEA1_9_il10r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl10r, Y => \I2.N_2517\);
    
    \I2.un54_reg_ads_0_a2_0_a2\ : NOR2
      port map(A => \I2.N_3006_1\, B => \I2.N_2995_1\, Y => 
        \I2.un54_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.un3_bnc_cnt_I_48\ : AND3
      port map(A => \I10.DWACT_FINC_El5r_adt_net_18828_\, B => 
        \I10.DWACT_FINC_El0r\, C => \I10.DWACT_FINC_El2r\, Y => 
        \I10.DWACT_FINC_El4r\);
    
    \I10.EVENT_DWORDl27r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_160_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl27r_net_1\);
    
    \I2.REG1_0_sqmuxa_0_a2\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAP_i_il14r\, Y => \I2.REG1_0_sqmuxa\);
    
    \I1.AIR_COMMAND_cnst_i_a2l0r\ : OR2
      port map(A => \I1.sstate2l1r_net_1\, B => 
        \I1.sstate2l2r_net_1\, Y => \I1.N_486\);
    
    \I3.un4_so_8_0\ : MUX2L
      port map(A => SP_PDL_inl44r, B => SP_PDL_inl40r, S => 
        REGl124r, Y => \I3.N_204\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L4R_266\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl12r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l4r_adt_net_28209_\);
    
    \I3.SBYTEl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.SBYTE_4_net_1\, CLR => 
        HWRES_c_2_0, Q => REGl138r);
    
    \I2.un1_tcnt1_I_23\ : AND3
      port map(A => \I2.TCNT1_i_0_il4r_net_1\, B => 
        \I2.TCNT1l3r_net_1\, C => \I2.DWACT_FINC_El0r\, Y => 
        \I2.N_4\);
    
    \I2.REG_1l289r_73\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_252_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL289R_57\);
    
    VDB_padl7r : IOB33PH
      port map(PAD => VDB(7), A => \I2.VDBml7r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl7r);
    
    \I10.CHIP_ADDR_129\ : MUX2L
      port map(A => CHIP_ADDRl2r, B => \I10.N_248\, S => 
        \I10.N_1595\, Y => \I10.CHIP_ADDR_129_net_1\);
    
    \I2.REG_1l97r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_470_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl97r);
    
    \I2.PIPEA_568\ : MUX2L
      port map(A => \I2.PIPEAl24r_net_1\, B => \I2.PIPEA_8l24r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_568_net_1\);
    
    \I2.PIPEAl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_546_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl2r_net_1\);
    
    \I2.UN1_STATE5_9_1_RD1__503\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.un1_STATE5_9_1\, CLR => 
        HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__88\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I52_un1_Y_1\ : AND3
      port map(A => \I10.N260\, B => \I10.N258\, C => \I10.N276\, 
        Y => \I10.ADD_16x16_medium_I52_un1_Y_1\);
    
    \I2.REG_1_389\ : MUX2H
      port map(A => VDB_inl0r, B => \I2.REGl474r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_389_net_1\);
    
    \I2.REG_1l78r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_451_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl78r);
    
    \I2.VDBi_67_dl0r\ : MUX2L
      port map(A => \I2.VDBi_61_dl0r_net_1\, B => \I2.N_1949\, S
         => \I2.N_1965\, Y => \I2.VDBi_67_dl0r_net_1\);
    
    \I10.EVENT_DWORD_148\ : MUX2H
      port map(A => \I10.EVENT_DWORDl15r_net_1\, B => 
        \I10.EVENT_DWORD_18l15r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_148_net_1\);
    
    \I5.un1_RESCNT_G_1_3_4\ : NAND3
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_1l0r\, B => 
        \I5.DWACT_ADD_CI_0_pog_array_1_5l0r\, C => 
        \I5.RESCNTl14r_net_1\, Y => \I5.G_1_3_4_i_adt_net_33036_\);
    
    \I2.WDOGTOi\ : DFFS
      port map(CLK => CLKOUT, D => \I2.N_2980_i_net_1\, SET => 
        \I2.un17_hwres_i\, Q => WDOGTO_i_0);
    
    \I2.VDBil18r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_594_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil18r_net_1\);
    
    \I2.REG_1_405\ : MUX2H
      port map(A => VDB_inl16r, B => \I2.REGl490r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_405_net_1\);
    
    \I10.EVENT_DWORD_18_RL7R_261\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl17r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l7r_adt_net_27903_\);
    
    \I2.REG_1l446r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_361_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl446r\);
    
    \I2.LB_il25r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il25r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il25r_Rd1__net_1\);
    
    \I3.un4_so_17_0\ : MUX2L
      port map(A => SP_PDL_inl38r, B => SP_PDL_inl6r, S => 
        REGL127R_3, Y => \I3.N_213\);
    
    \I2.un46_reg_ads_0_a2_0_a2\ : NOR3FFT
      port map(A => \I2.N_3008_1\, B => \I2.N_3070\, C => 
        \I2.N_3005_1\, Y => \I2.un46_reg_ads_0_a2_0_a2_net_1\);
    
    LBSP_padl19r : IOB33PH
      port map(PAD => LBSP(19), A => REGl412r, EN => REG_i_0l284r, 
        Y => LBSP_inl19r);
    
    \I10.un2_i2c_chain_0_i_0_o3l5r\ : NAND2
      port map(A => \I10.CNTl4r_net_1\, B => \I10.CNTl3r_net_1\, 
        Y => \I10.N_2296\);
    
    \I2.STATE1_ns_1l2r\ : OAI21TTF
      port map(A => \I2.N_1717\, B => \I2.N_1782\, C => 
        \I2.STATE1_ns_0l2r_net_1\, Y => \I2.STATE1_ns_1l2r_net_1\);
    
    \I2.VDBi_67_0l6r\ : MUX2L
      port map(A => REGl431r, B => \I2.REGL447R_31\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1955\);
    
    NLBWAIT_pad : OB33PH
      port map(PAD => NLBWAIT, A => \VCC\);
    
    \I2.CYCSF1\ : DFFC
      port map(CLK => CLKOUT, D => \I2.CYCSF1_46_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.CYCSF1_net_1\);
    
    \I10.FID_8_IV_0_0_0_1L19R_180\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl67r, Y => 
        \I10.FID_8_iv_0_0_0_1_il19r_adt_net_22257_\);
    
    \I2.REG_1_126\ : MUX2H
      port map(A => REGL124R_5, B => VDB_inl3r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_126_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_0_3l2r\ : OAI21TTF
      port map(A => \I10.CNTl5r_net_1\, B => \I10.N_2400_1\, C
         => \I10.un2_i2c_chain_0_i_0_0_3_il2r_adt_net_29431_\, Y
         => \I10.un2_i2c_chain_0_i_0_0_3_il2r\);
    
    \I10.FIDl24r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_189_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl24r_net_1\);
    
    \I3.sstatel0r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.sstate_ns_i_0l0r\, CLR => 
        HWRES_c_2_0, Q => \I3.sstatel0r_net_1\);
    
    \I1.DATAl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12l11r_net_1\, CLR
         => HWRES_c_2_0, Q => REGl116r);
    
    \I2.VDBi_56l18r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l18r_net_1\, Y => \I2.VDBi_56l18r_net_1\);
    
    \I2.UN756_REGMAP_19_296\ : NOR3
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGMAPl7r_net_1\, 
        C => \I2.REGMAPl6r_net_1\, Y => 
        \I2.un756_regmap_19_adt_net_36245_\);
    
    \I2.REG_1_138\ : MUX2H
      port map(A => REG_cl136r, B => VDB_inl15r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_138_net_1\);
    
    \I2.REG_1l183r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_173_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl183r);
    
    \I2.PIPEA_8_rl0r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl0r, C => 
        \I2.PIPEA_8l0r_adt_net_57674_\, Y => \I2.PIPEA_8l0r\);
    
    \I10.CNT_0l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CNT_10_i_0l2r_net_1\, CLR
         => CLEAR_0_0, Q => \I10.CNTl2r_net_1\);
    
    \I2.VADml29r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEA_i_0_il29r\, Y
         => \I2.VADml29r_net_1\);
    
    \I10.EVENT_DWORDl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_135_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl2r_net_1\);
    
    \I2.REG_1_259_e_1\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAP_i_il25r\, Y => \I2.N_3303_i_1\);
    
    \I10.OR_RREQ_130\ : MUX2H
      port map(A => \I10.OR_RREQ_net_1\, B => 
        \I10.STATE1l3r_net_1\, S => \I10.un1_OR_RREQ_1_sqmuxa\, Y
         => \I10.OR_RREQ_130_net_1\);
    
    \I3.un16_ae_33_1\ : OR2
      port map(A => \I3.un16_ae_1l47r\, B => \I3.un16_ae_1l41r\, 
        Y => \I3.un16_ae_1l33r\);
    
    \I10.EVNT_NUM_3_I_73\ : AND2
      port map(A => \I10.EVNT_NUMl4r_net_1\, B => 
        \I10.EVNT_NUMl5r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_pog_array_1_1_0l0r\);
    
    \I10.CRC32l17r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_104_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l17r_net_1\);
    
    \I10.STATE1_0l12r\ : DFFS
      port map(CLK => CLKOUT, D => \I10.N_557_i_0\, SET => 
        CLEAR_0_0, Q => \I10.STATE1L12R_10\);
    
    \I10.EVNT_NUMl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l6r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl6r_net_1\);
    
    LBSP_padl29r : IOB33PH
      port map(PAD => LBSP(29), A => REGl422r, EN => REG_i_0l294r, 
        Y => LBSP_inl29r);
    
    \I2.REGMAPl0r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un2_reg_ads_0_a2_net_1\, Q
         => \I2.REGMAPl0r_net_1\);
    
    INTR1_pad : OB33PH
      port map(PAD => INTR1, A => \VCC\);
    
    \I2.REG_1_329\ : MUX2L
      port map(A => REGl414r, B => VDB_inl21r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_329_net_1\);
    
    TST_padl5r : OB33PH
      port map(PAD => TST(5), A => TST_cl5r);
    
    \I2.VDBm_0l13r\ : MUX2L
      port map(A => \I2.PIPEAl13r_net_1\, B => 
        \I2.PIPEBl13r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2054\);
    
    \I10.FID_4_0_a2_0l5r\ : XOR2
      port map(A => \I10.CRC32l13r_net_1\, B => 
        \I10.CRC32l25r_net_1\, Y => \I10.FID_4_0_a2_0l5r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l20r\ : OAI21TTF
      port map(A => I2C_RDATAl0r, B => \I10.N_2639\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l20r_adt_net_26300_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l20r_net_1\);
    
    \I2.VDBml9r\ : MUX2L
      port map(A => \I2.VDBil9r_net_1\, B => \I2.N_2050\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml9r_net_1\);
    
    \I2.un1_STATE2_12_0_0_1\ : OR2
      port map(A => \I2.STATE2l5r_net_1\, B => 
        \I2.un1_STATE2_13_1\, Y => \I2.un1_STATE2_13_4_1\);
    
    \I2.VDBi_24_sl0r\ : NOR2
      port map(A => \I2.REGMAP_i_0_il9r\, B => 
        \I2.VDBi_24_sl1r_net_1\, Y => \I2.VDBi_24_sl0r_net_1\);
    
    \I2.VDBil29r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_605_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil29r_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l20r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl4r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il20r_adt_net_22135_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il20r\);
    
    \I2.REG_1_198\ : MUX2L
      port map(A => SYNC_cl2r, B => VDB_inl2r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_198_net_1\);
    
    \I2.VDBi_54_0_iv_1l8r\ : AO21
      port map(A => SYNC_cl8r, B => \I2.REGMAP_i_il23r\, C => 
        \I2.VDBi_54_0_iv_1_il8r_adt_net_48088_\, Y => 
        \I2.VDBi_54_0_iv_1_il8r\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L1R_272\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl9r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l1r_adt_net_28545_\);
    
    \I10.G_2\ : OR3
      port map(A => \I10.G_3_i\, B => \I10.G_2_4_i\, C => 
        \I10.un6_bnc_res_NE_14_i\, Y => 
        \I10.un6_bnc_res_NE_0_net_1\);
    
    \I1.sstatese_11_i\ : MUX2H
      port map(A => \I1.sstatel1r_net_1\, B => 
        \I1.sstatel2r_net_1\, S => TICKl0r, Y => 
        \I1.sstatese_11_i_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l7r\ : OR2
      port map(A => LB_inl7r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__70\, Y => \I2.N_3042\);
    
    \I10.BNCRES_CNT_4_I_46\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_2_0l0r\, B => 
        \I10.DWACT_ADD_CI_0_pog_array_2_0l0r\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_3_0l0r\);
    
    \I10.EVNT_NUM_3_I_65\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_1_1l0r\, B => 
        \I10.EVNT_NUMl2r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_12_5l0r\);
    
    \I2.un1_STATE2_12_0_0_a3_0\ : OR2FT
      port map(A => \I2.STATE2l2r_net_1\, B => \I2.N_2851\, Y => 
        \I2.N_3072\);
    
    \I2.STATE5l2r\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_106\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5l2r_net_1\);
    
    \I10.EVNT_NUMl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l8r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl8r_net_1\);
    
    \I10.BNC_NUMBER_237\ : MUX2L
      port map(A => \I10.BNCRES_CNTl7r_net_1\, B => 
        \I10.BNC_NUMBERl7r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_237_net_1\);
    
    \I2.VDBi_54_0_iv_5l4r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il4r\, B => 
        \I2.VDBi_54_0_iv_0_il4r\, C => \I2.VDBi_54_0_iv_1_il4r\, 
        Y => \I2.VDBi_54_0_iv_5_il4r\);
    
    SP_PDL_padl32r : IOB33PH
      port map(PAD => SP_PDL(32), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl32r);
    
    \I0.HWCLEARi_2_0\ : NAND2
      port map(A => \I10.PLL_LOCK_aclk\, B => \I10.PLL_LOCK_lclk\, 
        Y => \I0.HWCLEARi_2_0_i\);
    
    \I5.un1_BITCNT_I_9\ : XOR2
      port map(A => \I5.BITCNTl0r_net_1\, B => 
        \I5.un1_sstate_13_i_a2_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_partial_sum_0l0r\);
    
    \I2.VDBi_17_rl3r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1900_adt_net_51888_\, C => 
        \I2.N_1900_adt_net_51890_\, Y => \I2.VDBi_17l3r\);
    
    \I10.EVENT_DWORD_18_RL28R_221\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl28r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l28r_adt_net_25140_\);
    
    \I2.N_3047_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3047\, SET => 
        HWRES_c_2_0, Q => \I2.N_3047_Rd1__net_1\);
    
    \I10.FID_8_RL4R_211\ : AO21
      port map(A => \I10.STATE1L1R_14\, B => 
        \I10.EVENT_DWORDl4r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il4r\, Y => 
        \I10.FID_8l4r_adt_net_24259_\);
    
    LBSP_padl13r : IOB33PH
      port map(PAD => LBSP(13), A => REGl406r, EN => REG_i_0l278r, 
        Y => LBSP_inl13r);
    
    \I2.TCNT2_2_I_1\ : AND2
      port map(A => TICKl0r, B => \I2.TCNT2_i_0_il0r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_TMPl0r\);
    
    \I2.REG_1_174\ : MUX2L
      port map(A => REGl184r, B => VDB_inl15r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_174_net_1\);
    
    \I2.REG3l12r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_119_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl12r\);
    
    \I2.EVREAD_DS_1_sqmuxa_0_a2_0_1\ : AND3
      port map(A => \I2.PIPEB_i_il28r\, B => \I2.PIPEBl30r_net_1\, 
        C => \I2.EVREAD_DS_1_sqmuxa_0_a2_0_1_0_i\, Y => 
        \I2.N_2895_2\);
    
    \I10.un2_i2c_chain_0_i_0_7l5r\ : OR3
      port map(A => \I10.un2_i2c_chain_0_i_0_6_il5r\, B => 
        \I10.un2_i2c_chain_0_i_0_1_il5r\, C => 
        \I10.un2_i2c_chain_0_i_0_2_il5r\, Y => 
        \I10.un2_i2c_chain_0_i_0_7_il5r\);
    
    \I10.EVENT_DWORD_18_RL6R_263\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl16r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l6r_adt_net_28015_\);
    
    \I10.FID_8_rl10r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l10r_adt_net_23520_\, Y => \I10.FID_8l10r\);
    
    \I10.FID_183\ : MUX2L
      port map(A => \I10.FID_8l18r\, B => \I10.FIDl18r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_183_net_1\);
    
    \I2.VDBi_86_0_ivl23r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl23r\, C
         => \I2.VDBi_86l23r_adt_net_40867_\, Y => 
        \I2.VDBi_86l23r\);
    
    \I2.REG_1l394r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_309_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REGl394r);
    
    \I2.STATE2l4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE2l0r_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.STATE2l4r_net_1\);
    
    \I2.REG_1_315\ : MUX2L
      port map(A => REGl400r, B => VDB_inl7r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_315_net_1\);
    
    \I2.REG_1_463\ : MUX2H
      port map(A => VDB_inl1r, B => REGl90r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_463_net_1\);
    
    \I1.un1_SDAnoe_0_sqmuxa_0_o3\ : OR2
      port map(A => \I1.N_467\, B => \I1.N_408_adt_net_8520_\, Y
         => \I1.N_408\);
    
    \I10.FID_8_iv_0_0_0_1l25r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl25r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il25r_adt_net_21273_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il25r\);
    
    \I3.AEl15r\ : MUX2L
      port map(A => REGl168r, B => \I3.un16_ael15r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl15r);
    
    \I2.PIPEA_8_rl20r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl20r, C => 
        \I2.PIPEA_8l20r_adt_net_56237_\, Y => \I2.PIPEA_8l20r\);
    
    \I10.FID_4_0_a2l7r\ : XOR2FT
      port map(A => \I10.CRC32l3r_net_1\, B => 
        \I10.FID_4_0_a2_0l7r_net_1\, Y => \I10.FID_4_il7r\);
    
    \I10.BNC_LIMIT\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_0_sqmuxa\, CLR
         => CLEAR_0_0, Q => \I10.BNC_LIMIT_net_1\);
    
    \I2.N_3049_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3049\, SET => 
        HWRES_c_2_0, Q => \I2.N_3049_Rd1__net_1\);
    
    \I10.RDY_CNTl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.RDY_CNT_10_i_0l1r_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.RDY_CNTl1r_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L17R_240\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl25r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l17r_adt_net_26678_\);
    
    TST_padl15r : OB33PH
      port map(PAD => TST(15), A => \VCC\);
    
    SYSRESB_pad : IB33
      port map(PAD => SYSRESB, Y => SYSRESB_c);
    
    \I2.un1_WDOGRES_0_sqmuxa_0_0_a2_0_1\ : AND3
      port map(A => \I2.WDOGl1r_net_1\, B => \I2.WDOGl2r_net_1\, 
        C => \I2.WDOGl3r_net_1\, Y => \I2.N_2886_1\);
    
    \I2.REG_1_360\ : MUX2L
      port map(A => \I2.REGL445R_29\, B => VDB_inl4r, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_360_net_1\);
    
    LBSP_padl23r : IOB33PH
      port map(PAD => LBSP(23), A => REGl416r, EN => REG_i_0l288r, 
        Y => LBSP_inl23r);
    
    \I2.REG_92l83r\ : AND2
      port map(A => \I2.N_1826_0\, B => \I2.N_1986\, Y => 
        \I2.REG_92l83r_net_1\);
    
    \I2.REG3l11r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_118_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl11r\);
    
    \I10.CRC32l22r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_109_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l22r_net_1\);
    
    \I2.PIPEA_8_RL23R_430\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l23r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l23r_adt_net_56027_\);
    
    \I2.LB_il31r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il31r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il31r_Rd1__net_1\);
    
    \I1.START_I2C_26\ : MUX2H
      port map(A => \I1.START_I2C_net_1\, B => \I1.START_I2C_2\, 
        S => TICKl0r, Y => \I1.START_I2C_26_net_1\);
    
    \I8.un1_BITCNT_I_18\ : XOR2
      port map(A => \I8.DWACT_ADD_CI_0_g_array_1l0r\, B => 
        \I8.BITCNTl2r_net_1\, Y => \I8.I_18\);
    
    \I2.REG_1l405r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_320_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl405r);
    
    \I10.un2_i2c_chain_0_0_0_0_a3_1l3r\ : AND2
      port map(A => \I10.CNTl5r_net_1\, B => \I10.CNTL2R_11\, Y
         => \I10.N_2649\);
    
    \I2.VADml10r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl10r_net_1\, Y
         => \I2.VADml10r_net_1\);
    
    \I2.UN94_REG_ADS_0_A2_0_A2_304\ : NOR3FTT
      port map(A => \I2.N_2863\, B => \I2.N_3012_1\, C => 
        \I2.N_3065\, Y => 
        \I2.un94_reg_ads_0_a2_0_a2_adt_net_37494_\);
    
    \I8.un5_tick\ : NOR2
      port map(A => PULSEl9r, B => TICKl2r, Y => \I8.N_228\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l26r\ : OAI21
      port map(A => I2C_RDATAl6r, B => \I10.N_2639\, C => 
        \I10.N_2642_0\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l26r_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2l0r\ : AND2
      port map(A => \I10.CNTl5r_net_1\, B => \I10.CNTl3r_net_1\, 
        Y => \I10.N_2358\);
    
    \I2.VDBi_61l14r\ : MUX2L
      port map(A => LBSP_inl14r, B => \I2.VDBi_59l14r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l14r_net_1\);
    
    \I1.BITCNTl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.BITCNT_10l2r\, CLR => 
        HWRES_c_2_0, Q => \I1.BITCNTl2r_net_1\);
    
    \I10.OR_RADDR_218\ : MUX2H
      port map(A => \I10.CNTL0R_9\, B => \I10.OR_RADDRl0r_net_1\, 
        S => \I10.N_2126\, Y => \I10.OR_RADDR_218_net_1\);
    
    LBSP_padl10r : IOB33PH
      port map(PAD => LBSP(10), A => REGl403r, EN => REG_i_0l275r, 
        Y => LBSP_inl10r);
    
    \I10.I2C_RREQ\ : DFFC
      port map(CLK => CLKOUT, D => \I10.I2C_RREQ_132_net_1\, CLR
         => CLEAR_0_0, Q => I2C_RREQ);
    
    \I2.REG_1_202\ : MUX2L
      port map(A => SYNC_cl6r, B => VDB_inl6r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_202_net_1\);
    
    \I10.un1_STATE1_16_i_0\ : NAND2
      port map(A => \I10.N_557_1\, B => \I10.N_2382\, Y => 
        \I10.N_577\);
    
    \I2.VDBi_19l27r\ : AND2
      port map(A => TST_cl5r, B => REGl75r, Y => 
        \I2.VDBi_19l27r_net_1\);
    
    \I10.PDL_RADDR_224\ : MUX2H
      port map(A => \I10.CNTl0r_net_1\, B => 
        \I10.PDL_RADDRl0r_net_1\, S => \I10.PDL_RADDR_1_sqmuxa\, 
        Y => \I10.PDL_RADDR_224_net_1\);
    
    \I10.FID_8_RL10R_199\ : AO21
      port map(A => \I10.EVENT_DWORDl10r_net_1\, B => 
        \I10.STATE1L1R_14\, C => \I10.FID_8_iv_0_0_0_0_il10r\, Y
         => \I10.FID_8l10r_adt_net_23520_\);
    
    \I2.VDBi_86_iv_1l6r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl6r\, C
         => \I2.VDBi_86_iv_1_il6r_adt_net_49958_\, Y => 
        \I2.VDBi_86_iv_1_il6r\);
    
    \I3.I_42\ : AND3
      port map(A => \I3.sstatel0r_net_1\, B => \I3.N_195_2\, C
         => \I3.I_42_1_net_1\, Y => \I3.N_195\);
    
    \I2.REG_1l134r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_136_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl134r);
    
    \I2.REG_92l88r\ : AND2
      port map(A => \I2.N_1826_0\, B => \I2.N_1991\, Y => 
        \I2.REG_92l88r_net_1\);
    
    \I2.REG_1_134\ : MUX2H
      port map(A => REG_cl132r, B => VDB_inl11r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_134_net_1\);
    
    \I10.BNC_CNTl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_209_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl11r_net_1\);
    
    \I2.LB_i_7l14r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l14r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l14r_Rd1__net_1\);
    
    \I3.un16_ae_3_1\ : OR2
      port map(A => \I3.un16_ae_1l15r\, B => \I3.un16_ae_1l7r\, Y
         => \I3.un16_ae_1l5r\);
    
    \I2.NOEDTKi\ : DFFS
      port map(CLK => CLKOUT, D => \I2.NOEDTKi_103_net_1\, SET
         => \I2.N_2483_i_0_0_0\, Q => TST_c_cl3r);
    
    \I10.EVENT_DWORD_18_rl6r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l6r_net_1\, B => 
        \I10.EVENT_DWORD_18l6r_adt_net_28015_\, Y => 
        \I10.EVENT_DWORD_18l6r\);
    
    \I10.CRC32_91\ : MUX2H
      port map(A => \I10.CRC32l4r_net_1\, B => \I10.N_1348\, S
         => \I10.N_2351\, Y => \I10.CRC32_91_net_1\);
    
    \I10.CRC32_3_i_0l15r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2339_i_i_0\, Y => \I10.N_1590\);
    
    \I1.AIR_COMMAND_45\ : MUX2L
      port map(A => \I1.AIR_COMMANDl13r_net_1\, B => 
        \I1.AIR_COMMAND_21l13r\, S => \I1.un1_tick_12_net_1\, Y
         => \I1.AIR_COMMAND_45_net_1\);
    
    \I2.LB_il11r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il11r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il11r_Rd1__net_1\);
    
    \I10.FID_4_0_a2_0l6r\ : XOR2
      port map(A => \I10.CRC32l14r_net_1\, B => 
        \I10.CRC32l26r_net_1\, Y => \I10.FID_4_0_a2_0l6r_net_1\);
    
    SP_PDL_padl41r : IOB33PH
      port map(PAD => SP_PDL(41), A => REGl129r, EN => MD_PDL_C_0, 
        Y => SP_PDL_inl41r);
    
    \I1.I_213\ : NAND2
      port map(A => \I1.PULSE_FL_net_1\, B => \I1.SSTATEL13R_8\, 
        Y => \I1.N_544\);
    
    \I1.COMMAND_4\ : MUX2H
      port map(A => \I1.COMMANDl8r_net_1\, B => 
        \I1.COMMAND_4l8r_net_1\, S => \I1.SSTATEL13R_8\, Y => 
        \I1.COMMAND_4_net_1\);
    
    \I2.REG_1_176\ : MUX2L
      port map(A => REGl186r, B => VDB_inl1r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_176_net_1\);
    
    \I1.SBYTEl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SBYTE_33_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SBYTEl5r_net_1\);
    
    \I2.LB_i_7l2r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l2r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l2r_Rd1__net_1\);
    
    SP_PDL_padl33r : IOB33PH
      port map(PAD => SP_PDL(33), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl33r);
    
    \I10.PDL_RADDR_226\ : MUX2H
      port map(A => \I10.CNTL2R_11\, B => 
        \I10.PDL_RADDRl2r_net_1\, S => \I10.PDL_RADDR_1_sqmuxa\, 
        Y => \I10.PDL_RADDR_226_net_1\);
    
    VDB_padl11r : IOB33PH
      port map(PAD => VDB(11), A => \I2.VDBml11r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl11r);
    
    \I2.VDBi_24l14r\ : MUX2L
      port map(A => \I2.REGl488r\, B => \I2.VDBi_19l14r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l14r_net_1\);
    
    VAD_padl4r : IOB33PH
      port map(PAD => VAD(4), A => \I2.VADml4r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl4r);
    
    \I1.I2C_RDATA_9_il4r\ : MUX2L
      port map(A => I2C_RDATAl4r, B => REGl115r, S => 
        \I1.sstate2_0_sqmuxa_4_0\, Y => \I1.N_582\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I10_P0N\ : NOR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl42r\, Y => 
        \I10.N239\);
    
    \I10.EVENT_DWORD_18_i_0_0l15r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl15r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0l15r_adt_net_26902_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0l15r_net_1\);
    
    \I2.N_3040_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3040\, SET => 
        HWRES_c_2_0, Q => \I2.N_3040_Rd1__net_1\);
    
    SYNC_padl15r : OB33PH
      port map(PAD => SYNC(15), A => REG_cl248r);
    
    \I1.SBYTEl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SBYTE_30_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SBYTEl2r_net_1\);
    
    LB_padl22r : IOB33PH
      port map(PAD => LB(22), A => \I2.LB_il22r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl22r);
    
    \I2.STATE5L4R_ADT_NET_116400_RD1__482\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_NS_I_IL0R_95\, 
        SET => HWRES_c_2_0, Q => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__67\);
    
    LBSP_padl20r : IOB33PH
      port map(PAD => LBSP(20), A => REGl413r, EN => REG_i_0l285r, 
        Y => LBSP_inl20r);
    
    \I5.un1_reg_1\ : OAI21TTF
      port map(A => \I5.DRIVE_RELOAD_net_1\, B => REGl80r, C => 
        \un1_reg_1_adt_net_2497_\, Y => un1_reg_1);
    
    \I1.sstate2se_1_0\ : AO21
      port map(A => \I1.N_277_0\, B => \I1.sstate2l7r_net_1\, C
         => \I1.sstate2_ns_el2r_adt_net_8301_\, Y => 
        \I1.sstate2_ns_el2r\);
    
    \I5.UN1_RESCNT_G_1_1_289\ : AND3
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_1l0r\, B => 
        \I5.DWACT_ADD_CI_0_pog_array_2_1l0r\, C => \I5.G_net_1\, 
        Y => \I5.DWACT_ADD_CI_0_g_array_11_2l0r_adt_net_33417_\);
    
    \I1.SDAout_del1\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SDAout_del_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SDAout_del1_net_1\);
    
    \I2.REG_1_379\ : MUX2H
      port map(A => VDB_inl7r, B => REGl464r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_379_net_1\);
    
    \I2.VADml15r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl15r_net_1\, Y
         => \I2.VADml15r_net_1\);
    
    \I2.STATE1_ns_i_0l9r\ : OA21
      port map(A => \I2.REGMAP_i_0_il15r\, B => \I2.N_1729\, C
         => \I2.WRITES_net_1\, Y => \I2.STATE1_ns_i_0l9r_net_1\);
    
    \I2.REG_1l253r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_216_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl253r);
    
    \I1.sstate2l6r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2se_2_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstate2l6r_net_1\);
    
    \I2.VDBil12r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_588_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil12r_net_1\);
    
    \I2.VDBi_86_ivl12r\ : AO21TTF
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l12r_net_1\, C => \I2.VDBi_86_iv_2l12r_net_1\, 
        Y => \I2.VDBi_86l12r\);
    
    \I2.REG_1l181r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_171_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl181r);
    
    \I2.REG_1l445r_45\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_360_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL445R_29\);
    
    \I10.EVNT_NUMl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l5r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl5r_net_1\);
    
    \I2.STATE2_ns_0l3r\ : OA21
      port map(A => \I2.N_2821_0\, B => \I2.EVREAD_DS_net_1\, C
         => \I2.STATE2_i_0l3r\, Y => \I2.STATE2_ns_0l3r_net_1\);
    
    \I2.REGMAPl10r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un43_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl10r_net_1\);
    
    \I10.un3_bnc_cnt_I_114\ : AND2
      port map(A => \I10.DWACT_FINC_El13r\, B => 
        \I10.DWACT_FINC_El28r\, Y => \I10.N_9\);
    
    \I10.STATE1_ns_0_a2_0_1l10r\ : NOR2FT
      port map(A => \I10.STATE1L1R_14\, B => 
        \I10.READ_ADC_FLAG_net_1\, Y => \I10.N_2395_1\);
    
    \I2.PIPEA_8_rl5r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl5r, C => 
        \I2.PIPEA_8l5r_adt_net_57324_\, Y => \I2.PIPEA_8l5r\);
    
    \I2.PULSE_43_f0l7r\ : AND2FT
      port map(A => \I2.STATE1l6r_net_1\, B => 
        \I2.PULSE_43_f0l7r_adt_net_71087_\, Y => 
        \I2.PULSE_43_f0l7r_net_1\);
    
    \I2.REG_1_258\ : MUX2L
      port map(A => \I2.REGL295R_63\, B => VDB_inl30r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_258_net_1\);
    
    \I1.SBYTE_9_il4r\ : MUX2H
      port map(A => \I1.SBYTEl3r_net_1\, B => 
        \I1.COMMANDl12r_net_1\, S => \I1.N_625_0\, Y => 
        \I1.N_604\);
    
    \I10.EVENT_DWORD_134\ : MUX2H
      port map(A => \I10.EVENT_DWORDl1r_net_1\, B => 
        \I10.EVENT_DWORD_18l1r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_134_net_1\);
    
    \I3.un4_so_28_0\ : MUX2L
      port map(A => \I3.N_232\, B => \I3.N_221\, S => REGl126r, Y
         => \I3.N_224\);
    
    \I2.PIPEA1l25r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_536_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l25r_net_1\);
    
    \I2.un2_reg_ads_0_a3_0\ : OR2
      port map(A => \I2.VASl5r_net_1\, B => \I2.VASl3r_net_1\, Y
         => \I2.N_3061\);
    
    \I2.REG_1l418r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_333_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl418r);
    
    \I2.N_3024_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3024\, SET => 
        HWRES_c_2_0, Q => \I2.N_3024_Rd1__net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_1l1r\ : AO21TTF
      port map(A => \I10.N_2298\, B => \I10.N_2524_1\, C => 
        \I10.un2_i2c_chain_0_0_0_0_a2_4l1r_net_1\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_1_il1r\);
    
    \I2.VDBi_54_0_iv_2l9r\ : AOI21TTF
      port map(A => REGl178r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml162r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l9r_net_1\);
    
    \I3.un16_ae_38_1\ : OR2
      port map(A => \I3.un16_ae_2l47r\, B => \I3.un16_ae_1l46r\, 
        Y => \I3.un16_ae_1l38r\);
    
    \I2.un122_reg_ads_0_a2_0_a2_2\ : OR2FT
      port map(A => \I2.VASl2r_net_1\, B => \I2.N_3061\, Y => 
        \I2.N_3013_2\);
    
    \I10.EVNT_NUM_3_I_51\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_TMP_1l0r\, B => 
        \I10.EVNT_NUMl1r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_1_1l0r\);
    
    \I1.CHAIN_SELECT_24\ : MUX2H
      port map(A => \I1.CHAIN_SELECT_net_1\, B => 
        \I1.CHAIN_SELECT_4\, S => \I1.sstatel13r_net_1\, Y => 
        \I1.CHAIN_SELECT_24_net_1\);
    
    \I10.EVENT_DWORD_18_rl11r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l11r_net_1\, B => 
        \I10.EVENT_DWORD_18l11r_adt_net_27380_\, Y => 
        \I10.EVENT_DWORD_18l11r\);
    
    VDB_padl27r : IOB33PH
      port map(PAD => VDB(27), A => \I2.VDBml27r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl27r);
    
    \I10.un2_i2c_chain_0_i_i_i_a2_4l4r\ : AND2
      port map(A => \I10.CNTl0r_net_1\, B => \I10.CNTL2R_11\, Y
         => \I10.N_2525_i_adt_net_30597_\);
    
    \I2.VDBI_54_0_IV_1L11R_363\ : AND2
      port map(A => REG_cl244r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il11r_adt_net_45746_\);
    
    \I2.VDBi_24l19r\ : MUX2L
      port map(A => \I2.REGl493r\, B => \I2.VDBi_19l19r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l19r_net_1\);
    
    \I2.VDBi_54_0_iv_2l11r\ : AOI21TTF
      port map(A => REGl180r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml164r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l11r_net_1\);
    
    \I1.AIR_COMMANDl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_41_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl9r_net_1\);
    
    \I10.FID_8_rl29r\ : AND2FT
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.FID_8l29r_adt_net_20740_\, Y => \I10.FID_8l29r\);
    
    \I2.VDBm_0l24r\ : MUX2L
      port map(A => \I2.PIPEAl24r_net_1\, B => 
        \I2.PIPEBl24r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2065\);
    
    \I10.BNCRES_CNT_4_I_37\ : XOR2
      port map(A => \I10.BNCRES_CNTl3r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_12_0l0r\, Y => 
        \I10.BNCRES_CNT_4l3r\);
    
    \I5.SBYTE_5l0r\ : MUX2H
      port map(A => F_SO_c, B => REGl81r, S => 
        \I5.sstatel5r_net_1\, Y => \I5.SBYTE_5l0r_net_1\);
    
    \I2.PIPEA1l9r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_520_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l9r_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_x3l5r\ : XOR2
      port map(A => \I10.CNTl5r_net_1\, B => \I10.CNTl1r_net_1\, 
        Y => \I10.N_2295_i_0\);
    
    \I2.REG_ml113r\ : NAND2
      port map(A => REGl113r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.REG_ml113r_net_1\);
    
    AE_PDL_padl1r : OB33PH
      port map(PAD => AE_PDL(1), A => AE_PDL_cl1r);
    
    \I8.SWORD_5l8r\ : MUX2L
      port map(A => REGl257r, B => \I8.SWORDl7r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l8r_net_1\);
    
    \I2.VDBi_577\ : MUX2L
      port map(A => \I2.VDBil1r_net_1\, B => \I2.VDBi_86l1r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_577_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l31r\ : OR2
      port map(A => LB_inl31r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119373__net_1\, 
        Y => \I2.N_3016\);
    
    \I10.CRC32_100\ : MUX2H
      port map(A => \I10.CRC32l13r_net_1\, B => \I10.N_1356\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_100_net_1\);
    
    VAD_padl25r : OTB33PH
      port map(PAD => VAD(25), A => \I2.VADml25r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I2.REG3l6r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_113_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl6r);
    
    \I10.UN3_BNC_CNT_I_118_156\ : AND3
      port map(A => \I10.BNC_CNT_i_il14r\, B => 
        \I10.DWACT_FINC_El7r\, C => 
        \I10.DWACT_FINC_El9r_adt_net_18912_\, Y => 
        \I10.DWACT_FINC_El13r_adt_net_18968_\);
    
    \I10.FID_181\ : MUX2L
      port map(A => \I10.FID_8l16r\, B => \I10.FIDl16r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_181_net_1\);
    
    \I2.REG_1l461r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_376_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REGl461r);
    
    \I2.REG_1l136r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_138_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl136r);
    
    \I2.REG_1_136\ : MUX2H
      port map(A => REG_cl134r, B => VDB_inl13r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_136_net_1\);
    
    \I10.CRC32_3_0_a2_i_0l0r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2342_i_i_0\, Y => \I10.N_1722\);
    
    \I10.REG_1l34r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I66_Y\, 
        CLR => CLEAR_0_0, Q => REGl34r);
    
    \I8.SWORD_6\ : MUX2H
      port map(A => \I8.SWORDl5r_net_1\, B => 
        \I8.SWORD_5l5r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_6_net_1\);
    
    \I10.FID_4_0_a2l8r\ : XOR2
      port map(A => \I10.CRC32l4r_net_1\, B => 
        \I10.FID_4_0_a2_0l8r_net_1\, Y => \I10.FID_4l8r\);
    
    \I2.VDBm_0l10r\ : MUX2L
      port map(A => \I2.PIPEAl10r_net_1\, B => 
        \I2.PIPEBl10r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2051\);
    
    \I10.FID_8_rl16r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l16r_adt_net_22788_\, Y => \I10.FID_8l16r\);
    
    \I2.VDBi_24l7r\ : MUX2L
      port map(A => \I2.REGl481r\, B => \I2.VDBi_19l7r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l7r_net_1\);
    
    \I2.VDBil23r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_599_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil23r_net_1\);
    
    \I2.REG_1_443\ : MUX2H
      port map(A => VDB_inl22r, B => REGl70r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_443_net_1\);
    
    \I2.un1_STATE5_2_i_a3_0_a2_0_a2_1\ : NOR2
      port map(A => \I2.STATE5L1R_RD1__113\, B => 
        \I2.STATE5l4r_net_1\, Y => \I2.N_3021_1\);
    
    \I2.PIPEA1_525\ : MUX2L
      port map(A => \I2.PIPEA1l14r_net_1\, B => \I2.N_2525\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_525_net_1\);
    
    \I10.FID_8_IV_0_0_0_0L15R_188\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.N_2312_i_0_i\, 
        Y => \I10.FID_8_iv_0_0_0_0_il15r_adt_net_22871_\);
    
    \I5.sstatel2r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.sstatel3r_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.sstatel2r_net_1\);
    
    \I10.FID_8_iv_0_0_0_x3l13r\ : XOR2FT
      port map(A => \I10.CRC32l9r_net_1\, B => 
        \I10.CRC32l21r_net_1\, Y => \I10.N_2310_i_0_i\);
    
    \I2.VDBi_56l7r\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l7r_net_1\, C => \I2.VDBi_54_0_iv_5_il7r\, Y
         => \I2.VDBi_56l7r_adt_net_49002_\);
    
    \I10.BNC_NUMBER_0_sqmuxa_0_a2\ : NOR2FT
      port map(A => BNC_RES, B => \I10.un6_bnc_res_NE_0_net_1\, Y
         => \I10.BNC_NUMBER_0_sqmuxa\);
    
    \I2.LB_il17r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il17r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il17r_Rd1__net_1\);
    
    \I2.LB_i_494\ : MUX2L
      port map(A => \I2.LB_il16r_Rd1__net_1\, B => 
        \I2.LB_i_7l16r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__83\, Y => \I2.LB_il16r\);
    
    \I2.PIPEA1_514\ : MUX2L
      port map(A => \I2.PIPEA1l3r_net_1\, B => \I2.N_2503\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_514_net_1\);
    
    \I5.DRIVE_RELOAD_3\ : OAI21FTF
      port map(A => \I5.DRIVE_RELOAD_net_1\, B => REGl80r, C => 
        PULSEl10r, Y => \I5.DRIVE_RELOAD_3_net_1\);
    
    \I2.VDBi_594\ : MUX2L
      port map(A => \I2.VDBil18r_net_1\, B => \I2.VDBi_86l18r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_594_net_1\);
    
    \I2.REG_1_339\ : MUX2L
      port map(A => REGl424r, B => VDB_inl31r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_339_net_1\);
    
    \I10.FIDl16r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_181_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl16r_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2l6r\ : NAND3FTT
      port map(A => \I10.CNTL2R_11\, B => \I10.N_2295_i_0\, C => 
        \I10.N_2377_2\, Y => \I10.N_2373\);
    
    \I10.FID_8_iv_0_0_0_x3l15r\ : XOR2FT
      port map(A => \I10.CRC32l11r_net_1\, B => 
        \I10.CRC32l23r_net_1\, Y => \I10.N_2312_i_0_i\);
    
    \I3.un16_ae_30_1\ : OR2
      port map(A => REGl127r, B => REGl122r, Y => 
        \I3.un16_ae_1l30r\);
    
    \I2.REG_1_447\ : MUX2H
      port map(A => VDB_inl26r, B => REGl74r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_447_net_1\);
    
    \I2.PIPEA_8_RL22R_431\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l22r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l22r_adt_net_56097_\);
    
    \I2.REG_1_340\ : MUX2L
      port map(A => REGl425r, B => VDB_inl0r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_340_net_1\);
    
    \I8.sstatel0r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.sstate_ns_il0r_net_1\, CLR
         => HWRES_c_2_0, Q => \I8.sstatel0r_net_1\);
    
    \I2.REG_1_196\ : MUX2L
      port map(A => SYNC_cl0r, B => VDB_inl0r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_196_net_1\);
    
    \I1.sstate2se_7_i\ : MUX2L
      port map(A => \I1.sstate2l1r_net_1\, B => 
        \I1.sstate2l2r_net_1\, S => \I1.N_277_0\, Y => 
        \I1.sstate2se_7_i_net_1\);
    
    \I2.REG_1_210\ : MUX2L
      port map(A => REG_cl247r, B => VDB_inl14r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_210_net_1\);
    
    \I2.REGMAPl23r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un78_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAP_i_il23r\);
    
    \I2.un1_vsel_1_i_a2\ : NOR3FFT
      port map(A => \I2.N_2892_1\, B => \I2.N_2892_2\, C => 
        \I2.un1_vsel_1_i_a2_1_i\, Y => \I2.N_2887_i_i\);
    
    \I2.PIPEAl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_552_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl8r_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l4r\ : XOR2FT
      port map(A => \I10.CRC32l4r_net_1\, B => 
        \I10.EVENT_DWORDl4r_net_1\, Y => \I10.N_2323_i_i_0\);
    
    \I3.un16_ae_45_1\ : NAND2FT
      port map(A => REGl123r, B => REGl124r, Y => 
        \I3.un16_ae_1l45r\);
    
    \I3.SBYTE_5l4r\ : MUX2H
      port map(A => REG_cl133r, B => REGl140r, S => 
        \I3.sstatel0r_net_1\, Y => \I3.SBYTE_5l4r_net_1\);
    
    VAD_padl14r : IOB33PH
      port map(PAD => VAD(14), A => \I2.VADml14r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl14r);
    
    \I2.un756_regmap_11_0\ : OR2
      port map(A => \I2.un756_regmap_8_0_i\, B => 
        \I2.un756_regmap_11_0_i_adt_net_36347_\, Y => 
        \I2.un756_regmap_11_0_i\);
    
    \I2.REGMAPl19r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un64_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl19r_net_1\);
    
    \I3.SBYTE_6\ : MUX2L
      port map(A => REGl140r, B => \I3.SBYTE_5l3r_net_1\, S => 
        \I3.N_167\, Y => \I3.SBYTE_6_0\);
    
    \I2.REG_1_245\ : MUX2L
      port map(A => \I2.REGL282R_50\, B => VDB_inl17r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_245_net_1\);
    
    \I2.VDBi_67_0l15r\ : MUX2L
      port map(A => \I2.REGl440r\, B => \I2.REGl456r\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1964\);
    
    \I2.REG_1_318\ : MUX2L
      port map(A => REGl403r, B => VDB_inl10r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_318_net_1\);
    
    \I10.un2_evread_3_i_0_a2_0_2\ : AND2FT
      port map(A => REGl46r, B => REGl32r, Y => 
        \I10.un2_evread_3_i_0_a2_0_2_net_1\);
    
    \I10.CRC32l5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_92_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l5r_net_1\);
    
    \I2.VDBi_85_ml1r\ : NAND3
      port map(A => \I2.VDBil1r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml1r_net_1\);
    
    \I2.REG_1l494r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_409_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl494r\);
    
    \I2.PIPEBl24r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_73_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl24r_net_1\);
    
    \I10.EVNT_NUMl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l1r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl1r_net_1\);
    
    \I2.REG_1_399\ : MUX2H
      port map(A => VDB_inl10r, B => \I2.REGl484r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_399_net_1\);
    
    \I2.VDBi_54_0_iv_5l3r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il3r\, B => 
        \I2.VDBi_54_0_iv_0_il3r\, C => \I2.VDBi_54_0_iv_1_il3r\, 
        Y => \I2.VDBi_54_0_iv_5_il3r\);
    
    \I2.PIPEB_4_il27r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl27r, Y => \I2.N_2623\);
    
    \I1.sstatel9r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstatese_3_i_0_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstatel9r_net_1\);
    
    \I2.NRDMEBI_543_474\ : AND3FTT
      port map(A => \I2.N_2368\, B => 
        \I2.un1_NRDMEBi_2_sqmuxa_2_adt_net_57879_\, C => 
        \I2.NRDMEBi_543_adt_net_100728_\, Y => 
        \I2.NRDMEBi_543_adt_net_57947_\);
    
    \I1.I2C_RDATAl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_15_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl1r);
    
    \I2.REG_1_153\ : MUX2L
      port map(A => REGl163r, B => VDB_inl10r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_153_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_0l2r\ : NOR3FTT
      port map(A => \I10.un2_i2c_chain_0_i_0_0_i_1l2r_net_1\, B
         => \I10.un2_i2c_chain_0_i_0_0_2_il2r\, C => 
        \I10.un2_i2c_chain_0_i_0_0_3_il2r\, Y => \I10.N_589_i_0\);
    
    \I10.EVENT_DWORDl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_137_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl4r_net_1\);
    
    \I10.BNCRES_CNT_4_I_38\ : XOR2
      port map(A => \I10.BNCRES_CNTl6r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_11l0r\, Y => 
        \I10.BNCRES_CNT_4l6r\);
    
    \I2.LB_s_39\ : MUX2L
      port map(A => \I2.LB_sl25r_Rd1__net_1\, B => 
        \I2.N_3034_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116348_Rd1__net_1\, Y => 
        \I2.LB_sl25r\);
    
    \I2.un1_TCNT_1_I_21\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_pog_array_0_2l0r\, B => 
        \I2.DWACT_ADD_CI_0_g_array_12_4l0r\, Y => \I2.I_21_0\);
    
    \I1.COMMAND_2\ : MUX2H
      port map(A => \I1.COMMANDl1r_net_1\, B => 
        \I1.COMMAND_4l1r_net_1\, S => \I1.SSTATEL13R_8\, Y => 
        \I1.COMMAND_2_net_1\);
    
    \I10.EVNT_NUMl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l7r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl7r_net_1\);
    
    \I2.REGMAPl30r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un110_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl30r_net_1\);
    
    \I2.un14_tcnt3\ : NOR3FTT
      port map(A => \I2.un11_tcnt2_net_1\, B => 
        \I2.un14_tcnt3_4_i\, C => \I2.un14_tcnt3_5_i\, Y => 
        \I2.un14_tcnt3_net_1\);
    
    LB_padl8r : IOB33PH
      port map(PAD => LB(8), A => \I2.LB_il8r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl8r);
    
    \I10.BNCRES_CNT_4_G_2\ : NAND2
      port map(A => BNC_RES, B => \I10.BNCRES_CNTl1r_net_1\, Y
         => \I10.G_2_i_adt_net_16541_\);
    
    \I2.VDBI_54_0_IV_0L5R_389\ : AND2
      port map(A => \I2.REGMAP_i_il17r\, B => REGl142r, Y => 
        \I2.VDBi_54_0_iv_0_il5r_adt_net_50518_\);
    
    \I2.STATE5_ns_i_i_a2_0_1l0r_115\ : NOR2
      port map(A => \I2.STATE5L1R_RD1__110\, B => 
        \I2.STATE5L1R_114\, Y => \I2.N_2386_1_99\);
    
    \I2.REG_1_162\ : MUX2L
      port map(A => REGl172r, B => VDB_inl3r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_162_net_1\);
    
    \I2.TCNT_i_il1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.TCNT_10l1r\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.TCNT_i_il1r_net_1\);
    
    \I10.FID_8_RL30R_161\ : OA21FTF
      port map(A => \I10.STATE1l11r_net_1\, B => REGl78r, C => 
        \I10.STATE1l12r_net_1\, Y => 
        \I10.FID_8l30r_adt_net_20661_\);
    
    \I2.VDBI_54_0_IV_1L0R_418\ : AND2
      port map(A => REGl249r, B => \I2.REGMAPl24r_net_1\, Y => 
        \I2.VDBi_54_0_iv_1_il0r_adt_net_54961_\);
    
    \I10.un2_i2c_chain_0_i_0_6l5r\ : OR2
      port map(A => \I10.un2_i2c_chain_0_i_0_4_il5r\, B => 
        \I10.un2_i2c_chain_0_i_0_6_il5r_adt_net_30266_\, Y => 
        \I10.un2_i2c_chain_0_i_0_6_il5r\);
    
    \I2.VDBi_54_0_iv_5l15r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il15r\, B => 
        \I2.VDBi_54_0_iv_0_il15r\, C => \I2.VDBi_54_0_iv_1_il15r\, 
        Y => \I2.VDBi_54_0_iv_5_il15r\);
    
    \I2.VDBi_59l10r\ : AND2FT
      port map(A => \I2.VDBi_59_0l9r\, B => 
        \I2.VDBi_59l10r_adt_net_46576_\, Y => 
        \I2.VDBi_59l10r_net_1\);
    
    VDB_padl9r : IOB33PH
      port map(PAD => VDB(9), A => \I2.VDBml9r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl9r);
    
    \I2.REGMAPl18r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un61_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl18r_net_1\);
    
    \I2.PIPEA_559\ : MUX2L
      port map(A => \I2.PIPEAl15r_net_1\, B => \I2.PIPEA_8l15r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_559_net_1\);
    
    \I10.FIDl29r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_194_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl29r_net_1\);
    
    \I5.RESCNTl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l0r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl0r_net_1\);
    
    \I2.REG_1l452r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_367_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl452r\);
    
    \I2.VDBI_67L6R_386\ : AND2FT
      port map(A => \I2.N_1965\, B => \I2.N_1955\, Y => 
        \I2.VDBi_67l6r_adt_net_49916_\);
    
    \I2.STATE1_nsl2r\ : OAI21FTF
      port map(A => \I2.N_1885_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_ns_1l2r_net_1\, Y => \I2.STATE1_nsl2r_net_1\);
    
    \I10.BNC_NUMBER_230\ : MUX2L
      port map(A => \I10.BNCRES_CNTl0r_net_1\, B => 
        \I10.BNC_NUMBERl0r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_230_net_1\);
    
    \I10.BNC_CNT_200\ : MUX2H
      port map(A => \I10.BNC_CNTl2r_net_1\, B => 
        \I10.BNC_CNT_4l2r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_200_net_1\);
    
    \I3.un16_ae_40\ : NOR2
      port map(A => \I3.un16_ae_3l47r\, B => \I3.un16_ae_1l40r\, 
        Y => \I3.un16_ael40r\);
    
    \I2.REG_1_371_e_0\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl32r_net_1\, Y => \I2.N_3527_i_0\);
    
    \I5.SSTATE_NSL0R_292\ : AO21FTF
      port map(A => \I5.sstatel1r_net_1\, B => 
        \I5.sstatel0r_net_1\, C => \I5.ISI_0_sqmuxa\, Y => 
        \I5.sstate_nsl0r_adt_net_33840_\);
    
    \I1.DATA_12l12r\ : MUX2H
      port map(A => \I1.SBYTEl4r_net_1\, B => REGl117r, S => 
        \I1.DATA_1_sqmuxa_2\, Y => \I1.DATA_12l12r_net_1\);
    
    \I10.EVNT_NUMl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l10r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl10r_net_1\);
    
    \I2.un1_TCNT_1_I_24\ : OA21
      port map(A => \I2.TCNTl2r_net_1\, B => 
        \I2.TCNT_i_il3r_net_1\, C => \I2.N_1885_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_1_1_0l0r\);
    
    \I10.FID_4_0_a2_0l9r\ : XOR2
      port map(A => \I10.CRC32l17r_net_1\, B => 
        \I10.CRC32l29r_net_1\, Y => \I10.FID_4_0_a2_0l9r_net_1\);
    
    \I2.VADml14r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl14r_net_1\, Y
         => \I2.VADml14r_net_1\);
    
    \I2.PIPEA_8_sl29r\ : OR2FT
      port map(A => \I2.N_2830_4\, B => 
        \I2.PIPEA_8l29r_adt_net_55591_\, Y => \I2.PIPEA_8l29r\);
    
    \I10.FID_8_IV_0_0_0_0L6R_206\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.FID_4_il6r\, Y
         => \I10.FID_8_iv_0_0_0_0_il6r_adt_net_23986_\);
    
    \I2.N_3021_1_adt_net_116356_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3021_1\, SET => 
        HWRES_c_2_0, Q => \I2.N_3021_1_adt_net_116356_Rd1__net_1\);
    
    \I2.VDBi_1_sqmuxa_1_0_a3_1\ : NOR2FT
      port map(A => \I2.STATE1l8r_net_1\, B => \I2.N_1782\, Y => 
        \I2.VDBi_1_sqmuxa_1_1\);
    
    \I2.NOEDTKi_103\ : OAI21FTF
      port map(A => TST_C_CL3R_23, B => 
        \I2.un1_STATE1_25_adt_net_74991_\, C => 
        \I2.un1_STATE1_17\, Y => \I2.NOEDTKi_103_net_1\);
    
    \I10.CNT_0l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CNT_10_i_0l0r_net_1\, CLR
         => CLEAR_0_0, Q => \I10.CNTL0R_9\);
    
    \I10.FID_8_iv_0_0_0_1l23r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl23r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il23r_adt_net_21601_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il23r\);
    
    \I2.PIPEA_8_RL14R_439\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l14r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l14r_adt_net_56657_\);
    
    LB_padl12r : IOB33PH
      port map(PAD => LB(12), A => \I2.LB_il12r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl12r);
    
    \I2.VDBi_67l3r\ : OA21
      port map(A => \I2.VDBi_61l3r_adt_net_52281_\, B => 
        \I2.VDBi_61l3r_adt_net_52283_\, C => \I2.N_1965\, Y => 
        \I2.VDBi_67l3r_adt_net_52323_\);
    
    \I10.OR_RADDR_223\ : MUX2H
      port map(A => \I10.CNTl5r_net_1\, B => 
        \I10.OR_RADDRl5r_net_1\, S => \I10.N_2126\, Y => 
        \I10.OR_RADDR_223_net_1\);
    
    \I8.SWORD_2\ : MUX2H
      port map(A => \I8.SWORDl1r_net_1\, B => 
        \I8.SWORD_5l1r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_2_net_1\);
    
    \I2.REG_1l291r_75\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_254_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL291R_59\);
    
    \I3.AEl10r\ : MUX2L
      port map(A => REGl163r, B => \I3.un16_ael10r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl10r);
    
    \I10.FID_8_IV_0_0_0_0L11R_196\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.FID_4_il11r\, Y
         => \I10.FID_8_iv_0_0_0_0_il11r_adt_net_23359_\);
    
    \I5.SSTATE_NS_IL4R_291\ : OAI21TTF
      port map(A => \I5.N_211_0\, B => PULSEl6r, C => 
        \I5.sstatel1r_net_1\, Y => 
        \I5.sstate_ns_il4r_adt_net_33659_\);
    
    \I2.VDBi_86_ivl6r\ : OR3
      port map(A => \I2.VDBi_86_iv_1_il6r\, B => 
        \I2.VDBi_86_iv_0_il6r\, C => \I2.VDBi_67_m_il6r\, Y => 
        \I2.VDBi_86l6r\);
    
    \I2.un7_ronly_0_a2_0_a2_2_1\ : OR2
      port map(A => \I2.VAS_i_0_il11r\, B => \I2.VASl12r_net_1\, 
        Y => \I2.un7_ronly_0_a2_0_a2_2_1_i\);
    
    \I2.un1_STATE5_9_0_1_109\ : OR3
      port map(A => \I2.STATE5L1R_RD1__112\, B => \I2.N_2389_97\, 
        C => \I2.STATE5L0R_111\, Y => \I2.UN1_STATE5_9_0_1_I_93\);
    
    \I2.PIPEA_560\ : MUX2L
      port map(A => \I2.PIPEAl16r_net_1\, B => \I2.PIPEA_8l16r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_560_net_1\);
    
    \I2.VDBi_589\ : MUX2L
      port map(A => \I2.VDBil13r_net_1\, B => \I2.VDBi_86l13r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_589_net_1\);
    
    \I1.AIR_COMMAND_39\ : MUX2L
      port map(A => \I1.AIR_COMMANDl2r_net_1\, B => 
        \I1.AIR_COMMAND_21l2r_net_1\, S => \I1.un1_tick_12_net_1\, 
        Y => \I1.AIR_COMMAND_39_net_1\);
    
    \I2.LB_il4r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il4r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il4r_Rd1__net_1\);
    
    \I10.EVENT_DWORD_144\ : MUX2H
      port map(A => \I10.EVENT_DWORDl11r_net_1\, B => 
        \I10.EVENT_DWORD_18l11r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_144_net_1\);
    
    \I2.PIPEA_8_sl28r\ : OR2FT
      port map(A => \I2.N_2830_4\, B => 
        \I2.PIPEA_8l28r_adt_net_55675_\, Y => \I2.PIPEA_8l28r\);
    
    \I10.REG_1l37r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I69_Y\, 
        CLR => CLEAR_0_0, Q => \I10.REGl37r\);
    
    \I2.REG_1l456r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_371_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl456r\);
    
    \I3.un1_BITCNT_I_13\ : XOR2
      port map(A => \I3.DWACT_ADD_CI_0_TMPl0r\, B => 
        \I3.BITCNTl1r_net_1\, Y => \I3.I_13_3\);
    
    \I2.LB_i_500\ : MUX2L
      port map(A => \I2.LB_il22r_Rd1__net_1\, B => 
        \I2.LB_i_7l22r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__80\, Y => \I2.LB_il22r\);
    
    \I10.CNTl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CNT_10_i_0l1r_net_1\, CLR
         => CLEAR_0_0, Q => \I10.CNTl1r_net_1\);
    
    \I2.un1_tcnt1_I_9\ : XOR2
      port map(A => \I2.TCNT1_i_0_il2r_net_1\, B => \I2.N_15\, Y
         => \I2.I_9_0\);
    
    \I8.sstate_ns_0_x2l1r\ : XOR2
      port map(A => \I8.sstatel1r_net_1\, B => 
        \I8.sstatel0r_net_1\, Y => \I8.N_207_i\);
    
    \I2.VDBi_56l29r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l29r_net_1\, Y => \I2.VDBi_56l29r_net_1\);
    
    \I2.VDBi_86_0_iv_0_m3_0l19r\ : MUX2L
      port map(A => LBSP_inl19r, B => \I2.VDBi_56l19r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.N_2855\);
    
    \I2.REG_1l480r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_395_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl480r\);
    
    VAD_padl11r : IOB33PH
      port map(PAD => VAD(11), A => \I2.VADml11r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl11r);
    
    \I3.un4_so_5_0\ : MUX2L
      port map(A => \I3.N_200\, B => \I3.N_198\, S => REGL127R_3, 
        Y => \I3.N_201\);
    
    \I2.VDBi_605\ : MUX2L
      port map(A => \I2.VDBil29r_net_1\, B => \I2.VDBi_86l29r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_605_net_1\);
    
    \I2.TCNT1_i_0_il2r\ : DFF
      port map(CLK => CLKOUT, D => \I2.I_9_0\, Q => 
        \I2.TCNT1_i_0_il2r_net_1\);
    
    \I2.un11_tcnt2_2\ : OR2
      port map(A => \I2.TCNT2_i_0_il2r_net_1\, B => 
        \I2.TCNT2l3r_net_1\, Y => \I2.un11_tcnt2_2_i\);
    
    \I2.VDBI_54_0_IV_1L15R_347\ : AND2
      port map(A => REG_cl248r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il15r_adt_net_42730_\);
    
    \I2.un1_tcnt1_I_16\ : AND2
      port map(A => \I2.TCNT1_i_0_il2r_net_1\, B => \I2.N_15\, Y
         => \I2.DWACT_FINC_El0r\);
    
    \I10.EVENT_DWORDl29r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_162_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl29r_net_1\);
    
    \I10.EVENT_DWORD_18_RL11R_253\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl21r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l11r_adt_net_27380_\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I37_Y_i\ : OAI21
      port map(A => \I10.REGl36r\, B => \I10.REGl37r\, C => 
        \I10.N_2519_1\, Y => \I10.N263_i\);
    
    \I2.un50_reg_ads_0_a2_0_a2\ : NOR3FTT
      port map(A => \I2.WRITES_net_1\, B => \I2.N_3005_1\, C => 
        \I2.N_2995_1\, Y => \I2.un50_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0l25r\ : OAI21TTF
      port map(A => I2C_RDATAl5r, B => \I10.N_2639\, C => 
        \I10.EVENT_DWORD_18_i_0_0l25r_adt_net_25530_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0l25r_net_1\);
    
    \I2.PULSE_43_f0l0r\ : OA21TTF
      port map(A => PULSEl0r, B => \I2.REGMAPl3r_net_1\, C => 
        \I2.STATE1l6r_net_1\, Y => \I2.PULSE_43l0r\);
    
    \I1.sstate2_0_sqmuxa_0_a3\ : NAND2
      port map(A => REGl105r, B => \I1.sstate2l6r_net_1\, Y => 
        \I1.sstate2_0_sqmuxa\);
    
    \I2.VDBI_17_0L3R_400\ : AND2FT
      port map(A => \I10.REGl35r\, B => \I2.REGMAPl6r_net_1\, Y
         => \I2.N_1900_adt_net_51890_\);
    
    \I2.VDBi_17_0l12r\ : AND2
      port map(A => REG_i_0l44r, B => \I2.REGMAPl6r_net_1\, Y => 
        \I2.N_1909_adt_net_44714_\);
    
    \I2.REG_1_316\ : MUX2L
      port map(A => REGl401r, B => VDB_inl8r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_316_net_1\);
    
    \I5.un1_RESCNT_G_1\ : AND2
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_2l0r\, B => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r_adt_net_33510_\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_3l0r\);
    
    \I1.SDAnoe_del1\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SDAnoe_del_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SDAnoe_del1_net_1\);
    
    \I2.TCNT3_2_I_1\ : AND2
      port map(A => \I2.TCNT3_i_0_il0r_net_1\, B => 
        \I2.TICKl1r_net_1\, Y => \I2.DWACT_ADD_CI_0_TMP_0l0r\);
    
    SELCLK_pad : OB33PH
      port map(PAD => SELCLK, A => NSELCLK_c_i_0);
    
    \I2.VDBI_59L9R_372\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l9r_net_1\, C => \I2.VDBi_54_0_iv_5_il9r\, Y
         => \I2.VDBi_59l9r_adt_net_47330_\);
    
    VDB_padl22r : IOB33PH
      port map(PAD => VDB(22), A => \I2.VDBml22r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl22r);
    
    \I2.TCNT2_2_I_19\ : XOR2
      port map(A => TICKl0r, B => \I2.TCNT2_i_0_il0r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_partial_sum_0l0r\);
    
    \I10.BNCRES_CNT_4_G_147\ : AND3FFT
      port map(A => \I10.G_1_1_2_i\, B => 
        \I10.G_2_i_adt_net_16541_\, C => 
        \I10.DWACT_ADD_CI_0_pog_array_1_0l0r\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_11l0r_adt_net_16569_\);
    
    \I2.REGMAPl12r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un50_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl12r_net_1\);
    
    \I8.SWORDl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_1_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl0r_net_1\);
    
    \I10.OR_RADDRl3r\ : DFF
      port map(CLK => CLKOUT, D => \I10.OR_RADDR_221_net_1\, Q
         => \I10.OR_RADDRl3r_net_1\);
    
    \I10.FID_8_RL12R_195\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl12r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il12r\, Y => 
        \I10.FID_8l12r_adt_net_23276_\);
    
    \I2.REG_1l499r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_414_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl499r\);
    
    \I2.VDBi_86_ivl14r\ : AO21TTF
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l14r_net_1\, C => \I2.VDBi_86_iv_2l14r_net_1\, 
        Y => \I2.VDBi_86l14r\);
    
    \I1.AIR_COMMAND_43\ : MUX2L
      port map(A => \I1.AIR_COMMANDl11r_net_1\, B => 
        \I1.AIR_COMMAND_21l11r\, S => \I1.un1_tick_12_net_1\, Y
         => \I1.AIR_COMMAND_43_net_1\);
    
    \I2.PIPEBl29r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEB_78_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEBl29r_net_1\);
    
    \I10.FIDl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_166_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl1r_net_1\);
    
    \I2.VASl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_87_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl5r_net_1\);
    
    \I3.un4_so_37_0\ : MUX2L
      port map(A => SP_PDL_inl43r, B => SP_PDL_inl11r, S => 
        REGl127r, Y => \I3.N_233\);
    
    \I2.REG_1l158r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_148_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl158r);
    
    \I2.LB_i_7l12r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l12r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l12r_Rd1__net_1\);
    
    \I10.CRC32_3_i_0_x3l25r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl25r_net_1\, B => 
        \I10.CRC32l25r_net_1\, Y => \I10.N_2340_i_i_0\);
    
    NSELCLK_pad : OB33PH
      port map(PAD => NSELCLK, A => NSELCLK_c);
    
    \I2.un1_STATE5_8_i_a2_0_1\ : AND2
      port map(A => \I2.SINGCYC_net_1\, B => 
        \I2.REGMAPl35r_net_1\, Y => \I2.N_2310_1\);
    
    RSELC0_pad : OTB33PH
      port map(PAD => RSELC0, A => REGl428r, EN => REG_i_0l444r);
    
    \I8.un1_BITCNT_I_15\ : XOR2
      port map(A => \I8.DWACT_ADD_CI_0_TMPl0r\, B => 
        \I8.BITCNTl1r_net_1\, Y => \I8.I_15\);
    
    \I10.un3_bnc_cnt_I_76\ : AND3
      port map(A => \I10.BNC_CNT_i_il12r\, B => 
        \I10.DWACT_FINC_El7r\, C => \I10.DWACT_FINC_El28r\, Y => 
        \I10.N_36\);
    
    VDB_padl26r : IOB33PH
      port map(PAD => VDB(26), A => \I2.VDBml26r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl26r);
    
    \I1.I_212_0_a2\ : AND2
      port map(A => \I1.COMMANDl2r_net_1\, B => 
        \I1.sstatel0r_net_1\, Y => \I1.N_690\);
    
    \I1.AIR_COMMANDl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_40_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl8r_net_1\);
    
    \I1.sstatel8r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el5r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstatel8r_net_1\);
    
    \I2.PIPEB_61\ : MUX2H
      port map(A => \I2.PIPEBl12r_net_1\, B => \I2.N_2593\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_61_net_1\);
    
    \I8.BITCNT_6_rl3r\ : OA21
      port map(A => \I8.N_219\, B => \I8.I_17\, C => 
        \I8.SWORD_0_sqmuxa\, Y => \I8.BITCNT_6l3r\);
    
    \I1.un1_tick_10_0_a2\ : OA21
      port map(A => \I1.sstate_i_0_il3r\, B => 
        \I1.sstatel6r_net_1\, C => TICKl0r, Y => \I1.N_468\);
    
    \I2.VDBi_86_ivl10r\ : AO21TTF
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l10r_net_1\, C => \I2.VDBi_86_iv_2l10r_net_1\, 
        Y => \I2.VDBi_86l10r\);
    
    \I2.un1_STATE2_10_i_0\ : OA21FTT
      port map(A => \I2.STATE2l1r_net_1\, B => 
        \I2.STATE2l2r_net_1\, C => \I2.N_2895_i\, Y => 
        \I2.un1_STATE2_10_i_0_i\);
    
    \I1.COMMAND_4l14r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl14r_net_1\, B => REGl103r, S
         => REGl7r, Y => \I1.COMMAND_4l14r_net_1\);
    
    \I2.REG_1_sqmuxa_1_0_a3\ : NAND2
      port map(A => \I2.STATE1l7r_net_1\, B => 
        \I2.REGMAPl10r_net_1\, Y => \I2.REG_1_sqmuxa_1\);
    
    \I10.FID_4_0_a2l9r\ : XOR2
      port map(A => \I10.CRC32l5r_net_1\, B => 
        \I10.FID_4_0_a2_0l9r_net_1\, Y => \I10.FID_4l9r\);
    
    \I2.PIPEBl25r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_74_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl25r_net_1\);
    
    \I2.VASl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_95_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VAS_i_0_il13r\);
    
    \I10.FID_8_iv_0_0_0_0l28r\ : AO21
      port map(A => \I10.STATE1l11r_net_1\, B => REGl76r, C => 
        \I10.STATE1l2r_net_1\, Y => \I10.FID_8_iv_0_0_0_0_il28r\);
    
    \I2.LB_i_7l18r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l18r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l18r_Rd1__net_1\);
    
    \I10.CRC32_3_i_0_0l17r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2315_i_i_0\, Y => \I10.N_1037\);
    
    \I10.CRC32l23r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_110_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l23r_net_1\);
    
    LB_padl7r : IOB33PH
      port map(PAD => LB(7), A => \I2.LB_il7r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl7r);
    
    \I3.un1_BITCNT_I_14\ : XOR2
      port map(A => \I3.DWACT_ADD_CI_0_g_array_1l0r\, B => 
        \I3.BITCNTl2r_net_1\, Y => \I3.I_14_1\);
    
    \I2.VDBml14r\ : MUX2L
      port map(A => \I2.VDBil14r_net_1\, B => \I2.N_2055\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml14r_net_1\);
    
    \I10.CRC32l7r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_94_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l7r_net_1\);
    
    \I2.REG_1_0l123r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_125_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGL123R_6);
    
    SP_PDL_padl8r : IOB33PH
      port map(PAD => SP_PDL(8), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl8r);
    
    NLBRD_pad : OB33PH
      port map(PAD => NLBRD, A => \NLBRD_c\);
    
    \I2.VDBi_54_0_iv_3l7r\ : AO21TTF
      port map(A => \I2.REGMAPl16r_net_1\, B => \I2.REGl128r\, C
         => \I2.VDBi_54_0_iv_2l7r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il7r\);
    
    \I2.un110_reg_ads_0_a2_0_a2_1\ : NAND3FFT
      port map(A => \I2.LWORDS_net_1\, B => \I2.N_3067\, C => 
        \I2.VASl2r_net_1\, Y => \I2.un110_reg_ads_0_a2_0_a2_1_i\);
    
    \I2.REG_1_151\ : MUX2L
      port map(A => REGl161r, B => VDB_inl8r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_151_net_1\);
    
    \I2.VDBi_67_0l9r\ : MUX2L
      port map(A => \I2.REGl434r\, B => \I2.REGl450r\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1958\);
    
    \I2.VDBi_61l11r\ : MUX2L
      port map(A => LBSP_inl11r, B => \I2.VDBi_59l11r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l11r_net_1\);
    
    \I2.un37_reg_ads_0_a2_0_a2\ : AND2
      port map(A => \I2.N_3006_2\, B => 
        \I2.un37_reg_ads_0_a2_0_a2_adt_net_37774_\, Y => 
        \I2.un37_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.CHIP_ADDRl0r\ : DFF
      port map(CLK => CLKOUT, D => \I10.CHIP_ADDR_127_net_1\, Q
         => CHIP_ADDRl0r);
    
    \I10.CHANNELl0r\ : DFF
      port map(CLK => CLKOUT, D => \I10.CHANNEL_124_net_1\, Q => 
        CHANNELl0r);
    
    \I1.un1_sstate2_6_0\ : AO21
      port map(A => REGl105r, B => \I1.sstate2l3r_net_1\, C => 
        \I1.N_278\, Y => \I1.AIR_COMMAND_cnstl1r\);
    
    \I0.HWRES_2_0_35\ : NAND2
      port map(A => NPWON_c, B => SYSRESB_c, Y => HWRES_C_2_0_19);
    
    \I10.EVNT_NUM_3_I_60\ : AND3
      port map(A => \I10.DWACT_ADD_CI_0_g_array_1_1l0r\, B => 
        \I10.EVNT_NUMl2r_net_1\, C => \I10.EVNT_NUMl3r_net_1\, Y
         => \I10.DWACT_ADD_CI_0_g_array_2_1l0r\);
    
    \I2.VDBil25r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_601_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil25r_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l5r\ : OR2
      port map(A => LB_inl5r, B => 
        \I2.STATE5l4r_adt_net_116400_Rd1__net_1\, Y => 
        \I2.N_3040\);
    
    \I5.sstate_ns_a2_0_2l0r\ : NOR3FTT
      port map(A => \I5.N_225\, B => \I5.sstate_i_0_il4r\, C => 
        \I5.sstatel3r_net_1\, Y => \I5.sstate_ns_a2_0_2l0r_net_1\);
    
    \I2.REG_1l294r_78\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_257_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL294R_62\);
    
    \I5.SBYTE_5l3r\ : MUX2L
      port map(A => REGl84r, B => FBOUTl2r, S => 
        \I5.sstatel5r_net_1\, Y => \I5.SBYTE_5l3r_net_1\);
    
    \I2.un1_TCNT_1_I_22\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_partial_suml4r\, B => 
        \I2.DWACT_ADD_CI_0_g_array_2_1l0r\, Y => \I2.I_22_0\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I79_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => REGl47r, Y => 
        \I10.ADD_16x16_medium_I79_Y_0\);
    
    \I2.REG_1_351\ : MUX2H
      port map(A => VDB_inl11r, B => \I2.REGl436r\, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_351_net_1\);
    
    \I2.REG_1_325\ : MUX2L
      port map(A => REGl410r, B => VDB_inl17r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_325_net_1\);
    
    SDA1_pad : IOB33PH
      port map(PAD => SDA1, A => \I1.SDAout_del2_net_1\, EN => 
        un1_sdab_0_a2, Y => SDA1_in);
    
    \I2.un1_vsel_5_i_a2\ : NOR3FTT
      port map(A => AMB_cl0r, B => \I2.N_2892_4\, C => 
        \I2.N_2853_i\, Y => \I2.N_2892_i\);
    
    \I1.SBYTE_35\ : MUX2H
      port map(A => \I1.SBYTEl7r_net_1\, B => \I1.N_610\, S => 
        \I1.un1_tick_8\, Y => \I1.SBYTE_35_net_1\);
    
    \I2.REG_1_312\ : MUX2L
      port map(A => REGl397r, B => VDB_inl4r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_312_net_1\);
    
    \I2.PIPEA_8_rl2r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl2r, C => 
        \I2.PIPEA_8l2r_adt_net_57534_\, Y => \I2.PIPEA_8l2r\);
    
    \I10.STATE1l10r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl2r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l10r_net_1\);
    
    \I2.un756_regmap_17\ : OR2
      port map(A => \I2.un756_regmap_10_i\, B => 
        \I2.un756_regmap_17_i_adt_net_36523_\, Y => 
        \I2.un756_regmap_17_i\);
    
    \I2.PULSE_43_f0l2r\ : OA21TTF
      port map(A => PULSEl2r, B => \I2.REGMAPl5r_net_1\, C => 
        \I2.STATE1l6r_net_1\, Y => \I2.PULSE_43l2r\);
    
    \I2.EVREAD_DS_1_sqmuxa_0_o3\ : NOR2
      port map(A => \I2.ADACKCYC_net_1\, B => TST_cl2r, Y => 
        \I2.N_2836\);
    
    SP_PDL_padl18r : IOB33PH
      port map(PAD => SP_PDL(18), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl18r);
    
    \I5.RESCNT_6_rl14r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_65\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l14r\);
    
    \I10.BNC_CNTl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_201_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl3r_net_1\);
    
    \I2.LB_i_491\ : MUX2L
      port map(A => \I2.LB_il13r_Rd1__net_1\, B => 
        \I2.LB_i_7l13r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__84\, Y => \I2.LB_il13r\);
    
    \I10.CHIP_ADDR_128\ : MUX2L
      port map(A => CHIP_ADDRl1r, B => \I10.N_589_i_0\, S => 
        \I10.N_1595\, Y => \I10.CHIP_ADDR_128_net_1\);
    
    \I2.REG_1l76r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_449_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl76r);
    
    \I2.REG_1l177r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_167_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl177r);
    
    \I10.EVNT_NUMl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l9r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl9r_net_1\);
    
    \I2.un1_STATE5_11_0_0_a2\ : AND2
      port map(A => \I2.N_2310_1\, B => 
        \I2.STATE5l3r_adt_net_116444_Rd1__net_1\, Y => 
        \I2.STATE5_nsl2r\);
    
    \I2.VDBi_56l30r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l30r_net_1\, Y => \I2.VDBi_56l30r_net_1\);
    
    \I2.N_3027_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3027\, SET => 
        HWRES_c_2_0, Q => \I2.N_3027_Rd1__net_1\);
    
    \I2.END_PK_510\ : OR2
      port map(A => \I2.END_PK_510_adt_net_59368_\, B => 
        \I2.END_PK_510_adt_net_59370_\, Y => 
        \I2.END_PK_510_net_1\);
    
    \I3.AEl47r\ : MUX2L
      port map(A => REGl200r, B => \I3.un16_ael47r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl47r);
    
    \I10.FID_4_0_a2l5r\ : XOR2
      port map(A => \I10.CRC32l1r_net_1\, B => 
        \I10.FID_4_0_a2_0l5r_net_1\, Y => \I10.FID_4l5r\);
    
    \I10.FID_167\ : MUX2L
      port map(A => \I10.FID_8l2r\, B => \I10.FIDl2r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_167_net_1\);
    
    \I2.REG_1_ml157r\ : NAND2
      port map(A => REGl157r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml157r_net_1\);
    
    \I10.BNC_NUMBERl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_236_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl6r_net_1\);
    
    \I2.VDBi_61l16r\ : MUX2L
      port map(A => LBSP_inl16r, B => \I2.VDBi_56l16r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l16r_net_1\);
    
    \I2.VDBi_17_rl14r\ : OA21
      port map(A => \I2.N_1911_adt_net_43206_\, B => 
        \I2.N_1911_adt_net_43208_\, C => 
        \I2.VDBi_17l15r_adt_net_42484_\, Y => \I2.VDBi_17l14r\);
    
    \I0.CLEAR_0_a2_0_0_0_0\ : NAND3
      port map(A => NLBCLR_c, B => \I0.CLEAR_0_a2_0_net_1\, C => 
        REGl506r, Y => CLEAR_0_0);
    
    \I2.un2_anycyc_0_o3_i_a2_1\ : OR2
      port map(A => \I2.BLTCYC_17\, B => \I2.SINGCYC_net_1\, Y
         => \I2.N_2319_1\);
    
    \I2.VDBi_86_0_iv_0l31r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l31r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il31r_adt_net_39188_\, Y => 
        \I2.VDBi_86_0_iv_0_il31r\);
    
    \I2.STATE1_ns_0_0_0l1r\ : AO21
      port map(A => \I2.N_2831\, B => \I2.STATE1l8r_net_1\, C => 
        \I2.STATE1_ns_0_0_0_il1r_adt_net_38622_\, Y => 
        \I2.STATE1_ns_0_0_0_il1r\);
    
    VDB_padl1r : IOB33PH
      port map(PAD => VDB(1), A => \I2.VDBml1r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl1r);
    
    LB_padl2r : IOB33PH
      port map(PAD => LB(2), A => \I2.LB_il2r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl2r);
    
    \I2.VDBi_19l3r\ : MUX2L
      port map(A => REGl51r, B => \I2.VDBi_17l3r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l3r_net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_x3l4r\ : XOR2
      port map(A => \I10.CNTl1r_net_1\, B => \I10.N_2290\, Y => 
        \I10.N_2347_i_0\);
    
    \I1.SBYTEl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SBYTE_34_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SBYTEl6r_net_1\);
    
    \I2.TCNT_10_rl1r\ : OA21FTT
      port map(A => \I2.N_1826_0\, B => \I2.I_19\, C => 
        \I2.TCNT_0_sqmuxa\, Y => \I2.TCNT_10l1r\);
    
    \I2.PIPEAl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_551_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl7r_net_1\);
    
    \I2.LB_il21r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il21r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il21r_Rd1__net_1\);
    
    \I0.HWRES_2_0\ : NAND2
      port map(A => NPWON_c, B => SYSRESB_c, Y => HWRES_c_2_0);
    
    \I2.un17_reg_ads_0_a2_0_a3_0\ : NOR2
      port map(A => \I2.VASl2r_net_1\, B => \I2.N_3057\, Y => 
        \I2.N_3070\);
    
    \I10.UN2_I2C_CHAIN_0_0_0_0_3L1R_279\ : AND2
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2305\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_3_il1r_adt_net_29650_\);
    
    SP_PDL_padl17r : IOB33PH
      port map(PAD => SP_PDL(17), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl17r);
    
    \I2.PIPEB_4_i_a2l28r\ : OR2FT
      port map(A => \I2.N_2847_1\, B => DPRl28r, Y => \I2.N_2880\);
    
    \I1.BITCNT_0_SQMUXA_2_0_A3_124\ : AO21FTT
      port map(A => \I1.N_544\, B => \I1.N_402\, C => 
        \I1.sstatel11r_net_1\, Y => 
        \I1.BITCNT_0_sqmuxa_2_adt_net_7280_\);
    
    \I2.REG_1l268r_52\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_231_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL268R_36\);
    
    \I2.PIPEA1_530\ : MUX2L
      port map(A => \I2.PIPEA1l19r_net_1\, B => \I2.N_2535\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_530_net_1\);
    
    \I10.EVENT_DWORDl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_138_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl5r_net_1\);
    
    \I2.REGMAPl32r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un116_reg_ads_0_a2_net_1\, 
        Q => \I2.REGMAPl32r_net_1\);
    
    \I2.N_3029_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3029\, SET => 
        HWRES_c_2_0, Q => \I2.N_3029_Rd1__net_1\);
    
    \I5.RESCNTl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l11r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl11r_net_1\);
    
    \I10.REG_1l40r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I72_Y\, 
        CLR => CLEAR_0_0, Q => \I10.REGl40r\);
    
    \I5.G\ : OR2FT
      port map(A => \I5.N_211_0\, B => \I5.sstatel1r_net_1\, Y
         => \I5.G_net_1\);
    
    \I2.VDBi_82l6r\ : MUX2L
      port map(A => \I2.VDBil6r_net_1\, B => FBOUTl6r, S => 
        \I2.N_1721_1\, Y => \I2.VDBi_82l6r_net_1\);
    
    \I2.REG_1_314\ : MUX2L
      port map(A => REGl399r, B => VDB_inl6r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_314_net_1\);
    
    \I2.N_3021_1_adt_net_116352_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3021_1\, SET => 
        HWRES_c_2_0, Q => \I2.N_3021_1_adt_net_116352_Rd1__net_1\);
    
    VDB_padl0r : IOB33PH
      port map(PAD => VDB(0), A => \I2.VDBml0r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl0r);
    
    \I5.un1_sstate_13_i_a2\ : OR2FT
      port map(A => \I5.N_212\, B => \I5.sstatel2r_net_1\, Y => 
        \I5.un1_sstate_13_i_a2_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_1l6r\ : AND3FTT
      port map(A => \I10.CNTl5r_net_1\, B => \I10.N_2374_1\, C
         => \I10.N_2283_i_i_0\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_1_il6r_adt_net_30046_\);
    
    \I2.UN1_STATE5_9_1_RD1__496\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_91\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__81\);
    
    \I2.VDBi_19l16r\ : AND2
      port map(A => TST_cl5r, B => REGl64r, Y => 
        \I2.VDBi_19l16r_net_1\);
    
    \I2.REG_92l86r\ : AND2
      port map(A => \I2.N_1826_0\, B => \I2.N_1989\, Y => 
        \I2.REG_92l86r_net_1\);
    
    \I2.VDBi_67l6r\ : OA21
      port map(A => \I2.VDBi_61l6r_adt_net_49872_\, B => 
        \I2.VDBi_61l6r_adt_net_49874_\, C => \I2.N_1965\, Y => 
        \I2.VDBi_67l6r_adt_net_49914_\);
    
    \I5.RESCNT_6_rl9r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_52_0\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l9r\);
    
    \I2.PIPEAl23r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_567_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl23r_net_1\);
    
    \I10.CRC32_3_0_a2_i_0_x3l0r\ : XOR2FT
      port map(A => \I10.CRC32l0r_net_1\, B => 
        \I10.EVENT_DWORDl0r_net_1\, Y => \I10.N_2342_i_i_0\);
    
    \I2.REG_1l154r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_144_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl154r);
    
    \I10.un6_bnc_res_4\ : XOR2
      port map(A => \I10.BNC_CNTl4r_net_1\, B => REGl461r, Y => 
        \I10.un6_bnc_res_4_i_i\);
    
    \I10.EVENT_DWORD_18_RL10R_255\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl20r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l10r_adt_net_27492_\);
    
    \I10.CRC32_87\ : MUX2H
      port map(A => \I10.CRC32l0r_net_1\, B => \I10.N_1722\, S
         => \I10.N_2351\, Y => \I10.CRC32_87_net_1\);
    
    \I2.PIPEA_567\ : MUX2L
      port map(A => \I2.PIPEAl23r_net_1\, B => \I2.PIPEA_8l23r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_567_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I8_P0N\ : OR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl40r\, Y => 
        \I10.N233\);
    
    \I2.PIPEA1l23r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_534_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l23r_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l27r\ : OR2
      port map(A => LB_inl27r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119377__net_1\, 
        Y => \I2.N_3036\);
    
    \I1.SBYTE_32\ : MUX2H
      port map(A => \I1.SBYTEl4r_net_1\, B => \I1.N_604\, S => 
        \I1.un1_tick_8\, Y => \I1.SBYTE_32_net_1\);
    
    \I10.BNCRES_CNT_4_I_35\ : XOR2
      port map(A => \I10.BNCRES_CNTl2r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_1_0l0r\, Y => 
        \I10.BNCRES_CNT_4l2r\);
    
    \I10.FID_172\ : MUX2L
      port map(A => \I10.FID_8l7r\, B => \I10.FIDl7r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_172_net_1\);
    
    \I10.RDY_CNT_10_i_0l0r\ : AND2
      port map(A => \I10.N_2308\, B => 
        \I10.DWACT_ADD_CI_0_partial_sum_0l0r\, Y => 
        \I10.RDY_CNT_10_i_0l0r_net_1\);
    
    \I8.SWORD_11\ : MUX2H
      port map(A => \I8.SWORDl10r_net_1\, B => 
        \I8.SWORD_5l10r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_11_net_1\);
    
    \I2.VDBi_61l20r\ : MUX2L
      port map(A => LBSP_inl20r, B => \I2.VDBi_56l20r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l20r_net_1\);
    
    \I2.PIPEA1_529\ : MUX2L
      port map(A => \I2.PIPEA1l18r_net_1\, B => \I2.N_2533\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_529_net_1\);
    
    \I10.EVENT_DWORD_18_rl4r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l4r_net_1\, B => 
        \I10.EVENT_DWORD_18l4r_adt_net_28239_\, Y => 
        \I10.EVENT_DWORD_18l4r\);
    
    \I3.un16_ae_47\ : NOR2
      port map(A => \I3.un16_ae_3l47r\, B => \I3.un16_ae_4l47r\, 
        Y => \I3.un16_ael47r\);
    
    \I2.un1_STATE2_16_0_1\ : OR2FT
      port map(A => \I2.N_2849\, B => 
        \I2.un1_STATE2_16_1_adt_net_36115_\, Y => 
        \I2.un1_STATE2_16_1\);
    
    \I3.AEl16r\ : MUX2L
      port map(A => REGl169r, B => \I3.un16_ael16r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl16r);
    
    \I2.PIPEBl27r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_76_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl27r_net_1\);
    
    \I1.AIR_COMMANDl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_38_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl1r_net_1\);
    
    \I5.sstate_0_sqmuxa_1_0_a2\ : OR3
      port map(A => \I5.sstate_0_sqmuxa_1_0_a2_9_i\, B => 
        \I5.sstate_0_sqmuxa_1_0_a2_13_i_adt_net_33240_\, C => 
        \I5.sstate_nsl5r_adt_net_33314_\, Y => \I5.sstate_nsl5r\);
    
    \I10.REG_1l43r\ : DFFS
      port map(CLK => CLKOUT, D => \I10.un1_REG_1_il43r\, SET => 
        CLEAR_0_0, Q => REG_i_0l43r);
    
    \I2.VDBI_67L7R_380\ : AND2FT
      port map(A => \I2.N_1965\, B => \I2.N_1956\, Y => 
        \I2.VDBi_67l7r_adt_net_49085_\);
    
    \I2.REG_1_169\ : MUX2L
      port map(A => REGl179r, B => VDB_inl10r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_169_net_1\);
    
    \I10.FID_8_rl24r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il24r\, B => 
        \I10.FID_8_iv_0_0_0_0_il24r\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l24r\);
    
    \I1.I2C_RDATAl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_19_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl5r);
    
    SP_PDL_padl4r : IOB33PH
      port map(PAD => SP_PDL(4), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl4r);
    
    \I1.I2C_RDATA_9_il2r\ : MUX2L
      port map(A => I2C_RDATAl2r, B => REGl113r, S => 
        \I1.sstate2_0_sqmuxa_4_0\, Y => \I1.N_578\);
    
    \I3.AEl12r\ : MUX2L
      port map(A => REGl165r, B => \I3.un16_ael12r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl12r);
    
    \I1.sstatese_13_a3\ : AOI21TTF
      port map(A => TICKl0r, B => \I1.PULSE_FL_net_1\, C => 
        \I1.sstatel13r_net_1\, Y => \I1.N_453_i\);
    
    \I2.TCNT2l5r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT2_2l5r\, Q => 
        \I2.TCNT2l5r_net_1\);
    
    \I2.REG_1l91r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_464_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl91r);
    
    \I2.un1_tcnt1_I_5\ : XOR2
      port map(A => \I2.TCNT1_i_0_il1r_net_1\, B => 
        \I2.TCNT1l0r_net_1\, Y => \I2.I_5_0\);
    
    \I2.un1_STATE1_12_0_o3_0\ : OR2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.STATE1l8r_net_1\, Y => \I2.N_1730_0\);
    
    \I2.REG_1l277r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_240_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl277r\);
    
    \I2.REG_1l167r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_157_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl167r);
    
    \I2.LB_s_25\ : MUX2L
      port map(A => \I2.LB_sl11r_Rd1__net_1\, B => 
        \I2.N_3046_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116356_Rd1__net_1\, Y => 
        \I2.LB_sl11r\);
    
    \I3.SBYTEl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.SBYTE_8_0\, CLR => 
        HWRES_c_2_0, Q => REGl142r);
    
    VDB_padl28r : IOB33PH
      port map(PAD => VDB(28), A => \I2.VDBml28r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl28r);
    
    \I5.RESCNT_6_rl11r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_56_0\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l11r\);
    
    \I2.LB_i_503\ : MUX2L
      port map(A => \I2.LB_il25r_Rd1__net_1\, B => 
        \I2.LB_i_7l25r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__78\, Y => \I2.LB_il25r\);
    
    SP_PDL_padl20r : IOB33PH
      port map(PAD => SP_PDL(20), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl20r);
    
    \I2.VADml28r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl28r_net_1\, Y
         => \I2.VADml28r_net_1\);
    
    \I1.I2C_RDATA_22\ : MUX2L
      port map(A => I2C_RDATAl8r, B => \I1.N_590\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_22_net_1\);
    
    \I10.BNC_CNT_201\ : MUX2H
      port map(A => \I10.BNC_CNTl3r_net_1\, B => 
        \I10.BNC_CNT_4l3r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_201_net_1\);
    
    \I2.MYBERRi\ : DFFS
      port map(CLK => CLKOUT, D => \I2.MYBERRi_48_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => MYBERR_c);
    
    \I10.EVENT_DWORD_18_I_0_0L25R_224\ : NOR2
      port map(A => \I10.N_2642_0\, B => \I10.OR_RADDRl5r_net_1\, 
        Y => \I10.EVENT_DWORD_18_i_0_0l25r_adt_net_25530_\);
    
    \I10.FAULT_STAT_3_0_a3\ : NOR2FT
      port map(A => PSM_SP4_c, B => \I10.CLEAR_PSM_FLAGS_net_1\, 
        Y => \I10.FAULT_STAT_3\);
    
    \I2.VADml5r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl5r_net_1\, Y
         => \I2.VADml5r_net_1\);
    
    \I2.VDBi_61l27r\ : MUX2L
      port map(A => LBSP_inl27r, B => \I2.VDBi_56l27r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l27r_net_1\);
    
    \I2.REG_1_388_e\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl34r_net_1\, Y => \I2.PULSE_1_sqmuxa_5\);
    
    \I2.PULSE_43_f1l6r\ : AND2FT
      port map(A => PULSEl6r, B => 
        \I2.PULSE_43_f1l6r_adt_net_71125_\, Y => 
        \I2.PULSE_43_f1l6r_net_1\);
    
    \I2.PIPEA_546\ : MUX2L
      port map(A => \I2.PIPEAl2r_net_1\, B => \I2.PIPEA_8l2r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_546_net_1\);
    
    \I2.LB_il27r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il27r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il27r_Rd1__net_1\);
    
    \I2.REG_1_388\ : MUX2L
      port map(A => REGl473r, B => VDB_inl0r, S => 
        \I2.PULSE_1_sqmuxa_5\, Y => \I2.REG_1_388_net_1\);
    
    \I1.I2C_RVALID\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RVALID_2\, CLR => 
        HWRES_c_2_0, Q => I2C_RVALID);
    
    \I1.AIR_COMMAND_41\ : MUX2L
      port map(A => \I1.AIR_COMMANDl9r_net_1\, B => 
        \I1.AIR_COMMAND_21l9r\, S => \I1.un1_tick_12_net_1\, Y
         => \I1.AIR_COMMAND_41_net_1\);
    
    \I2.un1_TCNT_1_I_6\ : AND2
      port map(A => \I2.N_1885_1\, B => \I2.TCNTl2r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_0_2l0r\);
    
    \I10.FID_8_rl30r\ : OA21FTT
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl30r_net_1\, C => 
        \I10.FID_8l30r_adt_net_20661_\, Y => \I10.FID_8l30r\);
    
    \I2.REG_1_375\ : MUX2H
      port map(A => VDB_inl3r, B => REGl460r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_375_net_1\);
    
    \I5.un1_RESCNT_I_57\ : XOR2
      port map(A => \I5.RESCNTl5r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_12_1l0r\, Y => \I5.I_57\);
    
    \I2.VDBi_59_0l10r\ : OR2
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.REGMAPl29r_net_1\, Y => \I2.VDBi_59_0l9r\);
    
    \I2.REG_1l279r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_242_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl279r\);
    
    \I2.VDBil26r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_602_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil26r_net_1\);
    
    \I2.REG_1_158_e_0\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl18r_net_1\, Y => \I2.N_3111_i_0\);
    
    \I10.FID_8_IV_0_0_0_0L4R_210\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.FID_4_il4r\, Y
         => \I10.FID_8_iv_0_0_0_0_il4r_adt_net_24220_\);
    
    \I2.un7_noe32ri_i_0_i_i\ : OR2FT
      port map(A => \I2.MBLTCYC_net_1\, B => \I2.ADACKCYC_net_1\, 
        Y => NOEAD_c_i_0);
    
    \I10.EVENT_DWORD_141\ : MUX2H
      port map(A => \I10.EVENT_DWORDl8r_net_1\, B => 
        \I10.EVENT_DWORD_18l8r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_141_net_1\);
    
    SP_PDL_padl3r : IOB33PH
      port map(PAD => SP_PDL(3), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl3r);
    
    \I10.un1_REG_1_ADD_16x16_medium_I78_Y\ : XOR2
      port map(A => \I10.N300\, B => 
        \I10.ADD_16x16_medium_I78_Y_0\, Y => 
        \I10.ADD_16x16_medium_I78_Y\);
    
    \I10.FIDl20r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_185_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl20r_net_1\);
    
    \I2.STATE5l1r_126\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5l1r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L1R_RD1__110\);
    
    \I2.PIPEAl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_547_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl3r_net_1\);
    
    NLBAS_c : DFFS
      port map(CLK => ALICLK_c, D => \I2.nLBAS_81_net_1\, SET => 
        HWRES_c_2_0, Q => \NLBAS_c\);
    
    \I10.FID_8_IV_0_0_0_1L20R_178\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl68r, Y => 
        \I10.FID_8_iv_0_0_0_1_il20r_adt_net_22093_\);
    
    \I10.CRC32l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_88_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l1r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I75_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => REG_i_0l43r, Y => 
        \I10.ADD_16x16_medium_I75_Y_0\);
    
    \I10.EVNT_NUM_3_I_45\ : XOR2
      port map(A => \I10.DWACT_ADD_CI_0_TMP_1l0r\, B => 
        \I10.EVNT_NUMl1r_net_1\, Y => \I10.EVNT_NUM_3l1r\);
    
    \I2.REG_1l156r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_146_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl156r);
    
    \I2.PIPEA_564\ : MUX2L
      port map(A => \I2.PIPEAl20r_net_1\, B => \I2.PIPEA_8l20r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_564_net_1\);
    
    \I10.READ_PDL_FLAG_86_0_0_0_a2_1\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.STATE1l3r_net_1\, Y => \I10.N_2380_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I65_Y_0\ : XOR2
      port map(A => REGl33r, B => \I10.N208\, Y => 
        \I10.ADD_16x16_medium_I65_Y_0\);
    
    \I3.ISI\ : DFFC
      port map(CLK => CLKOUT, D => \I3.ISI_2_net_1\, CLR => 
        HWRES_c_2_0, Q => SI_PDL_c);
    
    \I3.un16_ae_17_1\ : NAND2FT
      port map(A => \I3.un16_ae_1l41r\, B => \I3.un16_ae_1l31r\, 
        Y => \I3.un16_ae_1l25r\);
    
    \I2.VDBI_67_ML1R_477\ : OA21
      port map(A => \I2.VDBi_24l1r_adt_net_91170_\, B => 
        \I2.VDBi_24l1r_adt_net_91174_\, C => 
        \I2.VDBi_67_m_il1r_adt_net_103676_\, Y => 
        \I2.VDBi_67_m_il1r_adt_net_103772_\);
    
    \I2.REG_1_450\ : MUX2H
      port map(A => VDB_inl29r, B => REGl77r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_450_net_1\);
    
    \I2.VDBi_17_rl6r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1903_adt_net_49479_\, C => 
        \I2.N_1903_adt_net_49481_\, Y => \I2.VDBi_17l6r\);
    
    \I2.VDBi_86_ivl15r\ : AO21TTF
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l15r_net_1\, C => \I2.VDBi_86_iv_2l15r_net_1\, 
        Y => \I2.VDBi_86l15r\);
    
    \I2.VDBi_54_0_iv_5l2r\ : NOR3
      port map(A => \I2.VDBi_54_0_iv_3_il2r\, B => 
        \I2.VDBi_54_0_iv_0_il2r\, C => \I2.VDBi_54_0_iv_1_il2r\, 
        Y => \I2.VDBi_54_0_iv_5l2r_net_1\);
    
    \I2.PIPEA_8_RL17R_436\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l17r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l17r_adt_net_56447_\);
    
    AE_PDL_padl13r : OB33PH
      port map(PAD => AE_PDL(13), A => AE_PDL_cl13r);
    
    \I2.REG_1_220\ : MUX2L
      port map(A => VDB_inl8r, B => REGl257r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_220_net_1\);
    
    \I2.REG3_110\ : MUX2L
      port map(A => VDB_inl3r, B => \I2.REGl3r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_110_net_1\);
    
    \I2.PULSE_1l6r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_43_f0l6r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => PULSEl6r);
    
    \I2.PIPEB_54\ : MUX2H
      port map(A => \I2.PIPEBl5r_net_1\, B => \I2.N_2579\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_54_net_1\);
    
    \I2.un1_STATE1_17_0_0\ : OR3FFT
      port map(A => \I2.N_2907\, B => \I2.N_2837\, C => 
        \I2.STATE1l0r_net_1\, Y => \I2.un1_STATE1_17\);
    
    \I2.PIPEA1_537\ : MUX2L
      port map(A => \I2.PIPEA1l26r_net_1\, B => \I2.N_2549\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_537_net_1\);
    
    \I10.un3_bnc_cnt_I_9\ : XOR2
      port map(A => \I10.BNC_CNTl2r_net_1\, B => 
        \I10.DWACT_FINC_El0r_adt_net_18772_\, Y => \I10.I_9\);
    
    \I8.ISI_5_IV_121\ : AND2
      port map(A => \I8.sstatel0r_net_1\, B => 
        \I8.SWORDl15r_net_1\, Y => \I8.ISI_5_adt_net_5506_\);
    
    \I2.PIPEB_4_il16r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl16r, Y => \I2.N_2601\);
    
    \I2.REG_1_328\ : MUX2L
      port map(A => REGl413r, B => VDB_inl20r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_328_net_1\);
    
    \I2.WRITES_2\ : MUX2H
      port map(A => \I2.WRITES_net_1\, B => WRITEB_c, S => 
        \I2.TST_c_0l1r\, Y => \I2.WRITES_2_net_1\);
    
    \I2.VDBi_85_ml6r\ : NAND3
      port map(A => \I2.VDBil6r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml6r_net_1\);
    
    \I2.un1_STATE2_13_0_1\ : OR3FFT
      port map(A => \I2.N_3072\, B => \I2.N_2849\, C => 
        \I2.N_3071_i\, Y => \I2.un1_STATE2_13_1\);
    
    \I10.FID_8_iv_0_0_0_x3l12r\ : XOR2FT
      port map(A => \I10.CRC32l8r_net_1\, B => 
        \I10.CRC32l20r_net_1\, Y => \I10.N_2309_i_0_i\);
    
    \I2.VDBi_54_0_iv_0l13r\ : AO21
      port map(A => REGl262r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il13r_adt_net_44196_\, Y => 
        \I2.VDBi_54_0_iv_0_il13r\);
    
    \I2.PIPEB_67\ : MUX2H
      port map(A => \I2.PIPEBl18r_net_1\, B => \I2.N_2605\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_67_net_1\);
    
    \I2.VDBil20r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_596_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil20r_net_1\);
    
    \I2.REG_1l63r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_436_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl63r);
    
    \I10.STATE1_ns_0_0_0l9r\ : AOI21FTF
      port map(A => \I10.N_2642_0\, B => \I10.N_2299\, C => 
        \I10.N_2393\, Y => \I10.STATE1_ns_0_0_0l9r_net_1\);
    
    \I2.VDBi_17_rl8r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1905_adt_net_47814_\, C => 
        \I2.N_1905_adt_net_47816_\, Y => \I2.VDBi_17l8r\);
    
    \I2.PIPEB_4_i_o3_1l0r\ : NAND2
      port map(A => \I2.STATE2_i_0l3r\, B => \I2.N_2823\, Y => 
        \I2.N_2847_1\);
    
    \I10.FID_8_IV_0_0_0_1L17R_184\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl65r, Y => 
        \I10.FID_8_iv_0_0_0_1_il17r_adt_net_22585_\);
    
    \I10.FIDl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_174_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl9r_net_1\);
    
    \I2.LB_sl13r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl13r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl13r_Rd1__net_1\);
    
    \I1.sstate2se_8_i\ : MUX2H
      port map(A => \I1.sstate2l1r_net_1\, B => 
        \I1.sstate2l0r_net_1\, S => \I1.N_277_0\, Y => 
        \I1.sstate2se_8_i_net_1\);
    
    \I10.EVENT_DWORD_18_rl25r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_1l25r_net_1\, B => 
        \I10.EVENT_DWORD_18l25r_adt_net_25602_\, Y => 
        \I10.EVENT_DWORD_18l25r\);
    
    \I2.VDBi_54_0_iv_2l1r\ : AO21
      port map(A => REGl170r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.VDBi_54_0_iv_2_il1r_adt_net_53747_\, Y => 
        \I2.VDBi_54_0_iv_2_il1r\);
    
    \I10.EVENT_DWORD_157\ : MUX2H
      port map(A => \I10.EVENT_DWORDl24r_net_1\, B => 
        \I10.EVENT_DWORD_18l24r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_157_net_1\);
    
    \I2.REG_1l267r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_230_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl267r\);
    
    \I2.PIPEB_74\ : MUX2H
      port map(A => \I2.PIPEBl25r_net_1\, B => \I2.N_2619\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_74_net_1\);
    
    \I5.un1_RESCNT_I_65\ : XOR2
      port map(A => \I5.RESCNTl14r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_11_2l0r\, Y => \I5.I_65\);
    
    \I2.VDBi_19l31r\ : AND2
      port map(A => TST_cl5r, B => REGl79r, Y => 
        \I2.VDBi_19l31r_net_1\);
    
    \I2.STATE1_ns_o3l1r\ : NAND2
      port map(A => \I2.WRITES_net_1\, B => \I2.N_1714\, Y => 
        \I2.N_1717\);
    
    \I2.REG_il272r\ : INV
      port map(A => \I2.REGl272r\, Y => REG_i_0l272r);
    
    \I2.PIPEA_8_RL15R_438\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l15r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l15r_adt_net_56587_\);
    
    \I2.REG_1l412r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_327_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl412r);
    
    \I2.REG_1l483r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_398_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl483r\);
    
    \I2.un81_reg_ads_0_a2_0_a2\ : NOR2
      port map(A => \I2.N_3006_1\, B => \I2.N_3003_1\, Y => 
        \I2.un81_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.REG_1_335\ : MUX2L
      port map(A => REGl420r, B => VDB_inl27r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_335_net_1\);
    
    \I2.REG_1l265r_49\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_228_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL265R_33\);
    
    \I1.SBYTE_9_il6r\ : MUX2H
      port map(A => \I1.SBYTEl5r_net_1\, B => 
        \I1.COMMANDl14r_net_1\, S => \I1.N_625_0\, Y => 
        \I1.N_608\);
    
    \I2.VDBI_86_IV_1L1R_416\ : AND2
      port map(A => \I2.PIPEAl1r_net_1\, B => \I2.N_1707_i_0_1\, 
        Y => \I2.VDBi_86_iv_1_il1r_adt_net_54111_\);
    
    \I2.PIPEA_8_RL10R_443\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l10r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l10r_adt_net_56937_\);
    
    \I2.LB_il12r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il12r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il12r_Rd1__net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L12R_250\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl20r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l12r_adt_net_27238_\);
    
    \I10.CRC32_106\ : MUX2H
      port map(A => \I10.CRC32l19r_net_1\, B => \I10.N_1039\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_106_net_1\);
    
    FCS_pad : OTB33PH
      port map(PAD => FCS, A => un1_reg_1, EN => un6_fcs);
    
    \I10.L2RF2\ : DFFC
      port map(CLK => ACLKOUT, D => \I10.L2RF1_net_1\, CLR => 
        HWRES_c_2_0, Q => \I10.L2RF2_net_1\);
    
    \I2.VDBi_67_0l13r\ : MUX2L
      port map(A => \I2.REGl438r\, B => \I2.REGl454r\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1962\);
    
    \I2.PIPEA_8_rl23r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl23r, C => 
        \I2.PIPEA_8l23r_adt_net_56027_\, Y => \I2.PIPEA_8l23r\);
    
    \I3.un16_ae_7_1\ : NAND2FT
      port map(A => REGl125r, B => REGl122r, Y => 
        \I3.un16_ae_1l7r\);
    
    \I2.VDBi_86_iv_2l15r\ : AOI21TTF
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl15r\, C
         => \I2.VDBi_86_iv_1l15r_net_1\, Y => 
        \I2.VDBi_86_iv_2l15r_net_1\);
    
    \I2.PIPEAl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_554_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl10r_net_1\);
    
    \I2.REG_1l487r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_402_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl487r\);
    
    GA_padl0r : IB33
      port map(PAD => GA(0), Y => GA_cl0r);
    
    \I2.LB_s_36\ : MUX2L
      port map(A => \I2.LB_sl22r_Rd1__net_1\, B => 
        \I2.N_3031_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116348_Rd1__net_1\, Y => 
        \I2.LB_sl22r\);
    
    \I1.I2C_RDATA_17\ : MUX2L
      port map(A => I2C_RDATAl3r, B => \I1.N_580\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_17_net_1\);
    
    \I10.FID_8_RL8R_203\ : OA21FTF
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl8r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l8r_adt_net_23782_\);
    
    \I5.DRIVECS\ : DFFC
      port map(CLK => CLKOUT, D => \I5.DRIVECS_2_net_1\, CLR => 
        HWRES_c_2_0, Q => \I5.DRIVECS_net_1\);
    
    \I10.FIFO_END_EVNT_119\ : MUX2L
      port map(A => \I10.FIFO_END_EVNT_net_1\, B => 
        \I10.un1_STATE1_10\, S => CLEAR_0_0_18, Y => 
        \I10.FIFO_END_EVNT_119_net_1\);
    
    \I2.REG_1l269r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_232_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl269r\);
    
    \I2.un1_STATE2_13_0_o3_0\ : NAND2
      port map(A => DPRl30r, B => DPRl28r, Y => 
        \I2.un1_STATE2_13_0_o3_0_net_1\);
    
    \I2.VDBi_17_rl4r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1901_adt_net_51085_\, C => 
        \I2.N_1901_adt_net_51087_\, Y => \I2.VDBi_17l4r\);
    
    \I2.un1_STATE5_9_0_a2_2_a2\ : NAND2
      port map(A => \I2.WRITES_net_1\, B => \I2.STATE5L2R_71\, Y
         => \I2.LB_nOE_1_sqmuxa\);
    
    \I10.REG_1l42r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I74_Y\, 
        CLR => CLEAR_0_0, Q => \I10.REGl42r\);
    
    \I2.REG_1_395\ : MUX2H
      port map(A => VDB_inl6r, B => \I2.REGl480r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_395_net_1\);
    
    \I2.VDBi_61l5r\ : AND3FTT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_61_sl0r_net_1\, C => 
        \I2.VDBi_56l5r_adt_net_50636_\, Y => 
        \I2.VDBi_61l5r_adt_net_50675_\);
    
    \I2.VAS_97\ : MUX2L
      port map(A => VAD_inl15r, B => \I2.VASl15r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_97_net_1\);
    
    MYBERR_pad : OB33PH
      port map(PAD => MYBERR, A => MYBERR_c);
    
    \I2.REG_1_445\ : MUX2H
      port map(A => VDB_inl24r, B => REGl72r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_445_net_1\);
    
    \I2.REG_1_414\ : MUX2H
      port map(A => VDB_inl25r, B => \I2.REGl499r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_414_net_1\);
    
    \I2.REG_1l285r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_248_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl285r\);
    
    \I10.FID_8_rl18r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il18r\, B => 
        \I10.FID_8_iv_0_0_0_0_il18r\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l18r\);
    
    \I10.CRC32l3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_90_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l3r_net_1\);
    
    \I10.STATE1_ns_0_a2_0l1r\ : OR2FT
      port map(A => \I10.STATE1l11r_net_1\, B => PULSEl3r, Y => 
        \I10.N_2382\);
    
    \I2.VDBi_56l8r\ : OA21TTF
      port map(A => \I2.VDBi_24_m_il8r\, B => 
        \I2.VDBi_54_0_iv_6_il8r\, C => \I2.REGMAPl28r_net_1\, Y
         => \I2.VDBi_56l8r_net_1\);
    
    \I2.REG_1_149\ : MUX2L
      port map(A => REGl159r, B => VDB_inl6r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_149_net_1\);
    
    SP_PDL_padl31r : IOB33PH
      port map(PAD => SP_PDL(31), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl31r);
    
    \I2.VDBI_54_0_IV_0L11R_362\ : AND2
      port map(A => REGl116r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.VDBi_54_0_iv_0_il11r_adt_net_45704_\);
    
    \I2.REG3_109\ : MUX2L
      port map(A => VDB_inl2r, B => \I2.REGl2r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_109_net_1\);
    
    \I10.EVNT_NUM_3_I_58\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_3l0r\, B => 
        \I10.EVNT_NUMl8r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_12_3l0r\);
    
    \I3.un16_ae_15\ : NOR2
      port map(A => \I3.un16_ae_2l7r\, B => \I3.un16_ae_2l15r\, Y
         => \I3.un16_ael15r\);
    
    \I3.AEl9r\ : MUX2L
      port map(A => REGl162r, B => \I3.un16_ael9r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl9r);
    
    \I10.un2_evread_3_i_0_a2_0_6\ : NOR2FT
      port map(A => REG_i_0l38r, B => \I10.REGl39r\, Y => 
        \I10.un2_evread_3_i_0_a2_0_6_net_1\);
    
    \I2.un1_STATE5_9_0_a2_1_113\ : AND2FT
      port map(A => \I2.REGMAPl35r_net_1\, B => \I2.STATE5L3R_98\, 
        Y => \I2.N_2389_97\);
    
    \I2.REG_1l416r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_331_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl416r);
    
    \I10.PDL_RADDR_228\ : MUX2H
      port map(A => \I10.CNTl4r_net_1\, B => 
        \I10.PDL_RADDRl4r_net_1\, S => \I10.PDL_RADDR_1_sqmuxa\, 
        Y => \I10.PDL_RADDR_228_net_1\);
    
    \I2.TCNT3_2_I_19\ : XOR2
      port map(A => \I2.TCNT3_i_0_il0r_net_1\, B => 
        \I2.TICKl1r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_partial_sum_1l0r\);
    
    \I2.MBLTCYC\ : DFFC
      port map(CLK => CLKOUT, D => \I2.MBLTCYC_106_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.MBLTCYC_net_1\);
    
    \I2.LB_i_487\ : MUX2L
      port map(A => \I2.LB_il9r_Rd1__net_1\, B => 
        \I2.LB_i_7l9r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__86\, Y => \I2.LB_il9r\);
    
    \I10.STATE2_ns_a3_0_a2_0_a2_0_a2l0r\ : NOR2
      port map(A => REGl384r, B => \I10.STATE2l1r_net_1\, Y => 
        \I10.STATE2_nsl0r\);
    
    \I2.REG_1l62r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_435_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl62r);
    
    \I10.un1_REG_1_ADD_16x16_medium_I58_Y\ : AO21TTF
      port map(A => \I10.N_2519_1\, B => REGl46r, C => 
        \I10.ADD_16x16_medium_I58_un1_Y\, Y => 
        \I10.ADD_16x16_medium_I58_Y\);
    
    \I10.BNC_CNT_4_0_a2l7r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_38\, 
        Y => \I10.BNC_CNT_4l7r\);
    
    \I2.REG_il288r\ : INV
      port map(A => \I2.REGl288r\, Y => REG_i_0l288r);
    
    \I10.FID_8_rl23r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il23r\, B => 
        \I10.FID_8_iv_0_0_0_0_il23r\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l23r\);
    
    \I2.TCNT_10_rl3r\ : OA21FTT
      port map(A => \I2.N_1826_0\, B => \I2.I_21_0\, C => 
        \I2.TCNT_0_sqmuxa\, Y => \I2.TCNT_10l3r\);
    
    \I10.EVENT_DWORD_18_rl7r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l7r_net_1\, B => 
        \I10.EVENT_DWORD_18l7r_adt_net_27903_\, Y => 
        \I10.EVENT_DWORD_18l7r\);
    
    \I2.VDBi_24l18r\ : MUX2L
      port map(A => \I2.REGl492r\, B => \I2.VDBi_19l18r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l18r_net_1\);
    
    \I2.VDBI_59L11R_364\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l11r_net_1\, C => \I2.VDBi_54_0_iv_5_il11r\, Y
         => \I2.VDBi_59l11r_adt_net_45822_\);
    
    \I2.REG_1l274r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_237_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl274r\);
    
    AE_PDL_padl10r : OB33PH
      port map(PAD => AE_PDL(10), A => AE_PDL_cl10r);
    
    L1R_pad : IB33
      port map(PAD => L1R, Y => L1R_c);
    
    \I2.LB_sl16r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl16r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl16r_Rd1__net_1\);
    
    \I2.VDBm_0l29r\ : MUX2L
      port map(A => \I2.PIPEA_i_0_il29r\, B => 
        \I2.PIPEBl29r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2070\);
    
    \I10.CRC32_107\ : MUX2H
      port map(A => \I10.CRC32l20r_net_1\, B => \I10.N_1466\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_107_net_1\);
    
    \I10.READ_ADC_FLAG\ : DFFC
      port map(CLK => CLKOUT, D => 
        \I10.READ_ADC_FLAG_84_0_0_0_net_1\, CLR => CLEAR_0_0, Q
         => \I10.READ_ADC_FLAG_net_1\);
    
    \I2.LB_i_7l0r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l0r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l0r_Rd1__net_1\);
    
    \I2.VDBi_61_dl3r\ : MUX2L
      port map(A => LBSP_inl3r, B => L2A_c, S => 
        \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61_dl3r_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_4l5r\ : OR3FFT
      port map(A => \I10.N_2403\, B => 
        \I10.un2_i2c_chain_0_i_0_a2_1l5r_net_1\, C => 
        \I10.N_2406\, Y => \I10.un2_i2c_chain_0_i_0_4_il5r\);
    
    \I10.OR_RREQ\ : DFFC
      port map(CLK => CLKOUT, D => \I10.OR_RREQ_130_net_1\, CLR
         => CLEAR_0_0, Q => \I10.OR_RREQ_net_1\);
    
    LED_padl1r : OB33PH
      port map(PAD => LED(1), A => \VCC\);
    
    \I3.un16_ae_16\ : NOR2
      port map(A => \I3.un16_ae_1l24r\, B => \I3.un16_ae_1l23r\, 
        Y => \I3.un16_ael16r\);
    
    \I2.un1_STATE1_25_0\ : NAND3FFT
      port map(A => \I2.STATE1l7r_net_1\, B => 
        \I2.un1_STATE1_25_0_0_adt_net_74952_\, C => 
        \I2.N_2860_i_0_i\, Y => \I2.un1_STATE1_25_adt_net_74991_\);
    
    DS1B_pad : IB33
      port map(PAD => DS1B, Y => DS1B_c);
    
    \I2.REG_1_165\ : MUX2L
      port map(A => REGl175r, B => VDB_inl6r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_165_net_1\);
    
    \I2.VDBi_82l1r\ : MUX2L
      port map(A => \I2.VDBil1r_net_1\, B => FBOUTl1r, S => 
        \I2.N_1721_1\, Y => \I2.VDBi_82l1r_net_1\);
    
    \I2.STATE2_nsl0r\ : AO21
      port map(A => \I2.STATE2l5r_net_1\, B => \I2.N_1568\, C => 
        \I2.STATE2_nsl0r_adt_net_38978_\, Y => 
        \I2.STATE2_nsl0r_net_1\);
    
    \I10.BNCRES_CNT_4_I_21\ : XOR2
      port map(A => \I10.BNCRES_CNTl0r_net_1\, B => 
        \I10.BNC_NUMBER_1_sqmuxa\, Y => 
        \I10.DWACT_ADD_CI_0_partial_sum_1l0r\);
    
    VDB_padl25r : IOB33PH
      port map(PAD => VDB(25), A => \I2.VDBml25r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl25r);
    
    \I2.UN102_REG_ADS_0_A2_0_A2_303\ : NOR3
      port map(A => \I2.N_3067\, B => \I2.N_3010_1\, C => 
        \I2.N_3009_1\, Y => 
        \I2.un102_reg_ads_0_a2_0_a2_adt_net_37466_\);
    
    \I2.REG_1_326\ : MUX2L
      port map(A => REGl411r, B => VDB_inl18r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_326_net_1\);
    
    \I2.PIPEA1_9_il6r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl6r, Y => \I2.N_2509\);
    
    \I10.I2C_RREQ_132\ : MUX2H
      port map(A => I2C_RREQ, B => \I10.STATE1l7r_net_1\, S => 
        \I10.un1_I2C_RREQ_1_sqmuxa\, Y => 
        \I10.I2C_RREQ_132_net_1\);
    
    \I2.REG_1_401\ : MUX2H
      port map(A => VDB_inl12r, B => \I2.REGl486r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_401_net_1\);
    
    \I2.VDBi_61l31r\ : MUX2L
      port map(A => LBSP_inl31r, B => \I2.VDBi_56l31r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l31r_net_1\);
    
    \I1.sstatel6r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstatese_6_i_0_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstatel6r_net_1\);
    
    \I10.FID_177\ : MUX2L
      port map(A => \I10.FID_8l12r\, B => \I10.FIDl12r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_177_net_1\);
    
    \I8.SWORD_8\ : MUX2H
      port map(A => \I8.SWORDl7r_net_1\, B => 
        \I8.SWORD_5l7r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_8_net_1\);
    
    \I2.un94_reg_ads_0_a2_0_a2\ : AND2FT
      port map(A => \I2.N_3154_i\, B => 
        \I2.un94_reg_ads_0_a2_0_a2_adt_net_37494_\, Y => 
        \I2.un94_reg_ads_0_a2_0_a2_net_1\);
    
    \I1.un1_tick_8_0_0_o2_0_0\ : OR2
      port map(A => \I1.N_625_0_adt_net_7241_\, B => 
        \I1.sstatel11r_net_1\, Y => \I1.N_625_0\);
    
    SP_PDL_padl12r : IOB33PH
      port map(PAD => SP_PDL(12), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl12r);
    
    \I2.LB_sl15r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl15r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl15r_Rd1__net_1\);
    
    \I2.LB_s_28\ : MUX2L
      port map(A => \I2.LB_sl14r_Rd1__net_1\, B => 
        \I2.N_3049_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116352_Rd1__net_1\, Y => 
        \I2.LB_sl14r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I39_Y\ : AO21
      port map(A => \I10.N267\, B => \I10.N266\, C => \I10.N265\, 
        Y => \I10.N279\);
    
    \I10.un3_bnc_cnt_I_83\ : AND3
      port map(A => \I10.DWACT_FINC_El7r\, B => 
        \I10.DWACT_FINC_El9r_adt_net_18912_\, C => 
        \I10.DWACT_FINC_El28r\, Y => \I10.N_31\);
    
    \I2.un1_tcnt1_I_24\ : XOR2
      port map(A => \I2.TCNT1l5r_net_1\, B => \I2.N_4\, Y => 
        \I2.I_24_1\);
    
    \I2.EVREAD_DS_139\ : AO21FTT
      port map(A => TST_cl2r, B => 
        \I2.un1_EVREAD_DS_1_sqmuxa_1_net_1\, C => 
        \I2.EVREAD_DS_139_adt_net_73658_\, Y => 
        \I2.EVREAD_DS_139_net_1\);
    
    P_PDL_padl3r : OB33PH
      port map(PAD => P_PDL(3), A => REG_cl132r);
    
    \I2.PIPEA1_531\ : MUX2L
      port map(A => \I2.PIPEA1l20r_net_1\, B => \I2.N_2537\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_531_net_1\);
    
    \I2.NLBRDY_s\ : DFFS
      port map(CLK => CLKOUT, D => NLBRDY_c, SET => HWRES_c_2_0, 
        Q => \I2.NLBRDY_s_net_1\);
    
    \I10.CRC32_3_i_0_0l8r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2317_i_i_0\, Y => \I10.N_1212\);
    
    \I10.CRC32_3_i_0_0l9r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2314_i_i_0\, Y => \I10.N_1035\);
    
    \I2.VDBi_86_0_iv_0l28r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l28r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il28r_adt_net_39803_\, Y => 
        \I2.VDBi_86_0_iv_0_il28r\);
    
    \I2.STATE5_ns_i_i_a2l0r_118\ : OR2FT
      port map(A => TST_cl2r, B => 
        \I2.STATE5L3R_ADT_NET_116444_RD1__108\, Y => 
        \I2.N_2385_ADT_NET_38045__102\);
    
    P_PDL_padl4r : OB33PH
      port map(PAD => P_PDL(4), A => REG_cl133r);
    
    \I2.REG_1_378\ : MUX2H
      port map(A => VDB_inl6r, B => REGl463r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_378_net_1\);
    
    \I10.BNC_CNT_4_0_a2l16r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => \I10.I_98\, 
        Y => \I10.BNC_CNT_4l16r\);
    
    \I2.VDBi_54_0_iv_5l11r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il11r\, B => 
        \I2.VDBi_54_0_iv_0_il11r\, C => \I2.VDBi_54_0_iv_1_il11r\, 
        Y => \I2.VDBi_54_0_iv_5_il11r\);
    
    \I2.REG_1l424r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_339_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl424r);
    
    \I2.LB_i_504\ : MUX2L
      port map(A => \I2.LB_il26r_Rd1__net_1\, B => 
        \I2.LB_i_7l26r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__78\, Y => \I2.LB_il26r\);
    
    \I1.COMMANDl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_6_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl10r_net_1\);
    
    AE_PDL_padl25r : OB33PH
      port map(PAD => AE_PDL(25), A => AE_PDL_cl25r);
    
    \I5.un1_RESCNT_I_95\ : AND3
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_1_1l0r\, B => 
        \I5.RESCNTl6r_net_1\, C => \I5.RESCNTl7r_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_pog_array_2l0r\);
    
    \I2.REG_1_382\ : MUX2H
      port map(A => VDB_inl10r, B => REGl467r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_382_net_1\);
    
    \I10.un3_bnc_cnt_I_98\ : XOR2
      port map(A => \I10.BNC_CNTl16r_net_1\, B => \I10.N_21\, Y
         => \I10.I_98\);
    
    \I2.VADml2r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl2r_net_1\, Y
         => \I2.VADml2r_net_1\);
    
    VAD_padl3r : IOB33PH
      port map(PAD => VAD(3), A => \I2.VADml3r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl3r);
    
    \I2.REG3_112\ : MUX2L
      port map(A => VDB_inl5r, B => REGl5r, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_112_net_1\);
    
    \I10.EVENT_DWORDl31r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_164_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl31r_net_1\);
    
    \I2.UN1_STATE5_9_1_RD1__500\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_92\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__85\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I71_Y\ : XOR2FT
      port map(A => \I10.N326_i\, B => 
        \I10.ADD_16x16_medium_I71_Y_0\, Y => 
        \I10.ADD_16x16_medium_I71_Y\);
    
    \I2.LB_s_22\ : MUX2L
      port map(A => \I2.LB_sl8r_Rd1__net_1\, B => 
        \I2.N_3043_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116356_Rd1__net_1\, Y => 
        \I2.LB_sl8r\);
    
    \I2.REG_il287r\ : INV
      port map(A => \I2.REGl287r\, Y => REG_i_0l287r);
    
    \I2.REG_1l504r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_419_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl504r\);
    
    \I2.un1_STATE2_12_0_o3_2_o3_2\ : AND2
      port map(A => \I2.MBLTCYC_net_1\, B => \I2.REGMAPl0r_net_1\, 
        Y => \I2.N_2835\);
    
    \I10.un2_i2c_chain_0_i_0_0_a2_1_1l2r\ : NAND2
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2279\, Y => 
        \I10.N_2400_1\);
    
    \I3.BITCNTl0r\ : DFF
      port map(CLK => CLKOUT, D => \I3.un1_BITCNT_1_rl0r_net_1\, 
        Q => \I3.BITCNTl0r_net_1\);
    
    \I2.STATE1l5r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.N_1679_i_0_i_net_1\, SET
         => \I2.N_2483_i_0_0_0\, Q => \I2.STATE1_i_0l5r\);
    
    \I10.event_meb.U4\ : OR2
      port map(A => \I10.event_meb.net00006\, B => 
        \I10.event_meb.net00007\, Y => FULL);
    
    \I10.FAULT_STROBE_0\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FAULT_STROBE_0_2\, CLR
         => HWRES_c_2_0, Q => \I10.FAULT_STROBE_0_net_1\);
    
    \I1.SSTATESE_13_122\ : AO21
      port map(A => TICKl0r, B => \I1.sstatel9r_net_1\, C => 
        \I1.N_453_i\, Y => \I1.sstate_ns_el0r_adt_net_7201_\);
    
    \I1.CHIP_ADDR_ml1r\ : NAND2
      port map(A => \I1.N_565_i_i\, B => CHIP_ADDRl1r, Y => 
        \I1.CHIP_ADDR_ml1r_net_1\);
    
    \I10.FID_8_RL9R_201\ : OA21FTF
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl9r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l9r_adt_net_23633_\);
    
    \I1.COMMANDl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_9_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl13r_net_1\);
    
    \I10.FID_8_iv_0_0_0_1l22r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl22r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il22r_adt_net_21765_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il22r\);
    
    \I1.sstate2se_4_i\ : MUX2H
      port map(A => \I1.sstate2l5r_net_1\, B => 
        \I1.sstate2l4r_net_1\, S => \I1.N_277_0\, Y => 
        \I1.sstate2se_4_i_net_1\);
    
    \I1.COMMANDl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_8_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl12r_net_1\);
    
    \I10.un1_CNT_1_I_22\ : XOR2
      port map(A => \I10.CNTL2R_11\, B => 
        \I10.DWACT_ADD_CI_0_g_array_1l0r\, Y => \I10.I_22\);
    
    \I5.SBYTEl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.SBYTE_12_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => FBOUTl6r);
    
    \I2.STATE2_ns_o2l0r\ : NAND2FT
      port map(A => REGl5r, B => \I2.un6_evrdy_i\, Y => 
        \I2.N_1568\);
    
    \I1.AIR_COMMANDl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_44_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl12r_net_1\);
    
    \I10.CRC32_103\ : MUX2H
      port map(A => \I10.CRC32l16r_net_1\, B => \I10.N_1214\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_103_net_1\);
    
    \I10.BNC_CNT_204\ : MUX2H
      port map(A => \I10.BNC_CNTl6r_net_1\, B => 
        \I10.BNC_CNT_4l6r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_204_net_1\);
    
    \I2.LB_s_43\ : MUX2L
      port map(A => \I2.LB_sl29r_Rd1__net_1\, B => 
        \I2.N_3014_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116344_Rd1__net_1\, Y => 
        \I2.LB_sl29r\);
    
    \I2.REG_1l264r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_227_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl264r);
    
    \I2.un1_vsel_5_i_a3_0\ : AND3
      port map(A => AMB_cl5r, B => AMB_cl2r, C => AMB_cl1r, Y => 
        \I2.N_3074_i\);
    
    \I2.REG_1_419\ : MUX2H
      port map(A => VDB_inl30r, B => \I2.REGl504r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_419_net_1\);
    
    \I2.NLBAS_81_460\ : AOI21TTF
      port map(A => \I2.N_2310_1\, B => 
        \I2.STATE5l3r_adt_net_116444_Rd1__net_1\, C => \NLBAS_c\, 
        Y => \I2.nLBAS_81_adt_net_76219_\);
    
    \I2.TCNT1l0r\ : DFF
      port map(CLK => CLKOUT, D => \I2.I_4\, Q => 
        \I2.TCNT1l0r_net_1\);
    
    \I2.PIPEA1l14r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_525_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l14r_net_1\);
    
    \I8.SWORDl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_5_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl4r_net_1\);
    
    \I2.STATE5_ns_i_il0r\ : AOI21FTF
      port map(A => \I2.STATE5_ns_i_i_a2_0_0l0r\, B => 
        \I2.N_2385_adt_net_38045_\, C => \I2.N_2386_1\, Y => 
        \I2.STATE5_ns_i_il0r_net_1\);
    
    \I2.un14_tcnt3_5\ : OR3
      port map(A => \I2.TCNT3_i_0_il4r_net_1\, B => 
        \I2.TCNT3l5r_net_1\, C => \I2.un14_tcnt3_0_i\, Y => 
        \I2.un14_tcnt3_5_i\);
    
    \I2.VDBi_67_0l11r\ : MUX2L
      port map(A => \I2.REGl436r\, B => \I2.REGl452r\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1960\);
    
    \I2.REG_1_322\ : MUX2L
      port map(A => REGl407r, B => VDB_inl14r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_322_net_1\);
    
    \I2.PIPEA1_9_i_a2l28r\ : OR2FT
      port map(A => \I2.N_2830_4\, B => DPRl28r, Y => \I2.N_2870\);
    
    \I10.EVENT_DWORD_136\ : MUX2H
      port map(A => \I10.EVENT_DWORDl3r_net_1\, B => 
        \I10.EVENT_DWORD_18l3r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_136_net_1\);
    
    \I10.EVENT_DWORD_18_rl28r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l28r_net_1\, B => 
        \I10.EVENT_DWORD_18l28r_adt_net_25140_\, Y => 
        \I10.EVENT_DWORD_18l28r\);
    
    \I2.VDBil27r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_603_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil27r_net_1\);
    
    \I10.un1_CNT_1_I_24\ : XOR2
      port map(A => \I10.CNTl4r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_2l0r\, Y => \I10.I_24_0\);
    
    \I10.CNTl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CNT_10_i_0l2r_net_1\, CLR
         => CLEAR_0_0, Q => \I10.CNTL2R_11\);
    
    \I2.REG_1_242\ : MUX2L
      port map(A => \I2.REGL279R_47\, B => VDB_inl14r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_242_net_1\);
    
    \I10.un1_STATE1_14_0_0_1_0\ : OR3
      port map(A => \I10.STATE1l4r_net_1\, B => 
        \I10.STATE1l6r_net_1\, C => \I10.un1_STATE1_14_1\, Y => 
        \I10.un1_STATE1_14_1_0\);
    
    \I2.REG_1_230\ : MUX2L
      port map(A => \I2.REGL267R_35\, B => VDB_inl2r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_230_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l10r\ : AO21
      port map(A => \I10.STATE1L11R_12\, B => REGl58r, C => 
        \I10.FID_8_iv_0_0_0_0_il10r_adt_net_23481_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il10r\);
    
    \I2.VDBi_61l13r\ : MUX2L
      port map(A => LBSP_inl13r, B => \I2.VDBi_59l13r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l13r_net_1\);
    
    \I2.STATE5L2R_513\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_106\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L2R_117\);
    
    \I2.N_3036_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3036\, SET => 
        HWRES_c_2_0, Q => \I2.N_3036_Rd1__net_1\);
    
    \I10.CRC32_3_i_0_0l23r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2329_i_i_0\, Y => \I10.N_1362\);
    
    \I2.LB_s_27\ : MUX2L
      port map(A => \I2.LB_sl13r_Rd1__net_1\, B => 
        \I2.N_3048_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116356_Rd1__net_1\, Y => 
        \I2.LB_sl13r\);
    
    \I2.PIPEB_53\ : MUX2H
      port map(A => \I2.PIPEBl4r_net_1\, B => \I2.N_2577\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_53_net_1\);
    
    \I2.VDBi_85_ml14r\ : NAND3
      port map(A => \I2.VDBil14r_net_1\, B => \I2.STATE1_i_il1r\, 
        C => \I2.N_1721_1\, Y => \I2.VDBi_85_ml14r_net_1\);
    
    \I2.CYCSF1_46\ : OA21TTF
      port map(A => \I2.CYCSF1_net_1\, B => \I2.N_2869\, C => 
        TST_cl0r, Y => \I2.CYCSF1_46_net_1\);
    
    \I2.un2_clear\ : OR2FT
      port map(A => EVRDY_c, B => CLEAR_0_0_18, Y => 
        \I2.un2_clear_i\);
    
    \I2.REG_1_338\ : MUX2L
      port map(A => REGl423r, B => VDB_inl30r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_338_net_1\);
    
    \I10.CRC32l12r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_99_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l12r_net_1\);
    
    SPULSE2_pad : IB33
      port map(PAD => SPULSE2, Y => SPULSE2_c);
    
    SP_PDL_padl13r : IOB33PH
      port map(PAD => SP_PDL(13), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl13r);
    
    \I2.LB_i_7_rl3r\ : AND2FT
      port map(A => \I2.STATE5L4R_ADT_NET_116400_RD1__67\, B => 
        \I2.N_1890\, Y => \I2.LB_i_7l3r_net_1\);
    
    \I3.un4_so_2_0\ : MUX2L
      port map(A => \I3.N_199\, B => \I3.N_197\, S => REGl125r, Y
         => \I3.N_198\);
    
    \I10.FID_8_rl4r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l4r_adt_net_24259_\, Y => \I10.FID_8l4r\);
    
    \I10.CNTl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CNT_10_i_0l0r_net_1\, CLR
         => CLEAR_0_0, Q => \I10.CNTl0r_net_1\);
    
    \I2.un1_STATE1_25_0_0\ : AND3FFT
      port map(A => TST_cl2r, B => \I2.PURGED_net_1\, C => 
        \I2.STATE1l4r_net_1\, Y => 
        \I2.un1_STATE1_25_0_0_adt_net_74952_\);
    
    \I3.un4_so_9_0\ : MUX2L
      port map(A => SP_PDL_inl28r, B => SP_PDL_inl24r, S => 
        REGl124r, Y => \I3.N_205\);
    
    \I2.STATE2l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE2_nsl4r\, CLR => 
        CLEAR_0_0, Q => \I2.STATE2l1r_net_1\);
    
    \I2.REG_1l240r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_203_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl7r);
    
    \I2.LB_il14r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il14r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il14r_Rd1__net_1\);
    
    \I2.REG_1_0l121r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_123_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => MD_PDL_C_7);
    
    \I2.PIPEA1l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_511_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l0r_net_1\);
    
    \I2.LB_i_7l8r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l8r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l8r_Rd1__net_1\);
    
    \I2.REG_1l182r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_172_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl182r);
    
    \I2.PIPEB_73\ : MUX2H
      port map(A => \I2.PIPEBl24r_net_1\, B => \I2.N_2617\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_73_net_1\);
    
    \I2.BLTCYC_105\ : OA21TTF
      port map(A => \I2.BLTCYC_net_1\, B => \I2.N_2887_i_i\, C
         => TST_cl0r, Y => \I2.BLTCYC_105_net_1\);
    
    \I2.LB_i_7l17r\ : AND2
      port map(A => VDB_inl17r, B => \I2.STATE5L2R_74\, Y => 
        \I2.LB_i_7l17r_net_1\);
    
    \I2.REG_1_324\ : MUX2L
      port map(A => REGl409r, B => VDB_inl16r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_324_net_1\);
    
    \I2.REG_1l401r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_316_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl401r);
    
    AE_PDL_padl22r : OB33PH
      port map(PAD => AE_PDL(22), A => AE_PDL_cl22r);
    
    \I2.REG_1_398\ : MUX2H
      port map(A => VDB_inl9r, B => \I2.REGl483r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_398_net_1\);
    
    \I2.LB_i_7l23r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l23r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l23r_Rd1__net_1\);
    
    \I10.BNC_CNT_213\ : MUX2H
      port map(A => \I10.BNC_CNTl15r_net_1\, B => 
        \I10.BNC_CNT_4l15r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_213_net_1\);
    
    \I2.VDBil11r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_587_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil11r_net_1\);
    
    \I10.FID_8_RL2R_215\ : AO21FTT
      port map(A => GA_cl2r, B => \I10.N_2288\, C => 
        \I10.FID_8_0_iv_0_0_0_0_il2r\, Y => 
        \I10.FID_8l2r_adt_net_24503_\);
    
    \I2.REG_1_376\ : MUX2H
      port map(A => VDB_inl4r, B => REGl461r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_376_net_1\);
    
    \I2.VDBi_54_0_iv_5l7r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il7r\, B => 
        \I2.VDBi_54_0_iv_0_il7r\, C => \I2.VDBi_54_0_iv_1_il7r\, 
        Y => \I2.VDBi_54_0_iv_5_il7r\);
    
    \I2.un10_reg_ads_0_a3_0\ : NAND2
      port map(A => \I2.LWORDS_net_1\, B => \I2.N_3006_2\, Y => 
        \I2.N_3057\);
    
    \I10.un1_I2C_RREQ_1_sqmuxa_0_0_0\ : OR3
      port map(A => \I10.N_2357\, B => \I10.STATE1l12r_net_1\, C
         => \I10.N_2356\, Y => \I10.un1_I2C_RREQ_1_sqmuxa\);
    
    \I2.REG_il442r\ : INV
      port map(A => \I2.REGl442r\, Y => REG_i_0l442r);
    
    \I2.REG_1_145\ : MUX2L
      port map(A => REGl155r, B => VDB_inl2r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_145_net_1\);
    
    \I1.BITCNT_2_sqmuxa_0_a3\ : AND2
      port map(A => \I1.N_468\, B => \I1.N_401\, Y => 
        \I1.BITCNT_2_sqmuxa\);
    
    \I2.VASl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_88_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl6r_net_1\);
    
    AE_PDL_padl24r : OB33PH
      port map(PAD => AE_PDL(24), A => AE_PDL_cl24r);
    
    \I2.VDBi_5l1r\ : AND2
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl1r\, Y => 
        \I2.VDBi_5l1r_net_1\);
    
    \I2.PIPEA_563\ : MUX2L
      port map(A => \I2.PIPEAl19r_net_1\, B => \I2.PIPEA_8l19r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_563_net_1\);
    
    \I10.BNCRES_CNT_4_G_1_2\ : XOR2
      port map(A => \I10.BNCRES_CNTl7r_net_1\, B => 
        \I10.G_1_1_net_1\, Y => \I10.BNCRES_CNT_4l7r\);
    
    \I2.un70_reg_ads_0_a2_0_a2_1\ : NAND2
      port map(A => \I2.WRITES_net_1\, B => \I2.N_3060\, Y => 
        \I2.N_3000_1\);
    
    \I2.LB_i_7l19r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l19r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l19r_Rd1__net_1\);
    
    \I2.LB_il0r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il0r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il0r_Rd1__net_1\);
    
    \I2.REG_il446r\ : INV
      port map(A => \I2.REGl446r\, Y => REG_i_0l446r);
    
    \I2.REG_1_420_e_1\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl13r_net_1\, Y => \I2.N_3625_i_1\);
    
    \I2.REG_1l429r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_344_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl429r);
    
    \I10.READ_PDL_FLAG_86_0_0_0_285\ : AND3FTT
      port map(A => \I10.STATE1l7r_net_1\, B => 
        \I10.READ_PDL_FLAG_net_1\, C => \I10.N_2380_1\, Y => 
        \I10.READ_PDL_FLAG_86_0_0_0_adt_net_32635_\);
    
    \I2.TCNT_10_rl0r\ : OA21FTT
      port map(A => \I2.N_1826_0\, B => 
        \I2.DWACT_ADD_CI_0_partial_suml0r\, C => 
        \I2.TCNT_0_sqmuxa\, Y => \I2.TCNT_10l0r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I51_Y\ : AO21TTF
      port map(A => \I10.N292\, B => 
        \I10.ADD_16x16_medium_I51_un1_Y_2\, C => 
        \I10.ADD_16x16_medium_I51_Y_2\, Y => \I10.N300\);
    
    NOE32W_pad : OB33PH
      port map(PAD => NOE32W, A => NOE32W_c_c);
    
    \I2.LB_s_4_i_a2_0_a2l15r\ : OR2
      port map(A => LB_inl15r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__69\, Y => \I2.N_3050\);
    
    \I2.un1_STATE2_12_0_o3_2_a3_1\ : NAND2
      port map(A => \I2.PIPEAl28r_net_1\, B => 
        \I2.PIPEAl30r_net_1\, Y => \I2.N_3058_1_i_i\);
    
    \I1.SBYTEl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SBYTE_29_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SBYTEl1r_net_1\);
    
    \I2.REG_92l84r\ : AND2
      port map(A => \I2.N_1826_0\, B => \I2.N_1987\, Y => 
        \I2.REG_92l84r_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l11r\ : XOR2FT
      port map(A => \I10.CRC32l11r_net_1\, B => 
        \I10.EVENT_DWORDl11r_net_1\, Y => \I10.N_2325_i_i_0\);
    
    \I2.REG_1l276r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_239_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl276r\);
    
    \I10.STATE1_ns_0l1r\ : NAND2
      port map(A => \I10.N_2381\, B => \I10.N_2382\, Y => 
        \I10.STATE1_nsl1r\);
    
    \I10.un2_i2c_chain_0_0_0_0l0r\ : OR3FTT
      port map(A => \I10.N_2290\, B => \I10.N_2358\, C => 
        \I10.N_2359\, Y => \I10.N_245\);
    
    \I8.sstate_ns_i_a2_0_0l0r\ : OAI21FTT
      port map(A => \I8.sstatel1r_net_1\, B => 
        \I8.BITCNTl3r_net_1\, C => \I8.sstatel0r_net_1\, Y => 
        \I8.sstate_ns_i_a2_0_il0r\);
    
    \I2.VADml11r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl11r_net_1\, Y
         => \I2.VADml11r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I69_Y_1\ : XOR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl37r\, Y => 
        \I10.un1_REG_1_1l37r\);
    
    \I10.BNCRES_CNT_4_I_53\ : AND2
      port map(A => \I10.BNCRES_CNTl4r_net_1\, B => 
        \I10.BNCRES_CNTl5r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_pog_array_1_1l0r\);
    
    TST_padl11r : OB33PH
      port map(PAD => TST(11), A => \GND\);
    
    \I1.AIR_CHAIN_m_0\ : AND3
      port map(A => I2C_RREQ, B => \I1.AIR_CHAIN_net_1\, C => 
        REGl7r, Y => \I1.AIR_CHAIN_m_0_i\);
    
    \I1.un1_AIR_CHAIN_1_sqmuxa_5\ : AND3FTT
      port map(A => \I1.N_3146_i\, B => \I1.sstate2_0_sqmuxa_3\, 
        C => \I1.un1_AIR_CHAIN_1_sqmuxa_5_adt_net_8909_\, Y => 
        \I1.un1_AIR_CHAIN_1_sqmuxa_5_net_1\);
    
    \I5.RESCNTl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l15r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl15r_net_1\);
    
    \I3.un16_ae_31_2\ : NAND2
      port map(A => REGl125r, B => REGl126r, Y => 
        \I3.un16_ae_2l31r\);
    
    \I2.TCNT_0_sqmuxa_0_a3\ : NAND2FT
      port map(A => \I2.N_1717\, B => \I2.REGMAP_i_0_il15r\, Y
         => \I2.TCNT_0_sqmuxa\);
    
    AE_PDL_padl3r : OB33PH
      port map(PAD => AE_PDL(3), A => AE_PDL_cl3r);
    
    \I5.sstate_0_sqmuxa_1_0_a2_3\ : NAND2
      port map(A => \I5.RESCNTl9r_net_1\, B => 
        \I5.RESCNTl10r_net_1\, Y => 
        \I5.sstate_0_sqmuxa_1_0_a2_3_i\);
    
    \I2.un3_noe32wi_i_0_0_o2\ : NOR2
      port map(A => \I2.LWORDS_net_1\, B => \I2.WRITES_net_1\, Y
         => \I2.N_2863\);
    
    \I2.REG_1_453\ : MUX2H
      port map(A => REGl80r, B => VDB_inl0r, S => \I2.N_3691_i\, 
        Y => \I2.REG_1_453_net_1\);
    
    \I2.LB_i_492\ : MUX2L
      port map(A => \I2.LB_il14r_Rd1__net_1\, B => 
        \I2.LB_i_7l14r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__84\, Y => \I2.LB_il14r\);
    
    \I10.CHANNELl1r\ : DFF
      port map(CLK => CLKOUT, D => \I10.CHANNEL_125_net_1\, Q => 
        CHANNELl1r);
    
    \I2.un1_STATE1_14_0_o3_i_a2\ : NOR2
      port map(A => \I2.STATE1l6r_net_1\, B => 
        \I2.STATE1l9r_net_1\, Y => \I2.N_2913\);
    
    \I2.REG_92l85r\ : AND2
      port map(A => \I2.N_1826_0\, B => \I2.N_1988\, Y => 
        \I2.REG_92l85r_net_1\);
    
    \I8.un1_BITCNT_I_19\ : AND2
      port map(A => \I8.DWACT_ADD_CI_0_TMPl0r\, B => 
        \I8.BITCNTl1r_net_1\, Y => 
        \I8.DWACT_ADD_CI_0_g_array_1l0r\);
    
    \I5.un1_sstate_12_0\ : OR2FT
      port map(A => \I5.N_212\, B => \I5.sstate_i_0_il4r\, Y => 
        \I5.un1_sstate_12\);
    
    \I10.REG_1l45r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I77_Y\, 
        CLR => CLEAR_0_0, Q => REGl45r);
    
    \I2.REG_92_0l82r\ : MUX2H
      port map(A => VDB_inl1r, B => REGl82r, S => 
        \I2.REG_1_sqmuxa_1\, Y => \I2.N_1985\);
    
    \I1.COMMAND_7\ : MUX2H
      port map(A => \I1.COMMANDl11r_net_1\, B => 
        \I1.COMMAND_4l11r_net_1\, S => \I1.SSTATEL13R_8\, Y => 
        \I1.COMMAND_7_net_1\);
    
    \I1.un1_sstate2_9_i\ : NOR3
      port map(A => \I1.sstate2l6r_net_1\, B => 
        \I1.sstate2l9r_net_1\, C => \I1.N_565_i_i\, Y => 
        \I1.N_256\);
    
    \I2.VDBi_24l17r\ : MUX2L
      port map(A => \I2.REGl491r\, B => \I2.VDBi_19l17r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l17r_net_1\);
    
    \I2.EVREADi_142\ : MUX2H
      port map(A => EVREAD, B => \I2.STATE2l2r_net_1\, S => 
        \I2.N_2645\, Y => \I2.EVREADi_142_net_1\);
    
    \I1.un1_tick_6_i\ : OAI21
      port map(A => \I1.sstate2l1r_net_1\, B => 
        \I1.sstate2l0r_net_1\, C => TICKl0r, Y => \I1.N_276\);
    
    \I2.PIPEB_50\ : MUX2H
      port map(A => \I2.PIPEBl1r_net_1\, B => \I2.N_2571\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_50_net_1\);
    
    \I2.DSSF1_2_0_a2\ : NAND2
      port map(A => DS0B_c, B => DS1B_c, Y => \I2.N_2869\);
    
    \I8.SWORD_5l0r\ : AND2
      port map(A => \I8.sstate_d_0l3r\, B => REGl249r, Y => 
        \I8.SWORD_5l0r_net_1\);
    
    \I2.REG_1l193r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_183_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl193r);
    
    \I10.BNCRES_CNT_4_G_1_1_0\ : AND2
      port map(A => BNC_RES, B => \I10.BNCRES_CNTl6r_net_1\, Y
         => \I10.G_1_1_0_net_1\);
    
    \I2.REG_1_457\ : MUX2H
      port map(A => REGl84r, B => \I2.REG_92l84r_net_1\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_457_net_1\);
    
    \I2.LB_il6r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il6r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il6r_Rd1__net_1\);
    
    \I10.CRC32_3_i_0_0l4r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2323_i_i_0\, Y => \I10.N_1348\);
    
    \I2.REG_1_350\ : MUX2H
      port map(A => VDB_inl10r, B => \I2.REGl435r\, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_350_net_1\);
    
    \I3.un4_so_24_0\ : MUX2L
      port map(A => SP_PDL_inl33r, B => SP_PDL_inl1r, S => 
        REGl127r, Y => \I3.N_220\);
    
    \I10.OR_RADDR_1_sqmuxa_i_o3_0\ : NAND2
      port map(A => \I10.N_2279\, B => \I10.N_2280\, Y => 
        \I10.N_2282\);
    
    \I8.SWORDl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_15_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl14r_net_1\);
    
    \I2.PIPEBl22r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_71_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl22r_net_1\);
    
    \I2.PIPEA1l4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_515_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l4r_net_1\);
    
    \I2.REG_il289r\ : INV
      port map(A => \I2.REGl289r\, Y => REG_i_0l289r);
    
    \I10.FID_8_RL31R_160\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl31r_net_1\, C => \I10.N_2505_i\, Y => 
        \I10.FID_8l31r_adt_net_20590_\);
    
    \I3.un16_ae_11\ : NOR2
      port map(A => \I3.un16_ae_2l15r\, B => \I3.un16_ae_1l11r\, 
        Y => \I3.un16_ael11r\);
    
    \I3.un16_ae_7\ : NOR2
      port map(A => \I3.un16_ae_2l7r\, B => \I3.un16_ae_1l7r\, Y
         => \I3.un16_ael7r\);
    
    VAD_padl5r : IOB33PH
      port map(PAD => VAD(5), A => \I2.VADml5r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl5r);
    
    \I10.CRC32_110\ : MUX2H
      port map(A => \I10.CRC32l23r_net_1\, B => \I10.N_1362\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_110_net_1\);
    
    \I2.REG_1_255\ : MUX2L
      port map(A => \I2.REGL292R_60\, B => VDB_inl27r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_255_net_1\);
    
    \I2.PIPEBl16r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_65_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl16r_net_1\);
    
    SYNC_padl14r : OB33PH
      port map(PAD => SYNC(14), A => REG_cl247r);
    
    \I2.VDBm_0l2r\ : MUX2L
      port map(A => \I2.PIPEAl2r_net_1\, B => \I2.PIPEBl2r_net_1\, 
        S => \I2.BLTCYC_17\, Y => \I2.N_2043\);
    
    \I2.PIPEA_562\ : MUX2L
      port map(A => \I2.PIPEAl18r_net_1\, B => \I2.PIPEA_8l18r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_562_net_1\);
    
    \I2.LB_i_7l27r\ : AND2
      port map(A => VDB_inl27r, B => \I2.STATE5L2R_72\, Y => 
        \I2.LB_i_7l27r_net_1\);
    
    VDB_padl10r : IOB33PH
      port map(PAD => VDB(10), A => \I2.VDBml10r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl10r);
    
    \I2.VDBm_0l8r\ : MUX2L
      port map(A => \I2.PIPEAl8r_net_1\, B => \I2.PIPEBl8r_net_1\, 
        S => \I2.BLTCYC_net_1\, Y => \I2.N_2049\);
    
    \I2.un11_tcnt2_5\ : OR3
      port map(A => \I2.TCNT2_i_0_il4r_net_1\, B => 
        \I2.TCNT2l5r_net_1\, C => \I2.un11_tcnt2_0_i\, Y => 
        \I2.un11_tcnt2_5_i\);
    
    \I2.REG_1_336\ : MUX2L
      port map(A => REGl421r, B => VDB_inl28r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_336_net_1\);
    
    \I2.VDBi_56l19r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l19r_net_1\, Y => \I2.VDBi_56l19r_net_1\);
    
    AE_PDL_padl43r : OB33PH
      port map(PAD => AE_PDL(43), A => AE_PDL_cl43r);
    
    \I2.REG_il270r\ : INV
      port map(A => \I2.REGl270r\, Y => REG_i_0l270r);
    
    \I10.CRC32_3_i_0_0_x3l21r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl21r_net_1\, B => 
        \I10.CRC32l21r_net_1\, Y => \I10.N_2328_i_i_0\);
    
    \I2.VDBi_19l26r\ : AND2
      port map(A => TST_cl5r, B => REGl74r, Y => 
        \I2.VDBi_19l26r_net_1\);
    
    \I2.PIPEB_70\ : MUX2H
      port map(A => \I2.PIPEBl21r_net_1\, B => \I2.N_2611\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_70_net_1\);
    
    \I2.LB_sl20r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl20r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl20r_Rd1__net_1\);
    
    \I2.LB_s_24\ : MUX2L
      port map(A => \I2.LB_sl10r_Rd1__net_1\, B => 
        \I2.N_3045_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116356_Rd1__net_1\, Y => 
        \I2.LB_sl10r\);
    
    \I2.REG_1_372\ : MUX2H
      port map(A => VDB_inl0r, B => REGl457r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_372_net_1\);
    
    \I2.PIPEA_8_rl22r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl22r, C => 
        \I2.PIPEA_8l22r_adt_net_56097_\, Y => \I2.PIPEA_8l22r\);
    
    \I5.BITCNTl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.BITCNT_6l0r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.BITCNTl0r_net_1\);
    
    \I10.un1_CNT_1_I_23\ : XOR2
      port map(A => \I10.CNTl3r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_12l0r\, Y => \I10.I_23\);
    
    \I10.STATE1_ns_0_a2l1r\ : NAND2
      port map(A => \I10.STATE1l12r_net_1\, B => REGl5r, Y => 
        \I10.N_2381\);
    
    \I3.un16_ae_9\ : NOR2
      port map(A => \I3.un16_ae_2l15r\, B => \I3.un16_ae_1l1r\, Y
         => \I3.un16_ael9r\);
    
    \I1.AIR_COMMAND_21_0_IVL15R_130\ : AND2
      port map(A => \I1.sstate2l9r_net_1\, B => REGl104r, Y => 
        \I1.AIR_COMMAND_21l15r_adt_net_8646_\);
    
    \I2.VDBi_24l11r\ : MUX2L
      port map(A => \I2.REGl485r\, B => \I2.VDBi_19l11r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l11r_net_1\);
    
    \I2.N_3035_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3035\, SET => 
        HWRES_c_2_0, Q => \I2.N_3035_Rd1__net_1\);
    
    \I2.UN1_STATE5_9_1_RD1__505\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.un1_STATE5_9_1\, CLR => 
        HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__90\);
    
    \I2.UN1_STATE5_9_1_RD1__493\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_91\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__78\);
    
    DIR_CTTM_padl0r : OB33PH
      port map(PAD => DIR_CTTM(0), A => \VCC\);
    
    \I2.N_1705_i_0_a2_1\ : OR2FT
      port map(A => \I2.STATE1l8r_net_1\, B => 
        \I2.REGMAPl0r_net_1\, Y => \I2.N_1705_i_0_1\);
    
    \I3.un16_ae_35\ : NOR2
      port map(A => \I3.un16_ae_2l43r\, B => \I3.un16_ae_1l39r\, 
        Y => \I3.un16_ael35r\);
    
    \I2.REG3l506r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_506_141_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => REGl506r);
    
    \I10.EVENT_DWORD_146\ : MUX2H
      port map(A => \I10.EVENT_DWORDl13r_net_1\, B => 
        \I10.EVENT_DWORD_18l13r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_146_net_1\);
    
    \I2.REG_1_396\ : MUX2H
      port map(A => VDB_inl7r, B => \I2.REGl481r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_396_net_1\);
    
    \I3.AEl23r\ : MUX2L
      port map(A => REGl176r, B => \I3.un16_ael23r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl23r);
    
    \I2.PIPEA_8_rl31r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl31r, C => 
        \I2.PIPEA_8l31r_adt_net_55425_\, Y => \I2.PIPEA_8l31r\);
    
    \I2.TCNT1_i_0_il1r\ : DFF
      port map(CLK => CLKOUT, D => \I2.I_5_0\, Q => 
        \I2.TCNT1_i_0_il1r_net_1\);
    
    \I2.STATE5L4R_ADT_NET_116400_RD1__485\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_ns_i_il0r_net_1\, 
        SET => HWRES_c_2_0, Q => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__70\);
    
    \I1.AIR_COMMAND_21_0_ivl15r\ : AO21
      port map(A => \I1.sstate2l6r_net_1\, B => CHANNELl2r, C => 
        \I1.AIR_COMMAND_21l15r_adt_net_8646_\, Y => 
        \I1.AIR_COMMAND_21l15r\);
    
    \I10.FID_8_0_IV_0_0_0_0L3R_212\ : AND2
      port map(A => \I10.STATE1L11R_12\, B => REGl51r, Y => 
        \I10.FID_8_0_iv_0_0_0_0_il3r_adt_net_24342_\);
    
    \I2.VDBi_86_iv_0l11r\ : AOI21TTF
      port map(A => \I2.VDBil11r_net_1\, B => 
        \I2.STATE1l2r_net_1\, C => \I2.VDBi_85_ml11r_net_1\, Y
         => \I2.VDBi_86_iv_0l11r_net_1\);
    
    \I2.STATE1l3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE1_ns_il6r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => \I2.STATE1l3r_net_1\);
    
    \I2.VDBI_54_0_IV_1L10R_367\ : AND2
      port map(A => REG_cl243r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il10r_adt_net_46500_\);
    
    \I10.EVNT_NUM_3_I_40\ : XOR2
      port map(A => \I10.EVNT_NUMl9r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_12_3l0r\, Y => 
        \I10.EVNT_NUM_3l9r\);
    
    \I10.un2_evread_3_i_0\ : AO21FTT
      port map(A => EVREAD, B => \I10.FIFO_END_EVNT_net_1\, C => 
        \I10.N_926_adt_net_20509_\, Y => \I10.N_926\);
    
    LED_padl2r : OB33PH
      port map(PAD => LED(2), A => \VCC\);
    
    \I2.VDBi_17_rl9r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1906_adt_net_46976_\, C => 
        \I2.N_1906_adt_net_46978_\, Y => \I2.VDBi_17l9r\);
    
    \I2.REG_1_ml167r\ : NAND2
      port map(A => REGl167r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml167r_net_1\);
    
    \I2.REG3_119\ : MUX2L
      port map(A => VDB_inl12r, B => \I2.REGl12r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_119_net_1\);
    
    \I10.event_meb.U3\ : OR3
      port map(A => \I10.event_meb.net00003\, B => 
        \I10.event_meb.net00005\, C => \I10.event_meb.net00004\, 
        Y => \I10.event_meb.net00007\);
    
    \I2.un57_reg_ads_0_a2_0_a2\ : NOR3
      port map(A => \I2.N_3065\, B => \I2.N_3006_1\, C => 
        \I2.N_3000_1\, Y => \I2.un57_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.REG_1l266r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_229_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl266r\);
    
    \I5.un1_RESCNT_G_1_2\ : AND2FT
      port map(A => \I5.G_1_3_3_i_adt_net_33073_\, B => 
        \I5.G_net_1\, Y => \I5.DWACT_ADD_CI_0_g_array_1l0r\);
    
    \I2.LB_il22r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il22r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il22r_Rd1__net_1\);
    
    \I10.UN3_BNC_CNT_I_69_155\ : AND2
      port map(A => \I10.BNC_CNTl9r_net_1\, B => 
        \I10.BNC_CNTl10r_net_1\, Y => 
        \I10.DWACT_FINC_El7r_adt_net_18884_\);
    
    \I10.CNT_10_i_0l0r\ : AND2
      port map(A => \I10.N_2287\, B => 
        \I10.DWACT_ADD_CI_0_partial_suml0r\, Y => 
        \I10.CNT_10_i_0l0r_net_1\);
    
    \I2.STATE5_nsl1r\ : AO21FTT
      port map(A => TST_CL2R_16, B => 
        \I2.STATE5L4R_ADT_NET_116396_RD1__101\, C => \I2.N_2383\, 
        Y => \I2.STATE5_nsl1r_net_1\);
    
    \I2.REG3_114\ : MUX2L
      port map(A => VDB_inl7r, B => REGL7R_2, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_114_net_1\);
    
    \I2.VADml17r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl17r_net_1\, Y
         => \I2.VADml17r_net_1\);
    
    \I2.REG_1_374\ : MUX2H
      port map(A => VDB_inl2r, B => REGl459r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_374_net_1\);
    
    \I10.EVNT_NUM_3_I_54\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_2_1l0r\, B => 
        \I10.EVNT_NUMl4r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_12_1_0l0r\);
    
    \I2.REG_1l279r_63\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_242_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL279R_47\);
    
    \I2.VDBI_59L10R_368\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l10r_net_1\, C => \I2.VDBi_54_0_iv_5_il10r\, Y
         => \I2.VDBi_59l10r_adt_net_46576_\);
    
    \I3.un16_ae_36\ : NOR2
      port map(A => \I3.un16_ae_1l44r\, B => \I3.un16_ae_1l39r\, 
        Y => \I3.un16_ael36r\);
    
    \I10.G_1_1\ : XOR2
      port map(A => \I10.BNC_CNTl5r_net_1\, B => REGl462r, Y => 
        \I10.un6_bnc_res_5_i_i_i_i\);
    
    \I10.BNC_CNT_4_0_a2l11r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => \I10.I_66\, 
        Y => \I10.BNC_CNT_4l11r\);
    
    AE_PDL_padl19r : OB33PH
      port map(PAD => AE_PDL(19), A => AE_PDL_cl19r);
    
    \I2.VDBi_61l15r\ : MUX2L
      port map(A => LBSP_inl15r, B => \I2.VDBi_59l15r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l15r_net_1\);
    
    \I2.REG_1l69r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_442_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl69r);
    
    \I2.I_743_0\ : NAND2
      port map(A => \I2.STATE1l8r_net_1\, B => 
        \I2.REGMAPl10r_net_1\, Y => \I2.I_743_0_i\);
    
    \I2.VASl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_97_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl15r_net_1\);
    
    \I2.VDBi_86_iv_2l14r\ : AOI21TTF
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl14r\, C
         => \I2.VDBi_86_iv_1l14r_net_1\, Y => 
        \I2.VDBi_86_iv_2l14r_net_1\);
    
    \I2.PIPEA1_9_il26r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl26r, Y => \I2.N_2549\);
    
    \I5.un1_RESCNT_I_52\ : XOR2
      port map(A => \I5.RESCNTl9r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_12_3l0r\, Y => \I5.I_52_0\);
    
    \I10.REG_1l41r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I73_Y\, 
        CLR => CLEAR_0_0, Q => \I10.REGl41r\);
    
    \I10.L2AF3\ : DFFC
      port map(CLK => ACLKOUT, D => \I10.L2AF2_net_1\, CLR => 
        HWRES_c_2_0, Q => \I10.L2AF3_net_1\);
    
    \I2.VDBi_17_0l13r\ : AND2
      port map(A => REGl45r, B => \I2.REGMAPl6r_net_1\, Y => 
        \I2.N_1910_adt_net_43960_\);
    
    NLBRES_pad : OB33PH
      port map(PAD => NLBRES, A => HWRES_c_i_0);
    
    \I2.REG_1l478r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_393_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl478r\);
    
    \I2.PIPEA1_9_il17r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl17r, Y => \I2.N_2531\);
    
    \I2.TCNT2_2_I_30\ : XOR2
      port map(A => \I2.TCNT2l3r_net_1\, B => 
        \I2.DWACT_ADD_CI_0_g_array_12l0r\, Y => \I2.TCNT2_2l3r\);
    
    \I10.GEN_LCLK_PLL_PLL_lclk_del.Core\ : PLLCORE
      port map(SDOUT => OPEN, SCLK => \GND\, SDIN => \GND\, 
        SSHIFT => \GND\, SUPDATE => \GND\, GLB => CLKOUT, CLK => 
        LCLK_c, GLA => OPEN, CLKA => \GND\, LOCK => 
        \I10.PLL_LOCK_lclk\, MODE => \GND\, FBDIV5 => \GND\, 
        EXTFB => \GND\, FBSEL0 => \VCC\, FBSEL1 => \GND\, FINDIV0
         => \GND\, FINDIV1 => \GND\, FINDIV2 => \GND\, FINDIV3
         => \GND\, FINDIV4 => \GND\, FBDIV0 => \GND\, FBDIV1 => 
        \GND\, FBDIV2 => \GND\, FBDIV3 => \GND\, FBDIV4 => \GND\, 
        STATBSEL => \GND\, DLYB0 => \GND\, DLYB1 => \GND\, OBDIV0
         => \GND\, OBDIV1 => \GND\, STATASEL => \GND\, DLYA0 => 
        \GND\, DLYA1 => \GND\, OADIV0 => \GND\, OADIV1 => \GND\, 
        OAMUX0 => \GND\, OAMUX1 => \GND\, OBMUX0 => \GND\, OBMUX1
         => \GND\, OBMUX2 => \VCC\, FBDLY0 => \GND\, FBDLY1 => 
        \GND\, FBDLY2 => \GND\, FBDLY3 => \GND\, XDLYSEL => \GND\);
    
    LB_padl31r : IOB33PH
      port map(PAD => LB(31), A => \I2.LB_il31r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl31r);
    
    \I2.VDBi_56l24r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l24r_net_1\, Y => \I2.VDBi_56l24r_net_1\);
    
    \I2.TCNT2_2_I_28\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_2l0r\, B => 
        \I2.TCNT2_i_0_il4r_net_1\, Y => \I2.TCNT2_2l4r\);
    
    \I2.REG_1_332\ : MUX2L
      port map(A => REGl417r, B => VDB_inl24r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_332_net_1\);
    
    \I10.FID_8_0_iv_0_0_0_0l3r\ : AO21
      port map(A => \I10.STATE1L1R_14\, B => 
        \I10.EVENT_DWORDl3r_net_1\, C => 
        \I10.FID_8_0_iv_0_0_0_0_il3r_adt_net_24342_\, Y => 
        \I10.FID_8_0_iv_0_0_0_0_il3r\);
    
    VAD_padl2r : IOB33PH
      port map(PAD => VAD(2), A => \I2.VADml2r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl2r);
    
    \I1.AIR_COMMANDl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_42_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl10r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I51_Y_2\ : AND3FFT
      port map(A => \I10.N273\, B => 
        \I10.ADD_16x16_medium_I51_Y_0_i\, C => \I10.N257_i\, Y
         => \I10.ADD_16x16_medium_I51_Y_2\);
    
    \I2.PIPEA_8_rl6r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl6r, C => 
        \I2.PIPEA_8l6r_adt_net_57254_\, Y => \I2.PIPEA_8l6r\);
    
    \I5.SBYTE_5l5r\ : MUX2L
      port map(A => REGl86r, B => FBOUTl4r, S => 
        \I5.sstatel5r_net_1\, Y => \I5.SBYTE_5l5r_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l26r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl10r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il26r_adt_net_21151_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il26r\);
    
    \I2.REG_1l60r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_433_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl60r);
    
    \I2.PIPEA_561\ : MUX2L
      port map(A => \I2.PIPEAl17r_net_1\, B => \I2.PIPEA_8l17r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_561_net_1\);
    
    \I2.REG_1_424\ : MUX2H
      port map(A => VDB_inl3r, B => REGl51r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_424_net_1\);
    
    \I1.SBYTE_9_il3r\ : MUX2H
      port map(A => \I1.SBYTEl2r_net_1\, B => 
        \I1.COMMANDl11r_net_1\, S => \I1.N_625_0\, Y => 
        \I1.N_602\);
    
    \I2.PIPEA_8_RL27R_426\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l27r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l27r_adt_net_55747_\);
    
    AE_PDL_padl40r : OB33PH
      port map(PAD => AE_PDL(40), A => AE_PDL_cl40r);
    
    \I10.EVENT_DWORD_18_RL21R_233\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl21r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l21r_adt_net_26218_\);
    
    \I2.WDOG_3_I_15\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_TMP_1l0r\, B => 
        \I2.WDOGl1r_net_1\, Y => \I2.WDOG_3l1r\);
    
    \I1.sstatese_6_i_0\ : MUX2H
      port map(A => \I1.sstatel6r_net_1\, B => 
        \I1.sstatel7r_net_1\, S => TICKl0r, Y => 
        \I1.sstatese_6_i_0_net_1\);
    
    \I10.BNC_NUMBER_238\ : MUX2L
      port map(A => \I10.BNCRES_CNTl8r_net_1\, B => 
        \I10.BNC_NUMBERl8r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_238_net_1\);
    
    \I10.L1AF1\ : DFFC
      port map(CLK => ACLKOUT, D => L1A_c, CLR => HWRES_c_2_0, Q
         => \I10.L1AF1_net_1\);
    
    \I2.REG_1_392\ : MUX2H
      port map(A => VDB_inl3r, B => \I2.REGl477r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_392_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I66_Y\ : XOR2
      port map(A => \I10.N267\, B => 
        \I10.ADD_16x16_medium_I66_Y_0\, Y => 
        \I10.ADD_16x16_medium_I66_Y\);
    
    \I2.VDBi_86_iv_2l13r\ : AOI21TTF
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl13r\, C
         => \I2.VDBi_86_iv_1l13r_net_1\, Y => 
        \I2.VDBi_86_iv_2l13r_net_1\);
    
    \I2.un1_STATE5_9_0_1\ : OR3
      port map(A => \I2.STATE5L1R_RD1__100\, B => \I2.N_2389\, C
         => \I2.STATE5L0R_111\, Y => \I2.un1_STATE5_9_0_1_i\);
    
    \I2.VDBi_54_0_iv_2l8r\ : AO21
      port map(A => REGl177r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.VDBi_54_0_iv_2_il8r_adt_net_48130_\, Y => 
        \I2.VDBi_54_0_iv_2_il8r\);
    
    \I10.FID_174\ : MUX2L
      port map(A => \I10.FID_8l9r\, B => \I10.FIDl9r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_174_net_1\);
    
    \I2.un3_asb_0\ : XOR2FT
      port map(A => VAD_inl28r, B => GA_cl0r, Y => 
        \I2.un3_asb_0_net_1\);
    
    \I1.COMMANDl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_11_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl15r_net_1\);
    
    \I10.FIDl31r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_196_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl31r_net_1\);
    
    SP_PDL_padl24r : IOB33PH
      port map(PAD => SP_PDL(24), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl24r);
    
    \I3.sstatel1r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.N_184_i\, CLR => 
        HWRES_c_2_0, Q => \I3.sstatel1r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I20_Y\ : OA21
      port map(A => \I10.REGl40r\, B => \I10.REGl41r\, C => 
        \I10.N_2519_1\, Y => \I10.N259\);
    
    \I2.VDBi_54_0_iv_1l13r\ : AO21
      port map(A => REGl198r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il13r_adt_net_44238_\, Y => 
        \I2.VDBi_54_0_iv_1_il13r\);
    
    \I1.sstatese_2_0_0\ : MUX2H
      port map(A => \I1.sstatel10r_net_1\, B => \I1.N_690\, S => 
        TICKl0r, Y => \I1.sstate_ns_el3r\);
    
    \I2.TCNT3_i_0_il4r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT3_2l4r\, Q => 
        \I2.TCNT3_i_0_il4r_net_1\);
    
    \I10.UN2_I2C_CHAIN_0_0_0_0L6R_281\ : NAND3FFT
      port map(A => \I10.N_3170_i\, B => 
        \I10.un2_i2c_chain_0_0_0_0_1_il6r_adt_net_30046_\, C => 
        \I10.N_2376\, Y => \I10.N_251_adt_net_30085_\);
    
    \I1.un1_tick_10_0\ : OR2
      port map(A => \I1.BITCNT_0_sqmuxa_2\, B => \I1.N_468\, Y
         => \I1.un1_tick_10_0_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_0l1r\ : OAI21TTF
      port map(A => \I10.N_2650\, B => \I10.N_2298\, C => 
        \I10.un2_i2c_chain_0_0_0_0_0_il1r_adt_net_29771_\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_0_il1r\);
    
    \I2.REG_1_334\ : MUX2L
      port map(A => REGl419r, B => VDB_inl26r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_334_net_1\);
    
    \I2.VDBm_0l15r\ : MUX2L
      port map(A => \I2.PIPEAl15r_net_1\, B => 
        \I2.PIPEBl15r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2056\);
    
    \I2.VDBi_592\ : MUX2L
      port map(A => \I2.VDBil16r_net_1\, B => \I2.VDBi_86l16r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_592_net_1\);
    
    \I2.VDBI_17_0L11R_361\ : AOI21
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl11r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1908_adt_net_45470_\);
    
    \I10.CRC32_92\ : MUX2H
      port map(A => \I10.CRC32l5r_net_1\, B => \I10.N_1724\, S
         => \I10.N_2351\, Y => \I10.CRC32_92_net_1\);
    
    \I10.un1_STATE1_15_0_0_0_0_a2\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => PULSEl3r, Y => 
        \I10.STATE1_nsl2r\);
    
    \I1.BITCNT_0_sqmuxa_2_0_a3\ : AND2
      port map(A => TICKl0r, B => 
        \I1.BITCNT_0_sqmuxa_2_adt_net_7280_\, Y => 
        \I1.BITCNT_0_sqmuxa_2\);
    
    \I2.REG_1l191r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_181_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl191r);
    
    AE_PDL_padl21r : OB33PH
      port map(PAD => AE_PDL(21), A => AE_PDL_cl21r);
    
    \I2.PIPEBl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_50_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl1r_net_1\);
    
    \I1.sstatese_7_0_0\ : AOI21FTF
      port map(A => TICKl0r, B => \I1.sstatel5r_net_1\, C => 
        \I1.N_435\, Y => \I1.sstatese_7_0_0_net_1\);
    
    \I2.un1_STATE2_12_0_o3_2_o2\ : NOR3
      port map(A => \I2.un1_STATE2_12_0_o3_2_o2_0_net_1\, B => 
        \I2.N_2846\, C => \I2.N_2894_2\, Y => \I2.N_2851\);
    
    \I2.REG3_0l7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_114_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl7r);
    
    \I10.STATE1_ns_0_a2_0l10r\ : NOR3FTT
      port map(A => \I10.N_2395_1\, B => 
        \I10.READ_PDL_FLAG_net_1\, C => \I10.READ_OR_FLAG_net_1\, 
        Y => \I10.N_2395_i\);
    
    \I10.STATE1l3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl9r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l3r_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l14r\ : OR2
      port map(A => LB_inl14r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__69\, Y => \I2.N_3049\);
    
    \I10.FID_8_RL7R_205\ : AO21
      port map(A => \I10.STATE1L1R_14\, B => 
        \I10.EVENT_DWORDl7r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il7r\, Y => 
        \I10.FID_8l7r_adt_net_23903_\);
    
    \I2.VDBi_581\ : MUX2L
      port map(A => \I2.VDBil5r_net_1\, B => \I2.VDBi_86l5r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_581_net_1\);
    
    \I2.VDBil0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_576_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil0r_net_1\);
    
    \I10.FID_8_rl19r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il19r\, B => 
        \I10.FID_8_iv_0_0_0_0_il19r\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l19r\);
    
    \I2.LB_i_7l9r\ : AND2
      port map(A => VDB_inl9r, B => \I2.STATE5l2r_net_1\, Y => 
        \I2.LB_i_7l9r_net_1\);
    
    AE_PDL_padl4r : OB33PH
      port map(PAD => AE_PDL(4), A => AE_PDL_cl4r);
    
    \I2.REG_1_394\ : MUX2H
      port map(A => VDB_inl5r, B => \I2.REGl479r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_394_net_1\);
    
    \I2.VDBI_54_0_IV_1L5R_390\ : AND2
      port map(A => SYNC_cl5r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il5r_adt_net_50560_\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L10R_254\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl18r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l10r_adt_net_27462_\);
    
    \I2.VDBi_54_0_iv_2l12r\ : AOI21TTF
      port map(A => REGl181r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml165r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l12r_net_1\);
    
    \I2.VDBi_86_iv_0l4r\ : AO21TTF
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.VDBi_82l4r_net_1\, C => \I2.VDBi_85_ml4r_net_1\, Y
         => \I2.VDBi_86_iv_0_il4r\);
    
    \I2.PIPEB_65\ : MUX2H
      port map(A => \I2.PIPEBl16r_net_1\, B => \I2.N_2601\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_65_net_1\);
    
    \I2.un119_reg_ads_0_a2\ : NOR2FT
      port map(A => \I2.N_3013_3\, B => \I2.N_3064\, Y => 
        \I2.un119_reg_ads_0_a2_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l12r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl12r_net_1\, B => 
        \I10.CRC32l12r_net_1\, Y => \I10.N_2333_i_i_0\);
    
    \I2.REG_1l485r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_400_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl485r\);
    
    \I3.un16_ae_43\ : NOR2
      port map(A => \I3.un16_ae_3l47r\, B => \I3.un16_ae_2l43r\, 
        Y => \I3.un16_ael43r\);
    
    \I1.SBYTEl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SBYTE_32_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SBYTEl4r_net_1\);
    
    \I2.REG_1l189r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_179_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl189r);
    
    \I2.LB_i_488\ : MUX2L
      port map(A => \I2.LB_il10r_Rd1__net_1\, B => 
        \I2.LB_i_7l10r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__86\, Y => \I2.LB_il10r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I2_P0N\ : OR2
      port map(A => \I10.N_2519_1\, B => REGl34r, Y => \I10.N215\);
    
    \I10.FID_8_iv_0_0_0_0l9r\ : OAI21FTF
      port map(A => \I10.STATE1l11r_net_1\, B => REGl57r, C => 
        \I10.FID_8_iv_0_0_0_0l9r_adt_net_23603_\, Y => 
        \I10.FID_8_iv_0_0_0_0l9r_net_1\);
    
    \I3.SBYTE_5l0r\ : MUX2H
      port map(A => REGL129R_1, B => \I3.SO_i\, S => 
        \I3.sstatel0r_net_1\, Y => \I3.SBYTE_5l0r_net_1\);
    
    \I2.REG_1_152\ : MUX2L
      port map(A => REGl162r, B => VDB_inl9r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_152_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l8r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl8r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l8r_adt_net_27723_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l8r_net_1\);
    
    \I2.REG_1l468r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_383_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl468r);
    
    \I2.PIPEA1_518\ : MUX2L
      port map(A => \I2.PIPEA1l7r_net_1\, B => \I2.N_2511\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_518_net_1\);
    
    \I2.WDOGl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.WDOG_3l1r\, CLR => 
        \I2.un17_hwres_i\, Q => \I2.WDOGl1r_net_1\);
    
    \I2.VDBi_56l6r\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l6r_net_1\, C => \I2.VDBi_54_0_iv_5_il6r\, Y
         => \I2.VDBi_56l6r_adt_net_49833_\);
    
    \I10.BNCRES_CNTl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNCRES_CNT_4l2r\, CLR => 
        CLEAR_0_0, Q => \I10.BNCRES_CNTl2r_net_1\);
    
    \I2.VADml26r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl26r_net_1\, Y
         => \I2.VADml26r_net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_2l4r\ : NOR3FFT
      port map(A => \I10.CNTl5r_net_1\, B => \I10.N_2283_i_i_0\, 
        C => \I10.CNTl3r_net_1\, Y => 
        \I10.un2_i2c_chain_0_i_i_i_2_il4r_adt_net_30782_\);
    
    \I1.I2C_RDATAl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_17_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl3r);
    
    \I2.TCNT3_2_I_45\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_11_0l0r\, B => 
        \I2.TCNT3_i_0_il6r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_12_2_0l0r\);
    
    \I2.PIPEB_4_il26r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl26r, Y => \I2.N_2621\);
    
    AE_PDL_padl0r : OB33PH
      port map(PAD => AE_PDL(0), A => AE_PDL_cl0r);
    
    \I10.FID_8_0_IV_0_0_0_0L2R_214\ : AND2
      port map(A => \I10.STATE1L11R_12\, B => REGl50r, Y => 
        \I10.FID_8_0_iv_0_0_0_0_il2r_adt_net_24464_\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L13R_248\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl21r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l13r_adt_net_27126_\);
    
    \I8.I_50_0\ : AND2
      port map(A => \I8.BITCNTl2r_net_1\, B => 
        \I8.BITCNTl3r_net_1\, Y => \I8.I_50_0_net_1\);
    
    \I2.VDBi_67l14r\ : MUX2L
      port map(A => \I2.VDBi_61l14r_net_1\, B => \I2.N_1963\, S
         => \I2.N_1965\, Y => \I2.VDBi_67l14r_net_1\);
    
    \I2.un90_reg_ads_0_a2_0_a2\ : AND2
      port map(A => \I2.N_3006_4\, B => 
        \I2.un90_reg_ads_0_a2_0_a2_adt_net_37522_\, Y => 
        \I2.un90_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l30r\ : OR2
      port map(A => LB_inl30r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119373__net_1\, 
        Y => \I2.N_3015\);
    
    \I2.LB_i_7l25r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l25r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l25r_Rd1__net_1\);
    
    \I3.sstate_s1_0_a3\ : AND2FT
      port map(A => \I3.sstatel1r_net_1\, B => 
        \I3.sstatel0r_net_1\, Y => \I3.sstate_dl2r\);
    
    \I2.REG_1l271r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_234_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl271r\);
    
    \I1.COMMAND_4l1r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl1r_net_1\, B => REGl90r, S
         => REGL7R_2, Y => \I1.COMMAND_4l1r_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_o3_1l3r\ : NOR2FT
      port map(A => \I10.CNTl5r_net_1\, B => \I10.CNTl0r_net_1\, 
        Y => \I10.N_2280\);
    
    \I8.SWORD_5l2r\ : MUX2L
      port map(A => REGl251r, B => \I8.SWORDl1r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l2r_net_1\);
    
    \I2.VDBi_54_0_iv_3l4r\ : AO21TTF
      port map(A => \I2.REGMAPl16r_net_1\, B => REGl125r, C => 
        \I2.VDBi_54_0_iv_2l4r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il4r\);
    
    TST_padl3r : OB33PH
      port map(PAD => TST(3), A => TST_C_CL3R_23);
    
    \I1.sstatel2r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el11r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstatel2r_net_1\);
    
    \I2.un1_STATE5_9_0_a2_1_112\ : AND2FT
      port map(A => \I2.REGMAPl35r_net_1\, B => 
        \I2.STATE5l3r_net_1\, Y => \I2.N_2389_96\);
    
    \I3.VALID\ : DFFS
      port map(CLK => CLKOUT, D => \I3.VALID_1_net_1\, SET => 
        HWRES_c_2_0, Q => REGl145r);
    
    \I10.EVNT_TRG_1_f0_i_0_0\ : OA21TTF
      port map(A => \I10.EVNT_TRG_net_1\, B => 
        \I10.STATE2l1r_net_1\, C => \I10.STATE2l0r_net_1\, Y => 
        \I10.N_1041\);
    
    \I10.BNCRES_CNT_4_I_51\ : AND3
      port map(A => \I10.BNCRES_CNTl7r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_pog_array_1_1l0r\, C => 
        \I10.BNCRES_CNTl6r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_pog_array_2_0l0r\);
    
    \I2.STATE5L1R_512\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl2r\, CLR => 
        HWRES_c_2_0, Q => \I2.STATE5L1R_114\);
    
    \I3.UN1_SSTATE_2_I_465\ : AND3
      port map(A => \I3.sstatel0r_net_1\, B => 
        \I3.BITCNTl1r_net_1\, C => \I3.N_195_2\, Y => 
        \I3.N_165_adt_net_80145_\);
    
    \I10.CRC32_3_i_0_0_x3l22r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl22r_net_1\, B => 
        \I10.CRC32l22r_net_1\, Y => \I10.N_2336_i_i_0\);
    
    \I10.CRC32l13r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_100_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l13r_net_1\);
    
    \I2.un11_tcnt2_0\ : OR2
      port map(A => \I2.TCNT2_i_0_il6r_net_1\, B => 
        \I2.TCNT2l7r_net_1\, Y => \I2.un11_tcnt2_0_i\);
    
    \I3.AEl25r\ : MUX2L
      port map(A => REGl178r, B => \I3.un16_ael25r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl25r);
    
    \I2.N_3046_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3046\, SET => 
        HWRES_c_2_0, Q => \I2.N_3046_Rd1__net_1\);
    
    \I2.REG_1_207\ : MUX2L
      port map(A => REG_cl244r, B => VDB_inl11r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_207_net_1\);
    
    \I1.SBYTE_9_IV_0L0R_136\ : AND2
      port map(A => \I1.N_625_0\, B => \I1.COMMANDl8r_net_1\, Y
         => \I1.SBYTE_9l0r_adt_net_10933_\);
    
    \I2.VDBm_0l17r\ : MUX2L
      port map(A => \I2.PIPEAl17r_net_1\, B => 
        \I2.PIPEBl17r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2058\);
    
    \I2.LB_s_19\ : MUX2L
      port map(A => \I2.LB_sl5r_Rd1__net_1\, B => 
        \I2.N_3040_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116360_Rd1__net_1\, Y => 
        \I2.LB_sl5r\);
    
    \I2.TCNT1l5r\ : DFF
      port map(CLK => CLKOUT, D => \I2.I_24_1\, Q => 
        \I2.TCNT1l5r_net_1\);
    
    \I2.VDBil31r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_607_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil31r_net_1\);
    
    \I5.RESCNTl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l4r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl4r_net_1\);
    
    \I10.EVENT_DWORDl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_147_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl14r_net_1\);
    
    \I2.REG_1_429\ : MUX2H
      port map(A => VDB_inl8r, B => REGl56r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_429_net_1\);
    
    \I8.SWORD_5l13r\ : MUX2L
      port map(A => REGl262r, B => \I8.SWORDl12r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l13r_net_1\);
    
    \I1.COMMANDl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_3_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl2r_net_1\);
    
    VAD_padl10r : IOB33PH
      port map(PAD => VAD(10), A => \I2.VADml10r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl10r);
    
    \I10.RDY_CNTl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.RDY_CNT_10_i_0l0r_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.RDY_CNTl0r_net_1\);
    
    \I10.event_meb.M2\ : FIFO256x9SST
      port map(DO8 => OPEN, DO7 => DPRl23r, DO6 => DPRl22r, DO5
         => DPRl21r, DO4 => DPRl20r, DO3 => DPRl19r, DO2 => 
        DPRl18r, DO1 => DPRl17r, DO0 => DPRl16r, FULL => 
        \I10.event_meb.net00005\, EMPTY => OPEN, EQTH => OPEN, 
        GEQTH => OPEN, WPE => OPEN, RPE => OPEN, DOS => OPEN, 
        LGDEP2 => \VCC\, LGDEP1 => \VCC\, LGDEP0 => \VCC\, RESET
         => CLEAR_i_0, LEVEL7 => \GND\, LEVEL6 => \GND\, LEVEL5
         => \GND\, LEVEL4 => \GND\, LEVEL3 => \GND\, LEVEL2 => 
        \GND\, LEVEL1 => \GND\, LEVEL0 => \VCC\, DI8 => \GND\, 
        DI7 => \I10.FIDl23r_net_1\, DI6 => \I10.FIDl22r_net_1\, 
        DI5 => \I10.FIDl21r_net_1\, DI4 => \I10.FIDl20r_net_1\, 
        DI3 => \I10.FIDl19r_net_1\, DI2 => \I10.FIDl18r_net_1\, 
        DI1 => \I10.FIDl17r_net_1\, DI0 => \I10.FIDl16r_net_1\, 
        WRB => \I10.WRB_net_1\, RDB => NRDMEB, WBLKB => \GND\, 
        RBLKB => \GND\, PARODD => \GND\, WCLKS => CLKOUT, RCLKS
         => CLKOUT, DIS => \GND\);
    
    \I2.VDBi_54_0_iv_2l14r\ : AOI21TTF
      port map(A => REGl183r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml167r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l14r_net_1\);
    
    \I2.TCNT1_i_0_il4r\ : DFF
      port map(CLK => CLKOUT, D => \I2.I_20_1\, Q => 
        \I2.TCNT1_i_0_il4r_net_1\);
    
    \I10.EVENT_DWORD_153\ : MUX2H
      port map(A => \I10.EVENT_DWORDl20r_net_1\, B => 
        \I10.EVENT_DWORD_18l20r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_153_net_1\);
    
    \I2.PIPEBl21r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_70_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl21r_net_1\);
    
    \I2.REG_1_474\ : MUX2H
      port map(A => VDB_inl12r, B => REGl101r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_474_net_1\);
    
    \I2.VDBI_86_IV_1L6R_387\ : AND2
      port map(A => \I2.PIPEAl6r_net_1\, B => \I2.N_1707_i_0_1\, 
        Y => \I2.VDBi_86_iv_1_il6r_adt_net_49958_\);
    
    \I2.VAS_88\ : MUX2L
      port map(A => VAD_inl6r, B => \I2.VASl6r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_88_net_1\);
    
    \I2.REGMAPl17r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un57_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAP_i_il17r\);
    
    \I2.un1_STATE5_9_0_a2_0\ : AND2FT
      port map(A => \I2.SINGCYC_net_1\, B => \I2.STATE5L3R_98\, Y
         => \I2.N_2383\);
    
    \I2.LB_sl1r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl1r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl1r_Rd1__net_1\);
    
    \I2.LB_il24r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il24r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il24r_Rd1__net_1\);
    
    \I10.FID_185\ : MUX2L
      port map(A => \I10.FID_8l20r\, B => \I10.FIDl20r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_185_net_1\);
    
    \I2.LB_i_478\ : MUX2L
      port map(A => \I2.LB_il0r_Rd1__net_1\, B => 
        \I2.LB_i_7l0r_Rd1__net_1\, S => 
        \I2.un1_STATE5_9_1_Rd1__net_1\, Y => \I2.LB_il0r\);
    
    AE_PDL_padl33r : OB33PH
      port map(PAD => AE_PDL(33), A => AE_PDL_cl33r);
    
    \I2.REG_1_209\ : MUX2L
      port map(A => REG_cl246r, B => VDB_inl13r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_209_net_1\);
    
    \I2.REGMAP_i_il26r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un94_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAP_i_il26r_net_1\);
    
    \I10.BNC_CNT_217\ : MUX2H
      port map(A => \I10.BNC_CNTl19r_net_1\, B => 
        \I10.BNC_CNT_4l19r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_217_net_1\);
    
    \I3.SBYTEl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.SBYTE_10_0\, CLR => 
        HWRES_c_2_0, Q => REGl144r);
    
    \I2.VDBi_24l22r\ : MUX2L
      port map(A => \I2.REGl496r\, B => \I2.VDBi_19l22r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l22r_net_1\);
    
    \I8.SWORDl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_8_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl7r_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l18r\ : AO21
      port map(A => \I10.STATE1l2r_net_1\, B => 
        \I10.EVNT_NUMl2r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il18r_adt_net_22463_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il18r\);
    
    \I2.EVREAD_DS_1_sqmuxa_0_a2\ : OR2FT
      port map(A => \I2.N_2894_2\, B => \I2.N_2894_1\, Y => 
        \I2.N_2883\);
    
    \I2.VDBi_54_0_iv_6l1r\ : NOR3
      port map(A => \I2.VDBi_54_0_iv_5_il1r\, B => 
        \I2.VDBi_54_0_iv_2_il1r\, C => \I2.VDBi_54_0_iv_0_il1r\, 
        Y => \I2.VDBi_54_0_iv_6l1r_net_1\);
    
    NOE32R_pad : OB33PH
      port map(PAD => NOE32R, A => \I2.N_2732_i_0\);
    
    \I2.VDBi_61_dl1r\ : MUX2L
      port map(A => LBSP_inl1r, B => L1A_c, S => 
        \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61_dl1r_net_1\);
    
    \I2.LB_i_7l0r\ : AND2
      port map(A => VDB_inl0r, B => \I2.STATE5L1R_105\, Y => 
        \I2.LB_i_7l0r_net_1\);
    
    \I10.BNCRES_CNTl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNCRES_CNT_4l5r\, CLR => 
        CLEAR_0_0, Q => \I10.BNCRES_CNTl5r_net_1\);
    
    \I2.TICKl1r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un11_tcnt2_net_1\, Q => 
        \I2.TICKl1r_net_1\);
    
    \I2.REG_1l250r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_213_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl250r);
    
    \I1.AIR_COMMANDl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_46_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl14r_net_1\);
    
    \I2.VDBI_54_0_IV_1L8R_374\ : AND2
      port map(A => REGl257r, B => \I2.REGMAPl24r_net_1\, Y => 
        \I2.VDBi_54_0_iv_1_il8r_adt_net_48088_\);
    
    \I2.LB_i_7l21r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l21r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l21r_Rd1__net_1\);
    
    \I10.un2_i2c_chain_0_i_i_il4r\ : AND3FFT
      port map(A => \I10.N_2521_i\, B => 
        \I10.un2_i2c_chain_0_i_i_i_4_il4r_adt_net_30634_\, C => 
        \I10.N_2189_i_0_adt_net_30812_\, Y => \I10.N_2189_i_0\);
    
    \I2.PIPEA_8_rl24r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl24r, C => 
        \I2.PIPEA_8l24r_adt_net_55957_\, Y => \I2.PIPEA_8l24r\);
    
    \I2.REGMAPl25r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un90_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAP_i_il25r\);
    
    \I2.VDBi_24_dl1r\ : MUX2H
      port map(A => REGl49r, B => \I2.REGl475r\, S => 
        \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24_dl1r_net_1\);
    
    \I3.un16_ae_31\ : NOR2
      port map(A => \I3.un16_ae_2l31r\, B => \I3.un16_ae_3l31r\, 
        Y => \I3.un16_ael31r\);
    
    \I3.un4_so_46_0\ : MUX2L
      port map(A => \I3.N_253\, B => \I3.N_252\, S => REGl125r, Y
         => \I3.N_254\);
    
    \I10.CRC32_3_i_0_0l16r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2318_i_i_0\, Y => \I10.N_1214\);
    
    \I2.REG_1l446r_46\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_361_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL446R_30\);
    
    \I2.PULSE_0_sqmuxa_4_0_a3_0_a2_1_0\ : NAND2FT
      port map(A => \I2.WRITES_net_1\, B => \I2.STATE1l7r_net_1\, 
        Y => \I2.PULSE_0_sqmuxa_4_1_0\);
    
    \I2.VDBm_0l31r\ : MUX2L
      port map(A => \I2.PIPEAl31r_net_1\, B => 
        \I2.PIPEBl31r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2072\);
    
    \I3.un16_ae_14_1\ : OR2FT
      port map(A => REGl125r, B => REGl122r, Y => 
        \I3.un16_ae_1l14r\);
    
    \I2.VDBi_86_ivl3r\ : OR3
      port map(A => \I2.VDBi_86_iv_1_il3r\, B => 
        \I2.VDBi_86_iv_0_il3r\, C => \I2.VDBi_67_m_il3r\, Y => 
        \I2.VDBi_86l3r\);
    
    \I10.FID_173\ : MUX2L
      port map(A => \I10.FID_8l8r\, B => \I10.FIDl8r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_173_net_1\);
    
    \I10.un6_bnc_res_NE_4\ : OR3
      port map(A => \I10.un6_bnc_res_NE_0_i\, B => 
        \I10.BNC_CNT_i_il14r\, C => \I10.BNC_CNTl17r_net_1\, Y
         => \I10.un6_bnc_res_NE_4_i\);
    
    \I2.VDBil19r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_595_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil19r_net_1\);
    
    \I2.VDBi_54_0_iv_2l10r\ : AOI21TTF
      port map(A => REGl179r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml163r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l10r_net_1\);
    
    \I3.un1_BITCNT_1_rl0r\ : OA21
      port map(A => \I3.N_195\, B => 
        \I3.DWACT_ADD_CI_0_partial_suml0r\, C => 
        \I3.un1_hwres_2_net_1\, Y => \I3.un1_BITCNT_1_rl0r_net_1\);
    
    \I2.REG_1l261r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_224_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl261r);
    
    \I2.PIPEB_4_il1r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl1r, Y => \I2.N_2571\);
    
    \I10.un3_bnc_cnt_I_108\ : AND2
      port map(A => \I10.BNC_CNTl16r_net_1\, B => 
        \I10.BNC_CNTl15r_net_1\, Y => 
        \I10.DWACT_FINC_El12r_adt_net_18940_\);
    
    \I5.SBYTE_12\ : MUX2H
      port map(A => FBOUTl6r, B => \I5.SBYTE_5l6r_net_1\, S => 
        \I5.un1_sstate_12\, Y => \I5.SBYTE_12_net_1\);
    
    \I1.sstate2se_8_i_o3_0\ : NAND2
      port map(A => TICKl0r, B => REGl105r, Y => \I1.N_277_0\);
    
    \I10.un2_evread_3_i_0_a2_0_4\ : AND2FT
      port map(A => \I10.REGl42r\, B => REG_i_0l43r, Y => 
        \I10.un2_evread_3_i_0_a2_0_4_net_1\);
    
    \I1.SBYTE_33\ : MUX2H
      port map(A => \I1.SBYTEl5r_net_1\, B => \I1.N_606\, S => 
        \I1.un1_tick_8\, Y => \I1.SBYTE_33_net_1\);
    
    \I2.un1_EVREAD_DS_1_sqmuxa_1\ : OAI21FTT
      port map(A => \I2.STATE2l2r_net_1\, B => 
        \I2.EVREAD_DS_1_sqmuxa\, C => \I2.N_2821_0\, Y => 
        \I2.un1_EVREAD_DS_1_sqmuxa_1_net_1\);
    
    \I2.REGMAPl11r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un46_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAP_i_0_il11r\);
    
    SP_PDL_padl2r : IOB33PH
      port map(PAD => SP_PDL(2), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl2r);
    
    \I2.LB_sl11r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl11r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl11r_Rd1__net_1\);
    
    \I2.un1_tcnt1_I_8\ : AND2
      port map(A => \I2.TCNT1_i_0_il1r_net_1\, B => 
        \I2.TCNT1l0r_net_1\, Y => \I2.N_15\);
    
    \I2.VDBi_61l4r\ : AND3FTT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_61_sl0r_net_1\, C => 
        \I2.VDBi_56l4r_adt_net_51439_\, Y => 
        \I2.VDBi_61l4r_adt_net_51478_\);
    
    \I2.LB_NOE_480\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_nOE_1_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_NOE_65\);
    
    \I2.LB_i_495\ : MUX2L
      port map(A => \I2.LB_il17r_Rd1__net_1\, B => 
        \I2.LB_i_7l17r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__82\, Y => \I2.LB_il17r\);
    
    \I2.PIPEA1l17r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_528_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l17r_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l6r\ : AO21
      port map(A => \I10.STATE1L11R_12\, B => REGl54r, C => 
        \I10.FID_8_iv_0_0_0_0_il6r_adt_net_23986_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il6r\);
    
    \I2.REG_1_0l129r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_131_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGL129R_1);
    
    \I10.PDL_RADDRl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.PDL_RADDR_227_net_1\, CLR
         => CLEAR_0_0, Q => \I10.PDL_RADDRl3r_net_1\);
    
    \I10.EVENT_DWORD_164\ : MUX2L
      port map(A => \I10.STATE1l5r_net_1\, B => 
        \I10.EVENT_DWORDl31r_net_1\, S => \I10.un1_STATE1_14_1_0\, 
        Y => \I10.EVENT_DWORD_164_net_1\);
    
    \I2.VDBi_67_0l1r\ : MUX2L
      port map(A => REGl426r, B => \I2.REGL442R_26\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1950\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I51_Y_0\ : AOI21FTF
      port map(A => REGl45r, B => REG_i_0l44r, C => 
        \I10.N_2519_1\, Y => \I10.ADD_16x16_medium_I51_Y_0_i\);
    
    \I2.REG_1_218\ : MUX2L
      port map(A => VDB_inl6r, B => REGl255r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_218_net_1\);
    
    \I10.BNC_CNT_4_0_a2l5r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_24\, 
        Y => \I10.BNC_CNT_4l5r\);
    
    \I2.REG_1l282r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_245_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl282r\);
    
    \I1.AIR_CHAIN_25\ : MUX2H
      port map(A => \I1.AIR_CHAIN_net_1\, B => \I1.AIR_CHAIN_3\, 
        S => TICKl0r, Y => \I1.AIR_CHAIN_25_net_1\);
    
    \I2.un1_TCNT_1_I_17\ : XOR2
      port map(A => \I2.N_1885_1\, B => \I2.TCNT_i_il0r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_partial_suml0r\);
    
    \I10.L2RF3\ : DFFC
      port map(CLK => ACLKOUT, D => \I10.L2RF2_net_1\, CLR => 
        HWRES_c_2_0, Q => \I10.L2RF3_net_1\);
    
    P_PDL_padl2r : OB33PH
      port map(PAD => P_PDL(2), A => REG_cl131r);
    
    \I10.un2_i2c_chain_0_0_0_0_0l3r\ : AOI21FTF
      port map(A => \I10.N_2649\, B => 
        \I10.N_2371_adt_net_28966_\, C => \I10.N_2279\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_0_il3r\);
    
    \I2.REG_1l434r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_349_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl434r\);
    
    \I2.REG_1l490r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_405_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl490r\);
    
    \I2.REG_1_434\ : MUX2H
      port map(A => VDB_inl13r, B => REGl61r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_434_net_1\);
    
    \I2.VDBi_86_0_ivl16r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl16r\, C
         => \I2.VDBi_86l16r_adt_net_42330_\, Y => 
        \I2.VDBi_86l16r\);
    
    \I2.PIPEA_8_RL16R_437\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l16r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l16r_adt_net_56517_\);
    
    \I10.RDY_CNT_10_i_0l1r\ : AND2
      port map(A => \I10.N_2308\, B => \I10.I_10\, Y => 
        \I10.RDY_CNT_10_i_0l1r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I12_G0N\ : NOR2FT
      port map(A => \I10.N_2519_1\, B => REG_i_0l44r, Y => 
        \I10.N_3114_i\);
    
    \I2.VDBi_19l13r\ : MUX2L
      port map(A => REGl61r, B => \I2.VDBi_17l13r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l13r_net_1\);
    
    \I2.VDBm_0l12r\ : MUX2L
      port map(A => \I2.PIPEAl12r_net_1\, B => 
        \I2.PIPEBl12r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2053\);
    
    \I2.VDBi_86_0_iv_0l26r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l26r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il26r_adt_net_40213_\, Y => 
        \I2.VDBi_86_0_iv_0_il26r\);
    
    NOE16W_pad : OB33PH
      port map(PAD => NOE16W, A => NOE16W_c_c);
    
    \I2.PIPEA1_9_il8r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl8r, Y => \I2.N_2513\);
    
    \I2.LB_il9r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il9r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il9r_Rd1__net_1\);
    
    \I2.VDBi_54_0_iv_0l15r\ : AO21
      port map(A => REGl264r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il15r_adt_net_42688_\, Y => 
        \I2.VDBi_54_0_iv_0_il15r\);
    
    \I2.REG_1l65r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_438_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl65r);
    
    \I2.VDBi_61_dl4r\ : MUX2L
      port map(A => LBSP_inl4r, B => REGl381r, S => 
        \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61_dl4r_net_1\);
    
    \I1.SSTATESE_4_0_0_125\ : MUX2L
      port map(A => \I1.N_625_0\, B => \I1.sstatel8r_net_1\, S
         => TICKl0r, Y => \I1.sstate_ns_el5r_adt_net_7874_\);
    
    \I2.PIPEA1_9_il23r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl23r, Y => \I2.N_2543\);
    
    \I1.PULSE_FL_12\ : AO21
      port map(A => \I1.sstatel13r_net_1\, B => 
        \I1.PULSE_FL_net_1\, C => \I1.PULSE_I2C_net_1\, Y => 
        \I1.PULSE_FL_12_net_1\);
    
    \I2.REG_92_0l88r\ : MUX2H
      port map(A => VDB_inl7r, B => REGl88r, S => 
        \I2.REG_1_sqmuxa_1\, Y => \I2.N_1991\);
    
    \I2.VDBi_67_dl1r\ : MUX2L
      port map(A => \I2.VDBi_61_dl1r_net_1\, B => \I2.N_1950\, S
         => \I2.N_1965\, Y => \I2.VDBi_67_dl1r_net_1\);
    
    \I10.FID_8_iv_0_0_0_1l18r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl18r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il18r_adt_net_22421_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il18r\);
    
    \I2.VDBi_85_ml9r\ : NAND3
      port map(A => \I2.VDBil9r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml9r_net_1\);
    
    \I2.REG_1l87r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_460_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl87r);
    
    \I2.VDBi_54_0_iv_2l2r\ : AOI21TTF
      port map(A => REGl171r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml155r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l2r_net_1\);
    
    \I2.REG_1_461\ : MUX2H
      port map(A => REGl88r, B => \I2.REG_92l88r_net_1\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_461_net_1\);
    
    \I2.REG_1l444r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_359_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl444r\);
    
    \I10.UN3_BNC_CNT_I_16_152\ : AND2
      port map(A => \I10.BNC_CNTl0r_net_1\, B => 
        \I10.BNC_CNTl1r_net_1\, Y => 
        \I10.DWACT_FINC_El0r_adt_net_18772_\);
    
    \I10.un6_bnc_res_3\ : XOR2
      port map(A => \I10.BNC_CNTl3r_net_1\, B => REGl460r, Y => 
        \I10.un6_bnc_res_3_i_i\);
    
    \I3.SBYTE_5l1r\ : MUX2H
      port map(A => REG_cl130r, B => REGl137r, S => 
        \I3.sstatel0r_net_1\, Y => \I3.SBYTE_5l1r_net_1\);
    
    \I3.AEl41r\ : MUX2L
      port map(A => REGl194r, B => \I3.un16_ael41r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl41r);
    
    \I10.FID_8_IV_0_0_0_0L16R_186\ : AND2
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl0r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il16r_adt_net_22749_\);
    
    \I2.N_3045_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3045\, SET => 
        HWRES_c_2_0, Q => \I2.N_3045_Rd1__net_1\);
    
    \I2.END_PK_510_475\ : OA21
      port map(A => \I2.N_2830_4\, B => 
        \I2.un1_STATE2_13_adt_net_59330_\, C => \I2.END_PK_net_1\, 
        Y => \I2.END_PK_510_adt_net_59368_\);
    
    \I2.VDBI_86_0_IV_0L28R_319\ : AND2
      port map(A => \I2.VDBil28r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il28r_adt_net_39803_\);
    
    \I2.VDBi_86_ivl5r\ : OR3
      port map(A => \I2.VDBi_86_iv_1_il5r\, B => 
        \I2.VDBi_86_iv_0_il5r\, C => \I2.VDBi_67_m_il5r\, Y => 
        \I2.VDBi_86l5r\);
    
    \I2.PIPEA1l31r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_542_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l31r_net_1\);
    
    \I2.REG3l7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_114_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGL7R_2);
    
    \I2.PIPEA1l29r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEA1_540_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEA1l29r_net_1\);
    
    SP_PDL_padl39r : IOB33PH
      port map(PAD => SP_PDL(39), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl39r);
    
    \I2.un90_reg_ads_0_a2_0_a2_1\ : NAND2
      port map(A => \I2.VASl5r_net_1\, B => \I2.VASl3r_net_1\, Y
         => \I2.N_3006_1\);
    
    \I10.EVENT_DWORD_18_RL14R_247\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl24r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l14r_adt_net_27044_\);
    
    AE_PDL_padl30r : OB33PH
      port map(PAD => AE_PDL(30), A => AE_PDL_cl30r);
    
    \I2.un84_reg_ads_0_a2_0_a2\ : NOR3FFT
      port map(A => \I2.N_3069\, B => \I2.N_3006_4\, C => 
        \I2.N_3009_1\, Y => \I2.un84_reg_ads_0_a2_0_a2_net_1\);
    
    \I1.sstatese_4_0_0\ : AO21
      port map(A => \I1.sstatel6r_net_1\, B => \I1.N_681_1\, C
         => \I1.sstate_ns_el5r_adt_net_7874_\, Y => 
        \I1.sstate_ns_el5r\);
    
    \I10.BNCRES_CNT_4_I_47\ : AND2
      port map(A => \I10.BNCRES_CNTl4r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_2_0l0r\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_12_1l0r\);
    
    \I2.VDBi_67l1r\ : AND3FFT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_67_sl0r_net_1\, C => \I2.VDBi_9_sqmuxa_0_net_1\, 
        Y => \I2.VDBi_67l1r_adt_net_94342_\);
    
    \I2.REG_1l288r_72\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_251_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL288R_56\);
    
    \I8.sstatel1r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.N_207_i\, CLR => 
        HWRES_c_2_0, Q => \I8.sstatel1r_net_1\);
    
    \I2.VASl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_84_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl2r_net_1\);
    
    \I2.PIPEB_69\ : MUX2H
      port map(A => \I2.PIPEBl20r_net_1\, B => \I2.N_2609\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_69_net_1\);
    
    \I3.un16_ae_35_1\ : OR2
      port map(A => \I3.un16_ae_1l47r\, B => \I3.un16_ae_1l43r\, 
        Y => \I3.un16_ae_2l43r\);
    
    \I2.REG_1l185r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_175_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl185r);
    
    \I2.LB_il2r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il2r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il2r_Rd1__net_1\);
    
    NLBLAST_c : DFFS
      port map(CLK => ALICLK_c, D => \I2.nLBLAST_3_net_1\, SET
         => HWRES_c_2_0, Q => \NLBLAST_c\);
    
    \I2.REGMAPl4r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un21_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAP_i_il4r\);
    
    \I10.EVENT_DWORDl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_143_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl10r_net_1\);
    
    \I2.REG_1_452_e_1\ : NAND2
      port map(A => \I2.N_1730_0\, B => \I2.REG_1_sqmuxa_3_net_1\, 
        Y => \I2.N_3689_i_1\);
    
    \I3.un4_so_3_0\ : MUX2L
      port map(A => SP_PDL_inl12r, B => SP_PDL_inl8r, S => 
        REGL124R_5, Y => \I3.N_199\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L2R_270\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl10r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l2r_adt_net_28433_\);
    
    LB_padl9r : IOB33PH
      port map(PAD => LB(9), A => \I2.LB_il9r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl9r);
    
    \I5.UN1_RESCNT_G_290\ : NOR3FFT
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_1l0r\, B => 
        \I5.G_net_1\, C => \I5.G_1_3_3_i_adt_net_33073_\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r_adt_net_33510_\);
    
    \I2.UN756_REGMAP_17_298\ : OR2
      port map(A => \I2.REGMAPl16r_net_1\, B => 
        \I2.REGMAPl12r_net_1\, Y => 
        \I2.un756_regmap_17_i_adt_net_36523_\);
    
    \I10.EVNT_TRG_120\ : MUX2L
      port map(A => \I10.EVNT_TRG_net_1\, B => \I10.N_1041\, S
         => \I10.STATE2l2r_net_1\, Y => \I10.EVNT_TRG_120_net_1\);
    
    \I2.VDBi_86_0_ivl18r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl18r\, C
         => \I2.VDBi_86l18r_adt_net_41920_\, Y => 
        \I2.VDBi_86l18r\);
    
    \I2.un33_reg_ads_0_a2_0_a2\ : NOR3
      port map(A => \I2.N_3061\, B => \I2.N_3068\, C => 
        \I2.N_3001_1\, Y => \I2.un33_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.STATE1_ns_0_0_0l5r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.READ_ADC_FLAG_net_1\, C => 
        \I10.STATE1_ns_0_0_0_il5r_adt_net_17702_\, Y => 
        \I10.STATE1_ns_0_0_0_il5r\);
    
    \I2.VDBm_0l5r\ : MUX2L
      port map(A => \I2.PIPEAl5r_net_1\, B => \I2.PIPEBl5r_net_1\, 
        S => \I2.BLTCYC_17\, Y => \I2.N_2046\);
    
    \I10.CRC32_3_i_0l25r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2340_i_i_0\, Y => \I10.N_1592\);
    
    \I2.REG_1_204\ : MUX2L
      port map(A => SYNC_cl8r, B => VDB_inl8r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_204_net_1\);
    
    \I2.PULSE_1l3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_1_102_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => PULSEl3r);
    
    \I2.PIPEA1_533\ : MUX2L
      port map(A => \I2.PIPEA1l22r_net_1\, B => \I2.N_2541\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_533_net_1\);
    
    \I2.STATE5L4R_ADT_NET_116396_RD1__507\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_NS_I_IL0R_94\, 
        SET => HWRES_c_2_0, Q => 
        \I2.STATE5L4R_ADT_NET_116396_RD1__101\);
    
    \I2.un1_TCNT_1_I_20\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_pog_array_0_1l0r\, B => 
        \I2.DWACT_ADD_CI_0_g_array_1_2l0r\, Y => \I2.I_20_0\);
    
    \I2.REG_il444r\ : INV
      port map(A => \I2.REGl444r\, Y => REG_i_0l444r);
    
    \I2.REG_il443r\ : INV
      port map(A => \I2.REGl443r\, Y => REG_i_0l443r);
    
    \I2.WRITES\ : DFFC
      port map(CLK => CLKOUT, D => \I2.WRITES_2_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.WRITES_net_1\);
    
    \I2.VASl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_94_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl12r_net_1\);
    
    \I2.LB_sl17r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl17r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl17r_Rd1__net_1\);
    
    \I2.un7_ronly_0_a2_0_a2\ : AND2FT
      port map(A => \I2.N_3018_2_i\, B => 
        \I2.un7_ronly_0_a2_0_a2_adt_net_37317_\, Y => 
        \I2.un7_ronly_0_a2_0_a2_net_1\);
    
    \I2.STATE1_ns_0l0r\ : AO21
      port map(A => \I2.N_2831\, B => \I2.STATE1l9r_net_1\, C => 
        \I2.STATE1_ns_0_0_il0r\, Y => \I2.STATE1_nsl0r\);
    
    \I2.LB_sl0r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl0r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl0r_Rd1__net_1\);
    
    \I2.NDTKIN\ : OR2
      port map(A => TST_C_CL3R_23, B => \I2.CLOSEDTK_net_1\, Y
         => NDTKIN_c);
    
    \I2.un1_MYBERRi_1_sqmuxa_0_a2_0\ : NAND3FFT
      port map(A => TST_CL2R_16, B => \I2.N_2854\, C => 
        \I2.PURGED_net_1\, Y => \I2.N_2879\);
    
    \I1.I_193\ : NAND3
      port map(A => \I1.sstate_i_0_il3r\, B => 
        \I1.BITCNTl2r_net_1\, C => \I1.N_545_1\, Y => \I1.N_516\);
    
    \I2.REG_1l296r_80\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_259_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL296R_64\);
    
    VAD_padl29r : IOB33PH
      port map(PAD => VAD(29), A => \I2.VADml29r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl29r);
    
    \I2.PIPEA1_9_il18r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl18r, Y => \I2.N_2533\);
    
    \I1.AIR_COMMAND_21_0_IVL11R_134\ : AND2
      port map(A => \I1.sstate2l9r_net_1\, B => REGl100r, Y => 
        \I1.AIR_COMMAND_21l11r_adt_net_9280_\);
    
    \I10.EVENT_DWORD_18_rl0r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l0r_net_1\, B => 
        \I10.EVENT_DWORD_18l0r_adt_net_28687_\, Y => 
        \I10.EVENT_DWORD_18l0r\);
    
    \I2.VDBi_24l15r\ : MUX2L
      port map(A => \I2.REGl489r\, B => \I2.VDBi_19l15r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l15r_net_1\);
    
    \I2.REGMAPl31r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un113_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl31r_net_1\);
    
    \I10.EVENT_DWORD_18_RL27R_222\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl27r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l27r_adt_net_25294_\);
    
    RSELA0_pad : OTB33PH
      port map(PAD => RSELA0, A => REGl432r, EN => REG_i_0l448r);
    
    VAD_padl16r : OTB33PH
      port map(PAD => VAD(16), A => \I2.VADml16r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I10.un1_REG_1_ADD_16x16_medium_I28_Y\ : AO21TTF
      port map(A => \I10.N_2519_1\, B => REGl33r, C => 
        \I10.I28_un1_Y\, Y => \I10.N267\);
    
    NLBLAST_pad : OB33PH
      port map(PAD => NLBLAST, A => \NLBLAST_c\);
    
    \I5.RELOAD\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RELOAD_1_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => NCYC_RELOAD_c);
    
    \I2.VDBI_86_0_IV_0L20R_335\ : AND2
      port map(A => \I2.VDBil20r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il20r_adt_net_41443_\);
    
    \I2.un1_tcnt1_I_4\ : INV
      port map(A => \I2.TCNT1l0r_net_1\, Y => \I2.I_4\);
    
    \I2.PIPEA1l18r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_529_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l18r_net_1\);
    
    \I5.RESCNTl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l8r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl8r_net_1\);
    
    \I2.REG_1_0l124r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_126_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGL124R_5);
    
    \I2.VDBi_54_0_iv_3l1r\ : AO21
      port map(A => REGl122r, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_3_il1r_adt_net_53668_\, Y => 
        \I2.VDBi_54_0_iv_3_il1r\);
    
    \I2.VDBi_586\ : MUX2L
      port map(A => \I2.VDBil10r_net_1\, B => \I2.VDBi_86l10r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_586_net_1\);
    
    \I10.EVENT_DWORDl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_146_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl13r_net_1\);
    
    \I2.PULSE_1l8r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_43_f0l8r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => PULSEl8r);
    
    \I10.un3_bnc_cnt_I_23\ : AND2
      port map(A => \I10.DWACT_FINC_El0r\, B => 
        \I10.DWACT_FINC_El2r_adt_net_18800_\, Y => \I10.N_74\);
    
    \I10.CRC32_105\ : MUX2H
      port map(A => \I10.CRC32l18r_net_1\, B => \I10.N_1464\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_105_net_1\);
    
    \I2.REG_1l273r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_236_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl273r\);
    
    \I2.LB_il7r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il7r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il7r_Rd1__net_1\);
    
    \I10.FID_171\ : MUX2L
      port map(A => \I10.FID_8l6r\, B => \I10.FIDl6r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_171_net_1\);
    
    \I2.REG_1_455\ : MUX2H
      port map(A => REGl82r, B => \I2.REG_92l82r_net_1\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_455_net_1\);
    
    \I2.TCNT2_2_I_31\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_TMPl0r\, B => 
        \I2.TCNT2l1r_net_1\, Y => \I2.TCNT2_2l1r\);
    
    \I10.un1_CNT_1_G_1_2\ : AND2
      port map(A => \I10.G_1_0_0_net_1\, B => \I10.CNTl0r_net_1\, 
        Y => \I10.DWACT_ADD_CI_0_TMPl0r\);
    
    \I1.sstate2se_3_i\ : MUX2H
      port map(A => \I1.sstate2l6r_net_1\, B => 
        \I1.sstate2l5r_net_1\, S => \I1.N_277_0\, Y => 
        \I1.sstate2se_3_i_net_1\);
    
    INTR2_pad : OB33PH
      port map(PAD => INTR2, A => \VCC\);
    
    \I2.REG_1_159\ : MUX2L
      port map(A => REGl169r, B => VDB_inl0r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_159_net_1\);
    
    \I10.CRC32_3_0_a2_i_0l26r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2345_i_i_0\, Y => \I10.N_1728\);
    
    \I2.VDBi_19l9r\ : MUX2L
      port map(A => REGl57r, B => \I2.VDBi_17l9r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l9r_net_1\);
    
    \I1.sstate2l4r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2se_4_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstate2l4r_net_1\);
    
    \I10.FID_8_0_IV_0_0_0_0L1R_216\ : AND2
      port map(A => \I10.STATE1L11R_12\, B => REGl49r, Y => 
        \I10.FID_8_0_iv_0_0_0_0_il1r_adt_net_24586_\);
    
    \I2.LB_i_7l15r\ : AND2
      port map(A => VDB_inl15r, B => \I2.STATE5L2R_75\, Y => 
        \I2.LB_i_7l15r_net_1\);
    
    \I2.VADml7r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl7r_net_1\, Y
         => \I2.VADml7r_net_1\);
    
    \I2.PIPEB_80\ : MUX2H
      port map(A => \I2.PIPEBl31r_net_1\, B => \I2.N_2631\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_80_net_1\);
    
    SP_PDL_padl11r : IOB33PH
      port map(PAD => SP_PDL(11), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl11r);
    
    \I2.REG_1l439r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_354_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl439r\);
    
    \I10.FID_190\ : MUX2L
      port map(A => \I10.FID_8l25r\, B => \I10.FIDl25r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_190_net_1\);
    
    \I3.un16_ae_20\ : NOR2
      port map(A => \I3.un16_ae_1l28r\, B => \I3.un16_ae_1l23r\, 
        Y => \I3.un16_ael20r\);
    
    PSM_SP3_pad : IB33
      port map(PAD => PSM_SP3, Y => PSM_SP3_c);
    
    \I2.TCNT3_2_I_30\ : XOR2
      port map(A => \I2.TCNT3l3r_net_1\, B => 
        \I2.DWACT_ADD_CI_0_g_array_12_0l0r\, Y => \I2.TCNT3_2l3r\);
    
    \I2.STATE1_ns_i_o3l9r\ : AND2
      port map(A => \I2.SINGCYC_net_1\, B => \I2.STATE1l8r_net_1\, 
        Y => \I2.N_1714\);
    
    \I2.REG_1_439\ : MUX2H
      port map(A => VDB_inl18r, B => REGl66r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_439_net_1\);
    
    \I2.PIPEBl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_52_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl3r_net_1\);
    
    \I2.VDBi_61l6r\ : AND3FTT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_61_sl0r_net_1\, C => 
        \I2.VDBi_56l6r_adt_net_49833_\, Y => 
        \I2.VDBi_61l6r_adt_net_49872_\);
    
    \I2.REG_1l448r_48\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_363_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL448R_32\);
    
    \I10.L2AS\ : AND2FT
      port map(A => \I10.L2AF3_net_1\, B => \I10.L2AF2_net_1\, Y
         => REGl382r);
    
    \I10.CRC32_116\ : MUX2H
      port map(A => \I10.CRC32l29r_net_1\, B => \I10.N_1220\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_116_net_1\);
    
    \I2.VDBI_54_0_IV_0L4R_395\ : AND2
      port map(A => \I2.REGMAP_i_il17r\, B => REGl141r, Y => 
        \I2.VDBi_54_0_iv_0_il4r_adt_net_51321_\);
    
    \I2.REG_92_0l84r\ : MUX2H
      port map(A => VDB_inl3r, B => REGl84r, S => 
        \I2.REG_1_sqmuxa_1\, Y => \I2.N_1987\);
    
    \I5.un1_RESCNT_I_96\ : AND2
      port map(A => \I5.RESCNTl4r_net_1\, B => 
        \I5.RESCNTl5r_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_pog_array_1_1l0r\);
    
    \I2.VDBm_0l21r\ : MUX2L
      port map(A => \I2.PIPEAl21r_net_1\, B => 
        \I2.PIPEBl21r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2062\);
    
    \I1.SDAnoe_8_s\ : AO21
      port map(A => \I1.N_517_3\, B => \I1.SDAnoe_m_1_net_1\, C
         => \I1.N_408\, Y => \I1.SDAnoe_8\);
    
    \I3.SBYTE_5\ : MUX2L
      port map(A => REGl139r, B => \I3.SBYTE_5l2r_net_1\, S => 
        \I3.N_167\, Y => \I3.SBYTE_5_net_1\);
    
    \I3.AEl20r\ : MUX2L
      port map(A => REGl173r, B => \I3.un16_ael20r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl20r);
    
    \I2.VADml0r\ : NOR2FT
      port map(A => \I2.PIPEAl0r_net_1\, B => \I2.N_2319_1\, Y
         => \I2.VADml0r_net_1\);
    
    \I2.REG_1l285r_69\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_248_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL285R_53\);
    
    \I1.BITCNT_10_rl1r\ : OA21TTF
      port map(A => \I1.BITCNT_2_sqmuxa\, B => \I1.I_13\, C => 
        \I1.BITCNT_0_sqmuxa_2\, Y => \I1.BITCNT_10l1r\);
    
    \I8.un1_BITCNT_I_1\ : AND2
      port map(A => \I8.BITCNTl0r_net_1\, B => 
        \I8.un1_ISI_1_sqmuxa_0_o2_net_1\, Y => 
        \I8.DWACT_ADD_CI_0_TMPl0r\);
    
    \I10.FID_8_RL6R_207\ : AO21
      port map(A => \I10.STATE1L1R_14\, B => 
        \I10.EVENT_DWORDl6r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il6r\, Y => 
        \I10.FID_8l6r_adt_net_24025_\);
    
    \I10.FID_8_iv_0_0_0_1l24r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl24r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il24r_adt_net_21437_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il24r\);
    
    \I2.REG_1l68r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_441_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl68r);
    
    \I2.REG_1l449r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_364_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl449r\);
    
    \I10.FID_189\ : MUX2L
      port map(A => \I10.FID_8l24r\, B => \I10.FIDl24r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_189_net_1\);
    
    \I2.VDBil13r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_589_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil13r_net_1\);
    
    \I1.AIR_CHAIN_3_iv_0\ : AOI21FTF
      port map(A => \I1.sstate2l9r_net_1\, B => 
        \I1.AIR_CHAIN_net_1\, C => \I1.I2C_CHAIN_m_net_1\, Y => 
        \I1.AIR_CHAIN_3_iv_0_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L11R_252\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl19r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l11r_adt_net_27350_\);
    
    \I2.VDBI_17_0L9R_369\ : AND2FT
      port map(A => \I10.REGl41r\, B => \I2.REGMAPl6r_net_1\, Y
         => \I2.N_1906_adt_net_46978_\);
    
    \I2.VDBi_54_0_iv_3l8r\ : AOI21TTF
      port map(A => REGl161r, B => \I2.REGMAPl18r_net_1\, C => 
        \I2.VDBi_54_0_iv_0l8r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3l8r_net_1\);
    
    \I2.un116_reg_ads_0_a3\ : NAND2
      port map(A => \I2.N_3056\, B => \I2.VASl6r_net_1\, Y => 
        \I2.N_3154_i\);
    
    \I1.SCLA_i_a2\ : OR2
      port map(A => \I1.SCL_net_1\, B => \I1.CHAIN_SELECT_net_1\, 
        Y => SCLA_i_a2);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_2_1l6r\ : AND2
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2294\, Y => 
        \I10.N_2376_1\);
    
    \I10.CHIP_ADDRl2r\ : DFF
      port map(CLK => CLKOUT, D => \I10.CHIP_ADDR_129_net_1\, Q
         => CHIP_ADDRl2r);
    
    \I2.PIPEA_8_RL5R_448\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l5r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l5r_adt_net_57324_\);
    
    \I10.un3_bnc_cnt_I_52\ : XOR2
      port map(A => \I10.BNC_CNTl9r_net_1\, B => \I10.N_54\, Y
         => \I10.I_52\);
    
    \I2.LB_i_7l9r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l9r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l9r_Rd1__net_1\);
    
    \I5.SBYTEl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.SBYTE_6_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => FBOUTl0r);
    
    \I10.STATE1_ns_o9_0_a2_0_a3l11r\ : AND2FT
      port map(A => \I10.N_2647\, B => \I10.RDY_CNTl0r_net_1\, Y
         => \I10.N_2640\);
    
    \I10.EVENT_DWORD_18_RL2R_271\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl12r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l2r_adt_net_28463_\);
    
    \I2.REG_1l123r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_125_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl123r);
    
    \I2.STATE1_ns_0_a2l5r\ : OAI21FTT
      port map(A => \I2.STATE1_i_0l5r\, B => \I2.STATE1l3r_net_1\, 
        C => TST_CL2R_16, Y => \I2.N_2907\);
    
    \I10.EVENT_DWORD_18_rl2r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l2r_net_1\, B => 
        \I10.EVENT_DWORD_18l2r_adt_net_28463_\, Y => 
        \I10.EVENT_DWORD_18l2r\);
    
    \I2.REG_1l283r_67\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_246_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL283R_51\);
    
    \I10.FID_8_rl14r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l14r_adt_net_23032_\, Y => \I10.FID_8l14r\);
    
    \I2.VDBi_61l12r\ : MUX2L
      port map(A => LBSP_inl12r, B => \I2.VDBi_59l12r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l12r_net_1\);
    
    \I2.REG_1_441\ : MUX2H
      port map(A => VDB_inl20r, B => REGl68r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_441_net_1\);
    
    \I2.EVREAD_DS_139_457\ : NOR2FT
      port map(A => \I2.EVREAD_DS_net_1\, B => 
        \I2.un1_EVREAD_DS_1_sqmuxa_1_net_1\, Y => 
        \I2.EVREAD_DS_139_adt_net_73658_\);
    
    \I3.ISCK\ : DFFC
      port map(CLK => CLKOUT, D => \I3.sstate_dl2r\, CLR => 
        HWRES_c_2_0, Q => SCLK_PDL_c);
    
    \I10.EVNT_NUM_3_I_63\ : AND3
      port map(A => \I10.DWACT_ADD_CI_0_g_array_3l0r\, B => 
        \I10.EVNT_NUMl8r_net_1\, C => \I10.EVNT_NUMl9r_net_1\, Y
         => \I10.DWACT_ADD_CI_0_g_array_11_1l0r\);
    
    \I2.VDBi_86_0_ivl26r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl26r\, C
         => \I2.VDBi_86l26r_adt_net_40252_\, Y => 
        \I2.VDBi_86l26r\);
    
    \I10.un3_bnc_cnt_I_59\ : AND2
      port map(A => \I10.BNC_CNTl6r_net_1\, B => 
        \I10.BNC_CNTl7r_net_1\, Y => 
        \I10.DWACT_FINC_El5r_adt_net_18828_\);
    
    \I2.VDBi_17_rl2r\ : OA21TTF
      port map(A => \I2.N_1917_adt_net_52812_\, B => 
        \I2.N_1917_adt_net_52814_\, C => \I2.REGMAPl7r_net_1\, Y
         => \I2.VDBi_17l2r_net_1\);
    
    \I1.CHAIN_SELECT_4_IV_139\ : OAI21FTF
      port map(A => REGl6r, B => REGl7r, C => 
        \I1.CHAIN_SELECT_m_i\, Y => 
        \I1.CHAIN_SELECT_4_adt_net_11533_\);
    
    \I10.REG_1l38r\ : DFFS
      port map(CLK => CLKOUT, D => \I10.un1_REG_1_il38r\, SET => 
        CLEAR_0_0, Q => REG_i_0l38r);
    
    \I2.VDBi_56l26r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l26r_net_1\, Y => \I2.VDBi_56l26r_net_1\);
    
    \I2.VDBi_61_dl7r\ : MUX2L
      port map(A => LBSP_inl7r, B => REGl384r, S => 
        \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61_dl7r_net_1\);
    
    \I2.VDBI_59L13R_356\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l13r_net_1\, C => \I2.VDBi_54_0_iv_5_il13r\, Y
         => \I2.VDBi_59l13r_adt_net_44314_\);
    
    \I2.STATE1_ns_0l5r\ : OR2FT
      port map(A => \I2.N_2907\, B => 
        \I2.STATE1_nsl5r_adt_net_38376_\, Y => \I2.STATE1_nsl5r\);
    
    \I2.VDBi_67l11r\ : MUX2L
      port map(A => \I2.VDBi_61l11r_net_1\, B => \I2.N_1960\, S
         => \I2.N_1965\, Y => \I2.VDBi_67l11r_net_1\);
    
    VDB_padl21r : IOB33PH
      port map(PAD => VDB(21), A => \I2.VDBml21r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl21r);
    
    \I10.CRC32_117\ : MUX2H
      port map(A => \I10.CRC32l30r_net_1\, B => \I10.N_1472\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_117_net_1\);
    
    \I3.AEl8r\ : MUX2L
      port map(A => REGl161r, B => \I3.un16_ael8r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl8r);
    
    \I2.PIPEA_8_RL26R_427\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l26r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l26r_adt_net_55817_\);
    
    \I2.REG_1l263r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_226_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl263r);
    
    \I2.VDBml3r\ : MUX2L
      port map(A => \I2.VDBil3r_net_1\, B => \I2.N_2044\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml3r_net_1\);
    
    \I2.PIPEB_51\ : MUX2H
      port map(A => \I2.PIPEBl2r_net_1\, B => \I2.N_2573\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_51_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I48_Y\ : OR2
      port map(A => \I10.N292_adt_net_15372_\, B => \I10.N277\, Y
         => \I10.N292\);
    
    \I2.un25_tcnt_0_o3_1\ : OR3
      port map(A => \I2.un25_tcnt_0_o3_2_i\, B => 
        \I2.TCNT_i_il3r_net_1\, C => \I2.TCNTl4r_net_1\, Y => 
        \I2.N_1721_1\);
    
    \I3.un4_so_22_0\ : MUX2L
      port map(A => \I3.N_217\, B => \I3.N_212\, S => REGl125r, Y
         => \I3.N_250\);
    
    \I2.LB_i_7l25r\ : AND2
      port map(A => VDB_inl25r, B => \I2.STATE5L2R_73\, Y => 
        \I2.LB_i_7l25r_net_1\);
    
    \I2.LB_i_7l4r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l4r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l4r_Rd1__net_1\);
    
    \I2.VDBI_54_0_IV_0L15R_346\ : AND2
      port map(A => REGl120r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.VDBi_54_0_iv_0_il15r_adt_net_42688_\);
    
    \I0.CLEAR_i\ : AND3
      port map(A => NLBCLR_c, B => \I0.CLEAR_0_a2_0_net_1\, C => 
        REGl506r, Y => CLEAR_i_0);
    
    \I1.DATA_1_sqmuxa_2_0_a3\ : OR2FT
      port map(A => TICKl0r, B => \I1.N_516\, Y => 
        \I1.DATA_1_sqmuxa_2\);
    
    LBSP_padl3r : IOB33PH
      port map(PAD => LBSP(3), A => REGl396r, EN => REG_i_0l268r, 
        Y => LBSP_inl3r);
    
    \I2.un1_STATE2_10_i_a2_0_2\ : NOR3
      port map(A => \I2.PIPEA_i_0_il29r\, B => 
        \I2.PIPEAl31r_net_1\, C => \I2.N_3058_1_i_i\, Y => 
        \I2.N_2894_2\);
    
    \I2.un1_STATE1_18_0\ : OR2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.STATE1l6r_net_1\, Y => \I2.un1_STATE1_18\);
    
    \I2.VDBi_86_ivl4r\ : OR3
      port map(A => \I2.VDBi_86_iv_1_il4r\, B => 
        \I2.VDBi_86_iv_0_il4r\, C => \I2.VDBi_67_m_il4r\, Y => 
        \I2.VDBi_86l4r\);
    
    \I10.BNC_CNT_215\ : MUX2H
      port map(A => \I10.BNC_CNTl17r_net_1\, B => 
        \I10.BNC_CNT_4l17r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_215_net_1\);
    
    \I2.VDBI_54_0_IV_0L13R_354\ : AND2
      port map(A => REGl118r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.VDBi_54_0_iv_0_il13r_adt_net_44196_\);
    
    \I2.UN106_REG_ADS_0_A2_0_A2_302\ : NOR3FTT
      port map(A => \I2.VASl2r_net_1\, B => \I2.N_3067\, C => 
        \I2.N_3010_1\, Y => 
        \I2.un106_reg_ads_0_a2_0_a2_adt_net_37438_\);
    
    \I2.TCNT3l5r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT3_2l5r\, Q => 
        \I2.TCNT3l5r_net_1\);
    
    \I2.STATE5L2R_486\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_106\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L2R_71\);
    
    \I2.REG_1l170r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_160_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl170r);
    
    \I2.NLBLAST_3_462\ : NOR2FT
      port map(A => \NLBLAST_c\, B => \I2.N_2388\, Y => 
        \I2.nLBLAST_3_adt_net_79232_\);
    
    \I10.EVENT_DWORD_18_RL20R_235\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl20r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l20r_adt_net_26372_\);
    
    \I10.BNC_CNT_4_0_a2l8r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_45\, 
        Y => \I10.BNC_CNT_4l8r\);
    
    \I2.VAS_94\ : MUX2L
      port map(A => VAD_inl12r, B => \I2.VASl12r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_94_net_1\);
    
    \I2.PIPEB_71\ : MUX2H
      port map(A => \I2.PIPEBl22r_net_1\, B => \I2.N_2613\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_71_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I73_Y\ : XOR2FT
      port map(A => \I10.N324_i\, B => 
        \I10.ADD_16x16_medium_I73_Y_0\, Y => 
        \I10.ADD_16x16_medium_I73_Y\);
    
    SCLK_PDL_pad : OB33PH
      port map(PAD => SCLK_PDL, A => SCLK_PDL_c);
    
    \I5.RESCNT_6_rl1r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_64\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l1r\);
    
    \I10.EVENT_DWORD_159\ : MUX2H
      port map(A => \I10.EVENT_DWORDl26r_net_1\, B => 
        \I10.EVENT_DWORD_18l26r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_159_net_1\);
    
    \I2.VDBml7r\ : MUX2L
      port map(A => \I2.VDBil7r_net_1\, B => \I2.N_2048\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml7r_net_1\);
    
    \I2.PIPEA1_512\ : MUX2L
      port map(A => \I2.PIPEA1l1r_net_1\, B => \I2.N_2499\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_512_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_1l24r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.PDL_RADDRl0r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l24r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l24r_net_1\);
    
    \I2.VDBi_85_ml0r\ : NAND3
      port map(A => \I2.VDBil0r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml0r_net_1\);
    
    \I2.PIPEA_8_rl10r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl10r, C => 
        \I2.PIPEA_8l10r_adt_net_56937_\, Y => \I2.PIPEA_8l10r\);
    
    \I2.VDBi_61l18r\ : MUX2L
      port map(A => LBSP_inl18r, B => \I2.VDBi_56l18r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l18r_net_1\);
    
    \I1.SDAnoe\ : DFFS
      port map(CLK => CLKOUT, D => \I1.SDAnoe_48_net_1\, SET => 
        HWRES_c_2_0, Q => \I1.SDAnoe_net_1\);
    
    \I10.BNC_CNT_216\ : MUX2H
      port map(A => \I10.BNC_CNT_i_il18r\, B => 
        \I10.BNC_CNT_4l18r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_216_net_1\);
    
    \I2.un1_STATE5_9_0_1_0\ : NAND3FFT
      port map(A => \I2.un1_STATE5_9_0_1_i\, B => \I2.N_2383\, C
         => \I2.LB_NOE_1_SQMUXA_116\, Y => \I2.un1_STATE5_9_1\);
    
    \I10.FID_8_IV_0_0_0_0L22R_175\ : AND2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.BNC_NUMBERl3r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il22r_adt_net_21807_\);
    
    \I8.SWORD_5l14r\ : MUX2L
      port map(A => REGl263r, B => \I8.SWORDl13r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l14r_net_1\);
    
    \I2.VDBi_85_ml15r\ : NAND3
      port map(A => \I2.VDBil15r_net_1\, B => \I2.STATE1_i_il1r\, 
        C => \I2.N_1721_1\, Y => \I2.VDBi_85_ml15r_net_1\);
    
    \I2.PIPEBl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_62_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl13r_net_1\);
    
    \I10.un6_bnc_res_0\ : XOR2
      port map(A => \I10.BNC_CNTl0r_net_1\, B => REGl457r, Y => 
        \I10.un6_bnc_res_0_i_i\);
    
    \I2.STATE1_nsl8r\ : AO21
      port map(A => \I2.STATE1_i_il1r\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_nsl8r_adt_net_37064_\, Y => 
        \I2.STATE1_nsl8r_net_1\);
    
    \I10.STATE1l6r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl6r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l6r_net_1\);
    
    \I2.VDBi_86_0_ivl28r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl28r\, C
         => \I2.VDBi_86l28r_adt_net_39842_\, Y => 
        \I2.VDBi_86l28r\);
    
    \I2.VDBi_86_ivl11r\ : AO21TTF
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l11r_net_1\, C => \I2.VDBi_86_iv_2l11r_net_1\, 
        Y => \I2.VDBi_86l11r\);
    
    \I1.un1_AIR_CHAIN_1_sqmuxa_3\ : AOI21FTF
      port map(A => \I1.sstate2l6r_net_1\, B => 
        \I1.un1_AIR_CHAIN_1_sqmuxa_0_adt_net_8716_\, C => 
        REGl105r, Y => 
        \I1.un1_AIR_CHAIN_1_sqmuxa_3_i_adt_net_8755_\);
    
    \I5.un1_RESCNT_I_61\ : XOR2
      port map(A => \I5.RESCNTl7r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_12_2l0r\, Y => \I5.I_61\);
    
    \I10.EVENT_DWORDl16r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_149_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl16r_net_1\);
    
    \I10.FID_8_IV_0_0_0_1L25R_168\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl73r, Y => 
        \I10.FID_8_iv_0_0_0_1_il25r_adt_net_21273_\);
    
    \I10.EVENT_DWORD_161\ : MUX2H
      port map(A => \I10.EVENT_DWORDl28r_net_1\, B => 
        \I10.EVENT_DWORD_18l28r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_161_net_1\);
    
    AMB_padl4r : IB33
      port map(PAD => AMB(4), Y => AMB_cl4r);
    
    \I3.un4_so_21_0\ : MUX2L
      port map(A => \I3.N_216\, B => \I3.N_211\, S => REGl124r, Y
         => \I3.N_217\);
    
    \I10.STATE1l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl10r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1L2R_13\);
    
    \I10.BNCRES_CNT_4_G_1_1\ : NOR3FTT
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => 
        \I10.G_1_1_2_i\, C => \I10.G_1_1_3_i\, Y => 
        \I10.G_1_1_net_1\);
    
    \I2.REG_1_206\ : MUX2L
      port map(A => REG_cl243r, B => VDB_inl10r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_206_net_1\);
    
    \I2.PIPEBl28r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEB_77_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEB_i_il28r\);
    
    \I2.REG_1_252\ : MUX2L
      port map(A => \I2.REGL289R_57\, B => VDB_inl24r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_252_net_1\);
    
    \I5.un1_RESCNT_G_1_1_3\ : NAND3
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_2l0r\, B => 
        \I5.RESCNTl0r_net_1\, C => \I5.G_1_1_0\, Y => 
        \I5.G_1_1_3_i\);
    
    \I2.REGMAPl9r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un40_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAP_i_0_il9r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I74_Y\ : XOR2FT
      port map(A => \I10.N304\, B => 
        \I10.ADD_16x16_medium_I74_Y_0\, Y => 
        \I10.ADD_16x16_medium_I74_Y\);
    
    \I2.REG_1_311\ : MUX2L
      port map(A => REGl396r, B => VDB_inl3r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_311_net_1\);
    
    \I10.FIDl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_170_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl5r_net_1\);
    
    \I10.un1_RDY_CNT_I_8\ : XOR2
      port map(A => \I10.G_1_0_0_net_1\, B => 
        \I10.RDY_CNTl0r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_partial_sum_0l0r\);
    
    \I2.N_3050_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3050\, SET => 
        HWRES_c_2_0, Q => \I2.N_3050_Rd1__net_1\);
    
    \I2.PULSE_1l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_1_101_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => PULSEl2r);
    
    \I2.LB_s_20\ : MUX2L
      port map(A => \I2.LB_sl6r_Rd1__net_1\, B => 
        \I2.N_3041_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116360_Rd1__net_1\, Y => 
        \I2.LB_sl6r\);
    
    \I2.VDBi_70_dl0r\ : MUX2L
      port map(A => REGl473r, B => \I2.VDBi_67_dl0r_net_1\, S => 
        \I2.REGMAPl34r_net_1\, Y => \I2.VDBi_70_dl0r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I6_P0N\ : NAND2FT
      port map(A => \I10.N_2519_1\, B => REG_i_0l38r, Y => 
        \I10.N227\);
    
    \I10.EVENT_DWORD_18_rl24r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l24r_net_1\, B => 
        \I10.EVENT_DWORD_18l24r_adt_net_25756_\, Y => 
        \I10.EVENT_DWORD_18l24r\);
    
    \I10.EVENT_DWORD_18_rl15r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0l15r_net_1\, B => 
        \I10.EVENT_DWORD_18l15r_adt_net_26932_\, Y => 
        \I10.EVENT_DWORD_18l15r\);
    
    \I2.UN1_STATE5_9_1_RD1__498\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_92\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__83\);
    
    \I2.PULSE_1l7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_43_f0l7r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => PULSEl7r);
    
    \I3.I_42_1\ : AND3FTT
      port map(A => HWRES_C_2_0_19, B => \I3.sstatel1r_net_1\, C
         => \I3.BITCNTl1r_net_1\, Y => \I3.I_42_1_net_1\);
    
    \I5.un1_RESCNT_G_1_3_3\ : NAND2
      port map(A => \I5.RESCNTl0r_net_1\, B => 
        \I5.RESCNTl1r_net_1\, Y => \I5.G_1_3_3_i_adt_net_33073_\);
    
    \I2.VDBi_86_1l31r\ : OR2
      port map(A => \I2.STATE1_i_il1r\, B => \I2.STATE1l2r_net_1\, 
        Y => \I2.N_1885_1\);
    
    \I2.VDBi_24l23r\ : MUX2L
      port map(A => \I2.REGl497r\, B => \I2.VDBi_19l23r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l23r_net_1\);
    
    \I5.RESCNT_6_rl7r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_61\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l7r\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_1_1l6r\ : NOR2FT
      port map(A => \I10.CNTl4r_net_1\, B => \I10.N_2650\, Y => 
        \I10.N_2375_1\);
    
    \I10.CRC32_113\ : MUX2H
      port map(A => \I10.CRC32l26r_net_1\, B => \I10.N_1728\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_113_net_1\);
    
    \I2.REG_1l476r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_391_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl476r\);
    
    \I5.sstate_ns_il5r\ : NOR3
      port map(A => \I5.sstate_0_sqmuxa_1_0_a2_9_i\, B => 
        \I5.sstate_0_sqmuxa_1_0_a2_13_i_adt_net_33240_\, C => 
        \I5.sstate_nsl5r_adt_net_33314_\, Y => 
        \I5.sstate_ns_i_0l5r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I21_Y\ : AO21
      port map(A => \I10.REGl40r\, B => \I10.REGl41r\, C => 
        \I10.N_2519_1\, Y => \I10.N260\);
    
    \I2.VDBI_86_0_IV_0L27R_321\ : AND2
      port map(A => \I2.VDBil27r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il27r_adt_net_40008_\);
    
    \I2.VAS_85\ : MUX2L
      port map(A => VAD_inl3r, B => \I2.VASl3r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_85_net_1\);
    
    \I10.un6_bnc_res_NE_14\ : OR3
      port map(A => \I10.un6_bnc_res_NE_10_i\, B => 
        \I10.un6_bnc_res_7_i_i\, C => \I10.un6_bnc_res_10_i_i\, Y
         => \I10.un6_bnc_res_NE_14_i\);
    
    \I10.un3_bnc_cnt_I_38\ : XOR2
      port map(A => \I10.BNC_CNTl7r_net_1\, B => \I10.N_64\, Y
         => \I10.I_38\);
    
    \I2.un1_STATE1_15_0\ : OAI21
      port map(A => \I2.REGMAPl10r_net_1\, B => 
        \I2.REGMAP_i_0_il15r\, C => \I2.WRITES_net_1\, Y => 
        \I2.un1_STATE1_15_0_net_1\);
    
    \I2.TCNT2_2_I_45\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_11l0r\, B => 
        \I2.TCNT2_i_0_il6r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_12_2l0r\);
    
    \I10.EVENT_DWORD_18_RL25R_225\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl25r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l25r_adt_net_25602_\);
    
    \I2.VDBi_86_iv_1l11r\ : AOI21TTF
      port map(A => \I2.PIPEAl11r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_iv_0l11r_net_1\, Y => 
        \I2.VDBi_86_iv_1l11r_net_1\);
    
    \I8.SWORD_5l5r\ : MUX2L
      port map(A => REGl254r, B => \I8.SWORDl4r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l5r_net_1\);
    
    AMB_padl2r : IB33
      port map(PAD => AMB(2), Y => AMB_cl2r);
    
    \I2.LB_i_7l3r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l3r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l3r_Rd1__net_1\);
    
    \I10.FID_8_IV_0_0_0_0L8R_202\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.FID_4l8r\, Y
         => \I10.FID_8_iv_0_0_0_0l8r_adt_net_23752_\);
    
    \I8.SWORDl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_4_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl3r_net_1\);
    
    \I2.PIPEA1_520\ : MUX2L
      port map(A => \I2.PIPEA1l9r_net_1\, B => \I2.N_2515\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_520_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_1l27r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.PDL_RADDRl3r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l27r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l27r_net_1\);
    
    \I1.START_I2C_2_iv_0\ : AOI21
      port map(A => \I1.sstate2l9r_net_1\, B => 
        \I1.START_I2C_net_1\, C => \I1.sstate2l8r_net_1\, Y => 
        \I1.START_I2C_2_iv_0_net_1\);
    
    \I2.VADml22r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl22r_net_1\, Y
         => \I2.VADml22r_net_1\);
    
    \I10.un6_bnc_res_1\ : XOR2
      port map(A => \I10.BNC_CNTl1r_net_1\, B => REGl458r, Y => 
        \I10.un6_bnc_res_1_i_i\);
    
    \I2.LB_s_16\ : MUX2L
      port map(A => \I2.LB_sl2r_Rd1__net_1\, B => 
        \I2.N_3024_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116360_Rd1__net_1\, Y => 
        \I2.LB_sl2r\);
    
    \I2.REG_1_155\ : MUX2L
      port map(A => REGl165r, B => VDB_inl12r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_155_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l1r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl1r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l1r_adt_net_28545_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l1r_net_1\);
    
    \I2.VDBi_67_0l14r\ : MUX2L
      port map(A => \I2.REGl439r\, B => \I2.REGl455r\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1963\);
    
    \I2.N_3026_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3026\, SET => 
        HWRES_c_2_0, Q => \I2.N_3026_Rd1__net_1\);
    
    \I1.AIR_COMMAND_21l14r\ : OR2
      port map(A => \I1.sstate2l3r_net_1\, B => \I1.N_278\, Y => 
        \I1.N_565_i_i\);
    
    \I2.REG_1l493r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_408_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl493r\);
    
    \I2.REG_1l160r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_150_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl160r);
    
    \I10.FIDl26r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_191_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl26r_net_1\);
    
    \I10.CRC32_3_0_a2_i_0_x3l6r\ : XOR2FT
      port map(A => \I10.CRC32l6r_net_1\, B => 
        \I10.EVENT_DWORDl6r_net_1\, Y => \I10.N_2344_i_i_0\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I77_Y\ : XOR2FT
      port map(A => \I10.N320_i\, B => 
        \I10.ADD_16x16_medium_I77_Y_0\, Y => 
        \I10.ADD_16x16_medium_I77_Y\);
    
    \I5.un1_RESCNT_I_98\ : AND2
      port map(A => \I5.RESCNTl2r_net_1\, B => 
        \I5.RESCNTl3r_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_pog_array_1l0r\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L18R_238\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl26r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l18r_adt_net_26566_\);
    
    \I2.STATE1_ns_0l3r\ : AOI21TTF
      port map(A => \I2.STATE1l7r_net_1\, B => \I2.N_2981\, C => 
        \I2.N_1762\, Y => \I2.STATE1_ns_0l3r_net_1\);
    
    \I2.VDBi_67l5r\ : OA21
      port map(A => \I2.VDBi_61l5r_adt_net_50675_\, B => 
        \I2.VDBi_61l5r_adt_net_50677_\, C => \I2.N_1965\, Y => 
        \I2.VDBi_67l5r_adt_net_50717_\);
    
    \I10.OR_RADDRl4r\ : DFF
      port map(CLK => CLKOUT, D => \I10.OR_RADDR_222_net_1\, Q
         => \I10.OR_RADDRl4r_net_1\);
    
    \I2.un13_reg_ads_0_a2_0_a3\ : OR2FT
      port map(A => \I2.VASl1r_net_1\, B => \I2.VASl4r_net_1\, Y
         => \I2.N_3065\);
    
    \I10.un2_i2c_chain_0_i_0_a2_8_1l5r\ : OR2FT
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2727\, Y => 
        \I10.N_2412_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2l3r\ : NAND3
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2375_1\, C
         => \I10.N_2346_i_i_0\, Y => \I10.N_2366\);
    
    \I0.BNC_RES1\ : DFFC
      port map(CLK => ACLKOUT, D => BNCRES_c, CLR => 
        \I0.N_111_i_0\, Q => \I0.BNC_RES1_net_1\);
    
    F_SCK_pad : OTB33PH
      port map(PAD => F_SCK, A => \I5.ISCK_net_1\, EN => 
        \I5.DRIVECS_net_1\);
    
    \I3.AEl44r\ : MUX2L
      port map(A => REGl197r, B => \I3.un16_ael44r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl44r);
    
    \I10.un3_bnc_cnt_I_77\ : XOR2
      port map(A => \I10.BNC_CNT_i_il13r\, B => \I10.N_36\, Y => 
        \I10.I_77\);
    
    \I2.VDBI_56L1R_471\ : OAI21TTF
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_54_0_iv_6l1r_net_1\, C => 
        \I2.VDBi_56l1r_adt_net_53899_\, Y => 
        \I2.VDBi_56l1r_adt_net_93309_\);
    
    \I2.REG_1l497r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_412_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl497r\);
    
    \I2.REG_1l462r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_377_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl462r);
    
    \I2.VDBi_17_0l7r\ : AOI21
      port map(A => REGL7R_2, B => \I2.REGMAP_i_il1r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1904_adt_net_48648_\);
    
    \I2.REG_1l121r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_123_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => MD_PDL_c);
    
    \I2.PIPEA1_540\ : MUX2L
      port map(A => \I2.PIPEA1l29r_net_1\, B => \I2.PIPEA1_9l29r\, 
        S => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_540_net_1\);
    
    AE_PDL_padl39r : OB33PH
      port map(PAD => AE_PDL(39), A => AE_PDL_cl39r);
    
    \I2.REG_1l178r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_168_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl178r);
    
    \I2.VDBi_593\ : MUX2L
      port map(A => \I2.VDBil17r_net_1\, B => \I2.VDBi_86l17r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_593_net_1\);
    
    \I1.sstate2l8r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2_ns_el1r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstate2l8r_net_1\);
    
    \I2.UN7_RONLY_0_A2_0_A2_301\ : AND3
      port map(A => \I2.LWORDS_net_1\, B => \I2.WRITES_net_1\, C
         => \I2.VASl15r_net_1\, Y => 
        \I2.un7_ronly_0_a2_0_a2_adt_net_37317_\);
    
    \I2.PIPEA1l12r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_523_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l12r_net_1\);
    
    \I2.REG_1l295r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_258_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl295r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I53_Y\ : NOR3
      port map(A => \I10.N277\, B => \I10.N273\, C => 
        \I10.I53_un1_Y\, Y => \I10.N304\);
    
    \I2.REG_1l57r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_430_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl57r);
    
    \I2.PIPEBl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_58_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl9r_net_1\);
    
    \I2.STATE1_ns_i_o3_0l9r\ : OR2
      port map(A => \I2.REGMAPl35r_net_1\, B => 
        \I2.REGMAPl10r_net_1\, Y => \I2.N_1729\);
    
    \I1.DATA_12l14r\ : MUX2H
      port map(A => \I1.SBYTEl6r_net_1\, B => REGl119r, S => 
        \I1.DATA_1_sqmuxa_2\, Y => \I1.DATA_12l14r_net_1\);
    
    \I10.FID_8_rl13r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l13r_adt_net_23154_\, Y => \I10.FID_8l13r\);
    
    \I2.LB_s_4_i_a2_0_a2l6r\ : OR2
      port map(A => LB_inl6r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__70\, Y => \I2.N_3041\);
    
    \I2.TCNT2l7r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT2_2l7r\, Q => 
        \I2.TCNT2l7r_net_1\);
    
    TST_padl1r : OB33PH
      port map(PAD => TST(1), A => \I2.TST_c_0l1r\);
    
    \I2.VDBI_86_IV_1L7R_381\ : AND2
      port map(A => \I2.PIPEAl7r_net_1\, B => \I2.N_1707_i_0_1\, 
        Y => \I2.VDBi_86_iv_1_il7r_adt_net_49127_\);
    
    \I10.EVENT_DWORD_137\ : MUX2H
      port map(A => \I10.EVENT_DWORDl4r_net_1\, B => 
        \I10.EVENT_DWORD_18l4r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_137_net_1\);
    
    SYNC_padl1r : OB33PH
      port map(PAD => SYNC(1), A => SYNC_cl1r);
    
    \I2.PIPEA_548\ : MUX2L
      port map(A => \I2.PIPEAl4r_net_1\, B => \I2.PIPEA_8l4r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_548_net_1\);
    
    \I3.AEl26r\ : MUX2L
      port map(A => REGl179r, B => \I3.un16_ael26r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl26r);
    
    \I2.PIPEA1_536\ : MUX2L
      port map(A => \I2.PIPEA1l25r_net_1\, B => \I2.N_2547\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_536_net_1\);
    
    \I10.FIDl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_176_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl11r_net_1\);
    
    \I3.un16_ae_27\ : NOR2
      port map(A => \I3.un16_ae_2l31r\, B => \I3.un16_ae_1l27r\, 
        Y => \I3.un16_ael27r\);
    
    \I2.REG_1_228\ : MUX2L
      port map(A => \I2.REGL265R_33\, B => VDB_inl0r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_228_net_1\);
    
    \I2.ASBSF1\ : DFFS
      port map(CLK => CLKOUT, D => ASB_c, SET => HWRES_c_2_0, Q
         => \I2.ASBSF1_net_1\);
    
    \I2.STATE1_nsl7r\ : OAI21TTF
      port map(A => \I2.REGMAPl35r_net_1\, B => \I2.N_1826_0\, C
         => \I2.STATE1_nsl7r_adt_net_38258_\, Y => 
        \I2.STATE1_nsl7r_net_1\);
    
    \I2.PIPEA1_0_sqmuxa_0_o3\ : OR2
      port map(A => \I2.END_PK_net_1\, B => \I2.EVREAD_DS_net_1\, 
        Y => \I2.N_2823\);
    
    \I10.FID_188\ : MUX2L
      port map(A => \I10.FID_8l23r\, B => \I10.FIDl23r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_188_net_1\);
    
    \I3.AEl22r\ : MUX2L
      port map(A => REGl175r, B => \I3.un16_ael22r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl22r);
    
    \I2.VDBil15r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_591_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil15r_net_1\);
    
    \I2.TCNT_i_il3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.TCNT_10l3r\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.TCNT_i_il3r_net_1\);
    
    \I2.REG_1_167\ : MUX2L
      port map(A => REGl177r, B => VDB_inl8r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_167_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l14r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl14r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l14r_adt_net_27014_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l14r_net_1\);
    
    \I5.un1_RESCNT_I_91\ : AND2
      port map(A => \I5.RESCNTl8r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_3l0r\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_12_3l0r\);
    
    \I2.LB_i_7l13r\ : AND2
      port map(A => VDB_inl13r, B => \I2.STATE5L2R_75\, Y => 
        \I2.LB_i_7l13r_net_1\);
    
    \I2.REG_1l466r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_381_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REGl466r);
    
    \I2.PIPEB_4_il11r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl11r, Y => \I2.N_2591\);
    
    \I10.un1_I2C_RREQ_1_sqmuxa_0_0_0_o3\ : NOR2FT
      port map(A => \I10.DWACT_ADD_CI_0_pog_array_1l0r\, B => 
        \I10.N_2282\, Y => \I10.N_2297\);
    
    \I10.un3_bnc_cnt_I_65\ : AND2
      port map(A => \I10.DWACT_FINC_El7r_adt_net_18884_\, B => 
        \I10.DWACT_FINC_El28r\, Y => \I10.N_44\);
    
    \I10.un3_bnc_cnt_I_51\ : AND2
      port map(A => \I10.BNC_CNTl8r_net_1\, B => 
        \I10.DWACT_FINC_El4r\, Y => \I10.N_54\);
    
    \I2.ADACKCYC\ : DFFC
      port map(CLK => CLKOUT, D => \I2.ADACKCYC_104_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.ADACKCYC_net_1\);
    
    \I1.sstatese_7_0_o2\ : AND2
      port map(A => \I1.BITCNTl2r_net_1\, B => \I1.N_545_1\, Y
         => \I1.N_401\);
    
    DIR_CTTM_padl6r : OB33PH
      port map(PAD => DIR_CTTM(6), A => \VCC\);
    
    \I3.un4_so_1_0\ : MUX2L
      port map(A => SP_PDL_inl4r, B => SP_PDL_inl0r, S => 
        REGL124R_5, Y => \I3.N_197\);
    
    \I2.REG_1_408\ : MUX2H
      port map(A => VDB_inl19r, B => \I2.REGl493r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_408_net_1\);
    
    \I10.FIDl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_169_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl4r_net_1\);
    
    \I2.un1_STATE2_12_0_o3_2_o3\ : NAND2
      port map(A => \I2.N_2835\, B => \I2.N_2836\, Y => 
        \I2.N_2846\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I2_G0N\ : AND2
      port map(A => \I10.N_2519_1\, B => REGl34r, Y => 
        \I10.N_3032_i\);
    
    \I2.VDBi_590\ : MUX2L
      port map(A => \I2.VDBil14r_net_1\, B => \I2.VDBi_86l14r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_590_net_1\);
    
    \I2.REG_1l454r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_369_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl454r\);
    
    \I10.BNC_CNT_4_0_a2l2r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_9\, Y
         => \I10.BNC_CNT_4l2r\);
    
    \I2.VDBi_86_0_ivl21r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl21r\, C
         => \I2.VDBi_86l21r_adt_net_41277_\, Y => 
        \I2.VDBi_86l21r\);
    
    \I1.UN1_TICK_8_0_0_O2_0_0_123\ : NOR3
      port map(A => \I1.COMMANDl1r_net_1\, B => 
        \I1.COMMANDl0r_net_1\, C => \I1.N_544\, Y => 
        \I1.N_625_0_adt_net_7241_\);
    
    \I8.BITCNTl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.BITCNT_6l1r\, CLR => 
        HWRES_c_2_0, Q => \I8.BITCNTl1r_net_1\);
    
    \I10.EVNT_NUM_3_I_46\ : XOR2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_11_1l0r\, B => 
        \I10.EVNT_NUMl10r_net_1\, Y => \I10.EVNT_NUM_3l10r\);
    
    \I1.un1_sstate2_7_0_o3\ : AO21
      port map(A => REGl105r, B => \I1.sstate2l5r_net_1\, C => 
        \I1.sstate2l8r_net_1\, Y => \I1.N_278\);
    
    \I2.PIPEA_565\ : MUX2L
      port map(A => \I2.PIPEAl21r_net_1\, B => \I2.PIPEA_8l21r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_565_net_1\);
    
    \I10.un1_I2C_RREQ_1_sqmuxa_0_0_0_a2_0\ : AND2
      port map(A => I2C_RVALID, B => \I10.STATE1l6r_net_1\, Y => 
        \I10.N_2357\);
    
    VAD_padl23r : OTB33PH
      port map(PAD => VAD(23), A => \I2.VADml23r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I5.SBYTE_6\ : MUX2H
      port map(A => FBOUTl0r, B => \I5.SBYTE_5l0r_net_1\, S => 
        \I5.un1_sstate_12\, Y => \I5.SBYTE_6_net_1\);
    
    \I2.REGMAPl2r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un13_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl2r_net_1\);
    
    \I2.un5_noe16ri_i_0_a2_i_0\ : OR2
      port map(A => \I2.N_2983_1\, B => NOEAD_C_0_0_21, Y => 
        \I2.N_2768_0\);
    
    \I10.FID_8_IV_0_0_0_1L24R_170\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl72r, Y => 
        \I10.FID_8_iv_0_0_0_1_il24r_adt_net_21437_\);
    
    \I2.VDBi_54_0_iv_2l6r\ : AOI21TTF
      port map(A => REGl175r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml159r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l6r_net_1\);
    
    \I2.VDBi_19l11r\ : MUX2L
      port map(A => REGl59r, B => \I2.VDBi_17l11r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l11r_net_1\);
    
    \I10.CRC32_3_0_a2_i_0_x3l5r\ : XOR2FT
      port map(A => \I10.CRC32l5r_net_1\, B => 
        \I10.EVENT_DWORDl5r_net_1\, Y => \I10.N_2343_i_i_0\);
    
    \I2.VDBm_0l4r\ : MUX2L
      port map(A => \I2.PIPEAl4r_net_1\, B => \I2.PIPEBl4r_net_1\, 
        S => \I2.BLTCYC_17\, Y => \I2.N_2045\);
    
    \I10.un1_CNT_1_G_1\ : AND3
      port map(A => \I10.G_1_0_0_net_1\, B => 
        \I10.DWACT_ADD_CI_0_pog_array_1l0r\, C => 
        \I10.DWACT_ADD_CI_0_g_array_1l0r_adt_net_16050_\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_2l0r\);
    
    \I2.REG3_506_141_456\ : AND3
      port map(A => NLBCLR_c, B => REGl506r, C => 
        \I2.REG1_0_sqmuxa\, Y => \I2.REG3_506_141_adt_net_73367_\);
    
    \I2.REG_il441r\ : INV
      port map(A => \I2.REGl441r\, Y => REG_i_0l441r);
    
    \I2.REGMAPl13r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un84_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl13r_net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_o3_0l4r\ : OR2FT
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTL2R_11\, Y
         => \I10.N_2303\);
    
    LB_padl4r : IOB33PH
      port map(PAD => LB(4), A => \I2.LB_il4r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl4r);
    
    \I2.REG_1_183\ : MUX2L
      port map(A => REGl193r, B => VDB_inl8r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_183_net_1\);
    
    \I10.UN3_BNC_CNT_I_111_154\ : AND2
      port map(A => \I10.DWACT_FINC_El0r\, B => 
        \I10.DWACT_FINC_El2r\, Y => 
        \I10.DWACT_FINC_El28r_adt_net_18856_\);
    
    \I10.STATE1_NS_O9_0_A2_0_A2L11R_149\ : OAI21TTF
      port map(A => \I10.N_2285\, B => \I10.RDY_CNTl0r_net_1\, C
         => \I10.N_2640\, Y => \I10.STATE1_nsl11r_adt_net_16793_\);
    
    \I10.FID_8_IV_0_0_0_1L21R_176\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl69r, Y => 
        \I10.FID_8_iv_0_0_0_1_il21r_adt_net_21929_\);
    
    \I5.BITCNT_6_rl1r\ : OA21FTT
      port map(A => \I5.ISI_0_sqmuxa\, B => \I5.I_13_1\, C => 
        \I5.N_212\, Y => \I5.BITCNT_6l1r\);
    
    \I2.VDBi_54_0_iv_5l12r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il12r\, B => 
        \I2.VDBi_54_0_iv_0_il12r\, C => \I2.VDBi_54_0_iv_1_il12r\, 
        Y => \I2.VDBi_54_0_iv_5_il12r\);
    
    \I10.CRC32_3_i_0_0_x3l2r\ : XOR2FT
      port map(A => \I10.CRC32l2r_net_1\, B => 
        \I10.EVENT_DWORDl2r_net_1\, Y => \I10.N_2331_i_i_0\);
    
    \I2.PIPEA1_9_il25r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl25r, Y => \I2.N_2547\);
    
    \I10.FAULT_STROBE\ : DFFS
      port map(CLK => CLKOUT, D => \I10.FAULT_STROBE_2_i_net_1\, 
        SET => HWRES_c_2_0, Q => \I10.FAULT_STROBE_i\);
    
    \I2.TCNT2_2_I_32\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_1l0r\, B => 
        \I2.TCNT2_i_0_il2r_net_1\, Y => \I2.TCNT2_2l2r\);
    
    \I5.RESCNTl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l5r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl5r_net_1\);
    
    \I3.un4_so_25_0\ : MUX2L
      port map(A => \I3.N_231\, B => \I3.N_220\, S => REGL123R_6, 
        Y => \I3.N_221\);
    
    \I2.VDBil24r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_600_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil24r_net_1\);
    
    \I2.PIPEB_57\ : MUX2H
      port map(A => \I2.PIPEBl8r_net_1\, B => \I2.N_2585\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_57_net_1\);
    
    \I2.STATE1_NS_0L5R_309\ : OAI21FTT
      port map(A => TST_CL2R_16, B => \I2.N_2854\, C => 
        \I2.N_2909\, Y => \I2.STATE1_nsl5r_adt_net_38376_\);
    
    \I2.REG_1l168r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_158_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl168r);
    
    \I2.REG_1_410\ : MUX2H
      port map(A => VDB_inl21r, B => \I2.REGl495r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_410_net_1\);
    
    \I2.PIPEB_4_il15r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl15r, Y => \I2.N_2599\);
    
    \I2.VDBml5r\ : MUX2L
      port map(A => \I2.VDBil5r_net_1\, B => \I2.N_2046\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml5r_net_1\);
    
    \I2.STATE1l7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE1_nsl2r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => \I2.STATE1l7r_net_1\);
    
    \I2.un74_reg_ads_0_a2_0_a2_1\ : NAND2
      port map(A => \I2.WRITES_net_1\, B => \I2.N_3070\, Y => 
        \I2.N_3001_1\);
    
    \I2.PIPEA1_527\ : MUX2L
      port map(A => \I2.PIPEA1l16r_net_1\, B => \I2.N_2529\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_527_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I65_Y\ : XOR2FT
      port map(A => \I10.N_2519_1\, B => 
        \I10.ADD_16x16_medium_I65_Y_0\, Y => 
        \I10.ADD_16x16_medium_I65_Y\);
    
    \I10.FID_8_IV_0_0_0_0L21R_177\ : AND2
      port map(A => \I10.BNC_NUMBERl2r_net_1\, B => 
        \I10.STATE1l9r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il21r_adt_net_21971_\);
    
    \I2.LB_i_7l11r\ : AND2
      port map(A => VDB_inl11r, B => \I2.STATE5l2r_net_1\, Y => 
        \I2.LB_i_7l11r_net_1\);
    
    \I1.un1_BITCNT_I_13\ : XOR2
      port map(A => \I1.DWACT_ADD_CI_0_TMPl0r\, B => 
        \I1.BITCNTl1r_net_1\, Y => \I1.I_13\);
    
    \I5.un1_sstate_7_0_a2\ : NOR2
      port map(A => \I5.sstatel1r_net_1\, B => 
        \I5.sstatel0r_net_1\, Y => \I5.N_218\);
    
    VDB_padl14r : IOB33PH
      port map(PAD => VDB(14), A => \I2.VDBml14r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl14r);
    
    \I10.EVENT_DWORD_18_i_0_0_0l17r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl17r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l17r_adt_net_26678_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l17r_net_1\);
    
    \I2.VDBI_54_0_IV_2L0R_419\ : AND2
      port map(A => REGl185r, B => \I2.REGMAPl20r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2_il0r_adt_net_55003_\);
    
    \I2.VDBi_86_iv_0l2r\ : AO21TTF
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.VDBi_82l2r_net_1\, C => \I2.VDBi_85_ml2r_net_1\, Y
         => \I2.VDBi_86_iv_0_il2r\);
    
    \I2.LB_i_508\ : MUX2L
      port map(A => \I2.LB_il30r_Rd1__net_1\, B => 
        \I2.LB_i_7l30r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__76\, Y => \I2.LB_il30r\);
    
    \I1.sstate2l5r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2se_3_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstate2l5r_net_1\);
    
    \I2.VADml1r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl1r_net_1\, Y
         => \I2.VADml1r_net_1\);
    
    \I1.sstatel12r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el1r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstatel12r_net_1\);
    
    \I2.N_3025_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3025\, SET => 
        HWRES_c_2_0, Q => \I2.N_3025_Rd1__net_1\);
    
    \I10.un6_bnc_res_NE_0\ : OR2
      port map(A => \I10.BNC_CNT_i_il18r\, B => 
        \I10.BNC_CNTl19r_net_1\, Y => \I10.un6_bnc_res_NE_0_i\);
    
    \I10.STATE1l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1L2R_13\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l0r_net_1\);
    
    \I2.VDBI_86_0_IV_0L24R_327\ : AND2
      port map(A => \I2.VDBil24r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il24r_adt_net_40623_\);
    
    \I2.VDBi_56l4r\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l4r_net_1\, C => \I2.VDBi_54_0_iv_5_il4r\, Y
         => \I2.VDBi_56l4r_adt_net_51439_\);
    
    \I2.PIPEB_77\ : MUX2H
      port map(A => \I2.PIPEB_i_il28r\, B => \I2.N_2880\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_77_net_1\);
    
    \I10.un2_i2c_chain_0_i_0l5r\ : OA21TTF
      port map(A => \I10.CNTL2R_11\, B => \I10.N_2412_1\, C => 
        \I10.un2_i2c_chain_0_i_0_7_il5r\, Y => \I10.N_591_i_0\);
    
    \I10.EVENT_DWORD_18_rl18r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l18r_net_1\, B => 
        \I10.EVENT_DWORD_18l18r_adt_net_26596_\, Y => 
        \I10.EVENT_DWORD_18l18r\);
    
    \I2.VDBi_86_0_iv_0l18r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l18r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il18r_adt_net_41881_\, Y => 
        \I2.VDBi_86_0_iv_0_il18r\);
    
    \I1.AIR_COMMAND_46\ : MUX2L
      port map(A => \I1.AIR_COMMANDl14r_net_1\, B => 
        \I1.AIR_COMMAND_21l14r_net_1\, S => 
        \I1.un1_tick_12_net_1\, Y => \I1.AIR_COMMAND_46_net_1\);
    
    \I2.PIPEA_8_rl27r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl27r, C => 
        \I2.PIPEA_8l27r_adt_net_55747_\, Y => \I2.PIPEA_8l27r\);
    
    \I2.VDBi_85_ml10r\ : NAND3
      port map(A => \I2.VDBil10r_net_1\, B => \I2.STATE1_i_il1r\, 
        C => \I2.N_1721_1\, Y => \I2.VDBi_85_ml10r_net_1\);
    
    \I2.REG_1l174r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_164_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl174r);
    
    \I2.LB_i_7l23r\ : AND2
      port map(A => VDB_inl23r, B => \I2.STATE5L2R_73\, Y => 
        \I2.LB_i_7l23r_net_1\);
    
    \I2.VDBi_19l23r\ : AND2
      port map(A => TST_cl5r, B => REGl71r, Y => 
        \I2.VDBi_19l23r_net_1\);
    
    \I2.REG_1_123\ : MUX2H
      port map(A => MD_PDL_C_22, B => VDB_inl0r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_123_net_1\);
    
    \I3.AEl0r\ : MUX2L
      port map(A => REGl153r, B => \I3.un16_ael0r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl0r);
    
    \I2.VDBi_54_0_iv_1l15r\ : AO21
      port map(A => REGl200r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il15r_adt_net_42730_\, Y => 
        \I2.VDBi_54_0_iv_1_il15r\);
    
    \I1.sstatese_7_0\ : AO21TTF
      port map(A => TICKl0r, B => \I1.N_467\, C => 
        \I1.sstatese_7_0_0_net_1\, Y => \I1.sstate_ns_el8r\);
    
    \I1.DATA_12l8r\ : MUX2H
      port map(A => \I1.SBYTEl0r_net_1\, B => REGl113r, S => 
        \I1.DATA_1_sqmuxa_2\, Y => \I1.DATA_12l8r_net_1\);
    
    \I10.CRC32_3_0_a2_i_0_x3l26r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl26r_net_1\, B => 
        \I10.CRC32l26r_net_1\, Y => \I10.N_2345_i_i_0\);
    
    \I2.un1_vsel_5_i_a2_2\ : AND2
      port map(A => \I2.N_2848\, B => IACKB_c, Y => \I2.N_2892_2\);
    
    \I2.PIPEA1_9_il7r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl7r, Y => \I2.N_2511\);
    
    \I10.un1_CNT_1_I_15\ : XOR2
      port map(A => \I10.G_1_0_0_net_1\, B => \I10.CNTl0r_net_1\, 
        Y => \I10.DWACT_ADD_CI_0_partial_suml0r\);
    
    \I10.un2_i2c_chain_0_0_0_0_o3_1l1r\ : OAI21TTF
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTl3r_net_1\, 
        C => \I10.N_2649\, Y => \I10.N_2305\);
    
    \I3.un4_so_29_0\ : MUX2L
      port map(A => SP_PDL_inl7r, B => SP_PDL_inl5r, S => 
        REGl123r, Y => \I3.N_225\);
    
    \I2.TCNT3_2_I_31\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_TMP_0l0r\, B => 
        \I2.TCNT3l1r_net_1\, Y => \I2.TCNT3_2l1r\);
    
    \I2.PIPEA1_9_il11r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl11r, Y => \I2.N_2519\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I6_G0N\ : NOR2FT
      port map(A => \I10.N_2519_1\, B => REG_i_0l38r, Y => 
        \I10.N226\);
    
    \I2.PIPEBl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_51_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl2r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I0_S\ : XOR2
      port map(A => \I10.N_2313_i_0\, B => REGl32r, Y => 
        \I10.ADD_16x16_medium_I0_S\);
    
    \I2.REG3l13r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_120_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl13r\);
    
    \I2.LB_s_4_i_a2_0_a2l25r\ : OR2
      port map(A => LB_inl25r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, Y => 
        \I2.N_3034\);
    
    \I2.LB_i_7l5r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l5r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l5r_Rd1__net_1\);
    
    \I3.AEl37r\ : MUX2L
      port map(A => REGl190r, B => \I3.un16_ael37r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl37r);
    
    \I2.VDBi_17_0l14r\ : AND2
      port map(A => REGl46r, B => \I2.REGMAPl6r_net_1\, Y => 
        \I2.N_1911_adt_net_43206_\);
    
    \I2.VDBI_54_0_IV_0L3R_401\ : AND2
      port map(A => \I2.REGMAP_i_il17r\, B => REGl140r, Y => 
        \I2.VDBi_54_0_iv_0_il3r_adt_net_52124_\);
    
    \I10.CRC32_99\ : MUX2H
      port map(A => \I10.CRC32l12r_net_1\, B => \I10.N_1462\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_99_net_1\);
    
    \I1.sstatese_0_0\ : AO21FTF
      port map(A => TICKl0r, B => \I1.sstatel12r_net_1\, C => 
        \I1.N_452\, Y => \I1.sstate_ns_el1r\);
    
    \I2.un1_STATE2_16_0_a2\ : AND2
      port map(A => REGl5r, B => DTEST_FIFO, Y => 
        \I2.N_2897_adt_net_36076_\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L9R_256\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl17r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l9r_adt_net_27574_\);
    
    \I1.AIR_COMMAND_21l1r\ : MUX2H
      port map(A => \I1.AIR_COMMAND_cnstl1r\, B => REGl90r, S => 
        \I1.sstate2l9r_net_1\, Y => \I1.AIR_COMMAND_21l1r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l3r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl3r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l3r_adt_net_28321_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l3r_net_1\);
    
    \I10.EVENT_DWORD_152\ : MUX2H
      port map(A => \I10.EVENT_DWORDl19r_net_1\, B => 
        \I10.EVENT_DWORD_18l19r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_152_net_1\);
    
    \I2.VDBi_54_0_iv_5l14r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il14r\, B => 
        \I2.VDBi_54_0_iv_0_il14r\, C => \I2.VDBi_54_0_iv_1_il14r\, 
        Y => \I2.VDBi_54_0_iv_5_il14r\);
    
    \I2.REG_1_201\ : MUX2L
      port map(A => SYNC_cl5r, B => VDB_inl5r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_201_net_1\);
    
    \I10.STATE1_5l12r\ : DFFS
      port map(CLK => CLKOUT, D => \I10.N_557_i_0\, SET => 
        CLEAR_0_0, Q => \I10.STATE1l12r_net_1\);
    
    \I2.VDBi_54_0_iv_0l11r\ : AO21
      port map(A => REGl260r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il11r_adt_net_45704_\, Y => 
        \I2.VDBi_54_0_iv_0_il11r\);
    
    \I2.REG_1l505r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_420_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl505r\);
    
    \I2.VDBi_56l22r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l22r_net_1\, Y => \I2.VDBi_56l22r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I72_Y\ : XOR2
      port map(A => \I10.N290\, B => 
        \I10.ADD_16x16_medium_I72_Y_0\, Y => 
        \I10.ADD_16x16_medium_I72_Y\);
    
    \I2.un1_noe64ri_0_a2_0_0\ : NOR2FT
      port map(A => \I2.MBLTCYC_net_1\, B => \I2.ADACKCYC_net_1\, 
        Y => NOEAD_c_0_0);
    
    \I10.CNTl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.G_0_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CNTl5r_net_1\);
    
    \I2.un1_MYBERRi_1_sqmuxa_0\ : AO21TTF
      port map(A => TST_cl2r, B => \I2.STATE1l3r_net_1\, C => 
        \I2.N_2879\, Y => \I2.un1_MYBERRi_1_sqmuxa\);
    
    \I2.STATE5_ns_i_i_a2_0_0_0l0r_119\ : AND2
      port map(A => \I2.SINGCYC_net_1\, B => \I2.N_2389_96\, Y
         => \I2.STATE5_NS_I_I_A2_0_0L0R_103\);
    
    \I2.LB_sl12r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl12r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl12r_Rd1__net_1\);
    
    \I1.SCLB_i_a2\ : NAND2FT
      port map(A => \I1.SCL_net_1\, B => \I1.CHAIN_SELECT_net_1\, 
        Y => SCLB_i_a2);
    
    \I10.FID_8_rl5r\ : AND2FT
      port map(A => \I10.FID_8_iv_0_0_0_0l5r_net_1\, B => 
        \I10.FID_8l5r_adt_net_24138_\, Y => \I10.FID_8l5r\);
    
    \I10.STATE1l5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl7r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l5r_net_1\);
    
    \I2.UN1_STATE5_9_1_RD1__499\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_92\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__84\);
    
    \I2.REG_1l408r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_323_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl408r);
    
    \I0.HWCLEARi\ : DFFC
      port map(CLK => CLKOUT, D => \I0.HWCLEARi_2_net_1\, CLR => 
        HWRES_c_2_0, Q => NLBCLR_c);
    
    \I3.AEl5r\ : MUX2L
      port map(A => REGl158r, B => \I3.un16_ael5r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl5r);
    
    \I2.REG_1l420r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_335_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl420r);
    
    \I10.EVENT_DWORD_147\ : MUX2H
      port map(A => \I10.EVENT_DWORDl14r_net_1\, B => 
        \I10.EVENT_DWORD_18l14r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_147_net_1\);
    
    \I2.VDBi_86_0_iv_0l20r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l20r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il20r_adt_net_41443_\, Y => 
        \I2.VDBi_86_0_iv_0_il20r\);
    
    \I10.un2_i2c_chain_0_i_0_2l5r\ : OAI21FTT
      port map(A => \I10.N_2280\, B => \I10.N_2284\, C => 
        \I10.N_2404\, Y => \I10.un2_i2c_chain_0_i_0_2_il5r\);
    
    \I2.STATE5L1R_508\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl2r\, CLR => 
        HWRES_c_2_0, Q => \I2.STATE5L1R_104\);
    
    \I2.REG_1l459r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_374_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl459r);
    
    \I10.STATE2_ns_0_0_0l2r\ : AO21FTT
      port map(A => \I10.STATE2l2r_net_1\, B => REGl384r, C => 
        \I10.STATE2l1r_net_1\, Y => \I10.STATE2_nsl2r\);
    
    \I2.REGMAPl33r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un119_reg_ads_0_a2_net_1\, 
        Q => \I2.REGMAPl33r_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_4l3r\ : NAND2FT
      port map(A => \I10.CNTl3r_net_1\, B => \I10.N_2302\, Y => 
        \I10.N_2371_adt_net_28966_\);
    
    \I2.N_3021_1_adt_net_116360_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3021_1\, SET => 
        HWRES_c_2_0, Q => \I2.N_3021_1_adt_net_116360_Rd1__net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_o3l4r\ : AND2
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTL2R_11\, Y
         => \I10.N_2294\);
    
    \I10.event_meb.M1\ : FIFO256x9SST
      port map(DO8 => OPEN, DO7 => DPRl15r, DO6 => DPRl14r, DO5
         => DPRl13r, DO4 => DPRl12r, DO3 => DPRl11r, DO2 => 
        DPRl10r, DO1 => DPRl9r, DO0 => DPRl8r, FULL => 
        \I10.event_meb.net00004\, EMPTY => OPEN, EQTH => OPEN, 
        GEQTH => OPEN, WPE => OPEN, RPE => OPEN, DOS => OPEN, 
        LGDEP2 => \VCC\, LGDEP1 => \VCC\, LGDEP0 => \VCC\, RESET
         => CLEAR_i_0, LEVEL7 => \GND\, LEVEL6 => \GND\, LEVEL5
         => \GND\, LEVEL4 => \GND\, LEVEL3 => \GND\, LEVEL2 => 
        \GND\, LEVEL1 => \GND\, LEVEL0 => \VCC\, DI8 => \GND\, 
        DI7 => \I10.FIDl15r_net_1\, DI6 => \I10.FIDl14r_net_1\, 
        DI5 => \I10.FIDl13r_net_1\, DI4 => \I10.FIDl12r_net_1\, 
        DI3 => \I10.FIDl11r_net_1\, DI2 => \I10.FIDl10r_net_1\, 
        DI1 => \I10.FIDl9r_net_1\, DI0 => \I10.FIDl8r_net_1\, WRB
         => \I10.WRB_net_1\, RDB => NRDMEB, WBLKB => \GND\, RBLKB
         => \GND\, PARODD => \GND\, WCLKS => CLKOUT, RCLKS => 
        CLKOUT, DIS => \GND\);
    
    \I2.REG_1l192r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_182_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl192r);
    
    \I2.LB_i_7l21r\ : AND2
      port map(A => VDB_inl21r, B => \I2.STATE5L2R_74\, Y => 
        \I2.LB_i_7l21r_net_1\);
    
    \I2.REG_1_147\ : MUX2L
      port map(A => REGl157r, B => VDB_inl4r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_147_net_1\);
    
    \I10.FIDl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_168_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl3r_net_1\);
    
    \I10.CRC32_3_i_0_0l22r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2336_i_i_0\, Y => \I10.N_1468\);
    
    \I10.STATE2_ns_a3_0_a2_0_a2_0_a2l1r\ : AND2
      port map(A => \I10.STATE2l2r_net_1\, B => REGl384r, Y => 
        \I10.STATE2_nsl1r\);
    
    \I2.VDBil16r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_592_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil16r_net_1\);
    
    \I2.N_3021_1_adt_net_116344_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3021_1\, SET => 
        HWRES_c_2_0, Q => \I2.N_3021_1_adt_net_116344_Rd1__net_1\);
    
    \I10.un3_bnc_cnt_I_90\ : AND2
      port map(A => \I10.DWACT_FINC_El13r_adt_net_18968_\, B => 
        \I10.DWACT_FINC_El28r\, Y => \I10.N_26\);
    
    \I2.VDBi_85_ml2r\ : NAND3
      port map(A => \I2.VDBil2r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml2r_net_1\);
    
    \I1.un1_BITCNT_I_14\ : XOR2
      port map(A => \I1.DWACT_ADD_CI_0_g_array_1l0r\, B => 
        \I1.BITCNTl2r_net_1\, Y => \I1.I_14\);
    
    \I10.EVENT_DWORD_18_RL16R_243\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl26r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l16r_adt_net_26820_\);
    
    \I2.VDBi_61l7r\ : AND3FTT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_56l7r_adt_net_49002_\, C => 
        \I2.VDBi_61_sl0r_net_1\, Y => 
        \I2.VDBi_61l7r_adt_net_49041_\);
    
    \I2.VDBI_54_0_IV_0L7R_377\ : AND2
      port map(A => \I2.REGMAP_i_il17r\, B => REGl144r, Y => 
        \I2.VDBi_54_0_iv_0_il7r_adt_net_48884_\);
    
    \I10.un1_STATE1_15_0_0_0_0_o2_0_0_0\ : OR2
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.STATE1L12R_10\, Y => \I10.N_2351_0_0\);
    
    \I2.VDBi_24l8r\ : MUX2L
      port map(A => \I2.REGl482r\, B => \I2.VDBi_19l8r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l8r_net_1\);
    
    \I2.VAS_91\ : MUX2L
      port map(A => VAD_inl9r, B => \I2.VAS_i_0_il9r\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_91_net_1\);
    
    \I2.REG_il273r\ : INV
      port map(A => \I2.REGl273r\, Y => REG_i_0l273r);
    
    \I2.VDBi_54_0_iv_5l10r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il10r\, B => 
        \I2.VDBi_54_0_iv_0_il10r\, C => \I2.VDBi_54_0_iv_1_il10r\, 
        Y => \I2.VDBi_54_0_iv_5_il10r\);
    
    \I2.REG_1l176r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_166_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl176r);
    
    \I5.G_1\ : NAND2
      port map(A => \I5.sstatel5r_net_1\, B => PULSEl10r, Y => 
        \I5.N_211_0\);
    
    \I1.PULSE_FL\ : DFFC
      port map(CLK => CLKOUT, D => \I1.PULSE_FL_12_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.PULSE_FL_net_1\);
    
    \I10.un3_bnc_cnt_I_97\ : AND3
      port map(A => \I10.BNC_CNTl15r_net_1\, B => 
        \I10.DWACT_FINC_El13r_adt_net_18968_\, C => 
        \I10.DWACT_FINC_El28r\, Y => \I10.N_21\);
    
    \I2.un1_STATE2_12_0_o3_2_o2_0\ : OR2
      port map(A => \I2.N_2895_2\, B => \I2.END_PK_net_1\, Y => 
        \I2.un1_STATE2_12_0_o3_2_o2_0_net_1\);
    
    \I2.LB_i_7l13r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l13r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l13r_Rd1__net_1\);
    
    NLBCLR_pad : OB33PH
      port map(PAD => NLBCLR, A => NLBCLR_c);
    
    \I10.FID_8_RL28R_163\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl28r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il28r\, Y => 
        \I10.FID_8l28r_adt_net_20862_\);
    
    \I2.un1_NRDMEBi_2_sqmuxa_2_1\ : OR3FFT
      port map(A => \I2.STATE2_i_0l3r\, B => 
        \I2.NRDMEBi_0_sqmuxa_1_net_1\, C => \I2.STATE2l0r_net_1\, 
        Y => \I2.un1_NRDMEBi_2_sqmuxa_2_1_i\);
    
    \I2.PIPEA1l11r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_522_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l11r_net_1\);
    
    \I2.REG_1l164r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_154_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl164r);
    
    \I5.sstate_0_sqmuxa_1_0_a2_13\ : OR3FFT
      port map(A => \I5.RESCNTl7r_net_1\, B => 
        \I5.RESCNTl8r_net_1\, C => 
        \I5.sstate_0_sqmuxa_1_0_a2_3_i\, Y => 
        \I5.sstate_0_sqmuxa_1_0_a2_13_i_adt_net_33240_\);
    
    \I1.AIR_COMMAND_37\ : MUX2L
      port map(A => \I1.AIR_COMMANDl0r_net_1\, B => 
        \I1.AIR_COMMAND_21l0r_net_1\, S => \I1.un1_tick_12_net_1\, 
        Y => \I1.AIR_COMMAND_37_net_1\);
    
    \I2.LB_i_7l16r\ : AND2
      port map(A => VDB_inl16r, B => \I2.STATE5L2R_75\, Y => 
        \I2.LB_i_7l16r_net_1\);
    
    \I5.un1_RESCNT_I_60\ : XOR2
      port map(A => \I5.RESCNTl13r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_12_5l0r\, Y => \I5.I_60\);
    
    \I2.VAS_83\ : MUX2L
      port map(A => VAD_inl1r, B => \I2.VASl1r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_83_net_1\);
    
    \I10.UN2_I2C_CHAIN_0_I_0_6L5R_282\ : OAI21TTF
      port map(A => \I10.N_2300\, B => \I10.N_2290\, C => 
        \I10.N_2411_i\, Y => 
        \I10.un2_i2c_chain_0_i_0_6_il5r_adt_net_30266_\);
    
    \I10.CRC32_3_i_0_0_x3l16r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl16r_net_1\, B => 
        \I10.CRC32l16r_net_1\, Y => \I10.N_2318_i_i_0\);
    
    \I3.un4_so_20_0\ : MUX2L
      port map(A => SP_PDL_inl30r, B => \I3.N_215\, S => REGl126r, 
        Y => \I3.N_216\);
    
    \I2.VDBi_54_0_iv_3l3r\ : AO21TTF
      port map(A => REGL124R_5, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l3r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il3r\);
    
    \I2.VDBil10r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_586_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil10r_net_1\);
    
    \I2.REG_il275r\ : INV
      port map(A => \I2.REGl275r\, Y => REG_i_0l275r);
    
    \I1.SDAout_11_iv\ : AO21TTF
      port map(A => \I1.COMMANDl15r_net_1\, B => \I1.N_536\, C
         => \I1.SDAout_11_iv_0_net_1\, Y => \I1.N_524\);
    
    \I10.un3_bnc_cnt_I_66\ : XOR2
      port map(A => \I10.BNC_CNTl11r_net_1\, B => \I10.N_44\, Y
         => \I10.I_66\);
    
    \I2.REG_1_181\ : MUX2L
      port map(A => REGl191r, B => VDB_inl6r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_181_net_1\);
    
    \I2.PIPEA1_9_il22r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl22r, Y => \I2.N_2541\);
    
    \I2.VDBi_54_0_iv_6l0r\ : NOR3
      port map(A => \I2.VDBi_54_0_iv_5_il0r\, B => 
        \I2.VDBi_54_0_iv_1_il0r\, C => \I2.VDBi_54_0_iv_2_il0r\, 
        Y => \I2.VDBi_54_0_iv_6l0r_net_1\);
    
    \I2.PIPEA1_521\ : MUX2L
      port map(A => \I2.PIPEA1l10r_net_1\, B => \I2.N_2517\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_521_net_1\);
    
    \I10.EVENT_DWORD_18_RL23R_229\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl23r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l23r_adt_net_25910_\);
    
    \I2.STATE1_ns_0l2r\ : OAI21FTF
      port map(A => \I2.STATE1l7r_net_1\, B => \I2.N_2981\, C => 
        \I2.STATE1l0r_net_1\, Y => \I2.STATE1_ns_0l2r_net_1\);
    
    \I2.STATE1l9r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.STATE1_nsl0r\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.STATE1l9r_net_1\);
    
    \I2.VDBi_24l20r\ : MUX2L
      port map(A => \I2.REGl494r\, B => \I2.VDBi_19l20r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l20r_net_1\);
    
    \I2.REG_1l238r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_201_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl5r);
    
    \I10.FID_8_iv_0_0_0_0l16r\ : AO21
      port map(A => \I10.STATE1l11r_net_1\, B => REGl64r, C => 
        \I10.FID_8_iv_0_0_0_0_il16r_adt_net_22749_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il16r\);
    
    \I3.un16_ae_4\ : AND2FT
      port map(A => \I3.un16_ae_1l45r\, B => \I3.un16_ae_1l4r\, Y
         => \I3.un16_ael4r\);
    
    \I2.REG_1_238\ : MUX2L
      port map(A => \I2.REGL275R_43\, B => VDB_inl10r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_238_net_1\);
    
    \I2.REG_1_381\ : MUX2H
      port map(A => VDB_inl9r, B => REGl466r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_381_net_1\);
    
    \I2.PIPEAl16r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_560_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl16r_net_1\);
    
    \I2.ADACKCYC_104\ : MUX2H
      port map(A => \I2.ADACKCYC_net_1\, B => \I2.TST_c_0l1r\, S
         => \I2.N_2637\, Y => \I2.ADACKCYC_104_net_1\);
    
    \I1.sstatel11r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstatese_1_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstatel11r_net_1\);
    
    LED_padl4r : OB33PH
      port map(PAD => LED(4), A => \VCC\);
    
    \I2.VDBi_587\ : MUX2L
      port map(A => \I2.VDBil11r_net_1\, B => \I2.VDBi_86l11r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_587_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l21r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl5r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il21r_adt_net_21971_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il21r\);
    
    \I2.VDBi_598\ : MUX2L
      port map(A => \I2.VDBil22r_net_1\, B => \I2.VDBi_86l22r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_598_net_1\);
    
    \I2.VDBI_86_0_IVL17R_341\ : AO21
      port map(A => \I2.PIPEAl17r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il17r\, Y => 
        \I2.VDBi_86l17r_adt_net_42125_\);
    
    \I2.LB_i_496\ : MUX2L
      port map(A => \I2.LB_il18r_Rd1__net_1\, B => 
        \I2.LB_i_7l18r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__82\, Y => \I2.LB_il18r\);
    
    \I1.DATAl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12l12r_net_1\, CLR
         => HWRES_c_2_0, Q => REGl117r);
    
    \I1.SDAout_11_iv_0\ : AOI21TTF
      port map(A => \I1.sstatel6r_net_1\, B => 
        \I1.SBYTEl7r_net_1\, C => \I1.SDAout_m_net_1\, Y => 
        \I1.SDAout_11_iv_0_net_1\);
    
    \I10.CRC32_3_i_0_0l24r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2337_i_i_0\, Y => \I10.N_1470\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I77_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => REGl45r, Y => 
        \I10.ADD_16x16_medium_I77_Y_0\);
    
    \I2.VDBi_56l23r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l23r_net_1\, Y => \I2.VDBi_56l23r_net_1\);
    
    \I0.BNC_RESi\ : DFFC
      port map(CLK => ACLKOUT, D => \I0.BNC_RESi_1_net_1\, CLR
         => \I0.N_111_i_0\, Q => BNC_RES);
    
    \I5.RESCNTl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l10r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl10r_net_1\);
    
    \I2.VDBi_67l13r\ : MUX2L
      port map(A => \I2.VDBi_61l13r_net_1\, B => \I2.N_1962\, S
         => \I2.N_1965\, Y => \I2.VDBi_67l13r_net_1\);
    
    \I2.VDBi_24l9r\ : MUX2L
      port map(A => \I2.REGl483r\, B => \I2.VDBi_19l9r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l9r_net_1\);
    
    \I2.LB_il30r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il30r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il30r_Rd1__net_1\);
    
    AE_PDL_padl15r : OB33PH
      port map(PAD => AE_PDL(15), A => AE_PDL_cl15r);
    
    \I2.REG_1_173\ : MUX2L
      port map(A => REGl183r, B => VDB_inl14r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_173_net_1\);
    
    \I2.REG_1_0l121r_38\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_123_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => MD_PDL_C_22);
    
    \I2.PIPEB_4_il7r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl7r, Y => \I2.N_2583\);
    
    \I2.LB_i_7l31r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l31r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l31r_Rd1__net_1\);
    
    \I2.PIPEA1_541\ : MUX2L
      port map(A => \I2.PIPEA1l30r_net_1\, B => \I2.N_2871\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_541_net_1\);
    
    \I10.un3_bnc_cnt_I_121\ : AND3
      port map(A => \I10.BNC_CNT_i_il18r\, B => 
        \I10.DWACT_FINC_El13r\, C => \I10.DWACT_FINC_El28r\, Y
         => \I10.N_4\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I67_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl35r\, Y => 
        \I10.ADD_16x16_medium_I67_Y_0\);
    
    TST_pad_il7r : AOI21FTT
      port map(A => \I2.LWORDS_net_1\, B => \I2.N_2983_1\, C => 
        NOEAD_C_0_0_21, Y => \I2.N_2732_i_0\);
    
    \I2.REG_1l248r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_211_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl248r);
    
    \I2.STATE5_ns_i_il0r_110\ : AOI21FTF
      port map(A => \I2.STATE5_NS_I_I_A2_0_0L0R_103\, B => 
        \I2.N_2385_ADT_NET_38045__102\, C => \I2.N_2386_1_99\, Y
         => \I2.STATE5_NS_I_IL0R_94\);
    
    \I2.REG_1l275r_59\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_238_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL275R_43\);
    
    \I10.BNC_CNTl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_202_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl4r_net_1\);
    
    \I1.sstate2l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2se_6_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstate2l2r_net_1\);
    
    \I8.I_50\ : AND3
      port map(A => \I8.sstatel1r_net_1\, B => 
        \I8.sstatel0r_net_1\, C => \I8.I_50_3_net_1\, Y => 
        \I8.N_219\);
    
    \I2.VDBi_86_ivl2r\ : OR2
      port map(A => \I2.VDBi_86_iv_1_il2r\, B => 
        \I2.VDBi_86l2r_adt_net_53418_\, Y => \I2.VDBi_86l2r\);
    
    \I2.REG_1_247\ : MUX2L
      port map(A => \I2.REGL284R_52\, B => VDB_inl19r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_247_net_1\);
    
    \I2.REG_1l81r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_454_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl81r);
    
    \I10.FAULT_STAT_1_sqmuxa_i\ : AO21
      port map(A => \I10.FAULT_STROBE_0_net_1\, B => 
        \I10.FAULT_STROBE_i\, C => \I10.CLEAR_PSM_FLAGS_net_1\, Y
         => \I10.N_1579\);
    
    \I2.VDBI_54_0_IV_1L6R_384\ : AND2
      port map(A => SYNC_cl6r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il6r_adt_net_49757_\);
    
    \I2.REG_1l481r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_396_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl481r\);
    
    \I3.un1_hwres_3\ : NOR3
      port map(A => HWRES_C_2_0_19, B => \I3.N_186\, C => 
        \I3.N_184_i\, Y => \I3.un1_hwres_3_net_1\);
    
    \I2.PULSE_1_101\ : MUX2H
      port map(A => PULSEl2r, B => \I2.PULSE_43l2r\, S => 
        \I2.un1_STATE1_18\, Y => \I2.PULSE_1_101_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I52_Y\ : AO21TTF
      port map(A => \I10.N279\, B => 
        \I10.ADD_16x16_medium_I52_un1_Y_1\, C => 
        \I10.ADD_16x16_medium_I52_Y_1\, Y => \I10.N302\);
    
    \I1.CHAIN_SELECT_m\ : NOR3FFT
      port map(A => \I1.CHAIN_SELECT_net_1\, B => REGl7r, C => 
        I2C_RREQ, Y => \I1.CHAIN_SELECT_m_i\);
    
    \I2.STATE1l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE1_nsl8r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => \I2.STATE1_i_il1r\);
    
    \I10.un3_bnc_cnt_I_105\ : XOR2
      port map(A => \I10.BNC_CNTl17r_net_1\, B => \I10.N_16\, Y
         => \I10.I_105\);
    
    \I1.BITCNTl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.BITCNT_10l1r\, CLR => 
        HWRES_c_2_0, Q => \I1.BITCNTl1r_net_1\);
    
    AE_PDL_padl27r : OB33PH
      port map(PAD => AE_PDL(27), A => AE_PDL_cl27r);
    
    \I2.REG_1_321\ : MUX2L
      port map(A => REGl406r, B => VDB_inl13r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_321_net_1\);
    
    \I10.EVENT_DWORD_18_RL0R_275\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl10r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l0r_adt_net_28687_\);
    
    \I10.EVENT_DWORD_18_I_0_0L15R_244\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl23r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0l15r_adt_net_26902_\);
    
    \I5.sstate_0_sqmuxa_0_o2\ : NAND2
      port map(A => \I5.sstatel5r_net_1\, B => PULSEl6r, Y => 
        \I5.N_212\);
    
    \I10.un2_evread_3_i_0_a2_0_9\ : NAND3FFT
      port map(A => REGl33r, B => \I10.REGl35r\, C => 
        \I10.un2_evread_3_i_0_a2_0_6_net_1\, Y => 
        \I10.un2_evread_3_i_0_a2_0_9_i\);
    
    \I2.REG_1l273r_57\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_236_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL273R_41\);
    
    \I2.PIPEA1_9_il3r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl3r, Y => \I2.N_2503\);
    
    \I2.PIPEA1_9_il1r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl1r, Y => \I2.N_2499\);
    
    \I2.REG_1l166r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_156_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl166r);
    
    \I2.UN1_STATE5_9_1_RD1__501\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_92\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__86\);
    
    \I10.EVENT_DWORD_18_i_0_0_1l28r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.PDL_RADDRl4r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l28r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l28r_net_1\);
    
    \I2.VDBil2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_578_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil2r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_1l29r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.PDL_RADDRl5r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l29r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l29r_net_1\);
    
    \I10.OR_RADDR_221\ : MUX2H
      port map(A => \I10.CNTl3r_net_1\, B => 
        \I10.OR_RADDRl3r_net_1\, S => \I10.N_2126\, Y => 
        \I10.OR_RADDR_221_net_1\);
    
    \I10.BNC_CNTl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_207_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl9r_net_1\);
    
    \I2.LB_i_7l26r\ : AND2
      port map(A => VDB_inl26r, B => \I2.STATE5L2R_73\, Y => 
        \I2.LB_i_7l26r_net_1\);
    
    \I10.BNCRES_CNT_4_I_33\ : XOR2
      port map(A => \I10.BNCRES_CNTl5r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_12_1l0r\, Y => 
        \I10.BNCRES_CNT_4l5r\);
    
    \I2.LB_il10r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il10r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il10r_Rd1__net_1\);
    
    \I2.REG_1_ml160r\ : NAND2
      port map(A => REGl160r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml160r_net_1\);
    
    \I10.FID_8_IV_0_0_0_1L23R_172\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl71r, Y => 
        \I10.FID_8_iv_0_0_0_1_il23r_adt_net_21601_\);
    
    \I10.EVNT_NUM_3_I_67\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_2_1l0r\, B => 
        \I10.DWACT_ADD_CI_0_pog_array_2l0r\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_3l0r\);
    
    \I2.WDOG_3_I_11\ : XOR2
      port map(A => TICKl2r, B => \I2.WDOGl0r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_partial_sum_2l0r\);
    
    \I2.REG_1l66r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_439_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl66r);
    
    \I8.un1_ISI_1_sqmuxa_0_o2\ : NOR2
      port map(A => \I8.N_207_i\, B => \I8.N_209\, Y => 
        \I8.un1_ISI_1_sqmuxa_0_o2_net_1\);
    
    \I2.REG_1_249\ : MUX2L
      port map(A => \I2.REGL286R_54\, B => VDB_inl21r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_249_net_1\);
    
    \I1.DATA_12l9r\ : MUX2H
      port map(A => \I1.SBYTEl1r_net_1\, B => REGl114r, S => 
        \I1.DATA_1_sqmuxa_2\, Y => \I1.DATA_12l9r_net_1\);
    
    \I2.VDBi_67l7r\ : OA21
      port map(A => \I2.VDBi_61l7r_adt_net_49041_\, B => 
        \I2.VDBi_61l7r_adt_net_49043_\, C => \I2.N_1965\, Y => 
        \I2.VDBi_67l7r_adt_net_49083_\);
    
    \I2.VDBi_86_iv_0l12r\ : AOI21TTF
      port map(A => \I2.VDBil12r_net_1\, B => 
        \I2.STATE1l2r_net_1\, C => \I2.VDBi_85_ml12r_net_1\, Y
         => \I2.VDBi_86_iv_0l12r_net_1\);
    
    \I0.HWCLEARi_2\ : AND3FFT
      port map(A => \I0.HWCLEARi_2_0_i\, B => PULSEl1r, C => 
        WDOGTO_i_0, Y => \I0.HWCLEARi_2_net_1\);
    
    \I10.FID_8_0_iv_0_0_0_a2_0l31r\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl79r, Y => 
        \I10.N_2505_i\);
    
    \I2.REG_1l292r_76\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_255_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL292R_60\);
    
    \I2.LB_i_7_rl7r\ : AND2FT
      port map(A => \I2.STATE5L4R_ADT_NET_116400_RD1__66\, B => 
        \I2.N_1894\, Y => \I2.LB_i_7l7r_net_1\);
    
    \I3.un1_BITCNT_I_15\ : AND2
      port map(A => \I3.DWACT_ADD_CI_0_TMPl0r\, B => 
        \I3.BITCNTl1r_net_1\, Y => 
        \I3.DWACT_ADD_CI_0_g_array_1l0r\);
    
    \I2.REG_il265r\ : INV
      port map(A => \I2.REGl265r\, Y => REG_i_0l265r);
    
    \I10.EVNT_NUMl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l4r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl4r_net_1\);
    
    \I2.N_1679_i_0_i\ : MUX2H
      port map(A => TST_CL2R_16, B => \I2.N_2860_i_0_i\, S => 
        \I2.STATE1_i_0l5r\, Y => \I2.N_1679_i_0_i_net_1\);
    
    \I10.FID_186\ : MUX2L
      port map(A => \I10.FID_8l21r\, B => \I10.FIDl21r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_186_net_1\);
    
    \I2.un78_reg_ads_0_a2_0_a2_1\ : NAND2FT
      port map(A => \I2.N_3068\, B => \I2.N_3070\, Y => 
        \I2.N_3002_1\);
    
    \I2.VDBi_67_ml1r\ : AND2
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l1r_adt_net_94342_\, Y => 
        \I2.VDBi_67_m_il1r_adt_net_103676_\);
    
    \I10.STATE1l9r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl3r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l9r_net_1\);
    
    VDB_padl4r : IOB33PH
      port map(PAD => VDB(4), A => \I2.VDBml4r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl4r);
    
    \I1.un83_tick\ : NOR3
      port map(A => CHANNELl2r, B => CHANNELl0r, C => CHANNELl1r, 
        Y => \I1.un83_tick_net_1\);
    
    \I2.REG_1l133r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_135_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl133r);
    
    LB_padl24r : IOB33PH
      port map(PAD => LB(24), A => \I2.LB_il24r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl24r);
    
    \I2.REG_1_133\ : MUX2H
      port map(A => REG_cl131r, B => VDB_inl10r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_133_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_a2_7l5r\ : NOR3FFT
      port map(A => \I10.CNTl4r_net_1\, B => \I10.N_2294\, C => 
        \I10.CNTl3r_net_1\, Y => \I10.N_2411_i\);
    
    \I2.un6_tcnt1\ : AND2FT
      port map(A => \I2.un6_tcnt1_2_i\, B => 
        \I2.un6_tcnt1_adt_net_79937_\, Y => \I2.un6_tcnt1_net_1\);
    
    \I2.REG_92_0l86r\ : MUX2H
      port map(A => VDB_inl5r, B => REGl86r, S => 
        \I2.REG_1_sqmuxa_1\, Y => \I2.N_1989\);
    
    \I2.PIPEA1l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_512_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l1r_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l24r\ : OR2
      port map(A => LB_inl24r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, Y => 
        \I2.N_3033\);
    
    \I10.EVENT_DWORD_18_rl27r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l27r_net_1\, B => 
        \I10.EVENT_DWORD_18l27r_adt_net_25294_\, Y => 
        \I10.EVENT_DWORD_18l27r\);
    
    \I5.SBYTE_13\ : MUX2H
      port map(A => FBOUTl7r, B => \I5.SBYTE_5l7r_net_1\, S => 
        \I5.un1_sstate_12\, Y => \I5.SBYTE_13_net_1\);
    
    \I8.BITCNT_6_rl1r\ : OA21
      port map(A => \I8.N_219\, B => \I8.I_15\, C => 
        \I8.SWORD_0_sqmuxa\, Y => \I8.BITCNT_6l1r\);
    
    \I1.I2C_CHAIN_m\ : NAND3
      port map(A => \I1.sstate2l9r_net_1\, B => I2C_RREQ, C => 
        I2C_CHAIN, Y => \I1.I2C_CHAIN_m_net_1\);
    
    \I2.PIPEAl31r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_575_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl31r_net_1\);
    
    \I2.LB_i_7_rl5r\ : AND2FT
      port map(A => \I2.STATE5L4R_ADT_NET_116400_RD1__67\, B => 
        \I2.N_1892\, Y => \I2.LB_i_7l5r_net_1\);
    
    \I3.un1_hwres_2\ : NAND2FT
      port map(A => HWRES_C_2_0_19, B => \I3.ISI_0_sqmuxa\, Y => 
        \I3.un1_hwres_2_net_1\);
    
    AE_PDL_padl12r : OB33PH
      port map(PAD => AE_PDL(12), A => AE_PDL_cl12r);
    
    \I1.I2C_RDATAl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_14_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl0r);
    
    GA_padl3r : IB33
      port map(PAD => GA(3), Y => GA_cl3r);
    
    \I2.LB_sl14r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl14r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl14r_Rd1__net_1\);
    
    \I3.un16_ae_47_2\ : NAND2
      port map(A => REGl123r, B => REGl124r, Y => 
        \I3.un16_ae_2l47r\);
    
    \I2.DSSF1_12\ : AO21
      port map(A => \I2.DSSF1_net_1\, B => \I2.N_2866\, C => 
        \I2.DSSF1_12_adt_net_79192_\, Y => \I2.DSSF1_12_net_1\);
    
    \I2.TCNT2_2_I_34\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_12_2l0r\, B => 
        \I2.TCNT2l7r_net_1\, Y => \I2.TCNT2_2l7r\);
    
    \I2.N_3033_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3033\, SET => 
        HWRES_c_2_0, Q => \I2.N_3033_Rd1__net_1\);
    
    AE_PDL_padl14r : OB33PH
      port map(PAD => AE_PDL(14), A => AE_PDL_cl14r);
    
    \I2.VDBI_86_0_IVL24R_328\ : AO21
      port map(A => \I2.PIPEAl24r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il24r\, Y => 
        \I2.VDBi_86l24r_adt_net_40662_\);
    
    \I10.I2C_CHAIN_1_sqmuxa_i_0\ : NAND2FT
      port map(A => CLEAR_0_0_18, B => \I10.N_2356\, Y => 
        \I10.N_1595\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L3R_268\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl11r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l3r_adt_net_28321_\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l24r\ : OAI21TTF
      port map(A => I2C_RDATAl4r, B => \I10.N_2639\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l24r_adt_net_25684_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l24r_net_1\);
    
    \I3.un4_so_16_0\ : MUX2L
      port map(A => \I3.N_214\, B => \I3.N_209\, S => REGl124r, Y
         => \I3.N_212\);
    
    \I10.EVENT_DWORDl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_142_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl9r_net_1\);
    
    SYNC_padl5r : OB33PH
      port map(PAD => SYNC(5), A => SYNC_cl5r);
    
    \I10.BNC_CNT_4_0_a2l18r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => 
        \I10.I_115\, Y => \I10.BNC_CNT_4l18r\);
    
    \I2.REG_1_203\ : MUX2L
      port map(A => SYNC_cl7r, B => VDB_inl7r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_203_net_1\);
    
    \I10.READ_PDL_FLAG_86_0_0_0\ : OR2
      port map(A => \I10.STATE1l8r_net_1\, B => 
        \I10.READ_PDL_FLAG_86_0_0_0_adt_net_32635_\, Y => 
        \I10.READ_PDL_FLAG_86_0_0_0_net_1\);
    
    LBSP_padl6r : IOB33PH
      port map(PAD => LBSP(6), A => REGl399r, EN => REG_i_0l271r, 
        Y => LBSP_inl6r);
    
    \I2.VDBi_86_ivl8r\ : AO21TTF
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l8r_net_1\, C => \I2.VDBi_86_iv_2l8r_net_1\, Y
         => \I2.VDBi_86l8r\);
    
    \I2.VDBi_67_sl0r\ : NAND2
      port map(A => \I2.N_1965\, B => \I2.VDBi_61_sl0r_net_1\, Y
         => \I2.VDBi_67_sl0r_net_1\);
    
    RSELB1_pad : OTB33PH
      port map(PAD => RSELB1, A => REGl429r, EN => REG_i_0l445r);
    
    \I2.VDBi_86_iv_1l2r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl2r\, C
         => \I2.VDBi_86_iv_1_il2r_adt_net_53258_\, Y => 
        \I2.VDBi_86_iv_1_il2r\);
    
    \I2.un756_regmap_6\ : OR3
      port map(A => \I2.REGMAPl5r_net_1\, B => 
        \I2.REGMAP_i_0_il9r\, C => \I2.REGMAP_i_il4r\, Y => 
        \I2.un756_regmap_6_i\);
    
    \I2.REGMAPl24r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un81_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl24r_net_1\);
    
    \I2.LB_i_7l30r\ : AND2
      port map(A => VDB_inl30r, B => \I2.STATE5L2R_72\, Y => 
        \I2.LB_i_7l30r_net_1\);
    
    \I2.un17_reg_ads_0_a2_0_a3\ : NAND2FT
      port map(A => \I2.VASl5r_net_1\, B => \I2.VASl3r_net_1\, Y
         => \I2.N_3067\);
    
    \I10.CRC32_104\ : MUX2H
      port map(A => \I10.CRC32l17r_net_1\, B => \I10.N_1037\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_104_net_1\);
    
    \I2.REGMAPl16r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un54_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl16r_net_1\);
    
    \I10.EVNT_NUM_3_I_69\ : AND3
      port map(A => \I10.DWACT_ADD_CI_0_pog_array_1_1_0l0r\, B
         => \I10.EVNT_NUMl6r_net_1\, C => \I10.EVNT_NUMl7r_net_1\, 
        Y => \I10.DWACT_ADD_CI_0_pog_array_2l0r\);
    
    \I2.REG_1_413\ : MUX2H
      port map(A => VDB_inl24r, B => \I2.REGl498r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_413_net_1\);
    
    \I10.BNC_NUMBER_233\ : MUX2L
      port map(A => \I10.BNCRES_CNTl3r_net_1\, B => 
        \I10.BNC_NUMBERl3r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_233_net_1\);
    
    \I10.EVNT_NUM_3_I_43\ : XOR2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_3l0r\, B => 
        \I10.EVNT_NUMl8r_net_1\, Y => \I10.EVNT_NUM_3l8r\);
    
    SP_PDL_padl19r : IOB33PH
      port map(PAD => SP_PDL(19), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl19r);
    
    \I10.CRC32l25r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_112_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l25r_net_1\);
    
    \I2.LB_nOE\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_nOE_1_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_nOE_net_1\);
    
    \I2.VDBi_54_0_iv_0l7r\ : AO21
      port map(A => REGl256r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il7r_adt_net_48884_\, Y => 
        \I2.VDBi_54_0_iv_0_il7r\);
    
    \I2.STATE5_ns_0l4r\ : AO21FTT
      port map(A => TST_CL2R_16, B => \I2.STATE5l0r_net_1\, C => 
        \I2.STATE5l1r_Rd1_\, Y => \I2.STATE5_nsl4r\);
    
    \I2.REG_1l414r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_329_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl414r);
    
    \I2.VDBi_67_ml5r\ : OA21
      port map(A => \I2.VDBi_67l5r_adt_net_50717_\, B => 
        \I2.VDBi_67l5r_adt_net_50719_\, C => \I2.N_1705_i_0_1_0\, 
        Y => \I2.VDBi_67_m_il5r\);
    
    \I10.UN2_I2C_CHAIN_0_I_0_0_I_1L2R_276\ : AOI21FTT
      port map(A => \I10.N_2279\, B => \I10.CNTl3r_net_1\, C => 
        \I10.N_2645_i\, Y => 
        \I10.un2_i2c_chain_0_i_0_0_i_1l2r_adt_net_29231_\);
    
    \I2.REG3_121\ : MUX2L
      port map(A => VDB_inl14r, B => \I2.REGl14r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_121_net_1\);
    
    \I2.PIPEA_8_SL30R_423\ : MUX2H
      port map(A => DPRl30r, B => \I2.PIPEA1l30r_net_1\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEA_8l30r_adt_net_55507_\);
    
    \I10.STATE1_ns_i_0_0_0_3l0r\ : NAND3FFT
      port map(A => \I10.STATE1L1R_14\, B => \I10.STATE1L11R_12\, 
        C => \I10.STATE1_ns_i_0_0_0_1l0r_net_1\, Y => 
        \I10.STATE1_ns_i_0_0_0_3_il0r\);
    
    \I2.PULSE_43_f0l3r\ : OA21TTF
      port map(A => PULSEl3r, B => \I2.REG_1_sqmuxa_3_net_1\, C
         => \I2.STATE1l6r_net_1\, Y => \I2.PULSE_43l3r\);
    
    \I2.VDBml1r\ : MUX2L
      port map(A => \I2.VDBil1r_net_1\, B => \I2.N_2042\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml1r_net_1\);
    
    \I1.REG_1_105_13\ : AND2FT
      port map(A => \I1.PULSE_I2C_net_1\, B => 
        \I1.REG_1_105_13_adt_net_12496_\, Y => 
        \I1.REG_1_105_13_net_1\);
    
    \I2.REG_1_417\ : MUX2H
      port map(A => VDB_inl28r, B => \I2.REGl502r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_417_net_1\);
    
    \I8.SWORDl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_2_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl1r_net_1\);
    
    \I2.REG_1_310\ : MUX2L
      port map(A => REGl395r, B => VDB_inl2r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_310_net_1\);
    
    \I2.VDBil17r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_593_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil17r_net_1\);
    
    \I2.un8_d32_0_a2\ : AND3FFT
      port map(A => \I2.LWORDS_net_1\, B => \I2.N_3055\, C => 
        \I2.VASl8r_net_1\, Y => \I2.un8_d32_0_a2_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_3_1l6r\ : NOR2
      port map(A => \I10.CNTl3r_net_1\, B => \I10.N_2298\, Y => 
        \I10.N_2377_1\);
    
    \I2.REG_1_171\ : MUX2L
      port map(A => REGl181r, B => VDB_inl12r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_171_net_1\);
    
    \I1.SCL\ : DFFS
      port map(CLK => CLKOUT, D => \I1.SCL_27_net_1\, SET => 
        HWRES_c_2_0, Q => \I1.SCL_net_1\);
    
    \I10.FID_8_IV_0_0_0_0L12R_194\ : AND2FT
      port map(A => \I10.N_2309_i_0_i\, B => \I10.STATE1L2R_13\, 
        Y => \I10.FID_8_iv_0_0_0_0_il12r_adt_net_23237_\);
    
    \I8.SWORD_5\ : MUX2H
      port map(A => \I8.SWORDl4r_net_1\, B => 
        \I8.SWORD_5l4r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_5_net_1\);
    
    \I2.REG_1_215\ : MUX2L
      port map(A => VDB_inl3r, B => REGl252r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_215_net_1\);
    
    \I10.BNCRES_CNT_4_I_52\ : AND2
      port map(A => \I10.BNCRES_CNTl2r_net_1\, B => 
        \I10.BNCRES_CNTl3r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_pog_array_1_0l0r\);
    
    \I10.BNCRES_CNTl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNCRES_CNT_4l7r\, CLR => 
        CLEAR_0_0, Q => \I10.BNCRES_CNTl7r_net_1\);
    
    \I2.REG_1_371\ : MUX2H
      port map(A => VDB_inl15r, B => \I2.REGl456r\, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_371_net_1\);
    
    \I2.REG_1l495r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_410_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl495r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I0_CO1\ : NAND2
      port map(A => \I10.N_2313_i_0\, B => REGl32r, Y => 
        \I10.N208\);
    
    \I2.VDBi_24l0r\ : OA21
      port map(A => \I2.REGMAPl7r_net_1\, B => \I2.N_1915\, C => 
        \I2.VDBi_24_sl0r_net_1\, Y => 
        \I2.VDBi_24l0r_adt_net_54799_\);
    
    \I10.EVENT_DWORD_18_RL26R_223\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl26r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l26r_adt_net_25448_\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l18r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl18r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l18r_adt_net_26566_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l18r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l19r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl19r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l19r_adt_net_26454_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l19r_net_1\);
    
    \I10.BNCRES_CNTl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNCRES_CNT_4l4r\, CLR => 
        CLEAR_0_0, Q => \I10.BNCRES_CNTl4r_net_1\);
    
    \I8.SWORD_16\ : MUX2H
      port map(A => \I8.SWORDl15r_net_1\, B => 
        \I8.SWORD_5l15r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_16_net_1\);
    
    \I2.REG_1_244\ : MUX2L
      port map(A => \I2.REGL281R_49\, B => VDB_inl16r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_244_net_1\);
    
    \I2.REG_1l199r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_189_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl199r);
    
    \I2.un122_reg_ads_0_a2_0_a2_1\ : OR2FT
      port map(A => \I2.LWORDS_net_1\, B => \I2.N_3154_i\, Y => 
        \I2.N_3013_1\);
    
    \I10.BNC_CNT_4_0_a2l3r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_13_0\, 
        Y => \I10.BNC_CNT_4l3r\);
    
    \I2.VDBi_67l15r\ : MUX2L
      port map(A => \I2.VDBi_61l15r_net_1\, B => \I2.N_1964\, S
         => \I2.N_1965\, Y => \I2.VDBi_67l15r_net_1\);
    
    SP_PDL_padl45r : IOB33PH
      port map(PAD => SP_PDL(45), A => REGl129r, EN => MD_PDL_c, 
        Y => SP_PDL_inl45r);
    
    \I1.START_I2C\ : DFFC
      port map(CLK => CLKOUT, D => \I1.START_I2C_26_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.START_I2C_net_1\);
    
    \I5.un6_fcs\ : OR2
      port map(A => \I5.DRIVE_RELOAD_net_1\, B => \I5.DRIVECS_20\, 
        Y => un6_fcs);
    
    \I2.VDBi_17_0l8r\ : AOI21
      port map(A => REGl8r, B => \I2.REGMAP_i_il1r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1905_adt_net_47814_\);
    
    SP_PDL_padl46r : IOB33PH
      port map(PAD => SP_PDL(46), A => REGl129r, EN => MD_PDL_c, 
        Y => SP_PDL_inl46r);
    
    \I10.EVENT_DWORD_18_rl1r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l1r_net_1\, B => 
        \I10.EVENT_DWORD_18l1r_adt_net_28575_\, Y => 
        \I10.EVENT_DWORD_18l1r\);
    
    VDB_padl8r : IOB33PH
      port map(PAD => VDB(8), A => \I2.VDBml8r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl8r);
    
    VAD_padl27r : OTB33PH
      port map(PAD => VAD(27), A => \I2.VADml27r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I2.TCNT3_2_I_32\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_1_0l0r\, B => 
        \I2.TCNT3_i_0_il2r_net_1\, Y => \I2.TCNT3_2l2r\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l27r\ : OAI21
      port map(A => I2C_RDATAl7r, B => \I10.N_2639\, C => 
        \I10.N_2642_0\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l27r_net_1\);
    
    \I2.STATE5l0r\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl4r\, CLR => 
        HWRES_c_2_0, Q => \I2.STATE5l0r_net_1\);
    
    \I1.SCL_1_IV_I_A2_137\ : OR3
      port map(A => \I1.sstatel10r_net_1\, B => 
        \I1.sstatel2r_net_1\, C => \I1.N_632\, Y => 
        \I1.N_661_adt_net_11089_\);
    
    \I2.VDBi_86_ivl0r\ : OR3
      port map(A => \I2.VDBi_86_iv_1_il0r\, B => 
        \I2.VDBi_86_iv_0_il0r\, C => \I2.VDBi_70_m_il0r\, Y => 
        \I2.VDBi_86l0r\);
    
    \I2.REG_1l502r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_417_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl502r\);
    
    \I2.PIPEA_8_RL9R_444\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l9r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l9r_adt_net_57007_\);
    
    \I1.AIR_COMMAND_44\ : MUX2L
      port map(A => \I1.AIR_COMMANDl12r_net_1\, B => 
        \I1.AIR_COMMAND_21l12r\, S => \I1.un1_tick_12_net_1\, Y
         => \I1.AIR_COMMAND_44_net_1\);
    
    \I2.VDBi_56l16r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l16r_net_1\, Y => \I2.VDBi_56l16r_net_1\);
    
    \I2.REG_1_420\ : MUX2H
      port map(A => VDB_inl31r, B => \I2.REGl505r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_420_net_1\);
    
    \I2.VDBi_24l31r\ : MUX2L
      port map(A => \I2.REGl505r\, B => \I2.VDBi_19l31r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l31r_net_1\);
    
    \I3.SBYTE_7\ : MUX2L
      port map(A => REGl141r, B => \I3.SBYTE_5l4r_net_1\, S => 
        \I3.N_167\, Y => \I3.SBYTE_7_0\);
    
    PSM_SP4_pad : IB33
      port map(PAD => PSM_SP4, Y => PSM_SP4_c);
    
    \I2.VDBi_585\ : MUX2L
      port map(A => \I2.VDBil9r_net_1\, B => \I2.VDBi_86l9r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_585_net_1\);
    
    \I2.VDBi_24l26r\ : MUX2L
      port map(A => \I2.REGl500r\, B => \I2.VDBi_19l26r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l26r_net_1\);
    
    \I2.PIPEAl24r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_568_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl24r_net_1\);
    
    \I10.REG_1l36r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I68_Y\, 
        CLR => CLEAR_0_0, Q => \I10.REGl36r\);
    
    \I10.EVENT_DWORD_18_RL4R_267\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl14r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l4r_adt_net_28239_\);
    
    \I2.un8_d32_0_a3\ : OR2
      port map(A => \I2.N_3018_2_i\, B => \I2.VASl15r_net_1\, Y
         => \I2.N_3055\);
    
    \I2.STATE5L2R_488\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_107\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L2R_73\);
    
    \I10.CRC32_3_i_0_0l28r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2320_i_i_0\, Y => \I10.N_1218\);
    
    \I10.un3_bnc_cnt_I_111\ : AND3
      port map(A => \I10.BNC_CNTl8r_net_1\, B => 
        \I10.DWACT_FINC_El5r_adt_net_18828_\, C => 
        \I10.DWACT_FINC_El28r_adt_net_18856_\, Y => 
        \I10.DWACT_FINC_El28r\);
    
    \I1.sstatese_5_0_0\ : MUX2H
      port map(A => \I1.sstatel7r_net_1\, B => 
        \I1.sstatel8r_net_1\, S => TICKl0r, Y => 
        \I1.sstate_ns_el6r\);
    
    \I10.CRC32_3_i_0_0l13r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2326_i_i_0\, Y => \I10.N_1356\);
    
    \I2.REG_1l423r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_338_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl423r);
    
    \I2.PIPEA_8_rl13r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl13r, C => 
        \I2.PIPEA_8l13r_adt_net_56727_\, Y => \I2.PIPEA_8l13r\);
    
    \I2.LB_i_7l15r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l15r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l15r_Rd1__net_1\);
    
    \I10.FID_165\ : MUX2L
      port map(A => \I10.FID_8l0r\, B => \I10.FIDl0r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_165_net_1\);
    
    \I2.PULSE_43_f0l1r\ : OA21TTF
      port map(A => PULSEl1r, B => \I2.REGMAP_i_il4r\, C => 
        \I2.STATE1l6r_net_1\, Y => \I2.PULSE_43l1r\);
    
    \I3.un16_ae_47_1\ : OR2FT
      port map(A => REGl122r, B => REGl126r, Y => 
        \I3.un16_ae_1l47r\);
    
    \I2.REG_1l131r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_133_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl131r);
    
    \I2.LB_i_489\ : MUX2L
      port map(A => \I2.LB_il11r_Rd1__net_1\, B => 
        \I2.LB_i_7l11r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__85\, Y => \I2.LB_il11r\);
    
    \I2.REG3_107\ : MUX2L
      port map(A => VDB_inl0r, B => \I2.REGl0r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_107_net_1\);
    
    \I2.VDBi_54_0_iv_0l9r\ : AO21
      port map(A => REGl258r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il9r_adt_net_47212_\, Y => 
        \I2.VDBi_54_0_iv_0_il9r\);
    
    \I2.REG_1_131\ : MUX2H
      port map(A => REGL129R_1, B => VDB_inl8r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_131_net_1\);
    
    \I2.un14_tcnt3_4\ : OR3
      port map(A => \I2.TCNT3_i_0_il0r_net_1\, B => 
        \I2.TCNT3l1r_net_1\, C => \I2.un14_tcnt3_2_i\, Y => 
        \I2.un14_tcnt3_4_i\);
    
    \I2.REG_1_ml164r\ : NAND2
      port map(A => REGl164r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml164r_net_1\);
    
    \I2.REG_1l427r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_342_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl427r);
    
    \I2.VDBi_67_0l7r\ : MUX2L
      port map(A => REGl432r, B => \I2.REGL448R_32\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1956\);
    
    \I2.REG_1_sqmuxa_3\ : AND2
      port map(A => TST_cl5r, B => \I2.STATE1l7r_net_1\, Y => 
        \I2.REG_1_sqmuxa_3_net_1\);
    
    LB_padl14r : IOB33PH
      port map(PAD => LB(14), A => \I2.LB_il14r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl14r);
    
    \I2.REG_1l503r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_418_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl503r\);
    
    \I2.REG3_116\ : MUX2L
      port map(A => VDB_inl9r, B => \I2.REGl9r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_116_net_1\);
    
    \I2.REGMAPl5r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un25_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl5r_net_1\);
    
    \I2.REG_1_331\ : MUX2L
      port map(A => REGl416r, B => VDB_inl23r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_331_net_1\);
    
    \I5.sstatel4r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.sstate_ns_il1r_net_1\, CLR
         => \I5.un2_hwres_2_net_1\, Q => \I5.sstate_i_0_il4r\);
    
    \I2.REG_1l290r_74\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_253_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL290R_58\);
    
    \I10.CRC32_115\ : MUX2H
      port map(A => \I10.CRC32l28r_net_1\, B => \I10.N_1218\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_115_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_0l0r\ : AND2
      port map(A => \I10.N_2294\, B => \I10.N_2406\, Y => 
        \I10.N_2359\);
    
    \I2.VDBI_54_0_IV_0L10R_366\ : AND2
      port map(A => REGl115r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.VDBi_54_0_iv_0_il10r_adt_net_46458_\);
    
    \I2.un113_reg_ads_0_a2_0_a2\ : NOR2
      port map(A => \I2.N_2875_1\, B => \I2.N_3064\, Y => 
        \I2.un113_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.OR_RADDRl5r\ : DFF
      port map(CLK => CLKOUT, D => \I10.OR_RADDR_223_net_1\, Q
         => \I10.OR_RADDRl5r_net_1\);
    
    \I2.LB_i_7l19r\ : AND2
      port map(A => VDB_inl19r, B => \I2.STATE5L2R_74\, Y => 
        \I2.LB_i_7l19r_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_0_a2_3l2r\ : NOR3
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2290\, C => 
        \I10.N_2298\, Y => \I10.N_3177_i\);
    
    \I2.VDBi_19l21r\ : AND2
      port map(A => TST_cl5r, B => REGl69r, Y => 
        \I2.VDBi_19l21r_net_1\);
    
    \I2.VDBil7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_583_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil7r_net_1\);
    
    \I2.STATE2_NSL0R_312\ : AND2FT
      port map(A => \I2.N_2821_0\, B => \I2.EVREAD_DS_net_1\, Y
         => \I2.STATE2_nsl0r_adt_net_38978_\);
    
    \I2.PIPEB_4_il4r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl4r, Y => \I2.N_2577\);
    
    \I2.REG_1_402\ : MUX2H
      port map(A => VDB_inl13r, B => \I2.REGl487r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_402_net_1\);
    
    \I1.DATAl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12l9r_net_1\, CLR => 
        HWRES_c_2_0, Q => REGl114r);
    
    \I10.STATE1_ns_i_0_0_0_1_0l0r\ : AND3FFT
      port map(A => \I10.STATE1l3r_net_1\, B => \I10.N_557_2\, C
         => \I10.N_557_1\, Y => 
        \I10.STATE1_ns_i_0_0_0_1l0r_net_1\);
    
    \I5.SBYTE_5l6r\ : MUX2L
      port map(A => REGl87r, B => FBOUTl5r, S => 
        \I5.sstatel5r_net_1\, Y => \I5.SBYTE_5l6r_net_1\);
    
    \I5.SBYTE_8\ : MUX2H
      port map(A => FBOUTl2r, B => \I5.SBYTE_5l2r_net_1\, S => 
        \I5.un1_sstate_12\, Y => \I5.SBYTE_8_net_1\);
    
    \I2.nLBRD_82\ : MUX2H
      port map(A => \NLBRD_c\, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, S => 
        \I2.N_2215\, Y => \I2.nLBRD_82_net_1\);
    
    \I2.VDBI_54_0_IV_2L1R_414\ : AND2
      port map(A => REGl186r, B => \I2.REGMAPl20r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2_il1r_adt_net_53747_\);
    
    ALICLK_pad : GL33
      port map(PAD => ALICLK, GL => ALICLK_c);
    
    \I2.VDBi_67_ml7r\ : OA21
      port map(A => \I2.VDBi_67l7r_adt_net_49083_\, B => 
        \I2.VDBi_67l7r_adt_net_49085_\, C => \I2.N_1705_i_0_1_0\, 
        Y => \I2.VDBi_67_m_il7r\);
    
    \I5.SBYTE_5l1r\ : MUX2L
      port map(A => REGl82r, B => FBOUTl0r, S => 
        \I5.sstatel5r_net_1\, Y => \I5.SBYTE_5l1r_net_1\);
    
    \I2.un40_reg_ads_0_a2_0_a2\ : NOR2
      port map(A => \I2.N_3067\, B => \I2.N_3003_1\, Y => 
        \I2.un40_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.un1_state1_1_i_o3\ : NOR2FT
      port map(A => \I2.CYCS_net_1\, B => \I2.CYCS1_net_1\, Y => 
        \I2.N_2848\);
    
    \I8.SWORDl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_16_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl15r_net_1\);
    
    \I2.un1_STATE5_9_0_a2_2_a2_133\ : NAND2
      port map(A => \I2.WRITES_net_1\, B => \I2.STATE5L2R_117\, Y
         => \I2.LB_NOE_1_SQMUXA_115\);
    
    \I2.PIPEA1l26r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_537_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l26r_net_1\);
    
    \I1.I2C_RDATA_19\ : MUX2L
      port map(A => I2C_RDATAl5r, B => \I1.N_584\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_19_net_1\);
    
    \I2.LB_i_7_rl4r\ : AND2FT
      port map(A => \I2.STATE5L4R_ADT_NET_116400_RD1__67\, B => 
        \I2.N_1891\, Y => \I2.LB_i_7l4r_net_1\);
    
    \I10.BNCRES_CNT_4_G_1_1_3\ : NAND3
      port map(A => \I10.G_1_1_0_net_1\, B => 
        \I10.BNCRES_CNTl1r_net_1\, C => 
        \I10.DWACT_ADD_CI_0_pog_array_1_0l0r\, Y => 
        \I10.G_1_1_3_i\);
    
    ASB_pad : GL33
      port map(PAD => ASB, GL => ASB_c);
    
    \I2.VDBil30r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_606_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil30r_net_1\);
    
    \I2.VASl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_93_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VAS_i_0_il11r\);
    
    \I2.PIPEA_556\ : MUX2L
      port map(A => \I2.PIPEAl12r_net_1\, B => \I2.PIPEA_8l12r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_556_net_1\);
    
    \I2.VDBi_86_iv_0l3r\ : AO21TTF
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.VDBi_82l3r_net_1\, C => \I2.VDBi_85_ml3r_net_1\, Y
         => \I2.VDBi_86_iv_0_il3r\);
    
    \I2.REG_1l419r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_334_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl419r);
    
    \I2.LB_i_509\ : MUX2L
      port map(A => \I2.LB_il31r_Rd1__net_1\, B => 
        \I2.LB_i_7l31r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__76\, Y => \I2.LB_il31r\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_0_1l6r\ : NOR2
      port map(A => \I10.CNTL2R_11\, B => \I10.N_2296\, Y => 
        \I10.N_2374_1\);
    
    \I2.REG_1_391\ : MUX2H
      port map(A => VDB_inl2r, B => \I2.REGl476r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_391_net_1\);
    
    \I2.LB_i_7l7r\ : MUX2L
      port map(A => VDB_inl7r, B => \I2.VASl7r_net_1\, S => 
        \I2.STATE5L1R_105\, Y => \I2.N_1894\);
    
    \I2.REG_1_451\ : MUX2H
      port map(A => VDB_inl30r, B => REGl78r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_451_net_1\);
    
    \I2.REG_1_174_e_0\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl19r_net_1\, Y => \I2.N_3143_i_0\);
    
    \I2.PULSE_1l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_1_100_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => PULSEl1r);
    
    \I10.un6_bnc_res_7\ : XOR2
      port map(A => \I10.BNC_CNTl7r_net_1\, B => REGl464r, Y => 
        \I10.un6_bnc_res_7_i_i\);
    
    \I10.BNC_CNTl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_213_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl15r_net_1\);
    
    \I2.PIPEA_8_SL28R_425\ : MUX2H
      port map(A => DPRl28r, B => \I2.PIPEA1l28r_net_1\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEA_8l28r_adt_net_55675_\);
    
    \I1.COMMAND_4l10r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl10r_net_1\, B => REGl99r, S
         => REGL7R_2, Y => \I1.COMMAND_4l10r_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l8r\ : OAI21FTF
      port map(A => \I10.STATE1l11r_net_1\, B => REGl56r, C => 
        \I10.FID_8_iv_0_0_0_0l8r_adt_net_23752_\, Y => 
        \I10.FID_8_iv_0_0_0_0l8r_net_1\);
    
    \I10.OR_RADDR_220\ : MUX2H
      port map(A => \I10.CNTL2R_11\, B => \I10.OR_RADDRl2r_net_1\, 
        S => \I10.N_2126\, Y => \I10.OR_RADDR_220_net_1\);
    
    \I2.LB_i_7l7r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l7r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l7r_Rd1__net_1\);
    
    \I2.PIPEB_4_il21r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl21r, Y => \I2.N_2611\);
    
    \I2.VDBi_85_ml4r\ : NAND3
      port map(A => \I2.VDBil4r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml4r_net_1\);
    
    \I2.N_3031_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3031\, SET => 
        HWRES_c_2_0, Q => \I2.N_3031_Rd1__net_1\);
    
    \I2.VDBi_86_iv_0l8r\ : AOI21TTF
      port map(A => \I2.VDBil8r_net_1\, B => \I2.STATE1l2r_net_1\, 
        C => \I2.VDBi_85_ml8r_net_1\, Y => 
        \I2.VDBi_86_iv_0l8r_net_1\);
    
    \I5.ISI_0_sqmuxa_0_a2\ : NAND3
      port map(A => \I5.BITCNTl0r_net_1\, B => 
        \I5.BITCNTl1r_net_1\, C => \I5.ISI_0_sqmuxa_0_a2_0_net_1\, 
        Y => \I5.ISI_0_sqmuxa\);
    
    \I2.LB_i_7l11r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l11r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l11r_Rd1__net_1\);
    
    NPWON_pad : IB33
      port map(PAD => NPWON, Y => NPWON_c);
    
    \I2.VASl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_90_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl8r_net_1\);
    
    \I2.VDBi_86_iv_1l4r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl4r\, C
         => \I2.VDBi_86_iv_1_il4r_adt_net_51564_\, Y => 
        \I2.VDBi_86_iv_1_il4r\);
    
    \I2.REG_1_406\ : MUX2H
      port map(A => VDB_inl17r, B => \I2.REGl491r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_406_net_1\);
    
    \I5.RELOAD_1_294\ : NOR3FTT
      port map(A => NCYC_RELOAD_c, B => \I5.sstatel5r_net_1\, C
         => \I5.sstatel0r_net_1\, Y => 
        \I5.RELOAD_1_adt_net_34760_\);
    
    \I2.PIPEA1_534\ : MUX2L
      port map(A => \I2.PIPEA1l23r_net_1\, B => \I2.N_2543\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_534_net_1\);
    
    \I1.DATAl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12l15r_net_1\, CLR
         => HWRES_c_2_0, Q => REGl120r);
    
    \I10.un1_OR_RREQ_1_sqmuxa_0_0_a2\ : NAND2
      port map(A => \I10.STATE1l3r_net_1\, B => \I10.N_2286\, Y
         => \I10.N_2354\);
    
    \I10.EVENT_DWORD_133\ : MUX2H
      port map(A => \I10.EVENT_DWORDl0r_net_1\, B => 
        \I10.EVENT_DWORD_18l0r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_133_net_1\);
    
    \I2.VDBi_19l15r\ : MUX2L
      port map(A => REGl63r, B => \I2.VDBi_17l15r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l15r_net_1\);
    
    \I2.PIPEA1l20r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_531_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l20r_net_1\);
    
    \I10.PDL_RADDRl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.PDL_RADDR_228_net_1\, CLR
         => CLEAR_0_0, Q => \I10.PDL_RADDRl4r_net_1\);
    
    \I2.PIPEA_547\ : MUX2L
      port map(A => \I2.PIPEAl3r_net_1\, B => \I2.PIPEA_8l3r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_547_net_1\);
    
    \I2.LB_i_479\ : MUX2L
      port map(A => \I2.LB_il1r_Rd1__net_1\, B => 
        \I2.LB_i_7l1r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__90\, Y => \I2.LB_il1r\);
    
    \I2.PIPEB_55\ : MUX2H
      port map(A => \I2.PIPEBl6r_net_1\, B => \I2.N_2581\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_55_net_1\);
    
    \I3.un16_ae_16_1\ : OR2
      port map(A => \I3.un16_ae_1l41r\, B => \I3.un16_ae_1l30r\, 
        Y => \I3.un16_ae_1l24r\);
    
    \I2.LB_s_4_i_a2_0_a2l9r\ : OR2
      port map(A => LB_inl9r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__70\, Y => \I2.N_3044\);
    
    \I2.REG_1l292r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_255_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl292r\);
    
    AE_PDL_padl11r : OB33PH
      port map(PAD => AE_PDL(11), A => AE_PDL_cl11r);
    
    \I2.un756_regmap_22\ : NOR3
      port map(A => \I2.un756_regmap_22_0_net_1\, B => 
        \I2.REGMAPl19r_net_1\, C => \I2.REGMAPl20r_net_1\, Y => 
        \I2.un756_regmap_22_net_1\);
    
    \I2.STATE1_ns_i_a3_1l9r\ : NOR2
      port map(A => \I2.REGMAPl35r_net_1\, B => 
        \I2.un756_regmap_net_1\, Y => \I2.N_1783\);
    
    \I2.REG_1l51r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_424_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl51r);
    
    \I2.PIPEB_4_i_a2l30r\ : OR2FT
      port map(A => \I2.N_2847_1\, B => DPRl30r, Y => \I2.N_2882\);
    
    \I2.PIPEA1_9_0_a2l31r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl31r, Y => 
        \I2.PIPEA1_9l31r\);
    
    \I2.un10_reg_ads_0_a3\ : NOR2FT
      port map(A => \I2.VASl2r_net_1\, B => \I2.N_3057\, Y => 
        \I2.N_3060\);
    
    \I10.STATE1_ns_0_0_a2_0l4r\ : NAND2
      port map(A => \I10.N_2395_1\, B => 
        \I10.READ_PDL_FLAG_net_1\, Y => \I10.N_2384\);
    
    \I10.FID_192\ : MUX2L
      port map(A => \I10.FID_8l27r\, B => \I10.FIDl27r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_192_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l14r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl14r_net_1\, B => 
        \I10.CRC32l14r_net_1\, Y => \I10.N_2327_i_i_0\);
    
    \I2.un3_asb_2\ : XOR2FT
      port map(A => VAD_inl30r, B => GA_cl2r, Y => 
        \I2.un3_asb_2_net_1\);
    
    \I2.PIPEAl29r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEA_573_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEA_i_0_il29r\);
    
    \I10.G_3\ : OR3
      port map(A => \I10.G_1_i\, B => \I10.un6_bnc_res_2_i_i\, C
         => \I10.un6_bnc_res_11_i_i\, Y => \I10.G_3_i\);
    
    LB_padl21r : IOB33PH
      port map(PAD => LB(21), A => \I2.LB_il21r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl21r);
    
    \I2.PULSE_43_F0L7R_454\ : AO21FTT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAP_i_0_il11r\, C => PULSEl7r, Y => 
        \I2.PULSE_43_f0l7r_adt_net_71087_\);
    
    L2A_pad : IB33
      port map(PAD => L2A, Y => L2A_c);
    
    \I2.PIPEA1_9_il20r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl20r, Y => \I2.N_2537\);
    
    \I1.DATAl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12l10r_net_1\, CLR
         => HWRES_c_2_0, Q => REGl115r);
    
    \I10.CRC32_3_i_0_0_x3l18r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl18r_net_1\, B => 
        \I10.CRC32l18r_net_1\, Y => \I10.N_2334_i_i_0\);
    
    \I2.PIPEB_75\ : MUX2H
      port map(A => \I2.PIPEBl26r_net_1\, B => \I2.N_2621\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_75_net_1\);
    
    \I2.LB_i_7l29r\ : AND2
      port map(A => VDB_inl29r, B => \I2.STATE5L2R_72\, Y => 
        \I2.LB_i_7l29r_net_1\);
    
    \I10.G_1_0_0\ : NAND2
      port map(A => \I10.N_2285\, B => \I10.N_2647\, Y => 
        \I10.G_1_0_0_net_1\);
    
    \I2.VDBm_0l0r\ : MUX2L
      port map(A => \I2.PIPEAl0r_net_1\, B => \I2.PIPEBl0r_net_1\, 
        S => \I2.BLTCYC_17\, Y => \I2.N_2041\);
    
    \I2.REG_1_470\ : MUX2H
      port map(A => VDB_inl8r, B => REGl97r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_470_net_1\);
    
    AE_PDL_padl45r : OB33PH
      port map(PAD => AE_PDL(45), A => AE_PDL_cl45r);
    
    \I2.VDBi_67_0l12r\ : MUX2L
      port map(A => \I2.REGl437r\, B => \I2.REGl453r\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1961\);
    
    \I2.VDBi_67_ml4r\ : OA21
      port map(A => \I2.VDBi_67l4r_adt_net_51520_\, B => 
        \I2.VDBi_67l4r_adt_net_51522_\, C => \I2.N_1705_i_0_1_0\, 
        Y => \I2.VDBi_67_m_il4r\);
    
    \I2.un1_TCNT_1_I_11\ : XOR2
      port map(A => \I2.N_1885_1\, B => \I2.TCNTl2r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_pog_array_0_1l0r\);
    
    \I2.VDBi_54_0_iv_1l11r\ : AO21
      port map(A => REGl196r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il11r_adt_net_45746_\, Y => 
        \I2.VDBi_54_0_iv_1_il11r\);
    
    \I2.PIPEB_4_il25r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl25r, Y => \I2.N_2619\);
    
    \I2.PIPEA_8_RL4R_449\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l4r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l4r_adt_net_57394_\);
    
    \I2.LB_i_7l8r\ : AND2
      port map(A => VDB_inl8r, B => \I2.STATE5l2r_net_1\, Y => 
        \I2.LB_i_7l8r_net_1\);
    
    \I2.LB_s_31\ : MUX2L
      port map(A => \I2.LB_sl17r_Rd1__net_1\, B => 
        \I2.N_3026_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116352_Rd1__net_1\, Y => 
        \I2.LB_sl17r\);
    
    \I1.SDAnoe_m_1\ : AND3FTT
      port map(A => \I1.sstatel9r_net_1\, B => \I1.N_516\, C => 
        \I1.SDAnoe_net_1\, Y => \I1.SDAnoe_m_1_net_1\);
    
    \I1.SDAout_36\ : MUX2H
      port map(A => \I1.SDAout_net_1\, B => \I1.SDAout_11\, S => 
        TICKl0r, Y => \I1.SDAout_36_net_1\);
    
    \I2.un7_cycs_i_a2\ : NOR2
      port map(A => \I2.CYCS_net_1\, B => TST_cl0r, Y => 
        \I2.N_2866\);
    
    \I2.PIPEA_8_RL21R_432\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l21r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l21r_adt_net_56167_\);
    
    SYNC_padl8r : OB33PH
      port map(PAD => SYNC(8), A => SYNC_cl8r);
    
    \I2.un1_STATE5_11_0_0_o2\ : OR2
      port map(A => \I2.STATE5L4R_ADT_NET_116400_RD1__66\, B => 
        \I2.STATE5L1R_104\, Y => \I2.N_2271\);
    
    \I3.un16_ae_23\ : NOR2
      port map(A => \I3.un16_ae_3l31r\, B => \I3.un16_ae_1l23r\, 
        Y => \I3.un16_ael23r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I19_Y\ : OAI21FTF
      port map(A => \I10.REGl42r\, B => REG_i_0l43r, C => 
        \I10.N_2519_1\, Y => \I10.N258\);
    
    \I8.SWORDl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_14_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl13r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l0r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl0r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l0r_adt_net_28657_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l0r_net_1\);
    
    \I10.STATE1_ns_0_0l6r\ : AO21FTT
      port map(A => I2C_RVALID, B => \I10.STATE1l6r_net_1\, C => 
        \I10.N_2356\, Y => \I10.STATE1_nsl6r\);
    
    \I3.un1_sstate_2_i\ : OR2
      port map(A => \I3.N_184_i\, B => \I3.N_165_adt_net_80145_\, 
        Y => \I3.N_165\);
    
    \I2.REG_1l187r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_177_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl187r);
    
    \I2.PIPEAl25r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_569_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl25r_net_1\);
    
    \I3.un4_so_23_0\ : MUX2L
      port map(A => \I3.N_250\, B => \I3.N_249\, S => REGL123R_6, 
        Y => \I3.N_251\);
    
    \I10.BNC_CNTl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_212_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNT_i_il14r\);
    
    \I10.READ_ADC_FLAG_84_0_0_0_286\ : AND3FTT
      port map(A => \I10.STATE1l8r_net_1\, B => 
        \I10.READ_ADC_FLAG_net_1\, C => \I10.N_2380_1\, Y => 
        \I10.READ_ADC_FLAG_84_0_0_0_adt_net_32677_\);
    
    LBSP_padl15r : IOB33PH
      port map(PAD => LBSP(15), A => REGl408r, EN => REG_i_0l280r, 
        Y => LBSP_inl15r);
    
    \I10.un2_i2c_chain_0_0_0_0_x3l3r\ : XOR2FT
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTL2R_11\, Y
         => \I10.N_2346_i_i_0\);
    
    \I2.REG_1l258r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_221_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl258r);
    
    \I10.FID_4_0_a2l4r\ : XOR2FT
      port map(A => \I10.CRC32l0r_net_1\, B => 
        \I10.FID_4_0_a2_0l4r_net_1\, Y => \I10.FID_4_il4r\);
    
    \I2.REG_il276r\ : INV
      port map(A => \I2.REGl276r\, Y => REG_i_0l276r);
    
    \I2.REG_1l100r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_473_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl100r);
    
    \I2.VDBm_0l18r\ : MUX2L
      port map(A => \I2.PIPEAl18r_net_1\, B => 
        \I2.PIPEBl18r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2059\);
    
    \I2.REG_1_246\ : MUX2L
      port map(A => \I2.REGL283R_51\, B => VDB_inl18r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_246_net_1\);
    
    \I2.LB_i_7l27r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l27r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l27r_Rd1__net_1\);
    
    \I10.I2C_CHAIN_122\ : MUX2L
      port map(A => I2C_CHAIN, B => \I10.N_245\, S => 
        \I10.N_1595\, Y => \I10.I2C_CHAIN_122_net_1\);
    
    \I10.FID_4_0_a2_0l8r\ : XOR2
      port map(A => \I10.CRC32l16r_net_1\, B => 
        \I10.CRC32l28r_net_1\, Y => \I10.FID_4_0_a2_0l8r_net_1\);
    
    \I5.SSTATE_0_SQMUXA_1_0_A2_288\ : OR3FTT
      port map(A => \I5.RESCNTl2r_net_1\, B => 
        \I5.G_1_3_3_i_adt_net_33073_\, C => 
        \I5.sstate_0_sqmuxa_1_0_a2_12_i\, Y => 
        \I5.sstate_nsl5r_adt_net_33314_\);
    
    \I2.REG_1l195r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_185_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl195r);
    
    \I2.VDBi_86_0_iv_0l16r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l16r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il16r_adt_net_42291_\, Y => 
        \I2.VDBi_86_0_iv_0_il16r\);
    
    \I2.VDBi_54_0_ivl0r\ : OA21
      port map(A => \I2.VDBi_24l0r_adt_net_54799_\, B => 
        \I2.VDBi_24l0r_adt_net_54801_\, C => 
        \I2.VDBi_9_sqmuxa_0_net_1\, Y => 
        \I2.VDBi_54l0r_adt_net_55073_\);
    
    \I10.FID_8_IV_0_0_0_1L26R_166\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl74r, Y => 
        \I10.FID_8_iv_0_0_0_1_il26r_adt_net_21109_\);
    
    \I8.SWORD_5l12r\ : MUX2L
      port map(A => REGl261r, B => \I8.SWORDl11r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l12r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l2r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl2r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l2r_adt_net_28433_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l2r_net_1\);
    
    \I5.sstate_0_sqmuxa_1_0_a2_11\ : AND3
      port map(A => \I5.RESCNTl12r_net_1\, B => 
        \I5.RESCNTl11r_net_1\, C => 
        \I5.sstate_0_sqmuxa_1_0_a2_1_net_1\, Y => 
        \I5.sstate_0_sqmuxa_1_0_a2_11_net_1\);
    
    \I2.VDBml28r\ : MUX2L
      port map(A => \I2.VDBil28r_net_1\, B => \I2.N_2069\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml28r_net_1\);
    
    \I2.VDBi_61l2r\ : MUX2L
      port map(A => \I2.VDBi_54l2r\, B => \I2.VDBi_61_dl2r_net_1\, 
        S => \I2.VDBi_61_sl2r_net_1\, Y => \I2.VDBi_61l2r_net_1\);
    
    \I2.un1_STATE5_9_0_1_0_107\ : NAND3FFT
      port map(A => \I2.UN1_STATE5_9_0_1_I_93\, B => \I2.N_2383\, 
        C => \I2.LB_NOE_1_SQMUXA_115\, Y => 
        \I2.UN1_STATE5_9_1_91\);
    
    \I5.RESCNT_6_rl3r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_54\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l3r\);
    
    \I5.ISI_5_iv\ : AO21FTT
      port map(A => \I5.N_212\, B => REGl88r, C => 
        \I5.ISI_5_adt_net_33880_\, Y => \I5.ISI_5\);
    
    \I3.un16_ae_42\ : NOR2
      port map(A => \I3.un16_ae_3l47r\, B => \I3.un16_ae_1l42r\, 
        Y => \I3.un16_ael42r\);
    
    \I2.VDBm_0l26r\ : MUX2L
      port map(A => \I2.PIPEAl26r_net_1\, B => 
        \I2.PIPEBl26r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2067\);
    
    \I2.REG_1l402r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_317_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl402r);
    
    \I5.sstate_0_sqmuxa_1_0_a2_12\ : NAND3
      port map(A => \I5.RESCNTl15r_net_1\, B => 
        \I5.sstatel1r_net_1\, C => 
        \I5.sstate_0_sqmuxa_1_0_a2_11_net_1\, Y => 
        \I5.sstate_0_sqmuxa_1_0_a2_12_i\);
    
    \I2.PIPEBl20r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_69_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl20r_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l24r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl24r_net_1\, B => 
        \I10.CRC32l24r_net_1\, Y => \I10.N_2337_i_i_0\);
    
    \I10.FID_8_IV_0_0_0_0L17R_185\ : AND2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.CYC_STAT_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il17r_adt_net_22627_\);
    
    \I2.LB_il20r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il20r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il20r_Rd1__net_1\);
    
    \I2.un1_tcnt1_I_20\ : XOR2
      port map(A => \I2.TCNT1_i_0_il4r_net_1\, B => \I2.N_7\, Y
         => \I2.I_20_1\);
    
    \I10.CRC32_3_i_0_0_x3l28r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl28r_net_1\, B => 
        \I10.CRC32l28r_net_1\, Y => \I10.N_2320_i_i_0\);
    
    \I10.CRC32_3_i_0_0l7r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2332_i_i_0\, Y => \I10.N_1460\);
    
    \I10.STATE1_ns_a9_0_a2_0_a2_0_a2l3r\ : NOR3FTT
      port map(A => \I10.STATE1l12r_net_1\, B => REGl5r, C => 
        \I10.STATE1_ns_1l3r\, Y => \I10.STATE1_nsl3r\);
    
    \I1.sstatese_7_0_a3_2\ : NOR2FT
      port map(A => \I1.COMMANDl0r_net_1\, B => \I1.N_544\, Y => 
        \I1.N_467\);
    
    \I2.SINGCYC\ : DFFC
      port map(CLK => CLKOUT, D => \I2.SINGCYC_140_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.SINGCYC_net_1\);
    
    \I1.I2C_RDATA_9_il0r\ : MUX2H
      port map(A => REGl119r, B => I2C_RDATAl0r, S => \I1.N_631\, 
        Y => \I1.N_574\);
    
    VDB_padl2r : IOB33PH
      port map(PAD => VDB(2), A => \I2.VDBml2r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl2r);
    
    SYNC_padl11r : OB33PH
      port map(PAD => SYNC(11), A => REG_cl244r);
    
    \I2.PIPEA_544\ : MUX2L
      port map(A => \I2.PIPEAl0r_net_1\, B => \I2.PIPEA_8l0r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_544_net_1\);
    
    \I10.FID_8_IV_0_0_0_0L26R_167\ : AND2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.BNC_NUMBERl7r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il26r_adt_net_21151_\);
    
    \I10.EVENT_DWORD_18_rl23r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l23r_net_1\, B => 
        \I10.EVENT_DWORD_18l23r_adt_net_25910_\, Y => 
        \I10.EVENT_DWORD_18l23r\);
    
    \I2.VDBi_19l30r\ : AND2
      port map(A => TST_cl5r, B => REGl78r, Y => 
        \I2.VDBi_19l30r_net_1\);
    
    \I2.LB_i_7l3r\ : MUX2L
      port map(A => VDB_inl3r, B => \I2.VASl3r_net_1\, S => 
        \I2.STATE5l2r_adt_net_116440_Rd1__net_1\, Y => 
        \I2.N_1890\);
    
    \I10.G_1\ : AND2
      port map(A => BNC_RES, B => \I10.un6_bnc_res_NE_0_net_1\, Y
         => \I10.BNC_NUMBER_1_sqmuxa\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I23_Y\ : AO21FTT
      port map(A => REG_i_0l38r, B => \I10.REGl39r\, C => 
        \I10.N_2519_1\, Y => \I10.N262\);
    
    LBSP_padl25r : IOB33PH
      port map(PAD => LBSP(25), A => REGl418r, EN => REG_i_0l290r, 
        Y => LBSP_inl25r);
    
    \I8.SWORD_9\ : MUX2H
      port map(A => \I8.SWORDl8r_net_1\, B => 
        \I8.SWORD_5l8r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_9_net_1\);
    
    VDB_padl20r : IOB33PH
      port map(PAD => VDB(20), A => \I2.VDBml20r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl20r);
    
    \I10.FID_4_0_a2l10r\ : XOR2FT
      port map(A => \I10.CRC32l6r_net_1\, B => 
        \I10.FID_4_0_a2_0l10r_net_1\, Y => \I10.FID_4_il10r\);
    
    \I2.PIPEA_8_RL6R_447\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l6r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l6r_adt_net_57254_\);
    
    \I1.SBYTE_29\ : MUX2H
      port map(A => \I1.SBYTEl1r_net_1\, B => \I1.N_598\, S => 
        \I1.un1_tick_8\, Y => \I1.SBYTE_29_net_1\);
    
    \I10.STATE1_0l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl10r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l2r_net_1\);
    
    \I2.un98_reg_ads_0_a2_0_a2\ : AND2
      port map(A => \I2.N_3013_3\, B => \I2.N_3008_1\, Y => 
        \I2.un98_reg_ads_0_a2_0_a2_net_1\);
    
    \I3.un16_ae_44\ : NOR2
      port map(A => \I3.un16_ae_3l47r\, B => \I3.un16_ae_1l44r\, 
        Y => \I3.un16_ael44r\);
    
    \I1.SBYTE_34\ : MUX2H
      port map(A => \I1.SBYTEl6r_net_1\, B => \I1.N_608\, S => 
        \I1.un1_tick_8\, Y => \I1.SBYTE_34_net_1\);
    
    \I2.REG_1l430r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_345_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl430r);
    
    \I1.CHAIN_SELECT_4_iv\ : OR2
      port map(A => \I1.AIR_CHAIN_m_0_i\, B => 
        \I1.CHAIN_SELECT_4_adt_net_11533_\, Y => 
        \I1.CHAIN_SELECT_4\);
    
    \I2.VDBi_17l2r\ : AND2
      port map(A => LOS_c, B => \I2.REGMAPl2r_net_1\, Y => 
        \I2.N_1917_adt_net_52812_\);
    
    \I2.REG_1_430\ : MUX2H
      port map(A => VDB_inl9r, B => REGl57r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_430_net_1\);
    
    \I5.un1_RESCNT_I_64\ : XOR2
      port map(A => \I5.RESCNTl1r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_TMPl0r\, Y => \I5.I_64\);
    
    \I5.DRIVECS_2\ : OA21TTF
      port map(A => REGl80r, B => \I5.DRIVECS_20\, C => PULSEl10r, 
        Y => \I5.DRIVECS_2_net_1\);
    
    VDB_padl3r : IOB33PH
      port map(PAD => VDB(3), A => \I2.VDBml3r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl3r);
    
    \I2.REG_1l406r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_321_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl406r);
    
    \I2.REG_1l77r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_450_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl77r);
    
    \I2.REG_1l122r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_124_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl122r);
    
    \I10.un2_evread_3_i_0_a2_0_11\ : NAND3FTT
      port map(A => REGl45r, B => REG_i_0l44r, C => 
        \I10.un2_evread_3_i_0_a2_0_2_net_1\, Y => 
        \I10.un2_evread_3_i_0_a2_0_11_i\);
    
    \I1.sstatese_8_0\ : MUX2H
      port map(A => \I1.sstatel4r_net_1\, B => 
        \I1.sstatel5r_net_1\, S => TICKl0r, Y => 
        \I1.sstate_ns_el9r\);
    
    \I2.TCNT3_i_0_il6r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT3_2l6r\, Q => 
        \I2.TCNT3_i_0_il6r_net_1\);
    
    AE_PDL_padl42r : OB33PH
      port map(PAD => AE_PDL(42), A => AE_PDL_cl42r);
    
    \I10.FIDl17r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_182_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl17r_net_1\);
    
    \I2.REG_1l440r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_355_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl440r\);
    
    \I2.TCNT3_2_I_27\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_11_0l0r\, B => 
        \I2.TCNT3_i_0_il6r_net_1\, Y => \I2.TCNT3_2l6r\);
    
    \I10.FIDl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_173_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl8r_net_1\);
    
    \I2.VDBi_54_0_iv_3l13r\ : AO21TTF
      port map(A => REG_cl134r, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l13r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il13r\);
    
    \I2.REG_1l287r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_250_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl287r\);
    
    \I2.PIPEA_8_rl1r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl1r, C => 
        \I2.PIPEA_8l1r_adt_net_57604_\, Y => \I2.PIPEA_8l1r\);
    
    \I2.N_3043_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3043\, SET => 
        HWRES_c_2_0, Q => \I2.N_3043_Rd1__net_1\);
    
    \I10.FID_169\ : MUX2L
      port map(A => \I10.FID_8l4r\, B => \I10.FIDl4r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_169_net_1\);
    
    \I1.AIR_COMMANDl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_37_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl0r_net_1\);
    
    AE_PDL_padl44r : OB33PH
      port map(PAD => AE_PDL(44), A => AE_PDL_cl44r);
    
    \I2.VDBi_86_ivl7r\ : OR3
      port map(A => \I2.VDBi_86_iv_1_il7r\, B => 
        \I2.VDBi_86_iv_0_il7r\, C => \I2.VDBi_67_m_il7r\, Y => 
        \I2.VDBi_86l7r\);
    
    \I2.STATE5L2R_490\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_107\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L2R_75\);
    
    \I2.REG_il266r\ : INV
      port map(A => \I2.REGl266r\, Y => REG_i_0l266r);
    
    \I10.BNC_CNTl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_198_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl0r_net_1\);
    
    \I2.UN1_STATE5_9_1_RD1__504\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.un1_STATE5_9_1\, CLR => 
        HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__89\);
    
    \I2.REG_1l153r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_143_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl153r);
    
    \I10.CRC32_3_i_0_0_x3l31r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl31r_net_1\, B => 
        \I10.CRC32l31r_net_1\, Y => \I10.N_2330_i_i_0\);
    
    \I10.EVENT_DWORD_143\ : MUX2H
      port map(A => \I10.EVENT_DWORDl10r_net_1\, B => 
        \I10.EVENT_DWORD_18l10r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_143_net_1\);
    
    \I2.un116_reg_ads_0_a2_1\ : OR2
      port map(A => \I2.N_3013_1\, B => \I2.N_3012_1\, Y => 
        \I2.N_2875_1\);
    
    \I2.STATE5_ns_i_i_a2l0r\ : OR2FT
      port map(A => TST_cl2r, B => 
        \I2.STATE5L3R_ADT_NET_116444_RD1__109\, Y => 
        \I2.N_2385_adt_net_38045_\);
    
    \I10.UN3_BNC_CNT_I_34_153\ : AND2
      port map(A => \I10.BNC_CNTl3r_net_1\, B => 
        \I10.BNC_CNTl4r_net_1\, Y => 
        \I10.DWACT_FINC_El2r_adt_net_18800_\);
    
    \I2.VDBi_54_0_iv_1l4r\ : AO21
      port map(A => REGl189r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il4r_adt_net_51363_\, Y => 
        \I2.VDBi_54_0_iv_1_il4r\);
    
    \I2.VADml19r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl19r_net_1\, Y
         => \I2.VADml19r_net_1\);
    
    SP_PDL_padl28r : IOB33PH
      port map(PAD => SP_PDL(28), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl28r);
    
    \I2.TCNT3_2_I_34\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_12_2_0l0r\, B => 
        \I2.TCNT3l7r_net_1\, Y => \I2.TCNT3_2l7r\);
    
    \I2.REG_1_367\ : MUX2H
      port map(A => VDB_inl11r, B => \I2.REGl452r\, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_367_net_1\);
    
    \I5.LOAD_RESi\ : DFFC
      port map(CLK => CLKOUT, D => \I5.LOAD_RESi_5_net_1\, CLR
         => \I5.un2_hwres_2_net_1\, Q => LOAD_RES);
    
    \I2.REG_1_380\ : MUX2H
      port map(A => VDB_inl8r, B => REGl465r, S => \I2.N_3559_i\, 
        Y => \I2.REG_1_380_net_1\);
    
    \I3.un16_ae_39_1\ : NAND2FT
      port map(A => REGl125r, B => REGl127r, Y => 
        \I3.un16_ae_1l39r\);
    
    \I2.REG_1_453_e\ : AND3
      port map(A => \I2.STATE1l7r_net_1\, B => \I2.N_1730_0\, C
         => \I2.REGMAP_i_0_il9r\, Y => \I2.N_3691_i\);
    
    \I2.REG_1l289r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_252_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl289r\);
    
    \I2.PIPEAl27r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_571_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl27r_net_1\);
    
    VAD_padl22r : OTB33PH
      port map(PAD => VAD(22), A => \I2.VADml22r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I2.un87_reg_ads_0_a2_0_a2\ : AND3FFT
      port map(A => \I2.N_3065\, B => \I2.N_3005_1\, C => 
        \I2.N_3060\, Y => \I2.un87_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I27_Y\ : AO21
      port map(A => REGl34r, B => \I10.REGl35r\, C => 
        \I10.N_2519_1\, Y => \I10.N266\);
    
    \I2.VDBi_24_dl0r\ : MUX2L
      port map(A => \I2.REGl474r\, B => \I2.VDBi_22_dl0r_net_1\, 
        S => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24_dl0r_net_1\);
    
    \I2.un98_reg_ads_0_a2_0_a2_1\ : NOR2
      port map(A => \I2.WRITES_net_1\, B => \I2.N_3065\, Y => 
        \I2.N_3008_1\);
    
    \I2.REG_1l278r_62\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_241_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL278R_46\);
    
    \I2.VADml23r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl23r_net_1\, Y
         => \I2.VADml23r_net_1\);
    
    \I2.REG_1_448\ : MUX2H
      port map(A => VDB_inl27r, B => REGl75r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_448_net_1\);
    
    \I1.SCL_1_iv_i_o2\ : OA21
      port map(A => \I1.sstatel13r_net_1\, B => 
        \I1.SCL_1_iv_i_a3_1_net_1\, C => \I1.SCL_net_1\, Y => 
        \I1.N_634\);
    
    \I2.PIPEA_569\ : MUX2L
      port map(A => \I2.PIPEAl25r_net_1\, B => \I2.PIPEA_8l25r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_569_net_1\);
    
    SP_PDL_padl27r : IOB33PH
      port map(PAD => SP_PDL(27), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl27r);
    
    \I2.VDBI_86_0_IV_0L25R_325\ : AND2
      port map(A => \I2.VDBil25r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il25r_adt_net_40418_\);
    
    \I10.EVENT_DWORD_18_RL13R_249\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl23r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l13r_adt_net_27156_\);
    
    \I2.LB_i_501\ : MUX2L
      port map(A => \I2.LB_il23r_Rd1__net_1\, B => 
        \I2.LB_i_7l23r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__79\, Y => \I2.LB_il23r\);
    
    \I2.VDBi_24l2r\ : MUX2L
      port map(A => \I2.VDBi_24_dl2r_net_1\, B => 
        \I2.VDBi_17l2r_net_1\, S => \I2.VDBi_24_sl1r_net_1\, Y
         => \I2.VDBi_24l2r_net_1\);
    
    \I10.FID_175\ : MUX2L
      port map(A => \I10.FID_8l10r\, B => \I10.FIDl10r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_175_net_1\);
    
    LB_padl11r : IOB33PH
      port map(PAD => LB(11), A => \I2.LB_il11r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl11r);
    
    \I10.un1_STATE1_7_0_a9_0_a2_0_a2_0_a2\ : NOR3
      port map(A => \I10.N_2288\, B => \I10.STATE1L11R_12\, C => 
        \I10.STATE1L1R_14\, Y => \I10.N_2627\);
    
    \I2.UN1_STATE5_9_1_RD1__492\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_91\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__77\);
    
    \I10.EVENT_DWORDl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_139_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl6r_net_1\);
    
    \I2.un1_TCNT_1_I_12\ : XOR2
      port map(A => \I2.N_1885_1\, B => \I2.TCNT_i_il3r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_pog_array_0_2l0r\);
    
    \I2.REG_1_423\ : MUX2H
      port map(A => VDB_inl2r, B => REGl50r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_423_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I53_un1_Y\ : AND2
      port map(A => \I10.N292_adt_net_15372_\, B => \I10.N274\, Y
         => \I10.I53_un1_Y\);
    
    \I2.un10_reg_ads_0_a2\ : NOR2
      port map(A => \I2.N_3061\, B => \I2.N_2995_1\, Y => 
        \I2.un10_reg_ads_0_a2_net_1\);
    
    \I2.PIPEB_59\ : MUX2H
      port map(A => \I2.PIPEBl10r_net_1\, B => \I2.N_2589\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_59_net_1\);
    
    \I8.ISI_5_iv\ : AO21FTT
      port map(A => \I8.SWORD_0_sqmuxa\, B => REGl264r, C => 
        \I8.ISI_5_adt_net_5506_\, Y => \I8.ISI_5\);
    
    \I2.PIPEA1_9_il14r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl14r, Y => \I2.N_2525\);
    
    \I3.un1_sstate_4_i\ : OAI21FTF
      port map(A => \I3.un4_pulse_net_1\, B => 
        \I3.sstatel0r_net_1\, C => \I3.sstatel1r_net_1\, Y => 
        \I3.N_167\);
    
    \I2.PIPEA_8_rl12r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl12r, C => 
        \I2.PIPEA_8l12r_adt_net_56797_\, Y => \I2.PIPEA_8l12r\);
    
    \I2.PIPEB_4_il9r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl9r, Y => \I2.N_2587\);
    
    \I1.SBYTE_9_il5r\ : MUX2H
      port map(A => \I1.SBYTEl4r_net_1\, B => 
        \I1.COMMANDl13r_net_1\, S => \I1.N_625_0\, Y => 
        \I1.N_606\);
    
    \I2.REG_1_ml155r\ : NAND2
      port map(A => REGl155r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml155r_net_1\);
    
    \I2.REG_1_427\ : MUX2H
      port map(A => VDB_inl6r, B => REGl54r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_427_net_1\);
    
    \I10.UN2_I2C_CHAIN_0_0_0_0_0L1R_280\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_pog_array_1l0r\, B => 
        \I10.CNTl5r_net_1\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_0_il1r_adt_net_29771_\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l28r\ : OAI21
      port map(A => I2C_RDATAl8r, B => \I10.N_2639\, C => 
        \I10.N_2642_0\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l28r_net_1\);
    
    \I2.VDBi_600\ : MUX2L
      port map(A => \I2.VDBil24r_net_1\, B => \I2.VDBi_86l24r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_600_net_1\);
    
    \I2.REG_1_320\ : MUX2L
      port map(A => REGl405r, B => VDB_inl12r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_320_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l29r\ : OAI21
      port map(A => I2C_RDATAl9r, B => \I10.N_2639\, C => 
        \I10.N_2642_0\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l29r_net_1\);
    
    AE_PDL_padl26r : OB33PH
      port map(PAD => AE_PDL(26), A => AE_PDL_cl26r);
    
    \I2.REG_92_0l85r\ : MUX2H
      port map(A => VDB_inl4r, B => REGl85r, S => 
        \I2.REG_1_sqmuxa_1\, Y => \I2.N_1988\);
    
    \I2.LB_i_480\ : MUX2L
      port map(A => \I2.LB_il2r_Rd1__net_1\, B => 
        \I2.LB_i_7l2r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__90\, Y => \I2.LB_il2r\);
    
    \I10.CNT_10_i_0l2r\ : AND2
      port map(A => \I10.N_2287\, B => \I10.I_22\, Y => 
        \I10.CNT_10_i_0l2r_net_1\);
    
    \I2.VDBi_54_0_iv_1l7r\ : AO21
      port map(A => REGl192r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il7r_adt_net_48926_\, Y => 
        \I2.VDBi_54_0_iv_1_il7r\);
    
    \I3.un4_so_36_0\ : MUX2L
      port map(A => SP_PDL_inl19r, B => SP_PDL_inl17r, S => 
        REGl123r, Y => \I3.N_232\);
    
    \I2.REG_1_363\ : MUX2L
      port map(A => \I2.REGL448R_32\, B => VDB_inl7r, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_363_net_1\);
    
    \I10.un3_bnc_cnt_I_34\ : AND2
      port map(A => \I10.BNC_CNTl5r_net_1\, B => 
        \I10.DWACT_FINC_El2r_adt_net_18800_\, Y => 
        \I10.DWACT_FINC_El2r\);
    
    \I10.FID_8_IV_0_0_0_0L18R_183\ : AND2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.FAULT_STAT_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il18r_adt_net_22463_\);
    
    \I2.VDBi_86_0_iv_0l30r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l30r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il30r_adt_net_39393_\, Y => 
        \I2.VDBi_86_0_iv_0_il30r\);
    
    \I2.REG3_117\ : MUX2L
      port map(A => VDB_inl10r, B => \I2.REGl10r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_117_net_1\);
    
    \I10.BNC_NUMBERl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_234_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl4r_net_1\);
    
    \I5.ISI_5_IV_293\ : AND2
      port map(A => \I5.sstatel2r_net_1\, B => FBOUTl7r, Y => 
        \I5.ISI_5_adt_net_33880_\);
    
    \I2.VDBi_54_0_iv_3l0r\ : AOI21TTF
      port map(A => REGl153r, B => \I2.REGMAPl18r_net_1\, C => 
        \I2.VDBi_54_0_iv_0l0r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3l0r_net_1\);
    
    \I2.PIPEB_79\ : MUX2H
      port map(A => \I2.PIPEBl30r_net_1\, B => \I2.N_2882\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_79_net_1\);
    
    TST_padl8r : OB33PH
      port map(PAD => TST(8), A => \GND\);
    
    \I3.un16_ae_29\ : NOR2
      port map(A => \I3.un16_ae_2l31r\, B => \I3.un16_ae_1l29r\, 
        Y => \I3.un16_ael29r\);
    
    \I2.VDBi_17_rl10r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1907_adt_net_46222_\, C => 
        \I2.N_1907_adt_net_46224_\, Y => \I2.VDBi_17l10r\);
    
    \I2.REG_1_225\ : MUX2L
      port map(A => VDB_inl13r, B => REGl262r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_225_net_1\);
    
    \I2.VDBI_86_IV_1L2R_410\ : AND2
      port map(A => \I2.PIPEAl2r_net_1\, B => \I2.N_1707_i_0_1\, 
        Y => \I2.VDBi_86_iv_1_il2r_adt_net_53258_\);
    
    \I2.REGMAPl8r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un37_reg_ads_0_a2_0_a2_net_1\, Q => TST_cl5r);
    
    \I2.PIPEAl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_557_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl13r_net_1\);
    
    \I2.REG_il282r\ : INV
      port map(A => \I2.REGl282r\, Y => REG_i_0l282r);
    
    \I2.LB_i_7l26r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l26r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l26r_Rd1__net_1\);
    
    \I2.PIPEA1_523\ : MUX2L
      port map(A => \I2.PIPEA1l12r_net_1\, B => \I2.N_2521\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_523_net_1\);
    
    NLBRDY_pad : IB33
      port map(PAD => NLBRDY, Y => NLBRDY_c);
    
    \I5.un1_RESCNT_I_94\ : AND2
      port map(A => \I5.RESCNTl8r_net_1\, B => 
        \I5.RESCNTl9r_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_pog_array_1_3l0r\);
    
    \I2.VDBi_59l9r\ : AND2FT
      port map(A => \I2.VDBi_59_0l9r\, B => 
        \I2.VDBi_59l9r_adt_net_47330_\, Y => 
        \I2.VDBi_59l9r_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l9r\ : XOR2FT
      port map(A => \I10.CRC32l9r_net_1\, B => 
        \I10.EVENT_DWORDl9r_net_1\, Y => \I10.N_2314_i_i_0\);
    
    \I2.LWORDS_47\ : MUX2H
      port map(A => \I2.LWORDS_net_1\, B => LWORDB_in, S => 
        \I2.TST_c_0l1r\, Y => \I2.LWORDS_47_net_1\);
    
    VAD_padl18r : OTB33PH
      port map(PAD => VAD(18), A => \I2.VADml18r_net_1\, EN => 
        NOEAD_c_0_0);
    
    P_PDL_padl6r : OB33PH
      port map(PAD => P_PDL(6), A => REG_cl135r);
    
    \I10.FID_8_iv_0_0_0_0l27r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl11r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il27r_adt_net_20987_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il27r\);
    
    \I0.BNC_RESi_i\ : OR2
      port map(A => HWRES_C_2_0_19, B => REGl8r, Y => 
        \I0.N_111_i_0\);
    
    \I10.FID_8_rl21r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il21r\, B => 
        \I10.FID_8_iv_0_0_0_0_il21r\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l21r\);
    
    \I2.VDBI_86_0_IVL29R_318\ : AO21
      port map(A => \I2.PIPEA_i_0_il29r\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il29r\, Y => 
        \I2.VDBi_86l29r_adt_net_39637_\);
    
    \I2.REG_1l270r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_233_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl270r\);
    
    \I3.AEl38r\ : MUX2L
      port map(A => REGl191r, B => \I3.un16_ael38r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl38r);
    
    \I1.I2C_RDATA_21\ : MUX2L
      port map(A => I2C_RDATAl7r, B => \I1.N_588\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_21_net_1\);
    
    \I5.RESCNTl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l9r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl9r_net_1\);
    
    \I2.REG_1l442r_42\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_357_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL442R_26\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I33_Y\ : OR2
      port map(A => \I10.N259\, B => \I10.N261\, Y => \I10.N273\);
    
    \I10.FIFO_END_EVNT\ : DFF
      port map(CLK => CLKOUT, D => \I10.FIFO_END_EVNT_119_net_1\, 
        Q => \I10.FIFO_END_EVNT_net_1\);
    
    \I2.WDOGRES_i\ : INV
      port map(A => \I2.WDOGRES_net_1\, Y => \I2.WDOGRES_i_net_1\);
    
    \I2.VDBml22r\ : MUX2L
      port map(A => \I2.VDBil22r_net_1\, B => \I2.N_2063\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml22r_net_1\);
    
    \I10.EVRDYi_197\ : OAI21FTF
      port map(A => EVRDY_c, B => \I10.N_926\, C => 
        \I10.EVRDYi_197_adt_net_20551_\, Y => 
        \I10.EVRDYi_197_net_1\);
    
    \I10.CRC32_102\ : MUX2H
      port map(A => \I10.CRC32l15r_net_1\, B => \I10.N_1590\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_102_net_1\);
    
    \I2.REG_il271r\ : INV
      port map(A => \I2.REGl271r\, Y => REG_i_0l271r);
    
    \I2.VDBI_61L3R_403\ : AND2FT
      port map(A => \I2.VDBi_61_sl0r_net_1\, B => 
        \I2.VDBi_61_dl3r_net_1\, Y => 
        \I2.VDBi_61l3r_adt_net_52283_\);
    
    \I2.PIPEBl31r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_80_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl31r_net_1\);
    
    \I10.STATE2l2r\ : DFFS
      port map(CLK => CLKOUT, D => \I10.STATE2_nsl0r\, SET => 
        CLEAR_0_0, Q => \I10.STATE2l2r_net_1\);
    
    \I10.PDL_RADDRl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.PDL_RADDR_225_net_1\, CLR
         => CLEAR_0_0, Q => \I10.PDL_RADDRl1r_net_1\);
    
    \I10.EVENT_DWORD_18_rl14r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l14r_net_1\, B => 
        \I10.EVENT_DWORD_18l14r_adt_net_27044_\, Y => 
        \I10.EVENT_DWORD_18l14r\);
    
    \I10.BNC_CNT_202\ : MUX2H
      port map(A => \I10.BNC_CNTl4r_net_1\, B => 
        \I10.BNC_CNT_4l4r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_202_net_1\);
    
    \I2.un3_asb_1\ : XOR2FT
      port map(A => VAD_inl29r, B => GA_cl1r, Y => 
        \I2.un3_asb_1_net_1\);
    
    \I5.sstate_ns_il4r\ : AND2
      port map(A => \I5.sstate_nsl5r\, B => 
        \I5.sstate_ns_il4r_adt_net_33659_\, Y => 
        \I5.sstate_ns_il4r_net_1\);
    
    \I2.VDBi_59l14r\ : AND2FT
      port map(A => \I2.VDBi_59_0l9r\, B => 
        \I2.VDBi_59l14r_adt_net_43560_\, Y => 
        \I2.VDBi_59l14r_net_1\);
    
    \I2.LB_sl29r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl29r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl29r_Rd1__net_1\);
    
    \I3.un16_ae_10\ : NOR2
      port map(A => \I3.un16_ae_1l14r\, B => \I3.un16_ae_1l11r\, 
        Y => \I3.un16_ael10r\);
    
    \I10.un2_i2c_chain_0_i_0_a2_1l5r\ : OR3FFT
      port map(A => \I10.CNTl3r_net_1\, B => \I10.CNTl0r_net_1\, 
        C => \I10.N_2295_i_0\, Y => 
        \I10.un2_i2c_chain_0_i_0_a2_1l5r_net_1\);
    
    \I10.STATE1l7r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl5r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l7r_net_1\);
    
    \I2.VDBil4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_580_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil4r_net_1\);
    
    \I2.REG_1_309\ : MUX2L
      port map(A => REGl394r, B => VDB_inl1r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_309_net_1\);
    
    \I2.VDBI_86_0_IVL27R_322\ : AO21
      port map(A => \I2.PIPEAl27r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il27r\, Y => 
        \I2.VDBi_86l27r_adt_net_40047_\);
    
    \I3.AEl17r\ : MUX2L
      port map(A => REGl170r, B => \I3.un16_ael17r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl17r);
    
    \I2.REG_1l266r_50\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_229_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL266R_34\);
    
    \I2.un2_reg_ads_0_a3_1\ : NOR2
      port map(A => \I2.VASl1r_net_1\, B => \I2.VASl4r_net_1\, Y
         => \I2.N_3069\);
    
    \I2.un1_state1_1_i\ : AO21FTT
      port map(A => \I2.N_2848\, B => \I2.STATE1l4r_net_1\, C => 
        \I2.N_2639\, Y => \I2.N_2637\);
    
    \I1.AIR_COMMAND_21_0_iv_0l8r\ : AOI21
      port map(A => \I1.sstate2l9r_net_1\, B => REGl97r, C => 
        \I1.sstate2l3r_net_1\, Y => 
        \I1.AIR_COMMAND_21_0_iv_0l8r_net_1\);
    
    \I10.EVENT_DWORD_18_RL19R_237\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl29r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l19r_adt_net_26484_\);
    
    AE_PDL_padl35r : OB33PH
      port map(PAD => AE_PDL(35), A => AE_PDL_cl35r);
    
    \I10.CRC32_93\ : MUX2H
      port map(A => \I10.CRC32l6r_net_1\, B => \I10.N_1726\, S
         => \I10.N_2351\, Y => \I10.CRC32_93_net_1\);
    
    \I2.VDBI_54_0_IV_1L13R_355\ : AND2
      port map(A => REG_cl246r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il13r_adt_net_44238_\);
    
    NCYC_RELOAD_pad : OB33PH
      port map(PAD => NCYC_RELOAD, A => NCYC_RELOAD_c);
    
    \I10.un1_REG_1_ADD_16x16_medium_I47_Y\ : AO21
      port map(A => \I10.N279\, B => \I10.N276\, C => \I10.N275\, 
        Y => \I10.N290\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I34_Y\ : AND2
      port map(A => \I10.N260\, B => \I10.N262\, Y => \I10.N274\);
    
    \I10.STATE1_ns_i_0_0_0_o2l0r\ : OR2
      port map(A => \I10.STATE1l4r_net_1\, B => 
        \I10.STATE1l5r_net_1\, Y => \I10.N_2349\);
    
    \I3.un4_so_44_0\ : MUX2L
      port map(A => \I3.N_239\, B => \I3.N_228\, S => REGl126r, Y
         => \I3.N_240\);
    
    \I2.TCNT2l1r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT2_2l1r\, Q => 
        \I2.TCNT2l1r_net_1\);
    
    AMB_padl5r : IB33
      port map(PAD => AMB(5), Y => AMB_cl5r);
    
    \I2.STATE5L1R_509\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl2r\, CLR => 
        HWRES_c_2_0, Q => \I2.STATE5L1R_105\);
    
    \I3.un4_so_18_0\ : MUX2L
      port map(A => SP_PDL_inl22r, B => \I3.N_213\, S => REGl126r, 
        Y => \I3.N_214\);
    
    \I2.REG_1_415\ : MUX2H
      port map(A => VDB_inl26r, B => \I2.REGl500r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_415_net_1\);
    
    RSELD0_pad : OTB33PH
      port map(PAD => RSELD0, A => REGl426r, EN => REG_i_0l442r);
    
    \I10.EVNT_NUM_3_I_47\ : XOR2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_1_1l0r\, B => 
        \I10.EVNT_NUMl2r_net_1\, Y => \I10.EVNT_NUM_3l2r\);
    
    \I10.REG_1l44r\ : DFFS
      port map(CLK => CLKOUT, D => \I10.un1_REG_1_il44r\, SET => 
        CLEAR_0_0, Q => REG_i_0l44r);
    
    AE_PDL_padl9r : OB33PH
      port map(PAD => AE_PDL(9), A => AE_PDL_cl9r);
    
    \I2.un756_regmap_19\ : NOR3FFT
      port map(A => \I2.un756_regmap_4_net_1\, B => 
        \I2.un756_regmap_19_adt_net_36245_\, C => 
        \I2.un756_regmap_12_i_adt_net_36217_\, Y => 
        \I2.un756_regmap_19_net_1\);
    
    \I2.REG_1l104r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_477_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl104r);
    
    \I2.REG_1_241\ : MUX2L
      port map(A => \I2.REGL278R_46\, B => VDB_inl13r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_241_net_1\);
    
    \I2.VDBi_82l5r\ : MUX2L
      port map(A => \I2.VDBil5r_net_1\, B => FBOUTl5r, S => 
        \I2.N_1721_1\, Y => \I2.VDBi_82l5r_net_1\);
    
    \I2.REG_1l284r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_247_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl284r\);
    
    \I1.COMMAND_5\ : MUX2H
      port map(A => \I1.COMMANDl9r_net_1\, B => 
        \I1.COMMAND_4l9r_net_1\, S => \I1.SSTATEL13R_8\, Y => 
        \I1.COMMAND_5_net_1\);
    
    LB_padl5r : IOB33PH
      port map(PAD => LB(5), A => \I2.LB_il5r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl5r);
    
    \I10.EVENT_DWORD_139\ : MUX2H
      port map(A => \I10.EVENT_DWORDl6r_net_1\, B => 
        \I10.EVENT_DWORD_18l6r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_139_net_1\);
    
    \I2.STATE5l1r_116_128\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5l1r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L1R_RD1__112\);
    
    \I2.VDBi_67l12r\ : MUX2L
      port map(A => \I2.VDBi_61l12r_net_1\, B => \I2.N_1961\, S
         => \I2.N_1965\, Y => \I2.VDBi_67l12r_net_1\);
    
    \I2.REG_1_157\ : MUX2L
      port map(A => REGl167r, B => VDB_inl14r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_157_net_1\);
    
    \I2.VDBI_54_0_IV_5L1R_413\ : AO21
      port map(A => REGl250r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.REG_1_m_il234r\, Y => 
        \I2.VDBi_54_0_iv_5_il1r_adt_net_53707_\);
    
    \I2.REG_il274r\ : INV
      port map(A => \I2.REGl274r\, Y => REG_i_0l274r);
    
    \I10.EVENT_DWORD_150\ : MUX2H
      port map(A => \I10.EVENT_DWORDl17r_net_1\, B => 
        \I10.EVENT_DWORD_18l17r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_150_net_1\);
    
    \I2.LB_s_23\ : MUX2L
      port map(A => \I2.LB_sl9r_Rd1__net_1\, B => 
        \I2.N_3044_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116356_Rd1__net_1\, Y => 
        \I2.LB_sl9r\);
    
    \I2.LB_sl4r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl4r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl4r_Rd1__net_1\);
    
    \I1.AIR_COMMAND_47\ : MUX2L
      port map(A => \I1.AIR_COMMANDl15r_net_1\, B => 
        \I1.AIR_COMMAND_21l15r\, S => \I1.un1_tick_12_net_1\, Y
         => \I1.AIR_COMMAND_47_net_1\);
    
    \I2.REG_1_347\ : MUX2L
      port map(A => REGl432r, B => VDB_inl7r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_347_net_1\);
    
    \I2.REG_1l84r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_457_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl84r);
    
    \I2.N_3041_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3041\, SET => 
        HWRES_c_2_0, Q => \I2.N_3041_Rd1__net_1\);
    
    \I10.EVENT_DWORDl24r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_157_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl24r_net_1\);
    
    \I2.VDBi_86_iv_1l12r\ : AOI21TTF
      port map(A => \I2.PIPEAl12r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_iv_0l12r_net_1\, Y => 
        \I2.VDBi_86_iv_1l12r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_o3_1l7r\ : OA21
      port map(A => I2C_RVALID, B => \I10.N_2349\, C => 
        \I10.N_2390\, Y => \I10.N_2275_i_1\);
    
    \I10.BNC_CNT_208\ : MUX2H
      port map(A => \I10.BNC_CNTl10r_net_1\, B => 
        \I10.BNC_CNT_4l10r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_208_net_1\);
    
    \I10.CRC32_89\ : MUX2H
      port map(A => \I10.CRC32l2r_net_1\, B => \I10.N_1458\, S
         => \I10.N_2351\, Y => \I10.CRC32_89_net_1\);
    
    \I2.VDBm_0l14r\ : MUX2L
      port map(A => \I2.PIPEAl14r_net_1\, B => 
        \I2.PIPEBl14r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2055\);
    
    \I3.un4_so_6_0\ : MUX2L
      port map(A => SP_PDL_inl36r, B => SP_PDL_inl32r, S => 
        REGL124R_5, Y => \I3.N_202\);
    
    \I8.un1_BITCNT_I_17\ : XOR2
      port map(A => \I8.DWACT_ADD_CI_0_g_array_12l0r\, B => 
        \I8.BITCNTl3r_net_1\, Y => \I8.I_17\);
    
    \I2.PIPEA1_515\ : MUX2L
      port map(A => \I2.PIPEA1l4r_net_1\, B => \I2.N_2505\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_515_net_1\);
    
    \I2.REG3l4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_111_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl4r\);
    
    \I1.sstatel7r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el6r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstatel7r_net_1\);
    
    \I10.UN2_I2C_CHAIN_0_I_0_0_3L2R_277\ : AND2
      port map(A => \I10.CNTl4r_net_1\, B => \I10.N_2305\, Y => 
        \I10.un2_i2c_chain_0_i_0_0_3_il2r_adt_net_29431_\);
    
    \I2.STATE2l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE2_nsl3r_net_1\, CLR
         => CLEAR_0_0, Q => \I2.STATE2l2r_net_1\);
    
    \I10.FID_8_rl3r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l3r_adt_net_24381_\, Y => \I10.FID_8l3r\);
    
    \I2.VDBi_56l21r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l21r_net_1\, Y => \I2.VDBi_56l21r_net_1\);
    
    \I5.sstatel0r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.sstate_ns_i_0l5r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.sstatel0r_net_1\);
    
    \I2.REG_1_473\ : MUX2H
      port map(A => VDB_inl11r, B => REGl100r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_473_net_1\);
    
    \I2.VDBi_9_sqmuxa_1\ : AND2FT
      port map(A => \I2.un756_regmap_17_i_adt_net_36523_\, B => 
        \I2.VDBi_9_sqmuxa_i_0_net_1\, Y => 
        \I2.VDBi_9_sqmuxa_1_net_1\);
    
    \I2.VDBi_602\ : MUX2L
      port map(A => \I2.VDBil26r_net_1\, B => \I2.VDBi_86l26r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_602_net_1\);
    
    \I2.UN7_NOE32RI_I_0_I_A2_1_119\ : NOR3FTT
      port map(A => \I2.WRITES_net_1\, B => DS0B_c, C => DS1B_c, 
        Y => \I2.N_2983_1_adt_net_2417_\);
    
    \I1.BITCNT_10_rl0r\ : OA21TTF
      port map(A => \I1.BITCNT_2_sqmuxa\, B => 
        \I1.DWACT_ADD_CI_0_partial_suml0r\, C => 
        \I1.BITCNT_0_sqmuxa_2\, Y => \I1.BITCNT_10l0r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I37_Y\ : AO21TTF
      port map(A => \I10.N264\, B => \I10.N265\, C => 
        \I10.N263_i\, Y => \I10.N277\);
    
    \I2.WDOG_3_I_1\ : AND2
      port map(A => TICKl2r, B => \I2.WDOGl0r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_TMP_1l0r\);
    
    \I2.REG_1l260r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_223_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl260r);
    
    \I10.L2AF1\ : DFFC
      port map(CLK => ACLKOUT, D => L2A_c, CLR => HWRES_c_2_0, Q
         => \I10.L2AF1_net_1\);
    
    \I2.PIPEAl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_550_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl6r_net_1\);
    
    \I10.FID_168\ : MUX2L
      port map(A => \I10.FID_8l3r\, B => \I10.FIDl3r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_168_net_1\);
    
    \I2.REG_1l99r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_472_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl99r);
    
    \I2.DSSF1\ : DFFS
      port map(CLK => CLKOUT, D => \I2.DSSF1_12_net_1\, SET => 
        HWRES_c_2_0, Q => \I2.DSSF1_net_1\);
    
    AE_PDL_padl41r : OB33PH
      port map(PAD => AE_PDL(41), A => AE_PDL_cl41r);
    
    \I10.PDL_RREQ\ : DFFC
      port map(CLK => CLKOUT, D => \I10.PDL_RREQ_131_net_1\, CLR
         => CLEAR_0_0, Q => \I10.PDL_RREQ_net_1\);
    
    \I2.REG_1_477\ : MUX2H
      port map(A => REGl104r, B => \I2.N_2225\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_477_net_1\);
    
    \I2.REG_1_182\ : MUX2L
      port map(A => REGl192r, B => VDB_inl7r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_182_net_1\);
    
    VDB_padl5r : IOB33PH
      port map(PAD => VDB(5), A => \I2.VDBml5r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl5r);
    
    \I2.REG_1_370\ : MUX2H
      port map(A => VDB_inl14r, B => \I2.REGl455r\, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_370_net_1\);
    
    \I2.NSELCLK_c_i\ : INV
      port map(A => NSELCLK_c, Y => NSELCLK_c_i_0);
    
    \I2.VDBi_86_0_ivl30r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl30r\, C
         => \I2.VDBi_86l30r_adt_net_39432_\, Y => 
        \I2.VDBi_86l30r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I22_Y\ : OA21FTT
      port map(A => REG_i_0l38r, B => \I10.REGl39r\, C => 
        \I10.N_2519_1\, Y => \I10.N261\);
    
    \I2.VADml30r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl30r_net_1\, Y
         => \I2.VADml30r_net_1\);
    
    \I2.un7_ronly_0_a2_0_a2_2_3\ : OR3
      port map(A => \I2.un7_ronly_0_a2_0_a2_2_1_i\, B => 
        \I2.VAS_i_0_il9r\, C => \I2.VASl10r_net_1\, Y => 
        \I2.un7_ronly_0_a2_0_a2_2_3_i\);
    
    \I1.sstate_0l13r\ : DFFS
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el0r\, SET => 
        HWRES_c_2_0, Q => \I1.sstatel13r_net_1\);
    
    \I2.VAS_86\ : MUX2L
      port map(A => VAD_inl4r, B => \I2.VASl4r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_86_net_1\);
    
    \I2.un756_regmap_10\ : OR3
      port map(A => \I2.un756_regmap_6_i\, B => 
        \I2.REGMAP_i_0_il15r\, C => \I2.REGMAPl34r_net_1\, Y => 
        \I2.un756_regmap_10_i\);
    
    \I2.VDBI_70L0R_420\ : AND2FT
      port map(A => \I2.VDBi_70_s_0l0r_net_1\, B => 
        \I2.VDBi_70_d_0l0r_net_1\, Y => 
        \I2.VDBi_70l0r_adt_net_55115_\);
    
    \I2.REG_1_ml162r\ : NAND2
      port map(A => REGl162r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml162r_net_1\);
    
    \I2.REG_1l425r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_340_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl425r);
    
    \I2.REG_1_343\ : MUX2L
      port map(A => REGl428r, B => VDB_inl3r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_343_net_1\);
    
    AE_PDL_padl32r : OB33PH
      port map(PAD => AE_PDL(32), A => AE_PDL_cl32r);
    
    \I2.VDBi_54_0_iv_1l5r\ : AO21
      port map(A => REGl190r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il5r_adt_net_50560_\, Y => 
        \I2.VDBi_54_0_iv_1_il5r\);
    
    \I2.REG_1l129r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_131_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl129r);
    
    \I2.LB_il1r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il1r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il1r_Rd1__net_1\);
    
    \I2.REG_1l90r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_463_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl90r);
    
    \I2.VDBi_67_0l8r\ : MUX2L
      port map(A => NSELCLK_c, B => \I2.REGl449r\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1957\);
    
    \I2.un1_NRDMEBi_2_sqmuxa_1_i_a3_0_a2\ : AND3FFT
      port map(A => REGl5r, B => \I2.un6_evrdy_i\, C => 
        \I2.STATE2l5r_net_1\, Y => \I2.N_2368\);
    
    \I3.AEl2r\ : MUX2L
      port map(A => REGl155r, B => \I3.un16_ael2r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl2r);
    
    \I10.EVNT_NUM_3_I_49\ : XOR2
      port map(A => \I10.EVNT_NUMl3r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_12_5l0r\, Y => 
        \I10.EVNT_NUM_3l3r\);
    
    LB_padl23r : IOB33PH
      port map(PAD => LB(23), A => \I2.LB_il23r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl23r);
    
    \I2.TCNT2_i_0_il6r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT2_2l6r\, Q => 
        \I2.TCNT2_i_0_il6r_net_1\);
    
    \I2.STATE5L2R_487\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_106\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L2R_72\);
    
    \I2.VDBI_54_0_IV_0L14R_350\ : AND2
      port map(A => REGl119r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.VDBi_54_0_iv_0_il14r_adt_net_43442_\);
    
    \I2.VDBm_0l3r\ : MUX2L
      port map(A => \I2.PIPEAl3r_net_1\, B => \I2.PIPEBl3r_net_1\, 
        S => \I2.BLTCYC_17\, Y => \I2.N_2044\);
    
    AE_PDL_padl34r : OB33PH
      port map(PAD => AE_PDL(34), A => AE_PDL_cl34r);
    
    \I2.VDBi_86_iv_0l6r\ : AO21TTF
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.VDBi_82l6r_net_1\, C => \I2.VDBi_85_ml6r_net_1\, Y
         => \I2.VDBi_86_iv_0_il6r\);
    
    \I2.REG_1_257\ : MUX2L
      port map(A => \I2.REGL294R_62\, B => VDB_inl29r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_257_net_1\);
    
    \I2.LB_sl8r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl8r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl8r_Rd1__net_1\);
    
    \I2.VDBml0r\ : MUX2L
      port map(A => \I2.VDBil0r_net_1\, B => \I2.N_2041\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml0r_net_1\);
    
    \I2.un6_tcnt1_2\ : OR3
      port map(A => \I2.TCNT1l5r_net_1\, B => 
        \I2.TCNT1_i_0_il1r_net_1\, C => \I2.TCNT1_i_0_il4r_net_1\, 
        Y => \I2.un6_tcnt1_2_i\);
    
    \I2.VDBi_24l1r\ : NOR2
      port map(A => \I2.REGMAPl7r_net_1\, B => 
        \I2.VDBi_24_sl1r_net_1\, Y => 
        \I2.VDBi_24l1r_adt_net_90940_\);
    
    \I5.RESCNT_6_rl2r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_51\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l2r\);
    
    \I1.sstate2se_0_0\ : AO21FTT
      port map(A => TICKl0r, B => \I1.sstate2l8r_net_1\, C => 
        \I1.sstate2_ns_el1r_adt_net_8343_\, Y => 
        \I1.sstate2_ns_el1r\);
    
    \I3.ISI_5_iv\ : AO21
      port map(A => REG_cl136r, B => \I3.ISI_0_sqmuxa\, C => 
        \I3.ISI_5_adt_net_82913_\, Y => \I3.ISI_5\);
    
    \I2.VDBi_86_iv_1l9r\ : AOI21TTF
      port map(A => \I2.PIPEAl9r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_iv_0l9r_net_1\, Y => 
        \I2.VDBi_86_iv_1l9r_net_1\);
    
    \I2.VDBI_86_0_IV_0L21R_333\ : AND2
      port map(A => \I2.VDBil21r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il21r_adt_net_41238_\);
    
    \I2.VADml8r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl8r_net_1\, Y
         => \I2.VADml8r_net_1\);
    
    \I10.FIDl18r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_183_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl18r_net_1\);
    
    \I10.REG_1l47r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I79_Y\, 
        CLR => CLEAR_0_0, Q => REGl47r);
    
    \I1.un1_tick_12\ : AO21TTF
      port map(A => \I1.sstate2_0_sqmuxa_4_0\, B => 
        \I1.un1_AIR_CHAIN_1_sqmuxa_5_net_1\, C => TICKl0r, Y => 
        \I1.un1_tick_12_net_1\);
    
    \I2.REG_1l433r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_348_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => NSELCLK_c);
    
    \I3.AEl31r\ : MUX2L
      port map(A => REGl184r, B => \I3.un16_ael31r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl31r);
    
    \I2.VDBi_54_0_ivl2r\ : AO21TTF
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l2r_net_1\, C => \I2.VDBi_54_0_iv_5l2r_net_1\, 
        Y => \I2.VDBi_54l2r\);
    
    \I2.REG_1_433\ : MUX2H
      port map(A => VDB_inl12r, B => REGl60r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_433_net_1\);
    
    \I10.FID_179\ : MUX2L
      port map(A => \I10.FID_8l14r\, B => \I10.FIDl14r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_179_net_1\);
    
    \I1.AIR_COMMAND_21_0_ivl14r\ : OR2
      port map(A => \I1.N_565_i_i\, B => 
        \I1.AIR_COMMAND_21l14r_adt_net_9030_\, Y => 
        \I1.AIR_COMMAND_21l14r_net_1\);
    
    \I3.AEl6r\ : MUX2L
      port map(A => REGl159r, B => \I3.un16_ael6r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl6r);
    
    \I2.VDBi_86_0_iv_0l24r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l24r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il24r_adt_net_40623_\, Y => 
        \I2.VDBi_86_0_iv_0_il24r\);
    
    \I10.un3_bnc_cnt_I_37\ : AND3
      port map(A => \I10.BNC_CNTl6r_net_1\, B => 
        \I10.DWACT_FINC_El0r\, C => \I10.DWACT_FINC_El2r\, Y => 
        \I10.N_64\);
    
    \I2.PIPEA_8_rl26r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl26r, C => 
        \I2.PIPEA_8l26r_adt_net_55817_\, Y => \I2.PIPEA_8l26r\);
    
    \I10.G\ : OR2
      port map(A => \I10.G_3_i\, B => 
        \I10.un6_bnc_res_NE_16_i_adt_net_16189_\, Y => 
        \I10.un6_bnc_res_NE_16_i\);
    
    SP_PDL_padl35r : IOB33PH
      port map(PAD => SP_PDL(35), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl35r);
    
    AE_PDL_padl2r : OB33PH
      port map(PAD => AE_PDL(2), A => AE_PDL_cl2r);
    
    \I2.REG_1l437r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_352_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl437r\);
    
    DIR_CTTM_padl2r : OB33PH
      port map(PAD => DIR_CTTM(2), A => \VCC\);
    
    SP_PDL_padl36r : IOB33PH
      port map(PAD => SP_PDL(36), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl36r);
    
    \I10.BNCRES_CNT_4_G_1_148\ : NOR3FFT
      port map(A => \I10.BNCRES_CNTl0r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_pog_array_1_0l0r\, C => 
        \I10.G_2_i_adt_net_16541_\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_2_0l0r_adt_net_16625_\);
    
    \I10.READ_OR_FLAG\ : DFFC
      port map(CLK => CLKOUT, D => 
        \I10.READ_OR_FLAG_85_i_0_0_net_1\, CLR => CLEAR_0_0, Q
         => \I10.READ_OR_FLAG_net_1\);
    
    \I2.VDBi_54_0_iv_0l6r\ : AO21
      port map(A => REGl255r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il6r_adt_net_49715_\, Y => 
        \I2.VDBi_54_0_iv_0_il6r\);
    
    \I10.EVENT_DWORDl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_145_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl12r_net_1\);
    
    \I2.REG_1_437\ : MUX2H
      port map(A => VDB_inl16r, B => REGl64r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_437_net_1\);
    
    \I2.REG_1_259\ : MUX2L
      port map(A => \I2.REGL296R_64\, B => VDB_inl31r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_259_net_1\);
    
    \I2.REG_1_330\ : MUX2L
      port map(A => REGl415r, B => VDB_inl22r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_330_net_1\);
    
    \I2.VDBil3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_579_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil3r_net_1\);
    
    \I2.REG_1_212\ : MUX2L
      port map(A => VDB_inl0r, B => REGl249r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_212_net_1\);
    
    \I5.un1_RESCNT_I_63\ : XOR2
      port map(A => \I5.RESCNTl8r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_3l0r\, Y => \I5.I_63\);
    
    \I2.STATE1l4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE1_nsl5r\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.STATE1l4r_net_1\);
    
    \I8.SWORDl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_13_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl12r_net_1\);
    
    \I2.VDBi_67l4r\ : OA21
      port map(A => \I2.VDBi_61l4r_adt_net_51478_\, B => 
        \I2.VDBi_61l4r_adt_net_51480_\, C => \I2.N_1965\, Y => 
        \I2.VDBi_67l4r_adt_net_51520_\);
    
    \I2.REG_1l443r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_358_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl443r\);
    
    \I2.REG_1l235r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_198_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl2r);
    
    \I10.un3_bnc_cnt_I_122\ : XOR2
      port map(A => \I10.BNC_CNTl19r_net_1\, B => \I10.N_4\, Y
         => \I10.I_122\);
    
    \I2.REG_92l82r\ : AND2
      port map(A => \I2.N_1826_0\, B => \I2.N_1985\, Y => 
        \I2.REG_92l82r_net_1\);
    
    \I1.BITCNT_0_sqmuxa_2_0_o3\ : OR2FT
      port map(A => \I1.COMMANDl1r_net_1\, B => 
        \I1.COMMANDl0r_net_1\, Y => \I1.N_402\);
    
    \I2.REG_1_235\ : MUX2L
      port map(A => \I2.REGL272R_40\, B => VDB_inl7r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_235_net_1\);
    
    \I2.VDBi_19l25r\ : AND2
      port map(A => TST_cl5r, B => REGl73r, Y => 
        \I2.VDBi_19l25r_net_1\);
    
    \I2.VDBi_54_0_iv_1l6r\ : AO21
      port map(A => REGl191r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il6r_adt_net_49757_\, Y => 
        \I2.VDBi_54_0_iv_1_il6r\);
    
    \I10.FID_8_RL15R_189\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl15r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il15r\, Y => 
        \I10.FID_8l15r_adt_net_22910_\);
    
    \I2.PULSE_43_rl10r\ : AOI21FTF
      port map(A => PULSEl10r, B => \I2.PULSE_1_sqmuxa_5\, C => 
        \I2.N_2913\, Y => \I2.PULSE_43_rl10r_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_3l3r\ : AOI21FTF
      port map(A => \I10.CNTl4r_net_1\, B => \I10.N_2401_i_i\, C
         => \I10.un2_i2c_chain_0_0_0_0_1l3r_net_1\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_3l3r_net_1\);
    
    \I2.STATE1_NSL7R_308\ : AND2
      port map(A => \I2.STATE1l2r_net_1\, B => \I2.N_1721_1\, Y
         => \I2.STATE1_nsl7r_adt_net_38258_\);
    
    \I1.I2C_RDATA_9_il9r\ : MUX2L
      port map(A => I2C_RDATAl9r, B => REGl120r, S => 
        \I1.sstate2_0_sqmuxa_4_0\, Y => \I1.N_592\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I58_un1_Y\ : OAI21
      port map(A => \I10.N_2519_1\, B => REGl46r, C => \I10.N300\, 
        Y => \I10.ADD_16x16_medium_I58_un1_Y\);
    
    \I2.PIPEAl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_553_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl9r_net_1\);
    
    \I10.STATE1_ns_0l7r\ : OAI21FTT
      port map(A => \I10.STATE1l5r_net_1\, B => 
        \I10.PDL_RREQ_net_1\, C => \I10.PDL_RADDR_1_sqmuxa\, Y
         => \I10.STATE1_nsl7r\);
    
    \I2.PIPEA_8_rl4r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl4r, C => 
        \I2.PIPEA_8l4r_adt_net_57394_\, Y => \I2.PIPEA_8l4r\);
    
    SP_PDL_padl22r : IOB33PH
      port map(PAD => SP_PDL(22), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl22r);
    
    \I2.PIPEB_68\ : MUX2H
      port map(A => \I2.PIPEBl19r_net_1\, B => \I2.N_2607\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_68_net_1\);
    
    \I2.REG_1l447r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_362_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl447r\);
    
    \I1.AIR_COMMAND_21_0_IVL13R_133\ : AND2
      port map(A => \I1.sstate2l9r_net_1\, B => REGl102r, Y => 
        \I1.AIR_COMMAND_21l13r_adt_net_9112_\);
    
    \I2.un54_reg_ads_0_a2_0_a2_1\ : NAND2
      port map(A => \I2.N_3069\, B => \I2.N_3060\, Y => 
        \I2.N_2995_1\);
    
    \I2.REG_1_390\ : MUX2H
      port map(A => VDB_inl1r, B => \I2.REGl475r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_390_net_1\);
    
    \I2.LB_sl31r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl31r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl31r_Rd1__net_1\);
    
    \I10.EVENT_DWORD_149\ : MUX2H
      port map(A => \I10.EVENT_DWORDl16r_net_1\, B => 
        \I10.EVENT_DWORD_18l16r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_149_net_1\);
    
    \I10.EVENT_DWORDl20r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_153_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl20r_net_1\);
    
    \I2.un1_TCNT_1_I_25\ : AO21
      port map(A => \I2.DWACT_ADD_CI_0_pog_array_0_1l0r\, B => 
        \I2.DWACT_ADD_CI_0_g_array_1_2l0r\, C => 
        \I2.DWACT_ADD_CI_0_g_array_0_2l0r\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_12_4l0r\);
    
    \I2.un1_NRDMEBi_2_sqmuxa_2\ : AOI21
      port map(A => \I2.STATE2l2r_net_1\, B => \I2.N_2851\, C => 
        \I2.un1_NRDMEBi_2_sqmuxa_2_1_i\, Y => 
        \I2.un1_NRDMEBi_2_sqmuxa_2_adt_net_57879_\);
    
    \I2.REG3_115\ : MUX2L
      port map(A => VDB_inl8r, B => REGl8r, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_115_net_1\);
    
    \I10.FID_4_0_a2_0l7r\ : XOR2
      port map(A => \I10.CRC32l15r_net_1\, B => 
        \I10.CRC32l27r_net_1\, Y => \I10.FID_4_0_a2_0l7r_net_1\);
    
    \I1.SDAnoe_del\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SDAnoe_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SDAnoe_del_net_1\);
    
    \I1.I2C_RDATAl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_22_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl8r);
    
    VDB_padl6r : IOB33PH
      port map(PAD => VDB(6), A => \I2.VDBml6r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl6r);
    
    \I2.PIPEA_8_rl14r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl14r, C => 
        \I2.PIPEA_8l14r_adt_net_56657_\, Y => \I2.PIPEA_8l14r\);
    
    \I2.REG_1l245r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_208_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl245r);
    
    \I1.COMMAND_4l13r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl13r_net_1\, B => REGl102r, S
         => REGl7r, Y => \I1.COMMAND_4l13r_net_1\);
    
    \I2.VDBi_604\ : MUX2L
      port map(A => \I2.VDBil28r_net_1\, B => \I2.VDBi_86l28r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_604_net_1\);
    
    \I8.SWORD_15\ : MUX2H
      port map(A => \I8.SWORDl14r_net_1\, B => 
        \I8.SWORD_5l14r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_15_net_1\);
    
    \I2.REGMAPl15r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un7_ronly_0_a2_0_a2_net_1\, 
        Q => \I2.REGMAP_i_0_il15r\);
    
    \I2.LB_s_4_i_a2_0_a2l4r\ : OR2
      port map(A => LB_inl4r, B => 
        \I2.STATE5l4r_adt_net_116400_Rd1__net_1\, Y => 
        \I2.N_3039\);
    
    \I10.FID_8_iv_0_0_0_0l11r\ : AO21
      port map(A => \I10.STATE1L11R_12\, B => REGl59r, C => 
        \I10.FID_8_iv_0_0_0_0_il11r_adt_net_23359_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il11r\);
    
    \I10.CRC32_98\ : MUX2H
      port map(A => \I10.CRC32l11r_net_1\, B => \I10.N_1354\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_98_net_1\);
    
    \I2.VDBi_54_0_iv_5l1r\ : OR2
      port map(A => \I2.VDBi_54_0_iv_3_il1r\, B => 
        \I2.VDBi_54_0_iv_5_il1r_adt_net_53707_\, Y => 
        \I2.VDBi_54_0_iv_5_il1r\);
    
    \I1.REG_ml103r\ : AND2
      port map(A => \I1.sstate2l9r_net_1\, B => REGl103r, Y => 
        \I1.REG_m_il103r\);
    
    \I10.un1_REG_1_un1_REG_1_il43r\ : XOR2
      port map(A => \I10.N322\, B => 
        \I10.ADD_16x16_medium_I75_Y_0\, Y => 
        \I10.un1_REG_1_il43r\);
    
    \I10.FID_8_iv_0_0_0_0l5r\ : OAI21FTF
      port map(A => \I10.STATE1l11r_net_1\, B => REGl53r, C => 
        \I10.FID_8_iv_0_0_0_0l5r_adt_net_24108_\, Y => 
        \I10.FID_8_iv_0_0_0_0l5r_net_1\);
    
    \I2.VDBI_24L1R_468\ : AND3FTT
      port map(A => \I2.REGMAPl2r_net_1\, B => 
        \I2.VDBi_24l1r_adt_net_90940_\, C => 
        \I2.VDBi_24l1r_adt_net_91078_\, Y => 
        \I2.VDBi_24l1r_adt_net_91121_\);
    
    \I10.BNC_CNT_4_0_a2l13r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => \I10.I_77\, 
        Y => \I10.BNC_CNT_4l13r\);
    
    \I2.REG_1_160\ : MUX2L
      port map(A => REGl170r, B => VDB_inl1r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_160_net_1\);
    
    \I2.REG_1l450r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_365_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl450r\);
    
    \I2.REG_1l286r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_249_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl286r\);
    
    \I1.START_I2C_2_IV_138\ : NOR3FTT
      port map(A => REGl105r, B => \I1.sstate2l0r_net_1\, C => 
        \I1.sstate2l9r_net_1\, Y => 
        \I1.START_I2C_2_adt_net_11237_\);
    
    \I2.un3_asb_3\ : XOR2FT
      port map(A => VAD_inl31r, B => GA_cl3r, Y => 
        \I2.un3_asb_3_net_1\);
    
    \I2.VDBml6r\ : MUX2L
      port map(A => \I2.VDBil6r_net_1\, B => \I2.N_2047\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml6r_net_1\);
    
    \I10.G_145\ : OR2
      port map(A => \I10.un6_bnc_res_5_i_i_i_i\, B => 
        \I10.un6_bnc_res_0_i_i\, Y => 
        \I10.un6_bnc_res_NE_16_i_adt_net_16189_\);
    
    LBSP_padl5r : IOB33PH
      port map(PAD => LBSP(5), A => REGl398r, EN => REG_i_0l270r, 
        Y => LBSP_inl5r);
    
    \I3.un16_ae_17\ : NOR2
      port map(A => \I3.un16_ae_1l25r\, B => \I3.un16_ae_1l23r\, 
        Y => \I3.un16_ael17r\);
    
    \I10.FID_8_iv_0_0_0_1l20r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl20r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il20r_adt_net_22093_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il20r\);
    
    \I2.VDBI_86_0_IVL21R_334\ : AO21
      port map(A => \I2.PIPEAl21r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il21r\, Y => 
        \I2.VDBi_86l21r_adt_net_41277_\);
    
    \I1.un1_sdaa_0_a2\ : NOR2
      port map(A => \I1.CHAIN_SELECT_net_1\, B => 
        \I1.SDAnoe_del2_net_1\, Y => un1_sdaa_0_a2);
    
    \I2.VDBi_54_0_iv_0l12r\ : AO21
      port map(A => REGl261r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il12r_adt_net_44950_\, Y => 
        \I2.VDBi_54_0_iv_0_il12r\);
    
    \I2.REG_1_462\ : MUX2H
      port map(A => VDB_inl0r, B => REGl89r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_462_net_1\);
    
    \I10.event_meb.M3\ : FIFO256x9SST
      port map(DO8 => OPEN, DO7 => DPRl31r, DO6 => DPRl30r, DO5
         => DPRl29r, DO4 => DPRl28r, DO3 => DPRl27r, DO2 => 
        DPRl26r, DO1 => DPRl25r, DO0 => DPRl24r, FULL => 
        \I10.event_meb.net00006\, EMPTY => OPEN, EQTH => OPEN, 
        GEQTH => OPEN, WPE => OPEN, RPE => OPEN, DOS => OPEN, 
        LGDEP2 => \VCC\, LGDEP1 => \VCC\, LGDEP0 => \VCC\, RESET
         => CLEAR_i_0, LEVEL7 => \GND\, LEVEL6 => \GND\, LEVEL5
         => \GND\, LEVEL4 => \GND\, LEVEL3 => \GND\, LEVEL2 => 
        \GND\, LEVEL1 => \GND\, LEVEL0 => \VCC\, DI8 => \GND\, 
        DI7 => \I10.FIDl31r_net_1\, DI6 => \I10.FIDl30r_net_1\, 
        DI5 => \I10.FIDl29r_net_1\, DI4 => \I10.FIDl28r_net_1\, 
        DI3 => \I10.FIDl27r_net_1\, DI2 => \I10.FIDl26r_net_1\, 
        DI1 => \I10.FIDl25r_net_1\, DI0 => \I10.FIDl24r_net_1\, 
        WRB => \I10.WRB_net_1\, RDB => NRDMEB, WBLKB => \GND\, 
        RBLKB => \GND\, PARODD => \GND\, WCLKS => CLKOUT, RCLKS
         => CLKOUT, DIS => \GND\);
    
    \I5.RESCNT_6_rl6r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_59\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l6r\);
    
    \I10.EVENT_DWORDl23r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_156_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl23r_net_1\);
    
    LTM_BUSY_pad : OB33PH
      port map(PAD => LTM_BUSY, A => FULL);
    
    \I1.sstatese_4_0_0_a2_0_1\ : NOR2FT
      port map(A => TICKl0r, B => \I1.N_401\, Y => \I1.N_681_1\);
    
    \I2.un1_state1_1_i_a2_0_1_0\ : OR3
      port map(A => AMB_cl1r, B => AMB_cl0r, C => \I2.N_2889_1\, 
        Y => \I2.un1_state1_1_i_a2_0_1_net_1\);
    
    \I2.VDBi_82l3r\ : MUX2L
      port map(A => \I2.VDBil3r_net_1\, B => FBOUTl3r, S => 
        \I2.N_1721_1\, Y => \I2.VDBi_82l3r_net_1\);
    
    \I2.VDBi_24l4r\ : MUX2L
      port map(A => \I2.REGl478r\, B => \I2.VDBi_19l4r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l4r_net_1\);
    
    \I2.VDBi_54_0_iv_0l4r\ : AO21
      port map(A => REGl253r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il4r_adt_net_51321_\, Y => 
        \I2.VDBi_54_0_iv_0_il4r\);
    
    \I2.TCNT2_2_I_39\ : AND3
      port map(A => \I2.DWACT_ADD_CI_0_g_array_2l0r\, B => 
        \I2.TCNT2_i_0_il4r_net_1\, C => \I2.TCNT2l5r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_g_array_11l0r\);
    
    \I5.un1_RESCNT_I_86\ : AND2
      port map(A => \I5.RESCNTl12r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_12_5l0r\);
    
    \I2.REG_1_243\ : MUX2L
      port map(A => \I2.REGL280R_48\, B => VDB_inl15r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_243_net_1\);
    
    \I2.PIPEA1_526\ : MUX2L
      port map(A => \I2.PIPEA1l15r_net_1\, B => \I2.N_2527\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_526_net_1\);
    
    \I10.REG_1l39r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I71_Y\, 
        CLR => CLEAR_0_0, Q => \I10.REGl39r\);
    
    \I2.TCNT2_2_I_33\ : XOR2
      port map(A => \I2.TCNT2l5r_net_1\, B => 
        \I2.DWACT_ADD_CI_0_g_array_12_1l0r\, Y => \I2.TCNT2_2l5r\);
    
    \I2.PIPEA1_9_il4r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl4r, Y => \I2.N_2505\);
    
    \I2.un1_STATE2_10_i_a2_0_3\ : OR2FT
      port map(A => \I2.STATE2l2r_net_1\, B => \I2.N_2894_1\, Y
         => \I2.N_2894_3\);
    
    \I2.VDBI_86_0_IVL20R_336\ : AO21
      port map(A => \I2.PIPEAl20r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il20r\, Y => 
        \I2.VDBi_86l20r_adt_net_41482_\);
    
    SP_PDL_padl40r : IOB33PH
      port map(PAD => SP_PDL(40), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl40r);
    
    \I2.REG_il280r\ : INV
      port map(A => \I2.REGl280r\, Y => REG_i_0l280r);
    
    \I2.un1_STATE5_9_0_1_0_108\ : NAND3FFT
      port map(A => \I2.un1_STATE5_9_0_1_i\, B => \I2.N_2383\, C
         => \I2.LB_NOE_1_SQMUXA_116\, Y => \I2.UN1_STATE5_9_1_92\);
    
    \I1.BITCNT_10_rl2r\ : OA21TTF
      port map(A => \I1.BITCNT_2_sqmuxa\, B => \I1.I_14\, C => 
        \I1.BITCNT_0_sqmuxa_2\, Y => \I1.BITCNT_10l2r\);
    
    DIR_CTTM_padl4r : OB33PH
      port map(PAD => DIR_CTTM(4), A => \VCC\);
    
    \I2.un122_reg_ads_0_a2_0_a2\ : NOR2FT
      port map(A => \I2.N_3013_3\, B => \I2.N_3068\, Y => 
        \I2.un122_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.un61_reg_ads_0_a2_0_a2\ : AND3FFT
      port map(A => \I2.N_3064\, B => \I2.N_3005_1\, C => 
        \I2.N_3070\, Y => \I2.un61_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l25r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl9r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il25r_adt_net_21315_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il25r\);
    
    \I10.EVRDYi\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVRDYi_197_net_1\, CLR
         => CLEAR_0_0, Q => EVRDY_c);
    
    \I8.BITCNTl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.BITCNT_6l0r\, CLR => 
        HWRES_c_2_0, Q => \I8.BITCNTl0r_net_1\);
    
    \I5.SBYTEl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.SBYTE_13_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => FBOUTl7r);
    
    \I2.REG_1_172\ : MUX2L
      port map(A => REGl182r, B => VDB_inl13r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_172_net_1\);
    
    \I3.un16_ae_30\ : NOR3
      port map(A => \I3.un16_ae_2l47r\, B => \I3.un16_ae_2l31r\, 
        C => \I3.un16_ae_1l30r\, Y => \I3.un16_ael30r\);
    
    \I2.N_3023_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3023\, SET => 
        HWRES_c_2_0, Q => \I2.N_3023_Rd1__net_1\);
    
    \I3.AEl1r\ : MUX2L
      port map(A => REGl154r, B => \I3.un16_ael1r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl1r);
    
    \I2.N_3014_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3014\, SET => 
        HWRES_c_2_0, Q => \I2.N_3014_Rd1__net_1\);
    
    LB_padl13r : IOB33PH
      port map(PAD => LB(13), A => \I2.LB_il13r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl13r);
    
    LB_padl25r : IOB33PH
      port map(PAD => LB(25), A => \I2.LB_il25r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl25r);
    
    \I2.VDBi_54_0_iv_3l5r\ : AO21TTF
      port map(A => REGL126R_4, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l5r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il5r\);
    
    SP_PDL_padl23r : IOB33PH
      port map(PAD => SP_PDL(23), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl23r);
    
    \I2.TCNT3l1r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT3_2l1r\, Q => 
        \I2.TCNT3l1r_net_1\);
    
    \I2.REGMAPl7r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un33_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl7r_net_1\);
    
    \I2.LB_sl5r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl5r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl5r_Rd1__net_1\);
    
    \I1.UN1_AIR_CHAIN_1_SQMUXA_5_131\ : NOR3
      port map(A => \I1.AIR_COMMAND_cnstl1r\, B => 
        \I1.AIR_COMMAND_cnstl10r\, C => 
        \I1.un1_AIR_CHAIN_1_sqmuxa_3_i_adt_net_8755_\, Y => 
        \I1.un1_AIR_CHAIN_1_sqmuxa_5_adt_net_8909_\);
    
    \I2.PIPEAl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_548_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl4r_net_1\);
    
    \I2.PIPEA1l15r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_526_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l15r_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l8r\ : XOR2FT
      port map(A => \I10.CRC32l8r_net_1\, B => 
        \I10.EVENT_DWORDl8r_net_1\, Y => \I10.N_2317_i_i_0\);
    
    \I2.VDBi_70_ml0r\ : OA21
      port map(A => \I2.VDBi_70l0r_adt_net_55113_\, B => 
        \I2.VDBi_70l0r_adt_net_55115_\, C => \I2.N_1705_i_0_1_0\, 
        Y => \I2.VDBi_70_m_il0r\);
    
    \I10.CNT_10_i_0_o2l0r\ : OA21TTF
      port map(A => \I10.N_2282\, B => \I10.N_2278\, C => 
        \I10.STATE1l12r_net_1\, Y => \I10.N_2287\);
    
    \I2.REG_1_254\ : MUX2L
      port map(A => \I2.REGL291R_59\, B => VDB_inl26r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_254_net_1\);
    
    \I10.FID_194\ : MUX2L
      port map(A => \I10.FID_8l29r\, B => \I10.FIDl29r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_194_net_1\);
    
    \I1.un1_AIR_CHAIN_1_sqmuxa_0\ : NOR2
      port map(A => \I1.sstate2l7r_net_1\, B => 
        \I1.sstate2l2r_net_1\, Y => 
        \I1.un1_AIR_CHAIN_1_sqmuxa_0_adt_net_8716_\);
    
    \I8.sstate_s0_0_a2_0\ : NOR2
      port map(A => \I8.sstatel1r_net_1\, B => 
        \I8.sstatel0r_net_1\, Y => \I8.sstate_d_0l3r\);
    
    \I2.un1_STATE5_6_0_a3_0_a2\ : NOR2
      port map(A => \I2.STATE5L3R_ADT_NET_116444_RD1__108\, B => 
        \I2.STATE5l0r_net_1\, Y => \I2.N_2388\);
    
    \I2.TCNT3_i_0_il2r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT3_2l2r\, Q => 
        \I2.TCNT3_i_0_il2r_net_1\);
    
    \I10.CRC32_114\ : MUX2H
      port map(A => \I10.CRC32l27r_net_1\, B => \I10.N_1216\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_114_net_1\);
    
    \I2.REG_1l125r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_127_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl125r);
    
    \I2.PIPEAl22r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_566_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl22r_net_1\);
    
    \I2.VDBi_599\ : MUX2L
      port map(A => \I2.VDBil23r_net_1\, B => \I2.VDBi_86l23r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_599_net_1\);
    
    \I2.VDBil1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_577_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil1r_net_1\);
    
    \I1.sstatese_3_i_0\ : MUX2H
      port map(A => \I1.sstatel9r_net_1\, B => 
        \I1.sstatel10r_net_1\, S => TICKl0r, Y => 
        \I1.sstatese_3_i_0_net_1\);
    
    \I10.EVENT_DWORD_18_RL24R_227\ : OA21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl24r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l24r_adt_net_25756_\);
    
    \I2.REGMAPl35r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un8_d32_0_a2_net_1\, Q => 
        \I2.REGMAPl35r_net_1\);
    
    \I2.PIPEA1_9_il19r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl19r, Y => \I2.N_2535\);
    
    \I10.un1_RDY_CNT_I_1\ : AND2
      port map(A => \I10.G_1_0_0_net_1\, B => 
        \I10.RDY_CNTl0r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_TMP_2l0r\);
    
    \I1.REG_1l105r\ : DFFS
      port map(CLK => CLKOUT, D => \I1.REG_1_105_13_net_1\, SET
         => HWRES_c_2_0, Q => REGl105r);
    
    \I10.EVENT_DWORD_18_rl26r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l26r_net_1\, B => 
        \I10.EVENT_DWORD_18l26r_adt_net_25448_\, Y => 
        \I10.EVENT_DWORD_18l26r\);
    
    LB_padl27r : IOB33PH
      port map(PAD => LB(27), A => \I2.LB_il27r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl27r);
    
    \I2.VDBi_54_0_iv_0l14r\ : AO21
      port map(A => REGl263r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il14r_adt_net_43442_\, Y => 
        \I2.VDBi_54_0_iv_0_il14r\);
    
    \I10.CRC32l15r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_102_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l15r_net_1\);
    
    \I10.BNC_CNT_210\ : MUX2H
      port map(A => \I10.BNC_CNT_i_il12r\, B => 
        \I10.BNC_CNT_4l12r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_210_net_1\);
    
    \I2.un25_reg_ads_0_a2_0_a2_1\ : AND2FT
      port map(A => \I2.N_3067\, B => \I2.N_3060\, Y => 
        \I2.N_2987_1\);
    
    \I2.VDBi_61l10r\ : MUX2L
      port map(A => LBSP_inl10r, B => \I2.VDBi_59l10r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l10r_net_1\);
    
    \I10.STATE1_ns_0_0_o3l5r\ : OR2FT
      port map(A => \I10.RDY_CNTl1r_net_1\, B => 
        \I10.RDY_CNTl0r_net_1\, Y => \I10.N_2299\);
    
    \I2.VDBi_54_0_iv_1l2r\ : AO21
      port map(A => REGl187r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il2r_adt_net_53062_\, Y => 
        \I2.VDBi_54_0_iv_1_il2r\);
    
    \I10.CRC32l20r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_107_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l20r_net_1\);
    
    \I10.UN1_REG_1_ADD_16X16_MEDIUM_I48_Y_141\ : AND3
      port map(A => \I10.N267\, B => \I10.N264\, C => \I10.N266\, 
        Y => \I10.N292_adt_net_15372_\);
    
    \I2.CLOSEDTK\ : DFFC
      port map(CLK => \I2.DS_i_a2_net_1\, D => \VCC\, CLR => 
        TST_c_cl3r, Q => \I2.CLOSEDTK_net_1\);
    
    \I2.VDBI_59L14R_352\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l14r_net_1\, C => \I2.VDBi_54_0_iv_5_il14r\, Y
         => \I2.VDBi_59l14r_adt_net_43560_\);
    
    AE_PDL_padl31r : OB33PH
      port map(PAD => AE_PDL(31), A => AE_PDL_cl31r);
    
    \I2.VDBi_86_iv_2l11r\ : AOI21TTF
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl11r\, C
         => \I2.VDBi_86_iv_1l11r_net_1\, Y => 
        \I2.VDBi_86_iv_2l11r_net_1\);
    
    \I2.REG_1_168\ : MUX2L
      port map(A => REGl178r, B => VDB_inl9r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_168_net_1\);
    
    \I2.un1_STATE2_13_0\ : OR3
      port map(A => \I2.STATE2l5r_net_1\, B => 
        \I2.un1_STATE2_13_1\, C => \I2.STATE2l4r_net_1\, Y => 
        \I2.un1_STATE2_13_adt_net_59330_\);
    
    VAD_padl24r : OTB33PH
      port map(PAD => VAD(24), A => \I2.VADml24r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I2.VDBI_17_0L7R_376\ : AND2FT
      port map(A => \I10.REGl39r\, B => \I2.REGMAPl6r_net_1\, Y
         => \I2.N_1904_adt_net_48650_\);
    
    \I10.CRC32l30r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_117_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l30r_net_1\);
    
    NLBCS_pad : OB33PH
      port map(PAD => NLBCS, A => \GND\);
    
    \I2.VDBI_86_0_IVL26R_324\ : AO21
      port map(A => \I2.PIPEAl26r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il26r\, Y => 
        \I2.VDBi_86l26r_adt_net_40252_\);
    
    \I2.VDBi_85_ml5r\ : NAND3
      port map(A => \I2.VDBil5r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml5r_net_1\);
    
    \I2.VDBml18r\ : MUX2L
      port map(A => \I2.VDBil18r_net_1\, B => \I2.N_2059\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml18r_net_1\);
    
    \I2.REG_1_189\ : MUX2L
      port map(A => REGl199r, B => VDB_inl14r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_189_net_1\);
    
    \I10.BNCRES_CNTl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNCRES_CNT_4l6r\, CLR => 
        CLEAR_0_0, Q => \I10.BNCRES_CNTl6r_net_1\);
    
    \I2.REG_1l488r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_403_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl488r\);
    
    \I8.SWORDl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_12_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl11r_net_1\);
    
    LBSP_padl18r : IOB33PH
      port map(PAD => LBSP(18), A => REGl411r, EN => REG_i_0l283r, 
        Y => LBSP_inl18r);
    
    \I2.STATE1_NS_0_0L1R_311\ : AO21FTF
      port map(A => \I2.N_1717\, B => \I2.N_2981_1\, C => 
        \I2.N_2885\, Y => \I2.STATE1_nsl1r_adt_net_38698_\);
    
    \I2.REG_1l132r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_134_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl132r);
    
    \I10.FID_8_iv_0_0_0_x3l14r\ : XOR2FT
      port map(A => \I10.CRC32l10r_net_1\, B => 
        \I10.CRC32l22r_net_1\, Y => \I10.N_2311_i_0_i\);
    
    \I2.PIPEA1_9_il5r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl5r, Y => \I2.N_2507\);
    
    \I2.REG_1_132\ : MUX2H
      port map(A => REG_cl130r, B => VDB_inl9r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_132_net_1\);
    
    \I2.VDBi_54_0_iv_0l8r\ : AOI21TTF
      port map(A => \I2.REGMAP_i_il17r\, B => REGl145r, C => 
        \I2.REG_ml113r_net_1\, Y => \I2.VDBi_54_0_iv_0l8r_net_1\);
    
    \I10.BNC_NUMBER_232\ : MUX2L
      port map(A => \I10.BNCRES_CNTl2r_net_1\, B => 
        \I10.BNC_NUMBERl2r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_232_net_1\);
    
    \I2.VDBI_17_RL15R_345\ : NOR2
      port map(A => \I2.REGMAPl7r_net_1\, B => 
        \I2.REGMAPl2r_net_1\, Y => 
        \I2.VDBi_17l15r_adt_net_42484_\);
    
    \I10.FID_178\ : MUX2L
      port map(A => \I10.FID_8l13r\, B => \I10.FIDl13r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_178_net_1\);
    
    \I2.REG_1l491r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_406_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl491r\);
    
    \I2.VDBi_54_0_iv_0l10r\ : AO21
      port map(A => REGl259r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il10r_adt_net_46458_\, Y => 
        \I2.VDBi_54_0_iv_0_il10r\);
    
    \I2.REG_1l281r_65\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_244_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL281R_49\);
    
    \I2.VDBi_61l17r\ : MUX2L
      port map(A => LBSP_inl17r, B => \I2.VDBi_56l17r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l17r_net_1\);
    
    \I2.REG_1l54r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_427_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl54r);
    
    \I2.PIPEA1_519\ : MUX2L
      port map(A => \I2.PIPEA1l8r_net_1\, B => \I2.N_2513\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_519_net_1\);
    
    \I2.REG_1l267r_51\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_230_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL267R_35\);
    
    \I10.G_1_1_0\ : NOR2FT
      port map(A => \I10.N_2642_0\, B => \I10.N_2357\, Y => 
        \I10.N_2285\);
    
    \I10.FIDl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_172_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl7r_net_1\);
    
    \I2.REG3l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_109_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl2r\);
    
    \I2.LB_s_4_i_a2_0_a2l12r\ : OR2
      port map(A => LB_inl12r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__69\, Y => \I2.N_3047\);
    
    \I0.CLEAR_0_a2_0\ : AND2FT
      port map(A => HWRES_C_2_0_19, B => LOAD_RES, Y => 
        \I0.CLEAR_0_a2_0_net_1\);
    
    \I2.VAS_90\ : MUX2L
      port map(A => VAD_inl8r, B => \I2.VASl8r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_90_net_1\);
    
    \I2.VDBI_86_0_IV_0L29R_317\ : AND2
      port map(A => \I2.VDBil29r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il29r_adt_net_39598_\);
    
    \I10.FID_166\ : MUX2L
      port map(A => \I10.FID_8l1r\, B => \I10.FIDl1r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_166_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0l5r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl5r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0l5r_adt_net_28097_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0l5r_net_1\);
    
    \I3.un16_ae_5\ : NOR2
      port map(A => \I3.un16_ae_1l45r\, B => \I3.un16_ae_1l5r\, Y
         => \I3.un16_ael5r\);
    
    \I1.I_192_3\ : NOR3FTT
      port map(A => \I1.N_544\, B => \I1.N_690\, C => 
        \I1.I_192_3_0_net_1\, Y => \I1.N_517_3\);
    
    \I10.EVENT_DWORDl26r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_159_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl26r_net_1\);
    
    LBSP_padl28r : IOB33PH
      port map(PAD => LBSP(28), A => REGl421r, EN => REG_i_0l293r, 
        Y => LBSP_inl28r);
    
    \I2.REG_1_442\ : MUX2H
      port map(A => VDB_inl21r, B => REGl69r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_442_net_1\);
    
    LB_padl6r : IOB33PH
      port map(PAD => LB(6), A => \I2.LB_il6r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl6r);
    
    \I1.I2C_RDATA_9_il5r\ : MUX2L
      port map(A => I2C_RDATAl5r, B => REGl116r, S => 
        \I1.sstate2_0_sqmuxa_4_0\, Y => \I1.N_584\);
    
    \I2.REG_1_425\ : MUX2H
      port map(A => VDB_inl4r, B => REGl52r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_425_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_o3_0l5r\ : OR2FT
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTl0r_net_1\, 
        Y => \I10.N_2300\);
    
    \I10.CLEAR_PSM_FLAGS\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1l9r_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CLEAR_PSM_FLAGS_net_1\);
    
    \I10.FID_8_rl9r\ : AND2FT
      port map(A => \I10.FID_8_iv_0_0_0_0l9r_net_1\, B => 
        \I10.FID_8l9r_adt_net_23633_\, Y => \I10.FID_8l9r\);
    
    \I2.N_1707_i_0_a2_1\ : AND2
      port map(A => \I2.N_1782\, B => \I2.N_2909_1\, Y => 
        \I2.N_1707_i_0_1\);
    
    \I1.SDAnoe_48\ : MUX2H
      port map(A => \I1.SDAnoe_net_1\, B => \I1.SDAnoe_8\, S => 
        TICKl0r, Y => \I1.SDAnoe_48_net_1\);
    
    \I2.REG_1_129\ : MUX2H
      port map(A => REGL127R_3, B => VDB_inl6r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_129_net_1\);
    
    \I5.sstate_ns_il1r\ : NOR2
      port map(A => \I5.N_210\, B => \I5.N_225\, Y => 
        \I5.sstate_ns_il1r_net_1\);
    
    \I10.un1_REG_1_un1_REG_1_il38r\ : XOR2
      port map(A => \I10.N292\, B => 
        \I10.ADD_16x16_medium_I70_Y_0\, Y => 
        \I10.un1_REG_1_il38r\);
    
    \I2.VDBi_54_0_iv_0l3r\ : AO21
      port map(A => REGl252r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il3r_adt_net_52124_\, Y => 
        \I2.VDBi_54_0_iv_0_il3r\);
    
    \I2.VDBi_61l9r\ : MUX2L
      port map(A => LBSP_inl9r, B => \I2.VDBi_59l9r_net_1\, S => 
        \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l9r_net_1\);
    
    \I2.un119_reg_ads_0_a3\ : NAND2FT
      port map(A => \I2.VASl1r_net_1\, B => \I2.VASl4r_net_1\, Y
         => \I2.N_3064\);
    
    \I2.STATE5l3r_adt_net_116444_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl1r_net_1\, CLR
         => HWRES_c_2_0, Q => 
        \I2.STATE5l3r_adt_net_116444_Rd1__net_1\);
    
    TST_padl13r : OB33PH
      port map(PAD => TST(13), A => NOE32W_c_c);
    
    \I10.un2_evread_3_i_0_a2_0_12\ : OR2
      port map(A => \I10.un2_evread_3_i_0_a2_0_11_i\, B => 
        \I10.un2_evread_3_i_0_a2_0_12_i_adt_net_20367_\, Y => 
        \I10.un2_evread_3_i_0_a2_0_12_i\);
    
    \I10.FID_4_0_a2_0l10r\ : XOR2
      port map(A => \I10.CRC32l18r_net_1\, B => 
        \I10.CRC32l30r_net_1\, Y => \I10.FID_4_0_a2_0l10r_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_a2l5r\ : NAND2
      port map(A => \I10.N_2374_1\, B => \I10.N_2300\, Y => 
        \I10.N_2403\);
    
    \I10.EVENT_DWORD_18_rl17r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l17r_net_1\, B => 
        \I10.EVENT_DWORD_18l17r_adt_net_26708_\, Y => 
        \I10.EVENT_DWORD_18l17r\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l7r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl7r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l7r_adt_net_27873_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l7r_net_1\);
    
    \I3.un16_ae_39_2\ : OR2
      port map(A => \I3.un16_ae_1l47r\, B => \I3.un16_ae_2l47r\, 
        Y => \I3.un16_ae_4l47r\);
    
    \I2.VDBI_54_0_IV_1L9R_371\ : AND2
      port map(A => SYNC_cl9r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il9r_adt_net_47254_\);
    
    \I2.un7_ronly_0_a2_0_a2_2\ : OR3
      port map(A => \I2.un7_ronly_0_a2_0_a2_2_3_i\, B => 
        \I2.VAS_i_0_il13r\, C => \I2.VASl14r_net_1\, Y => 
        \I2.N_3018_2_i\);
    
    \I2.STATE2_ns_a3l5r\ : NOR2FT
      port map(A => \I2.STATE2l5r_net_1\, B => \I2.N_1568\, Y => 
        \I2.STATE2_nsl5r\);
    
    \I1.I2C_RDATA_20\ : MUX2L
      port map(A => I2C_RDATAl6r, B => \I1.N_586\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_20_net_1\);
    
    L0_pad : IB33
      port map(PAD => L0, Y => L0_c);
    
    \I10.un1_REG_1_ADD_16x16_medium_I8_G0N\ : AND2
      port map(A => \I10.N_2519_1\, B => \I10.REGl40r\, Y => 
        \I10.N232_i_i\);
    
    \I2.REG_1l474r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_389_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl474r\);
    
    \I10.FID_8_IV_0_0_0_1L27R_164\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl75r, Y => 
        \I10.FID_8_iv_0_0_0_1_il27r_adt_net_20945_\);
    
    LB_padl3r : IOB33PH
      port map(PAD => LB(3), A => \I2.LB_il3r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl3r);
    
    \I2.PIPEA1_9_il2r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl2r, Y => \I2.N_2501\);
    
    \I10.un2_evread_1_0_x2_0_x3l15r\ : XOR2
      port map(A => EVREAD, B => \I10.FIFO_END_EVNT_net_1\, Y => 
        \I10.N_2313_i_0\);
    
    \I2.STATE2_ns_0_0_a2l4r\ : OR2FT
      port map(A => \I2.STATE2l1r_net_1\, B => TST_CL2R_16, Y => 
        \I2.N_2900\);
    
    \I10.CYC_STAT_1\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CYC_STAT_1_2\, CLR => 
        HWRES_c_2_0, Q => \I10.CYC_STAT_1_net_1\);
    
    \I3.un4_so_38_0\ : MUX2L
      port map(A => SP_PDL_inl27r, B => \I3.N_233\, S => REGl126r, 
        Y => \I3.N_234\);
    
    \I2.REG_1_446\ : MUX2H
      port map(A => VDB_inl25r, B => REGl73r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_446_net_1\);
    
    VAD_padl21r : OTB33PH
      port map(PAD => VAD(21), A => \I2.VADml21r_net_1\, EN => 
        NOEAD_c_0_0);
    
    SDIN_DAC_pad : OB33PH
      port map(PAD => SDIN_DAC, A => SDIN_DAC_c);
    
    \I3.AEl34r\ : MUX2L
      port map(A => REGl187r, B => \I3.un16_ael34r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl34r);
    
    \I2.VDBi_17_rl11r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1908_adt_net_45468_\, C => 
        \I2.N_1908_adt_net_45470_\, Y => \I2.VDBi_17l11r\);
    
    \I2.REG_1l71r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_444_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl71r);
    
    \I1.AIR_COMMAND_21_0_ivl8r\ : AO21TTF
      port map(A => \I1.sstate2l7r_net_1\, B => \I1.N_256\, C => 
        \I1.AIR_COMMAND_21_0_iv_0l8r_net_1\, Y => 
        \I1.AIR_COMMAND_21l8r\);
    
    \I2.PIPEA_8_rl3r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl3r, C => 
        \I2.PIPEA_8l3r_adt_net_57464_\, Y => \I2.PIPEA_8l3r\);
    
    \I2.VDBI_86_0_IV_0L18R_338\ : AND2
      port map(A => \I2.VDBil18r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il18r_adt_net_41881_\);
    
    \I2.DS_i_a2\ : OR2
      port map(A => DS0B_c, B => DS1B_c, Y => \I2.DS_i_a2_net_1\);
    
    \I2.REG_1_190_e_0\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl20r_net_1\, Y => \I2.N_3175_i_0\);
    
    \I10.BNC_CNT_209\ : MUX2H
      port map(A => \I10.BNC_CNTl11r_net_1\, B => 
        \I10.BNC_CNT_4l11r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_209_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I4_G0N\ : AND2
      port map(A => \I10.N_2519_1\, B => \I10.REGl36r\, Y => 
        \I10.N220\);
    
    \I10.CNT_10_I_0_O3_0L0R_143\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_pog_array_1l0r\, B => 
        \I10.STATE1l7r_net_1\, Y => 
        \I10.CNT_10_i_0_o3_0l0r_adt_net_15944_\);
    
    \I2.VADml18r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl18r_net_1\, Y
         => \I2.VADml18r_net_1\);
    
    \I10.BNCRES_CNT_4_G\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_11l0r_adt_net_16569_\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_11l0r\);
    
    \I2.VDBI_17_0L15R_344\ : NOR3FFT
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl15r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1912_adt_net_42454_\);
    
    \I2.VDBI_17_0L10R_365\ : AND2FT
      port map(A => \I10.REGl42r\, B => \I2.REGMAPl6r_net_1\, Y
         => \I2.N_1907_adt_net_46224_\);
    
    \I2.TCNT3_i_0_il0r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.DWACT_ADD_CI_0_partial_sum_1l0r\, Q => 
        \I2.TCNT3_i_0_il0r_net_1\);
    
    \I2.STATE1l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE1_nsl7r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => \I2.STATE1l2r_net_1\);
    
    \I2.VDBil14r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_590_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil14r_net_1\);
    
    LB_padl15r : IOB33PH
      port map(PAD => LB(15), A => \I2.LB_il15r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl15r);
    
    SP_PDL_padl1r : IOB33PH
      port map(PAD => SP_PDL(1), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl1r);
    
    \I10.BNC_CNT_4_0_a2l19r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => 
        \I10.I_122\, Y => \I10.BNC_CNT_4l19r\);
    
    \I2.LB_sl28r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl28r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl28r_Rd1__net_1\);
    
    \I10.EVENT_DWORD_142\ : MUX2H
      port map(A => \I10.EVENT_DWORDl9r_net_1\, B => 
        \I10.EVENT_DWORD_18l9r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_142_net_1\);
    
    \I2.PULSE_1l9r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_43_f0l9r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => PULSEl9r);
    
    \I10.FID_193\ : MUX2L
      port map(A => \I10.FID_8l28r\, B => \I10.FIDl28r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_193_net_1\);
    
    \I2.STATE5L3R_506\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl1r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L3R_98\);
    
    \I2.REG_1_164\ : MUX2L
      port map(A => REGl174r, B => VDB_inl5r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_164_net_1\);
    
    \I10.un1_STATE1_15_0_0_0_0_o2_0\ : OR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.STATE1l1r_net_1\, Y => \I10.N_2351\);
    
    \I2.REG_1_ml163r\ : NAND2
      port map(A => REGl163r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml163r_net_1\);
    
    \I2.REG_1l281r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_244_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl281r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I76_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => REG_i_0l44r, Y => 
        \I10.ADD_16x16_medium_I76_Y_0\);
    
    RSELC1_pad : OTB33PH
      port map(PAD => RSELC1, A => REGl427r, EN => REG_i_0l443r);
    
    \I3.AEl3r\ : MUX2L
      port map(A => REGl156r, B => \I3.un16_ael3r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl3r);
    
    PWR_i : PWR
      port map(Y => \VCC\);
    
    \I10.un3_bnc_cnt_I_19\ : AND2
      port map(A => \I10.BNC_CNTl3r_net_1\, B => 
        \I10.DWACT_FINC_El0r\, Y => \I10.N_77\);
    
    \I2.REG_1_ml165r\ : NAND2
      port map(A => REGl165r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml165r_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I66_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => REGl34r, Y => 
        \I10.ADD_16x16_medium_I66_Y_0\);
    
    \I3.un16_ae_18_1\ : OR2
      port map(A => \I3.un16_ae_1l43r\, B => \I3.un16_ae_1l30r\, 
        Y => \I3.un16_ae_1l26r\);
    
    \I1.SBYTEl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SBYTE_28_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SBYTEl0r_net_1\);
    
    \I2.REG_1l284r_68\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_247_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL284R_52\);
    
    \I2.PIPEA_8_rl19r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl19r, C => 
        \I2.PIPEA_8l19r_adt_net_56307_\, Y => \I2.PIPEA_8l19r\);
    
    SYNC_padl13r : OB33PH
      port map(PAD => SYNC(13), A => REG_cl246r);
    
    \I2.VDBi_56l27r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l27r_net_1\, Y => \I2.VDBi_56l27r_net_1\);
    
    \I5.LOAD_RESi_5\ : OR2
      port map(A => LOAD_RES, B => \I5.sstatel5r_net_1\, Y => 
        \I5.LOAD_RESi_5_net_1\);
    
    LOS_pad : IB33
      port map(PAD => LOS, Y => LOS_c);
    
    \I2.TCNT1l3r\ : DFF
      port map(CLK => CLKOUT, D => \I2.I_13_2\, Q => 
        \I2.TCNT1l3r_net_1\);
    
    \I2.VDBi_24l6r\ : MUX2L
      port map(A => \I2.REGl480r\, B => \I2.VDBi_19l6r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l6r_net_1\);
    
    \I2.REG_1_256\ : MUX2L
      port map(A => \I2.REGL293R_61\, B => VDB_inl28r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_256_net_1\);
    
    LB_padl17r : IOB33PH
      port map(PAD => LB(17), A => \I2.LB_il17r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl17r);
    
    \I2.VDBi_54_0_iv_0l5r\ : AO21
      port map(A => REGl254r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il5r_adt_net_50518_\, Y => 
        \I2.VDBi_54_0_iv_0_il5r\);
    
    \I10.UN6_BNC_RES_NE_11_146\ : OR3
      port map(A => \I10.un6_bnc_res_1_i_i\, B => 
        \I10.BNC_CNT_i_il12r\, C => \I10.BNC_CNTl15r_net_1\, Y
         => \I10.un6_bnc_res_NE_11_i_adt_net_16263_\);
    
    \I2.REG_1_148\ : MUX2L
      port map(A => REGl158r, B => VDB_inl5r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_148_net_1\);
    
    \I2.REG_1l98r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_471_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl98r);
    
    \I1.COMMAND_11\ : MUX2H
      port map(A => \I1.COMMANDl15r_net_1\, B => 
        \I1.COMMAND_4l15r_net_1\, S => \I1.sstatel13r_net_1\, Y
         => \I1.COMMAND_11_net_1\);
    
    LB_padl26r : IOB33PH
      port map(PAD => LB(26), A => \I2.LB_il26r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl26r);
    
    \I10.FID_8_RL16R_187\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl16r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il16r\, Y => 
        \I10.FID_8l16r_adt_net_22788_\);
    
    \I2.VDBI_86_0_IV_0L23R_329\ : AND2
      port map(A => \I2.VDBil23r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il23r_adt_net_40828_\);
    
    \I2.PIPEA_8_RL20R_433\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l20r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l20r_adt_net_56237_\);
    
    \I2.REG_1_387_e\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl33r_net_1\, Y => \I2.N_3559_i\);
    
    \I2.VDBi_86_iv_0l10r\ : AOI21TTF
      port map(A => \I2.VDBil10r_net_1\, B => 
        \I2.STATE1l2r_net_1\, C => \I2.VDBi_85_ml10r_net_1\, Y
         => \I2.VDBi_86_iv_0l10r_net_1\);
    
    \I2.PIPEB_49\ : MUX2H
      port map(A => \I2.PIPEBl0r_net_1\, B => \I2.N_2569\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_49_net_1\);
    
    \I10.EVNT_NUM_3_I_68\ : AND2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_2_1l0r\, B => 
        \I10.DWACT_ADD_CI_0_pog_array_1_1_0l0r\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_11_0l0r\);
    
    \I10.FIDl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_177_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl12r_net_1\);
    
    \I10.UN1_CNT_1_G_1_0_142\ : AND3FTT
      port map(A => \I10.G_1_0_0_i\, B => 
        \I10.DWACT_ADD_CI_0_pog_array_1l0r\, C => 
        \I10.CNTl0r_net_1\, Y => \I10.G_1_0_adt_net_15904_\);
    
    \I3.un16_ae_2\ : AND2FT
      port map(A => \I3.un16_ae_1l43r\, B => \I3.un16_ae_1l4r\, Y
         => \I3.un16_ael2r\);
    
    \I10.BNCRES_CNT_4_G_1_0\ : NOR3FFT
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => 
        \I10.BNCRES_CNTl0r_net_1\, C => 
        \I10.G_2_i_adt_net_16541_\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_1_0l0r\);
    
    \I1.COMMAND_4l0r\ : MUX2H
      port map(A => REGl89r, B => \I1.AIR_COMMANDl0r_net_1\, S
         => REGL7R_2, Y => \I1.COMMAND_4l0r_net_1\);
    
    \I10.EVENT_DWORD_18_rl29r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l29r_net_1\, B => 
        \I10.EVENT_DWORD_18l29r_adt_net_24986_\, Y => 
        \I10.EVENT_DWORD_18l29r\);
    
    \I2.VDBI_54_0_IV_2L8R_375\ : AND2
      port map(A => REGl193r, B => \I2.REGMAPl20r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2_il8r_adt_net_48130_\);
    
    \I2.VDBI_54_0_IV_1L3R_402\ : AND2
      port map(A => SYNC_cl3r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il3r_adt_net_52166_\);
    
    \I2.un74_reg_ads_0_a2_0_a2\ : NOR3
      port map(A => \I2.N_3064\, B => \I2.N_3006_1\, C => 
        \I2.N_3001_1\, Y => \I2.un74_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.VDBI_86_0_IV_0L30R_315\ : AND2
      port map(A => \I2.VDBil30r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il30r_adt_net_39393_\);
    
    \I2.PIPEA_8_rl18r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl18r, C => 
        \I2.PIPEA_8l18r_adt_net_56377_\, Y => \I2.PIPEA_8l18r\);
    
    \I2.VDBI_61L7R_379\ : AND2FT
      port map(A => \I2.VDBi_61_sl0r_net_1\, B => 
        \I2.VDBi_61_dl7r_net_1\, Y => 
        \I2.VDBi_61l7r_adt_net_49043_\);
    
    \I2.LB_i_483\ : MUX2L
      port map(A => \I2.LB_il5r_Rd1__net_1\, B => 
        \I2.LB_i_7l5r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__88\, Y => \I2.LB_il5r\);
    
    \I3.un16_ae_37\ : NOR3
      port map(A => \I3.un16_ae_1l47r\, B => \I3.un16_ae_1l45r\, 
        C => \I3.un16_ae_1l39r\, Y => \I3.un16_ael37r\);
    
    \I2.LB_i_497\ : MUX2L
      port map(A => \I2.LB_il19r_Rd1__net_1\, B => 
        \I2.LB_i_7l19r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__81\, Y => \I2.LB_il19r\);
    
    \I10.CRC32l29r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_116_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l29r_net_1\);
    
    \I2.VDBI_67L1R_472\ : MUX2L
      port map(A => \I2.VDBi_67_dl1r_net_1\, B => 
        \I2.VDBi_56l1r_adt_net_93309_\, S => 
        \I2.VDBi_67_sl0r_net_1\, Y => 
        \I2.VDBi_67l1r_adt_net_95714_\);
    
    \I2.un106_reg_ads_0_a2_0_a2\ : AND2FT
      port map(A => \I2.N_3013_1\, B => 
        \I2.un106_reg_ads_0_a2_0_a2_adt_net_37438_\, Y => 
        \I2.un106_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.REG_1l464r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_379_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl464r);
    
    \I2.PULSE_43_F1L6R_455\ : AO21TTF
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => \I2.N_1717\, 
        C => \I2.REGMAPl10r_net_1\, Y => 
        \I2.PULSE_43_f1l6r_adt_net_71125_\);
    
    \I2.REG3_120\ : MUX2L
      port map(A => VDB_inl13r, B => \I2.REGl13r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_120_net_1\);
    
    \I1.BITCNTl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.BITCNT_10l0r\, CLR => 
        HWRES_c_2_0, Q => \I1.BITCNT_i_il0r\);
    
    \I10.FID_8_iv_0_0_0_0l23r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl7r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il23r_adt_net_21643_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il23r\);
    
    \I2.VDBi_19l18r\ : AND2
      port map(A => TST_cl5r, B => REGl66r, Y => 
        \I2.VDBi_19l18r_net_1\);
    
    \I10.BNC_NUMBERl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_237_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl7r_net_1\);
    
    VAD_padl15r : IOB33PH
      port map(PAD => VAD(15), A => \I2.VADml15r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl15r);
    
    \I2.VDBi_54_0_iv_3l15r\ : AO21TTF
      port map(A => REG_cl136r, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l15r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il15r\);
    
    \I2.PURGED\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PURGED_13_net_1\, SET => 
        \I2.un2_clear_i\, Q => \I2.PURGED_net_1\);
    
    \I1.I2C_RDATA_18\ : MUX2L
      port map(A => I2C_RDATAl4r, B => \I1.N_582\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_18_net_1\);
    
    \I10.CNT_10_i_0l1r\ : AND2
      port map(A => \I10.N_2287\, B => \I10.I_21\, Y => 
        \I10.CNT_10_i_0l1r_net_1\);
    
    \I10.FIDl21r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_186_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl21r_net_1\);
    
    \I5.ISI\ : DFFC
      port map(CLK => CLKOUT, D => \I5.ISI_14_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.ISI_net_1\);
    
    \I2.REG_1l453r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_368_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl453r\);
    
    \I10.OR_RADDR_222\ : MUX2H
      port map(A => \I10.CNTl4r_net_1\, B => 
        \I10.OR_RADDRl4r_net_1\, S => \I10.N_2126\, Y => 
        \I10.OR_RADDR_222_net_1\);
    
    AE_PDL_padl28r : OB33PH
      port map(PAD => AE_PDL(28), A => AE_PDL_cl28r);
    
    \I2.VDBi_70_s_0l0r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_70_sl0r_net_1\, Y => \I2.VDBi_70_s_0l0r_net_1\);
    
    \I2.PIPEA_8_RL2R_451\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l2r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l2r_adt_net_57534_\);
    
    \I3.un16_ae_10_1\ : OR2
      port map(A => \I3.un16_ae_1l43r\, B => \I3.un16_ae_1l15r\, 
        Y => \I3.un16_ae_1l11r\);
    
    \I2.REG_1_475\ : MUX2H
      port map(A => VDB_inl13r, B => REGl102r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_475_net_1\);
    
    \I3.un16_ae_32_1\ : OR2
      port map(A => \I3.un16_ae_1l46r\, B => \I3.un16_ae_1l41r\, 
        Y => \I3.un16_ae_1l40r\);
    
    \I2.VDBml12r\ : MUX2L
      port map(A => \I2.VDBil12r_net_1\, B => \I2.N_2053\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml12r_net_1\);
    
    \I3.un4_so_27_0\ : MUX2L
      port map(A => SP_PDL_inl25r, B => \I3.N_222\, S => REGl126r, 
        Y => \I3.N_223\);
    
    \I2.VASl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_96_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl14r_net_1\);
    
    \I2.REG_1_222\ : MUX2L
      port map(A => VDB_inl10r, B => REGl259r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_222_net_1\);
    
    \I2.REG_1_179\ : MUX2L
      port map(A => REGl189r, B => VDB_inl4r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_179_net_1\);
    
    \I2.REG_1_185\ : MUX2L
      port map(A => REGl195r, B => VDB_inl10r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_185_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I18_Y\ : AO21FTF
      port map(A => \I10.REGl42r\, B => REG_i_0l43r, C => 
        \I10.N_2519_1\, Y => \I10.N257_i\);
    
    \I2.un102_reg_ads_0_a2_0_a2_1\ : OR2
      port map(A => \I2.LWORDS_net_1\, B => \I2.VASl2r_net_1\, Y
         => \I2.N_3009_1\);
    
    \I2.VDBi_61_dl6r\ : MUX2L
      port map(A => LBSP_inl6r, B => REGl383r, S => 
        \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61_dl6r_net_1\);
    
    \I2.REG_1_166\ : MUX2L
      port map(A => REGl176r, B => VDB_inl7r, S => 
        \I2.N_3143_i_0\, Y => \I2.REG_1_166_net_1\);
    
    \I10.FID_8_rl7r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l7r_adt_net_23903_\, Y => \I10.FID_8l7r\);
    
    \I2.REG_1l457r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_372_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl457r);
    
    NOE64R_pad : OB33PH
      port map(PAD => NOE64R, A => NOEAD_c_i_0);
    
    \I2.REG_1l479r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_394_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl479r\);
    
    \I10.EVNT_NUM_3_I_41\ : XOR2
      port map(A => \I10.EVNT_NUMl7r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_12_2l0r\, Y => 
        \I10.EVNT_NUM_3l7r\);
    
    AE_PDL_padl17r : OB33PH
      port map(PAD => AE_PDL(17), A => AE_PDL_cl17r);
    
    \I2.PIPEA1l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_513_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l2r_net_1\);
    
    \I10.un1_I2C_RREQ_1_sqmuxa_0_0_0_a2\ : NOR2FT
      port map(A => \I10.STATE1l7r_net_1\, B => \I10.N_2297\, Y
         => \I10.N_2356\);
    
    \I2.WDOGRES\ : DFFC
      port map(CLK => CLKOUT, D => \I2.WDOGRES_98_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.WDOGRES_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_1l22r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl30r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l22r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l22r_net_1\);
    
    \I2.VASl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_85_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl3r_net_1\);
    
    \I10.FIDl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_167_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl2r_net_1\);
    
    \I2.PIPEA_8_sl30r\ : OR2FT
      port map(A => \I2.N_2830_4\, B => 
        \I2.PIPEA_8l30r_adt_net_55507_\, Y => \I2.PIPEA_8l30r\);
    
    \I3.un4_so_42_0\ : MUX2L
      port map(A => SP_PDL_inl47r, B => SP_PDL_inl15r, S => 
        REGl127r, Y => \I3.N_238\);
    
    MD_PDL_pad : OB33PH
      port map(PAD => MD_PDL, A => MD_PDL_C_22);
    
    SYNC_padl2r : OB33PH
      port map(PAD => SYNC(2), A => SYNC_cl2r);
    
    \I5.ISI_14\ : MUX2L
      port map(A => \I5.ISI_net_1\, B => \I5.ISI_5\, S => 
        \I5.N_210\, Y => \I5.ISI_14_net_1\);
    
    \I2.WDOG_3_I_18\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_1_1l0r\, B => 
        \I2.WDOGl2r_net_1\, Y => \I2.WDOG_3l2r\);
    
    \I2.REG_1l255r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_218_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl255r);
    
    \I8.SWORD_5l1r\ : MUX2L
      port map(A => REGl250r, B => \I8.SWORDl0r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l1r_net_1\);
    
    \I2.PIPEAl21r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_565_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl21r_net_1\);
    
    \I2.un19_evreadi_0_o3\ : OR2
      port map(A => \I2.MBLTCYC_net_1\, B => \I2.BLTCYC_17\, Y
         => \I2.N_2829\);
    
    \I2.REG_1_369\ : MUX2H
      port map(A => VDB_inl13r, B => \I2.REGl454r\, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_369_net_1\);
    
    \I2.NRDMEBI_543_473\ : OR3
      port map(A => \I2.N_2821_0\, B => \I2.N_2823\, C => 
        \I2.N_2858\, Y => \I2.NRDMEBi_543_adt_net_100728_\);
    
    \I2.VDBm_0l23r\ : MUX2L
      port map(A => \I2.PIPEAl23r_net_1\, B => 
        \I2.PIPEBl23r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2064\);
    
    \I5.un1_RESCNT_G_1_1\ : AND2FT
      port map(A => \I5.G_1_1_3_i\, B => 
        \I5.DWACT_ADD_CI_0_g_array_11_2l0r_adt_net_33417_\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_11_2l0r\);
    
    \I2.LB_s_29\ : MUX2L
      port map(A => \I2.LB_sl15r_Rd1__net_1\, B => 
        \I2.N_3050_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116352_Rd1__net_1\, Y => 
        \I2.LB_sl15r\);
    
    \I2.PIPEAl30r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEA_574_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEAl30r_net_1\);
    
    \I2.STATE5L4R_ADT_NET_116400_RD1__481\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_NS_I_IL0R_94\, 
        SET => HWRES_c_2_0, Q => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__66\);
    
    \I2.LB_sl10r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl10r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl10r_Rd1__net_1\);
    
    \I10.FIDl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_165_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl0r_net_1\);
    
    VDB_padl24r : IOB33PH
      port map(PAD => VDB(24), A => \I2.VDBml24r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl24r);
    
    \I2.VDBi_85_ml8r\ : NAND3
      port map(A => \I2.VDBil8r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml8r_net_1\);
    
    \I2.VDBi_61_sl0r\ : NOR2
      port map(A => \I2.REGMAPl30r_net_1\, B => 
        \I2.REGMAPl29r_net_1\, Y => \I2.VDBi_61_sl0r_net_1\);
    
    \I2.un7_noe32ri_i_0_i_0\ : AO21FTT
      port map(A => \I2.LWORDS_net_1\, B => \I2.N_2983_1\, C => 
        NOEAD_C_0_0_21, Y => \I2.N_2732_0\);
    
    \I2.VDBm_0l19r\ : MUX2L
      port map(A => \I2.PIPEAl19r_net_1\, B => 
        \I2.PIPEBl19r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2060\);
    
    \I2.REG_1l410r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_325_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl410r);
    
    \I2.NRDMEBi_543\ : AO21
      port map(A => NRDMEB, B => \I2.N_2368\, C => 
        \I2.NRDMEBi_543_adt_net_57947_\, Y => 
        \I2.NRDMEBi_543_net_1\);
    
    \I2.NOEDTKi_39\ : DFFS
      port map(CLK => CLKOUT, D => \I2.NOEDTKi_103_net_1\, SET
         => \I2.N_2483_i_0_0_0\, Q => TST_C_CL3R_23);
    
    \I8.sstate_ns_i_a2_2l0r\ : OA21FTT
      port map(A => \I8.BITCNTl0r_net_1\, B => 
        \I8.sstate_ns_i_a2_1_il0r_adt_net_5385_\, C => 
        \I8.sstatel1r_net_1\, Y => \I8.sstate_ns_i_a2_2_il0r\);
    
    \I2.VDBi_54_0_iv_2l0r\ : AO21
      port map(A => REGl169r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.VDBi_54_0_iv_2_il0r_adt_net_55003_\, Y => 
        \I2.VDBi_54_0_iv_2_il0r\);
    
    \I10.CRC32_3_i_0_0_x3l13r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl13r_net_1\, B => 
        \I10.CRC32l13r_net_1\, Y => \I10.N_2326_i_i_0\);
    
    \I2.REG_il447r\ : INV
      port map(A => \I2.REGl447r\, Y => REG_i_0l447r);
    
    \I10.BNC_CNT_211\ : MUX2H
      port map(A => \I10.BNC_CNT_i_il13r\, B => 
        \I10.BNC_CNT_4l13r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_211_net_1\);
    
    \I10.BNCRES_CNTl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNCRES_CNT_4l8r\, CLR => 
        CLEAR_0_0, Q => \I10.BNCRES_CNTl8r_net_1\);
    
    AMB_padl3r : IB33
      port map(PAD => AMB(3), Y => AMB_cl3r);
    
    \I5.DRIVECS_36\ : DFFC
      port map(CLK => CLKOUT, D => \I5.DRIVECS_2_net_1\, CLR => 
        HWRES_c_2_0, Q => \I5.DRIVECS_20\);
    
    \I2.VDBm_0l30r\ : MUX2L
      port map(A => \I2.PIPEAl30r_net_1\, B => 
        \I2.PIPEBl30r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2071\);
    
    \I2.STATE2l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE2_nsl5r\, CLR => 
        CLEAR_0_0, Q => \I2.STATE2l0r_net_1\);
    
    \I8.SWORDl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_7_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl6r_net_1\);
    
    \I5.SBYTEl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.SBYTE_8_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => FBOUTl2r);
    
    \I2.REG_1_125\ : MUX2H
      port map(A => REGL123R_6, B => VDB_inl2r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_125_net_1\);
    
    \I1.SBYTEl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SBYTE_35_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SBYTEl7r_net_1\);
    
    \I10.BNCRES_CNT_4_I_32\ : XOR2
      port map(A => \I10.BNCRES_CNTl1r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_TMP_0l0r\, Y => \I10.BNCRES_CNT_4l1r\);
    
    \I10.CRC32_3_i_0_0l12r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2333_i_i_0\, Y => \I10.N_1462\);
    
    \I2.REG_1_200\ : MUX2L
      port map(A => SYNC_cl4r, B => VDB_inl4r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_200_net_1\);
    
    \I1.sstatel4r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el9r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstatel4r_net_1\);
    
    \I10.FID_191\ : MUX2L
      port map(A => \I10.FID_8l26r\, B => \I10.FIDl26r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_191_net_1\);
    
    \I3.un4_so_41_0\ : MUX2L
      port map(A => SP_PDL_inl23r, B => SP_PDL_inl21r, S => 
        REGl123r, Y => \I3.N_237\);
    
    \I2.REG_1l435r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_350_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl435r\);
    
    \I1.sstatese_13\ : OR2
      port map(A => \I1.N_455_i\, B => 
        \I1.sstate_ns_el0r_adt_net_7201_\, Y => 
        \I1.sstate_ns_el0r\);
    
    \I2.LB_i_7_rl1r\ : AND2FT
      port map(A => \I2.STATE5L4R_ADT_NET_116400_RD1__68\, B => 
        \I2.N_1888\, Y => \I2.LB_i_7l1r_net_1\);
    
    \I2.REG_1_435\ : MUX2H
      port map(A => VDB_inl14r, B => REGl62r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_435_net_1\);
    
    \I2.STATE2l5r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.STATE2_nsl0r_net_1\, SET
         => CLEAR_0_0, Q => \I2.STATE2l5r_net_1\);
    
    \I2.REG_1_308\ : MUX2L
      port map(A => REGl393r, B => VDB_inl0r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_308_net_1\);
    
    \I2.REG_1_458\ : MUX2H
      port map(A => REGl85r, B => \I2.REG_92l85r_net_1\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_458_net_1\);
    
    \I2.REG_1_144\ : MUX2L
      port map(A => REGl154r, B => VDB_inl1r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_144_net_1\);
    
    \I1.AIR_COMMAND_42\ : MUX2L
      port map(A => \I1.AIR_COMMANDl10r_net_1\, B => 
        \I1.AIR_COMMAND_21l10r\, S => \I1.un1_tick_12_net_1\, Y
         => \I1.AIR_COMMAND_42_net_1\);
    
    \I1.I2C_RDATAl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_20_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl6r);
    
    \I5.un1_RESCNT_G_1_4\ : XOR2
      port map(A => \I5.RESCNTl15r_net_1\, B => \I5.G_1_3\, Y => 
        \I5.G_1_4\);
    
    \I2.PIPEA_570\ : MUX2L
      port map(A => \I2.PIPEAl26r_net_1\, B => \I2.PIPEA_8l26r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_570_net_1\);
    
    \I2.PIPEA1_538\ : MUX2L
      port map(A => \I2.PIPEA1l27r_net_1\, B => \I2.N_2551\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_538_net_1\);
    
    \I2.un119_reg_ads_0_a2_1\ : NOR2
      port map(A => \I2.N_3013_1\, B => \I2.N_3013_2\, Y => 
        \I2.N_3013_3\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_4l1r\ : OR3
      port map(A => \I10.CNTl5r_net_1\, B => \I10.N_2296\, C => 
        \I10.N_2303\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_a2_4l1r_net_1\);
    
    \I2.TCNT3_2_I_39\ : AND3
      port map(A => \I2.DWACT_ADD_CI_0_g_array_2_0l0r\, B => 
        \I2.TCNT3_i_0_il4r_net_1\, C => \I2.TCNT3l5r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_g_array_11_0l0r\);
    
    \I8.un1_sstate_6_i\ : OR2
      port map(A => \I8.N_207_i\, B => \I8.N_219\, Y => 
        \I8.N_180\);
    
    \I2.PULSE_43_f0l8r\ : OA21TTF
      port map(A => \I2.PULSE_1_sqmuxa_8_0_net_1\, B => PULSEl8r, 
        C => \I2.STATE1l6r_net_1\, Y => \I2.PULSE_43_f0l8r_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_0_a3l2r\ : OR2
      port map(A => \I10.CNTl5r_net_1\, B => \I10.CNTl3r_net_1\, 
        Y => \I10.N_2650\);
    
    DIR_CTTM_padl3r : OB33PH
      port map(PAD => DIR_CTTM(3), A => \VCC\);
    
    \I2.REG_1l49r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_422_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl49r);
    
    \I2.VDBI_86_0_IVL31R_314\ : AO21
      port map(A => \I2.PIPEAl31r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il31r\, Y => 
        \I2.VDBi_86_0l31r_adt_net_39227_\);
    
    \I2.VADml20r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl20r_net_1\, Y
         => \I2.VADml20r_net_1\);
    
    \I2.TCNT3_2_I_33\ : XOR2
      port map(A => \I2.TCNT3l5r_net_1\, B => 
        \I2.DWACT_ADD_CI_0_g_array_12_1_0l0r\, Y => 
        \I2.TCNT3_2l5r\);
    
    \I2.PIPEBl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_63_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl14r_net_1\);
    
    \I2.VDBi_61l30r\ : MUX2L
      port map(A => LBSP_inl30r, B => \I2.VDBi_56l30r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l30r_net_1\);
    
    \I10.L1AF2\ : DFFC
      port map(CLK => ACLKOUT, D => \I10.L1AF1_net_1\, CLR => 
        HWRES_c_2_0, Q => \I10.L1AF2_net_1\);
    
    \I2.VDBI_86_0_IV_0L22R_331\ : AND2
      port map(A => \I2.VDBil22r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il22r_adt_net_41033_\);
    
    \I2.VDBi_578\ : MUX2L
      port map(A => \I2.VDBil2r_net_1\, B => \I2.VDBi_86l2r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_578_net_1\);
    
    \I10.G_0\ : AND2FT
      port map(A => \I10.un1_CNT_1_il6r\, B => \I10.N_2287\, Y
         => \I10.G_0_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l11r\ : OR2
      port map(A => LB_inl11r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__69\, Y => \I2.N_3046\);
    
    \I10.CRC32_3_i_0_0_x3l23r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl23r_net_1\, B => 
        \I10.CRC32l23r_net_1\, Y => \I10.N_2329_i_i_0\);
    
    \I5.SBYTEl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.SBYTE_11_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => FBOUTl5r);
    
    \I2.VDBi_54_0_iv_5l5r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il5r\, B => 
        \I2.VDBi_54_0_iv_0_il5r\, C => \I2.VDBi_54_0_iv_1_il5r\, 
        Y => \I2.VDBi_54_0_iv_5_il5r\);
    
    \I2.REG_1l445r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_360_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl445r\);
    
    \I2.PIPEA1l13r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_524_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l13r_net_1\);
    
    \I2.LB_il3r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il3r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il3r_Rd1__net_1\);
    
    \I8.SWORD_5l11r\ : MUX2L
      port map(A => REGl260r, B => \I8.SWORDl10r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l11r_net_1\);
    
    \I2.REG_1_199\ : MUX2L
      port map(A => SYNC_cl3r, B => VDB_inl3r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_199_net_1\);
    
    \I10.UN2_I2C_CHAIN_0_I_I_I_3L4R_283\ : NOR3
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2296\, C => 
        \I10.N_2294\, Y => 
        \I10.un2_i2c_chain_0_i_i_i_3_il4r_adt_net_30702_\);
    
    \I2.VDBi_86_0_ivl29r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl29r\, C
         => \I2.VDBi_86l29r_adt_net_39637_\, Y => 
        \I2.VDBi_86l29r\);
    
    \I10.EVNT_NUM_3_I_55\ : AND2
      port map(A => \I10.EVNT_NUMl6r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_11_0l0r\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_12_2l0r\);
    
    \I10.CRC32l9r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_96_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l9r_net_1\);
    
    \I2.TCNT3l7r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT3_2l7r\, Q => 
        \I2.TCNT3l7r_net_1\);
    
    \I3.SBYTE_5l6r\ : MUX2H
      port map(A => REG_cl135r, B => REGl142r, S => 
        \I3.sstatel0r_net_1\, Y => \I3.SBYTE_5l6r_net_1\);
    
    \I10.FID_4_0_a2l11r\ : XOR2FT
      port map(A => \I10.CRC32l7r_net_1\, B => 
        \I10.FID_4_0_a2_0l11r_net_1\, Y => \I10.FID_4_il11r\);
    
    \I10.EVENT_DWORD_18_i_0_0_a3_0_1l7r\ : NAND2FT
      port map(A => \I10.STATE1l4r_net_1\, B => 
        \I10.STATE1l5r_net_1\, Y => \I10.N_2635_i_1\);
    
    \I2.EVREADi\ : DFFC
      port map(CLK => CLKOUT, D => \I2.EVREADi_142_net_1\, CLR
         => CLEAR_0_0, Q => EVREAD);
    
    LB_padl16r : IOB33PH
      port map(PAD => LB(16), A => \I2.LB_il16r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl16r);
    
    \I10.FID_176\ : MUX2L
      port map(A => \I10.FID_8l11r\, B => \I10.FIDl11r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_176_net_1\);
    
    \I5.un1_BITCNT_I_15\ : AND2
      port map(A => \I5.DWACT_ADD_CI_0_TMP_0l0r\, B => 
        \I5.BITCNTl1r_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_1_0l0r\);
    
    \I2.LB_s_35\ : MUX2L
      port map(A => \I2.LB_sl21r_Rd1__net_1\, B => 
        \I2.N_3030_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116348_Rd1__net_1\, Y => 
        \I2.LB_sl21r\);
    
    \I2.VDBi_22_dl0r\ : MUX2L
      port map(A => REGl80r, B => REGl48r, S => 
        \I2.REGMAP_i_0_il9r\, Y => \I2.VDBi_22_dl0r_net_1\);
    
    \I2.VDBi_584\ : MUX2L
      port map(A => \I2.VDBil8r_net_1\, B => \I2.VDBi_86l8r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_584_net_1\);
    
    \I2.VDBI_59L12R_360\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l12r_net_1\, C => \I2.VDBi_54_0_iv_5_il12r\, Y
         => \I2.VDBi_59l12r_adt_net_45068_\);
    
    P_PDL_padl1r : OB33PH
      port map(PAD => P_PDL(1), A => REG_cl130r);
    
    \I10.CRC32_3_i_0_0l2r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2331_i_i_0\, Y => \I10.N_1458\);
    
    \I1.AIR_COMMANDl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_39_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl2r_net_1\);
    
    VDB_padl13r : IOB33PH
      port map(PAD => VDB(13), A => \I2.VDBml13r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl13r);
    
    \I10.CRC32_3_i_0_0_x3l7r\ : XOR2FT
      port map(A => \I10.CRC32l7r_net_1\, B => 
        \I10.EVENT_DWORDl7r_net_1\, Y => \I10.N_2332_i_i_0\);
    
    VAD_padl1r : IOB33PH
      port map(PAD => VAD(1), A => \I2.VADml1r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl1r);
    
    \I10.CRC32_3_i_0_0l14r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2327_i_i_0\, Y => \I10.N_1358\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L0R_274\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl8r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l0r_adt_net_28657_\);
    
    \I2.VDBI_17_0L12R_357\ : AOI21
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl12r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1909_adt_net_44716_\);
    
    \I2.PIPEB_4_i_a2l29r\ : OR2FT
      port map(A => \I2.N_2847_1\, B => DPRl29r, Y => \I2.N_2881\);
    
    \I2.EVREAD_DS_1_sqmuxa_0\ : OA21FTT
      port map(A => \I2.N_2895_2\, B => \I2.N_2846\, C => 
        \I2.N_2883\, Y => \I2.EVREAD_DS_1_sqmuxa\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l6r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl6r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l6r_adt_net_27985_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l6r_net_1\);
    
    \I10.FID_8_IV_0_0_0_0L24R_171\ : AND2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.BNC_NUMBERl5r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il24r_adt_net_21479_\);
    
    \I2.un110_reg_ads_0_a2_0_a2\ : NOR3
      port map(A => \I2.N_3154_i\, B => \I2.N_3065\, C => 
        \I2.un110_reg_ads_0_a2_0_a2_1_i\, Y => 
        \I2.un110_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.REG3_122\ : MUX2L
      port map(A => VDB_inl15r, B => \I2.REGl15r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_122_net_1\);
    
    \I2.PULSE_1_99\ : MUX2H
      port map(A => PULSEl0r, B => \I2.PULSE_43l0r\, S => 
        \I2.un1_STATE1_18\, Y => \I2.PULSE_1_99_net_1\);
    
    \I1.un1_BITCNT_I_1\ : AND2
      port map(A => \I1.BITCNT_i_il0r\, B => 
        \I1.un1_tick_10_0_net_1\, Y => \I1.DWACT_ADD_CI_0_TMPl0r\);
    
    \I3.AEl18r\ : MUX2L
      port map(A => REGl171r, B => \I3.un16_ael18r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl18r);
    
    \I2.VDBi_54_0_iv_1l12r\ : AO21
      port map(A => REGl197r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il12r_adt_net_44992_\, Y => 
        \I2.VDBi_54_0_iv_1_il12r\);
    
    \I2.VADml25r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl25r_net_1\, Y
         => \I2.VADml25r_net_1\);
    
    \I2.un6_evrdy_i_0_o2\ : AOI21FTF
      port map(A => \I2.N_2831\, B => \I2.REGMAPl0r_net_1\, C => 
        EVRDY_c, Y => \I2.un6_evrdy_i\);
    
    \I10.BNC_CNTl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_208_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl10r_net_1\);
    
    \I1.AIR_COMMANDl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_43_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl11r_net_1\);
    
    \I10.EVENT_DWORDl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_144_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl11r_net_1\);
    
    \I2.LB_i_7_rl2r\ : AND2FT
      port map(A => \I2.STATE5L4R_ADT_NET_116400_RD1__67\, B => 
        \I2.N_1889\, Y => \I2.LB_i_7l2r_net_1\);
    
    \I8.SWORDl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_3_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl2r_net_1\);
    
    \I2.REG_1l283r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_246_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl283r\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l12r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl12r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l12r_adt_net_27238_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l12r_net_1\);
    
    \I2.STATE5l2r_adt_net_116440_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_106\, CLR
         => HWRES_c_2_0, Q => 
        \I2.STATE5l2r_adt_net_116440_Rd1__net_1\);
    
    \I1.SSTATE2SE_1_0_126\ : AND2
      port map(A => TICKl0r, B => \I1.sstate2l8r_net_1\, Y => 
        \I1.sstate2_ns_el2r_adt_net_8301_\);
    
    ADLTC_pad : OB33PH
      port map(PAD => ADLTC, A => \GND\);
    
    \I2.VDBml21r\ : MUX2L
      port map(A => \I2.VDBil21r_net_1\, B => \I2.N_2062\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml21r_net_1\);
    
    \I2.REG_1_146\ : MUX2L
      port map(A => REGl156r, B => VDB_inl3r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_146_net_1\);
    
    \I10.BNC_CNTl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_206_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl8r_net_1\);
    
    \I2.REG_1l197r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_187_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl197r);
    
    \I10.BNC_CNTl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_200_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl2r_net_1\);
    
    \I2.PIPEA_8_rl17r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl17r, C => 
        \I2.PIPEA_8l17r_adt_net_56447_\, Y => \I2.PIPEA_8l17r\);
    
    \I2.un1_STATE5_8_i_a2_0\ : AND2
      port map(A => \I2.WRITES_net_1\, B => \I2.N_2310_1\, Y => 
        \I2.N_2310_i_adt_net_76095_\);
    
    \I10.PDL_RREQ_131\ : MUX2H
      port map(A => \I10.PDL_RREQ_net_1\, B => 
        \I10.STATE1l8r_net_1\, S => \I10.un1_PDL_RADDR_1_sqmuxa\, 
        Y => \I10.PDL_RREQ_131_net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_a2l4r\ : AND3FFT
      port map(A => \I10.CNTL2R_11\, B => \I10.CNTl0r_net_1\, C
         => \I10.N_2347_i_0\, Y => \I10.N_2520_i\);
    
    \I2.VDBI_17_0L13R_353\ : NOR3FFT
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl13r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1910_adt_net_43962_\);
    
    \I10.un2_evread_3_i_0_a2_0_1\ : OR2
      port map(A => \I10.REGl37r\, B => REGl34r, Y => 
        \I10.un2_evread_3_i_0_a2_0_1_i\);
    
    \I10.FID_8_0_iv_0_0_0_a2_0l29r\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl77r, Y => 
        \I10.N_2503_i\);
    
    \I2.REG_1_349\ : MUX2H
      port map(A => VDB_inl9r, B => \I2.REGl434r\, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_349_net_1\);
    
    \I10.EVENT_DWORD_18_rl13r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l13r_net_1\, B => 
        \I10.EVENT_DWORD_18l13r_adt_net_27156_\, Y => 
        \I10.EVENT_DWORD_18l13r\);
    
    \I2.VDBi_86_0_iv_0l29r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l29r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il29r_adt_net_39598_\, Y => 
        \I2.VDBi_86_0_iv_0_il29r\);
    
    \I10.BNC_NUMBERl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_238_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl8r_net_1\);
    
    \I2.VDBi_61l24r\ : MUX2L
      port map(A => LBSP_inl24r, B => \I2.VDBi_56l24r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l24r_net_1\);
    
    \I10.FID_8_0_iv_0_0_0_0l2r\ : AO21
      port map(A => \I10.STATE1L1R_14\, B => 
        \I10.EVENT_DWORDl2r_net_1\, C => 
        \I10.FID_8_0_iv_0_0_0_0_il2r_adt_net_24464_\, Y => 
        \I10.FID_8_0_iv_0_0_0_0_il2r\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_2l6r\ : NAND3FTT
      port map(A => \I10.CNTl4r_net_1\, B => \I10.CNTl5r_net_1\, 
        C => \I10.N_2376_1\, Y => \I10.N_2376\);
    
    \I10.un2_i2c_chain_0_0_0_0_3l1r\ : OAI21TTF
      port map(A => \I10.N_2302\, B => \I10.N_2727\, C => 
        \I10.un2_i2c_chain_0_0_0_0_3_il1r_adt_net_29650_\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_3_il1r\);
    
    \I2.REG_1_251\ : MUX2L
      port map(A => \I2.REGL288R_56\, B => VDB_inl23r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_251_net_1\);
    
    \I10.BNC_CNT_4_0_a2l12r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => \I10.I_73\, 
        Y => \I10.BNC_CNT_4l12r\);
    
    \I2.REG_1l200r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_190_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl200r);
    
    \I2.VDBi_601\ : MUX2L
      port map(A => \I2.VDBil25r_net_1\, B => \I2.VDBi_86l25r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_601_net_1\);
    
    \I5.un1_RESCNT_I_55\ : XOR2
      port map(A => \I5.RESCNTl4r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r_adt_net_33510_\, Y => 
        \I5.I_55\);
    
    \I2.VDBi_59l12r\ : AND2FT
      port map(A => \I2.VDBi_59_0l9r\, B => 
        \I2.VDBi_59l12r_adt_net_45068_\, Y => 
        \I2.VDBi_59l12r_net_1\);
    
    \I2.REG_1_175\ : MUX2L
      port map(A => REGl185r, B => VDB_inl0r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_175_net_1\);
    
    \I10.CRC32_112\ : MUX2H
      port map(A => \I10.CRC32l25r_net_1\, B => \I10.N_1592\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_112_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l4r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl4r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l4r_adt_net_28209_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l4r_net_1\);
    
    \I2.VDBi_67l2r\ : MUX2L
      port map(A => \I2.VDBi_61l2r_net_1\, B => \I2.N_1951\, S
         => \I2.N_1965\, Y => \I2.VDBi_67l2r_net_1\);
    
    \I10.BNCRES_CNT_4_G_1\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_2_0l0r_adt_net_16625_\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_2_0l0r\);
    
    \I2.LB_i_7l17r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l17r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l17r_Rd1__net_1\);
    
    \I1.sstate2se_6_i\ : MUX2H
      port map(A => \I1.sstate2l3r_net_1\, B => 
        \I1.sstate2l2r_net_1\, S => \I1.N_277_0\, Y => 
        \I1.sstate2se_6_i_net_1\);
    
    \I2.VDBI_86_0_IVL28R_320\ : AO21
      port map(A => \I2.PIPEAl28r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il28r\, Y => 
        \I2.VDBi_86l28r_adt_net_39842_\);
    
    \I2.REG_1_357\ : MUX2L
      port map(A => \I2.REGL442R_26\, B => VDB_inl1r, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_357_net_1\);
    
    \I2.PIPEA_558\ : MUX2L
      port map(A => \I2.PIPEAl14r_net_1\, B => \I2.PIPEA_8l14r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_558_net_1\);
    
    \I10.CRC32_3_i_0_0l31r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2330_i_i_0\, Y => \I10.N_1365\);
    
    \I2.LB_i_7l5r\ : MUX2L
      port map(A => VDB_inl5r, B => \I2.VASl5r_net_1\, S => 
        \I2.STATE5L1R_105\, Y => \I2.N_1892\);
    
    \I10.event_meb.M0\ : FIFO256x9SST
      port map(DO8 => OPEN, DO7 => DPRl7r, DO6 => DPRl6r, DO5 => 
        DPRl5r, DO4 => DPRl4r, DO3 => DPRl3r, DO2 => DPRl2r, DO1
         => DPRl1r, DO0 => DPRl0r, FULL => 
        \I10.event_meb.net00003\, EMPTY => OPEN, EQTH => OPEN, 
        GEQTH => OPEN, WPE => OPEN, RPE => OPEN, DOS => OPEN, 
        LGDEP2 => \VCC\, LGDEP1 => \VCC\, LGDEP0 => \VCC\, RESET
         => CLEAR_i_0, LEVEL7 => \GND\, LEVEL6 => \GND\, LEVEL5
         => \GND\, LEVEL4 => \GND\, LEVEL3 => \GND\, LEVEL2 => 
        \GND\, LEVEL1 => \GND\, LEVEL0 => \VCC\, DI8 => \GND\, 
        DI7 => \I10.FIDl7r_net_1\, DI6 => \I10.FIDl6r_net_1\, DI5
         => \I10.FIDl5r_net_1\, DI4 => \I10.FIDl4r_net_1\, DI3
         => \I10.FIDl3r_net_1\, DI2 => \I10.FIDl2r_net_1\, DI1
         => \I10.FIDl1r_net_1\, DI0 => \I10.FIDl0r_net_1\, WRB
         => \I10.WRB_net_1\, RDB => NRDMEB, WBLKB => \GND\, RBLKB
         => \GND\, PARODD => \GND\, WCLKS => CLKOUT, RCLKS => 
        CLKOUT, DIS => \GND\);
    
    \I2.VDBI_67L3R_404\ : AND2FT
      port map(A => \I2.N_1965\, B => \I2.N_1952\, Y => 
        \I2.VDBi_67l3r_adt_net_52325_\);
    
    \I2.PIPEB_66\ : MUX2H
      port map(A => \I2.PIPEBl17r_net_1\, B => \I2.N_2603\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_66_net_1\);
    
    \I1.I2C_RDATA_9_il1r\ : MUX2H
      port map(A => REGl120r, B => I2C_RDATAl1r, S => \I1.N_631\, 
        Y => \I1.N_576\);
    
    \I10.EVENT_DWORD_18_RL12R_251\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl22r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l12r_adt_net_27268_\);
    
    \I3.AEl43r\ : MUX2L
      port map(A => REGl196r, B => \I3.un16_ael43r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl43r);
    
    \I3.AEl4r\ : MUX2L
      port map(A => REGl157r, B => \I3.un16_ael4r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl4r);
    
    \I1.I2C_RDATA_15\ : MUX2L
      port map(A => I2C_RDATAl1r, B => \I1.N_576\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_15_net_1\);
    
    \I10.CRC32l24r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_111_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l24r_net_1\);
    
    \I2.REG_1_232\ : MUX2L
      port map(A => \I2.REGL269R_37\, B => VDB_inl4r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_232_net_1\);
    
    \I2.PIPEBl19r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_68_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl19r_net_1\);
    
    \I1.COMMAND_10\ : MUX2H
      port map(A => \I1.COMMANDl14r_net_1\, B => 
        \I1.COMMAND_4l14r_net_1\, S => \I1.sstatel13r_net_1\, Y
         => \I1.COMMAND_10_net_1\);
    
    \I10.EVENT_DWORD_18_RL18R_239\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl28r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l18r_adt_net_26596_\);
    
    \I2.VDBi_85_ml11r\ : NAND3
      port map(A => \I2.VDBil11r_net_1\, B => \I2.STATE1_i_il1r\, 
        C => \I2.N_1721_1\, Y => \I2.VDBi_85_ml11r_net_1\);
    
    \I2.VDBi_54_0_iv_1l14r\ : AO21
      port map(A => REGl199r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il14r_adt_net_43484_\, Y => 
        \I2.VDBi_54_0_iv_1_il14r\);
    
    \I10.FID_8_rl22r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il22r\, B => 
        \I10.FID_8_iv_0_0_0_0_il22r\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l22r\);
    
    LTM_DRDY_pad : OB33PH
      port map(PAD => LTM_DRDY, A => EVRDY_c);
    
    \I2.VDBm_0l20r\ : MUX2L
      port map(A => \I2.PIPEAl20r_net_1\, B => 
        \I2.PIPEBl20r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2061\);
    
    \I2.REG_1_0l126r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_128_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGL126R_4);
    
    \I2.un113_reg_ads_0_a2_0_a2_1\ : OR2
      port map(A => \I2.VASl2r_net_1\, B => \I2.N_3061\, Y => 
        \I2.N_3012_1\);
    
    \I2.PULSE_1_100\ : MUX2H
      port map(A => PULSEl1r, B => \I2.PULSE_43l1r\, S => 
        \I2.un1_STATE1_18\, Y => \I2.PULSE_1_100_net_1\);
    
    \I2.PIPEA_8_rl7r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl7r, C => 
        \I2.PIPEA_8l7r_adt_net_57184_\, Y => \I2.PIPEA_8l7r\);
    
    \I3.un16_ae_2_1\ : NOR2
      port map(A => \I3.un16_ae_1l15r\, B => \I3.un16_ae_1l6r\, Y
         => \I3.un16_ae_1l4r\);
    
    \I1.AIR_COMMAND_cnst_i_a2l2r\ : NAND3FTT
      port map(A => \I1.sstate2l1r_net_1\, B => 
        \I1.sstate2_0_sqmuxa_3\, C => \I1.sstate2_0_sqmuxa\, Y
         => \I1.N_487\);
    
    \I10.FID_8_iv_0_0_0_0l17r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl1r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il17r_adt_net_22627_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il17r\);
    
    \I1.AIR_COMMAND_21_0_ivl12r\ : AO21
      port map(A => \I1.sstate2l9r_net_1\, B => REGl101r, C => 
        \I1.N_565_i_i\, Y => \I1.AIR_COMMAND_21l12r\);
    
    \I10.BNCRES_CNT_4_I_30\ : XOR2
      port map(A => \I10.BNCRES_CNTl4r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_2_0l0r\, Y => 
        \I10.BNCRES_CNT_4l4r\);
    
    \I2.PIPEBl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_64_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl15r_net_1\);
    
    \I3.un4_so_45_0\ : MUX2L
      port map(A => \I3.N_240\, B => \I3.N_229\, S => REGl124r, Y
         => \I3.N_253\);
    
    SP_PDL_padl44r : IOB33PH
      port map(PAD => SP_PDL(44), A => REGl129r, EN => MD_PDL_c, 
        Y => SP_PDL_inl44r);
    
    \I2.VDBi_61_dl2r\ : MUX2L
      port map(A => LBSP_inl2r, B => \I2.VDBi_59_dl2r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61_dl2r_net_1\);
    
    \I2.REG_1l242r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_205_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl9r);
    
    \I2.PIPEA1l3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_514_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l3r_net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_0l4r\ : AOI21
      port map(A => \I10.CNTl1r_net_1\, B => \I10.N_2524_1\, C
         => \I10.N_2406\, Y => 
        \I10.un2_i2c_chain_0_i_i_i_0l4r_net_1\);
    
    \I10.EVENT_DWORDl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_148_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl15r_net_1\);
    
    \I3.un4_so_14_0\ : MUX2L
      port map(A => SP_PDL_inl42r, B => SP_PDL_inl10r, S => 
        REGl127r, Y => \I3.N_210\);
    
    \I10.BNC_NUMBER_235\ : MUX2L
      port map(A => \I10.BNCRES_CNTl5r_net_1\, B => 
        \I10.BNC_NUMBERl5r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_235_net_1\);
    
    \I3.AEl39r\ : MUX2L
      port map(A => REGl192r, B => \I3.un16_ael39r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl39r);
    
    \I3.BITCNTl2r\ : DFF
      port map(CLK => CLKOUT, D => \I3.un1_BITCNT_1_rl2r_net_1\, 
        Q => \I3.BITCNTl2r_net_1\);
    
    \I2.REG_1_411\ : MUX2H
      port map(A => VDB_inl22r, B => \I2.REGl496r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_411_net_1\);
    
    \I2.I_748_0_o3_0\ : NAND2
      port map(A => TST_cl2r, B => \I2.STATE2l1r_net_1\, Y => 
        \I2.N_2821_0\);
    
    \I10.EVENT_DWORD_18_rl9r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l9r_net_1\, B => 
        \I10.EVENT_DWORD_18l9r_adt_net_27604_\, Y => 
        \I10.EVENT_DWORD_18l9r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I70_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => REG_i_0l38r, Y => 
        \I10.ADD_16x16_medium_I70_Y_0\);
    
    \I2.VDBi_56l5r\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l5r_net_1\, C => \I2.VDBi_54_0_iv_5_il5r\, Y
         => \I2.VDBi_56l5r_adt_net_50636_\);
    
    GA_padl1r : IB33
      port map(PAD => GA(1), Y => GA_cl1r);
    
    \I10.un1_REG_1_ADD_16x16_medium_I12_P0N\ : NAND2FT
      port map(A => \I10.N_2519_1\, B => REG_i_0l44r, Y => 
        \I10.N245\);
    
    \I3.un1_BITCNT_1_rl1r\ : OA21
      port map(A => \I3.N_195\, B => \I3.I_13_3\, C => 
        \I3.un1_hwres_2_net_1\, Y => \I3.un1_BITCNT_1_rl1r_net_1\);
    
    \I2.REG_1_353\ : MUX2H
      port map(A => VDB_inl13r, B => \I2.REGl438r\, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_353_net_1\);
    
    SCL1_pad : OB33PH
      port map(PAD => SCL1, A => SCLB_i_a2);
    
    \I2.REG_1l135r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_137_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl135r);
    
    \I5.un1_RESCNT_I_100\ : AND3
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_1_3l0r\, B => 
        \I5.RESCNTl10r_net_1\, C => \I5.RESCNTl11r_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_pog_array_2_1l0r\);
    
    \I2.REG_1l180r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_170_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl180r);
    
    \I2.PIPEA_8_RL3R_450\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l3r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l3r_adt_net_57464_\);
    
    \I2.PIPEA1_524\ : MUX2L
      port map(A => \I2.PIPEA1l13r_net_1\, B => \I2.N_2523\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_524_net_1\);
    
    \I2.REG_1_135\ : MUX2H
      port map(A => REG_cl133r, B => VDB_inl12r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_135_net_1\);
    
    \I2.VDBi_54_0_iv_1l10r\ : AO21
      port map(A => REGl195r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il10r_adt_net_46500_\, Y => 
        \I2.VDBi_54_0_iv_1_il10r\);
    
    \I2.UN1_STATE2_16_0_1_295\ : OAI21FTF
      port map(A => \I2.STATE2l5r_net_1\, B => 
        \I2.N_2897_adt_net_36076_\, C => \I2.STATE2l2r_net_1\, Y
         => \I2.un1_STATE2_16_1_adt_net_36115_\);
    
    \I2.un25_tcnt_0_o3_2\ : OR3
      port map(A => \I2.TCNTl2r_net_1\, B => 
        \I2.TCNT_i_il0r_net_1\, C => \I2.TCNT_i_il1r_net_1\, Y
         => \I2.un25_tcnt_0_o3_2_i\);
    
    \I10.EVENT_DWORD_163\ : MUX2L
      port map(A => \I10.STATE1l5r_net_1\, B => 
        \I10.EVENT_DWORDl30r_net_1\, S => \I10.un1_STATE1_14_1_0\, 
        Y => \I10.EVENT_DWORD_163_net_1\);
    
    \I3.sstate_ns_i_a2_0l0r\ : NOR2FT
      port map(A => \I3.un4_pulse_net_1\, B => 
        \I3.sstatel1r_net_1\, Y => \I3.N_186\);
    
    \I10.un3_bnc_cnt_I_104\ : AND3
      port map(A => \I10.DWACT_FINC_El12r_adt_net_18940_\, B => 
        \I10.DWACT_FINC_El13r_adt_net_18968_\, C => 
        \I10.DWACT_FINC_El28r\, Y => \I10.N_16\);
    
    \I10.STATE1_ns_0_a2l8r\ : OR2FT
      port map(A => \I10.STATE1l4r_net_1\, B => 
        \I10.OR_RREQ_net_1\, Y => \I10.N_2390\);
    
    \I5.un1_RESCNT_G_1_1_0\ : AND2
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_1_5l0r\, B => 
        \I5.RESCNTl1r_net_1\, Y => \I5.G_1_1_0\);
    
    \I3.un16_ae_13\ : NOR3
      port map(A => \I3.un16_ae_1l45r\, B => \I3.un16_ae_1l15r\, 
        C => \I3.un16_ae_2l15r\, Y => \I3.un16_ael13r\);
    
    \I2.REG_1l271r_55\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_234_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL271R_39\);
    
    GA_padl2r : IB33
      port map(PAD => GA(2), Y => GA_cl2r);
    
    SP_PDL_padl30r : IOB33PH
      port map(PAD => SP_PDL(30), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl30r);
    
    \I2.REG_1l482r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_397_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl482r\);
    
    \I2.NOE16Wi_0_0_o2_0\ : OR2
      port map(A => \I2.WRITES_net_1\, B => \I2.N_2831\, Y => 
        NOE16W_c_c);
    
    \I2.LB_i_484\ : MUX2L
      port map(A => \I2.LB_il6r_Rd1__net_1\, B => 
        \I2.LB_i_7l6r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__88\, Y => \I2.LB_il6r\);
    
    \I1.I2C_RDATA_9_il6r\ : MUX2L
      port map(A => I2C_RDATAl6r, B => REGl117r, S => 
        \I1.sstate2_0_sqmuxa_4_0\, Y => \I1.N_586\);
    
    \I2.LB_s_41\ : MUX2L
      port map(A => \I2.LB_sl27r_Rd1__net_1\, B => 
        \I2.N_3036_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116344_Rd1__net_1\, Y => 
        \I2.LB_sl27r\);
    
    \I2.VDBi_59l13r\ : AND2FT
      port map(A => \I2.VDBi_59_0l9r\, B => 
        \I2.VDBi_59l13r_adt_net_44314_\, Y => 
        \I2.VDBi_59l13r_net_1\);
    
    \I2.VADml24r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl24r_net_1\, Y
         => \I2.VADml24r_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L21R_232\ : NOR2
      port map(A => \I10.N_2642_0\, B => \I10.OR_RADDRl1r_net_1\, 
        Y => \I10.EVENT_DWORD_18_i_0_0_0l21r_adt_net_26146_\);
    
    \I10.BNC_CNT_214\ : MUX2H
      port map(A => \I10.BNC_CNTl16r_net_1\, B => 
        \I10.BNC_CNT_4l16r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_214_net_1\);
    
    \I2.REG_1l286r_70\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_249_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL286R_54\);
    
    \I2.STATE2_nsl3r\ : AO21TTF
      port map(A => \I2.STATE2l2r_net_1\, B => \I2.N_2894_1\, C
         => \I2.STATE2_ns_0l3r_net_1\, Y => 
        \I2.STATE2_nsl3r_net_1\);
    
    \I1.COMMAND_8\ : MUX2H
      port map(A => \I1.COMMANDl12r_net_1\, B => 
        \I1.COMMAND_4l12r_net_1\, S => \I1.sstatel13r_net_1\, Y
         => \I1.COMMAND_8_net_1\);
    
    \I2.VDBi_24l12r\ : MUX2L
      port map(A => \I2.REGl486r\, B => \I2.VDBi_19l12r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l12r_net_1\);
    
    SP_PDL_padl21r : IOB33PH
      port map(PAD => SP_PDL(21), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl21r);
    
    \I2.VDBI_86_IV_1L3R_405\ : AND2
      port map(A => \I2.PIPEAl3r_net_1\, B => \I2.N_1707_i_0_1\, 
        Y => \I2.VDBi_86_iv_1_il3r_adt_net_52367_\);
    
    \I1.AIR_COMMAND_21_0_ivl13r\ : AO21
      port map(A => \I1.sstate2l6r_net_1\, B => CHANNELl0r, C => 
        \I1.AIR_COMMAND_21l13r_adt_net_9112_\, Y => 
        \I1.AIR_COMMAND_21l13r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I69_Y\ : XOR2
      port map(A => \I10.un1_REG_1_1l37r\, B => \I10.N328\, Y => 
        \I10.ADD_16x16_medium_I69_Y\);
    
    \I10.CRC32_3_i_0_0_x3l10r\ : XOR2FT
      port map(A => \I10.CRC32l10r_net_1\, B => 
        \I10.EVENT_DWORDl10r_net_1\, Y => \I10.N_2324_i_i_0\);
    
    \I2.PIPEA1_9_il27r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl27r, Y => \I2.N_2551\);
    
    \I10.STATE1_0l11r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl1r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l11r_net_1\);
    
    \I10.FID_8_rl1r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l1r_adt_net_24625_\, Y => \I10.FID_8l1r\);
    
    \I10.CRC32_108\ : MUX2H
      port map(A => \I10.CRC32l21r_net_1\, B => \I10.N_1360\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_108_net_1\);
    
    \I3.un16_ae_28\ : NOR2
      port map(A => \I3.un16_ae_2l31r\, B => \I3.un16_ae_1l28r\, 
        Y => \I3.un16_ael28r\);
    
    \I10.FID_8_rl27r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il27r\, B => 
        \I10.FID_8_iv_0_0_0_0_il27r\, C => \I10.STATE1l12r_net_1\, 
        Y => \I10.FID_8l27r\);
    
    \I3.AEl11r\ : MUX2L
      port map(A => REGl164r, B => \I3.un16_ael11r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl11r);
    
    LBSP_padl16r : IOB33PH
      port map(PAD => LBSP(16), A => REGl409r, EN => REG_i_0l281r, 
        Y => LBSP_inl16r);
    
    \I2.VDBi_19l10r\ : MUX2L
      port map(A => REGl58r, B => \I2.VDBi_17l10r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l10r_net_1\);
    
    \I10.OR_RADDR_1_sqmuxa_i\ : OR2
      port map(A => CLEAR_0_0_18, B => \I10.N_2354\, Y => 
        \I10.N_2126\);
    
    \I2.PIPEB_62\ : MUX2H
      port map(A => \I2.PIPEBl13r_net_1\, B => \I2.N_2595\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_62_net_1\);
    
    \I1.SDAout_del\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SDAout_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SDAout_del_net_1\);
    
    \I8.SWORD_4\ : MUX2H
      port map(A => \I8.SWORDl3r_net_1\, B => 
        \I8.SWORD_5l3r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_4_net_1\);
    
    \I10.BNC_CNT_199\ : MUX2H
      port map(A => \I10.BNC_CNTl1r_net_1\, B => 
        \I10.BNC_CNT_4l1r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_199_net_1\);
    
    \I8.SWORD_5l4r\ : MUX2L
      port map(A => REGl253r, B => \I8.SWORDl3r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l4r_net_1\);
    
    \I8.SWORDl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_11_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl10r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l9r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl9r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l9r_adt_net_27574_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l9r_net_1\);
    
    \I2.VDBm_0l9r\ : MUX2L
      port map(A => \I2.PIPEAl9r_net_1\, B => \I2.PIPEBl9r_net_1\, 
        S => \I2.BLTCYC_net_1\, Y => \I2.N_2050\);
    
    \I10.FID_8_RL1R_217\ : AO21FTT
      port map(A => GA_cl1r, B => \I10.N_2288\, C => 
        \I10.FID_8_0_iv_0_0_0_0_il1r\, Y => 
        \I10.FID_8l1r_adt_net_24625_\);
    
    \I2.PIPEBl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_55_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl6r_net_1\);
    
    \I2.WDOG_3_I_19\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_TMP_1l0r\, B => 
        \I2.WDOGl1r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_1_1l0r\);
    
    \I3.VALID_1\ : MUX2H
      port map(A => REGl145r, B => \I3.un4_pulse_net_1\, S => 
        \I3.sstate_dl3r\, Y => \I3.VALID_1_net_1\);
    
    \I3.un4_so_4_0\ : MUX2L
      port map(A => \I3.N_204\, B => \I3.N_202\, S => REGl125r, Y
         => \I3.N_200\);
    
    \I2.un1_STATE5_11_0_0_a2_122\ : AND2
      port map(A => \I2.N_2310_1\, B => 
        \I2.STATE5L3R_ADT_NET_116444_RD1__109\, Y => 
        \I2.STATE5_NSL2R_106\);
    
    \I2.PULSE_43_f0l9r\ : OA21TTF
      port map(A => PULSEl9r, B => \I2.PULSE_1_sqmuxa_6_0\, C => 
        \I2.STATE1l6r_net_1\, Y => \I2.PULSE_43_f0l9r_net_1\);
    
    \I10.FID_8_iv_0_0_0_1l17r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl17r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il17r_adt_net_22585_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il17r\);
    
    \I10.EVNT_TRG\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_TRG_120_net_1\, CLR
         => CLEAR_0_0, Q => \I10.EVNT_TRG_net_1\);
    
    \I2.LB_s_38\ : MUX2L
      port map(A => \I2.LB_sl24r_Rd1__net_1\, B => 
        \I2.N_3033_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116348_Rd1__net_1\, Y => 
        \I2.LB_sl24r\);
    
    SP_PDL_padl15r : IOB33PH
      port map(PAD => SP_PDL(15), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl15r);
    
    SP_PDL_padl16r : IOB33PH
      port map(PAD => SP_PDL(16), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl16r);
    
    \I10.EVENT_DWORD_18_i_0_1l25r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.PDL_RADDRl1r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0l25r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_1l25r_net_1\);
    
    \I2.REG_1l486r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_401_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl486r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I10_G0N\ : NAND2
      port map(A => \I10.N_2519_1\, B => \I10.REGl42r\, Y => 
        \I10.N238\);
    
    \I2.REG3_108\ : MUX2L
      port map(A => VDB_inl1r, B => \I2.REGl1r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_108_net_1\);
    
    \I2.VDBI_24L1R_470\ : AO21
      port map(A => \I2.VDBi_24_sl1r_net_1\, B => 
        \I2.VDBi_24_dl1r_net_1\, C => 
        \I2.VDBi_24l1r_adt_net_91121_\, Y => 
        \I2.VDBi_24l1r_adt_net_91174_\);
    
    \I2.REG_1l421r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_336_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl421r);
    
    \I1.SCL_27\ : MUX2H
      port map(A => \I1.SCL_net_1\, B => \I1.N_661\, S => TICKl0r, 
        Y => \I1.SCL_27_net_1\);
    
    \I10.CYC_STAT\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CYC_STAT_83_net_1\, CLR
         => CLEAR_0_0, Q => \I10.CYC_STAT_net_1\);
    
    \I2.PIPEA_545\ : MUX2L
      port map(A => \I2.PIPEAl1r_net_1\, B => \I2.PIPEA_8l1r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_545_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_4l6r\ : NOR2FT
      port map(A => \I10.DWACT_ADD_CI_0_pog_array_1l0r\, B => 
        \I10.N_2412_1\, Y => \I10.N_3170_i\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I68_Y_1\ : XOR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl36r\, Y => 
        \I10.un1_REG_1_1l36r\);
    
    LBSP_padl26r : IOB33PH
      port map(PAD => LBSP(26), A => REGl419r, EN => REG_i_0l291r, 
        Y => LBSP_inl26r);
    
    \I10.CRC32_3_i_0_0_x3l20r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl20r_net_1\, B => 
        \I10.CRC32l20r_net_1\, Y => \I10.N_2335_i_i_0\);
    
    \I10.FID_8_rl11r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l11r_adt_net_23398_\, Y => \I10.FID_8l11r\);
    
    \I2.LB_s_32\ : MUX2L
      port map(A => \I2.LB_sl18r_Rd1__net_1\, B => 
        \I2.N_3027_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116352_Rd1__net_1\, Y => 
        \I2.LB_sl18r\);
    
    \I3.un16_ae_21_1\ : NAND2FT
      port map(A => \I3.un16_ae_1l45r\, B => \I3.un16_ae_1l31r\, 
        Y => \I3.un16_ae_1l29r\);
    
    \I2.VDBi_86_0_ivl17r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl17r\, C
         => \I2.VDBi_86l17r_adt_net_42125_\, Y => 
        \I2.VDBi_86l17r\);
    
    \I2.REG_il292r\ : INV
      port map(A => \I2.REGl292r\, Y => REG_i_0l292r);
    
    \I2.REG_1l413r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_328_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl413r);
    
    \I10.CHANNEL_124\ : MUX2L
      port map(A => CHANNELl0r, B => \I10.N_2189_i_0\, S => 
        \I10.N_1595\, Y => \I10.CHANNEL_124_net_1\);
    
    AE_PDL_padl47r : OB33PH
      port map(PAD => AE_PDL(47), A => AE_PDL_cl47r);
    
    \I2.PIPEA_574\ : MUX2L
      port map(A => \I2.PIPEAl30r_net_1\, B => \I2.PIPEA_8l30r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_574_net_1\);
    
    \I10.CRC32_3_i_0_0l18r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2334_i_i_0\, Y => \I10.N_1464\);
    
    \I2.PIPEAl28r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEA_572_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEAl28r_net_1\);
    
    \I1.AIR_COMMANDl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_47_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl15r_net_1\);
    
    \I2.VDBi_54_0_iv_0l2r\ : AO21
      port map(A => REGl251r, B => \I2.REGMAPl24r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il2r_adt_net_53020_\, Y => 
        \I2.VDBi_54_0_iv_0_il2r\);
    
    \I10.DTEST_FIFO_82\ : OA21TTF
      port map(A => DTEST_FIFO, B => \I10.STATE1l10r_net_1\, C
         => \I10.STATE1L12R_15\, Y => \I10.DTEST_FIFO_82_net_1\);
    
    \I10.CRC32_3_i_0_0_x3l17r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl17r_net_1\, B => 
        \I10.CRC32l17r_net_1\, Y => \I10.N_2315_i_i_0\);
    
    \I2.WDOGl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.WDOG_3l2r\, CLR => 
        \I2.un17_hwres_i\, Q => \I2.WDOGl2r_net_1\);
    
    \I10.CRC32l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_87_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l0r_net_1\);
    
    \I1.sstate2l7r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2_ns_el2r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstate2l7r_net_1\);
    
    \I2.PIPEBl17r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_66_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl17r_net_1\);
    
    \I2.VADml31r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl31r_net_1\, Y
         => \I2.VADml31r_net_1\);
    
    LB_padl28r : IOB33PH
      port map(PAD => LB(28), A => \I2.LB_il28r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl28r);
    
    \I2.un90_reg_ads_0_a2_0_a2_2\ : NOR2FT
      port map(A => \I2.N_3056\, B => \I2.VASl6r_net_1\, Y => 
        \I2.N_3006_2\);
    
    \I3.un16_ae_22\ : NOR3
      port map(A => \I3.un16_ae_2l47r\, B => \I3.un16_ae_1l30r\, 
        C => \I3.un16_ae_1l23r\, Y => \I3.un16_ael22r\);
    
    \I2.REG_1l417r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_332_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl417r);
    
    \I2.VDBi_54_0_iv_5l9r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il9r\, B => 
        \I2.VDBi_54_0_iv_0_il9r\, C => \I2.VDBi_54_0_iv_1_il9r\, 
        Y => \I2.VDBi_54_0_iv_5_il9r\);
    
    \I2.un70_reg_ads_0_a2_0_a2\ : NOR3
      port map(A => \I2.N_3068\, B => \I2.N_3005_1\, C => 
        \I2.N_3000_1\, Y => \I2.un70_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.un3_bnc_cnt_I_13\ : XOR2
      port map(A => \I10.BNC_CNTl3r_net_1\, B => 
        \I10.DWACT_FINC_El0r\, Y => \I10.I_13_0\);
    
    \I2.STATE5_ns_i_i_a2_0_0_0l0r\ : AND2
      port map(A => \I2.SINGCYC_net_1\, B => \I2.N_2389_96\, Y
         => \I2.STATE5_ns_i_i_a2_0_0l0r\);
    
    \I2.LB_i_7l16r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l16r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l16r_Rd1__net_1\);
    
    \I1.DATAl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.DATA_12l8r_net_1\, CLR => 
        HWRES_c_2_0, Q => REGl113r);
    
    \I3.un4_so_40_0\ : MUX2L
      port map(A => SP_PDL_inl39r, B => SP_PDL_inl37r, S => 
        REGl123r, Y => \I3.N_236\);
    
    VDB_padl19r : IOB33PH
      port map(PAD => VDB(19), A => \I2.VDBml19r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl19r);
    
    \I2.CYCS1\ : DFFC
      port map(CLK => CLKOUT, D => \I2.un8_cycs_0_a2_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.CYCS1_net_1\);
    
    \I2.VDBi_17_0l2r\ : AND2
      port map(A => REGl34r, B => \I2.REGMAPl6r_net_1\, Y => 
        \I2.N_1899_adt_net_52770_\);
    
    \I2.REG_1l188r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_178_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl188r);
    
    PSM_RES_pad : OB33PH
      port map(PAD => PSM_RES, A => \GND\);
    
    \I2.VDBi_24l24r\ : MUX2L
      port map(A => \I2.REGl498r\, B => \I2.VDBi_19l24r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l24r_net_1\);
    
    \I2.BLTCYC_0\ : DFFC
      port map(CLK => CLKOUT, D => \I2.BLTCYC_105_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.BLTCYC_net_1\);
    
    \I10.un3_bnc_cnt_I_55\ : AND3
      port map(A => \I10.BNC_CNTl8r_net_1\, B => 
        \I10.BNC_CNTl9r_net_1\, C => \I10.DWACT_FINC_El4r\, Y => 
        \I10.N_51\);
    
    SPULSE0_pad : IB33
      port map(PAD => SPULSE0, Y => SPULSE0_c);
    
    \I10.FID_8_IV_0_0_0_0L5R_208\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.FID_4l5r\, Y
         => \I10.FID_8_iv_0_0_0_0l5r_adt_net_24108_\);
    
    \I2.un64_reg_ads_0_a2_0_a2\ : NOR2
      port map(A => \I2.N_3005_1\, B => \I2.N_3002_1\, Y => 
        \I2.un64_reg_ads_0_a2_0_a2_net_1\);
    
    \I5.SBYTEl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.SBYTE_10_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => FBOUTl4r);
    
    \I3.un16_ae_24\ : NOR2
      port map(A => \I3.un16_ae_2l31r\, B => \I3.un16_ae_1l24r\, 
        Y => \I3.un16_ael24r\);
    
    \I2.VDBI_54_0_IV_0L1R_415\ : AND2
      port map(A => \I2.REGMAP_i_il17r\, B => REGl138r, Y => 
        \I2.VDBi_54_0_iv_0_il1r_adt_net_53789_\);
    
    \I2.VDBI_86_IV_1L0R_421\ : AND2
      port map(A => \I2.PIPEAl0r_net_1\, B => \I2.N_1707_i_0_1\, 
        Y => \I2.VDBi_86_iv_1_il0r_adt_net_55157_\);
    
    \I2.REG_1l274r_58\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_237_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL274R_42\);
    
    \I10.un2_i2c_chain_0_0_0_0_o3l1r\ : NAND2FT
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTL2R_11\, Y
         => \I10.N_2298\);
    
    \I2.LB_i_498\ : MUX2L
      port map(A => \I2.LB_il20r_Rd1__net_1\, B => 
        \I2.LB_i_7l20r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__81\, Y => \I2.LB_il20r\);
    
    \I3.AEl45r\ : MUX2L
      port map(A => REGl198r, B => \I3.un16_ael45r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl45r);
    
    \I10.CRC32_3_0_a2_i_0l1r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2341_i_i_0\, Y => \I10.N_1679\);
    
    \I2.LB_s_37\ : MUX2L
      port map(A => \I2.LB_sl23r_Rd1__net_1\, B => 
        \I2.N_3032_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116348_Rd1__net_1\, Y => 
        \I2.LB_sl23r\);
    
    \I10.CRC32_3_i_0_0_x3l27r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl27r_net_1\, B => 
        \I10.CRC32l27r_net_1\, Y => \I10.N_2319_i_i_0\);
    
    \I10.FIDl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_180_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl15r_net_1\);
    
    \I10.CYC_STAT_83\ : OA21TTF
      port map(A => \I10.CYC_STAT_net_1\, B => 
        \I10.CYC_STAT_1_net_1\, C => \I10.CLEAR_PSM_FLAGS_net_1\, 
        Y => \I10.CYC_STAT_83_net_1\);
    
    \I3.un1_BITCNT_I_1\ : AND2
      port map(A => \I3.BITCNTl0r_net_1\, B => 
        \I3.un1_hwres_3_net_1\, Y => \I3.DWACT_ADD_CI_0_TMPl0r\);
    
    \I1.I2C_RDATA_23\ : MUX2L
      port map(A => I2C_RDATAl9r, B => \I1.N_592\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_23_net_1\);
    
    LB_padl30r : IOB33PH
      port map(PAD => LB(30), A => \I2.LB_il30r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl30r);
    
    \I2.PIPEB_4_il10r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl10r, Y => \I2.N_2589\);
    
    \I2.REG_ml105r\ : NAND2
      port map(A => REGl105r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.REG_ml105r_net_1\);
    
    \I2.LB_il19r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il19r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il19r_Rd1__net_1\);
    
    \I2.REG_1_253\ : MUX2L
      port map(A => \I2.REGL290R_58\, B => VDB_inl25r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_253_net_1\);
    
    \I10.STATE1l11r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl1r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1L11R_12\);
    
    \I10.CRC32_88\ : MUX2H
      port map(A => \I10.CRC32l1r_net_1\, B => \I10.N_1679\, S
         => \I10.N_2351\, Y => \I10.CRC32_88_net_1\);
    
    \I10.CRC32l28r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_115_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l28r_net_1\);
    
    \I2.un1_STATE2_13_0_o3\ : NOR3
      port map(A => DPRl31r, B => DPRl29r, C => 
        \I2.un1_STATE2_13_0_o3_0_net_1\, Y => \I2.N_2858\);
    
    \I2.REG_1l294r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_257_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl294r\);
    
    \I5.BITCNTl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.BITCNT_6l2r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.BITCNTl2r_net_1\);
    
    \I2.un1_STATE2_8_0_0_o2_6\ : NAND2
      port map(A => \I2.N_2821_0\, B => \I2.STATE2_i_0l3r\, Y => 
        \I2.N_2822_6\);
    
    \I10.un1_CNT_1_G_1_0_0_0\ : NAND2
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTl4r_net_1\, 
        Y => \I10.G_1_0_0_i\);
    
    \I10.STATE1_ns_0_0_a2l4r\ : AO21
      port map(A => \I10.RDY_CNTl1r_net_1\, B => 
        \I10.RDY_CNTl0r_net_1\, C => \I10.N_2647\, Y => 
        \I10.N_2383\);
    
    \I10.BNC_CNT_4_0_a2l14r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => \I10.I_84\, 
        Y => \I10.BNC_CNT_4l14r\);
    
    \I10.un2_i2c_chain_0_i_0_0_i_1l2r\ : OR2FT
      port map(A => \I10.CNTl5r_net_1\, B => 
        \I10.un2_i2c_chain_0_i_0_0_i_1l2r_adt_net_29231_\, Y => 
        \I10.un2_i2c_chain_0_i_0_0_i_1l2r_net_1\);
    
    \I2.VDBi_19l28r\ : AND2
      port map(A => TST_cl5r, B => REGl76r, Y => 
        \I2.VDBi_19l28r_net_1\);
    
    \I2.LB_s_26\ : MUX2L
      port map(A => \I2.LB_sl12r_Rd1__net_1\, B => 
        \I2.N_3047_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116356_Rd1__net_1\, Y => 
        \I2.LB_sl12r\);
    
    \I2.VDBi_24l29r\ : MUX2L
      port map(A => \I2.REGl503r\, B => \I2.VDBi_19l29r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l29r_net_1\);
    
    \I3.sstate_ns_il0r\ : AOI21
      port map(A => \I3.sstatel0r_net_1\, B => \I3.N_165\, C => 
        \I3.N_186\, Y => \I3.sstate_ns_i_0l0r\);
    
    \I10.FAULT_STAT_121\ : MUX2H
      port map(A => \I10.FAULT_STAT_net_1\, B => 
        \I10.FAULT_STAT_3\, S => \I10.N_1579\, Y => 
        \I10.FAULT_STAT_121_net_1\);
    
    \I5.RESCNTl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l1r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl1r_net_1\);
    
    \I10.un1_PDL_RADDR_1_sqmuxa_0_0\ : NAND2FT
      port map(A => \I10.un1_STATE1_14_1\, B => 
        \I10.PDL_RADDR_1_sqmuxa\, Y => 
        \I10.un1_PDL_RADDR_1_sqmuxa\);
    
    \I8.ISCK\ : DFFC
      port map(CLK => CLKOUT, D => \I8.sstate_dl2r\, CLR => 
        HWRES_c_2_0, Q => SCLK_DAC_c);
    
    \I2.un102_reg_ads_0_a2_0_a2\ : AND2FT
      port map(A => \I2.N_3154_i\, B => 
        \I2.un102_reg_ads_0_a2_0_a2_adt_net_37466_\, Y => 
        \I2.un102_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.PIPEA_8_RL13R_440\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l13r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l13r_adt_net_56727_\);
    
    \I10.un3_bnc_cnt_I_84\ : XOR2
      port map(A => \I10.BNC_CNT_i_il14r\, B => \I10.N_31\, Y => 
        \I10.I_84\);
    
    \I10.EVENT_DWORD_18_rl3r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l3r_net_1\, B => 
        \I10.EVENT_DWORD_18l3r_adt_net_28351_\, Y => 
        \I10.EVENT_DWORD_18l3r\);
    
    \I10.FID_8_0_iv_0_0_0_0l0r\ : AO21
      port map(A => \I10.STATE1L1R_14\, B => 
        \I10.EVENT_DWORDl0r_net_1\, C => 
        \I10.FID_8_0_iv_0_0_0_0_il0r_adt_net_24708_\, Y => 
        \I10.FID_8_0_iv_0_0_0_0_il0r\);
    
    \I2.REG_1_365\ : MUX2H
      port map(A => VDB_inl9r, B => \I2.REGl450r\, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_365_net_1\);
    
    \I2.PIPEBl26r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_75_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl26r_net_1\);
    
    \I2.REGMAPl14r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un87_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAP_i_il14r\);
    
    \I2.PIPEA1_532\ : MUX2L
      port map(A => \I2.PIPEA1l21r_net_1\, B => \I2.N_2539\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_532_net_1\);
    
    \I2.REG_1l455r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_370_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl455r\);
    
    \I2.VDBi_54_0_iv_1l3r\ : AO21
      port map(A => REGl188r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il3r_adt_net_52166_\, Y => 
        \I2.VDBi_54_0_iv_1_il3r\);
    
    \I2.REG_1l159r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_149_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl159r);
    
    \I2.REG_1l278r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_241_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl278r\);
    
    \I10.un3_bnc_cnt_I_118\ : AND3
      port map(A => \I10.BNC_CNTl17r_net_1\, B => 
        \I10.DWACT_FINC_El12r_adt_net_18940_\, C => 
        \I10.DWACT_FINC_El13r_adt_net_18968_\, Y => 
        \I10.DWACT_FINC_El13r\);
    
    \I1.sstatel0r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstatese_12_i_0_net_1\, 
        CLR => HWRES_c_2_0, Q => \I1.sstatel0r_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L8R_258\ : NOR2
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl16r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l8r_adt_net_27723_\);
    
    \I10.FID_8_iv_0_0_0_0l22r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl6r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il22r_adt_net_21807_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il22r\);
    
    \I2.REG3l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_107_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl0r\);
    
    \I10.L2RF1\ : DFFC
      port map(CLK => ACLKOUT, D => L2R_c, CLR => HWRES_c_2_0, Q
         => \I10.L2RF1_net_1\);
    
    \I1.sstatese_9_i\ : MUX2H
      port map(A => \I1.sstate_i_0_il3r\, B => 
        \I1.sstatel4r_net_1\, S => TICKl0r, Y => 
        \I1.sstatese_9_i_net_1\);
    
    \I2.VDBi_54_0_iv_3l11r\ : AO21TTF
      port map(A => REG_cl132r, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l11r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il11r\);
    
    \I2.VDBI_24L1R_469\ : AND3
      port map(A => FULL, B => \I2.REGMAPl2r_net_1\, C => 
        \I2.VDBi_24l1r_adt_net_90940_\, Y => 
        \I2.VDBi_24l1r_adt_net_91170_\);
    
    \I10.un1_evread_0_a2_0_a2_1\ : NOR2FT
      port map(A => EVREAD, B => \I10.FIFO_END_EVNT_net_1\, Y => 
        \I10.N_2519_1\);
    
    \I3.un16_ae_19\ : NOR2
      port map(A => \I3.un16_ae_1l27r\, B => \I3.un16_ae_1l23r\, 
        Y => \I3.un16_ael19r\);
    
    \I10.CRC32_96\ : MUX2H
      port map(A => \I10.CRC32l9r_net_1\, B => \I10.N_1035\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_96_net_1\);
    
    \I2.VADml16r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl16r_net_1\, Y
         => \I2.VADml16r_net_1\);
    
    \I10.CRC32l4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_91_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l4r_net_1\);
    
    VAD_padl31r : IOB33PH
      port map(PAD => VAD(31), A => \I2.VADml31r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl31r);
    
    \I2.un7_noe32ri_i_0_i_a2_1\ : AND2FT
      port map(A => \I2.N_2831\, B => \I2.N_2983_1_adt_net_2417_\, 
        Y => \I2.N_2983_1\);
    
    \I2.STATE2_ns_0_0l4r\ : NAND2
      port map(A => \I2.N_2900\, B => \I2.N_2894_3\, Y => 
        \I2.STATE2_nsl4r\);
    
    DIR_CTTM_padl7r : OB33PH
      port map(PAD => DIR_CTTM(7), A => \VCC\);
    
    \I5.RESCNTl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l7r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl7r_net_1\);
    
    \I10.FID_4_0_a2_0l4r\ : XOR2
      port map(A => \I10.CRC32l12r_net_1\, B => 
        \I10.CRC32l24r_net_1\, Y => \I10.FID_4_0_a2_0l4r_net_1\);
    
    \I2.REG_1l83r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_456_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl83r);
    
    LBSP_padl12r : IOB33PH
      port map(PAD => LBSP(12), A => REGl405r, EN => REG_i_0l277r, 
        Y => LBSP_inl12r);
    
    \I5.un1_RESCNT_I_97\ : AND2
      port map(A => \I5.RESCNTl12r_net_1\, B => 
        \I5.RESCNTl13r_net_1\, Y => 
        \I5.DWACT_ADD_CI_0_pog_array_1_5l0r\);
    
    \I2.PULSE_1l10r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PULSE_43_rl10r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => PULSEl10r);
    
    TST_padl2r : OB33PH
      port map(PAD => TST(2), A => TST_cl2r);
    
    \I1.I2C_RDATAl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_23_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl9r);
    
    \I10.EVNT_NUM_3_I_50\ : XOR2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_2_1l0r\, B => 
        \I10.EVNT_NUMl4r_net_1\, Y => \I10.EVNT_NUM_3l4r\);
    
    \I2.REG_1l48r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_421_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl48r);
    
    \I10.un1_REG_1_ADD_16x16_medium_I78_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => REGl46r, Y => 
        \I10.ADD_16x16_medium_I78_Y_0\);
    
    \I2.REG_1_0l127r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_129_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGL127R_3);
    
    \I10.FID_8_IV_0_0_0_0L20R_179\ : AND2
      port map(A => \I10.BNC_NUMBERl1r_net_1\, B => 
        \I10.STATE1l9r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il20r_adt_net_22135_\);
    
    \I10.STATE2l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE2_nsl1r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE2l1r_net_1\);
    
    \I2.VDBi_86_0_iv_0_m3l19r\ : MUX2L
      port map(A => \I2.PIPEAl19r_net_1\, B => \I2.N_2855\, S => 
        \I2.REGMAPl0r_net_1\, Y => \I2.N_2861\);
    
    \I2.REG_1_404\ : MUX2H
      port map(A => VDB_inl15r, B => \I2.REGl489r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_404_net_1\);
    
    \I2.LB_sl7r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl7r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl7r_Rd1__net_1\);
    
    \I1.REG_1_105_13_140\ : OAI21FTF
      port map(A => \I1.sstatel13r_net_1\, B => 
        \I1.PULSE_FL_net_1\, C => REGl105r, Y => 
        \I1.REG_1_105_13_adt_net_12496_\);
    
    \I2.VDBi_61l21r\ : MUX2L
      port map(A => LBSP_inl21r, B => \I2.VDBi_56l21r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l21r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l22r\ : OAI21TTF
      port map(A => I2C_RDATAl2r, B => \I10.N_2639\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l22r_adt_net_25992_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l22r_net_1\);
    
    \I2.REG_1l184r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_174_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl184r);
    
    \I2.LB_i_481\ : MUX2L
      port map(A => \I2.LB_il3r_Rd1__net_1\, B => 
        \I2.LB_i_7l3r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__89\, Y => \I2.LB_il3r\);
    
    \I8.SWORD_5l10r\ : MUX2L
      port map(A => REGl259r, B => \I8.SWORDl9r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l10r_net_1\);
    
    \I2.un756_regmap_24\ : NAND3FTT
      port map(A => \I2.un756_regmap_17_i\, B => 
        \I2.VDBi_9_sqmuxa_i_0_net_1\, C => 
        \I2.un756_regmap_22_net_1\, Y => \I2.un756_regmap_24_i\);
    
    \I2.un1_state1_1_i_a2_0_1\ : OR2
      port map(A => AMB_cl5r, B => AMB_cl2r, Y => \I2.N_2889_1\);
    
    \I2.REG_1l74r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_447_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl74r);
    
    \I10.FIDl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_178_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl13r_net_1\);
    
    \I2.PIPEBl30r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEB_79_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEBl30r_net_1\);
    
    AE_PDL_padl16r : OB33PH
      port map(PAD => AE_PDL(16), A => AE_PDL_cl16r);
    
    \I1.I2C_RDATA_9_il8r\ : MUX2L
      port map(A => I2C_RDATAl8r, B => REGl119r, S => 
        \I1.sstate2_0_sqmuxa_4_0\, Y => \I1.N_590\);
    
    \I10.EVENT_DWORDl18r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_151_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl18r_net_1\);
    
    \I2.TCNT2_2_I_36\ : AND3
      port map(A => \I2.DWACT_ADD_CI_0_g_array_1l0r\, B => 
        \I2.TCNT2_i_0_il2r_net_1\, C => \I2.TCNT2l3r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_g_array_2l0r\);
    
    \I10.EVNT_NUM_3_I_48\ : XOR2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_12_4l0r\, B => 
        \I10.EVNT_NUMl11r_net_1\, Y => \I10.EVNT_NUM_3l11r\);
    
    \I2.VDBml29r\ : MUX2L
      port map(A => \I2.VDBil29r_net_1\, B => \I2.N_2070\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml29r_net_1\);
    
    LED_padl0r : OB33PH
      port map(PAD => LED(0), A => \VCC\);
    
    \I2.LB_s_34\ : MUX2L
      port map(A => \I2.LB_sl20r_Rd1__net_1\, B => 
        \I2.N_3029_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116352_Rd1__net_1\, Y => 
        \I2.LB_sl20r\);
    
    \I5.RESCNT_6_rl12r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_58\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l12r\);
    
    LBSP_padl22r : IOB33PH
      port map(PAD => LBSP(22), A => REGl415r, EN => REG_i_0l287r, 
        Y => LBSP_inl22r);
    
    \I10.un1_RDY_CNT_I_10\ : XOR2
      port map(A => \I10.RDY_CNTl1r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_TMP_2l0r\, Y => \I10.I_10\);
    
    \I2.STATE1_ns_o3_i_a2_0_a2l3r\ : NAND2FT
      port map(A => \I2.WRITES_net_1\, B => \I2.N_2981_1\, Y => 
        \I2.N_2981\);
    
    \I2.un1_TCNT_1_I_13\ : XOR2
      port map(A => \I2.N_1885_1\, B => \I2.TCNTl4r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_partial_suml4r\);
    
    \I2.REG_1_150\ : MUX2L
      port map(A => REGl160r, B => VDB_inl7r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_150_net_1\);
    
    LB_padl18r : IOB33PH
      port map(PAD => LB(18), A => \I2.LB_il18r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl18r);
    
    \I2.REG_92_0l87r\ : MUX2H
      port map(A => VDB_inl6r, B => REGl87r, S => 
        \I2.REG_1_sqmuxa_1\, Y => \I2.N_1990\);
    
    \I2.VDBi_86_0_ivl27r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl27r\, C
         => \I2.VDBi_86l27r_adt_net_40047_\, Y => 
        \I2.VDBi_86l27r\);
    
    \I2.VDBi_86_iv_1l10r\ : AOI21TTF
      port map(A => \I2.PIPEAl10r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_iv_0l10r_net_1\, Y => 
        \I2.VDBi_86_iv_1l10r_net_1\);
    
    \I2.BLTCYC\ : DFFC
      port map(CLK => CLKOUT, D => \I2.BLTCYC_105_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.BLTCYC_17\);
    
    \I1.un1_BITCNT_I_15\ : AND2
      port map(A => \I1.DWACT_ADD_CI_0_TMPl0r\, B => 
        \I1.BITCNTl1r_net_1\, Y => 
        \I1.DWACT_ADD_CI_0_g_array_1l0r\);
    
    \I10.CRC32l10r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_97_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l10r_net_1\);
    
    \I2.VDBi_17_0l0r\ : MUX2L
      port map(A => REGl32r, B => \I2.VDBi_8l0r_net_1\, S => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1897\);
    
    \I10.FID_8_iv_0_0_0_0l15r\ : AO21
      port map(A => \I10.STATE1l11r_net_1\, B => REGl63r, C => 
        \I10.FID_8_iv_0_0_0_0_il15r_adt_net_22871_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il15r\);
    
    \I2.un1_STATE5_9_0_a2_1\ : AND2FT
      port map(A => \I2.REGMAPl35r_net_1\, B => 
        \I2.STATE5l3r_net_1\, Y => \I2.N_2389\);
    
    \I2.VDBi_17_0l5r\ : AOI21
      port map(A => REGl5r, B => \I2.REGMAP_i_il1r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1902_adt_net_50282_\);
    
    \I1.DATA_12_iv_0_o2l1r\ : AND2
      port map(A => TICKl0r, B => \I1.sstatel1r_net_1\, Y => 
        \I1.N_633\);
    
    \I10.EVENT_DWORDl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_140_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl7r_net_1\);
    
    \I2.VDBi_61l26r\ : MUX2L
      port map(A => LBSP_inl26r, B => \I2.VDBi_56l26r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l26r_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_2l6r\ : AO21TTF
      port map(A => \I10.N_2375_1\, B => \I10.N_2376_1\, C => 
        \I10.un2_i2c_chain_0_0_0_0_0l6r_net_1\, Y => 
        \I10.un2_i2c_chain_0_0_0_0_2_il6r\);
    
    \I2.VDBi_591\ : MUX2L
      port map(A => \I2.VDBil15r_net_1\, B => \I2.VDBi_86l15r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_591_net_1\);
    
    \I2.VDBI_54_0_IV_1L14R_351\ : AND2
      port map(A => REG_cl247r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il14r_adt_net_43484_\);
    
    \I2.STATE1l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.STATE1_ns_il9r_net_1\, CLR
         => \I2.N_2483_i_0_0_0\, Q => \I2.STATE1l0r_net_1\);
    
    \I2.REG_1_452\ : MUX2H
      port map(A => VDB_inl31r, B => REGl79r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_452_net_1\);
    
    \I10.FID_8_0_IV_0_0_0_0L0R_218\ : AND2
      port map(A => \I10.STATE1L11R_12\, B => REGl48r, Y => 
        \I10.FID_8_0_iv_0_0_0_0_il0r_adt_net_24708_\);
    
    \I2.STATE5l3r\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl1r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5l3r_net_1\);
    
    \I10.CRC32_3_i_0_0l30r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2338_i_i_0\, Y => \I10.N_1472\);
    
    \I2.un3_asb_NE_0\ : OR2
      port map(A => \I2.un3_asb_2_net_1\, B => 
        \I2.un3_asb_3_net_1\, Y => \I2.un3_asb_NE_0_net_1\);
    
    \I2.VDBi_56l17r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l17r_net_1\, Y => \I2.VDBi_56l17r_net_1\);
    
    \I2.un8_cycs_0_a2\ : NOR2FT
      port map(A => \I2.CYCS_net_1\, B => TST_cl0r, Y => 
        \I2.un8_cycs_0_a2_net_1\);
    
    \I2.REG_1l268r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_231_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl268r\);
    
    \I10.DTEST_FIFO\ : DFFC
      port map(CLK => CLKOUT, D => \I10.DTEST_FIFO_82_net_1\, CLR
         => CLEAR_0_0, Q => DTEST_FIFO);
    
    \I2.REGMAPl34r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un122_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl34r_net_1\);
    
    \I2.REG_1l82r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_455_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl82r);
    
    \I2.REG_1l173r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_163_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl173r);
    
    \I3.AEl27r\ : MUX2L
      port map(A => REGl180r, B => \I3.un16_ael27r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl27r);
    
    \I3.un16_ae_33\ : NOR2
      port map(A => \I3.un16_ae_1l33r\, B => \I3.un16_ae_1l39r\, 
        Y => \I3.un16_ael33r\);
    
    \I10.CHANNELl2r\ : DFF
      port map(CLK => CLKOUT, D => \I10.CHANNEL_126_net_1\, Q => 
        CHANNELl2r);
    
    \I2.REG_il445r\ : INV
      port map(A => \I2.REGl445r\, Y => REG_i_0l445r);
    
    \I2.PIPEA_550\ : MUX2L
      port map(A => \I2.PIPEAl6r_net_1\, B => \I2.PIPEA_8l6r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_550_net_1\);
    
    \I10.PDL_RADDRl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.PDL_RADDR_224_net_1\, CLR
         => CLEAR_0_0, Q => \I10.PDL_RADDRl0r_net_1\);
    
    \I2.PIPEA1_9_0l29r\ : OR2FT
      port map(A => \I2.N_2830_4\, B => DPRl29r, Y => 
        \I2.PIPEA1_9l29r\);
    
    \I2.PIPEA1l24r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_535_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l24r_net_1\);
    
    \I10.CRC32_3_i_0_0l21r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2328_i_i_0\, Y => \I10.N_1360\);
    
    \I10.UN2_I2C_CHAIN_0_I_I_IL4R_284\ : AND3FFT
      port map(A => \I10.un2_i2c_chain_0_i_i_i_3_il4r\, B => 
        \I10.un2_i2c_chain_0_i_i_i_2_il4r_adt_net_30782_\, C => 
        \I10.un2_i2c_chain_0_i_i_i_0l4r_net_1\, Y => 
        \I10.N_2189_i_0_adt_net_30812_\);
    
    \I10.FID_8_IV_0_0_0_0L14R_190\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.N_2311_i_0_i\, 
        Y => \I10.FID_8_iv_0_0_0_0_il14r_adt_net_22993_\);
    
    \I8.sstate_ns_i_a2_1l0r\ : NAND2
      port map(A => \I8.BITCNTl1r_net_1\, B => 
        \I8.BITCNTl2r_net_1\, Y => 
        \I8.sstate_ns_i_a2_1_il0r_adt_net_5385_\);
    
    \I2.un17_reg_ads_0_a2_0_a2\ : AND3FTT
      port map(A => \I2.N_3067\, B => \I2.N_3008_1\, C => 
        \I2.N_3070\, Y => \I2.un17_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.UN90_REG_ADS_0_A2_0_A2_305\ : NOR3FFT
      port map(A => \I2.N_2863\, B => \I2.VASl2r_net_1\, C => 
        \I2.N_3068\, Y => 
        \I2.un90_reg_ads_0_a2_0_a2_adt_net_37522_\);
    
    \I2.REG3_113\ : MUX2L
      port map(A => VDB_inl6r, B => REGl6r, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_113_net_1\);
    
    \I8.SWORDl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.SWORD_9_net_1\, CLR => 
        HWRES_c_2_0, Q => \I8.SWORDl8r_net_1\);
    
    \I10.BNC_NUMBER_231\ : MUX2L
      port map(A => \I10.BNCRES_CNTl1r_net_1\, B => 
        \I10.BNC_NUMBERl1r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_231_net_1\);
    
    \I2.VDBi_56l25r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l25r_net_1\, Y => \I2.VDBi_56l25r_net_1\);
    
    \I2.VDBi_70_d_0l0r\ : MUX2L
      port map(A => SPULSE0_c, B => \I2.VDBi_70_dl0r_net_1\, S
         => \I2.VDBi_70_sl0r_net_1\, Y => 
        \I2.VDBi_70_d_0l0r_net_1\);
    
    \I10.un3_bnc_cnt_I_56\ : XOR2
      port map(A => \I10.BNC_CNTl10r_net_1\, B => \I10.N_51\, Y
         => \I10.I_56\);
    
    \I10.un3_bnc_cnt_I_72\ : AND2
      port map(A => \I10.DWACT_FINC_El7r\, B => 
        \I10.DWACT_FINC_El28r\, Y => \I10.N_39\);
    
    SCL0_pad : OB33PH
      port map(PAD => SCL0, A => SCLA_i_a2);
    
    \I2.VDBI_86_0_IVL16R_343\ : AO21
      port map(A => \I2.PIPEAl16r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il16r\, Y => 
        \I2.VDBi_86l16r_adt_net_42330_\);
    
    \I10.FID_8_IV_0_0_0_0L19R_181\ : AND2
      port map(A => \I10.BNC_NUMBERl0r_net_1\, B => 
        \I10.STATE1l9r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il19r_adt_net_22299_\);
    
    \I3.AEl7r\ : MUX2L
      port map(A => REGl160r, B => \I3.un16_ael7r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl7r);
    
    \I2.UN2_REG_ADS_0_A2_307\ : NOR3
      port map(A => \I2.N_3061\, B => \I2.N_3010_1\, C => 
        \I2.N_3009_1\, Y => \I2.un2_reg_ads_0_a2_adt_net_37970_\);
    
    \I2.REG_il283r\ : INV
      port map(A => \I2.REGl283r\, Y => REG_i_0l283r);
    
    \I10.un3_bnc_cnt_I_5\ : XOR2
      port map(A => \I10.BNC_CNTl0r_net_1\, B => 
        \I10.BNC_CNTl1r_net_1\, Y => \I10.I_5\);
    
    \I2.STATE1_NS_0_0_0L1R_310\ : NOR2
      port map(A => \I2.SINGCYC_net_1\, B => \I2.N_1705_i_0_1\, Y
         => \I2.STATE1_ns_0_0_0_il1r_adt_net_38622_\);
    
    \I2.REG_1_456\ : MUX2H
      port map(A => REGl83r, B => \I2.REG_92l83r_net_1\, S => 
        \I2.N_1730_0\, Y => \I2.REG_1_456_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l8r\ : OR2
      port map(A => LB_inl8r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__70\, Y => \I2.N_3043\);
    
    \I2.REG_1l186r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_176_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl186r);
    
    \I10.FID_8_RL14R_191\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl14r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il14r\, Y => 
        \I10.FID_8l14r_adt_net_23032_\);
    
    \I5.DRIVE_RELOAD\ : DFFC
      port map(CLK => CLKOUT, D => \I5.DRIVE_RELOAD_3_net_1\, CLR
         => HWRES_c_2_0, Q => \I5.DRIVE_RELOAD_net_1\);
    
    \I3.AEl14r\ : MUX2L
      port map(A => REGl167r, B => \I3.un16_ael14r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl14r);
    
    \I2.un1_STATE2_10_i\ : OAI21FTT
      port map(A => \I2.N_2894_2\, B => \I2.N_2894_3\, C => 
        \I2.un1_STATE2_10_i_0_i\, Y => \I2.N_2645\);
    
    \I10.REG_1l33r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I65_Y\, 
        CLR => CLEAR_0_0, Q => REGl33r);
    
    \I2.VDBi_17_0l3r\ : AOI21
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl3r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1900_adt_net_51888_\);
    
    \I5.SBYTEl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.SBYTE_9_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => FBOUTl3r);
    
    \I2.REG_1_345\ : MUX2L
      port map(A => REGl430r, B => VDB_inl5r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_345_net_1\);
    
    \I2.REG_1l252r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_215_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl252r);
    
    \I5.sstatel1r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.sstate_ns_il4r_net_1\, CLR
         => \I5.un2_hwres_2_net_1\, Q => \I5.sstatel1r_net_1\);
    
    AE_PDL_padl37r : OB33PH
      port map(PAD => AE_PDL(37), A => AE_PDL_cl37r);
    
    \I5.SBYTE_7\ : MUX2H
      port map(A => FBOUTl1r, B => \I5.SBYTE_5l1r_net_1\, S => 
        \I5.un1_sstate_12\, Y => \I5.SBYTE_7_net_1\);
    
    \I2.VAS_92\ : MUX2L
      port map(A => VAD_inl10r, B => \I2.VASl10r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_92_net_1\);
    
    \I2.un1_vsel_1_i_a2_1\ : OR3FFT
      port map(A => AMB_cl1r, B => AMB_cl0r, C => \I2.N_2889_1\, 
        Y => \I2.un1_vsel_1_i_a2_1_i\);
    
    \I10.un6_bnc_res_NE\ : OR3
      port map(A => \I10.un6_bnc_res_NE_16_i\, B => 
        \I10.un6_bnc_res_NE_15_i\, C => \I10.un6_bnc_res_NE_14_i\, 
        Y => \I10.un6_bnc_res_NE_net_1\);
    
    \I3.un16_ae_41_1\ : OR2
      port map(A => REGl123r, B => REGl124r, Y => 
        \I3.un16_ae_1l41r\);
    
    \I2.LB_i_7l12r\ : AND2
      port map(A => VDB_inl12r, B => \I2.STATE5L2R_75\, Y => 
        \I2.LB_i_7l12r_net_1\);
    
    \I10.FID_8_rl2r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l2r_adt_net_24503_\, Y => \I10.FID_8l2r\);
    
    \I10.EVENT_DWORD_18_rl8r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l8r_net_1\, B => 
        \I10.EVENT_DWORD_18l8r_adt_net_27753_\, Y => 
        \I10.EVENT_DWORD_18l8r\);
    
    \I2.REG_1l296r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_259_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl296r\);
    
    \I2.un1_WDOGRES_0_sqmuxa_0_0\ : AND3FTT
      port map(A => \I2.WDOGl0r_net_1\, B => \I2.N_2886_1\, C => 
        \I2.STATE1l9r_net_1\, Y => 
        \I2.un1_WDOGRES_0_sqmuxa_adt_net_75393_\);
    
    \I1.COMMAND_4l11r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl11r_net_1\, B => REGl100r, S
         => REGl7r, Y => \I1.COMMAND_4l11r_net_1\);
    
    \I2.REG_il285r\ : INV
      port map(A => \I2.REGl285r\, Y => REG_i_0l285r);
    
    \I2.REG_1_421\ : MUX2H
      port map(A => VDB_inl0r, B => REGl48r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_421_net_1\);
    
    \I3.sstate_ns_0_x2l1r\ : XOR2
      port map(A => \I3.sstatel1r_net_1\, B => 
        \I3.sstatel0r_net_1\, Y => \I3.N_184_i\);
    
    \I2.LB_s_4_i_a2_0_a2l13r\ : OR2
      port map(A => LB_inl13r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__69\, Y => \I2.N_3048\);
    
    \I10.EVENT_DWORD_18_RL3R_269\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl13r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l3r_adt_net_28351_\);
    
    \I1.COMMAND_4l15r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl15r_net_1\, B => REGl104r, S
         => REGl7r, Y => \I1.COMMAND_4l15r_net_1\);
    
    \I2.un1_STATE5_9_0_a2_2_a2_134\ : NAND2
      port map(A => \I2.WRITES_net_1\, B => \I2.STATE5L2R_118\, Y
         => \I2.LB_NOE_1_SQMUXA_116\);
    
    \I2.REG3_506_141\ : OAI21FTF
      port map(A => VDB_inl0r, B => \I2.REG1_0_sqmuxa\, C => 
        \I2.REG3_506_141_adt_net_73367_\, Y => 
        \I2.REG3_506_141_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I28_un1_Y\ : OAI21TTF
      port map(A => \I10.N_2519_1\, B => REGl33r, C => \I10.N208\, 
        Y => \I10.I28_un1_Y\);
    
    \I2.REG_1_409\ : MUX2H
      port map(A => VDB_inl20r, B => \I2.REGl494r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_409_net_1\);
    
    \I2.REG_1l404r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_319_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl404r);
    
    \I2.REG3_118\ : MUX2L
      port map(A => VDB_inl11r, B => \I2.REGl11r\, S => 
        \I2.REG1_0_sqmuxa_1_0\, Y => \I2.REG3_118_net_1\);
    
    \I2.REG_1_368\ : MUX2H
      port map(A => VDB_inl12r, B => \I2.REGl453r\, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_368_net_1\);
    
    \I2.VDBi_24l13r\ : MUX2L
      port map(A => \I2.REGl487r\, B => \I2.VDBi_19l13r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l13r_net_1\);
    
    \I2.PIPEA_8_rl21r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl21r, C => 
        \I2.PIPEA_8l21r_adt_net_56167_\, Y => \I2.PIPEA_8l21r\);
    
    \I2.PIPEA_573\ : MUX2L
      port map(A => \I2.PIPEA_i_0_il29r\, B => \I2.PIPEA_8l29r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_573_net_1\);
    
    \I3.un16_ae_23_2\ : NAND2FT
      port map(A => \I3.un16_ae_2l47r\, B => \I3.un16_ae_1l31r\, 
        Y => \I3.un16_ae_3l31r\);
    
    \I2.LB_i_7_rl6r\ : AND2FT
      port map(A => \I2.STATE5L4R_ADT_NET_116400_RD1__67\, B => 
        \I2.N_1893\, Y => \I2.LB_i_7l6r_net_1\);
    
    \I10.un3_bnc_cnt_I_87\ : AND2
      port map(A => \I10.BNC_CNT_i_il13r\, B => 
        \I10.BNC_CNT_i_il12r\, Y => 
        \I10.DWACT_FINC_El9r_adt_net_18912_\);
    
    \I2.un1_tcnt1_I_19\ : AND2
      port map(A => \I2.TCNT1l3r_net_1\, B => 
        \I2.DWACT_FINC_El0r\, Y => \I2.N_7\);
    
    \I2.REG_1_158\ : MUX2L
      port map(A => REGl168r, B => VDB_inl15r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_158_net_1\);
    
    \I10.EVENT_DWORD_140\ : MUX2H
      port map(A => \I10.EVENT_DWORDl7r_net_1\, B => 
        \I10.EVENT_DWORD_18l7r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_140_net_1\);
    
    \I10.FID_8_rl25r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il25r\, B => 
        \I10.FID_8_iv_0_0_0_0_il25r\, C => \I10.STATE1l12r_net_1\, 
        Y => \I10.FID_8l25r\);
    
    \I2.VDBi_19l14r\ : MUX2L
      port map(A => REGl62r, B => \I2.VDBi_17l14r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l14r_net_1\);
    
    \I2.REG_1l443r_43\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_358_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL443R_27\);
    
    \I2.REG_1l163r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_153_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl163r);
    
    \I1.COMMANDl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_10_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl14r_net_1\);
    
    \I10.un6_bnc_res_9\ : XOR2
      port map(A => \I10.BNC_CNTl9r_net_1\, B => REGl466r, Y => 
        \I10.un6_bnc_res_9_i_i\);
    
    \I3.un16_ae_0\ : AND2FT
      port map(A => \I3.un16_ae_1l41r\, B => \I3.un16_ae_1l4r\, Y
         => \I3.un16_ael0r\);
    
    \I3.AEl40r\ : MUX2L
      port map(A => REGl193r, B => \I3.un16_ael40r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl40r);
    
    \I2.TCNT2_i_0_il0r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.DWACT_ADD_CI_0_partial_sum_0l0r\, Q => 
        \I2.TCNT2_i_0_il0r_net_1\);
    
    \I2.REG_1l155r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_145_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl155r);
    
    \I2.VDBi_56l1r\ : AND2
      port map(A => SPULSE1_c, B => \I2.REGMAPl28r_net_1\, Y => 
        \I2.VDBi_56l1r_adt_net_53899_\);
    
    TST_padl0r : OB33PH
      port map(PAD => TST(0), A => TST_cl0r);
    
    \I2.VDBI_86_0_IVL23R_330\ : AO21
      port map(A => \I2.PIPEAl23r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il23r\, Y => 
        \I2.VDBi_86l23r_adt_net_40867_\);
    
    \I2.REG_1l287r_71\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_250_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL287R_55\);
    
    \I2.PIPEA_8_RL24R_429\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l24r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l24r_adt_net_55957_\);
    
    \I1.START_I2C_2_iv\ : NAND2FT
      port map(A => \I1.START_I2C_2_adt_net_11237_\, B => 
        \I1.START_I2C_2_iv_0_net_1\, Y => \I1.START_I2C_2\);
    
    \I3.un4_so_34_0\ : MUX2L
      port map(A => \I3.N_235\, B => \I3.N_224\, S => REGl124r, Y
         => \I3.N_252\);
    
    \I2.REG_92_0l81r\ : MUX2H
      port map(A => VDB_inl0r, B => REGl81r, S => 
        \I2.REG_1_sqmuxa_1\, Y => \I2.N_1984\);
    
    \I2.REG_il290r\ : INV
      port map(A => \I2.REGl290r\, Y => REG_i_0l290r);
    
    LBSP_padl9r : IOB33PH
      port map(PAD => LBSP(9), A => REGl402r, EN => REG_i_0l274r, 
        Y => LBSP_inl9r);
    
    \I2.VDBml31r\ : MUX2L
      port map(A => \I2.VDBil31r_net_1\, B => \I2.N_2072\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml31r_net_1\);
    
    \I2.un1_STATE2_12_0_0_o2\ : AND2FT
      port map(A => \I2.STATE2l0r_net_1\, B => \I2.N_2900\, Y => 
        \I2.N_2849\);
    
    \I1.COMMAND_1\ : MUX2H
      port map(A => \I1.COMMANDl0r_net_1\, B => 
        \I1.COMMAND_4l0r_net_1\, S => \I1.SSTATEL13R_8\, Y => 
        \I1.COMMAND_1_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l18r\ : OR2
      port map(A => LB_inl18r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__68\, Y => \I2.N_3027\);
    
    \I10.CRC32l2r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_89_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l2r_net_1\);
    
    \I10.FIDl27r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_192_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl27r_net_1\);
    
    \I2.VDBI_86_IVL2R_411\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l2r_net_1\, C => \I2.VDBi_86_iv_0_il2r\, Y => 
        \I2.VDBi_86l2r_adt_net_53418_\);
    
    \I2.N_3021_1_adt_net_116348_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3021_1\, SET => 
        HWRES_c_2_0, Q => \I2.N_3021_1_adt_net_116348_Rd1__net_1\);
    
    \I2.EVREAD_DS_1_sqmuxa_0_a2_0_1_0\ : NOR2
      port map(A => \I2.PIPEBl29r_net_1\, B => 
        \I2.PIPEBl31r_net_1\, Y => 
        \I2.EVREAD_DS_1_sqmuxa_0_a2_0_1_0_i\);
    
    \I10.CRC32_3_i_0_0l29r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2321_i_i_0\, Y => \I10.N_1220\);
    
    \I2.REG_1l127r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_129_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl127r);
    
    \I10.BNC_CNTl16r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_214_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl16r_net_1\);
    
    \I2.un756_regmap_4\ : NOR3
      port map(A => \I2.REGMAPl27r_net_1\, B => 
        \I2.REGMAP_i_0_il11r\, C => \I2.REGMAP_i_il26r_net_1\, Y
         => \I2.un756_regmap_4_net_1\);
    
    \I2.VAS_87\ : MUX2L
      port map(A => VAD_inl5r, B => \I2.VASl5r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_87_net_1\);
    
    \I1.un1_sdab_0_a2\ : NOR2FT
      port map(A => \I1.CHAIN_SELECT_net_1\, B => 
        \I1.SDAnoe_del2_net_1\, Y => un1_sdab_0_a2);
    
    \I10.EVENT_DWORD_18_rl16r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l16r_net_1\, B => 
        \I10.EVENT_DWORD_18l16r_adt_net_26820_\, Y => 
        \I10.EVENT_DWORD_18l16r\);
    
    \I2.REG_1_217\ : MUX2L
      port map(A => VDB_inl5r, B => REGl254r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_217_net_1\);
    
    \I10.EVENT_DWORD_18_RL1R_273\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl11r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l1r_adt_net_28575_\);
    
    \I5.RESCNT_6_rl0r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => 
        \I5.DWACT_ADD_CI_0_partial_suml0r\, C => \I5.N_211_0\, Y
         => \I5.RESCNT_6l0r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I26_Y\ : OA21
      port map(A => REGl34r, B => \I10.REGl35r\, C => 
        \I10.N_2519_1\, Y => \I10.N265\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L23R_228\ : NOR2
      port map(A => \I10.N_2642_0\, B => \I10.OR_RADDRl3r_net_1\, 
        Y => \I10.EVENT_DWORD_18_i_0_0_0l23r_adt_net_25838_\);
    
    \I10.BNC_CNTl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_210_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNT_i_il12r\);
    
    \I2.VASl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_92_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl10r_net_1\);
    
    \I2.VDBi_67l8r\ : MUX2L
      port map(A => \I2.VDBi_59l8r_net_1\, B => 
        \I2.VDBi_67_dl8r_net_1\, S => \I2.VDBi_67_sl8r_net_1\, Y
         => \I2.VDBi_67l8r_net_1\);
    
    \I3.SBYTE_5l3r\ : MUX2H
      port map(A => REG_cl132r, B => REGl139r, S => 
        \I3.sstatel0r_net_1\, Y => \I3.SBYTE_5l3r_net_1\);
    
    \I2.PIPEA_8_rl25r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl25r, C => 
        \I2.PIPEA_8l25r_adt_net_55887_\, Y => \I2.PIPEA_8l25r\);
    
    \I1.COMMAND_4l2r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl2r_net_1\, B => REGl91r, S
         => REGL7R_2, Y => \I1.COMMAND_4l2r_net_1\);
    
    \I3.un16_ae_46_1\ : OR2
      port map(A => REGl122r, B => REGl126r, Y => 
        \I3.un16_ae_1l46r\);
    
    \I2.LB_s_4_i_a2_0_a2l22r\ : OR2
      port map(A => LB_inl22r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, Y => 
        \I2.N_3031\);
    
    \I2.PIPEAl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_544_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl0r_net_1\);
    
    \I2.un43_reg_ads_0_a2_0_a2\ : AND2FT
      port map(A => \I2.N_3068\, B => \I2.N_2987_1\, Y => 
        \I2.un43_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.DSSF1_12_461\ : OAI21FTF
      port map(A => \I2.CYCS_net_1\, B => \I2.N_2869\, C => 
        TST_cl0r, Y => \I2.DSSF1_12_adt_net_79192_\);
    
    \I2.WDOGl0r\ : DFFC
      port map(CLK => CLKOUT, D => 
        \I2.DWACT_ADD_CI_0_partial_sum_2l0r\, CLR => 
        \I2.un17_hwres_i\, Q => \I2.WDOGl0r_net_1\);
    
    \I2.un3_asb_NE\ : NOR3
      port map(A => \I2.un3_asb_NE_0_net_1\, B => 
        \I2.un3_asb_0_net_1\, C => \I2.un3_asb_1_net_1\, Y => 
        \I2.un3_asb_NE_net_1\);
    
    \I2.LB_i_7l22r\ : AND2
      port map(A => VDB_inl22r, B => \I2.STATE5L2R_73\, Y => 
        \I2.LB_i_7l22r_net_1\);
    
    \I2.VDBi_86_iv_1l0r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl0r\, C
         => \I2.VDBi_86_iv_1_il0r_adt_net_55157_\, Y => 
        \I2.VDBi_86_iv_1_il0r\);
    
    \I1.sstatese_10_0\ : AO21FTT
      port map(A => TICKl0r, B => \I1.sstatel2r_net_1\, C => 
        \I1.BITCNT_2_sqmuxa\, Y => \I1.sstate_ns_el11r\);
    
    \I2.PIPEA_572\ : MUX2L
      port map(A => \I2.PIPEAl28r_net_1\, B => \I2.PIPEA_8l28r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_572_net_1\);
    
    \I8.SWORD_7\ : MUX2H
      port map(A => \I8.SWORDl6r_net_1\, B => 
        \I8.SWORD_5l6r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_7_net_1\);
    
    \I2.VDBml11r\ : MUX2L
      port map(A => \I2.VDBil11r_net_1\, B => \I2.N_2052\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml11r_net_1\);
    
    \I2.VDBi_17_0l10r\ : AOI21
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl10r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1907_adt_net_46222_\);
    
    \I10.FID_8_iv_0_0_0_1l26r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl26r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il26r_adt_net_21109_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il26r\);
    
    \I2.SELGEO\ : LD
      port map(EN => ASB_c, D => \I2.un3_asb_NE_net_1\, Q => 
        TST_cl4r);
    
    \I10.un1_EVENT_DWORD_0_sqmuxa_0_0_a3\ : NAND2
      port map(A => \I10.STATE1l5r_net_1\, B => 
        \I10.PDL_RREQ_net_1\, Y => \I10.N_2647\);
    
    \I2.VDBml23r\ : MUX2L
      port map(A => \I2.VDBil23r_net_1\, B => \I2.N_2064\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml23r_net_1\);
    
    \I10.BNC_CNT_203\ : MUX2H
      port map(A => \I10.BNC_CNTl5r_net_1\, B => 
        \I10.BNC_CNT_4l5r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_203_net_1\);
    
    \I10.STATE1_ns_0_0_a2_1l9r\ : OR3FFT
      port map(A => \I10.N_2395_1\, B => \I10.READ_OR_FLAG_net_1\, 
        C => \I10.READ_PDL_FLAG_net_1\, Y => \I10.N_2393\);
    
    \I2.REG_1_219\ : MUX2L
      port map(A => VDB_inl7r, B => REGl256r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_219_net_1\);
    
    \I2.REG_1l171r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_161_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl171r);
    
    \I2.PIPEB_58\ : MUX2H
      port map(A => \I2.PIPEBl9r_net_1\, B => \I2.N_2587\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_58_net_1\);
    
    \I2.UN37_REG_ADS_0_A2_0_A2_306\ : NOR3
      port map(A => \I2.LWORDS_net_1\, B => \I2.N_3013_2\, C => 
        \I2.N_3064\, Y => 
        \I2.un37_reg_ads_0_a2_0_a2_adt_net_37774_\);
    
    \I2.LB_s_4_i_a2_0_a2l1r\ : OR2
      port map(A => LB_inl1r, B => 
        \I2.STATE5l4r_adt_net_116400_Rd1__net_1\, Y => 
        \I2.N_3023\);
    
    \I2.LB_s_4_i_a2_0_a2l19r\ : OR2
      port map(A => LB_inl19r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, Y => 
        \I2.N_3028\);
    
    \I2.TCNT3_2_I_42\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_2_0l0r\, B => 
        \I2.TCNT3_i_0_il4r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_12_1_0l0r\);
    
    \I2.LB_s_4_i_a2_0_a2l0r\ : OR2
      port map(A => LB_inl0r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__68\, Y => \I2.N_3022\);
    
    \I3.I_42_2\ : AND2
      port map(A => \I3.BITCNTl0r_net_1\, B => 
        \I3.BITCNTl2r_net_1\, Y => \I3.N_195_2\);
    
    \I2.VDBi_67_0l10r\ : MUX2L
      port map(A => \I2.REGl435r\, B => \I2.REGl451r\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1959\);
    
    \I2.STATE5L2R_514\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_NSL2R_106\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L2R_118\);
    
    \I10.CRC32l19r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_106_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l19r_net_1\);
    
    \I2.un81_reg_ads_0_a2_0_a2_1\ : NAND2FT
      port map(A => \I2.N_3064\, B => \I2.N_3060\, Y => 
        \I2.N_3003_1\);
    
    \I2.VDBi_61l3r\ : AND3FTT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_61_sl0r_net_1\, C => 
        \I2.VDBi_56l3r_adt_net_52242_\, Y => 
        \I2.VDBi_61l3r_adt_net_52281_\);
    
    \I2.VDBi_86_iv_2l12r\ : AOI21TTF
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl12r\, C
         => \I2.VDBi_86_iv_1l12r_net_1\, Y => 
        \I2.VDBi_86_iv_2l12r_net_1\);
    
    \I2.VDBm_0l11r\ : MUX2L
      port map(A => \I2.PIPEAl11r_net_1\, B => 
        \I2.PIPEBl11r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2052\);
    
    \I5.sstate_0_sqmuxa_1_0_a2_1\ : AND2
      port map(A => \I5.RESCNTl13r_net_1\, B => 
        \I5.RESCNTl14r_net_1\, Y => 
        \I5.sstate_0_sqmuxa_1_0_a2_1_net_1\);
    
    \I2.REG_1l498r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_413_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl498r\);
    
    \I10.UN1_STATE1_15_0_0_0_0_1_150\ : AO21
      port map(A => \I10.STATE1l11r_net_1\, B => PULSEl3r, C => 
        \I10.N_2288\, Y => \I10.un1_STATE1_15_1_adt_net_16929_\);
    
    VAD_padl20r : OTB33PH
      port map(PAD => VAD(20), A => \I2.VADml20r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I2.REG_1_366\ : MUX2H
      port map(A => VDB_inl10r, B => \I2.REGl451r\, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_366_net_1\);
    
    \I2.PIPEB_78\ : MUX2H
      port map(A => \I2.PIPEBl29r_net_1\, B => \I2.N_2881\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_78_net_1\);
    
    \I10.un6_bnc_res_10\ : XOR2
      port map(A => \I10.BNC_CNTl10r_net_1\, B => REGl467r, Y => 
        \I10.un6_bnc_res_10_i_i\);
    
    \I10.REG_1l32r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I0_S\, 
        CLR => CLEAR_0_0, Q => REGl32r);
    
    \I1.sstate2se_5_i\ : MUX2H
      port map(A => \I1.sstate2l4r_net_1\, B => 
        \I1.sstate2l3r_net_1\, S => \I1.N_277_0\, Y => 
        \I1.sstate2se_5_i_net_1\);
    
    \I1.CHAIN_SELECT\ : DFFC
      port map(CLK => CLKOUT, D => \I1.CHAIN_SELECT_24_net_1\, 
        CLR => HWRES_c_2_0, Q => \I1.CHAIN_SELECT_net_1\);
    
    \I2.SINGCYC_140\ : OA21TTF
      port map(A => \I2.SINGCYC_net_1\, B => \I2.N_2892_i\, C => 
        TST_cl0r, Y => \I2.SINGCYC_140_net_1\);
    
    \I3.un16_ae_39\ : NOR2
      port map(A => \I3.un16_ae_4l47r\, B => \I3.un16_ae_1l39r\, 
        Y => \I3.un16_ael39r\);
    
    LBSP_padl14r : IOB33PH
      port map(PAD => LBSP(14), A => REGl407r, EN => REG_i_0l279r, 
        Y => LBSP_inl14r);
    
    \I1.AIR_COMMAND_40\ : MUX2L
      port map(A => \I1.AIR_COMMANDl8r_net_1\, B => 
        \I1.AIR_COMMAND_21l8r\, S => \I1.un1_tick_12_net_1\, Y
         => \I1.AIR_COMMAND_40_net_1\);
    
    \I10.EVENT_DWORD_18_rl20r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l20r_net_1\, B => 
        \I10.EVENT_DWORD_18l20r_adt_net_26372_\, Y => 
        \I10.EVENT_DWORD_18l20r\);
    
    \I2.WDOGRES1\ : DFFS
      port map(CLK => CLKOUT, D => \I2.WDOGRES_i_net_1\, SET => 
        HWRES_c_2_0, Q => \I2.WDOGRES1_i\);
    
    \I2.VDBi_19l20r\ : AND2
      port map(A => TST_cl5r, B => REGl68r, Y => 
        \I2.VDBi_19l20r_net_1\);
    
    \I2.REG_1l409r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_324_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl409r);
    
    \I1.un1_BITCNT_I_9\ : XOR2
      port map(A => \I1.BITCNT_i_il0r\, B => 
        \I1.un1_tick_10_0_net_1\, Y => 
        \I1.DWACT_ADD_CI_0_partial_suml0r\);
    
    \I2.LB_il29r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il29r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il29r_Rd1__net_1\);
    
    \I2.PIPEA_557\ : MUX2L
      port map(A => \I2.PIPEAl13r_net_1\, B => \I2.PIPEA_8l13r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_557_net_1\);
    
    \I2.VDBI_54_0_IV_0L6R_383\ : AND2
      port map(A => \I2.REGMAP_i_il17r\, B => REGl143r, Y => 
        \I2.VDBi_54_0_iv_0_il6r_adt_net_49715_\);
    
    \I2.REG_1_471\ : MUX2H
      port map(A => VDB_inl9r, B => REGl98r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_471_net_1\);
    
    \I3.un1_BITCNT_1_rl2r\ : OA21
      port map(A => \I3.N_195\, B => \I3.I_14_1\, C => 
        \I3.un1_hwres_2_net_1\, Y => \I3.un1_BITCNT_1_rl2r_net_1\);
    
    \I2.VDBi_17_rl15r\ : OA21
      port map(A => \I2.N_1912_adt_net_42452_\, B => 
        \I2.N_1912_adt_net_42454_\, C => 
        \I2.VDBi_17l15r_adt_net_42484_\, Y => \I2.VDBi_17l15r\);
    
    \I1.AIR_COMMAND_1_sqmuxa\ : NOR2
      port map(A => \I1.sstate2_0_sqmuxa_3\, B => 
        \I1.un83_tick_net_1\, Y => \I1.AIR_COMMAND_cnstl10r\);
    
    \I10.FID_8_RL5R_209\ : OA21FTF
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl5r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l5r_adt_net_24138_\);
    
    \I2.VDBi_82l7r\ : MUX2L
      port map(A => \I2.VDBil7r_net_1\, B => FBOUTl7r, S => 
        \I2.N_1721_1\, Y => \I2.VDBi_82l7r_net_1\);
    
    \I2.VDBil5r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_581_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil5r_net_1\);
    
    \I2.PIPEBl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_61_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl12r_net_1\);
    
    \I2.REG_1_154\ : MUX2L
      port map(A => REGl164r, B => VDB_inl11r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_154_net_1\);
    
    \I2.REG_1l67r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_440_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl67r);
    
    \I2.VDBi_9_sqmuxa_i_1\ : NOR2
      port map(A => \I2.REGMAP_i_il17r\, B => 
        \I2.REGMAPl18r_net_1\, Y => \I2.VDBi_9_sqmuxa_i_1_net_1\);
    
    \I10.STATE1_ns_i_0_0_0_1l0r\ : NOR2
      port map(A => \I10.STATE1l6r_net_1\, B => \I10.N_2349\, Y
         => \I10.N_557_1\);
    
    \I3.un4_so_43_0\ : MUX2L
      port map(A => SP_PDL_inl31r, B => SP_PDL_inl29r, S => 
        REGl123r, Y => \I3.N_239\);
    
    \I10.BNC_CNT_4_0_a2l4r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_20\, 
        Y => \I10.BNC_CNT_4l4r\);
    
    \I2.VDBi_86_ivl9r\ : AO21TTF
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l9r_net_1\, C => \I2.VDBi_86_iv_2l9r_net_1\, Y
         => \I2.VDBi_86l9r\);
    
    \I2.STATE5L4R_ADT_NET_116400_RD1__483\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_NS_I_IL0R_95\, 
        SET => HWRES_c_2_0, Q => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__68\);
    
    \I2.REG_1_240\ : MUX2L
      port map(A => \I2.REGL277R_45\, B => VDB_inl12r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_240_net_1\);
    
    \I10.FID_8_IV_0_0_0_0L13R_192\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.N_2310_i_0_i\, 
        Y => \I10.FID_8_iv_0_0_0_0_il13r_adt_net_23115_\);
    
    \I10.FID_8_iv_0_0_0_0l13r\ : AO21
      port map(A => \I10.STATE1L11R_12\, B => REGl61r, C => 
        \I10.FID_8_iv_0_0_0_0_il13r_adt_net_23115_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il13r\);
    
    \I1.SDAout_del2\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SDAout_del1_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.SDAout_del2_net_1\);
    
    \I2.VDBi_70l0r\ : AOI21FTF
      port map(A => \I2.VDBi_54l0r_adt_net_55073_\, B => 
        \I2.VDBi_54_0_iv_6l0r_net_1\, C => 
        \I2.VDBi_70_s_0l0r_net_1\, Y => 
        \I2.VDBi_70l0r_adt_net_55113_\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I60_Y\ : OAI21
      port map(A => \I10.N239\, B => \I10.N304\, C => \I10.N238\, 
        Y => \I10.N322\);
    
    \I2.REG_1_348\ : MUX2L
      port map(A => NSELCLK_c, B => VDB_inl8r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_348_net_1\);
    
    \I3.un4_so_12_0\ : MUX2L
      port map(A => SP_PDL_inl34r, B => SP_PDL_inl2r, S => 
        REGL127R_3, Y => \I3.N_208\);
    
    WRITEB_pad : IB33
      port map(PAD => WRITEB, Y => WRITEB_c);
    
    \I1.SBYTE_9_iv_0_m2l0r\ : MUX2L
      port map(A => SDA1_in, B => SDA0_in, S => 
        \I1.CHAIN_SELECT_net_1\, Y => \I1.N_630\);
    
    LBSP_padl24r : IOB33PH
      port map(PAD => LBSP(24), A => REGl417r, EN => REG_i_0l289r, 
        Y => LBSP_inl24r);
    
    \I2.REG_1l500r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_415_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl500r\);
    
    \I5.RESCNT_6_rl10r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_53\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l10r\);
    
    \I2.VDBi_86_0_ivl25r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl25r\, C
         => \I2.VDBi_86l25r_adt_net_40457_\, Y => 
        \I2.VDBi_86l25r\);
    
    SP_PDL_padl34r : IOB33PH
      port map(PAD => SP_PDL(34), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl34r);
    
    LBSP_padl0r : IOB33PH
      port map(PAD => LBSP(0), A => REGl393r, EN => REG_i_0l265r, 
        Y => LBSP_inl0r);
    
    \I10.CRC32_3_i_0_0_x3l19r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl19r_net_1\, B => 
        \I10.CRC32l19r_net_1\, Y => \I10.N_2316_i_i_0\);
    
    LB_padl1r : IOB33PH
      port map(PAD => LB(1), A => \I2.LB_il1r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl1r);
    
    \I2.REG_1l53r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_426_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl53r);
    
    \I2.PIPEA_571\ : MUX2L
      port map(A => \I2.PIPEAl27r_net_1\, B => \I2.PIPEA_8l27r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_571_net_1\);
    
    \I2.un3_noe32wi_i_0_0\ : OR2FT
      port map(A => \I2.N_2863\, B => \I2.N_2831\, Y => 
        NOE32W_c_c);
    
    \I3.un16_ae_34_1\ : OR2
      port map(A => \I3.un16_ae_1l46r\, B => \I3.un16_ae_1l43r\, 
        Y => \I3.un16_ae_1l42r\);
    
    \I2.un1_vsel_5_i_o3\ : OA21TTF
      port map(A => AMB_cl1r, B => \I2.N_2889_1\, C => 
        \I2.N_3074_i\, Y => \I2.N_2853_i\);
    
    LBSP_padl8r : IOB33PH
      port map(PAD => LBSP(8), A => REGl401r, EN => REG_i_0l273r, 
        Y => LBSP_inl8r);
    
    \I2.REG_1l161r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_151_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl161r);
    
    NLBAS_pad : OB33PH
      port map(PAD => NLBAS, A => \NLBAS_c\);
    
    \I2.N_3032_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3032\, SET => 
        HWRES_c_2_0, Q => \I2.N_3032_Rd1__net_1\);
    
    \I2.VDBi_596\ : MUX2L
      port map(A => \I2.VDBil20r_net_1\, B => \I2.VDBi_86l20r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_596_net_1\);
    
    \I10.BNC_CNTl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_199_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl1r_net_1\);
    
    \I10.un2_i2c_chain_0_i_i_i_a2_0l4r\ : AND3
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2303\, C => 
        \I10.N_2358\, Y => \I10.N_2521_i\);
    
    \I10.BNCRES_CNT_4_I_49\ : AND2
      port map(A => \I10.BNCRES_CNTl2r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_1_0l0r\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_12_0l0r\);
    
    \I2.REG_1l415r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_330_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl415r);
    
    \I10.BNC_CNTl19r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_217_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl19r_net_1\);
    
    \I2.VDBi_67l10r\ : MUX2L
      port map(A => \I2.VDBi_61l10r_net_1\, B => \I2.N_1959\, S
         => \I2.N_1965\, Y => \I2.VDBi_67l10r_net_1\);
    
    \I10.PDL_RADDR_225\ : MUX2H
      port map(A => \I10.CNTl1r_net_1\, B => 
        \I10.PDL_RADDRl1r_net_1\, S => \I10.PDL_RADDR_1_sqmuxa\, 
        Y => \I10.PDL_RADDR_225_net_1\);
    
    \I5.un1_BITCNT_I_14\ : XOR2
      port map(A => \I5.DWACT_ADD_CI_0_g_array_1_0l0r\, B => 
        \I5.BITCNTl2r_net_1\, Y => \I5.I_14_0\);
    
    \I2.un1_STATE1_27_i_1\ : NAND2FT
      port map(A => \I2.N_1712_1_adt_net_36665_\, B => 
        \I2.N_1762\, Y => \I2.N_1712_1\);
    
    \I10.EVENT_DWORD_155\ : MUX2H
      port map(A => \I10.EVENT_DWORDl22r_net_1\, B => 
        \I10.EVENT_DWORD_18l22r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_155_net_1\);
    
    L1A_pad : IB33
      port map(PAD => L1A, Y => L1A_c);
    
    \I2.REG_1_362\ : MUX2L
      port map(A => \I2.REGL447R_31\, B => VDB_inl6r, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_362_net_1\);
    
    \I2.LB_i_7l10r\ : AND2
      port map(A => VDB_inl10r, B => \I2.STATE5l2r_net_1\, Y => 
        \I2.LB_i_7l10r_net_1\);
    
    \I3.un4_so_11_0\ : MUX2L
      port map(A => \I3.N_206\, B => \I3.N_201\, S => REGL126R_4, 
        Y => \I3.N_249\);
    
    \I2.STATE1_ns_i_o3l6r\ : NAND2FT
      port map(A => TST_cl0r, B => \I2.STATE1l4r_net_1\, Y => 
        \I2.N_2854\);
    
    \I2.LB_i_506\ : MUX2L
      port map(A => \I2.LB_il28r_Rd1__net_1\, B => 
        \I2.LB_i_7l28r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__77\, Y => \I2.LB_il28r\);
    
    \I3.SBYTEl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.SBYTE_5_net_1\, CLR => 
        HWRES_c_2_0, Q => REGl139r);
    
    \I10.EVNT_NUM_3_I_44\ : XOR2
      port map(A => \I10.EVNT_NUMl6r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_11_0l0r\, Y => 
        \I10.EVNT_NUM_3l6r\);
    
    \I0.CLEAR_0_a2_0_0_0_0_34\ : NAND3
      port map(A => NLBCLR_c, B => \I0.CLEAR_0_a2_0_net_1\, C => 
        REGl506r, Y => CLEAR_0_0_18);
    
    \I2.VDBI_86_0_IV_0L16R_342\ : AND2
      port map(A => \I2.VDBil16r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il16r_adt_net_42291_\);
    
    \I2.REG_1l431r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_346_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl431r);
    
    \I5.un1_RESCNT_I_56\ : XOR2
      port map(A => \I5.RESCNTl11r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_12_4l0r\, Y => \I5.I_56_0\);
    
    \I8.BITCNTl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I8.BITCNT_6l3r\, CLR => 
        HWRES_c_2_0, Q => \I8.BITCNTl3r_net_1\);
    
    \I2.REG_1_431\ : MUX2H
      port map(A => VDB_inl10r, B => REGl58r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_431_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0_1l3r\ : OA21FTT
      port map(A => \I10.N_2374_1\, B => \I10.N_2300\, C => 
        \I10.N_2366\, Y => \I10.un2_i2c_chain_0_0_0_0_1l3r_net_1\);
    
    \I2.STATE1_NSL8R_300\ : NOR2
      port map(A => \I2.N_1729\, B => \I2.TCNT_0_sqmuxa\, Y => 
        \I2.STATE1_nsl8r_adt_net_37064_\);
    
    \I2.VDBi_8l0r\ : MUX2L
      port map(A => REGl506r, B => \I2.VDBi_5l0r_net_1\, S => 
        \I2.REGMAP_i_il14r\, Y => \I2.VDBi_8l0r_net_1\);
    
    \I2.PIPEA_554\ : MUX2L
      port map(A => \I2.PIPEAl10r_net_1\, B => \I2.PIPEA_8l10r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_554_net_1\);
    
    \I1.AIR_CHAIN_3_iv\ : AO21TTF
      port map(A => \I1.N_3146_i\, B => REGl6r, C => 
        \I1.AIR_CHAIN_3_iv_0_net_1\, Y => \I1.AIR_CHAIN_3\);
    
    \I10.EVENT_DWORD_162\ : MUX2H
      port map(A => \I10.EVENT_DWORDl29r_net_1\, B => 
        \I10.EVENT_DWORD_18l29r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_162_net_1\);
    
    \I2.REG_1_214\ : MUX2L
      port map(A => VDB_inl2r, B => REGl251r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_214_net_1\);
    
    \I2.REG3l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_108_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl1r\);
    
    \I10.STATE1l1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl11r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1L1R_14\);
    
    \I10.CRC32_3_i_0_0_x3l29r\ : XOR2FT
      port map(A => \I10.EVENT_DWORDl29r_net_1\, B => 
        \I10.CRC32l29r_net_1\, Y => \I10.N_2321_i_i_0\);
    
    \I8.sstate_s1_0_a2\ : AND2FT
      port map(A => \I8.sstatel1r_net_1\, B => 
        \I8.sstatel0r_net_1\, Y => \I8.sstate_dl2r\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I36_Y\ : AND2
      port map(A => \I10.N264\, B => \I10.N262\, Y => \I10.N276\);
    
    \I2.REG_1l291r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_254_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl291r\);
    
    AE_PDL_padl46r : OB33PH
      port map(PAD => AE_PDL(46), A => AE_PDL_cl46r);
    
    \I2.VDBi_17l0r\ : MUX2L
      port map(A => EVRDY_c, B => \I2.N_1897\, S => 
        \I2.REGMAPl2r_net_1\, Y => \I2.N_1915\);
    
    \I10.CRC32l8r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_95_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l8r_net_1\);
    
    \I3.un16_ae_15_2\ : NAND2
      port map(A => REGl125r, B => REGl122r, Y => 
        \I3.un16_ae_2l15r\);
    
    \I2.REG_1_156\ : MUX2L
      port map(A => REGl166r, B => VDB_inl13r, S => 
        \I2.N_3111_i_0\, Y => \I2.REG_1_156_net_1\);
    
    \I10.un2_i2c_chain_0_0_0_0l1r\ : OR3
      port map(A => \I10.un2_i2c_chain_0_0_0_0_1_il1r\, B => 
        \I10.un2_i2c_chain_0_0_0_0_0_il1r\, C => 
        \I10.un2_i2c_chain_0_0_0_0_3_il1r\, Y => \I10.N_246\);
    
    \I1.UN1_SDANOE_0_SQMUXA_0_O3_129\ : OA21
      port map(A => \I1.sstatel6r_net_1\, B => 
        \I1.sstatel7r_net_1\, C => \I1.N_401\, Y => 
        \I1.N_408_adt_net_8520_\);
    
    \I5.un1_RESCNT_I_78\ : AND2
      port map(A => \I5.RESCNTl6r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_11l0r\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_12_2l0r\);
    
    \I3.un16_ae_45\ : NOR3
      port map(A => \I3.un16_ae_3l47r\, B => \I3.un16_ae_1l47r\, 
        C => \I3.un16_ae_1l45r\, Y => \I3.un16_ael45r\);
    
    \I3.AEl46r\ : MUX2L
      port map(A => REGl199r, B => \I3.un16_ael46r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl46r);
    
    \I2.TCNT2_i_0_il2r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT2_2l2r\, Q => 
        \I2.TCNT2_i_0_il2r_net_1\);
    
    \I2.LB_il5r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il5r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il5r_Rd1__net_1\);
    
    \I2.VDBi_67_ml6r\ : OA21
      port map(A => \I2.VDBi_67l6r_adt_net_49914_\, B => 
        \I2.VDBi_67l6r_adt_net_49916_\, C => \I2.N_1705_i_0_1_0\, 
        Y => \I2.VDBi_67_m_il6r\);
    
    \I2.REG_1l441r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_356_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl441r\);
    
    IACKB_pad : IB33
      port map(PAD => IACKB, Y => IACKB_c);
    
    \I1.AIR_COMMAND_21_0_iv_0l10r\ : AOI21TTF
      port map(A => \I1.sstate2l9r_net_1\, B => REGl99r, C => 
        \I1.CHIP_ADDR_ml1r_net_1\, Y => 
        \I1.AIR_COMMAND_21_0_iv_0l10r_net_1\);
    
    \I10.FID_8_rl31r\ : AND2FT
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.FID_8l31r_adt_net_20590_\, Y => \I10.FID_8l31r\);
    
    \I2.VDBi_85_ml3r\ : NAND3
      port map(A => \I2.VDBil3r_net_1\, B => \I2.N_1721_1\, C => 
        \I2.STATE1_i_il1r\, Y => \I2.VDBi_85_ml3r_net_1\);
    
    \I1.COMMANDl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_1_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl0r_net_1\);
    
    \I10.BNC_NUMBERl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_233_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl3r_net_1\);
    
    \I2.REG_1l397r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_312_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl397r);
    
    \I10.FID_8_IV_0_0_0_1L18R_182\ : AND2
      port map(A => \I10.STATE1l11r_net_1\, B => REGl66r, Y => 
        \I10.FID_8_iv_0_0_0_1_il18r_adt_net_22421_\);
    
    \I10.BNC_NUMBERl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_235_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl5r_net_1\);
    
    \I2.UN1_VSEL_2_I_458\ : NOR2
      port map(A => \I2.N_2892_4\, B => 
        \I2.un1_state1_1_i_a2_0_1_net_1\, Y => 
        \I2.N_2639_adt_net_74747_\);
    
    \I10.EVENT_DWORD_18_rl19r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_0l19r_net_1\, B => 
        \I10.EVENT_DWORD_18l19r_adt_net_26484_\, Y => 
        \I10.EVENT_DWORD_18l19r\);
    
    \I10.FID_180\ : MUX2L
      port map(A => \I10.FID_8l15r\, B => \I10.FIDl15r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_180_net_1\);
    
    \I3.AEl42r\ : MUX2L
      port map(A => REGl195r, B => \I3.un16_ael42r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl42r);
    
    \I2.REG_1_359\ : MUX2L
      port map(A => \I2.REGL444R_28\, B => VDB_inl3r, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_359_net_1\);
    
    \I2.PIPEA_8_RL8R_445\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l8r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l8r_adt_net_57114_\);
    
    \I2.LB_il18r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il18r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il18r_Rd1__net_1\);
    
    \I10.FAULT_STROBE_0_2_0_a3\ : NOR2FT
      port map(A => PSM_SP5_c, B => \I10.CLEAR_PSM_FLAGS_net_1\, 
        Y => \I10.FAULT_STROBE_0_2\);
    
    \I10.EVENT_DWORDl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_134_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl1r_net_1\);
    
    \I2.REG_1_364\ : MUX2H
      port map(A => VDB_inl8r, B => \I2.REGl449r\, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_364_net_1\);
    
    \I2.REG_1l52r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_425_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl52r);
    
    \I2.REG_1l89r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_462_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl89r);
    
    \I10.un1_REG_1_ADD_16x16_medium_I72_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl40r\, Y => 
        \I10.ADD_16x16_medium_I72_Y_0\);
    
    \I2.TCNT2l3r\ : DFF
      port map(CLK => CLKOUT, D => \I2.TCNT2_2l3r\, Q => 
        \I2.TCNT2l3r_net_1\);
    
    \I2.REG3l15r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_122_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl15r\);
    
    \I10.EVENT_DWORD_18_rl22r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l22r_net_1\, B => 
        \I10.EVENT_DWORD_18l22r_adt_net_26064_\, Y => 
        \I10.EVENT_DWORD_18l22r\);
    
    \I2.TCNT3_2_I_36\ : AND3
      port map(A => \I2.DWACT_ADD_CI_0_g_array_1_0l0r\, B => 
        \I2.TCNT3_i_0_il2r_net_1\, C => \I2.TCNT3l3r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_g_array_2_0l0r\);
    
    \I2.REG_1l441r_41\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_356_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL441R_25\);
    
    \I2.LB_sl23r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl23r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl23r_Rd1__net_1\);
    
    \I2.VDBi_17_rl7r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1904_adt_net_48648_\, C => 
        \I2.N_1904_adt_net_48650_\, Y => \I2.VDBi_17l7r\);
    
    \I1.AIR_COMMANDl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_COMMAND_45_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_COMMANDl13r_net_1\);
    
    \I2.PIPEA1l19r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_530_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l19r_net_1\);
    
    \I2.DSS_0\ : DFFS
      port map(CLK => CLKOUT, D => \I2.DSSF1_net_1\, SET => 
        HWRES_c_2_0, Q => TST_CL2R_16);
    
    \I2.VDBi_67_0l2r\ : MUX2L
      port map(A => REGl427r, B => \I2.REGL443R_27\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1951\);
    
    \I2.VAS_95\ : MUX2L
      port map(A => VAD_inl13r, B => \I2.VAS_i_0_il13r\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_95_net_1\);
    
    RSELA1_pad : OTB33PH
      port map(PAD => RSELA1, A => REGl431r, EN => REG_i_0l447r);
    
    \I2.VDBI_24L0R_417\ : AND2FT
      port map(A => \I2.VDBi_24_sl0r_net_1\, B => 
        \I2.VDBi_24_dl0r_net_1\, Y => 
        \I2.VDBi_24l0r_adt_net_54801_\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I51_un1_Y_0\ : OA21FTF
      port map(A => REGl45r, B => REG_i_0l44r, C => 
        \I10.N_2519_1\, Y => \I10.ADD_16x16_medium_I51_un1_Y_0_i\);
    
    \I8.ISI_17\ : MUX2L
      port map(A => SDIN_DAC_c, B => \I8.ISI_5\, S => \I8.N_180\, 
        Y => \I8.ISI_17_net_1\);
    
    \I3.un16_ae_46\ : NOR2
      port map(A => \I3.un16_ae_3l47r\, B => \I3.un16_ae_1l38r\, 
        Y => \I3.un16_ael46r\);
    
    \I2.REG_1_346\ : MUX2L
      port map(A => REGl431r, B => VDB_inl6r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_346_net_1\);
    
    \I10.CRC32_94\ : MUX2H
      port map(A => \I10.CRC32l7r_net_1\, B => \I10.N_1460\, S
         => \I10.N_2351\, Y => \I10.CRC32_94_net_1\);
    
    \I2.VADml21r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl21r_net_1\, Y
         => \I2.VADml21r_net_1\);
    
    \I2.VDBi_67_dl8r\ : MUX2L
      port map(A => LBSP_inl8r, B => \I2.N_1957\, S => 
        \I2.N_1965\, Y => \I2.VDBi_67_dl8r_net_1\);
    
    \I2.VDBI_86_0_IVL22R_332\ : AO21
      port map(A => \I2.PIPEAl22r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il22r\, Y => 
        \I2.VDBi_86l22r_adt_net_41072_\);
    
    \I10.un2_i2c_chain_0_0_0_0_a2_3_2l6r\ : NOR2
      port map(A => \I10.CNTl4r_net_1\, B => \I10.CNTl0r_net_1\, 
        Y => \I10.N_2377_2\);
    
    \I10.EVENT_DWORD_18_RL17R_241\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl27r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l17r_adt_net_26708_\);
    
    \I2.VDBi_54_0_iv_6l8r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_5_il8r\, B => 
        \I2.VDBi_54_0_iv_1_il8r\, C => \I2.VDBi_54_0_iv_2_il8r\, 
        Y => \I2.VDBi_54_0_iv_6_il8r\);
    
    \I2.LB_i_7l4r\ : MUX2L
      port map(A => VDB_inl4r, B => \I2.VASl4r_net_1\, S => 
        \I2.STATE5l2r_adt_net_116440_Rd1__net_1\, Y => 
        \I2.N_1891\);
    
    \I10.FID_8_IV_0_0_0_0L23R_173\ : AND2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.BNC_NUMBERl4r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il23r_adt_net_21643_\);
    
    \I2.REG_1l80r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_453_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl80r);
    
    \I2.LB_i_7l20r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l20r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l20r_Rd1__net_1\);
    
    \I10.un2_i2c_chain_0_i_0_o3_1l5r\ : OR2
      port map(A => \I10.CNTl3r_net_1\, B => \I10.CNTL2R_11\, Y
         => \I10.N_2284\);
    
    \I2.VDBi_61l23r\ : MUX2L
      port map(A => LBSP_inl23r, B => \I2.VDBi_56l23r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l23r_net_1\);
    
    \I2.REG_1_187\ : MUX2L
      port map(A => REGl197r, B => VDB_inl12r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_187_net_1\);
    
    VAD_padl26r : OTB33PH
      port map(PAD => VAD(26), A => \I2.VADml26r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I10.CRC32_3_i_0_0l20r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2335_i_i_0\, Y => \I10.N_1466\);
    
    \I10.WRB_123\ : MUX2L
      port map(A => \I10.WRB_net_1\, B => \I10.N_2627\, S => 
        \I10.N_577\, Y => \I10.WRB_123_net_1\);
    
    SP_PDL_padl29r : IOB33PH
      port map(PAD => SP_PDL(29), A => REGL129R_1, EN => 
        MD_PDL_C_0, Y => SP_PDL_inl29r);
    
    \I2.VADml12r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl12r_net_1\, Y
         => \I2.VADml12r_net_1\);
    
    \I2.LB_i_7l20r\ : AND2
      port map(A => VDB_inl20r, B => \I2.STATE5L2R_74\, Y => 
        \I2.LB_i_7l20r_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L20R_234\ : NOR2
      port map(A => \I10.N_2642_0\, B => \I10.OR_RADDRl0r_net_1\, 
        Y => \I10.EVENT_DWORD_18_i_0_0_0l20r_adt_net_26300_\);
    
    \I10.READ_ADC_FLAG_84_0_0_0\ : OR2
      port map(A => \I10.STATE1l7r_net_1\, B => 
        \I10.READ_ADC_FLAG_84_0_0_0_adt_net_32677_\, Y => 
        \I10.READ_ADC_FLAG_84_0_0_0_net_1\);
    
    SP_PDL_padl6r : IOB33PH
      port map(PAD => SP_PDL(6), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl6r);
    
    \I2.END_PK_510_476\ : NOR3FFT
      port map(A => \I2.N_2830_4\, B => \I2.N_2858\, C => 
        \I2.un1_STATE2_13_adt_net_59330_\, Y => 
        \I2.END_PK_510_adt_net_59370_\);
    
    \I8.SWORD_13\ : MUX2H
      port map(A => \I8.SWORDl12r_net_1\, B => 
        \I8.SWORD_5l12r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_13_net_1\);
    
    VDB_padl31r : IOB33PH
      port map(PAD => VDB(31), A => \I2.VDBml31r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl31r);
    
    \I10.CNT_10_i_0_o3l0r\ : AOI21FTT
      port map(A => \I10.N_2284\, B => \I10.STATE1l8r_net_1\, C
         => \I10.CNT_10_i_0_o3_0l0r_net_1\, Y => \I10.N_2278\);
    
    \I2.VDBml25r\ : MUX2L
      port map(A => \I2.VDBil25r_net_1\, B => \I2.N_2066\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml25r_net_1\);
    
    \I2.un756_regmap_23\ : NOR3FTT
      port map(A => \I2.un756_regmap_19_net_1\, B => 
        \I2.REGMAPl30r_net_1\, C => \I2.REGMAPl13r_net_1\, Y => 
        \I2.un756_regmap_23_net_1\);
    
    \I2.un14_tcnt3_2\ : OR2
      port map(A => \I2.TCNT3_i_0_il2r_net_1\, B => 
        \I2.TCNT3l3r_net_1\, Y => \I2.un14_tcnt3_2_i\);
    
    \I2.TCNT_10_rl4r\ : OA21FTT
      port map(A => \I2.N_1826_0\, B => \I2.I_22_0\, C => 
        \I2.TCNT_0_sqmuxa\, Y => \I2.TCNT_10l4r\);
    
    \I2.REG_1l393r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_308_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl393r);
    
    \I10.CNTl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CNT_10_i_0l4r_net_1\, CLR
         => CLEAR_0_0, Q => \I10.CNTl4r_net_1\);
    
    \I2.PIPEB_4_il20r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl20r, Y => \I2.N_2609\);
    
    \I5.un1_RESCNT_I_92\ : AND2
      port map(A => \I5.RESCNTl4r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r_adt_net_33510_\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_12_1l0r\);
    
    \I1.sstate2se_9_o3\ : NAND2
      port map(A => TICKl0r, B => I2C_RREQ, Y => \I1.N_279\);
    
    \I1.SBYTE_30\ : MUX2H
      port map(A => \I1.SBYTEl2r_net_1\, B => \I1.N_600\, S => 
        \I1.un1_tick_8\, Y => \I1.SBYTE_30_net_1\);
    
    IACKOUTB_pad : OB33PH
      port map(PAD => IACKOUTB, A => \VCC\);
    
    \I2.VDBi_24l10r\ : MUX2L
      port map(A => \I2.REGl484r\, B => \I2.VDBi_19l10r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l10r_net_1\);
    
    \I2.VDBi_86_0_iv_0l23r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l23r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il23r_adt_net_40828_\, Y => 
        \I2.VDBi_86_0_iv_0_il23r\);
    
    \I2.REG_1_ml156r\ : NAND2
      port map(A => REGl156r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml156r_net_1\);
    
    \I2.VDBi_59l11r\ : AND2FT
      port map(A => \I2.VDBi_59_0l9r\, B => 
        \I2.VDBi_59l11r_adt_net_45822_\, Y => 
        \I2.VDBi_59l11r_net_1\);
    
    \I10.STATE1_ns_i_0_0_0_4l0r\ : OA21FTF
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.STATE1_ns_1l3r\, C => \I10.N_2288\, Y => 
        \I10.STATE1_ns_i_0_0_0_4l0r_net_1\);
    
    \I10.FID_8_rl6r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l6r_adt_net_24025_\, Y => \I10.FID_8l6r\);
    
    \I10.STATE1_ns_i_0_0_0l0r\ : AND3FTT
      port map(A => \I10.STATE1_ns_i_0_0_0_3_il0r\, B => 
        \I10.N_2381\, C => \I10.STATE1_ns_i_0_0_0_4l0r_net_1\, Y
         => \I10.N_557_i_0\);
    
    \I2.STATE5L4R_ADT_NET_116400_RD1__484\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_ns_i_il0r_net_1\, 
        SET => HWRES_c_2_0, Q => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__69\);
    
    \I10.un1_CNT_1_I_31\ : AND2
      port map(A => \I10.CNTl2r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_1l0r\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_12l0r\);
    
    \I10.EVENT_DWORDl22r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_155_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl22r_net_1\);
    
    \I2.STATE1_ns_0_a2_1l5r\ : OR3FFT
      port map(A => \I2.BLTCYC_net_1\, B => \I2.N_2909_1\, C => 
        \I2.SINGCYC_net_1\, Y => \I2.N_2909\);
    
    \I3.SBYTEl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.SBYTE_7_0\, CLR => 
        HWRES_c_2_0, Q => REGl141r);
    
    \I3.AEl19r\ : MUX2L
      port map(A => REGl172r, B => \I3.un16_ael19r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl19r);
    
    \I2.nLBAS_81\ : OR2
      port map(A => \I2.nLBAS_81_adt_net_76219_\, B => 
        \I2.N_2271\, Y => \I2.nLBAS_81_net_1\);
    
    \I10.PDL_RADDRl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.PDL_RADDR_229_net_1\, CLR
         => CLEAR_0_0, Q => \I10.PDL_RADDRl5r_net_1\);
    
    \I1.I2C_RDATAl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_16_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl2r);
    
    \I10.BNCRES_CNT_4_G_1_3\ : AND3
      port map(A => BNC_RES, B => \I10.un6_bnc_res_NE_0_net_1\, C
         => \I10.BNCRES_CNTl0r_net_1\, Y => 
        \I10.DWACT_ADD_CI_0_TMP_0l0r\);
    
    \I10.FIDl28r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_193_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl28r_net_1\);
    
    \I10.EVENT_DWORDl17r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_150_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl17r_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l21r\ : OR2
      port map(A => LB_inl21r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, Y => 
        \I2.N_3030\);
    
    \I8.SWORD_5l7r\ : MUX2L
      port map(A => REGl256r, B => \I8.SWORDl6r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l7r_net_1\);
    
    \I2.VDBml8r\ : MUX2L
      port map(A => \I2.VDBil8r_net_1\, B => \I2.N_2049\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml8r_net_1\);
    
    \I2.un1_STATE2_12_0_0_a3\ : NOR3FFT
      port map(A => \I2.STATE2l1r_net_1\, B => \I2.END_PK_net_1\, 
        C => \I2.EVREAD_DS_net_1\, Y => \I2.N_3071_i\);
    
    \I2.VDBi_86_0_iv_0l27r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l27r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il27r_adt_net_40008_\, Y => 
        \I2.VDBi_86_0_iv_0_il27r\);
    
    \I5.SBYTE_9\ : MUX2H
      port map(A => FBOUTl3r, B => \I5.SBYTE_5l3r_net_1\, S => 
        \I5.un1_sstate_12\, Y => \I5.SBYTE_9_net_1\);
    
    \I2.TCNT3_2_I_28\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_2_0l0r\, B => 
        \I2.TCNT3_i_0_il4r_net_1\, Y => \I2.TCNT3_2l4r\);
    
    \I2.VDBi_24l28r\ : MUX2L
      port map(A => \I2.REGl502r\, B => \I2.VDBi_19l28r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l28r_net_1\);
    
    \I3.SBYTE_8\ : MUX2L
      port map(A => REGl142r, B => \I3.SBYTE_5l5r_net_1\, S => 
        \I3.N_167\, Y => \I3.SBYTE_8_0\);
    
    \I2.VDBi_19l8r\ : MUX2L
      port map(A => REGl56r, B => \I2.VDBi_17l8r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l8r_net_1\);
    
    \I2.REG_1_127\ : MUX2L
      port map(A => VDB_inl4r, B => REGl125r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_127_net_1\);
    
    \I2.REG_1_476_e\ : NAND2
      port map(A => \I2.N_1730_0\, B => \I2.N_2265\, Y => 
        \I2.N_3719_i\);
    
    \I10.EVENT_DWORD_18_RL9R_257\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl19r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l9r_adt_net_27604_\);
    
    \I2.VDBi_607\ : MUX2L
      port map(A => \I2.VDBil31r_net_1\, B => \I2.VDBi_86_0l31r\, 
        S => \I2.N_1712_1\, Y => \I2.VDBi_607_net_1\);
    
    \I5.ISCK\ : DFFC
      port map(CLK => CLKOUT, D => \I5.ISCK_4_net_1\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.ISCK_net_1\);
    
    \I10.CRC32l14r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_101_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l14r_net_1\);
    
    \I2.LB_sl26r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl26r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl26r_Rd1__net_1\);
    
    \I1.AIR_CHAIN\ : DFFC
      port map(CLK => CLKOUT, D => \I1.AIR_CHAIN_25_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.AIR_CHAIN_net_1\);
    
    \I2.LB_i_482\ : MUX2L
      port map(A => \I2.LB_il4r_Rd1__net_1\, B => 
        \I2.LB_i_7l4r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__89\, Y => \I2.LB_il4r\);
    
    \I1.SBYTEl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SBYTE_31_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.SBYTEl3r_net_1\);
    
    \I10.UN2_EVREAD_3_I_0_158\ : AND2
      port map(A => \I10.N_2519_1\, B => 
        \I10.un2_evread_3_i_0_a2_0_14_net_1\, Y => 
        \I10.N_926_adt_net_20509_\);
    
    \I10.FIDl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_179_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl14r_net_1\);
    
    SYNC_padl7r : OB33PH
      port map(PAD => SYNC(7), A => SYNC_cl7r);
    
    \I5.ISI_0_sqmuxa_0_a2_0\ : AND2
      port map(A => \I5.sstatel2r_net_1\, B => 
        \I5.BITCNTl2r_net_1\, Y => \I5.ISI_0_sqmuxa_0_a2_0_net_1\);
    
    \I2.VDBi_582\ : MUX2L
      port map(A => \I2.VDBil6r_net_1\, B => \I2.VDBi_86l6r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_582_net_1\);
    
    \I10.BNC_NUMBERl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_NUMBER_231_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.BNC_NUMBERl1r_net_1\);
    
    \I10.FID_8_RL29R_162\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl29r_net_1\, C => \I10.N_2503_i\, Y => 
        \I10.FID_8l29r_adt_net_20740_\);
    
    \I5.ISCK_4\ : MUX2H
      port map(A => \I5.ISCK_net_1\, B => \I5.sstate_i_0_il4r\, S
         => \I5.N_218\, Y => \I5.ISCK_4_net_1\);
    
    \I10.CYC_STAT_1_2_0_a3\ : AND2FT
      port map(A => \I10.CLEAR_PSM_FLAGS_net_1\, B => 
        \I10.CYC_STAT_0_net_1\, Y => \I10.CYC_STAT_1_2\);
    
    LBSP_padl2r : IOB33PH
      port map(PAD => LBSP(2), A => REGl395r, EN => REG_i_0l267r, 
        Y => LBSP_inl2r);
    
    \I1.AIR_CHAIN_1_sqmuxa_0_a3\ : NOR2FT
      port map(A => \I1.sstate2l9r_net_1\, B => I2C_RREQ, Y => 
        \I1.N_3146_i\);
    
    \I2.un2_reg_ads_0_a3\ : NOR3
      port map(A => \I2.N_3055\, B => \I2.VASl7r_net_1\, C => 
        \I2.VASl8r_net_1\, Y => \I2.N_3056\);
    
    \I2.REG_1_342\ : MUX2L
      port map(A => REGl427r, B => VDB_inl2r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_342_net_1\);
    
    \I2.UN756_REGMAP_11_0_297\ : OR3
      port map(A => \I2.REGMAPl29r_net_1\, B => 
        \I2.REGMAP_i_il25r\, C => \I2.REGMAPl33r_net_1\, Y => 
        \I2.un756_regmap_11_0_i_adt_net_36347_\);
    
    \I1.SDAout\ : DFFS
      port map(CLK => CLKOUT, D => \I1.SDAout_36_net_1\, SET => 
        HWRES_c_2_0, Q => \I1.SDAout_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_a2_0l5r\ : NAND3FTT
      port map(A => \I10.CNTl5r_net_1\, B => \I10.N_2296\, C => 
        \I10.N_2302\, Y => \I10.N_2404\);
    
    \I10.REG_1l35r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I67_Y\, 
        CLR => CLEAR_0_0, Q => \I10.REGl35r\);
    
    \I10.FID_8_IV_0_0_0_0L9R_200\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.FID_4l9r\, Y
         => \I10.FID_8_iv_0_0_0_0l9r_adt_net_23603_\);
    
    \I8.un1_BITCNT_I_11\ : XOR2
      port map(A => \I8.BITCNTl0r_net_1\, B => 
        \I8.un1_ISI_1_sqmuxa_0_o2_net_1\, Y => 
        \I8.DWACT_ADD_CI_0_partial_suml0r\);
    
    \I5.RESCNTl12r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l12r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl12r_net_1\);
    
    SP_PDL_padl10r : IOB33PH
      port map(PAD => SP_PDL(10), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl10r);
    
    \I10.STATE1_ns_0l10r\ : OAI21FTF
      port map(A => \I10.STATE1l3r_net_1\, B => \I10.N_2286\, C
         => \I10.N_2395_i\, Y => \I10.STATE1_nsl10r\);
    
    \I2.VDBil9r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_585_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil9r_net_1\);
    
    \I2.REG_1l460r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_375_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl460r);
    
    \I10.STATE1_ns_i_0_0_0_2l0r\ : OR2
      port map(A => \I10.STATE1l7r_net_1\, B => 
        \I10.STATE1l8r_net_1\, Y => \I10.N_557_2\);
    
    \I2.PIPEAl14r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_558_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl14r_net_1\);
    
    \I2.VDBi_579\ : MUX2L
      port map(A => \I2.VDBil3r_net_1\, B => \I2.VDBi_86l3r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_579_net_1\);
    
    \I2.VADml27r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl27r_net_1\, Y
         => \I2.VADml27r_net_1\);
    
    \I10.un6_bnc_res_2\ : XOR2
      port map(A => \I10.BNC_CNTl2r_net_1\, B => REGl459r, Y => 
        \I10.un6_bnc_res_2_i_i\);
    
    \I2.LB_sl25r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl25r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl25r_Rd1__net_1\);
    
    \I2.PIPEA1_517\ : MUX2L
      port map(A => \I2.PIPEA1l6r_net_1\, B => \I2.N_2509\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_517_net_1\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L24R_226\ : NOR2
      port map(A => \I10.N_2642_0\, B => \I10.OR_RADDRl4r_net_1\, 
        Y => \I10.EVENT_DWORD_18_i_0_0_0l24r_adt_net_25684_\);
    
    \I2.STATE5_ns_i_i_a2_0_1l0r\ : NOR2
      port map(A => \I2.STATE5l1r_Rd1_\, B => \I2.STATE5L1R_104\, 
        Y => \I2.N_2386_1\);
    
    SPULSE1_pad : IB33
      port map(PAD => SPULSE1, Y => SPULSE1_c);
    
    \I2.VDBI_67L5R_392\ : AND2FT
      port map(A => \I2.N_1965\, B => \I2.N_1954\, Y => 
        \I2.VDBi_67l5r_adt_net_50719_\);
    
    \I10.FIDl30r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_195_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl30r_net_1\);
    
    \I2.un14_tcnt3_0\ : OR2
      port map(A => \I2.TCNT3_i_0_il6r_net_1\, B => 
        \I2.TCNT3l7r_net_1\, Y => \I2.un14_tcnt3_0_i\);
    
    \I2.PIPEB_4_il13r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl13r, Y => \I2.N_2595\);
    
    \I3.un4_so_15_0\ : MUX2L
      port map(A => SP_PDL_inl26r, B => \I3.N_210\, S => REGl126r, 
        Y => \I3.N_211\);
    
    \I2.PIPEA1l27r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_538_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l27r_net_1\);
    
    \I1.AIR_COMMAND_21_0_ivl10r\ : AO21TTF
      port map(A => \I1.AIR_COMMAND_cnstl10r\, B => \I1.N_256\, C
         => \I1.AIR_COMMAND_21_0_iv_0l10r_net_1\, Y => 
        \I1.AIR_COMMAND_21l10r\);
    
    \I3.un16_ae_23_1\ : NAND2FT
      port map(A => REGl125r, B => REGl126r, Y => 
        \I3.un16_ae_1l23r\);
    
    \I2.un1_STATE1_27_i_o3\ : NOR2
      port map(A => \I2.N_1717\, B => \I2.N_1783\, Y => 
        \I2.N_1734_i\);
    
    \I5.un1_RESCNT_I_58\ : XOR2
      port map(A => \I5.RESCNTl12r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r\, Y => \I5.I_58\);
    
    \I2.VDBi_19l12r\ : MUX2L
      port map(A => REGl60r, B => \I2.VDBi_17l12r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l12r_net_1\);
    
    \I2.PIPEBl23r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_72_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl23r_net_1\);
    
    \I3.un16_ae_1\ : NOR2
      port map(A => \I3.un16_ae_1l1r\, B => \I3.un16_ae_1l7r\, Y
         => \I3.un16_ael1r\);
    
    \I2.un756_regmap_25\ : NAND3
      port map(A => \I2.un756_regmap_23_net_1\, B => 
        \I2.VDBi_9_sqmuxa_i_1_net_1\, C => 
        \I2.un756_regmap_18_net_1\, Y => \I2.un756_regmap_25_i\);
    
    \I2.TCNT3_2_I_44\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_1_0l0r\, B => 
        \I2.TCNT3_i_0_il2r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_12_0l0r\);
    
    \I2.TCNT_i_0_0l4r\ : NAND2FT
      port map(A => HWRES_C_2_0_19, B => WDOGTO_i_0, Y => 
        \I2.N_2483_i_0_0_0\);
    
    \I2.PIPEA1l7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_518_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l7r_net_1\);
    
    \I2.REG_il286r\ : INV
      port map(A => \I2.REGl286r\, Y => REG_i_0l286r);
    
    \I10.un3_bnc_cnt_I_91\ : XOR2
      port map(A => \I10.BNC_CNTl15r_net_1\, B => \I10.N_26\, Y
         => \I10.I_91\);
    
    \I2.PIPEA1_9_il21r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl21r, Y => \I2.N_2539\);
    
    \I2.TICKil2r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un14_tcnt3_net_1\, Q => 
        TICKl2r);
    
    \I2.VDBi_19l4r\ : MUX2L
      port map(A => REGl52r, B => \I2.VDBi_17l4r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l4r_net_1\);
    
    \I10.FAULT_STROBE_2_i\ : OR2FT
      port map(A => \I10.FAULT_STROBE_0_net_1\, B => 
        \I10.CLEAR_PSM_FLAGS_net_1\, Y => 
        \I10.FAULT_STROBE_2_i_net_1\);
    
    \I10.un2_i2c_chain_0_i_0_a2_5l5r\ : OR3FFT
      port map(A => \I10.CNTl0r_net_1\, B => \I10.N_2649\, C => 
        \I10.CNTl3r_net_1\, Y => \I10.N_2409\);
    
    LED_padl5r : OB33PH
      port map(PAD => LED(5), A => \VCC\);
    
    \I2.LB_s_15\ : MUX2L
      port map(A => \I2.LB_sl1r_Rd1__net_1\, B => 
        \I2.N_3023_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116360_Rd1__net_1\, Y => 
        \I2.LB_sl1r\);
    
    \I2.REG_1_344\ : MUX2L
      port map(A => REGl429r, B => VDB_inl4r, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_344_net_1\);
    
    \I2.PIPEBl11r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_60_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl11r_net_1\);
    
    \I3.un1_BITCNT_I_9\ : XOR2
      port map(A => \I3.BITCNTl0r_net_1\, B => 
        \I3.un1_hwres_3_net_1\, Y => 
        \I3.DWACT_ADD_CI_0_partial_suml0r\);
    
    \I2.UN1_STATE5_9_1_RD1__495\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_91\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__80\);
    
    \I10.un2_i2c_chain_0_0_0_0_a3l3r\ : AND3FFT
      port map(A => \I10.CNTL2R_11\, B => \I10.CNTl4r_net_1\, C
         => \I10.N_2283_i_i_0\, Y => \I10.N_2645_i\);
    
    \I10.UN1_CNT_1_G_144\ : AND2
      port map(A => \I10.CNTl1r_net_1\, B => \I10.CNTl0r_net_1\, 
        Y => \I10.DWACT_ADD_CI_0_g_array_1l0r_adt_net_16050_\);
    
    \I1.SCL_1_iv_i_a2\ : OR2
      port map(A => \I1.N_634\, B => \I1.N_661_adt_net_11089_\, Y
         => \I1.N_661\);
    
    \I3.SBYTEl0r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.SBYTE_3_net_1\, CLR => 
        HWRES_c_2_0, Q => REGl137r);
    
    \I1.AIR_COMMAND_21_0_ivl11r\ : AO21
      port map(A => \I1.N_565_i_i\, B => CHIP_ADDRl2r, C => 
        \I1.AIR_COMMAND_21l11r_adt_net_9280_\, Y => 
        \I1.AIR_COMMAND_21l11r\);
    
    \I5.sstatel5r\ : DFFS
      port map(CLK => CLKOUT, D => \I5.sstate_nsl0r_net_1\, SET
         => \I5.un2_hwres_2_net_1\, Q => \I5.sstatel5r_net_1\);
    
    \I2.REG_1_216\ : MUX2L
      port map(A => VDB_inl4r, B => REGl253r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_216_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l10r\ : OR2
      port map(A => LB_inl10r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__70\, Y => \I2.N_3045\);
    
    \I10.un3_bnc_cnt_I_73\ : XOR2
      port map(A => \I10.BNC_CNT_i_il12r\, B => \I10.N_39\, Y => 
        \I10.I_73\);
    
    \I2.PIPEA_549\ : MUX2L
      port map(A => \I2.PIPEAl5r_net_1\, B => \I2.PIPEA_8l5r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_549_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l16r\ : OR2
      port map(A => LB_inl16r, B => 
        \I2.STATE5L4R_ADT_NET_116400_RD1__68\, Y => \I2.N_3025\);
    
    \I2.PIPEA_8_rl16r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl16r, C => 
        \I2.PIPEA_8l16r_adt_net_56517_\, Y => \I2.PIPEA_8l16r\);
    
    \I10.CRC32_118\ : MUX2H
      port map(A => \I10.CRC32l31r_net_1\, B => \I10.N_1365\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_118_net_1\);
    
    \I2.VDBi_67_0l0r\ : MUX2L
      port map(A => REGl425r, B => \I2.REGL441R_25\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1949\);
    
    \I1.SBYTE_9_iv_0l0r\ : AO21
      port map(A => \I1.N_630\, B => \I1.sstatel5r_net_1\, C => 
        \I1.SBYTE_9l0r_adt_net_10933_\, Y => \I1.SBYTE_9l0r\);
    
    \I2.REGMAPl20r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un67_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl20r_net_1\);
    
    \I2.VDBi_67_0l5r\ : MUX2L
      port map(A => REGl430r, B => \I2.REGL446R_30\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1954\);
    
    \I2.REG_1_227\ : MUX2L
      port map(A => VDB_inl15r, B => REGl264r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_227_net_1\);
    
    \I2.I_743_0_0\ : OR3FFT
      port map(A => \I2.WRITES_net_1\, B => \I2.SINGCYC_net_1\, C
         => \I2.I_743_0_i\, Y => \I2.N_1826_0\);
    
    \I10.BNC_CNT_207\ : MUX2H
      port map(A => \I10.BNC_CNTl9r_net_1\, B => 
        \I10.BNC_CNT_4l9r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_207_net_1\);
    
    \I3.un4_so_19_0\ : MUX2L
      port map(A => SP_PDL_inl46r, B => SP_PDL_inl14r, S => 
        REGl127r, Y => \I3.N_215\);
    
    \I10.un2_i2c_chain_0_i_0_1l5r\ : AO21FTF
      port map(A => \I10.CNTl1r_net_1\, B => \I10.N_2280\, C => 
        \I10.N_2409\, Y => \I10.un2_i2c_chain_0_i_0_1_il5r\);
    
    \I2.REG3l5r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_112_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl5r);
    
    \I2.VASl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_83_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VASl1r_net_1\);
    
    \I10.FID_195\ : MUX2L
      port map(A => \I10.FID_8l30r\, B => \I10.FIDl30r_net_1\, S
         => \I10.un1_STATE1_15_1\, Y => \I10.FID_195_net_1\);
    
    \I2.STATE1_ns_0_a3l0r\ : AND2
      port map(A => TST_CL2R_16, B => \I2.STATE1l6r_net_1\, Y => 
        \I2.N_3062\);
    
    \I10.un3_bnc_cnt_I_24\ : XOR2
      port map(A => \I10.BNC_CNTl5r_net_1\, B => \I10.N_74\, Y
         => \I10.I_24\);
    
    VAD_padl9r : IOB33PH
      port map(PAD => VAD(9), A => \I2.VADml9r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl9r);
    
    \I5.un1_RESCNT_I_51\ : XOR2
      port map(A => \I5.RESCNTl2r_net_1\, B => 
        \I5.DWACT_ADD_CI_0_g_array_1l0r\, Y => \I5.I_51\);
    
    \I5.un1_RESCNT_G\ : AND3
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_2l0r\, B => 
        \I5.DWACT_ADD_CI_0_pog_array_2_1l0r\, C => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r_adt_net_33510_\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_10l0r\);
    
    \I2.REG_1_464\ : MUX2H
      port map(A => VDB_inl2r, B => REGl91r, S => \I2.N_3719_i\, 
        Y => \I2.REG_1_464_net_1\);
    
    DIR_CTTM_padl1r : OB33PH
      port map(PAD => DIR_CTTM(1), A => \VCC\);
    
    \I2.N_1705_i_0_a2_1_0\ : NOR2FT
      port map(A => \I2.N_1782\, B => \I2.N_1705_i_0_1\, Y => 
        \I2.N_1705_i_0_1_0\);
    
    \I1.sstatel10r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate_ns_el3r\, CLR => 
        HWRES_c_2_0, Q => \I1.sstatel10r_net_1\);
    
    \I8.SWORD_3\ : MUX2H
      port map(A => \I8.SWORDl2r_net_1\, B => 
        \I8.SWORD_5l2r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_3_net_1\);
    
    \I2.STATE1_ns_o3_i_a2_0_a2_1l3r\ : AND2
      port map(A => \I2.REGMAPl35r_net_1\, B => 
        \I2.NLBRDY_s_net_1\, Y => \I2.N_2981_1\);
    
    \I2.PIPEA_8_RL0R_453\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l0r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l0r_adt_net_57674_\);
    
    \I2.VDBi_86_iv_0l5r\ : AO21TTF
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.VDBi_82l5r_net_1\, C => \I2.VDBi_85_ml5r_net_1\, Y
         => \I2.VDBi_86_iv_0_il5r\);
    
    \I10.un6_bnc_res_6\ : XOR2
      port map(A => \I10.BNC_CNTl6r_net_1\, B => REGl463r, Y => 
        \I10.un6_bnc_res_6_i_i\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I68_Y\ : XOR2
      port map(A => \I10.un1_REG_1_1l36r\, B => \I10.N279\, Y => 
        \I10.ADD_16x16_medium_I68_Y\);
    
    \I2.VDBml19r\ : MUX2L
      port map(A => \I2.VDBil19r_net_1\, B => \I2.N_2060\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml19r_net_1\);
    
    \I2.STATE5l1r_116_129\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5l1r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5L1R_RD1__113\);
    
    \I3.un4_pulse\ : NAND2FT
      port map(A => MD_PDL_C_24, B => PULSEl8r, Y => 
        \I3.un4_pulse_net_1\);
    
    \I3.un16_ae_15_1\ : OR2
      port map(A => REGl127r, B => REGl126r, Y => 
        \I3.un16_ae_1l15r\);
    
    \I2.PIPEA_8_RL12R_441\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l12r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l12r_adt_net_56797_\);
    
    \I2.VDBi_19l6r\ : MUX2L
      port map(A => REGl54r, B => \I2.VDBi_17l6r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l6r_net_1\);
    
    \I2.VDBI_67L4R_398\ : AND2FT
      port map(A => \I2.N_1965\, B => \I2.N_1953\, Y => 
        \I2.VDBi_67l4r_adt_net_51522_\);
    
    \I10.EVENT_DWORD_18_i_0_0_1l21r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl29r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l21r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l21r_net_1\);
    
    \I2.VDBi_61_dl5r\ : MUX2L
      port map(A => LBSP_inl5r, B => REGl382r, S => 
        \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61_dl5r_net_1\);
    
    \I2.VDBI_54_0_IV_0L2R_408\ : AND2
      port map(A => \I2.REGMAP_i_il17r\, B => REGl139r, Y => 
        \I2.VDBi_54_0_iv_0_il2r_adt_net_53020_\);
    
    \I2.VDBI_86_0_IVL30R_316\ : AO21
      port map(A => \I2.PIPEAl30r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il30r\, Y => 
        \I2.VDBi_86l30r_adt_net_39432_\);
    
    \I2.PIPEB_4_il0r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl0r, Y => \I2.N_2569\);
    
    \I2.VDBml26r\ : MUX2L
      port map(A => \I2.VDBil26r_net_1\, B => \I2.N_2067\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml26r_net_1\);
    
    \I2.REG_1l293r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_256_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl293r\);
    
    \I2.PIPEA1l8r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_519_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l8r_net_1\);
    
    \I1.I2C_RDATA_9_il3r\ : MUX2L
      port map(A => I2C_RDATAl3r, B => REGl114r, S => 
        \I1.sstate2_0_sqmuxa_4_0\, Y => \I1.N_580\);
    
    \I2.REG_1_208\ : MUX2L
      port map(A => REG_cl245r, B => VDB_inl12r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_208_net_1\);
    
    \I2.VDBil28r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_604_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil28r_net_1\);
    
    \I2.PIPEAl20r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_564_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl20r_net_1\);
    
    \I2.PIPEA1_9_il16r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl16r, Y => \I2.N_2529\);
    
    \I2.VDBi_61l29r\ : MUX2L
      port map(A => LBSP_inl29r, B => \I2.VDBi_56l29r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l29r_net_1\);
    
    \I2.REG_1_229\ : MUX2L
      port map(A => \I2.REGL266R_34\, B => VDB_inl1r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_229_net_1\);
    
    \I2.DSS\ : DFFS
      port map(CLK => CLKOUT, D => \I2.DSSF1_net_1\, SET => 
        HWRES_c_2_0, Q => TST_cl2r);
    
    \I2.VDBml2r\ : MUX2L
      port map(A => \I2.VDBil2r_net_1\, B => \I2.N_2043\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml2r_net_1\);
    
    \I10.FID_8_iv_0_0_0_0l24r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl8r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il24r_adt_net_21479_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il24r\);
    
    \I2.REG_1_ml158r\ : NAND2
      port map(A => REGl158r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml158r_net_1\);
    
    \I2.VDBm_0l25r\ : MUX2L
      port map(A => \I2.PIPEAl25r_net_1\, B => 
        \I2.PIPEBl25r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2066\);
    
    \I2.VDBi_61l25r\ : MUX2L
      port map(A => LBSP_inl25r, B => \I2.VDBi_56l25r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l25r_net_1\);
    
    \I2.PIPEA_8_RL1R_452\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l1r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l1r_adt_net_57604_\);
    
    \I2.UN1_STATE5_9_1_RD1__502\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.un1_STATE5_9_1\, CLR => 
        HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__87\);
    
    VAD_padl8r : IOB33PH
      port map(PAD => VAD(8), A => \I2.VADml8r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl8r);
    
    AE_PDL_padl18r : OB33PH
      port map(PAD => AE_PDL(18), A => AE_PDL_cl18r);
    
    \I2.VDBi_19l24r\ : AND2
      port map(A => TST_cl5r, B => REGl72r, Y => 
        \I2.VDBi_19l24r_net_1\);
    
    \I10.BNC_CNT_4_0_a2l15r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_0_net_1\, B => \I10.I_91\, 
        Y => \I10.BNC_CNT_4l15r\);
    
    \I2.VDBi_54_0_iv_3l6r\ : AO21TTF
      port map(A => REGL127R_3, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l6r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il6r\);
    
    SCLK_DAC_pad : OB33PH
      port map(PAD => SCLK_DAC, A => SCLK_DAC_c);
    
    \I2.STATE1_ns_0_o2l0r\ : AOI21
      port map(A => TST_cl0r, B => \I2.STATE1l4r_net_1\, C => 
        \I2.N_3062\, Y => \I2.N_2837\);
    
    \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119373_\ : BFR
      port map(A => \I2.STATE5L4R_ADT_NET_116396_RD1__101\, Y => 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119373__net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I74_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl42r\, Y => 
        \I10.ADD_16x16_medium_I74_Y_0\);
    
    \I2.LWORDS\ : DFFC
      port map(CLK => CLKOUT, D => \I2.LWORDS_47_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.LWORDS_net_1\);
    
    AE_PDL_padl36r : OB33PH
      port map(PAD => AE_PDL(36), A => AE_PDL_cl36r);
    
    \I2.REG_1_177\ : MUX2L
      port map(A => REGl187r, B => VDB_inl2r, S => 
        \I2.N_3175_i_0\, Y => \I2.REG_1_177_net_1\);
    
    \I2.LB_s_30\ : MUX2L
      port map(A => \I2.LB_sl16r_Rd1__net_1\, B => 
        \I2.N_3025_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116352_Rd1__net_1\, Y => 
        \I2.LB_sl16r\);
    
    \I10.READ_OR_FLAG_85_i_0_0\ : NOR3
      port map(A => \I10.STATE1l12r_net_1\, B => \I10.N_557_2\, C
         => \I10.N_2396\, Y => \I10.READ_OR_FLAG_85_i_0_0_net_1\);
    
    \I2.VDBi_67_0l3r\ : MUX2L
      port map(A => REGl428r, B => \I2.REGL444R_28\, S => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_1952\);
    
    \I3.un16_ae_41\ : NOR2
      port map(A => \I3.un16_ae_3l47r\, B => \I3.un16_ae_1l33r\, 
        Y => \I3.un16_ael41r\);
    
    \I2.VDBi_86_iv_1l8r\ : AOI21TTF
      port map(A => \I2.PIPEAl8r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_iv_0l8r_net_1\, Y => 
        \I2.VDBi_86_iv_1l8r_net_1\);
    
    \I10.un3_bnc_cnt_I_115\ : XOR2
      port map(A => \I10.BNC_CNT_i_il18r\, B => \I10.N_9\, Y => 
        \I10.I_115\);
    
    \I10.un2_i2c_chain_0_0_0_0_a3_0l1r\ : OR2
      port map(A => \I10.CNTl1r_net_1\, B => \I10.N_2290\, Y => 
        \I10.N_2727\);
    
    \I10.un2_i2c_chain_0_0_0_0l3r\ : OR3FFT
      port map(A => \I10.un2_i2c_chain_0_0_0_0_3l3r_net_1\, B => 
        \I10.un2_i2c_chain_0_i_0_0_i_1l2r_net_1\, C => 
        \I10.un2_i2c_chain_0_0_0_0_2_il3r\, Y => \I10.N_248\);
    
    \I2.VDBi_56l31r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l31r_net_1\, Y => \I2.VDBi_56l31r_net_1\);
    
    \I2.VDBI_61L4R_397\ : AND2FT
      port map(A => \I2.VDBi_61_sl0r_net_1\, B => 
        \I2.VDBi_61_dl4r_net_1\, Y => 
        \I2.VDBi_61l4r_adt_net_51480_\);
    
    \I2.PIPEA1l28r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEA1_539_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEA1l28r_net_1\);
    
    \I10.EVENT_DWORD_18_RL5R_265\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl15r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l5r_adt_net_28127_\);
    
    \I2.VDBi_54_0_iv_5l0r\ : AO21TTF
      port map(A => MD_PDL_C_22, B => \I2.REGMAPl16r_net_1\, C
         => \I2.VDBi_54_0_iv_3l0r_net_1\, Y => 
        \I2.VDBi_54_0_iv_5_il0r\);
    
    \I1.AIR_COMMAND_21l2r\ : MUX2L
      port map(A => REGl91r, B => \I1.N_487\, S => 
        \I1.sstate2l9r_net_1\, Y => \I1.AIR_COMMAND_21l2r_net_1\);
    
    SP_PDL_padl9r : IOB33PH
      port map(PAD => SP_PDL(9), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl9r);
    
    \I2.VDBml20r\ : MUX2L
      port map(A => \I2.VDBil20r_net_1\, B => \I2.N_2061\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml20r_net_1\);
    
    \I2.PIPEAl19r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_563_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl19r_net_1\);
    
    \I10.un6_bnc_res_11\ : XOR2
      port map(A => \I10.BNC_CNTl11r_net_1\, B => REGl468r, Y => 
        \I10.un6_bnc_res_11_i_i\);
    
    \I2.PIPEA_553\ : MUX2L
      port map(A => \I2.PIPEAl9r_net_1\, B => \I2.PIPEA_8l9r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_553_net_1\);
    
    \I2.REG_1_sqmuxa_2_0_o3\ : AND2
      port map(A => \I2.STATE1l7r_net_1\, B => 
        \I2.REGMAP_i_0_il11r\, Y => \I2.N_2265\);
    
    \I2.VDBi_67_ml3r\ : OA21
      port map(A => \I2.VDBi_67l3r_adt_net_52323_\, B => 
        \I2.VDBi_67l3r_adt_net_52325_\, C => \I2.N_1705_i_0_1_0\, 
        Y => \I2.VDBi_67_m_il3r\);
    
    P_PDL_padl5r : OB33PH
      port map(PAD => P_PDL(5), A => REG_cl134r);
    
    \I10.un6_bnc_res_NE_11\ : OR3
      port map(A => \I10.BNC_CNT_i_il13r\, B => 
        \I10.BNC_CNTl16r_net_1\, C => 
        \I10.un6_bnc_res_NE_11_i_adt_net_16263_\, Y => 
        \I10.un6_bnc_res_NE_11_i\);
    
    VAD_padl19r : OTB33PH
      port map(PAD => VAD(19), A => \I2.VADml19r_net_1\, EN => 
        NOEAD_c_0_0);
    
    \I2.REG_1l121r_40\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_123_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => MD_PDL_C_24);
    
    \I2.PIPEAl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_545_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl1r_net_1\);
    
    \I2.VDBi_82l4r\ : MUX2L
      port map(A => \I2.VDBil4r_net_1\, B => FBOUTl4r, S => 
        \I2.N_1721_1\, Y => \I2.VDBi_82l4r_net_1\);
    
    \I2.REGMAPl29r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un106_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl29r_net_1\);
    
    \I2.VDBI_67_ML1R_478\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l1r_adt_net_95714_\, C => 
        \I2.VDBi_67_m_il1r_adt_net_103772_\, Y => 
        \I2.VDBi_67_m_il1r\);
    
    \I10.FID_8_rl12r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l12r_adt_net_23276_\, Y => \I10.FID_8l12r\);
    
    \I2.UN1_STATE1_27_I_1_299\ : NOR3
      port map(A => \I2.N_1885_1\, B => \I2.N_1734_i\, C => 
        \I2.STATE1l6r_net_1\, Y => \I2.N_1712_1_adt_net_36665_\);
    
    \I2.LB_sl9r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl9r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl9r_Rd1__net_1\);
    
    \I2.PIPEA1_511\ : MUX2L
      port map(A => \I2.PIPEA1l0r_net_1\, B => \I2.N_2497\, S => 
        \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_511_net_1\);
    
    \I2.VDBi_86_iv_0l7r\ : AO21TTF
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.VDBi_82l7r_net_1\, C => \I2.VDBi_85_ml7r_net_1\, Y
         => \I2.VDBi_86_iv_0_il7r\);
    
    \I2.REG3l14r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG3_121_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl14r\);
    
    \I1.SDAnoe_del2\ : DFFC
      port map(CLK => CLKOUT, D => \I1.SDAnoe_del1_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.SDAnoe_del2_net_1\);
    
    \I2.PIPEAl15r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_559_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl15r_net_1\);
    
    \I3.un4_so_10_0\ : MUX2L
      port map(A => \I3.N_205\, B => \I3.N_203\, S => REGl125r, Y
         => \I3.N_206\);
    
    \I2.REG_1l85r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_458_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl85r);
    
    \I2.VDBi_86_0_iv_0l19r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl19r\, C
         => \I2.VDBi_86l19r_adt_net_41715_\, Y => 
        \I2.VDBi_86l19r\);
    
    \I2.N_3042_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3042\, SET => 
        HWRES_c_2_0, Q => \I2.N_3042_Rd1__net_1\);
    
    \I10.EVENT_DWORD_158\ : MUX2H
      port map(A => \I10.EVENT_DWORDl25r_net_1\, B => 
        \I10.EVENT_DWORD_18l25r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_158_net_1\);
    
    \I2.TCNT2_2_I_42\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_2l0r\, B => 
        \I2.TCNT2_i_0_il4r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_12_1l0r\);
    
    \I2.N_3016_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3016\, SET => 
        HWRES_c_2_0, Q => \I2.N_3016_Rd1__net_1\);
    
    \I8.SWORD_5l15r\ : MUX2L
      port map(A => REGl264r, B => \I8.SWORDl14r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l15r_net_1\);
    
    \I10.BNC_CNTl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_205_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl7r_net_1\);
    
    \I1.un1_tick_8_0_0_o2_0\ : OR2
      port map(A => \I1.sstatel5r_net_1\, B => 
        \I1.sstatel8r_net_1\, Y => \I1.N_632\);
    
    \I2.VDBI_54_0_IV_0L12R_358\ : AND2
      port map(A => REGl117r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.VDBi_54_0_iv_0_il12r_adt_net_44950_\);
    
    \I0.HWRES_c_i\ : AND2
      port map(A => NPWON_c, B => SYSRESB_c, Y => HWRES_c_i_0);
    
    \I2.PIPEA1_528\ : MUX2L
      port map(A => \I2.PIPEA1l17r_net_1\, B => \I2.N_2531\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_528_net_1\);
    
    \I2.LB_sl3r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl3r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl3r_Rd1__net_1\);
    
    \I2.VAS_93\ : MUX2L
      port map(A => VAD_inl11r, B => \I2.VAS_i_0_il11r\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_93_net_1\);
    
    \I2.VDBi_24l16r\ : MUX2L
      port map(A => \I2.REGl490r\, B => \I2.VDBi_19l16r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l16r_net_1\);
    
    \I2.REG_1_418\ : MUX2H
      port map(A => VDB_inl29r, B => \I2.REGl503r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_418_net_1\);
    
    \I3.ISI_5_IV_466\ : AND2
      port map(A => REGl144r, B => \I3.sstatel1r_net_1\, Y => 
        \I3.ISI_5_adt_net_82913_\);
    
    \I10.un1_REG_1_un1_REG_1_il44r\ : XOR2
      port map(A => \I10.N302\, B => 
        \I10.ADD_16x16_medium_I76_Y_0\, Y => 
        \I10.un1_REG_1_il44r\);
    
    SYNC_padl4r : OB33PH
      port map(PAD => SYNC(4), A => SYNC_cl4r);
    
    \I10.CRC32l18r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_105_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l18r_net_1\);
    
    \I10.L2RS\ : AND2FT
      port map(A => \I10.L2RF3_net_1\, B => \I10.L2RF2_net_1\, Y
         => REGl383r);
    
    \I2.VDBi_24l27r\ : MUX2L
      port map(A => \I2.REGl501r\, B => \I2.VDBi_19l27r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l27r_net_1\);
    
    \I2.VDBi_17_0l4r\ : AOI21
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl4r\, C => 
        \I2.REGMAPl6r_net_1\, Y => \I2.N_1901_adt_net_51085_\);
    
    \I2.REGMAPl28r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un102_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl28r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_1l23r\ : OAI21TTF
      port map(A => \I10.N_2635_i_1\, B => 
        \I10.EVENT_DWORDl31r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l23r_net_1\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_1l23r_net_1\);
    
    NOEDTK_pad : OB33PH
      port map(PAD => NOEDTK, A => TST_C_CL3R_23);
    
    \I1.sstate2se_2_i\ : MUX2L
      port map(A => \I1.sstate2l6r_net_1\, B => 
        \I1.sstate2l7r_net_1\, S => \I1.N_277_0\, Y => 
        \I1.sstate2se_2_i_net_1\);
    
    \I2.REG_1_137\ : MUX2H
      port map(A => REG_cl135r, B => VDB_inl14r, S => 
        \I2.PULSE_1_sqmuxa_8_0_net_1\, Y => \I2.REG_1_137_net_1\);
    
    \I2.REG_1_355_e_0\ : NAND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl31r_net_1\, Y => \I2.N_3495_i_0\);
    
    \I2.PIPEB_4_il8r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl8r, Y => \I2.N_2585\);
    
    AE_PDL_padl6r : OB33PH
      port map(PAD => AE_PDL(6), A => AE_PDL_cl6r);
    
    \I2.LB_s_45\ : MUX2L
      port map(A => \I2.LB_sl31r_Rd1__net_1\, B => 
        \I2.N_3016_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116344_Rd1__net_1\, Y => 
        \I2.LB_sl31r\);
    
    \I2.VDBm_0l27r\ : MUX2L
      port map(A => \I2.PIPEAl27r_net_1\, B => 
        \I2.PIPEBl27r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2068\);
    
    \I2.VDBi_17_0l11r\ : AND2
      port map(A => REG_i_0l43r, B => \I2.REGMAPl6r_net_1\, Y => 
        \I2.N_1908_adt_net_45468_\);
    
    \I5.RESCNTl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l3r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl3r_net_1\);
    
    \I2.TCNTl4r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.TCNT_10l4r\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.TCNTl4r_net_1\);
    
    \I2.VDBi_86_iv_0l15r\ : AOI21TTF
      port map(A => \I2.VDBil15r_net_1\, B => 
        \I2.STATE1l2r_net_1\, C => \I2.VDBi_85_ml15r_net_1\, Y
         => \I2.VDBi_86_iv_0l15r_net_1\);
    
    \I2.VDBI_54_0_IV_1L4R_396\ : AND2
      port map(A => SYNC_cl4r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il4r_adt_net_51363_\);
    
    \I2.VDBi_24_ml8r\ : AND2
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l8r_net_1\, Y => \I2.VDBi_24_m_il8r\);
    
    VDB_padl17r : IOB33PH
      port map(PAD => VDB(17), A => \I2.VDBml17r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl17r);
    
    \I5.sstatel3r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.sstate_i_0_il4r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.sstatel3r_net_1\);
    
    \I10.UN2_EVREAD_3_I_0_A2_0_12_157\ : OR3
      port map(A => \I10.REGl36r\, B => REGl47r, C => 
        \I10.un2_evread_3_i_0_a2_0_1_i\, Y => 
        \I10.un2_evread_3_i_0_a2_0_12_i_adt_net_20367_\);
    
    \I2.REGMAPl6r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un29_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl6r_net_1\);
    
    \I2.PIPEA_552\ : MUX2L
      port map(A => \I2.PIPEAl8r_net_1\, B => \I2.PIPEA_8l8r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_552_net_1\);
    
    \I10.EVENT_DWORD_18_RL15R_245\ : OA21TTF
      port map(A => \I10.N_2276_i_0\, B => 
        \I10.EVENT_DWORDl25r_net_1\, C => \I10.STATE1L12R_10\, Y
         => \I10.EVENT_DWORD_18l15r_adt_net_26932_\);
    
    \I2.REG3l3r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG3_110_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl3r\);
    
    \I2.VDBi_56l20r\ : AND2FT
      port map(A => \I2.REGMAPl28r_net_1\, B => 
        \I2.VDBi_24l20r_net_1\, Y => \I2.VDBi_56l20r_net_1\);
    
    \I2.STATE5l4r_adt_net_116396_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_NS_I_IL0R_94\, 
        SET => HWRES_c_2_0, Q => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\);
    
    \I2.REG_1l59r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_432_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl59r);
    
    \I10.CRC32_101\ : MUX2H
      port map(A => \I10.CRC32l14r_net_1\, B => \I10.N_1358\, S
         => \I10.N_2351_0_0\, Y => \I10.CRC32_101_net_1\);
    
    \I2.REG_1l190r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_180_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl190r);
    
    \I2.VDBi_56l3r\ : AO21
      port map(A => \I2.VDBi_9_sqmuxa_0_net_1\, B => 
        \I2.VDBi_24l3r_net_1\, C => \I2.VDBi_54_0_iv_5_il3r\, Y
         => \I2.VDBi_56l3r_adt_net_52242_\);
    
    \I10.EVNT_NUM_3_I_42\ : XOR2
      port map(A => \I10.EVNT_NUMl5r_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_12_1_0l0r\, Y => 
        \I10.EVNT_NUM_3l5r\);
    
    \I10.STATE1_NS_0_0_0L5R_151\ : AND2
      port map(A => \I10.N_2357\, B => \I10.N_2299\, Y => 
        \I10.STATE1_ns_0_0_0_il5r_adt_net_17702_\);
    
    \I2.VDBI_17_0L4R_394\ : AND2FT
      port map(A => \I10.REGl36r\, B => \I2.REGMAPl6r_net_1\, Y
         => \I2.N_1901_adt_net_51087_\);
    
    \I3.un4_so_32_0\ : MUX2L
      port map(A => \I3.N_238\, B => \I3.N_227\, S => REGl123r, Y
         => \I3.N_228\);
    
    \I2.VDBi_85_ml13r\ : NAND3
      port map(A => \I2.VDBil13r_net_1\, B => \I2.STATE1_i_il1r\, 
        C => \I2.N_1721_1\, Y => \I2.VDBi_85_ml13r_net_1\);
    
    \I10.G_2_4\ : OR2
      port map(A => \I10.un6_bnc_res_NE_16_i_adt_net_16189_\, B
         => \I10.un6_bnc_res_NE_15_i\, Y => \I10.G_2_4_i\);
    
    \I10.CRC32_3_0_a2_i_0l5r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2343_i_i_0\, Y => \I10.N_1724\);
    
    \I2.VDBI_86_0_IV_0L26R_323\ : AND2
      port map(A => \I2.VDBil26r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il26r_adt_net_40213_\);
    
    \I2.VDBil8r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_584_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil8r_net_1\);
    
    \I1.AIR_COMMAND_38\ : MUX2L
      port map(A => \I1.AIR_COMMANDl1r_net_1\, B => 
        \I1.AIR_COMMAND_21l1r_net_1\, S => \I1.un1_tick_12_net_1\, 
        Y => \I1.AIR_COMMAND_38_net_1\);
    
    \I2.EVREAD_DS\ : DFFC
      port map(CLK => CLKOUT, D => \I2.EVREAD_DS_139_net_1\, CLR
         => CLEAR_0_0, Q => \I2.EVREAD_DS_net_1\);
    
    \I5.RESCNT_6_rl13r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_60\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l13r\);
    
    \I2.REG_1_197\ : MUX2L
      port map(A => SYNC_cl1r, B => VDB_inl1r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_197_net_1\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I52_Y_1\ : AND3FFT
      port map(A => \I10.N259\, B => \I10.N275\, C => 
        \I10.N257_i\, Y => \I10.ADD_16x16_medium_I52_Y_1\);
    
    \I2.un1_STATE5_8_i\ : MUX2H
      port map(A => \I2.STATE5L4R_ADT_NET_116396_RD1__101\, B => 
        \I2.N_2310_i_adt_net_76095_\, S => 
        \I2.STATE5l3r_adt_net_116444_Rd1__net_1\, Y => 
        \I2.N_2215\);
    
    \I2.PIPEA_8_rl9r\ : OA21
      port map(A => \I2.N_2822_6\, B => DPRl9r, C => 
        \I2.PIPEA_8l9r_adt_net_57007_\, Y => \I2.PIPEA_8l9r\);
    
    \I2.REG_1l473r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_388_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REGl473r);
    
    \I2.REG_1l280r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_243_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl280r\);
    
    \I2.VDBi_54_0_iv_0l1r\ : AO21
      port map(A => REGl106r, B => \I2.REGMAPl12r_net_1\, C => 
        \I2.VDBi_54_0_iv_0_il1r_adt_net_53789_\, Y => 
        \I2.VDBi_54_0_iv_0_il1r\);
    
    \I2.REG_1l492r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_407_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl492r\);
    
    \I1.COMMANDl8r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_4_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl8r_net_1\);
    
    \I10.CRC32_95\ : MUX2H
      port map(A => \I10.CRC32l8r_net_1\, B => \I10.N_1212\, S
         => \I10.N_2351\, Y => \I10.CRC32_95_net_1\);
    
    \I2.VDBi_24l21r\ : MUX2L
      port map(A => \I2.REGl495r\, B => \I2.VDBi_19l21r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l21r_net_1\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l11r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl11r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l11r_adt_net_27350_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l11r_net_1\);
    
    \I2.VDBi_19l7r\ : MUX2L
      port map(A => REGl55r, B => \I2.VDBi_17l7r\, S => TST_cl5r, 
        Y => \I2.VDBi_19l7r_net_1\);
    
    \I10.FID_8_rl17r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il17r\, B => 
        \I10.FID_8_iv_0_0_0_0_il17r\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l17r\);
    
    \I5.BITCNT_6_rl2r\ : OA21FTT
      port map(A => \I5.ISI_0_sqmuxa\, B => \I5.I_14_0\, C => 
        \I5.N_212\, Y => \I5.BITCNT_6l2r\);
    
    \I3.SBYTE_5l7r\ : MUX2H
      port map(A => REG_cl136r, B => REGl143r, S => 
        \I3.sstatel0r_net_1\, Y => \I3.SBYTE_5l7r_net_1\);
    
    \I2.VDBm_0l7r\ : MUX2L
      port map(A => \I2.PIPEAl7r_net_1\, B => \I2.PIPEBl7r_net_1\, 
        S => \I2.BLTCYC_17\, Y => \I2.N_2048\);
    
    \I10.un1_REG_1_ADD_16x16_medium_I71_Y_0\ : XOR2
      port map(A => \I10.N_2519_1\, B => \I10.REGl39r\, Y => 
        \I10.ADD_16x16_medium_I71_Y_0\);
    
    \I2.REG_1_444\ : MUX2H
      port map(A => VDB_inl23r, B => REGl71r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_444_net_1\);
    
    \I2.LB_il28r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il28r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il28r_Rd1__net_1\);
    
    \I2.REG_il281r\ : INV
      port map(A => \I2.REGl281r\, Y => REG_i_0l281r);
    
    \I2.REG_1_224\ : MUX2L
      port map(A => VDB_inl12r, B => REGl261r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_224_net_1\);
    
    \I1.AIR_COMMAND_21_0_IVL14R_132\ : AO21
      port map(A => \I1.sstate2l6r_net_1\, B => CHANNELl1r, C => 
        \I1.REG_m_il103r\, Y => 
        \I1.AIR_COMMAND_21l14r_adt_net_9030_\);
    
    \I10.EVENT_DWORDl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_136_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl3r_net_1\);
    
    \I2.REG_1l451r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_366_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl451r\);
    
    \I2.REG_1l50r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_423_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl50r);
    
    \I2.REG_1l477r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_392_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl477r\);
    
    \I5.un1_RESCNT_I_70\ : AND2
      port map(A => \I5.DWACT_ADD_CI_0_pog_array_1_3l0r\, B => 
        \I5.DWACT_ADD_CI_0_g_array_3l0r\, Y => 
        \I5.DWACT_ADD_CI_0_g_array_11_1l0r\);
    
    \I2.LB_s_18\ : MUX2L
      port map(A => \I2.LB_sl4r_Rd1__net_1\, B => 
        \I2.N_3039_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116360_Rd1__net_1\, Y => 
        \I2.LB_sl4r\);
    
    \I3.un16_ae_20_1\ : OR2
      port map(A => \I3.un16_ae_1l45r\, B => \I3.un16_ae_1l30r\, 
        Y => \I3.un16_ae_1l28r\);
    
    \I2.PIPEA_566\ : MUX2L
      port map(A => \I2.PIPEAl22r_net_1\, B => \I2.PIPEA_8l22r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_566_net_1\);
    
    \I10.EVNT_NUM_3_I_1\ : AND2
      port map(A => \I10.EVNT_NUMl0r_net_1\, B => 
        \I10.STATE1l0r_net_1\, Y => \I10.DWACT_ADD_CI_0_TMP_1l0r\);
    
    SDA0_pad : IOB33PH
      port map(PAD => SDA0, A => \I1.SDAout_del2_net_1\, EN => 
        un1_sdaa_0_a2, Y => SDA0_in);
    
    \I2.REG_1l275r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_238_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl275r\);
    
    \I10.BNC_CNT_4_0_a2l1r\ : AND2
      port map(A => \I10.un6_bnc_res_NE_net_1\, B => \I10.I_5\, Y
         => \I10.BNC_CNT_4l1r\);
    
    \I3.AEl28r\ : MUX2L
      port map(A => REGl181r, B => \I3.un16_ael28r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl28r);
    
    \I1.SSTATE2SE_0_0_127\ : NOR2FT
      port map(A => \I1.sstate2l9r_net_1\, B => \I1.N_279\, Y => 
        \I1.sstate2_ns_el1r_adt_net_8343_\);
    
    \I10.un3_bnc_cnt_I_20\ : XOR2
      port map(A => \I10.BNC_CNTl4r_net_1\, B => \I10.N_77\, Y
         => \I10.I_20\);
    
    \I3.un4_so_31_0\ : MUX2L
      port map(A => SP_PDL_inl45r, B => SP_PDL_inl13r, S => 
        REGl127r, Y => \I3.N_227\);
    
    \I2.PIPEA1l30r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.PIPEA1_541_net_1\, SET => 
        CLEAR_0_0, Q => \I2.PIPEA1l30r_net_1\);
    
    \I10.BNCRES_CNT_4_I_36\ : XOR2
      port map(A => \I10.DWACT_ADD_CI_0_g_array_3_0l0r\, B => 
        \I10.BNCRES_CNTl8r_net_1\, Y => \I10.BNCRES_CNT_4l8r\);
    
    TST_padl9r : OB33PH
      port map(PAD => TST(9), A => \GND\);
    
    \I2.REG_1l428r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_343_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl428r);
    
    \I2.REG_1l295r_79\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_258_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL295R_63\);
    
    \I10.FID_8_IV_0_0_0_0L10R_198\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.FID_4_il10r\, Y
         => \I10.FID_8_iv_0_0_0_0_il10r_adt_net_23481_\);
    
    \I2.VDBi_86_ivl13r\ : AO21TTF
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_67l13r_net_1\, C => \I2.VDBi_86_iv_2l13r_net_1\, 
        Y => \I2.VDBi_86l13r\);
    
    \I2.VDBi_61_dl0r\ : MUX2L
      port map(A => LBSP_inl0r, B => L0_c, S => 
        \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61_dl0r_net_1\);
    
    \I2.REG_1l496r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_411_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl496r\);
    
    \I10.un1_CNT_1_G\ : AND2
      port map(A => \I10.G_1_0_0_net_1\, B => 
        \I10.DWACT_ADD_CI_0_g_array_1l0r_adt_net_16050_\, Y => 
        \I10.DWACT_ADD_CI_0_g_array_1l0r\);
    
    \I2.VDBi_86_0_ivl22r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl22r\, C
         => \I2.VDBi_86l22r_adt_net_41072_\, Y => 
        \I2.VDBi_86l22r\);
    
    \I1.I2C_RDATA_9_i_o2l0r\ : NAND2FT
      port map(A => \I1.sstate2l1r_net_1\, B => REGl105r, Y => 
        \I1.N_631\);
    
    \I10.FIDl19r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_184_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl19r_net_1\);
    
    \I2.REG_il278r\ : INV
      port map(A => \I2.REGl278r\, Y => REG_i_0l278r);
    
    \I2.VDBml13r\ : MUX2L
      port map(A => \I2.VDBil13r_net_1\, B => \I2.N_2054\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml13r_net_1\);
    
    \I2.REG_1_6l121r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_123_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => MD_PDL_C_0);
    
    \I10.un1_REG_1_ADD_16x16_medium_I61_Y\ : AOI21
      port map(A => \I10.N233\, B => \I10.N290\, C => 
        \I10.N232_i_i\, Y => \I10.N324_i\);
    
    \I3.un16_ae_43_1\ : OR2FT
      port map(A => REGl123r, B => REGl124r, Y => 
        \I3.un16_ae_1l43r\);
    
    \I1.DATA_12_iv_0_a2_0_0l1r\ : NAND2FT
      port map(A => REGl89r, B => \I1.N_630\, Y => 
        \I1.DATA_12_iv_0_a2_0_0_il1r\);
    
    \I2.VDBi_61_sl2r\ : NOR2
      port map(A => \I2.REGMAPl30r_net_1\, B => \I2.VDBi_59_0l9r\, 
        Y => \I2.VDBi_61_sl2r_net_1\);
    
    \I2.un106_reg_ads_0_a2_0_a2_1\ : NAND2
      port map(A => \I2.WRITES_net_1\, B => \I2.N_3069\, Y => 
        \I2.N_3010_1\);
    
    \I10.FID_8_iv_0_0_0_0l12r\ : AO21
      port map(A => \I10.STATE1L11R_12\, B => REGl60r, C => 
        \I10.FID_8_iv_0_0_0_0_il12r_adt_net_23237_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il12r\);
    
    LWORDB_pad : IOB33PH
      port map(PAD => LWORDB, A => \I2.VADml0r_net_1\, EN => 
        NOEAD_c_0_0, Y => LWORDB_in);
    
    \I2.REG_1l237r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_200_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl4r);
    
    \I2.VDBm_0l6r\ : MUX2L
      port map(A => \I2.PIPEAl6r_net_1\, B => \I2.PIPEBl6r_net_1\, 
        S => \I2.BLTCYC_17\, Y => \I2.N_2047\);
    
    \I2.REGMAPl22r\ : DFF
      port map(CLK => CLKOUT, D => 
        \I2.un74_reg_ads_0_a2_0_a2_net_1\, Q => 
        \I2.REGMAPl22r_net_1\);
    
    \I2.PIPEAl17r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA_561_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEAl17r_net_1\);
    
    \I2.REG_il284r\ : INV
      port map(A => \I2.REGl284r\, Y => REG_i_0l284r);
    
    \I1.COMMAND_9\ : MUX2H
      port map(A => \I1.COMMANDl13r_net_1\, B => 
        \I1.COMMAND_4l13r_net_1\, S => \I1.sstatel13r_net_1\, Y
         => \I1.COMMAND_9_net_1\);
    
    \I2.REG_1_237\ : MUX2L
      port map(A => \I2.REGL274R_42\, B => VDB_inl9r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_237_net_1\);
    
    \I1.un1_sstate_12_0_0\ : OAI21FTF
      port map(A => \I1.COMMANDl2r_net_1\, B => \I1.N_516\, C => 
        \I1.sstatel9r_net_1\, Y => \I1.un1_sstate_12_0_0_net_1\);
    
    \I2.VDBi_54_0_iv_2l3r\ : AOI21TTF
      port map(A => REGl172r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml156r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l3r_net_1\);
    
    \I2.VDBI_17_0L5R_388\ : AND2FT
      port map(A => \I10.REGl37r\, B => \I2.REGMAPl6r_net_1\, Y
         => \I2.N_1902_adt_net_50284_\);
    
    \I2.REG_1l293r_77\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_256_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL293R_61\);
    
    \I10.un2_i2c_chain_0_i_0_0_0l2r\ : OR2FT
      port map(A => \I10.N_2650\, B => 
        \I10.un2_i2c_chain_0_i_0_0_0_il2r_adt_net_29501_\, Y => 
        \I10.un2_i2c_chain_0_i_0_0_0_il2r\);
    
    \I2.VDBil22r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_598_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil22r_net_1\);
    
    \I2.PIPEB_56\ : MUX2H
      port map(A => \I2.PIPEBl7r_net_1\, B => \I2.N_2583\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_56_net_1\);
    
    SYNC_padl9r : OB33PH
      port map(PAD => SYNC(9), A => SYNC_cl9r);
    
    \I2.REGMAPl1r\ : DFF
      port map(CLK => CLKOUT, D => \I2.un10_reg_ads_0_a2_net_1\, 
        Q => \I2.REGMAP_i_il1r\);
    
    \I10.EVENT_DWORDl30r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_163_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl30r_net_1\);
    
    \I2.REG_1_211\ : MUX2L
      port map(A => REG_cl248r, B => VDB_inl15r, S => 
        \I2.N_3207_i_0\, Y => \I2.REG_1_211_net_1\);
    
    \I10.BNC_NUMBER_236\ : MUX2L
      port map(A => \I10.BNCRES_CNTl6r_net_1\, B => 
        \I10.BNC_NUMBERl6r_net_1\, S => \I10.BNC_NUMBER_0_sqmuxa\, 
        Y => \I10.BNC_NUMBER_236_net_1\);
    
    \I2.VDBI_54_0_IV_1L12R_359\ : AND2
      port map(A => REG_cl245r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il12r_adt_net_44992_\);
    
    \I10.CRC32_3_i_0_0l3r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2322_i_i_0\, Y => \I10.N_1346\);
    
    LBSP_padl31r : IOB33PH
      port map(PAD => LBSP(31), A => REGl424r, EN => REG_i_0l296r, 
        Y => LBSP_inl31r);
    
    \I2.REG_1l88r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_461_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl88r);
    
    \I2.un1_STATE1_25_0_o3\ : NAND3FTT
      port map(A => \I2.N_2319_1\, B => \I2.STATE1l8r_net_1\, C
         => \I2.N_2835\, Y => \I2.N_2860_i_0_i\);
    
    \I2.N_3015_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3015\, SET => 
        HWRES_c_2_0, Q => \I2.N_3015_Rd1__net_1\);
    
    \I2.un1_STATE2_10_i_a2_0_1\ : NAND2
      port map(A => \I2.REGMAPl0r_net_1\, B => \I2.N_2836\, Y => 
        \I2.N_2894_1\);
    
    \I2.UN1_STATE5_9_1_RD1__494\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_91\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__79\);
    
    \I2.VDBi_86_0_ivl24r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl24r\, C
         => \I2.VDBi_86l24r_adt_net_40662_\, Y => 
        \I2.VDBi_86l24r\);
    
    \I2.VDBm_0l22r\ : MUX2L
      port map(A => \I2.PIPEAl22r_net_1\, B => 
        \I2.PIPEBl22r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2063\);
    
    \I2.PIPEA_551\ : MUX2L
      port map(A => \I2.PIPEAl7r_net_1\, B => \I2.PIPEA_8l7r\, S
         => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_551_net_1\);
    
    \I3.un16_ae_3\ : NOR2
      port map(A => \I3.un16_ae_1l43r\, B => \I3.un16_ae_1l5r\, Y
         => \I3.un16_ael3r\);
    
    \I2.REG_1_317\ : MUX2L
      port map(A => REGl402r, B => VDB_inl9r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_317_net_1\);
    
    \I2.REG_1_355\ : MUX2H
      port map(A => VDB_inl15r, B => \I2.REGl440r\, S => 
        \I2.N_3495_i_0\, Y => \I2.REG_1_355_net_1\);
    
    \I2.REG_1l247r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_210_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl247r);
    
    \I3.SBYTEl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I3.SBYTE_6_0\, CLR => 
        HWRES_c_2_0, Q => REGl140r);
    
    \I2.VDBi_86_0_ivl31r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl31r\, C
         => \I2.VDBi_86_0l31r_adt_net_39227_\, Y => 
        \I2.VDBi_86_0l31r\);
    
    \I2.VDBi_597\ : MUX2L
      port map(A => \I2.VDBil21r_net_1\, B => \I2.VDBi_86l21r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_597_net_1\);
    
    \I2.un756_regmap_22_0\ : OR2
      port map(A => \I2.REGMAPl21r_net_1\, B => 
        \I2.REGMAPl22r_net_1\, Y => \I2.un756_regmap_22_0_net_1\);
    
    \I2.PIPEB_4_il12r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl12r, Y => \I2.N_2593\);
    
    TST_padl14r : OB33PH
      port map(PAD => TST(14), A => \GND\);
    
    NDTKIN_pad : OB33PH
      port map(PAD => NDTKIN, A => NDTKIN_c);
    
    \I2.REG_1l239r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_202_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl6r);
    
    \I2.REG_1l463r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_378_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl463r);
    
    \I2.PIPEB_76\ : MUX2H
      port map(A => \I2.PIPEBl27r_net_1\, B => \I2.N_2623\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_76_net_1\);
    
    \I2.TCNT_i_il0r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.TCNT_10l0r\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.TCNT_i_il0r_net_1\);
    
    \I2.un756_regmap_8_0\ : OR3
      port map(A => \I2.REGMAP_i_il14r\, B => 
        \I2.REGMAPl10r_net_1\, C => \I2.REGMAPl3r_net_1\, Y => 
        \I2.un756_regmap_8_0_i\);
    
    \I2.REG_1_239\ : MUX2L
      port map(A => \I2.REGL276R_44\, B => VDB_inl11r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_239_net_1\);
    
    \I2.LB_i_485\ : MUX2L
      port map(A => \I2.LB_il7r_Rd1__net_1\, B => 
        \I2.LB_i_7l7r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__87\, Y => \I2.LB_il7r\);
    
    \I2.REG_1l103r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_476_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl103r);
    
    \I1.SDAout_m\ : NAND3
      port map(A => \I1.N_517_3\, B => \I1.N_516\, C => 
        \I1.SDAout_net_1\, Y => \I1.SDAout_m_net_1\);
    
    \I2.LB_s_17\ : MUX2L
      port map(A => \I2.LB_sl3r_Rd1__net_1\, B => 
        \I2.N_3038_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116360_Rd1__net_1\, Y => 
        \I2.LB_sl3r\);
    
    \I2.CYCS\ : DFFC
      port map(CLK => CLKOUT, D => \I2.CYCSF1_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.CYCS_net_1\);
    
    \I10.FIDl22r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_187_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl22r_net_1\);
    
    \I2.REG_1l198r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_188_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl198r);
    
    \I2.VDBI_86_0_IV_0L17R_340\ : AND2
      port map(A => \I2.VDBil17r_net_1\, B => \I2.N_1885_1\, Y
         => \I2.VDBi_86_0_iv_0_il17r_adt_net_42086_\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l13r\ : OAI21TTF
      port map(A => \I10.N_2275_i_1\, B => 
        \I10.EVENT_DWORDl13r_net_1\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l13r_adt_net_27126_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l13r_net_1\);
    
    \I1.sstate2l0r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstate2se_8_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstate2l0r_net_1\);
    
    \I2.VDBml27r\ : MUX2L
      port map(A => \I2.VDBil27r_net_1\, B => \I2.N_2068\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml27r_net_1\);
    
    \I2.REG_1l467r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_382_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REGl467r);
    
    \I2.VDBm_0l1r\ : MUX2L
      port map(A => \I2.PIPEAl1r_net_1\, B => \I2.PIPEBl1r_net_1\, 
        S => \I2.BLTCYC_17\, Y => \I2.N_2042\);
    
    \I2.PIPEA1l6r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_517_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l6r_net_1\);
    
    VAD_padl30r : IOB33PH
      port map(PAD => VAD(30), A => \I2.VADml30r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl30r);
    
    \I10.un1_REG_1_ADD_16x16_medium_I25_Y\ : AND2
      port map(A => \I10.un1_REG_1_1l36r\, B => 
        \I10.un1_REG_1_1l37r\, Y => \I10.N264\);
    
    SP_PDL_padl5r : IOB33PH
      port map(PAD => SP_PDL(5), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl5r);
    
    \I2.VDBi_24_sl1r\ : OR2
      port map(A => TST_cl5r, B => \I2.REGMAPl13r_net_1\, Y => 
        \I2.VDBi_24_sl1r_net_1\);
    
    \I2.VDBi_5l0r\ : AND2
      port map(A => \I2.REGMAP_i_il1r\, B => \I2.REGl0r\, Y => 
        \I2.VDBi_5l0r_net_1\);
    
    \I2.PULSE_1_sqmuxa_8_0\ : AND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl16r_net_1\, Y => \I2.PULSE_1_sqmuxa_8_0_net_1\);
    
    \I10.OR_RADDRl2r\ : DFF
      port map(CLK => CLKOUT, D => \I10.OR_RADDR_220_net_1\, Q
         => \I10.OR_RADDRl2r_net_1\);
    
    \I2.VDBI_86_0_IVL18R_339\ : AO21
      port map(A => \I2.PIPEAl18r_net_1\, B => \I2.N_1707_i_0_1\, 
        C => \I2.VDBi_86_0_iv_0_il18r\, Y => 
        \I2.VDBi_86l18r_adt_net_41920_\);
    
    \I2.VADml6r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl6r_net_1\, Y
         => \I2.VADml6r_net_1\);
    
    \I2.REG_1l249r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_212_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl249r);
    
    \I10.BNC_CNT_205\ : MUX2H
      port map(A => \I10.BNC_CNTl7r_net_1\, B => 
        \I10.BNC_CNT_4l7r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_205_net_1\);
    
    \I2.REG_1l265r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_228_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGl265r\);
    
    \I10.un2_i2c_chain_0_0_0_0l6r\ : OR2
      port map(A => \I10.un2_i2c_chain_0_0_0_0_2_il6r\, B => 
        \I10.N_251_adt_net_30085_\, Y => \I10.N_251\);
    
    \I10.CRC32l21r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_108_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l21r_net_1\);
    
    \I2.REG_il277r\ : INV
      port map(A => \I2.REGl277r\, Y => REG_i_0l277r);
    
    \I10.STATE1l8r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.STATE1_nsl4r\, CLR => 
        CLEAR_0_0, Q => \I10.STATE1l8r_net_1\);
    
    \I2.REG_1l276r_60\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_239_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL276R_44\);
    
    \I2.REG_1_449\ : MUX2H
      port map(A => VDB_inl28r, B => REGl76r, S => 
        \I2.N_3689_i_1\, Y => \I2.REG_1_449_net_1\);
    
    \I10.REG_1l46r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.ADD_16x16_medium_I78_Y\, 
        CLR => CLEAR_0_0, Q => REGl46r);
    
    \I10.CHIP_ADDRl1r\ : DFF
      port map(CLK => CLKOUT, D => \I10.CHIP_ADDR_128_net_1\, Q
         => CHIP_ADDRl1r);
    
    \I1.I2C_RDATA_16\ : MUX2L
      port map(A => I2C_RDATAl2r, B => \I1.N_578\, S => 
        \I1.N_276\, Y => \I1.I2C_RDATA_16_net_1\);
    
    \I10.EVENT_DWORDl19r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_152_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl19r_net_1\);
    
    \I10.CRC32l31r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_118_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l31r_net_1\);
    
    \I2.END_PK\ : DFFC
      port map(CLK => CLKOUT, D => \I2.END_PK_510_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.END_PK_net_1\);
    
    \I10.BNC_CNT_206\ : MUX2H
      port map(A => \I10.BNC_CNTl8r_net_1\, B => 
        \I10.BNC_CNT_4l8r\, S => BNC_RES, Y => 
        \I10.BNC_CNT_206_net_1\);
    
    \I1.DATA_12l15r\ : MUX2H
      port map(A => \I1.SBYTEl7r_net_1\, B => REGl120r, S => 
        \I1.DATA_1_sqmuxa_2\, Y => \I1.DATA_12l15r_net_1\);
    
    \I3.un16_ae_18\ : NOR2
      port map(A => \I3.un16_ae_1l26r\, B => \I3.un16_ae_1l23r\, 
        Y => \I3.un16_ael18r\);
    
    \I2.REG_il268r\ : INV
      port map(A => \I2.REGl268r\, Y => REG_i_0l268r);
    
    \I2.REG_1_313\ : MUX2L
      port map(A => REGl398r, B => VDB_inl5r, S => 
        \I2.N_3463_i_1\, Y => \I2.REG_1_313_net_1\);
    
    \I2.REG_1l61r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_434_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl61r);
    
    \I2.PIPEA1_9_il13r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl13r, Y => \I2.N_2523\);
    
    \I2.PIPEBl18r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_67_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl18r_net_1\);
    
    \I5.SBYTE_5l7r\ : MUX2L
      port map(A => REGl88r, B => FBOUTl6r, S => 
        \I5.sstatel5r_net_1\, Y => \I5.SBYTE_5l7r_net_1\);
    
    \I2.PIPEA1l22r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_533_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l22r_net_1\);
    
    \I2.un756_regmap\ : NAND3FFT
      port map(A => \I2.un756_regmap_25_i\, B => 
        \I2.un756_regmap_24_i\, C => \I2.N_1965\, Y => 
        \I2.un756_regmap_net_1\);
    
    \I2.LB_i_507\ : MUX2L
      port map(A => \I2.LB_il29r_Rd1__net_1\, B => 
        \I2.LB_i_7l29r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__76\, Y => \I2.LB_il29r\);
    
    TST_pad_il6r : NOR2
      port map(A => \I2.N_2983_1\, B => NOEAD_C_0_0_21, Y => 
        \I2.N_2768_i_0\);
    
    \I2.un116_reg_ads_0_a3_0\ : NAND2
      port map(A => \I2.VASl1r_net_1\, B => \I2.VASl4r_net_1\, Y
         => \I2.N_3068\);
    
    \I2.PIPEA1_9_i_o3_4l0r\ : NAND2
      port map(A => \I2.STATE2l1r_net_1\, B => 
        \I2.EVREAD_DS_net_1\, Y => \I2.N_2830_4\);
    
    \I2.VDBi_54_0_iv_2l13r\ : AOI21TTF
      port map(A => REGl182r, B => \I2.REGMAPl19r_net_1\, C => 
        \I2.REG_1_ml166r_net_1\, Y => 
        \I2.VDBi_54_0_iv_2l13r_net_1\);
    
    VDB_padl12r : IOB33PH
      port map(PAD => VDB(12), A => \I2.VDBml12r_net_1\, EN => 
        \I2.N_2768_0\, Y => VDB_inl12r);
    
    \I10.FID_8_RL13R_193\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl13r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il13r\, Y => 
        \I10.FID_8l13r_adt_net_23154_\);
    
    \I2.VDBi_54_0_iv_1l0r\ : AO21
      port map(A => SYNC_cl0r, B => \I2.REGMAP_i_il23r\, C => 
        \I2.VDBi_54_0_iv_1_il0r_adt_net_54961_\, Y => 
        \I2.VDBi_54_0_iv_1_il0r\);
    
    \I2.PIPEB_52\ : MUX2H
      port map(A => \I2.PIPEBl3r_net_1\, B => \I2.N_2575\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_52_net_1\);
    
    \I2.un1_state1_1_i_a2_0_3\ : NAND2
      port map(A => \I2.N_2892_1\, B => \I2.N_2892_2\, Y => 
        \I2.N_2892_4\);
    
    \I2.LB_i_499\ : MUX2L
      port map(A => \I2.LB_il21r_Rd1__net_1\, B => 
        \I2.LB_i_7l21r_Rd1__net_1\, S => 
        \I2.UN1_STATE5_9_1_RD1__80\, Y => \I2.LB_il21r\);
    
    \I2.VDBI_54_0_IV_1L2R_409\ : AND2
      port map(A => SYNC_cl2r, B => \I2.REGMAP_i_il23r\, Y => 
        \I2.VDBi_54_0_iv_1_il2r_adt_net_53062_\);
    
    \I2.VDBi_70_sl0r\ : NOR2
      port map(A => \I2.REGMAPl34r_net_1\, B => 
        \I2.VDBi_67_sl0r_net_1\, Y => \I2.VDBi_70_sl0r_net_1\);
    
    \I1.sstatese_7_0_a3\ : NAND2
      port map(A => \I1.sstate_i_0_il3r\, B => \I1.N_681_1\, Y
         => \I1.N_435\);
    
    \I10.RDY_CNT_10_i_0_o2l0r\ : AOI21
      port map(A => \I10.RDY_CNTl1r_net_1\, B => 
        \I10.STATE1_nsl11r_adt_net_16793_\, C => 
        \I10.STATE1l12r_net_1\, Y => \I10.N_2308\);
    
    \I2.VDBi_54_0_iv_3l12r\ : AO21TTF
      port map(A => REG_cl133r, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l12r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il12r\);
    
    \I2.PIPEBl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_54_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl5r_net_1\);
    
    \I1.AIR_COMMAND_21_0_ivl9r\ : AO21
      port map(A => \I1.N_565_i_i\, B => CHIP_ADDRl0r, C => 
        \I1.AIR_COMMAND_21l9r_adt_net_9514_\, Y => 
        \I1.AIR_COMMAND_21l9r\);
    
    \I10.EVENT_DWORD_18_I_0_0_0L22R_230\ : NOR2
      port map(A => \I10.N_2642_0\, B => \I10.OR_RADDRl2r_net_1\, 
        Y => \I10.EVENT_DWORD_18_i_0_0_0l22r_adt_net_25992_\);
    
    \I2.VDBi_17_rl12r\ : NOR3FTT
      port map(A => \I2.VDBi_17l15r_adt_net_42484_\, B => 
        \I2.N_1909_adt_net_44714_\, C => 
        \I2.N_1909_adt_net_44716_\, Y => \I2.VDBi_17l12r\);
    
    \I2.VDBml4r\ : MUX2L
      port map(A => \I2.VDBil4r_net_1\, B => \I2.N_2045\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml4r_net_1\);
    
    \I2.VDBI_54_0_IV_0L9R_370\ : AND2
      port map(A => REGl114r, B => \I2.REGMAPl12r_net_1\, Y => 
        \I2.VDBi_54_0_iv_0_il9r_adt_net_47212_\);
    
    VDB_padl16r : IOB33PH
      port map(PAD => VDB(16), A => \I2.VDBml16r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl16r);
    
    \I2.STATE5l1r\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5l1r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.STATE5l1r_Rd1_\);
    
    \I2.VADml3r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl3r_net_1\, Y
         => \I2.VADml3r_net_1\);
    
    \I3.AEl21r\ : MUX2L
      port map(A => REGl174r, B => \I3.un16_ael21r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl21r);
    
    \I2.LB_i_7l1r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l1r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l1r_Rd1__net_1\);
    
    \I5.sstate_ns_i_o2l1r\ : OAI21
      port map(A => \I5.sstatel5r_net_1\, B => 
        \I5.sstatel2r_net_1\, C => \I5.ISI_0_sqmuxa\, Y => 
        \I5.N_210\);
    
    \I2.VDBi_86_0_iv_0l25r\ : AO21
      port map(A => \I2.N_1705_i_0_1_0\, B => 
        \I2.VDBi_61l25r_net_1\, C => 
        \I2.VDBi_86_0_iv_0_il25r_adt_net_40418_\, Y => 
        \I2.VDBi_86_0_iv_0_il25r\);
    
    \I2.un1_WDOGRES_0_sqmuxa_0_0_a2\ : NAND3FFT
      port map(A => \I2.N_2831\, B => TST_CL2R_16, C => 
        \I2.STATE1l9r_net_1\, Y => \I2.N_2885\);
    
    \I10.un6_bnc_res_NE_15\ : OR3
      port map(A => \I10.un6_bnc_res_NE_11_i\, B => 
        \I10.un6_bnc_res_8_i_i\, C => \I10.un6_bnc_res_9_i_i\, Y
         => \I10.un6_bnc_res_NE_15_i\);
    
    \I10.CNT_10_i_0l4r\ : AND2
      port map(A => \I10.N_2287\, B => \I10.I_24_0\, Y => 
        \I10.CNT_10_i_0l4r_net_1\);
    
    \I10.OR_RADDRl0r\ : DFF
      port map(CLK => CLKOUT, D => \I10.OR_RADDR_218_net_1\, Q
         => \I10.OR_RADDRl0r_net_1\);
    
    \I10.CYC_STAT_0\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CYC_STAT_0_2\, CLR => 
        HWRES_c_2_0, Q => \I10.CYC_STAT_0_net_1\);
    
    \I2.PIPEB_72\ : MUX2H
      port map(A => \I2.PIPEBl23r_net_1\, B => \I2.N_2615\, S => 
        \I2.N_2822_6\, Y => \I2.PIPEB_72_net_1\);
    
    \I2.STATE1_nsl3r\ : AO21TTF
      port map(A => \I2.N_1714\, B => \I2.N_1783\, C => 
        \I2.STATE1_ns_0l3r_net_1\, Y => \I2.STATE1_nsl3r_net_1\);
    
    \I10.un1_PDL_RADDR_1_sqmuxa_0_0_a2\ : NAND2
      port map(A => \I10.STATE1l8r_net_1\, B => \I10.N_2286\, Y
         => \I10.PDL_RADDR_1_sqmuxa\);
    
    \I2.REG_1_226\ : MUX2L
      port map(A => VDB_inl14r, B => REGl263r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_226_net_1\);
    
    \I2.STATE1_ns_il6r\ : OA21FTF
      port map(A => \I2.N_2854\, B => \I2.STATE1l3r_net_1\, C => 
        TST_cl2r, Y => \I2.STATE1_ns_il6r_net_1\);
    
    TST_padl12r : OB33PH
      port map(PAD => TST(12), A => NOE16W_c_c);
    
    \I2.LB_s_42\ : MUX2L
      port map(A => \I2.LB_sl28r_Rd1__net_1\, B => 
        \I2.N_3037_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116344_Rd1__net_1\, Y => 
        \I2.LB_sl28r\);
    
    \I2.PIPEBl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEB_56_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEBl7r_net_1\);
    
    LB_padl0r : IOB33PH
      port map(PAD => LB(0), A => \I2.LB_il0r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl0r);
    
    \I2.REG_1l172r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_162_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl172r);
    
    \I1.I2C_RVALID_2_0_a3\ : AND2FT
      port map(A => \I1.N_277_0\, B => \I1.sstate2l0r_net_1\, Y
         => \I1.I2C_RVALID_2\);
    
    \I10.FID_8_iv_0_0_0_0l4r\ : AO21
      port map(A => \I10.STATE1L11R_12\, B => REGl52r, C => 
        \I10.FID_8_iv_0_0_0_0_il4r_adt_net_24220_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il4r\);
    
    \I3.un16_ae_12\ : NOR3
      port map(A => \I3.un16_ae_1l45r\, B => \I3.un16_ae_1l15r\, 
        C => \I3.un16_ae_1l14r\, Y => \I3.un16_ael12r\);
    
    \I2.PIPEA_8_RL25R_428\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l25r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l25r_adt_net_55887_\);
    
    \I3.un4_so_35_0\ : MUX2L
      port map(A => SP_PDL_inl35r, B => SP_PDL_inl3r, S => 
        REGl127r, Y => \I3.N_231\);
    
    \I2.WDOGRES_98_459\ : AND3FFT
      port map(A => \I2.STATE1l8r_net_1\, B => 
        \I2.STATE1l9r_net_1\, C => \I2.WDOGRES_net_1\, Y => 
        \I2.WDOGRES_98_adt_net_75433_\);
    
    \I10.CNT_10_i_0_o3_0l0r\ : OAI21FTF
      port map(A => \I10.STATE1l3r_net_1\, B => \I10.N_2284\, C
         => \I10.CNT_10_i_0_o3_0l0r_adt_net_15944_\, Y => 
        \I10.CNT_10_i_0_o3_0l0r_net_1\);
    
    AE_PDL_padl7r : OB33PH
      port map(PAD => AE_PDL(7), A => AE_PDL_cl7r);
    
    \I2.PIPEA_575\ : MUX2L
      port map(A => \I2.PIPEAl31r_net_1\, B => \I2.PIPEA_8l31r\, 
        S => \I2.un1_STATE2_16_1\, Y => \I2.PIPEA_575_net_1\);
    
    \I10.FID_8_IV_0_0_0_0L25R_169\ : AND2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.BNC_NUMBERl6r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il25r_adt_net_21315_\);
    
    \I2.REG_1l447r_47\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_362_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL447R_31\);
    
    \I2.REG_1_227_e_0\ : AND2FT
      port map(A => \I2.PULSE_0_sqmuxa_4_1_0\, B => 
        \I2.REGMAPl24r_net_1\, Y => \I2.PULSE_1_sqmuxa_6_0\);
    
    \I2.N_3038_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3038\, SET => 
        HWRES_c_2_0, Q => \I2.N_3038_Rd1__net_1\);
    
    \I8.ISI\ : DFFC
      port map(CLK => CLKOUT, D => \I8.ISI_17_net_1\, CLR => 
        HWRES_c_2_0, Q => SDIN_DAC_c);
    
    \I10.un1_STATE1_10_0_0\ : OAI21FTF
      port map(A => \I10.FIFO_END_EVNT_net_1\, B => 
        \I10.STATE1L12R_10\, C => \I10.STATE1l0r_net_1\, Y => 
        \I10.un1_STATE1_10\);
    
    \I10.BNCRES_CNTl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNCRES_CNT_4l3r\, CLR => 
        CLEAR_0_0, Q => \I10.BNCRES_CNTl3r_net_1\);
    
    \I2.VDBi_54_0_iv_1l9r\ : AO21
      port map(A => REGl194r, B => \I2.REGMAPl20r_net_1\, C => 
        \I2.VDBi_54_0_iv_1_il9r_adt_net_47254_\, Y => 
        \I2.VDBi_54_0_iv_1_il9r\);
    
    \I2.REG_il267r\ : INV
      port map(A => \I2.REGl267r\, Y => REG_i_0l267r);
    
    \I2.LB_s_14\ : MUX2L
      port map(A => \I2.LB_sl0r_Rd1__net_1\, B => 
        \I2.N_3022_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116360_Rd1__net_1\, Y => 
        \I2.LB_sl0r\);
    
    \I2.LB_sl30r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl30r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl30r_Rd1__net_1\);
    
    \I2.REG_1l234r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_197_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl1r);
    
    \I2.REG_1l282r_66\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_245_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL282R_50\);
    
    \I2.REG_1l194r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_184_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl194r);
    
    L2R_pad : IB33
      port map(PAD => L2R, Y => L2R_c);
    
    \I2.TCNT2_2_I_44\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_1l0r\, B => 
        \I2.TCNT2_i_0_il2r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_12l0r\);
    
    \I2.REG_1_234\ : MUX2L
      port map(A => \I2.REGL271R_39\, B => VDB_inl6r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_234_net_1\);
    
    \I2.un67_reg_ads_0_a2_0_a2\ : NOR2
      port map(A => \I2.N_3005_1\, B => \I2.N_3003_1\, Y => 
        \I2.un67_reg_ads_0_a2_0_a2_net_1\);
    
    \I2.TCNT2_2_I_35\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_TMPl0r\, B => 
        \I2.TCNT2l1r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_1l0r\);
    
    \I10.un2_i2c_chain_0_0_0_0_0l6r\ : AOI21TTF
      port map(A => \I10.N_2377_2\, B => \I10.N_2377_1\, C => 
        \I10.N_2373\, Y => \I10.un2_i2c_chain_0_0_0_0_0l6r_net_1\);
    
    \I1.I2C_RDATAl7r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.I2C_RDATA_21_net_1\, CLR
         => HWRES_c_2_0, Q => I2C_RDATAl7r);
    
    \I2.WDOG_3_I_21\ : AND2
      port map(A => \I2.DWACT_ADD_CI_0_g_array_1_1l0r\, B => 
        \I2.WDOGl2r_net_1\, Y => 
        \I2.DWACT_ADD_CI_0_g_array_12_3l0r\);
    
    \I3.un16_ae_14\ : NOR2
      port map(A => \I3.un16_ae_2l7r\, B => \I3.un16_ae_1l14r\, Y
         => \I3.un16_ael14r\);
    
    TST_padl4r : OB33PH
      port map(PAD => TST(4), A => TST_cl4r);
    
    \I2.PIPEA1_9_il9r\ : AND2
      port map(A => \I2.N_2830_4\, B => DPRl9r, Y => \I2.N_2515\);
    
    VDB_padl23r : IOB33PH
      port map(PAD => VDB(23), A => \I2.VDBml23r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl23r);
    
    VAD_padl13r : IOB33PH
      port map(PAD => VAD(13), A => \I2.VADml13r_net_1\, EN => 
        NOEAD_c_0_0, Y => VAD_inl13r);
    
    \I10.un2_i2c_chain_0_0_0_0_o3l0r\ : OR2
      port map(A => \I10.CNTl4r_net_1\, B => \I10.CNTl5r_net_1\, 
        Y => \I10.N_2290\);
    
    \I10.STATE1l12r\ : DFFS
      port map(CLK => CLKOUT, D => \I10.N_557_i_0\, SET => 
        CLEAR_0_0, Q => \I10.STATE1L12R_15\);
    
    \I10.EVENT_DWORD_18_i_0_0_a3l20r\ : OR3FTT
      port map(A => I2C_RVALID, B => \I10.STATE1l4r_net_1\, C => 
        \I10.STATE1l5r_net_1\, Y => \I10.N_2639\);
    
    \I2.un1_TCNT_1_I_1\ : AND2
      port map(A => \I2.N_1885_1\, B => \I2.TCNT_i_il0r_net_1\, Y
         => \I2.DWACT_ADD_CI_0_TMP_2l0r\);
    
    \I2.un1_STATE2_10_i_a2_1\ : OR3FFT
      port map(A => \I2.STATE2l2r_net_1\, B => \I2.N_2895_2\, C
         => \I2.N_2846\, Y => \I2.N_2895_i\);
    
    LCLK_pad : GL33
      port map(PAD => LCLK, GL => LCLK_c);
    
    \I2.REG_1l269r_53\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_232_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL269R_37\);
    
    \I3.SBYTE_5l2r\ : MUX2H
      port map(A => REG_cl131r, B => REGl138r, S => 
        \I3.sstatel0r_net_1\, Y => \I3.SBYTE_5l2r_net_1\);
    
    \I2.VDBi_24l3r\ : MUX2L
      port map(A => \I2.REGl477r\, B => \I2.VDBi_19l3r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l3r_net_1\);
    
    \I1.DATA_12l11r\ : MUX2H
      port map(A => \I1.SBYTEl3r_net_1\, B => REGl116r, S => 
        \I1.DATA_1_sqmuxa_2\, Y => \I1.DATA_12l11r_net_1\);
    
    \I10.PDL_RADDR_229\ : MUX2H
      port map(A => \I10.CNTl5r_net_1\, B => 
        \I10.PDL_RADDRl5r_net_1\, S => \I10.PDL_RADDR_1_sqmuxa\, 
        Y => \I10.PDL_RADDR_229_net_1\);
    
    \I2.un1_tcnt1_I_13\ : XOR2
      port map(A => \I2.TCNT1l3r_net_1\, B => 
        \I2.DWACT_FINC_El0r\, Y => \I2.I_13_2\);
    
    \I2.REG_1l55r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_428_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl55r);
    
    \I1.un1_tick_8_0_0\ : OA21
      port map(A => \I1.N_625_0\, B => \I1.N_632\, C => TICKl0r, 
        Y => \I1.un1_tick_8\);
    
    \I2.VDBi_19l22r\ : AND2
      port map(A => TST_cl5r, B => REGl70r, Y => 
        \I2.VDBi_19l22r_net_1\);
    
    \I2.PIPEA1_535\ : MUX2L
      port map(A => \I2.PIPEA1l24r_net_1\, B => \I2.N_2545\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_535_net_1\);
    
    \I2.REG_1l244r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_207_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => REG_cl244r);
    
    \I2.REG_1l101r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_474_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl101r);
    
    \I3.un4_so_39_0\ : MUX2L
      port map(A => \I3.N_237\, B => \I3.N_226\, S => REGl126r, Y
         => \I3.N_235\);
    
    \I2.REG_1_ml166r\ : NAND2
      port map(A => REGl166r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml166r_net_1\);
    
    \I2.VDBi_54_0_iv_3l14r\ : AO21TTF
      port map(A => REG_cl135r, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l14r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il14r\);
    
    \I2.PIPEA1_9_i_a2l30r\ : OR2FT
      port map(A => \I2.N_2830_4\, B => DPRl30r, Y => \I2.N_2871\);
    
    \I2.REG_1_250\ : MUX2L
      port map(A => \I2.REGL287R_55\, B => VDB_inl22r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_250_net_1\);
    
    \I1.SSTATE2SE_9_128\ : AND2
      port map(A => \I1.sstate2l9r_net_1\, B => \I1.N_279\, Y => 
        \I1.sstate2_ns_el0r_adt_net_8385_\);
    
    \I1.PULSE_I2C\ : MUX2L
      port map(A => \I1.START_I2C_net_1\, B => PULSEl7r, S => 
        REGl7r, Y => \I1.PULSE_I2C_net_1\);
    
    \I10.FID_8_rl20r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il20r\, B => 
        \I10.FID_8_iv_0_0_0_0_il20r\, C => \I10.STATE1L12R_10\, Y
         => \I10.FID_8l20r\);
    
    \I10.EVENT_DWORDl21r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_154_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl21r_net_1\);
    
    \I10.FID_8_IV_0_0_0_0L7R_204\ : NOR2FT
      port map(A => \I10.STATE1L2R_13\, B => \I10.FID_4_il7r\, Y
         => \I10.FID_8_iv_0_0_0_0_il7r_adt_net_23864_\);
    
    \I2.VDBml15r\ : MUX2L
      port map(A => \I2.VDBil15r_net_1\, B => \I2.N_2056\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml15r_net_1\);
    
    \I1.sstatese_1_i\ : MUX2H
      port map(A => \I1.sstatel11r_net_1\, B => 
        \I1.sstatel12r_net_1\, S => TICKl0r, Y => 
        \I1.sstatese_1_i_net_1\);
    
    \I2.un13_reg_ads_0_a2_0_a2\ : NOR3
      port map(A => \I2.N_3061\, B => \I2.N_3065\, C => 
        \I2.N_3000_1\, Y => \I2.un13_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.BNC_CNTl5r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_203_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNTl5r_net_1\);
    
    \I2.WDOGl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.WDOG_3l3r\, CLR => 
        \I2.un17_hwres_i\, Q => \I2.WDOGl3r_net_1\);
    
    \I10.EVNT_NUMl3r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVNT_NUM_3l3r\, CLR => 
        CLEAR_0_0, Q => \I10.EVNT_NUMl3r_net_1\);
    
    \I10.CRC32_3_i_0_0l27r\ : NOR2
      port map(A => \I10.STATE1l12r_net_1\, B => 
        \I10.N_2319_i_i_0\, Y => \I10.N_1216\);
    
    LBSP_padl11r : IOB33PH
      port map(PAD => LBSP(11), A => REGl404r, EN => REG_i_0l276r, 
        Y => LBSP_inl11r);
    
    \I2.REG_1_358\ : MUX2L
      port map(A => \I2.REGL443R_27\, B => VDB_inl2r, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_358_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l23r\ : OR2
      port map(A => LB_inl23r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__net_1\, Y => 
        \I2.N_3032\);
    
    NOEAD_pad : OB33PH
      port map(PAD => NOEAD, A => NOEAD_C_0_0_21);
    
    \I10.un1_REG_1_ADD_16x16_medium_I35_Y\ : OR2FT
      port map(A => \I10.N263_i\, B => \I10.N261\, Y => 
        \I10.N275\);
    
    \I2.REG_1l73r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_446_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl73r);
    
    \I8.BITCNT_6_rl2r\ : OA21
      port map(A => \I8.N_219\, B => \I8.I_18\, C => 
        \I8.SWORD_0_sqmuxa\, Y => \I8.BITCNT_6l2r\);
    
    \I1.sstatese_0_0_a3_0\ : OR3FTT
      port map(A => TICKl0r, B => \I1.N_544\, C => \I1.N_402\, Y
         => \I1.N_452\);
    
    \I2.VAS_84\ : MUX2L
      port map(A => VAD_inl2r, B => \I2.VASl2r_net_1\, S => 
        \I2.TST_c_0l1r\, Y => \I2.VAS_84_net_1\);
    
    \I2.REG_il279r\ : INV
      port map(A => \I2.REGl279r\, Y => REG_i_0l279r);
    
    \I2.UN1_STATE5_9_1_RD1__497\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.UN1_STATE5_9_1_92\, CLR
         => HWRES_c_2_0, Q => \I2.UN1_STATE5_9_1_RD1__82\);
    
    \I1.sstate2_0_sqmuxa_4_0_a3_0\ : NAND2
      port map(A => \I1.sstate2l1r_net_1\, B => REGl105r, Y => 
        \I1.sstate2_0_sqmuxa_4_0\);
    
    \I2.LB_sl21r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl21r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl21r_Rd1__net_1\);
    
    \I10.CRC32l26r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_113_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l26r_net_1\);
    
    \I2.VDBi_583\ : MUX2L
      port map(A => \I2.VDBil7r_net_1\, B => \I2.VDBi_86l7r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_583_net_1\);
    
    \I2.un1_vsel_2_i\ : OAI21TTF
      port map(A => \I2.N_2892_4\, B => 
        \I2.un1_state1_1_i_a2_0_1_net_1\, C => TST_cl0r, Y => 
        \I2.N_2639\);
    
    SP_PDL_padl14r : IOB33PH
      port map(PAD => SP_PDL(14), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl14r);
    
    \I2.VDBil6r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VDBi_582_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.VDBil6r_net_1\);
    
    \I2.LB_i_7l24r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l24r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l24r_Rd1__net_1\);
    
    \I3.AEl33r\ : MUX2L
      port map(A => REGl186r, B => \I3.un16_ael33r\, S => 
        MD_PDL_C_24, Y => AE_PDL_cl33r);
    
    \I2.VASl9r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.VAS_91_net_1\, CLR => 
        HWRES_c_2_0, Q => \I2.VAS_i_0_il9r\);
    
    \I2.un78_reg_ads_0_a2_0_a2\ : NOR2
      port map(A => \I2.N_3006_1\, B => \I2.N_3002_1\, Y => 
        \I2.un78_reg_ads_0_a2_0_a2_net_1\);
    
    \I10.BNC_CNTl13r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.BNC_CNT_211_net_1\, CLR
         => CLEAR_0_0, Q => \I10.BNC_CNT_i_il13r\);
    
    \I2.REG_1_213\ : MUX2L
      port map(A => VDB_inl1r, B => REGl250r, S => 
        \I2.PULSE_1_sqmuxa_6_0\, Y => \I2.REG_1_213_net_1\);
    
    \I1.sstate2l9r\ : DFFS
      port map(CLK => CLKOUT, D => \I1.sstate2_ns_el0r\, SET => 
        HWRES_c_2_0, Q => \I1.sstate2l9r_net_1\);
    
    \I10.TRIGGERS\ : OR2
      port map(A => \I10.BNC_LIMIT_net_1\, B => PULSEl2r, Y => 
        REGl384r);
    
    \I2.REG_1l162r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_152_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl162r);
    
    \I2.NRDMEBi_0_sqmuxa_1\ : OAI21FTT
      port map(A => REGl5r, B => DTEST_FIFO, C => 
        \I2.STATE2l5r_net_1\, Y => \I2.NRDMEBi_0_sqmuxa_1_net_1\);
    
    \I10.EVENT_DWORD_154\ : MUX2H
      port map(A => \I10.EVENT_DWORDl21r_net_1\, B => 
        \I10.EVENT_DWORD_18l21r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_154_net_1\);
    
    \I2.VDBi_54_0_iv_5l6r\ : OR3
      port map(A => \I2.VDBi_54_0_iv_3_il6r\, B => 
        \I2.VDBi_54_0_iv_0_il6r\, C => \I2.VDBi_54_0_iv_1_il6r\, 
        Y => \I2.VDBi_54_0_iv_5_il6r\);
    
    PSM_SP5_pad : IB33
      port map(PAD => PSM_SP5, Y => PSM_SP5_c);
    
    \I2.VDBi_54_0_iv_3l10r\ : AO21TTF
      port map(A => REG_cl131r, B => \I2.REGMAPl16r_net_1\, C => 
        \I2.VDBi_54_0_iv_2l10r_net_1\, Y => 
        \I2.VDBi_54_0_iv_3_il10r\);
    
    \I2.REG_il293r\ : INV
      port map(A => \I2.REGl293r\, Y => REG_i_0l293r);
    
    LBSP_padl21r : IOB33PH
      port map(PAD => LBSP(21), A => REGl414r, EN => REG_i_0l286r, 
        Y => LBSP_inl21r);
    
    DS0B_pad : IB33
      port map(PAD => DS0B, Y => DS0B_c);
    
    \I3.ISI_0_sqmuxa_0_a3\ : AND2FT
      port map(A => \I3.un4_pulse_net_1\, B => \I3.sstate_dl3r\, 
        Y => \I3.ISI_0_sqmuxa\);
    
    \I2.VDBi_67_sn_m1_0_a2\ : NOR2
      port map(A => \I2.REGMAPl31r_net_1\, B => 
        \I2.REGMAPl32r_net_1\, Y => \I2.N_1965\);
    
    \I2.PIPEB_4_il6r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl6r, Y => \I2.N_2581\);
    
    \I2.VDBi_86_iv_1l7r\ : AO21
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl7r\, C
         => \I2.VDBi_86_iv_1_il7r_adt_net_49127_\, Y => 
        \I2.VDBi_86_iv_1_il7r\);
    
    \I2.VDBi_595\ : MUX2L
      port map(A => \I2.VDBil19r_net_1\, B => \I2.VDBi_86l19r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_595_net_1\);
    
    \I2.REG_1_400\ : MUX2H
      port map(A => VDB_inl11r, B => \I2.REGl485r\, S => 
        \I2.N_3625_i_1\, Y => \I2.REG_1_400_net_1\);
    
    \I1.SBYTE_31\ : MUX2H
      port map(A => \I1.SBYTEl3r_net_1\, B => \I1.N_602\, S => 
        \I1.un1_tick_8\, Y => \I1.SBYTE_31_net_1\);
    
    \I2.VADml4r\ : AND2FT
      port map(A => \I2.N_2319_1\, B => \I2.PIPEAl4r_net_1\, Y
         => \I2.VADml4r_net_1\);
    
    \I2.REG_1l196r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_186_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl196r);
    
    \I2.PIPEB_4_il23r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl23r, Y => \I2.N_2615\);
    
    \I2.LB_s_4_i_a2_0_a2l28r\ : OR2
      port map(A => LB_inl28r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119377__net_1\, 
        Y => \I2.N_3037\);
    
    \I8.SWORD_1\ : MUX2H
      port map(A => \I8.SWORDl0r_net_1\, B => 
        \I8.SWORD_5l0r_net_1\, S => \I8.N_198_0\, Y => 
        \I8.SWORD_1_net_1\);
    
    \I5.RESCNTl2r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l2r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl2r_net_1\);
    
    \I2.VSEL_0_a2_0\ : NOR2FT
      port map(A => \I2.N_2848\, B => TST_cl0r, Y => 
        \I2.TST_c_0l1r\);
    
    \I2.REG_92_0l83r\ : MUX2H
      port map(A => VDB_inl2r, B => REGl83r, S => 
        \I2.REG_1_sqmuxa_1\, Y => \I2.N_1986\);
    
    \I10.FID_8_iv_0_0_0_1l21r\ : AO21
      port map(A => \I10.STATE1l1r_net_1\, B => 
        \I10.EVENT_DWORDl21r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_1_il21r_adt_net_21929_\, Y => 
        \I10.FID_8_iv_0_0_0_1_il21r\);
    
    TST_padl6r : OB33PH
      port map(PAD => TST(6), A => \I2.N_2768_i_0\);
    
    \I8.un1_BITCNT_I_21\ : AND2
      port map(A => \I8.DWACT_ADD_CI_0_g_array_1l0r\, B => 
        \I8.BITCNTl2r_net_1\, Y => 
        \I8.DWACT_ADD_CI_0_g_array_12l0r\);
    
    \I10.OR_RADDR_219\ : MUX2H
      port map(A => \I10.CNTl1r_net_1\, B => 
        \I10.OR_RADDRl1r_net_1\, S => \I10.N_2126\, Y => 
        \I10.OR_RADDR_219_net_1\);
    
    \I3.un16_ae_1_1\ : OR2
      port map(A => \I3.un16_ae_1l41r\, B => \I3.un16_ae_1l15r\, 
        Y => \I3.un16_ae_1l1r\);
    
    \I2.VDBi_61l22r\ : MUX2L
      port map(A => LBSP_inl22r, B => \I2.VDBi_56l22r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l22r_net_1\);
    
    \I2.STATE1_ns_0_a2_1_1l5r\ : AND2
      port map(A => \I2.STATE1l8r_net_1\, B => 
        \I2.REGMAPl0r_net_1\, Y => \I2.N_2909_1\);
    
    \I2.MBLTCYC_106\ : OA21TTF
      port map(A => \I2.MBLTCYC_net_1\, B => 
        \I2.N_2639_adt_net_74747_\, C => TST_cl0r, Y => 
        \I2.MBLTCYC_106_net_1\);
    
    \I2.LB_sl19r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl19r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl19r_Rd1__net_1\);
    
    \I3.un4_so_47_0\ : MUX2L
      port map(A => \I3.N_254\, B => \I3.N_251\, S => REGl122r, Y
         => \I3.N_255\);
    
    \I2.REG_1_428\ : MUX2H
      port map(A => VDB_inl7r, B => REGl55r, S => \I2.N_3689_i_1\, 
        Y => \I2.REG_1_428_net_1\);
    
    \I1.sstatel1r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.sstatese_11_i_net_1\, CLR
         => HWRES_c_2_0, Q => \I1.sstatel1r_net_1\);
    
    \I2.PIPEA1_522\ : MUX2L
      port map(A => \I2.PIPEA1l11r_net_1\, B => \I2.N_2519\, S
         => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_522_net_1\);
    
    \I3.un4_so_13_0\ : MUX2L
      port map(A => SP_PDL_inl18r, B => \I3.N_208\, S => 
        REGL126R_4, Y => \I3.N_209\);
    
    \I2.VDBi_67l9r\ : MUX2L
      port map(A => \I2.VDBi_61l9r_net_1\, B => \I2.N_1958\, S
         => \I2.N_1965\, Y => \I2.VDBi_67l9r_net_1\);
    
    \I2.REG_1l399r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_314_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl399r);
    
    \I2.VDBi_86_iv_0l1r\ : AO21TTF
      port map(A => \I2.STATE1l2r_net_1\, B => 
        \I2.VDBi_82l1r_net_1\, C => \I2.VDBi_85_ml1r_net_1\, Y
         => \I2.VDBi_86_iv_0_il1r\);
    
    \I1.COMMAND_4l8r\ : MUX2L
      port map(A => \I1.AIR_COMMANDl8r_net_1\, B => REGl97r, S
         => REGL7R_2, Y => \I1.COMMAND_4l8r_net_1\);
    
    SP_PDL_padl47r : IOB33PH
      port map(PAD => SP_PDL(47), A => REGl129r, EN => MD_PDL_c, 
        Y => SP_PDL_inl47r);
    
    \I2.VDBi_86_iv_2l9r\ : AOI21TTF
      port map(A => \I2.VDBi_1_sqmuxa_1_1\, B => \I2.LB_sl9r\, C
         => \I2.VDBi_86_iv_1l9r_net_1\, Y => 
        \I2.VDBi_86_iv_2l9r_net_1\);
    
    \I2.VDBi_86_iv_0l14r\ : AOI21TTF
      port map(A => \I2.VDBil14r_net_1\, B => 
        \I2.STATE1l2r_net_1\, C => \I2.VDBi_85_ml14r_net_1\, Y
         => \I2.VDBi_86_iv_0l14r_net_1\);
    
    \I2.REG_il295r\ : INV
      port map(A => \I2.REGl295r\, Y => REG_i_0l295r);
    
    \I2.VDBi_580\ : MUX2L
      port map(A => \I2.VDBil4r_net_1\, B => \I2.VDBi_86l4r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_580_net_1\);
    
    \I2.STATE5l4r_adt_net_116400_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.STATE5_NS_I_IL0R_94\, 
        SET => HWRES_c_2_0, Q => 
        \I2.STATE5l4r_adt_net_116400_Rd1__net_1\);
    
    \I5.un1_RESCNT_I_40\ : XOR2
      port map(A => \I5.RESCNTl0r_net_1\, B => \I5.G_net_1\, Y
         => \I5.DWACT_ADD_CI_0_partial_suml0r\);
    
    \I1.I_207\ : OAI21TTF
      port map(A => \I1.COMMANDl1r_net_1\, B => \I1.N_544\, C => 
        \I1.sstatel11r_net_1\, Y => \I1.N_536\);
    
    \I2.VDBI_86_IV_1L5R_393\ : AND2
      port map(A => \I2.PIPEAl5r_net_1\, B => \I2.N_1707_i_0_1\, 
        Y => \I2.VDBi_86_iv_1_il5r_adt_net_50761_\);
    
    \I2.STATE5l0r_127\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.STATE5_nsl4r\, CLR => 
        HWRES_c_2_0, Q => \I2.STATE5L0R_111\);
    
    \I2.STATE1_ns_0_0l0r\ : AO21TTF
      port map(A => TST_CL2R_16, B => \I2.STATE1l9r_net_1\, C => 
        \I2.N_2837\, Y => \I2.STATE1_ns_0_0_il0r\);
    
    \I3.un4_so_30_0\ : MUX2L
      port map(A => \I3.N_236\, B => \I3.N_225\, S => REGl127r, Y
         => \I3.N_226\);
    
    VDB_padl18r : IOB33PH
      port map(PAD => VDB(18), A => \I2.VDBml18r_net_1\, EN => 
        \I2.N_2732_0\, Y => VDB_inl18r);
    
    \I10.un2_i2c_chain_0_0_0_0_2l3r\ : OAI21FTF
      port map(A => \I10.DWACT_ADD_CI_0_pog_array_1l0r\, B => 
        \I10.N_2400_1\, C => \I10.un2_i2c_chain_0_0_0_0_0_il3r\, 
        Y => \I10.un2_i2c_chain_0_0_0_0_2_il3r\);
    
    \I10.FID_8_rl15r\ : AND2FT
      port map(A => \I10.STATE1L12R_10\, B => 
        \I10.FID_8l15r_adt_net_22910_\, Y => \I10.FID_8l15r\);
    
    \I8.SWORD_5l9r\ : MUX2L
      port map(A => REGl258r, B => \I8.SWORDl8r_net_1\, S => 
        \I8.sstate_d_0l3r\, Y => \I8.SWORD_5l9r_net_1\);
    
    \I2.STATE2_il4r\ : INV
      port map(A => \I2.STATE2l4r_net_1\, Y => 
        \I2.STATE2_il4r_net_1\);
    
    \I2.N_3022_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.N_3022\, SET => 
        HWRES_c_2_0, Q => \I2.N_3022_Rd1__net_1\);
    
    \I10.G_1_0\ : OR2
      port map(A => \I10.un6_bnc_res_3_i_i\, B => 
        \I10.un6_bnc_res_NE_4_i\, Y => \I10.G_1_i\);
    
    \I10.L2AF2\ : DFFC
      port map(CLK => ACLKOUT, D => \I10.L2AF1_net_1\, CLR => 
        HWRES_c_2_0, Q => \I10.L2AF2_net_1\);
    
    \I2.REG_1l72r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_445_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl72r);
    
    \I2.PIPEB_4_il14r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl14r, Y => \I2.N_2597\);
    
    \I2.LB_il8r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_il8r\, CLR => 
        HWRES_c_2_0, Q => \I2.LB_il8r_Rd1__net_1\);
    
    \I10.FIDl10r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FID_175_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.FIDl10r_net_1\);
    
    \I2.REG_1l157r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_147_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl157r);
    
    \I2.LB_i_7l30r_Rd1_\ : DFFC
      port map(CLK => ALICLK_c, D => \I2.LB_i_7l30r_net_1\, CLR
         => HWRES_c_2_0, Q => \I2.LB_i_7l30r_Rd1__net_1\);
    
    \I2.PIPEB_4_il3r\ : AND2
      port map(A => \I2.N_2847_1\, B => DPRl3r, Y => \I2.N_2575\);
    
    \I10.EVENT_DWORD_18_i_0_0_0l21r\ : OAI21TTF
      port map(A => I2C_RDATAl1r, B => \I10.N_2639\, C => 
        \I10.EVENT_DWORD_18_i_0_0_0l21r_adt_net_26146_\, Y => 
        \I10.EVENT_DWORD_18_i_0_0_0l21r_net_1\);
    
    \I10.EVENT_DWORDl25r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.EVENT_DWORD_158_net_1\, 
        CLR => CLEAR_0_0, Q => \I10.EVENT_DWORDl25r_net_1\);
    
    \I2.PIPEA1_542\ : MUX2L
      port map(A => \I2.PIPEA1l31r_net_1\, B => \I2.PIPEA1_9l31r\, 
        S => \I2.un1_STATE2_13_4_1\, Y => \I2.PIPEA1_542_net_1\);
    
    \I2.PIPEA_8_RL7R_446\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l7r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l7r_adt_net_57184_\);
    
    \I5.RESCNT_6_rl4r\ : OA21FTT
      port map(A => \I5.sstate_nsl5r\, B => \I5.I_55\, C => 
        \I5.N_211_0\, Y => \I5.RESCNT_6l4r\);
    
    LBSP_padl7r : IOB33PH
      port map(PAD => LBSP(7), A => REGl400r, EN => REG_i_0l272r, 
        Y => LBSP_inl7r);
    
    \I2.PIPEA1l21r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.PIPEA1_532_net_1\, CLR => 
        CLEAR_0_0, Q => \I2.PIPEA1l21r_net_1\);
    
    \I2.VDBm_0l16r\ : MUX2L
      port map(A => \I2.PIPEAl16r_net_1\, B => 
        \I2.PIPEBl16r_net_1\, S => \I2.BLTCYC_net_1\, Y => 
        \I2.N_2057\);
    
    \I10.EVENT_DWORD_160\ : MUX2H
      port map(A => \I10.EVENT_DWORDl27r_net_1\, B => 
        \I10.EVENT_DWORD_18l27r\, S => \I10.un1_STATE1_14_1_0\, Y
         => \I10.EVENT_DWORD_160_net_1\);
    
    \I2.LB_s_4_i_a2_0_a2l29r\ : OR2
      port map(A => LB_inl29r, B => 
        \I2.STATE5l4r_adt_net_116396_Rd1__adt_net_119373__net_1\, 
        Y => \I2.N_3014\);
    
    \I10.CRC32l27r\ : DFFC
      port map(CLK => CLKOUT, D => \I10.CRC32_114_net_1\, CLR => 
        CLEAR_0_0, Q => \I10.CRC32l27r_net_1\);
    
    \I1.COMMANDl1r\ : DFFC
      port map(CLK => CLKOUT, D => \I1.COMMAND_2_net_1\, CLR => 
        HWRES_c_2_0, Q => \I1.COMMANDl1r_net_1\);
    
    \I2.VDBi_61l28r\ : MUX2L
      port map(A => LBSP_inl28r, B => \I2.VDBi_56l28r_net_1\, S
         => \I2.REGMAPl30r_net_1\, Y => \I2.VDBi_61l28r_net_1\);
    
    \I2.REG_1l411r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_326_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl411r);
    
    LBSP_padl1r : IOB33PH
      port map(PAD => LBSP(1), A => REGl394r, EN => REG_i_0l266r, 
        Y => LBSP_inl1r);
    
    \I10.FAULT_STAT\ : DFFC
      port map(CLK => CLKOUT, D => \I10.FAULT_STAT_121_net_1\, 
        CLR => HWRES_c_2_0, Q => \I10.FAULT_STAT_net_1\);
    
    LB_padl20r : IOB33PH
      port map(PAD => LB(20), A => \I2.LB_il20r\, EN => 
        \I2.LB_nOE_i_0_1\, Y => LB_inl20r);
    
    \I2.VDBi_86_iv_0l13r\ : AOI21TTF
      port map(A => \I2.VDBil13r_net_1\, B => 
        \I2.STATE1l2r_net_1\, C => \I2.VDBi_85_ml13r_net_1\, Y
         => \I2.VDBi_86_iv_0l13r_net_1\);
    
    \I2.REG_il269r\ : INV
      port map(A => \I2.REGl269r\, Y => REG_i_0l269r);
    
    \I2.LB_s_44\ : MUX2L
      port map(A => \I2.LB_sl30r_Rd1__net_1\, B => 
        \I2.N_3015_Rd1__net_1\, S => 
        \I2.N_3021_1_adt_net_116344_Rd1__net_1\, Y => 
        \I2.LB_sl30r\);
    
    BNCRES_pad : IB33
      port map(PAD => BNCRES, Y => BNCRES_c);
    
    \I2.VDBi_603\ : MUX2L
      port map(A => \I2.VDBil27r_net_1\, B => \I2.VDBi_86l27r\, S
         => \I2.N_1712_1\, Y => \I2.VDBi_603_net_1\);
    
    \I2.VDBI_17_0L8R_373\ : AND2FT
      port map(A => \I10.REGl40r\, B => \I2.REGMAPl6r_net_1\, Y
         => \I2.N_1905_adt_net_47816_\);
    
    \I2.REG_1_356\ : MUX2L
      port map(A => \I2.REGL441R_25\, B => VDB_inl0r, S => 
        \I2.N_3527_i_0\, Y => \I2.REG_1_356_net_1\);
    
    \I2.LB_sl27r_Rd1_\ : DFFS
      port map(CLK => ALICLK_c, D => \I2.LB_sl27r\, SET => 
        HWRES_c_2_0, Q => \I2.LB_sl27r_Rd1__net_1\);
    
    \I1.sstatese_13_a3_1\ : AND3FTT
      port map(A => \I1.COMMANDl2r_net_1\, B => 
        \I1.sstatel0r_net_1\, C => TICKl0r, Y => \I1.N_455_i\);
    
    \I10.FID_8_iv_0_0_0_0l19r\ : AO21
      port map(A => \I10.STATE1L2R_13\, B => 
        \I10.EVNT_NUMl3r_net_1\, C => 
        \I10.FID_8_iv_0_0_0_0_il19r_adt_net_22299_\, Y => 
        \I10.FID_8_iv_0_0_0_0_il19r\);
    
    \I2.VDBi_24l25r\ : MUX2L
      port map(A => \I2.REGl499r\, B => \I2.VDBi_19l25r_net_1\, S
         => \I2.REGMAPl13r_net_1\, Y => \I2.VDBi_24l25r_net_1\);
    
    SP_PDL_padl0r : IOB33PH
      port map(PAD => SP_PDL(0), A => REGL129R_1, EN => 
        MD_PDL_C_7, Y => SP_PDL_inl0r);
    
    \I2.REG_1l58r\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_431_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => REGl58r);
    
    \I10.READ_PDL_FLAG\ : DFFC
      port map(CLK => CLKOUT, D => 
        \I10.READ_PDL_FLAG_86_0_0_0_net_1\, CLR => CLEAR_0_0, Q
         => \I10.READ_PDL_FLAG_net_1\);
    
    \I10.EVENT_DWORD_18_rl21r\ : AND2FT
      port map(A => \I10.EVENT_DWORD_18_i_0_0_1l21r_net_1\, B => 
        \I10.EVENT_DWORD_18l21r_adt_net_26218_\, Y => 
        \I10.EVENT_DWORD_18l21r\);
    
    \I3.un16_ae_6\ : NOR2
      port map(A => \I3.un16_ae_2l7r\, B => \I3.un16_ae_1l6r\, Y
         => \I3.un16_ael6r\);
    
    \I2.un1_TCNT_1_I_19\ : XOR2
      port map(A => \I2.DWACT_ADD_CI_0_pog_array_0l0r\, B => 
        \I2.DWACT_ADD_CI_0_TMP_2l0r\, Y => \I2.I_19\);
    
    \I2.VDBi_59_dl2r\ : MUX2H
      port map(A => SPULSE2_c, B => L1R_c, S => 
        \I2.REGMAPl29r_net_1\, Y => \I2.VDBi_59_dl2r_net_1\);
    
    \I2.VDBi_67_sl8r\ : AND2FT
      port map(A => \I2.REGMAPl30r_net_1\, B => \I2.N_1965\, Y
         => \I2.VDBi_67_sl8r_net_1\);
    
    SYNC_padl10r : OB33PH
      port map(PAD => SYNC(10), A => REG_cl243r);
    
    \I2.un756_regmap_12\ : OR2
      port map(A => \I2.REGMAPl0r_net_1\, B => 
        \I2.REGMAPl28r_net_1\, Y => 
        \I2.un756_regmap_12_i_adt_net_36217_\);
    
    \I2.REG_1_ml168r\ : NAND2
      port map(A => REGl168r, B => \I2.REGMAPl18r_net_1\, Y => 
        \I2.REG_1_ml168r_net_1\);
    
    \I2.REG_1l236r\ : DFFS
      port map(CLK => CLKOUT, D => \I2.REG_1_199_net_1\, SET => 
        \I2.N_2483_i_0_0_0\, Q => SYNC_cl3r);
    
    \I2.REG_1l280r_64\ : DFFC
      port map(CLK => CLKOUT, D => \I2.REG_1_243_net_1\, CLR => 
        \I2.N_2483_i_0_0_0\, Q => \I2.REGL280R_48\);
    
    \I2.VDBml30r\ : MUX2L
      port map(A => \I2.VDBil30r_net_1\, B => \I2.N_2071\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml30r_net_1\);
    
    \I2.VDBI_86_IV_1L4R_399\ : AND2
      port map(A => \I2.PIPEAl4r_net_1\, B => \I2.N_1707_i_0_1\, 
        Y => \I2.VDBi_86_iv_1_il4r_adt_net_51564_\);
    
    \I2.REG_1_236\ : MUX2L
      port map(A => \I2.REGL273R_41\, B => VDB_inl8r, S => 
        \I2.N_3303_i_1\, Y => \I2.REG_1_236_net_1\);
    
    \I1.sstate2se_9\ : AO21FTT
      port map(A => \I1.N_277_0\, B => \I1.sstate2l0r_net_1\, C
         => \I1.sstate2_ns_el0r_adt_net_8385_\, Y => 
        \I1.sstate2_ns_el0r\);
    
    \I10.un1_STATE1_15_0_0_0_0_1\ : OR2
      port map(A => \I10.N_2351_0_0\, B => 
        \I10.un1_STATE1_15_1_adt_net_16929_\, Y => 
        \I10.un1_STATE1_15_1\);
    
    \I5.RESCNTl6r\ : DFFC
      port map(CLK => CLKOUT, D => \I5.RESCNT_6l6r\, CLR => 
        \I5.un2_hwres_2_net_1\, Q => \I5.RESCNTl6r_net_1\);
    
    \I2.VDBml16r\ : MUX2L
      port map(A => \I2.VDBil16r_net_1\, B => \I2.N_2057\, S => 
        \I2.SINGCYC_net_1\, Y => \I2.VDBml16r_net_1\);
    
    \I2.PIPEA_8_RL11R_442\ : OA21FTT
      port map(A => \I2.N_2822_6\, B => \I2.PIPEA1l11r_net_1\, C
         => \I2.N_2830_4\, Y => \I2.PIPEA_8l11r_adt_net_56867_\);
    
    \I10.FID_8_rl26r\ : OA21TTF
      port map(A => \I10.FID_8_iv_0_0_0_1_il26r\, B => 
        \I10.FID_8_iv_0_0_0_0_il26r\, C => \I10.STATE1l12r_net_1\, 
        Y => \I10.FID_8l26r\);
    
    \I10.FID_8_IV_0_0_0_0L27R_165\ : AND2
      port map(A => \I10.STATE1l9r_net_1\, B => 
        \I10.BNC_NUMBERl8r_net_1\, Y => 
        \I10.FID_8_iv_0_0_0_0_il27r_adt_net_20987_\);
    
    LED_padl3r : OB33PH
      port map(PAD => LED(3), A => \VCC\);
    
    \I10.STATE1_ns_a9_0_a2_0_a2_0_a2_1l3r\ : NAND2
      port map(A => REGl506r, B => \I10.EVNT_TRG_net_1\, Y => 
        \I10.STATE1_ns_1l3r\);
    
    \I3.un16_ae_38\ : NOR2
      port map(A => \I3.un16_ae_1l38r\, B => \I3.un16_ae_1l39r\, 
        Y => \I3.un16_ael38r\);
    

end DEF_ARCH; 
