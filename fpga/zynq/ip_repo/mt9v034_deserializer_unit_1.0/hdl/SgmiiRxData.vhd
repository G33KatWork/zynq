library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_UNSIGNED.all;
library UNISIM;
	use UNISIM.vcomponents.all;
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
-- RxD_p/n      : Serial data inputs.
-- CLk0         : Clock 160/270 MHz, no phase shift.
-- Clk90        : Clock 160/270 MHz, 90 degrees phase shift.
-- Rst          : Reset input.
-- Ena          : Enable input.
-- IdlyCtrlRst  : Reset for the IDELAYCTRL block.
-- IdlyCtrlRdy  : When IDELAYCTRL block is ready.
-- RxData       : received data output for DRU.
---------------------------------------------------------------------------------------------
entity SgmiiRxData is
    generic (
        C_RefClkFreq    : real := 200.00;
        C_IdlyCntVal_M  : std_logic_vector(4 downto 0) := "00000";
        C_IdlyCntVal_S  : std_logic_vector(4 downto 0) := "00101"
    );
	port (
		RxD_p         : in std_logic;
		RxD_n         : in std_logic;
		Clk0          : in std_logic;
		Clk90         : in std_logic;
		ClkDiv        : in std_logic;
		Rst           : in std_Logic;
		Ena           : in std_logic;
		IsrdsRxData   : out std_logic_vector(7 downto 0)
	);
end SgmiiRxData;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture SgmiiRxData_struct of SgmiiRxData is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
function stdlvec_to_int(inp : std_logic_vector) return integer is
    variable result, abit   : integer := 0;
    variable count          : integer := 0;
