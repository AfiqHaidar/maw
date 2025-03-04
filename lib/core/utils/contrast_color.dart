import 'package:flutter/material.dart';

class ContrastColorUtil {
  static Color getContrastColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }
}
