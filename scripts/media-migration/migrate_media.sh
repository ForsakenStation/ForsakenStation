#!/bin/bash

#############################################################################
# Media Migration Script for Emulator
#
# Purpose: Reorganize downloaded media based on new JSONL ROM structure
#
# Usage: ./migrate_media.sh <platform> [--dry-run]
#
# Example: ./migrate_media.sh amiga500
#          ./migrate_media.sh amiga500 --dry-run
#
# This script:
# 1. Reads the JSONL file for the platform
# 2. Extracts ROM names (without extensions)
# 3. Finds matching media files in old structure
# 4. Copies them to new structure (downloaded_media_new)
# 5. Preserves old files that don't match
#############################################################################

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
JSONL_DIR="$HOME/.local/share/com.example.emulator/romlists/main"
OLD_MEDIA_DIR="/home/victor/ES-DE/downloaded_media"
NEW_MEDIA_DIR="/home/victor/ES-DE/downloaded_media_new"

# Options
DRY_RUN=false

# Stats
TOTAL_ROMS=0
MIGRATED_FILES=0

#############################################################################
# Functions
#############################################################################

print_usage() {
    echo "Usage: $0 <platform> [--dry-run]"
    echo ""
    echo "Example: $0 amiga500"
    echo "         $0 amiga500 --dry-run"
    echo ""
    echo "Options:"
    echo "  --dry-run    Show what would be done without copying files"
    echo ""
    echo "Available platforms:"
    ls "$JSONL_DIR"/*.jsonl 2>/dev/null | xargs -n1 basename | sed 's/.jsonl$//' | column | head -20
    echo "  ... and more"
    exit 1
}

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

#############################################################################
# Main Script
#############################################################################

# Parse arguments
if [ $# -lt 1 ]; then
    print_usage
fi

PLATFORM="$1"
shift

while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run) DRY_RUN=true ;;
        *) log_error "Unknown option: $1"; print_usage ;;
    esac
    shift
done

JSONL_FILE="$JSONL_DIR/${PLATFORM}.jsonl"

# Validate
if [ ! -f "$JSONL_FILE" ]; then
    log_error "JSONL file not found: $JSONL_FILE"
    print_usage
fi

if [ ! -d "$OLD_MEDIA_DIR/$PLATFORM" ]; then
    log_error "Old media directory not found: $OLD_MEDIA_DIR/$PLATFORM"
    exit 1
fi

# Create new media directory
[ "$DRY_RUN" = false ] && mkdir -p "$NEW_MEDIA_DIR/$PLATFORM"

log_info "Media migration for: $PLATFORM"
[ "$DRY_RUN" = true ] && log_warning "DRY RUN - No files will be copied"
echo ""

# Extract ROM names from JSONL
log_info "Extracting ROM names..."
TMP_ROM_LIST=$(mktemp)
trap "rm -f $TMP_ROM_LIST" EXIT
grep '"type": "file"' "$JSONL_FILE" | grep -o '"n": "[^"]*"' | sed 's/"n": "//; s/"$//' > "$TMP_ROM_LIST"
TOTAL_ROMS=$(wc -l < "$TMP_ROM_LIST")
log_info "Found $TOTAL_ROMS ROMs"
echo ""

# Get media types
MEDIA_TYPES=$(ls -1 "$OLD_MEDIA_DIR/$PLATFORM" 2>/dev/null)
log_info "Media types: $(echo $MEDIA_TYPES | tr '\n' ' ')"
echo ""

# Process each media type
for MEDIA_TYPE in $MEDIA_TYPES; do
    [ ! -d "$OLD_MEDIA_DIR/$PLATFORM/$MEDIA_TYPE" ] && continue
    
    log_info "Processing $MEDIA_TYPE..."
    
    # Create destination
    [ "$DRY_RUN" = false ] && mkdir -p "$NEW_MEDIA_DIR/$PLATFORM/$MEDIA_TYPE"
    
    # Use awk for fast matching (single pass through files)
    log_info "  Migrating files..."
    MEDIA_MIGRATED=0
    
    # Build ROM name pattern file for awk
    TMP_PATTERN=$(mktemp)
    awk '{print $0 "\\."}' "$TMP_ROM_LIST" > "$TMP_PATTERN"
    
    # Find and copy matching files
    find "$OLD_MEDIA_DIR/$PLATFORM/$MEDIA_TYPE" -type f 2>/dev/null | while IFS= read -r filepath; do
        basename_file=$(basename "$filepath")
        basename_noext="${basename_file%.*}"
        
        # Check if this basename matches any ROM name
        if grep -qFx "$basename_noext" "$TMP_ROM_LIST"; then
            if [ "$DRY_RUN" = true ]; then
                ((MEDIA_MIGRATED++)) 2>/dev/null || MEDIA_MIGRATED=1
            else
                cp "$filepath" "$NEW_MEDIA_DIR/$PLATFORM/$MEDIA_TYPE/$basename_file"
                ((MEDIA_MIGRATED++)) 2>/dev/null || MEDIA_MIGRATED=1
            fi
            ((MIGRATED_FILES++)) 2>/dev/null || MIGRATED_FILES=1
        fi
    done
    
    log_info "  $MEDIA_TYPE: $MEDIA_MIGRATED files migrated"
    rm -f "$TMP_PATTERN"
done

echo ""

# Count actual files
if [ "$DRY_RUN" = false ] && [ -d "$NEW_MEDIA_DIR/$PLATFORM" ]; then
    log_success "Migration complete!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Summary for: $PLATFORM"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ROMs processed:    $TOTAL_ROMS"
    echo "  Files migrated:    $MIGRATED_FILES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    log_info "Media breakdown:"
    for MEDIA_TYPE in $(ls -1 "$NEW_MEDIA_DIR/$PLATFORM" 2>/dev/null); do
        COUNT=$(find "$NEW_MEDIA_DIR/$PLATFORM/$MEDIA_TYPE" -type f 2>/dev/null | wc -l)
        echo "  $MEDIA_TYPE: $COUNT files"
    done
    echo ""
    
    log_info "Old: $OLD_MEDIA_DIR/$PLATFORM (preserved)"
    log_info "New: $NEW_MEDIA_DIR/$PLATFORM"
    echo ""
    log_success "Done! Review and delete old directory if satisfied."
else
    log_info "DRY RUN complete - run without --dry-run to copy files"
fi
