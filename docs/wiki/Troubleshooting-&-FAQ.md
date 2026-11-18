> **Language**: **English** | [Español](Troubleshooting-&-FAQ-ES)

# Troubleshooting & FAQ

### Emulator fails to launch on Linux (AppImage)
- Ensure the binary is executable (`chmod +x *.AppImage`) and `libfuse2` is installed on your system, or check **Settings → System Check**.

### `xemu` shows `Failed to open flash file ''`
- Open `xemu` and set `mcpx_1.0.bin`, `Complex_4627v1.03.bin`, and `xbox_hdd.qcow2` under **Machine → Settings → System**. See [BIOS & Firmware](BIOS-&-Firmware).

### RetroArch launches but the game doesn't load
- Verify the core `.so`/`.dll`/`.dylib` exists in `~/.config/retroarch/cores/` and check **Settings → BIOS & Firmware Help**.

### Archive.org downloads fail with 401/403
- Add your S3 API keys in **Settings → Archive.org Settings**.

### How to inspect logs
- Enable verbose logging in **Settings → Debug Settings** (`DebugService` logs).
