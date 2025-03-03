import 'package:flutter/material.dart';

class FadeAndSlideWrapper extends StatelessWidget {
  final Widget child;
  final AnimationController animationController;
  final Interval fadeCurve;
  final Interval slideCurve;
  final Offset slideOffset;

  const FadeAndSlideWrapper({
    super.key,
    required this.child,
    required this.animationController,
    this.fadeCurve = const Interval(0.0, 1.0, curve: Curves.easeOut),
    this.slideCurve = const Interval(0.0, 1.0, curve: Curves.easeOut),
    this.slideOffset = const Offset(0.0, 1.0),
  });

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: fadeCurve),
    );

    final slideAnimation = Tween<Offset>(
      begin: slideOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: slideCurve),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}
