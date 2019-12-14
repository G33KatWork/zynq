`timescale 1ns / 1ps

module axi_pwm_motor_output #(
    parameter integer C_S_AXI_ACLK_FREQ_HZ = 100000000,
    parameter integer C_S_AXI_DATA_WIDTH	= 32,
    parameter integer C_S_AXI_ADDR_WIDTH	= 7,
    parameter integer NUMBER_OF_MOTORS      = 4
)
(
    input wire  S_AXI_ACLK,
    input wire  S_AXI_ARESETN,

    axi_ifc.slave s,
    
    output wire [NUMBER_OF_MOTORS-1:0] MOTOR_OUT
);

localparam integer MOTOR_COMPARE_VAL_REG_START = 8;
localparam integer MOTOR_ARM_MAGIC_VALUE = 32'h214d5241;

reg [31:0] timer_period_reg = 32'h00000000;
reg [31:0] arm_safety_reg = 32'h00000000;
reg [31:0] motor_compare_values [NUMBER_OF_MOTORS-1:0] = '{NUMBER_OF_MOTORS{0}};

//Instantiate register access logic
wire [31:0]wdata;
reg [31:0]rdata;
wire [C_S_AXI_ADDR_WIDTH-3:0]wreg;
wire [C_S_AXI_ADDR_WIDTH-3:0]rreg;
wire wr;
wire rd;

axi_registers #(
    .R_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH-2)
) regs (
	.clk(S_AXI_ACLK),
	.s(s),
	.o_rreg(rreg),
	.o_wreg(wreg),
	.i_rdata(rdata),
	.o_wdata(wdata),
	.o_rd(rd),
	.o_wr(wr)
);

//register read
always_comb begin
    if(rreg == 0)
        rdata = C_S_AXI_ACLK_FREQ_HZ;
    else if(rreg == 1)
        rdata = NUMBER_OF_MOTORS;
    else if(rreg == 3)
        rdata = timer_period_reg;
    else if(rreg == 4)
        rdata = arm_safety_reg;
    else if(rreg >= MOTOR_COMPARE_VAL_REG_START && (rreg - MOTOR_COMPARE_VAL_REG_START) < NUMBER_OF_MOTORS)
        rdata = motor_compare_values[rreg - MOTOR_COMPARE_VAL_REG_START];
    else
        rdata = 0;
end

//register write
always_ff @(posedge S_AXI_ACLK) begin
	if(S_AXI_ARESETN == 0) begin
	   timer_period_reg <= 0;
	   arm_safety_reg <= 0;
	   motor_compare_values <= '{NUMBER_OF_MOTORS{0}};
	end else if (wr) begin
        if(wreg == 3)
            timer_period_reg <= wdata;
        else if(wreg == 4)
            arm_safety_reg <= wdata;
        else if(wreg >= MOTOR_COMPARE_VAL_REG_START && (wreg - MOTOR_COMPARE_VAL_REG_START) < NUMBER_OF_MOTORS)
            motor_compare_values[wreg - MOTOR_COMPARE_VAL_REG_START] <= wdata;
	end
end

//Instantiate timer
wire [31:0] timer_value;
wire timer_overflowed;

timer timer(
    .clk(S_AXI_ACLK),
    .rstn(S_AXI_ARESETN),
    .period(timer_period_reg),
    .force_overflow(wr && wreg == 2),   //write to commit oneshot values register
    .timer_value(timer_value),
    .overflowed(timer_overflowed)
);

//Generate motor timing comparators
wire motor_compare_outputs [0:NUMBER_OF_MOTORS-1];

generate
    genvar i;
    for (i = 0; i < NUMBER_OF_MOTORS; i++) begin : motor_timing_generator
        motor_timing_generator motor_timing_generator(
            .clk(S_AXI_ACLK),
            .rstn(S_AXI_ARESETN),
            .timer_value(timer_value),
            .compare_value(motor_compare_values[i]),
            .compare_value_latch(timer_overflowed),
            .motor_output(motor_compare_outputs[i])
        );
        assign MOTOR_OUT[i] = (arm_safety_reg == MOTOR_ARM_MAGIC_VALUE) ? motor_compare_outputs[i] : 0;
    end
endgenerate

endmodule
