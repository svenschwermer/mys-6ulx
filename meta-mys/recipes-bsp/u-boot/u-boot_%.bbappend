FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "\
    file://0001-mys_6ulx-Unset-initrd_high-in-environment.patch \
    file://0002-sdp-Rename-boot-script.patch \
    file://0003-myir_mys_6ulx-Enable-SDP.patch \
    file://0004-Fast-SDP-falcon-boot-using-FIT-image.patch \
    file://${UBOOT_ENV_SRC} \
    "
# Make the UBOOT_ENV_BINARY available to kernel recipe
SYSROOT_DIRS += "/boot"
