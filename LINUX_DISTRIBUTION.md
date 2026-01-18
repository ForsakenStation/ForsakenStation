# Forsaken Emulator - Distribución Linux

Este documento explica cómo crear ejecutables portables de Forsaken Emulator para Linux que incluyan todas las dependencias necesarias (especialmente libmpv).

## 🎯 Opciones de Distribución

### 1️⃣ **Portable ZIP** (Más simple)
Bundle con todas las librerías incluidas en un ZIP.

**Uso:**
```bash
./build_linux_portable.sh
```

**Resultado:**
- `build/linux/x64/release/bundle_portable/` - Carpeta portable
- `build/linux/x64/release/forsaken-linux-portable-YYYYMMDD.zip` - ZIP comprimido

**Distribución:**
- Extrae el ZIP en cualquier máquina Linux x64
- Ejecuta: `./forsaken.sh`
- No requiere instalación de libmpv

---

### 2️⃣ **AppImage** (Recomendado) ⭐
Archivo único ejecutable con todas las dependencias.

**Uso:**
```bash
./build_appimage.sh
```

**Resultado:**
- `Forsaken-1.0.0-x86_64.AppImage` - Archivo único ejecutable

**Distribución:**
- Un solo archivo portable
- Doble click para ejecutar
- Funciona en cualquier distribución Linux moderna
- No requiere instalación

**Ventajas:**
- ✅ Un solo archivo
- ✅ Integración con el sistema (icono, .desktop)
- ✅ Auto-actualización posible
- ✅ Sandboxing opcional

---

### 3️⃣ **Flatpak** (Para tiendas)
Paquete para Flathub y tiendas de aplicaciones.

**Requisitos:**
```bash
sudo apt install flatpak flatpak-builder
```

**Build:**
```bash
# Primera vez: build e instalar
flatpak-builder --user --install --force-clean build-flatpak com.forsaken.Emulator.yml

# Ejecutar
flatpak run com.forsaken.Emulator
```

**Distribución:**
- Publicar en Flathub
- Instalación desde tiendas de apps
- Actualizaciones automáticas
- Sandbox de seguridad

---

## 📋 Dependencias del Sistema (para compilar)

### Ubuntu/Debian:
```bash
sudo apt install \
  libmpv-dev \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev \
  libswresample-dev \
  zip
```

### Fedora:
```bash
sudo dnf install \
  mpv-libs-devel \
  ffmpeg-devel \
  zip
```

### Arch:
```bash
sudo pacman -S mpv ffmpeg zip
```

---

## 🚀 Proceso Recomendado

Para distribución general, usa **AppImage**:

```bash
# 1. Instalar dependencias
sudo apt install libmpv-dev zip

# 2. Build AppImage
./build_appimage.sh

# 3. Distribuir el archivo .AppImage
# Usuario solo necesita:
chmod +x Forsaken-*.AppImage
./Forsaken-*.AppImage
```

---

## 🔍 Verificar Dependencias Incluidas

Después de crear el portable/AppImage:

```bash
# Para ZIP portable:
ldd build/linux/x64/release/bundle_portable/lib/libmpv.so

# Para AppImage (después de extraer):
./Forsaken-*.AppImage --appimage-extract
ldd squashfs-root/usr/lib/libmpv.so
```

---

## ⚠️ Notas Importantes

1. **libmpv versions**: El script copia la versión instalada en tu sistema
   - Para máxima compatibilidad, compila en la distribución más antigua que soportes
   - Ubuntu 20.04 LTS es un buen baseline

2. **Tamaño del paquete**:
   - ZIP portable: ~150-200 MB (con libmpv y ffmpeg)
   - AppImage: ~180-250 MB (incluye runtime)
   - Flatpak: ~200 MB (compartido con otras apps)

3. **Codecs**:
   - Asegúrate de tener ffmpeg con H.264/H.265 habilitado
   - Para H.264: `ffmpeg -codecs | grep h264`

4. **Testing**:
   - Prueba el ejecutable en una VM limpia sin dependencias instaladas
   - Verifica que los videos del carousel funcionen

---

## 📦 Comparación

| Método | Tamaño | Portabilidad | Complejidad | Integración |
|--------|--------|-------------|-------------|-------------|
| ZIP Portable | ~150 MB | ⭐⭐⭐ | ⭐ (Fácil) | ❌ |
| AppImage | ~200 MB | ⭐⭐⭐⭐⭐ | ⭐⭐ (Media) | ✅ |
| Flatpak | ~200 MB | ⭐⭐⭐⭐ | ⭐⭐⭐ (Alta) | ✅✅ |

**Recomendación**: Usa AppImage para distribución pública.

---

## 🐛 Troubleshooting

### "libmpv.so.2: cannot open shared object file"
→ El script no incluyó libmpv. Verifica que `libmpv-dev` esté instalado.

### "symbol lookup error"
→ Incompatibilidad de versiones. Recompila en sistema más antiguo.

### Videos no funcionan
→ Verifica codecs: `ldd libmpv.so | grep avcodec`

### AppImage no ejecuta
→ Asegúrate de que FUSE esté disponible: `sudo apt install fuse`
