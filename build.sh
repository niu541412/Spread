#!/bin/bash
set -euo pipefail

ARCH="${1:?usage: ./build.sh arm64|x86_64}"
case "$ARCH" in arm64|x86_64) ;; *) echo "Unsupported architecture: $ARCH" >&2; exit 2;; esac

ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD_ROOT="$ROOT/build/$ARCH"
BUNDLE="$BUILD_ROOT/products/Spread.saver"
EXECUTABLE="$BUNDLE/Contents/MacOS/Spread"

rm -rf "$BUILD_ROOT"
xcodebuild \
    -project "$ROOT/Spread.xcodeproj" \
    -target Spread \
    -configuration Release \
    ARCHS="$ARCH" \
    ONLY_ACTIVE_ARCH=YES \
    CONFIGURATION_BUILD_DIR="$BUILD_ROOT/products" \
    CODE_SIGNING_ALLOWED=NO \
    build

codesign --force --deep --sign - "$BUNDLE"
codesign --verify --deep --strict --verbose=2 "$BUNDLE"
test "$(lipo -archs "$EXECUTABLE")" = "$ARCH"
test -f "$BUNDLE/Contents/Resources/thumbnail.tiff"
ditto -c -k --sequesterRsrc --keepParent \
    "$BUNDLE" "$BUILD_ROOT/Spread-$ARCH.saver.zip"
echo "$BUILD_ROOT/Spread-$ARCH.saver.zip"
