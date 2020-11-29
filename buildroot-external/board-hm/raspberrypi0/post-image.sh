#!/bin/sh

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"

# Use our own cmdline.txt+config.txt
cp "${BR2_EXTERNAL_HASSOS_PATH}/board/${BOARD_NAME}/cmdline.txt" "${BINARIES_DIR}/"
cp "${BR2_EXTERNAL_HASSOS_PATH}/board/${BOARD_NAME}/config.txt" "${BINARIES_DIR}/"

#
# Create user filesystem
#
echo "Create user filesystem"
mkdir -p ${BUILD_DIR}/userfs
touch "${BUILD_DIR}/userfs/.doFactoryReset"
rm -f ${BINARIES_DIR}/userfs.ext4
mkfs.ext4 -d ${BUILD_DIR}/userfs -F -L userfs ${BINARIES_DIR}/userfs.ext4 3000

#
# VERSION File
#
cp ${TARGET_DIR}/boot/VERSION ${BINARIES_DIR}

# create *.img file using genimage
support/scripts/genimage.sh -c "${BR2_EXTERNAL_HASSOS_PATH}/board/${BOARD_NAME}/genimage.cfg"

exit $?
