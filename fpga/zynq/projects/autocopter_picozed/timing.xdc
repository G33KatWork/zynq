################# Single Cam #################

#rename a few generated MMCM clocks because the automatically derived names are too confusing
create_generated_clock -name IDELAYCTRL_RefClk_cams_single [get_pins system_i/cams_single/cam_single_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT0]
create_generated_clock -name IntClk0_cams_single [get_pins system_i/cams_single/cam_single_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT1]
create_generated_clock -name IntClk90_cams_single [get_pins system_i/cams_single/cam_single_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT2]
create_generated_clock -name RxClkDiv_cams_single [get_pins system_i/cams_single/cam_single_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT3]
create_generated_clock -name RxClk_cams_single [get_pins system_i/cams_single/cam_single_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT4]

#buffered clocks through BUFIOs
create_clock -period 6.250 -name IntClk0Bufio_cams_single [get_pins system_i/cams_single/cam_single_clk_infra/inst/clock_infrastructure/Receiver_I_Bufio_Clk0/O]
create_clock -period 6.250 -name IntClk90Bufio_cams_single [get_pins system_i/cams_single/cam_single_clk_infra/inst/clock_infrastructure/Receiver_I_Bufio_Clk90/O]

#false paths between the clocks
set_false_path -from [get_clocks IDELAYCTRL_RefClk_cams_single] -to [get_clocks {IntClk0_cams_single IntClk0Bufio_cams_single IntClk90_cams_single IntClk90Bufio_cams_single RxClkDiv_cams_single RxClk_cams_single}]
set_false_path -from [get_clocks {IntClk0_cams_single IntClk0Bufio_cams_single}] -to [get_clocks {IDELAYCTRL_RefClk_cams_single IntClk90_cams_single IntClk90Bufio_cams_single RxClkDiv_cams_single RxClk_cams_single}]
set_false_path -from [get_clocks {IntClk90_cams_single IntClk90Bufio_cams_single}] -to [get_clocks {IDELAYCTRL_RefClk_cams_single IntClk0_cams_single IntClk0Bufio_cams_single RxClkDiv_cams_single RxClk_cams_single}]
set_false_path -from [get_clocks RxClkDiv_cams_single] -to [get_clocks {IDELAYCTRL_RefClk_cams_single IntClk0_cams_single IntClk0Bufio_cams_single IntClk90_cams_single IntClk90Bufio_cams_single RxClk_cams_single}]
set_false_path -from [get_clocks RxClk_cams_single] -to [get_clocks {IDELAYCTRL_RefClk_cams_single IntClk0_cams_single IntClk0Bufio_cams_single IntClk90_cams_single IntClk90Bufio_cams_single RxClkDiv_cams_single}]


set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/ID*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/II*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/E*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/ID*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/II*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/E*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/ID*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/II*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/E*}] 6.250


set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/R*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/S*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/T*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/D*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/R*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/S*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/T*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/D*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/R*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/S*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/T*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/D*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/R*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/S*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/T*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Gen_1*.Receiver_I_Dru/D*}] 12.500

# The MMCM alignment state machine runs at 80 MHz.
#FIXME: do I need this?
#set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Receiver_I_MmcmAlign/*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_single/*/Receiver_I_MmcmAlign/*}] 12.500

#location constraints
#create_pblock pblock_cams_single
#add_cells_to_pblock [get_pblocks pblock_cams_single] [get_cells -quiet [list {system_i/cams_single/mt9v034_lvds_deserializer_cams_single/inst/receiver/Gen_1[1].Receiver_I_Dru}]]
#resize_pblock [get_pblocks pblock_cams_single] -add {SLICE_X98Y72:SLICE_X113Y74}

set_property LOC ILOGIC_X1Y185 [get_cells system_i/cams_single/cam_single_clk_infra/inst/clock_infrastructure/Receiver_I_MmcmAlign/MmcmAlign_I_MmcmAlignIo/MmcmAlignIo_I_Isrdse2_Clk]




################# Stereo Cams #################

