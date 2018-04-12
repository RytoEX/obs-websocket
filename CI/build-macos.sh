#!/bin/sh
set -ex

#export QT_PREFIX="$(find /usr/local/Cellar/qt5 -d 1 | tail -n 1)"

echo obsPath: $obsPath
if [ -d "$PWD/../obs-studio/libobs" ]; then echo LIBOBS_INCLUDE_DIR exists; fi
if [ -f "$PWD/../obs-studio/libobs/build/libobs/libobs.dylib" ]; then echo LIBOBS_LIB exists; fi
if [ -f "$PWD/../obs-studio/build/UI/obs-frontend-api/libobs-frontend-api.dylib" ]; then echo OBS_FRONTEND_LIB exists; fi

find "$HOME" -name obs.dylib
find "$HOME" -name libobs.dylib


mkdir build && cd build
if [ -d "$PWD/../../obs-studio/libobs" ]; then echo LIBOBS_INCLUDE_DIR exists; fi
if [ -f "$PWD/../../obs-studio/libobs/build/libobs/libobs.dylib" ]; then echo LIBOBS_LIB exists; fi
if [ -f "$PWD/../../obs-studio/build/UI/obs-frontend-api/libobs-frontend-api.dylib" ]; then echo OBS_FRONTEND_LIB exists; fi

cmake -DQTDIR=/usr/local/opt/qt \
  -DLIBOBS_INCLUDE_DIR="$(pwd)/../../obs-studio/libobs" \
  -DLIBOBS_LIB="$(pwd)/../../obs-studio/libobs/build/libobs/libobs.dylib" \
  -DOBS_FRONTEND_LIB="$(pwd)/../../obs-studio/build/UI/obs-frontend-api/libobs-frontend-api.dylib" \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=/usr \
  .. \
&& make -j4
