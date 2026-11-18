> **Idioma**: [English](Contributing-&-Architecture) | **Español**

# Contribuir y Arquitectura

## Estructura del Proyecto
```text
lib/
  main.dart                 # Inicialización de la app y widget raíz EmulatorApp
  constants/                # Constantes legales y versión de la app
  models/                   # Modelos de datos (Rom, EmulatorPlatform, GameInfo, etc.)
  services/                 # Lógica de negocio (ConfigService, RomService, MediaService, EmulatorService)
  screens/                  # Pantallas completas (Platforms, ROMs, Settings y subpantallas)
  widgets/                  # Widgets reutilizables (ControlsBottomBar, AppSnackBar, PlatformBadge)
  utils/                    # Alias de plataformas, validación de seguridad y temas
```

## Convenciones de Desarrollo
- Usar siempre `DebugService.instance` para logs (nunca `print()` ni `debugPrint()`).
- Incluir `ControlsBottomBar` en todas las pantallas completas.
- Ejecutar `fvm flutter analyze --no-pub` y `fvm flutter test --no-pub` antes de abrir un PR.

## Releases y Sincronización de Wiki Automáticas
- Hacer push de un tag `v*` lanza `.github/workflows/release.yml` (Linux AppImage/tar.gz, macOS DMG, Windows ZIP).
- Hacer push en `main` con cambios en `docs/wiki/` sincroniza automáticamente esta Wiki mediante `.github/workflows/wiki.yml`.
