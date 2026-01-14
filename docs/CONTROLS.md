# 🎮 Forsaken Emulator - Controles y Atajos

Este documento detalla todos los controles disponibles en Forsaken Emulator, tanto para teclado como para mandos de juego.

---

## ⌨️ ATAJOS DE TECLADO

### 🏠 Pantalla de Plataformas

#### Navegación
| Tecla | Acción |
|-------|--------|
| `↑` `↓` `←` `→` | Navegar entre plataformas |
| `Home` | Ir a la primera plataforma |
| `End` | Ir a la última plataforma |
| `Page Up` | Avanzar una página |
| `Page Down` | Retroceder una página |
| `Shift` + `A-Z` | Saltar a plataforma que empiece con esa letra |
| `Shift` + `0-9` | Saltar a plataforma que empiece con ese número |

#### Acciones
| Tecla | Acción |
|-------|--------|
| `Enter` / `Space` | Seleccionar plataforma |
| `Escape` | Salir de la aplicación (con confirmación) |
| `V` | Cambiar modo de vista (Grid ↔ Carousel) |
| `Shift` + `?` | Mostrar ayuda |

---

### 🎯 Pantalla de ROMs

#### Navegación
| Tecla | Acción |
|-------|--------|
| `↑` `↓` | Navegar arriba/abajo (List/Grid) |
| `←` `→` | Navegar izquierda/derecha (Grid/Carousel) |
| `Home` | Ir al primer ROM |
| `End` | Ir al último ROM |
| `Page Up` | Avanzar una página |
| `Page Down` | Retroceder una página |
| `Shift` + `A-Z` | Saltar a ROM que empiece con esa letra |
| `Shift` + `0-9` | Saltar a ROM que empiece con ese número |

#### Acciones Principales
| Tecla | Acción |
|-------|--------|
| `Enter` / `Space` | Lanzar ROM seleccionado |
| `Escape` | Volver a pantalla de plataformas |
| `S` | Abrir búsqueda/filtro |
| `Escape` (en búsqueda) | Cerrar búsqueda |
| `V` | Cambiar modo de vista (List ↔ Grid ↔ Carousel) |
| `R` | Refrescar lista de ROMs |
| `Shift` + `?` | Mostrar ayuda |

#### Navegación de Plataformas (desde ROMs)
| Tecla | Acción |
|-------|--------|
| `Alt` + `←` | Plataforma anterior |
| `Alt` + `→` | Plataforma siguiente |

#### Acciones sobre ROM Seleccionado
| Tecla | Acción |
|-------|--------|
| `I` | Ver información del ROM |
| `F` | Agregar/quitar de favoritos |
| `Delete` | Eliminar ROM descargado |

---

### 📄 Visor de PDF (Manuales)

#### Navegación
| Tecla | Acción |
|-------|--------|
| `↑` / `Page Up` | Página anterior |
| `↓` / `Page Down` | Página siguiente |
| `Home` | Primera página |
| `End` | Última página |

#### Zoom
| Tecla | Acción |
|-------|--------|
| `+` / `=` | Aumentar zoom |
| `-` | Reducir zoom |
| `0` | Restablecer zoom |

#### Cerrar
| Tecla | Acción |
|-------|--------|
| `Escape` / `Q` | Cerrar visor de PDF |

---

### 🖼️ Visor de Imágenes (Capturas/Boxart)

| Tecla | Acción |
|-------|--------|
| `Escape` / `Q` | Cerrar visor |
| `←` | Imagen anterior |
| `→` | Imagen siguiente |
| Scroll del mouse | Zoom in/out |

---

## 🎮 CONTROLES DE MANDO (Xbox Controller)

### Mapeo de Botones Xbox

El siguiente mapeo está diseñado para mandos Xbox (360/One/Series) en Linux:

```
Físico          ID    Uso Principal
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Botón A         0     Seleccionar/Confirmar
Botón B         1     Volver/Cancelar
Botón X         2     Búsqueda/Acción especial
Botón Y         3     Ayuda
LB (L1)         4     Página abajo
RB (R1)         5     Página arriba
Select/Back     6     Ajustes
Start           7     Menú/Pausa
Xbox/Guide      8     (Sin uso)
LS Click        9     (Reservado)
RS Click        10    Cambiar vista
```

