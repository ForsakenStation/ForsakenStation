> **Language**: **English** | [Español](Media-&-Metadata-ES)

# Media & Metadata

Forsaken supports EmulationStation-compatible `gamelist.xml` files and local media directories under `MEDIA_PATH`.

## Directory Structure

```text
MEDIA_PATH/
  <platform>/
    3dboxes/       # 3D box art
    covers/        # 2D box art
    miximages/     # Composite mix images
    screenshots/   # In-game screenshots
    titlescreens/  # Title screens
    marquee/       # Arcade marquees
    fanart/        # Fan art
    videos/        # Video previews (.mp4)
    manuals/       # PDF manuals (.pdf)
```

## Features
- **Fullscreen Media Viewer (`M`)**: Inspect images, watch video previews (`media_kit`), or read PDF manuals (`pdfrx`).
- **Media Cache**: Rebuild the media index anytime from **Settings → ROM Database → Rebuild Media Cache**.
- **HTML Entity Decoding**: Automatically decodes escaped entities in `gamelist.xml` descriptions and titles.
