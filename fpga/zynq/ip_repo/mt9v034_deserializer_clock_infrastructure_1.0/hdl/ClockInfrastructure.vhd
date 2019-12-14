library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_UNSIGNED.all;
	use IEEE.numeric_std.all;
library UNISIM;
	use UNISIM.vcomponents.all;
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
-- GENERICS
-- C_MmcmLoc       -- Where to place the RX MMCM. 
-- C_UseFbBufg     -- Use a BUFG in the MMCM feedback loop. 0 = no.
-- C_UseBufg       -- Use a BUFG in the clock outputs of the MMCM. 0 = no
--                 --   example: [5:0] "0011000", only CLKOUT3 and CLKOUT4 get a BUFG 
-- C_RstOutDly     -- Set the delay, in raw clock cycles, to relase the reset. 
-- C_EnaOutDly     -- Set the delay, in MMCM clcok cycles, to activate the enable.
-- C_BufioClk0Loc  -- Fix location of the BUFIO passing the non-inverted 625Mhz clock.
-- C_BufioClk90Loc  -- Fix location of the BUFIO passing the inverted 625Mhz clock.
-- C_IdlyCtrlLoc   -- Where goes the IDLEAYCTRL component
-- C_IoSrdsDataWidth   -- Number of OSERDES inputs and ISERDES outputs. (4 or 8)
-- C_ClockPattern      -- Clock pattern to generate. Depend the C_IoSerdesDataWidth.
---------------------------------------------------------------------------------------------
entity ClockInfrastructure is
    generic (
        C_MmcmLoc           : string := "MMCME2_ADV_X1Y2";
        C_UseFbBufg         : integer := 0;
        C_UseBufg           : std_logic_vector(6 downto 0) := "0011001";
        C_RstOutDly         : integer := 2;
        C_EnaOutDly         : integer := 6;
        C_BufioClk0Loc      : string := "BUFIO_X1Y8";
        C_BufioClk90Loc     : string := "BUFIO_X1Y9";
        C_IdlyCtrlLoc       : string := "IDELAYCTRL_X1Y2";
        C_IoSrdsDataWidth   : integer := 4;
        C_ClockPattern      : std_logic_vector(3 downto 0) := "1010";
        C_ClkinPeriod       : real    := 10.0;
        C_DivClkDivide      : integer := 1;
        C_ClkFboutMult      : real    := 8.0;
        C_Clkout0_Divide    : real    := 4.0;
        C_Clkout1_Divide    : integer := 5;
        C_Clkout2_Divide    : integer := 5;
        C_Clkout3_Divide    : integer := 10;
        C_Clkout4_Divide    : integer := 5
    );
	port (
	    -- Clock and reset signals
        ClkIn           : in std_logic;
        Rst             : in std_logic;
        
        -- Control signals
        MmcmAlignd      : out std_logic;
        DeserUnitReset  : out std_logic;
        DeserUnitEnable : out std_logic;
        
        -- Clock outputs for deserializers
        RxClk           : out std_logic;
        RxClkDiv        : out std_logic;
        Clk0Bufio       : out std_logic;
        Clk90Bufio      : out std_logic
	);
end ClockInfrastructure;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture ClockInfrastructure_struct of ClockInfrastructure is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
-- Constants
constant Low    : std_logic := '0';
constant LowVec : std_logic_vector(31 downto 0) := X"00000000";
constant High   : std_logic := '1';
-- Signals
signal IntFbOut         : std_logic;
signal IntFbIn          : std_logic;
signal IntRefClk        : std_logic; -- 200MHz.
signal IntClk0          : std_logic; -- 160MHz/270MHz, no phase shift.
signal IntClk90         : std_logic; -- 160MHz/270MHz, 90-degrees phase shift.
signal IntClk0Bufio     : std_logic; -- IntClk0 after passthrough BUFIO
signal IntClk90Bufio    : std_logic; -- IntClk90 after passthrough BUFIO
signal IntClk           : std_logic; -- 160MHz/270Mhz, fine phase shift.
signal IntClkDiv        : std_logic; -- 80MHz/135Mz, fine phase shift.
signal IntLocked        : std_logic;
signal IntIdlyCtrlRst   : std_logic;
signal IntIdlyCtrlRdy   : std_logic;
signal IntRstOut        : std_logic;
signal IntEnaOut        : std_logic;
signal IntPsIncDec      : std_logic;
signal IntPsEna         : std_logic;
signal IntPsDone        : std_logic;
-- Attributes
attribute KEEP_HIERARCHY : string;
attribute LOC : string;

