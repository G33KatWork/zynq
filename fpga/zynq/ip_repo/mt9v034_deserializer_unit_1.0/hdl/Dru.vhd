library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_UNSIGNED.all;
    use IEEE.numeric_std.all;
library UNISIM;
    use UNISIM.vcomponents.all;
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
entity Dru is
    generic (
        C_DataWidth : integer := 12
    );
    port (
        CLK     : in std_logic;                      -- 625MHz clock
        I       : in std_logic_vector(7 downto 0);   -- the even bits are inverted!
        CLKP    : in std_logic;                      -- 312.5 MHz clock
        O       : out std_logic_vector(C_DataWidth-1 downto 0); -- deserialized data out
        VO      : out std_logic;                     -- valid data out
        LOCKED  : out std_logic
    );
end Dru;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture Dru_struct of Dru is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
function clog2(x : positive) return natural is
  variable r  : natural := 0;
  variable rp : natural := 1; -- rp tracks the value 2**r
begin 
  while rp < x loop -- Termination condition T: x <= 2**r
    -- Loop invariant L: 2**(r-1) < x
    r := r + 1;
    if rp > integer'high - rp then exit; end if;  -- If doubling rp overflows
      -- the integer range, the doubled value would exceed x, so safe to exit.
    rp := rp + rp;
  end loop;
  -- L and T  <->  2**(r-1) < x <= 2**r  <->  (r-1) < log2(x) <= r
  return r; --
