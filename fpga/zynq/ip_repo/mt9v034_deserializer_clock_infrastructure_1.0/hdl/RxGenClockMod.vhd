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
-- Device:              Series-7
-- Author:              defossez
-- Entity Name:         RxGenClockMod
-- Purpose:             Clock generation for a SGMII Receiver.
--
-- MMCM frequency calculations
-- Input frequency: 125 MHz
-- Component: Kintex    -2 or -3 (These speed grades are strongly recomended for this design).
--                      -1 needs special care. The numbers that work for this speed grade are
--                          mentionned between [ ] brackets.
--                          Read also comments about -1 speed grade between [ ] brackets.
--        Fin_min     = 10 MHz
--        Fin_max     = 933 MHz [800]
--        Fvco_min    = 600 MHz
--        Fvco_max    = 1440 MHz [1200]
--        Fout_min    = 4.69 Mhz 
--        Fout_max    = 933 MHz [800]
--        Fpfd_min    = 10 MHz 
--        Fpfd_max    = 500 MHz [450] (Bandwidth set to High or Optimized.)
--        
--        Dmin = rndup Fin/Fpfd_max               => 1 <==
--        Dmax = Rnddwn Fin/Fpfd_min              => 12 
--        Mmin = (rndup Fvco_min/Fin) * Dmin      => 5
--        Mmax = rnddwn ((Dmax * Fvco_max)/Fin)   => 138 [115.5]
--        Mideal = (Dmin * Fvco_max) / Fin        => 11.52 [9.6] <==
--              Fvco must be maximized for best functioning of the VCO.
--              For easy calculation and use, the multiply factor will be taken
--              as a integer value close to the ideal multiplier setting the VCO
--              frequency as high as possible.
--              M is taken as 10, then Fvco is 1250 MHz (12 as M is too high, 1500 MHz)
--            [ For a -1, Fvcomax is 1200 MHz, this is too low when M = 10 and D = 1. ]
--            [ There is no ferquency other than 625 MMHz at which the VCO can run were ]
--            [ it is possible to use integer values for the counter dividers in the MMCM ]
--            [ clock outputs. the value for M remains is therefore reduced to 5. ]
--
--        Fvco = Fin * M/D          125 x 10/1  => 1250
--                                  [125 x 5/1  => 625]
--        Fout = Fin * M/D*O        Fout_Clk0  => D = 4.0322  ==> 310 MHz IDELAYCTRL ref clock.
--                                [ Fout_Clk0  => D = 3.125   ==> 200 MHz IDELAYCTRL ref clock. ]
--                                  Fout_Clk1  => D = 2 [1]    ==> 625 MHz  
--                                  Fout_Clk2  => D = 2 [1]    ==> 625 MHz
--                                  Fout_Clk3  => D = 4 [2]    ==> 312.5 MHz
--                                  Fout_Clk4  => D = 2 [1]    ==> 625 MHz
--                                  Fout_Clk5  => D = 4        |
--                                  Fout_Clk6  => D = 4        |==> Not Used
--
-- CLKOUT0 is used for the reference clock of the IDELAYCTRL component.
-- When the reference clock is set to 200 Mhz the tap delay is 78ps, when the clock is set
-- to 300 MHZ the tap delay is 52ps. The clock precission must be +- 10MHz.
-- The clock for the IDLEAYCTRL block can thus be set at 310MHz.
-- [ -1 speed grade                                                                         ]
-- [ CLKOUT0 is here also used as reference clock of the IDELAYCTRL component.              ]
-- [ The IDELAYCTRL in a -1 component cannot run at 310 MHz. The maximal speed is 200 MHz.  ]
-- [ Therefore the division factor 'D' of CLKOUT0 is set to 3.125.                          ]
-- 
-- Clock output 1 and 2 are used to generate 90-degrees shifted 625 MHz clocks.
--
-- Outputs 3 and 4 are used in FINE PHASE SHIFT mode (..._USE_FINE_PS = TRUE).
--
-- Because the reference clock, CLKOUT0, is now 312.5 MHz the "LifeIndicator", ""TimeTick", and
-- "AppsRstEna" circuits are running on this clock frequency.
-----------------------------------------------------------------------------------------------
-- Tools:               ISE_13.2
-- Limitations:         none
--
-- Vendor:              Xilinx Inc.
-- Version:             0.01
-- Filename:            RxGenClockMod.vhd
-- Date Created:        02 September, 2011
-- Date Last Modified:  02 September, 2011
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
--  Rev. 10 Oct 2011
--      Neede to put teh common used components between the clock design of the transmitter
--      and the reciever in a common library. This due the fact that the ISE tool went nuts
--      when finding files with teh same name in different directories of the design.
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
library UNISIM;
	use UNISIM.vcomponents.all;
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
--      GENERICS
--  C_GenMmcmLoc    : Location constraint for the MMCM
--  C_UseFbBufg     : '1' = use a BUFG in the feedback loop.
--  C_UseBufg       : A '1' in the vector = Use BUFG in the clock paths.
--                  : std_logic_vector(5 downto 0), 5 = ClkOut5 & 0 = ClkOut0
-- -- Reset and enable stuff
-- C_PrimRstOutDly : Delay on the primary reset, most of the time used for the IDELAYCTRL.RST  
-- C_UseRstOutDly  : Use a delay on the reset synchronous to a MMCM clock?
-- C_RstOutDly     : The delay that the above enable reset gets.
-- C_EnaOutDly     : After the reset is released, teh delay of the enable.
--      PORTS
--  Mmcm_ClkIn1     : MMCM clock input.
--  Mmcm_ClkIn2     : MMCM clock input.
--  Mmcm_ClkInSel   : MMCM clock input.
--
--  Mmcm_ClkFbOut   : MMCM Feedback output, can be internal teh FPGA but can also be on the PCB.
--  Mmcm_ClkFbIn    : MMCM feedback input, When from external a IBUFG is needed.
--
--  Mmcm_RstIn      : Sysyem reset input.
--  Mmcm_EnaIn      : Enable input, let the system start.

