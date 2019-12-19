LINUX_VERSION = "4.19"
XILINX_RELEASE_VERSION = "v2019.2"
KBRANCH ?= "xlnx_rebase_v4.19"
SRCREV ?= "b983d5fd71d4feaf494cdbe0593ecc29ed471cb8"

include recipes-kernel/linux/linux-xlnx.inc

FILESEXTRAPATHS_append := "${THISDIR}/${PN}/4.19:${THISDIR}/${PN}/config:"

SRC_URI_append = " \
        file://custom-features;type=kmeta;destsuffix=custom-features \
        "

KERNEL_FEATURES_append_zynq += " \
        led.scc \
        "

# Autocopter related stuff
SRC_URI_append_autocopterall = " \
        file://autocopter-features;type=kmeta;destsuffix=autocopter-features \
        file://0001-Fix-cadence-SPI-driver-to-not-use-_relaxed-read-and-.patch \
        file://0002-Add-compatible-strings-to-spidev-driver-for-Autocopt.patch \
        file://0003-Add-LVDS-mode-to-MT9V032-camera-driver.patch \
        file://0004-Add-MT9V032-stereo-mode-camera-driver.patch \
        "

KERNEL_FEATURES_append_autocopterall += " \
        copter.scc \
        "

# CRZ01
SRC_URI_append_crz01all = " \
        file://0005-Include-ADI-drivers-for-HDMI-video-output.patch \
        "

KERNEL_FEATURES_append_crz01all += " \
        rtc.scc \
        adi-hdmi.scc \
        10gbe.scc \
        "