end clog2;
-- Constants
constant Low  : std_logic   := '0';
constant High : std_logic   := '1';
-- Signals
signal II,ID:std_logic_vector(7 downto 0):=(others=>'0');
signal I7DD:std_logic:='0';
signal E8:std_logic_vector(7 downto 0):=(others=>'0');
signal E4:std_logic_vector(3 downto 0):=(others=>'0');
signal DO:std_logic_vector(2 downto 0):="000";
signal DV:UNSIGNED(1 downto 0):="00"; 
signal S:std_logic_vector(1 downto 0):="00";
signal DVE:std_logic_vector(1 downto 0):="00"; 
signal cDVE:std_logic_vector(DVE'range); 
signal cDV:UNSIGNED(DV'range); 
signal DO2:std_logic_vector(4 downto 0):="00000";
signal DV2:UNSIGNED(2 downto 0):="000"; 
signal DO2D:std_logic_vector(4 downto 0):="00000";
signal DV2D:UNSIGNED(2 downto 0):="000"; 
signal RxSH:std_logic_vector(C_DataWidth-2 downto 0):=(others=>'0');
signal RxDATA:std_logic_vector(C_DataWidth-1 downto 0):=(others=>'0');
signal RxCNT:UNSIGNED(clog2(C_DataWidth)-1 downto 0):=(others=>'0');
signal RxCE:std_logic:='0';
signal T,T1D,T2D:std_logic:='0';
signal BITSLIP,BITSLIP1D,BITSLIP2D:std_logic:='0';

signal holdoff        : unsigned(9 downto 0)         := (others => '0');
signal error_seen     : std_logic                    := '0';
signal valid_counter  : unsigned(13 downto 0)        := (others => '0');

-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of Dru_struct : architecture is "YES";
attribute USE_CLOCK_ENABLE : STRING;
attribute USE_CLOCK_ENABLE of DO2 : signal is "no";  
attribute USE_CLOCK_ENABLE of DV2 : signal is "no";  
---------------------------------------------------------------------------------------------
begin
--
process(CLK)
begin
  if rising_edge(CLK) then
    II<=I;
    E8<=II xnor II(6 downto 0)&ID(7);
    E4(0)<=(II(0) xnor II(1)) or (II(4) xnor II(5));
    E4(1)<=(II(1) xnor II(2)) or (II(5) xnor II(6));
    E4(2)<=(II(2) xnor II(3)) or (II(6) xnor II(7));
    E4(3)<=(II(3) xnor II(4)) or (ID(7) xnor II(0));
    ID<=II xor X"55";
    I7DD<=ID(7);
  end if;
end process;
--
cDVE(0)<='1' when S="10" and E4(3)='0' and E4(2)='1' else '0';
cDVE(1)<='1' when S="00" and E4(3)='0' and E4(0)='1' else '0';
cDV(0)<=DVE(0) or DVE(1);
cDV(1)<=not DVE(0) or DVE(1);
process (CLK)
begin
  if rising_edge(CLK) then
    case S is
      when "00"=>if E4(0)='1' then
                   S<="10";
                 elsif E4(3)='1' then
                   S<="01";
                 end if;
      when "01"=>if E4(1)='1' then
                   S<="00";
                 elsif E4(0)='1' then
                   S<="11";
                 end if;
      when "11"=>if E4(2)='1' then
                   S<="01";
                 elsif E4(1)='1' then
                   S<="10";
                 end if;
      when "10"=>if E4(3)='1' then
                   S<="11";
                 elsif E4(2)='1' then
                   S<="00";
                 end if;
      when others=>null;
    end case;
    DVE<=cDVE;
    DV<=cDV;
    case S is
      when "00"=>DO<=I7DD&ID(0)&ID(4);
      when "01"=>DO<=I7DD&ID(1)&ID(5);
      when "11"=>DO<=I7DD&ID(2)&ID(6);
      when "10"=>DO<=I7DD&ID(3)&ID(7);
      when others=>null;
    end case;
  end if;
end process;
--
process(CLKP)
begin
  if rising_edge(CLKP) then
    T<=not T;
  end if;
end process;
--
process(CLK)
begin
  if rising_edge(CLK) then
    T1D<=T;
    T2D<=T1D;
    BITSLIP1D<=BITSLIP;
    BITSLIP2D<=BITSLIP1D;
    if T2D/=T1D then
      if BITSLIP2D='1' then
        DV2<=RESIZE(DV,DV2'length)-1;
      else
        DV2<=RESIZE(DV,DV2'length);
      end if;
      DO2<="00"&DO;
    else
      DV2<=DV2+RESIZE(DV,DV2'length);
      case DV is
        when "01"=>DO2<=DO2(DO2'high-1 downto DO2'low)&DO(0);
        when "10"=>DO2<=DO2(DO2'high-2 downto DO2'low)&DO(1 downto 0);
        when "11"=>DO2<=DO2(DO2'high-3 downto DO2'low)&DO(2 downto 0);
        when others=>null;
      end case;
    end if;
  end if;
end process;
--
process(CLKP)
begin
  if rising_edge(CLKP) then
    DV2D<=DV2;  
    DO2D<=DO2;

    case DV2D is

      when "011"=>
        RxSH<=RxSH(RxSH'high-3 downto RxSH'low)&DO2D(2 downto 0);
        if RxCNT=C_DataWidth-3 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-2 downto RxSH'low)&DO2D(2 downto 0);
            RxCNT<=TO_UNSIGNED(0,RxCNT'length);
        elsif RxCNT=C_DataWidth-2 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-1 downto RxSH'low)&DO2D(2 downto 1);
            RxCNT<=TO_UNSIGNED(1,RxCNT'length);
        elsif RxCNT=C_DataWidth-1 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high downto RxSH'low)&DO2D(2);
            RxCNT<=TO_UNSIGNED(2,RxCNT'length);
        else
            RxCE<='0';
            RxCNT<=RxCNT+3;
        end if;

      when "100"=>
        RxSH<=RxSH(RxSH'high-4 downto RxSH'low)&DO2D(3 downto 0);
        if RxCNT=C_DataWidth-4 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-3 downto RxSH'low)&DO2D(3 downto 0);
            RxCNT<=TO_UNSIGNED(0,RxCNT'length);
        elsif RxCNT=C_DataWidth-3 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-2 downto RxSH'low)&DO2D(3 downto 1);
            RxCNT<=TO_UNSIGNED(1,RxCNT'length);
        elsif RxCNT=C_DataWidth-2 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-1 downto RxSH'low)&DO2D(3 downto 2);
            RxCNT<=TO_UNSIGNED(2,RxCNT'length);
        elsif RxCNT=C_DataWidth-1 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high downto RxSH'low)&DO2D(3);
            RxCNT<=TO_UNSIGNED(3,RxCNT'length);
        else
            RxCE<='0';
            RxCNT<=RxCNT+4;
        end if;

      when "101"=>
        RxSH<=RxSH(RxSH'high-5 downto RxSH'low)&DO2D(4 downto 0);
        if RxCNT=C_DataWidth-5 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-4 downto RxSH'low)&DO2D(4 downto 0);
            RxCNT<=TO_UNSIGNED(0,RxCNT'length);
        elsif RxCNT=C_DataWidth-4 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-3 downto RxSH'low)&DO2D(4 downto 1);
            RxCNT<=TO_UNSIGNED(1,RxCNT'length);
        elsif RxCNT=C_DataWidth-3 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-2 downto RxSH'low)&DO2D(4 downto 2);
            RxCNT<=TO_UNSIGNED(2,RxCNT'length);
        elsif RxCNT=C_DataWidth-2 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high-1 downto RxSH'low)&DO2D(4 downto 3);
            RxCNT<=TO_UNSIGNED(3,RxCNT'length);
        elsif RxCNT=C_DataWidth-1 then
            RxCE<='1';
            RxDATA<=RxSH(RxSH'high downto RxSH'low)&DO2D(4);
            RxCNT<=TO_UNSIGNED(4,RxCNT'length);
        else
            RxCE<='0';
            RxCNT<=RxCNT+5;
        end if;

      when others=>null;
 
    end case;
       
  end if;
end process;
--
process(CLKP)
begin
    if rising_edge(CLKP) then
        error_seen <= '0';
        BITSLIP <= '0';

        if RxCE = '1' then
            --Check for error, asser error_seen only if no recent bitslip activity took place
            if holdoff = 0 then
                if RxDATA(C_DataWidth-1) /= '1' or RxDATA(0) /= '0' then
                    error_seen <= '1';
                end if;
            else 
                holdoff <= holdoff-1;
            end if;
        end if;

        -- if we saw an error, correct it by bitslipping
        if error_seen = '1' then
            holdoff <= (others => '1');
            BITSLIP <= '1';
        end if;
    end if;
end process;
--
process(CLKP)
begin
    if rising_edge(CLKP) then
        --if RxCE = '1' then
            if error_seen = '1' then
                valid_counter <= (others => '1');
                LOCKED <= '0';
            else
                if valid_counter = 0 then
                    LOCKED <= '1';
                else
                    valid_counter <= valid_counter - 1;
                end if;
            end if;
        --end if;
    end if;
end process;
--
VO <= RxCE;
O <= RxDATA;
---------------------------------------------------------------------------------------------
end Dru_struct;