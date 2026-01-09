# Configuración del Icono de la App

Este documento explica cómo se configuró el icono de la aplicación Forsaken para todas las plataformas soportadas.

## 📱 Icono Actual

**Archivo fuente**: `assets/images/icon.png`
- **Resolución**: 557x558px
- **Formato**: PNG
- **Tamaño**: 86KB

## 🛠️ Configuración

### Herramienta Utilizada

Usamos el paquete [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) para generar automáticamente todos los iconos necesarios para cada plataforma.

### Configuración en pubspec.yaml

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.4

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon.png"
  
  # Android adaptive icon
  adaptive_icon_background: "#000000"
  adaptive_icon_foreground: "assets/images/icon.png"
  
  # Web
  web:
    generate: true
    image_path: "assets/images/icon.png"
    background_color: "#000000"
    theme_color: "#000000"
  
  # Windows
  windows:
    generate: true
    image_path: "assets/images/icon.png"
    icon_size: 256
  
  # macOS
  macos:
    generate: true
    image_path: "assets/images/icon.png"
  
  # Linux
  linux:
    generate: true
    image_path: "assets/images/icon.png"
```

## 🎯 Plataformas Configuradas

### ✅ Android
- **Icono launcher estándar**: Generado en múltiples densidades (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- **Adaptive icon**: Configurado con fondo negro (#000000)
- **Ubicación**: `android/app/src/main/res/mipmap-*/`

**Archivos generados**:
- `ic_launcher.png` (en cada carpeta mipmap-*)
- Adaptive icon con background y foreground separados

### ✅ iOS
- **Iconos generados**: Todos los tamaños requeridos por Apple (20x20 a 1024x1024)
- **Ubicación**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

**⚠️ Advertencia iOS**: 
El icono actual contiene un canal alpha (transparencia). La App Store de Apple **no permite iconos con canal alpha**. 

**Soluciones**:
1. **Opción automática**: Agregar a `pubspec.yaml`:
   ```yaml
   flutter_launcher_icons:
     remove_alpha_ios: true
   ```
   
2. **Opción manual**: Editar `assets/images/icon.png` en un editor de imágenes y:
   - Remover la transparencia
   - Agregar un fondo sólido (negro recomendado)
   - Guardar sin canal alpha

### ✅ Web
- **Iconos generados**: 192x192 y 512x512 (estándar y maskable)
- **Ubicación**: `web/icons/`
- **Configuración PWA**: Los iconos están configurados en `web/manifest.json`

**Archivos generados**:
- `Icon-192.png`
- `Icon-512.png`
- `Icon-maskable-192.png`
- `Icon-maskable-512.png`

### ✅ Windows
- **Formato**: ICO (contiene múltiples resoluciones)
- **Resolución máxima**: 256x256
- **Ubicación**: `windows/runner/resources/app_icon.ico`

### ✅ macOS
- **Iconos generados**: Todos los tamaños requeridos (16x16 a 1024x1024)
- **Ubicación**: `macos/Runner/Assets.xcassets/AppIcon.appiconset/`

**Archivos generados**:
- `app_icon_16.png`
- `app_icon_32.png`
- `app_icon_64.png`
- `app_icon_128.png`
- `app_icon_256.png`
- `app_icon_512.png`
- `app_icon_1024.png`

### ✅ Linux
- **Icono**: Copiado manualmente
- **Ubicación**: `linux/flutter/launcher_icon.png`

**Nota**: El paquete `flutter_launcher_icons` no genera automáticamente el icono para Linux, por lo que se copió manualmente.

## 🔄 Cómo Regenerar los Iconos

### 1. Preparar el icono fuente

Coloca tu nuevo icono en `assets/images/icon.png` con las siguientes especificaciones:
- **Resolución mínima recomendada**: 1024x1024px
- **Formato**: PNG
- **Fondo**: Sólido (sin transparencia) si planeas publicar en iOS App Store

### 2. Instalar dependencias

```bash
fvm flutter pub get
```

### 3. Generar iconos

```bash
fvm flutter pub run flutter_launcher_icons
```

### 4. Copiar icono para Linux (manual)

```bash
cp assets/images/icon.png linux/flutter/launcher_icon.png
```

### 5. Verificar los cambios

Revisa que los iconos se generaron correctamente:

```bash
# Android
ls -lh android/app/src/main/res/mipmap-xxxhdpi/

