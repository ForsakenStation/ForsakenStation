#!/bin/bash
#
# Batch migrate all platforms with existing media
#

set -e

MEDIA_DIR="/home/victor/ES-DE/downloaded_media"
SCRIPT="./migrate_media.py"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Media Migration - Batch Mode${NC}"
echo ""

# Get list of platforms with existing media
echo "Scanning for platforms with media..."
PLATFORMS=()
for dir in "$MEDIA_DIR"/*; do
    if [ -d "$dir" ]; then
        platform=$(basename "$dir")
        # Skip symlinks
        if [ ! -L "$dir" ]; then
            PLATFORMS+=("$platform")
        fi
    fi
done

echo -e "${GREEN}Found ${#PLATFORMS[@]} platforms with media${NC}"
echo ""

# Confirm
echo "Platforms to migrate:"
printf '  %s\n' "${PLATFORMS[@]}" | column
echo ""
read -p "Continue with migration? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "Starting batch migration..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Migrate each platform
SUCCESS=0
FAILED=0
SKIPPED=0

for platform in "${PLATFORMS[@]}"; do
    echo -e "${BLUE}[${SUCCESS}/${#PLATFORMS[@]}] Migrating: $platform${NC}"
    
    if $SCRIPT "$platform"; then
        ((SUCCESS++))
    else
        echo "  ⚠️  Failed"
        ((FAILED++))
    fi
    
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}Batch migration complete!${NC}"
echo ""
echo "  Total platforms: ${#PLATFORMS[@]}"
echo "  Successful:      $SUCCESS"
echo "  Failed:          $FAILED"
echo ""
