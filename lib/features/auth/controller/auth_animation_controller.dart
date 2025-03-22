import 'package:flutter/material.dart';

class AuthAnimatedOpacityController {
  final TickerProvider vsync;
  late final AnimationController controller;
  late final Animation<double> opacityAnim;
  late final Animation<double> lowOpacityAnim;

  AuthAnimatedOpacityController({required this.vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    opacityAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    lowOpacityAnim = Tween<double>(begin: 1, end: 0.7).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void dispose() {
    controller.dispose();
  }
}