--  Mmcm_SysClk0    : Clock 0 output
--  Mmcm_SysClk1    : Clock 1 output
--  Mmcm_SysClk2    : Clock 2 output
--  Mmcm_SysClk3    : Clock 3 output 
--  Mmcm_SysClk4    : Clock 4 output 
--  Mmcm_SysClk5    : Clock 5 output |==> Not Used Here
--  Mmcm_SysClk5    : Clock 6 output |
--
--  Mmcm_PrimRstOut : 'x' clock cycles after the MMCM is locked this reset will be released
--  Mmcm_RstOut     : 'x' clock cycles after external events this reset will be released
--  Mmcm_EnaOut     : 'x' clcok cycles after above reset is release this enable will go active.
--  Mmcm_ReadyIn    : input from IDELAYCTRL.RDY
--
--  Mmcm_Drp_Di     : DRP port
--  Mmcm_Drp_Addr   : DRP port
--  Mmcm_Drp_We     : DRP port
--  Mmcm_Drp_En     : DRP port
--  Mmcm_Drp_Clk    : DRP port
--  Mmcm_Drp_Do     : DRP port
--  Mmcm_Drp_Rdy    : DRP port
--
--  Mmcm_PsIncDec   : Phase shift of the MMCM
--  Mmcm_Psen       : Phase shift of the MMCM
--  Mmcm_PsClk      : Phase shift of the MMCM
--  Mmcm_PsDone     : Phase shift of the MMCM
--
--  Mmcm_TimeTick_Fast  : Pulsing output followin a 1/2 second rate
--  Mmcm_TimeTick_Slow  : Pulsing output folling a sec rate.
-----------------------------------------------------------------------------------------------
entity RxGenClockMod is
    generic (
        -- MMCM related stuff
        C_AppsMmcmLoc   : string;
        C_UseFbBufg     : integer := 0;
        C_UseBufg       : std_logic_vector(6 downto 0) := "0011001"; -- "0011001";
        -- Reset and enable stuff
        C_PrimRstOutDly : integer := 2;
        C_UseRstOutDly  : integer := 1;
        C_RstOutDly     : integer := 6;
        C_EnaOutDly     : integer := 8;
        -- Main clock config
        C_ClkinPeriod   : real    := 10.0;
        C_DivClkDivide  : integer := 1;
        C_ClkFboutMult  : real    := 8.0;
        -- Clock output config
        C_Clkout0_Divide: real    := 4.0;
        C_Clkout1_Divide: integer := 5;
        C_Clkout2_Divide: integer := 5;
        C_Clkout3_Divide: integer := 10;
        C_Clkout4_Divide: integer := 5
                
    );
    port (
        Mmcm_ClkIn1         : in std_logic;
        Mmcm_ClkIn2         : in std_logic;
        Mmcm_ClkInSel       : in std_logic;
        Mmcm_ClkFbOut       : out std_Logic;
        Mmcm_ClkFbIn        : in std_Logic;
        Mmcm_RstIn          : in std_Logic;
        Mmcm_EnaIn          : in std_Logic;
        Mmcm_SysClk0        : out std_logic;
        Mmcm_SysClk1        : out std_logic;
        Mmcm_SysClk2        : out std_logic;
        Mmcm_SysClk3        : out std_logic;
        Mmcm_SysClk4        : out std_logic;
        Mmcm_SysClk5        : out std_logic;
        Mmcm_SysClk6        : out std_logic;
        Mmcm_Locked         : out std_logic;
        Mmcm_PrimRstOut     : out std_Logic;
        Mmcm_RstOut         : out std_logic;
        Mmcm_EnaOut         : out std_logic;
        Mmcm_ReadyIn        : in std_Logic;
        --
        Mmcm_Drp_Di         : in std_logic_vector(15 downto 0);
        Mmcm_Drp_Addr       : in std_logic_vector(6 downto 0);
        Mmcm_Drp_We         : in std_logic;
        Mmcm_Drp_En         : in std_logic;
        Mmcm_Drp_Clk        : in std_logic;
        Mmcm_Drp_Do         : out std_logic_vector(15 downto 0);
        Mmcm_Drp_Rdy        : out std_logic;
        --
        Mmcm_PsIncDec       : in std_logic;
        Mmcm_Psen           : in std_logic;
        Mmcm_PsClk          : in std_logic;
        Mmcm_PsDone         : out std_logic
    );
