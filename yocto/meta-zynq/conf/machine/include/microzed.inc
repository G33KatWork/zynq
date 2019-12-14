include common.inc

MACHINE_FEATURES = "ext2 vfat usbhost"

MACHINEOVERRIDES =. "microzedall:"

UBOOT_MACHINE = "zynq_microzed_config"
FORCE_PLATFORM_INIT = "1"
SPL_BINARY = "spl/boot.bin"

SERIAL_CONSOLE = "115200 ttyPS0"

MACHINE_DEVICETREE = "microzed-iocc-zynq7"
