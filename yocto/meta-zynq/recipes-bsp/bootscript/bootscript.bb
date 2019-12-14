SUMMARY = "U-boot boot scripts for Ultrazed"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
COMPATIBLE_MACHINE = ".*"

DEPENDS = "u-boot-mkimage-native"

INHIBIT_DEFAULT_DEPS = "1"

SRC_URI = "file://boot.cmd"
SRC_URI_append_autocopter-microzed-iocc-zynq7 = " file://userenv.txt"
SRC_URI_append_autocopter-picozed-pciecc-zynq7 = " file://userenv.txt"

do_compile() {
    mkimage -A arm -T script -C none -a 0 -e 0 -n "Boot script" -d "${WORKDIR}/boot.cmd" boot.scr
}

inherit deploy nopackages

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 boot.scr ${DEPLOYDIR}

    for i in $(ls ${WORKDIR}/*.txt); do
        install -m 0644 $i ${DEPLOYDIR}
    done
}

addtask do_deploy after do_compile before do_build
