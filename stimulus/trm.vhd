LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
use work.DRM_pack.all;

entity TRM is
   generic (SLOT : integer );
   port(
	  enable: in	 std_logic;
      AS    : in     std_logic;
      IACK  : in     std_logic;
      DS0   : in     std_logic;
      DS1   : in     std_logic;
      WRITE : in     std_logic;
      LWORD : inout  std_logic;
      A     : inout  std_logic_vector (31 downto 1);
      D     : inout  std_logic_vector (31 downto 0);
      AM    : in     std_logic_vector (5 downto 0);
      BERR  : out    std_logic;
      DTACK : out    std_logic;

      L0    : in     std_logic;
      L1A   : in     std_logic;
      L1R   : in     std_logic;
      L2A   : in     std_logic;
      L2R   : in     std_logic;
      BUSY  : out    std_logic;
      DRDY  : out    std_logic
   );

end TRM ;


ARCHITECTURE BEHAV OF TRM IS

-- ****************************************************************************************
--constant MEB_SIZE  : integer := 1024;  -- numero di word (32bit) del MEB emulato
constant MEB_SIZE  : integer := 10240;  -- numero di word (32bit) del MEB emulato

-- Registri
subtype reg_type is std_logic_vector(31 downto 0);
type reg_array is array (integer range 0 to 31) of reg_type;

-- Event Buffer
subtype mem_type is std_logic_vector(31 downto 0);
type mem_array is array (integer range 0 to MEB_SIZE-1) of mem_type;

-- Dimensioni degli eventi
type size_array is array (integer range 0 to 9) of integer;
--constant EV_SIZE : size_array := (15, 12, 45, 24, 19, 100, 45, 26, 12, 14);
constant EV_SIZE : size_array := (6, 6, 6, 6, 6, 6, 6, 6, 6, 6);
--constant EV_SIZE : size_array := (8, 16, 16, 8, 4, 18, 20, 12, 50, 6);

type   TSTATE is (IDLE, ADDACK, ADDACK1, RREG, WREG, BLTDATA, WAITNEXT, ENDCYC, ENDCYC1);
signal STATE : TSTATE;

type   TCYC is (CYC_NULL, CYC_RW, CYC_BLT, CYC_MBLT, CYC_2ESST);
signal CYCTYPE : TCYC;

signal DTACKi       : std_logic;
signal BERRi        : std_logic;
signal STOP_BLT     : std_logic;
signal AS_S, DS_S   : std_logic;
signal AS_S1, DS_S1 : std_logic;
signal RESET        : std_logic;

signal L2A_SERVING  : std_logic := '0';
signal L2A_CNT      : integer := 0;
signal REG          : reg_array := (others => (others => '0'));
signal MEB          : mem_array := (others => (others => '0'));

signal Ai,Di        : std_logic_vector(31 downto 0);
signal addr         : integer;
signal meb_rp       : integer := 0; -- MEB read pointer
signal meb_wp       : integer := 0; -- MEB write pointer
signal evnum        : integer := 0;

signal CLK          : std_logic;
signal DRDYi        : std_logic;

signal first_time	: std_logic;	-- DAV


