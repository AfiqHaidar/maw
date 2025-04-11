// lib/features/project/screens/project_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/handlers/error_handler.dart';
import 'package:mb/core/mappers/firestore_error_mapper.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/providers/project_provider.dart';
import 'package:mb/features/portofolio/screens/portofolio_screen.dart';
import 'package:mb/features/project/widgets/project_banner.dart';
import 'package:mb/features/project/widgets/project_challenge_item.dart';
import 'package:mb/features/project/widgets/project_enhancement_item.dart';
import 'package:mb/features/project/widgets/project_feature_item.dart';
import 'package:mb/features/project/widgets/project_image_carousel.dart';
import 'package:mb/features/project/widgets/project_links_section.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';
import 'package:mb/features/project/widgets/project_stats_row.dart';
import 'package:mb/features/project/widgets/project_team_member_card.dart';
import 'package:mb/features/project/widgets/project_testimonial_item.dart';
import 'package:mb/features/upsert_project/screens/edit_project_screen.dart';
import 'package:mb/widgets/confirmation_dialog.dart';

class ProjectScreen extends ConsumerStatefulWidget {
  final ProjectEntity project;

  const ProjectScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  ConsumerState<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<ProjectScreen> {
  bool _showMoreDetails = false;

  String _getLastName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.last : fullName;
  }

  bool _hasExpandableContent(ProjectEntity project) {
    return (project.challenges != null && project.challenges!.isNotEmpty) ||
        (project.futureEnhancements != null &&
            project.futureEnhancements!.isNotEmpty) ||
        (project.testimonials != null && project.testimonials!.isNotEmpty);
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        header: 'Delete ${widget.project.name}?',
        subheader:
            'This action cannot be undone. All data associated with this project will be permanently removed.',
        confirmButtonText: 'Delete',
        cancelButtonText: 'Cancel',
        confirmButtonColor: Colors.red,
        onConfirm: () async {
          Navigator.of(ctx).pop();
          await _deleteProject();
        },
      ),
    );
  }

  Future<void> _deleteProject() async {
    try {
      ref.read(projectProvider.notifier).deleteProject(widget.project.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.project.name} deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => PortofolioScreen()),
      );
    } on FirebaseException catch (e) {
      ErrorHandler.showError(
        context,
        FirestoreErrorMapper.map(e),
        useDialog: false,
      );
    } catch (e) {
      ErrorHandler.showError(
        context,
        "Error deleting project",
      );
    }
  }

  void _navigateToEditScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProjectScreen(project: widget.project),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.project.bannerBgColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'edit') {
                _navigateToEditScreen();
              } else if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Using the new ProjectBanner widget (logo only)
            ProjectBanner(
              backgroundColor: themeColor,
              logoPath: widget.project.bannerImagePath,
              projectId: widget.project.id,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Project title
                  Text(
                    widget.project.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: themeColor,
                    ),
                  ),

                  // Short description
                  if (widget.project.shortDescription != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.project.shortDescription!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  // Release date
                  if (widget.project.releaseDate != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Released: ${widget.project.releaseDate!.year}/${widget.project.releaseDate!.month.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: themeColor,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Image Carousel
                  if (widget.project.carouselImagePaths.isNotEmpty) ...[
                    ProjectImageCarousel(
                      imagePaths: widget.project.carouselImagePaths,
                      themeColor: themeColor,
                      projectId: widget.project.id,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Project Stats
                  if (widget.project.stats != null) ...[
                    ProjectSectionHeader(
                      icon: Icons.bar_chart_rounded,
                      title: "Project Stats",
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 12),
                    ProjectStatsRow(
                      stats: widget.project.stats!,
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  ProjectSectionHeader(
                    icon: Icons.description_outlined,
                    title: "Overview",
                    themeColor: themeColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.project.details,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tech Stack
                  if (widget.project.techStack != null &&
                      widget.project.techStack!.isNotEmpty) ...[
                    ProjectSectionHeader(
                      icon: Icons.code_rounded,
                      title: "Tech Stack",
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.project.techStack!
                          .map(
                            (tech) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                tech,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Key Features
                  if (widget.project.keyFeatures != null &&
                      widget.project.keyFeatures!.isNotEmpty) ...[
                    ProjectSectionHeader(
                      icon: Icons.star_outline_rounded,
                      title: "Key Features",
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 16),
                    ...widget.project.keyFeatures!
                        .map((feature) => ProjectFeatureItem(
                              feature: feature,
                              themeColor: themeColor,
                            )),
                    const SizedBox(height: 32),
                  ],

                  // Team Members
                  if (widget.project.teamMembers != null &&
                      widget.project.teamMembers!.isNotEmpty) ...[
                    ProjectSectionHeader(
                      icon: Icons.groups_rounded,
                      title: "Team",
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.project.teamMembers!.length,
                        itemBuilder: (context, index) {
                          final member = widget.project.teamMembers![index];
                          return ProjectTeamMemberCard(
                            member: member,
                            themeColor: themeColor,
                            getLastName: _getLastName,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // "Show More" / "Show Less"
                  if (_hasExpandableContent(widget.project)) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showMoreDetails = !_showMoreDetails;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _showMoreDetails
                                  ? "Show Less"
                                  : "Show More Details",
                              style: TextStyle(
                                color: themeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _showMoreDetails
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: themeColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Expandable content
                  if (_showMoreDetails) ...[
                    // Challenges
                    if (widget.project.challenges != null &&
                        widget.project.challenges!.isNotEmpty) ...[
                      ProjectSectionHeader(
                        icon: Icons.engineering_rounded,
                        title: "Challenges & Solutions",
                        themeColor: themeColor,
                      ),
                      const SizedBox(height: 16),
                      ...widget.project.challenges!
                          .map((challenge) => ProjectChallengeItem(
                                challenge: challenge,
                                themeColor: themeColor,
                              )),
                      const SizedBox(height: 32),
                    ],

                    // Future Enhancements
                    if (widget.project.futureEnhancements != null &&
                        widget.project.futureEnhancements!.isNotEmpty) ...[
                      ProjectSectionHeader(
                        icon: Icons.update_rounded,
                        title: "Future Enhancements",
                        themeColor: themeColor,
                      ),
                      const SizedBox(height: 16),
                      ...widget.project.futureEnhancements!
                          .map((enhancement) => ProjectEnhancementItem(
                                enhancement: enhancement,
                                themeColor: themeColor,
                              )),
                      const SizedBox(height: 32),
                    ],

                    // Testimonials
                    if (widget.project.testimonials != null &&
                        widget.project.testimonials!.isNotEmpty) ...[
                      ProjectSectionHeader(
                        icon: Icons.format_quote_rounded,
                        title: "Testimonials",
                        themeColor: themeColor,
                      ),
                      const SizedBox(height: 16),
                      ...widget.project.testimonials!
                          .map((testimonial) => ProjectTestimonialItem(
                                testimonial: testimonial,
                                themeColor: themeColor,
                                projectId: widget.project.id,
                              )),
                      const SizedBox(height: 32),
                    ],
                  ],

                  // Tags
                  if (widget.project.tags != null &&
                      widget.project.tags!.isNotEmpty) ...[
                    ProjectSectionHeader(
                      icon: Icons.tag_rounded,
                      title: "Tags",
                      themeColor: themeColor,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.project.tags!
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: themeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "#$tag",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: themeColor,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Links section with buttons
                  ProjectLinksSection(
                    project: widget.project,
                    themeColor: themeColor,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
