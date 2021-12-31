DEPENDS += "lzop-native"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://defconfig"
COMPATIBLE_MACHINE .= "|mys-6ulx"

# Make sure the boot script from the u-boot recipe is available at built time
# when the initramfs is assembled. We also need the firmware, since we have
# configured the kernel to incorporate the SDMA firmware blob.
DEPENDS += "\
    u-boot \
    linux-firmware \
    "
