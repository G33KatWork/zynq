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
-- Entity Name:         SgmiiRxData
-- Purpose:             ISERDES data inputs used in oversample configuration.
-- Tools:               ISE_13.2
-- Limitations:         none
--
-- Vendor:              Xilinx Inc.
-- Version:             0.01
-- Filename:            SgmiiRxData.vhd
-- Date Created:        16 Augustus, 2011
-- Date Last Modified:  06 September, 2011
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
--  Rev. 06 Sep 2011
--      Multi channels test and needed adjustments.
--  Rev. 07 Dec 2011
--      Moved IDELAYCTRL from toplevel to this level.
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
-- RxD_p/n      : Serial data inputs.
-- CLk0         : Clock 625 MHz, no phase shift.
-- Clk90        : Clock 625 MHz, 90 degrees phase shift.
-- Rst          : Reset input.
-- Ena          : Enable input.
-- RefClk       : Clock for the IDLEAYCTRL block.
-- IdlyCtrlRst  : Reset for the IDELAYCTRL block.
-- IdlyCtrlRdy  : When IDELAYCTRL block is ready.
-- RxData       : received data output for DRU.
---------------------------------------------------------------------------------------------
entity SgmiiRxData is
    generic (
        C_IdlyCtrlLoc   : string := "IDELAYCTRL_X0Y0";
        C_RefClkFreq    : real := 200.00;
        C_IdlyCntVal_M  : std_logic_vector(4 downto 0) := "00000";
        C_IdlyCntVal_S  : std_logic_vector(4 downto 0) := "00101";
        C_NmbrOfInst    : integer
    );
	port (
		RxD_p         : in std_logic;
		RxD_n         : in std_logic;
		Clk0          : in std_logic;
		Clk90         : in std_logic;
		ClkDiv        : in std_logic;
		Rst           : in std_Logic;
		Ena           : in std_logic;
        RefClk        : in std_logic;
        IdlyCtrlRst   : in std_logic;
        IdlyCtrlRdy   : out std_logic;
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
attribute LOC : string;
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
Gen_IdlyCtrl : if C_NmbrOfInst = 1 generate
    attribute LOC of SgmiiRxData_I_IdlyCtrl : label is C_IdlyCtrlLoc;
    begin
    SgmiiRxData_I_IdlyCtrl : IDELAYCTRL 
        port map (
            RST     => IdlyCtrlRst,
            REFCLK  => RefClk,
            RDY     => IdlyCtrlRdy
        );
end generate Gen_IdlyCtrl;
Gen_NoIdlyCtrl : if C_NmbrOfInst /= 1 generate
    IdlyCtrlRdy <= Low;
end generate Gen_NoIdlyCtrl;
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