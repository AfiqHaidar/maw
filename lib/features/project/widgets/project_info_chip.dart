// lib/features/portofolio/widgets/project_info_chip.dart
import 'package:flutter/material.dart';

class ProjectInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color themeColor;

  const ProjectInfoChip({
    Key? key,
    required this.icon,
    required this.text,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: themeColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: themeColor,
            ),
          ),
        ],
      ),
    );
  }
}