# iOS
ls -lh ios/Runner/Assets.xcassets/AppIcon.appiconset/

# Web
ls -lh web/icons/

# Windows
ls -lh windows/runner/resources/

# macOS
ls -lh macos/Runner/Assets.xcassets/AppIcon.appiconset/

# Linux
ls -lh linux/flutter/launcher_icon.png
```

### 6. Limpiar y reconstruir

```bash
fvm flutter clean
fvm flutter pub get
fvm flutter run -d <platform>
```

## 📋 Checklist de Verificación

Después de regenerar los iconos, verifica lo siguiente:

- [ ] **Android**: El icono aparece en el launcher y en configuración de apps
- [ ] **iOS**: El icono aparece en el home screen y en la App Store (si aplica)
- [ ] **Web**: El icono aparece en la pestaña del navegador y como PWA
- [ ] **Windows**: El icono aparece en el ejecutable y en la barra de tareas
- [ ] **macOS**: El icono aparece en el Dock y en el Finder
- [ ] **Linux**: El icono aparece en el launcher del sistema

## 🎨 Recomendaciones de Diseño

### Para el icono principal:
- **Resolución ideal**: 1024x1024px (se escala automáticamente)
- **Formato**: PNG de 32 bits
- **Diseño**: Simple y reconocible a tamaños pequeños
- **Padding**: Dejar 10-15% de margen en los bordes
- **Fondo**: Sólido para iOS, puede tener transparencia para otras plataformas

### Para Android Adaptive Icon:
- **Foreground**: Tu logo principal con transparencia
- **Background**: Color sólido o patrón simple
- **Safe zone**: El logo debe estar en el centro, considerando que los bordes pueden cortarse
- **Tamaño recomendado**: 432x432px para foreground, dentro de un área de 1024x1024px

### Para iOS:
- **Sin transparencia**: El fondo debe ser sólido
- **Sin esquinas redondeadas**: iOS las agrega automáticamente
- **Sin efectos**: Evita sombras y brillos (iOS puede agregar sus propios efectos)

## 🔧 Solución de Problemas

### El icono no aparece después de instalar

**Problema**: En Android, el icono antiguo sigue apareciendo

**Solución**:
```bash
# Desinstala la app completamente
adb uninstall com.example.forsaken

# Limpia y reconstruye
fvm flutter clean
fvm flutter pub get
fvm flutter run
```

### Error en iOS sobre canal alpha

**Problema**: Warning sobre canal alpha al generar iconos

**Solución 1 - Automática**:
```yaml
flutter_launcher_icons:
  remove_alpha_ios: true
```

**Solución 2 - Manual**:
Edita el icono para remover la transparencia usando GIMP, Photoshop, o cualquier editor de imágenes.

### Icono borroso en algunas plataformas

**Problema**: El icono se ve pixelado o borroso

**Solución**: Usa un icono fuente de mayor resolución (mínimo 1024x1024px)

## 📚 Recursos Adicionales

- [flutter_launcher_icons en pub.dev](https://pub.dev/packages/flutter_launcher_icons)
- [Guías de iconos de Android](https://developer.android.com/guide/practices/ui_guidelines/icon_design_launcher)
- [Guías de iconos de iOS](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Generador de Adaptive Icons](https://adapticon.tooo.io/)
- [Herramienta de diseño de iconos](https://appicon.co/)

## 📝 Notas

- Los iconos se regeneran cada vez que ejecutas `flutter pub run flutter_launcher_icons`
- Los iconos generados están en `.gitignore` por defecto (depende de tu configuración)
- Para apps en producción, considera usar iconos optimizados y comprimidos
- El icono de Linux puede necesitar configuración adicional en el archivo `.desktop`

---

**Última actualización**: 9 de Enero, 2026
**Herramienta**: flutter_launcher_icons v0.14.4
