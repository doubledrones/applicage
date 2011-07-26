#!/bin/sh

MACPORTS_DIR="$HOME/.macports"
MACPORTS_VERSION="1.9.2"

CACHE_DIR="$HOME/Library/Caches/AppliCage"

APPLICAGE_ROOT=`cd \`dirname $0\` ; pwd -P`

export PATH="$MACPORTS_DIR/bin:$PATH"

if [ ! -d $MACPORTS_DIR ]; then
  if [ ! -d $CACHE_DIR ]; then
    mkdir -p $CACHE_DIR
  fi

  cd $CACHE_DIR
  if [ ! -f MacPorts-$MACPORTS_VERSION.tar.bz2.ok ]; then
    curl http://distfiles.macports.org/MacPorts/MacPorts-$MACPORTS_VERSION.tar.bz2 -o MacPorts-$MACPORTS_VERSION.tar.bz2
    tar xvjf $CACHE_DIR/MacPorts-$MACPORTS_VERSION.tar.bz2 -C /tmp/
    touch MacPorts-$MACPORTS_VERSION.tar.bz2.ok
  else
    tar xvjf $CACHE_DIR/MacPorts-$MACPORTS_VERSION.tar.bz2 -C /tmp/
  fi

  cd /tmp/MacPorts-$MACPORTS_VERSION

  ./configure \
    --with-no-root-privileges \
    --prefix=$MACPORTS_DIR \
    --enable-readline \
    --with-install-user=`id -un` \
    --with-install-group=`id -gn` \
    --with-tclpackage=$MACPORTS_DIR/share/macports/Tcl

  make
  make install

  cd

  # port -v selfupdate

  rm -rf /tmp/MacPorts-$MACPORTS_VERSION
fi

if [ ! -d $MACPORTS_DIR/etc/macports ]; then
  mkdir -p $MACPORTS_DIR/etc/macports
fi
echo "-doc +no_x11 +no_java -ipv6 +no_root" > $MACPORTS_DIR/etc/macports/variants.conf

CPU_NUM=`ioreg | grep CPU.@ | wc -l | sed -e 's/ //g'`
MAKEJOBS=`expr \`expr $CPU_NUM \* 2\` + 1`

echo "buildmakejobs $MAKEJOBS" > $MACPORTS_DIR/macports.conf

if [ -f $HOME/.ssh/id_dsa.pub ] || [ -f $HOME/.ssh/id_rsa.pub ]; then
  if [ ! -d $HOME/projects ]; then
    mkdir -p $HOME/projects
  fi
  cd $HOME/projects
  if [ ! -d applicage ]; then
    port install git-core
    git clone git@github.com:doubledrones/applicage.git
    if [ $? -eq 0 ]; then
      APPLICAGE_ROOT="$HOME/projects/applicage"
    fi
  else
    APPLICAGE_ROOT="$HOME/projects/applicage"
  fi
fi

cd $APPLICAGE_ROOT

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
