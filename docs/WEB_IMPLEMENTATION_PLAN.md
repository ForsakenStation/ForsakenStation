# 🌐 Forsaken Emulator - Plan de Implementación Web

## 📋 Resumen Ejecutivo

Este documento describe la estrategia completa para implementar una versión web de Forsaken Emulator usando EmulatorJS y los cores de RetroArch compilados para WebAssembly, permitiendo ejecutar ROMs directamente en el navegador.

---

## 🎯 Objetivos

### Objetivos Principales
- ✅ Ejecutar ROMs en navegadores web sin instalaciones
- ✅ Mantener compatibilidad con la arquitectura Flutter existente
- ✅ Soporte para múltiples plataformas de emulación
- ✅ Gestión eficiente de assets (cores + ROMs)
- ✅ Experiencia de usuario consistente entre desktop y web

### Objetivos Secundarios
- 🎮 Soporte para gamepads web
- 💾 Persistencia local de configuraciones
- 📱 Diseño responsive para móviles
- 🚀 Carga progresiva de cores
- 🔐 Gestión de derechos de ROMs

---

## 🏗️ Arquitectura Técnica

### Stack Tecnológico
```
Frontend:     Flutter Web + EmulatorJS
Cores:        RetroArch cores compilados a WebAssembly  
Storage:      IndexedDB + File System Access API
Assets:       CDN + Progressive Loading
Audio:        Web Audio API
Input:        Gamepad API + Keyboard Events
```

### Estructura de Componentes
```
lib/
├── platforms/
│   ├── web/                     # Implementaciones específicas web
│   │   ├── web_emulator_service.dart
│   │   ├── web_rom_storage.dart
│   │   ├── emulatorjs_bridge.dart
│   │   └── core_manager.dart
│   └── shared/                  # Código compartido
└── web/                         # Assets y configuración web
    ├── cores/                   # RetroArch cores (.wasm)
    ├── emulatorjs/              # EmulatorJS library
    └── index.html               # Entry point web
```

---

## 📦 Gestión de Cores y Assets

### Estrategia de Cores
```yaml
Cores Incluidos en Assets (Esenciales):
  - gambatte_libretro.wasm      # Game Boy / Game Boy Color
  - snes9x_libretro.wasm        # Super Nintendo
  - genesis_plus_gx.wasm        # Sega Genesis/Mega Drive
  - nestopia_libretro.wasm      # Nintendo Entertainment System
  - vba_next_libretro.wasm      # Game Boy Advance
  - mupen64plus_next.wasm       # Nintendo 64
  - pcsx_rearmed.wasm           # PlayStation 1

Cores Descargables (Opcional):
  - flycast_libretro.wasm       # Sega Dreamcast
  - ppsspp_libretro.wasm        # PlayStation Portable
  - duckstation_libretro.wasm   # PlayStation 1 (alternativo)
  - mgba_libretro.wasm          # Game Boy Advance (alternativo)
```

### Gestión de Assets
```dart
// Estructura propuesta para WebCoreManager
class WebCoreManager {
  static const Map<String, CoreInfo> essentialCores = {
    'gb': CoreInfo(
      filename: 'gambatte_libretro.wasm',
      size: '1.2MB',
      included: true,
      platforms: ['gb', 'gbc'],
    ),
    'snes': CoreInfo(
      filename: 'snes9x_libretro.wasm', 
      size: '2.1MB',
      included: true,
      platforms: ['snes'],
    ),
    // ... más cores
  };
  
  static const Map<String, CoreInfo> downloadableCores = {
    'dreamcast': CoreInfo(
      filename: 'flycast_libretro.wasm',
      size: '8.5MB',
      included: false,
      downloadUrl: 'https://cdn.forsaken.emu/cores/',
      platforms: ['dreamcast'],
    ),
    // ... cores adicionales
  };
}
```

---

## 🔧 Implementación Detallada

### Fase 1: Infraestructura Base (2-3 semanas)

