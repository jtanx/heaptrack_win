#!/bin/bash

set -euox pipefail

HTVERSION="$(git -C heaptrack describe)"

echo "HEAPTRACK VERSION $HTVERSION"

# Patch heaptrack
git -C heaptrack/ apply ../0001-Add-path-relocation.patch
git -C heaptrack/ apply ../0002-Fix-usage-of-nonstandard-uint-type.patch

# Install kdiagram/kchart
# cmake -S kdiagram -B kdbuild -GNinja -DCMAKE_INSTALL_PREFIX=/d/heaptrack -DCMAKE_BUILD_TYPE=Release
# ninja -C kdbuild install

# Install heaptrack
cmake -S heaptrack -B htbuild -GNinja -DCMAKE_INSTALL_PREFIX=/d/heaptrack -DCMAKE_BUILD_TYPE=Release
ninja -C htbuild install

# Make bundle
cp -rP /d/heaptrack/bin heaptrack-build
cp -rP heaptrack/LICENSES heaptrack-build/
pushd heaptrack-build
windeployqt6 heaptrack_gui.exe
../collect-dlls.sh heaptrack_gui.exe
7z a -mx9 ../heaptrack-${HTVERSION}.7z *
popd

sha256sum *.7z
