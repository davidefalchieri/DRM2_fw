-- Version: 7.3 7.3.0.29

library ieee;
use ieee.std_logic_1164.all;
library APA;
use APA.all;

entity SoftFIFO160x32 is 
    port(WE, RE, WCLOCK, RCLOCK : in std_logic;  FULL, EMPTY : 
        out std_logic;  RESET : in std_logic;  AEMPTY, AFULL : 
        out std_logic; MEMWADDR : out std_logic_vector(7 downto 0
        ); MEMRADDR : out std_logic_vector(7 downto 0);MEMWE, 
        MEMRE : out std_logic) ;
end SoftFIFO160x32;


architecture DEF_ARCH of  SoftFIFO160x32 is

    component AO21
        port(A, B, C : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component DFFC
        port(CLK, D, CLR : in std_logic := 'U'; Q : out std_logic
        ) ;
    end component;

    component AND2
        port(A, B : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component XNOR2
        port(A, B : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component AO21FTF
        port(A, B, C : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component OR2FT
        port(A, B : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component NAND3FTT
        port(A, B, C : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component XOR2
        port(A, B : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component NOR3FTT
        port(A, B, C : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component INV
        port(A : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component MUX2H
        port(A, B, S : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component AND3
        port(A, B, C : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component AOI21
        port(A, B, C : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component OR3
        port(A, B, C : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component NOR2FT
        port(A, B : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component BFR
        port(A : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component DFFS
        port(CLK, D, SET : in std_logic := 'U'; Q : out std_logic
        ) ;
    end component;

    component NAND2
        port(A, B : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component AND2FT
        port(A, B : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component OR2
        port(A, B : in std_logic := 'U'; Y : out std_logic) ;
    end component;

    component PWR
        port( Y : out std_logic);
    end component;

    component GND
        port( Y : out std_logic);
    end component;

    signal FULL_1_net, EMPTY_1_net, WEP, REP, RBIN_0_net, 
        RBINNXT_0_net, WBINSYNC_0_net, WBIN_0_net, WBINNXT_0_net, 
        RBINSYNC_0_net, RBIN_1_net, RBINNXT_1_net, WBINSYNC_1_net, 
        WBIN_1_net, WBINNXT_1_net, RBINSYNC_1_net, RBIN_2_net, 
        RBINNXT_2_net, WBINSYNC_2_net, WBIN_2_net, WBINNXT_2_net, 
        RBINSYNC_2_net, RBIN_3_net, RBINNXT_3_net, WBINSYNC_3_net, 
        WBIN_3_net, WBINNXT_3_net, RBINSYNC_3_net, RBIN_4_net, 
        RBINNXT_4_net, WBINSYNC_4_net, WBIN_4_net, WBINNXT_4_net, 
        RBINSYNC_4_net, RBIN_5_net, RBINNXT_5_net, WBINSYNC_5_net, 
        WBIN_5_net, WBINNXT_5_net, RBINSYNC_5_net, RBIN_6_net, 
        RBINNXT_6_net, WBINSYNC_6_net, WBIN_6_net, WBINNXT_6_net, 
        RBINSYNC_6_net, RBIN_7_net, RBINNXT_7_net, WBINSYNC_7_net, 
        WBIN_7_net, WBINNXT_7_net, RBINSYNC_7_net, RBIN_8_net, 
        RBINNXT_8_net, WBINSYNC_8_net, WBIN_8_net, WBINNXT_8_net, 
        RBINSYNC_8_net, FULLCONSTVALUE_0_net, 
        FULLCONSTVALUE_5_net, WDIFF_0_net, WDIFF_1_net, 
        WDIFF_2_net, WDIFF_3_net, WDIFF_4_net, WDIFF_5_net, 
        WDIFF_6_net, WDIFF_7_net, WDIFF_8_net, MEMORYWE, 
        AFVALCONST_0_net, AFVALCONST_1_net, WGRY_0_net, 
        WGRY_1_net, WGRY_2_net, WGRY_3_net, WGRY_4_net, 
        WGRY_5_net, WGRY_6_net, WGRY_7_net, WGRY_8_net, 
        RGRYSYNC_0_net, RGRYSYNC_1_net, RGRYSYNC_2_net, 
        RGRYSYNC_3_net, RGRYSYNC_4_net, RGRYSYNC_5_net, 
        RGRYSYNC_6_net, RGRYSYNC_7_net, RGRYSYNC_8_net, 
        EMPTYVALUECONST_0_net, RDIFF_0_net, RDIFF_1_net, 
        RDIFF_2_net, RDIFF_3_net, RDIFF_4_net, RDIFF_5_net, 
        RDIFF_6_net, RDIFF_7_net, RDIFF_8_net, MEMORYRE, 
        AEVALCONST_0_net, AEVALCONST_1_net, DVLDI, DVLDX, 
        RGRY_0_net, RGRY_1_net, RGRY_2_net, RGRY_3_net, 
        RGRY_4_net, RGRY_5_net, RGRY_6_net, RGRY_7_net, 
        RGRY_8_net, WGRYSYNC_0_net, WGRYSYNC_1_net, 
        WGRYSYNC_2_net, WGRYSYNC_3_net, WGRYSYNC_4_net, 
        WGRYSYNC_5_net, WGRYSYNC_6_net, WGRYSYNC_7_net, 
        WGRYSYNC_8_net, MEMWADDR_0_net, MEMWADDR_1_net, 
        MEMWADDR_2_net, MEMWADDR_3_net, MEMWADDR_4_net, 
        MEMWADDR_5_net, MEMWADDR_6_net, MEMWADDR_7_net, 
        MEM_WADDR_8_net, MEMRADDR_0_net, MEMRADDR_1_net, 
        MEMRADDR_2_net, MEMRADDR_3_net, MEMRADDR_4_net, 
        MEMRADDR_5_net, MEMRADDR_6_net, MEMRADDR_7_net, 
        MEM_RADDR_8_net, NOR2FT_0_Y, INV_27_Y, INV_20_Y, 
        INV_109_Y, INV_72_Y, INV_70_Y, INV_73_Y, INV_17_Y, 
        INV_103_Y, INV_40_Y, AND2_49_Y, AND2_79_Y, AND2_12_Y, 
        AND2_43_Y, AND2_51_Y, AND2_81_Y, AND2_23_Y, AND2_47_Y, 
        AND2_9_Y, AND2_88_Y, XOR2_9_Y, XOR2_125_Y, XOR2_29_Y, 
        XOR2_102_Y, XOR2_105_Y, XOR2_58_Y, XOR2_12_Y, XOR2_89_Y, 
        AND2_83_Y, AO21_4_Y, AND2_48_Y, AO21_59_Y, AND2_19_Y, 
        AO21_32_Y, AND2_53_Y, AND2_17_Y, AO21_10_Y, AND2_82_Y, 
        AO21_57_Y, AND2_64_Y, AND2_77_Y, AND2_84_Y, AND2_95_Y, 
        AND2_100_Y, OR3_1_Y, AO21_41_Y, AO21_33_Y, AO21_26_Y, 
        AO21_12_Y, AO21_16_Y, AO21_38_Y, XOR2_136_Y, XOR2_52_Y, 
        XOR2_83_Y, XOR2_21_Y, XOR2_127_Y, XOR2_121_Y, XOR2_71_Y, 
        XOR2_107_Y, DFFC_15_Q, DFFC_8_Q, DFFC_10_Q, DFFC_11_Q, 
        DFFC_0_Q, DFFC_13_Q, DFFC_4_Q, DFFC_3_Q, DFFC_5_Q, 
        INV_102_Y, INV_91_Y, INV_59_Y, INV_1_Y, INV_37_Y, 
        INV_39_Y, INV_99_Y, INV_3_Y, INV_5_Y, INV_107_Y, INV_78_Y, 
        INV_54_Y, INV_25_Y, INV_110_Y, INV_85_Y, INV_76_Y, 
        INV_58_Y, INV_114_Y, XOR2_95_Y, XOR2_0_Y, XNOR2_31_Y, 
        XNOR2_14_Y, XOR2_66_Y, XOR2_143_Y, XOR2_31_Y, XNOR2_18_Y, 
        XNOR2_1_Y, XNOR2_11_Y, XNOR2_15_Y, XOR2_87_Y, XOR2_99_Y, 
        XOR2_79_Y, XNOR2_57_Y, XNOR2_20_Y, XNOR2_12_Y, XOR2_132_Y, 
        XOR2_36_Y, XNOR2_3_Y, XOR2_61_Y, XOR2_47_Y, XOR2_56_Y, 
        XNOR2_29_Y, XNOR2_63_Y, XOR2_81_Y, XOR2_126_Y, XNOR2_52_Y, 
        XOR2_145_Y, XOR2_50_Y, XOR2_133_Y, XOR2_138_Y, XOR2_120_Y, 
        XOR2_139_Y, XOR2_131_Y, XOR2_39_Y, XOR2_112_Y, INV_66_Y, 
        INV_95_Y, INV_43_Y, INV_113_Y, INV_35_Y, INV_61_Y, 
        INV_71_Y, INV_44_Y, INV_34_Y, INV_2_Y, INV_31_Y, INV_53_Y, 
        INV_69_Y, INV_26_Y, INV_16_Y, INV_98_Y, INV_48_Y, 
        INV_42_Y, AND2_45_Y, AND2_13_Y, AND2_75_Y, AND2_38_Y, 
        AND2_1_Y, AND2_55_Y, AND2_0_Y, AND2_52_Y, XOR2_91_Y, 
        XOR2_137_Y, XOR2_42_Y, XOR2_75_Y, XOR2_20_Y, XOR2_113_Y, 
        XOR2_84_Y, XOR2_67_Y, XOR2_17_Y, AND2_56_Y, AO21_24_Y, 
        AND2_21_Y, AO21_29_Y, AND2_11_Y, AO21_58_Y, AND2_7_Y, 
        AND2_73_Y, AO21_43_Y, AND2_3_Y, AND2_90_Y, AND2_69_Y, 
        AND2_10_Y, AND2_36_Y, AND2_54_Y, AO21_30_Y, AND2_28_Y, 
        AND2_41_Y, AO21_11_Y, AO21_51_Y, AO21_20_Y, AO21_50_Y, 
        AO21_7_Y, AO21_52_Y, AO21_3_Y, XOR2_93_Y, XOR2_5_Y, 
        XOR2_129_Y, XOR2_77_Y, XOR2_103_Y, XOR2_109_Y, XOR2_18_Y, 
        XOR2_141_Y, WRADDRGEN_CONST_0_net, WRADDRGEN_CONST_5_net, 
        XOR2_118_Y, XOR2_24_Y, XOR2_140_Y, XOR2_37_Y, XOR2_41_Y, 
        XOR2_35_Y, XOR2_63_Y, XOR2_72_Y, XOR2_51_Y, AND2FT_2_Y, 
        AND2_85_Y, AND3_0_Y, INV_50_Y, MUX2H_16_Y, INV_14_Y, 
        MUX2H_15_Y, INV_68_Y, MUX2H_3_Y, INV_46_Y, MUX2H_14_Y, 
        INV_108_Y, MUX2H_12_Y, INV_63_Y, MUX2H_6_Y, INV_75_Y, 
        MUX2H_2_Y, INV_83_Y, MUX2H_8_Y, INV_106_Y, AND2_26_Y, 
        AO21_19_Y, AO21_2_Y, AO21_55_Y, AO21_15_Y, AO21_49_Y, 
        AO21_0_Y, AO21_48_Y, XOR2_114_Y, AND2_76_Y, XOR2_123_Y, 
        AND2_33_Y, XOR2_16_Y, AND2_5_Y, XOR2_98_Y, AND2_94_Y, 
        XOR2_135_Y, XOR2_32_Y, AND2_50_Y, XOR2_116_Y, AND2_59_Y, 
        XOR2_80_Y, AND2_2_Y, MUX2H_4_Y, INV_104_Y, XNOR2_4_Y, 
        XNOR2_56_Y, XNOR2_54_Y, XNOR2_13_Y, XNOR2_65_Y, 
        XNOR2_39_Y, XNOR2_49_Y, XNOR2_10_Y, XNOR2_6_Y, AND3_11_Y, 
        AND3_8_Y, AND3_9_Y, NAND2_1_Y, XOR2_49_Y, XOR2_57_Y, 
        XOR2_54_Y, XOR2_4_Y, XOR2_78_Y, XOR2_65_Y, XOR2_130_Y, 
        XOR2_134_Y, XOR2_2_Y, INV_94_Y, INV_10_Y, INV_93_Y, 
        INV_29_Y, INV_92_Y, INV_97_Y, INV_89_Y, INV_80_Y, 
        INV_28_Y, INV_88_Y, INV_111_Y, INV_0_Y, INV_81_Y, INV_9_Y, 
        INV_90_Y, INV_21_Y, INV_55_Y, INV_79_Y, AND2_62_Y, 
        AND2_34_Y, AND2_44_Y, AND2_89_Y, AND2_66_Y, AND2_97_Y, 
        AND2_80_Y, AND2_27_Y, XOR2_30_Y, XOR2_74_Y, XOR2_44_Y, 
        XOR2_92_Y, XOR2_15_Y, XOR2_82_Y, XOR2_94_Y, XOR2_70_Y, 
        XOR2_110_Y, AND2_24_Y, AO21_14_Y, AND2_91_Y, AO21_42_Y, 
        AND2_6_Y, AO21_31_Y, AND2_101_Y, AND2_37_Y, AO21_53_Y, 
        AND2_67_Y, AND2_46_Y, AND2_71_Y, AND2_39_Y, AND2_70_Y, 
        AND2_78_Y, AO21_60_Y, AND2_86_Y, AND2_8_Y, AO21_44_Y, 
        AO21_1_Y, AO21_54_Y, AO21_46_Y, AO21_40_Y, AO21_23_Y, 
        AO21_9_Y, XOR2_62_Y, XOR2_7_Y, XOR2_19_Y, XOR2_34_Y, 
        XOR2_45_Y, XOR2_28_Y, XOR2_104_Y, XOR2_119_Y, XOR2_146_Y, 
        XOR2_1_Y, XNOR2_33_Y, XNOR2_45_Y, XOR2_43_Y, XOR2_96_Y, 
        XOR2_33_Y, XNOR2_19_Y, XNOR2_32_Y, XNOR2_42_Y, XNOR2_46_Y, 
        XOR2_68_Y, XOR2_101_Y, XOR2_55_Y, XNOR2_60_Y, XNOR2_48_Y, 
        XNOR2_44_Y, XOR2_88_Y, XOR2_106_Y, XNOR2_38_Y, XOR2_85_Y, 
        XOR2_13_Y, XOR2_144_Y, XNOR2_64_Y, XNOR2_23_Y, XOR2_111_Y, 
        XOR2_128_Y, XNOR2_53_Y, DFFC_1_Q, DFFC_16_Q, DFFC_9_Q, 
        DFFC_6_Q, DFFC_2_Q, DFFC_12_Q, DFFC_17_Q, DFFC_7_Q, 
        DFFC_14_Q, INV_52_Y, INV_77_Y, INV_32_Y, INV_115_Y, 
        INV_74_Y, INV_49_Y, INV_87_Y, INV_45_Y, INV_65_Y, 
        INV_38_Y, INV_100_Y, INV_15_Y, INV_56_Y, INV_13_Y, 
        INV_82_Y, INV_30_Y, INV_24_Y, INV_84_Y, AOI21_0_Y, 
        AND3_10_Y, NAND3FTT_9_Y, AO21_25_Y, OR2FT_16_Y, 
        AO21FTF_7_Y, NOR3FTT_10_Y, OR2FT_10_Y, NAND3FTT_8_Y, 
        XNOR2_47_Y, XNOR2_17_Y, XNOR2_66_Y, AND3_13_Y, 
        NAND3FTT_11_Y, NAND3FTT_20_Y, OR2FT_11_Y, AO21FTF_5_Y, 
        NOR3FTT_0_Y, OR2FT_1_Y, NAND3FTT_4_Y, XNOR2_40_Y, 
        XNOR2_37_Y, XNOR2_58_Y, OR2FT_19_Y, AO21FTF_4_Y, 
        NOR3FTT_6_Y, OR2FT_5_Y, NAND3FTT_23_Y, INV_33_Y, 
        NOR2FT_1_Y, INV_23_Y, INV_12_Y, INV_105_Y, INV_64_Y, 
        INV_62_Y, INV_67_Y, INV_8_Y, INV_96_Y, INV_57_Y, 
        AND2_31_Y, AND2_57_Y, AND2_93_Y, AND2_20_Y, AND2_32_Y, 
        AND2_60_Y, AND2_98_Y, AND2_29_Y, AND2_87_Y, AND2_65_Y, 
        XOR2_115_Y, XOR2_86_Y, XOR2_142_Y, XOR2_73_Y, XOR2_76_Y, 
        XOR2_27_Y, XOR2_117_Y, XOR2_69_Y, AND2_99_Y, AO21_35_Y, 
        AND2_35_Y, AO21_47_Y, AND2_74_Y, AO21_18_Y, AND2_72_Y, 
        AND2_25_Y, AO21_37_Y, AND2_63_Y, AO21_56_Y, AND2_58_Y, 
        AND2_92_Y, AND2_16_Y, AND2_14_Y, AND2_15_Y, OR3_0_Y, 
        AO21_8_Y, AO21_61_Y, AO21_63_Y, AO21_6_Y, AO21_17_Y, 
        AO21_5_Y, XOR2_90_Y, XOR2_46_Y, XOR2_124_Y, XOR2_122_Y, 
        XOR2_97_Y, XOR2_48_Y, XOR2_64_Y, XOR2_11_Y, AND2FT_1_Y, 
        INV_11_Y, INV_101_Y, AOI21_3_Y, INV_51_Y, AND3_12_Y, 
        NAND3FTT_3_Y, AO21_27_Y, OR2FT_23_Y, AO21FTF_1_Y, 
        NOR3FTT_7_Y, OR2FT_18_Y, NAND3FTT_1_Y, XNOR2_25_Y, 
        XNOR2_2_Y, XNOR2_21_Y, AND3_3_Y, NAND3FTT_16_Y, 
        NAND3FTT_13_Y, OR2FT_6_Y, AO21FTF_10_Y, NOR3FTT_8_Y, 
        OR2FT_13_Y, NAND3FTT_2_Y, XNOR2_24_Y, XNOR2_16_Y, 
        XNOR2_7_Y, OR2FT_21_Y, AO21FTF_9_Y, NOR3FTT_11_Y, 
        OR2FT_15_Y, NAND3FTT_15_Y, NAND2_0_Y, AOI21_2_Y, OR2_0_Y, 
        AND3_2_Y, NAND3FTT_18_Y, AO21_62_Y, OR2FT_20_Y, 
        AO21FTF_2_Y, NOR3FTT_4_Y, OR2FT_0_Y, NAND3FTT_7_Y, 
        XNOR2_41_Y, XNOR2_26_Y, XNOR2_59_Y, AND3_5_Y, 
        NAND3FTT_17_Y, NAND3FTT_22_Y, OR2FT_12_Y, AO21FTF_6_Y, 
        NOR3FTT_9_Y, OR2FT_3_Y, NAND3FTT_10_Y, XNOR2_0_Y, 
        XNOR2_55_Y, XNOR2_67_Y, OR2FT_2_Y, AO21FTF_3_Y, 
        NOR3FTT_2_Y, OR2FT_22_Y, NAND3FTT_12_Y, INV_36_Y, 
        AOI21_1_Y, INV_47_Y, AND3_14_Y, NAND3FTT_5_Y, AO21_45_Y, 
        OR2FT_7_Y, AO21FTF_0_Y, NOR3FTT_5_Y, OR2FT_9_Y, 
        NAND3FTT_6_Y, XNOR2_35_Y, XNOR2_36_Y, XNOR2_22_Y, 
        AND3_1_Y, NAND3FTT_19_Y, NAND3FTT_21_Y, OR2FT_14_Y, 
        AO21FTF_8_Y, NOR3FTT_1_Y, OR2FT_8_Y, NAND3FTT_14_Y, 
        XNOR2_8_Y, XNOR2_61_Y, XNOR2_50_Y, OR2FT_17_Y, 
        AO21FTF_11_Y, NOR3FTT_3_Y, OR2FT_4_Y, NAND3FTT_0_Y, 
        RDADDRGEN_CONST_0_net, RDADDRGEN_CONST_5_net, XOR2_60_Y, 
        XOR2_53_Y, XOR2_23_Y, XOR2_147_Y, XOR2_100_Y, XOR2_38_Y, 
        XOR2_6_Y, XOR2_8_Y, XOR2_22_Y, AND2FT_0_Y, AND2_42_Y, 
        AND3_4_Y, INV_41_Y, MUX2H_13_Y, INV_4_Y, MUX2H_0_Y, 
        INV_22_Y, MUX2H_1_Y, INV_86_Y, MUX2H_17_Y, INV_112_Y, 
        MUX2H_7_Y, INV_19_Y, MUX2H_10_Y, INV_60_Y, MUX2H_11_Y, 
        INV_6_Y, MUX2H_9_Y, INV_7_Y, AND2_61_Y, AO21_39_Y, 
        AO21_28_Y, AO21_36_Y, AO21_13_Y, AO21_21_Y, AO21_34_Y, 
        AO21_22_Y, XOR2_40_Y, AND2_18_Y, XOR2_108_Y, AND2_68_Y, 
        XOR2_10_Y, AND2_4_Y, XOR2_59_Y, AND2_22_Y, XOR2_25_Y, 
        XOR2_14_Y, AND2_40_Y, XOR2_3_Y, AND2_96_Y, XOR2_26_Y, 
        AND2_30_Y, MUX2H_5_Y, INV_18_Y, XNOR2_5_Y, XNOR2_62_Y, 
        XNOR2_34_Y, XNOR2_27_Y, XNOR2_43_Y, XNOR2_30_Y, 
        XNOR2_28_Y, XNOR2_9_Y, XNOR2_51_Y, AND3_15_Y, AND3_7_Y, 
        AND3_6_Y, VCC, GND_1_net : std_logic ;
    begin   

    AFVALCONST_0_net <= FULLCONSTVALUE_0_net;
    AFVALCONST_1_net <= FULLCONSTVALUE_5_net;
    EMPTYVALUECONST_0_net <= FULLCONSTVALUE_0_net;
    AEVALCONST_0_net <= FULLCONSTVALUE_0_net;
    AEVALCONST_1_net <= FULLCONSTVALUE_5_net;
    WRADDRGEN_CONST_0_net <= FULLCONSTVALUE_0_net;
    WRADDRGEN_CONST_5_net <= FULLCONSTVALUE_5_net;
    RDADDRGEN_CONST_0_net <= FULLCONSTVALUE_0_net;
    RDADDRGEN_CONST_5_net <= FULLCONSTVALUE_5_net;
    VCC <= FULLCONSTVALUE_5_net;
    GND_1_net <= FULLCONSTVALUE_0_net;
    FULL <= FULL_1_net;
    
    EMPTY <= EMPTY_1_net;
    
    MEMWADDR(0) <= MEMWADDR_0_net;
    
    MEMWADDR(1) <= MEMWADDR_1_net;
    
    MEMWADDR(2) <= MEMWADDR_2_net;
    
    MEMWADDR(3) <= MEMWADDR_3_net;
    
    MEMWADDR(4) <= MEMWADDR_4_net;
    
    MEMWADDR(5) <= MEMWADDR_5_net;
    
    MEMWADDR(6) <= MEMWADDR_6_net;
    
    MEMWADDR(7) <= MEMWADDR_7_net;
    
    MEMRADDR(0) <= MEMRADDR_0_net;
    
    MEMRADDR(1) <= MEMRADDR_1_net;
    
    MEMRADDR(2) <= MEMRADDR_2_net;
    
    MEMRADDR(3) <= MEMRADDR_3_net;
    
    MEMRADDR(4) <= MEMRADDR_4_net;
    
    MEMRADDR(5) <= MEMRADDR_5_net;
    
    MEMRADDR(6) <= MEMRADDR_6_net;
    
    MEMRADDR(7) <= MEMRADDR_7_net;
    
    PWR_1_net : PWR port map(Y => FULLCONSTVALUE_5_net);
    GND_2_net : GND port map(Y => FULLCONSTVALUE_0_net);
    AO21_63 : AO21
      port map(A => AND2_35_Y, B => AO21_8_Y, C => AO21_35_Y, 
        Y => AO21_63_Y);
    DFFC_WGRYSYNC_5_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_13_Q, CLR => INV_5_Y, 
        Q => WGRYSYNC_5_net);
    AND2_12 : AND2
      port map(A => INV_27_Y, B => INV_40_Y, Y => AND2_12_Y);
    XNOR2_35 : XNOR2
      port map(A => RDIFF_6_net, B => AEVALCONST_0_net, Y => 
        XNOR2_35_Y);
    AO21FTF_2 : AO21FTF
      port map(A => AFVALCONST_0_net, B => WDIFF_7_net, C => 
        AFVALCONST_1_net, Y => AO21FTF_2_Y);
    OR2FT_18 : OR2FT
      port map(A => FULLCONSTVALUE_0_net, B => WDIFF_8_net, Y => 
        OR2FT_18_Y);
    DFFC_RGRY_7_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_39_Y, CLR => INV_61_Y, 
        Q => RGRY_7_net);
    AND2_72 : AND2
      port map(A => XOR2_117_Y, B => XOR2_69_Y, Y => AND2_72_Y);
    XNOR2_24 : XNOR2
      port map(A => WDIFF_3_net, B => FULLCONSTVALUE_0_net, Y => 
        XNOR2_24_Y);
    NAND3FTT_9 : NAND3FTT
      port map(A => NOR3FTT_10_Y, B => OR2FT_10_Y, C => 
        NAND3FTT_8_Y, Y => NAND3FTT_9_Y);
    XNOR2_19 : XNOR2
      port map(A => WGRYSYNC_8_net, B => WGRYSYNC_7_net, Y => 
        XNOR2_19_Y);
    XNOR2_47 : XNOR2
      port map(A => RDIFF_6_net, B => EMPTYVALUECONST_0_net, Y => 
        XNOR2_47_Y);
    XOR2_58 : XOR2
      port map(A => WBINSYNC_6_net, B => INV_73_Y, Y => XOR2_58_Y);
    NOR3FTT_9 : NOR3FTT
      port map(A => OR2FT_12_Y, B => AO21FTF_6_Y, C => 
        WDIFF_3_net, Y => NOR3FTT_9_Y);
    INV_68 : INV
      port map(A => AND2_85_Y, Y => INV_68_Y);
    XOR2_RBINNXT_7_inst : XOR2
      port map(A => XOR2_18_Y, B => AO21_52_Y, Y => RBINNXT_7_net);
    AND2_49 : AND2
      port map(A => WBINSYNC_1_net, B => INV_27_Y, Y => AND2_49_Y);
    AND2_23 : AND2
      port map(A => WBINSYNC_5_net, B => INV_70_Y, Y => AND2_23_Y);
    XOR2_40 : XOR2
      port map(A => MEMRADDR_5_net, B => GND_1_net, Y => 
        XOR2_40_Y);
    AND2_91 : AND2
      port map(A => XOR2_44_Y, B => XOR2_92_Y, Y => AND2_91_Y);
    AO21FTF_5 : AO21FTF
      port map(A => RDIFF_4_net, B => EMPTYVALUECONST_0_net, C => 
        RDIFF_3_net, Y => AO21FTF_5_Y);
    AO21_9 : AO21
      port map(A => AND2_67_Y, B => AO21_54_Y, C => AO21_53_Y, 
        Y => AO21_9_Y);
    DFFC_MEM_RADDR_8_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_11_Y, CLR => INV_6_Y, 
        Q => MEM_RADDR_8_net);
    AO21_22 : AO21
      port map(A => XOR2_14_Y, B => AO21_34_Y, C => AND2_40_Y, 
        Y => AO21_22_Y);
    INV_9 : INV
      port map(A => RESET, Y => INV_9_Y);
    AO21_10 : AO21
      port map(A => AND2_53_Y, B => AO21_59_Y, C => AO21_32_Y, 
        Y => AO21_10_Y);
    XNOR2_48 : XNOR2
      port map(A => WGRYSYNC_2_net, B => WGRYSYNC_1_net, Y => 
        XNOR2_48_Y);
    INV_77 : INV
      port map(A => RESET, Y => INV_77_Y);
    AND2_69 : AND2
      port map(A => AND2_73_Y, B => AND2_11_Y, Y => AND2_69_Y);
    XOR2_92 : XOR2
      port map(A => WBIN_3_net, B => GND_1_net, Y => XOR2_92_Y);
    DFFC_WGRYSYNC_1_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_8_Q, CLR => INV_1_Y, Q => 
        WGRYSYNC_1_net);
    MUX2H_11 : MUX2H
      port map(A => MEM_RADDR_8_net, B => XOR2_22_Y, S => 
        AND2FT_0_Y, Y => MUX2H_11_Y);
    XNOR2_27 : XNOR2
      port map(A => RDADDRGEN_CONST_0_net, B => MEMRADDR_3_net, 
        Y => XNOR2_27_Y);
    INV_51 : INV
      port map(A => RESET, Y => INV_51_Y);
    AND2_55 : AND2
      port map(A => RBIN_6_net, B => GND_1_net, Y => AND2_55_Y);
    NOR3FTT_6 : NOR3FTT
      port map(A => OR2FT_19_Y, B => AO21FTF_4_Y, C => 
        EMPTYVALUECONST_0_net, Y => NOR3FTT_6_Y);
    AND3_12 : AND3
      port map(A => XNOR2_25_Y, B => XNOR2_2_Y, C => XNOR2_21_Y, 
        Y => AND3_12_Y);
    NAND3FTT_4 : NAND3FTT
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_4_net, C => 
        OR2FT_11_Y, Y => NAND3FTT_4_Y);
    INV_66 : INV
      port map(A => RESET, Y => INV_66_Y);
    AO21_30 : AO21
      port map(A => XOR2_17_Y, B => AO21_3_Y, C => AND2_52_Y, 
        Y => AO21_30_Y);
    OR2FT_14 : OR2FT
      port map(A => AEVALCONST_1_net, B => RDIFF_5_net, Y => 
        OR2FT_14_Y);
    AND2_96 : AND2
      port map(A => MEMRADDR_3_net, B => GND_1_net, Y => 
        AND2_96_Y);
    AND3_8 : AND3
      port map(A => XNOR2_49_Y, B => XNOR2_10_Y, C => XNOR2_6_Y, 
        Y => AND3_8_Y);
    AO21_17 : AO21
      port map(A => AND2_74_Y, B => AO21_63_Y, C => AO21_47_Y, 
        Y => AO21_17_Y);
    MUX2H_15 : MUX2H
      port map(A => MEMWADDR_7_net, B => XOR2_72_Y, S => 
        AND2FT_2_Y, Y => MUX2H_15_Y);
    OR2FT_12 : OR2FT
      port map(A => WDIFF_5_net, B => AFVALCONST_1_net, Y => 
        OR2FT_12_Y);
    XOR2_71 : XOR2
      port map(A => WBINSYNC_7_net, B => INV_17_Y, Y => XOR2_71_Y);
    INV_41 : INV
      port map(A => AND3_4_Y, Y => INV_41_Y);
    XNOR2_28 : XNOR2
      port map(A => RDADDRGEN_CONST_0_net, B => MEMRADDR_6_net, 
        Y => XNOR2_28_Y);
    AND2_18 : AND2
      port map(A => MEMRADDR_5_net, B => GND_1_net, Y => 
        AND2_18_Y);
    INV_80 : INV
      port map(A => RESET, Y => INV_80_Y);
    XNOR2_65 : XNOR2
      port map(A => WRADDRGEN_CONST_0_net, B => MEMWADDR_4_net, 
        Y => XNOR2_65_Y);
    XOR2_96 : XOR2
      port map(A => XNOR2_32_Y, B => WGRYSYNC_0_net, Y => 
        XOR2_96_Y);
    AND2_78 : AND2
      port map(A => AND2_71_Y, B => XOR2_94_Y, Y => AND2_78_Y);
    AO21_7 : AO21
      port map(A => AND2_11_Y, B => AO21_20_Y, C => AO21_29_Y, 
        Y => AO21_7_Y);
    INV_33 : INV
      port map(A => RESET, Y => INV_33_Y);
    DFFC_0 : DFFC
      port map(CLK => RCLOCK, D => WGRY_4_net, CLR => INV_39_Y, 
        Q => DFFC_0_Q);
    XNOR2_4 : XNOR2
      port map(A => WRADDRGEN_CONST_0_net, B => MEMWADDR_0_net, 
        Y => XNOR2_4_Y);
    AND2_40 : AND2
      port map(A => MEMRADDR_7_net, B => GND_1_net, Y => 
        AND2_40_Y);
    DFFC_WBIN_0_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_0_net, CLR => INV_90_Y, 
        Q => WBIN_0_net);
    INV_85 : INV
      port map(A => RESET, Y => INV_85_Y);
    AO21_44 : AO21
      port map(A => XOR2_74_Y, B => AND2_8_Y, C => AND2_62_Y, 
        Y => AO21_44_Y);
    DFFC_12 : DFFC
      port map(CLK => WCLOCK, D => RGRY_5_net, CLR => INV_13_Y, 
        Q => DFFC_12_Q);
    AO21_50 : AO21
      port map(A => XOR2_20_Y, B => AO21_20_Y, C => AND2_38_Y, 
        Y => AO21_50_Y);
    XOR2_127 : XOR2
      port map(A => WBINSYNC_5_net, B => INV_70_Y, Y => 
        XOR2_127_Y);
    NOR3FTT_3 : NOR3FTT
      port map(A => OR2FT_17_Y, B => AO21FTF_11_Y, C => 
        AEVALCONST_0_net, Y => NOR3FTT_3_Y);
    XNOR2_36 : XNOR2
      port map(A => RDIFF_7_net, B => AEVALCONST_0_net, Y => 
        XNOR2_36_Y);
    XOR2_24 : XOR2
      port map(A => XOR2_98_Y, B => AND2_26_Y, Y => XOR2_24_Y);
    AO21_37 : AO21
      port map(A => AND2_72_Y, B => AO21_47_Y, C => AO21_18_Y, 
        Y => AO21_37_Y);
    XOR2_34 : XOR2
      port map(A => WBIN_4_net, B => GND_1_net, Y => XOR2_34_Y);
    AND2_32 : AND2
      port map(A => WBINNXT_3_net, B => INV_105_Y, Y => AND2_32_Y);
    AND2_60 : AND2
      port map(A => WBINNXT_4_net, B => INV_64_Y, Y => AND2_60_Y);
    AOI21_1 : AOI21
      port map(A => AND3_14_Y, B => AO21_45_Y, C => NAND3FTT_5_Y, 
        Y => AOI21_1_Y);
    XNOR2_55 : XNOR2
      port map(A => WDIFF_4_net, B => AFVALCONST_0_net, Y => 
        XNOR2_55_Y);
    DFFC_RGRY_4_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_120_Y, CLR => INV_44_Y, 
        Q => RGRY_4_net);
    XOR2_115 : XOR2
      port map(A => WBINNXT_1_net, B => INV_23_Y, Y => XOR2_115_Y);
    XOR2_43 : XOR2
      port map(A => XNOR2_42_Y, B => WGRYSYNC_3_net, Y => 
        XOR2_43_Y);
    DFFC_MEMRADDR_1_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_17_Y, CLR => INV_112_Y, 
        Q => MEMRADDR_1_net);
    NAND3FTT_12 : NAND3FTT
      port map(A => WDIFF_1_net, B => AFVALCONST_1_net, C => 
        OR2FT_2_Y, Y => NAND3FTT_12_Y);
    MUX2H_16 : MUX2H
      port map(A => MEMWADDR_4_net, B => XOR2_41_Y, S => 
        AND2FT_2_Y, Y => MUX2H_16_Y);
    XOR2_RBINNXT_5_inst : XOR2
      port map(A => XOR2_103_Y, B => AO21_50_Y, Y => 
        RBINNXT_5_net);
    XOR2_61 : XOR2
      port map(A => RGRYSYNC_8_net, B => RGRYSYNC_7_net, Y => 
        XOR2_61_Y);
    AND2_85 : AND2
      port map(A => INV_50_Y, B => RESET, Y => AND2_85_Y);
    XNOR2_2 : XNOR2
      port map(A => FULLCONSTVALUE_5_net, B => WDIFF_7_net, Y => 
        XNOR2_2_Y);
    XOR2_49 : XOR2
      port map(A => WBINNXT_0_net, B => WBINNXT_1_net, Y => 
        XOR2_49_Y);
    XOR2_WDIFF_7_inst : XOR2
      port map(A => XOR2_64_Y, B => AO21_17_Y, Y => WDIFF_7_net);
    NOR3FTT_1 : NOR3FTT
      port map(A => OR2FT_14_Y, B => AO21FTF_8_Y, C => 
        AEVALCONST_0_net, Y => NOR3FTT_1_Y);
    AO21_57 : AO21
      port map(A => AND2_82_Y, B => AO21_26_Y, C => AO21_10_Y, 
        Y => AO21_57_Y);
    OR2FT_6 : OR2FT
      port map(A => WDIFF_5_net, B => FULLCONSTVALUE_5_net, Y => 
        OR2FT_6_Y);
    OR2FT_1 : OR2FT
      port map(A => RDIFF_5_net, B => EMPTYVALUECONST_0_net, Y => 
        OR2FT_1_Y);
    INV_111 : INV
      port map(A => RESET, Y => INV_111_Y);
    WEBUBBLE : INV
      port map(A => WE, Y => WEP);
    INV_14 : INV
      port map(A => AND2_85_Y, Y => INV_14_Y);
    AND2_53 : AND2
      port map(A => XOR2_12_Y, B => XOR2_89_Y, Y => AND2_53_Y);
    AO21_48 : AO21
      port map(A => XOR2_32_Y, B => AO21_0_Y, C => AND2_50_Y, 
        Y => AO21_48_Y);
    OR2FT_13 : OR2FT
      port map(A => FULLCONSTVALUE_5_net, B => WDIFF_5_net, Y => 
        OR2FT_13_Y);
    AND2_99 : AND2
      port map(A => XOR2_115_Y, B => XOR2_86_Y, Y => AND2_99_Y);
    XOR2_47 : XOR2
      port map(A => XNOR2_63_Y, B => RGRYSYNC_3_net, Y => 
        XOR2_47_Y);
    INV_57 : INV
      port map(A => NOR2FT_1_Y, Y => INV_57_Y);
    INV_89 : INV
      port map(A => RESET, Y => INV_89_Y);
    XOR2_118 : XOR2
      port map(A => MEMWADDR_0_net, B => VCC, Y => XOR2_118_Y);
    XOR2_9 : XOR2
      port map(A => WBINSYNC_1_net, B => INV_27_Y, Y => XOR2_9_Y);
    NAND3FTT_7 : NAND3FTT
      port map(A => WDIFF_7_net, B => AFVALCONST_0_net, C => 
        OR2FT_20_Y, Y => NAND3FTT_7_Y);
    XOR2_25 : XOR2
      port map(A => MEM_RADDR_8_net, B => GND_1_net, Y => 
        XOR2_25_Y);
    NAND3FTT_21 : NAND3FTT
      port map(A => NOR3FTT_3_Y, B => OR2FT_4_Y, C => 
        NAND3FTT_0_Y, Y => NAND3FTT_21_Y);
    DFFC_WGRYSYNC_8_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_5_Q, CLR => INV_59_Y, 
        Q => WGRYSYNC_8_net);
    INV_12 : INV
      port map(A => RBINSYNC_2_net, Y => INV_12_Y);
    NOR3FTT_4 : NOR3FTT
      port map(A => OR2FT_20_Y, B => AO21FTF_2_Y, C => 
        WDIFF_6_net, Y => NOR3FTT_4_Y);
    XOR2_35 : XOR2
      port map(A => XOR2_114_Y, B => AO21_15_Y, Y => XOR2_35_Y);
    AND3_0 : AND3
      port map(A => AND3_8_Y, B => AND3_11_Y, C => AND3_9_Y, Y => 
        AND3_0_Y);
    XNOR2_WBINSYNC_5_inst : XNOR2
      port map(A => WGRYSYNC_5_net, B => XOR2_128_Y, Y => 
        WBINSYNC_5_net);
    XOR2_RBINNXT_2_inst : XOR2
      port map(A => XOR2_5_Y, B => AO21_11_Y, Y => RBINNXT_2_net);
    DFFC_MEMRADDR_6_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_5_Y, CLR => INV_18_Y, 
        Q => MEMRADDR_6_net);
    INV_47 : INV
      port map(A => RESET, Y => INV_47_Y);
    INV_93 : INV
      port map(A => RESET, Y => INV_93_Y);
    AND2_17 : AND2
      port map(A => AND2_83_Y, B => AND2_48_Y, Y => AND2_17_Y);
    AO21FTF_1 : AO21FTF
      port map(A => FULLCONSTVALUE_5_net, B => WDIFF_7_net, C => 
        FULLCONSTVALUE_0_net, Y => AO21FTF_1_Y);
    DFFC_7 : DFFC
      port map(CLK => WCLOCK, D => RGRY_7_net, CLR => INV_56_Y, 
        Q => DFFC_7_Q);
    XNOR2_66 : XNOR2
      port map(A => RDIFF_8_net, B => EMPTYVALUECONST_0_net, Y => 
        XNOR2_66_Y);
    AND2_77 : AND2
      port map(A => AND2_17_Y, B => AND2_19_Y, Y => AND2_77_Y);
    AND3_7 : AND3
      port map(A => XNOR2_28_Y, B => XNOR2_9_Y, C => XNOR2_51_Y, 
        Y => AND3_7_Y);
    AND2_38 : AND2
      port map(A => RBIN_4_net, B => GND_1_net, Y => AND2_38_Y);
    NAND3FTT_20 : NAND3FTT
      port map(A => NOR3FTT_6_Y, B => OR2FT_5_Y, C => 
        NAND3FTT_23_Y, Y => NAND3FTT_20_Y);
    INV_61 : INV
      port map(A => RESET, Y => INV_61_Y);
    OR3_0 : OR3
      port map(A => AND2_31_Y, B => AND2_57_Y, C => AND2_93_Y, 
        Y => OR3_0_Y);
    DFFC_17 : DFFC
      port map(CLK => WCLOCK, D => RGRY_6_net, CLR => INV_45_Y, 
        Q => DFFC_17_Q);
    XOR2_72 : XOR2
      port map(A => XOR2_32_Y, B => AO21_0_Y, Y => XOR2_72_Y);
    DFFC_RBIN_1_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_1_net, CLR => 
        INV_113_Y, Q => RBIN_1_net);
    XOR2_WDIFF_5_inst : XOR2
      port map(A => XOR2_97_Y, B => AO21_63_Y, Y => WDIFF_5_net);
    MUX2H_10 : MUX2H
      port map(A => MEMRADDR_2_net, B => XOR2_23_Y, S => 
        AND2FT_0_Y, Y => MUX2H_10_Y);
    DFFC_RGRY_0_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_145_Y, CLR => INV_53_Y, 
        Q => RGRY_0_net);
    AND2_83 : AND2
      port map(A => XOR2_9_Y, B => XOR2_125_Y, Y => AND2_83_Y);
    NAND3FTT_15 : NAND3FTT
      port map(A => WDIFF_1_net, B => FULLCONSTVALUE_0_net, C => 
        OR2FT_21_Y, Y => NAND3FTT_15_Y);
    XNOR2_56 : XNOR2
      port map(A => WRADDRGEN_CONST_0_net, B => MEMWADDR_1_net, 
        Y => XNOR2_56_Y);
    AND2_90 : AND2
      port map(A => AND2_73_Y, B => AND2_3_Y, Y => AND2_90_Y);
    AND2_11 : AND2
      port map(A => XOR2_20_Y, B => XOR2_113_Y, Y => AND2_11_Y);
    XOR2_18 : XOR2
      port map(A => RBIN_7_net, B => GND_1_net, Y => XOR2_18_Y);
    INV_38 : INV
      port map(A => RESET, Y => INV_38_Y);
    OR2FT_16 : OR2FT
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_8_net, Y => 
        OR2FT_16_Y);
    AND2_71 : AND2
      port map(A => AND2_37_Y, B => AND2_6_Y, Y => AND2_71_Y);
    XOR2_20 : XOR2
      port map(A => RBIN_4_net, B => GND_1_net, Y => XOR2_20_Y);
    NOR2FT_1 : NOR2FT
      port map(A => RBINSYNC_0_net, B => WBINNXT_0_net, Y => 
        NOR2FT_1_Y);
    XOR2_76 : XOR2
      port map(A => WBINNXT_5_net, B => INV_62_Y, Y => XOR2_76_Y);
    XOR2_30 : XOR2
      port map(A => WBIN_0_net, B => MEMORYWE, Y => XOR2_30_Y);
    XOR2_RDIFF_7_inst : XOR2
      port map(A => XOR2_71_Y, B => AO21_16_Y, Y => RDIFF_7_net);
    XOR2_88 : XOR2
      port map(A => XNOR2_38_Y, B => WGRYSYNC_3_net, Y => 
        XOR2_88_Y);
    XOR2_125 : XOR2
      port map(A => WBINSYNC_2_net, B => INV_20_Y, Y => 
        XOR2_125_Y);
    INV_8 : INV
      port map(A => RBINSYNC_7_net, Y => INV_8_Y);
    XOR2_62 : XOR2
      port map(A => WBIN_1_net, B => GND_1_net, Y => XOR2_62_Y);
    AND2_4 : AND2
      port map(A => MEMRADDR_6_net, B => GND_1_net, Y => AND2_4_Y);
    AO21FTF_11 : AO21FTF
      port map(A => RDIFF_1_net, B => AEVALCONST_1_net, C => 
        RDIFF_0_net, Y => AO21FTF_11_Y);
    DFFC_WGRYSYNC_3_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_11_Q, CLR => INV_78_Y, 
        Q => WGRYSYNC_3_net);
    AO21FTF_7 : AO21FTF
      port map(A => RDIFF_7_net, B => EMPTYVALUECONST_0_net, C => 
        RDIFF_6_net, Y => AO21FTF_7_Y);
    DFFC_WGRYSYNC_2_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_10_Q, CLR => INV_76_Y, 
        Q => WGRYSYNC_2_net);
    AND2_0 : AND2
      port map(A => RBIN_7_net, B => GND_1_net, Y => AND2_0_Y);
    XNOR2_40 : XNOR2
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_3_net, Y => 
        XNOR2_40_Y);
    INV_36 : INV
      port map(A => RESET, Y => INV_36_Y);
    NAND3FTT_0 : NAND3FTT
      port map(A => AEVALCONST_1_net, B => RDIFF_1_net, C => 
        OR2FT_17_Y, Y => NAND3FTT_0_Y);
    DFFC_10 : DFFC
      port map(CLK => RCLOCK, D => WGRY_2_net, CLR => INV_99_Y, 
        Q => DFFC_10_Q);
    XNOR2_33 : XNOR2
      port map(A => WGRYSYNC_8_net, B => WGRYSYNC_7_net, Y => 
        XNOR2_33_Y);
    AND2_16 : AND2
      port map(A => AND2_99_Y, B => XOR2_142_Y, Y => AND2_16_Y);
    AO21_41 : AO21
      port map(A => XOR2_125_Y, B => OR3_1_Y, C => AND2_43_Y, 
        Y => AO21_41_Y);
    AND2_76 : AND2
      port map(A => MEMWADDR_5_net, B => GND_1_net, Y => 
        AND2_76_Y);
    AND2_6 : AND2
      port map(A => XOR2_15_Y, B => XOR2_82_Y, Y => AND2_6_Y);
    XNOR2_0 : XNOR2
      port map(A => WDIFF_3_net, B => AFVALCONST_1_net, Y => 
        XNOR2_0_Y);
    AO21_20 : AO21
      port map(A => AND2_21_Y, B => AO21_11_Y, C => AO21_24_Y, 
        Y => AO21_20_Y);
    XOR2_RBINNXT_8_inst : XOR2
      port map(A => XOR2_141_Y, B => AO21_3_Y, Y => RBINNXT_8_net);
    XNOR2_41 : XNOR2
      port map(A => AFVALCONST_1_net, B => WDIFF_6_net, Y => 
        XNOR2_41_Y);
    INV_107 : INV
      port map(A => RESET, Y => INV_107_Y);
    AND3_11 : AND3
      port map(A => XNOR2_4_Y, B => XNOR2_56_Y, C => XNOR2_54_Y, 
        Y => AND3_11_Y);
    XNOR2_15 : XNOR2
      port map(A => XOR2_31_Y, B => XOR2_66_Y, Y => XNOR2_15_Y);
    XOR2_128 : XOR2
      port map(A => XNOR2_53_Y, B => WGRYSYNC_6_net, Y => 
        XOR2_128_Y);
    XOR2_66 : XOR2
      port map(A => XNOR2_11_Y, B => RGRYSYNC_3_net, Y => 
        XOR2_66_Y);
    DFFC_MEMRADDR_3_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_7_Y, CLR => INV_19_Y, 
        Q => MEMRADDR_3_net);
    AND2_37 : AND2
      port map(A => AND2_24_Y, B => AND2_91_Y, Y => AND2_37_Y);
    INV_67 : INV
      port map(A => RBINSYNC_6_net, Y => INV_67_Y);
    INV_10 : INV
      port map(A => RESET, Y => INV_10_Y);
    XNOR2_20 : XNOR2
      port map(A => RGRYSYNC_2_net, B => RGRYSYNC_1_net, Y => 
        XNOR2_20_Y);
    INV_108 : INV
      port map(A => AND2_85_Y, Y => INV_108_Y);
    XOR2_41 : XOR2
      port map(A => XOR2_123_Y, B => AO21_55_Y, Y => XOR2_41_Y);
    XOR2_7 : XOR2
      port map(A => WBIN_2_net, B => GND_1_net, Y => XOR2_7_Y);
    REBUBBLE : INV
      port map(A => RE, Y => REP);
    DFFC_RBIN_3_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_3_net, CLR => INV_35_Y, 
        Q => RBIN_3_net);
    INV_15 : INV
      port map(A => RESET, Y => INV_15_Y);
    XOR2_54 : XOR2
      port map(A => WBINNXT_2_net, B => WBINNXT_3_net, Y => 
        XOR2_54_Y);
    AO21_27 : AO21
      port map(A => AND3_3_Y, B => NAND3FTT_13_Y, C => 
        NAND3FTT_16_Y, Y => AO21_27_Y);
    AND3_9 : AND3
      port map(A => XNOR2_13_Y, B => XNOR2_65_Y, C => XNOR2_39_Y, 
        Y => AND3_9_Y);
    INV_98 : INV
      port map(A => RESET, Y => INV_98_Y);
    XNOR2_21 : XNOR2
      port map(A => FULLCONSTVALUE_0_net, B => WDIFF_8_net, Y => 
        XNOR2_21_Y);
    AND2_44 : AND2
      port map(A => WBIN_3_net, B => GND_1_net, Y => AND2_44_Y);
    XOR2_141 : XOR2
      port map(A => RBIN_8_net, B => GND_1_net, Y => XOR2_141_Y);
    DFFC_WGRY_1_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_57_Y, CLR => INV_94_Y, 
        Q => WGRY_1_net);
    DFFC_WGRYSYNC_6_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_4_Q, CLR => INV_114_Y, 
        Q => WGRYSYNC_6_net);
    DFFC_DVLDI : DFFC
      port map(CLK => RCLOCK, D => AND2FT_1_Y, CLR => INV_11_Y, 
        Q => DVLDI);
    XOR2_RBINNXT_0_inst : XOR2
      port map(A => RBIN_0_net, B => MEMORYRE, Y => RBINNXT_0_net);
    DFFC_RGRYSYNC_7_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_7_Q, CLR => INV_82_Y, 
        Q => RGRYSYNC_7_net);
    XOR2_23 : XOR2
      port map(A => XOR2_26_Y, B => AO21_39_Y, Y => XOR2_23_Y);
    XOR2_33 : XOR2
      port map(A => XNOR2_19_Y, B => WGRYSYNC_6_net, Y => 
        XOR2_33_Y);
    AND2_31 : AND2
      port map(A => WBINNXT_1_net, B => INV_23_Y, Y => AND2_31_Y);
    XNOR2_WDIFF_1_inst : XNOR2
      port map(A => XOR2_90_Y, B => NOR2FT_1_Y, Y => WDIFF_1_net);
    XNOR2_WBINSYNC_1_inst : XNOR2
      port map(A => XOR2_68_Y, B => XOR2_55_Y, Y => 
        WBINSYNC_1_net);
    DFFC_RGRYSYNC_0_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_1_Q, CLR => INV_52_Y, 
        Q => RGRYSYNC_0_net);
    AO21_1 : AO21
      port map(A => XOR2_44_Y, B => AO21_44_Y, C => AND2_34_Y, 
        Y => AO21_1_Y);
    XOR2_29 : XOR2
      port map(A => WBINSYNC_3_net, B => INV_109_Y, Y => 
        XOR2_29_Y);
    AO21_45 : AO21
      port map(A => AND3_1_Y, B => NAND3FTT_21_Y, C => 
        NAND3FTT_19_Y, Y => AO21_45_Y);
    AND2_64 : AND2
      port map(A => AND2_17_Y, B => AND2_82_Y, Y => AND2_64_Y);
    AO21_46 : AO21
      port map(A => XOR2_15_Y, B => AO21_54_Y, C => AND2_89_Y, 
        Y => AO21_46_Y);
    XOR2_39 : XOR2
      port map(A => RBINNXT_7_net, B => RBINNXT_8_net, Y => 
        XOR2_39_Y);
    OR2FT_0 : OR2FT
      port map(A => AFVALCONST_0_net, B => WDIFF_8_net, Y => 
        OR2FT_0_Y);
    XNOR2_63 : XNOR2
      port map(A => RGRYSYNC_5_net, B => RGRYSYNC_4_net, Y => 
        XNOR2_63_Y);
    AND2_19 : AND2
      port map(A => XOR2_105_Y, B => XOR2_58_Y, Y => AND2_19_Y);
    DFFC_RBIN_8_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_8_net, CLR => INV_69_Y, 
        Q => RBIN_8_net);
    AND2_79 : AND2
      port map(A => WBINSYNC_1_net, B => INV_40_Y, Y => AND2_79_Y);
    INV_96 : INV
      port map(A => RBINSYNC_8_net, Y => INV_96_Y);
    DFFC_WGRY_6_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_130_Y, CLR => INV_10_Y, 
        Q => WGRY_6_net);
    XOR2_27 : XOR2
      port map(A => WBINNXT_6_net, B => INV_67_Y, Y => XOR2_27_Y);
    AO21_19 : AO21
      port map(A => XOR2_98_Y, B => AND2_26_Y, C => AND2_94_Y, 
        Y => AO21_19_Y);
    XOR2_6 : XOR2
      port map(A => XOR2_10_Y, B => AO21_21_Y, Y => XOR2_6_Y);
    DFFC_2 : DFFC
      port map(CLK => WCLOCK, D => RGRY_4_net, CLR => INV_49_Y, 
        Q => DFFC_2_Q);
    XOR2_37 : XOR2
      port map(A => XOR2_116_Y, B => AO21_2_Y, Y => XOR2_37_Y);
    XNOR2_WBINSYNC_3_inst : XNOR2
      port map(A => XOR2_106_Y, B => XOR2_88_Y, Y => 
        WBINSYNC_3_net);
    NAND3FTT_16 : NAND3FTT
      port map(A => NOR3FTT_8_Y, B => OR2FT_13_Y, C => 
        NAND3FTT_2_Y, Y => NAND3FTT_16_Y);
    AO21_3 : AO21
      port map(A => AND2_3_Y, B => AO21_20_Y, C => AO21_43_Y, 
        Y => AO21_3_Y);
    XOR2_143 : XOR2
      port map(A => XNOR2_1_Y, B => RGRYSYNC_0_net, Y => 
        XOR2_143_Y);
    INV_103 : INV
      port map(A => RBINNXT_8_net, Y => INV_103_Y);
    XOR2_55 : XOR2
      port map(A => XNOR2_48_Y, B => XOR2_101_Y, Y => XOR2_55_Y);
    DFFC_MEMRADDR_5_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_1_Y, CLR => INV_86_Y, 
        Q => MEMRADDR_5_net);
    INV_19 : INV
      port map(A => AND2_42_Y, Y => INV_19_Y);
    AO21_61 : AO21
      port map(A => XOR2_142_Y, B => AO21_8_Y, C => AND2_32_Y, 
        Y => AO21_61_Y);
    INV_106 : INV
      port map(A => AND2_85_Y, Y => INV_106_Y);
    XOR2_109 : XOR2
      port map(A => RBIN_6_net, B => GND_1_net, Y => XOR2_109_Y);
    AND2_36 : AND2
      port map(A => AND2_73_Y, B => XOR2_20_Y, Y => AND2_36_Y);
    DFFC_MEMWADDR_0_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_8_Y, CLR => INV_106_Y, 
        Q => MEMWADDR_0_net);
    AND2_9 : AND2
      port map(A => WBINSYNC_7_net, B => INV_17_Y, Y => AND2_9_Y);
    AO21_13 : AO21
      port map(A => XOR2_108_Y, B => AO21_36_Y, C => AND2_68_Y, 
        Y => AO21_13_Y);
    NAND3FTT_11 : NAND3FTT
      port map(A => NOR3FTT_0_Y, B => OR2FT_1_Y, C => 
        NAND3FTT_4_Y, Y => NAND3FTT_11_Y);
    XNOR2_16 : XNOR2
      port map(A => WDIFF_4_net, B => FULLCONSTVALUE_0_net, Y => 
        XNOR2_16_Y);
    XNOR2_53 : XNOR2
      port map(A => WGRYSYNC_8_net, B => WGRYSYNC_7_net, Y => 
        XNOR2_53_Y);
    NAND3FTT_3 : NAND3FTT
      port map(A => NOR3FTT_7_Y, B => OR2FT_18_Y, C => 
        NAND3FTT_1_Y, Y => NAND3FTT_3_Y);
    XNOR2_32 : XNOR2
      port map(A => WGRYSYNC_2_net, B => WGRYSYNC_1_net, Y => 
        XNOR2_32_Y);
    INV_100 : INV
      port map(A => RESET, Y => INV_100_Y);
    INV_83 : INV
      port map(A => AND2_85_Y, Y => INV_83_Y);
    INV_31 : INV
      port map(A => RESET, Y => INV_31_Y);
    AO21_5 : AO21
      port map(A => XOR2_117_Y, B => AO21_17_Y, C => AND2_87_Y, 
        Y => AO21_5_Y);
    AO21_39 : AO21
      port map(A => XOR2_59_Y, B => AND2_61_Y, C => AND2_22_Y, 
        Y => AO21_39_Y);
    INV_24 : INV
      port map(A => RESET, Y => INV_24_Y);
    OR2FT_22 : OR2FT
      port map(A => AFVALCONST_1_net, B => WDIFF_2_net, Y => 
        OR2FT_22_Y);
    XNOR2_49 : XNOR2
      port map(A => WRADDRGEN_CONST_0_net, B => MEMWADDR_6_net, 
        Y => XNOR2_49_Y);
    AND2_101 : AND2
      port map(A => XOR2_94_Y, B => XOR2_70_Y, Y => AND2_101_Y);
    XNOR2_RBINSYNC_5_inst : XNOR2
      port map(A => RGRYSYNC_5_net, B => XOR2_126_Y, Y => 
        RBINSYNC_5_net);
    NAND3FTT_10 : NAND3FTT
      port map(A => WDIFF_4_net, B => AFVALCONST_0_net, C => 
        OR2FT_12_Y, Y => NAND3FTT_10_Y);
    XOR2_RDIFF_4_inst : XOR2
      port map(A => XOR2_21_Y, B => AO21_33_Y, Y => RDIFF_4_net);
    AO21_33 : AO21
      port map(A => XOR2_29_Y, B => AO21_41_Y, C => AND2_51_Y, 
        Y => AO21_33_Y);
    AND2_10 : AND2
      port map(A => AND2_56_Y, B => XOR2_42_Y, Y => AND2_10_Y);
    AND2_70 : AND2
      port map(A => AND2_37_Y, B => XOR2_15_Y, Y => AND2_70_Y);
    XOR2_WBINNXT_7_inst : XOR2
      port map(A => XOR2_104_Y, B => AO21_23_Y, Y => 
        WBINNXT_7_net);
    AO21_59 : AO21
      port map(A => XOR2_58_Y, B => AND2_23_Y, C => AND2_47_Y, 
        Y => AO21_59_Y);
    BFR_WBINSYNC_8_inst : BFR
      port map(A => WGRYSYNC_8_net, Y => WBINSYNC_8_net);
    XOR2_RBINNXT_1_inst : XOR2
      port map(A => XOR2_93_Y, B => AND2_41_Y, Y => RBINNXT_1_net);
    XNOR2_7 : XNOR2
      port map(A => WDIFF_5_net, B => FULLCONSTVALUE_5_net, Y => 
        XNOR2_7_Y);
    INV_104 : INV
      port map(A => AND2_85_Y, Y => INV_104_Y);
    INV_22 : INV
      port map(A => AND2_42_Y, Y => INV_22_Y);
    XOR2_42 : XOR2
      port map(A => RBIN_2_net, B => GND_1_net, Y => XOR2_42_Y);
    XOR2_50 : XOR2
      port map(A => RBINNXT_1_net, B => RBINNXT_2_net, Y => 
        XOR2_50_Y);
    XNOR2_29 : XNOR2
      port map(A => RGRYSYNC_2_net, B => XOR2_56_Y, Y => 
        XNOR2_29_Y);
    AO21_53 : AO21
      port map(A => AND2_101_Y, B => AO21_42_Y, C => AO21_31_Y, 
        Y => AO21_53_Y);
    INV_115 : INV
      port map(A => RESET, Y => INV_115_Y);
    XOR2_0 : XOR2
      port map(A => XNOR2_31_Y, B => RGRYSYNC_6_net, Y => 
        XOR2_0_Y);
    XOR2_101 : XOR2
      port map(A => XNOR2_60_Y, B => WGRYSYNC_6_net, Y => 
        XOR2_101_Y);
    AND2_94 : AND2
      port map(A => MEMWADDR_1_net, B => GND_1_net, Y => 
        AND2_94_Y);
    XOR2_RBINSYNC_2_inst : XOR2
      port map(A => XNOR2_29_Y, B => XOR2_47_Y, Y => 
        RBINSYNC_2_net);
    AND2_22 : AND2
      port map(A => MEMRADDR_1_net, B => GND_1_net, Y => 
        AND2_22_Y);
    DFFC_RBIN_5_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_5_net, CLR => INV_26_Y, 
        Q => RBIN_5_net);
    AND2_39 : AND2
      port map(A => AND2_24_Y, B => XOR2_44_Y, Y => AND2_39_Y);
    OR2FT_10 : OR2FT
      port map(A => RDIFF_8_net, B => EMPTYVALUECONST_0_net, Y => 
        OR2FT_10_Y);
    OR2FT_2 : OR2FT
      port map(A => WDIFF_2_net, B => AFVALCONST_1_net, Y => 
        OR2FT_2_Y);
    XOR2_46 : XOR2
      port map(A => WBINNXT_2_net, B => INV_12_Y, Y => XOR2_46_Y);
    INV_1 : INV
      port map(A => RESET, Y => INV_1_Y);
    OR2FT_23 : OR2FT
      port map(A => WDIFF_8_net, B => FULLCONSTVALUE_0_net, Y => 
        OR2FT_23_Y);
    XNOR2_62 : XNOR2
      port map(A => RDADDRGEN_CONST_0_net, B => MEMRADDR_1_net, 
        Y => XNOR2_62_Y);
    DFFC_WGRY_2_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_54_Y, CLR => INV_88_Y, 
        Q => WGRY_2_net);
    NAND3FTT_23 : NAND3FTT
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_1_net, C => 
        OR2FT_19_Y, Y => NAND3FTT_23_Y);
    XOR2_146 : XOR2
      port map(A => WGRYSYNC_8_net, B => WGRYSYNC_7_net, Y => 
        XOR2_146_Y);
    XOR2_139 : XOR2
      port map(A => RBINNXT_5_net, B => RBINNXT_6_net, Y => 
        XOR2_139_Y);
    AND3_10 : AND3
      port map(A => XNOR2_47_Y, B => XNOR2_17_Y, C => XNOR2_66_Y, 
        Y => AND3_10_Y);
    DFFC_RGRYSYNC_5_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_12_Q, CLR => INV_65_Y, 
        Q => RGRYSYNC_5_net);
    INV_91 : INV
      port map(A => RESET, Y => INV_91_Y);
    DFFC_RBIN_4_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_4_net, CLR => INV_71_Y, 
        Q => RBIN_4_net);
    DFFC_RBIN_6_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_6_net, CLR => INV_42_Y, 
        Q => RBIN_6_net);
    XOR2_103 : XOR2
      port map(A => RBIN_5_net, B => GND_1_net, Y => XOR2_103_Y);
    INV_74 : INV
      port map(A => RESET, Y => INV_74_Y);
    INV_37 : INV
      port map(A => RESET, Y => INV_37_Y);
    AND2_45 : AND2
      port map(A => RBIN_1_net, B => GND_1_net, Y => AND2_45_Y);
    DFFC_WGRY_5_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_65_Y, CLR => INV_93_Y, 
        Q => WGRY_5_net);
    XNOR2_52 : XNOR2
      port map(A => RGRYSYNC_8_net, B => RGRYSYNC_7_net, Y => 
        XNOR2_52_Y);
    XOR2_RDIFF_0_inst : XOR2
      port map(A => WBINSYNC_0_net, B => RBINNXT_0_net, Y => 
        RDIFF_0_net);
    DFFC_3 : DFFC
      port map(CLK => RCLOCK, D => WGRY_7_net, CLR => INV_25_Y, 
        Q => DFFC_3_Q);
    XOR2_RBINNXT_3_inst : XOR2
      port map(A => XOR2_129_Y, B => AO21_51_Y, Y => 
        RBINNXT_3_net);
    XOR2_21 : XOR2
      port map(A => WBINSYNC_4_net, B => INV_72_Y, Y => XOR2_21_Y);
    XOR2_31 : XOR2
      port map(A => XNOR2_18_Y, B => RGRYSYNC_6_net, Y => 
        XOR2_31_Y);
    AND2_65 : AND2
      port map(A => WBINNXT_8_net, B => INV_96_Y, Y => AND2_65_Y);
    XOR2_14 : XOR2
      port map(A => MEMRADDR_7_net, B => GND_1_net, Y => 
        XOR2_14_Y);
    INV_88 : INV
      port map(A => RESET, Y => INV_88_Y);
    AND2_30 : AND2
      port map(A => MEMRADDR_2_net, B => GND_1_net, Y => 
        AND2_30_Y);
    INV_72 : INV
      port map(A => RBINNXT_4_net, Y => INV_72_Y);
    DFFC_RBIN_2_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_2_net, CLR => INV_31_Y, 
        Q => RBIN_2_net);
    DFFC_RGRYSYNC_1_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_16_Q, CLR => INV_115_Y, 
        Q => RGRYSYNC_1_net);
    DFFC_RBIN_7_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_7_net, CLR => INV_98_Y, 
        Q => RBIN_7_net);
    AND2_28 : AND2
      port map(A => AND2_90_Y, B => XOR2_17_Y, Y => AND2_28_Y);
    OR2FT_5 : OR2FT
      port map(A => RDIFF_2_net, B => EMPTYVALUECONST_0_net, Y => 
        OR2FT_5_Y);
    XOR2_84 : XOR2
      port map(A => RBIN_6_net, B => GND_1_net, Y => XOR2_84_Y);
    XOR2_53 : XOR2
      port map(A => XOR2_59_Y, B => AND2_61_Y, Y => XOR2_53_Y);
    XOR2_4 : XOR2
      port map(A => WBINNXT_3_net, B => WBINNXT_4_net, Y => 
        XOR2_4_Y);
    XOR2_131 : XOR2
      port map(A => RBINNXT_6_net, B => RBINNXT_7_net, Y => 
        XOR2_131_Y);
    MEMREBUBBLE : INV
      port map(A => MEMORYRE, Y => MEMRE);
    DFFC_WGRY_8_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_2_Y, CLR => INV_55_Y, 
        Q => WGRY_8_net);
    XOR2_59 : XOR2
      port map(A => MEMRADDR_1_net, B => GND_1_net, Y => 
        XOR2_59_Y);
    XNOR2_13 : XNOR2
      port map(A => WRADDRGEN_CONST_0_net, B => MEMWADDR_3_net, 
        Y => XNOR2_13_Y);
    DFFC_MEMRADDR_2_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_10_Y, CLR => INV_60_Y, 
        Q => MEMRADDR_2_net);
    DFFC_16 : DFFC
      port map(CLK => WCLOCK, D => RGRY_1_net, CLR => INV_38_Y, 
        Q => DFFC_16_Q);
    NAND3FTT_6 : NAND3FTT
      port map(A => AEVALCONST_0_net, B => RDIFF_7_net, C => 
        OR2FT_7_Y, Y => NAND3FTT_6_Y);
    INV_20 : INV
      port map(A => RBINNXT_2_net, Y => INV_20_Y);
    XOR2_98 : XOR2
      port map(A => MEMWADDR_1_net, B => GND_1_net, Y => 
        XOR2_98_Y);
    OR2FT_17 : OR2FT
      port map(A => AEVALCONST_0_net, B => RDIFF_2_net, Y => 
        OR2FT_17_Y);
    AOI21_3 : AOI21
      port map(A => AND3_12_Y, B => AO21_27_Y, C => NAND3FTT_3_Y, 
        Y => AOI21_3_Y);
    OR2FT_19 : OR2FT
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_2_net, Y => 
        OR2FT_19_Y);
    AO21FTF_6 : AO21FTF
      port map(A => AFVALCONST_0_net, B => WDIFF_4_net, C => 
        AFVALCONST_1_net, Y => AO21FTF_6_Y);
    XOR2_142 : XOR2
      port map(A => WBINNXT_3_net, B => INV_105_Y, Y => 
        XOR2_142_Y);
    AND2_52 : AND2
      port map(A => RBIN_8_net, B => GND_1_net, Y => AND2_52_Y);
    XNOR2_RBINSYNC_1_inst : XNOR2
      port map(A => XOR2_87_Y, B => XOR2_79_Y, Y => 
        RBINSYNC_1_net);
    INV_86 : INV
      port map(A => AND2_42_Y, Y => INV_86_Y);
    DFFC_MEMWADDR_2_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_6_Y, CLR => INV_75_Y, 
        Q => MEMWADDR_2_net);
    XOR2_57 : XOR2
      port map(A => WBINNXT_1_net, B => WBINNXT_2_net, Y => 
        XOR2_57_Y);
    DFFC_WGRYSYNC_4_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_0_Q, CLR => INV_54_Y, 
        Q => WGRYSYNC_4_net);
    INV_25 : INV
      port map(A => RESET, Y => INV_25_Y);
    AO21_2 : AO21
      port map(A => XOR2_80_Y, B => AO21_19_Y, C => AND2_2_Y, 
        Y => AO21_2_Y);
    AND2_1 : AND2
      port map(A => RBIN_5_net, B => GND_1_net, Y => AND2_1_Y);
    AND2_7 : AND2
      port map(A => XOR2_84_Y, B => XOR2_67_Y, Y => AND2_7_Y);
    OR2FT_11 : OR2FT
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_5_net, Y => 
        OR2FT_11_Y);
    DFFC_MEMWADDR_1_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_14_Y, CLR => INV_108_Y, 
        Q => MEMWADDR_1_net);
    AND2_100 : AND2
      port map(A => AND2_77_Y, B => XOR2_12_Y, Y => AND2_100_Y);
    XOR2_15 : XOR2
      port map(A => WBIN_4_net, B => GND_1_net, Y => XOR2_15_Y);
    AND2_43 : AND2
      port map(A => WBINSYNC_2_net, B => INV_20_Y, Y => AND2_43_Y);
    INV_97 : INV
      port map(A => RESET, Y => INV_97_Y);
    AO21_14 : AO21
      port map(A => XOR2_92_Y, B => AND2_34_Y, C => AND2_44_Y, 
        Y => AO21_14_Y);
    XOR2_133 : XOR2
      port map(A => RBINNXT_2_net, B => RBINNXT_3_net, Y => 
        XOR2_133_Y);
    XOR2_85 : XOR2
      port map(A => WGRYSYNC_8_net, B => WGRYSYNC_7_net, Y => 
        XOR2_85_Y);
    XOR2_144 : XOR2
      port map(A => XOR2_111_Y, B => WGRYSYNC_6_net, Y => 
        XOR2_144_Y);
    XNOR2_RBINSYNC_3_inst : XNOR2
      port map(A => XOR2_36_Y, B => XOR2_132_Y, Y => 
        RBINSYNC_3_net);
    XOR2_106 : XOR2
      port map(A => XOR2_85_Y, B => WGRYSYNC_6_net, Y => 
        XOR2_106_Y);
    NOR3FTT_10 : NOR3FTT
      port map(A => OR2FT_16_Y, B => AO21FTF_7_Y, C => 
        EMPTYVALUECONST_0_net, Y => NOR3FTT_10_Y);
    AO21_29 : AO21
      port map(A => XOR2_113_Y, B => AND2_38_Y, C => AND2_1_Y, 
        Y => AO21_29_Y);
    AND3_4 : AND3
      port map(A => AND3_7_Y, B => AND3_15_Y, C => AND3_6_Y, Y => 
        AND3_4_Y);
    AND2_63 : AND2
      port map(A => AND2_74_Y, B => AND2_72_Y, Y => AND2_63_Y);
    INV_13 : INV
      port map(A => RESET, Y => INV_13_Y);
    XNOR2_8 : XNOR2
      port map(A => AEVALCONST_0_net, B => RDIFF_3_net, Y => 
        XNOR2_8_Y);
    INV_54 : INV
      port map(A => RESET, Y => INV_54_Y);
    AO21_23 : AO21
      port map(A => XOR2_94_Y, B => AO21_40_Y, C => AND2_97_Y, 
        Y => AO21_23_Y);
    XOR2_RBINSYNC_6_inst : XOR2
      port map(A => XOR2_95_Y, B => RGRYSYNC_6_net, Y => 
        RBINSYNC_6_net);
    AO21_34 : AO21
      port map(A => XOR2_10_Y, B => AO21_21_Y, C => AND2_4_Y, 
        Y => AO21_34_Y);
    AND2_95 : AND2
      port map(A => AND2_17_Y, B => XOR2_105_Y, Y => AND2_95_Y);
    XNOR2_34 : XNOR2
      port map(A => RDADDRGEN_CONST_0_net, B => MEMRADDR_2_net, 
        Y => XNOR2_34_Y);
    XNOR2_RDIFF_1_inst : XNOR2
      port map(A => XOR2_136_Y, B => NOR2FT_0_Y, Y => RDIFF_1_net);
    AND3_1 : AND3
      port map(A => XNOR2_8_Y, B => XNOR2_61_Y, C => XNOR2_50_Y, 
        Y => AND3_1_Y);
    XOR2_22 : XOR2
      port map(A => XOR2_25_Y, B => AO21_22_Y, Y => XOR2_22_Y);
    AND2_27 : AND2
      port map(A => WBIN_8_net, B => GND_1_net, Y => AND2_27_Y);
    XOR2_32 : XOR2
      port map(A => MEMWADDR_7_net, B => GND_1_net, Y => 
        XOR2_32_Y);
    INV_29 : INV
      port map(A => RESET, Y => INV_29_Y);
    AO21_18 : AO21
      port map(A => XOR2_69_Y, B => AND2_87_Y, C => AND2_65_Y, 
        Y => AO21_18_Y);
    INV_44 : INV
      port map(A => RESET, Y => INV_44_Y);
    XOR2_WBINNXT_2_inst : XOR2
      port map(A => XOR2_7_Y, B => AO21_44_Y, Y => WBINNXT_2_net);
    AO21_42 : AO21
      port map(A => XOR2_82_Y, B => AND2_89_Y, C => AND2_66_Y, 
        Y => AO21_42_Y);
    MUX2H_7 : MUX2H
      port map(A => MEMRADDR_3_net, B => XOR2_147_Y, S => 
        AND2FT_0_Y, Y => MUX2H_7_Y);
    AND2_14 : AND2
      port map(A => AND2_25_Y, B => XOR2_76_Y, Y => AND2_14_Y);
    INV_52 : INV
      port map(A => RESET, Y => INV_52_Y);
    AND2_82 : AND2
      port map(A => AND2_19_Y, B => AND2_53_Y, Y => AND2_82_Y);
    AND2_74 : AND2
      port map(A => XOR2_76_Y, B => XOR2_27_Y, Y => AND2_74_Y);
    AND2_58 : AND2
      port map(A => AND2_25_Y, B => AND2_63_Y, Y => AND2_58_Y);
    XOR2_10 : XOR2
      port map(A => MEMRADDR_6_net, B => GND_1_net, Y => 
        XOR2_10_Y);
    DFFC_RGRYSYNC_8_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_14_Q, CLR => INV_32_Y, 
        Q => RGRYSYNC_8_net);
    XNOR2_9 : XNOR2
      port map(A => RDADDRGEN_CONST_5_net, B => MEMRADDR_7_net, 
        Y => XNOR2_9_Y);
    AO21_54 : AO21
      port map(A => AND2_91_Y, B => AO21_44_Y, C => AO21_14_Y, 
        Y => AO21_54_Y);
    INV_70 : INV
      port map(A => RBINNXT_5_net, Y => INV_70_Y);
    XOR2_119 : XOR2
      port map(A => WBIN_8_net, B => GND_1_net, Y => XOR2_119_Y);
    XOR2_80 : XOR2
      port map(A => MEMWADDR_2_net, B => GND_1_net, Y => 
        XOR2_80_Y);
    DFFC_MEMRADDR_7_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_0_Y, CLR => INV_22_Y, 
        Q => MEMRADDR_7_net);
    INV_42 : INV
      port map(A => RESET, Y => INV_42_Y);
    XNOR2_12 : XNOR2
      port map(A => RGRYSYNC_5_net, B => RGRYSYNC_4_net, Y => 
        XNOR2_12_Y);
    XOR2_26 : XOR2
      port map(A => MEMRADDR_2_net, B => GND_1_net, Y => 
        XOR2_26_Y);
    AO21_38 : AO21
      port map(A => XOR2_12_Y, B => AO21_16_Y, C => AND2_9_Y, 
        Y => AO21_38_Y);
    XNOR2_45 : XNOR2
      port map(A => WGRYSYNC_5_net, B => WGRYSYNC_4_net, Y => 
        XNOR2_45_Y);
    XOR2_36 : XOR2
      port map(A => XOR2_61_Y, B => RGRYSYNC_6_net, Y => 
        XOR2_36_Y);
    INV_75 : INV
      port map(A => AND2_85_Y, Y => INV_75_Y);
    OR2FT_7 : OR2FT
      port map(A => AEVALCONST_0_net, B => RDIFF_8_net, Y => 
        OR2FT_7_Y);
    MUX2H_1 : MUX2H
      port map(A => MEMRADDR_5_net, B => XOR2_38_Y, S => 
        AND2FT_0_Y, Y => MUX2H_1_Y);
    AND2_21 : AND2
      port map(A => XOR2_42_Y, B => XOR2_75_Y, Y => AND2_21_Y);
    XNOR2_37 : XNOR2
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_4_net, Y => 
        XNOR2_37_Y);
    MUX2H_5 : MUX2H
      port map(A => MEMRADDR_6_net, B => XOR2_6_Y, S => 
        AND2FT_0_Y, Y => MUX2H_5_Y);
    AND2_3 : AND2
      port map(A => AND2_11_Y, B => AND2_7_Y, Y => AND2_3_Y);
    XOR2_WBINSYNC_2_inst : XOR2
      port map(A => XNOR2_64_Y, B => XOR2_13_Y, Y => 
        WBINSYNC_2_net);
    NAND3FTT_13 : NAND3FTT
      port map(A => NOR3FTT_11_Y, B => OR2FT_15_Y, C => 
        NAND3FTT_15_Y, Y => NAND3FTT_13_Y);
    MUX2H_17 : MUX2H
      port map(A => MEMRADDR_1_net, B => XOR2_53_Y, S => 
        AND2FT_0_Y, Y => MUX2H_17_Y);
    XOR2_102 : XOR2
      port map(A => WBINSYNC_4_net, B => INV_72_Y, Y => 
        XOR2_102_Y);
    INV_102 : INV
      port map(A => RESET, Y => INV_102_Y);
    AO21_58 : AO21
      port map(A => XOR2_67_Y, B => AND2_55_Y, C => AND2_0_Y, 
        Y => AO21_58_Y);
    AND3_14 : AND3
      port map(A => XNOR2_35_Y, B => XNOR2_36_Y, C => XNOR2_22_Y, 
        Y => AND3_14_Y);
    XOR2_136 : XOR2
      port map(A => WBINSYNC_1_net, B => INV_27_Y, Y => 
        XOR2_136_Y);
    INV_81 : INV
      port map(A => RESET, Y => INV_81_Y);
    XNOR2_38 : XNOR2
      port map(A => WGRYSYNC_5_net, B => WGRYSYNC_4_net, Y => 
        XNOR2_38_Y);
    XOR2_78 : XOR2
      port map(A => WBINNXT_4_net, B => WBINNXT_5_net, Y => 
        XOR2_78_Y);
    XOR2_RDIFF_6_inst : XOR2
      port map(A => XOR2_121_Y, B => AO21_12_Y, Y => RDIFF_6_net);
    XNOR2_25 : XNOR2
      port map(A => FULLCONSTVALUE_0_net, B => WDIFF_6_net, Y => 
        XNOR2_25_Y);
    XNOR2_64 : XNOR2
      port map(A => WGRYSYNC_2_net, B => XOR2_144_Y, Y => 
        XNOR2_64_Y);
    AND2_93 : AND2
      port map(A => INV_23_Y, B => INV_57_Y, Y => AND2_93_Y);
    DFFC_MEMWADDR_5_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_3_Y, CLR => INV_46_Y, 
        Q => MEMWADDR_5_net);
    DFFS_AEMPTY : DFFS
      port map(CLK => RCLOCK, D => AOI21_1_Y, SET => INV_47_Y, 
        Q => AEMPTY);
    DFFS_EMPTY : DFFS
      port map(CLK => RCLOCK, D => AOI21_0_Y, SET => INV_33_Y, 
        Q => EMPTY_1_net);
    AND2_26 : AND2
      port map(A => MEMWADDR_0_net, B => VCC, Y => AND2_26_Y);
    XOR2_51 : XOR2
      port map(A => XOR2_135_Y, B => AO21_48_Y, Y => XOR2_51_Y);
    AND2_88 : AND2
      port map(A => WBINSYNC_8_net, B => INV_103_Y, Y => 
        AND2_88_Y);
    XOR2_104 : XOR2
      port map(A => WBIN_7_net, B => GND_1_net, Y => XOR2_104_Y);
    INV_2 : INV
      port map(A => RESET, Y => INV_2_Y);
    DFFC_FULL : DFFC
      port map(CLK => WCLOCK, D => AOI21_3_Y, CLR => INV_51_Y, 
        Q => FULL_1_net);
    XOR2_111 : XOR2
      port map(A => WGRYSYNC_8_net, B => WGRYSYNC_7_net, Y => 
        XOR2_111_Y);
    DFFC_RGRYSYNC_3_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_6_Q, CLR => INV_100_Y, 
        Q => RGRYSYNC_3_net);
    INV_79 : INV
      port map(A => RESET, Y => INV_79_Y);
    XOR2_RBINSYNC_0_inst : XOR2
      port map(A => XNOR2_15_Y, B => XOR2_143_Y, Y => 
        RBINSYNC_0_net);
    XOR2_RBINSYNC_4_inst : XOR2
      port map(A => XNOR2_14_Y, B => XOR2_0_Y, Y => 
        RBINSYNC_4_net);
    DFFC_RGRYSYNC_2_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_9_Q, CLR => INV_30_Y, 
        Q => RGRYSYNC_2_net);
    INV_18 : INV
      port map(A => AND2_42_Y, Y => INV_18_Y);
    XOR2_13 : XOR2
      port map(A => XNOR2_23_Y, B => WGRYSYNC_3_net, Y => 
        XOR2_13_Y);
    XOR2_2 : XOR2
      port map(A => WBINNXT_8_net, B => GND_1_net, Y => XOR2_2_Y);
    AO21_62 : AO21
      port map(A => AND3_5_Y, B => NAND3FTT_22_Y, C => 
        NAND3FTT_17_Y, Y => AO21_62_Y);
    NOR3FTT_2 : NOR3FTT
      port map(A => OR2FT_2_Y, B => AO21FTF_3_Y, C => WDIFF_0_net, 
        Y => NOR3FTT_2_Y);
    AND2_57 : AND2
      port map(A => WBINNXT_1_net, B => INV_57_Y, Y => AND2_57_Y);
    XNOR2_54 : XNOR2
      port map(A => WRADDRGEN_CONST_0_net, B => MEMWADDR_2_net, 
        Y => XNOR2_54_Y);
    DFFC_WGRY_3_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_4_Y, CLR => INV_28_Y, 
        Q => WGRY_3_net);
    AND2_34 : AND2
      port map(A => WBIN_2_net, B => GND_1_net, Y => AND2_34_Y);
    XOR2_3 : XOR2
      port map(A => MEMRADDR_3_net, B => GND_1_net, Y => XOR2_3_Y);
    INV_64 : INV
      port map(A => RBINSYNC_4_net, Y => INV_64_Y);
    MUX2H_3 : MUX2H
      port map(A => MEMWADDR_5_net, B => XOR2_35_Y, S => 
        AND2FT_2_Y, Y => MUX2H_3_Y);
    XOR2_19 : XOR2
      port map(A => WBIN_3_net, B => GND_1_net, Y => XOR2_19_Y);
    XOR2_83 : XOR2
      port map(A => WBINSYNC_3_net, B => INV_109_Y, Y => 
        XOR2_83_Y);
    XNOR2_3 : XNOR2
      port map(A => RGRYSYNC_5_net, B => RGRYSYNC_4_net, Y => 
        XNOR2_3_Y);
    DFFC_MEM_WADDR_8_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_2_Y, CLR => INV_83_Y, 
        Q => MEM_WADDR_8_net);
    XOR2_68 : XOR2
      port map(A => XNOR2_44_Y, B => WGRYSYNC_3_net, Y => 
        XOR2_68_Y);
    XNOR2_67 : XNOR2
      port map(A => WDIFF_5_net, B => AFVALCONST_1_net, Y => 
        XNOR2_67_Y);
    XOR2_89 : XOR2
      port map(A => WBINSYNC_8_net, B => INV_103_Y, Y => 
        XOR2_89_Y);
    AO21_11 : AO21
      port map(A => XOR2_137_Y, B => AND2_41_Y, C => AND2_45_Y, 
        Y => AO21_11_Y);
    INV_50 : INV
      port map(A => AND3_0_Y, Y => INV_50_Y);
    XNOR2_46 : XNOR2
      port map(A => XOR2_33_Y, B => XOR2_43_Y, Y => XNOR2_46_Y);
    XOR2_129 : XOR2
      port map(A => RBIN_3_net, B => GND_1_net, Y => XOR2_129_Y);
    XOR2_17 : XOR2
      port map(A => RBIN_8_net, B => GND_1_net, Y => XOR2_17_Y);
    XOR2_140 : XOR2
      port map(A => XOR2_80_Y, B => AO21_19_Y, Y => XOR2_140_Y);
    XOR2_113 : XOR2
      port map(A => RBIN_5_net, B => GND_1_net, Y => XOR2_113_Y);
    OR2FT_20 : OR2FT
      port map(A => WDIFF_8_net, B => AFVALCONST_0_net, Y => 
        OR2FT_20_Y);
    INV_62 : INV
      port map(A => RBINSYNC_5_net, Y => INV_62_Y);
    DFFC_RGRY_1_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_50_Y, CLR => INV_66_Y, 
        Q => RGRY_1_net);
    INV_16 : INV
      port map(A => RESET, Y => INV_16_Y);
    AO21FTF_8 : AO21FTF
      port map(A => RDIFF_4_net, B => AEVALCONST_1_net, C => 
        RDIFF_3_net, Y => AO21FTF_8_Y);
    INV_55 : INV
      port map(A => RESET, Y => INV_55_Y);
    XOR2_132 : XOR2
      port map(A => XNOR2_3_Y, B => RGRYSYNC_3_net, Y => 
        XOR2_132_Y);
    AND2_51 : AND2
      port map(A => WBINSYNC_3_net, B => INV_109_Y, Y => 
        AND2_51_Y);
    MUX2H_8 : MUX2H
      port map(A => MEMWADDR_0_net, B => XOR2_118_Y, S => 
        AND2FT_2_Y, Y => MUX2H_8_Y);
    OR3_1 : OR3
      port map(A => AND2_49_Y, B => AND2_79_Y, C => AND2_12_Y, 
        Y => OR3_1_Y);
    XOR2_87 : XOR2
      port map(A => XNOR2_12_Y, B => RGRYSYNC_3_net, Y => 
        XOR2_87_Y);
    NAND2_1 : NAND2
      port map(A => EMPTY_1_net, B => VCC, Y => NAND2_1_Y);
    XNOR2_57 : XNOR2
      port map(A => RGRYSYNC_8_net, B => RGRYSYNC_7_net, Y => 
        XNOR2_57_Y);
    MUX2H_14 : MUX2H
      port map(A => MEMWADDR_1_net, B => XOR2_24_Y, S => 
        AND2FT_2_Y, Y => MUX2H_14_Y);
    INV_40 : INV
      port map(A => NOR2FT_0_Y, Y => INV_40_Y);
    AO21_31 : AO21
      port map(A => XOR2_70_Y, B => AND2_97_Y, C => AND2_80_Y, 
        Y => AO21_31_Y);
    AND2_29 : AND2
      port map(A => WBINNXT_6_net, B => INV_67_Y, Y => AND2_29_Y);
    NAND3FTT_19 : NAND3FTT
      port map(A => NOR3FTT_1_Y, B => OR2FT_8_Y, C => 
        NAND3FTT_14_Y, Y => NAND3FTT_19_Y);
    INV_87 : INV
      port map(A => RESET, Y => INV_87_Y);
    NOR3FTT_7 : NOR3FTT
      port map(A => OR2FT_23_Y, B => AO21FTF_1_Y, C => 
        WDIFF_6_net, Y => NOR3FTT_7_Y);
    DFFC_WBIN_1_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_1_net, CLR => INV_29_Y, 
        Q => WBIN_1_net);
    DFFC_RGRYSYNC_6_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_17_Q, CLR => INV_84_Y, 
        Q => RGRYSYNC_6_net);
    INV_45 : INV
      port map(A => RESET, Y => INV_45_Y);
    XNOR2_26 : XNOR2
      port map(A => AFVALCONST_0_net, B => WDIFF_7_net, Y => 
        XNOR2_26_Y);
    AOI21_0 : AOI21
      port map(A => AND3_10_Y, B => AO21_25_Y, C => NAND3FTT_9_Y, 
        Y => AOI21_0_Y);
    DFFC_RGRY_6_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_131_Y, CLR => INV_95_Y, 
        Q => RGRY_6_net);
    XOR2_134 : XOR2
      port map(A => WBINNXT_7_net, B => WBINNXT_8_net, Y => 
        XOR2_134_Y);
    XNOR2_58 : XNOR2
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_5_net, Y => 
        XNOR2_58_Y);
    INV_7 : INV
      port map(A => AND2_42_Y, Y => INV_7_Y);
    AND2_87 : AND2
      port map(A => WBINNXT_7_net, B => INV_8_Y, Y => AND2_87_Y);
    AND2_15 : AND2
      port map(A => AND2_92_Y, B => XOR2_117_Y, Y => AND2_15_Y);
    DFFC_MEMRADDR_4_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_13_Y, CLR => INV_4_Y, 
        Q => MEMRADDR_4_net);
    AO21_51 : AO21
      port map(A => XOR2_42_Y, B => AO21_11_Y, C => AND2_13_Y, 
        Y => AO21_51_Y);
    XOR2_WDIFF_6_inst : XOR2
      port map(A => XOR2_48_Y, B => AO21_6_Y, Y => WDIFF_6_net);
    DFFC_RBIN_0_inst : DFFC
      port map(CLK => RCLOCK, D => RBINNXT_0_net, CLR => INV_16_Y, 
        Q => RBIN_0_net);
    AND2_75 : AND2
      port map(A => RBIN_3_net, B => GND_1_net, Y => AND2_75_Y);
    XOR2_WBINNXT_8_inst : XOR2
      port map(A => XOR2_119_Y, B => AO21_9_Y, Y => WBINNXT_8_net);
    AO21_24 : AO21
      port map(A => XOR2_75_Y, B => AND2_13_Y, C => AND2_75_Y, 
        Y => AO21_24_Y);
    AO21_15 : AO21
      port map(A => XOR2_123_Y, B => AO21_55_Y, C => AND2_33_Y, 
        Y => AO21_15_Y);
    AND2_56 : AND2
      port map(A => XOR2_91_Y, B => XOR2_137_Y, Y => AND2_56_Y);
    AO21_16 : AO21
      port map(A => AND2_19_Y, B => AO21_26_Y, C => AO21_59_Y, 
        Y => AO21_16_Y);
    XOR2_52 : XOR2
      port map(A => WBINSYNC_2_net, B => INV_20_Y, Y => XOR2_52_Y);
    XNOR2_6 : XNOR2
      port map(A => WRADDRGEN_CONST_0_net, B => MEM_WADDR_8_net, 
        Y => XNOR2_6_Y);
    INV_109 : INV
      port map(A => RBINNXT_3_net, Y => INV_109_Y);
    XOR2_121 : XOR2
      port map(A => WBINSYNC_6_net, B => INV_73_Y, Y => 
        XOR2_121_Y);
    INV_59 : INV
      port map(A => RESET, Y => INV_59_Y);
    OR2FT_4 : OR2FT
      port map(A => RDIFF_2_net, B => AEVALCONST_0_net, Y => 
        OR2FT_4_Y);
    XOR2_RDIFF_3_inst : XOR2
      port map(A => XOR2_83_Y, B => AO21_41_Y, Y => RDIFF_3_net);
    INV_101 : INV
      port map(A => RESET, Y => INV_101_Y);
    XOR2_94 : XOR2
      port map(A => WBIN_6_net, B => GND_1_net, Y => XOR2_94_Y);
    XOR2_WBINSYNC_6_inst : XOR2
      port map(A => XOR2_146_Y, B => WGRYSYNC_6_net, Y => 
        WBINSYNC_6_net);
    AND2_81 : AND2
      port map(A => WBINSYNC_4_net, B => INV_72_Y, Y => AND2_81_Y);
    AO21_35 : AO21
      port map(A => XOR2_73_Y, B => AND2_32_Y, C => AND2_60_Y, 
        Y => AO21_35_Y);
    AO21_36 : AO21
      port map(A => XOR2_3_Y, B => AO21_28_Y, C => AND2_96_Y, 
        Y => AO21_36_Y);
    AND2_20 : AND2
      port map(A => WBINNXT_2_net, B => INV_12_Y, Y => AND2_20_Y);
    INV_23 : INV
      port map(A => RBINSYNC_1_net, Y => INV_23_Y);
    AO21FTF_0 : AO21FTF
      port map(A => RDIFF_7_net, B => AEVALCONST_0_net, C => 
        RDIFF_6_net, Y => AO21FTF_0_Y);
    XOR2_56 : XOR2
      port map(A => XOR2_81_Y, B => RGRYSYNC_6_net, Y => 
        XOR2_56_Y);
    AO21_28 : AO21
      port map(A => XOR2_26_Y, B => AO21_39_Y, C => AND2_30_Y, 
        Y => AO21_28_Y);
    DFFC_13 : DFFC
      port map(CLK => RCLOCK, D => WGRY_5_net, CLR => INV_110_Y, 
        Q => DFFC_13_Q);
    INV_49 : INV
      port map(A => RESET, Y => INV_49_Y);
    XNOR2_5 : XNOR2
      port map(A => RDADDRGEN_CONST_0_net, B => MEMRADDR_0_net, 
        Y => XNOR2_5_Y);
    AO21_40 : AO21
      port map(A => AND2_6_Y, B => AO21_54_Y, C => AO21_42_Y, 
        Y => AO21_40_Y);
    DFFC_WGRY_7_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_134_Y, CLR => INV_97_Y, 
        Q => WGRY_7_net);
    XOR2_RDIFF_2_inst : XOR2
      port map(A => XOR2_52_Y, B => OR3_1_Y, Y => RDIFF_2_net);
    AND3_15 : AND3
      port map(A => XNOR2_5_Y, B => XNOR2_62_Y, C => XNOR2_34_Y, 
        Y => AND3_15_Y);
    XOR2_116 : XOR2
      port map(A => MEMWADDR_3_net, B => GND_1_net, Y => 
        XOR2_116_Y);
    NAND3FTT_14 : NAND3FTT
      port map(A => AEVALCONST_1_net, B => RDIFF_4_net, C => 
        OR2FT_14_Y, Y => NAND3FTT_14_Y);
    AND2FT_1 : AND2FT
      port map(A => EMPTY_1_net, B => REP, Y => AND2FT_1_Y);
    AO21_55 : AO21
      port map(A => XOR2_116_Y, B => AO21_2_Y, C => AND2_59_Y, 
        Y => AO21_55_Y);
    XOR2_WDIFF_8_inst : XOR2
      port map(A => XOR2_11_Y, B => AO21_5_Y, Y => WDIFF_8_net);
    AO21_56 : AO21
      port map(A => AND2_63_Y, B => AO21_63_Y, C => AO21_37_Y, 
        Y => AO21_56_Y);
    NAND3FTT_8 : NAND3FTT
      port map(A => EMPTYVALUECONST_0_net, B => RDIFF_7_net, C => 
        OR2FT_16_Y, Y => NAND3FTT_8_Y);
    XOR2_123 : XOR2
      port map(A => MEMWADDR_4_net, B => GND_1_net, Y => 
        XOR2_123_Y);
    OR2FT_21 : OR2FT
      port map(A => WDIFF_2_net, B => FULLCONSTVALUE_0_net, Y => 
        OR2FT_21_Y);
    XOR2_WDIFF_0_inst : XOR2
      port map(A => WBINNXT_0_net, B => RBINSYNC_0_net, Y => 
        WDIFF_0_net);
    AO21_8 : AO21
      port map(A => XOR2_86_Y, B => OR3_0_Y, C => AND2_20_Y, Y => 
        AO21_8_Y);
    XOR2_100 : XOR2
      port map(A => XOR2_108_Y, B => AO21_36_Y, Y => XOR2_100_Y);
    XOR2_147 : XOR2
      port map(A => XOR2_3_Y, B => AO21_28_Y, Y => XOR2_147_Y);
    AND2_13 : AND2
      port map(A => RBIN_2_net, B => GND_1_net, Y => AND2_13_Y);
    XNOR2_14 : XNOR2
      port map(A => RGRYSYNC_5_net, B => RGRYSYNC_4_net, Y => 
        XNOR2_14_Y);
    AND2_86 : AND2
      port map(A => AND2_46_Y, B => XOR2_110_Y, Y => AND2_86_Y);
    INV_60 : INV
      port map(A => AND2_42_Y, Y => INV_60_Y);
    NOR3FTT_8 : NOR3FTT
      port map(A => OR2FT_6_Y, B => AO21FTF_10_Y, C => 
        WDIFF_3_net, Y => NOR3FTT_8_Y);
    AND2_73 : AND2
      port map(A => AND2_56_Y, B => AND2_21_Y, Y => AND2_73_Y);
    XOR2_WBINNXT_5_inst : XOR2
      port map(A => XOR2_45_Y, B => AO21_46_Y, Y => WBINNXT_5_net);
    AND2_59 : AND2
      port map(A => MEMWADDR_3_net, B => GND_1_net, Y => 
        AND2_59_Y);
    AO21_0 : AO21
      port map(A => XOR2_16_Y, B => AO21_49_Y, C => AND2_5_Y, 
        Y => AO21_0_Y);
    INV_11 : INV
      port map(A => RESET, Y => INV_11_Y);
    AO21_47 : AO21
      port map(A => XOR2_27_Y, B => AND2_98_Y, C => AND2_29_Y, 
        Y => AO21_47_Y);
    DFFC_WBIN_3_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_3_net, CLR => INV_92_Y, 
        Q => WBIN_3_net);
    XOR2_95 : XOR2
      port map(A => RGRYSYNC_8_net, B => RGRYSYNC_7_net, Y => 
        XOR2_95_Y);
    XOR2_RBINSYNC_7_inst : XOR2
      port map(A => RGRYSYNC_8_net, B => RGRYSYNC_7_net, Y => 
        RBINSYNC_7_net);
    INV_65 : INV
      port map(A => RESET, Y => INV_65_Y);
    XNOR2_30 : XNOR2
      port map(A => RDADDRGEN_CONST_5_net, B => MEMRADDR_5_net, 
        Y => XNOR2_30_Y);
    DFFC_RGRY_2_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_133_Y, CLR => INV_2_Y, 
        Q => RGRY_2_net);
    XOR2_11 : XOR2
      port map(A => WBINNXT_8_net, B => INV_96_Y, Y => XOR2_11_Y);
    NAND3FTT_5 : NAND3FTT
      port map(A => NOR3FTT_5_Y, B => OR2FT_9_Y, C => 
        NAND3FTT_6_Y, Y => NAND3FTT_5_Y);
    AND2_35 : AND2
      port map(A => XOR2_142_Y, B => XOR2_73_Y, Y => AND2_35_Y);
    XNOR2_43 : XNOR2
      port map(A => RDADDRGEN_CONST_0_net, B => MEMRADDR_4_net, 
        Y => XNOR2_43_Y);
    XOR2_48 : XOR2
      port map(A => WBINNXT_6_net, B => INV_67_Y, Y => XOR2_48_Y);
    INV_5 : INV
      port map(A => RESET, Y => INV_5_Y);
    XOR2_81 : XOR2
      port map(A => RGRYSYNC_8_net, B => RGRYSYNC_7_net, Y => 
        XOR2_81_Y);
    XNOR2_31 : XNOR2
      port map(A => RGRYSYNC_8_net, B => RGRYSYNC_7_net, Y => 
        XNOR2_31_Y);
    AO21FTF_4 : AO21FTF
      port map(A => RDIFF_1_net, B => EMPTYVALUECONST_0_net, C => 
        RDIFF_0_net, Y => AO21FTF_4_Y);
    MUX2H_9 : MUX2H
      port map(A => MEMRADDR_0_net, B => XOR2_60_Y, S => 
        AND2FT_0_Y, Y => MUX2H_9_Y);
    XOR2_5 : XOR2
      port map(A => RBIN_2_net, B => GND_1_net, Y => XOR2_5_Y);
    DFFC_WBIN_8_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_8_net, CLR => INV_81_Y, 
        Q => WBIN_8_net);
    INV_34 : INV
      port map(A => RESET, Y => INV_34_Y);
    XNOR2_17 : XNOR2
      port map(A => RDIFF_7_net, B => EMPTYVALUECONST_0_net, Y => 
        XNOR2_17_Y);
    DFFC_14 : DFFC
      port map(CLK => WCLOCK, D => RGRY_8_net, CLR => INV_74_Y, 
        Q => DFFC_14_Q);
    DFFC_RGRY_5_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_139_Y, CLR => INV_43_Y, 
        Q => RGRY_5_net);
    INV_4 : INV
      port map(A => AND2_42_Y, Y => INV_4_Y);
    NAND2_0 : NAND2
      port map(A => FULL_1_net, B => VCC, Y => NAND2_0_Y);
    AND3_13 : AND3
      port map(A => XNOR2_40_Y, B => XNOR2_37_Y, C => XNOR2_58_Y, 
        Y => AND3_13_Y);
    AND2_MEMORYWE : AND2
      port map(A => NAND2_0_Y, B => WEP, Y => MEMORYWE);
    INV_73 : INV
      port map(A => RBINNXT_6_net, Y => INV_73_Y);
    XOR2_112 : XOR2
      port map(A => RBINNXT_8_net, B => GND_1_net, Y => 
        XOR2_112_Y);
    XNOR2_23 : XNOR2
      port map(A => WGRYSYNC_5_net, B => WGRYSYNC_4_net, Y => 
        XNOR2_23_Y);
    XOR2_WBINSYNC_0_inst : XOR2
      port map(A => XNOR2_46_Y, B => XOR2_96_Y, Y => 
        WBINSYNC_0_net);
    XOR2_WBINSYNC_4_inst : XOR2
      port map(A => XNOR2_45_Y, B => XOR2_1_Y, Y => 
        WBINSYNC_4_net);
    AND2_50 : AND2
      port map(A => MEMWADDR_7_net, B => GND_1_net, Y => 
        AND2_50_Y);
    XOR2_90 : XOR2
      port map(A => WBINNXT_1_net, B => INV_23_Y, Y => XOR2_90_Y);
    INV_32 : INV
      port map(A => RESET, Y => INV_32_Y);
    AO21_60 : AO21
      port map(A => XOR2_110_Y, B => AO21_9_Y, C => AND2_27_Y, 
        Y => AO21_60_Y);
    XNOR2_18 : XNOR2
      port map(A => RGRYSYNC_8_net, B => RGRYSYNC_7_net, Y => 
        XNOR2_18_Y);
    DFFC_4 : DFFC
      port map(CLK => RCLOCK, D => WGRY_6_net, CLR => INV_3_Y, 
        Q => DFFC_4_Q);
    DFFC_15 : DFFC
      port map(CLK => RCLOCK, D => WGRY_0_net, CLR => INV_58_Y, 
        Q => DFFC_15_Q);
    INV_113 : INV
      port map(A => RESET, Y => INV_113_Y);
    INV_69 : INV
      port map(A => RESET, Y => INV_69_Y);
    AND2_89 : AND2
      port map(A => WBIN_4_net, B => GND_1_net, Y => AND2_89_Y);
    DFFC_WGRY_4_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_78_Y, CLR => INV_80_Y, 
        Q => WGRY_4_net);
    XOR2_RBINNXT_4_inst : XOR2
      port map(A => XOR2_77_Y, B => AO21_20_Y, Y => RBINNXT_4_net);
    DFFC_RGRY_8_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_112_Y, CLR => INV_48_Y, 
        Q => RGRY_8_net);
    XOR2_126 : XOR2
      port map(A => XNOR2_52_Y, B => RGRYSYNC_6_net, Y => 
        XOR2_126_Y);
    XOR2_130 : XOR2
      port map(A => WBINNXT_6_net, B => WBINNXT_7_net, Y => 
        XOR2_130_Y);
    INV_28 : INV
      port map(A => RESET, Y => INV_28_Y);
    AO21_21 : AO21
      port map(A => XOR2_40_Y, B => AO21_13_Y, C => AND2_18_Y, 
        Y => AO21_21_Y);
    INV_110 : INV
      port map(A => RESET, Y => INV_110_Y);
    XOR2_74 : XOR2
      port map(A => WBIN_1_net, B => GND_1_net, Y => XOR2_74_Y);
    XOR2_114 : XOR2
      port map(A => MEMWADDR_5_net, B => GND_1_net, Y => 
        XOR2_114_Y);
    XNOR2_60 : XNOR2
      port map(A => WGRYSYNC_8_net, B => WGRYSYNC_7_net, Y => 
        XNOR2_60_Y);
    MUX2H_6 : MUX2H
      port map(A => MEMWADDR_2_net, B => XOR2_140_Y, S => 
        AND2FT_2_Y, Y => MUX2H_6_Y);
    XOR2_WBINNXT_0_inst : XOR2
      port map(A => WBIN_0_net, B => MEMORYWE, Y => WBINNXT_0_net);
    AND2_42 : AND2
      port map(A => INV_41_Y, B => RESET, Y => AND2_42_Y);
    DFFC_5 : DFFC
      port map(CLK => RCLOCK, D => WGRY_8_net, CLR => INV_37_Y, 
        Q => DFFC_5_Q);
    AOI21_2 : AOI21
      port map(A => AND3_2_Y, B => AO21_62_Y, C => NAND3FTT_18_Y, 
        Y => AOI21_2_Y);
    AND2_33 : AND2
      port map(A => MEMWADDR_4_net, B => GND_1_net, Y => 
        AND2_33_Y);
    INV_17 : INV
      port map(A => RBINNXT_7_net, Y => INV_17_Y);
    XNOR2_61 : XNOR2
      port map(A => AEVALCONST_1_net, B => RDIFF_4_net, Y => 
        XNOR2_61_Y);
    AND2_2 : AND2
      port map(A => MEMWADDR_2_net, B => GND_1_net, Y => AND2_2_Y);
    DFFC_DVLDX : DFFC
      port map(CLK => RCLOCK, D => DVLDI, CLR => INV_101_Y, Q => 
        DVLDX);
    AND2_62 : AND2
      port map(A => WBIN_1_net, B => GND_1_net, Y => AND2_62_Y);
    XOR2_107 : XOR2
      port map(A => WBINSYNC_8_net, B => INV_103_Y, Y => 
        XOR2_107_Y);
    XNOR2_1 : XNOR2
      port map(A => RGRYSYNC_2_net, B => RGRYSYNC_1_net, Y => 
        XNOR2_1_Y);
    AND3_2 : AND3
      port map(A => XNOR2_41_Y, B => XNOR2_26_Y, C => XNOR2_59_Y, 
        Y => AND3_2_Y);
    DFFC_MEMRADDR_0_inst : DFFC
      port map(CLK => RCLOCK, D => MUX2H_9_Y, CLR => INV_7_Y, 
        Q => MEMRADDR_0_net);
    INV_114 : INV
      port map(A => RESET, Y => INV_114_Y);
    XNOR2_50 : XNOR2
      port map(A => AEVALCONST_1_net, B => RDIFF_5_net, Y => 
        XNOR2_50_Y);
    INV_26 : INV
      port map(A => RESET, Y => INV_26_Y);
    OR2_0 : OR2
      port map(A => AOI21_2_Y, B => FULL_1_net, Y => OR2_0_Y);
    INV_94 : INV
      port map(A => RESET, Y => INV_94_Y);
    NOR3FTT_5 : NOR3FTT
      port map(A => OR2FT_7_Y, B => AO21FTF_0_Y, C => 
        AEVALCONST_0_net, Y => NOR3FTT_5_Y);
    XOR2_12 : XOR2
      port map(A => WBINSYNC_7_net, B => INV_17_Y, Y => XOR2_12_Y);
    XOR2_145 : XOR2
      port map(A => RBINNXT_0_net, B => RBINNXT_1_net, Y => 
        XOR2_145_Y);
    DFFC_RGRYSYNC_4_inst : DFFC
      port map(CLK => WCLOCK, D => DFFC_2_Q, CLR => INV_15_Y, 
        Q => RGRYSYNC_4_net);
    NAND3FTT_2 : NAND3FTT
      port map(A => WDIFF_4_net, B => FULLCONSTVALUE_0_net, C => 
        OR2FT_6_Y, Y => NAND3FTT_2_Y);
    XNOR2_42 : XNOR2
      port map(A => WGRYSYNC_5_net, B => WGRYSYNC_4_net, Y => 
        XNOR2_42_Y);
    MEMWEBUBBLE : INV
      port map(A => MEMORYWE, Y => MEMWE);
    DFFC_1 : DFFC
      port map(CLK => WCLOCK, D => RGRY_0_net, CLR => INV_24_Y, 
        Q => DFFC_1_Q);
    XOR2_64 : XOR2
      port map(A => WBINNXT_7_net, B => INV_8_Y, Y => XOR2_64_Y);
    DFFC_WBIN_5_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_5_net, CLR => INV_9_Y, 
        Q => WBIN_5_net);
    AND2_80 : AND2
      port map(A => WBIN_7_net, B => GND_1_net, Y => AND2_80_Y);
    XNOR2_51 : XNOR2
      port map(A => RDADDRGEN_CONST_0_net, B => MEM_RADDR_8_net, 
        Y => XNOR2_51_Y);
    XOR2_82 : XOR2
      port map(A => WBIN_5_net, B => GND_1_net, Y => XOR2_82_Y);
    XNOR2_39 : XNOR2
      port map(A => WRADDRGEN_CONST_5_net, B => MEMWADDR_5_net, 
        Y => XNOR2_39_Y);
    NOR3FTT_11 : NOR3FTT
      port map(A => OR2FT_21_Y, B => AO21FTF_9_Y, C => 
        WDIFF_0_net, Y => NOR3FTT_11_Y);
    XOR2_75 : XOR2
      port map(A => RBIN_3_net, B => GND_1_net, Y => XOR2_75_Y);
    AO21_25 : AO21
      port map(A => AND3_13_Y, B => NAND3FTT_20_Y, C => 
        NAND3FTT_11_Y, Y => AO21_25_Y);
    AO21_26 : AO21
      port map(A => AND2_48_Y, B => AO21_41_Y, C => AO21_4_Y, 
        Y => AO21_26_Y);
    INV_92 : INV
      port map(A => RESET, Y => INV_92_Y);
    INV_6 : INV
      port map(A => AND2_42_Y, Y => INV_6_Y);
    XOR2_93 : XOR2
      port map(A => RBIN_1_net, B => GND_1_net, Y => XOR2_93_Y);
    XOR2_16 : XOR2
      port map(A => MEMWADDR_6_net, B => GND_1_net, Y => 
        XOR2_16_Y);
    INV_53 : INV
      port map(A => RESET, Y => INV_53_Y);
    DFFC_MEMWADDR_7_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_15_Y, CLR => INV_68_Y, 
        Q => MEMWADDR_7_net);
    AND2_MEMORYRE : AND2
      port map(A => NAND2_1_Y, B => REP, Y => MEMORYRE);
    DFFC_WGRY_0_inst : DFFC
      port map(CLK => WCLOCK, D => XOR2_49_Y, CLR => INV_0_Y, 
        Q => WGRY_0_net);
    AND2FT_2 : AND2FT
      port map(A => AND3_0_Y, B => MEMORYWE, Y => AND2FT_2_Y);
    XOR2_99 : XOR2
      port map(A => XNOR2_57_Y, B => RGRYSYNC_6_net, Y => 
        XOR2_99_Y);
    NAND3FTT_18 : NAND3FTT
      port map(A => NOR3FTT_4_Y, B => OR2FT_0_Y, C => 
        NAND3FTT_7_Y, Y => NAND3FTT_18_Y);
    AND2_24 : AND2
      port map(A => XOR2_30_Y, B => XOR2_74_Y, Y => AND2_24_Y);
    XOR2_122 : XOR2
      port map(A => WBINNXT_4_net, B => INV_64_Y, Y => XOR2_122_Y);
    AND2_48 : AND2
      port map(A => XOR2_29_Y, B => XOR2_102_Y, Y => AND2_48_Y);
    AND2FT_0 : AND2FT
      port map(A => AND3_4_Y, B => MEMORYRE, Y => AND2FT_0_Y);
    XOR2_86 : XOR2
      port map(A => WBINNXT_2_net, B => INV_12_Y, Y => XOR2_86_Y);
    XNOR2_22 : XNOR2
      port map(A => RDIFF_8_net, B => AEVALCONST_0_net, Y => 
        XNOR2_22_Y);
    DFFC_WBIN_4_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_4_net, CLR => INV_89_Y, 
        Q => WBIN_4_net);
    DFFC_WBIN_6_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_6_net, CLR => INV_79_Y, 
        Q => WBIN_6_net);
    INV_78 : INV
      port map(A => RESET, Y => INV_78_Y);
    XOR2_WDIFF_4_inst : XOR2
      port map(A => XOR2_122_Y, B => AO21_61_Y, Y => WDIFF_4_net);
    XOR2_RBINNXT_6_inst : XOR2
      port map(A => XOR2_109_Y, B => AO21_7_Y, Y => RBINNXT_6_net);
    INV_43 : INV
      port map(A => RESET, Y => INV_43_Y);
    INV_30 : INV
      port map(A => RESET, Y => INV_30_Y);
    AND2_68 : AND2
      port map(A => MEMRADDR_4_net, B => GND_1_net, Y => 
        AND2_68_Y);
    XOR2_97 : XOR2
      port map(A => WBINNXT_5_net, B => INV_62_Y, Y => XOR2_97_Y);
    OR2FT_15 : OR2FT
      port map(A => FULLCONSTVALUE_0_net, B => WDIFF_2_net, Y => 
        OR2FT_15_Y);
    XOR2_65 : XOR2
      port map(A => WBINNXT_5_net, B => WBINNXT_6_net, Y => 
        XOR2_65_Y);
    MUX2H_4 : MUX2H
      port map(A => MEMWADDR_6_net, B => XOR2_63_Y, S => 
        AND2FT_2_Y, Y => MUX2H_4_Y);
    XOR2_124 : XOR2
      port map(A => WBINNXT_3_net, B => INV_105_Y, Y => 
        XOR2_124_Y);
    INV_35 : INV
      port map(A => RESET, Y => INV_35_Y);
    XOR2_70 : XOR2
      port map(A => WBIN_7_net, B => GND_1_net, Y => XOR2_70_Y);
    XOR2_137 : XOR2
      port map(A => RBIN_1_net, B => GND_1_net, Y => XOR2_137_Y);
    DFFC_WBIN_7_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_7_net, CLR => INV_21_Y, 
        Q => WBIN_7_net);
    DFFC_WBIN_2_inst : DFFC
      port map(CLK => WCLOCK, D => WBINNXT_2_net, CLR => 
        INV_111_Y, Q => WBIN_2_net);
    AO21_12 : AO21
      port map(A => XOR2_105_Y, B => AO21_26_Y, C => AND2_23_Y, 
        Y => AO21_12_Y);
    AND2_5 : AND2
      port map(A => MEMWADDR_6_net, B => GND_1_net, Y => AND2_5_Y);
    MUX2H_2 : MUX2H
      port map(A => MEM_WADDR_8_net, B => XOR2_51_Y, S => 
        AND2FT_2_Y, Y => MUX2H_2_Y);
    AND2_92 : AND2
      port map(A => AND2_25_Y, B => AND2_74_Y, Y => AND2_92_Y);
    XOR2_28 : XOR2
      port map(A => WBIN_6_net, B => GND_1_net, Y => XOR2_28_Y);
    INV_76 : INV
      port map(A => RESET, Y => INV_76_Y);
    XOR2_38 : XOR2
      port map(A => XOR2_40_Y, B => AO21_13_Y, Y => XOR2_38_Y);
    AO21FTF_10 : AO21FTF
      port map(A => FULLCONSTVALUE_0_net, B => WDIFF_4_net, C => 
        FULLCONSTVALUE_0_net, Y => AO21FTF_10_Y);
    AO21FTF_9 : AO21FTF
      port map(A => FULLCONSTVALUE_0_net, B => WDIFF_1_net, C => 
        FULLCONSTVALUE_0_net, Y => AO21FTF_9_Y);
    OR2FT_9 : OR2FT
      port map(A => RDIFF_8_net, B => AEVALCONST_0_net, Y => 
        OR2FT_9_Y);
    XOR2_WBINSYNC_7_inst : XOR2
      port map(A => WGRYSYNC_8_net, B => WGRYSYNC_7_net, Y => 
        WBINSYNC_7_net);
    INV_105 : INV
      port map(A => RBINSYNC_3_net, Y => INV_105_Y);
    XOR2_1 : XOR2
      port map(A => XNOR2_33_Y, B => WGRYSYNC_6_net, Y => 
        XOR2_1_Y);
    OR2FT_3 : OR2FT
      port map(A => AFVALCONST_1_net, B => WDIFF_5_net, Y => 
        OR2FT_3_Y);
    AO21_32 : AO21
      port map(A => XOR2_89_Y, B => AND2_9_Y, C => AND2_88_Y, 
        Y => AO21_32_Y);
    DFFC_11 : DFFC
      port map(CLK => RCLOCK, D => WGRY_3_net, CLR => INV_91_Y, 
        Q => DFFC_11_Q);
    DFFC_8 : DFFC
      port map(CLK => RCLOCK, D => WGRY_1_net, CLR => INV_107_Y, 
        Q => DFFC_8_Q);
    XOR2_8 : XOR2
      port map(A => XOR2_14_Y, B => AO21_34_Y, Y => XOR2_8_Y);
    INV_21 : INV
      port map(A => RESET, Y => INV_21_Y);
    AO21_4 : AO21
      port map(A => XOR2_102_Y, B => AND2_51_Y, C => AND2_81_Y, 
        Y => AO21_4_Y);
    XOR2_105 : XOR2
      port map(A => WBINSYNC_5_net, B => INV_70_Y, Y => 
        XOR2_105_Y);
    MUX2H_12 : MUX2H
      port map(A => MEMWADDR_3_net, B => XOR2_37_Y, S => 
        AND2FT_2_Y, Y => MUX2H_12_Y);
    XOR2_WBINNXT_1_inst : XOR2
      port map(A => XOR2_62_Y, B => AND2_8_Y, Y => WBINNXT_1_net);
    DFFC_WGRYSYNC_7_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_3_Q, CLR => INV_85_Y, 
        Q => WGRYSYNC_7_net);
    XNOR2_59 : XNOR2
      port map(A => AFVALCONST_0_net, B => WDIFF_8_net, Y => 
        XNOR2_59_Y);
    XOR2_60 : XOR2
      port map(A => MEMRADDR_0_net, B => VCC, Y => XOR2_60_Y);
    OR2FT_8 : OR2FT
      port map(A => RDIFF_5_net, B => AEVALCONST_1_net, Y => 
        OR2FT_8_Y);
    XOR2_110 : XOR2
      port map(A => WBIN_8_net, B => GND_1_net, Y => XOR2_110_Y);
    DFFC_WGRYSYNC_0_inst : DFFC
      port map(CLK => RCLOCK, D => DFFC_15_Q, CLR => INV_102_Y, 
        Q => WGRYSYNC_0_net);
    INV_39 : INV
      port map(A => RESET, Y => INV_39_Y);
    AO21_52 : AO21
      port map(A => XOR2_84_Y, B => AO21_7_Y, C => AND2_55_Y, 
        Y => AO21_52_Y);
    AND2_47 : AND2
      port map(A => WBINSYNC_6_net, B => INV_73_Y, Y => AND2_47_Y);
    XOR2_WDIFF_2_inst : XOR2
      port map(A => XOR2_46_Y, B => OR3_0_Y, Y => WDIFF_2_net);
    AO21_49 : AO21
      port map(A => XOR2_114_Y, B => AO21_15_Y, C => AND2_76_Y, 
        Y => AO21_49_Y);
    AND2_54 : AND2
      port map(A => AND2_69_Y, B => XOR2_84_Y, Y => AND2_54_Y);
    XNOR2_10 : XNOR2
      port map(A => WRADDRGEN_CONST_5_net, B => MEMWADDR_7_net, 
        Y => XNOR2_10_Y);
    INV_90 : INV
      port map(A => RESET, Y => INV_90_Y);
    DFFC_RGRY_3_inst : DFFC
      port map(CLK => RCLOCK, D => XOR2_138_Y, CLR => INV_34_Y, 
        Q => RGRY_3_net);
    XOR2_RDIFF_5_inst : XOR2
      port map(A => XOR2_127_Y, B => AO21_26_Y, Y => RDIFF_5_net);
    XOR2_108 : XOR2
      port map(A => MEMRADDR_4_net, B => GND_1_net, Y => 
        XOR2_108_Y);
    AND2_67 : AND2
      port map(A => AND2_6_Y, B => AND2_101_Y, Y => AND2_67_Y);
    INV_58 : INV
      port map(A => RESET, Y => INV_58_Y);
    AND3_5 : AND3
      port map(A => XNOR2_0_Y, B => XNOR2_55_Y, C => XNOR2_67_Y, 
        Y => AND3_5_Y);
    AND2_8 : AND2
      port map(A => WBIN_0_net, B => MEMORYWE, Y => AND2_8_Y);
    INV_95 : INV
      port map(A => RESET, Y => INV_95_Y);
    AND2_98 : AND2
      port map(A => WBINNXT_5_net, B => INV_62_Y, Y => AND2_98_Y);
    INV_63 : INV
      port map(A => AND2_85_Y, Y => INV_63_Y);
    AO21_43 : AO21
      port map(A => AND2_7_Y, B => AO21_29_Y, C => AO21_58_Y, 
        Y => AO21_43_Y);
    XNOR2_11 : XNOR2
      port map(A => RGRYSYNC_5_net, B => RGRYSYNC_4_net, Y => 
        XNOR2_11_Y);
    XOR2_73 : XOR2
      port map(A => WBINNXT_4_net, B => INV_64_Y, Y => XOR2_73_Y);
    XOR2_WBINNXT_3_inst : XOR2
      port map(A => XOR2_19_Y, B => AO21_1_Y, Y => WBINNXT_3_net);
    AND2_41 : AND2
      port map(A => RBIN_0_net, B => MEMORYRE, Y => AND2_41_Y);
    XOR2_79 : XOR2
      port map(A => XNOR2_20_Y, B => XOR2_99_Y, Y => XOR2_79_Y);
    XOR2_44 : XOR2
      port map(A => WBIN_2_net, B => GND_1_net, Y => XOR2_44_Y);
    AO21FTF_3 : AO21FTF
      port map(A => AFVALCONST_1_net, B => WDIFF_1_net, C => 
        AFVALCONST_0_net, Y => AO21FTF_3_Y);
    INV_48 : INV
      port map(A => RESET, Y => INV_48_Y);
    NAND3FTT_22 : NAND3FTT
      port map(A => NOR3FTT_2_Y, B => OR2FT_22_Y, C => 
        NAND3FTT_12_Y, Y => NAND3FTT_22_Y);
    MUX2H_0 : MUX2H
      port map(A => MEMRADDR_7_net, B => XOR2_8_Y, S => 
        AND2FT_0_Y, Y => MUX2H_0_Y);
    NOR2FT_0 : NOR2FT
      port map(A => RBINNXT_0_net, B => WBINSYNC_0_net, Y => 
        NOR2FT_0_Y);
    AND2_61 : AND2
      port map(A => MEMRADDR_0_net, B => VCC, Y => AND2_61_Y);
    DFFC_MEMWADDR_4_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_16_Y, CLR => INV_14_Y, 
        Q => MEMWADDR_4_net);
    AND3_3 : AND3
      port map(A => XNOR2_24_Y, B => XNOR2_16_Y, C => XNOR2_7_Y, 
        Y => AND3_3_Y);
    INV_84 : INV
      port map(A => RESET, Y => INV_84_Y);
    INV_56 : INV
      port map(A => RESET, Y => INV_56_Y);
    XOR2_77 : XOR2
      port map(A => RBIN_4_net, B => GND_1_net, Y => XOR2_77_Y);
    BFR_RBINSYNC_8_inst : BFR
      port map(A => RGRYSYNC_8_net, Y => RBINSYNC_8_net);
    XOR2_91 : XOR2
      port map(A => RBIN_0_net, B => MEMORYRE, Y => XOR2_91_Y);
    NAND3FTT_1 : NAND3FTT
      port map(A => WDIFF_7_net, B => FULLCONSTVALUE_5_net, C => 
        OR2FT_23_Y, Y => NAND3FTT_1_Y);
    DFFC_AFULL : DFFC
      port map(CLK => WCLOCK, D => OR2_0_Y, CLR => INV_36_Y, Q => 
        AFULL);
    XOR2_135 : XOR2
      port map(A => MEM_WADDR_8_net, B => GND_1_net, Y => 
        XOR2_135_Y);
    INV_71 : INV
      port map(A => RESET, Y => INV_71_Y);
    AND2_25 : AND2
      port map(A => AND2_99_Y, B => AND2_35_Y, Y => AND2_25_Y);
    INV_27 : INV
      port map(A => RBINNXT_1_net, Y => INV_27_Y);
    DFFC_9 : DFFC
      port map(CLK => WCLOCK, D => RGRY_2_net, CLR => INV_87_Y, 
        Q => DFFC_9_Q);
    INV_3 : INV
      port map(A => RESET, Y => INV_3_Y);
    XOR2_RDIFF_8_inst : XOR2
      port map(A => XOR2_107_Y, B => AO21_38_Y, Y => RDIFF_8_net);
    XOR2_63 : XOR2
      port map(A => XOR2_16_Y, B => AO21_49_Y, Y => XOR2_63_Y);
    AND2_46 : AND2
      port map(A => AND2_37_Y, B => AND2_67_Y, Y => AND2_46_Y);
    AND2_84 : AND2
      port map(A => AND2_83_Y, B => XOR2_29_Y, Y => AND2_84_Y);
    INV_46 : INV
      port map(A => AND2_85_Y, Y => INV_46_Y);
    AO21_6 : AO21
      port map(A => XOR2_76_Y, B => AO21_63_Y, C => AND2_98_Y, 
        Y => AO21_6_Y);
    INV_99 : INV
      port map(A => RESET, Y => INV_99_Y);
    INV_82 : INV
      port map(A => RESET, Y => INV_82_Y);
    INV_0 : INV
      port map(A => RESET, Y => INV_0_Y);
    XOR2_69 : XOR2
      port map(A => WBINNXT_8_net, B => INV_96_Y, Y => XOR2_69_Y);
    XOR2_WDIFF_3_inst : XOR2
      port map(A => XOR2_124_Y, B => AO21_8_Y, Y => WDIFF_3_net);
    DFFC_MEMWADDR_6_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_4_Y, CLR => INV_104_Y, 
        Q => MEMWADDR_6_net);
    XOR2_45 : XOR2
      port map(A => WBIN_5_net, B => GND_1_net, Y => XOR2_45_Y);
    NAND3FTT_17 : NAND3FTT
      port map(A => NOR3FTT_9_Y, B => OR2FT_3_Y, C => 
        NAND3FTT_10_Y, Y => NAND3FTT_17_Y);
    DFFC_MEMWADDR_3_inst : DFFC
      port map(CLK => WCLOCK, D => MUX2H_12_Y, CLR => INV_63_Y, 
        Q => MEMWADDR_3_net);
    XNOR2_44 : XNOR2
      port map(A => WGRYSYNC_5_net, B => WGRYSYNC_4_net, Y => 
        XNOR2_44_Y);
    AND2_66 : AND2
      port map(A => WBIN_5_net, B => GND_1_net, Y => AND2_66_Y);
    XOR2_120 : XOR2
      port map(A => RBINNXT_4_net, B => RBINNXT_5_net, Y => 
        XOR2_120_Y);
    AND3_6 : AND3
      port map(A => XNOR2_27_Y, B => XNOR2_43_Y, C => XNOR2_30_Y, 
        Y => AND3_6_Y);
    XOR2_138 : XOR2
      port map(A => RBINNXT_3_net, B => RBINNXT_4_net, Y => 
        XOR2_138_Y);
    INV_112 : INV
      port map(A => AND2_42_Y, Y => INV_112_Y);
    DFFC_6 : DFFC
      port map(CLK => WCLOCK, D => RGRY_3_net, CLR => INV_77_Y, 
        Q => DFFC_6_Q);
    XOR2_WBINNXT_6_inst : XOR2
      port map(A => XOR2_28_Y, B => AO21_40_Y, Y => WBINNXT_6_net);
    XOR2_67 : XOR2
      port map(A => RBIN_7_net, B => GND_1_net, Y => XOR2_67_Y);
    XOR2_117 : XOR2
      port map(A => WBINNXT_7_net, B => INV_8_Y, Y => XOR2_117_Y);
    XOR2_WBINNXT_4_inst : XOR2
      port map(A => XOR2_34_Y, B => AO21_54_Y, Y => WBINNXT_4_net);
    MUX2H_13 : MUX2H
      port map(A => MEMRADDR_4_net, B => XOR2_100_Y, S => 
        AND2FT_0_Y, Y => MUX2H_13_Y);
    AND2_97 : AND2
      port map(A => WBIN_6_net, B => GND_1_net, Y => AND2_97_Y);
    NOR3FTT_0 : NOR3FTT
      port map(A => OR2FT_11_Y, B => AO21FTF_5_Y, C => 
        EMPTYVALUECONST_0_net, Y => NOR3FTT_0_Y);
