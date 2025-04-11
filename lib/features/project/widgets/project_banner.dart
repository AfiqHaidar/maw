// lib/features/project/widgets/project_banner.dart
import 'package:flutter/material.dart';
import 'package:mb/widgets/cached_image_widget.dart';

class ProjectBanner extends StatelessWidget {
  final Color backgroundColor;
  final String logoPath;
  final String projectId;

  const ProjectBanner({
    Key? key,
    required this.backgroundColor,
    required this.logoPath,
    required this.projectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Center(
        child: logoPath.isNotEmpty
            ? Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: _buildLogoImage(),
                ),
              )
            : Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 32,
                ),
              ),
      ),
    );
  }

  Widget _buildLogoImage() {
    if (logoPath.isEmpty) {
      return const SizedBox();
    }

    if (logoPath.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        logoPath,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else if (!logoPath.startsWith('http')) {
      // Local file path (should not happen in view mode, but just in case)
      return const Icon(
        Icons.image,
        color: Colors.white,
        size: 40,
      );
    } else {
      // Remote URL - use cached image
      return CachedImageWidget(
        imageUrl: logoPath,
        projectId: projectId,
        imageType: 'logo',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        placeholder: Container(
          color: Colors.white.withOpacity(0.1),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        errorWidget: Container(
          color: Colors.white.withOpacity(0.1),
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.white,
            size: 32,
          ),
        ),
      );
    }
  }
}
