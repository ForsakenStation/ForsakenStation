> **Language**: **English** | [Español](BIOS-&-Firmware-ES)

# BIOS & Firmware

Some systems require original BIOS or firmware files to boot games.

## BIOS Help & Auto-Downloader
Open **Settings → BIOS & Firmware Help** to:
- Check which BIOS files are **present** or **missing** per platform.
- See the exact expected folder (e.g. `~/.config/retroarch/system/`, `~/.local/share/xemu/xemu/`).
- Download missing BIOS/firmware files directly where community preservation mappings are available (with MD5/SHA1/CRC32/size verification).

## Original Xbox (`xemu`) Note
`xemu` requires three system files configured in `xemu` under **Machine → Settings → System**:
1. `mcpx_1.0.bin` (MCPX Boot ROM)
2. `Complex_4627v1.03.bin` (Flash / BIOS ROM)
3. `xbox_hdd.qcow2` (Pre-formatted Xbox HDD image)

If `xemu` shows `Failed to open flash file ''`, configure these three paths inside `xemu` settings first.
