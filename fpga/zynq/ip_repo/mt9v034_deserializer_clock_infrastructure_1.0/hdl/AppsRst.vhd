---------------------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /   
-- \   \   \/    © Copyright 2011 Xilinx, Inc. All rights reserved.
--  \   \        This file contains confidential and proprietary information of Xilinx, Inc.
--  /   /        and is protected under U.S. and international copyright and other
-- /___/   /\    intellectual property laws.
-- \   \  /  \    
--  \___\/\___\ 
-- 
---------------------------------------------------------------------------------------------
-- Device:              Series-7
-- Author:              defossez
-- Entity Name:         AppsRst
-- Purpose:             Provide a output signal synchronous to a clock and controlled by an
--                      input signal. The input signal is active high (low-to-high) and can be 
--                      delivered by a MMCM locked output.
--                      The output signal, available after a programmable delay, can then be
--                      use to take circuits out of reset.
--                      Typical use: As written above a MMCM provides a locked signal and this
--                      circuit provides the the release of the reset of the IDELAYCTRL
--                      component (when used with ISERDES). 
-- Tools:               ISE_13.2
-- Limitations:         none
--
-- Vendor:              Xilinx Inc.
-- Version:             0.01
-- Filename:            AppsRst.vhd
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
--  Rev. 
--      
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
-- C_AppsRstDly :   -- Delay value (address of a SRL32).
--                  -- between 0 and 31.
-- PORTS
-- Ena      : -- Input to start the circuit.
-- Rst      : -- Reset, normall connected to teh system reset input (same reset as the MMCM).
-- ClkIn    : -- clock input, normally the same clockinput as for the MMCM.
-- EnaRstOut    : -- Output used to release the rest of a design.
---------------------------------------------------------------------------------------------
entity AppsRst is
    generic (C_AppsRstDly : integer := 31);
	port (
		ClkIn     : in std_logic;
		Locked    : in std_logic;
		Rst       : in std_logic;
		PrimRstOut : out std_logic
	);
end AppsRst;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture AppsRst_struct of AppsRst is
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
signal IntSetRst    : std_logic;
signal IntSrlAddr   : std_logic_vector(4 downto 0);
signal IntSrlToFf   : std_logic;
signal IntFfToSrlFf : std_logic;
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of AppsRst_struct : architecture is "NO";
---------------------------------------------------------------------------------------------
begin
--
IntSrlAddr <= std_logic_vector(to_unsigned(C_AppsRstDly, IntSrlAddr'LENGTH));
IntSetRst <= not Locked or Rst;
--
AppsRst_I_Srlc32e : SRLC32E
    generic map (INIT => X"00000001")
    port map (CLK => ClkIn, A => IntSrlAddr, CE => Locked, D => IntFfToSrlFf,
                Q => IntSrlToFf, Q31 => open);
AppsRst_I_Fdce : FDRE
    generic map (INIT => '0')
    port map (D => IntSrlToFf, CE => High, C => ClkIn, R => IntSetRst, Q => IntFfToSrlFf);
--
AppsRst_I_Fdse : FDSE
    generic map (INIT => '1')
    port map (C => ClkIn, CE => IntFfToSrlFf, S => IntSetRst, D => Low, Q => PrimRstOut);
---------------------------------------------------------------------------------------------
end AppsRst_struct;
--