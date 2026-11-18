<div align="center">

# Forsaken

**A modern, multi-platform retro gaming frontend built with Flutter**

[![Version](https://img.shields.io/badge/version-0.1.0-0A84FF)](https://github.com/ForsakenStation/ForsakenStation/releases)
[![Flutter](https://img.shields.io/badge/Flutter-3.47.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## Overview

**Forsaken** is a cross-platform frontend for browsing, organizing, and launching retro games across **170+ platforms**. It combines an Apple TV-inspired hero interface with full keyboard and gamepad navigation, EmulationStation `gamelist.xml` metadata/media support, built-in emulator & BIOS management, and multi-platform desktop builds.

### Key Features

- **170+ Preconfigured Platforms** — Consoles, handhelds, arcades, and retro computers sorted by display name with logos, backgrounds, and system specs.
- **3 Game Library Views** — List (with rich detail panel), Carousel, and Grid views, persisting your last-used view mode automatically.
- **Global Search & Collections** — Search across all platforms (`S`) or browse **Recently Played** and **Downloaded**, grouped cleanly by platform.
- **Keyboard & Gamepad First** — Full controller polling, `Shift + Letter` alphabetical jump, and consistent `ControlsBottomBar` hints across every screen.
- **Rich Media & Metadata** — Supports box art, 3D boxes, screenshots, mix images, marquees, fan art, PDF manuals (`pdfrx`), and video previews (`media_kit`).
- **Emulator, BIOS & Database Managers** — Download emulators, verify/download BIOS & firmware files, manage ROM storage, and import/export `config.json`.
- **Multi-Language UI** — Localized in English, Spanish, French, Italian, Portuguese, Catalan, Basque, and Galician.
- **Web Mode** — Optional browser playback via EmulatorJS.

---

## Installation & Running

### Prebuilt Releases (Linux, macOS, Windows)

Download the latest build from [GitHub Releases](https://github.com/ForsakenStation/ForsakenStation/releases):

- **Linux**: `.AppImage` or portable `.tar.gz` (`./forsaken.sh`)
- **macOS**: `.dmg` (drag `Forsaken.app` to Applications)
- **Windows**: `.zip` (extract and run `emulator.exe`)

### Build from Source

#### Prerequisites
- **Flutter SDK** `3.47.7` (via [FVM](https://fvm.app/) recommended)
- **Linux desktop build deps**: `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`, `liblzma-dev`, `libudev-dev`, `libmpv-dev`, `mpv`

```bash
git clone https://github.com/ForsakenStation/ForsakenStation.git
cd ForsakenStation
fvm flutter pub get

# Run in debug mode
fvm flutter run -d linux   # or macos / windows / chrome
```

#### Useful Makefile Targets

```bash
make help        # List all commands
make build       # Linux release build
make portable    # Linux portable bundle with libmpv
make appimage    # Linux AppImage package
make test        # Run all unit & widget tests
make analyze     # Run static analysis
make format      # Format Dart code
```

---

## Keyboard Shortcuts

| Context | Key | Action |
|---|---|---|
| **Global** | `Esc` / `Backspace` | Back / Exit dialog |
| **Global** | `Tab` | Open Settings |
| **Global** | `F1` / `?` | Controls Help |
| **Platforms** | `←` `→` | Navigate platforms |
| **Platforms** | `Shift + A–Z` | Jump to platform by initial |
| **Platforms** | `S` | Global game search |
| **Platforms** | `R` | Refresh platforms |
| **ROMs** | `↑` `↓` `←` `→` | Navigate games |
| **ROMs** | `Shift + A–Z` | Jump to game by initial |
| **ROMs** | `V` | Cycle view mode (List / Carousel / Grid) |
| **ROMs** | `S` | Filter current list |
| **ROMs** | `M` | Open media / manual viewer |
| **ROMs** | `Q` / `E` | Previous / Next platform |

See [docs/CONTROLS.md](docs/CONTROLS.md) and [docs/EMULATOR_CONFIG.md](docs/EMULATOR_CONFIG.md) for detailed guides.

---

## Testing & Quality

```bash
fvm flutter analyze --no-pub
dart format --set-exit-if-changed .
fvm flutter test --no-pub
```

Coverage reports can be generated with `fvm flutter test --coverage` (exclusions configured in `.lcovrc`).

---

## Contributing

Contributions are welcome! Please open an [Issue](https://github.com/ForsakenStation/ForsakenStation/issues/new/choose) or submit a Pull Request:

1. Fork the repository and create a feature branch.
2. Follow the project guidelines in [AGENTS.md](AGENTS.md) (use `DebugService` for logging, include `ControlsBottomBar` on full screens).
3. Ensure `fvm flutter analyze` and `fvm flutter test` pass cleanly.
4. Open a Pull Request describing your changes.

---

## License

Licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

## Legal Disclaimer & Trademarks

Forsaken Emulator is a frontend interface for launching emulators. It does not include, distribute, or encourage the download of copyrighted game ROMs or BIOS files. Users are solely responsible for ensuring they have the legal right to use any ROM or BIOS files with this software.

Forsaken Emulator is an independent project and is **not affiliated with, endorsed by, or sponsored by** any console manufacturer, hardware vendor, or game publisher. All platform names, logos, console images, artwork, and trademarks displayed in this repository or application belong to their respective owners and are used solely for identification and informational purposes.
