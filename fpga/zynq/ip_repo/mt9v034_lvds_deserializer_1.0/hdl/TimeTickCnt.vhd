-----------------------------------------------------------------------------------------------
-- ?? Copyright 2009 - 2011, Xilinx, Inc. All rights reserved.
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
-- /___/  \  /   Vendor:                Xilinx
-- \   \   \/    Version: 
--  \   \        Filename:              TimeTickCnt.vhd
--  /   /        Date Last Modified:    6 Jul 2011
-- /___/   /\    Date Created:          10 Mar 08 
-- \   \  /  \
--  \___\/\___\
-- 
-- Device:      Virtex-6 and Series-7
-- Author:      Marc Defossez
-- Entity Name: TimeTickCnt
-- Purpose:     A kind of counting device to generate time tick pulses
-- Tools:       ISE_13.2 and higher
-- Limitations: none
--
-- Revision History:
--  Rev. 6 Jul 2011
--      Adapted for Virtex-6 and Series-7
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
-----------------------------------------------------------------------------------------------
--
library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_UNSIGNED.all;
library UNISIM;
	use UNISIM.VCOMPONENTS.all;
-----------------------------------------------------------------------------------------------
-- Entity pin description
-----------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------------
entity TimeTickCnt is
    port (
        RefClkIn		: in std_logic;
        TickEna			: in std_logic;
        TickOut_Fast	: out std_logic;
        TickOut_Slow	: out std_logic
    );
end TimeTickCnt;
-----------------------------------------------------------------------------------------------
-- Arcitecture section
-----------------------------------------------------------------------------------------------
architecture TimeTickCnt_struct of TimeTickCnt  is
-----------------------------------------------------------------------------------------------
-- Component Instantiation
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
-----------------------------------------------------------------------------------------------
-- Functions
-- Constants
constant Low  : std_logic	:= '0';
constant High : std_logic	:= '1';
constant SrlFrstAddr	: std_logic_vector (4 downto 0) := "11111"; -- 1F
constant SrlScndAddr	: std_logic_vector (4 downto 0) := "11111";	-- 1F
constant SrlThrdAddr	: std_logic_vector (4 downto 0) := "11111"; -- 1F
constant SrlFrthAddr	: std_logic_vector (4 downto 0) := "00101"; -- 05
constant SrlFfthAddr	: std_logic_vector (4 downto 0) := "00010"; -- 02
-- Signals
signal IntSrlFrstOut	: std_logic;
signal IntSrlScndOut	: std_logic;
signal IntPlsScndOut	: std_logic;
signal IntSrlThrdOut	: std_logic;
signal IntPlsThrdOut	: std_logic;
signal IntSrlFrthOut	: std_logic;
signal IntSrlFfthOut	: std_logic;
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of TimeTickCnt_struct : architecture is "YES";
attribute HBLKNM : string;
--    attribute HBLKNM of TimeTickCnt_I_Srlc32e_Frst : label is "LowMicroSec";
    attribute HBLKNM of TimeTickCnt_I_Srlc32e_Scnd : label is "LowMicroSec";
    attribute HBLKNM of TimeTickCnt_I_GenPulse_One : label is "LowMicroSec";
    --
    attribute HBLKNM of TimeTickCnt_I_Srlc32e_Thrd : label is "HigMicroSec";
    attribute HBLKNM of TimeTickCnt_I_GenPulse_Two : label is "HigMicroSec";
    --
    attribute HBLKNM of TimeTickCnt_I_Srlc32e_Frth : label is "MilliSec";
    attribute HBLKNM of TimeTickCnt_I_GenPulse_Tre : label is "MilliSec";
    attribute HBLKNM of TimeTickCnt_I_Srlc32e_Ffth : label is "MilliSec";
    attribute HBLKNM of TimeTickCnt_I_GenPulse_For : label is "MilliSec";
-----------------------------------------------------------------------------------------------
begin
-----------------------------------------------------------------------------------------------
-- Generate a time tick.
-- Example:
-- The input clock is 200 MHz or 5 ns.
-- The first 32-bit SRL produces an output pulse every 32 clock cycles or every 160 ns
-- The second 32-bit SRL produces then an output pulse every 160 ns x 32 = 5.12 us,
-- The tird 32-bit SRL provides an output pulse every 512 us x 32 = 164 us.
-- The fourth 32-bit SRL must be initialized as below in order to provide a tick approximately
-- every 1 ms.
--		1 ms / 164 us = 6.1
--		Initialize the SRL with as address 5 and as INIT value 00000001 (every 6th bit = high).
--		The output will produce a tick every ~ 1ms (984 us).
--		  
TimeTickCnt_I_Srlc32e_Frst : SRLC32E
	generic map (INIT => X"00000001")
	port map (D => IntSrlFrstOut, CE => High, CLK => RefClkIn, A => SrlFrstAddr,
			Q31 => open, Q => IntSrlFrstOut);
--
TimeTickCnt_I_Srlc32e_Scnd : SRLC32E
	generic map (INIT => X"00000001")
	port map (D => IntSrlScndOut, CE => IntSrlFrstOut, CLK => RefClkIn, A => SrlScndAddr,
			Q31 => open, Q => IntSrlScndOut);
--
TimeTickCnt_I_GenPulse_One : entity work.GenPulse
    port map (SigIn => IntSrlScndOut, Clk => RefClkIn, Ena => High, SigOut => IntPlsScndOut);
-----------------------------------------------------------------------------------------------
TimeTickCnt_I_Srlc32e_Thrd : SRLC32E
	generic map (INIT => X"00000001")
	port map (D => IntSrlThrdOut, CE => IntPlsScndOut, CLK => RefClkIn, A => SrlThrdAddr,
			Q31 => open, Q => IntSrlThrdOut);
--
TimeTickCnt_I_GenPulse_Two : entity work.GenPulse
    port map (SigIn => IntSrlThrdOut, Clk => RefClkIn, Ena => High, SigOut => IntPlsThrdOut);
-----------------------------------------------------------------------------------------------
-- Slow output
TimeTickCnt_I_Srlc32e_Frth : SRLC32E
	generic map (INIT => X"00000020")
	port map (D => IntSrlFrthOut, CE => IntPlsThrdOut, CLK => RefClkIn, A => SrlFrthAddr,
			Q31 => open, Q => IntSrlFrthOut);
--
TimeTickCnt_I_GenPulse_Tre : entity work.GenPulse
    port map (Clk => RefClkIn, Ena => TickEna, SigIn => IntSrlFrthOut, SigOut => TickOut_Slow);
-----------------------------------------------------------------------------------------------
--Fast output ( = 1/2 of slow)
TimeTickCnt_I_Srlc32e_Ffth : SRLC32E
	generic map (INIT => X"00000004")
	port map (D => IntSrlFfthOut, CE => IntPlsThrdOut, CLK => RefClkIn, A => SrlFfthAddr,
			Q31 => open, Q => IntSrlFfthOut);
--
TimeTickCnt_I_GenPulse_For : entity work.GenPulse
    port map (SigIn => IntSrlFfthOut, Clk => RefClkIn, Ena => TickEna, SigOut => TickOut_Fast);

-----------------------------------------------------------------------------------------------
end  TimeTickCnt_struct;
--