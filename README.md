# Emulator Frontend

Multi-platform emulator frontend built with Flutter. Manages ROM files, downloads them on-demand, and launches emulators with the downloaded ROMs.

## Features

- Multi-platform support (Android, iOS, Linux, Windows, macOS, Web)
- Automatic ROM discovery from configured directory
- On-demand ROM downloading from URLs
- Media support (boxart, screenshots, videos)
- Clean temporary file management
- Simple configuration via environment variables

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── rom.dart                 # ROM model
│   ├── platform.dart            # Platform model
│   └── media.dart               # Media model
├── services/                    # Business logic
│   ├── rom_service.dart         # ROM file reading
│   ├── download_service.dart    # ROM downloading
│   ├── media_service.dart       # Media file management
│   └── emulator_service.dart    # Emulator launching
├── screens/                     # UI screens
│   ├── platforms_screen.dart    # Platform selection
│   └── roms_screen.dart         # ROM listing
└── widgets/                     # Reusable UI components
    └── rom_card.dart            # ROM display card
```

## Setup

### 1. Install Flutter

Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install) for your platform.

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` with your paths:

```bash
# Path to ROMs directory
ROMS_PATH=/path/to/your/roms

# Path to media directory
MEDIA_PATH=/path/to/your/media

# Optional: Configure emulator paths per platform
EMULATOR_SNES=/usr/bin/snes9x
EMULATOR_NES=/usr/bin/fceux
EMULATOR_N64=/usr/bin/mupen64plus
EMULATOR_PS1=/usr/bin/duckstation-qt
EMULATOR_GBA=/usr/bin/mgba
```

### 4. Directory Structure

Organize your ROMs and media files as follows:

```
ROMS_PATH/
├── snes/
│   ├── super_mario_world.txt
│   ├── zelda_alttp.txt
│   └── ...
├── nes/
│   ├── super_mario_bros.txt
│   └── ...
└── gba/
    └── ...

MEDIA_PATH/
├── snes/
│   ├── boxart/
│   │   ├── super_mario_world.png
│   │   └── zelda_alttp.png
│   ├── screenshots/
│   │   └── super_mario_world.png
│   └── videos/
│       └── super_mario_world.mp4
├── nes/
│   └── ...
└── gba/
    └── ...
```

**ROM Files**: Each ROM is represented by a `.txt` file containing the download URL:

```
super_mario_world.txt:
https://example.com/roms/super_mario_world.sfc
```

**Media Files**: Images and videos should have the same name as the ROM file (without `.txt` extension).

## Running the App

### Desktop (Linux/Windows/macOS)

```bash
flutter run -d linux      # Linux
flutter run -d windows    # Windows
flutter run -d macos      # macOS
```

### Mobile

```bash
flutter run -d android    # Android
flutter run -d ios        # iOS (macOS only)
```

### Web

```bash
flutter run -d chrome
```

## Building

### Release Builds

```bash
flutter build apk           # Android APK
flutter build appbundle     # Android App Bundle
flutter build linux         # Linux
flutter build windows       # Windows
flutter build macos         # macOS
flutter build ios           # iOS
flutter build web           # Web
```

## How It Works

1. **Platform Discovery**: The app scans `ROMS_PATH` for subdirectories (each represents a platform)
2. **ROM Discovery**: Within each platform directory, `.txt` files are discovered (each represents a ROM)
3. **Media Loading**: Corresponding media files are loaded from `MEDIA_PATH/platform/type/romname.ext`
4. **ROM Launch**:
   - User selects a ROM
   - App reads the download URL from the `.txt` file
   - ROM is downloaded to temporary directory
   - Emulator is launched with the downloaded ROM path
   - Temporary file is cleaned up after emulator closes

## Configuration

### Emulator Paths

Configure emulator executables via environment variables:

```bash
EMULATOR_<PLATFORM>=<path_to_emulator>
```

Platform names should match your directory names in uppercase.

### Supported Media Extensions

- **Images** (boxart/screenshots): `.png`, `.jpg`, `.jpeg`, `.webp`
- **Videos**: `.mp4`, `.webm`, `.mkv`, `.avi`

## Development

### Run Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Format Code

```bash
dart format -o write .
```

## Troubleshooting

### "No platforms found"

- Verify `ROMS_PATH` in `.env` is correct
- Ensure the directory exists and contains platform subdirectories

### "Failed to launch emulator"

- Check that an emulator executable path is configured in `.env`
- Verify the emulator executable exists and is executable
- Check console output for error messages

### Media not showing

- Verify `MEDIA_PATH` in `.env` is correct
- Ensure media files have the same name as ROM files (without `.txt`)
- Check file extensions are supported

## License

This project is open source.


## Thanks
[https://github.com/dm2912/Crystal](https://github.com/dm2912/Crystal) for the images
