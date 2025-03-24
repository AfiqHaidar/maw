// lib/features/portfolio/utils/position_utils.dart
import 'package:flutter/material.dart';

class PositionUtils {
  /// Get the center point of a widget using its GlobalKey
  static Offset getWidgetCenter(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return Offset(
      position.dx + size.width / 2,
      position.dy + size.height / 2,
    );
  }
}
