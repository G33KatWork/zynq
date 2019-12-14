################# Single Cam #################

#rename a few generated MMCM clocks because the automatically derived names are too confusing
create_generated_clock -name IDELAYCTRL_RefClk_single_cam [get_pins system_i/single_cam/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT0]
create_generated_clock -name IntClk0_single_cam [get_pins system_i/single_cam/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT1]
create_generated_clock -name IntClk90_single_cam [get_pins system_i/single_cam/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT2]
create_generated_clock -name RxClkDiv_single_cam [get_pins system_i/single_cam/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT3]
create_generated_clock -name RxClk_single_cam [get_pins system_i/single_cam/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT4]

#buffered clocks through BUFIOs
create_clock -period 6.250 -name IntClk0Bufio_single_cam [get_pins system_i/single_cam/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_Bufio_Clk0/O]
create_clock -period 6.250 -name IntClk90Bufio_single_cam [get_pins system_i/single_cam/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_Bufio_Clk90/O]

#false paths between the clocks
set_false_path -from [get_clocks IDELAYCTRL_RefClk_single_cam] -to [get_clocks {IntClk0_single_cam IntClk0Bufio_single_cam IntClk90_single_cam IntClk90Bufio_single_cam RxClkDiv_single_cam RxClk_single_cam}]
set_false_path -from [get_clocks {IntClk0_single_cam IntClk0Bufio_single_cam}] -to [get_clocks {IDELAYCTRL_RefClk_single_cam IntClk90_single_cam IntClk90Bufio_single_cam RxClkDiv_single_cam RxClk_single_cam}]
set_false_path -from [get_clocks {IntClk90_single_cam IntClk90Bufio_single_cam}] -to [get_clocks {IDELAYCTRL_RefClk_single_cam IntClk0_single_cam IntClk0Bufio_single_cam RxClkDiv_single_cam RxClk_single_cam}]
set_false_path -from [get_clocks RxClkDiv_single_cam] -to [get_clocks {IDELAYCTRL_RefClk_single_cam IntClk0_single_cam IntClk0Bufio_single_cam IntClk90_single_cam IntClk90Bufio_single_cam RxClk_single_cam}]
set_false_path -from [get_clocks RxClk_single_cam] -to [get_clocks {IDELAYCTRL_RefClk_single_cam IntClk0_single_cam IntClk0Bufio_single_cam IntClk90_single_cam IntClk90Bufio_single_cam RxClkDiv_single_cam}]


set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/ID*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/II*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/E*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/ID*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/II*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/E*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/ID*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/II*}] 6.250
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/E*}] 6.250


set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/R*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/S*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/T*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/D*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/R*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/S*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/T*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/D*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/R*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/S*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/T*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/D*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/R*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/S*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/T*}] 12.500
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_Dru/D*}] 12.500


# The MMCM alignment state machine runs at 80 MHz.
#FIXME: do I need this?
#set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Receiver_I_MmcmAlign/*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Receiver_I_MmcmAlign/*}] 12.500

# The Reset constraint to the different hierarchical blocks.
#set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/AppsRstEna_I_LocalRstEna/*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_SgmiiRxData/*}] 12.500
#set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/AppsRstEna_I_AppsRst/*}] -to [get_cells * -hierarchical -filter {NAME =~ */single_cam/*/Gen_1*.Receiver_I_SgmiiRxData/*}] 12.500


#location constraints
#create_pblock pblock_single_cam
#add_cells_to_pblock [get_pblocks pblock_single_cam] [get_cells -quiet [list {system_i/single_cam/mt9v034_lvds_deserializer_single_cam/inst/receiver/Gen_1[1].Receiver_I_Dru}]]
#resize_pblock [get_pblocks pblock_single_cam] -add {SLICE_X98Y72:SLICE_X113Y74}

set_property LOC ILOGIC_X1Y72 [get_cells system_i/single_cam/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_MmcmAlign/MmcmAlign_I_MmcmAlignIo/MmcmAlignIo_I_Isrdse2_Clk]






################# Stereo Cams #################