#rename a few generated MMCM clocks because the automatically derived names are too confusing
create_generated_clock -name IDELAYCTRL_RefClk_cams_stereo [get_pins system_i/cams_stereo/cam_stereo_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT0]
create_generated_clock -name IntClk0_cams_stereo [get_pins system_i/cams_stereo/cam_stereo_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT1]
create_generated_clock -name IntClk90_cams_stereo [get_pins system_i/cams_stereo/cam_stereo_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT2]
create_generated_clock -name RxClkDiv_cams_stereo [get_pins system_i/cams_stereo/cam_stereo_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT3]
create_generated_clock -name RxClk_cams_stereo [get_pins system_i/cams_stereo/cam_stereo_clk_infra/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT4]

#buffered clocks through BUFIOs
create_clock -period 4.167 -name IntClk0Bufio_cams_stereo [get_pins system_i/cams_stereo/cam_stereo_clk_infra/inst/clock_infrastructure/Receiver_I_Bufio_Clk0/O]
create_clock -period 4.167 -name IntClk90Bufio_cams_stereo [get_pins system_i/cams_stereo/cam_stereo_clk_infra/inst/clock_infrastructure/Receiver_I_Bufio_Clk90/O]

#false paths between the clocks
set_false_path -from [get_clocks IDELAYCTRL_RefClk_cams_stereo] -to [get_clocks {IntClk0_cams_stereo IntClk0Bufio_cams_stereo IntClk90_cams_stereo IntClk90Bufio_cams_stereo RxClkDiv_cams_stereo RxClk_cams_stereo}]
set_false_path -from [get_clocks {IntClk0_cams_stereo IntClk0Bufio_cams_stereo}] -to [get_clocks {IDELAYCTRL_RefClk_cams_stereo IntClk90_cams_stereo IntClk90Bufio_cams_stereo RxClkDiv_cams_stereo RxClk_cams_stereo}]
set_false_path -from [get_clocks {IntClk90_cams_stereo IntClk90Bufio_cams_stereo}] -to [get_clocks {IDELAYCTRL_RefClk_cams_stereo IntClk0_cams_stereo IntClk0Bufio_cams_stereo RxClkDiv_cams_stereo RxClk_cams_stereo}]
set_false_path -from [get_clocks RxClkDiv_cams_stereo] -to [get_clocks {IDELAYCTRL_RefClk_cams_stereo IntClk0_cams_stereo IntClk0Bufio_cams_stereo IntClk90_cams_stereo IntClk90Bufio_cams_stereo RxClk_cams_stereo}]
set_false_path -from [get_clocks RxClk_cams_stereo] -to [get_clocks {IDELAYCTRL_RefClk_cams_stereo IntClk0_cams_stereo IntClk0Bufio_cams_stereo IntClk90_cams_stereo IntClk90Bufio_cams_stereo RxClkDiv_cams_stereo}]


set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/ID*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/II*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/E*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/ID*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/II*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/E*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/ID*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/II*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/E*}] 4.167


set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/R*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/S*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/T*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/D*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/R*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/S*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/T*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/D*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/R*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/S*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/T*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/D*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/R*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/S*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/T*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Gen_1*.Receiver_I_Dru/D*}] 8.333


# The MMCM alignment state machine runs at 120 MHz.
#FIXME: do I need this?
#set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Receiver_I_MmcmAlign/*}] -to [get_cells * -hierarchical -filter {NAME =~ */cams_stereo/*/Receiver_I_MmcmAlign/*}] 8.333

#location constraints
#create_pblock pblock_cams_stereo
#add_cells_to_pblock [get_pblocks pblock_cams_stereo] [get_cells -quiet [list {system_i/cams_stereo/mt9v034_lvds_deserializer_stereocam1/inst/receiver/Gen_1[1].Receiver_I_Dru}]]
#resize_pblock [get_pblocks pblock_cams_stereo] -add {SLICE_X98Y108:SLICE_X113Y110}

set_property LOC ILOGIC_X1Y106 [get_cells system_i/cams_stereo/cam_stereo_clk_infra/inst/clock_infrastructure/Receiver_I_MmcmAlign/MmcmAlign_I_MmcmAlignIo/MmcmAlignIo_I_Isrdse2_Clk]
