#!/usr/bin/env bash
set -euo pipefail

VERSION=${1:-1.0.0}
PKG="simple-screen-capture_${VERSION}_all"

echo "Building $PKG.deb..."

rm -rf "/tmp/$PKG"
mkdir -p "/tmp/$PKG/DEBIAN"
mkdir -p "/tmp/$PKG/usr/bin"
mkdir -p "/tmp/$PKG/usr/share/doc/simple-screen-capture"

# Install scripts
install -m 755 src/capture                  "/tmp/$PKG/usr/bin/capture"
install -m 755 src/capture-region           "/tmp/$PKG/usr/bin/capture-region"
install -m 755 src/capture-stop             "/tmp/$PKG/usr/bin/capture-stop"
install -m 755 src/capture-setup            "/tmp/$PKG/usr/bin/capture-setup"
install -m 755 src/capture-xbindkeys-start  "/tmp/$PKG/usr/bin/capture-xbindkeys-start"

# Control file (inject version)
sed "s/^Version: .*/Version: $VERSION/" debian/control > "/tmp/$PKG/DEBIAN/control"

dpkg-deb --build --root-owner-group "/tmp/$PKG" "${PKG}.deb"
echo "Built: ${PKG}.deb ($(du -h "${PKG}.deb" | cut -f1))"
