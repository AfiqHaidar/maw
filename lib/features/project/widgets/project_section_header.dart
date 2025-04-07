// lib/features/portofolio/widgets/project_section_header.dart
import 'package:flutter/material.dart';

class ProjectSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color themeColor;

  const ProjectSectionHeader({
    Key? key,
    required this.icon,
    required this.title,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: themeColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
