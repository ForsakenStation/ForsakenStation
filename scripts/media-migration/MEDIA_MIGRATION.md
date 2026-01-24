# Media Migration Guide

## Overview
This guide explains how to migrate media files from the old EmulationStation-DE format to the new ROM-based structure used by the Forsaken Emulator.

## What This Does
- Reads JSONL ROM lists to determine which ROMs exist
- **Preserves folder structure from JSONL** (e.g., "- Alternates -" subfolder)
- Finds matching media files in old directory structure
- Copies only media for ROMs that exist in JSONL lists
- Preserves original files (non-destructive)
- Handles subdirectories and multiple file formats

## File Structure

### Old Structure (ES-DE)
```
/home/victor/ES-DE/downloaded_media/
├── platform1/
│   ├── covers/
│   │   ├── ROM Name.png
│   │   └── subdirectory/
│   │       └── Another ROM.png
│   ├── screenshots/
│   ├── videos/
│   └── ... (9 media types)
```

### New Structure (Forsaken)
```
/home/victor/ES-DE/downloaded_media_new/
├── platform1/
│   ├── covers/
│   │   ├── ROM Name.png               # Root level ROM
│   │   ├── Another ROM.png
│   │   └── - Alternates -/            # Subfolder preserved from JSONL
│   │       ├── ROM Alt Version.png
│   │       └── ROM Another Alt.png
│   ├── screenshots/
│   └── ... (9 media types)
```

**Important**: Folder structure matches JSONL `parent` field! 
- If ROM has `"parent": ""` → file goes in root
- If ROM has `"parent": "- Alternates -"` → file goes in `covers/- Alternates -/`

### JSONL ROM Lists
```
~/.local/share/com.forsaken.emulator/romlists/AndroidRoms-main/
├── amiga500.jsonl
├── arduboy.jsonl
└── ... (100+ platforms)
```

**JSONL Format Example**:
```json
{"type": "dir", "p": "- Alternates -", "n": "- Alternates -", "parent": ""}
{"type": "file", "p": "- Alternates -/Game (Alt).zip", "n": "Game (Alt)", "parent": "- Alternates -", "ext": ".zip", "urls": [...]}
{"type": "file", "p": "Game.zip", "n": "Game", "parent": "", "ext": ".zip", "urls": [...]}
```

**Key Fields**:
- `type`: "file" or "dir"
- `n`: ROM name (without extension) - **used to match media files**
- `parent`: Parent folder name (empty string = root level)
- `p`: Full path including folder structure

## Scripts

### 1. migrate_media.py (Single Platform)
Migrates media for one platform at a time.

**Usage:**
```bash
# Dry run (preview what would be copied)
./migrate_media.py <platform> --dry-run

# Actual migration
./migrate_media.py <platform>

# List available platforms
./migrate_media.py --list

# Examples
./migrate_media.py arduboy --dry-run    # Test first
./migrate_media.py arduboy               # Actually migrate
./migrate_media.py amiga500
```

**Features:**
- Fast (Python-based, ~2-5 seconds per platform)
- **Preserves folder structure from JSONL parent field**
- Shows progress and statistics
- Dry-run mode for testing
- Handles special characters in filenames
- Recursively searches subdirectories in old media
- Preserves file timestamps

### 2. migrate_all_platforms.sh (Batch Migration)
Migrates all platforms with existing media in one go.

**Usage:**
```bash
./migrate_all_platforms.sh
```

**Features:**
- Auto-detects platforms with media
- Shows confirmation prompt
- Displays progress counter
- Summary statistics at end
- Skips symlinks

## Step-by-Step Migration

### Option A: Single Platform
1. **Test with dry-run:**
   ```bash
   ./migrate_media.py arduboy --dry-run
   ```

2. **Review output** - check ROM count and file counts

3. **Run actual migration:**
   ```bash
   ./migrate_media.py arduboy
   ```

4. **Verify results:**
   ```bash
   ls -lh /home/victor/ES-DE/downloaded_media_new/arduboy/
   find /home/victor/ES-DE/downloaded_media_new/arduboy -type f | wc -l
   ```

5. **Test in app** - verify media displays correctly

6. **Repeat for other platforms**

### Option B: Batch Migration
1. **Review platforms to migrate:**
   ```bash
   ls /home/victor/ES-DE/downloaded_media/
   ```

2. **Run batch script:**
   ```bash
   ./migrate_all_platforms.sh
   ```

3. **Confirm when prompted**

4. **Wait for completion** (may take 5-15 minutes for all platforms)

5. **Review summary statistics**

## Verification

### Check Migration Results
```bash
# Compare file counts
OLD_COUNT=$(find /home/victor/ES-DE/downloaded_media/arduboy -type f | wc -l)
NEW_COUNT=$(find /home/victor/ES-DE/downloaded_media_new/arduboy -type f | wc -l)
echo "Old: $OLD_COUNT files"
echo "New: $NEW_COUNT files"
echo "Difference: $((OLD_COUNT - NEW_COUNT)) files (extras not in JSONL)"
```