end DEF_ARCH;

-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:7.3.0.29
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_SOFTFIFO
-- LPM_HINT:CTRLFF
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:F
-- "DESDIR:C:/FrontEnd/Annalisa/work/vx1392/smartgen\SoftFIFO160x32"
-- GEN_BEHV_MODULE:F
-- WWIDTH:32
-- WDEPTH:160
-- RWIDTH:32
-- RDEPTH:160
-- CLKS:2
-- WCLOCK_PN:WCLOCK
-- RCLOCK_PN:RCLOCK
-- WCLK_EDGE:RISE
-- RCLK_EDGE:RISE
-- ACLR_PN:RESET
-- RESET_POLARITY:0
-- INIT_RAM:F
-- WE_POLARITY:0
-- RE_POLARITY:0
-- FF_PN:FULL
-- AF_PN:AFULL
-- WACK_PN:WACK
-- OVRFLOW_PN:OVERFLOW
-- WRCNT_PN:WRCNT
-- WE_PN:WE
-- EF_PN:EMPTY
-- AE_PN:AEMPTY
-- DVLD_PN:DVLD
-- UDRFLOW_PN:UNDERFLOW
-- RDCNT_PN:RDCNT
-- RE_PN:RE
-- CONTROLLERONLY:T
-- FSTOP:YES
-- ESTOP:YES
-- WRITEACK:NO
-- OVERFLOW:NO
-- WRCOUNT:NO
-- DATAVALID:NO
-- UNDERFLOW:NO
-- RDCOUNT:NO
-- AF_PORT_PN:AFVAL
-- AE_PORT_PN:AEVAL
-- AFFLAG:STATIC
-- AEFLAG:STATIC
-- AFVAL:110
-- AEVAL:50
-- MEMWADDR_PN:MEMWADDR
-- MEMRADDR_PN:MEMRADDR
-- MEMWE_PN:MEMWE
-- MEMRE_PN:MEMRE

-- _End_Comments_

