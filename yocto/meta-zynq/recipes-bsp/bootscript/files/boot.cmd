setenv kernel_addr "0x02080000"
setenv fdt_addr    "0x01000000"
setenv tmp_addr    "0x04000000"

setenv dtb_filename "devicetree/system.dtb"
setenv kernel_filename "uImage"
setenv fpga_filename "fpga.bit"
setenv rootpart "root=/dev/mmcblk0p2 rootwait"
setenv bootargs "console=ttyPS0,115200 earlyprintk ${rootpart}"
setenv overlays ""

setenv sdbootdev "0"
setenv partid "1"

setenv overlay_error "false"

if test -e mmc ${sdbootdev}:${partid} userenv.txt; then
    echo "Loading userenv"
    load mmc ${sdbootdev}:${partid} ${tmp_addr} userenv.txt
    env import -t ${tmp_addr} ${filesize}
fi

# load FPGA bitstream
if test -e mmc ${sdbootdev}:${partid} ${fpga_filename}; then
    echo "Loading FPGA bitstream"
    load mmc ${sdbootdev}:${partid} ${tmp_addr} ${fpga_filename}
    fpga loadb 0 ${tmp_addr} ${filesize}
fi

# load kernel
echo "Loading kernel: mmc ${sdbootdev}:${partid}/${kernel_filename}"
load mmc ${sdbootdev}:${partid} ${kernel_addr} ${kernel_filename}
setenv kernel_filesize ${filesize}
setenv boot_addr ${kernel_addr}

# load dtb
echo "Loading kernel: mmc ${sdbootdev}:${partid}/${dtb_filename}"
load mmc ${sdbootdev}:${partid} ${fdt_addr} ${dtb_filename}
fdt addr ${fdt_addr}

# apply device tree overlays
for overlay_file in ${overlays}; do
    if test -e mmc ${sdbootdev}:${partid} ${overlay_file}; then
        echo "Loading fdt overlay: mmc ${sdbootdev}:${partid}/${overlay_file}"
        load mmc ${sdbootdev}:${partid} ${tmp_addr} ${overlay_file}
        fdt apply ${tmp_addr} || setenv overlay_error "true"
    fi
done

if test "${overlay_error}" = "true"; then
    echo "Error applying DT overlays, restoring original DT"
    load mmc ${sdbootdev}:${partid} ${fdt_addr} ${dtb_filename}
fi

# boot
bootm ${boot_addr} - ${fdt_addr}
