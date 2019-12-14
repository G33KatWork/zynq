PREFERRED_PROVIDER_virtual/kernel ?= "linux-xlnx"
PREFERRED_VERSION_linux-xlnx ?= "4.19%"

require conf/machine/include/tune-zynq.inc
require conf/machine/include/machine-xilinx-overrides.inc
require conf/machine/include/machine-xilinx-default.inc

EXTRA_IMAGEDEPENDS += " \
    virtual/boot-bin \
    virtual/bootloader \
    bootscript \
    device-tree \
    "

IMAGE_BOOT_FILES = " \
    boot.bin \
    boot.scr \
    ${KERNEL_IMAGETYPE} \
    u-boot.itb \
    devicetree/${MACHINE_DEVICETREE}.dtb;devicetree/system.dtb \
    devicetree/*.dtbo;devicetree/ \
    "

IMAGE_FSTYPES += "wic wic.bmap"
WKS_FILES = "sdimage-bootpart.wks"
