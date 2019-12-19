DESCRIPTION = "A zynq image"

IMAGE_FEATURES += "package-management ssh-server-dropbear tools-sdk tools-debug debug-tweaks dev-pkgs"

CORE_IMAGE_EXTRA_INSTALL += "\
	kernel-dev \
	"

CORE_IMAGE_EXTRA_INSTALL += "screen"
CORE_IMAGE_EXTRA_INSTALL += "libstdc++-dev"
CORE_IMAGE_EXTRA_INSTALL += "libc6-dev"
CORE_IMAGE_EXTRA_INSTALL += "vim git"
CORE_IMAGE_EXTRA_INSTALL += "i2c-tools"
CORE_IMAGE_EXTRA_INSTALL += "python3-modules tcpdump iperf3"

inherit core-image
