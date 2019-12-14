module mt9v034_input (
	input pclk,
	input [9:0] PIXEL_DATA,
	input LINE_VALID,
	input FRAME_VALID,
	input DATA_VALID,

    input axi4sclk,
    input axi4s_resetn,
	input m_axis_tready,
	output m_axis_tvalid,
	output m_axis_tlast,
	output [15:0] m_axis_tdata,
	output m_axis_tuser
);

wire [9:0] cam_tdata;
wire cam_tvalid;
wire cam_tlast;
wire cam_tuser;

/*wire [11:0] axi4s_fifo_read;
wire axi4s_fifo_empty;
wire axi4s_fifo_valid;
assign m_axis_tuser = axi4s_fifo_read[11] & axi4s_fifo_valid;
assign m_axis_tlast = axi4s_fifo_read[10] & axi4s_fifo_valid;
assign m_axis_tdata = {6'b0, axi4s_fifo_read[9:0]};
assign m_axis_tvalid = axi4s_fifo_valid;*/

pixel_input camera_pixel_into (
    .clk(pclk),
    .PIXEL_DATA(PIXEL_DATA),
    .LINE_VALID(LINE_VALID),
    .FRAME_VALID(FRAME_VALID),
    .DATA_VALID(DATA_VALID),

    .m_axis_tvalid(cam_tvalid),
    .m_axis_tlast(cam_tlast),
    .m_axis_tdata(cam_tdata),
    .m_axis_tuser(cam_tuser)
);

pixel_fifo axi4s_pixel_fifo (
  .m_aclk(axi4sclk),                // input wire m_aclk
  .s_aclk(pclk),                // input wire s_aclk
  .s_aresetn(axi4s_resetn),       // input wire s_aresetn
  
  .s_axis_tvalid(cam_tvalid),  // input wire s_axis_tvalid
  .s_axis_tready(),  // output wire s_axis_tready
  .s_axis_tdata({6'b0, cam_tdata}),    // input wire [15 : 0] s_axis_tdata
  .s_axis_tlast(cam_tlast),    // input wire s_axis_tlast
  .s_axis_tuser(cam_tuser),    // input wire [0 : 0] s_axis_tuser
  
  .m_axis_tvalid(m_axis_tvalid),  // output wire m_axis_tvalid
  .m_axis_tready(m_axis_tready),  // input wire m_axis_tready
  .m_axis_tdata(m_axis_tdata),    // output wire [15 : 0] m_axis_tdata
  .m_axis_tlast(m_axis_tlast),    // output wire m_axis_tlast
  .m_axis_tuser(m_axis_tuser)    // output wire [0 : 0] m_axis_tuser
);

/*pixel_fifo axi4s_pixel_fifo (
    .rst(~axi4s_resetn),
    
    .wr_clk(pclk),
    .wr_en(cam_tvalid),
    .din({cam_tuser, cam_tlast, cam_tdata}),
    
    .rd_clk(axi4sclk),
    .rd_en(m_axis_tready & ~axi4s_fifo_empty),
    .dout(axi4s_fifo_read),
    .valid(axi4s_fifo_valid),
    
    .full(),
    .empty(axi4s_fifo_empty)
);*/

endmodule
