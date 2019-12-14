-----------------------------------------------------------------------------------------------
-- © Copyright 2008 - 2011, Xilinx, Inc. All rights reserved.
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
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.05
--  \   \        Filename: LifeIndicator.vhd
--  /   /        Date Last Modified:
-- /___/   /\    Date Created: 11/10/06
-- \   \  /  \
--  \___\/\___\
--
-- Device: Virtex-4 & Virtex-5 & Virtex-6 & 7-Series
-- Author: Marc Defossez
-- Entity Name:  LifeIndicator
-- Purpose: LED indication of working DCM / PLL / MMCM /
-- Tools:	ISE_13.1 and later
-- Limitations: none
--
-- Revision History:
--  Rev: 11 Oct 2006
--		This is an actualized copy of an earlier used and working design.
--  Rev: 26 May 2011
--      Version adapted for Virtex-6 and Series-7
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
-- Generics
-- C_Width          : Number of inputs and outputs that need a connection to an LED.
-- C_AlifeOn        : Turns the "Alife" or blink option on for an output else the output
--                  : is a straight connection without blinking (input determines output).
-- C_AlifeFactor    : Frequency of blinking. Set by a even number.
-----------------------------------------------------------------------------------------------
entity LifeIndicator is
  generic (
    C_Width				: integer := 8;
    C_AlifeFactor		: integer := 6;
    --  Bus of 8 inputs and output and only one (bit-0) gets a blinking effect.
    C_AlifeOn			: std_logic_vector(7 downto 0) := "00000001"
  );
    port (
      RefClkIn	: in std_logic;
      LifeRst		: in std_logic;
      LifeIn		: in std_logic_vector(C_Width-1 downto 0);
      LifeOut		: out std_logic_vector(C_Width-1 downto 0)
    );
end LifeIndicator;
-----------------------------------------------------------------------------------------------
-- Arcitecture section
-----------------------------------------------------------------------------------------------
architecture LifeIndicator_struct of LifeIndicator  is
-----------------------------------------------------------------------------------------------
-- Component Instantiation
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
-----------------------------------------------------------------------------------------------
-- Constants
constant Low			: std_logic := '0';
constant High			: std_logic := '1';
constant SrlCntAddr		: std_logic_vector (4 downto 0) := "11111"; -- 1F
-- Signals
signal IntFrstSrlIn     : std_logic_vector(C_Width-1 downto 0);
signal IntFrstFfOut     : std_logic_vector(C_Width-1 downto 0);
signal IntLastSrlIn     : std_logic_vector(C_Width-1 downto 0);
signal IntLastFfOut     : std_logic_vector(C_Width-1 downto 0);
signal IntFrstSrlToFf   : std_logic_vector(C_Width-1 downto 0);
signal IntLastSrlToFf   : std_logic_vector(C_Width-1 downto 0);
--
signal IntSrlToFf	: std_logic_vector((C_Width*C_AlifeFactor) downto 0);
signal IntFfToSrl   : std_logic_vector((C_Width*C_AlifeFactor) downto 0);
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of LifeIndicator_struct : architecture is "YES";
-----------------------------------------------------------------------------------------------
begin
-----------------------------------------------------------------------------------------------
-- The first and last SRL+FF.
-- The first is initialized with X"00000000" + '0'.
-- The last is initialized with X"11111111" +'1'.
-----------------------------------------------------------------------------------------------
Gen_Life : for p in 0 to C_Width-1 generate
    Gen_On : if C_AlifeOn(p) = '1' generate
        Frst_I_Srlc32e : SRLC32E
            generic map (INIT => X"00000000")
            port map (D => IntLastFfOut(p), CE => High, CLK => RefClkIn,
                      A => SrlCntAddr, Q31 => open, Q => IntFrstSrlToFf(p));
        Frst_I_Fdce : FDCE
            generic map (INIT => '0')
            port map (D => IntFrstSrlToFf(p), CE => High, C => RefClkIn,
                      CLR => LifeRst, Q => IntFrstFfOut(p));
    --
        Last_I_Srlc32e : SRLC32E
            generic map (INIT => X"FFFFFFFF")
            port map (D => IntLastSrlIn(p), CE => High, CLK => RefClkIn,
                      A => SrlCntAddr, Q31 => open, Q => IntLastSrlToFf(p));
        last_I_Fdpe : FDPE
          generic map (INIT => '1')
          port map (D => IntLastSrlToFf(p), CE => High, C => RefClkIn,
                    PRE => LifeRst, Q => IntLastFfOut(p));
    end generate Gen_On;
  --
    Gen_Off : if C_AlifeOn(p) = '0' generate
        IntFrstFfOut(p) <= LifeIn(p) and not LifeRst;
        IntLastFfOut(p) <= IntLastSrlIn(p);
    end generate Gen_Off;
    LifeOut(p) <= IntLastFfOut(p);
