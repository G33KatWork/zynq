-----------------------------------------------------------------------------------------------
-- ? Copyright 2008 - 2009, Xilinx, Inc. All rights reserved.
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
--  \   \        Filename: GenPulse.vhd
--  /   /        Date Last Modified:  
-- /___/   /\    Date Created:  08 Mar 08 
-- \   \  /  \
--  \___\/\___\
-- 
-- Device: 
-- Author: Marc Defossez
-- Entity Name:  GenPulse
-- Purpose: Generate a clock cycle wide pulse from a wide high input
-- Tools: ISE_10.1
-- Limitations: none
--
-- Revision History:
--    Rev. 8 Dec 2011
--      Changed FDCE into FDRE.
--    Rev. 14 Dec 2011
--      Moved to FD Ffs and and gates for compact design.
--      In 7-series there is only one "Clr/Rst and Set" connection for all FFs in a slice.
--      CE and WE share also the same connection to the FFs and LUTs. It is or WE or CE.
--      CE is one connection for all FFs in a slice.
 
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
entity GenPulse is
    port (
        Clk		: in std_logic;
        Ena		: in std_logic;
        SigIn	: in std_logic;
        SigOut	: out std_logic
    );
end GenPulse;

-----------------------------------------------------------------------------------------------
-- Arcitecture section
-----------------------------------------------------------------------------------------------
architecture GenPulse_struct of GenPulse  is
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
-- Signals
signal IntSigClr    : std_logic;
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of GenPulse_struct : architecture is "NO";
-----------------------------------------------------------------------------------------------
begin
--
GenPulse_I_Fdcr_1 : entity work.Fdcr
    generic map (INIT => '0')
    port map (D => SigIn, CE => Ena, C => Clk, R => IntSigClr, Q => SigOut);
--
GenPulse_I_Fdcr_2 : entity work.Fdcr
    generic map (INIT => '0')
    port map (D => SigIn, CE => High, C => Clk, R => Low, Q => IntSigClr);
--
-----------------------------------------------------------------------------------------------
end  GenPulse_struct;
--