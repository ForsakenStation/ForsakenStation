# Media Scraper

Downloads missing media (covers, screenshots, videos) from ScreenScraper.fr API and generates/updates EmulationStation gamelist.xml files with game metadata.

## Quick Start

```bash
# 1. Setup credentials
cp .env.example .env
nano .env  # Add your ScreenScraper username/password

# 2. Test with dry-run
./scrape_with_env.sh arduboy --dry-run --limit 5

# 3. Download media and update gamelist
./scrape_with_env.sh arduboy --media-types covers,screenshots

# 4. Only update gamelist (no media download)
./scrape_with_env.sh nes --gamelist-only --limit 50

# 5. Only download media (skip gamelist)
./scrape_with_env.sh snes --skip-gamelist
```

## What It Does

1. **Downloads Media:** Box art, screenshots, videos, and more from ScreenScraper's database
2. **Generates Gamelists:** Creates/updates EmulationStation `gamelist.xml` files with:
   - Game names
   - Descriptions
   - Release dates
   - Developers/Publishers
   - Genres
   - Player count
   - Ratings

Preserves subdirectory structure from JSONL files automatically.

## Requirements

### Account
- Free account at [ScreenScraper.fr](https://www.screenscraper.fr/)
- Add credentials to `.env` file
- Optional: Developer credentials for higher rate limits (requires special access)

### Credentials Setup

Edit `.env` file with your credentials:

```bash
# Required: Your ScreenScraper account
SCREENSCRAPER_USER=your_username
SCREENSCRAPER_PASSWORD=your_password

# Optional: Developer credentials (if you have access)
# SCREENSCRAPER_DEV_ID=your_dev_id
# SCREENSCRAPER_DEV_PASSWORD=your_dev_password
```

**Note:** If you don't have developer credentials, the script will use generic ones. This works fine but may have stricter rate limits.

### Dependencies
- Python 3.8+
- `requests` library (pre-installed on most systems)
- `Pillow` library (pre-installed on most systems)

### Install Dependencies (if needed)
```bash
# Arch Linux
sudo pacman -S python-requests python-pillow python-dotenv

# Or via pip
pip install --user requests Pillow python-dotenv
```

## Usage

```bash
# Using helper script (recommended)
./scrape_with_env.sh <platform> [options]

# Or directly with environment variables
export SCREENSCRAPER_USER="your_username"
export SCREENSCRAPER_PASSWORD="your_password"
python3 scrape_media.py <platform> [options]
```

## Options

- `--media-types` - Comma-separated list (default: covers,screenshots,marquees)
- `--dry-run` - Show what would be downloaded without downloading
- `--limit N` - Process only first N ROMs
- `--skip-existing` - Skip ROMs that already have media (default: true)
- `--no-skip-existing` - Download even if media exists
- `--skip-gamelist` - Skip gamelist.xml generation (only download media)
- `--gamelist-only` - Only update gamelist.xml without downloading media

## Examples

```bash
# Dry-run test (safe)
./scrape_with_env.sh arduboy --dry-run --limit 5

# Download covers only
./scrape_with_env.sh nes --media-types covers

# Download multiple media types
./scrape_with_env.sh snes --media-types covers,screenshots,videos

# Download for ROMs that don't have media yet
./scrape_with_env.sh genesis --skip-existing

# Redownload everything (overwrite)
./scrape_with_env.sh amiga500 --no-skip-existing --limit 10

# Only update gamelist (no media download)
./scrape_with_env.sh gb --gamelist-only --limit 50

# Only download media (skip gamelist)
./scrape_with_env.sh gba --skip-gamelist
```

## Supported Media Types

Available media types (comma-separated):
- `covers` - Box art (front)
- `backcovers` - Box art (back)
- `3dboxes` - 3D box renders
- `screenshots` - In-game screenshots
- `titlescreens` - Title screen images
- `marquees` - Arcade marquees
- `videos` - Video previews
- `fanart` - Fan art / wallpapers
- `miximages` - Mixed images

## Supported Platforms

50+ platforms including:
- `arduboy`, `nes`, `snes`, `genesis`, `n64`
- `gb`, `gbc`, `gba`, `nds`
- `ps1`, `ps2`, `psp`
- `dreamcast`, `saturn`, `gamecube`, `wii`
- And many more...

See `PLATFORM_IDS` in `scrape_media.py` for full list.

## Rate Limiting

**Important:** ScreenScraper enforces rate limits
- **Free accounts:** 1 request per 2 seconds (default)
- **Registered accounts:** Can be 1 request per second
- Script automatically respects limits
- Exceeding limits may result in temporary ban

## Files

- **scrape_media.py** - Main scraper script (526 lines)
- **scrape_with_env.sh** - Helper to run with .env file
- **requirements-scraper.txt** - Python dependencies list
- **.env.example** - Template for credentials
- **MEDIA_SCRAPER.md** - Complete documentation

## Common Issues

### "Missing ScreenScraper credentials"
**Solution:** Create `.env` file and add credentials:
```bash
cp .env.example .env
nano .env
```

### "Rate limit exceeded"
**Solution:** Script automatically waits. Free accounts = 2 sec/request.

### "Import dotenv could not be resolved"
**Solution:** Install python-dotenv or use `scrape_with_env.sh` wrapper.

### "Platform not found"
**Solution:** Check PLATFORM_IDS mapping or use different platform name.

### "No media available for ROM"
**Solution:** ROM not in ScreenScraper database or name doesn't match.

## Output Structure

Media is saved with subdirectory structure preserved:

```
/home/victor/ES-DE/downloaded_media_new/
└── arduboy/
    ├── covers/
    │   ├── Game1.png                 # Root level
    │   └── - Alternates -/
    │       └── Game (Alt).png        # Subfolder
    ├── screenshots/
    └── videos/
```

Gamelists are saved to:

```
~/.local/share/com.example.emulator/gamelists/
└── arduboy/
    └── gamelist.xml                  # ES-DE compatible format
```

**Note:** Gamelists are stored separately from ES-DE to allow independent management and future GitHub publication alongside ROM lists.

## Performance

- Sequential downloads (respects rate limits)
- ~30 ROMs per minute on free account (2 sec/request)
- ~60 ROMs per minute on registered account (1 sec/request)
- Automatic retry on failures
- Progress tracking and statistics

## Status Codes

- ✓ Found and downloaded
- ✗ Not found in database
- ⚠ API error or no media available
- • Skipped (already exists)

## See Also

- [Complete Documentation](./MEDIA_SCRAPER.md)
- [Main Scripts README](../README.md)
- [Media Migration](../media-migration/)
- [ScreenScraper API Docs](https://www.screenscraper.fr/api/)
