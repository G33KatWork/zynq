FILESEXTRAPATHS_prepend := "${THISDIR}/files:${THISDIR}/files/overlays:"

COMPATIBLE_MACHINE_microzedall = ".*"
SRC_URI_microzedall = " file://microzed-iocc-zynq7.dts"

COMPATIBLE_MACHINE_picozedall = ".*"
SRC_URI_append_picozedall = " file://picozed-pciecc-zynq7.dts"

COMPATIBLE_MACHINE_crz01all = ".*"
SRC_URI_append_crz01all = " file://crz01-carrier-zynq7.dts"

DTC_BFLAGS += " -@"

# Overlays
SRC_URI_append_autocopterall = " \
    file://stereocam.dts \
    file://sensors.dts \
    "

SRC_URI_append_autocopter-microzed-iocc-zynq7 = " \
    file://ofcam.dts \
    "
