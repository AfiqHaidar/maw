// lib/features/upsert_project/widgets/upsert_project_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/enums/banner_identifier.dart';
import 'package:mb/data/models/challenge_model.dart';
import 'package:mb/data/models/feature_model.dart';
import 'package:mb/data/models/future_enhancement_model.dart';
import 'package:mb/data/models/project_stats_model.dart';
import 'package:mb/data/models/team_member_model.dart';
import 'package:mb/data/models/testimonial_model.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_banner.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_category_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_details_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_enhancements_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_features_challenges_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_features_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_images_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_info_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_links_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_tags_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_tech_stack_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_testimonials_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_stats_section.dart';
import 'package:mb/features/upsert_project/widgets/upsert_team_member_section.dart';
import 'package:uuid/uuid.dart';

class ProjectForm extends ConsumerStatefulWidget {
  final ProjectEntity? project;
  final Color selectedColor;
  final Function(ProjectEntity) onSave;
  final String submitButtonText;

  const ProjectForm({
    Key? key,
    this.project,
    required this.selectedColor,
    required this.onSave,
    required this.submitButtonText,
  }) : super(key: key);

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  late TextEditingController _shortDescriptionController;
  late TextEditingController _linkController;
  late TextEditingController _githubLinkController;
  late TextEditingController _roleController;

  late DateTime? _releaseDate;
  late String? _selectedCategory;
  late Color _selectedColor;
  late String _selectedLogoPath;
  late List<String> _carouselImages;
  late List<String> _techStack;
  late List<String> _tags;
  late int _developmentDays;
  late List<TeamMember> _teamMembers;
  late List<String> _additionalLinks;
  late List<Feature> _keyFeatures;
  late List<Challenge> _challenges;
  late List<FutureEnhancement> _futureEnhancements;
  late List<Testimonial> _testimonials;
  late ProjectStats _stats;

  // Sample categories
  final List<String> _categories = [
    'Arcade Games',
    'Logic Puzzles',
    'Mobile Apps',
    'Web Development',
    'Tools'
  ];

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    final project = widget.project;
    _nameController = TextEditingController(text: project?.name ?? '');
    _detailsController = TextEditingController(text: project?.details ?? '');
    _shortDescriptionController =
        TextEditingController(text: project?.shortDescription ?? '');
    _linkController = TextEditingController(text: project?.link ?? '');
    _githubLinkController =
        TextEditingController(text: project?.githubLink ?? '');
    _additionalLinks = project?.additionalLinks?.toList() ?? [];
    _roleController = TextEditingController(text: project?.role ?? '');

    _releaseDate = project?.releaseDate;
    _selectedCategory = project?.category ?? _categories.first;
    _selectedColor = widget.selectedColor;
    _selectedLogoPath = project?.bannerImagePath ?? '';
    _carouselImages = project?.carouselImagePaths.toList() ?? [];
    _techStack = project?.techStack?.toList() ?? [];
    _tags = project?.tags?.toList() ?? [];
    _developmentDays = project?.developmentTime?.inDays ?? 0;
    _teamMembers = project?.teamMembers?.toList() ?? [];
    _keyFeatures = project?.keyFeatures?.toList() ?? [];
    _challenges = project?.challenges?.toList() ?? [];
    _futureEnhancements = project?.futureEnhancements?.toList() ?? [];
    _testimonials = project?.testimonials?.toList() ?? [];

