`timescale 1ns / 1ps

module clockgen_tb;

reg clk_main = 0;
initial forever
    //100MHz
    #(10000/2) clk_main = !clk_main;

wire mmcm_aligned;
wire rx_clk;
wire rx_clkDiv;
wire rx_clk0Bufio;
wire rx_clk90Bufio;

ClockInfrastructure #(
    .C_MmcmLoc("MMCME2_ADV_X1Y2"),
    .C_UseFbBufg(0),
    .C_UseBufg(7'b0011001),
    .C_RstOutDly(2),
    .C_EnaOutDly(6),
    .C_BufioClk0Loc("BUFIO_X0Y0"),
    .C_BufioClk90Loc("BUFIO_X0Y1"),
    .C_IdlyCtrlLoc("IDELAYCTRL_X1Y2"),
    .C_IoSrdsDataWidth(4),
    .C_ClockPattern(4'b1010),
    .C_ClkinPeriod(10.0),
    .C_DivClkDivide(1),
    .C_ClkFboutMult(8.0),
    .C_Clkout0_Divide(4.0),
    .C_Clkout1_Divide(5),
    .C_Clkout2_Divide(5),
    .C_Clkout3_Divide(10),
    .C_Clkout4_Divide(5)
) clkgen_dut (
    .ClkIn(clk_main),
    .Rst(1'b0),
    
    .MmcmAlignd(mmcm_aligned),
    
    .RxClk(rx_clk),
    .RxClkDiv(rx_clkDiv),
    .Clk0Bufio(rx_clk0Bufio),
    .Clk90Bufio(rx_clk90Bufio)
);

endmodule
