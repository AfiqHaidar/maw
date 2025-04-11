import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/enums/banner_identifier.dart';
import 'package:mb/widgets/cached_image_widget.dart';

class ExpandedCircleOverlay extends StatelessWidget {
  final Offset origin;
  final double animation;
  final double circleSize;
  final ProjectEntity item;
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

    // Content size transition
    final initialContentSize = circleSize * 0.75;
    final expandedContentSize = screenSize.width * 0.5;
    final currentContentSize = initialContentSize +
        (expandedContentSize - initialContentSize) * animation;

    return Positioned(
      left: left,
      top: top,
      width: currentWidth,
      height: currentHeight,
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          decoration: BoxDecoration(
            color: item.bannerBgColor,
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
              Container(
                width: currentWidth,
                height: currentHeight,
                color: item.bannerType == BannerIdentifier.picture
                    ? Colors.transparent
                    : item.bannerBgColor,
              ),
              Center(
                child: Container(
                  width: currentContentSize,
                  height: currentContentSize,
                  child: _buildContent(currentContentSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(double contentSize) {
    if (item.bannerType == BannerIdentifier.picture) {
      return _buildImage(contentSize);
    } else {
      return Lottie.asset(
        item.bannerLottiePath,
        fit: BoxFit.contain,
        repeat: true,
      );
    }
  }

  Widget _buildImage(double contentSize) {
    final String imagePath = item.bannerImagePath;

    if (imagePath.isEmpty) {
      return Container(
        color: item.bannerBgColor,
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.white54,
          size: 48,
        ),
      );
    }

    if (imagePath.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: item.bannerBgColor,
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.white54,
              size: 48,
            ),
          );
        },
      );
    } else if (imagePath.startsWith('http')) {
      // Remote URL - use cached image
      return CachedImageWidget(
        imageUrl: imagePath,
        projectId: item.id,
        imageType: 'banner',
        width: contentSize,
        height: contentSize,
        fit: BoxFit.contain,
        placeholder: Container(
          color: item.bannerBgColor,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          ),
        ),
        errorWidget: Container(
          color: item.bannerBgColor,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.white54,
            size: 48,
          ),
        ),
      );
    } else {
      // Fallback for any other type of path
      return Container(
        color: item.bannerBgColor,
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.white54,
          size: 48,
        ),
      );
    }
  }
}