    _stats = project?.stats ??
        ProjectStats(
          users: 0,
          stars: 0,
          forks: 0,
          downloads: 0,
          contributions: 0,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _shortDescriptionController.dispose();
    _linkController.dispose();
    _githubLinkController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(userProvider)!;
      print("debug: ${user.id}");
      final ProjectEntity formData = widget.project == null
          ? ProjectEntity(
              id: const Uuid().v4(),
              userId: user.id,
              name: _nameController.text,
              bannerBgColor: _selectedColor,
              bannerType: _selectedLogoPath.isNotEmpty
                  ? BannerIdentifier.picture
                  : BannerIdentifier.lottie,
              bannerImagePath: _selectedLogoPath,
              bannerLottiePath: user.profilePicture,
              carouselImagePaths: _carouselImages,
              details: _detailsController.text,
              shortDescription: _shortDescriptionController.text.isEmpty
                  ? null
                  : _shortDescriptionController.text,
              role: _roleController.text.isEmpty ? null : _roleController.text,
              techStack: _techStack.isEmpty ? null : _techStack,
              tags: _tags.isEmpty ? null : _tags,
              link: _linkController.text,
              githubLink: _githubLinkController.text.isEmpty
                  ? null
                  : _githubLinkController.text,
              additionalLinks:
                  _additionalLinks.isEmpty ? null : _additionalLinks,
              releaseDate: _releaseDate,
              category: _selectedCategory ?? _categories.first,
              developmentTime: _developmentDays > 0
                  ? Duration(days: _developmentDays)
                  : null,
              stats: ProjectStats(
                users: 0,
                stars: 0,
                forks: 0,
                downloads: 0,
                contributions: 0,
              ),
              teamMembers: _teamMembers.isEmpty ? null : _teamMembers,
              keyFeatures: _keyFeatures.isEmpty ? null : _keyFeatures,
              challenges: _challenges.isEmpty ? null : _challenges,
              futureEnhancements:
                  _futureEnhancements.isEmpty ? null : _futureEnhancements,
              testimonials: _testimonials.isEmpty ? null : _testimonials,
            )
          : ProjectEntity(
              id: widget.project!.id,
              userId: widget.project!.userId,
              name: _nameController.text,
              bannerBgColor: _selectedColor,
              bannerType: _selectedLogoPath.isNotEmpty
                  ? BannerIdentifier.picture
                  : BannerIdentifier.lottie,
              bannerImagePath: _selectedLogoPath,
              bannerLottiePath: widget.project!.bannerLottiePath,
              carouselImagePaths: _carouselImages,
              details: _detailsController.text,
              shortDescription: _shortDescriptionController.text.isEmpty
                  ? null
                  : _shortDescriptionController.text,
              role: _roleController.text.isEmpty ? null : _roleController.text,
              techStack: _techStack.isEmpty ? null : _techStack,
              tags: _tags.isEmpty ? null : _tags,
              link: _linkController.text,
              githubLink: _githubLinkController.text.isEmpty
                  ? null
                  : _githubLinkController.text,
              additionalLinks:
                  _additionalLinks.isEmpty ? null : _additionalLinks,
              releaseDate: _releaseDate,
              category: _selectedCategory ?? _categories.first,
              developmentTime: _developmentDays > 0
                  ? Duration(days: _developmentDays)
                  : null,
              stats: _stats,
              teamMembers: _teamMembers.isEmpty ? null : _teamMembers,
              keyFeatures: _keyFeatures.isEmpty ? null : _keyFeatures,
              challenges: _challenges.isEmpty ? null : _challenges,
              futureEnhancements:
                  _futureEnhancements.isEmpty ? null : _futureEnhancements,
              testimonials: _testimonials.isEmpty ? null : _testimonials,
            );

      widget.onSave(formData);
    }
  }

  void _updateColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _updateLogoPath(String path) {
    setState(() {
      _selectedLogoPath = path;
    });
  }

  void _updateCarouselImages(List<String> images) {
    setState(() {
      _carouselImages = images;
    });
  }

  void _updateReleaseDate(DateTime? date) {
    setState(() {
      _releaseDate = date;
    });
  }

  void _updateDevelopmentDays(int days) {
    setState(() {
      _developmentDays = days;
    });
  }

  void _updateSelectedCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _updateTechStack(List<String> techStack) {
    setState(() {
      _techStack = techStack;
    });
  }

  void _updateTags(List<String> tags) {
    setState(() {
      _tags = tags;
    });
  }

  void _updateTeamMembers(List<TeamMember> members) {
    setState(() {
      _teamMembers = members;
    });
  }

  void _updateAdditionalLinks(List<String> links) {
    setState(() {
      _additionalLinks = links;
    });
  }

  // Update methods for the new sections
  void _updateFeatures(List<Feature> features) {
    setState(() {
      _keyFeatures = features;
    });
  }

  void _updateChallenges(List<Challenge> challenges) {
    setState(() {
      _challenges = challenges;
    });
  }

  void _updateEnhancements(List<FutureEnhancement> enhancements) {
    setState(() {
      _futureEnhancements = enhancements;
    });
  }

  void _updateTestimonials(List<Testimonial> testimonials) {
    setState(() {
      _testimonials = testimonials;
    });
  }

  void _updateStats(ProjectStats stats) {
    setState(() {
      _stats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project banner with color picker and logo selection
            UpsertProjectBanner(
              selectedColor: _selectedColor,
              selectedLogoPath: _selectedLogoPath,
              onPickLogo: () async {
                final path = await _pickLogo();
                if (path != null) {
                  _updateLogoPath(path);
                }
              },
              onColorChange: _updateColor,
            ),

            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Project details section
                  ProjectDetailsSection(
                    nameController: _nameController,
                    shortDescriptionController: _shortDescriptionController,
                    detailsController: _detailsController,
                    themeColor: _selectedColor,
                  ),

                  const SizedBox(height: 24),

                  // Category section
                  ProjectCategorySection(
                    selectedCategory: _selectedCategory,
                    themeColor: _selectedColor,
                    categories: _categories,
                    onCategoryChanged: _updateSelectedCategory,
                  ),

                  const SizedBox(height: 24),

                  // Project images section
                  ProjectImagesSection(
                    carouselImages: _carouselImages,
                    themeColor: _selectedColor,
                    onImagesChanged: _updateCarouselImages,
                  ),

                  const SizedBox(height: 24),

                  // Project Statistics section
                  ProjectStatsSection(
                    initialStats: widget.project?.stats,
                    themeColor: _selectedColor,
                    onStatsChanged: _updateStats,
                  ),

                  const SizedBox(height: 24),

                  // Project links section
                  ProjectLinksSection(
                    linkController: _linkController,
                    githubLinkController: _githubLinkController,
                    additionalLinks: _additionalLinks,
                    themeColor: _selectedColor,
                    onAdditionalLinksChanged: _updateAdditionalLinks,
                  ),

                  const SizedBox(height: 24),

                  // Project info section
                  ProjectInfoSection(
                    roleController: _roleController,
                    releaseDate: _releaseDate,
                    developmentDays: _developmentDays,
                    themeColor: _selectedColor,
                    onReleaseDateChanged: _updateReleaseDate,
                    onDevelopmentDaysChanged: _updateDevelopmentDays,
                  ),

                  const SizedBox(height: 24),

                  // Key Features section
                  ProjectFeaturesSection(
                    initialFeatures: _keyFeatures,
                    themeColor: _selectedColor,
                    onFeaturesChanged: _updateFeatures,
                  ),

                  const SizedBox(height: 24),

                  // Challenges section
                  ProjectChallengesSection(
                    initialChallenges: _challenges,
                    themeColor: _selectedColor,
                    onChallengesChanged: _updateChallenges,
                  ),

                  const SizedBox(height: 24),

                  // Future Enhancements section
                  ProjectEnhancementsSection(
                    initialEnhancements: _futureEnhancements,
                    themeColor: _selectedColor,
                    onEnhancementsChanged: _updateEnhancements,
                  ),

                  const SizedBox(height: 24),

                  // Team Members section
                  ProjectTeamMemberSection(
                    themeColor: _selectedColor,
                    initialMembers: _teamMembers,
                    onTeamMembersChanged: _updateTeamMembers,
                  ),

                  const SizedBox(height: 24),

                  // Testimonials section
                  ProjectTestimonialsSection(
                    initialTestimonials: _testimonials,
                    themeColor: _selectedColor,
                    onTestimonialsChanged: _updateTestimonials,
                  ),
                  const SizedBox(height: 24),
                  // Tech stack section
                  ProjectTechStackSection(
                    techStack: _techStack,
                    themeColor: _selectedColor,
                    onTechStackChanged: _updateTechStack,
                  ),

                  const SizedBox(height: 24),

                  // Tags section
                  ProjectTagsSection(
                    tags: _tags,
                    themeColor: _selectedColor,
                    onTagsChanged: _updateTags,
                  ),

                  const SizedBox(height: 32),

                  // Save button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.save_rounded, size: 20),
                      label: Text(widget.submitButtonText),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _selectedColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return image.path;
    }
    return null;
  }
}
