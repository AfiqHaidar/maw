// lib/features/portfolio/widgets/project_item.dart
import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/features/Portofolio/widgets/expandable_circle.dart';

class ProjectItem extends StatelessWidget {
  final ProjectEntity project;
  final int index;
  final GlobalKey circleKey;
  final double circleSize;
  final Function(int) onTap;

  const ProjectItem({
    Key? key,
    required this.project,
    required this.index,
    required this.circleKey,
    required this.circleSize,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          _buildProjectCircle(),
          const SizedBox(height: 12),
          _buildProjectName(),
          if (project.shortDescription != null) _buildProjectDescription(),
          if (project.releaseDate != null) _buildReleaseDateBadge(),
        ],
      ),
    );
  }

  Widget _buildProjectCircle() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpandableCircle(
        item: project,
        size: circleSize,
        onTap: () => onTap(index),
        circleKey: circleKey,
        shadow: BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ),
    );
  }

  Widget _buildProjectName() {
    return Container(
      width: circleSize,
      alignment: Alignment.center,
      child: Text(
        project.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGrey,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProjectDescription() {
    return Container(
      width: circleSize,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        project.shortDescription!,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildReleaseDateBadge() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: project.bannerBgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${project.releaseDate!.year}/${project.releaseDate!.month.toString().padLeft(2, '0')}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: project.bannerBgColor,
        ),
      ),
    );
  }
}
