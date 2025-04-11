import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/enums/banner_identifier.dart';
import 'package:mb/widgets/cached_image_widget.dart';

class ExpandableCircle extends StatelessWidget {
  final ProjectEntity item;
  final double size;
  final VoidCallback onTap;
  final GlobalKey circleKey;
  final BoxShadow? shadow;

  const ExpandableCircle({
    Key? key,
    required this.item,
    required this.size,
    required this.onTap,
    required this.circleKey,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          key: circleKey,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: item.bannerBgColor,
            shape: BoxShape.circle,
            boxShadow: shadow != null ? [shadow!] : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final contentSize = size *
        0.75; // Limit content to 75% of the circle size to prevent clipping

    // If the type is picture, show the image
    if (item.bannerType == BannerIdentifier.picture) {
      return Center(
        child: Container(
          width: contentSize,
          height: contentSize,
          child: _buildImage(contentSize),
        ),
      );
    }
    // Otherwise show the Lottie animation with the background color
    else {
      return Center(
        child: SizedBox(
          width: contentSize,
          height: contentSize,
          child: Lottie.asset(
            item.bannerLottiePath,
            fit:
                BoxFit.contain, // Use contain to prevent stretching or clipping
            repeat: true,
          ),
        ),
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
          size: 24,
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
              size: 24,
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
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          ),
        ),
        errorWidget: Container(
          color: item.bannerBgColor,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.white54,
            size: 24,
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
          size: 24,
        ),
      );
    }
  }
}
