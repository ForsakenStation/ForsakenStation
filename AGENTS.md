# AGENTS.md - Emulator Frontend Development Guide

## ⚠️ CRITICAL GIT POLICY ⚠️

**ABSOLUTELY NEVER USE ANY GIT COMMANDS WITHOUT EXPLICIT USER PERMISSION**

### PROHIBITED Git Commands:
- ❌ **NEVER** run `git commit` 
- ❌ **NEVER** run `git add`
- ❌ **NEVER** run `git checkout`
- ❌ **NEVER** run `git stash` (especially `git stash drop`)
- ❌ **NEVER** run `git reset`
- ❌ **NEVER** run `git rebase`
- ❌ **NEVER** run `git push`
- ❌ **NEVER** run ANY destructive git operation
- ❌ **NEVER** suggest or execute git commands proactively

### ALLOWED Git Commands (Read-only):
- ✅ `git status` - Only when explicitly requested
- ✅ `git diff` - Only when explicitly requested  
- ✅ `git log` - Only when explicitly requested

### The ONLY Exception:
- User explicitly says: "commit this", "create a commit", "git commit", "push to remote", etc.
- Even then, CONFIRM before executing destructive commands

**WHY THIS IS CRITICAL**: Running git commands without permission can cause MASSIVE data loss. The user MUST review all changes before committing. NEVER assume the user wants changes committed, even after tests pass or builds succeed.

## 💬 COMMUNICATION STYLE

**BE CONCISE TO SAVE TOKENS:**
- Short, direct responses
- No verbose explanations unless asked
- No emoji unless requested
- No unnecessary context
- Get straight to the point
- Use bullet points over paragraphs
- Omit pleasantries and filler words

## Project Overview
Flutter-based multi-platform emulator frontend that manages ROM files and launches emulators. ROMs are organized by platform, with metadata stored in text files containing download URLs. Media assets (images, videos) are organized separately by platform and type.

## Build/Lint/Test Commands

### Setup
```bash
fvm flutter pub get                    # Install dependencies
fvm flutter doctor                     # Check Flutter installation
```

### Build
```bash
fvm flutter build apk                  # Build Android APK
fvm flutter build appbundle            # Build Android App Bundle
fvm flutter build ios                  # Build iOS (macOS only)
fvm flutter build linux                # Build Linux
fvm flutter build macos                # Build macOS (macOS only)
fvm flutter build windows              # Build Windows (Windows only)
fvm flutter build web                  # Build web version
```

### Run
```bash
fvm flutter run                        # Run on connected device/emulator
fvm flutter run -d linux               # Run on specific platform
fvm flutter run -d chrome              # Run on Chrome
fvm flutter run --release              # Run in release mode
```

### Lint/Analysis
```bash
fvm flutter analyze                    # Run static analysis
dart format --set-exit-if-changed . # Check formatting
dart format -o write .             # Format all Dart files
```

### Testing
```bash
fvm flutter test                       # Run all tests
fvm flutter test test/widget_test.dart # Run single test file
fvm flutter test --coverage            # Run with coverage report
fvm flutter test --name "test_name"    # Run specific test by name
```

### Clean
```bash
fvm flutter clean                      # Clean build artifacts
fvm flutter pub get                    # Reinstall dependencies after clean
```

## Code Style Guidelines

### Imports
- Order: Dart SDK → Flutter SDK → External packages → Internal imports
- Use relative imports for internal files in the same lib directory
- Group imports with blank lines between groups

```dart
// Dart SDK imports
import 'dart:async';
import 'dart:io';

// Flutter SDK imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// External package imports
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Internal imports
import 'package:forsaken/models/rom.dart';
import 'package:forsaken/services/rom_service.dart';
```

### Formatting
- Use `dart format` for consistent formatting
- Line length: 80 characters (default)
- Use trailing commas for better formatting in widget trees
- 2-space indentation (default Dart style)

### Naming Conventions
- **Classes/Enums**: PascalCase (`RomLoader`, `PlatformType`)
- **Files**: snake_case (`rom_loader.dart`, `platform_service.dart`)
- **Variables/Functions**: camelCase (`romPath`, `loadPlatforms()`)
- **Constants**: lowerCamelCase with const (`const maxRetries = 3`)
- **Private members**: prefix with underscore (`_privateMethod()`, `_counter`)

### Types
- Always specify return types for functions
- Use explicit types for public APIs
- Use `var` or `final` for obvious local variables
- Prefer `final` over `var` when values don't change
- Use nullable types (`String?`) when values can be null

```dart
// Good
Future<List<Rom>> loadRoms(String platformPath) async { ... }
final String platformName = 'snes';
String? optionalValue;

// Avoid
loadRoms(platformPath) { ... }  // Missing return type
var platformName = 'snes';      // Should be final
```

### Error Handling
- Use try-catch for expected errors (file I/O, network)
- Propagate errors with meaningful context
- Log errors appropriately
- Use Result/Either pattern for operations that may fail
- Show user-friendly error messages in UI

