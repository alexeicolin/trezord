#!/bin/sh

set -e

cd $(dirname $0)

TARGET=$1
BUILDDIR=build${TARGET:+-$TARGET}
BUILDTYPE=${2-Debug}

case "$TARGET" in
  lin32 | lin64 | win32 | win64 | mac64 ) # cross build
    PLATFORM_FILE="-C $(pwd)/cmake/Platform-$TARGET.cmake"
    ;;
  * ) # native build
    JOBS="-j 4"
    ;;
esac

# Compile jsoncpp
if [ \! -f $BUILDDIR/lib/jsoncpp/lib/libjson.a ]; then
  mkdir -p $BUILDDIR/lib/jsoncpp && cd $BUILDDIR/lib/jsoncpp
  cmake -DCMAKE_BUILD_TYPE=$BUILDTYPE $PLATFORM_FILE ../../../vendor/jsoncpp
  make $JOBS
  cd ../../..
fi

# Compile protobuf
PROTOBUF_BUILD_DIR=$BUILDDIR/lib/protobuf/build
PROTOBUF_INSTALL_DIR=$BUILDDIR/lib/protobuf/install
if [ \! -f $BUILDDIR/lib/protobuf/install/lib/libprotobuf.a ]; then
  echo Building protobuf...
  rm -rf $PROTOBUF_BUILD_DIR
  mkdir -p $PROTOBUF_BUILD_DIR
  mkdir -p $PROTOBUF_INSTALL_DIR
  PROTOBUF_BUILD_DIR=$(realpath $PROTOBUF_BUILD_DIR)
  PROTOBUF_INSTALL_DIR=$(realpath $PROTOBUF_INSTALL_DIR)
  cd vendor/protobuf
  git archive HEAD | tar -x -C $PROTOBUF_BUILD_DIR
  cd $PROTOBUF_BUILD_DIR
  ./autogen.sh
  ./configure --prefix=$PROTOBUF_INSTALL_DIR
  make $JOBS
  make install
  cd ../../../..
fi

mkdir -p $BUILDDIR && cd $BUILDDIR
cmake -DCMAKE_BUILD_TYPE=$BUILDTYPE $PLATFORM_FILE ..
make $JOBS
