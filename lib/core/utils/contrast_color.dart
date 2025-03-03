import 'package:flutter/material.dart';

class ContrastColorUtil {
  static Color getContrastColor(Color backgroundColor) {
    // Calculate luminance to determine contrast
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }
}
