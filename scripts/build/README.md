# Build Scripts

Scripts for building and packaging Forsaken Emulator for distribution.

## Available Build Scripts

### 📦 build_linux_portable.sh
Creates a portable Linux bundle with all dependencies included.

**What it does:**
- Builds Flutter app in release mode
- Copies libmpv and video codec libraries
- Creates portable directory with all dependencies
- Generates launcher script
- Creates ZIP archive for distribution

**Usage:**
```bash
# From project root
make portable

# Or directly
bash scripts/build/build_linux_portable.sh
```

**Output:**
- `build/linux/x64/release/bundle_portable/` - Portable directory
- `build/linux/x64/release/forsaken-linux-portable-YYYYMMDD.zip` - ZIP archive

**Features:**
- ✅ No installation needed
- ✅ All dependencies included
- ✅ Works on any Linux x64 system
- ✅ Just extract and run

---

### 🗜️ build_appimage.sh
Creates an AppImage package for universal Linux distribution.

**What it does:**
- Builds Flutter app in release mode
- Creates AppDir structure
- Copies all dependencies
- Includes libmpv and video codecs
- Generates AppImage with appimagetool

**Requirements:**
- `appimagetool` (automatically downloaded if not found)

**Usage:**
```bash
# From project root
make appimage

# Or directly
bash scripts/build/build_appimage.sh
```

**Output:**
- `Forsaken-X.Y.Z-x86_64.AppImage` - Portable AppImage

**Features:**
- ✅ Single file distribution
- ✅ No installation needed
- ✅ Desktop integration
- ✅ Works on any Linux x64 system
- ✅ Auto-updates support (with AppImageUpdate)

---

## Quick Start

### Using Makefile (Recommended)
```bash
# Build portable bundle
make portable

# Build AppImage
make appimage

# Build regular release
make build

# Show all commands
make help
```

### Direct Execution
```bash
# Make scripts executable
chmod +x scripts/build/*.sh

# Run from project root
bash scripts/build/build_linux_portable.sh
bash scripts/build/build_appimage.sh
```

---

## Requirements

### System Dependencies
- **Flutter SDK** (managed via fvm)
- **Linux build tools**
- **libmpv-dev** - For video playback
  ```bash
  sudo apt install libmpv-dev  # Debian/Ubuntu
  sudo pacman -S mpv           # Arch Linux
  ```

### Optional
- **appimagetool** - For AppImage builds (auto-downloaded)
- **zip** - For portable ZIP creation

---

## Build Output

### Portable Bundle Structure
```
bundle_portable/
├── forsaken              # Main executable
├── forsaken.sh          # Launcher script
├── lib/                 # Bundled libraries
│   ├── libmpv.so
│   ├── libavcodec.so
│   └── ...
├── data/                # Flutter assets
└── README.txt           # Usage instructions
```

### AppImage Structure
```
Forsaken.AppDir/
├── AppRun               # Entry point
├── forsaken.desktop     # Desktop entry
├── forsaken.png         # Icon
├── usr/
│   ├── bin/             # Executables
│   ├── lib/             # Libraries
│   └── share/           # Desktop files & icons
```

---

## Distribution

### Portable Bundle
1. Build: `make portable`
2. Extract ZIP from `build/linux/x64/release/`
3. Distribute ZIP file
4. Users extract and run `./forsaken.sh`

### AppImage
1. Build: `make appimage`
2. Distribute single `.AppImage` file
3. Users make executable: `chmod +x Forsaken-*.AppImage`
4. Users run: `./Forsaken-*.AppImage`

---

## Troubleshooting

### "libmpv.so not found"
**Solution:** Install libmpv development package
```bash
sudo apt install libmpv-dev     # Debian/Ubuntu
sudo pacman -S mpv              # Arch Linux
sudo dnf install mpv-libs-devel # Fedora
```

### "appimagetool not found"
**Solution:** Script will auto-download. Or install manually:
```bash
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
sudo mv appimagetool-x86_64.AppImage /usr/local/bin/appimagetool
```

### Build fails with "command not found: fvm"
**Solution:** Install Flutter Version Management
```bash
dart pub global activate fvm
fvm install
```

### AppImage doesn't run
**Solution:** Make it executable
```bash
chmod +x Forsaken-*.AppImage
```

---

## Development Notes

### Adding New Build Types

To add a new build script:

1. Create script in `scripts/build/`
2. Add target to `Makefile`
3. Update this README
4. Test from project root and from script directory

Example Makefile target:
```makefile
my-build:
	@echo "🔨 Building my custom build..."
	@bash scripts/build/my_build.sh
```

### Testing Builds

Always test builds on a clean system or VM to ensure all dependencies are included:

```bash
# Test portable bundle
cd build/linux/x64/release/bundle_portable
./forsaken.sh

# Test AppImage
./Forsaken-*.AppImage
```

---

## See Also

- [Main README](../../README.md) - Project overview
- [Scripts Overview](../README.md) - All utility scripts
- [Makefile](../../Makefile) - Build automation
- [AGENTS.md](../../AGENTS.md) - Development guidelines