### Ejes Analógicos y Triggers

```
Control              ID    Rango          Uso
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Stick Izq. X         0     -1.0 a +1.0    Navegación H
Stick Izq. Y         1     -1.0 a +1.0    Navegación V
Trigger Izq. (LT)    2     -1.0 a +1.0    Zoom Out (PDF)
Stick Der. X         3     -1.0 a +1.0    (Sin uso)
Stick Der. Y         4     -1.0 a +1.0    (Sin uso)
Trigger Der. (RT)    5     -1.0 a +1.0    Zoom In (PDF)
D-pad X              6     -1.0 a +1.0    Navegación H
D-pad Y              7     -1.0 a +1.0    Navegación V
```

### 🏠 Pantalla de Plataformas (Mando)

#### Navegación
| Control | Acción |
|---------|--------|
| Stick Izq. / D-pad | Navegar entre plataformas |
| LB | Página abajo |
| RB | Página arriba |

#### Acciones
| Control | Acción |
|---------|--------|
| A | Seleccionar plataforma |
| B | Salir de la aplicación (con confirmación) |
| Y | Cambiar modo de vista |
| X | Mostrar ayuda |
| RS Click | Cambiar modo de vista (alternativo) |

---

### 🎯 Pantalla de ROMs (Mando)

#### Navegación
| Control | Acción |
|---------|--------|
| Stick Izq. / D-pad | Navegar entre ROMs |
| LB | Página abajo |
| RB | Página arriba |

#### Acciones
| Control | Acción |
|---------|--------|
| A | Lanzar ROM seleccionado |
| B | Volver a pantalla de plataformas |
| X | Abrir búsqueda |
| Y | Mostrar ayuda |
| RS Click | Cambiar modo de vista |

**⚠️ Nota sobre Modo Búsqueda:**
- Durante la búsqueda, usa el **teclado** para escribir
- Presiona **Ⓑ (B button)** o **ESC** para salir del modo búsqueda
- Los demás botones del mando están deshabilitados durante la búsqueda
- El fondo NO se mueve con el mando mientras buscas

---

### 📄 Visor de PDF (Mando)

#### Navegación
| Control | Acción |
|---------|--------|
| D-pad ↑ / Stick Izq. ↑ | Página anterior |
| D-pad ↓ / Stick Izq. ↓ | Página siguiente |
| LB | Última página |
| RB | Primera página |

#### Zoom
| Control | Acción |
|---------|--------|
| LT (Trigger Izq.) | Reducir zoom |
| RT (Trigger Der.) | Aumentar zoom |
| X | Restablecer zoom |

#### Cerrar
| Control | Acción |
|---------|--------|
| B | Cerrar visor de PDF |

---

### 💬 Diálogos con Soporte de Mando

Todos los diálogos principales soportan navegación con mando y muestran indicadores visuales:

#### Diálogos Implementados (✅)

| Diálogo | Gamepad | Teclado | Blur/Focus | Indicadores |
|---------|---------|---------|------------|-------------|
| **Ayuda (Help)** | Ⓐ/Ⓑ Cerrar | ESC/Enter | ✅ | Ⓐ verde, Ⓑ rojo |
| **Detalle de ROM** | Ⓐ Jugar, Ⓑ Cerrar, D-pad navegar | Enter/ESC | ✅ | Ⓐ verde, Ⓑ rojo |
| **Guardar ROM** | Ⓐ Guardar, Ⓑ Cancelar | Enter/ESC | ✅ | Ⓐ verde, Ⓑ rojo |
| **Selección Emulador** | Ⓐ Seleccionar, Ⓑ Cancelar, D-pad lista | Enter/ESC | ✅ | Ⓐ verde, Ⓑ rojo |

**Características especiales de los diálogos implementados:**
- 🔒 **Focus trap:** Los diálogos capturan todo el input (el fondo NO responde)
- 🌫️ **Blur effect:** El fondo se difumina (5px gaussian blur) cuando un diálogo está abierto
- 🎯 **Auto-focus:** El botón principal recibe foco automáticamente al abrir
- ⏸️ **Polling pausado:** Las pantallas de fondo pausan su polling de mando
- 🎮 **Edge detection:** Los botones no se repiten si mantienes presionado

