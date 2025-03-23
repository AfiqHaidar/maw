import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/features/home/controllers/home_animation_controller.dart';
import 'package:mb/features/home/data/project_item.dart';
import 'package:mb/features/home/widgets/project_sheet.dart';
import 'package:mb/features/home/widgets/expandable_circle_overlay.dart';
import '../widgets/expandable_circle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int? _expandedIndex;
  final List<ExpansionAnimationController> _animationControllers = [];
  final List<GlobalKey> _circleKeys = [];
  Offset? _expandOrigin;
  double _circleSize = 150.0;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < dummyProjects.length; i++) {
      _animationControllers.add(ExpansionAnimationController(vsync: this));
      _circleKeys.add(GlobalKey());
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Offset _getWidgetCenter(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return Offset(
      position.dx + size.width / 2,
      position.dy + size.height / 2,
    );
  }

  void _toggleExpand(int index) {
    if (_expandedIndex == index) {
      _collapseCurrentExpanded();
    } else if (_expandedIndex == null) {
      final circleCenter = _getWidgetCenter(_circleKeys[index]);
      setState(() {
        _expandedIndex = index;
        _expandOrigin = circleCenter;
      });
      _animationControllers[index].forward();
    } else {
      _animationControllers[_expandedIndex!].reverse().then((_) {
        final circleCenter = _getWidgetCenter(_circleKeys[index]);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final _bottomSheetHeight = screenHeight * 5 / 7;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildCircleList(),
          if (_expandedIndex != null && _expandOrigin != null)
            AnimatedBuilder(
              animation: _animationControllers[_expandedIndex!].controller,
              builder: (context, child) {
                final animation = _animationControllers[_expandedIndex!]
                    .expansionAnimation
                    .value;

                return ExpandedCircleOverlay(
                  origin: _expandOrigin!,
                  animation: animation,
                  circleSize: _circleSize,
                  item: dummyProjects[_expandedIndex!],
                  screenSize: size,
                  onClose: _collapseCurrentExpanded,
                );
              },
            ),
          if (_expandedIndex != null)
            AnimatedBuilder(
              animation: _animationControllers[_expandedIndex!].controller,
              builder: (context, child) {
                final sheetAnimation = _animationControllers[_expandedIndex!]
                    .sheetSlideAnimation
                    .value;
                final fadeAnimation = _animationControllers[_expandedIndex!]
                    .fadingAnimation
                    .value;

                return ProjectSheet(
                  sheetAnimation: sheetAnimation,
                  fadeAnimation: fadeAnimation,
                  sheetHeight: _bottomSheetHeight,
                  project: dummyProjects[_expandedIndex!],
                  itemIndex: _expandedIndex!,
                  onClose: _collapseCurrentExpanded,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCircleList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(dummyProjects.length, (index) {
            return Column(
              children: [
                ExpandableCircle(
                  item: dummyProjects[index],
                  size: _circleSize,
                  onTap: () => _toggleExpand(index),
                  circleKey: _circleKeys[index],
                  shadow: BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ),
                const SizedBox(height: 8), // Space between circle and text
                Text(
                  dummyProjects[index].name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24), // Space between items
              ],
            );
          }),
        ),
      ),
    );
  }
}
