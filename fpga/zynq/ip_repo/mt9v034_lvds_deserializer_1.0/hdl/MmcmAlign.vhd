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
-- Device:              
-- Author:              defossez
-- Entity Name:         MmcmAlign
-- Purpose:             Container for MmcmAlignIo and MmcmAlignSm
-- Tools:               ISE_13.3
-- Limitations:         none
--
-- Vendor:              Xilinx Inc.
-- Version:             0.01
-- Filename:            MmcmAlign.vhd
-- Date Created:        6 July, 2011
-- Date Last Modified:  16 December, 2011
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
--  Rev. 16 December 2011
--      FFs adapted in lower layers.
--  Rev. 10 Jan 2012
--      Removed external connection of the sampled clock data.
--      made alignment state machine obey to generics.
---------------------------------------------------------------------------------------------
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
entity MmcmAlign is
    generic (
        C_IoSrdsDataWidth : integer := 4;
        -- The width of this pattern is equal to: C_IoSrdsDataWidth-1:0
        C_ClockPattern : std_logic_vector(3 downto 0) := "1010"
    );
    port (
        Clk0        : in std_logic;
        Clk90       : in std_logic;
        Clk         : in std_logic;
        ClkDiv      : in std_logic;
        Rst         : in std_logic;
        Ena         : in std_logic;
        MmcmLocked  : in  std_logic;
        PsDone      : in  std_logic;
        PsInc       : out std_logic;
        PsIce       : out std_logic;
        Aligned     : out std_logic
    );
end MmcmAlign;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture MmcmAlign_struct of MmcmAlign is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
-- Constants
constant Low  : std_logic	:= '0';
constant High : std_logic	:= '1';
-- Signals
signal IntClkDataSmpl : std_logic_vector(C_IosrdsDataWidth-1 downto 0);
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of MmcmAlign_struct : architecture is "YES";
---------------------------------------------------------------------------------------------
begin
--
MmcmAlign_I_MmcmAlignSm : entity work.MmcmAlignSm
    generic map (
        C_IoSrdsDataWidth => C_IoSrdsDataWidth, --
        C_ClockPattern    => C_ClockPattern  --
    )
    port map (
        ClkDiv      => ClkDiv, -- in  
        Rst         => Rst, -- in  
        MmcmLocked  => MmcmLocked, -- in  
        ClkSmpld    => IntClkDataSmpl, -- in [3:0]
        PsDone      => PsDone, -- in  
        PsInc       => PsInc, -- out 
        PsIce       => PsIce, -- out 
        Aligned     => Aligned -- out 
    );
-- This hierarchical block contains an OSERDES and ISERDES, both in NETWORKING-DDR mode.
-- The OSERDES transmits a clock pattern that is received by the ISERDES per the internal
-- OFB net. This way it is possible to tune the MMCM, per phase shift, so that the clocks
-- used for the data capturing ISERDES are running in phase with teh internal logic of the
-- PHY and DRU. 
-- Reason for doing this:
--      ISERDES used in oversampling mode require fast bit clocks (CLK and OCLK).
--      These clock can only be routed to the ISERDES via a BUFIO clock buffer (instantiated
--      with the MMCM above).
--      This buffer can only clock the IOI (ISERDES, OSERDES), thus for clocking of the FPGA
--      logic other outputs of the MMCM need to be used. because these clocks take other
--      routing resources in the FPGA (are no longer phase aligned) a state machine must make
--      sure all clocks get again phase aligned. 
MmcmAlign_I_MmcmAlignIo : entity work.MmcmAlignIo
    generic map (
        C_IoSrdsDataWidth => C_IoSrdsDataWidth, --
        C_ClockPattern    => C_ClockPattern  --
    )
    port map (
        Clk0          => Clk0, -- in
        Clk90         => Clk90, -- in
        Clk           => Clk, -- in
        ClkDiv        => ClkDiv, -- in
        Rst           => Rst, -- in
        Ena           => Ena, -- in
        ClkDataSmpl   => IntClkDataSmpl -- out [C_IosrdsDataWidth-1:0]
    );
-- At implementation of this block, MAP provides a set of warnings about BUFIO and BUFR.
-- This is the warning:
--      WARNING:PhysDesignRules:2240 - The MMCME2_ADV block <Receiver_Toplevel_I_Receiver/
--      Receiver_I_GenClockMod/RxGenClockMod_I_Mmcm_Adv> has CLKOUT pins that do not drive the
--      same kind of BUFFER load. Routing from the different buffer types will not be phase
--      aligned. 
--      WARNING:PhysDesignRules:2455 - Unsupported clocking topology used for ISERDESE2
--      <Receiver_Toplevel_I_Receiver/Receiver_I_MmcmAlignIo/MmcmAlignIo_I_Isrdse2_Clk>.
--      This can result in corrupted data. The CLK / CLKDIV pins should be driven by the
--      same source through the same buffer type or by a BUFIO / BUFR combination in order
--      to have a proper phase relationship. Please refer to the Select I/O User Guide for
--      supported clocking topologies of the chosen INTERFACE_TYPE mode.
-- The warnings can safely be ignored since all clocks are phase aligned by phase shifting
-- "IntClk" and "IntClkDiv" within the MMCM.
--
---------------------------------------------------------------------------------------------
end MmcmAlign_struct;
