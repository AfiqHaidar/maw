import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/data/enums/banner_identifier.dart';
import 'package:mb/data/models/project_model.dart';

class ExpandableCircle extends StatelessWidget {
  final ProjectModel item;
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(item.bannerImagePath),
              fit: BoxFit.contain,
            ),
          ),
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
}
