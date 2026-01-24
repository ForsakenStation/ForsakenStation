# 📋 PLAN DE INTEGRACIÓN - BIOS Download desde retroarch_system

## Repositorio Fuente
- **URL:** https://github.com/Abdess/retroarch_system
- **Rama:** `libretro` (no `master`)
- **Descripción:** Compilation of BIOSes for various emulation platforms
- **Estrellas:** 5k+ - repositorio bien mantenido
- **Última actualización:** 2020-11-02 (archivos estables)

## Estructura del Repo
```
retroarch_system/
├── Sony - PlayStation/
│   ├── scph5500.bin (JAP)
│   ├── scph5501.bin (USA) 
│   └── scph5502.bin (EUR)
├── Sega - Dreamcast/
│   ├── dc_boot.bin
│   └── dc_flash.bin
├── Nintendo - Game Boy Advance/
│   └── gba_bios.bin
└── ... (50+ plataformas)
```

## Fase 1: Mapeo de Plataformas y URLs

### Objetivo
Crear mapeo entre las plataformas actuales y los archivos del repositorio

### Tareas
1. **BiosDownloadMapping** - Modelo que vincule:
   - Plataforma local (ej: 'psx') 
   - Carpeta en el repo (ej: 'Sony - PlayStation')
   - Archivos específicos a descargar
   - URLs de GitHub raw para cada archivo

2. **BiosDownloadService** - Servicio con:
   - Método para construir URLs de GitHub raw:
     ```
     https://github.com/Abdess/retroarch_system/raw/libretro/{plataforma}/{archivo}
     ```
   - Método para descargar archivo individual
   - Método para descargar todos los archivos de una plataforma
   - Método para descargar todos los BIOS faltantes
   - Manejo de progreso de descarga
   - Verificación de checksums (MD5/SHA1 del repo)

3. **BiosRequirement** - Extender con:
   - Campo opcional `downloadableFiles` con mapeo a URLs
   - Flag `canDownload` para indicar si está disponible en el repo

### Archivos Afectados
- `lib/models/bios_download_mapping.dart` (nuevo)
- `lib/services/bios_download_service.dart` (nuevo)
- `lib/models/bios_requirement.dart` (modificar)

## Fase 2: UI - Botones de Descarga en BiosHelpScreen

### Objetivo
Agregar funcionalidad de descarga tanto individual como global

### Cambios en BiosHelpScreen

#### 1. Botón Global "Download All Missing"
- **Ubicación:** En el card de Summary, junto a las estadísticas
- **Visibilidad:** Solo si hay BIOS faltantes descargables
- **Funcionalidad:** Muestra diálogo de confirmación con lista de archivos
- **Progreso:** Indicador de progreso global

#### 2. Botón Individual por Plataforma
- **Ubicación:** En cada `ExpansionTile` de plataforma
- **Visibilidad:** Solo si plataforma tiene archivos faltantes Y disponibles en repo
- **Estados del botón:**
  - "Download" - normal
  - "Downloading..." - en progreso con spinner
  - "Downloaded" - completado con checkmark
  - "Error" - con icono de error

#### 3. Diálogo de Progreso
- Muestra archivo actual siendo descargado
- Barra de progreso por archivo
- Progreso total (X/Y archivos)
- Opción de cancelar
- Log de errores si algo falla

### Archivos Afectados
- `lib/screens/settings_categories/bios_help_screen.dart` (modificar)
- `lib/widgets/bios/bios_download_dialog.dart` (nuevo)

## Fase 3: Atribución en About Dialog

### Objetivo
Dar crédito apropiado al repositorio retroarch_system

### Implementación
Agregar nueva sección en `_showAboutDialog()` en `settings_screen.dart`:

```dart
const Text(
  'BIOS Files',
  style: TextStyle(fontWeight: FontWeight.bold),
),
const SizedBox(height: 8),
const Text(
  'BIOS files are sourced from the retroarch_system repository by Abdess:',
  style: TextStyle(fontSize: 13),
),
const SizedBox(height: 8),
const SelectableText(
  'https://github.com/Abdess/retroarch_system',
  style: TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    color: Colors.blue,
  ),
),
const SizedBox(height: 8),
const Text(
  'This repository contains system files and BIOS required by various emulation platforms. Special thanks to the maintainers for preserving these essential files.',
  style: TextStyle(fontSize: 12, color: Colors.grey),
),
```

### Archivos Afectados
- `lib/screens/settings_screen.dart` (modificar)

## Fase 4: Actualización de ControlsBottomBar

### Objetivo
Agregar controles para la nueva funcionalidad

### En BiosHelpScreen
- Agregar acción condicional "Download" cuando haya BIOS faltantes
- **Tecla:** D / **Gamepad:** Y
- **Visibilidad:** Solo cuando hay archivos descargables faltantes

### Archivos Afectados
- `lib/screens/settings_categories/bios_help_screen.dart` (modificar)

## Fase 5: Verificación Post-Descarga

### Objetivo
Validar archivos descargados y actualizar UI

### Funcionalidad
1. Después de descargar, verificar checksum MD5/SHA1
2. Mover archivo a ubicación correcta en sistema
3. Actualizar estado en UI automáticamente
4. Mostrar resumen de descarga:
   - ✅ Archivos descargados exitosamente
   - ❌ Archivos con errores
   - ℹ️ Acción requerida si es necesario

### Archivos Afectados
- `lib/services/bios_download_service.dart` (ampliar)
- `lib/services/bios_check_service.dart` (agregar método de re-scan)

## Dependencias Necesarias

Agregar a `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.2.0  # Para descargas HTTP
  crypto: ^3.0.3  # Para verificación de checksums
  path: ^1.9.0  # Ya presente
```

