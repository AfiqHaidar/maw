// lib/widgets/lottie_animation_widget.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const LottieAnimationWidget({
    Key? key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget lottieWidget = Lottie.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: _buildErrorWidget,
    );

    if (backgroundColor != null || borderRadius != null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: lottieWidget,
        ),
      );
    }

    return lottieWidget;
  }

  Widget _buildErrorWidget(
      BuildContext context, Object? error, StackTrace? stackTrace) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.animation,
          size: (width != null && height != null) ? (width! + height!) / 6 : 24,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
