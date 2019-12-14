`timescale 1ns / 1ps

module deserializer_top #(
    parameter IBUF_LOW_PWR="FALSE",
    parameter DIFF_TERM="TRUE",
    parameter IOSTANDARD="LVDS_25",
    parameter real IDELAYCTRL_REFCLK=200.0,
    parameter USE_EMBEDDED_SYNCS=0,
    parameter VIDEO_BIT_WIDTH=8,
    parameter STEREO_MODE=0,
    parameter C_IdlyCntVal_M=5'b00000,
    parameter C_IdlyCntVal_S=5'b00101
) (
    input wire cam_p,
    input wire cam_n,

    input wire ResetFromClkManager,
    input wire EnableFromClkManager,
    input wire MmcmAligned,

    input wire RxClk,
    input wire RxClkDiv,
    input wire Clk0Bufio,
    input wire Clk90Bufio,

    output wire pxclk,
    output wire pixel_data_valid,
    output wire receiver_locked,

    //Camera 1
    output wire vid_active_video,
    output wire [VIDEO_BIT_WIDTH-1:0] vid_data,
    output wire vid_hblank,
    output wire vid_vblank,

    //Camera 2
    output wire vid2_active_video,
    output wire [VIDEO_BIT_WIDTH-1:0] vid2_data,
    output wire vid2_hblank,
    output wire vid2_vblank,

    //Cameras Interleaved
    output wire vid_interleaved_active_video,
    output wire [VIDEO_BIT_WIDTH*2-1:0] vid_interleaved_data,
    output wire vid_interleaved_hblank,
    output wire vid_interleaved_vblank
);

wire cam_p_buffered;
wire cam_n_buffered;

wire rx_data_ready;
wire frame_valid, frame_valid2;
wire line_valid, line_valid2;
wire data_locked;



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

if(STEREO_MODE == 0) begin
    wire [11:0] rx_data;
    wire [11:0] rx_data_reversed;

    genvar i;
    for(i = 0; i < 12; i = i+1)
        assign rx_data_reversed[i] = rx_data[11-i];
        
    Receiver #(
        .C_LaneWidth(1),
        .C_DataWidth(12),
        .C_RefClkFreq(IDELAYCTRL_REFCLK),
        .C_IdlyCntVal_M(C_IdlyCntVal_M),
        .C_IdlyCntVal_S(C_IdlyCntVal_S)
    ) receiver (
        .RxD_p(cam_p_buffered),
        .RxD_n(cam_n_buffered),
        
        .ResetFromClkManager(ResetFromClkManager),
        .EnableFromClkManager(EnableFromClkManager),
        
        .RxClk(RxClk),
        .RxClkDiv(RxClkDiv),
        .Clk0Bufio(Clk0Bufio),
        .Clk90Bufio(Clk90Bufio),
        
        .RxDataClk(pxclk),
        .RxDataRdy(rx_data_ready),
        .RxData(rx_data),
        .RxDataLocked(data_locked)
    );
    
    //Sync generation
    if(USE_EMBEDDED_SYNCS == 1) begin
        embedded_sync_detector #(
            .VIDEO_BIT_WIDTH(VIDEO_BIT_WIDTH),
            .INPUT_BIT_WIDTH(10)
        ) sync_detector(
            .pxclk(pxclk),
            .reset(ResetFromClkManager),
    
            .rx_data_valid(rx_data_ready),
            .rx_data_payload(rx_data_reversed[10:1]),
    
            .line_valid(line_valid),
            .frame_valid(frame_valid),
            .active_video(vid_active_video),
            .pixel_data(vid_data),
            .pixel_data_valid(pixel_data_valid)
        );
    end else begin
        if(VIDEO_BIT_WIDTH != 8) begin
            $error("** Illegal Condition ** VIDEO_BIT_WIDTH has to be 8 if not using embedded syncs");
        end

        assign line_valid = rx_data_reversed[9];
        assign frame_valid = rx_data_reversed[10];
        assign vid_data = rx_data_reversed[8:1];
        assign pixel_data_valid = rx_data_ready;
    end
end else begin
    if(USE_EMBEDDED_SYNCS == 0) begin
        $error("** Illegal Condition ** USE_EMBEDDED_SYNCS has to be enabled in STEREO_MODE");
    end
    
    if(VIDEO_BIT_WIDTH != 8) begin
        $error("** Illegal Condition ** VIDEO_BIT_WIDTH has to be 8 in STEREO_MODE");
    end
    
    wire [17:0] rx_data;
    wire [17:0] rx_data_reversed;

    genvar i;
    for(i = 0; i < 18; i = i+1)
        assign rx_data_reversed[i] = rx_data[17-i];
    
    Receiver #(
        .C_LaneWidth(1),
        .C_DataWidth(18),
        .C_RefClkFreq(IDELAYCTRL_REFCLK),
        .C_IdlyCntVal_M(C_IdlyCntVal_M),
        .C_IdlyCntVal_S(C_IdlyCntVal_S)
    ) receiver (
        .RxD_p(cam_p_buffered),
        .RxD_n(cam_n_buffered),
        
        .ResetFromClkManager(ResetFromClkManager),
        .EnableFromClkManager(EnableFromClkManager),
        
        .RxClk(RxClk),
        .RxClkDiv(RxClkDiv),
        .Clk0Bufio(Clk0Bufio),
        .Clk90Bufio(Clk90Bufio),
        
        .RxDataClk(pxclk),
        .RxDataRdy(rx_data_ready),
        .RxData(rx_data),
        .RxDataLocked(data_locked)
    );
    
    embedded_sync_detector #(
        .VIDEO_BIT_WIDTH(8),
        .INPUT_BIT_WIDTH(8)
    ) sync_detector_cam1(
        .pxclk(pxclk),
        .reset(ResetFromClkManager | ~receiver_locked),

        .rx_data_valid(rx_data_ready),
        .rx_data_payload(rx_data_reversed[8:1]),

        .line_valid(line_valid),
        .frame_valid(frame_valid),
        .active_video(vid_active_video),
        .pixel_data(vid_data),
        .pixel_data_valid(pixel_data_valid)
    );
    
    embedded_sync_detector #(
        .VIDEO_BIT_WIDTH(8),
        .INPUT_BIT_WIDTH(8)
    ) sync_detector_cam2(
        .pxclk(pxclk),
        .reset(ResetFromClkManager | ~receiver_locked),

        .rx_data_valid(rx_data_ready),
        .rx_data_payload(rx_data_reversed[16:9]),

        .line_valid(line_valid2),
        .frame_valid(frame_valid2),
        .active_video(vid2_active_video),
        .pixel_data(vid2_data),
        .pixel_data_valid(pixel_data_valid)
    );
end

assign vid_hblank = ~line_valid;
assign vid_vblank = ~frame_valid;

assign vid2_hblank = ~line_valid2;
assign vid2_vblank = ~frame_valid2;

assign vid_interleaved_hblank = ~line_valid;
assign vid_interleaved_vblank = ~frame_valid;

assign vid_interleaved_active_video = vid_active_video;

assign vid_interleaved_data = { vid2_data, vid_data };

assign receiver_locked = data_locked && MmcmAligned;


endmodule