### Check Specific Media Type
```bash
# Check root level files
ls /home/victor/ES-DE/downloaded_media_new/arduboy/covers/*.png | head -10

# Check subfolder files
ls "/home/victor/ES-DE/downloaded_media_new/arduboy/covers/- Alternates -/" | head -10

# Count files by location
echo "Root level: $(find /home/victor/ES-DE/downloaded_media_new/arduboy/covers -maxdepth 1 -type f | wc -l)"
echo "Alternates: $(find "/home/victor/ES-DE/downloaded_media_new/arduboy/covers/- Alternates -" -type f 2>/dev/null | wc -l)"
echo "Total: $(find /home/victor/ES-DE/downloaded_media_new/arduboy/covers -type f | wc -l)"
```

### Verify App Integration
1. Update app configuration to use new media path
2. Launch app and browse to platform
3. Check that boxart/covers display correctly
4. Verify video previews work
5. Test media viewer (M key)

## Understanding the Output

### Example Output
```
[INFO] Media migration for: arduboy
[INFO] Found 531 ROMs
[INFO] Media types: covers screenshots videos ...

[INFO] Processing covers...
[INFO]   Found 477 files
[INFO]   covers: 473 files migrated

Summary:
  ROMs processed:    531
  Files migrated:    3192
```

**Key Metrics:**
- **ROMs processed**: Number of ROMs in JSONL
- **Files found**: Total files in old directory (may include extras)
- **Files migrated**: Only files matching JSONL ROMs
- **Difference**: Files in old dir but NOT in JSONL (duplicates, alternates, etc.)

## Troubleshooting

### No Files Migrated
- **Check JSONL exists**: `ls ~/.local/share/com.forsaken.emulator/romlists/AndroidRoms-main/platform.jsonl`
- **Check old media exists**: `ls /home/victor/ES-DE/downloaded_media/platform/`
- **Check ROM names match**: Compare JSONL names to file basenames

### Fewer Files Than Expected
- **Normal behavior** - only migrates files matching JSONL ROM names
- Old directory may have:
  - Alternate versions not in JSONL
  - Duplicates (e.g., `Game.png` and `Game.jpg`)
  - Old/outdated ROMs
  - Test files

### Permission Errors
```bash
# Fix ownership
sudo chown -R $USER:$USER /home/victor/ES-DE/downloaded_media_new/

# Fix permissions
chmod -R u+rw /home/victor/ES-DE/downloaded_media_new/
```

### Disk Space Issues
```bash
# Check available space
df -h /home/victor/ES-DE/

# Estimate size needed
du -sh /home/victor/ES-DE/downloaded_media/
```

## Cleanup After Migration

### After Verifying Everything Works

1. **Test thoroughly** - use app with new media for a few days

2. **Backup old directory** (optional):
   ```bash
   tar -czf ~/media_backup_$(date +%Y%m%d).tar.gz /home/victor/ES-DE/downloaded_media/
   ```

3. **Delete old directory**:
   ```bash
   rm -rf /home/victor/ES-DE/downloaded_media/
   ```

4. **Rename new directory**:
   ```bash
   mv /home/victor/ES-DE/downloaded_media_new /home/victor/ES-DE/downloaded_media
   ```

### Update App Configuration
Update `.env` or app settings to point to new media path if needed.

## Performance

**Single Platform:**
- Small platform (< 1000 files): ~2-5 seconds
- Large platform (3000-5000 files): ~10-15 seconds

**Batch Migration:**
- ~100 platforms: 5-15 minutes total
- Depends on number of files per platform

## Media Types Supported
- **covers**: Box art / cover art
- **screenshots**: In-game screenshots
- **titlescreens**: Title screen images
- **videos**: Video previews
- **fanart**: Fan-created artwork
- **marquees**: Arcade marquees
- **3dboxes**: 3D box renders
- **backcovers**: Back cover art
- **miximages**: Mixed/composite images

## Notes
- **Non-destructive**: Original files are never deleted
- **Folder structure preserved**: Subfolders from JSONL `parent` field are recreated
- **Basename matching**: Matches ROM name without extension
- **First match wins**: If duplicate basenames exist, first found is used
- **Timestamp preserved**: Uses `shutil.copy2()` to preserve modification times

## Example: Arduboy Platform
After migration, arduboy covers directory looks like:
```
covers/
├── Game1.png                          # 354 files at root level
├── Game2.png
├── ...
└── - Alternates -/                    # 119 files in subfolder
    ├── Game1 (Alt).png
    ├── Game2 (v1.0).png
    └── ...
```

This matches the JSONL structure where some ROMs have `"parent": ""` (root) and others have `"parent": "- Alternates -"` (subfolder).
