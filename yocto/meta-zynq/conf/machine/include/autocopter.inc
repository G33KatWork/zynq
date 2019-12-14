MACHINEOVERRIDES =. "autocopterall:"

# Add the userenv.txt which contains the list ob device tree overlays
IMAGE_BOOT_FILES += "\
	userenv.txt \
    "

# For easier kernel tinkering
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "\
    kernel-modules \
    "
