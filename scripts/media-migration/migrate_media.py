#!/usr/bin/env python3
"""
Media Migration Script for Emulator

Purpose: Reorganize downloaded media based on new JSONL ROM structure

Usage: ./migrate_media.py <platform> [--dry-run]

Example: ./migrate_media.py amiga500
         ./migrate_media.py amiga500 --dry-run
"""

import argparse
import json
import os
import shutil
import sys
from pathlib import Path
from typing import Dict, List, Tuple

# ANSI colors
COLORS = {
    "RED": "\033[0;31m",
    "GREEN": "\033[0;32m",
    "YELLOW": "\033[1;33m",
    "BLUE": "\033[0;34m",
    "NC": "\033[0m",
}

# Configuration
JSONL_DIR = Path.home() / ".local/share/com.example.emulator/romlists/main"
OLD_MEDIA_DIR = Path("/home/victor/ES-DE/downloaded_media")
NEW_MEDIA_DIR = Path("/home/victor/ES-DE/downloaded_media_new")


def log(level: str, message: str):
    """Print colored log message"""
    color = COLORS.get(level.upper(), COLORS["NC"])
    print(f"{color}[{level.upper()}]{COLORS['NC']} {message}")


def extract_rom_info(jsonl_file: Path) -> List[Tuple[str, str]]:
    """
    Extract ROM information from JSONL file
    Returns list of (rom_name, parent_folder) tuples
    """
    rom_info = []

    with open(jsonl_file, "r", encoding="utf-8") as f:
        for line in f:
            try:
                data = json.loads(line.strip())
                if data.get("type") == "file":
                    rom_name = data.get("n", "")
                    parent = data.get("parent", "")
                    if rom_name:
                        rom_info.append((rom_name, parent))
            except json.JSONDecodeError:
                continue

    return rom_info


def build_file_index(media_dir: Path) -> Dict[str, Path]:
    """Build index of basename (without extension) to file path"""
    file_index = {}

    for filepath in media_dir.rglob("*"):
        if filepath.is_file():
            basename_noext = filepath.stem
            # If duplicate, keep first one
            if basename_noext not in file_index:
                file_index[basename_noext] = filepath

    return file_index


def migrate_platform(platform: str, dry_run: bool = False):
    """Migrate media files for a single platform"""

    jsonl_file = JSONL_DIR / f"{platform}.jsonl"
    old_platform_dir = OLD_MEDIA_DIR / platform
    new_platform_dir = NEW_MEDIA_DIR / platform

    # Validate
    if not jsonl_file.exists():
        log("error", f"JSONL file not found: {jsonl_file}")
        return False

    if not old_platform_dir.exists():
        log("error", f"Old media directory not found: {old_platform_dir}")
        return False

    log("info", f"Media migration for: {platform}")
    if dry_run:
        log("warning", "DRY RUN - No files will be copied")
    print()

    # Extract ROM info with folder structure
    log("info", "Extracting ROM information...")
    rom_info = extract_rom_info(jsonl_file)
    log("info", f"Found {len(rom_info)} ROMs")
    print()

    # Get media types
    media_types = [d.name for d in old_platform_dir.iterdir() if d.is_dir()]
    log("info", f"Media types: {' '.join(media_types)}")
    print()

    # Process each media type
    total_migrated = 0
    media_stats = {}

    for media_type in media_types:
        old_media_type_dir = old_platform_dir / media_type
        new_media_type_dir = new_platform_dir / media_type

        log("info", f"Processing {media_type}...")
        log("info", f"  Building file index...")

        # Build index
        file_index = build_file_index(old_media_type_dir)
        log("info", f"  Found {len(file_index)} files")

        log("info", f"  Matching ROMs to files...")

        # Match and copy with the folder structure
        migrated = 0
        for rom_name, parent_folder in rom_info:
            if rom_name in file_index:
                source_file = file_index[rom_name]

                # Build destination path with folder structure
                if parent_folder:
                    dest_dir = new_media_type_dir / parent_folder
                    dest_file = dest_dir / source_file.name
                else:
                    dest_dir = new_media_type_dir
                    dest_file = new_media_type_dir / source_file.name

                if not dry_run:
                    dest_dir.mkdir(parents=True, exist_ok=True)
                    shutil.move(source_file, dest_file)

                migrated += 1
                total_migrated += 1

        log("info", f"  {media_type}: {migrated} files migrated")
        media_stats[media_type] = migrated
        print()

    # Summary
    if not dry_run and new_platform_dir.exists():
        log("success", "Migration complete!")
        print()
        print("━" * 42)
        print(f"  Summary for: {platform}")
        print("━" * 42)
        print(f"  ROMs processed:    {len(rom_info)}")
        print(f"  Files migrated:    {total_migrated}")
        print("━" * 42)
        print()

        log("info", "Media breakdown:")
        for media_type, count in media_stats.items():
            print(f"  {media_type}: {count} files")
        print()

        log("info", f"Old: {old_platform_dir} (preserved)")
        log("info", f"New: {new_platform_dir}")
        print()
        log("success", "Done! Review and delete old directory if satisfied.")
    else:
        log("info", "DRY RUN complete - run without --dry-run to copy files")

    return True


def list_platforms():
    """List available platforms"""
    platforms = sorted([f.stem for f in JSONL_DIR.glob("*.jsonl")])
    print("Available platforms:")
    for i in range(0, len(platforms), 5):
        print("  " + "  ".join(platforms[i : i + 5]))


def main():
    parser = argparse.ArgumentParser(
        description="Migrate media files based on JSONL ROM lists",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s amiga500              # Migrate amiga500 media
  %(prog)s amiga500 --dry-run    # Test migration without copying
  %(prog)s --list                # List available platforms
        """,
    )

    parser.add_argument("platform", nargs="?", help="Platform to migrate")
    parser.add_argument(
        "--dry-run", action="store_true", help="Show what would be done without copying"
    )
    parser.add_argument("--list", action="store_true", help="List available platforms")

    args = parser.parse_args()

    if args.list:
        list_platforms()
        return 0

    if not args.platform:
        parser.print_help()
        print()
        list_platforms()
        return 1

    success = migrate_platform(args.platform, dry_run=args.dry_run)
    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())
