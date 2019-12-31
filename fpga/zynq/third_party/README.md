Building network stack IP

    cd fpga-network-stack
    mkdir build
    cd build
    cmake .. -DNETWORK_BANDWIDTH=10 -DFPGA_PART=xc7z100ffg900-2 -DFPGA_FAMILY=7series -DTCP_STACK_RX_DDR_BYPASS_EN=0 -DTCP_STACK_MAX_SESSIONS=1024
    make installip
