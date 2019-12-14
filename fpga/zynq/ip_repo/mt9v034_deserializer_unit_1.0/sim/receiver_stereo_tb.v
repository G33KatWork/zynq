`timescale 1ps / 1ps

module receiver_stereo_tb;

parameter CAM_CLK_PERIOD = (37500);

wire cam_p, cam_n;

reg clk_data_parallel = 0;
initial forever
    //26.66666MHz
    #(CAM_CLK_PERIOD/2) clk_data_parallel = !clk_data_parallel;
    
//Main 100MHz clock for PLL
reg clk_in1_clk_sim_stereo = 0;
initial forever
    #(10000/2) clk_in1_clk_sim_stereo = !clk_in1_clk_sim_stereo;


lvds_data_sender #(
    .CLK_PERIOD(CAM_CLK_PERIOD),
    .DATA_WIDTH(16)
) data_sender (
    .clk    (clk_data_parallel),
    .out_p  (cam_p),
    .out_n  (cam_n)
);


//clock generation
wire rxclk;                             //240MHz
wire rxclkdiv;                          //120MHz
wire clk0bufio;                         //240MHz
wire clk90bufio;                        //240MHz, 90deg

wire        locked;

wire pxclk;
wire rx_data_ready;
wire [17:0] rx_data;
wire rx_data_locked;

Receiver #(
    .C_LaneWidth(1),
    .C_DataWidth(18),
    .C_RefClkFreq(300.0),
    .C_IdlyCntVal_M(5'b00000),
    .C_IdlyCntVal_S(5'b00101)           //52ps per tap @300MHz refclk, 480MHz = 2083.3333ps, 45deg phase shift: 2083.3333ps / 8 = 260,4166625ps, taps: 260,4166625ps / 52ps = 5,00801274 ~= 5
) receiver_top (
    .RxD_p(cam_p),
    .RxD_n(cam_n),
    
    .ResetFromClkManager(1'b0),
    .EnableFromClkManager(locked),
    
    .RxClk(rxclk),
    .RxClkDiv(rxclkdiv),
    .Clk0Bufio(clk0bufio),
    .Clk90Bufio(clk90bufio),
    
    .RxDataClk(pxclk),
    .RxDataRdy(rx_data_ready),
    .RxData(rx_data),
    .RxDataLocked(rx_data_locked)
);



// Clock generation

wire        rxclk_clk_sim_stereo;
wire        rxclkdiv_clk_sim_stereo;
wire        clk0bufio_clk_sim_stereo;
wire        clk90bufio_clk_sim_stereo;

wire        clkfbout_clk_sim_stereo;
wire        clkfbout_buf_clk_sim_stereo;

MMCME2_ADV
#(.BANDWIDTH            ("OPTIMIZED"),
.CLKOUT4_CASCADE      ("FALSE"),
.COMPENSATION         ("ZHOLD"),
.STARTUP_WAIT         ("FALSE"),
.DIVCLK_DIVIDE        (5),
.CLKFBOUT_MULT_F      (48.000),
.CLKFBOUT_PHASE       (0.000),
.CLKFBOUT_USE_FINE_PS ("FALSE"),
.CLKOUT0_DIVIDE_F     (4.000),
.CLKOUT0_PHASE        (0.000),
.CLKOUT0_DUTY_CYCLE   (0.500),
.CLKOUT0_USE_FINE_PS  ("FALSE"),
.CLKOUT1_DIVIDE       (8),
.CLKOUT1_PHASE        (0.000),
.CLKOUT1_DUTY_CYCLE   (0.500),
.CLKOUT1_USE_FINE_PS  ("FALSE"),
.CLKOUT2_DIVIDE       (4),
.CLKOUT2_PHASE        (0.000),
.CLKOUT2_DUTY_CYCLE   (0.500),
.CLKOUT2_USE_FINE_PS  ("FALSE"),
.CLKOUT3_DIVIDE       (4),
.CLKOUT3_PHASE        (90.000),
.CLKOUT3_DUTY_CYCLE   (0.500),
.CLKOUT3_USE_FINE_PS  ("FALSE"),
.CLKIN1_PERIOD        (10.0))
mmcm_adv_inst
// Output clocks
(
.CLKFBOUT            (clkfbout_clk_sim_stereo),
.CLKFBOUTB           (),
.CLKOUT0             (rxclk_clk_sim_stereo),
.CLKOUT0B            (),
.CLKOUT1             (rxclkdiv_clk_sim_stereo),
.CLKOUT1B            (),
.CLKOUT2             (clk0bufio_clk_sim_stereo),
.CLKOUT2B            (),
.CLKOUT3             (clk90bufio_clk_sim_stereo),
.CLKOUT3B            (),
.CLKOUT4             (),
.CLKOUT5             (),
.CLKOUT6             (),
 // Input clock control
.CLKFBIN             (clkfbout_buf_clk_sim_stereo),
.CLKIN1              (clk_in1_clk_sim_stereo),
.CLKIN2              (1'b0),
 // Tied to always select the primary input clock
.CLKINSEL            (1'b1),
// Ports for dynamic reconfiguration
.DADDR               (7'h0),
.DCLK                (1'b0),
.DEN                 (1'b0),
.DI                  (16'h0),
.DO                  (),
.DRDY                (),
.DWE                 (1'b0),
// Ports for dynamic phase shift
.PSCLK               (1'b0),
.PSEN                (1'b0),
.PSINCDEC            (1'b0),
.PSDONE              (),
// Other control and status signals
.LOCKED              (locked),
.CLKINSTOPPED        (),
.CLKFBSTOPPED        (),
.PWRDWN              (1'b0),
.RST                 (1'b0));


// Clock Monitor clock assigning
//--------------------------------------
// Output buffering
//-----------------------------------

BUFG clkf_buf
(.O (clkfbout_buf_clk_sim_stereo),
.I (clkfbout_clk_sim_stereo));

BUFG clkout1_buf
(.O   (rxclk),
.I   (rxclk_clk_sim_stereo));


BUFG clkout2_buf
(.O   (rxclkdiv),
.I   (rxclkdiv_clk_sim_stereo));

BUFG clkout3_buf
(.O   (clk0bufio),
.I   (clk0bufio_clk_sim_stereo));

BUFG clkout4_buf
(.O   (clk90bufio),
.I   (clk90bufio_clk_sim_stereo));

endmodule
