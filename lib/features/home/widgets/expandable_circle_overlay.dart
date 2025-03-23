import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/data/enums/banner_identifier.dart';
import 'package:mb/data/enums/circle_identifier.dart';
import 'package:mb/data/models/project_model.dart';

class ExpandedCircleOverlay extends StatelessWidget {
  final Offset origin;
  final double animation;
  final double circleSize;
  final ProjectModel item;
  final Size screenSize;
  final VoidCallback? onClose;

  const ExpandedCircleOverlay({
    Key? key,
    required this.origin,
    required this.animation,
    required this.circleSize,
    required this.item,
    required this.screenSize,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initial circle radius
    final initialRadius = circleSize / 2;
    final contentSize = circleSize * 0.75;

    // Calculate final width and height
    final finalWidth = screenSize.width;
    final finalHeight = screenSize.height / 2; // Half of the screen height

    // Interpolate dimensions based on animation value
    final currentWidth =
        initialRadius * 2 + (finalWidth - initialRadius * 2) * animation;
    final currentHeight =
        initialRadius * 2 + (finalHeight - initialRadius * 2) * animation;

    // Calculate interpolated position
    // Start from the center of the original circle, move toward top-center of screen
    final finalX = screenSize.width / 2;
    final finalY = finalHeight / 2;

    final currentX = origin.dx + (finalX - origin.dx) * animation;
    final currentY = origin.dy + (finalY - origin.dy) * animation;

    // Calculate position (left, top) of the container
    final left = currentX - currentWidth / 2;
    final top = currentY - currentHeight / 2;

    // Calculate border radius (from circle to rectangle)
    final borderRadius = initialRadius * (1 - animation);

    return Positioned(
      left: left,
      top: top,
      width: currentWidth,
      height: currentHeight,
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          decoration: BoxDecoration(
            color: item.bannerType == CircleIdentifier.picture
                ? Colors.transparent
                : item.bannerBgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(animation > 0.8 ? 0 : borderRadius),
              topRight: Radius.circular(animation > 0.8 ? 0 : borderRadius),
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background container that fills the entire space
              Container(
                width: currentWidth,
                height: currentHeight,
                color: item.bannerType == CircleIdentifier.picture
                    ? Colors.transparent
                    : item.bannerBgColor,
              ),

              // Content container limited to 1/3 of screen width
              Center(
                child: Container(
                  width: contentSize,
                  height: contentSize,
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final contentSize = screenSize.width / 3;

    if (item.bannerType == BannerIdentifier.picture) {
      return Container(
        width: contentSize,
        height: contentSize,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(item.bannerImagePath),
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return Container(
        width: contentSize,
        height: contentSize,
        child: Lottie.asset(
          item.bannerLottiePath,
          width: contentSize,
          height: contentSize,
          fit: BoxFit.contain,
          repeat: true,
        ),
      );
    }
  }
}
