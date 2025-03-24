// lib/features/portofolio/widgets/project_sheet.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/project_model.dart';
import 'package:mb/features/portofolio/widgets/project_sheet_header.dart';
import 'package:mb/features/portofolio/widgets/project_image_carousel.dart';
import 'package:mb/features/portofolio/widgets/project_info_chip.dart';

class ProjectSheet extends StatefulWidget {
  final double sheetAnimation;
  final double fadeAnimation;
  final double sheetHeight;
  final ProjectModel project;
  final int itemIndex;
  final VoidCallback onClose;
  final VoidCallback onViewDetails;

  const ProjectSheet({
    Key? key,
    required this.sheetAnimation,
    required this.fadeAnimation,
    required this.sheetHeight,
    required this.project,
    required this.itemIndex,
    required this.onClose,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  State<ProjectSheet> createState() => _ProjectSheetState();
}

class _ProjectSheetState extends State<ProjectSheet> {
  late DraggableScrollableController _dragController;

  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final themeColor = widget.project.bannerBgColor;

    final minFraction = 0.55;
    final maxFraction = widget.sheetHeight / screenHeight;
    final initialFraction = maxFraction;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: screenHeight,
      child: Stack(
        children: [
          AnimatedSlide(
            offset: Offset(0, 1 - widget.sheetAnimation),
            duration: const Duration(milliseconds: 150),
            child: DraggableScrollableSheet(
              initialChildSize: initialFraction,
              minChildSize: minFraction,
              maxChildSize: maxFraction,
              controller: _dragController,
              snap: true,
              snapSizes: [minFraction, maxFraction],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.15 * widget.fadeAnimation),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header section with release date, handle bar, and close button
                      ProjectSheetHeader(
                        project: widget.project,
                        onClose: widget.onClose,
                      ),

                      // Scrollable content
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(height: 16),

                            // Project title
                            Text(
                              widget.project.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),

                            // Short description
                            if (widget.project.shortDescription != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                widget.project.shortDescription!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],

                            // Role and Development time
                            if (widget.project.role != null ||
                                widget.project.developmentTime != null) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 16,
                                children: [
                                  if (widget.project.role != null)
                                    ProjectInfoChip(
                                      icon: Icons.person_outline_rounded,
                                      text: widget.project.role!,
                                      themeColor: themeColor,
                                    ),
                                  if (widget.project.developmentTime != null)
                                    ProjectInfoChip(
                                      icon: Icons.calendar_today_rounded,
                                      text:
                                          "${widget.project.developmentTime!.inDays} days",
                                      themeColor: themeColor,
                                    ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 20),

                            // Image Carousel
                            if (widget
                                .project.carouselImagePaths.isNotEmpty) ...[
                              ProjectImageCarousel(
                                imagePaths: widget.project.carouselImagePaths,
                                themeColor: themeColor,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Brief description (first paragraph only)
                            Text(
                              _getFirstParagraph(widget.project.details),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // View Details Button
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ElevatedButton.icon(
                                onPressed: widget.onViewDetails,
                                icon: const Icon(Icons.visibility_rounded,
                                    size: 20),
                                label: const Text("View Full Details"),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: themeColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getFirstParagraph(String text) {
    // Extract just the first paragraph or first 150 characters
    final paragraphs = text.split('\n\n');
    if (paragraphs.isNotEmpty) {
      if (paragraphs[0].length > 150) {
        return '${paragraphs[0].substring(0, 150)}...';
      }
      return paragraphs[0];
    }

    // Fallback if there are no paragraphs
    if (text.length > 150) {
      return '${text.substring(0, 150)}...';
    }
    return text;
  }
}
