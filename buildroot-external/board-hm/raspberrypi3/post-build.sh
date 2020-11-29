#!/bin/sh

# copy the kernel image to rootfs
cp -a ${BINARIES_DIR}/Image ${TARGET_DIR}/

# create VERSION file
echo "VERSION=${PRODUCT_VERSION}" >${TARGET_DIR}/VERSION
echo "PRODUCT=${PRODUCT}" >>${TARGET_DIR}/VERSION
echo "PLATFORM=rpi3" >>${TARGET_DIR}/VERSION

# fix some permissions
[ -e ${TARGET_DIR}/etc/monitrc ] && chmod 600 ${TARGET_DIR}/etc/monitrc

# link VERSION in /boot on rootfs
mkdir -p ${TARGET_DIR}/boot
ln -sf ../VERSION ${TARGET_DIR}/boot/VERSION
