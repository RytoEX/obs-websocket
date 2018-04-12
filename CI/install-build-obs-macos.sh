#!/bin/sh
set -ex

# Build obs-studio if needed
# Check if obs-studio build exists.
# If the obs-studio directory does exist, check if the last OBS tag built
# matches the latest OBS tag.
# If the tags match, do not build obs-studio.
# If the tags do not match, build obs-studio.
# If the obs-studio directory doesn't exist, build obs-studio.

# Debug info
echo directories info
echo pwd:
pwd
echo \$PWD:
echo $PWD
echo \$HOME:
echo $HOME
echo \$TRAVIS_BUILD_DIR:
echo $TRAVIS_BUILD_DIR

# Setup variables
OBSLatestTagPrePull=0
OBSLatestTagPostPull=0
OBSLatestTag=0
BuildOBS=false

echo Checking obs-studio build...
echo Latest tag pre-pull: $OBSLatestTagPrePull
echo Latest tag post-pull: $OBSLatestTagPostPull

# Check the last tag successfully built by CI
if [ -f "$TRAVIS_BUILD_DIR/../obs-studio/build/obs-studio-last-tag-built.txt" ]; then
  OBSLastTagBuilt=$(cat "$TRAVIS_BUILD_DIR/../obs-studio/build/obs-studio-last-tag-built.txt")
else
  OBSLastTagBuilt=0
fi

# Check if obs-studio exists
if [ -d "$PWD/../obs-studio/.git" ]; then
  echo obs-studio git directory exists
  echo   Updating tag info
  cd ../obs-studio
  OBSLatestTagPrePull=$(git describe --tags --abbrev=0)
  git checkout master
  git pull
  OBSLatestTagPostPull=$(git describe --tags --abbrev=0)
  OBSLatestTag="$OBSLatestTagPostPull"
else
  echo obs-studio git directory does not exist
  cd ..
  git clone https://github.com/obsproject/obs-studio
  cd obs-studio
  OBSLatestTag=$(git describe --tags --abbrev=0)
  BuildOBS=true
fi

# Check the obs-studio tags for mismatches.
# If a new tag was pulled, set the build flag.
if [ "$OBSLatestTagPrePull" != "$OBSLatestTagPostPull" ]; then
  echo Latest tag pre-pull: $OBSLatestTagPrePull
  echo Latest tag post-pull: $OBSLatestTagPostPull
  echo Tags do not match.  Need to rebuild OBS.
  BuildOBS=true
fi

# If the latest git tag doesn't match the last built tag, set the build flag.
if [ "$OBSLatestTagPostPull" != "$OBSLastTagBuilt" ]; then
  echo Last built OBS tag: $OBSLastTagBuilt
  echo Latest tag post-pull: $OBSLatestTagPostPull
  echo Tags do not match.  Need to rebuild OBS.
  BuildOBS=true
fi


# Some debug info
echo
echo Latest tag pre-pull: $OBSLatestTagPrePull
echo Latest tag post-pull: $OBSLatestTagPostPull
echo Latest tag: $OBSLatestTag
echo Last built OBS tag: $OBSLastTagBuilt

if [ "$BuildOBS" = true ]; then
  echo BuildOBS: true
else
  echo BuildOBS: false
fi
echo

# If the build flag is set, build obs-studio.
if [ "$BuildOBS" = true ]; then
  echo Building obs-studio...
  echo   git checkout "$OBSLatestTag"
  git checkout "$OBSLatestTag"
  echo
  echo   Removing previous build dir...
  if [ -d "./build" ]; then rm -rf "./build"; fi
  echo   Making new build dir...
  mkdir build && cd build
  echo   Running cmake and make for obs-studio "$OBSLatestTag"...
  cmake -DDISABLE_PLUGINS=true \
    -DCMAKE_PREFIX_PATH=/usr/local/opt/qt/lib/cmake \
    .. \
  && make -j4
  cd ..
  OBSLastTagBuilt=$(git describe --tags --abbrev=0)
  echo "$OBSLastTagBuilt" > "$TRAVIS_BUILD_DIR/../obs-studio/build/obs-studio-last-tag-built.txt"
else
  echo Last OBS tag built is:  "$OBSLastTagBuilt"
  echo No need to rebuild OBS.
fi
