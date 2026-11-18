> **Idioma**: [English](BIOS-&-Firmware) | **Español**

# BIOS y Firmware

Algunos sistemas necesitan archivos BIOS o firmware para arrancar los juegos.

## Ayuda y Descarga de BIOS
Abre **Ajustes → Ayuda de BIOS y Firmware** para:
- Comprobar qué archivos BIOS están **disponibles** o **faltan** en cada plataforma.
- Ver la ruta exacta esperada (por ejemplo `~/.config/retroarch/system/` o `~/.local/share/xemu/xemu/`).
- Descargar automáticamente los archivos faltantes cuando hay enlace verificado (con comprobación de tamaño y hash).

## Nota sobre Xbox Original (`xemu`)
`xemu` necesita tres archivos configurados dentro del propio emulador en **Machine → Settings → System**:
1. `mcpx_1.0.bin` (MCPX Boot ROM)
2. `Complex_4627v1.03.bin` (Flash / BIOS ROM)
3. `xbox_hdd.qcow2` (Imagen de disco duro Xbox)

Si `xemu` muestra `Failed to open flash file ''`, selecciona esos tres archivos en la configuración de máquina de `xemu`.