begin

  process
  begin
    CLK <= '0';
    wait for 12.5 ns;
    CLK <= '1';    
    wait for 12.5 ns;
  end process;  
  

  DTACK  <= DTACKi after 10 ns;
  BERR   <= BERRi  after 10 ns;

  LWORD <= Ai(0)              after 10 ns;
  A     <= Ai(31 downto 1)    after 10 ns;
  D     <= Di                 after 10 ns;
  
  RESET <= '1', '0' after 100 ns;

  
  process(CLK, RESET)
    variable rp : integer;
  begin
    if RESET = '1' then

      DTACKi   <= 'Z';
      BERRi    <= 'Z';
      DS_S     <= '1';
      DS_S1    <= '1';
      AS_S     <= '1';
      AS_S1    <= '1';
      STOP_BLT <= '0';
      Ai       <= (others => 'Z');
      Di       <= (others => 'Z');
      addr     <= conv_integer(A(15 downto 1) & '0');
      STATE    <= IDLE;
      CYCTYPE  <= CYC_NULL;
      rp       := 0;
      
    elsif CLK'event and CLK='1' then  
    
      if DS0 = '0' and DS1 = '0' then
        DS_S1 <= '0';
      else
        DS_S1 <= '1';
      end if;
      DS_S <= DS_S1;      
      
      if AS = '0' then
        AS_S1 <= '0';
      else
        AS_S1 <= '1';
      end if;  
      AS_S <= AS_S1;
    
    
      case STATE is
      
        when IDLE =>
			if(enable = '0') then
			
			  DTACKi   <= 'Z';
			  BERRi    <= 'Z';
			  STOP_BLT <= '0';
			  Ai       <= (others => 'Z');
			  Di       <= (others => 'Z');
			  CYCTYPE  <= CYC_NULL;
			  first_time	<= '1';	-- DAV (added first_time)
			
			else
			
			  DTACKi   <= 'Z';
			  BERRi    <= 'Z';
			  STOP_BLT <= '0';
			  Ai       <= (others => 'Z');
			  Di       <= (others => 'Z');
			  CYCTYPE  <= CYC_NULL;
			  first_time	<= '1';	-- DAV (added first_time)
			  
			  if AS_S = '0' and conv_integer(A(31 downto 28)) = SLOT then
				DTACKi <= '1';
				BERRi  <= '1';
				addr <= conv_integer(A(15 downto 1) & '0');
				if AM=A32_U_2ESST and conv_integer(A(15 downto 1)) = 0 then
				  CYCTYPE <= CYC_2ESST;
				  STATE <= ADDACK;
				elsif (AM=A32_U_MBLT or AM=A32_S_MBLT) and conv_integer(A(15 downto 1)) = 0 then
				  CYCTYPE <= CYC_MBLT;
				  STATE   <= ADDACK;
				elsif (AM=A32_U_BLT or AM=A32_S_BLT) and conv_integer(A(15 downto 1)) = 0 then
				  CYCTYPE <= CYC_BLT;
				  STATE   <= BLTDATA;
				elsif AM=A32_U_DATA or AM=A32_S_DATA or AM=A32_U_PROG or AM=A32_S_PROG then
				  CYCTYPE <= CYC_RW;
				  if WRITE = '0' then
					STATE <= WREG;
				  else  
					STATE <= RREG;
				  end if;  
				end if;
			  end if;
			  
			 end if;
          
        when WREG =>
          DTACKi <= '0';
          if first_time = '1' and (addr /= 0) then	-- DAV
            REG((addr/2) mod 32) <= D;
			first_time	<= '0';	-- DAV
          end if;
          if DS_S = '1' and AS = '1' then
            STATE <= IDLE;
          end if;

        when RREG =>
          DTACKi <= '0';
          if addr = 0 then
            if rp < meb_wp then
              Di <= MEB(rp);
              rp := (rp + 1) mod MEB_SIZE;
            else
              Di <= X"70000000";
            end if;
          else
            Di <= REG((addr/2) mod 32);
          end if;
          if DS_S = '1' and AS = '1' then
            STATE <= IDLE;
          end if;

        when ADDACK =>
          if CYCTYPE = CYC_2ESST then
            STATE <= ADDACK1;
          elsif DS_S = '1' then
            DTACKi <= '1';
            STATE <= BLTDATA;
		  else				-- DAV (23 March 2017): added
			DTACKi <= '0';	-- DAV (23 March 2017): added
          end if;
          
        when ADDACK1 =>
          STATE <= BLTDATA;
          
        when BLTDATA =>
          
          if DS_S = '0' then
            if STOP_BLT = '1' then
              BERRi <= '0';
              STATE <= ENDCYC;
            else
              if (CYCTYPE = CYC_MBLT or CYCTYPE = CYC_2ESST) then
                rp := meb_rp;
                if rp < meb_wp then
                  Ai <= MEB(rp);
                  if MEB(rp)(31 downto 28) = "0101" then
                    STOP_BLT <= '1';
                    if CYCTYPE = CYC_2ESST then
                      BERRi <= '0';
                    end if;
                  end if;
                  rp := (rp + 1) mod MEB_SIZE;
                  if (CYCTYPE /= CYC_2ESST) then
                    DTACKi <= '0';
                  else
                    DTACKi <= not DTACKi;
                  end if;  
                else
                  Ai <= X"70000000";
                  BERRi <= '0';
                end if;
              end if;  
              if rp < meb_wp then
                Di <= MEB(rp);
                if MEB(rp)(31 downto 28) = "0101" then
                  STOP_BLT <= '1';
                  if CYCTYPE = CYC_2ESST then
                    BERRi <= '0';
                  end if;
                end if;
                rp := (rp + 1) mod MEB_SIZE;
                if CYCTYPE = CYC_BLT then
                  DTACKi <= '0';
                end if;  
              else
                Di <= X"70000000";
                if CYCTYPE = CYC_BLT then
                  BERRi <= '0';
                end if;
              end if;
              meb_rp <= rp;
              STATE  <= WAITNEXT;
            end if;  
          end if;  
          
        when WAITNEXT =>
          if CYCTYPE = CYC_2ESST then
            if BERRi = '0' then
              DTACKi <= '1';
              STATE <= ENDCYC;
            elsif DS_S = '0'  then
              STATE <= BLTDATA;
            end if;  
          elsif DS_S = '1' then
            DTACKi <= '1';
            STATE <= BLTDATA;
          end if;
          
        when ENDCYC =>  
          if DS_S = '1' then	
            BERRi  <= '1';
            STATE <= ENDCYC1;	-- DAV	 STATE <= IDLE;
          end if;
		
		when ENDCYC1 =>  -- DAV (non esisteva prima del 24/03/2017)
          if AS_S = '1' then	
            STATE <= IDLE;
          end if;
          
      end case;  
        
    end if;
  end process;
  

  -- Processo che scrive gli eventi nel MEB
  process
  variable i, wpnt, n : integer;
  begin
    BUSY <= 'Z';
    if L2A_CNT /= 0 then
      wait for 100 ns;  -- latenza della TRM prima di iniziare a scaricare i dati nella FIFO (quanto è???)
      L2A_SERVING <= '1';
      wpnt := meb_wp;
      n := EV_SIZE((evnum+slot) mod 10);
      for i in 0 to n-1 loop
        if i = 0 then
          -- Header
          MEB(wpnt) <= "0100" & conv_std_logic_vector(slot, 4) & conv_std_logic_vector(evnum, 24);
        elsif i = n-1 then
          -- Trailer
          MEB(wpnt) <= "0101" & conv_std_logic_vector(slot, 4) & conv_std_logic_vector(n, 24);
        else
          -- Dato
          MEB(wpnt) <= "0000" & conv_std_logic_vector(slot, 4) & conv_std_logic_vector(i-1, 24);
        end if;
        wpnt := (wpnt + 1) mod MEB_SIZE;
        wait for 25 ns;
        -- se vado full (raggiungo il rd-pnt => aspetto)
        while wpnt = meb_rp loop
          BUSY <= '0';
          wait for 25 ns;
        end loop;
        BUSY <= 'Z';
      end loop;
      meb_wp <= wpnt;  -- Adesso i dati sono disponibili per la lettura
      evnum <= evnum + 1;
      L2A_SERVING <= '0';
    end if;

    wait for 25 ns;
    -- fermo il processo se non ci sono trigger da servire per 50us
    --if L2A_CNT = 0 and NOW > 100 us and L2A_CNT'stable(100 us) then
    --  wait;
    --end if;
  end process;

  -- Contatore di L2A pending --> L1a
  process(L1A, L2A_SERVING)
  begin
    if L1A'event and L1A='1' then
      L2A_CNT <= L2A_CNT + 1;
    elsif L2A_SERVING'event and L2A_SERVING = '1' then
      L2A_CNT <= L2A_CNT - 1;
    end if;
  end process;

  -- Data Ready sul P2
  DRDYi <= '0' when meb_wp /= meb_rp else '1';
  DRDY  <= DRDYi after 3 us;
  -- DRDY <= '0';

END BEHAV;

