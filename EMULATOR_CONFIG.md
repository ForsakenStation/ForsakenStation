# Emulator Configuration Guide

This guide explains how to configure emulators for each platform.

## Directory Structure

```
EMULATORS_CONFIG_PATH=config.json  # Single config file for all platforms

EMULATORS_PATH/
├── fceux
├── snes9x
├── fs-uae
├── mgba
└── [emulator_binary]

ROMS_PATH/
├── _temp/              # Auto-created for downloaded ROMs
│   ├── nes/
│   ├── snes/
│   └── [platform]/
├── nes/
│   ├── mario.zip
│   └── zelda.txt       # URL file
└── [platform]/
```

## Configuration File Format

All platform configurations are stored in a **single JSON file** specified by the `EMULATORS_CONFIG_PATH` environment variable.

The app supports **two configuration formats**:

1. **Native format** - Our custom format with detailed control
2. **Forsaken format** - Compatible with Forsaken emulator frontend

### Path Resolution

Emulator paths are resolved as follows:
- **Relative paths** (`../retroarch.AppImage`): Resolved relative to the config file directory
- **Absolute paths** (`/usr/bin/retroarch`): Used as-is
- **Simple names** (`retroarch`): Resolved relative to `EMULATORS_PATH`

### Native Format (Recommended)

The `config.json` file contains an array of platform configurations:

```json
{
  "emulators": [
    {
      "platform": "platform_name",
      "commands": [
        {
          "name": "Emulator Display Name",
          "command": "emulator_binary_name",
          "args": ["{ROM}", "--arg1", "--arg2"]
        }
      ]
    }
  ]
}
```

### Forsaken Format (Auto-detected)

If you already have a Forsaken config file, the app will automatically detect and use it:

```json
{
  "emulators": [
    {
      "system": "nes",
      "command": "../retroarch.AppImage -f -L ~/.config/retroarch/cores/nestopia_libretro.so",
      "useForeverMode": false,
      "acceptZipFiles": true,
      "corePreferences": {}
    }
  ]
}
```

The app will:
- Map `system` → `platform`
- Parse the command string into command + args
- Automatically add `{ROM}` placeholder at the end
- Handle both single commands (string) and multiple commands (array)
- Resolve relative paths (`../`) relative to the config file location

### Fields

- **emulators**: Array of platform configurations
  - **platform**: Name of the platform (must match ROM folder name)
  - **commands**: Array of emulator configurations
    - **name**: Display name shown in UI
    - **command**: Emulator binary name (relative to EMULATORS_PATH)
    - **args**: Array of command-line arguments
      - Use `{ROM}` placeholder for ROM file path
      - Will be replaced with actual downloaded/local ROM path

### Single Emulator Example (Amiga)

```json
{
  "emulators": [
    {
      "platform": "amiga",
      "commands": [
        {
          "name": "FS-UAE",
          "command": "fs-uae",
          "args": ["--floppy-drive-0={ROM}"]
        }
      ]
    }
  ]
}
```

When launching: User clicks "Launch" → Emulator starts immediately

### Multiple Emulators Example (NES)

```json
{
  "emulators": [
    {
      "platform": "nes",
      "commands": [
        {
          "name": "FCEUX",
          "command": "fceux",
          "args": ["{ROM}"]
        },
        {
          "name": "Nestopia",
          "command": "nestopia",
          "args": ["--fullscreen", "{ROM}"]
        }
      ]
    }
  ]
}
```

When launching: User clicks "Launch" → Dialog shows → User selects emulator → Emulator starts

## Setup Steps

### 1. Configure Environment Variables

Edit your `.env` file:

```env
ROMS_PATH=/path/to/roms
MEDIA_PATH=/path/to/media
EMULATORS_PATH=/path/to/emulators
EMULATORS_CONFIG_PATH=/path/to/config.json
```

### 2. Install Emulators

Install your emulators in `EMULATORS_PATH` or ensure they're in your system PATH.

**Linux:**
```bash
# Install via package manager
sudo apt install fceux snes9x mgba

# Or place binaries in EMULATORS_PATH
mkdir -p /path/to/emulators
cp /usr/bin/fceux /path/to/emulators/
```

**Windows:**
```
EMULATORS_PATH/
├── fceux.exe
├── snes9x.exe
└── mgba.exe
```

**macOS:**
```bash
# Install via Homebrew
brew install fceux snes9x mgba

# Or place .app bundles in EMULATORS_PATH
```

### 3. Create Configuration File

Create a single `config.json` file at the path specified by `EMULATORS_CONFIG_PATH`:

```bash
# Copy the example config
cp /path/to/project/config.example.json /path/to/config.json

# Edit to match your installed emulators
nano /path/to/config.json
```