## Mapeo de Plataformas

### Plataformas Disponibles en retroarch_system
| Plataforma Local | Carpeta en Repo | Archivos Principales |
|------------------|-----------------|---------------------|
| `psx` | Sony - PlayStation | scph5500.bin, scph5501.bin, scph5502.bin |
| `ps2` | No disponible | - |
| `saturn` | Sega - Saturn | sega_101.bin, mpr-17933.bin |
| `dreamcast` | Sega - Dreamcast | dc_boot.bin, dc_flash.bin |
| `segacd` | Sega - Mega CD - Sega CD | bios_CD_U.bin, bios_CD_E.bin, bios_CD_J.bin |
| `pcenginecd` | NEC - PC Engine - TurboGrafx 16 - SuperGrafx | syscard3.pce, syscard2.pce, syscard1.pce |
| `nds` | Nintendo - Nintendo DS | bios7.bin, bios9.bin, firmware.bin |
| `fds` | Nintendo - Famicom Disk System | disksys.rom |
| `atari5200` | Atari - 5200 | 5200.rom |
| `gba` | Nintendo - Game Boy Advance | gba_bios.bin |
| `msx` | Microsoft - MSX | MSX.ROM, MSX2.ROM, MSX2EXT.ROM, MSX2P.ROM |
| `amiga` | Commodore - Amiga | kick34005.A500, kick40063.A600, kick40068.A1200 |
| `neogeo` | SNK - NeoGeo CD | neogeo.zip |
| `gbc` | Nintendo - Gameboy Color | gbc_bios.bin |
| `n64dd` | Nintendo - Nintendo 64DD | 64DD_IPL.bin |
| `atari7800` | Atari - 7800 | 7800 BIOS (U).rom |
| `intellivision` | Mattel - Intellivision | exec.bin, grom.bin |
| `colecovision` | Coleco - ColecoVision | colecovision.rom |
| `lynx` | Atari - Lynx | lynxboot.img |
| `pcfx` | NEC - PC-FX | pcfx.rom |
| `3do` | 3DO Company, The - 3DO | panafz10.bin, panafz1.bin, goldstar.bin |

## Flujo de Usuario Final

### Escenario 1 - Descarga Individual
1. Usuario abre BIOS Help Screen
2. Ve plataforma con archivos faltantes (ej: PlayStation 1)
3. Expande el card de la plataforma
4. Ve botón "Download 3 missing files"
5. Click en botón → Diálogo de confirmación
6. Descarga inicia → Barra de progreso
7. Al completar → Auto-refresh → Archivos aparecen como ✅

### Escenario 2 - Descarga Masiva
1. Usuario abre BIOS Help Screen
2. Ve estadísticas: "15 platforms missing files"
3. Ve botón "Download All Missing BIOS" en Summary
4. Click → Diálogo con lista completa de archivos
5. Confirma → Descarga secuencial con progreso global
6. Al completar → Resumen detallado
7. Auto-refresh → Estadísticas actualizadas

### Escenario 3 - Ver Atribución
1. Usuario abre Settings
2. Click en "About & Debug"
3. Ve sección "BIOS Files" con link
4. Puede copiar URL para referencia

## Consideraciones de Implementación

### Seguridad
- Verificar checksums MD5/SHA1 del repo
- Manejar errores de red gracefully
- No sobreescribir archivos existentes sin confirmación

### Performance
- Descargas concurrentes (max 3 simultáneas)
- Cancelación de descargas en progreso
- Reintentos automáticos (max 3 intentos)
- Timeout de 30 segundos por archivo

### UX
- Feedback visual claro del progreso
- Estimación de tiempo restante
- Notificación al completar

### Mantenimiento
- El repo usa la rama `libretro` (no `master`)
- Última actualización 2020 - archivos estables
- Mapeo debe ser verificado manualmente
- Considerar fallback si repo cambia

## Orden de Implementación

1. **Fase 1** - Mapeo y servicios básicos (core)
2. **Dependencias** - Actualizar pubspec.yaml
3. **Fase 3** - Atribución en About (rápido, visible)
4. **Fase 2** - UI de descarga individual
5. **Fase 2** - UI de descarga global
6. **Fase 4** - Controles de gamepad/teclado
7. **Fase 5** - Verificación y refinamiento

## Testing

### Casos a Probar
- [ ] Descarga de archivo único
- [ ] Descarga de plataforma completa (múltiples archivos)
- [ ] Descarga masiva (all missing)
- [ ] Error de red durante descarga
- [ ] Checksum inválido
- [ ] Archivo ya existe
- [ ] Cancelación de descarga
- [ ] Navegación con gamepad
- [ ] Refresh después de descarga

## URLs de Ejemplo

```
# PlayStation BIOS USA
https://github.com/Abdess/retroarch_system/raw/libretro/Sony%20-%20PlayStation/scph5501.bin

# Dreamcast BIOS boot
https://github.com/Abdess/retroarch_system/raw/libretro/Sega%20-%20Dreamcast/dc_boot.bin

# GBA BIOS
https://github.com/Abdess/retroarch_system/raw/libretro/Nintendo%20-%20Game%20Boy%20Advance/gba_bios.bin
```

## Estructura de Archivos Final

```
lib/
├── models/
│   ├── bios_requirement.dart (modificar)
│   └── bios_download_mapping.dart (nuevo)
├── services/
│   ├── bios_check_service.dart (modificar)
│   └── bios_download_service.dart (nuevo)
├── screens/
│   ├── settings_screen.dart (modificar)
│   └── settings_categories/
│       └── bios_help_screen.dart (modificar)
└── widgets/
    └── bios/
        └── bios_download_dialog.dart (nuevo)
```