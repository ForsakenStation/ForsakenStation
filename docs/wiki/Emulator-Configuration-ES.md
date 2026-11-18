> **Idioma**: [English](Emulator-Configuration) | **Español**

# Configuración de Emuladores

Forsaken incluye configuraciones por defecto para **171 plataformas** en `assets/config.json`, compatibles tanto con **cores de RetroArch** como con **emuladores independientes** (Dolphin, PCSX2, Cemu, RPCS3, xemu, Xenia, DuckStation, etc.).

## Gestión desde la App
En **Ajustes → Gestión de Emuladores** puedes:
- Descargar emuladores compatibles directamente a `EMULATORS_PATH`.
- Añadir, editar o cambiar el comando de lanzamiento por plataforma.
- Configurar `acceptZipFiles` (si es `false`, Forsaken descomprime el `.zip` en almacenamiento permanente antes de lanzar).

## Exportar e Importar `config.json`
En **Ajustes → Utilidades del Sistema**:
- **Export config.json**: Exporta tu configuración activa a un archivo JSON de respaldo.
- **Import config.json**: Restaura una copia previa validando su formato.

## Ejemplos de Comandos Especiales
- **Xbox (`xemu`)**: `xemu.AppImage -dvd_path` (`acceptZipFiles: false`)
- **GameCube / Wii (`dolphin`)**: `dolphin.AppImage -e` (`acceptZipFiles: false`)
- **Wii U (`cemu`)**: `cemu.AppImage -g`
- **RetroArch**: `retroarch.AppImage -f -L ~/.config/retroarch/cores/<core>_libretro.so`
