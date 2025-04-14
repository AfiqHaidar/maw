// lib/features/profile/widgets/profile_info_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/features/profile/widgets/profile_info_card.dart';
import 'package:mb/features/profile/widgets/profile_section_header.dart';

class ProfileInfoSection extends StatelessWidget {
  final UserEntity user;

  const ProfileInfoSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSectionHeader(
          icon: Icons.person_outline,
          title: "Personal Information",
        ),
        const SizedBox(height: 16),
        ProfileInfoCard(
          items: [
            ProfileInfoItem(
              icon: Icons.email_outlined,
              label: "Email",
              value: user.email,
            ),
            ProfileInfoItem(
              icon: Icons.badge_outlined,
              label: "User ID",
              value: user.id,
            ),
          ],
        ),
      ],
    );
  }
}