```dart
try {
  final rom = await downloadRom(url);
  return rom;
} on IOException catch (e) {
  DebugService.instance.error('Failed to download ROM: $e', tag: 'RomService');
  rethrow;
} catch (e) {
  DebugService.instance.error('Unexpected error: $e', tag: 'RomService');
  rethrow;
}
```

### Logging
- **ALWAYS** use `DebugService` for ALL logging. NEVER use `print()`, `debugPrint()`, or `dart:developer log()` directly.
- `DebugService` is a singleton accessed via `DebugService.instance`.
- Use the appropriate log level:
  - `.error(msg, tag: 'Tag')` — errors and caught exceptions
  - `.warning(msg, tag: 'Tag')` — warnings
  - `.info(msg, tag: 'Tag')` — status and progress messages
  - `.debug(msg, tag: 'Tag')` — verbose/trace output
- Always provide a meaningful `tag:` parameter (typically the class or service name).
- For JavaScript (`forsaken_bridge.js`), use the `_log()`, `_warn()`, `_error()` helpers gated by `window.FORSAKEN_DEBUG`.

```dart
import '../services/debug_service.dart';

final debug = DebugService.instance;
debug.info('Loading platforms...', tag: 'PlatformsScreen');
debug.error('Failed to load ROM: $e', tag: 'RomService');
```

### Async/Await
- Always use async/await for asynchronous operations
- Prefer async/await over raw Futures
- Use `FutureBuilder` or `StreamBuilder` in widgets
- Handle loading and error states in UI

### Widget Best Practices
- Prefer StatelessWidget when possible
- Extract complex widgets into separate classes
- Use const constructors when possible for performance
- Keep build methods simple and readable
- Pass data down via constructors, not global state

```dart
class RomCard extends StatelessWidget {
  const RomCard({super.key, required this.rom});
  
  final Rom rom;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(rom.name),
        subtitle: Text(rom.platform),
      ),
    );
  }
}
```

### State Management
- Use setState for simple local state
- Consider provider/riverpod for app-wide state
- Keep business logic outside widgets
- Use services/repositories for data operations

### File Organization
```
lib/
  main.dart                          # App entry point and initialization logic only
  models/                            # Data models (Rom, Platform, Media)
  services/                          # Business logic (RomService, EmulatorService)
  screens/                           # Full-screen pages (NEVER in main.dart)
    platforms_screen.dart            # Platform selection screen
    roms_screen.dart                 # ROM listing screen
    initializing_screen.dart         # App loading/splash screen
    error_screen.dart                # Error display screen
    configuration_error_screen.dart  # Configuration error screen
    settings_screen.dart             # Settings screen
    settings_categories/             # Settings subscreens
    roms/                            # ROM screen components
  widgets/                           # Reusable UI components
    common/                          # Shared widgets
    platforms/                       # Platform-specific widgets
  providers/                         # State management (Provider/Riverpod)
  utils/                             # Helper functions
  constants/                         # App constants
```

**IMPORTANT**: 
- **NEVER** define screen classes in `main.dart`
- `main.dart` should ONLY contain:
  - `main()` function
  - App initialization logic
  - Root `EmulatorApp` widget
- ALL screens (StatelessWidget/StatefulWidget for full pages) MUST be in separate files under `screens/`
- When creating new screens, always create a new file in `screens/` directory

## Project-Specific Guidelines

### Configuration
- All user-configurable paths are stored in SharedPreferences via `ConfigService`
- Available settings: `MEDIA_PATH`, `EMULATORS_PATH`, `EMULATORS_CONFIG_PATH`, `ROM_TEMP_PATH`, `ROM_FOREVER_PATH`, `DEBUG_ENABLED`, `DEBUG_MIN_LEVEL`
- Use `ConfigService.instance.setPathSetting(key, value)` to update settings
- Settings are editable from Settings > System Paths screen
- No `.env` file is used; all config is in SharedPreferences

### File Structure Assumptions
```
ROMS_PATH/
  platform1/              # e.g., snes, nes, genesis
    rom1.txt              # Contains download URL
    rom2.txt
  platform2/
    rom3.txt

MEDIA_PATH/
  platform1/
    boxart/               # Box art images
      rom1.png
    screenshots/          # Screenshot images
      rom1.png
    videos/              # Video previews
      rom1.mp4
```

### ROM Processing
- Read .txt files to get download URLs
- Download to temporary directory
- Pass temp file path to emulator process
- Clean up temp files after emulator closes
- Handle download failures gracefully

### Platform Support
- Test on multiple platforms (Android, iOS, Linux, Windows, macOS)
- Use `Platform.isAndroid`, `Platform.isIOS`, etc. for platform-specific code
- Use `kIsWeb` for web-specific code

