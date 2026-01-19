#!/bin/bash

# Script para crear AppImage de Forsaken Emulator
# Requiere: appimagetool (https://appimage.github.io/appimagetool/)
# Descarga: wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
#           chmod +x appimagetool-x86_64.AppImage
#
# Usage: Run from project root or use Makefile
#        make appimage

set -e

# Change to project root if running from scripts/build/
if [ -f "../../pubspec.yaml" ]; then
    cd ../..
fi

echo "🚀 Building Forsaken Emulator - AppImage"
echo "========================================"

# Verificar appimagetool
if ! command -v appimagetool &> /dev/null; then
    if [ ! -f "./appimagetool-x86_64.AppImage" ]; then
        echo "❌ appimagetool not found"
        echo "Downloading appimagetool..."
        wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
        chmod +x appimagetool-x86_64.AppImage
    fi
    APPIMAGETOOL="./appimagetool-x86_64.AppImage"
else
    APPIMAGETOOL="appimagetool"
fi

# 1. Build Flutter
echo "🔨 Building Flutter app..."
fvm flutter clean
fvm flutter build linux --release

# 2. Crear estructura AppDir
echo "📁 Creating AppDir structure..."
APPDIR="build/Forsaken.AppDir"
rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/lib"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/256x256/apps"

# 3. Copiar bundle de Flutter
echo "📋 Copying Flutter bundle..."
cp -r build/linux/x64/release/bundle/* "$APPDIR/usr/bin/"

# 4. Copiar libmpv y dependencias
echo "📚 Copying libraries..."
# Copiar libmpv
LIBMPV_PATH=$(ldconfig -p | grep libmpv.so | head -n1 | awk '{print $NF}')
if [ -n "$LIBMPV_PATH" ]; then
    cp "$LIBMPV_PATH" "$APPDIR/usr/lib/"
    echo "   ✓ libmpv.so"
fi

# Copiar dependencias de video
for lib in libavcodec.so libavformat.so libavutil.so libswscale.so libswresample.so libavfilter.so; do
    LIB_PATH=$(ldconfig -p | grep "$lib" | head -n1 | awk '{print $NF}')
    if [ -n "$LIB_PATH" ]; then
        cp "$LIB_PATH" "$APPDIR/usr/lib/" 2>/dev/null || true
        echo "   ✓ $lib"
    fi
done

# 5. Crear .desktop file
echo "📝 Creating desktop entry..."
cat > "$APPDIR/usr/share/applications/forsaken.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Forsaken Emulator
Comment=Multi-platform ROM frontend
Exec=forsaken
Icon=forsaken
Categories=Game;Emulator;
Terminal=false
EOF

# 6. Copiar icono
if [ -f "assets/images/icon.png" ]; then
    cp "assets/images/icon.png" "$APPDIR/usr/share/icons/hicolor/256x256/apps/forsaken.png"
    cp "assets/images/icon.png" "$APPDIR/forsaken.png"
fi

# 7. Crear AppRun script
echo "🏃 Creating AppRun..."
cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/bash
# AppRun for Forsaken Emulator

SELF=$(readlink -f "$0")
HERE=${SELF%/*}

# Add lib to LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/usr/lib:$LD_LIBRARY_PATH"

# Run the app
exec "$HERE/usr/bin/forsaken" "$@"
EOF

chmod +x "$APPDIR/AppRun"

# 8. Crear symlinks requeridos
ln -sf "usr/share/applications/forsaken.desktop" "$APPDIR/forsaken.desktop"
ln -sf "usr/share/icons/hicolor/256x256/apps/forsaken.png" "$APPDIR/.DirIcon"

# 9. Generar AppImage
echo "🗜️  Generating AppImage..."
VERSION=$(grep "version:" pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
OUTPUT="Forsaken-$VERSION-x86_64.AppImage"

$APPIMAGETOOL "$APPDIR" "$OUTPUT"

echo ""
echo "✅ AppImage created successfully!"
echo "📦 File: $OUTPUT"
echo "🚀 Run: ./$OUTPUT"
echo ""
echo "To distribute:"
echo "  - Single file, no installation needed"
echo "  - All dependencies included"
echo "  - Works on any Linux x64 system"
