#!/bin/sh
set -ex

#export QT_PREFIX="$(find /usr/local/Cellar/qt5 -d 1 | tail -n 1)"

echo obsPath: $obsPath
if [ -d "$PWD/../obs-studio/libobs" ]; then echo LIBOBS_INCLUDE_DIR exists; fi
if [ -d "$PWD/../obs-studio/build/libobs" ]; then echo LibObs_DIR exists; fi
if [ -f "$PWD/../obs-studio/build/libobs/LibObsConfig.cmake" ]; then echo LibObsConfig.cmake exists; fi
if [ -f "$PWD/../obs-studio/build/libobs/libobs.dylib" ]; then echo LIBOBS_LIB exists; fi
if [ -f "$PWD/../obs-studio/build/UI/obs-frontend-api/libobs-frontend-api.dylib" ]; then echo OBS_FRONTEND_LIB exists; fi

find "$HOME" -name FindLibobs.cmake
find "$HOME" -name FindLibObs.cmake
find "$HOME" -name LibObsConfig.cmake
find "$HOME" -name libobs-config.cmake
find "$HOME" -name obs-module.h
find /usr/lib -name LibObsConfig.cmake
find /usr/local -name LibObsConfig.cmake
find /usr/share -name LibObsConfig.cmake
find /usr/lib -name libobs-config.cmake
find /usr/local -name libobs-config.cmake
find /usr/share -name libobs-config.cmake
find /usr/lib -name obs-module.h
find /usr/local -name obs-module.h
find /usr/share -name obs-module.h

mkdir build && cd build
cmake -DQTDIR=/usr/local/opt/qt \
  -DLIBOBS_INCLUDE_DIR=../../obs-studio/libobs \
  -DLibObs_DIR=../../obs-studio/build/libobs \
  -DOBS_FRONTEND_LIB="$(pwd)/../../obs-studio/build/UI/obs-frontend-api/libobs-frontend-api.dylib" \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=/usr \
  .. \
&& make -j4