## Common Pitfalls
- Remember to call `fvm flutter pub get` after updating pubspec.yaml
- Always dispose controllers and streams in StatefulWidget
- Use `mounted` check before setState after async operations
- Test file path handling on different platforms (path separators)
- Handle permissions for file system access on mobile platforms

## UI/UX Standards

### ControlsBottomBar - REQUIRED for All Full Screens

**CRITICAL**: ALL full-screen pages (Platforms, ROMs, Settings, and Settings subpages) MUST include `ControlsBottomBar` at the bottom of the screen.

#### Why It's Required
- **Consistency**: Uniform navigation experience across all screens
- **Accessibility**: Users always know which keys/buttons are available
- **Gamepad Support**: Automatically shows gamepad buttons when connected
- **Discoverability**: New users can see available actions without guessing

#### Implementation Pattern

```dart
// 1. Import the widget
import 'package:forsaken/widgets/common/controls_bottom_bar.dart';

// 2. Wrap body in Column with Expanded + ControlsBottomBar
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Screen Title')),
    body: Column(
      children: [
        // Main content - MUST be wrapped in Expanded
        Expanded(
          child: YourMainContent(),
        ),
        
        // Bottom controls bar - REQUIRED
        ControlsBottomBar(
          actions: const [
            BottomBarAction(
              label: 'Back',
              keyboardKey: 'ESC',
              gamepadButton: 'B',
            ),
            BottomBarAction(
              label: 'Select',
              keyboardKey: 'Enter',
              gamepadButton: 'A',
            ),
            BottomBarAction(
              label: 'Refresh',
              keyboardKey: 'F5',
              gamepadButton: 'Start',
            ),
          ],
          counterText: 'Optional counter text',  // Can be null
        ),
      ],
    ),
  );
}
```

#### Common Actions Reference

```dart
// Navigation
const BottomBarAction(label: 'Back', keyboardKey: 'ESC', gamepadButton: 'B')
const BottomBarAction(label: 'Select', keyboardKey: 'Enter', gamepadButton: 'A')

// View controls
const BottomBarAction(label: 'Refresh', keyboardKey: 'F5', gamepadButton: 'Start')
const BottomBarAction(label: 'Toggle View', keyboardKey: 'V', gamepadButton: 'Y')
const BottomBarAction(label: 'Search', keyboardKey: 'S', gamepadButton: 'X')

// Media
const BottomBarAction(label: 'Media', keyboardKey: 'M', gamepadButton: 'L1')
const BottomBarAction(label: 'Help', keyboardKey: '?', gamepadButton: 'R1')
```

#### Key Features
- **Auto-detect gamepad**: Shows keyboard keys OR gamepad buttons
- **Responsive**: Hides actions on mobile if no gamepad
- **Glassmorphism**: Translucent background with blur effect
- **Optional counter**: For showing "X / Y" item counts

#### Example: Settings Screen

```dart
body: Column(
  children: [
    Expanded(
      child: ListView(
        controller: _scrollController,
        children: [...],
      ),
    ),
    ControlsBottomBar(
      actions: const [
        BottomBarAction(label: 'Back', keyboardKey: 'ESC', gamepadButton: 'B'),
        BottomBarAction(label: 'Select', keyboardKey: 'Enter', gamepadButton: 'A'),
      ],
    ),
  ],
),
```

#### Example: BIOS Help Screen

```dart
body: Column(
  children: [
    Expanded(
      child: ListView.builder(...),
    ),
    ControlsBottomBar(
      actions: const [
        BottomBarAction(label: 'Back', keyboardKey: 'ESC', gamepadButton: 'B'),
        BottomBarAction(label: 'Toggle Filter', keyboardKey: 'Enter', gamepadButton: 'A'),
        BottomBarAction(label: 'Refresh', keyboardKey: 'F5', gamepadButton: 'Start'),
      ],
      counterText: '${_filteredCount} platforms',
    ),
  ],
),
```

#### Conditional Actions

Use `if` expressions for conditional actions:

```dart
ControlsBottomBar(
  actions: [
    const BottomBarAction(label: 'Back', keyboardKey: 'ESC', gamepadButton: 'B'),
    if (canRefresh)
      const BottomBarAction(label: 'Refresh', keyboardKey: 'R', gamepadButton: 'Start'),
    if (hasSelection)
      const BottomBarAction(label: 'Delete', keyboardKey: 'Del', gamepadButton: 'Y'),
  ],
),
```

#### DON'Ts
- ❌ Don't use custom help text at bottom of screen
- ❌ Don't hardcode keyboard shortcuts in UI without ControlsBottomBar
- ❌ Don't forget to wrap main content in `Expanded`
- ❌ Don't use `Flexible` instead of `Expanded` for main content

#### Migration Checklist
When updating an existing screen:
1. Import `controls_bottom_bar.dart`
2. Wrap `body` content in `Column`
3. Wrap main content in `Expanded`
4. Add `ControlsBottomBar` as last child
5. Define appropriate actions for the screen
6. Remove any custom help text widgets
7. Test keyboard and gamepad navigation
