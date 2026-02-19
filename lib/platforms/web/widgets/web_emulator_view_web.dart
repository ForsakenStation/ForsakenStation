import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Register and create the HTML element view for web emulator
class WebEmulatorViewFactory {
  static final Set<String> _registeredViews = {};
  static final Map<String, web.HTMLDivElement> _elements = {};

  /// Register a view factory for the given container ID
  static void registerViewFactory(String containerId) {
    if (_registeredViews.contains(containerId)) {
      return; // Already registered
    }

    ui_web.platformViewRegistry.registerViewFactory(containerId, (int viewId) {
      final div = web.document.createElement('div') as web.HTMLDivElement
        ..id = containerId;
      div.style.width = '100%';
      div.style.height = '100%';
      div.style.backgroundColor = '#000000';
      div.style.position = 'relative';

      // Store reference for JS access
      _elements[containerId] = div;

      // Also store globally for cross-frame access
      web.console.log('Creating emulator container: $containerId'.toJS);
      _exposeContainerGlobally(containerId, div);

      // Add placeholder content that will be replaced by EmulatorJS
      div.innerHTML =
          '''
          <div style="display: flex; align-items: center; justify-content: center; 
                      height: 100%; color: #ffffff; font-family: Arial, sans-serif;">
            <div style="text-align: center;">
              <div style="font-size: 48px; margin-bottom: 16px;">🎮</div>
              <div style="font-size: 18px;">Initializing Emulator...</div>
            </div>
          </div>
        '''
              .toJS;

      return div;
    });

    _registeredViews.add(containerId);
  }

  /// Expose container globally for JS bridge access
  static void _exposeContainerGlobally(
    String containerId,
    web.HTMLDivElement div,
  ) {
    // Store in a global map that JS can access via globalContext (window)
    if (!globalContext.has('ForsakenContainers')) {
      globalContext['ForsakenContainers'] = JSObject();
    }
    final containers = globalContext['ForsakenContainers']! as JSObject;
    containers[containerId] = div;
  }

  /// Check if a view is registered
  static bool isRegistered(String containerId) {
    return _registeredViews.contains(containerId);
  }

  /// Get the HTML element by ID
  static web.Element? getElement(String containerId) {
    // First check our cache
    if (_elements.containsKey(containerId)) {
      return _elements[containerId];
    }
    // Fallback to document lookup
    return web.document.getElementById(containerId);
  }
}

/// Widget that displays the HTML element view
class WebEmulatorHtmlView extends StatelessWidget {
  final String containerId;
  final double? width;
  final double? height;

  const WebEmulatorHtmlView({
    super.key,
    required this.containerId,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure view is registered
    WebEmulatorViewFactory.registerViewFactory(containerId);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 400,
      child: HtmlElementView(viewType: containerId),
    );
  }
}

/// Create the emulator HTML view (web implementation)
Widget createEmulatorHtmlView({
  required String containerId,
  double? width,
  double? height,
}) {
  return WebEmulatorHtmlView(
    containerId: containerId,
    width: width,
    height: height,
  );
}

/// Register the emulator container (web implementation)
void registerEmulatorContainer(String containerId) {
  WebEmulatorViewFactory.registerViewFactory(containerId);
}

/// Check if running on web
bool get isWebPlatform => true;
