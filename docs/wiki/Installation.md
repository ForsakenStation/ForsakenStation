> **Language**: **English** | [Español](Installation-ES)

# Installation

## Prebuilt Releases (Recommended)

Download the latest release for your OS from [GitHub Releases](https://github.com/ForsakenStation/ForsakenStation/releases):

- **Linux**:
  - **AppImage**: `chmod +x Forsaken-*-linux-x64.AppImage && ./Forsaken-*-linux-x64.AppImage`
  - **Portable `.tar.gz`**: extract and run `./forsaken.sh` (includes bundled `libmpv` and FFmpeg libraries).
- **macOS**:
  - Open `Forsaken-*-macos.dmg` and drag `Forsaken.app` into `/Applications`.
  - If Gatekeeper warns about an unsigned app: right-click → **Open** (or `xattr -dr com.apple.quarantine /Applications/Forsaken.app`).
- **Windows**:
  - Extract `Forsaken-*-windows-x64.zip` and run `emulator.exe`.

## Building from Source

### Prerequisites
- **Flutter SDK** `3.47.7` (via [FVM](https://fvm.app/) recommended)
- **Linux dependencies**:
  ```bash
  sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libudev-dev libmpv-dev mpv
  ```

### Build & Run
```bash
git clone https://github.com/ForsakenStation/ForsakenStation.git
cd ForsakenStation
fvm flutter pub get
fvm flutter run -d linux   # or macos / windows / chrome
```
