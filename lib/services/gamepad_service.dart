// GamepadService with conditional imports
// Uses the real implementation on desktop, stub on web
export 'gamepad_service_io.dart'
    if (dart.library.js_interop) 'gamepad_service_web_impl.dart';
