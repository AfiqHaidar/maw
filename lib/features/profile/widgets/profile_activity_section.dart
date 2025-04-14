// lib/features/profile/widgets/profile_activity_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/profile/widgets/profile_activity_card.dart';
import 'package:mb/features/profile/widgets/profile_section_header.dart';

class ProfileActivitySection extends StatelessWidget {
  const ProfileActivitySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSectionHeader(
          icon: Icons.trending_up_outlined,
          title: "Recent Activity",
        ),

        const SizedBox(height: 16),

        // Recent activity cards
        const ProfileActivityCard(
          title: "Project Update",
          description: "Updated Flutter Portfolio project",
          time: "3 hours ago",
          icon: Icons.code_outlined,
        ),

        const SizedBox(height: 12),

        const ProfileActivityCard(
          title: "New Connection",
          description: "Connected with Jane Smith",
          time: "Yesterday",
          icon: Icons.people_alt_outlined,
        ),

        const SizedBox(height: 12),

        const ProfileActivityCard(
          title: "Achievement",
          description: "Earned 'Flutter Expert' badge",
          time: "3 days ago",
          icon: Icons.emoji_events_outlined,
        ),
      ],
    );
  }
}
