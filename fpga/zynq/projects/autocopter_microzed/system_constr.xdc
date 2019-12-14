# IMU IIC
#JY1
set_property PACKAGE_PIN U7 [get_ports IMU_IIC_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports IMU_IIC_scl_io]

#JY2
set_property PACKAGE_PIN V7 [get_ports IMU_IIC_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports IMU_IIC_sda_io]


# IMU SPI
#JY3
set_property PACKAGE_PIN T9 [get_ports SPI0_MOSI_O]
set_property IOSTANDARD LVCMOS33 [get_ports SPI0_MOSI_O]

#JY4
set_property PACKAGE_PIN U10 [get_ports SPI0_MISO_I]
set_property IOSTANDARD LVCMOS33 [get_ports SPI0_MISO_I]

#JY7
set_property PACKAGE_PIN V8 [get_ports SPI0_SCLK_O]
set_property IOSTANDARD LVCMOS33 [get_ports SPI0_SCLK_O]

#JY8
set_property PACKAGE_PIN W8 [get_ports SPI0_SS_O]
set_property IOSTANDARD LVCMOS33 [get_ports SPI0_SS_O]

#JY9
set_property PACKAGE_PIN T5 [get_ports SPI0_SS1_O]
set_property IOSTANDARD LVCMOS33 [get_ports SPI0_SS1_O]

#JY10
set_property PACKAGE_PIN U5 [get_ports SPI0_SS2_O]
set_property IOSTANDARD LVCMOS33 [get_ports SPI0_SS2_O]


# Receiver UART
#JZ1
set_property IOSTANDARD LVCMOS33 [get_ports RECEIVER_UART_rxd]
set_property PACKAGE_PIN Y12 [get_ports RECEIVER_UART_rxd]

#JZ2
set_property IOSTANDARD LVCMOS33 [get_ports RECEIVER_UART_txd]
set_property PACKAGE_PIN Y13 [get_ports RECEIVER_UART_txd]


# Motor output
#JZ4,8,9,10
set_property IOSTANDARD LVCMOS33 [get_ports {MOTOR_OUT[0]}]
set_property PACKAGE_PIN V10 [get_ports {MOTOR_OUT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {MOTOR_OUT[1]}]
set_property PACKAGE_PIN V5 [get_ports {MOTOR_OUT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {MOTOR_OUT[2]}]
set_property PACKAGE_PIN V6 [get_ports {MOTOR_OUT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {MOTOR_OUT[3]}]
set_property PACKAGE_PIN W6 [get_ports {MOTOR_OUT[3]}]


############### CAM1 (Single) ###############

#JD1
set_property PACKAGE_PIN R16 [get_ports SINGLE_CAM_IIC_scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports SINGLE_CAM_IIC_scl_io]
set_property SLEW SLOW [get_ports SINGLE_CAM_IIC_scl_io]

#JD2
set_property PACKAGE_PIN R17 [get_ports SINGLE_CAM_IIC_sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports SINGLE_CAM_IIC_sda_io]
set_property SLEW SLOW [get_ports SINGLE_CAM_IIC_sda_io]

#JD7
set_property PACKAGE_PIN V17 [get_ports SINGLE_CAM_SYSCLK]
set_property IOSTANDARD LVCMOS25 [get_ports SINGLE_CAM_SYSCLK]

#JC1 CAM1 data_p
#JC2 CAM1 data_n
set_property PACKAGE_PIN N18 [get_ports SINGLE_CAM_p]
set_property PACKAGE_PIN P19 [get_ports SINGLE_CAM_n]


############### CAM2 (Stereo) ###############

#JG1
set_property PACKAGE_PIN G17 [get_ports STEREOCAMS_IIC_scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports STEREOCAMS_IIC_scl_io]
set_property SLEW SLOW [get_ports STEREOCAMS_IIC_scl_io]

#JG2
set_property PACKAGE_PIN G18 [get_ports STEREOCAMS_IIC_sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports STEREOCAMS_IIC_sda_io]
set_property SLEW SLOW [get_ports STEREOCAMS_IIC_sda_io]

#JG7
set_property PACKAGE_PIN H16 [get_ports STEREOCAM1_SYSCLK]
set_property IOSTANDARD LVCMOS25 [get_ports STEREOCAM1_SYSCLK]

#JG8
set_property PACKAGE_PIN H17 [get_ports STEREOCAM2_SYSCLK]
set_property IOSTANDARD LVCMOS25 [get_ports STEREOCAM2_SYSCLK]

#JH1 CAM1 data_p
#JH2 CAM1 data_n
set_property PACKAGE_PIN K14 [get_ports STEREOCAM1_p]
set_property PACKAGE_PIN J14 [get_ports STEREOCAM1_n]


############### Debug Signals ###############

#LED1
set_property PACKAGE_PIN U14 [get_ports single_cam_receiver_locked]
set_property IOSTANDARD LVCMOS25 [get_ports single_cam_receiver_locked]

#LED2
set_property PACKAGE_PIN U15 [get_ports stereocam1_receiver_locked]
set_property IOSTANDARD LVCMOS25 [get_ports stereocam1_receiver_locked]