#### Diálogos Pendientes (❌ Sin gamepad implementado)

| Diálogo | Teclado | Blur | Notas |
|---------|---------|------|-------|
| **Info de Plataforma** | ESC cierra | ❌ | Falta: Ⓑ cerrar, blur background |
| **Error Dialog** | ESC cierra | ❌ | Falta: Ⓐ/Ⓑ botones, blur background |
| **Launch Progress** | Click Cancel | ❌ | Falta: Ⓑ cancelar descarga, blur |

**Próximos pasos para diálogos pendientes:**
1. Añadir blur + focus trap (patrón estándar)
2. Añadir polling de gamepad (50ms timer)
3. Mapear botones Ⓐ/Ⓑ según acción
4. Añadir indicadores visuales en botones

---

### 🖼️ Visores Especiales

#### Visor de Imágenes en Pantalla Completa

**Actualmente implementado:**
| Control | Acción |
|---------|--------|
| ESC / Q | Cerrar visor |
| ← → | Imagen anterior/siguiente |
| Scroll mouse | Zoom in/out |

**Pendiente (❌):**
| Control | Acción Planeada |
|---------|-----------------|
| Ⓑ | Cerrar visor |
| D-pad / Stick Izq. | Navegar imágenes (←/→) |

**Archivo:** `lib/widgets/roms/fullscreen_image_viewer.dart` (líneas 53-88)

#### Reproductor de Video

**Estado actual:** ❌ Sin controles de teclado ni gamepad

**Pendiente:**

Teclado:
- `Space` / `Enter` → Play/Pause
- `ESC` / `Q` → Cerrar
- `←` / `→` → Retroceder/Avanzar (si soportado)

Gamepad:
- Ⓐ → Play/Pause
- Ⓑ → Cerrar
- Stick Izq. ←/→ → Seek (si soportado)

**Archivo:** `lib/widgets/roms/video_player_screen.dart`

---

### ⚙️ Pantallas de Configuración

Todas las pantallas de Settings tienen soporte parcial:

**Actualmente implementado:**
- ✅ Teclado: `ESC` vuelve atrás en todas las pantallas

**Pendiente (❌ Gamepad):**
- Settings Screen principal (8 categorías)
- System Paths Screen
- ROM Storage Management Screen
- Emulator Management Screen
- ROM Database Screen
- Download Manager Screen
- System Check Screen
- System Utilities Screen

**Gamepad planeado:**
- Ⓑ → Volver atrás (Navigator.pop)
- D-pad / Stick Izq. → Navegar lista de opciones
- Ⓐ → Seleccionar item / Acción principal

**Prioridad:** BAJA (settings son infrecuentes, teclado disponible)

---

## 🎨 Indicadores Visuales

### Botones de Mando en Diálogos

Los diálogos implementados muestran indicadores visuales para guiar al jugador:

| Indicador | Color | Significado | Ejemplos |
|-----------|-------|-------------|----------|
| Ⓐ | 🟢 Verde | Acción principal (confirmar) | Jugar, Guardar, Aceptar, Seleccionar |
| Ⓑ | 🔴 Rojo | Acción secundaria (cancelar) | Cerrar, Volver, Cancelar |

### Efectos de Focus & Blur

Cuando un diálogo está abierto (solo en diálogos implementados):
- 🌫️ **Blur background:** El fondo se difumina con gaussian blur de 5px
- 🔒 **Barrier:** `barrierDismissible: false` + `barrierColor: Colors.black.withValues(alpha: 0.7)`
- 🎯 **Focus trap:** El diálogo usa `Focus(autofocus: true)` para capturar todo el input
- 🚫 **Background inactivo:** Las pantallas de fondo NO responden a input del mando
- ⏸️ **Polling management:** Pantalla padre pausa polling antes de mostrar diálogo

**Implementación técnica:**
```dart
// En el método show() del diálogo:
showDialog(
  barrierDismissible: false,
  barrierColor: Colors.black.withValues(alpha: 0.7),
  builder: (context) => BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    child: MiDialogo(...),
  ),
);

// En build() del diálogo:
Widget build(BuildContext context) {
  return Focus(
    autofocus: true,
    child: Dialog(...),
  );
}
```