end entity RxGenClockMod;
-----------------------------------------------------------------------------------------------
-- Architecture section
-----------------------------------------------------------------------------------------------
architecture RxGenClockMod_struct of RxGenClockMod is
-----------------------------------------------------------------------------------------------
-- Component Instantiation
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
-----------------------------------------------------------------------------------------------
-- Functions
-- Constants
constant Low  : std_logic   := '0';
constant High : std_logic   := '1';
-- Signals
signal IntMmcm_Bufg_SysClk      : std_logic_vector(6 downto 0);
signal IntMmcm_Bufg_ClkFbOut    : std_logic;
signal IntMmcm_SysClk   : std_logic_vector(6 downto 0);
signal IntMmcm_ClkFbOut : std_logic;
signal IntMmcm_Locked   : std_logic;
signal IntMmcm_EnaOut   : std_logic;
signal IntMmcm_RstOut   : std_logic;
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of RxgenClockMod_struct : architecture is "YES";
attribute LOC : string;
    attribute LOC of RxGenClockMod_I_Mmcm_Adv : label is C_AppsMmcmLoc;
-----------------------------------------------------------------------------------------------
begin
-----------------------------------------------------------------------------------------------
RxGenClockMod_I_Mmcm_Adv : MMCME2_ADV
    generic map (
        BANDWIDTH               => "OPTIMIZED", -- string
        CLKIN1_PERIOD           => C_ClkinPeriod,-- real
        CLKIN2_PERIOD           => 0.0,         -- real
        REF_JITTER1             => 0.010,       -- real
        REF_JITTER2             => 0.0,         -- real
        DIVCLK_DIVIDE           => C_DivClkDivide,-- integer
        CLKFBOUT_MULT_F         => C_ClkFboutMult,-- real
        CLKFBOUT_PHASE          => 0.0,         -- real
        CLKFBOUT_USE_FINE_PS    => FALSE,       -- boolean
        CLKOUT0_DIVIDE_F        => C_Clkout0_Divide,-- real
        CLKOUT0_DUTY_CYCLE      => 0.5,         -- real
        CLKOUT0_PHASE           => 0.0,         -- real
        CLKOUT0_USE_FINE_PS     => FALSE,       -- boolean
        CLKOUT1_DIVIDE          => C_Clkout1_Divide,-- integer
        CLKOUT1_DUTY_CYCLE      => 0.5,         -- real
        CLKOUT1_PHASE           => 0.0,         -- real
        CLKOUT1_USE_FINE_PS     => FALSE,       -- boolean
        CLKOUT2_DIVIDE          => C_Clkout2_Divide,-- integer
        CLKOUT2_DUTY_CYCLE      => 0.5,         -- real
        CLKOUT2_PHASE           => 90.000,      -- real  --
        CLKOUT2_USE_FINE_PS     => FALSE,       -- boolean
        CLKOUT3_DIVIDE          => C_Clkout3_Divide,-- integer
        CLKOUT3_DUTY_CYCLE      => 0.5,         -- real
        CLKOUT3_PHASE           => 0.0,         -- real
        CLKOUT3_USE_FINE_PS     => TRUE,        -- boolean  --
        CLKOUT4_CASCADE         => FALSE,       -- boolean
        CLKOUT4_DIVIDE          => C_Clkout4_Divide,-- integer
        CLKOUT4_DUTY_CYCLE      => 0.5,         -- real
        CLKOUT4_PHASE           => 0.0,         -- real
        CLKOUT4_USE_FINE_PS     => TRUE,        -- boolean  --
        CLKOUT5_DIVIDE          => 4,           -- integer
        CLKOUT5_DUTY_CYCLE      => 0.5,         -- real
        CLKOUT5_PHASE           => 0.0,         -- real
        CLKOUT5_USE_FINE_PS     => FALSE,       -- boolean
        CLKOUT6_DIVIDE          => 4,           -- integer
        CLKOUT6_DUTY_CYCLE      => 0.5,         -- real
        CLKOUT6_PHASE           => 0.0,         -- real
        CLKOUT6_USE_FINE_PS     => FALSE,       -- boolean
        COMPENSATION            => "ZHOLD",     -- string
        STARTUP_WAIT            => FALSE        -- boolean
    )
    port map (
        CLKIN1          => Mmcm_ClkIn1,             -- in
        CLKIN2          => Mmcm_ClkIn2,             -- in
        CLKINSEL        => Mmcm_ClkInSel,           -- in
        CLKFBIN         => Mmcm_ClkFbIn,            -- in
        CLKOUT0         => IntMmcm_Bufg_SysClk(0),  -- out
        CLKOUT0B        => open,                    -- out
        CLKOUT1         => IntMmcm_Bufg_SysClk(1),  -- out
        CLKOUT1B        => open,                    -- out
        CLKOUT2         => IntMmcm_Bufg_SysClk(2),  -- out
        CLKOUT2B        => open,                    -- out
        CLKOUT3         => IntMmcm_Bufg_SysClk(3),  -- out
        CLKOUT3B        => open,                    -- out
        CLKOUT4         => IntMmcm_Bufg_SysClk(4),  -- out
        CLKOUT5         => IntMmcm_Bufg_SysClk(5),  -- out
        CLKOUT6         => IntMmcm_Bufg_SysClk(6),  -- out
        CLKFBOUT        => IntMmcm_Bufg_ClkFbOut,   -- out
        CLKFBOUTB       => open,                    -- out
        CLKINSTOPPED    => open,                    -- out
        CLKFBSTOPPED    => open,                    -- out
        LOCKED          => IntMmcm_Locked,          -- out
        PWRDWN          => Low,             -- in
        RST             => Mmcm_RstIn,      -- in
        DI              => Mmcm_Drp_Di,     -- in
        DADDR           => Mmcm_Drp_Addr,   -- in
        DCLK            => Mmcm_Drp_Clk,    -- in
        DEN             => Mmcm_Drp_En,     -- in
        DWE             => Mmcm_Drp_We,     -- in
        DO              => Mmcm_Drp_Do,     -- out
        DRDY            => Mmcm_Drp_Rdy,    -- out
        PSINCDEC        => Mmcm_PsIncDec,   -- in
        PSEN            => Mmcm_PsEn,       -- in
        PSCLK           => Mmcm_PsClk,      -- in
        PSDONE          => Mmcm_PsDone      -- out
    );