#rename a few generated MMCM clocks because the automatically derived names are too confusing
create_generated_clock -name IDELAYCTRL_RefClk_stereocams [get_pins system_i/stereocams/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT0]
create_generated_clock -name IntClk0_stereocams [get_pins system_i/stereocams/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT1]
create_generated_clock -name IntClk90_stereocams [get_pins system_i/stereocams/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT2]
create_generated_clock -name RxClkDiv_stereocams [get_pins system_i/stereocams/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT3]
create_generated_clock -name RxClk_stereocams [get_pins system_i/stereocams/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_RxGenClockMod/RxGenClockMod_I_Mmcm_Adv/CLKOUT4]

#buffered clocks through BUFIOs
create_clock -period 4.167 -name IntClk0Bufio_stereocams [get_pins system_i/stereocams/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_Bufio_Clk0/O]
create_clock -period 4.167 -name IntClk90Bufio_stereocams [get_pins system_i/stereocams/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_Bufio_Clk90/O]

#false paths between the clocks
set_false_path -from [get_clocks IDELAYCTRL_RefClk_stereocams] -to [get_clocks {IntClk0_stereocams IntClk0Bufio_stereocams IntClk90_stereocams IntClk90Bufio_stereocams RxClkDiv_stereocams RxClk_stereocams}]
set_false_path -from [get_clocks {IntClk0_stereocams IntClk0Bufio_stereocams}] -to [get_clocks {IDELAYCTRL_RefClk_stereocams IntClk90_stereocams IntClk90Bufio_stereocams RxClkDiv_stereocams RxClk_stereocams}]
set_false_path -from [get_clocks {IntClk90_stereocams IntClk90Bufio_stereocams}] -to [get_clocks {IDELAYCTRL_RefClk_stereocams IntClk0_stereocams IntClk0Bufio_stereocams RxClkDiv_stereocams RxClk_stereocams}]
set_false_path -from [get_clocks RxClkDiv_stereocams] -to [get_clocks {IDELAYCTRL_RefClk_stereocams IntClk0_stereocams IntClk0Bufio_stereocams IntClk90_stereocams IntClk90Bufio_stereocams RxClk_stereocams}]
set_false_path -from [get_clocks RxClk_stereocams] -to [get_clocks {IDELAYCTRL_RefClk_stereocams IntClk0_stereocams IntClk0Bufio_stereocams IntClk90_stereocams IntClk90Bufio_stereocams RxClkDiv_stereocams}]


set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/ID*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/II*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/ID*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/E*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/ID*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/II*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/II*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/E*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/ID*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/II*}] 4.167
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/E*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/E*}] 4.167


set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/R*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/S*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/T*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/R*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/D*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/R*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/S*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/T*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/S*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/D*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/R*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/S*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/T*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/T*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/D*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/R*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/S*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/T*}] 8.333
set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/D*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_Dru/D*}] 8.333


# The MMCM alignment state machine runs at 120 MHz.
#FIXME: do I need this?
#set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Receiver_I_MmcmAlign/*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Receiver_I_MmcmAlign/*}] 8.333

# The Reset constraint to the different hierarchical blocks.
#set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/AppsRstEna_I_LocalRstEna/*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_SgmiiRxData/*}] 8.333
#set_max_delay -from [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/AppsRstEna_I_AppsRst/*}] -to [get_cells * -hierarchical -filter {NAME =~ */stereocams/*/Gen_1*.Receiver_I_SgmiiRxData/*}] 8.333


#location constraints
#create_pblock pblock_stereocams
#add_cells_to_pblock [get_pblocks pblock_stereocams] [get_cells -quiet [list {system_i/stereocams/mt9v034_lvds_deserializer_stereocam1/inst/receiver/Gen_1[1].Receiver_I_Dru}]]
#resize_pblock [get_pblocks pblock_stereocams] -add {SLICE_X98Y108:SLICE_X113Y110}

set_property LOC ILOGIC_X1Y111 [get_cells system_i/stereocams/mt9v034_deserializer_clock_infrastructure_0/inst/clock_infrastructure/Receiver_I_MmcmAlign/MmcmAlign_I_MmcmAlignIo/MmcmAlignIo_I_Isrdse2_Clk]