See `config.example.json` in the project root for a complete example with multiple platforms.

### 4. Test Configuration

1. Run the app
2. Navigate to a platform
3. Select a ROM
4. Click "Launch" or "Download & Launch"
5. Select emulator (if multiple configured)
6. Emulator should start with the ROM loaded

## ROM Download Behavior

### Local ROMs
- File exists in ROM folder (e.g., `mario.zip`)
- Launches directly from original location
- No download or temp file created

### URL ROMs
- `.txt` file contains download URL
- Downloads to `ROMS_PATH/_temp/[platform]/`
- Launches from temp location
- Temp file persists (not auto-deleted)

### Cleaning Temp Files

Temp files are NOT automatically deleted. To clean them:

```bash
# Clean all platforms
rm -rf /path/to/roms/_temp/

# Clean specific platform
rm -rf /path/to/roms/_temp/nes/
```

## Platform-Specific Examples

### Complete Multi-Platform Configuration

See `config.example.json` for a complete example. Below are individual platform snippets:

### NES
```json
{
  "platform": "nes",
  "commands": [
    {
      "name": "FCEUX",
      "command": "fceux",
      "args": ["{ROM}"]
    }
  ]
}
```

### SNES
```json
{
  "platform": "snes",
  "commands": [
    {
      "name": "SNES9x",
      "command": "snes9x",
      "args": ["{ROM}"]
    }
  ]
}
```

### Game Boy Advance
```json
{
  "platform": "gba",
  "commands": [
    {
      "name": "mGBA",
      "command": "mgba",
      "args": ["-f", "{ROM}"]
    }
  ]
}
```

### PlayStation 1
```json
{
  "platform": "ps1",
  "commands": [
    {
      "name": "DuckStation",
      "command": "duckstation-qt",
      "args": ["-fullscreen", "{ROM}"]
    },
    {
      "name": "PCSX-ReARMed",
      "command": "pcsx",
      "args": ["-nogui", "-cdfile", "{ROM}"]
    }
  ]
}
```

### Nintendo 64
```json
{
  "platform": "n64",
  "commands": [
    {
      "name": "Mupen64Plus",
      "command": "mupen64plus",
      "args": ["--fullscreen", "{ROM}"]
    }
  ]
}
```

## Troubleshooting

### "No emulator configured" Error

**Cause:** No configuration exists for the platform in `config.json`

**Solution:**
1. Open your `config.json` file
2. Add an entry to the `emulators` array for the platform
3. Ensure platform name matches ROM folder name exactly (case-insensitive)
4. Check file permissions (must be readable)

### "Emulator not found" Error

**Cause:** Emulator binary doesn't exist at specified path

**Solution:**
1. Check `command` field points to correct binary
2. Verify binary exists in `EMULATORS_PATH` or system PATH
3. On Linux/macOS, ensure binary has execute permissions:
   ```bash
   chmod +x /path/to/emulators/fceux
   ```

### "Failed to launch ROM" Error

**Cause:** Various issues with ROM or emulator

**Solution:**
1. Verify ROM file is valid (not corrupted)
2. Check emulator supports the ROM format
3. Try launching emulator manually from terminal:
   ```bash
   /path/to/emulators/fceux /path/to/rom.nes
   ```
4. Check emulator logs for errors

### Download Fails

**Cause:** Network issues or invalid URL

**Solution:**
1. Verify URL in `.txt` file is correct
2. Check internet connection
3. Try downloading URL manually with curl/wget
4. Ensure sufficient disk space in `ROMS_PATH/_temp/`

## Advanced Configuration

### Custom Arguments

You can pass any arguments supported by the emulator:

```json
{
  "name": "FCEUX (No Sound)",
  "command": "fceux",
  "args": ["--sound", "0", "{ROM}"]
}
```

### Multiple ROM Paths

Some emulators need multiple files:

```json
{
  "name": "Multi-Disc Game",
  "command": "emulator",
  "args": ["-disc1", "{ROM}", "-disc2", "/path/to/disc2.bin"]
}
```

### Platform-Specific Paths

Use absolute paths for platform-specific resources:

```json
{
  "name": "Amiga with Kickstart",
  "command": "fs-uae",
  "args": [
    "--kickstart_file=/path/to/kickstart.rom",
    "--floppy-drive-0={ROM}"
  ]
}
```

## Environment Variable Reference

| Variable | Purpose | Example |
|----------|---------|---------|
| `ROMS_PATH` | Base directory for ROMs | `/home/user/roms` |
| `MEDIA_PATH` | Directory for media assets | `/home/user/media` |
| `EMULATORS_PATH` | Directory containing emulator binaries | `/home/user/emulators` |
| `EMULATORS_CONFIG_PATH` | Path to config.json file | `/home/user/emulators/config.json` |
