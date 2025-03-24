// lib/features/portfolio/screens/portfolio_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/data/models/project_model.dart';
import 'package:mb/features/Portofolio/screens/project_screen.dart';
import 'package:mb/features/portofolio/controllers/project_animation_controller.dart';
import 'package:mb/features/portofolio/data/project_item.dart';
import 'package:mb/features/portofolio/screens/add_project_screen.dart';
import 'package:mb/features/portofolio/utils/position_utils.dart';
import 'package:mb/features/portofolio/widgets/expandable_circle_overlay.dart';
import 'package:mb/features/portofolio/widgets/portofolio_category_section.dart';
import 'package:mb/features/portofolio/widgets/portofolio_header.dart';
import 'package:mb/features/portofolio/widgets/project_sheet.dart';
import 'package:mb/widgets/drawer/main_drawer.dart';

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

  final Color _selectedColor = AppColors.primary;

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

  void _initializeAnimationControllers() {
    final projects = ref.read(projectsProvider);

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
    final projects = ref.read(projectsProvider);

    if (index < 0 ||
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

  void _navigateToProjectDetails(ProjectModel project) {
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
    );
  }

  Map<String, List<ProjectModel>> _getProjectsByCategory() {
    final projects = ref.watch(projectsProvider);
    final Map<String, List<ProjectModel>> projectsByCategory = {};

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
    final projectsByCategory = _getProjectsByCategory();
    final categories = projectsByCategory.keys.toList()..sort();
    final projects = ref.watch(projectsProvider);

    return Scaffold(
        drawer: const MainDrawer(),
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            _buildMainContent(categories, projectsByCategory, projects),
            if (_expandedIndex != null && _expandOrigin != null)
              _buildExpandedCircleOverlay(projects, size),
            if (_expandedIndex != null)
              _buildProjectSheet(projects, bottomSheetHeight),
          ],
        ));
  }

  Widget _buildMainContent(
      List<String> categories,
      Map<String, List<ProjectModel>> projectsByCategory,
      List<ProjectModel> projects) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) => PortofolioHeader(
              themeColor: _selectedColor,
              onAddProject: _navigateToAddProject,
              onMenuPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          const SizedBox(height: 20),
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

  Widget _buildExpandedCircleOverlay(List<ProjectModel> projects, Size size) {
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
      List<ProjectModel> projects, double bottomSheetHeight) {
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

        return ProjectSheet(
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
