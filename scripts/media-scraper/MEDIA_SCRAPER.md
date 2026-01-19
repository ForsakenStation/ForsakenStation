# Media Scraper Guide

## Overview
Python script to automatically download missing media (covers, screenshots, videos, etc.) for your ROMs using ScreenScraper.fr API.

## Features
- ✅ Uses JSONL ROM lists as source
- ✅ Preserves folder structure (subdirectories)
- ✅ Skips existing media (configurable)
- ✅ Rate limiting to respect API limits
- ✅ Dry-run mode for testing
- ✅ Retry logic for failed requests
- ✅ Progress tracking and statistics
- ✅ Multiple media types support

## Setup

### 1. Install Dependencies
```bash
pip install -r requirements-scraper.txt
```

### 2. Create ScreenScraper Account
1. Go to https://www.screenscraper.fr/
2. Click "Register" / "S'inscrire"
3. Fill in registration form
4. Verify email
5. Note your username and password

### 3. Configure Credentials
```bash
# Copy example config
cp .env.example .env

# Edit .env and add your credentials
nano .env
```

**.env file:**
```
SCREENSCRAPER_USER=your_username
SCREENSCRAPER_PASSWORD=your_password
```

## Usage

### Basic Usage
```bash
# Download covers, screenshots, and marquees for a platform
./scrape_media.py arduboy

# Specific media types
./scrape_media.py nes --media-types covers,screenshots

# Test without downloading
./scrape_media.py snes --dry-run

# Process only first 10 ROMs
./scrape_media.py amiga500 --limit 10

# Re-download even if media exists
./scrape_media.py genesis --no-skip-existing
```

### Available Media Types
- `covers` - Box art / cover art
- `3dboxes` - 3D box renders
- `screenshots` - In-game screenshots
- `titlescreens` - Title screen images
- `marquees` - Arcade marquees
- `videos` - Video previews
- `fanart` - Fan artwork
- `backcovers` - Back cover art
- `miximages` - Mixed composite images

### Command Line Options
```
./scrape_media.py <platform> [options]

Options:
  --media-types TYPES     Comma-separated list of media types to download
                          Default: covers,screenshots,marquees
                          
  --skip-existing         Skip ROMs that already have media (default)
  --no-skip-existing      Download media even if it exists
  
  --dry-run               Show what would be downloaded without downloading
  
  --limit N               Process only first N ROMs (for testing)
```

## Examples

### Example 1: Download All Media for Small Platform
```bash
./scrape_media.py arduboy --media-types covers,screenshots,marquees,videos
```

