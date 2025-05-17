// lib/features/profile/widgets/profile_stats_card.dart
import 'package:flutter/material.dart';
import 'package:mb/features/profile/widgets/profile_stat_item.dart';

class ProfileStatsCard extends StatelessWidget {
  final int projectCount;
  final int connectionCount;
  final bool isProjectsLoading;
  final bool isConnectionsLoading;

  const ProfileStatsCard({
    Key? key,
    this.projectCount = 0,
    this.connectionCount = 0,
    this.isProjectsLoading = false,
    this.isConnectionsLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileStatItem(
            count: ProfileStatItem.formatCount(projectCount),
            label: "Projects",
            icon: Icons.folder_outlined,
            color: colorScheme.primary,
            isLoading: isProjectsLoading,
          ),
          _buildDivider(),
          ProfileStatItem(
            count: ProfileStatItem.formatCount(connectionCount),
            label: "Connections",
            icon: Icons.people_alt_outlined,
            color: colorScheme.secondary,
            isLoading: isConnectionsLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}
