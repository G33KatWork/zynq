`timescale 1ns / 1ps

module timer #(
    parameter integer TIMER_WIDTH = 32
)
(
    input clk,
    input rstn,
    input [TIMER_WIDTH-1:0] period,
    input force_overflow,
    output [TIMER_WIDTH-1:0] timer_value,
    output reg overflowed
);

reg [TIMER_WIDTH-1:0] timer = 0;

always_ff @(posedge clk) begin
    if(rstn == 0) begin
        timer <= 0;
        overflowed <= 0;
    end else begin
        overflowed <= 0;
        
        if(force_overflow == 1)
            timer <= period;
        else if(timer < period)
            timer <= timer + 1;
        else begin
            timer <= 0;
            if (period > 0)
                overflowed <= 1;
        end
    end
end

assign timer_value = timer;

endmodule
