`timescale 1 ps / 1 ps

module system_top
   (CAM_SINGLE1_SYSCLK,
    CAM_SINGLE2_SYSCLK,
    CAM_SINGLE_IIC_scl_io,
    CAM_SINGLE_IIC_sda_io,
    CAM_STEREO1_SYSCLK,
    CAM_STEREO2_SYSCLK,
    CAM_STEREO3_SYSCLK,
    CAM_STEREO4_SYSCLK,
    CAM_STEREO_IIC_scl_io,
    CAM_STEREO_IIC_sda_io,
    COPTER_CAN_rx,
    COPTER_CAN_tx,
    COPTER_I2C_scl_io,
    COPTER_I2C_sda_io,
    COPTER_MOTOR_PWM,
    COPTER_SERIAL2_cts,
    COPTER_SERIAL2_rts,
    COPTER_SERIAL2_rx,
    COPTER_SERIAL2_tx,
    COPTER_SPI_IMU_cs_mpu,
    COPTER_SPI_IMU_cs_ms5611,
    COPTER_SPI_IMU_miso,
    COPTER_SPI_IMU_mosi,
    COPTER_SPI_IMU_sclk,
    COPTER_SPI_cs,
    COPTER_SPI_miso,
    COPTER_SPI_mosi,
    COPTER_SPI_sclk,
    DDR_addr,
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
    HDMIO_IIC_scl_io,
    HDMIO_IIC_sda_io,
    SINGLE_CAM_1_n,
    SINGLE_CAM_1_p,
    SINGLE_CAM_2_n,
    SINGLE_CAM_2_p,
    STEREO_CAM_1_n,
    STEREO_CAM_1_p,
    STEREO_CAM_2_n,
    STEREO_CAM_2_p,
    STEREO_CAM_3_n,
    STEREO_CAM_3_p,
    STEREO_CAM_4_n,
    STEREO_CAM_4_p);
  output CAM_SINGLE1_SYSCLK;
  output CAM_SINGLE2_SYSCLK;
  inout CAM_SINGLE_IIC_scl_io;
  inout CAM_SINGLE_IIC_sda_io;
  output CAM_STEREO1_SYSCLK;
  output CAM_STEREO2_SYSCLK;
  output CAM_STEREO3_SYSCLK;
  output CAM_STEREO4_SYSCLK;
  inout CAM_STEREO_IIC_scl_io;
  inout CAM_STEREO_IIC_sda_io;
  input COPTER_CAN_rx;
  output COPTER_CAN_tx;
  inout COPTER_I2C_scl_io;
  inout COPTER_I2C_sda_io;
  output [5:0]COPTER_MOTOR_PWM;
  input COPTER_SERIAL2_cts;
  output COPTER_SERIAL2_rts;
  input COPTER_SERIAL2_rx;
  output COPTER_SERIAL2_tx;
  output COPTER_SPI_IMU_cs_mpu;
  output COPTER_SPI_IMU_cs_ms5611;
  input COPTER_SPI_IMU_miso;
  output COPTER_SPI_IMU_mosi;
  output COPTER_SPI_IMU_sclk;
  output COPTER_SPI_cs;
  input COPTER_SPI_miso;
  output COPTER_SPI_mosi;
  output COPTER_SPI_sclk;
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
  inout HDMIO_IIC_scl_io;
  inout HDMIO_IIC_sda_io;
  input SINGLE_CAM_1_n;
  input SINGLE_CAM_1_p;
  input SINGLE_CAM_2_n;
  input SINGLE_CAM_2_p;
  input STEREO_CAM_1_n;
  input STEREO_CAM_1_p;
  input STEREO_CAM_2_n;
  input STEREO_CAM_2_p;
  input STEREO_CAM_3_n;
  input STEREO_CAM_3_p;
  input STEREO_CAM_4_n;
  input STEREO_CAM_4_p;

  wire CAM_SINGLE1_SYSCLK;
  wire CAM_SINGLE2_SYSCLK;
  wire CAM_SINGLE_IIC_scl_i;
  wire CAM_SINGLE_IIC_scl_io;
  wire CAM_SINGLE_IIC_scl_o;
  wire CAM_SINGLE_IIC_scl_t;
  wire CAM_SINGLE_IIC_sda_i;
  wire CAM_SINGLE_IIC_sda_io;
  wire CAM_SINGLE_IIC_sda_o;
  wire CAM_SINGLE_IIC_sda_t;
  wire CAM_STEREO1_SYSCLK;
  wire CAM_STEREO2_SYSCLK;
  wire CAM_STEREO3_SYSCLK;
  wire CAM_STEREO4_SYSCLK;
  wire CAM_STEREO_IIC_scl_i;
  wire CAM_STEREO_IIC_scl_io;
  wire CAM_STEREO_IIC_scl_o;
  wire CAM_STEREO_IIC_scl_t;
  wire CAM_STEREO_IIC_sda_i;
  wire CAM_STEREO_IIC_sda_io;
  wire CAM_STEREO_IIC_sda_o;
  wire CAM_STEREO_IIC_sda_t;
  wire COPTER_CAN_rx;
  wire COPTER_CAN_tx;
  wire COPTER_I2C_scl_i;
  wire COPTER_I2C_scl_io;
  wire COPTER_I2C_scl_o;
  wire COPTER_I2C_scl_t;
  wire COPTER_I2C_sda_i;
  wire COPTER_I2C_sda_io;
  wire COPTER_I2C_sda_o;
  wire COPTER_I2C_sda_t;
  wire [5:0]COPTER_MOTOR_PWM;
  wire COPTER_SERIAL2_cts;
  wire COPTER_SERIAL2_rts;
  wire COPTER_SERIAL2_rx;
  wire COPTER_SERIAL2_tx;
  wire COPTER_SPI_IMU_cs_mpu;
  wire COPTER_SPI_IMU_cs_ms5611;
  wire COPTER_SPI_IMU_miso;
  wire COPTER_SPI_IMU_mosi;
  wire COPTER_SPI_IMU_sclk;
  wire COPTER_SPI_cs;
  wire COPTER_SPI_miso;
  wire COPTER_SPI_mosi;
  wire COPTER_SPI_sclk;
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
  wire HDMIO_IIC_scl_i;
  wire HDMIO_IIC_scl_io;
  wire HDMIO_IIC_scl_o;
  wire HDMIO_IIC_scl_t;
  wire HDMIO_IIC_sda_i;
  wire HDMIO_IIC_sda_io;
  wire HDMIO_IIC_sda_o;
  wire HDMIO_IIC_sda_t;
  wire SINGLE_CAM_1_n;
  wire SINGLE_CAM_1_p;
  wire SINGLE_CAM_2_n;
  wire SINGLE_CAM_2_p;
  wire STEREO_CAM_1_n;
  wire STEREO_CAM_1_p;
  wire STEREO_CAM_2_n;
  wire STEREO_CAM_2_p;
  wire STEREO_CAM_3_n;
  wire STEREO_CAM_3_p;
  wire STEREO_CAM_4_n;
  wire STEREO_CAM_4_p;

  IOBUF CAM_SINGLE_IIC_scl_iobuf
       (.I(CAM_SINGLE_IIC_scl_o),
        .IO(CAM_SINGLE_IIC_scl_io),
        .O(CAM_SINGLE_IIC_scl_i),
        .T(CAM_SINGLE_IIC_scl_t));
  IOBUF CAM_SINGLE_IIC_sda_iobuf
       (.I(CAM_SINGLE_IIC_sda_o),
        .IO(CAM_SINGLE_IIC_sda_io),
        .O(CAM_SINGLE_IIC_sda_i),
        .T(CAM_SINGLE_IIC_sda_t));
  IOBUF CAM_STEREO_IIC_scl_iobuf
       (.I(CAM_STEREO_IIC_scl_o),
        .IO(CAM_STEREO_IIC_scl_io),
        .O(CAM_STEREO_IIC_scl_i),
        .T(CAM_STEREO_IIC_scl_t));
  IOBUF CAM_STEREO_IIC_sda_iobuf
       (.I(CAM_STEREO_IIC_sda_o),
        .IO(CAM_STEREO_IIC_sda_io),
        .O(CAM_STEREO_IIC_sda_i),
        .T(CAM_STEREO_IIC_sda_t));
  IOBUF COPTER_I2C_scl_iobuf
       (.I(COPTER_I2C_scl_o),
        .IO(COPTER_I2C_scl_io),
        .O(COPTER_I2C_scl_i),
        .T(COPTER_I2C_scl_t));
  IOBUF COPTER_I2C_sda_iobuf
       (.I(COPTER_I2C_sda_o),
        .IO(COPTER_I2C_sda_io),
        .O(COPTER_I2C_sda_i),
        .T(COPTER_I2C_sda_t));
  IOBUF HDMIO_IIC_scl_iobuf
       (.I(HDMIO_IIC_scl_o),
        .IO(HDMIO_IIC_scl_io),
        .O(HDMIO_IIC_scl_i),
        .T(HDMIO_IIC_scl_t));
  IOBUF HDMIO_IIC_sda_iobuf
       (.I(HDMIO_IIC_sda_o),
        .IO(HDMIO_IIC_sda_io),
        .O(HDMIO_IIC_sda_i),
        .T(HDMIO_IIC_sda_t));
  system system_i
       (.CAM_SINGLE1_SYSCLK(CAM_SINGLE1_SYSCLK),
        .CAM_SINGLE2_SYSCLK(CAM_SINGLE2_SYSCLK),
        .CAM_SINGLE_IIC_scl_i(CAM_SINGLE_IIC_scl_i),
        .CAM_SINGLE_IIC_scl_o(CAM_SINGLE_IIC_scl_o),
        .CAM_SINGLE_IIC_scl_t(CAM_SINGLE_IIC_scl_t),
        .CAM_SINGLE_IIC_sda_i(CAM_SINGLE_IIC_sda_i),
        .CAM_SINGLE_IIC_sda_o(CAM_SINGLE_IIC_sda_o),
        .CAM_SINGLE_IIC_sda_t(CAM_SINGLE_IIC_sda_t),
        .CAM_STEREO1_SYSCLK(CAM_STEREO1_SYSCLK),
        .CAM_STEREO2_SYSCLK(CAM_STEREO2_SYSCLK),
        .CAM_STEREO3_SYSCLK(CAM_STEREO3_SYSCLK),
        .CAM_STEREO4_SYSCLK(CAM_STEREO4_SYSCLK),
        .CAM_STEREO_IIC_scl_i(CAM_STEREO_IIC_scl_i),
        .CAM_STEREO_IIC_scl_o(CAM_STEREO_IIC_scl_o),
        .CAM_STEREO_IIC_scl_t(CAM_STEREO_IIC_scl_t),
        .CAM_STEREO_IIC_sda_i(CAM_STEREO_IIC_sda_i),
        .CAM_STEREO_IIC_sda_o(CAM_STEREO_IIC_sda_o),
        .CAM_STEREO_IIC_sda_t(CAM_STEREO_IIC_sda_t),
        .COPTER_CAN_rx(COPTER_CAN_rx),
        .COPTER_CAN_tx(COPTER_CAN_tx),
        .COPTER_I2C_scl_i(COPTER_I2C_scl_i),
        .COPTER_I2C_scl_o(COPTER_I2C_scl_o),
        .COPTER_I2C_scl_t(COPTER_I2C_scl_t),
        .COPTER_I2C_sda_i(COPTER_I2C_sda_i),
        .COPTER_I2C_sda_o(COPTER_I2C_sda_o),
        .COPTER_I2C_sda_t(COPTER_I2C_sda_t),
        .COPTER_MOTOR_PWM(COPTER_MOTOR_PWM),
        .COPTER_SERIAL2_cts(COPTER_SERIAL2_cts),
        .COPTER_SERIAL2_rts(COPTER_SERIAL2_rts),
        .COPTER_SERIAL2_rx(COPTER_SERIAL2_rx),
        .COPTER_SERIAL2_tx(COPTER_SERIAL2_tx),
        .COPTER_SPI_IMU_cs_mpu(COPTER_SPI_IMU_cs_mpu),
        .COPTER_SPI_IMU_cs_ms5611(COPTER_SPI_IMU_cs_ms5611),
        .COPTER_SPI_IMU_miso(COPTER_SPI_IMU_miso),
        .COPTER_SPI_IMU_mosi(COPTER_SPI_IMU_mosi),
        .COPTER_SPI_IMU_sclk(COPTER_SPI_IMU_sclk),
        .COPTER_SPI_cs(COPTER_SPI_cs),
        .COPTER_SPI_miso(COPTER_SPI_miso),
        .COPTER_SPI_mosi(COPTER_SPI_mosi),
        .COPTER_SPI_sclk(COPTER_SPI_sclk),
        .DDR_addr(DDR_addr),
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
        .HDMIO_IIC_scl_i(HDMIO_IIC_scl_i),
        .HDMIO_IIC_scl_o(HDMIO_IIC_scl_o),
        .HDMIO_IIC_scl_t(HDMIO_IIC_scl_t),
        .HDMIO_IIC_sda_i(HDMIO_IIC_sda_i),
        .HDMIO_IIC_sda_o(HDMIO_IIC_sda_o),
        .HDMIO_IIC_sda_t(HDMIO_IIC_sda_t),
        .SINGLE_CAM_1_n(SINGLE_CAM_1_n),
        .SINGLE_CAM_1_p(SINGLE_CAM_1_p),
        .SINGLE_CAM_2_n(SINGLE_CAM_2_n),
        .SINGLE_CAM_2_p(SINGLE_CAM_2_p),
        .STEREO_CAM_1_n(STEREO_CAM_1_n),
        .STEREO_CAM_1_p(STEREO_CAM_1_p),
        .STEREO_CAM_2_n(STEREO_CAM_2_n),
        .STEREO_CAM_2_p(STEREO_CAM_2_p),
        .STEREO_CAM_3_n(STEREO_CAM_3_n),
        .STEREO_CAM_3_p(STEREO_CAM_3_p),
        .STEREO_CAM_4_n(STEREO_CAM_4_n),
        .STEREO_CAM_4_p(STEREO_CAM_4_p));
endmodule
