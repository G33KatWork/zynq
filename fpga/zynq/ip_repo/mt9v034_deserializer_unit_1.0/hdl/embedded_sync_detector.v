`timescale 1ns / 1ps

module embedded_sync_detector #(
    parameter VIDEO_BIT_WIDTH = 8,
    parameter INPUT_BIT_WIDTH = 10
) (
    input wire pxclk,
    input wire reset,

    input wire rx_data_valid,
    input wire [INPUT_BIT_WIDTH-1:0] rx_data_payload,

    output wire line_valid,
    output wire frame_valid,
    output wire active_video,
    output wire [VIDEO_BIT_WIDTH-1:0] pixel_data,
    output wire pixel_data_valid
);

reg line_valid_r = 1'b0;
reg frame_valid_r = 1'b0;
reg [VIDEO_BIT_WIDTH-1:0] vid_data_d;
reg rx_data_ready_d;

reg line_valid_old_r = 1'b0;
reg frame_valid_old_r = 1'b0;

//logic for detecting frame_valid and line_valid
always @(posedge pxclk) begin
    if(reset) begin
        line_valid_r <= 1'b0;
        frame_valid_r <= 1'b0;
        
        line_valid_old_r <= 1'b0;
        frame_valid_old_r <= 1'b0;

    end else begin
        if(rx_data_valid) begin
            line_valid_old_r <= line_valid_r;
            frame_valid_old_r <= frame_valid_r;

            case (rx_data_payload[INPUT_BIT_WIDTH-1:0])
                0: frame_valid_r <= 1'b1;
                1: line_valid_r  <= 1'b1;
                2: line_valid_r  <= 1'b0;
                3: frame_valid_r <= 1'b0;
            endcase
        end
    end
end

//delay some stuff
always @(posedge pxclk) begin
    if(reset) begin
        vid_data_d <= {VIDEO_BIT_WIDTH{1'b0}};
        rx_data_ready_d <= 1'b0;
    end else begin
        vid_data_d <= rx_data_payload[INPUT_BIT_WIDTH-1:INPUT_BIT_WIDTH-VIDEO_BIT_WIDTH];
        rx_data_ready_d <= rx_data_valid;
    end
end

//output
assign line_valid = line_valid_r;
assign frame_valid = frame_valid_r;
assign pixel_data = vid_data_d;
assign pixel_data_valid = rx_data_ready_d;
assign active_video = line_valid && frame_valid && !(line_valid_old_r == 0 && line_valid_r == 1 || frame_valid_old_r == 0 && frame_valid_r == 1);

endmodule
