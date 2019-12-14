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
-- Device:              
-- Author:              defossez
-- Entity Name:         MmcmAlignIo
-- Purpose:             OSERDES and ISERDES connected, without IOB to help with
--                      Clock Domain Crossing.
--
--                      PLEASE NOTE THAT:
--                      These OSERDES and ISERDES must reside (locked) in the same IO-Bank
--                      as the ISERDES used in the receiver part of the design.
--                      When the IOB pair in front of these OSERDES and ISERDES is a data
--                      only (not Clock_Capable) the IOB cannot be used anymore.
--                      When the IOB pair in front of these OSERDES and ISERDES are
--                      Clock_Capable then the IOBs still can be used as direct clock inputs.
--
-- Tools:               ISE_13.2
-- Limitations:         none
--
-- Vendor:              Xilinx Inc.
-- Version:             0.01
-- Filename:            MmcmAlignIo.Vhd
-- Date Created:        06 September, 2011
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
--  Rev. 10 Jan 2012
--      Added some extra comments, restrictions on C_IoSrdsDataWidth.
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
entity MmcmAlignIo is
    generic (
        -- C_IoSrdsDataWidth is normally 4, 6, or 8.
        C_IoSrdsDataWidth : integer := 4;
        -- The width of this pattern must be equal to: C_IoSrdsDataWidth-1:0
        C_ClockPattern : std_logic_vector(3 downto 0) := "1010"
    );
	port (
		Clk0          : in std_logic;
		Clk90         : in std_logic;
		Clk           : in std_logic;
		ClkDiv        : in std_logic;
		Rst           : in std_logic;
		Ena           : in std_logic;
		ClkDataSmpl   : out std_logic_vector(C_IoSrdsDataWidth-1 downto 0)
	);
end MmcmAlignIo;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture MmcmAlignIo_struct of MmcmAlignIo is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
-- Constants
constant Low  : std_logic	:= '0';
constant LowVec : std_logic_vector(31 downto 0) := X"00000000";
constant High : std_logic	:= '1';
-- Signals
signal IntClk0_n        : std_logic;
signal IntOsrdsToIsrds  : std_logic;
signal IntClkGenReg     : std_logic_vector(7 downto 0);
signal IntClkDataSmpl   : std_logic_vector(7 downto 0);
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of MmcmAlignIo_struct : architecture is "NO";
attribute MAXDELAY : string;
    attribute MAXDELAY of IntClkGenReg : signal is "600ps";
    attribute MAXDELAY of IntClkDataSmpl : signal is "600ps";
---------------------------------------------------------------------------------------------
begin
--
IntClk0_n <= not Clk0;
--
Gen_1 : if C_IoSrdsDataWidth = 8 generate
    MmcmAlignIo_ClkGenReg8_PROCESS : process (ClkDiv, Rst)
    begin
        if (Rst = '1') then
            IntClkGenReg <= (others => '0');
        elsif (ClkDiv'event and ClkDiv = '1') then
            if (Ena = '1') then
                IntClkGenReg <= C_ClockPattern;
            end if;
        end if;
    end process; 
end generate Gen_1;
Gen_2 : if C_IoSrdsDataWidth /= 8 generate
    MmcmAlignIo_ClkGenReg_PROCESS : process (ClkDiv, Rst)
    begin
        if (Rst = '1') then
            IntClkGenReg <= (others => '0');
        elsif (ClkDiv'event and ClkDiv = '1') then
            if (Ena = '1') then
                IntClkGenReg <= LowVec((7-C_IoSrdsdataWidth) downto 0) & C_ClockPattern;
            end if;
        end if;
    end process;
end generate Gen_2;
--
MmcmAlignIo_I_Osrdse2_Clk : OSERDESE2
    generic map (
        DATA_RATE_OQ    => "DDR", 
        DATA_RATE_TQ    => "DDR", 
        DATA_WIDTH      => C_IoSrdsDataWidth, 
        INIT_OQ         => '0', 
        INIT_TQ         => '0', 
        SERDES_MODE     => "MASTER", 
        SRVAL_OQ        => '0', 
        SRVAL_TQ        => '0', 
        TRISTATE_WIDTH  => 4,
        TBYTE_CTL       => "FALSE",
        TBYTE_SRC       => "FALSE"
    ) 
    port map (
        SHIFTOUT1       => open,
        SHIFTOUT2       => open,
        OQ              => open,
        OFB             => IntOsrdsToIsrds,
        D1              => IntClkGenReg(0),
        D2              => IntClkGenReg(1),
        D3              => IntClkGenReg(2),
        D4              => IntClkGenReg(3),
        D5              => IntClkGenReg(4),
        D6              => IntClkGenReg(5),
        D7              => IntClkGenReg(6),
        D8              => IntClkGenReg(7),
        OCE             => Ena,
        RST             => Rst,
        CLK             => Clk,
        CLKDIV          => ClkDiv,
        SHIFTIN1        => Low,
        SHIFTIN2        => Low,
        TBYTEOUT        => open,
        TQ              => open,
        TFB             => open,
        T1              => Low,
        T2              => Low,
        T3              => Low,
        T4              => Low,
        TBYTEIN         => Low,
        TCE             => Low
    );
--
MmcmAlignIo_I_Isrdse2_Clk : ISERDESE2
    generic map (
        DATA_RATE       => "DDR", 
        DATA_WIDTH      => C_IoSrdsDataWidth, 
        IOBDELAY        => "NONE",
        OFB_USED        => "TRUE",
        INTERFACE_TYPE  => "NETWORKING", 
        NUM_CE          => 1,
        SERDES_MODE     => "MASTER",
        DYN_CLKDIV_INV_EN => "FALSE",
        DYN_CLK_INV_EN  => "FALSE",
        INIT_Q1         => '0',
        INIT_Q2         => '0',
        INIT_Q3         => '0',
        INIT_Q4         => '0',
        SRVAL_Q1        => '0',
        SRVAL_Q2        => '0',
        SRVAL_Q3        => '0',
        SRVAL_Q4        => '0'
    ) 
    port map (
        SHIFTIN1        => Low,
        SHIFTIN2        => Low,
        DDLY            => Low,
        D               => Low,
        OFB             => IntOsrdsToIsrds,
        O               => open,        
        Q1              => IntClkDataSmpl(0),
        Q2              => IntClkDataSmpl(1),
        Q3              => IntClkDataSmpl(2),
        Q4              => IntClkDataSmpl(3),
        Q5              => IntClkDataSmpl(4),
        Q6              => IntClkDataSmpl(5),
        Q7              => IntClkDataSmpl(6),
        Q8              => IntClkDataSmpl(7),
        BITSLIP         => Low,
        RST             => Rst,
        CE1             => Ena,
        CE2             => High,
        DYNCLKDIVSEL    => Low,
        DYNCLKSEL       => Low,
        OCLK            => Low,
        OCLKB           => Low,
        CLK             => Clk0,
        CLKB            => IntClk0_n,
        CLKDIV          => ClkDiv,
        CLKDIVP         => Low,
        SHIFTOUT1       => open,
        SHIFTOUT2       => open
   );
--
MmcmAlignIo_SmplReg_PROCESS : process (ClkDiv, Rst)
begin
    if (Rst = '1') then
        ClkDataSmpl <= (others => '0');
    elsif (ClkDiv'event and ClkDiv = '1') then
        if (Ena = '1') then
            ClkDataSmpl <= IntClkDataSmpl(C_IoSrdsDataWidth-1 downto 0);
        end if;
    end if;
end process;
---------------------------------------------------------------------------------------------
end MmcmAlignIo_struct;
--