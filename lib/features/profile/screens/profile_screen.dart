import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'dart:ui';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/widgets/confirmation_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userAsyncValue = ref.watch(userStreamProvider);

    return userAsyncValue.when(
      data: (user) =>
          _buildProfileContent(context, user, colorScheme, textTheme, ref),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error loading profile: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserEntity user,
      ColorScheme colorScheme, TextTheme textTheme, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.8),
                      colorScheme.secondary,
                      colorScheme.onPrimaryContainer.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Animated avatar with fancy border
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.all(3), // Border width
                        child: ClipOval(
                          child: Lottie.asset(
                            user.profilePicture.isNotEmpty
                                ? user.profilePicture
                                : 'assets/animations/blue_hang.json',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // User name with shimmer effect
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          user.name,
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Username with backdrop filter
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "@${user.username}",
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.95),
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () {
                  // You can use ref.read here to invoke user controller methods
                  // Example: ref.read(userProvider.notifier).updateUserProfile();
                },
              ),
            ],
          ),

          // Profile content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile stats
                  _buildProfileStatsCard(colorScheme),

                  const SizedBox(height: 24),

                  // Personal information section
                  _buildSectionHeader(Icons.person_outline,
                      "Personal Information", colorScheme.primary),

                  const SizedBox(height: 16),

                  // User information card
                  _buildInfoCard(
                    [
                      _buildInfoRow(Icons.email_outlined, "Email", user.email,
                          colorScheme),
                      _buildInfoRow(Icons.badge_outlined, "User ID", user.id,
                          colorScheme),
                    ],
                    colorScheme,
                  ),

                  const SizedBox(height: 24),

                  // Activity section
                  _buildSectionHeader(Icons.trending_up_outlined,
                      "Recent Activity", colorScheme.primary),

                  const SizedBox(height: 16),

                  // Recent activity cards
                  _buildActivityCard(
                    "Project Update",
                    "Updated Flutter Portfolio project",
                    "3 hours ago",
                    Icons.code_outlined,
                    colorScheme,
                  ),

                  const SizedBox(height: 12),

                  _buildActivityCard(
                    "New Connection",
                    "Connected with Jane Smith",
                    "Yesterday",
                    Icons.people_alt_outlined,
                    colorScheme,
                  ),

                  const SizedBox(height: 12),

                  _buildActivityCard(
                    "Achievement",
                    "Earned 'Flutter Expert' badge",
                    "3 days ago",
                    Icons.emoji_events_outlined,
                    colorScheme,
                  ),

                  const SizedBox(height: 24),

                  // Settings section
                  _buildSectionHeader(
                      Icons.settings_outlined, "Settings", colorScheme.primary),

                  const SizedBox(height: 16),

                  // Settings options
                  _buildSettingItem(
                      Icons.dark_mode_outlined, "Theme", "Dark", colorScheme),
                  _buildSettingItem(Icons.notifications_outlined,
                      "Notifications", "Enabled", colorScheme),
                  _buildSettingItem(Icons.lock_outline, "Privacy",
                      "Manage settings", colorScheme),
                  _buildSettingItem(Icons.help_outline, "Help & Support",
                      "Contact us", colorScheme),

                  const SizedBox(height: 24),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => ConfirmationDialog(
                            header: "Logout Confirmation",
                            subheader:
                                "Are you sure you want to log out of the account?",
                            confirmButtonText: "Logout",
                            cancelButtonText: "Cancel",
                            onConfirm: () async {
                              Navigator.of(context).pop(); // Close dialog
                              await ref.read(authProvider.notifier).logout();
                              // No need to manually navigate - your main.dart StreamBuilder should handle this
                              // Firebase authStateChanges() will trigger the navigation
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: const Text("Log Out"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: colorScheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStatsCard(ColorScheme colorScheme) {
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
          _buildStatItem(
              "12", "Projects", Icons.folder_outlined, colorScheme.primary),
          _buildDivider(),
          _buildStatItem("847", "Connections", Icons.people_alt_outlined,
              colorScheme.secondary),
          _buildDivider(),
          _buildStatItem("28", "Badges", Icons.emoji_events_outlined,
              colorScheme.tertiary),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String count, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
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

  Widget _buildInfoCard(List<Widget> children, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String description, String time,
      IconData icon, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      IconData icon, String title, String value, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade500,
            size: 20,
          ),
        ],
      ),
    );
  }
}
