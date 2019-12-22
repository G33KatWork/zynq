Building network stack IP

    cd fpga-network-stack
    mkdir build
    cd build
    cmake .. -DNETWORK_BANDWIDTH=10 -DFPGA_PART=xc7z100ffg900-2 -DFPGA_FAMILY=7series
    make installip