#### 1.1 Configuración EmulatorJS
```javascript
// web/emulatorjs/integration.js
class ForsakenEmulatorJS {
  constructor(containerElement) {
    this.container = containerElement;
    this.emulator = null;
    this.currentCore = null;
  }
  
  async loadCore(coreUrl) {
    return new Promise((resolve, reject) => {
      this.emulator = new EJS_emulator(this.container, {
        core: coreUrl,
        onReady: () => resolve(),
        onError: (error) => reject(error)
      });
    });
  }
  
  async loadRom(romData) {
    if (!this.emulator) throw new Error('Core not loaded');
    return this.emulator.loadRom(romData);
  }
}
```

#### 1.2 Bridge Dart ↔ JavaScript
```dart
// lib/platforms/web/emulatorjs_bridge.dart
@JS('ForsakenEmulatorJS')
class EmulatorJSBridge {
  external EmulatorJSBridge(Element container);
  external Future<void> loadCore(String coreUrl);
  external Future<void> loadRom(Uint8List romData);
  external void pause();
  external void resume();
  external void reset();
}

class WebEmulatorService extends EmulatorServiceBase {
  EmulatorJSBridge? _emulator;
  
  @override
  Future<LaunchResult> launchRom(RomItem rom) async {
    try {
      // 1. Determinar core necesario
      final coreInfo = await _determineCoreForPlatform(rom.platform);
      
      // 2. Cargar core (desde assets o descargar)
      await _ensureCoreAvailable(coreInfo);
      
      // 3. Descargar/cargar ROM
      final romData = await _loadRomData(rom);
      
      // 4. Inicializar emulador
      await _initializeEmulator(coreInfo, romData);
      
      return LaunchResult.success();
    } catch (e) {
      return LaunchResult.error(e.toString());
    }
  }
}
```

#### 1.3 Almacenamiento Web
```dart
// lib/platforms/web/web_rom_storage.dart
class WebRomStorage implements RomStorageInterface {
  static const String _dbName = 'forsaken_emulator_db';
  static const String _romStore = 'roms';
  static const String _coreStore = 'cores';
  
  Future<void> storeRom(String id, Uint8List data) async {
    final db = await _openDatabase();
    final tx = db.transaction(_romStore, 'readwrite');
    await tx.objectStore(_romStore).put({
      'id': id,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  Future<Uint8List?> getRom(String id) async {
    final db = await _openDatabase();
    final result = await db.transaction(_romStore).objectStore(_romStore).get(id);
    return result?['data'] as Uint8List?;
  }
}
```

### Fase 2: Gestión de Cores (1-2 semanas)

#### 2.1 Core Manager
```dart
// lib/platforms/web/core_manager.dart
class WebCoreManager {
  static const String _coresCDN = 'https://cdn.forsaken.emu/cores/';
  
  Future<String> getCoreUrl(String platform) async {
    final coreInfo = _getCoreInfo(platform);
    
    if (coreInfo.included) {
      // Core incluido en assets
      return 'assets/cores/${coreInfo.filename}';
    } else {
      // Core descargable - verificar cache local primero
      final cached = await _getCachedCore(coreInfo.filename);
      if (cached != null) return cached;
      
      // Descargar y cachear
      return await _downloadAndCacheCore(coreInfo);
    }
  }
  
  Future<void> preloadEssentialCores() async {
    final essentials = WebCoreManager.essentialCores.values;
    await Future.wait(
      essentials.map((core) => _preloadCore(core))
    );
  }
}
```

#### 2.2 Progressive Loading UI
```dart
// lib/widgets/web/core_loading_widget.dart
class CoreLoadingWidget extends StatefulWidget {
  final String platform;
  final VoidCallback onLoaded;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CoreLoadingState>(
      stream: _coreManager.getLoadingStream(platform),
      builder: (context, snapshot) {
        final state = snapshot.data ?? CoreLoadingState.initial();
        
        return Column(
          children: [
            Text('Loading ${state.coreName}...'),
            LinearProgressIndicator(value: state.progress),
            Text('${state.downloadedMB} / ${state.totalMB} MB'),
            if (state.isDownloading)
              Text('Downloading core from CDN...'),
            if (state.isInitializing)
              Text('Initializing WebAssembly core...'),
          ],
        );
      },
    );
  }
}
```

### Fase 3: Interfaz Usuario Web (2 semanas)

