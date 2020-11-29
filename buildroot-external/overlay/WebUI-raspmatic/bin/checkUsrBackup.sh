#!/bin/sh

pathBackup=$1

[[ -r /var/hm_mode ]] && . /var/hm_mode

if [[ -n "${HM_HMIP_DEV}" ]]; then

  HM_SERVER=/opt/HMServer/HMIPServer.jar
  HM_SERVER_DEVNODE=/dev/mmd_hmip
  HM_SERVER_ARGS="/var/etc/crRFD.conf"

  # if no raw uart is used to connect to the rf module (e.g. HmIP-RFUSB)
  # we have to set the device node
  if [[ "${HM_HMIP_DEVNODE}" != "${HM_HMRF_DEVNODE}" ]] ||
     ! echo -n "${HM_HMIP_DEVNODE}" | grep -q raw-uart; then
    HM_SERVER_DEVNODE=${HM_HMIP_DEVNODE}
  else
    HM_SERVER_DEVNODE=/dev/mmd_hmip
  fi

  # get the architecture
  ARCH=$(uname -m)

  # if we run on aarch64 we have to override the libNRJavaSerial definition
  # so that the aarch64 (v8) version is used we supply our own
  JAVAOPT=
  if [[ "${ARCH}" == "aarch64" ]];then
    JAVAOPT="-DlibNRJavaSerial.userlib=/opt/HMServer/libNRJavaSerialv8.so"
  fi

  /opt/java/bin/java -Dos.arch=${ARCH} ${JAVAOPT} -Dfile.encoding=ISO-8859-1 -Dvertx.cacheDirBase=/tmp/.vertx-backuprestore -Dgnu.io.rxtx.SerialPorts=${HM_SERVER_DEVNODE} -cp ${HM_SERVER} de.eq3.ccu.server.ip.validation.ValidateHmIPBackup ${HM_SERVER_ARGS} $pathBackup

  case $? in
   -1) exitCode=9 ;;
    0) exitCode=10 ;;
    1) exitCode=11 ;;
    2) exitCode=12 ;;
    3) exitCode=13 ;;
    4) exitCode=14 ;;
    5) exitCode=15 ;;
    6) exitCode=16 ;;
    7) exitCode=17 ;;
    8) exitCode=18 ;;
    *) exitCode=99 ;;
  esac
else
  exitCode=10
fi

# Important - don't delete the echo output - backupStatus.log is necessary for determining the error code of the above java application.
echo $exitCode > /tmp/backupStatus.log
exit $exitCode
