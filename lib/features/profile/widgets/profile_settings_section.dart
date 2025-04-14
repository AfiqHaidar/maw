// lib/features/profile/widgets/profile_settings_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/profile/widgets/profile_section_header.dart';
import 'package:mb/features/profile/widgets/profile_setting_item.dart';
import 'package:mb/widgets/confirmation_dialog.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSectionHeader(
          icon: Icons.settings_outlined,
          title: "Settings",
        ),

        const SizedBox(height: 16),

        // Settings options
        ProfileSettingItem(
          icon: Icons.dark_mode_outlined,
          title: "Theme",
          value: "Dark",
          onTap: () => _showSettingDialog(
            context,
            "Theme Settings",
            "Choose your preferred theme for the app.",
            Icons.dark_mode_outlined,
          ),
        ),

        ProfileSettingItem(
          icon: Icons.notifications_outlined,
          title: "Notifications",
          value: "Enabled",
          onTap: () => _showSettingDialog(
            context,
            "Notification Settings",
            "Manage how you receive notifications from the app.",
            Icons.notifications_outlined,
          ),
        ),

        ProfileSettingItem(
          icon: Icons.lock_outline,
          title: "Privacy",
          value: "Manage settings",
          onTap: () => _showSettingDialog(
            context,
            "Privacy Settings",
            "Control who can see your profile and projects.",
            Icons.lock_outline,
          ),
        ),

        ProfileSettingItem(
          icon: Icons.help_outline,
          title: "Help & Support",
          value: "Contact us",
          onTap: () => _showSettingDialog(
            context,
            "Help & Support",
            "Get assistance with using the app or report issues.",
            Icons.help_outline,
          ),
        ),
      ],
    );
  }

  void _showSettingDialog(
      BuildContext context, String title, String message, IconData icon) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: title,
        description: message,
        confirmButtonText: "OK",
        cancelButtonText: "Cancel",
        icon: icon,
        onConfirm: () {
          // This would contain actual functionality in a real implementation
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text("$title selected"),
          //     behavior: SnackBarBehavior.floating,
          //   ),
          // );
        },
      ),
    );
  }
}
