`timescale 1ns / 1ps

module testbench;
	// Inputs
	reg PIXCLK = 1'b0;
	reg LINE_VALID;
	reg FRAME_VALID;
	reg [9:0] DATA_IN;
	reg DATA_VALID = 1'b0;

    reg axisclk = 1'b0;
    reg axisrst;
    reg m_axis_tready;

	// Outputs
	wire [15:0] m_axis_tdata;
	wire m_axis_tvalid;
	wire m_axis_tlast;
	wire m_axis_tuser;
	
	
	// Generate clocks
	always #2.5 PIXCLK <= ~PIXCLK;
    always #1.25 axisclk <= ~axisclk;

	// Generate DATA_VALID every other camera clock cycle
	always @ (posedge PIXCLK) begin
       DATA_VALID <= ~DATA_VALID;
    end
	

	// Instantiate the Unit Under Test (UUT)
	mt9v034_input uut (
		.pclk(PIXCLK),
		.LINE_VALID(LINE_VALID), 
		.FRAME_VALID(FRAME_VALID), 
		.PIXEL_DATA(DATA_IN),
		.DATA_VALID(DATA_VALID),
		
		.axi4sclk(axisclk),
		.axi4s_resetn(axisrst),
		.m_axis_tready(m_axis_tready),
		.m_axis_tdata(m_axis_tdata), 
		.m_axis_tvalid(m_axis_tvalid), 
		.m_axis_tlast(m_axis_tlast), 
		.m_axis_tuser(m_axis_tuser)
	);
	
	
	reg [9:0] i;

	initial begin
		// Initialize Inputs
		m_axis_tready = 1;
		
		axisrst = 0;
		#100
		axisrst = 1;
		
		LINE_VALID = 1;
		FRAME_VALID = 1;
		DATA_IN = 0;
		// Test ignoring of random already ongoing frame
		#42;
		#42;
		#42;
		#42;
		#42;
		LINE_VALID = 0;
		FRAME_VALID = 0;
		#20;
		
		
		//frame start
		FRAME_VALID = 1;
		#710; //frame start blanking = 71*clock
		
		//active data (line 1)
		LINE_VALID = 1;
		for(i = 0; i < 752; i = i + 1) begin
		  DATA_IN = i+1;
		  #10;
		end
		LINE_VALID = 0;
        DATA_IN = 0;
		
		#940; //horizontal blanking = 94*clock
		
		//active data (line 2)
		LINE_VALID = 1;
        for(i = 0; i < 752; i = i + 1) begin
          DATA_IN = i+1;
          #10;
        end
        LINE_VALID = 0;
        DATA_IN = 0;
        
        //frame end blanking = 23*clock
        #230;
        FRAME_VALID = 0;
        
        //vertical blanking = 38074*clock
        #380740;
        
        
        
        
        //frame start
        FRAME_VALID = 1;
        #710; //frame start blanking = 71*clock
        
        //active data (line 1)
        LINE_VALID = 1;
        for(i = 0; i < 752; i = i + 1) begin
          DATA_IN = i+1;
          #10;
        end
        LINE_VALID = 0;
        DATA_IN = 0;
        
        #940; //horizontal blanking = 94*clock
        
        //active data (line 2)
        LINE_VALID = 1;
        for(i = 0; i < 752; i = i + 1) begin
          DATA_IN = i+1;
          #10;
        end
        LINE_VALID = 0;
        DATA_IN = 0;
        
        //frame end blanking = 23*clock
        #230;
        FRAME_VALID = 0;
        
        //vertical blanking = 38074*clock
        #380740;
        
        $finish;
        
		
		
		/*FRAME_VALID = 1;
		#20
		LINE_VALID = 1;
		DATA_IN = 11;
		#10
		LINE_VALID = 1;
		DATA_IN = 12;
		#10
		LINE_VALID = 1;
		DATA_IN = 13;
		#10
		LINE_VALID = 0;
		#10
		
		LINE_VALID = 1;
		DATA_IN = 21;
		#10
		LINE_VALID = 1;
		DATA_IN = 22;
		#10
        LINE_VALID = 1;
        DATA_IN = 23;
        #10
		LINE_VALID = 0;
		#10
		
		LINE_VALID = 1;
		DATA_IN = 31;
		#10
		LINE_VALID = 1;
		DATA_IN = 32;
		#10
        LINE_VALID = 1;
        DATA_IN = 33;
        #10
		LINE_VALID = 0;
		#20
		
		FRAME_VALID = 0;
		
		
		#40; 
        FRAME_VALID = 1;
        #20
        LINE_VALID = 1;
        DATA_IN = 11;
        #10
        LINE_VALID = 1;
        DATA_IN = 12;
        #10
        LINE_VALID = 1;
        DATA_IN = 13;
        #10
        LINE_VALID = 0;
        #10
        
        LINE_VALID = 1;
        DATA_IN = 21;
        #10
        LINE_VALID = 1;
        DATA_IN = 22;
        #10
        LINE_VALID = 1;
        DATA_IN = 23;
        #10
        LINE_VALID = 0;
        #10
        
        LINE_VALID = 1;
        DATA_IN = 31;
        #10
        LINE_VALID = 1;
        DATA_IN = 32;
        #10
        LINE_VALID = 1;
        DATA_IN = 33;
        #10
        LINE_VALID = 0;
        #10
        
        FRAME_VALID = 0;*/
		
		#20
		$finish;

	end

endmodule
