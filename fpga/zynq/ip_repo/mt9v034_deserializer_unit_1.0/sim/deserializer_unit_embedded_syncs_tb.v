`timescale 1ps / 1ps

module deserializer_unit_embedded_syncs_tb;

parameter CAM_CLK_PERIOD = (37500);

wire cam_p, cam_n;

reg clk_data_parallel = 0;
initial forever
    //26.66666MHz
    #(CAM_CLK_PERIOD/2) clk_data_parallel = !clk_data_parallel;

mt9v032_model #(
    .CLK_PERIOD(CAM_CLK_PERIOD)
) camera_sender (
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
wire pixel_data_valid;
wire receiver_locked;
wire vid_active_video;
wire [9:0] vid_data;
wire vid_hblank;
wire vid_vblank;

deserializer_top #(
    .IBUF_LOW_PWR("FALSE"),
    .DIFF_TERM("TRUE"),
    .IOSTANDARD("LVDS_25"),
    .IDELAYCTRL_REFCLK(200.0),
    .USE_EMBEDDED_SYNCS(1),
    .VIDEO_BIT_WIDTH(10)
) deserializer (
    .cam_p(cam_p),
    .cam_n(cam_n),

    .ResetFromClkManager(1'b0),
    .EnableFromClkManager(1'b1),
    .MmcmAligned(1'b1),

    .RxClk(rxclk),
    .RxClkDiv(rxclkdiv),
    .Clk0Bufio(clk0bufio),
    .Clk90Bufio(clk90bufio),

    .pxclk(pxclk),
    .pixel_data_valid(pixel_data_valid),
    .receiver_locked(receiver_locked),

    .vid_active_video(vid_active_video),
    .vid_data(vid_data),
    .vid_hblank(vid_hblank),
    .vid_vblank(vid_vblank)
);

endmodule
