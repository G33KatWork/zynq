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
-- C_DataWidth     -- Number of LVDS data input channels
-- C_IdlyCntVal_M  -- Set the delay on the LVDS_p input (IDELAY value).
-- C_IdlyCntVal_S  -- Set the delay on the LVDS_n input (IDELAY value).
---------------------------------------------------------------------------------------------
entity Receiver is
    generic (
        C_LaneWidth         : integer := 1;
        C_DataWidth         : integer := 12;
        C_RefClkFreq        : real := 200.00;
        C_IdlyCntVal_M      : std_logic_vector(4 downto 0) := "00000";
        C_IdlyCntVal_S      : std_logic_vector(4 downto 0) := "00101"
    );
	port (
        RxD_p       : in std_logic_vector(C_LaneWidth-1 downto 0);
        RxD_n       : in std_logic_vector(C_LaneWidth-1 downto 0);
        
        ResetFromClkManager  : in std_logic;
        EnableFromClkManager : in std_logic;
        
        RxClk       : in std_logic;
        RxClkDiv    : in std_logic;
        Clk0Bufio   : in std_logic;
        Clk90Bufio  : in std_logic;
        
        RxDataClk   : out std_logic;
        RxDataRdy   : out std_logic_vector(C_LaneWidth-1 downto 0);
        RxData      : out std_logic_vector((C_LaneWidth*C_DataWidth)-1 downto 0);
        RxDataLocked: out std_logic_vector(C_LaneWidth-1 downto 0)
	);
end Receiver;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture Receiver_struct of Receiver is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
-- Constants
-- Signals
signal IntRxDataToDru   : std_logic_vector((C_LaneWidth*8)-1 downto 0);
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of Receiver_struct : architecture is "YES";
attribute MAXDELAY : string;
    attribute MAXDELAY of IntRxDataToDru : signal is "2300ps";
---------------------------------------------------------------------------------------------
begin
--
RxDataClk <= RxClkDiv;
---------------------------------------------------------------------------------------------
-- Data reception and recovery
--------------------------------------------------------------------------------------------- 
Gen_1 : for n in 1 to C_LaneWidth generate
    Receiver_I_SgmiiRxData : entity work.SgmiiRxData
        generic map (
            C_RefClkFreq    => C_RefClkFreq,
            C_IdlyCntVal_M  => C_IdlyCntVal_M,
            C_IdlyCntVal_S  => C_IdlyCntVal_S
        )
        port map (
            RxD_p       => RxD_p(n-1),  -- in
            RxD_n       => RxD_n(n-1),  -- in
            Clk0        => Clk0Bufio,   -- in
            Clk90       => Clk90Bufio,  -- in
            ClkDiv      => RxClkDiv, -- in
            Rst         => ResetFromClkManager, -- in
            Ena         => EnableFromClkManager, -- in
            IsrdsRxData => IntRxDataToDru((n*8)-1 downto (n*8)-8) -- out [7:0]
        );
    --
    Receiver_I_Dru : entity work.Dru
        generic map (
            C_DataWidth     => C_DataWidth
        )
        port map (
            CLK     => RxClk,      -- in
            CLKP    => RxClkDiv,   -- in
            I       => IntRxDataToDru((n*8)-1 downto (n*8)-8), -- out [7:0], -- in [7:0]
            O       => RxData((n*C_DataWidth)-1 downto (n*C_DataWidth)-C_DataWidth), -- out [11:0]
            VO      => RxDataRdy(n-1),  -- out
            LOCKED  => RxDataLocked(n-1) -- out
        );
end generate Gen_1;
---------------------------------------------------------------------------------------------
end Receiver_struct;
--
