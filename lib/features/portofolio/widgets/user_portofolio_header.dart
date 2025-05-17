// Updated user_portofolio_header.dart with better scrolling behavior and title
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/connection_entity.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/enums/connection_identifier.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/data/providers/connection_provider.dart';
import 'package:mb/features/profile/widgets/profile_avatar.dart';
import 'package:mb/widgets/confirmation_dialog.dart';
import 'package:mb/features/home/screens/inbox_screen.dart';

class UserPortfolioHeader extends ConsumerStatefulWidget {
  final UserEntity? user;

  const UserPortfolioHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  ConsumerState<UserPortfolioHeader> createState() =>
      _UserPortfolioHeaderState();
}

class _UserPortfolioHeaderState extends ConsumerState<UserPortfolioHeader> {
  bool _isLoading = false;
  ConnectionEntity? _connection;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _fetchConnectionStatus();
    }
  }

  void _navigateToInbox() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const InboxScreen(),
      ),
    );
  }

  Future<void> _fetchConnectionStatus() async {
    if (widget.user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUserId =
          ref.read(authRepositoryProvider).getCurrentUser()!.uid;
      if (currentUserId == widget.user!.id) {
        // Don't check connection status with yourself
        setState(() {
          _isLoading = false;
        });
        return;
      }

      _connection = await ref
          .read(connectionProvider.notifier)
          .connectionBetweenUsers(currentUserId, widget.user!.id);
    } catch (e) {
      print('Error fetching connection status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestConnection() async {
    if (widget.user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(connectionProvider.notifier)
          .sendConnectionRequest(widget.user!.id);
      await _fetchConnectionStatus();
    } catch (e) {
      print('Error requesting connection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to request connection: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showRemoveConnectionDialog() {
    if (_connection == null) return;

    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Remove Connection',
        description:
            'Are you sure you want to remove your connection with ${widget.user?.name}?',
        confirmButtonText: 'Remove',
        cancelButtonText: 'Cancel',
        icon: Icons.person_remove_outlined,
        onConfirm: _removeConnection,
      ),
    );
  }

  Future<void> _removeConnection() async {
    if (_connection == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(connectionProvider.notifier)
          .removeConnection(_connection!.id);

      // Refresh connection status
      await _fetchConnectionStatus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection with ${widget.user?.name} removed'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error removing connection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove connection: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildConnectionAction() {
    if (widget.user == null) return const SizedBox.shrink();

    // Check if current user is the profile owner
    final currentUserId =
        ref.read(authRepositoryProvider).getCurrentUser()!.uid;
    if (currentUserId == widget.user!.id) {
      return const SizedBox
          .shrink(); // Don't show connection icon on own profile
    }

    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Match leading button padding
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    if (_connection == null) {
      // No connection exists
      return IconButton(
        icon: const Icon(Icons.person_add_outlined, color: Colors.white),
        onPressed: _requestConnection,
        tooltip: 'Request Connection',
        padding: const EdgeInsets.all(16.0), // Match leading button padding
      );
    } else if (_connection!.status == ConnectionIdentifier.pending) {
      // Check if current user initiated the request
      final isInitiator = _connection!.initiatedBy == currentUserId;

      return Stack(
        children: [
          IconButton(
            icon: Icon(
              isInitiator
                  ? Icons.hourglass_top_outlined
                  : Icons.move_to_inbox_rounded,
              color: Colors.white,
            ),
            onPressed: isInitiator ? null : _navigateToInbox,
            tooltip: isInitiator ? 'Pending' : 'Accept Request',
            padding: const EdgeInsets.all(16.0),
          ),
          if (!isInitiator)
            Positioned(
              top: 14,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
              ),
            ),
        ],
      );
    } else if (_connection!.status == ConnectionIdentifier.connected) {
      return IconButton(
        icon: const Icon(Icons.how_to_reg_outlined, color: Colors.white),
        onPressed: _showRemoveConnectionDialog,
        tooltip: 'Connected - Click to remove',
        padding: const EdgeInsets.all(16.0), // Match leading button padding
      );
    } else {
      return const SizedBox.shrink(); // For other statuses like blocked
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: colorScheme.primary,
      centerTitle: true,
      titleSpacing: 0,
      floating: false,
      snap: false,
      stretch: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        padding: const EdgeInsets.all(16.0),
      ),
      actions: [
        _buildConnectionAction(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: null,
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
          child: widget.user != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Profile avatar with animation
                      ProfileAvatar(avatarPath: widget.user!.profilePicture),

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
                          widget.user!.name,
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
                              "@${widget.user!.username}",
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
                )
              : Container(),
        ),
        collapseMode: CollapseMode.parallax,
        stretchModes: [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
      ),
    );
  }
}
