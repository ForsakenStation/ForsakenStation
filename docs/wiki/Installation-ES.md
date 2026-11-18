> **Idioma**: [English](Installation) | **Español**

# Instalación

## Releases Precompiladas (Recomendado)

Descarga la última versión desde [GitHub Releases](https://github.com/ForsakenStation/ForsakenStation/releases):

- **Linux**:
  - **AppImage**: `chmod +x Forsaken-*-linux-x64.AppImage && ./Forsaken-*-linux-x64.AppImage`
  - **Portable `.tar.gz`**: descomprime y ejecuta `./forsaken.sh` (incluye `libmpv` y librerías FFmpeg).
- **macOS**:
  - Abre `Forsaken-*-macos.dmg` y arrastra `Forsaken.app` a `/Applications`.
  - Si Gatekeeper avisa de app sin firma: clic derecho → **Abrir** (o `xattr -dr com.apple.quarantine /Applications/Forsaken.app`).
- **Windows**:
  - Descomprime `Forsaken-*-windows-x64.zip` y ejecuta `emulator.exe`.

## Compilar desde el Código Fuente

### Requisitos
- **Flutter SDK** `3.47.7` (recomendado con [FVM](https://fvm.app/))
- **Dependencias en Linux**:
  ```bash
  sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libudev-dev libmpv-dev mpv
  ```

### Compilar y Ejecutar
```bash
git clone https://github.com/ForsakenStation/ForsakenStation.git
cd ForsakenStation
fvm flutter pub get
fvm flutter run -d linux   # o macos / windows / chrome
```
