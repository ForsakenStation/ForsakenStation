#!/usr/bin/env python3
"""
ROM Media Scraper for Forsaken Emulator

Downloads missing media (covers, screenshots, videos, etc.) for ROMs
using ScreenScraper.fr API based on JSONL ROM lists.

Requirements:
  pip install requests Pillow

Setup:
  1. Create an account at https://www.screenscraper.fr/
  2. Copy .env.example to .env
  3. Add your credentials to .env:
     SCREENSCRAPER_USER=your_username
     SCREENSCRAPER_PASSWORD=your_password

  4. (Optional) If you have developer access, add:
     SCREENSCRAPER_DEV_ID=your_dev_id
     SCREENSCRAPER_DEV_PASSWORD=your_dev_password

Usage:
  ./scrape_media.py <platform> [options]

Examples:
  ./scrape_media.py arduboy --media-types covers,screenshots
  ./scrape_media.py nes --dry-run
  ./scrape_media.py snes --limit 10
  ./scrape_media.py amiga500 --skip-existing
"""

import argparse
import json
import os
import sys
import time
import hashlib
from pathlib import Path
from typing import Dict, List, Optional, Set
from urllib.parse import quote
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

# Load environment variables
try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError:
    print("Warning: python-dotenv not installed, using environment variables")

# ANSI colors
COLORS = {
    "RED": "\033[0;31m",
    "GREEN": "\033[0;32m",
    "YELLOW": "\033[1;33m",
    "BLUE": "\033[0;34m",
    "MAGENTA": "\033[0;35m",
    "CYAN": "\033[0;36m",
    "NC": "\033[0m",
}

# Configuration
JSONL_DIR = Path.home() / ".local/share/com.example.emulator/romlists/AndroidRoms-main"
MEDIA_DIR = Path("/home/victor/ES-DE/downloaded_media_new")

# ScreenScraper API
SCREENSCRAPER_API = "https://www.screenscraper.fr/api2"
SCREENSCRAPER_SOFT_NAME = "Forsaken-Emulator"

# Default dev credentials (can be overridden via environment variables)
# These are generic credentials - if you have developer access, set them in .env
DEFAULT_DEV_ID = "xxx"
DEFAULT_DEV_PASSWORD = "yyy"

# Rate limiting: Free accounts = 1 req/2sec, Registered = 1 req/sec
RATE_LIMIT_DELAY = 2.0  # seconds between requests

# Media type mapping: ScreenScraper → Local folder names
MEDIA_TYPES = {
    "box-2D": ["covers", "3dboxes"],
    "box-3D": ["3dboxes"],
    "screenmarquee": ["marquees"],
    "screenshot": ["screenshots"],
    "titlescreen": ["titlescreens"],
    "video": ["videos"],
    "fanart": ["fanart"],
    "box-2D-back": ["backcovers"],
    "mixrbv1": ["miximages"],
}

# Platform mapping: Local name → ScreenScraper ID
# https://www.screenscraper.fr/api/systemesListe.php
PLATFORM_IDS = {
    "amiga500": 64,
    "amiga1200": 64,
    "amiga": 64,
    "amigacd32": 130,
    "arduboy": 263,
    "atari2600": 26,
    "atari5200": 40,
    "atari7800": 41,
    "atarijaguar": 27,
    "atarilynx": 28,
    "atarist": 42,
    "c64": 66,
    "dreamcast": 23,
    "gb": 9,
    "gba": 12,
    "gbc": 10,
    "gamecube": 13,
    "genesis": 1,
    "megadrive": 1,
    "n64": 14,
    "nds": 15,
    "nes": 3,
    "famicom": 3,
    "ngp": 25,
    "ngpc": 82,
    "ps1": 57,
    "psx": 57,
    "ps2": 58,
    "psp": 61,
    "saturn": 22,
    "segacd": 20,
    "sega32x": 19,
    "snes": 4,
    "superfamicom": 4,
    "wii": 16,
    "wiiu": 18,
    "wasm4": 262,
}


def log(level: str, message: str):
    """Print colored log message"""
    color = COLORS.get(level.upper(), COLORS["NC"])
    print(f"{color}[{level.upper()}]{COLORS['NC']} {message}")


