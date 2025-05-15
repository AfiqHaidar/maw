import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/providers/project_provider.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/features/portofolio/controllers/project_animation_controller.dart';
import 'package:mb/features/portofolio/utils/position_utils.dart';
import 'package:mb/features/portofolio/widgets/expandable_circle_overlay.dart';
import 'package:mb/features/portofolio/widgets/portofolio_category_section.dart';
import 'package:mb/features/portofolio/widgets/portofolio_project_preview_sheet.dart';
import 'package:mb/features/project/screens/project_screen.dart';

class UserPortfolioScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserPortfolioScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<UserPortfolioScreen> createState() =>
      _UserPortfolioScreenState();
}

class _UserPortfolioScreenState extends ConsumerState<UserPortfolioScreen>
    with TickerProviderStateMixin {
  int? _expandedIndex;
  final List<ExpansionAnimationController> _animationControllers = [];
  final List<GlobalKey> _circleKeys = [];
  Offset? _expandOrigin;
  final double _circleSize = 150.0;
  bool _isLoading = true;
  List<ProjectEntity>? _userProjects;
  UserEntity? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the user profile
      final allUsers = await ref.read(allUsersProvider.future);
      _user = allUsers.firstWhere((user) => user.id == widget.userId);

      // Fetch the user's projects
      _userProjects =
          await ref.read(projectProvider.notifier).fetchByUserId(widget.userId);

      _initializeAnimationControllers();
    } catch (e) {
      debugPrint('Error loading user portfolio: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userProjects != null) {
      _initializeAnimationControllers();
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeAnimationControllers() {
    if (_userProjects == null) {
      return;
    }

    if (_animationControllers.length != _userProjects!.length) {
      for (var controller in _animationControllers) {
        controller.dispose();
      }

      _animationControllers.clear();
      _circleKeys.clear();

      for (int i = 0; i < _userProjects!.length; i++) {
        _animationControllers.add(ExpansionAnimationController(vsync: this));
        _circleKeys.add(GlobalKey());
      }
    }
  }

  void _toggleExpand(int index) {
    if (_userProjects == null ||
        index < 0 ||
        index >= _userProjects!.length ||
        index >= _animationControllers.length ||
        index >= _circleKeys.length) {
      return;
    }

    if (_expandedIndex == index) {
      _collapseCurrentExpanded();
    } else if (_expandedIndex == null) {
      final circleCenter = PositionUtils.getWidgetCenter(_circleKeys[index]);
      setState(() {
        _expandedIndex = index;
        _expandOrigin = circleCenter;
      });
      _animationControllers[index].forward();
    } else {
      _animationControllers[_expandedIndex!].reverse().then((_) {
        final circleCenter = PositionUtils.getWidgetCenter(_circleKeys[index]);
        setState(() {
          _expandedIndex = index;
          _expandOrigin = circleCenter;
        });
        _animationControllers[index].forward();
      });
    }
  }

  void _collapseCurrentExpanded() {
    if (_expandedIndex != null) {
      _animationControllers[_expandedIndex!].reverse().then((_) {
        setState(() {
          _expandedIndex = null;
          _expandOrigin = null;
        });
      });
    }
  }

  void _navigateToProjectDetails(ProjectEntity project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectScreen(
          project: project,
          isOwner: false,
        ),
      ),
    );
  }

  Map<String, List<ProjectEntity>> _getProjectsByCategory() {
    final Map<String, List<ProjectEntity>> projectsByCategory = {};

    if (_userProjects == null || _userProjects!.isEmpty)
      return projectsByCategory;

    for (var project in _userProjects!) {
      if (!projectsByCategory.containsKey(project.category)) {
        projectsByCategory[project.category] = [];
      }
      projectsByCategory[project.category]!.add(project);
    }

    return projectsByCategory;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final bottomSheetHeight = screenHeight * 5 / 7;
    final projectsByCategory = _getProjectsByCategory();
    final categories = projectsByCategory.keys.toList()..sort();
    final hasProjects = _userProjects != null && _userProjects!.isNotEmpty;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildProfileHeader(),
              SliverPadding(
                padding: const EdgeInsets.only(top: 16.0),
                sliver: SliverToBoxAdapter(
                  child: hasProjects
                      ? _buildMainContent(
                          categories, projectsByCategory, _userProjects!)
                      : _buildEmptyState(),
                ),
              ),
            ],
          ),
          if (hasProjects && _expandedIndex != null && _expandOrigin != null)
            _buildExpandedCircleOverlay(_userProjects!, size),
          if (hasProjects && _expandedIndex != null)
            _buildProjectSheet(_userProjects!, bottomSheetHeight),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _user != null
                  ? "${_user!.name} hasn't added any projects yet"
                  : "No projects found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(
      List<String> categories,
      Map<String, List<ProjectEntity>> projectsByCategory,
      List<ProjectEntity> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project count text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        ),

        ...categories
            .map((category) => CategorySection(
                  category: category,
                  projects: projectsByCategory[category]!,
                  allProjects: projects,
                  circleKeys: _circleKeys,
                  circleSize: _circleSize,
                  onProjectTap: _toggleExpand,
                ))
            .toList(),
        const SizedBox(height: 80),
      ],
    );
  }

  SliverAppBar _buildProfileHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.8),
                colorScheme.secondary,
                colorScheme.onPrimaryContainer.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: _user != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Profile avatar with animation
                      CircleAvatar(
                        radius: 55,
                        child: ClipOval(
                          child: Lottie.asset(
                            _user!.profilePicture,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // User name with shimmer effect
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          _user!.name,
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Username with backdrop filter
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "@${_user!.username}",
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.95),
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  Widget _buildExpandedCircleOverlay(List<ProjectEntity> projects, Size size) {
    // Safety check
    if (_expandedIndex! < 0 ||
        _expandedIndex! >= projects.length ||
        _expandedIndex! >= _animationControllers.length) {
      // Reset invalid index
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _expandedIndex = null;
          _expandOrigin = null;
        });
      });
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationControllers[_expandedIndex!].controller,
      builder: (context, child) {
        final animation =
            _animationControllers[_expandedIndex!].expansionAnimation.value;

        return ExpandedCircleOverlay(
          origin: _expandOrigin!,
          animation: animation,
          circleSize: _circleSize,
          item: projects[_expandedIndex!],
          screenSize: size,
          onClose: _collapseCurrentExpanded,
        );
      },
    );
  }

  Widget _buildProjectSheet(
      List<ProjectEntity> projects, double bottomSheetHeight) {
    // Safety check
    if (_expandedIndex! < 0 ||
        _expandedIndex! >= projects.length ||
        _expandedIndex! >= _animationControllers.length) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationControllers[_expandedIndex!].controller,
      builder: (context, child) {
        final sheetAnimation =
            _animationControllers[_expandedIndex!].sheetSlideAnimation.value;
        final fadeAnimation =
            _animationControllers[_expandedIndex!].fadingAnimation.value;

        return ProjectPreviewSheet(
          sheetAnimation: sheetAnimation,
          fadeAnimation: fadeAnimation,
          sheetHeight: bottomSheetHeight,
          project: projects[_expandedIndex!],
          itemIndex: _expandedIndex!,
          onClose: _collapseCurrentExpanded,
          onViewDetails: () =>
              _navigateToProjectDetails(projects[_expandedIndex!]),
        );
      },
    );
  }
}
