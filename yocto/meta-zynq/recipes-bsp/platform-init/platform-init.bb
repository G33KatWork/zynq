SUMMARY = "Xilinx Platform Headers"
DESCRPTION = "Xilinx ps*_init_gpl.c/h platform init code, used for building u-boot-spl and fsbl"
HOMEPAGE = "http://www.xilinx.com"
SECTION = "bsp"

INHIBIT_DEFAULT_DEPS = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit xilinx-platform-init
inherit deploy nopackages

COMPATIBLE_MACHINE = "$^"
COMPATIBLE_MACHINE_base-microzed-iocc-zynq7 = "base-microzed-iocc-zynq7"
COMPATIBLE_MACHINE_base-picozed-pciecc-zynq7 = "base-picozed-pciecc-zynq7"
COMPATIBLE_MACHINE_base-crz01-carrier-zynq7 = "base-crz01-carrier-zynq7"
COMPATIBLE_MACHINE_fixelplut-crz01-carrier-zynq7 = "fixelplut-crz01-carrier-zynq7"
COMPATIBLE_MACHINE_autocopter-microzed-iocc-zynq7 = "autocopter-microzed-iocc-zynq7"
COMPATIBLE_MACHINE_autocopter-picozed-pciecc-zynq7 = "autocopter-picozed-pciecc-zynq7"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

PROVIDES = " \
    virtual/bitstream \
    virtual/xilinx-platform-init \
    "

SRC_URI = "file://platform.xsa"
S = "${WORKDIR}/platform"

SYSROOT_DIRS += "${PLATFORM_INIT_DIR}"

do_unpack_xsa(){
    unzip -q -o -d ${S} ${WORKDIR}/platform.xsa
}
addtask unpack_xsa after do_unpack before do_patch
do_unpack_xsa[depends] += "unzip-native:do_populate_sysroot"

do_compile() {
	:
}

do_install() {
    install -d ${D}${PLATFORM_INIT_DIR}

    fn=$(ls | awk '{print $NF}' | grep ".bit$")
    install -m 0644 ${fn} ${D}${PLATFORM_INIT_DIR}/fpga.bit
    
    for i in ${PLATFORM_INIT_FILES}; do
        install -m 0644 ${i} ${D}${PLATFORM_INIT_DIR}
    done
}

do_deploy () {
    echo ${D}
    if [ -e ${D}${PLATFORM_INIT_DIR}/fpga.bit ]; then
        install -d ${DEPLOYDIR}
        install -m 0644 ${D}${PLATFORM_INIT_DIR}/fpga.bit ${DEPLOYDIR}/fpga.bit
    fi
}
addtask deploy before do_build after do_install
