`timescale 1ps / 1ps

module receiver_tb;

parameter CAM_CLK_PERIOD = (37500);

reg clk_data_parallel = 0;
initial forever
    //26.66666MHz
    #(CAM_CLK_PERIOD/2) clk_data_parallel = !clk_data_parallel;

wire cam_p, cam_n;

lvds_data_sender #(
    .CLK_PERIOD(CAM_CLK_PERIOD)
) lvds_data_sender (
    .clk    (clk_data_parallel),
    .out_p  (cam_p),
    .out_n  (cam_n)
);

/*mt9v032_model #(
    .CLK_PERIOD(CAM_CLK_PERIOD)
) camera_sender (
    .clk    (clk_data_parallel),
    .out_p  (cam_p),
    .out_n  (cam_n)
);*/





reg clk_receiver = 0;
initial forever
    //100MHz
    #(10000/2) clk_receiver = !clk_receiver;

wire rx_clk;
wire rx_clk_div;
wire mmcm_alive;
wire rx_data_aligned;
wire rx_data_rdy;
wire [11:0] rx_data;
wire rx_data_locked;

Receiver #(
    .C_MmcmLoc("MMCME2_ADV_X1Y2"),
    .C_UseFbBufg(0),
    .C_UseBufg(7'b0011000),
    .C_RstOutDly(2),
    .C_EnaOutDly(6),
    .C_Width(1),
    .C_AlifeFactor(5),
    .C_AlifeOn(8'b00000001),
    .C_DataWidth(1),
    .C_BufioClk0Loc("BUFIO_X0Y0"),
    .C_BufioClk90Loc("BUFIO_X0Y1"),
    .C_IdlyCtrlLoc("IDELAYCTRL_X1Y2"),
    .C_IdlyCntVal_M(5'b00000),
    .C_IdlyCntVal_S(5'b00101),
    .C_RefClkFreq(200.00),
    .C_IoSrdsDataWidth(4),
    .C_ClockPattern(4'b1010)
) receiver_dut (
    .RxD_p(cam_p),
    .RxD_n(cam_n),
    
    .RxClkIn(clk_receiver),
    
    .RxRst(1'b0),
    
    .RxClk(rx_clk),
    .RxClkDiv(rx_clk_div),
    
    .RxMmcmAlive(mmcm_alive),
    
    .RxDatAlignd(rx_data_aligned),
    .RxDataRdy(rx_data_rdy),
    .RxRawData(),
    .RxData(rx_data),
    .RxDataLocked(rx_data_locked)
);


/*wire [11:0] rx_data_rotated;
wire framing_okay = ((rx_data_rotated[11] == 1'b1) && (rx_data_rotated[0] == 1'b0));

reg [3:0] rotateAmount = 4'b0000;

always @(posedge rx_clk_div) begin
    if (rx_data_rdy) begin
        if (!framing_okay) begin
            if (rotateAmount == 4'd11) begin
                rotateAmount <= 4'd0;
            end else begin
                rotateAmount <= rotateAmount + 4'd1;
            end
        end else begin
            rotateAmount <= rotateAmount;
        end
    end
end

assign rx_data_rotated = (rx_data << rotateAmount) | (rx_data >> 12-rotateAmount);*/

endmodule
