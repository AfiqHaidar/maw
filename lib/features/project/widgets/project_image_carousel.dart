// lib/features/project/widgets/project_image_carousel.dart
import 'package:flutter/material.dart';
import 'package:mb/widgets/cached_image_widget.dart';

class ProjectImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final Color themeColor;
  final String projectId;

  const ProjectImageCarousel({
    Key? key,
    required this.imagePaths,
    required this.themeColor,
    required this.projectId,
  }) : super(key: key);

  @override
  State<ProjectImageCarousel> createState() => _ProjectImageCarouselState();
}

class _ProjectImageCarouselState extends State<ProjectImageCarousel> {
  late PageController _carouselController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = PageController();
    _carouselController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _carouselController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  void dispose() {
    _carouselController.removeListener(_onPageChanged);
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // PageView carousel
          PageView.builder(
            controller: _carouselController,
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildCarouselImage(widget.imagePaths[index], index),
                ),
              );
            },
          ),

          // Page indicator
          if (widget.imagePaths.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imagePaths.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? widget.themeColor
                          : Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCarouselImage(String path, int index) {
    if (path.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade400,
            size: 32,
          ),
        ),
      );
    }

    if (path.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        path,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey.shade400,
                size: 32,
              ),
            ),
          );
        },
      );
    } else if (path.startsWith('http')) {
      // Remote URL - use cached image
      return CachedImageWidget(
        imageUrl: path,
        projectId: widget.projectId,
        imageType: 'carousel_$index',
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(20),
        placeholder: Container(
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(widget.themeColor),
            ),
          ),
        ),
        errorWidget: Container(
          color: Colors.grey.shade200,
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey.shade400,
              size: 32,
            ),
          ),
        ),
      );
    } else {
      // Local file path (should not happen in view mode, but just in case)
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade400,
            size: 32,
          ),
        ),
      );
    }
  }
}
