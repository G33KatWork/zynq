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
-- Entity Name:         MmcmAlignSm
-- Purpose:             The BUS_ALIGN_MACHINE module samples the clock input as if it were
--                      a data channel, and uses the information about the deserialized clock
--                      to determine the optimal  clock/data relationship for that channel.
--                      By dynamically changing the delay of the clock channel (with respect
--                      to the data bus), the machine places the sampling point at the center
--                      of the data eye.
-- Tools:               ISE_13.2
-- Limitations:         none
--
-- Vendor:              Xilinx Inc.
-- Version:             0.02 
-- Filename:            MmcmAlignSm.vhd
-- Date Created:        6 July, 2011
-- Date Last Modified:  11 August, 2011
---------------------------------------------------------------------------------------------
-- Disclaimer:
--      This disclaimer is not a license and does not grant any rights to the materials
--      distributed herewith. Except as otherwise provided in a valid license issued to you
--      by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
--      ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
--      WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
--      TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
--      PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
--      negligence, or under any other theory of liability) for any loss or damage of any
--      kind or nature related to, arising under or in connection with these materials,
--      including for any direct, or any indirect, special, incidental, or consequential
--      loss or damage (including loss of data, profits, goodwill, or any type of loss or
--      damage suffered as a result of any action brought by a third party) even if such
--      damage or loss was reasonably foreseeable or Xilinx had been advised of the
--      possibility of the same.
--
-- CRITICAL APPLICATIONS
--      Xilinx products are not designed or intended to be fail-safe, or for use in any
--      application requiring fail-safe performance, such as life-support or safety devices
--      or systems, Class III medical devices, nuclear facilities, applications related to
--      the deployment of airbags, or any other applications that could lead to death,
--      personal injury, or severe property or environmental damage (individually and
--      collectively, "Critical Applications"). Customer assumes the sole risk and
--      liability of any use of Xilinx products in Critical Applications, subject only to
--      applicable laws and regulations governing limitations on product liability.
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
---------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library unisim;
    use unisim.vcomponents.all;
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
entity MmcmAlignSm is
    generic (
        C_IoSrdsDataWidth : integer := 4;
        -- The width of this pattern must be equal to: C_IoSrdsDataWidth-1:0
        C_ClockPattern : std_logic_vector(3 downto 0) := "1010"
    );
    port(
        ClkDiv      : in  std_logic;
        Rst         : in  std_logic;
        MmcmLocked  : in  std_logic;
        ClkSmpld    : in  std_logic_vector(C_IoSrdsDataWidth-1 downto 0);
        PsDone      : in  std_logic;
        PsInc       : out std_logic;
        PsIce       : out std_logic;
        Aligned     : out std_logic
    );
