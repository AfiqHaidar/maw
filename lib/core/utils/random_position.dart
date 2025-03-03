import 'dart:math';
import 'package:flutter/material.dart';

class RandomPositionUtil {
  static Offset generateRandomPosition(Size screenSize, double buttonSize) {
    final random = Random();

    double paddingY = screenSize.height * (2 / 8);
    double paddingX = screenSize.width * 0.1;

    double maxX = screenSize.width - buttonSize - paddingX;
    double maxY = screenSize.height - buttonSize - paddingY;

    double randomX = paddingX + random.nextDouble() * (maxX - paddingX);
    double randomY = paddingY + random.nextDouble() * (maxY - paddingY);

    return Offset(randomX, randomY);
  }
}
