#!/bin/sh

cd `dirname $0`

MACPORTS_DIR="$HOME/.macports"


MACPORTS_SOURCE_DIR="$MACPORTS_DIR/var/macports/sources/applicage"
if [ ! -L $MACPORTS_SOURCE_DIR ]; then
  ln -s `pwd -P`/sources $MACPORTS_SOURCE_DIR
fi


cd $MACPORTS_SOURCE_DIR/release/ports || exit $?
portindex


DEFAULT_SOURCES_LINE="rsync://rsync.macports.org/release/ports/ [default]"
SOURCES_CONF_LINE="file://$MACPORTS_SOURCE_DIR/release/ports [nosync]"
SOURCES_CONF="$MACPORTS_DIR/etc/macports/sources.conf"
FOUND_IN_SOURCES_CONF=`cat $SOURCES_CONF | fgrep "$SOURCES_CONF_LINE"`
if [ -z "$FOUND_IN_SOURCES_CONF" ]; then
  cat $SOURCES_CONF | fgrep -v "$DEFAULT_SOURCES_LINE" > $SOURCES_CONF.tmp
  mv $SOURCES_CONF.tmp $SOURCES_CONF
  echo "$SOURCES_CONF_LINE" >> $SOURCES_CONF
  echo "$DEFAULT_SOURCES_LINE" >> $SOURCES_CONF
fi
