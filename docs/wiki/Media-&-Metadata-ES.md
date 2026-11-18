> **Idioma**: [English](Media-&-Metadata) | **Español**

# Medios y Metadatos

Forsaken es compatible con archivos `gamelist.xml` de EmulationStation y carpetas de medios locales dentro de `MEDIA_PATH`.

## Estructura de Directorios

```text
MEDIA_PATH/
  <plataforma>/
    3dboxes/       # Carátulas 3D
    covers/        # Carátulas 2D
    miximages/     # Imágenes combinadas
    screenshots/   # Capturas de pantalla
    titlescreens/  # Pantallas de título
    marquee/       # Marquesinas arcade
    fanart/        # Fan art
    videos/        # Vídeos de vista previa (.mp4)
    manuals/       # Manuales PDF (.pdf)
```

## Funcionalidades
- **Visor de Medios a Pantalla Completa (`M`)**: Explora imágenes, reproduce vídeos (`media_kit`) o lee manuales PDF (`pdfrx`).
- **Caché de Medios**: Reconstruye el índice desde **Ajustes → Base de Datos de ROMs → Reconstruir Caché de Medios**.
- **Decodificación HTML**: Limpia automáticamente entidades HTML en descripciones y títulos de `gamelist.xml`.