begin
    gen : for i in inp'low to inp'high loop
        abit := 0;
        if (inp(i) = '1') then
            abit := 2**(i - inp'low);
        end if;
        result := result + abit;
        count := count + 1;
        exit gen when count = 32;
    end loop;
    return (result);
end stdlvec_to_int;
-- Constants
constant Low  : std_logic	:= '0';
constant High : std_logic	:= '1';
-- Signals
signal IntClk0_n    : std_logic;
signal IntClk90_n   : std_logic;
signal IntDataIdlyToIsrds_M : std_logic;
signal IntDataIdlyToIsrds_S : std_logic;
signal IntEna       : std_logic;
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of SgmiiRxData_struct : architecture is "YES";
---------------------------------------------------------------------------------------------
begin
-- Register the enable signal, synchronize with CLKDIV.
SgmiiRxData_I_Fdce : FDSE
    generic map (INIT => '0')
    port map (D => Low, CE => High, C => ClkDiv, S => Ena, Q => IntEna);
--
IntClk0_n <= not Clk0;
IntClk90_n <= not Clk90;
--
SgmiiRxData_I_Idlye2_M : IDELAYE2 
    generic map (
        IDELAY_TYPE             => "FIXED", 
        IDELAY_VALUE            => stdlvec_to_int(C_IdlyCntVal_M),
        HIGH_PERFORMANCE_MODE   => "TRUE",
        REFCLK_FREQUENCY        => C_RefClkFreq
    )
    port map (
        C           => Low,
        LD          => Low,
        LDPIPEEN    => Low,
        REGRST      => Low,
        CE          => Low,
        INC         => Low,
        CINVCTRL    => Low,
        CNTVALUEIN  => C_IdlyCntVal_M,
        IDATAIN     => RxD_p,
        DATAIN      => Low,
        DATAOUT     => IntDataIdlyToIsrds_M,
        CNTVALUEOUT => open
    );
--
SgmiiRxData_I_Idlye2_S : IDELAYE2
    generic map (
        IDELAY_TYPE             => "FIXED",
        IDELAY_VALUE            => stdlvec_to_int(C_IdlyCntVal_S),
        HIGH_PERFORMANCE_MODE   => "TRUE",
        REFCLK_FREQUENCY        => C_RefClkFreq
    )
    port map (
        C           => Low,
        LD          => Low,
        LDPIPEEN    => Low,
        REGRST      => Low,
        CE          => Low,
        INC         => Low,
        CINVCTRL    => Low,
        CNTVALUEIN  => C_IdlyCntVal_S,
        IDATAIN     => RxD_n,
        DATAIN      => Low,
        DATAOUT     => IntDataIdlyToIsrds_S,
        CNTVALUEOUT => open
    );
--
SgmiiRxData_I_Isrdse2_M : ISERDESE2
    generic map (
        INTERFACE_TYPE      => "OVERSAMPLE",
        DATA_RATE           => "DDR", 
        DATA_WIDTH          => 4, 
        OFB_USED            => "FALSE",
        NUM_CE              => 1,
        SERDES_MODE         => "MASTER",
        IOBDELAY            => "IFD",
        DYN_CLKDIV_INV_EN   => "FALSE",
        DYN_CLK_INV_EN      => "FALSE",
        INIT_Q1             => '0',
        INIT_Q2             => '0',
        INIT_Q3             => '0',
        INIT_Q4             => '0',
        SRVAL_Q1            => '0',
        SRVAL_Q2            => '0',
        SRVAL_Q3            => '0',
        SRVAL_Q4            => '0'
    )
    port map (
        CLK             => Clk0,
        CLKB            => IntClk0_n,
        OCLK            => Clk90,
        OCLKB           => IntClk90_n,
        D               => Low,
        BITSLIP         => Low,
        CE1             => IntEna,
        CE2             => High,
        CLKDIV          => Low,
        CLKDIVP         => Low,
        DDLY            => IntDataIdlyToIsrds_M,
        DYNCLKDIVSEL    => Low,
        DYNCLKSEL       => Low,
        OFB             => Low,
        RST             => Rst,
        SHIFTIN1        => Low,
        SHIFTIN2        => Low,
        O               => open,
        Q1              => IsrdsRxData(1),
        Q2              => IsrdsRxData(5),
        Q3              => IsrdsRxData(3),
        Q4              => IsrdsRxData(7),
        Q5              => open,
        Q6              => open,
        Q7              => open,
        Q8              => open,
        SHIFTOUT1       => open,
        SHIFTOUT2       => open
    );
--
SgmiiRxData_I_Isrdse2_S : ISERDESE2 
    generic map (
        INTERFACE_TYPE      => "OVERSAMPLE",
        DATA_RATE           => "DDR", 
        DATA_WIDTH          => 4,
        OFB_USED            => "FALSE",
        NUM_CE              => 1,
        SERDES_MODE         => "MASTER",
        IOBDELAY            => "IFD",
        DYN_CLKDIV_INV_EN   => "FALSE",
        DYN_CLK_INV_EN      => "FALSE",
        INIT_Q1             => '0',
        INIT_Q2             => '0',
        INIT_Q3             => '0',
        INIT_Q4             => '0',
        SRVAL_Q1            => '0',
        SRVAL_Q2            => '0',
        SRVAL_Q3            => '0',
        SRVAL_Q4            => '0'
    )
    port map (
        CLK             => Clk0,
        CLKB            => IntClk0_n,
        OCLK            => Clk90,
        OCLKB           => IntClk90_n,
        D               => Low,
        BITSLIP         => Low,
        CE1             => IntEna,
        CE2             => High,
        CLKDIV          => Low,
        CLKDIVP         => Low,
        DDLY            => IntDataIdlyToIsrds_S,
        DYNCLKDIVSEL    => Low,
        DYNCLKSEL       => Low,
        OFB             => Low,
        RST             => Rst,
        SHIFTIN1        => Low,
        SHIFTIN2        => Low,
        O               => open,
        Q1              => IsrdsRxData(0),
        Q2              => IsrdsRxData(4),
        Q3              => IsrdsRxData(2),
        Q4              => IsrdsRxData(6),
        Q5              => open,
        Q6              => open,
        Q7              => open,
        Q8              => open,
        SHIFTOUT1       => open,
        SHIFTOUT2       => open
    );
---------------------------------------------------------------------------------------------
end SgmiiRxData_struct;
--