class ScreenScraperAPI:
    """ScreenScraper.fr API client"""

    def __init__(
        self,
        username: str,
        password: str,
        dev_id: Optional[str] = None,
        dev_password: Optional[str] = None,
    ):
        self.username = username
        self.password = password
        self.dev_id = dev_id or DEFAULT_DEV_ID
        self.dev_password = dev_password or DEFAULT_DEV_PASSWORD
        self.session = requests.Session()

        # Set up retry strategy
        retry_strategy = Retry(
            total=2,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
        )
        adapter = HTTPAdapter(max_retries=retry_strategy)
        self.session.mount("https://", adapter)
        self.session.mount("http://", adapter)

        self.last_request_time = 0

    def _rate_limit(self):
        """Enforce rate limiting"""
        elapsed = time.time() - self.last_request_time
        if elapsed < RATE_LIMIT_DELAY:
            time.sleep(RATE_LIMIT_DELAY - elapsed)
        self.last_request_time = time.time()

    def _build_auth_params(self) -> Dict[str, str]:
        """Build authentication parameters"""
        return {
            "devid": self.dev_id,
            "devpassword": self.dev_password,
            "softname": SCREENSCRAPER_SOFT_NAME,
            "ssid": self.username,
            "sspassword": self.password,
        }

    def search_game(
        self, rom_name: str, platform_id: int, sha1: Optional[str] = None
    ) -> Optional[Dict]:
        """
        Search for game by ROM name and platform

        Args:
            rom_name: ROM display name
            platform_id: ScreenScraper platform ID
            sha1: Optional SHA1 hash for exact match

        Returns:
            Game data dict or None if not found
        """
        self._rate_limit()

        params = self._build_auth_params()
        params.update(
            {
                "output": "json",
                "systemeid": str(platform_id),
                "romnom": rom_name,
            }
        )

        if sha1:
            params["sha1"] = sha1

        try:
            url = f"{SCREENSCRAPER_API}/jeuInfos.php"
            response = self.session.get(url, params=params, timeout=30)

            if response.status_code == 200:
                data = response.json()

                # Check for API errors
                if "response" in data:
                    resp = data["response"]
                    if resp.get("erreur"):
                        log("warning", f"API error: {resp['erreur']}")
                        return None

                # Extract game data
                if "response" in data and "jeu" in data["response"]:
                    return data["response"]["jeu"]

            elif response.status_code == 429:
                log("warning", "Rate limit exceeded, waiting 5 seconds...")
                time.sleep(5)
                return None
            else:
                log("warning", f"HTTP {response.status_code}: {response.text[:100]}")

        except Exception as e:
            log("error", f"Request failed: {e}")

        return None

    def download_media(self, media_url: str, output_path: Path) -> bool:
        """Download media file"""
        try:
            self._rate_limit()

            response = self.session.get(media_url, timeout=60, stream=True)
            if response.status_code == 200:
                output_path.parent.mkdir(parents=True, exist_ok=True)

                with open(output_path, "wb") as f:
                    for chunk in response.iter_content(chunk_size=8192):
                        f.write(chunk)

                return True
            else:
                log("warning", f"Download failed: HTTP {response.status_code}")

        except Exception as e:
            log("error", f"Download error: {e}")

        return False


def extract_rom_info(jsonl_file: Path) -> List[Dict]:
    """Extract ROM information from JSONL file"""
    roms = []

    with open(jsonl_file, "r", encoding="utf-8") as f:
        for line in f:
            try:
                data = json.loads(line.strip())
                if data.get("type") == "file":
                    rom_name = data.get("n", "")
                    parent = data.get("parent", "")
                    if rom_name:
                        roms.append(
                            {
                                "name": rom_name,
                                "parent": parent,
                            }
                        )
            except json.JSONDecodeError:
                continue

    return roms


def get_existing_media(
    media_dir: Path, rom_name: str, media_type: str
) -> Optional[Path]:
    """Check if media already exists"""
    for ext in [".png", ".jpg", ".jpeg", ".webp", ".mp4"]:
        media_file = media_dir / f"{rom_name}{ext}"
        if media_file.exists():
            return media_file
    return None


