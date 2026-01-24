# Media Migration Script

Reorganizes media files from ES-DE structure to match JSONL ROM folder structure.

## Quick Start

```bash
# Test first with dry-run
./migrate_media.py arduboy --dry-run

# Actually migrate
./migrate_media.py arduboy

# Migrate all platforms
./migrate_all_platforms.sh
```

## What It Does

Reads JSONL ROM lists and reorganizes media to match the folder structure:

**Before (ES-DE structure):**
```
media/
  arduboy/
    covers/
      Game.png
      Game (Alt).png
```

**After (JSONL structure):**
```
media/
  arduboy/
    covers/
      Game.png                    # Root level
      - Alternates -/
        Game (Alt).png            # In subfolder
```

## Usage

```bash
./migrate_media.py <platform> [options]

Options:
  --dry-run              Show what would be done without moving files
  --media-path PATH      Custom media directory
  --jsonl-path PATH      Custom JSONL directory
```

## Examples

```bash
# Single platform with dry-run
./migrate_media.py arduboy --dry-run

# Single platform (actual migration)
./migrate_media.py nes

# All platforms at once
./migrate_all_platforms.sh

# Custom paths
./migrate_media.py snes --media-path /path/to/media --jsonl-path /path/to/jsonl
```

## Requirements

- Python 3.8+
- No external dependencies (uses standard library only)

## Files

- **migrate_media.py** - Main migration script (Python, recommended)
- **migrate_all_platforms.sh** - Batch process all platforms
- **migrate_media.sh** - Alternative bash version (slower, legacy)
- **MEDIA_MIGRATION.md** - Complete documentation with examples

## Testing Results

✅ **Tested on arduboy:** 3192 files migrated successfully
- 354 files in root
- 119 files in "- Alternates -" subfolder
- No files lost or corrupted

## Common Issues

**Issue:** "JSONL file not found"
- Check that JSONL files exist in `~/.local/share/com.forsaken.emulator/romlists/`

**Issue:** "No ROMs with parent folders found"
- This platform has no subdirectories, nothing to migrate

**Issue:** "File already exists at destination"
- Script preserves existing files, shows warning but continues

## See Also

- [Complete Documentation](./MEDIA_MIGRATION.md)
- [Main Scripts README](../README.md)
- [Media Scraper](../media-scraper/)
