// Conditional import for web-specific HTML view
import 'web_emulator_view_stub.dart'
    if (dart.library.js_interop) 'web_emulator_view_web.dart';

export 'web_emulator_view_stub.dart'
    if (dart.library.js_interop) 'web_emulator_view_web.dart'
    show createEmulatorHtmlView, registerEmulatorContainer, isWebPlatform;