end generate Gen_Life;
-----------------------------------------------------------------------------------------------
-- The SRL and FF in the middle.
-- The first half is initialized at X"00000000" the second half is initialized at "FFFFFFFF".
-----------------------------------------------------------------------------------------------
Gen_MidLife : for p in 0 to C_Width-1 generate
    Gen_On : if C_AlifeOn(p) = '1' generate
        Gen_Factor_Nul : if C_AlifeFactor = 0 generate
            IntlastSrlIn(p) <= IntFrstFfOut(p);
        end generate Gen_Factor_Nul;
        --
        Gen_Factor_One : if C_AlifeFactor = 1 generate
            One_I_Srlc32e : SRLC32E
                generic map (INIT => X"0000FFFF")
                port map (D => IntFrstFfOut(p), CE => High, CLK => RefClkIn,
                          A => SrlCntAddr, Q31 => open, Q => IntSrlToFf(p));
            One_I_Fdce : FDPE
                generic map (INIT => '1')
                port map (D => IntSrlToFf(p), CE => High, C => RefClkIn,
                          PRE => LifeRst, Q => IntLastSrlIn(p));
        end generate Gen_Factor_One;
        --
        Gen_Factor_Lot : if C_AlifeFactor > 1 generate
            Gen_Factor : for n in 0 to C_AlifeFactor-1 generate
                Gen_Lsb : if n = 0 generate
                    Lsb_I_Srlc32e : SRLC32E
                        generic map (INIT => X"00000000")
                        port map (D => IntFrstFfOut(p), CE => High,
                                  CLK => RefClkIn, A => SrlCntAddr, Q31 => open,
                                  Q => IntSrlToFf((C_AlifeFactor*p)+n));
                    Lsb_I_Fdce : FDCE
                        generic map (INIT => '0')
                        port map (D => IntSrlToFf((C_AlifeFactor*p)+n),
                                  CE => High, C => RefClkIn, CLR => LifeRst,
                                  Q => IntFfToSrl((C_AlifeFactor*p)+n));
                end generate Gen_Lsb;
                Gen_LsbMid : if n /= 0 and n <= (C_Alifefactor/2)-1 generate
                    LsbMid_I_Srlc32e : SRLC32E
                        generic map (INIT => X"00000000")
                        port map (D => IntFfToSrl(((C_AlifeFactor*p)+n)-1), CE => High,
                                  CLK => RefClkIn, A => SrlCntAddr, Q31 => open,
                                  Q => IntSrlToFf((C_AlifeFactor*p)+n));
                    LsbMid_I_Fdce : FDCE
                        generic map (INIT => '0')
                        port map (D => IntSrlToFf((C_AlifeFactor*p)+n),
                                  CE => High, C => RefClkIn, CLR => LifeRst,
                                  Q => IntFfToSrl((C_AlifeFactor*p)+n));
                end generate Gen_LsbMid;
                Gen_MidMsb : if n > (C_Alifefactor/2)-1 and n < C_AlifeFactor-1 generate
                    MidMsb_I_Srlc32e : SRLC32E
                        generic map (INIT => X"FFFFFFFF")
                        port map (D => IntFfToSrl(((C_AlifeFactor*p)+n)-1), CE => High,
                                  CLK => RefClkIn, A => SrlCntAddr, Q31 => open,
                                  Q => IntSrlToFf((C_AlifeFactor*p)+n));
                    MidMsb_I_Fdce : FDPE
                        generic map (INIT => '1')
                        port map (D => IntSrlToFf((C_AlifeFactor*p)+n),
                                  CE => High, C => RefClkIn, PRE => LifeRst,
                                  Q => IntFfToSrl((C_AlifeFactor*p)+n));
                end generate Gen_MidMsb;
                Gen_Msb : if n = C_AlifeFactor-1 generate
                    Msb_I_Srlc32e : SRLC32E
                        generic map (INIT => X"FFFFFFFF")
                        port map (D => IntFfToSrl(((C_AlifeFactor*p)+n)-1), CE => High,
                                  CLK => RefClkIn, A => SrlCntAddr, Q31 => open,
                                  Q => IntSrlToFf((C_AlifeFactor*p)+n));
                    Msb_I_Fdce : FDPE
                        generic map (INIT => '1')
                        port map (D => IntSrlToFf((C_AlifeFactor*p)+n),
                                  CE => High, C => RefClkIn, PRE => LifeRst,
                                  Q => IntLastSrlIn(p));
                end generate Gen_Msb;
            end generate Gen_Factor;
        end generate Gen_Factor_Lot;
    end generate Gen_On;
    --
    Gen_Off : if C_AlifeOn(p) = '0' generate
        IntLastSrlIn(p) <= IntFrstFfOut(p);
    end generate Gen_Off;
end generate Gen_MidLife;
-----------------------------------------------------------------------------------------------
end  LifeIndicator_struct;
--