`timescale 1ns / 1ps

module ClockInfrastructure_top(
    input wire ClkIn,
    input wire Rst,
    
    output wire MmcmAlignd,
    output wire DeserUnitReset,
    output wire DeserUnitEnable,
    
    output wire RxClk,
    output wire RxClkDiv,
    output wire Clk0Bufio,
    output wire Clk90Bufio
);

parameter C_MmcmLoc="MMCME2_ADV_X1Y2";
parameter C_BufioClk0Loc="BUFIO_X1Y8";
parameter C_BufioClk90Loc="BUFIO_X1Y9";
parameter C_IdlyCtrlLoc="IDELAYCTRL_X1Y2";
parameter real C_ClkinPeriod=10.0;
parameter C_DivClkDivide=1;
parameter real C_ClkFboutMult=8.0;
parameter real C_Clkout0_Divide=4.0;
parameter C_Clkout1_Divide=5;
parameter C_Clkout2_Divide=5;
parameter C_Clkout3_Divide=10;
parameter C_Clkout4_Divide=5;


ClockInfrastructure #(
    .C_MmcmLoc(C_MmcmLoc),
    .C_UseFbBufg(0),
    .C_UseBufg(7'b0011001),
    .C_RstOutDly(2),
    .C_EnaOutDly(6),
    .C_BufioClk0Loc(C_BufioClk0Loc),
    .C_BufioClk90Loc(C_BufioClk90Loc),
    .C_IdlyCtrlLoc(C_IdlyCtrlLoc),
    .C_IoSrdsDataWidth(4),
    .C_ClockPattern(4'b1010),
    .C_ClkinPeriod(C_ClkinPeriod),
    .C_DivClkDivide(C_DivClkDivide),
    .C_ClkFboutMult(C_ClkFboutMult),
    .C_Clkout0_Divide(C_Clkout0_Divide),
    .C_Clkout1_Divide(C_Clkout1_Divide),
    .C_Clkout2_Divide(C_Clkout2_Divide),
    .C_Clkout3_Divide(C_Clkout3_Divide),
    .C_Clkout4_Divide(C_Clkout4_Divide)
) clock_infrastructure (
    .ClkIn(ClkIn),
    .Rst(Rst),
    .MmcmAlignd(MmcmAlignd),
    .DeserUnitReset(DeserUnitReset),
    .DeserUnitEnable(DeserUnitEnable),
    .RxClk(RxClk),
    .RxClkDiv(RxClkDiv),
    .Clk0Bufio(Clk0Bufio),
    .Clk90Bufio(Clk90Bufio)
);

endmodule
