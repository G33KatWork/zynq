## Building

Starting shell:

    SHELL=/bin/bash ./kas-docker shell kas-project.yml

Single target:

    MACHINE=base-crz01-carrier-zynq7 bitbake zynq-image

All:

    bitbake multiconfig:base-microzed:zynq-image \
        multiconfig:base-picozed:zynq-image \
        multiconfig:base-crz01:zynq-image \
        multiconfig:autocopter-microzed:copter-image \
        multiconfig:autocopter-picozed:copter-image


Video test:

    v4l2-ctl -d /dev/video0 --set-fmt-video=width=1504,height=480,pixelformat=GREY --stream-mmap --stream-count=32 --stream-to=test.raw


Manual uboot build for development:

    cp ../../fpga/zynq/build/base_crz01/base_crz01.srcs/sources_1/bd/system/ip/system_processing_system7_0_0/ps7_init_gpl.{h,c} board/xilinx/zynq/
    python3 ../../yocto/meta-zynq/recipes-bsp/fpga/fpga-bit-to-bin/fpga-bit-to-bin.py -f ../../fpga/zynq/build/base_crz01/base_crz01.runs/impl_1/system_top.bit fpga.bin

    CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm make -j32 zynq_crz01_defconfig
    CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm make -j32 all u-boot.itb


Setting MAC address in I2C eeprom:

    i2c bus
    i2c dev <bus with eeprom>
    i2c probe

    i2c read 53 0 100 10000000
    md 10000000

    <Sets MAC to 68:82:F2:31:33:73>
    i2c mw 53 FA 68
    i2c mw 53 FB 82
    i2c mw 53 FC F2
    i2c mw 53 FD 31
    i2c mw 53 FE 33
    i2c mw 53 FF 73

Setting up yocto package repo:

    bitbake package-index
    cd build/tmp/deploy/ipk
    sudo python3 -m http.server --bind 0.0.0.0 80

On the machine:

    cat >> /etc/opkg/opkg.conf << EOF
    src/gz all http://192.168.178.37/all
    src/gz cortexa9hf-vfp-neon-mx6 http://192.168.178.37/base_crz01_carrier_zynq7
    src/gz cortexa9hf-vfp-neon http://192.168.178.37/cortexa9t2hf-neon
    EOF
    opkg update
