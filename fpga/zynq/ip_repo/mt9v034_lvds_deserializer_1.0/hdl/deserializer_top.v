`timescale 1ns / 1ps

module deserializer_top (
    input wire rxclk,
    
    input wire cam_p,
    input wire cam_n,
    
    output wire pxclk,
    output wire pixel_data_valid,
    output wire frame_valid,
    output wire line_valid,
    output wire [7:0] pixel_data,
    output wire receiver_locked,
    output wire receiver_mmcm_ready
);

parameter IBUF_LOW_PWR="FALSE";
parameter DIFF_TERM="TRUE";
parameter IOSTANDARD="LVDS_25";

wire cam_p_buffered;
wire cam_n_buffered;

wire rx_data_ready;
wire [11:0] rx_data;
wire [11:0] rx_data_reversed;

genvar i;
for(i = 0; i < 12; i = i+1)
    assign rx_data_reversed[i] = rx_data[11-i];

assign pixel_data_valid = rx_data_ready;
assign pixel_data = rx_data_reversed[8:1];
assign line_valid = rx_data_reversed[9];
assign frame_valid = rx_data_reversed[10];

IBUFDS_DIFF_OUT #(
    .IBUF_LOW_PWR(IBUF_LOW_PWR),
    .DIFF_TERM(DIFF_TERM),
    .IOSTANDARD(IOSTANDARD)
) cam1_IBUFDS_diff_out (
    .I(cam_p),
    .IB(cam_n),
    .O(cam_p_buffered),
    .OB(cam_n_buffered)
);

Receiver #(
    .C_MmcmLoc("MMCME2_ADV_X1Y2"),
    .C_UseFbBufg(0),
    .C_UseBufg(7'b0011001),
    .C_RstOutDly(2),
    .C_EnaOutDly(6),
    .C_Width(1),
    .C_AlifeFactor(5),
    .C_AlifeOn(8'b00000001),
    .C_DataWidth(1),
    .C_BufioClk0Loc("BUFIO_X1Y8"),
    .C_BufioClk90Loc("BUFIO_X1Y9"),
    .C_IdlyCtrlLoc("IDELAYCTRL_X1Y2"),
    .C_IdlyCntVal_M(5'b00000),
    .C_IdlyCntVal_S(5'b00101),
    .C_RefClkFreq(200.00),
    .C_IoSrdsDataWidth(4),
    .C_ClockPattern(4'b1010)
) receiver (
    .RxD_p(cam_p_buffered),
    .RxD_n(cam_n_buffered),
    
    .RxClkIn(rxclk),
    
    .RxRst(1'b0),
    
    .RxClk(),
    .RxClkDiv(pxclk),
    
    .RxMmcmAlive(),
    
    .RxDatAlignd(receiver_mmcm_ready),
    .RxDataRdy(rx_data_ready),
    .RxDataLocked(receiver_locked),
    
    .RxRawData(),
    .RxData(rx_data)
);

endmodule
