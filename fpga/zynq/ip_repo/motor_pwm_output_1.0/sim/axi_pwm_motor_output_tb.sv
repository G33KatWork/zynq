`timescale 1ns/1ps

module testbench();

localparam integer NUMBER_OF_MOTORS = 4;

reg rstn = 0;
reg clk = 0;
always #5 clk = ~clk;

axi_ifc axi0();




wire [NUMBER_OF_MOTORS-1:0] MOTOR_OUT;

axi_pwm_motor_output #( 
    .C_S_AXI_ACLK_FREQ_HZ(100000000),
    .C_S_AXI_DATA_WIDTH(32),
    .C_S_AXI_ADDR_WIDTH(7),
    .NUMBER_OF_MOTORS(NUMBER_OF_MOTORS)
) motors (
	.S_AXI_ACLK(clk),
	.S_AXI_ARESETN(rstn),
	.s(axi0),
	.MOTOR_OUT(MOTOR_OUT)
);




integer tick = 0;
reg [31:0]addr = 32'hffffffff;
reg [31:0]next_addr;
reg [31:0]data = 32'hffffffff;
reg [31:0]next_data;
reg do_rd = 0;
reg next_do_rd;
reg do_wr = 0;
reg next_do_wr;

axi_rw_engine engine0(
	.clk(clk),
	.m(axi0),
	.rd(do_rd),
	.wr(do_wr),
	.addr(addr),
	.data(data)
	);
	
always_comb begin
    next_do_rd = 0;
	next_do_wr = 0;
	next_addr = 32'hffffffff;
	next_data = 32'hffffffff;
	
    if (tick == 10) begin
        rstn = 1;
    
    //Read constant registers
    end else if (tick == 20) begin
        next_do_rd = 1;
        next_addr = 32'h00000000; //Timer frequency
    end else if (tick == 30) begin
        next_do_rd = 1;
        next_addr = 32'h00000004; //Number of motors
        

    //Test traditional Servo-PWM
    end else if (tick == 40) begin
        next_do_wr = 1;
        next_data = 100000000/400;
        next_addr = 32'h0000000C; //Write timer period
        
    end else if (tick == 60) begin
        next_do_wr = 1;
        next_data = 100000000/(1000000/1000);
        next_addr = 32'h00000020; //Motor 1 compare
    end else if (tick == 80) begin
        next_do_wr = 1;
        next_data = 100000000/(1000000/1333);
        next_addr = 32'h00000024; //Motor 1 compare
    end else if (tick == 100) begin
        next_do_wr = 1;
        next_data = 100000000/(1000000/1666);
        next_addr = 32'h00000028; //Motor 1 compare
    end else if (tick == 120) begin
        next_do_wr = 1;
        next_data = 100000000/(1000000/2000);
        next_addr = 32'h0000002C; //Motor 1 compare
    
    end else if (tick == 140) begin
        next_do_wr = 1;
        next_data = 32'h214d5241;
        next_addr = 32'h00000010; //ARM!
    
    //<...stare at waveforms...>
    
    end else if (tick == 2000000) begin
        next_do_wr = 1;
        next_data = 32'h00000000;
        next_addr = 32'h00000010; //Disarm
    
    
    //Test oneshot125
    end else if (tick == 3010000) begin
        next_do_wr = 1;
        next_data = 32'hffffffff;
        next_addr = 32'h0000000C; //Write timer period
   
    end else if (tick == 3010010) begin
        next_do_wr = 1;
        next_data = 100000000/(1000000/(125+(125/3)*0));
        next_addr = 32'h00000020; //Motor 1 compare
    end else if (tick == 3010020) begin
        next_do_wr = 1;
        next_data = 100000000/(1000000/(125+(125/3)*1));
        next_addr = 32'h00000024; //Motor 1 compare
    end else if (tick == 3010030) begin
        next_do_wr = 1;
        next_data = 100000000/(1000000/(125+(125/3)*2));
        next_addr = 32'h00000028; //Motor 1 compare
    end else if (tick == 3010040) begin
        next_do_wr = 1;
        next_data = 100000000/(1000000/(125+(125/3)*3));
        next_addr = 32'h0000002C; //Motor 1 compare
    
    end else if (tick == 3011060) begin
        next_do_wr = 1;
        next_data = 32'h1;
        next_addr = 32'h00000008; //Commit
    
    end else if (tick == 3011080) begin
        next_do_wr = 1;
        next_data = 32'h214d5241;
        next_addr = 32'h00000010; //ARM!
    
    end else if (tick == 3111060) begin
        next_do_wr = 1;
        next_data = 32'h1;
        next_addr = 32'h00000008; //Commit
    
   end else if (tick == 3211060) begin
        next_do_wr = 1;
        next_data = 32'h1;
        next_addr = 32'h00000008; //Commit
    
        
    end else if (tick == 3611060) begin
        $finish;
    end
end

always_ff @(posedge clk) begin
	do_rd <= next_do_rd;
	do_wr <= next_do_wr;
	addr <= next_addr;
	data <= next_data;
	tick <= tick + 1;
end

endmodule