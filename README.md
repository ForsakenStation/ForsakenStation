# Forsaken - Multi-Platform Retro Gaming Frontend

<div align="center">

**A beautiful, feature-rich Flutter-based frontend for managing and launching retro game emulators**

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 🎮 Overview

Forsaken is a modern, cross-platform retro gaming frontend built with Flutter. It provides a polished interface for browsing, organizing, and launching ROMs across multiple gaming platforms, with support for custom emulators, media management, and an intuitive navigation system.

### Key Features

- 🎯 **Multi-Platform Support** - Works on Android, iOS, Linux, Windows, macOS, and Web
- 🎨 **Beautiful UI** - Gorgeous themes with custom backgrounds, logos, and platform-specific artwork
- 🕹️ **Multiple View Modes** - Grid, List, and Carousel views for browsing your game library
- 🎮 **Gamepad Support** - Full controller navigation with customizable button mappings
- ⌨️ **Keyboard Navigation** - Comprehensive keyboard shortcuts for power users
- 🖼️ **Rich Media Display** - Box art, screenshots, videos, marquees, and fan art support
- 📥 **ROM Download Management** - Built-in download manager with queue and progress tracking
- 🔍 **Advanced Search** - Quick search with letter jumping and filtering
- 🎲 **Random Game Selection** - Discover games you haven't played in a while
- 📊 **Platform Information** - Detailed specs and history for each gaming platform
- ⚙️ **Emulator Management** - Configure and manage multiple emulators per platform
- 🌐 **GameList Support** - Compatible with popular frontend formats (EmulationStation XML)
- 🎬 **Fullscreen Media Viewer** - Browse game media in an immersive fullscreen mode
- 🎯 **Smart Navigation** - Context-aware controls and navigation overlay

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.10.0 or higher
- **FVM** (Flutter Version Management) - recommended
- **Dart SDK** 3.10.0 or higher
- Platform-specific build tools (for mobile/desktop builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd forsaken
   ```

2. **Install Flutter dependencies**
   ```bash
   fvm flutter pub get
   ```

3. **Configure paths (first launch)**
   
   On first launch, go to **Settings > System Paths** to configure:
   - **Media Path**: directory containing media assets (images, videos)
   - **Emulators Path**: directory containing emulator binaries
   - **Emulators Config Path**: path to your emulator config JSON
   - **ROM Storage**: optional temporary/permanent ROM download paths

   Paths are stored in SharedPreferences and persist across sessions.

4. **Set up directory structure**
   
   Organize your ROMs and media following this structure:
   ```
   ROMS_PATH/
     ├── nes/
     │   ├── game1.nes
     │   └── game2.nes
     ├── snes/
     │   ├── game1.sfc
     │   └── game2.sfc
     └── ...
   
   MEDIA_PATH/
     ├── nes/
     │   ├── boxart/
     │   ├── screenshots/
     │   ├── videos/
     │   ├── marquee/
     │   └── fanart/
     └── ...
   ```

5. **Run the app**
   ```bash
   # Desktop (Linux/macOS/Windows)
   fvm flutter run -d linux
   fvm flutter run -d macos
   fvm flutter run -d windows
   
   # Mobile
   fvm flutter run -d android
   fvm flutter run -d ios
   
   # Web
   fvm flutter run -d chrome
   ```

---

## 🏗️ Building

Build commands are available through the Makefile for convenience.

### Quick Build
```bash
# Show all available commands
make help

# Standard release build
make build

# Portable Linux bundle (includes all dependencies)
make portable

# AppImage (single-file distribution)
make appimage
```

### Desktop

Standard Flutter builds:

```bash
# Linux
fvm flutter build linux --release
make build

# macOS
fvm flutter build macos --release

# Windows
fvm flutter build windows --release
```

### Mobile

```bash
# Android APK
fvm flutter build apk --release

# Android App Bundle
fvm flutter build appbundle --release

# iOS
fvm flutter build ios --release
```

### Web

```bash
fvm flutter build web --release
```

---

## 🎯 Usage

### Navigation

#### Keyboard Controls

**Platform Selection:**
- `↑/↓` - Navigate platforms
- `Enter` - Select platform
- `Esc` - Go back
- `Q` - Quit application
- `S` - Open settings
- `F` - Toggle fullscreen
- `1-4` - Switch themes

**ROM Browsing (List View at Root):**
- `↑/↓` - Navigate ROMs
- `←/→` or `Q/E` - Switch between platforms (with slide animation)
- `Enter` - Launch ROM
- `R` - Random game selection
- `V` - Change view mode (Grid/List/Carousel)
- `S` - Search ROMs
- `Shift + Letter` - Jump to ROMs starting with that letter
- `Esc` - Back to platforms

**ROM Browsing (in Subdirectories):**
- `↑/↓` - Navigate ROMs
- `Enter` - Launch ROM or enter folder
- `Esc` - Go back to parent folder
- `R` - Random game
- `V` - Change view
- `S` - Search

**Fullscreen Media Viewer:**
- `←/→` - Navigate between images
- `Space` - Toggle controls overlay
- `Esc` - Exit fullscreen

#### Gamepad Controls

- **D-Pad/Left Stick** - Navigate
- **A Button** - Select/Launch
- **B Button** - Back
- **X Button** - Random game
- **Y Button** - Search
- **Start** - Settings
- **L1/R1 or L2/R2** - Switch platforms (in List View at root)

### View Modes

1. **Grid View** - Display games in a grid with box art
2. **List View** - Compact list with icons and game names
3. **Carousel View** - Cinematic 3D carousel with large preview images

Press `V` or click the view button to cycle between modes.

### Settings

Access the settings screen to configure:

- **ROM Storage Management** - Manage ROM paths and directories
- **Emulator Configuration** - Add and configure emulators per platform
- **Download Manager** - View and manage ROM downloads
- **Media Paths** - Configure media asset directories
- **GameList Settings** - Import/export EmulationStation XML files
- **Appearance** - Theme selection and customization
- **Controls** - Customize keyboard and gamepad mappings

---

## 🏗️ Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/                        # Data models
│   ├── platform.dart             # Platform model
│   ├── rom.dart                  # ROM model
│   ├── rom_item.dart             # ROM item for display
│   ├── media.dart                # Media assets model
│   └── ...
├── screens/                       # UI screens
│   ├── platforms_screen.dart     # Platform selection
│   ├── roms_screen.dart          # ROM browser
│   ├── settings_screen.dart      # Settings hub
│   ├── settings_categories/      # Settings sub-screens
│   └── roms/                     # ROM view implementations
├── services/                      # Business logic
│   ├── rom_service.dart          # ROM management
│   ├── media_service.dart        # Media asset management
│   ├── emulator_service.dart     # Emulator launching
│   ├── download_service.dart     # Download management
│   ├── keyboard_service.dart     # Keyboard input handling
│   ├── gamepad_service.dart      # Gamepad input handling
│   ├── platform_info_service.dart # Platform information
│   └── ...
├── widgets/                       # Reusable UI components
│   ├── common/                   # Common widgets
│   │   ├── navigation_overlay.dart
│   │   └── platform_logo.dart
│   └── roms/                     # ROM-specific widgets
│       ├── media_carousel.dart
│       ├── fullscreen_image_viewer.dart
│       └── ...
├── utils/                         # Helper functions
│   ├── platform_icons.dart
│   └── ...
└── constants/                     # App constants

scripts/                           # Utility scripts
├── README.md                      # Scripts overview
├── media-migration/               # Media reorganization tools
│   ├── migrate_media.py          # Migrate media to JSONL structure
│   └── ...
└── media-scraper/                 # Download media from web
    ├── scrape_media.py           # ScreenScraper.fr integration
    └── ...

assets/
├── config.json                    # App configuration
├── data/
│   └── platforms_info.json       # Platform metadata
├── images/                        # App images (logo, icon)
└── theme/
    └── images/
        ├── logos/                # Platform logos (white)
        ├── clogos/               # Platform logos (color)
        ├── backgrounds/          # Platform backgrounds
        └── systems/              # Platform system images
```

---

## 🔧 Configuration

### Platform Configuration

Platforms are automatically detected from directories in your `ROMS_PATH`. Each platform directory should match the standard naming convention (e.g., `nes`, `snes`, `genesis`, `psx`).

Platform information is loaded from `assets/data/platforms_info.json`, which includes:
- Display names
- Manufacturer
- Generation
- Release year
- CPU/GPU specs
- Description and history

### Emulator Configuration

Configure emulators through the Settings > Emulator Management screen:
1. Add a new emulator
2. Specify the executable path
3. Configure command-line arguments
4. Set file extension filters
5. Test with a sample ROM

### Media Assets

Media files should be organized by platform and type. The project includes utilities in the `scripts/` directory to help manage media:

**Media Directory Structure:**
```
MEDIA_PATH/
  └── <platform>/
      ├── boxart/     # Box art images (PNG/JPG)
      ├── screenshots/ # In-game screenshots
      ├── videos/      # Video previews (MP4)
      ├── marquee/     # Arcade marquee images
      ├── titlescreen/ # Title screen captures
      └── fanart/      # Fan-created artwork
```

File names should match the ROM filename (without extension).

**Media Management Scripts:**

The project includes scripts to help manage your media collection:

1. **Media Migration** - Reorganize existing media to match ROM folder structure
   ```bash
   cd scripts/media-migration
   ./migrate_media.py <platform> --dry-run
   ```

2. **Media Scraper** - Download missing media from ScreenScraper.fr
   ```bash
   cd scripts/media-scraper
   ./scrape_with_env.sh <platform> --media-types covers,screenshots
   ```

See [scripts/README.md](scripts/README.md) for complete documentation.

---

## 🛠️ Development

### Code Style

This project follows the [Flutter Style Guide](https://flutter.dev/docs/development/tools/formatting) and conventions outlined in `AGENTS.md`.

Key points:
- Use `dart format` for consistent formatting
- Run `fvm flutter analyze` before committing
- Write meaningful commit messages
- Keep widgets small and focused
- Extract reusable components

### Running Tests

```bash
# Run all tests
fvm flutter test

# Run with coverage
fvm flutter test --coverage

# Run specific test file
fvm flutter test test/widget_test.dart
```

### Code Analysis

```bash
# Static analysis
fvm flutter analyze

# Format code
dart format -o write .

# Check formatting
dart format --set-exit-if-changed .
```

---

## 📦 Dependencies

### Core
- **flutter** - UI framework
- **provider** - State management
- **path_provider** - File system paths
- **shared_preferences** - Local settings storage

### Media & Assets
- **flutter_svg** - SVG rendering for logos
- **media_kit** - Video playback support
- **media_kit_video** - Video player UI
- **media_kit_libs_video** - Video codecs

### Input
- **gamepads** - Gamepad/controller support

### UI & Theming
- **google_fonts** - Custom fonts

### Utilities
- **http** - HTTP requests for downloads
- **xml** - GameList XML parsing
- **archive** - Archive extraction (ZIP, 7Z)
- **file_picker** - File selection dialogs
- **window_manager** - Desktop window management

---

## 🎨 Themes

Forsaken includes multiple built-in themes:
1. **Cyber Blue** - Modern blue/cyan aesthetic
2. **Neon Pink** - Vibrant pink/purple palette
3. **Retro Green** - Classic CRT green terminal
4. **Sunset Orange** - Warm orange/red gradient

Switch themes from the platform screen using number keys (1-4) or through Settings.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and analysis
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

Please ensure your code follows the project style guidelines and includes appropriate tests.

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Retro gaming community for inspiration
- EmulationStation for the GameList XML format
- All contributors and testers

---

## 📚 Documentation

See the `docs/` directory for detailed guides on configuration, controls, and debugging:
- [docs/CONTROLS.md](docs/CONTROLS.md)
- [docs/CONTROLS_ARCHITECTURE.md](docs/CONTROLS_ARCHITECTURE.md)
- [docs/EMULATOR_CONFIG.md](docs/EMULATOR_CONFIG.md)
- [docs/GAMEPAD_DEBUG.md](docs/GAMEPAD_DEBUG.md)

---

## 🗺️ Roadmap

- [x] Media migration utilities
- [x] Online scraper integration (ScreenScraper.fr)
- [ ] TheGamesDB integration
- [ ] Cloud save sync
- [ ] Achievement tracking
- [ ] Play time statistics
- [ ] Favorites and collections
- [ ] Multi-language support
- [ ] Custom theme editor
- [ ] Shader support for enhanced visuals
- [ ] Network multiplayer lobby
- [ ] Plugin system for extensions

---

<div align="center">

**Made with ❤️ by the retro gaming community**

[⬆ back to top](#forsaken---multi-platform-retro-gaming-frontend)

</div>

## Testing

### Run all tests
```bash
fvm flutter test
```

### Run tests with coverage
```bash
fvm flutter test --coverage
```

Coverage data is written to `coverage/lcov.info`. To generate an HTML report (requires `lcov`):
```bash
genhtml coverage/lcov.info -o coverage/html
```

### Coverage targets
- Models: 80%
- Services: 70%
- Utils: 75%

### Excluded from coverage
- Generated files (`*.g.dart`, `*.freezed.dart`)
- Platform stubs (`*_stub.dart`)
- Localization files (`lib/l10n/generated/`)

See `.lcovrc` for the full exclusion configuration.

## Legal Disclaimer & Trademarks

Forsaken Emulator is a frontend interface for launching emulators. It does not include, distribute, or encourage the download of copyrighted game ROMs or BIOS files. Users are solely responsible for ensuring they have the legal right to use any ROM or BIOS files with this software.

Forsaken Emulator is an independent project and is **not affiliated with, endorsed by, or sponsored by** any console manufacturer, hardware vendor, or game publisher. All platform names, logos, console images, artwork, and trademarks displayed in this repository or application belong to their respective owners and are used solely for identification and informational purposes.
