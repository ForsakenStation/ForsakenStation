#!/usr/bin/env python3
"""
ROM Media Scraper for Forsaken Emulator

Downloads missing media (covers, screenshots, videos, etc.) for ROMs
using ScreenScraper.fr API based on JSONL ROM lists.

Also generates/updates EmulationStation gamelist.xml files with metadata
from the API (name, description, release date, genre, developer, etc.).

Requirements:
  pip install requests Pillow python-dotenv

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
  # Download media and update gamelist
  ./scrape_media.py arduboy --media-types covers,screenshots

  # Only update gamelist without downloading media
  ./scrape_media.py nes --gamelist-only --limit 50

  # Only download media without updating gamelist
  ./scrape_media.py snes --skip-gamelist

  # Dry run to see what would happen
  ./scrape_media.py amiga500 --dry-run --limit 10
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
from datetime import datetime
import xml.etree.ElementTree as ET
from xml.dom import minidom
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
JSONL_DIR = Path.home() / ".local/share/com.example.emulator/romlists/romList-main"
MEDIA_DIR = Path("/home/victor/ES-DE/downloaded_media_new")
GAMELIST_DIR = Path.home() / ".local/share/com.example.emulator/gamelists"

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
    "wonderswan": 45,
    "wonderswancolor": 46,
    "x68000": 79,
    "zmachine": 215,
    "uzebox": 216,
    "virtualboy": 11,
    "3do": 29,
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
        """
        Download media file

        Args:
            media_url: URL to download from
            output_path: Path to save to (extension will be corrected based on Content-Type)

        Returns:
            True if successful, False otherwise
        """
        try:
            self._rate_limit()

            response = self.session.get(media_url, timeout=60, stream=True)
            if response.status_code == 200:
                # Detect correct extension from Content-Type header
                content_type = response.headers.get("Content-Type", "").lower()

                if "image/png" in content_type:
                    ext = ".png"
                elif "image/jpeg" in content_type or "image/jpg" in content_type:
                    ext = ".jpg"
                elif "image/webp" in content_type:
                    ext = ".webp"
                elif "video/mp4" in content_type:
                    ext = ".mp4"
                else:
                    # Fallback: try to get extension from URL, or default to .png
                    ext = Path(media_url).suffix
                    if not ext or ext.startswith(".php"):
                        ext = ".png"  # Default for images

                # Update output path with correct extension
                output_path = output_path.with_suffix(ext)
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


def escape_xml(text: str) -> str:
    """Escape special XML characters"""
    if not text:
        return ""
    return (
        text.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
        .replace("'", "&apos;")
    )


def format_date(date_str: str) -> str:
    """Convert date string to ES-DE format (YYYYMMDDTHHMMSS)"""
    if not date_str:
        return ""

    # Try different date formats
    formats = ["%Y-%m-%d", "%Y%m%d", "%Y"]

    for fmt in formats:
        try:
            dt = datetime.strptime(date_str, fmt)
            return dt.strftime("%Y%m%dT000000")
        except ValueError:
            continue

    return ""


def extract_game_metadata(game_data: Dict, rom_name: str) -> Dict[str, str]:
    """Extract metadata from ScreenScraper game data"""
    metadata = {}

    # Name
    if "noms" in game_data and game_data["noms"]:
        metadata["name"] = game_data["noms"][0].get("text", rom_name)
    else:
        metadata["name"] = rom_name

    # Description
    if "synopsis" in game_data and game_data["synopsis"]:
        for synopsis in game_data["synopsis"]:
            if synopsis.get("langue") == "en":
                metadata["desc"] = synopsis.get("text", "")
                break
        if "desc" not in metadata and game_data["synopsis"]:
            metadata["desc"] = game_data["synopsis"][0].get("text", "")

    # Release date
    if "dates" in game_data and game_data["dates"]:
        for date in game_data["dates"]:
            if date.get("region") == "wor":  # World release
                metadata["releasedate"] = format_date(date.get("text", ""))
                break
        if "releasedate" not in metadata and game_data["dates"]:
            metadata["releasedate"] = format_date(game_data["dates"][0].get("text", ""))

    # Developer
    if "developpeur" in game_data:
        metadata["developer"] = game_data["developpeur"].get("text", "")

    # Publisher
    if "editeur" in game_data:
        metadata["publisher"] = game_data["editeur"].get("text", "")

    # Genre
    if "genres" in game_data and game_data["genres"]:
        genres = []
        for genre in game_data["genres"]:
            if "noms" in genre and genre["noms"]:
                for nom in genre["noms"]:
                    if nom.get("langue") == "en":
                        genres.append(nom.get("text", ""))
                        break
        if genres:
            metadata["genre"] = " / ".join(genres)

    # Players
    if "joueurs" in game_data:
        metadata["players"] = game_data["joueurs"].get("text", "1")

    # Rating (convert 0-20 scale to 0-1 scale)
    if "note" in game_data:
        try:
            note = float(game_data["note"].get("text", "0"))
            metadata["rating"] = str(note / 20.0)
        except (ValueError, AttributeError):
            pass

    return metadata


def load_gamelist(gamelist_path: Path) -> ET.Element:
    """Load existing gamelist.xml or create new one"""
    if gamelist_path.exists():
        try:
            tree = ET.parse(gamelist_path)
            return tree.getroot()
        except ET.ParseError:
            log("warning", f"Could not parse existing gamelist.xml, creating new one")

    # Create new gamelist
    root = ET.Element("gameList")
    return root


def update_gamelist(
    gamelist_root: ET.Element, rom_name: str, metadata: Dict[str, str], parent: str = ""
) -> bool:
    """Update or add game entry in gamelist"""
    # Build path (with parent directory if exists)
    if parent:
        rom_path = f"./{parent}/{rom_name}.zip"
    else:
        rom_path = f"./{rom_name}.zip"

    # Check if game already exists
    game_elem = None
    for game in gamelist_root.findall("game"):
        path_elem = game.find("path")
        if path_elem is not None and path_elem.text == rom_path:
            game_elem = game
            break

    # Create new game element if not exists
    if game_elem is None:
        game_elem = ET.SubElement(gamelist_root, "game")
        path_elem = ET.SubElement(game_elem, "path")
        path_elem.text = rom_path

    # Update metadata fields
    fields = [
        "name",
        "desc",
        "releasedate",
        "developer",
        "publisher",
        "genre",
        "players",
        "rating",
    ]

    for field in fields:
        if field in metadata and metadata[field]:
            # Find or create element
            elem = game_elem.find(field)
            if elem is None:
                elem = ET.SubElement(game_elem, field)
            elem.text = escape_xml(metadata[field])

    return True


def save_gamelist(gamelist_root: ET.Element, gamelist_path: Path) -> bool:
    """Save gamelist.xml with proper formatting"""
    try:
        # Convert to string with minidom for pretty printing
        xml_str = ET.tostring(gamelist_root, encoding="unicode")
        dom = minidom.parseString(xml_str)
        pretty_xml = dom.toprettyxml(indent="\t", encoding="utf-8")

        # Remove extra blank lines
        lines = [
            line for line in pretty_xml.decode("utf-8").split("\n") if line.strip()
        ]
        pretty_xml = "\n".join(lines) + "\n"

        # Ensure directory exists
        gamelist_path.parent.mkdir(parents=True, exist_ok=True)

        # Write file
        with open(gamelist_path, "w", encoding="utf-8") as f:
            f.write(pretty_xml)

        return True
    except Exception as e:
        log("error", f"Failed to save gamelist.xml: {e}")
        return False


def game_exists_in_gamelist(
    gamelist_root: ET.Element, rom_name: str, parent: str = ""
) -> bool:
    """Check if game already exists in gamelist with metadata"""
    # Build path (with parent directory if exists)
    if parent:
        rom_path = f"./{parent}/{rom_name}.zip"
    else:
        rom_path = f"./{rom_name}.zip"

    # Check if game exists and has at least name and description
    for game in gamelist_root.findall("game"):
        path_elem = game.find("path")
        if path_elem is not None and path_elem.text == rom_path:
            # Check if it has meaningful metadata (at least name and desc)
            name_elem = game.find("name")
            desc_elem = game.find("desc")
            if (
                name_elem is not None
                and name_elem.text
                and desc_elem is not None
                and desc_elem.text
            ):
                return True
    return False


def scrape_platform(
    platform: str,
    api: ScreenScraperAPI,
    media_types: List[str],
    skip_existing: bool = True,
    dry_run: bool = False,
    limit: Optional[int] = None,
    skip_gamelist: bool = False,
    gamelist_only: bool = False,
):
    """Scrape media for a platform"""

    jsonl_file = JSONL_DIR / f"{platform}.jsonl"
    platform_media_dir = MEDIA_DIR / platform
    gamelist_path = GAMELIST_DIR / platform / "gamelist.xml"

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
    if gamelist_only:
        log("info", "GAMELIST ONLY - Only updating gamelist.xml")
    if skip_gamelist:
        log("info", "Skipping gamelist.xml generation")
    print()

    # Load or create gamelist
    gamelist_root = None
    if not skip_gamelist:
        gamelist_root = load_gamelist(gamelist_path)
        log("info", f"Gamelist: {gamelist_path}")
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
        "skipped_all_exist": 0,  # ROMs with all media already present
        "api_calls_saved": 0,  # API calls saved by checking media first
        "gamelist_updated": 0,  # Games added/updated in gamelist
        "errors": 0,
    }

    # Process each ROM
    for i, rom in enumerate(roms, 1):
        rom_name = rom["name"]
        parent = rom["parent"]

        print(f"[{i}/{stats['total']}] {rom_name}")

        # Check if gamelist entry already exists with full metadata
        gamelist_exists = False
        if not skip_gamelist and gamelist_root is not None:
            gamelist_exists = game_exists_in_gamelist(gamelist_root, rom_name, parent)
            if gamelist_exists:
                print(f"  ✓ Gamelist entry exists")

        # Check which media types are missing
        missing_media_types = []
        existing_media_types = []

        if not gamelist_only:
            for media_type in media_types:
                # Build path with subdirectory
                if parent:
                    media_dir = platform_media_dir / media_type / parent
                else:
                    media_dir = platform_media_dir / media_type

                existing = get_existing_media(media_dir, rom_name, media_type)
                if existing:
                    existing_media_types.append(media_type)
                else:
                    missing_media_types.append(media_type)

            # Check if we can skip entirely (all media + gamelist exists)
            if skip_existing and not missing_media_types:
                if gamelist_exists or skip_gamelist:
                    print(f"  ✓ All media and gamelist exists, skipping")
                    stats["skipped"] += 1
                    stats["skipped_all_exist"] += 1
                    stats["api_calls_saved"] += 1
                    continue
                # If media exists but gamelist doesn't, continue to update gamelist
                print(f"  ✓ All media exists")

            # Show what media already exists
            if existing_media_types:
                existing_str = ", ".join(existing_media_types)
                print(f"  • Already have: {existing_str}")

            # Show what we're looking for
            if missing_media_types:
                missing_str = ", ".join(missing_media_types)
                print(f"  • Looking for: {missing_str}")

            # Check if we can skip API call (all media exists and no gamelist needed)
            if not missing_media_types and (gamelist_exists or skip_gamelist):
                print(f"  ✓ All requested media and gamelist exists")
                stats["skipped"] += 1
                stats["skipped_all_exist"] += 1
                stats["api_calls_saved"] += 1
                continue

        # If gamelist_only mode and entry already exists, skip
        if gamelist_only and gamelist_exists:
            print(f"  ✓ Gamelist entry already complete, skipping")
            stats["skipped"] += 1
            stats["api_calls_saved"] += 1
            continue

        # Search game (if we need media or gamelist)
        print(f"  🔍 Searching API...")
        game_data = api.search_game(rom_name, platform_id)

        if not game_data:
            print(f"  ✗ Not found in ScreenScraper")
            stats["not_found"] += 1
            print()
            continue

        stats["found"] += 1
        game_name = game_data.get("noms", [{}])[0].get("text", rom_name)
        print(f"  ✓ Found: {game_name}")

        # Update gamelist
        if not skip_gamelist and gamelist_root is not None:
            metadata = extract_game_metadata(game_data, rom_name)
            if update_gamelist(gamelist_root, rom_name, metadata, parent):
                stats["gamelist_updated"] += 1
                print(f"    📝 Gamelist updated")

                # Save gamelist after each ROM (incremental save)
                if not dry_run:
                    if save_gamelist(gamelist_root, gamelist_path):
                        print(f"    💾 Gamelist saved")
                    else:
                        print(f"    ⚠️  Failed to save gamelist")

        # Skip media download if gamelist_only
        if gamelist_only:
            print()
            continue

        # Download media
        medias = game_data.get("medias", [])
        if not medias:
            print(f"  ⚠ No media available from ScreenScraper")
            print()
            continue

        # Only try to download missing media types
        for media_type in missing_media_types:
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

                                # Use temporary extension - download_media() will correct it
                                output_path = output_dir / f"{rom_name}.tmp"

                                # Skip if media already exists (check all common extensions)
                                if skip_existing:
                                    existing = get_existing_media(
                                        output_dir, rom_name, media_type
                                    )
                                    if existing:
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

    # Final save of gamelist (as backup, since we save after each ROM)
    if not skip_gamelist and gamelist_root is not None and not dry_run:
        log("info", f"Final gamelist save: {gamelist_path}")
        if save_gamelist(gamelist_root, gamelist_path):
            log("info", f"✓ Gamelist finalized successfully")
        else:
            log("error", "Failed to finalize gamelist.xml")

    # Summary
    print("━" * 50)
    print(f"{'Summary for:':<25} {platform}")
    print("━" * 50)
    print(f"{'Total ROMs:':<25} {stats['total']}")
    print(f"{'Found in API:':<25} {stats['found']}")
    print(f"{'Not found in API:':<25} {stats['not_found']}")
    if not gamelist_only:
        print(f"{'Media downloaded:':<25} {stats['downloaded']}")
        print(f"{'Skipped (all exist):':<25} {stats['skipped_all_exist']}")
        print(
            f"{'Skipped (other):':<25} {stats['skipped'] - stats['skipped_all_exist']}"
        )
    if not skip_gamelist:
        print(f"{'Gamelist entries:':<25} {stats['gamelist_updated']}")
    print(f"{'Errors:':<25} {stats['errors']}")
    print("━" * 50)
    if not gamelist_only:
        print(f"{'API calls saved:':<25} {stats['api_calls_saved']} 🎉")
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
  %(prog)s gb --gamelist-only --limit 50
  %(prog)s gba --skip-gamelist
        """,
    )

    parser.add_argument("platform", help="Platform to scrape")
    parser.add_argument(
        "--media-types",
        default="covers,screenshots,marquees,fanart,backcovers,3dboxes,titlescreens,videos,miximages",
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
        "--skip-gamelist",
        action="store_true",
        help="Skip gamelist.xml generation (only download media)",
    )
    parser.add_argument(
        "--gamelist-only",
        action="store_true",
        help="Only update gamelist.xml without downloading media",
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
        skip_gamelist=args.skip_gamelist,
        gamelist_only=args.gamelist_only,
    )

    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())