attribute KEEP_HIERARCHY of ClockInfrastructure_struct : architecture is "YES";
attribute LOC of Receiver_I_Bufio_Clk0 : label is C_BufioClk0Loc;
attribute LOC of Receiver_I_Bufio_Clk90 : label is C_BufioClk90Loc;
attribute LOC of Receiver_I_IdlyCtrl : label is C_IdlyCtrlLoc;
---------------------------------------------------------------------------------------------
begin
---------------------------------------------------------------------------------------------
-- Clock generation, adjustment
---------------------------------------------------------------------------------------------
IntFbIn <= IntFbOut;
RxClk <= IntClk;
RxClkDiv <= IntClkDiv;
Clk0Bufio <= IntClk0Bufio;
Clk90Bufio <= IntClk90Bufio;
DeserUnitReset <= IntRstOut;
DeserUnitEnable <= IntEnaOut;
--
Receiver_I_RxGenClockMod : entity work.RxGenClockMod
    generic map (
        C_AppsMmcmLoc   => C_MmcmLoc,
        C_UseFbBufg     => C_UseFbBufg,
        C_UseBufg       => C_UseBufg,
        C_RstOutDly     => C_RstOutDly,
        C_EnaOutDly     => C_EnaOutDly,
        C_ClkinPeriod   => C_ClkinPeriod,
        C_DivClkDivide  => C_DivClkDivide,
        C_ClkFboutMult  => C_ClkFboutMult,
        C_Clkout0_Divide=> C_Clkout0_Divide,
        C_Clkout1_Divide=> C_Clkout1_Divide,
        C_Clkout2_Divide=> C_Clkout2_Divide,
        C_Clkout3_Divide=> C_Clkout3_Divide,
        C_Clkout4_Divide=> C_Clkout4_Divide
    )
    port map (
        Mmcm_ClkIn1         => ClkIn,       -- in
        Mmcm_ClkIn2         => Low,         -- in
        Mmcm_ClkInSel       => High,        -- in
        Mmcm_ClkFbOut       => IntFbOut,    -- out
        Mmcm_ClkFbIn        => IntFbIn,     -- in
        Mmcm_RstIn          => Rst,         -- in
        Mmcm_EnaIn          => High,        -- in
        Mmcm_SysClk0        => IntRefClk,   -- out -- 200 MHz for IDELAYCTRL, BUFG
        Mmcm_SysClk1        => IntClk0,     -- out -- 160 MHz, 00 phase, needs BUFIO
        Mmcm_SysClk2        => IntClk90,    -- out -- 160 MHz, 90 phase, needs BUFIO 
        Mmcm_SysClk3        => IntClkDiv,   -- out -- 80 MHz, adjustable, BUFG
        Mmcm_SysClk4        => IntClk,      -- out -- 160 MHz, adjustable, BUFG
        Mmcm_SysClk5        => open,        -- out
        Mmcm_SysClk6        => open,        -- out
        Mmcm_Locked         => IntLocked,   -- Out
        Mmcm_PrimRstOut     => IntIdlyCtrlRst, -- out
        Mmcm_RstOut         => IntRstOut,      -- out
        Mmcm_EnaOut         => IntEnaOut,      -- out
        Mmcm_ReadyIn        => IntIdlyCtrlRdy, -- in
        --
        Mmcm_Drp_Di         => LowVec(15 downto 0), -- in [15:0]
        Mmcm_Drp_Addr       => LowVec(6 downto 0), -- in [6:0]
        Mmcm_Drp_We         => Low, -- in 
        Mmcm_Drp_En         => Low, -- in 
        Mmcm_Drp_Clk        => Low, -- in 
        Mmcm_Drp_Do         => open, -- out [15:0]
        Mmcm_Drp_Rdy        => open, -- out 
        --
        Mmcm_PsIncDec       => IntPsIncDec, -- in 
        Mmcm_Psen           => IntPsEna, -- in 
        Mmcm_PsClk          => IntClkDiv, -- in 
        Mmcm_PsDone         => IntPsDone  -- out
    );
-- The data capturing ISERDES are used in DDR/OVERSAMPLE mode need CLK, CLKB, OCLK and OCLKB.
-- The CLKB and OCLKB are the inverted CLK and OCLK clocks. The inversion must be done at the
-- output of the BUFIO, but inside the hierarchical level were it is used
-- (else software goes nuts).
-- In this level the BUFIOs are instantiated and inside "SgmiiRxData" and "MmcmAlignmentIo"
-- the clocks are inverted.
Receiver_I_Bufio_Clk0 : BUFIO port map (I => IntClk0, O => IntClk0Bufio);
Receiver_I_Bufio_Clk90 : BUFIO port map (I => IntClk90, O => IntClk90Bufio);
--
Receiver_I_MmcmAlign : entity work.MmcmAlign
    generic map (
        C_IoSrdsDataWidth => C_IoSrdsDataWidth, --
        C_ClockPattern    => C_ClockPattern  --
    )
    port map (
        Clk0        => IntClk0Bufio, -- in
        Clk90       => IntClk90Bufio, -- in
        Clk         => IntClk, -- in
        ClkDiv      => IntClkDiv, -- in
        Rst         => IntRstOut, -- in
        Ena         => IntEnaOut, -- in
        MmcmLocked  => IntLocked, -- in  
        PsDone      => IntPsDone, -- in  
        PsInc       => IntPsIncDec, -- out 
        PsIce       => IntPsEna, -- out 
        Aligned     => MmcmAlignd -- out
    );
---------------------------------------------------------------------------------------------
Receiver_I_IdlyCtrl : IDELAYCTRL 
    port map (
        RST     => IntIdlyCtrlRst,
        REFCLK  => IntRefClk,
        RDY     => IntIdlyCtrlRdy
    );
---------------------------------------------------------------------------------------------
end ClockInfrastructure_struct;
--