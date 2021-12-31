#!/bin/bash

set -euo pipefail

if false; then
  kernel_load='0x81000000'
  fdt_load='0x82000000'
  ramdisk_load='0x82100000'
else
  kernel_load='0x82000000'
  fdt_load='0x83000000'
  ramdisk_load='0x84000000'
fi

ramdisk_size=$(stat -Lc%s '/home/sven/mys/build/tmp/deploy/images/mys-6ulx/mys-initramfs-mys-6ulx.cpio.gz')

cd '/home/sven/mys/build/tmp/work/mys_6ulx-poky-linux-musleabi/linux-yocto-tiny/5.14.21+gitAUTOINC+4f4ad2c808_9d5572038e-r0/linux-mys_6ulx-tiny-build'

# Modify device tree blob
fdt_path='arch/arm/boot/dts/imx6ull-myir-mys-6ulx-eval.dtb'
fdtput -pt x $fdt_path /memory reg 0x80000000 0x10000000
fdtput -pt s $fdt_path /memory device_type memory
fdtput -pt x $fdt_path /chosen linux,initrd-start $ramdisk_load
ramdisk_end=$(awk --non-decimal-data \
  -vld=$ramdisk_load \
  -vsz="$ramdisk_size" \
  'BEGIN{printf "0x%08x",ld+sz}')
fdtput -pt x $fdt_path /chosen linux,initrd-end "$ramdisk_end"
fdtput -pt s $fdt_path /chosen bootargs 'quiet rdinit=/bin/ash' # earlycon
console=$(fdtget $fdt_path /chosen stdout-path | cut -d: -f1)
fdtput -t s $fdt_path /chosen stdout-path "$console:115200"

# Generate flattened image tree blob
its='fit-image-mys-initramfs.its'
fit='/home/sven/mys/fitImage'
/home/sven/u-boot/tools/mkimage -f $its $fit

# Modify flattened image tree blob
fdt_file=$(basename $fdt_path)
fdtput -pt x $fit /images/kernel-1 load $kernel_load
fdtput -pt x $fit /images/kernel-1 entry $kernel_load
fdtput -pt x $fit "/images/fdt-$fdt_file" load $fdt_load
fdtput -pt x $fit /images/ramdisk-1 load $ramdisk_load
fdtput -pt s $fit "/configurations/conf-$fdt_file" \
  loadables ramdisk-1
#  loadables "fdt-$fdt_file" ramdisk-1
