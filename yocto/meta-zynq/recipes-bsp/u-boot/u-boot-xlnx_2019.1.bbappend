FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
        file://0001-Fix-picozed-device-tree.patch \
        file://0002-Use-FIT-image-for-main-u-boot-and-load-FPGA-in-SPL-f.patch \
        file://0003-Enable-fdt-overlay-support.patch \
        file://0004-Add-CRZ01-board-support.patch \
        "

UBOOT_ENV = "uEnv"
SRC_URI_append = " file://uEnv.txt"

DEPENDS += " \
        fpga-bit-to-bin-native \
        virtual/bitstream \
        "

do_compile_prepend() {
        #Fix paths in zynq its file for u-boot. This is a hack but works for now
        sed -i -e 's#../../../#../../../../build/#g' ${S}/board/xilinx/zynq/fit_spl_fpga.its

        #convert and add the bitstream for inclusion in FIT image
        fpga-bit-to-bin.py --flip ${PLATFORM_INIT_STAGE_DIR}/fpga.bit ${B}/fpga.bin
}

# Hack to build itb file instead of bin
UBOOT_SUFFIX = "itb"
UBOOT_BINARY = "u-boot.itb"
UBOOT_MAKE_TARGET = "all u-boot.itb"
