import 'package:flutter/material.dart';

class ExpansionAnimationController {
  final TickerProvider vsync;
  late final AnimationController controller;
  late final Animation<double> expansionAnimation;
  late final Animation<double> sheetSlideAnimation;
  late final Animation<double> fadingAnimation;

  ExpansionAnimationController({required this.vsync}) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );

    expansionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Bottom sheet slide animation with a slight delay
    sheetSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    fadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.1, 0.9, curve: Curves.easeInOut),
      ),
    );
  }

  void forward() => controller.forward(from: 0.0);

  Future<void> reverse() => controller.reverse();

  void dispose() {
    controller.dispose();
  }
}
