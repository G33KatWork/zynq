`timescale 1ps / 1ps

module receiver_tb;

parameter CAM_CLK_PERIOD = (37500);

wire cam_p, cam_n;

reg clk_data_parallel = 0;
initial forever
    //26.66666MHz
    #(CAM_CLK_PERIOD/2) clk_data_parallel = !clk_data_parallel;

lvds_data_sender #(
    .CLK_PERIOD(CAM_CLK_PERIOD),
    .DATA_WIDTH(10)
) data_sender (
    .clk    (clk_data_parallel),
    .out_p  (cam_p),
    .out_n  (cam_n)
);


//clock generation
reg  rxclk = 0;                                 //160MHz
reg  rxclkdiv = 0;                              //80MHz
wire clk0bufio = rxclk;                         //160MHz
reg  clk90bufio = 0;                            //160MHz, 90deg

initial begin
    forever #(6250/2)   rxclk = !rxclk;             //160MHz
end

initial begin
    #(6250/2);
    forever #((6250*2)/2) rxclkdiv = !rxclkdiv;     //80MHz
end

initial begin
    #((6250/2)/2);                                  //90 deg phaseshift
    forever #(6250/2)   clk90bufio = !clk90bufio;   //160MHz
end


wire pxclk;
wire rx_data_ready;
wire [11:0] rx_data;
wire rx_data_locked;

Receiver #(
    .C_LaneWidth(1),
    .C_DataWidth(12),
    .C_RefClkFreq(200.0),
    .C_IdlyCntVal_M(5'b00000),
    .C_IdlyCntVal_S(5'b00101)
) receiver_top (
    .RxD_p(cam_p),
    .RxD_n(cam_n),
    
    .ResetFromClkManager(1'b0),
    .EnableFromClkManager(1'b1),
    
    .RxClk(rxclk),
    .RxClkDiv(rxclkdiv),
    .Clk0Bufio(clk0bufio),
    .Clk90Bufio(clk90bufio),
    
    .RxDataClk(pxclk),
    .RxDataRdy(rx_data_ready),
    .RxData(rx_data),
    .RxDataLocked(rx_data_locked)
);

endmodule
