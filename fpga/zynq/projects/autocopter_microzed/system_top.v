`timescale 1 ps / 1 ps

module system_top
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    IMU_IIC_scl_io,
    IMU_IIC_sda_io,
    MOTOR_OUT,
    RECEIVER_UART_rxd,
    RECEIVER_UART_txd,
    SINGLE_CAM_IIC_scl_io,
    SINGLE_CAM_IIC_sda_io,
    SINGLE_CAM_SYSCLK,
    SINGLE_CAM_n,
    SINGLE_CAM_p,
    SPI0_MISO_I,
    SPI0_MOSI_O,
    SPI0_SCLK_O,
    SPI0_SS1_O,
    SPI0_SS2_O,
    SPI0_SS_O,
    STEREOCAM1_SYSCLK,
    STEREOCAM1_n,
    STEREOCAM1_p,
    STEREOCAM2_SYSCLK,
    STEREOCAMS_IIC_scl_io,
    STEREOCAMS_IIC_sda_io,
    single_cam_receiver_locked,
    stereocam1_receiver_locked);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  inout IMU_IIC_scl_io;
  inout IMU_IIC_sda_io;
  output [3:0]MOTOR_OUT;
  input RECEIVER_UART_rxd;
  output RECEIVER_UART_txd;
  inout SINGLE_CAM_IIC_scl_io;
  inout SINGLE_CAM_IIC_sda_io;
  output SINGLE_CAM_SYSCLK;
  input SINGLE_CAM_n;
  input SINGLE_CAM_p;
  input SPI0_MISO_I;
  output SPI0_MOSI_O;
  output SPI0_SCLK_O;
  output SPI0_SS1_O;
  output SPI0_SS2_O;
  output SPI0_SS_O;
  output STEREOCAM1_SYSCLK;
  input STEREOCAM1_n;
  input STEREOCAM1_p;
  output STEREOCAM2_SYSCLK;
  inout STEREOCAMS_IIC_scl_io;
  inout STEREOCAMS_IIC_sda_io;
  output single_cam_receiver_locked;
  output stereocam1_receiver_locked;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire IMU_IIC_scl_i;
  wire IMU_IIC_scl_io;
  wire IMU_IIC_scl_o;
  wire IMU_IIC_scl_t;
  wire IMU_IIC_sda_i;
  wire IMU_IIC_sda_io;
  wire IMU_IIC_sda_o;
  wire IMU_IIC_sda_t;
  wire [3:0]MOTOR_OUT;
  wire RECEIVER_UART_rxd;
  wire RECEIVER_UART_txd;
  wire SINGLE_CAM_IIC_scl_i;
  wire SINGLE_CAM_IIC_scl_io;
  wire SINGLE_CAM_IIC_scl_o;
  wire SINGLE_CAM_IIC_scl_t;
  wire SINGLE_CAM_IIC_sda_i;
  wire SINGLE_CAM_IIC_sda_io;
  wire SINGLE_CAM_IIC_sda_o;
  wire SINGLE_CAM_IIC_sda_t;
  wire SINGLE_CAM_SYSCLK;
  wire SINGLE_CAM_n;
  wire SINGLE_CAM_p;
  wire SPI0_MISO_I;
  wire SPI0_MOSI_O;
  wire SPI0_SCLK_O;
  wire SPI0_SS1_O;
  wire SPI0_SS2_O;
  wire SPI0_SS_O;
  wire STEREOCAM1_SYSCLK;
  wire STEREOCAM1_n;
  wire STEREOCAM1_p;
  wire STEREOCAM2_SYSCLK;
  wire STEREOCAMS_IIC_scl_i;
  wire STEREOCAMS_IIC_scl_io;
  wire STEREOCAMS_IIC_scl_o;
  wire STEREOCAMS_IIC_scl_t;
  wire STEREOCAMS_IIC_sda_i;
  wire STEREOCAMS_IIC_sda_io;
  wire STEREOCAMS_IIC_sda_o;
  wire STEREOCAMS_IIC_sda_t;
  wire single_cam_receiver_locked;
  wire stereocam1_receiver_locked;

  IOBUF IMU_IIC_scl_iobuf
       (.I(IMU_IIC_scl_o),
        .IO(IMU_IIC_scl_io),
        .O(IMU_IIC_scl_i),
        .T(IMU_IIC_scl_t));
  IOBUF IMU_IIC_sda_iobuf
       (.I(IMU_IIC_sda_o),
        .IO(IMU_IIC_sda_io),
        .O(IMU_IIC_sda_i),
        .T(IMU_IIC_sda_t));
  IOBUF SINGLE_CAM_IIC_scl_iobuf
       (.I(SINGLE_CAM_IIC_scl_o),
        .IO(SINGLE_CAM_IIC_scl_io),
        .O(SINGLE_CAM_IIC_scl_i),
        .T(SINGLE_CAM_IIC_scl_t));
  IOBUF SINGLE_CAM_IIC_sda_iobuf
       (.I(SINGLE_CAM_IIC_sda_o),
        .IO(SINGLE_CAM_IIC_sda_io),
        .O(SINGLE_CAM_IIC_sda_i),
        .T(SINGLE_CAM_IIC_sda_t));
  IOBUF STEREOCAMS_IIC_scl_iobuf
       (.I(STEREOCAMS_IIC_scl_o),
        .IO(STEREOCAMS_IIC_scl_io),
        .O(STEREOCAMS_IIC_scl_i),
        .T(STEREOCAMS_IIC_scl_t));
  IOBUF STEREOCAMS_IIC_sda_iobuf
       (.I(STEREOCAMS_IIC_sda_o),
        .IO(STEREOCAMS_IIC_sda_io),
        .O(STEREOCAMS_IIC_sda_i),
        .T(STEREOCAMS_IIC_sda_t));
  system system_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .IMU_IIC_scl_i(IMU_IIC_scl_i),
        .IMU_IIC_scl_o(IMU_IIC_scl_o),
        .IMU_IIC_scl_t(IMU_IIC_scl_t),
        .IMU_IIC_sda_i(IMU_IIC_sda_i),
        .IMU_IIC_sda_o(IMU_IIC_sda_o),
        .IMU_IIC_sda_t(IMU_IIC_sda_t),
        .MOTOR_OUT(MOTOR_OUT),
        .RECEIVER_UART_rxd(RECEIVER_UART_rxd),
        .RECEIVER_UART_txd(RECEIVER_UART_txd),
        .SINGLE_CAM_IIC_scl_i(SINGLE_CAM_IIC_scl_i),
        .SINGLE_CAM_IIC_scl_o(SINGLE_CAM_IIC_scl_o),
        .SINGLE_CAM_IIC_scl_t(SINGLE_CAM_IIC_scl_t),
        .SINGLE_CAM_IIC_sda_i(SINGLE_CAM_IIC_sda_i),
        .SINGLE_CAM_IIC_sda_o(SINGLE_CAM_IIC_sda_o),
        .SINGLE_CAM_IIC_sda_t(SINGLE_CAM_IIC_sda_t),
        .SINGLE_CAM_SYSCLK(SINGLE_CAM_SYSCLK),
        .SINGLE_CAM_n(SINGLE_CAM_n),
        .SINGLE_CAM_p(SINGLE_CAM_p),
        .SPI0_MISO_I(SPI0_MISO_I),
        .SPI0_MOSI_O(SPI0_MOSI_O),
        .SPI0_SCLK_O(SPI0_SCLK_O),
        .SPI0_SS1_O(SPI0_SS1_O),
        .SPI0_SS2_O(SPI0_SS2_O),
        .SPI0_SS_O(SPI0_SS_O),
        .STEREOCAM1_SYSCLK(STEREOCAM1_SYSCLK),
        .STEREOCAM1_n(STEREOCAM1_n),
        .STEREOCAM1_p(STEREOCAM1_p),
        .STEREOCAM2_SYSCLK(STEREOCAM2_SYSCLK),
        .STEREOCAMS_IIC_scl_i(STEREOCAMS_IIC_scl_i),
        .STEREOCAMS_IIC_scl_o(STEREOCAMS_IIC_scl_o),
        .STEREOCAMS_IIC_scl_t(STEREOCAMS_IIC_scl_t),
        .STEREOCAMS_IIC_sda_i(STEREOCAMS_IIC_sda_i),
        .STEREOCAMS_IIC_sda_o(STEREOCAMS_IIC_sda_o),
        .STEREOCAMS_IIC_sda_t(STEREOCAMS_IIC_sda_t),
        .single_cam_receiver_locked(single_cam_receiver_locked),
        .stereocam1_receiver_locked(stereocam1_receiver_locked));
endmodule
