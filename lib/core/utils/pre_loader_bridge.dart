import 'pre_loader_bridge_stub.dart'
    if (dart.library.html) 'pre_loader_bridge_web.dart' as impl;

/// Bridge to the HTML pre-loader defined in `web/index.html`.
///
/// On web, calls into JavaScript functions exposed by the inline `<script>`
/// block in `index.html`. On non-web platforms, these are harmless no-ops.
abstract class PreLoaderBridge {
  const PreLoaderBridge._();

  /// Returns the current HTML pre-loader progress percentage (0–100).
  static int getProgress() => impl.getPreLoaderProgress();

  /// Removes the HTML pre-loader overlay with a fade-out transition.
  static void remove() => impl.removePreLoader();
}
