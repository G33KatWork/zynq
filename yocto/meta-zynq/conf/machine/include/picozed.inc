include common.inc

MACHINE_FEATURES = "ext2 vfat usbhost"

MACHINEOVERRIDES =. "picozedall:"

UBOOT_MACHINE = "zynq_picozed_config"
FORCE_PLATFORM_INIT = "1"
SPL_BINARY = "spl/boot.bin"

SERIAL_CONSOLE = "115200 ttyPS0"

MACHINE_DEVICETREE = "picozed-pciecc-zynq7"
