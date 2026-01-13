# 🎮 Guía de Debugging del Mando

## 🚀 Acceso Rápido a la Herramienta de Debug

1. Ejecuta la aplicación:
   ```bash
   fvm flutter run -d linux
   ```

2. Navega a: **Settings → Gamepad Test & Debug**

3. Verás una pantalla con información en tiempo real del mando

---

## 📊 Qué Información Muestra la Pantalla de Debug

### 1. **Connection Status** (Estado de Conexión)
- ✅ Verde: Mando conectado
- ❌ Gris: No hay mando conectado

### 2. **Last Action** (Última Acción)
- Muestra la última función detectada (ej: "A (Select)", "B (Back)")
- Se ilumina en azul durante 2 segundos
- **USO:** Te dice qué función se activó, no solo el botón físico

### 3. **Button Function Tests** (Test de Funciones)
- Lista todas las funciones del gamepad:
  - A (Select)
  - B (Back)
  - X (Search)
  - Y (Help)
  - LB (Page Down)
  - RB (Page Up)
  - Start
  - Select/Back
  - RS Click (View Toggle)
  - LT (Left Trigger)
  - RT (Right Trigger)
- Círculo verde = función activa
- **USO:** Verifica si las funciones (`isSelectPressed()`, etc.) funcionan correctamente

### 4. **Raw Button States** (Estados de Botones Crudos)
- Muestra TODOS los botones que el sistema detecta
- Formato: `Button X: PRESSED` o `Button X: released`
- **USO:** Identifica los IDs reales de tu mando

### 5. **Axis Values (Raw)** (Valores de Ejes Crudos)
- Muestra todos los ejes analógicos con sus valores
- Rango: -1.000 a +1.000
- Barra de progreso visual
- Color:
  - 🟢 Verde: >0.3 (fuera del deadzone)
  - 🟡 Amarillo: 0.1-0.3
  - ⚪ Gris: <0.1 (dentro del deadzone)
- **USO:** Verifica que los sticks y triggers funcionen

### 6. **Navigation Test** (Test de Navegación)
- Muestra flechas direccionales (↑ ↓ ← →)
- Se iluminan en verde cuando detecta movimiento
- Texto grande: "Direction: UP/DOWN/LEFT/RIGHT"
- **USO:** Verifica que `getNavigationDirection()` funcione

---

## 🔍 Cómo Debuggear Problemas Comunes

### Problema 1: "El botón A no selecciona"

**Paso 1:** Ve a la sección "Raw Button States"

**Paso 2:** Presiona el botón A físico en tu mando

**Paso 3:** Observa qué botón se ilumina. Ejemplo:
```
Button 0: PRESSED    ← Este es el botón A
Button 1: released
Button 2: released
```

**Paso 4:** Ve a la sección "Button Function Tests"

**Paso 5:** Verifica si "A (Select)" se ilumina

**Si NO se ilumina:**
- El mapeo está mal
- Abre `lib/services/gamepad_service.dart`
- Busca: `static const String buttonA = '0';`
- Cámbialo por el ID que viste en Raw Button States

---

### Problema 2: "El stick izquierdo no navega"

**Paso 1:** Ve a "Axis Values (Raw)"

**Paso 2:** Mueve el stick izquierdo en todas direcciones

**Paso 3:** Observa qué ejes cambian:
```
Axis 0:  0.850  [█████████████      ]  ← Stick izquierdo horizontal
Axis 1: -0.920  [███                ]  ← Stick izquierdo vertical
Axis 2:  0.000  [        █         ]
```

**Paso 4:** Ve a "Navigation Test"

**Paso 5:** Verifica si las flechas se iluminan

**Si NO se iluminan:**
- El mapeo de ejes está mal
- Abre `lib/services/gamepad_service.dart`
- Busca:
  ```dart
  static const String axisLeftX = '0';
  static const String axisLeftY = '1';
  ```
- Ajusta los números según lo que observaste

---

### Problema 3: "El D-pad no funciona"

**Paso 1:** Ve a "Axis Values (Raw)"

**Paso 2:** Presiona cada dirección del D-pad

**Paso 3:** Observa qué ejes cambian:
```
D-pad arriba:
Axis 6:  0.000
Axis 7: -1.000  ← D-pad vertical

D-pad derecha:
Axis 6:  1.000  ← D-pad horizontal
Axis 7:  0.000
```

**Si los ejes 6 y 7 NO cambian:**
- Tu mando usa ejes diferentes
- Anota cuáles cambian
- Abre `lib/services/gamepad_service.dart`
- Busca:
  ```dart
  static const String axisDpadX = '6';
  static const String axisDpadY = '7';
  ```
- Ajusta según tus observaciones

---

### Problema 4: "Los botones hacen acciones incorrectas"

**Ejemplo:** Presiono A y se activa "B (Back)" en lugar de "A (Select)"

**Paso 1:** Ve a "Raw Button States" y presiona cada botón físico

**Paso 2:** Anota el mapeo real:
```
Botón físico A  → Button 0
Botón físico B  → Button 1
Botón físico X  → Button 3  ← DIFERENTE!
Botón físico Y  → Button 2  ← DIFERENTE!
```

