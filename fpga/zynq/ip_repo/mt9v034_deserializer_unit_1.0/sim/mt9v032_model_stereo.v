`timescale 1ps/1ps

/* NOTES
    Clk frequencies for real cam:
    Input: 26.666MHz (37.5 ns)
    LVDS in standalone: 320MHz (input * 12)
    LVDS in stereoscopy: 480MHz (input * 18)
    
    !!!This model has embedded syncs!!!
*/

module mt9v032_model_stereo #(
    parameter CLK_PERIOD = 37500,
    parameter CLK_DELAY = 0.0,

    parameter HPX = 64,     // horizontal pixels (visible)
    parameter VPX = 48,     // vertical lines (visible)
    parameter HBLANK = 24,  // horizontal blanking pixels
    parameter VBLANK = 24   // vertical blanking lines
) (
    input   wire                    clk,

    output  reg                     out_p,
    output  reg                     out_n
);

wire clk_px;

assign #CLK_DELAY clk_px = clk;

// measure clock period
time period;
time prev_time;
real lvds_time = ( CLK_PERIOD / 36.0 ); //18 bits over LVDS per clock

always @(posedge clk_px) begin
    period          = $time - prev_time;
    prev_time       = $time;

    // lvds period is running average
    lvds_time       = lvds_time*0.75 + (period/36.0)*0.25;
end

// create LVDS clock
reg clk_lvds = 0;
always @(clk_px) begin
    clk_lvds = !clk_lvds;
    repeat(17) begin
        #lvds_time clk_lvds = !clk_lvds;
    end
end


reg [7:0] data = 0;
wire [17:0] data_framed = { 1'b0, data[7:0], data[7:0], 1'b1 };
integer data_i = 0;

reg frame_valid = 0;
reg line_valid  = 0;

integer x = 0;
integer y = 0;


always @(posedge clk_lvds) begin
    out_p <=  data_framed[data_i];
    out_n <= !data_framed[data_i];

    if(data_i == 17) begin
        data_i      <= 0;

        x <= x + 1;
        if(x == (HPX+HBLANK-1)) begin
            x <= 0;
            y <= y + 1;
            if(y == (VPX+VBLANK-1)) begin
                y <= 0;
            end
        end

        if(frame_valid && line_valid) begin
            data <= x+y+4; // visible pixels
        end else begin
            data <= 8'd4;
        end                

        if(x == (HPX+HBLANK-1)) begin // last blanking pixel
            if(frame_valid) begin
                data <= 8'd1;
                line_valid <= 1'b1;
            end
        end

        if(x == HPX) begin // first blanking pixel
            line_valid <= 1'b0;
            if(frame_valid) begin
                data <= 8'd2;
            end
        end

        if(y == (VPX+VBLANK-1)) begin // last blanking line
            case(x)
                (HPX+HBLANK-4): begin data <= 8'd255; end
                (HPX+HBLANK-3): begin data <= 8'd0; end
                (HPX+HBLANK-2): begin data <= 8'd255; frame_valid <= 1'b1; end
            endcase
        end

        if(y == (VPX-1)) begin // last visible line
            if(x == HPX+1) begin // first blanking pixel
                data <= 8'd3;
                frame_valid <= 1'b0;
            end
        end

    end else begin
        data_i <= data_i + 1;
    end
end

endmodule