---

## 🧪 Pantalla de Debug del Gamepad

Una herramienta especializada para probar y diagnosticar el mando.

**Acceso:** Settings → Gamepad Test & Debug

#### Características
- **Estado de Conexión:** Indicador visual si el mando está conectado
- **Última Acción:** Muestra el último botón detectado (2 segundos)
- **Test de Funciones:** Indicadores en tiempo real de todas las funciones mapeadas
- **Estados Raw:** Muestra los IDs reales de los botones cuando se presionan
- **Valores de Ejes:** Visualización en tiempo real con barras de progreso
- **Test de Navegación:** D-pad visual que se ilumina según la dirección

#### Importante
- **⚠️ Las acciones están desactivadas** en esta pantalla (solo visualización)
- No lanzará ayuda, búsqueda, back, etc. al presionar botones
- Es un entorno seguro para probar sin efectos secundarios

#### Salir de la Pantalla de Debug
| Control | Acción |
|---------|--------|
| **Start + Select** juntos | Volver al menú de Settings |

**Nota:** Debes presionar ambos botones simultáneamente durante ~50ms para salir.

---

## ⚙️ Configuración Técnica

### Deadzone del Stick Analógico
- **Valor:** 0.3 (30% del rango total)
- **Explicación:** Movimientos menores al 30% no se registran (evita drift)

### Debounce de Navegación
- **Valor:** 150ms
- **Explicación:** Tiempo mínimo entre movimientos de navegación

### Polling Rate del Gamepad
- **Valor:** 50ms (20 veces por segundo)
- **Ubicación:** `GamepadService` y todas las pantallas/diálogos con soporte de mando

### Normalización de Valores
Los valores brutos del joystick en Linux (-32768 a 32767) se normalizan automáticamente a -1.0 a +1.0 para facilitar el manejo.

---

## 🔧 Resolución de Problemas

### Mando no detectado

1. **Verificar que el mando esté conectado:**
   ```bash
   ls -la /dev/input/js*
   ```
   Deberías ver algo como `/dev/input/js0`

2. **Verificar permisos:**
   ```bash
   groups $USER
   ```
   El usuario debe estar en el grupo `input`. Si no:
   ```bash
   sudo usermod -a -G input $USER
   ```
   Luego cierra sesión y vuelve a entrar.

3. **Probar el mando con jstest:**
   ```bash
   jstest /dev/input/js0
   ```

### Botones no funcionan correctamente

Los botones y ejes están mapeados específicamente para mandos Xbox en Linux. Si usas otro tipo de mando (PlayStation, Nintendo Switch Pro, genérico), los índices pueden ser diferentes.

**Logs de diagnóstico:**
La aplicación registra todos los eventos de botones y ejes:
```
[GamepadService] 🎮 Button pressed: "0" (value: 1.0)
[GamepadService] 🕹️ Analog axis: "0" = 0.85 (raw: 27852)
```

Revisa estos logs para identificar qué ID tiene cada botón en tu mando y repórtalo para agregar soporte.

### El stick analógico "deriva" (drift)

Ajusta el deadzone en `lib/services/gamepad_service.dart`:
```dart
static const double deadzone = 0.3; // Aumentar si hay drift
```

---

## 🎯 Diferencias entre Mandos

### Xbox 360 / Xbox One / Xbox Series
✅ **Totalmente soportado** - Mapeo actual

### PlayStation 4 / PlayStation 5
⚠️ **Puede requerir ajustes** - IDs de botones pueden diferir

### Nintendo Switch Pro Controller
⚠️ **Puede requerir ajustes** - Diseño de botones diferente (A/B invertidos)

### Mandos Genéricos
⚠️ **Puede requerir ajustes** - Depende del driver y mapeo del SO

---

## 📝 Notas de Desarrollo

### Archivos Relevantes

- **GamepadService:** `lib/services/gamepad_service.dart`
- **Manejo en Platforms:** `lib/screens/platforms_screen.dart` (línea ~124)
- **Manejo en ROMs:** `lib/screens/roms_screen.dart` (línea ~168)
- **Manejo en PDF:** `lib/screens/pdf_viewer_screen.dart`

