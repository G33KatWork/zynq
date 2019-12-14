module pixel_input (
	input clk,

	input [9:0] PIXEL_DATA,
	input LINE_VALID,
	input FRAME_VALID,
	input DATA_VALID,

	output m_axis_tvalid,
	output m_axis_tlast,
	output [9:0] m_axis_tdata,
	output m_axis_tuser
);

/********* Input *********/

reg[9:0] data;
reg[9:0] data_d;
reg[9:0] data_d2;
reg[9:0] data_d3;
always @ (posedge clk)
begin
    if(DATA_VALID) begin
        data <= PIXEL_DATA;
        data_d <= data;
        data_d2 <= data_d;
        data_d3 <= data_d2;
    end;
end
assign m_axis_tdata = data_d3;

reg line_valid_latched;
always @ (posedge clk)
begin
    if(DATA_VALID) begin
        line_valid_latched <= LINE_VALID;
    end;
end

reg frame_valid_latched;
always @ (posedge clk)
begin
    if(DATA_VALID) begin
        frame_valid_latched <= FRAME_VALID;
    end;
end

reg data_valid_latched;
always @ (posedge clk)
begin
    data_valid_latched <= DATA_VALID;
end

/********* Edge detection of LINE_VALID *********/

reg line_valid_prev = 0;
always @(posedge clk) begin
    if(DATA_VALID) begin
        line_valid_prev <= line_valid_latched;
    end;
end
wire line_valid_falling = line_valid_prev && !line_valid_latched;

/********* Output *********/

reg tvalid;
reg tvalid_d;
always @ (posedge clk)
begin
	tvalid_d <= tvalid;
end
assign m_axis_tvalid = tvalid_d & data_valid_latched;

reg tuser;
reg tuser_d;
always @ (posedge clk)
begin
	tuser_d <= tuser;
end
assign m_axis_tuser = tuser_d;

reg tlast;
assign m_axis_tlast = tlast;

/********** Statemachine *********/

parameter SKIP_RUNNING_FRAME=0,
    WAIT_FOR_FRAME_START=1,
    WAIT_FOR_LINE_START=2,
    CAPTURE_LINE=3,
    CAPTURE_FIRST_LINE=4,
    CAPTURE_LAST_PIXEL = 6,
    WAIT_FOR_FIRST_LINE_START=5,
    CAPTURE_FIRST_PIXEL_OF_FIRST_LINE = 7;

reg [2:0] state = SKIP_RUNNING_FRAME;

always @(state) begin
    case(state)
        SKIP_RUNNING_FRAME: begin
            tvalid <= 0;
            tlast <= 0;
            tuser <= 0;
        end
        
        WAIT_FOR_FRAME_START: begin
            tvalid <= 0;
            tlast <= 0;
            tuser <= 0;
        end
        
        WAIT_FOR_FIRST_LINE_START: begin
            tvalid <= 0;
            tlast <= 0;
            tuser <= 0;
        end
        
        CAPTURE_FIRST_PIXEL_OF_FIRST_LINE: begin
            tvalid <= 1;
            tlast <= 0;
            tuser <= 1;
        end
        
        CAPTURE_FIRST_LINE: begin
            tvalid <= 1;
            tlast <= 0;
            tuser <= 0;
        end
        
        WAIT_FOR_LINE_START: begin
            tvalid <= 0;
            tlast <= 0;
            tuser <= 0;
        end
        
        CAPTURE_LINE: begin
            tvalid <= 1;
            tlast <= 0;
            tuser <= 0;
        end
        
        CAPTURE_LAST_PIXEL: begin
            tvalid <= 0;
            tlast <= 1;
            tuser <= 0;
        end
        
        default: begin
            tvalid <= 0;
            tlast <= 0;
            tuser <= 0;
        end
    endcase
end

always @(posedge clk) begin
    if(DATA_VALID) begin
        case(state)
            SKIP_RUNNING_FRAME:
                if(!line_valid_latched)
                    state <= WAIT_FOR_FIRST_LINE_START;
                else
                    state <= SKIP_RUNNING_FRAME;
           
            WAIT_FOR_FIRST_LINE_START:
                if(line_valid_latched)
                    state <= CAPTURE_FIRST_PIXEL_OF_FIRST_LINE;
                else
                    state <= WAIT_FOR_FIRST_LINE_START;
            
            CAPTURE_FIRST_PIXEL_OF_FIRST_LINE:
                state <= CAPTURE_FIRST_LINE;
            
            CAPTURE_FIRST_LINE:
                if(line_valid_falling)
                    state <= CAPTURE_LAST_PIXEL;
                else
                    state <= CAPTURE_FIRST_LINE;
            
            WAIT_FOR_LINE_START:
                if(line_valid_latched)
                    state <= CAPTURE_LINE;
                else if(!frame_valid_latched)
                    state <= WAIT_FOR_FIRST_LINE_START;
                else
                    state <= WAIT_FOR_LINE_START;
    
            CAPTURE_LINE:
                if(line_valid_falling)
                    state <= CAPTURE_LAST_PIXEL;
                else
                    state <= CAPTURE_LINE;
            
            CAPTURE_LAST_PIXEL:
                state <= WAIT_FOR_LINE_START;
    
            default:
                state <= SKIP_RUNNING_FRAME;
        endcase
    end
end

endmodule
