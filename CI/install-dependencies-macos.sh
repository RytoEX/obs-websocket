#!/bin/sh
set -ex

# OBS Studio deps
brew update
brew install ffmpeg
brew install libav

# qtwebsockets deps
# qt latest
brew install qt5

# ccache
brew install ccache

export PATH="/usr/local/opt/ccache/libexec:$PATH"
ccache -s || echo "CCache is not available."

# Packages app
wget --quiet --retry-connrefused --waitretry=1 https://s3-us-west-2.amazonaws.com/obs-nightly/Packages.pkg
sudo installer -pkg ./Packages.pkg -target /