#### 3.1 Responsive Layout
```dart
// lib/screens/web/web_game_screen.dart
class WebGameScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;
        
        return Scaffold(
          body: isDesktop 
            ? _buildDesktopLayout()
            : _buildMobileLayout(),
        );
      },
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar con controles
        SizedBox(
          width: 250,
          child: GameControlsSidebar(),
        ),
        // Área principal del emulador
        Expanded(
          child: EmulatorContainer(),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Emulador fullscreen
        Expanded(child: EmulatorContainer()),
        // Controles táctiles overlay
        TouchControlsOverlay(),
      ],
    );
  }
}
```

#### 3.2 Controles Táctiles
```dart
// lib/widgets/web/touch_controls.dart
class TouchControlsOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // D-Pad
        Positioned(
          left: 20,
          bottom: 20,
          child: VirtualDPad(
            onDirectionChanged: _handleDPadInput,
          ),
        ),
        // Botones de acción
        Positioned(
          right: 20,
          bottom: 20,
          child: Row(
            children: [
              VirtualButton(
                label: 'A',
                onPressed: () => _sendInput('a'),
              ),
              VirtualButton(
                label: 'B', 
                onPressed: () => _sendInput('b'),
              ),
            ],
          ),
        ),
        // Botones de sistema
        Positioned(
          top: 20,
          right: 20,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: _pauseGame,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: _showSettings,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

### Fase 4: Funcionalidades Avanzadas (3 semanas)

#### 4.1 Save States Web
```dart
// lib/platforms/web/web_save_manager.dart
class WebSaveManager {
  static const String _saveStore = 'save_states';
  
