// lib/features/portfolio/widgets/category_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/features/portofolio/widgets/portofolio_project_item.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final List<ProjectEntity> projects;
  final List<ProjectEntity> allProjects;
  final List<GlobalKey> circleKeys;
  final double circleSize;
  final Function(int) onProjectTap;

  const CategorySection({
    Key? key,
    required this.category,
    required this.projects,
    required this.allProjects,
    required this.circleKeys,
    required this.circleSize,
    required this.onProjectTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default theme color - use one from the first project if available

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
          child: ProjectSectionHeader(
            icon: _getCategoryIcon(),
            title: category,
            themeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        _buildProjectsList(),
      ],
    );
  }

  IconData _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'arcade games':
        return Icons.sports_esports;
      case 'logic puzzles':
        return Icons.extension;
      case 'mobile apps':
        return Icons.phone_android;
      case 'web development':
        return Icons.web;
      case 'tools':
        return Icons.build;
      default:
        return Icons.category;
    }
  }

  Widget _buildProjectsList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: projects.map((project) {
            final index = allProjects.indexOf(project);

            // Safety check for index
            if (index < 0 || index >= circleKeys.length) {
              return const SizedBox.shrink();
            }

            return ProjectItem(
              project: project,
              index: index,
              circleKey: circleKeys[index],
              circleSize: circleSize,
              onTap: onProjectTap,
            );
          }).toList(),
        ),
      ),
    );
  }
}
