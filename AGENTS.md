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
  debugPrint('Failed to download ROM: $e');
  rethrow;
} catch (e) {
  debugPrint('Unexpected error: $e');
  rethrow;
}
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

### Environment Variables
- Use `flutter_dotenv` or similar for environment configuration
- Store ROM_PATH and MEDIA_PATH in .env file
- Never commit .env files to version control

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
