---------------------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /   
-- \   \   \/    ?? Copyright 2011 Xilinx, Inc. All rights reserved.
--  \   \        This file contains confidential and proprietary information of Xilinx, Inc.
--  /   /        and is protected under U.S. and international copyright and other
-- /___/   /\    intellectual property laws.
-- \   \  /  \    
--  \___\/\___\ 
-- 
---------------------------------------------------------------------------------------------
-- Device:              7-Series
-- Author:              defossez
-- Entity Name:         Receiver
-- Purpose:             toplevel of a 4x oversample design that can be used for SGMII purposes.
--                      This design can be used in all speed grades but it is strongly 
--                      adviced to use -2 or -3 components. In case a -1 component is 
--                      needed, please read the comments in the source code of:
--                      .\SgmiiReceiver\Libraries\SgmiiRxClock_Lib\Vhdl\RxGenClockMod.vhd.
--
--                      These sub-designs are needed for this design:
--                      .\Libraries\MmcmAlignment_Lib\MmcmAlign.vhd
--                      .\Libraries\MmcmAlignment_Lib\MmcmAlignIo.vhd
--                      .\Libraries\MmcmAlignment_Lib\MmcmAlignSm.vhd
--                      .\Libraries\SgmiiRxClock_Lib\RxGenClockMod.vhd
--                      .\Libraries\SgmiiRxData_Lib\SgmiiRxData.vhd
--                      The file below is only for test purposes. Normally, in stead of this file
--                      a real design is used. Therefore this file is introduced in the deisgn 
--                      inplementation at the top level implementation.
--                      .\Libraries\SgmiiRxPrbs_Lib\SgmiiRxPrbs.vhd
--
-- Tools:               ISE_13.3 or later.
-- Limitations:         none
--
-- Vendor:              Xilinx Inc.
-- Version:              
-- Filename:            Receiver.vhd
-- Date Created:        01 September, 2011
-- Date Last Modified:  05 September, 2011
---------------------------------------------------------------------------------------------
-- Disclaimer:
--		This disclaimer is not a license and does not grant any rights to the materials
--		distributed herewith. Except as otherwise provided in a valid license issued to you
--		by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
--		ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
--		WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
--		TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
--		PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
--		negligence, or under any other theory of liability) for any loss or damage of any
--		kind or nature related to, arising under or in connection with these materials,
--		including for any direct, or any indirect, special, incidental, or consequential
--		loss or damage (including loss of data, profits, goodwill, or any type of loss or
--		damage suffered as a result of any action brought by a third party) even if such
--		damage or loss was reasonably foreseeable or Xilinx had been advised of the
--		possibility of the same.
--
-- CRITICAL APPLICATIONS
--		Xilinx products are not designed or intended to be fail-safe, or for use in any
--		application requiring fail-safe performance, such as life-support or safety devices
--		or systems, Class III medical devices, nuclear facilities, applications related to
--		the deployment of airbags, or any other applications that could lead to death,
--		personal injury, or severe property or environmental damage (individually and
--		collectively, "Critical Applications"). Customer assumes the sole risk and
--		liability of any use of Xilinx products in Critical Applications, subject only to
--		applicable laws and regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 
--
-- Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
---------------------------------------------------------------------------------------------
-- Revision History:
--  Rev. 08 Dec 2011
--      Added comments to the code in order to make it selfexplanatory.
--      Commented the BUFIO and the MmcmAlignIO block.
------------------------------------------------------------------------------
-- Naming Conventions:
--  Generics start with:                        "C_*"
--  Ports
--      All words in the label of a port name start with a upper case, AnInputPort.
--      Active low ports end in                             "*_n"
--      Active high ports of a differential pair end in:    "*_p"
--      Ports being device pins end in _pin                 "*_pin"
--      Reset ports end in:                                 "*Rst"
--      Enable ports end in:                                "*Ena", "*En"
--      Clock ports end in:                                 "*Clk", "ClkDiv", "*Clk#"
--  Signals and constants
--      Signals and constant labels start with              "Int*"
--      Registered signals end in                           "_d#"
--      User defined types:                                 "*_TYPE"
--      State machine next state:                           "*_Ns"
--      State machine current state:                        "*_Cs"
--      Counter signals end in:                             "*Cnt", "*Cnt_n"
--   Processes:                                 "<Entity_><Function>_PROCESS"
--   Component instantiations:                  "<Entity>_I_<Component>_<Function>"
---------------------------------------------------------------------------------------------
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
-- C_Width         -- Number of inputs for the "MmcmAlive" circuit. = Numer of LED.
-- C_AlifeFactor   -- Blinking rate. 
-- C_AlifeOn       -- What input, set by C_Width, must have a blink circuit? 1 = blink.
-- C_DataWidth     -- Number of LVDS data input channels
-- C_BufioClk0Loc  -- Fix location of the BUFIO passing the non-inverted 625Mhz clock.
-- C_BufioClk90Loc  -- Fix location of the BUFIO passing the inverted 625Mhz clock.
-- C_IdlyCtrlLoc   -- Where goes the IDLEAYCTRL component
-- C_IdlyCntVal_M  -- Set the delay on the LVDS_p input (IDELAY value).
-- C_IdlyCntVal_S  -- Set the delay on the LVDS_n input (IDELAY value).
-- C_RefClkFreq    -- Set the reference frequency of the IDLEAY components, precission.
--                 -- Clock Alignment, Clock Domain Crossing, settings 
-- C_IoSrdsDataWidth   -- Number of OSERDES inputs and ISERDES outputs. (4 or 8)
-- C_ClockPattern      -- Clock pattern to generate. Depend the C_IoSerdesDataWidth.
---------------------------------------------------------------------------------------------
entity Receiver is
    generic (
        C_MmcmLoc           : string := "MMCME2_ADV_X0Y0";
        C_UseFbBufg         : integer := 0;
        C_UseBufg           : std_logic_vector(6 downto 0) := "0011001";
        C_RstOutDly         : integer := 2;
        C_EnaOutDly         : integer := 6;
        C_Width             : integer := 1;
        C_AlifeFactor       : integer := 5;
        C_AlifeOn           : std_logic_vector(7 downto 0) := "00000001";
        C_DataWidth         : integer := 1;
        C_BufioClk0Loc      : string := "BUFIO_X0Y0";
        C_BufioClk90Loc     : string := "BUFIO_X0Y1";
        C_IdlyCtrlLoc       : string := "IDELAYCTRL_X0Y0";
        C_IdlyCntVal_M      : std_logic_vector(4 downto 0) := "00000";
        C_IdlyCntVal_S      : std_logic_vector(4 downto 0) := "00101";
        C_RefClkFreq        : real := 200.00;
        C_IoSrdsDataWidth   : integer := 4;
        C_ClockPattern      : std_logic_vector(3 downto 0) := "1010"
    );
	port (
        RxD_p       : in std_logic_vector(C_DataWidth-1 downto 0);
        RxD_n       : in std_logic_vector(C_DataWidth-1 downto 0);
        RxClkIn     : in std_logic;
        RxRst       : in std_logic;
        RxClk       : out std_logic;
        RxClkDiv    : out std_logic;
        RxMmcmAlive : out std_logic;
        RxDatAlignd : out std_logic;
        RxDataRdy   : out std_logic_vector(C_DataWidth-1 downto 0);
        RxRawData   : out std_logic_vector((C_DataWidth*8)-1 downto 0);
        RxData      : out std_logic_vector((C_DataWidth*12)-1 downto 0);
        RxDataLocked: out std_logic_vector(C_DataWidth-1 downto 0)
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
constant Low    : std_logic := '0';
constant LowVec : std_logic_vector(31 downto 0) := X"00000000";
constant High   : std_logic := '1';
-- Signals
signal IntFbOut         : std_logic;
signal IntFbIn          : std_logic;
signal IntRefClk        : std_logic; -- 310MHz.
signal IntClk0          : std_logic; -- 625MHz, no phase shift.
signal IntClk90         : std_logic; -- 625Mhz, 90-degrees phase shift.
signal IntClk0Bufio     : std_logic; -- IntClk0 after passthrough BUFIO
signal IntClk90Bufio    : std_logic; -- IntClk90 after passthrough BUFIO
signal IntClk           : std_logic; -- 625Mhz, fine phase shift.
signal IntClkDiv        : std_logic; -- 312.5MHz, fine phase shift.
signal IntLocked        : std_logic;
signal IntIdlyCtrlRst   : std_logic;
signal IntIdlyCtrlRdy   : std_logic_vector(C_DataWidth downto 1);
signal IntRstOut        : std_logic;
signal IntEnaOut        : std_logic;
signal IntPsIncDec      : std_logic;
signal IntPsEna         : std_logic;
signal IntPsDone        : std_logic;
signal IntClkDataSmpl   : std_logic_vector(C_IoSrdsDataWidth-1 downto 0);
signal IntRxDataToDru   : std_logic_vector((C_DataWidth*8)-1 downto 0);
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of Receiver_struct : architecture is "YES";
attribute LOC : string;
        attribute LOC of Receiver_I_Bufio_Clk0 : label is C_BufioClk0Loc;
        attribute LOC of Receiver_I_Bufio_Clk90 : label is C_BufioClk90Loc;
attribute MAXDELAY : string;
    attribute MAXDELAY of IntRxDataToDru : signal is "2300ps";
---------------------------------------------------------------------------------------------
begin
---------------------------------------------------------------------------------------------
-- Data reception and recovery
--------------------------------------------------------------------------------------------- 
Gen_1 : for n in 1 to C_DataWidth generate
    Receiver_I_SgmiiRxData : entity work.SgmiiRxData
        generic map (
            C_IdlyCtrlLoc   => C_IdlyCtrlLoc,
            C_RefClkFreq    => C_RefClkFreq,
            C_IdlyCntVal_M  => C_IdlyCntVal_M,
            C_IdlyCntVal_S  => C_IdlyCntVal_S,
            C_NmbrOfInst    => (n)
        )
        port map (
            RxD_p       => RxD_p(n-1),  -- in
            RxD_n       => RxD_n(n-1),  -- in
            Clk0        => IntClk0Bufio,   -- in
            Clk90       => IntClk90Bufio,  -- in
            ClkDiv      => IntClkDiv, -- in
            Rst         => IntRstOut, -- in
            Ena         => IntEnaOut, -- in
            RefClk      => IntRefClk, -- in
            IdlyCtrlRst => IntIdlyCtrlRst, -- in
            IdlyCtrlRdy => IntIdlyCtrlRdy(n), -- out
            IsrdsRxData => IntRxDataToDru((n*8)-1 downto (n*8)-8) -- out [7:0]
        );
    --
    RxRawData((n*8)-1 downto (n*8)-8) <= IntRxDataToDru((n*8)-1 downto (n*8)-8);
    --
    Receiver_I_Dru : entity work.Dru
        port map (
            CLK     => IntClk,      -- in
            CLKP    => IntClkDiv,   -- in
            I       => IntRxDataToDru((n*8)-1 downto (n*8)-8), -- out [7:0], -- in [7:0]
            O       => RxData((n*12)-1 downto (n*12)-12), -- out [11:0]
            VO      => RxDataRdy(n-1),  -- out
            LOCKED  => RxDataLocked(n-1) -- out
        );
end generate Gen_1;
---------------------------------------------------------------------------------------------
-- Clock generation, adjustment
---------------------------------------------------------------------------------------------
IntFbIn <= IntFbOut;
RxClk <= IntClk;
RxClkDiv <= IntClkDiv;
--
Receiver_I_RxGenClockMod : entity work.RxGenClockMod
    generic map (
        C_AppsMmcmLoc   => C_MmcmLoc,       --
        C_UseFbBufg     => C_UseFbBufg,     --
        C_UseBufg       => C_UseBufg,       --
        C_RstOutDly     => C_RstOutDly,     --
        C_EnaOutDly     => C_EnaOutDly,     --
        C_Width         => C_Width,         --
        C_AlifeFactor   => C_AlifeFactor,   --
        C_AlifeOn       => C_AlifeOn        --
    )
    port map (
        Mmcm_ClkIn1         => RxClkIn,       -- in
        Mmcm_ClkIn2         => Low,         -- in
        Mmcm_ClkInSel       => High,        -- in
        Mmcm_ClkFbOut       => IntFbOut,    -- out
        Mmcm_ClkFbIn        => IntFbIn,     -- in
        Mmcm_RstIn          => RxRst,       -- in
        Mmcm_EnaIn          => High,        -- in
        Mmcm_SysClk0        => IntRefClk,   -- out -- 310 MHz for IDELAYCTRL, BUFG
        Mmcm_SysClk1        => IntClk0,     -- out -- 625 MHz, 00 phase, needs BUFIO
        Mmcm_SysClk2        => IntClk90,    -- out -- 625 MHz, 90 phase, needs BUFIO 
        Mmcm_SysClk3        => IntClkDiv,   -- out -- 312.5 MHz, adjustable, BUFG
        Mmcm_SysClk4        => IntClk,      -- out -- 625 MHz, adjustable, BUFG
        Mmcm_SysClk5        => open,        -- out
        Mmcm_SysClk6        => open,        -- out
        Mmcm_Locked         => IntLocked,   -- Out
        Mmcm_AliveOut       => RxMmcmAlive, -- out
        Mmcm_PrimRstOut     => IntIdlyCtrlRst, -- out
        Mmcm_RstOut         => IntRstOut,      -- out
        Mmcm_EnaOut         => IntEnaOut,      -- out
        Mmcm_ReadyIn        => IntIdlyCtrlRdy(1), -- in
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
        Mmcm_PsDone         => IntPsDone, -- out
        
        Mmcm_TimeTick_Fast  => open, -- out
        Mmcm_TimeTick_Slow  => open -- out
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
        Aligned     => RxDatAlignd -- out
    );
---------------------------------------------------------------------------------------------
end Receiver_struct;
--