**Output:**
```
[INFO] Scraping media for: arduboy (ScreenScraper ID: 263)
[INFO] Loading ROM list...
[INFO] Found 531 ROMs

[1/531] 1010 (World) (v0.96) (Erwin's Collection)
  ✓ All media exists, skipping

[2/531] 1943 (World) (Erwin's Collection)
  🔍 Searching...
  ✓ Found: 1943: The Battle of Midway
    ⬇ covers... ✓
    ⬇ screenshots... ✓
    ✗ videos: not available

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Summary for:         arduboy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total ROMs:          531
Found:               425
Not found:           106
Downloaded:          850
Skipped:             0
Errors:              5
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Test Before Downloading
```bash
./scrape_media.py nes --dry-run --limit 5
```

### Example 3: Fill In Missing Covers Only
```bash
./scrape_media.py snes --media-types covers
```

### Example 4: Re-download Everything (Force)
```bash
./scrape_media.py genesis --no-skip-existing --media-types covers
```

## Platform Support

The scraper supports 50+ platforms. Most common ones:

| Platform Name | ScreenScraper ID | Notes |
|---------------|------------------|-------|
| `amiga500` | 64 | Amiga |
| `arduboy` | 263 | Arduboy |
| `atari2600` | 26 | Atari 2600 |
| `c64` | 66 | Commodore 64 |
| `dreamcast` | 23 | Sega Dreamcast |
| `gb` | 9 | Game Boy |
| `gba` | 12 | Game Boy Advance |
| `gbc` | 10 | Game Boy Color |
| `genesis` | 1 | Sega Genesis/Mega Drive |
| `n64` | 14 | Nintendo 64 |
| `nds` | 15 | Nintendo DS |
| `nes` | 3 | Nintendo Entertainment System |
| `ngp` | 25 | Neo Geo Pocket |
| `ps1` | 57 | PlayStation 1 |
| `ps2` | 58 | PlayStation 2 |
| `psp` | 61 | PlayStation Portable |
| `saturn` | 22 | Sega Saturn |
| `snes` | 4 | Super Nintendo |
| `wii` | 16 | Nintendo Wii |

**Full list**: Check `PLATFORM_IDS` in `scrape_media.py`

### Adding New Platforms
If your platform isn't listed:

1. Find ScreenScraper ID: https://www.screenscraper.fr/api/systemesListe.php
2. Add to `PLATFORM_IDS` in `scrape_media.py`:
```python
PLATFORM_IDS = {
    ...
    'your_platform': 123,  # ScreenScraper ID
}
```

## Rate Limits

ScreenScraper.fr has rate limits:
- **Free account**: 1 request per 2 seconds
- **Registered (€5/year)**: 1 request per second
- **Premium (€15/year)**: Higher limits

The script automatically enforces rate limiting. For large collections, consider upgrading your account.

## Folder Structure

Media is downloaded preserving the folder structure from JSONL:

```
downloaded_media_new/
├── arduboy/
│   ├── covers/
│   │   ├── Game1.png                    # Root level ROM
│   │   ├── Game2.png
│   │   └── - Alternates -/              # Subfolder from JSONL
│   │       ├── Game1 (Alt).png
│   │       └── Game2 (v1.0).png
│   ├── screenshots/
│   │   ├── Game1.png
│   │   └── - Alternates -/
│   │       └── Game1 (Alt).png
│   └── videos/
```

## Troubleshooting

### "Missing ScreenScraper credentials!"
Create `.env` file with your credentials (see Setup section).

### "Platform 'xyz' not supported"
Add the platform to `PLATFORM_IDS` mapping (see Platform Support section).

### "Rate limit exceeded"
- Script will automatically wait
- Consider upgrading ScreenScraper account for faster downloads
- Use `--limit` to process smaller batches

### "Not found" for many ROMs
- ScreenScraper may not have media for all ROMs
- ROM name might not match database
- Try different regions (USA vs Europe vs Japan)

### Downloads are slow
- Free accounts have 2-second rate limit (normal)
- Upgrade to registered account for 1-second limit
- Use `--limit` to test with smaller batches first

### "HTTP 429: Too Many Requests"
- You're being rate limited
- Script will automatically retry after delay
- Don't run multiple instances simultaneously

## Advanced Usage

### Batch Process Multiple Platforms
```bash
#!/bin/bash
# scrape_all.sh

PLATFORMS="arduboy nes snes genesis gb gba"

for platform in $PLATFORMS; do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Processing: $platform"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ./scrape_media.py "$platform" --media-types covers,screenshots
    echo ""
done
```

### Only Download Missing Media
```bash
# Skip ROMs that already have all requested media types
./scrape_media.py nes --media-types covers,screenshots --skip-existing
```

### Download Everything (Fill Gaps)
```bash
# Download all media types for ROMs missing any media
./scrape_media.py snes --media-types covers,screenshots,marquees,videos,titlescreens
```

## API Response Caching

For development, you can add caching to avoid hitting API repeatedly:

```python
# Add to scrape_media.py
import pickle
from pathlib import Path

CACHE_DIR = Path('.cache')
CACHE_DIR.mkdir(exist_ok=True)

def get_cached_game_data(rom_name, platform_id):
    cache_file = CACHE_DIR / f"{platform_id}_{rom_name}.pkl"
    if cache_file.exists():
        with open(cache_file, 'rb') as f:
            return pickle.load(f)
    return None

def cache_game_data(rom_name, platform_id, data):
    cache_file = CACHE_DIR / f"{platform_id}_{rom_name}.pkl"
    with open(cache_file, 'wb') as f:
        pickle.dump(data, f)
```

## Best Practices

1. **Start small**: Test with `--dry-run` and `--limit 10` first
2. **Be patient**: Rate limits mean large collections take time
3. **Check results**: Verify downloaded media looks correct
4. **Backup**: Keep your old media until verified
5. **Respect API**: Don't try to bypass rate limits
6. **Upgrade account**: For large collections, paid account saves time

## Tips

- **ScreenScraper matches by ROM name**, so clean ROM names work best
- **Some platforms have better coverage** than others
- **Videos are large** and take longer to download
- **Check ScreenScraper status**: https://www.screenscraper.fr/ (site goes down sometimes)
- **Use --limit during testing** to avoid wasting API quota

## Credits

- **ScreenScraper.fr**: Media database and API
- **Forsaken Emulator**: ROM management system
- Built with Python, requests, and love ❤️