### Agregar Soporte para Nuevo Mando

1. Obtener logs de eventos de botones y ejes
2. Crear nuevo mapeo de constantes en `GamepadService`
3. Detectar tipo de mando en `initialize()`
4. Aplicar mapeo correspondiente

---

## 🎊 Características Destacadas

- ✅ Soporte completo para navegación con teclado
- ✅ Soporte completo para mando Xbox en Linux
- ✅ Detección automática de gamepad con edge detection
- ✅ Notificación visual cuando se conecta un mando
- ✅ Debounce y deadzone configurables
- ✅ Modos de vista múltiples (List, Grid, Carousel)
- ✅ Navegación alfabética y numérica instantánea
- ✅ Soporte para múltiples plataformas simultáneamente
- ✅ Sistema de focus trap para diálogos (sin handler overlap)
- ✅ Blur automático de fondo en diálogos importantes
- ✅ Indicadores visuales Ⓐ/Ⓑ en diálogos
- ✅ Polling management (pausa/resume al navegar)

---

## 📊 Estado de Implementación por Componente

### Pantallas Principales

| Pantalla | Keyboard | Gamepad | Estado |
|----------|----------|---------|--------|
| Platforms Screen | ✅ | ✅ | 🟢 Completo |
| ROMs Screen | ✅ | ✅ | 🟢 Completo |
| PDF Viewer | ✅ | ✅ | 🟢 Completo |
| Gamepad Test Screen | N/A | ✅ | 🟢 Completo (debug) |
| Settings Screen | ✅ ESC | ❌ | 🟡 Parcial |
| System Paths | ✅ ESC | ❌ | 🟡 Parcial |
| ROM Storage Mgmt | ✅ ESC | ❌ | 🟡 Parcial |
| Emulator Mgmt | ✅ ESC | ❌ | 🟡 Parcial |
| ROM Database | ✅ ESC | ❌ | 🟡 Parcial |
| Download Manager | ✅ ESC | ❌ | 🟡 Parcial |
| System Check | ✅ ESC | ❌ | 🟡 Parcial |
| System Utilities | ✅ ESC | ❌ | 🟡 Parcial |

### Diálogos

| Diálogo | Keyboard | Gamepad | Blur/Focus | Estado |
|---------|----------|---------|------------|--------|
| Help Dialog | ✅ | ✅ Ⓐ/Ⓑ | ✅ | 🟢 Completo |
| ROM Detail | ✅ | ✅ Ⓐ/Ⓑ/D-pad | ✅ | 🟢 Completo |
| Save ROM | ✅ | ✅ Ⓐ/Ⓑ | ✅ | 🟢 Completo |
| Emulator Selection | ✅ | ✅ Ⓐ/Ⓑ/D-pad | ✅ | 🟢 Completo |
| Platform Info | ✅ ESC | ❌ | ❌ | 🔴 Incompleto |
| Error Dialog | ✅ ESC | ❌ | ❌ | 🔴 Incompleto |
| Launch Progress | Mouse | ❌ | ❌ | 🔴 Incompleto |

### Visores Especiales

| Componente | Keyboard | Gamepad | Estado |
|------------|----------|---------|--------|
| Fullscreen Image | ✅ ESC/Q/arrows | ❌ | 🔴 Incompleto |
| Video Player | ❌ | ❌ | 🔴 Incompleto |

---

## 🎯 Roadmap de Implementación

### Fase 1: Diálogos Críticos (ALTA PRIORIDAD)

**Objetivo:** Todos los diálogos con blur + gamepad

**Tareas:**
1. ✅ Help Dialog - COMPLETADO
2. ✅ ROM Detail Dialog - COMPLETADO
3. ✅ Save ROM Dialog - COMPLETADO
4. ✅ Emulator Selection Dialog - COMPLETADO
5. ❌ Platform Info Dialog - **PENDIENTE**
   - Añadir blur/focus trap
   - Añadir Ⓑ para cerrar
   - Archivo: `lib/widgets/platforms/platform_info_dialog.dart`
