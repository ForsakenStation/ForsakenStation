#!/bin/bash

# Script para crear un build portable de Linux con libmpv incluido
# Uso: ./build_linux_portable.sh

set -e

echo "🚀 Building Forsaken Emulator - Linux Portable"
echo "=============================================="

# 1. Limpiar builds anteriores
echo "📦 Cleaning previous builds..."
fvm flutter clean
rm -rf build/linux/x64/release/bundle_portable

# 2. Build de Flutter
echo "🔨 Building Flutter app..."
fvm flutter build linux --release

# 3. Crear directorio portable
echo "📁 Creating portable bundle..."
BUNDLE_DIR="build/linux/x64/release/bundle"
PORTABLE_DIR="build/linux/x64/release/bundle_portable"
mkdir -p "$PORTABLE_DIR"

# 4. Copiar el bundle
echo "📋 Copying Flutter bundle..."
cp -r "$BUNDLE_DIR"/* "$PORTABLE_DIR/"

# 5. Copiar libmpv y dependencias
echo "📚 Copying libmpv libraries..."
mkdir -p "$PORTABLE_DIR/lib"

# Buscar libmpv en el sistema
LIBMPV_PATH=$(ldconfig -p | grep libmpv.so | head -n1 | awk '{print $NF}')

if [ -z "$LIBMPV_PATH" ]; then
    echo "❌ ERROR: libmpv.so not found in system"
    echo "   Install it with: sudo apt install libmpv-dev"
    exit 1
fi

echo "   Found libmpv at: $LIBMPV_PATH"

# Copiar libmpv y sus dependencias
cp "$LIBMPV_PATH" "$PORTABLE_DIR/lib/"

# Copiar dependencias adicionales de mpv
for lib in libavcodec.so libavformat.so libavutil.so libswscale.so libswresample.so; do
    LIB_PATH=$(ldconfig -p | grep "$lib" | head -n1 | awk '{print $NF}')
    if [ -n "$LIB_PATH" ]; then
        echo "   Copying $lib..."
        cp "$LIB_PATH" "$PORTABLE_DIR/lib/"
    fi
done

# 6. Crear script de lanzamiento
echo "📝 Creating launcher script..."
cat > "$PORTABLE_DIR/forsaken.sh" << 'EOF'
#!/bin/bash
# Launcher script for Forsaken Emulator

# Get script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Add lib directory to LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$DIR/lib:$LD_LIBRARY_PATH"

# Launch the app
"$DIR/forsaken" "$@"
EOF

chmod +x "$PORTABLE_DIR/forsaken.sh"

# 7. Crear archivo README
cat > "$PORTABLE_DIR/README.txt" << 'EOF'
Forsaken Emulator - Portable Linux Version
===========================================

INSTALLATION:
1. Extract this folder anywhere
2. Run: ./forsaken.sh

REQUIREMENTS:
- Linux x64
- No additional dependencies needed (libmpv included)

CONFIGURATION:
- Edit .env file to set ROM_PATH and MEDIA_PATH
- Place your ROMs in the configured directories

For more information, visit the documentation.
EOF

# 8. Crear .zip portable
echo "🗜️  Creating portable ZIP..."
PORTABLE_ZIP="forsaken-linux-portable-$(date +%Y%m%d).zip"
cd "$PORTABLE_DIR/.."
zip -r "$PORTABLE_ZIP" "bundle_portable"
cd - > /dev/null

echo ""
echo "✅ Build complete!"
echo "📦 Portable bundle: $PORTABLE_DIR"
echo "🗜️  Portable ZIP: build/linux/x64/release/$PORTABLE_ZIP"
echo ""
echo "To run:"
echo "  cd $PORTABLE_DIR"
echo "  ./forsaken.sh"
