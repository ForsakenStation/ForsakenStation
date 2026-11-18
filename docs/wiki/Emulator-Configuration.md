> **Language**: **English** | [Español](Emulator-Configuration-ES)

# Emulator Configuration

Forsaken includes default launch configurations for **171 platforms** in `assets/config.json`, supporting both **RetroArch cores** and **standalone emulators** (Dolphin, PCSX2, Cemu, RPCS3, xemu, Xenia, DuckStation, etc.).

## Managing Emulators
Go to **Settings → Emulator Management** to:
- Download supported emulators directly into `EMULATORS_PATH`.
- Add, edit, or reorder launch commands for any platform.
- Toggle `acceptZipFiles` (when `false`, `.zip` ROMs are extracted to permanent storage before launch).

## Export & Import `config.json`
In **Settings → System Utilities**:
- **Export config.json**: Saves your active emulator configuration to a backup JSON file.
- **Import config.json**: Restores a previously exported `config.json` with schema validation.

## Special Launch Flags Examples
- **Xbox (`xemu`)**: `xemu.AppImage -dvd_path` (`acceptZipFiles: false`)
- **GameCube / Wii (`dolphin`)**: `dolphin.AppImage -e` (`acceptZipFiles: false`)
- **Wii U (`cemu`)**: `cemu.AppImage -g`
- **RetroArch**: `retroarch.AppImage -f -L ~/.config/retroarch/cores/<core>_libretro.so`
