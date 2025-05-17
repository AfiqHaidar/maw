// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/connection_entity.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/providers/connection_provider.dart';
import 'package:mb/data/providers/project_provider.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/features/profile/widgets/profile_header.dart';
import 'package:mb/features/profile/widgets/profile_info_section.dart';
import 'package:mb/features/profile/widgets/profile_logout_button.dart';
import 'package:mb/features/profile/widgets/profile_settings_section.dart';
import 'package:mb/features/profile/widgets/profile_stats_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isProjectsLoading = false;
  bool _isConnectionsLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
    _fetchConnections();
  }

  Future<void> _fetchProjects() async {
    final projects = ref.read(projectProvider);

    if (projects == null) {
      setState(() {
        _isProjectsLoading = true;
      });

      try {
        await ref.read(projectProvider.notifier).fetch();
      } catch (e) {
      } finally {
        if (mounted) {
          setState(() {
            _isProjectsLoading = false;
          });
        }
      }
    }
  }

  Future<void> _fetchConnections() async {
    final connection = ref.read(connectionProvider);

    if (connection == null) {
      setState(() {
        _isConnectionsLoading = true;
      });

      try {
        await ref.read(connectionProvider.notifier).fetchConnections();
      } catch (e) {
      } finally {
        if (mounted) {
          setState(() {
            _isConnectionsLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userStreamProvider);
    final projects = ref.watch(projectProvider);
    final connections = ref.watch(connectionProvider);

    return userAsyncValue.when(
      data: (user) =>
          _buildProfileContent(context, user, projects, connections),
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
      List<ProjectEntity>? projects, List<ConnectionEntity>? connections) {
    final projectCount = projects?.length ?? 0;
    final connectionCount = connections?.length ?? 0;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Profile header with avatar, name, and username
          ProfileHeader(user: user),

          // Profile content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileStatsCard(
                    projectCount: projectCount,
                    isProjectsLoading: _isProjectsLoading,
                    connectionCount: connectionCount,
                    isConnectionsLoading: _isConnectionsLoading,
                  ),
                  const SizedBox(height: 24),
                  ProfileInfoSection(user: user),
                  const SizedBox(height: 24),
                  const ProfileSettingsSection(),
                  const SizedBox(height: 24),
                  const ProfileLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
