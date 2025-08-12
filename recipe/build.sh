#!/bin/bash

set -ex

mkdir build
pushd build

../configure \
  --prefix=${PREFIX} \
  --host=${HOST} \
  --build=${BUILD}

make build 
make install -j${CPU_COUNT}

popd