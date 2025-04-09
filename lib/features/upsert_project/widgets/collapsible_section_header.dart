// lib/features/common/widgets/collapsible_section_header.dart
import 'package:flutter/material.dart';

class CollapsibleSectionHeader extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color themeColor;
  final Widget child;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry headerPadding;

  const CollapsibleSectionHeader({
    Key? key,
    required this.icon,
    required this.title,
    required this.themeColor,
    required this.child,
    this.initiallyExpanded = false,
    this.contentPadding = const EdgeInsets.only(top: 16, bottom: 8),
    this.headerPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  State<CollapsibleSectionHeader> createState() =>
      _CollapsibleSectionHeaderState();
}

class _CollapsibleSectionHeaderState extends State<CollapsibleSectionHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5)
        .chain(CurveTween(curve: Curves.easeIn)));

    _isExpanded = widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: widget.headerPadding,
          child: InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 20,
                      color: widget.themeColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ClipRect(
          child: AnimatedBuilder(
            animation: _controller.view,
            builder: (BuildContext context, Widget? child) {
              return SizeTransition(
                sizeFactor: _heightFactor,
                child: child,
              );
            },
            child: Padding(
              padding: widget.contentPadding,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
