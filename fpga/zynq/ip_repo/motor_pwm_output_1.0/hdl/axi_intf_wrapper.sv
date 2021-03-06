`timescale 1ns / 1ps

module axi_intf_wrapper #(
    parameter integer C_S_AXI_ACLK_FREQ_HZ = 100000000,
    parameter integer NUMBER_OF_MOTORS      = 4
)
(
    input wire  S_AXI_ACLK,
    input wire  S_AXI_ARESETN,

    input wire [7-1 : 0] S_AXI_AWADDR,
    input wire  S_AXI_AWVALID,
    output wire  S_AXI_AWREADY,
    input wire [32-1 : 0] S_AXI_WDATA,
    input wire [(32/8)-1 : 0] S_AXI_WSTRB,
    input wire  S_AXI_WVALID,
    output wire  S_AXI_WREADY,
    output wire [1 : 0] S_AXI_BRESP,
    output wire  S_AXI_BVALID,
    input wire  S_AXI_BREADY,
    input wire [7-1 : 0] S_AXI_ARADDR,
    input wire  S_AXI_ARVALID,
    output wire  S_AXI_ARREADY,
    output wire [32-1 : 0] S_AXI_RDATA,
    output wire [1 : 0] S_AXI_RRESP,
    output wire  S_AXI_RVALID,
    input wire  S_AXI_RREADY,
    
    output wire [NUMBER_OF_MOTORS-1:0] MOTOR_OUT
);

//AXI bus interface
axi_ifc #(
    .AWIDTH(7),
    .DWIDTH(32)
) axi_ctl();

//Assign individual incoming AXI signals to axi_ctl interface
assign axi_ctl.awaddr = S_AXI_AWADDR;
assign axi_ctl.awvalid = S_AXI_AWVALID;
assign axi_ctl.awready = S_AXI_AWREADY;

assign axi_ctl.wdata = S_AXI_WDATA;
assign axi_ctl.wstrb = S_AXI_WSTRB;
assign axi_ctl.wvalid = S_AXI_WVALID;
assign axi_ctl.wready = S_AXI_WREADY;

assign axi_ctl.bresp = S_AXI_BRESP;
assign axi_ctl.bvalid = S_AXI_BVALID;
assign axi_ctl.bready = S_AXI_BREADY;

assign axi_ctl.araddr = S_AXI_ARADDR;
assign axi_ctl.arvalid = S_AXI_ARVALID;
assign axi_ctl.arready = S_AXI_ARREADY;

assign axi_ctl.rdata = S_AXI_RDATA;
assign axi_ctl.rresp = S_AXI_RRESP;
assign axi_ctl.rvalid = S_AXI_RVALID;
assign axi_ctl.rready = S_AXI_RREADY;

//instance of main controller
axi_pwm_motor_output #(
    .C_S_AXI_ACLK_FREQ_HZ(C_S_AXI_ACLK_FREQ_HZ),
    .C_S_AXI_DATA_WIDTH(32),
    .C_S_AXI_ADDR_WIDTH(7),
    .NUMBER_OF_MOTORS(NUMBER_OF_MOTORS)
) motor_output (
    .S_AXI_ACLK(S_AXI_ACLK),
    .S_AXI_ARESETN(S_AXI_ARESETN),
    .s(axi_ctl),
    .MOTOR_OUT(MOTOR_OUT)
);

endmodule
