// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:js' as js;

/// Returns the current HTML pre-loader progress percentage (0–100).
int getPreLoaderProgress() {
  try {
    final fn = js.context['_preLoaderProgress'];
    if (fn is js.JsFunction) {
      final result = fn.apply([]);
      if (result is num) return result.toInt();
    }
  } catch (_) {
    // Silently ignore — pre-loader may have already been removed.
  }
  return 0;
}

/// Removes the HTML pre-loader overlay with a fade-out transition.
void removePreLoader() {
  try {
    final fn = js.context['removePreLoader'];
    if (fn is js.JsFunction) {
      fn.apply([]);
    }
  } catch (_) {
    // Silently ignore — pre-loader may have already been removed.
  }
}
