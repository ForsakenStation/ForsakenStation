# Emulator Scripts

Collection of utility scripts for managing the Forsaken Emulator project.

## Available Scripts

### 🏗️ [build](./build/)
Build and packaging scripts for creating distributable releases.

**Use case:** Create portable bundles and AppImages for Linux distribution.

**Key features:**
- Portable Linux bundle with dependencies
- AppImage single-file distribution
- Automatic library bundling
- Desktop integration

**Quick start:**
```bash
# Using Makefile (recommended)
make portable   # Create portable bundle
make appimage   # Create AppImage

# Or directly
cd scripts/build
./build_linux_portable.sh
```

See [build/README.md](./build/README.md) for full documentation.

---

### 📦 [media-migration](./media-migration/)
Reorganizes media files from ES-DE structure to match JSONL ROM folder structure.

**Use case:** After downloading media from ES-DE or other sources, migrate it to match the subdirectory structure defined in JSONL files.

**Key features:**
- Preserves subdirectory structure from JSONL `parent` field
- Fast Python implementation
- Batch processing for all platforms
- Dry-run mode for testing

**Quick start:**
```bash
cd scripts/media-migration
./migrate_media.py --help
```

See [media-migration/MEDIA_MIGRATION.md](./media-migration/MEDIA_MIGRATION.md) for full documentation.

---

### 🌐 [media-scraper](./media-scraper/)
Downloads missing media (covers, screenshots, videos) from ScreenScraper.fr API.

**Use case:** Download missing media assets for your ROM collection using ScreenScraper's database.

**Key features:**
- Downloads covers, screenshots, videos, marquees, etc.
- Preserves subdirectory structure
- Rate limiting and retry logic
- Skip existing files
- Dry-run mode for testing

**Quick start:**
```bash
cd scripts/media-scraper

# Setup credentials
cp .env.example .env
nano .env  # Add your ScreenScraper credentials

# Test
./scrape_with_env.sh arduboy --dry-run --limit 5
```

See [media-scraper/MEDIA_SCRAPER.md](./media-scraper/MEDIA_SCRAPER.md) for full documentation.

---

## Typical Workflow

### Development Workflow

1. **Build the app:**
   ```bash
   make build           # Regular release build
   make portable        # Portable bundle
   make appimage        # AppImage package
   ```

2. **Test the app:**
   ```bash
   make run             # Run in debug mode
   make test            # Run tests
   make analyze         # Check code quality
   ```

### Media Management Workflow

1. **Download or receive media from external source** (ES-DE, internet, etc.)

2. **Migrate media to match JSONL structure:**
   ```bash
   cd scripts/media-migration
   ./migrate_media.py arduboy --dry-run  # Test first
   ./migrate_media.py arduboy              # Actually migrate
   ```

3. **Download missing media from ScreenScraper:**
   ```bash
   cd scripts/media-scraper
   ./scrape_with_env.sh arduboy --media-types covers,screenshots
   ```

4. **Verify in app:**
   ```bash
   make run
   # Or run the built executable
   ./build/linux/x64/release/bundle/emulator
   ```

---

## Directory Structure

```
scripts/
├── README.md                      # This file
├── build/                         # Build & packaging scripts
│   ├── README.md                 #   Quick guide
│   ├── build_linux_portable.sh   #   Portable bundle builder
│   └── build_appimage.sh         #   AppImage builder
├── media-migration/               # Media reorganization
│   ├── README.md                 #   Quick guide
│   ├── MEDIA_MIGRATION.md        #   Full documentation
│   ├── migrate_media.py          #   Main migration script
│   ├── migrate_all_platforms.sh  #   Batch migration
│   └── migrate_media.sh          #   Alternative bash version
└── media-scraper/                 # Media downloader
    ├── README.md                 #   Quick guide
    ├── MEDIA_SCRAPER.md          #   Full documentation
    ├── scrape_media.py           #   Main scraper script
    ├── scrape_with_env.sh        #   Helper to run with .env
    ├── requirements-scraper.txt  #   Python dependencies
    └── .env.example              #   Credentials template
```

---

## Requirements

### For build scripts:
- Flutter SDK (managed via fvm)
- Linux build tools
- libmpv-dev (for video playback)
- appimagetool (auto-downloaded for AppImage builds)

### For media-migration:
- Python 3.8+
- Standard library only (no extra packages needed)

### For media-scraper:
- Python 3.8+
- `requests` library (usually pre-installed)
- `Pillow` library (usually pre-installed)
- ScreenScraper.fr account (free registration)

---

## Common Issues

### "Permission denied" when running scripts
```bash
chmod +x scripts/media-migration/*.sh scripts/media-migration/*.py
chmod +x scripts/media-scraper/*.sh scripts/media-scraper/*.py
```

### "Module not found" errors
Most dependencies are pre-installed on Linux systems. If needed:
```bash
# System-wide (Arch Linux)
sudo pacman -S python-requests python-pillow

# Or user-local
pip install --user requests Pillow
```

### Scripts can't find files
Make sure you run scripts from their respective directories:
```bash
cd scripts/media-migration  # Not from project root
./migrate_media.py arduboy
```

---

## Contributing

When adding new scripts:

1. Create a new directory under `scripts/`
2. Add a README.md or documentation file
3. Include example usage
4. Update this main README.md
5. Make scripts executable: `chmod +x script.py`

---

## Support

For issues or questions:
- Check individual script documentation in their folders
- Review TESTING_NEEDED.md in project root
- Check Flutter app logs for media loading issues
