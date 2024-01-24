library  ieee;
use ieee.std_logic_1164.all;
package  COMPONENTS is
  component AND2
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component AND2FT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component NAND2
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component NAND2FT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component NOR2
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component NOR2FT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component OR2
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component OR2FT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component AND3
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AND3FTT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AND3FFT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component NAND3
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component NAND3FTT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component NAND3FFT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component NOR3
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component NOR3FTT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component NOR3FFT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OR3
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OR3FTT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OR3FFT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AO21
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AO21FTT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AO21TTF
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AO21FTF
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AOI21
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AOI21FTT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AOI21TTF
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component AOI21FTF
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OA21
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OA21FTT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OA21TTF
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OA21FTF
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OAI21
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OAI21FTT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OAI21TTF
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component OAI21FTF
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic
    );
  end component;
  component INV
  port
    (
      Y : out std_logic;
      A : in std_logic
    );
  end component;
  component BUBBLE
  port
    (
      Y : out std_logic;
      A : in std_logic
    );
  end component;
  component BFR
  port
    (
      Y : out std_logic;
      A : in std_logic
    );
  end component;
  component NUBBLE
  port
    (
      Y : out std_logic;
      A : in std_logic
    );
  end component;
  component MUX2H
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      S : in std_logic
    );
  end component;
  component MUX2L
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      S : in std_logic
    );
  end component;
  component XOR2
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component XOR2FT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component XNOR2
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component XNOR2FT
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic
    );
  end component;
  component LD
  port
    (
      Q : out std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDC
  port
    (
      Q : out std_logic;
      CLR : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDL
  port
    (
      Q : out std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDLC
  port
    (
      Q : out std_logic;
      CLR : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDS
  port
    (
      Q : out std_logic;
      SET : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDLS
  port
    (
      Q : out std_logic;
      SET : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDB
  port
    (
      Q : out std_logic;
      CLR : in std_logic;
      SET : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDLB
  port
    (
      Q : out std_logic;
      CLR : in std_logic;
      SET : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDI
  port
    (
      QBAR : out std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDCI
  port
    (
      QBAR : out std_logic;
      CLR : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDLI
  port
    (
      QBAR : out std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDLCI
  port
    (
      QBAR : out std_logic;
      CLR : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDSI
  port
    (
      QBAR : out std_logic;
      SET : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDLSI
  port
    (
      QBAR : out std_logic;
      SET : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDBI
  port
    (
      QBAR : out std_logic;
      CLR : in std_logic;
      SET : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component LDLBI
  port
    (
      QBAR : out std_logic;
      CLR : in std_logic;
      SET : in std_logic;
      EN : in std_logic;
      D : in std_logic
    );
  end component;
  component DFF
  port
    (
      Q : out std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFC
  port
    (
      Q : out std_logic;
      CLR : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFL
  port
    (
      Q : out std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFLC
  port
    (
      Q : out std_logic;
      CLR : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFS
  port
    (
      Q : out std_logic;
      SET : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFLS
  port
    (
      Q : out std_logic;
      SET : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFB
  port
    (
      Q : out std_logic;
      CLR : in std_logic;
      SET : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFLB
  port
    (
      Q : out std_logic;
      CLR : in std_logic;
      SET : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFI
  port
    (
      QBAR : out std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFCI
  port
    (
      QBAR : out std_logic;
      CLR : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFLI
  port
    (
      QBAR : out std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFLCI
  port
    (
      QBAR : out std_logic;
      CLR : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFSI
  port
    (
      QBAR : out std_logic;
      SET : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFLSI
  port
    (
      QBAR : out std_logic;
      SET : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFBI
  port
    (
      QBAR : out std_logic;
      CLR : in std_logic;
      SET : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component DFFLBI
  port
    (
      QBAR : out std_logic;
      CLR : in std_logic;
      SET : in std_logic;
      CLK : in std_logic;
      D : in std_logic
    );
  end component;
  component IB25U
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB25US
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB25
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB25S
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB25LPU
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB25LPUS
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB25LP
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB25LPS
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB33U
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB33US
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB33
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component IB33S
  port
    (
      Y : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL25U
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL25US
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL25
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL25S
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL25LPU
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL25LPUS
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL25LP
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL25LPS
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL33U
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL33US
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL33
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GL33S
  port
    (
      GL : out std_logic;
      PAD : in std_logic
    );
  end component;
  component GLIB25U
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB25US
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB25
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB25S
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB25LPU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB25LPUS
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB25LP
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB25LPS
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB33U
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB33US
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB33
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLIB33S
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic
    );
  end component;
  component GLMIBL25U
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB25U
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL25US
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB25US
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL25
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB25
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL25S
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB25S
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL25LPU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB25LPU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL25LPUS
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB25LPUS
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL25LP
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB25LP
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL25LPS
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB25LPS
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL33U
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB33U
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL33US
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB33US
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL33
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB33
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIBL33S
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIB33S
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : in std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLINT
  port
    (
      GL : out std_logic;
      A : in std_logic
    );
  end component;
  component GLPE
  port
    (
      GL : out std_logic;
      PECLIN : in std_logic;
      PECLREF : in std_logic
    );
  end component;
  component GLPEMIB
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic;
      PECLIN : in std_logic;
      PECLREF : in std_logic
    );
  end component;
  component OB25LL
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25LN
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25LH
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25HL
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25HN
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25HH
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25LPLL
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25LPLN
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25LPLH
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25LPHL
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25LPHN
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB25LPHH
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB33LL
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB33LN
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB33LH
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB33PL
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB33PN
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OB33PH
  port
    (
      PAD : out std_logic;
      A : in std_logic
    );
  end component;
  component OTBL25LL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25LN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25LH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25HL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25HL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25HN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25HN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25HH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25HH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25LPLL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LPLL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25LPLN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LPLN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25LPLH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LPLH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25LPHL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LPHL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25LPHN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LPHN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL25LPHH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB25LPHH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL33LL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB33LL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL33LN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB33LN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL33LH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB33LH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL33PL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB33PL
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL33PN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB33PN
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTBL33PH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component OTB33PH
  port
    (
      PAD : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25HLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25HLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25HL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25HL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25HNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25HNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25HN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25HN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25HHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25HHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25HH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25HH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPLLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPLLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPLL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPLL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPLNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPLNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPLN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPLN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPLHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPLHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPLH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPLH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPHLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPHLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPHL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPHL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPHNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPHNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPHN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPHN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPHHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPHHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL25LPHH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB25LPHH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33LLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33LLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33LL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33LL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33LNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33LNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33LN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33LN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33LHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33LHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33LH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33LH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33PLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33PLU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33PL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33PL
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33PNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33PNU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33PN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33PN
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33PHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33PHU
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOBL33PH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component IOB33PH
  port
    (
      PAD : inout std_logic;
      Y : out std_logic;
      A : in std_logic;
      EN : in std_logic
    );
  end component;
  component GLMIOBL25LLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25HLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25HLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25HL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25HL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25HNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25HNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25HN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25HN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25HHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25HHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25HH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25HH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPLLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPLLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPLL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPLL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPLNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPLNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPLN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPLN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPLHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPLHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPLH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPLH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPHLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPHLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPHL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPHL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPHNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPHNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPHN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPHN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPHHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPHHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL25LPHH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB25LPHH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33LLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33LLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33LL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33LL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33LNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33LNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33LN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33LN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33LHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33LHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33LH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33LH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33PLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33PLU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33PL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33PL
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33PNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33PNU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33PN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33PN
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33PHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33PHU
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOBL33PH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMIOB33PH
  port
    (
      GL : out std_logic;
      Y : out std_logic;
      PAD : inout std_logic;
      A : in std_logic;
      EN : in std_logic;
      D : in std_logic;
      DE : in std_logic
    );
  end component;
  component GLMXL25LLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25HLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25HLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25HL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25HL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25HNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25HNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25HN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25HN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25HHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25HHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25HH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25HH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPLLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPLLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPLL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPLL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPLNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPLNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPLN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPLN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPLHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPLHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPLH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPLH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPHLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPHLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPHL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPHL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPHNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPHNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPHN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPHN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPHHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPHHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL25LPHH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX25LPHH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33LLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33LLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33LL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33LL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33LNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33LNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33LN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33LN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33LHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33LHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33LH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33LH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33PLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33PLU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33PL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33PL
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33PNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33PNU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33PN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33PN
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33PHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33PHU
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMXL33PH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component GLMX33PH
  port
    (
      GL : out std_logic;
      Y1 : out std_logic;
      PAD1 : inout std_logic;
      EN : in std_logic;
      D1 : in std_logic;
      DE1 : in std_logic;
      Y2 : out std_logic;
      PAD2 : inout std_logic;
      D2 : in std_logic;
      DE2 : in std_logic
    );
  end component;
  component PWR
  port
    (
      Y : out std_logic
    );
  end component;
  component GND
  port
    (
      Y : out std_logic
    );
  end component;
  component RAM256x9ASTP
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9AST
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9ASRP
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9ASR
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9AAP
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9AA
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9ASTP
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9AST
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9ASRP
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9ASR
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9AAP
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9AA
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9SSTP
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9SST
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9SSRP
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9SSR
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9SAP
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component RAM256x9SA
  generic(
      MEMORYFILE : String := "");
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9SSTP
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9SST
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9SSRP
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9SSR
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      RCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9SAP
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component FIFO256x9SA
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      WCLKS : in std_logic;
      DIS : in std_logic
    );
  end component;
  component DMUX
  port
    (
      Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      S : in std_logic
    );
  end component;
  component SRAM256x9
  port
    (
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      DOS : out std_logic;
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARGEN : in std_logic;
      PARODD : in std_logic;
      WSYNC : in std_logic;
      WCLKS : in std_logic;
      RSYNC : in std_logic;
      RCLKS : in std_logic;
      RPIPE : in std_logic;
      FIFO : in std_logic;
      DIS : in std_logic
    );
  end component;
  component PLLCORE
  port
    (
      CLK                     : in    STD_ULOGIC;                     -- Reference Clock input
      CLKA                    : in    STD_ULOGIC;                     -- Global A input
      EXTFB                   : in    STD_ULOGIC;                     -- External Feedback Clock input
      SCLK                    : in    STD_ULOGIC;                     --
      SSHIFT                  : in    STD_ULOGIC;                     --
      SDIN                    : in    STD_ULOGIC;                     --
      SUPDATE                 : in    STD_ULOGIC;                     --
      MODE                    : in    STD_ULOGIC;                     --
      FINDIV0                 : in    STD_ULOGIC;  --
      FINDIV1                 : in    STD_ULOGIC;
      FINDIV2                 : in    STD_ULOGIC;
      FINDIV3                 : in    STD_ULOGIC;
      FINDIV4                 : in    STD_ULOGIC;
      FBDIV0                  : in    STD_ULOGIC;  --
      FBDIV1                  : in    STD_ULOGIC;
      FBDIV2                  : in    STD_ULOGIC;
      FBDIV3                  : in    STD_ULOGIC;
      FBDIV4                  : in    STD_ULOGIC;
      FBDIV5                  : in    STD_ULOGIC;
      OADIV0                  : in    STD_ULOGIC;  --
      OADIV1                  : in    STD_ULOGIC;
      OBDIV0                  : in    STD_ULOGIC;  --
      OBDIV1                  : in    STD_ULOGIC;
      OAMUX0                  : in    STD_ULOGIC;  --
      OAMUX1                  : in    STD_ULOGIC;
      OBMUX0                  : in    STD_ULOGIC;  --
      OBMUX1                  : in    STD_ULOGIC;
      OBMUX2                  : in    STD_ULOGIC;
      FBSEL0                  : in    STD_ULOGIC;  --
      FBSEL1                  : in    STD_ULOGIC;
      FBDLY3                  : in    STD_ULOGIC;  --
      FBDLY2                  : in    STD_ULOGIC;
      FBDLY1                  : in    STD_ULOGIC;
      FBDLY0                  : in    STD_ULOGIC;
      XDLYSEL                  : in    STD_ULOGIC;                     --
      DLYA1                   : in    STD_ULOGIC;  -- Additional GLA delay
      DLYA0                   : in    STD_ULOGIC;
      DLYB1                   : in    STD_ULOGIC;  -- Additional GLB delay

      DLYB0                   : in    STD_ULOGIC;
      STATASEL                : in    STD_ULOGIC;
      STATBSEL                : in    STD_ULOGIC;
      GLA                     : out   STD_ULOGIC;                     -- Global A output
      GLB                     : out   STD_ULOGIC;                     -- Global B output
      LOCK                    : out   STD_ULOGIC;                     -- Lock Output - high when locked on CLK
      SDOUT                   : out   STD_ULOGIC);           

      -- GLA : out std_logic;
      -- GLB : out std_logic;
      -- LOCK : out std_logic;
      -- SDOUT : out std_logic;
      -- CLK : in std_logic;
      -- CLKA : in std_logic;
      -- EXTFB : in std_logic;
      -- SCLK : in std_logic;
      -- SSHIFT : in std_logic;
      -- SDIN : in std_logic;
      -- SUPDATE : in std_logic;
      -- MODE : in std_logic;
      -- FINDIV4 : in std_logic;
      -- FINDIV3 : in std_logic;
      -- FINDIV2 : in std_logic;
      -- FINDIV1 : in std_logic;
      -- FINDIV0 : in std_logic;
      -- FBDIV5 : in std_logic;
      -- FBDIV4 : in std_logic;
      -- FBDIV3 : in std_logic;
      -- FBDIV2 : in std_logic;
      -- FBDIV1 : in std_logic;
      -- FBDIV0 : in std_logic;
      -- OADIV1 : in std_logic;
      -- OADIV0 : in std_logic;
      -- OBDIV1 : in std_logic;
      -- OBDIV0 : in std_logic;
      -- OAMUX1 : in std_logic;
      -- OAMUX0 : in std_logic;
      -- OBMUX2 : in std_logic;
      -- OBMUX1 : in std_logic;
      -- OBMUX0 : in std_logic;
      -- FBSEL1 : in std_logic;
      -- FBSEL0 : in std_logic;
      -- FBDLY3 : in std_logic;
      -- FBDLY2 : in std_logic;
      -- FBDLY1 : in std_logic;
      -- FBDLY0 : in std_logic;
      -- XDLYSEL : in std_logic;
      -- DLYA1 : in std_logic;
      -- DLYA0 : in std_logic;
      -- DLYB1 : in std_logic;
      -- DLYB0 : in std_logic
--     );
  end component;
  component UJTAG
  port
    (
      UIREG0 : out std_logic;
      UIREG1 : out std_logic;
      UIREG2 : out std_logic;
      UIREG3 : out std_logic;
      UIREG4 : out std_logic;
      UIREG5 : out std_logic;
      UIREG6 : out std_logic;
      UIREG7 : out std_logic;
      URSTB : out std_logic;
      UDRCK : out std_logic;
      UDRCAP : out std_logic;
      UDRSH : out std_logic;
      UDRUPD : out std_logic;
      UTDI : out std_logic;
      UTDO : in std_logic;
      TDO : out std_logic;
      TMS : in std_logic;
      TDI : in std_logic;
      TCK : in std_logic;
      TRSTB : in std_logic
    );
  end component;
end COMPONENTS ;