**Paso 3:** Compara con el mapeo actual en `gamepad_service.dart`:
```dart
static const String buttonA = '0';  // ✅ Correcto
static const String buttonB = '1';  // ✅ Correcto
static const String buttonX = '2';  // ❌ Debería ser '3'
static const String buttonY = '3';  // ❌ Debería ser '2'
```

**Paso 4:** Corrige el mapeo

---

### Problema 5: "Los triggers no funcionan"

**Paso 1:** Ve a "Axis Values"

**Paso 2:** Presiona LT (trigger izquierdo) completamente

**Paso 3:** Observa qué eje cambia y su rango:
```
Axis 2:  0.950  ← Trigger izquierdo (va de -1 a +1)
o
Axis 2:  0.950  ← Trigger izquierdo (va de 0 a +1)
```

**Paso 4:** Verifica en "Button Function Tests" si "LT (Left Trigger)" se activa

**Si NO se activa:**
- Problema 1: Eje incorrecto
  ```dart
  static const String axisLT = '2';  // Cambia este número
  ```
  
- Problema 2: Umbral incorrecto en `isLeftTriggerPressed()`:
  ```dart
  bool isLeftTriggerPressed() {
    return getAxisValue(axisLT) > 0.5;  // Ajusta el 0.5
  }
  ```

---

## 📝 Plantilla para Reportar Problemas

Copia esto y completa con tus resultados de la pantalla de debug:

```markdown
### Mi Configuración de Mando

**Modelo:** [ej: Xbox 360 Controller]

**Raw Button States cuando presiono:**
- Botón A físico → Button [?]
- Botón B físico → Button [?]
- Botón X físico → Button [?]
- Botón Y físico → Button [?]
- LB físico → Button [?]
- RB físico → Button [?]
- Start físico → Button [?]
- Select/Back físico → Button [?]
- RS Click físico → Button [?]

**Axis Values cuando muevo:**
- Stick Izq. Horizontal → Axis [?] (rango: [?] a [?])
- Stick Izq. Vertical → Axis [?] (rango: [?] a [?])
- Stick Der. Horizontal → Axis [?] (rango: [?] a [?])
- Stick Der. Vertical → Axis [?] (rango: [?] a [?])
- Trigger Izq. (LT) → Axis [?] (rango: [?] a [?])
- Trigger Der. (RT) → Axis [?] (rango: [?] a [?])
- D-pad Horizontal → Axis [?] (rango: [?] a [?])
- D-pad Vertical → Axis [?] (rango: [?] a [?])

**Qué NO funciona:**
- [Describe el problema específico]

**Button Function Tests - Qué se ilumina:**
- Presiono A → Se ilumina: [?]
- Presiono B → Se ilumina: [?]
- etc.
```

---

## 🛠️ Mapeo Personalizado

Una vez que tengas tu mapeo correcto, edita:

**Archivo:** `lib/services/gamepad_service.dart`

**Líneas ~153-182:**

```dart
/// MAPEO PERSONALIZADO PARA [TU MANDO]
static const String buttonA = 'X';      // Reemplaza X con tu ID
static const String buttonB = 'X';
static const String buttonX = 'X';
static const String buttonY = 'X';
static const String buttonLB = 'X';
static const String buttonRB = 'X';
static const String buttonSelect = 'X';
static const String buttonStart = 'X';
static const String buttonGuide = 'X';
static const String buttonLS = 'X';
static const String buttonRS = 'X';

// Ejes
static const String axisLeftX = 'X';
static const String axisLeftY = 'X';
static const String axisRightX = 'X';
static const String axisRightY = 'X';
static const String axisLT = 'X';
static const String axisRT = 'X';
static const String axisDpadX = 'X';
static const String axisDpadY = 'X';
```

**Guarda y ejecuta:**
```bash
fvm flutter run -d linux
```

---

## 💡 Tips Adicionales

### Deadzone (Zona Muerta)
Si el stick "deriva" (se mueve solo):
```dart
// En gamepad_service.dart línea ~20
static const double deadzone = 0.3;  // Aumenta a 0.4 o 0.5
```

### Debounce (Anti-rebote)
Si la navegación es demasiado rápida:
```dart
// En gamepad_service.dart línea ~24
static const Duration dpadDebounce = Duration(milliseconds: 150);  // Aumenta a 200 o 250
```

### Invertir Ejes
Si arriba/abajo o izquierda/derecha están invertidos, en `getNavigationDirection()`:
```dart
// Cambiar signos:
if (leftY < -deadzone) return 'down';  // Era 'up'
if (leftY > deadzone) return 'up';      // Era 'down'
```

---

## 🎯 Mandos Soportados (Contribuciones)

Cuando tengas tu mapeo funcionando, compártelo para agregarlo a `CONTROLS.md`:

```markdown
### [Nombre del Mando]
- Botón A → ID: X
- Botón B → ID: X
- [etc...]
```

---

**¡Con esta herramienta puedes debuggear cualquier mando en minutos!** 🎮✨
