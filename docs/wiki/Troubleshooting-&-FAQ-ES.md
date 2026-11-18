> **Idioma**: [English](Troubleshooting-&-FAQ) | **Español**

# Solución de Problemas y FAQ

### El emulador no arranca en Linux (AppImage)
- Asegúrate de que tiene permisos de ejecución (`chmod +x *.AppImage`) y de tener `libfuse2` instalado, o revisa **Ajustes → Comprobación del Sistema**.

### `xemu` muestra `Failed to open flash file ''`
- Abre `xemu` y configura `mcpx_1.0.bin`, `Complex_4627v1.03.bin` y `xbox_hdd.qcow2` en **Machine → Settings → System**. Más detalles en [BIOS y Firmware](BIOS-&-Firmware-ES).

### RetroArch abre pero el juego no carga
- Comprueba que el core (`.so`/`.dll`/`.dylib`) está en `~/.config/retroarch/cores/` y revisa **Ajustes → Ayuda de BIOS y Firmware**.

### Descargas de Archive.org fallan con 401/403
- Configura tus claves S3 en **Ajustes → Configuración de Archive.org**.

### Cómo revisar los logs
- Activa el registro detallado en **Ajustes → Ajustes de Depuración** (`DebugService`).