6. ❌ Error Dialog - **PENDIENTE**
   - Añadir blur/focus trap
   - Añadir Ⓐ/Ⓑ según botones disponibles
   - Archivo: `lib/widgets/common/error_dialog.dart`
7. ❌ Launch Progress Dialog - **PENDIENTE** (opcional)
   - Añadir blur
   - Añadir Ⓑ para cancelar descarga
   - Archivo: `lib/widgets/roms/launch_progress_dialog.dart`

**Tiempo estimado:** ~30 minutos

### Fase 2: Visores de Media (MEDIA PRIORIDAD)

**Objetivo:** Navegación completa con gamepad en visores

**Tareas:**
1. ❌ Fullscreen Image Viewer - **PENDIENTE**
   - Añadir polling de gamepad (50ms)
   - Añadir D-pad/Stick navegación (←/→)
   - Añadir Ⓑ para cerrar
   - Archivo: `lib/widgets/roms/fullscreen_image_viewer.dart`
2. ❌ Video Player Screen - **PENDIENTE**
   - Añadir controles de teclado (Space/ESC/arrows)
   - Añadir controles de gamepad (Ⓐ play/pause, Ⓑ cerrar)
   - Archivo: `lib/widgets/roms/video_player_screen.dart`

**Tiempo estimado:** ~45 minutos

### Fase 3: Settings Navigation (BAJA PRIORIDAD)

**Objetivo:** Gamepad en pantallas de configuración

**Tareas:**
1. ❌ Settings Screen - **PENDIENTE**
   - Añadir polling de gamepad
   - Añadir Ⓑ para volver
   - Añadir D-pad para navegar lista
   - Añadir Ⓐ para seleccionar
2. ❌ Todas las Settings Categories (7 pantallas) - **PENDIENTE**
   - Mismo patrón que Settings Screen
   - Ⓑ para volver en todas

**Tiempo estimado:** ~60 minutos

**Justificación de baja prioridad:**
- Settings son infrecuentes
- Teclado siempre disponible en desktop
- Usuarios no necesitan gamepad para configurar

---

## 🐛 Problemas Conocidos Resueltos

### ✅ Handler Overlap (RESUELTO)
**Problema:** Múltiples pantallas recibían input de gamepad simultáneamente  
**Solución:** Polling pause/resume al navegar entre pantallas  
**Commit:** [referencia commit reciente]  
**Archivos:** `platforms_screen.dart`, `roms_screen.dart`

### ✅ Búsqueda + Gamepad Conflict (RESUELTO)
**Problema:** Gamepad navegaba el fondo mientras se escribía en búsqueda  
**Solución:** Bloquear todos los botones excepto Ⓑ durante búsqueda  
**Archivo:** `roms_screen.dart` (línea ~300)

### ✅ Duplicate Actions (RESUELTO)
**Problema:** Mantener presionado un botón ejecutaba la acción múltiples veces  
**Solución:** Edge detection system en GamepadService  
**Archivo:** `lib/services/gamepad_service.dart` (línea ~80-120)

### ✅ Dialog Background Response (RESUELTO)
**Problema:** Pantalla de fondo respondía a input con diálogo abierto  
**Solución:** Focus trap + blur + barrierDismissible: false + pausar polling del padre  
**Patrón aplicado:** Help, ROM Detail, Save ROM, Emulator Selection dialogs

---

## 📝 Patrones de Implementación

### Patrón: Diálogo con Gamepad Support

