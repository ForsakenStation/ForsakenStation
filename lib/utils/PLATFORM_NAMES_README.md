# Platform Names Mapping

## Overview
This utility provides a comprehensive mapping from common emulation folder names to their proper platform display names.

## Usage

### In Platform Model
The `Platform` model now automatically uses this mapping:

```dart
final platform = Platform(name: 'snes', path: '/path/to/snes');
print(platform.displayName); // "Super Nintendo Entertainment System"
print(platform.shortName);   // "SNES"
```

### Direct Usage
You can also use the utility class directly:

```dart
import 'package:forsaken/utils/platform_names.dart';

// Get full display name
String fullName = PlatformNames.getDisplayName('nes');
// Returns: "Nintendo Entertainment System"

// Get short name (for compact displays)
String shortName = PlatformNames.getShortName('nes');
// Returns: "NES"

// Check if a platform exists
bool exists = PlatformNames.exists('genesis');
// Returns: true

// Get all available platform codes
List<String> allCodes = PlatformNames.getAllCodes();
```

## Supported Platforms

### Nintendo
- `nes` → Nintendo Entertainment System
- `snes` → Super Nintendo Entertainment System
- `n64` → Nintendo 64
- `gc`, `gamecube` → Nintendo GameCube
- `wii` → Nintendo Wii
- `wiiu` → Nintendo Wii U
- `switch` → Nintendo Switch
- `gb` → Game Boy
- `gbc` → Game Boy Color
- `gba` → Game Boy Advance
- `nds`, `ds` → Nintendo DS
- `3ds` → Nintendo 3DS

### Sega
- `genesis`, `megadrive`, `md` → Sega Genesis / Mega Drive
- `mastersystem`, `sms` → Sega Master System
- `saturn` → Sega Saturn
- `dreamcast`, `dc` → Sega Dreamcast
- `gamegear`, `gg` → Sega Game Gear

### Sony
- `ps1`, `psx`, `playstation` → PlayStation
- `ps2` → PlayStation 2
- `ps3` → PlayStation 3
- `ps4` → PlayStation 4
- `psp` → PlayStation Portable
- `psvita`, `vita` → PlayStation Vita

### Microsoft
- `xbox` → Xbox
- `xbox360` → Xbox 360
- `xboxone` → Xbox One

### Atari
- `atari2600` → Atari 2600
- `atari5200` → Atari 5200
- `atari7800` → Atari 7800
- `atarijaguar`, `jaguar` → Atari Jaguar
- `atarilynx`, `lynx` → Atari Lynx
- `atarist` → Atari ST

### Classic Computers
- `amiga` → Commodore Amiga
- `c64` → Commodore 64
- `c128` → Commodore 128
- `vic20` → Commodore VIC-20
- `zxspectrum`, `spectrum` → ZX Spectrum
- `msx` → MSX
- `msx2` → MSX2
- `amstradcpc`, `cpc` → Amstrad CPC

### Arcade
- `arcade` → Arcade
- `mame` → MAME Arcade
- `fba` → FinalBurn Alpha
- `fbneo` → FinalBurn Neo
- `naomi` → Sega Naomi

### Other Systems
- `3do` → 3DO Interactive Multiplayer
- `colecovision`, `coleco` → ColecoVision
- `intellivision` → Intellivision
- `pcengine`, `pce`, `tg16`, `turbografx16` → PC Engine / TurboGrafx-16
- `wonderswan`, `ws` → WonderSwan
- `neogeo` → Neo Geo
- `virtualboy`, `vb` → Virtual Boy

### PC
- `dos` → MS-DOS
- `windows` → Windows
- `scummvm` → ScummVM

## Fallback Behavior
If a platform code is not found in the mapping, the utility will:
1. Split the code by underscores, hyphens, or spaces
2. Capitalize the first letter of each word
3. Join them with spaces

Example:
```dart
PlatformNames.getDisplayName('super_famicom');
// Returns: "Super Famicom"
```

## Adding New Platforms
To add support for a new platform, edit `lib/utils/platform_names.dart` and add entries to the `displayNames` map and optionally the `shortNames` map in `getShortName()`.

## Benefits
1. **Consistent naming** across the entire app
2. **User-friendly display** - shows proper names instead of folder codes
3. **Flexible** - handles multiple aliases for the same platform
4. **Extensible** - easy to add new platforms
5. **Fallback** - gracefully handles unknown platforms