def scrape_platform(
    platform: str,
    api: ScreenScraperAPI,
    media_types: List[str],
    skip_existing: bool = True,
    dry_run: bool = False,
    limit: Optional[int] = None,
):
    """Scrape media for a platform"""

    jsonl_file = JSONL_DIR / f"{platform}.jsonl"
    platform_media_dir = MEDIA_DIR / platform

    # Validate
    if not jsonl_file.exists():
        log("error", f"JSONL file not found: {jsonl_file}")
        return False

    platform_id = PLATFORM_IDS.get(platform)
    if not platform_id:
        log(
            "error", f"Platform '{platform}' not supported. Check PLATFORM_IDS mapping."
        )
        return False

    log("info", f"Scraping media for: {platform} (ScreenScraper ID: {platform_id})")
    if dry_run:
        log("warning", "DRY RUN - No files will be downloaded")
    print()

    # Extract ROM info
    log("info", "Loading ROM list...")
    roms = extract_rom_info(jsonl_file)
    log("info", f"Found {len(roms)} ROMs")
    print()

    if limit:
        roms = roms[:limit]
        log("info", f"Limiting to first {limit} ROMs")

    # Statistics
    stats = {
        "total": len(roms),
        "found": 0,
        "not_found": 0,
        "downloaded": 0,
        "skipped": 0,
        "errors": 0,
    }

    # Process each ROM
    for i, rom in enumerate(roms, 1):
        rom_name = rom["name"]
        parent = rom["parent"]

        print(f"[{i}/{stats['total']}] {rom_name}")

        # Check existing media
        has_all_media = True
        for media_type in media_types:
            # Build path with subdirectory
            if parent:
                media_dir = platform_media_dir / media_type / parent
            else:
                media_dir = platform_media_dir / media_type

            existing = get_existing_media(media_dir, rom_name, media_type)
            if not existing:
                has_all_media = False
                break

        if skip_existing and has_all_media:
            print(f"  ✓ All media exists, skipping")
            stats["skipped"] += 1
            continue

        # Search game
        print(f"  🔍 Searching...")
        game_data = api.search_game(rom_name, platform_id)

        if not game_data:
            print(f"  ✗ Not found")
            stats["not_found"] += 1
            continue

        stats["found"] += 1
        game_name = game_data.get("noms", [{}])[0].get("text", rom_name)
        print(f"  ✓ Found: {game_name}")

        # Download media
        medias = game_data.get("medias", [])
        if not medias:
            print(f"  ⚠ No media available")
            continue

        for media_type in media_types:
            # Find matching media in response
            media_found = False
            for ss_type, local_types in MEDIA_TYPES.items():
                if media_type in local_types:
                    for media in medias:
                        if media.get("type") == ss_type:
                            media_url = media.get("url")
                            if media_url:
                                # Build output path with subdirectory
                                if parent:
                                    output_dir = (
                                        platform_media_dir / media_type / parent
                                    )
                                else:
                                    output_dir = platform_media_dir / media_type

                                # Determine extension from URL
                                ext = Path(media_url).suffix or ".png"
                                output_path = output_dir / f"{rom_name}{ext}"

                                # Skip if exists
                                if skip_existing and output_path.exists():
                                    print(f"    • {media_type}: exists")
                                    media_found = True
                                    break

                                if not dry_run:
                                    print(f"    ⬇ {media_type}...", end="", flush=True)
                                    if api.download_media(media_url, output_path):
                                        print(" ✓")
                                        stats["downloaded"] += 1
                                        media_found = True
                                    else:
                                        print(" ✗")
                                        stats["errors"] += 1
                                else:
                                    print(f"    • {media_type}: would download")
                                    media_found = True

                                break
                    if media_found:
                        break

            if not media_found and not skip_existing:
                print(f"    ✗ {media_type}: not available")

        print()

    # Summary
    print("━" * 50)
    print(f"{'Summary for:':<20} {platform}")
    print("━" * 50)
    print(f"{'Total ROMs:':<20} {stats['total']}")
    print(f"{'Found:':<20} {stats['found']}")
    print(f"{'Not found:':<20} {stats['not_found']}")
    print(f"{'Downloaded:':<20} {stats['downloaded']}")
    print(f"{'Skipped:':<20} {stats['skipped']}")
    print(f"{'Errors:':<20} {stats['errors']}")
    print("━" * 50)

    return True


def main():
    parser = argparse.ArgumentParser(
        description="Scrape ROM media using ScreenScraper.fr API",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s arduboy
  %(prog)s nes --media-types covers,screenshots
  %(prog)s snes --dry-run
  %(prog)s amiga500 --limit 10 --no-skip-existing
        """,
    )

    parser.add_argument("platform", help="Platform to scrape")
    parser.add_argument(
        "--media-types",
        default="covers,screenshots,marquees,fanart",
        help="Media types to download (comma-separated)",
    )
    parser.add_argument(
        "--skip-existing",
        dest="skip_existing",
        action="store_true",
        default=True,
        help="Skip ROMs that already have media (default)",
    )
    parser.add_argument(
        "--no-skip-existing",
        dest="skip_existing",
        action="store_false",
        help="Download media even if it exists",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be downloaded without actually downloading",
    )
    parser.add_argument("--limit", type=int, help="Limit number of ROMs to process")

    args = parser.parse_args()

    # Get credentials from the environment
    username = os.getenv("SCREENSCRAPER_USER")
    password = os.getenv("SCREENSCRAPER_PASSWORD")
    dev_id = os.getenv("SCREENSCRAPER_DEV_ID")  # Optional
    dev_password = os.getenv("SCREENSCRAPER_DEV_PASSWORD")  # Optional

    if not username or not password:
        log("error", "Missing ScreenScraper credentials!")
        print()
        print("Please set environment variables:")
        print("  export SCREENSCRAPER_USER=your_username")
        print("  export SCREENSCRAPER_PASSWORD=your_password")
        print()
        print("Or create a .env file with:")
        print("  SCREENSCRAPER_USER=your_username")
        print("  SCREENSCRAPER_PASSWORD=your_password")
        print()
        print("Optionally, if you have developer access:")
        print("  SCREENSCRAPER_DEV_ID=your_dev_id")
        print("  SCREENSCRAPER_DEV_PASSWORD=your_dev_password")
        print()
        print("Create account at: https://www.screenscraper.fr/")
        return 1

    # Parse media types
    media_types = [t.strip() for t in args.media_types.split(",")]

    # Create API client
    api = ScreenScraperAPI(username, password, dev_id, dev_password)

    # Scrape
    success = scrape_platform(
        args.platform,
        api,
        media_types,
        skip_existing=args.skip_existing,
        dry_run=args.dry_run,
        limit=args.limit,
    )

    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())