end MmcmAlignSm;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture MmcmAlignSm_struct of MmcmAlignSm is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Functions
-- Invert a incoming std_logic_vector string
    function InvertData(Inp : std_logic_vector) return std_logic_vector is
    variable Temp : std_logic_vector(Inp'range) := (others => '0');
    begin
		for i in Inp'range loop
			if (Inp(i) = '1') then
				Temp(i) := '0';
			elsif (Inp(i) = '0') then
				Temp(i) := '1'; 
			end if;
		end loop;
	return Temp;
	end function InvertData;
    
-- Depending the data width value set the mid point for the counter
    function MidCnt(Inp : integer) return unsigned is
    variable Temp : unsigned((Inp-1)*2 downto 0) := (others => '0');
    begin
        if (Inp = 4) then -- Count lenght = (4-1)*2 downto 0 =  6:0
            Temp := "0001111";
        elsif (Inp = 6) then -- Count lenght = (6-1)*2 downto 0 =  10:0
            Temp := "00000111111";
        elsif (Inp = 8) then -- Count lenght = (8-1)*2 downto 0 =  14:0
            Temp := "000000011111111";
        else
            Temp := (others => '0');
            assert false
            report CR & " Only values 4, 6 and 8 are allowed as C_IoSrdsDataWidth value! " & CR
            severity error;        
        end if;
    return Temp;
    end function MidCnt;

-- Depending the data width value set the end point for the counter
    function EndCnt(Inp : integer) return unsigned is
    variable Temp : unsigned((Inp-1)*2 downto 0) := (others => '0');
    begin
        if (Inp = 4) then -- Count lenght = (4-1)*2 downto 0 =  6:0
            Temp := "0111111";
        elsif (Inp = 6) then -- Count lenght = (6-1)*2 downto 0 =  10:0
            Temp := "01111111111";
        elsif (Inp = 8) then -- Count lenght = (8-1)*2 downto 0 =  14:0
            Temp := "011111111111111";
        else
            Temp := (others => '0');
            assert false
            report CR & " Only values 4, 6 and 8 are allowed as C_IoSrdsDataWidth value! " & CR
            severity error;        
        end if;
    return Temp;
    end function EndCnt;
    
-- Constants
constant Low  : std_logic   := '0';
constant High : std_logic   := '1';
constant IntClockPattern : std_logic_vector(C_IoSrdsDataWidth-1 downto 0) := C_ClockPattern;
constant IntInvClkPttern : std_logic_vector(C_IoSrdsDataWidth-1 downto 0) := InvertData(C_ClockPattern);
constant IntMidCnt : unsigned((C_IoSrdsDataWidth-1)*2 downto 0) := MidCnt(C_IoSrdsDataWidth);
constant IntEndCnt : unsigned((C_IoSrdsDataWidth-1)*2 downto 0) := EndCnt(C_IoSrdsDataWidth);
-- Signals
signal IntAligned        : std_logic;
signal IntCntSmpl        : std_logic;
signal IntCount          : std_logic;
signal IntCntVal         : unsigned((C_IoSrdsDataWidth-1)*2 downto 0);
signal IntCntCtrl        : std_logic_vector(1 downto 0);
signal IntUd             : std_logic;
signal IntUdSmpl         : std_logic;
signal IntCurrentState   : std_logic_vector(3 downto 0);
signal IntNextState      : std_logic_vector(3 downto 0);
signal IntClkSmpld       : std_logic_vector(C_IoSrdsDataWidth-1 downto 0);
-- Attributes
attribute KEEP_HIERARCHY : string;
    attribute KEEP_HIERARCHY of MmcmAlignSm_struct : architecture is "NO";
---------------------------------------------------------------------------------------------
begin
--    
IntCntCtrl <= IntCount & Intud;
--
MmcmAlignSm_Cnt_PROCESS : process (ClkDiv, Rst)
begin
    if Rst = '1' then
        IntCntVal <= (others => '0');
    elsif ClkDiv'event and ClkDiv = '1' then
        case (IntCntCtrl) is
            when "00"   => IntCntVal <= (others => '0');
            when "01"   => IntCntVal <= IntCntVal;
            when "10"   => IntCntVal <= IntCntVal - 1;
            when others => IntCntVal <= IntCntVal + 1;
        end case;
    end if;
end process;
---------------------------------------------------------------------------------------------
MmcmAlignSm_I_Fdr_CntReg: FDR
    port map (
        Q     => Aligned,
        C     => ClkDiv,
        D     => IntAligned,
        R     => Rst
    );
--
Gen_1 : for n in 0 to C_IoSrdsDataWidth-1 generate
    MmcmAlignSm_I_Fdre_Bits : FDRE
        port map (
            Q     => IntClkSmpld(n),
            C     => ClkDiv,
            CE    => '1',
            D     => ClkSmpld(n),
            R     => Rst
        );
end generate Gen_1;
--
IntAligned <= (not IntCurrentState(3) and IntCurrentState(2) and 
                  IntCurrentState(1) and IntCurrentState(0));
---------------------------------------------------------------------------------------------
MmcmAlignSm_CurState_PROCESS : process (ClkDiv, Rst)
begin
    if Rst = '1' then
        IntCurrentState <= "0000";
    elsif ClkDiv'event and ClkDiv = '1' then
        IntCurrentState <= IntNextState;
    end if;
end process;
-- Next_State logic
MmcmAlignSm_NxtState_PROCESS : process (IntCurrentState, ClkSmpld, IntCntVal, IntClkSmpld,
                                        PsDone, MmcmLocked)
begin
    case (IntCurrentState) is
    when "0000" =>
        if (MmcmLocked = '1') then
          IntNextState <= "0001"; --Rst state
        else
          IntNextState <= "0000"; --Rst state
        end if;
    -- initial state, sample training bit
    when "0001" =>
        if (IntClkSmpld /= ClkSmpld) then
          IntNextState <= "1111";
        else
          IntNextState <= "1000";
        end if;
    -- check sample to see if it is on a transition
    when "1000" =>
        if (IntClkSmpld /= ClkSmpld) then
          IntNextState <= "1111";
        elsif ((IntCntVal > IntMidCnt) and (ClkSmpld = IntClockPattern)) then
          IntNextState <= "1011";
        elsif ((IntCntVal > IntMidCnt) and (ClkSmpld = IntInvClkPttern)) then
          IntNextState <= "0010";
        else
          IntNextState <= "1000";
        end if;
    when "1111" =>
        IntNextState <= "1101";
    -- wait 8 cycles
    when "1101" =>
        if (PsDone = '1') then
          IntNextState <= "1100";
        else
          IntNextState <= "1101";
        end if;
    -- idle (needed for counter reset)
    when "1100" =>
        IntNextState <= "1000";
    -- PsInc once
    when "0010" =>
        IntNextState <= "1110";
    -- wait 8 cycles, look for rising edge
    when "1110" =>
        if (IntCntVal > IntEndCnt) then
          IntNextState <= "1110";
        elsif (ClkSmpld /= IntInvClkPttern) then
          IntNextState <= "0111";
        else
          IntNextState <= "0010";
        end if;
    -- PsInc once
    when "1011" =>
        IntNextState <= "0100";
    -- wait 8 cycles, look for falling edge
    when "0100" =>
        if (PsDone = '0') then
          IntNextState <= "0100";
        elsif (ClkSmpld = IntInvClkPttern) then
          IntNextState <= "1001";
        else
          IntNextState <= "1011";
        end if;
    --PsInc once
    when "1001" =>
        IntNextState <= "0011";
    --wait 8 cycles, look for rising edge
    when "0011" =>
        if (PsDone = '0') then
          IntNextState <= "0011";
        elsif (ClkSmpld = IntClockPattern) then
          IntNextState <= "0111";
        else
          IntNextState <= "1001";
        end if;
    --training complete for this channel
    when "0111" =>
        IntNextState <= "0111";
    when others =>
        IntNextState <= "0000";
    end case;
end process;
---------------------------------------------------------------------------------------------
-- Output Logic
MmcmAlignSm_OutState_PROCESS : process (IntCurrentState)
begin
    case IntCurrentState is
        -- Rst state
        when "0000" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount        <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        -- Initial state, sample training bit
        when "0001" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount        <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        -- Check sample to see if it is on a transition
        when "1000" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount        <= '1';
            IntUd           <= '1';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        -- If sampled point is transition, increment delay 2 times
        when "1111" =>
            PsInc          <= '1';
            PsIce          <= '1';
            IntCount        <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '1';
            IntUdSmpl    <= '1';
        -- Wait 8 cycles
        when "1101" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount        <= '1';
            IntUd           <= '1';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        -- Idle (needed for counter reset)
        when "1100" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount        <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        -- Increment once
        when "0010" =>
            PsInc          <= '1';
            PsIce          <= '1';
            IntCount        <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        -- Wait 8 cycles, look for 1 (to locate falling edge)
        when "1110" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount        <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '1';
            IntUdSmpl    <= '1';
        -- Increment once
        when "1011" =>
            PsInc          <= '1';
            PsIce          <= '1';
            IntCount        <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        -- Wait 8 cycles, look for 0
        when "0100" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount        <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '1';
            IntUdSmpl    <= '1';
        -- Increment once
        when "1001" =>
            PsInc          <= '1';
            PsIce          <= '1';
            IntCount       <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        -- Wait 8 cycles, look for 1 (to locate falling edge)
        when "0011" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount       <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '1';
            IntUdSmpl    <= '1';
        -- Training complete on this channel
        when "0111" =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount       <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
        --
        when others =>
            PsInc          <= '0';
            PsIce          <= '0';
            IntCount       <= '0';
            IntUd           <= '0';
            IntCntSmpl <= '0';
            IntUdSmpl    <= '0';
    end case;
end process;
---------------------------------------------------------------------------------------------
end MmcmAlignSm_struct;
--