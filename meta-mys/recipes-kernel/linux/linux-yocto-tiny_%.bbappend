DEPENDS += "lzop-native"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://defconfig"
COMPATIBLE_MACHINE .= "|mys-6ulx"

# Make sure UBOOT_ENV is available ${STAGING_DIR_HOST}/boot/${UBOOT_ENV_BINARY} 
DEPENDS += "u-boot"
