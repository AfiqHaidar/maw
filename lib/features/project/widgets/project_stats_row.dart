// lib/features/project/widgets/project_stats_row.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/project_stats_model.dart';

class ProjectStatsRow extends StatelessWidget {
  final ProjectStats stats;
  final Color themeColor;

  const ProjectStatsRow({
    Key? key,
    required this.stats,
    required this.themeColor,
  }) : super(key: key);

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toString();
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 22,
            color: themeColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
            Icons.people_alt_outlined, "${_formatNumber(stats.users)} Users"),
        _buildStatItem(
            Icons.star_outline_rounded, "${_formatNumber(stats.stars)} Stars"),
        _buildStatItem(
            Icons.fork_right_outlined, "${_formatNumber(stats.forks)} Forks"),
        _buildStatItem(
            Icons.download_outlined, "${_formatNumber(stats.downloads)} DL"),
      ],
    );
  }
}