-----------------------------------------------------------------------------------------------
Gen_1 : for n in 0 to 6 generate
    Gen_10 : if C_UseBufg(n) = '0' generate
        IntMmcm_SysClk(n) <= IntMmcm_Bufg_SysClk(n);
    end generate Gen_10;
    Gen_11 : if C_UseBufg(n) = '1' generate
        RxGenClockMod_I_Bufg_Clk :
                    BUFG port map (I => IntMmcm_Bufg_SysClk(n), O => IntMmcm_SysClk(n));    
    end generate Gen_11;
end generate Gen_1;
--
Gen_2 : if C_UseFbBufg = 0 generate
    IntMmcm_ClkFbOut <= IntMmcm_Bufg_ClkFbOut;
end generate Gen_2;
--
Gen_3 : if C_UseFbBufg = 1 generate
    RxGenClockMod_I_Bufg_ClkFbOut :
            BUFG port map (I => IntMmcm_Bufg_ClkFbOut, O => IntMmcm_ClkFbOut);
end generate Gen_3;
--
Mmcm_SysClk0 <= IntMmcm_SysClk(0);
Mmcm_SysClk1 <= IntMmcm_SysClk(1);
Mmcm_SysClk2 <= IntMmcm_SysClk(2);
Mmcm_SysClk3 <= IntMmcm_SysClk(3);
Mmcm_SysClk4 <= IntMmcm_SysClk(4);
Mmcm_SysClk5 <= IntMmcm_SysClk(5);
Mmcm_SysClk6 <= IntMmcm_SysClk(6);
Mmcm_ClkFbOut <= IntMmcm_ClkFbOut;
Mmcm_Locked <= IntMmcm_Locked;
-----------------------------------------------------------------------------------------------
RxGenClockMod_I_AppsRstEna : entity work.AppsRstEna
    generic map (
        C_PrimRstOutDly => C_PrimRstOutDly,
        C_UseRstOutDly  => C_UseRstOutDly,
        C_RstOutDly     => C_RstOutDly,
        C_EnaOutDly     => C_EnaOutDly
    )
    port map (
        Locked      => IntMmcm_Locked,      -- in
        Rst         => Mmcm_RstIn,          -- in
        SysClkIn    => Mmcm_ClkIn1,         -- in -- When CLKIN2 is used modify this line.
        ExtRst      => Low,                 -- in
        ReadyIn     => Mmcm_ReadyIn,        -- in
        ClkIn       => IntMmcm_SysClk(3),   -- in -- Clocked at 312.5 MHz - CLKDIV
        PrimRstOut  => Mmcm_PrimRstOut,     -- out
        RstOut      => IntMmcm_RstOut,      -- out
        EnaOut      => IntMmcm_EnaOut       -- out
    );
Mmcm_RstOut <= IntMmcm_RstOut;
Mmcm_EnaOut <= IntMmcm_EnaOut;
---------------------------------------------------------------------------------------------
end RxGenClockMod_struct;
--