// lib/features/portfolio/screens/portfolio_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/providers/project_provider.dart';
import 'package:mb/features/project/screens/project_screen.dart';
import 'package:mb/features/portofolio/controllers/project_animation_controller.dart';
import 'package:mb/features/portofolio/utils/position_utils.dart';
import 'package:mb/features/portofolio/widgets/expandable_circle_overlay.dart';
import 'package:mb/features/portofolio/widgets/portofolio_category_section.dart';
import 'package:mb/features/portofolio/widgets/portofolio_project_preview_sheet.dart';
import 'package:mb/features/upsert_project/screens/add_project_screen.dart';

class PortofolioScreen extends ConsumerStatefulWidget {
  const PortofolioScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PortofolioScreen> createState() => _PortofolioScreenState();
}

class _PortofolioScreenState extends ConsumerState<PortofolioScreen>
    with TickerProviderStateMixin {
  int? _expandedIndex;
  final List<ExpansionAnimationController> _animationControllers = [];
  final List<GlobalKey> _circleKeys = [];
  Offset? _expandOrigin;
  final double _circleSize = 150.0;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeAnimationControllers();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await ref.read(projectProvider.notifier).fetch();
      _initializeAnimationControllers();
    } catch (e) {
      debugPrint('Error refreshing projects: $e');
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _initializeAnimationControllers() {
    final projects = ref.read(projectProvider);

    if (projects == null) {
      ref.read(projectProvider.notifier).fetch();
      return;
    }

    if (_animationControllers.length != projects.length) {
      for (var controller in _animationControllers) {
        controller.dispose();
      }

      _animationControllers.clear();
      _circleKeys.clear();

      for (int i = 0; i < projects.length; i++) {
        _animationControllers.add(ExpansionAnimationController(vsync: this));
        _circleKeys.add(GlobalKey());
      }
    }
  }

  void _toggleExpand(int index) {
    final projects = ref.read(projectProvider);

    if (projects == null ||
        index < 0 ||
        index >= projects.length ||
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
        builder: (context) => ProjectScreen(project: project),
      ),
    );
  }

  void _navigateToAddProject() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProjectScreen(),
      ),
    ).then((_) {
      // Refresh the project list when returning from add project screen
      ref.read(projectProvider.notifier).fetch();
    });
  }

  Map<String, List<ProjectEntity>> _getProjectsByCategory() {
    final projects = ref.watch(projectProvider);
    final Map<String, List<ProjectEntity>> projectsByCategory = {};

    if (projects == null || projects.isEmpty) return projectsByCategory;

    for (var project in projects) {
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
    final projects = ref.watch(projectProvider);
    final projectsByCategory = _getProjectsByCategory();
    final categories = projectsByCategory.keys.toList()..sort();
    final hasProjects = projects != null && projects.isNotEmpty;

    return Scaffold(
        floatingActionButton: FloatingActionButton.small(
          onPressed: _navigateToAddProject,
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          tooltip: 'Add Project',
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            RefreshIndicator(
              onRefresh: _onRefresh,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              displacement: 40,
              strokeWidth: 3,
              child: hasProjects
                  ? _buildMainContent(categories, projectsByCategory, projects)
                  : _buildEmptyState(),
            ),
            if (_isRefreshing)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            if (hasProjects && _expandedIndex != null && _expandOrigin != null)
              _buildExpandedCircleOverlay(projects, size),
            if (hasProjects && _expandedIndex != null)
              _buildProjectSheet(projects, bottomSheetHeight),
          ],
        ));
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 120,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Start adding your projects to build your portfolio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      List<String> categories,
      Map<String, List<ProjectEntity>> projectsByCategory,
      List<ProjectEntity> projects) {
    return SingleChildScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Builder(
          //   builder: (context) => PortfolioHeader(
          //     title: "My Projects",
          //     onActionPressed: () => Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const AddProjectScreen(),
          //       ),
          //     ),
          //     actionIcon: Icons.add,
          //   ),
          // ),
          SizedBox(height: MediaQuery.of(context).padding.top + 16),

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
          const SizedBox(height: 20),
        ],
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
