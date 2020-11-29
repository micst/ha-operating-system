#!/bin/sh

BASE_DIR=/opt/mediola
PLUGIN_DIR=/usr/local/addons/mediola
USER_DIR=/etc/config/addons/mediola
WWW_DIR=/etc/config/addons/www/mediola

if ! grep -q "ID mediola CONFIG_NAME NEOServer" /etc/config/hm_addons.cfg 2>/dev/null; then
  $BASE_DIR/install.tcl
fi

if [ ! "$(readlink $WWW_DIR)" = "$BASE_DIR/www" ]; then
  rm -rf $WWW_DIR
  ln -sf $BASE_DIR/www $WWW_DIR
fi

if [ ! -e $PLUGIN_DIR ] ; then

  rm -rf $USER_DIR
  mkdir -p $USER_DIR

  cp -a $BASE_DIR/user/* $USER_DIR 2>/dev/null
  chmod -R 777 $USER_DIR
  chown -R root:root $USER_DIR
   
  mkdir -p /usr/local/addons
  tar -C /usr/local/addons -xf /opt/mediola/pkg/mediola.tar.gz

  ln -sf /usr/local/addons/mediola/rc.d/97NeoServer /etc/config/rc.d/97NeoServer

  exit 0
fi

if ! grep -q "/usr/local/addons/mediola/bin/watchdog" /usr/local/crontabs/root 2>/dev/null; then
  echo "*/5 * * * * /usr/local/addons/mediola/bin/watchdog" >>/usr/local/crontabs/root
fi
