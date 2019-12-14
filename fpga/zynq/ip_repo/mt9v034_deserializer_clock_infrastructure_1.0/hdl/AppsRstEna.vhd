-----------------------------------------------------------------------------------------------
-- ? Copyright 2011, Xilinx, Inc. All rights reserved.
-- This file contains confidential and proprietary information of Xilinx, Inc. and is
-- protected under U.S. and international copyright and other intellectual property laws.
-----------------------------------------------------------------------------------------------
--
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
--		Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 
--  \   \        Filename: AppsRstEna.vhd
--  /   /        Date Last Modified:	10 Oct 11
-- /___/   /\    Date Created:			22 Feb 08 
-- \   \  /  \
--  \___\/\___\
-- 
-- Device:			Series-7
-- Author:			Marc Defossez
-- Entity Name:		AppsRstEna
-- Purpose: Synchronous reset and enable generation for designs.
--			Reset happens after a programmable delay (not dynamic, code set)
--			When DCM, PLL, or MMCM is stable and operational and when possible used
--			IODELAYCTRL components are stable an delay is enabled.
--			That delay generates a reset for All logic including used IODELAY components.
--			A second delay starts for generating a reset of the IODELAY components.
--			When everything came out of reset an enable is generated.
--
-- 			Virtex-6 SRLC32E components are used.
--
-- Tools:	ISE 13.2.x
-- Limitations: none
--
-- Revision History:
--    Rev. 
--
-----------------------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
---------------------------------------------------------------------------------------------------
--
library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_UNSIGNED.all;
library UNISIM;
	use UNISIM.VCOMPONENTS.all;
-----------------------------------------------------------------------------------------------
-- Entity pin description
-----------------------------------------------------------------------------------------------
--      GENERICS
-- C_PrimRstOutDly -- Delay before the primary reset is relased. Runs on the MMCM input clock.
-- C_UseRstOutDly  -- 1 = use delay. if 0 teh one clock cycle delay. Runs on MMCM output clock. 
-- C_RstOutDly     -- Delay between 0 and 31.
-- C_EnaOutDly     -- After RstOut is relased a delay to activate the enable output.
--      PORTS
-- Rst		    -- Raw system reset.
-- SysClkIn		-- Raw system clock.
-- ExtRst       -- Reset input from somewhere else in the design.
-- ReadyIn      -- Ready input, most of teh time connected to IDEALYCTRL.RDY.
-- ClkIn        -- Clock from a MMCM.
-- PrimRstOut 	-- Primary reset output, Mostly connected to the IDELAYCTRL reset input.
-- RstOut   	-- System reset synchronous to a MMCM output clock
-- EnaOut		-- System enable synchronous to a MMCM output clock 
-----------------------------------------------------------------------------------------------
entity AppsRstEna is
    generic (
        C_PrimRstOutDly : integer := 2;
        C_UseRstOutDly : integer := 1;
        C_RstOutDly : integer := 6;
        C_EnaOutDly : integer := 6
    );
    port (
        Locked      : in std_logic;
        Rst 		: in std_logic;
        SysClkIn	: in std_logic;
        ExtRst      : in std_logic;
        ReadyIn     : in std_logic;
        ClkIn       : in std_logic;
        PrimRstOut	: out std_logic;
        RstOut  	: out std_logic;
        EnaOut		: out std_logic
    );
end AppsRstEna;
-----------------------------------------------------------------------------------------------
-- Arcitecture section
-----------------------------------------------------------------------------------------------
architecture AppsRstEna_struct of AppsRstEna  is
-----------------------------------------------------------------------------------------------
-- Component Instantiation
-----------------------------------------------------------------------------------------------
-- Components come from Xilinx Unisim labraries.
-----------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
-----------------------------------------------------------------------------------------------
-- Functions
-- Constants
constant Low  : std_logic	:= '0';
constant High : std_logic	:= '1';
-- Signals
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of AppsRstEna_struct : architecture is "YES";
-----------------------------------------------------------------------------------------------
begin
--
AppsRstEna_I_AppsRst : entity work.AppsRst
    generic map (C_AppsRstDly => C_PrimRstOutDly)
    port map (
        ClkIn     => SysClkIn,  -- in
        Locked    => Locked,    -- in
        Rst       => Rst,       -- in
        PrimRstOut => PrimRstOut -- out
    );
--
AppsRstEna_I_LocalRstEna : entity work.LocalRstEna
    generic map (
        C_LocalUseRstDly => C_UseRstOutDly,
        C_LocalRstDly => C_RstOutDly,
        C_LocalEnaDly => C_EnaOutDly
    )
    port map (
        ClkIn     => ClkIn,     -- in
        Ena       => ReadyIn,   -- in
        Rst       => ExtRst,    -- in
        RstOut    => RstOut,    -- out
        EnaOut    => EnaOut     -- out
    );
-----------------------------------------------------------------------------------------------
end  AppsRstEna_struct;
--