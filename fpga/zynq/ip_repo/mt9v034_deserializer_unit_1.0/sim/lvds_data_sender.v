`timescale 1ps/1ps

module lvds_data_sender #(
    parameter CLK_PERIOD = 37500,    //26.6666MHz
    parameter DATA_WIDTH = 10
) (
    input   wire                    clk,

    output  reg                     out_p,
    output  reg                     out_n
);

real lvds_time = ( CLK_PERIOD / ((DATA_WIDTH+2.0)*2.0) );

// create LVDS clock
reg clk_lvds = 0;
always @(clk) begin
    clk_lvds = !clk_lvds;
    repeat(DATA_WIDTH+1) begin
        #lvds_time clk_lvds = !clk_lvds;
    end
end


//reg [9:0] data = 10'b1111011101;
reg [DATA_WIDTH-1:0] data = {DATA_WIDTH{1'b0}};

//                                    STOP    MSB LSB    START
wire [DATA_WIDTH+1:0] data_framed = { 1'b0,    data,     1'b1 };
integer data_i = DATA_WIDTH;

reg output_data = 1;
/*initial begin
    output_data <= 0;
    #231432403
    output_data <= 1;
end*/

always @(posedge clk_lvds) begin
    if(output_data == 1) begin
        out_p <=  data_framed[data_i];
        out_n <= !data_framed[data_i];
    end else begin
        out_p <= 0;
        out_n <= 1;
    end

    if(data_i == DATA_WIDTH+1) begin
        data_i      <= 0;
        data <= data + 1;
    end else begin
        data <= data;
        data_i <= data_i + 1;
    end
end

endmodule
