> **Language**: **English** | [Español](Contributing-&-Architecture-ES)

# Contributing & Architecture

## Project Structure
```text
lib/
  main.dart                 # App initialization & root EmulatorApp
  constants/                # Legal constants & app version
  models/                   # Data models (Rom, EmulatorPlatform, GameInfo, etc.)
  services/                 # Business logic (ConfigService, RomService, MediaService, EmulatorService)
  screens/                  # Full-screen pages (Platforms, ROMs, Settings & subscreens)
  widgets/                  # Reusable UI components (ControlsBottomBar, AppSnackBar, PlatformBadge)
  utils/                    # Platform aliases, security validation, theme helpers
```

## Development Rules
- Use `DebugService.instance` for all logging (never `print()` or `debugPrint()`).
- Include `ControlsBottomBar` on all full-screen pages.
- Run `fvm flutter analyze --no-pub` and `fvm flutter test --no-pub` before submitting PRs.

## Automated Releases & Wiki Sync
- Pushing a `v*` tag triggers `.github/workflows/release.yml` (Linux AppImage/tar.gz, macOS DMG, Windows ZIP).
- Pushing changes under `docs/wiki/` to `main` automatically syncs this GitHub Wiki via `.github/workflows/wiki.yml`.