  Future<void> createSaveState(String romId, int slot) async {
    final saveData = await _emulator.createSaveState();
    await _storage.storeSaveState(romId, slot, {
      'data': saveData,
      'screenshot': await _emulator.getScreenshot(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  Future<void> loadSaveState(String romId, int slot) async {
    final saveState = await _storage.getSaveState(romId, slot);
    if (saveState != null) {
      await _emulator.loadSaveState(saveState['data']);
    }
  }
}
```

#### 4.2 Gamepad Support
```dart
// lib/platforms/web/web_gamepad_service.dart
class WebGamepadService {
  StreamSubscription? _gamepadSubscription;
  
  void initialize() {
    // Detectar gamepads conectados
    html.window.addEventListener('gamepadconnected', _onGamepadConnected);
    html.window.addEventListener('gamepaddisconnected', _onGamepadDisconnected);
    
    // Polling de inputs
    _startGamepadPolling();
  }
  
  void _startGamepadPolling() {
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      final gamepads = html.window.navigator.getGamepads();
      for (final gamepad in gamepads) {
        if (gamepad != null) {
          _processGamepadInput(gamepad);
        }
      }
    });
  }
}
```

#### 4.3 Audio/Video Settings
```dart
// lib/widgets/web/web_settings_panel.dart
class WebSettingsPanel extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) => 
            ListTile(title: Text('Video Settings')),
          body: Column(
            children: [
              // Resolución de renderizado
              ListTile(
                title: Text('Rendering Scale'),
                trailing: DropdownButton<int>(
                  value: _renderScale,
                  items: [1, 2, 3, 4].map((scale) =>
                    DropdownMenuItem(
                      value: scale,
                      child: Text('${scale}x'),
                    ),
                  ).toList(),
                  onChanged: _updateRenderScale,
                ),
              ),
              // Filtros
              SwitchListTile(
                title: Text('Smoothing Filter'),
                value: _smoothingEnabled,
                onChanged: _toggleSmoothing,
              ),
            ],
          ),
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) => 
            ListTile(title: Text('Audio Settings')),
          body: Column(
            children: [
              ListTile(
                title: Text('Audio Latency'),
                trailing: Slider(
                  value: _audioLatency,
                  min: 32,
                  max: 512,
                  divisions: 8,
                  onChanged: _updateAudioLatency,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

---

## 📊 Gestión de Assets y Performance

### Estrategia de Carga
```yaml
Bundle Size Optimization:
  Essential Cores: ~15MB (incluidos en build)
  Optional Cores: ~50MB (descarga on-demand)
  EmulatorJS: ~2MB (minificado)
  
Loading Strategy:
  1. App Shell: Instant load
  2. Essential cores: Preload on app start  
  3. Optional cores: Download on first use
  4. ROMs: Stream/cache as needed
```

### Métricas de Performance
```dart
// lib/services/web_performance_monitor.dart
class WebPerformanceMonitor {
  void trackCoreLoadTime(String core, Duration loadTime) {
    analytics.track('core_load_time', {
      'core': core,
      'load_time_ms': loadTime.inMilliseconds,
      'browser': _getBrowserInfo(),
    });
  }
  
  void trackFrameRate(double fps) {
    if (fps < 50) {
      _debug.warning('Low FPS detected: $fps');
      // Sugerir reducir calidad gráfica
    }
  }
}
```

---

## 🔐 Consideraciones Legales y Técnicas

### Gestión de ROMs
```dart
// Verificación de derechos
class RomLegalityChecker {
  static const Set<String> publicDomainRoms = {
    'homebrew_collection',
    'demo_roms',
    'open_source_games',
  };
  
  bool isRomLegalForDistribution(Rom rom) {
    return publicDomainRoms.contains(rom.collection) ||
           rom.license == RomLicense.publicDomain ||
           rom.license == RomLicense.homebrew;
  }
}
```

### Limitaciones Técnicas Web
```yaml
Browser Limitations:
  - File System Access: Limited to IndexedDB/localStorage
  - Memory: Típicamente 1-4GB disponible
  - CPU: Sin threads nativos (Web Workers limitados)
  - Audio Latency: Mayor que aplicaciones nativas

Mitigaciones:
  - Streaming de ROMs grandes
  - Web Workers para cores pesados
  - Audio worklets para baja latencia
  - Compresión agresiva de assets
```

---

## 📱 Responsive Design Strategy

### Breakpoints
```scss
// web/styles/responsive.scss
$mobile: 480px;
$tablet: 768px;  
$desktop: 1024px;
$large: 1440px;

@media (max-width: $mobile) {
  .emulator-container {
    height: 60vh; // Más espacio para controles táctiles
  }
  .touch-controls { display: block; }
  .keyboard-hints { display: none; }
}

@media (min-width: $desktop) {
  .emulator-container {
    height: 80vh;
  }
  .sidebar-controls { display: block; }
  .touch-controls { display: none; }
}
```

### Mobile Optimizations
```dart
// lib/platforms/web/mobile_optimizations.dart
class MobileOptimizations {
  static void applyFor(String userAgent) {
    if (_isMobile(userAgent)) {
      // Reducir calidad gráfica automáticamente
      EmulatorSettings.renderScale = 1;
      EmulatorSettings.audioLatency = 128; // Mayor para estabilidad
      
      // Habilitar controles táctiles
      TouchControlsManager.enable();
      
      // Prevenir zoom accidental
      _preventZoom();
    }
  }
}
```

---

## 🚀 Plan de Implementación

### Timeline Estimado: 8-10 semanas

| Semana | Fase | Tareas Principales |
|--------|------|-------------------|
| 1-2 | Setup | Configurar EmulatorJS, bridges JS↔Dart |
| 3-4 | Cores | Implementar gestión de cores, CDN setup |
| 5-6 | UI Web | Responsive design, controles táctiles |
| 7-8 | Features | Save states, gamepad, settings |
| 9-10 | Polish | Performance, testing, deployment |

### Hitos Clave
- ✅ **Semana 2**: Primer core funcionando (Game Boy)
- ✅ **Semana 4**: 5+ cores estables, descarga on-demand
- ✅ **Semana 6**: UI completamente responsive
- ✅ **Semana 8**: Feature parity con versión desktop
- ✅ **Semana 10**: Deployment production-ready

---

## 💻 Configuración de Desarrollo

### Estructura de Proyecto
```
forsaken_emulator_web/
├── lib/
│   ├── platforms/
│   │   ├── web/           # Implementaciones web
│   │   └── shared/        # Código compartido
│   └── web/               # Assets web específicos
├── web/
│   ├── cores/             # RetroArch cores (.wasm)
│   ├── emulatorjs/        # EmulatorJS library  
│   ├── manifest.json      # PWA manifest
│   └── sw.js              # Service Worker
└── build_web/             # Output de Flutter web build
```

### Build Process
```yaml
# pubspec.yaml additions
flutter:
  assets:
    - web/cores/
    - web/emulatorjs/
    
dev_dependencies:
  build_web_compilers: ^4.0.0
  js: ^0.6.0
```

### Development Commands
```bash
# Desarrollo local
flutter run -d chrome --web-renderer html

# Build optimizado para producción  
flutter build web --web-renderer html --dart-define=FLUTTER_WEB_USE_SKIA=false

# Deploy con cores
./scripts/deploy_web_with_cores.sh
```

---

## 🌐 Deployment Strategy

### CDN Setup
```yaml
Assets Distribution:
  App Shell: Vercel/Netlify (< 1MB)
  Essential Cores: CDN (15MB total)
  Optional Cores: CDN with lazy loading (50MB)
  
Caching Strategy:
  App Shell: Cache-first with updates
  Cores: Cache with version check
  ROMs: No cache (user uploads)
```

### Service Worker
```javascript
// web/sw.js
self.addEventListener('fetch', (event) => {
  if (event.request.url.includes('/cores/')) {
    // Cache cores agresivamente
    event.respondWith(cacheFirst(event.request));
  } else if (event.request.url.includes('/roms/')) {
    // ROMs solo en memoria
    event.respondWith(networkOnly(event.request));
  }
});
```

---

## 📈 Métricas y Analytics

### Performance Tracking
```dart
class WebAnalytics {
  void trackEmulatorPerformance({
    required String core,
    required String platform, 
    required double averageFPS,
    required Duration loadTime,
    required String browserInfo,
  }) {
    analytics.track('emulator_performance', {
      'core': core,
      'platform': platform,
      'fps': averageFPS,
      'load_time_ms': loadTime.inMilliseconds,
      'browser': browserInfo,
      'user_agent': html.window.navigator.userAgent,
    });
  }
}
```

### Success Metrics
- **Core Load Success Rate**: > 95%
- **Average FPS**: > 55 FPS (para cores 2D)
- **Time to First Play**: < 10 segundos
- **Mobile Compatibility**: > 80% de dispositivos Android/iOS

---

## 🔒 Security Considerations

### Content Security Policy
```html
<!-- web/index.html -->
<meta http-equiv="Content-Security-Policy" 
      content="script-src 'self' 'unsafe-inline' 'unsafe-eval' blob:; 
               worker-src 'self' blob:;
               wasm-src 'self';">
```

### ROM Upload Security
```dart
class SecureRomUploader {
  Future<bool> validateRom(Uint8List data) async {
    // Verificar tamaño máximo
    if (data.length > maxRomSize) return false;
    
    // Verificar header/magic numbers conocidos
    return _hasValidRomHeader(data);
  }
}
```

---

## 🎯 Conclusiones y Próximos Pasos

### Ventajas de la Versión Web
- ✅ **Sin instalación**: Acceso inmediato desde navegador
- ✅ **Cross-platform**: Funciona en cualquier dispositivo moderno  
- ✅ **Compartible**: URLs directas a juegos
- ✅ **Actualizable**: Deployment continuo sin friction

### Desafíos Técnicos
- ⚠️ **Performance**: Overhead de WebAssembly vs nativo
- ⚠️ **Storage**: Limitaciones de almacenamiento browser
- ⚠️ **Latency**: Audio/input lag mayor que desktop
- ⚠️ **Compatibility**: Variabilidad entre navegadores

### Recomendación Final
**La versión web es altamente viable y complementará perfectamente la versión desktop**, ofreciendo accesibilidad instantánea mientras mantiene una experiencia de calidad para emulación de consolas retro.

**Priority #1**: Comenzar con Game Boy/Game Boy Color como proof-of-concept, luego expandir a SNES y Genesis para validar el pipeline completo.

---

*Documento creado: Enero 2026*  
*Versión: 1.0*  
*Estado: Listo para implementación* ✅