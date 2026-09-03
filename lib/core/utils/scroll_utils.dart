import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

class ScrollUtils {
  const ScrollUtils._();

  static Future<void> toKey(
    GlobalKey key, {
    Duration duration = AppMotion.medium,
    Curve curve = AppMotion.easeInOut,
    double alignment = 0.08,
  }) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: duration,
      curve: curve,
      alignment: alignment,
    );
  }

  static Future<void> toOffset(
    ScrollController controller,
    double offset, {
    Duration duration = AppMotion.medium,
    Curve curve = AppMotion.easeInOut,
  }) async {
    if (!controller.hasClients) return;
    await controller.animateTo(
      offset.clamp(
        controller.position.minScrollExtent,
        controller.position.maxScrollExtent,
      ),
      duration: duration,
      curve: curve,
    );
  }

  static Future<void> toTop(
    ScrollController controller, {
    Duration duration = AppMotion.medium,
    Curve curve = AppMotion.easeInOut,
  }) {
    return toOffset(controller, 0, duration: duration, curve: curve);
  }
}