**1. Estructura del StatefulWidget:**
```dart
class MiDialogo extends StatefulWidget {
  // ... constructor
}

class MiDialogoState extends State<MiDialogo> {
  Timer? _gamepadPollTimer;
  final FocusNode _primaryButtonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startGamepadPolling();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _primaryButtonFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    _primaryButtonFocusNode.dispose();
    super.dispose();
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final gamepad = GamepadService.instance;
      
      if (gamepad.isSelectPressed()) {
        _onPrimaryAction(); // Ⓐ button
        gamepad.updatePreviousButtonStates();
      } else if (gamepad.isBackPressed()) {
        Navigator.of(context).pop(); // Ⓑ button
        gamepad.updatePreviousButtonStates();
      }
    });
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: Dialog(
        child: Column(
          children: [
            // ... contenido
            ElevatedButton(
              focusNode: _primaryButtonFocusNode,
              onPressed: _onPrimaryAction,
              child: Row(
                children: [
                  Text('Acción'),
                  if (GamepadService.instance.isGamepadConnected) ...[
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Text('Ⓐ', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**2. Método estático show() con blur:**
```dart
static Future<T?> show<T>(BuildContext context, ...) {
  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: MiDialogo(...),
    ),
  );
}
```

**3. Llamar desde pantalla padre (con pause/resume):**
```dart
Future<void> _showMiDialogo() async {
  _stopGamepadPolling(); // Pausar polling del padre
  
  final result = await MiDialogo.show(context, ...);
  
  if (mounted) {
    _startGamepadPolling(); // Resumir polling del padre
  }
  
  // Procesar resultado...
}
```

### Patrón: Pantalla con Gamepad Support

**1. Estructura básica:**
```dart
class MiPantalla extends StatefulWidget { }

class MiPantallaState extends State<MiPantalla> {
  Timer? _gamepadPollTimer;
  
  @override
  void initState() {
    super.initState();
    _startGamepadPolling();
  }

  @override
  void dispose() {
    _stopGamepadPolling();
    super.dispose();
  }

  void _startGamepadPolling() {
    _gamepadPollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      final gamepad = GamepadService.instance;
      
      // Navegación
      final direction = gamepad.getNavigationDirection();
      if (direction != null) {
        _handleNavigation(direction);
      }
      
      // Acciones
      if (gamepad.isSelectPressed()) {
        _onSelectAction();
        gamepad.updatePreviousButtonStates();
      }
      // ... otros botones
    });
  }

  void _stopGamepadPolling() {
    _gamepadPollTimer?.cancel();
    _gamepadPollTimer = null;
  }

  Future<void> _navigateToChild() async {
    _stopGamepadPolling(); // Pausar antes de navegar
    await Navigator.push(...);
    if (mounted) {
      _startGamepadPolling(); // Resumir al volver
    }
  }
}
```

---

## 🔗 Referencias de Código

### Archivos de Servicio
- **GamepadService:** `lib/services/gamepad_service.dart`
  - Edge detection: líneas ~80-120
  - Navigation direction: líneas ~140-160
  - Debug mode: líneas ~200-220

### Pantallas Implementadas (Referencia)
- **Platforms Screen:** `lib/screens/platforms_screen.dart`
  - Gamepad polling: línea ~124
  - Pause/resume: líneas ~450, ~480
- **ROMs Screen:** `lib/screens/roms_screen.dart`
  - Gamepad polling: línea ~168
  - Search mode blocking: línea ~300
  - Pause/resume: líneas ~550, ~580
- **PDF Viewer:** `lib/screens/pdf_viewer_screen.dart`
  - Gamepad + triggers: líneas ~180-250

### Diálogos Implementados (Referencia)
- **Help Dialog:** `lib/widgets/common/help_dialog.dart`
  - Patrón completo de blur + focus + gamepad
- **ROM Detail Dialog:** `lib/widgets/roms/rom_detail_dialog.dart`
  - Navegación D-pad entre tabs
  - Autofocus en botón Play
- **Save ROM Dialog:** `lib/widgets/roms/save_rom_dialog.dart`
  - Ⓐ Save, Ⓑ Cancel
  - Indicadores visuales
- **Emulator Selection:** `lib/widgets/roms/emulator_selection_dialog.dart`
  - D-pad navigation en lista
  - Ⓐ seleccionar, Ⓑ cancelar

### Diálogos Pendientes (Para Implementar)
- **Platform Info Dialog:** `lib/widgets/platforms/platform_info_dialog.dart`
- **Error Dialog:** `lib/widgets/common/error_dialog.dart`
- **Launch Progress:** `lib/widgets/roms/launch_progress_dialog.dart`

### Visores Pendientes (Para Implementar)
- **Fullscreen Image:** `lib/widgets/roms/fullscreen_image_viewer.dart` (líneas 53-88)
- **Video Player:** `lib/widgets/roms/video_player_screen.dart`

---

**Versión del documento:** 2.0  
**Última actualización:** 2026-01-14  
**Mando probado:** Xbox Controller (Linux)
