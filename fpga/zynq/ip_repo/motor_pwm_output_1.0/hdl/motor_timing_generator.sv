`timescale 1ns / 1ps

module motor_timing_generator #(
    parameter integer TIMER_WIDTH = 32
)
(
    input clk,
    input rstn,
    input [TIMER_WIDTH-1:0] timer_value,
    input [TIMER_WIDTH-1:0] compare_value,
    input compare_value_latch,
    output motor_output
);

reg [TIMER_WIDTH-1:0] compare_value_latched = 0;

always_ff @(posedge clk) begin
    if(rstn == 0)
        compare_value_latched <= 0;
    else begin
        if(compare_value_latch == 1)
            compare_value_latched <= compare_value;
    end
end

assign motor_output = timer_value < compare_value_latched;

endmodule
