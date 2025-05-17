// lib/features/connection/screens/inbox_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/connection_entity.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/providers/connection_provider.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/features/home/widgets/accepted_card.dart';
import 'package:mb/features/home/widgets/pending_card.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    final incomingRequestsAsync = ref.watch(incomingConnectionRequestsProvider);
    final establishedConnectionsAsync =
        ref.watch(establishedConnectionsProvider);
    final allUsersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        elevation: 0,
      ),
      body: allUsersAsync.when(
        data: (users) {
          return CustomScrollView(
            slivers: [
              _buildPendingRequests(incomingRequestsAsync, users),
              _buildRecentConnections(establishedConnectionsAsync, users),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading user data: $err'),
        ),
      ),
    );
  }

  Widget _buildPendingRequests(AsyncValue<List<ConnectionEntity>> requestsAsync,
      List<UserEntity> allUsers) {
    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "No Connection Requests",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You don't have any pending connection requests",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }

        // Sort requests by creation date, newest first
        final sortedRequests = [...requests]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Connection Requests",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedRequests.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: Colors.transparent,
                ),
                itemBuilder: (context, index) {
                  final request = sortedRequests[index];
                  final requester =
                      _findUserById(allUsers, request.initiatedBy);

                  if (requester == null) return const SizedBox.shrink();

                  return RequestCard(
                    user: requester,
                    connection: request,
                    onAccept: () => _acceptRequest(request.id),
                    onDecline: () => _declineRequest(request.id),
                  );
                },
              ),
            ],
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (err, stack) => SliverToBoxAdapter(
        child: Center(
          child: Text('Error loading requests: $err'),
        ),
      ),
    );
  }

  Widget _buildRecentConnections(
      AsyncValue<List<ConnectionEntity>> connectionsAsync,
      List<UserEntity> allUsers) {
    return connectionsAsync.when(
      data: (connections) {
        // Filter to show only recent connections (e.g., last 30 days)
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        final recentConnections = connections
            .where((c) =>
                c.updatedAt != null && c.updatedAt!.isAfter(thirtyDaysAgo))
            .toList();

        if (recentConnections.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        // Sort connections by updated date, newest first
        recentConnections.sort((a, b) =>
            (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt));

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  "Recent Connections",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentConnections.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 0,
                  color: Colors.transparent,
                ),
                itemBuilder: (context, index) {
                  final connection = recentConnections[index];
                  final otherUserId = _getOtherUserId(connection);
                  final otherUser = _findUserById(allUsers, otherUserId);

                  if (otherUser == null) return const SizedBox.shrink();

                  return AcceptedCard(
                    user: otherUser,
                    connection: connection,
                  );
                },
              ),
            ],
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (err, stack) => SliverToBoxAdapter(
        child: Center(
          child: Text('Error loading connections: $err'),
        ),
      ),
    );
  }

  String _getOtherUserId(ConnectionEntity connection) {
    final currentUserId = ref.read(userProvider)!.id;
    return connection.user1Id == currentUserId
        ? connection.user2Id
        : connection.user1Id;
  }

  UserEntity? _findUserById(List<UserEntity> users, String userId) {
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _acceptRequest(String connectionId) async {
    try {
      await ref
          .read(connectionProvider.notifier)
          .acceptConnectionRequest(connectionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection request accepted'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to accept request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _declineRequest(String connectionId) async {
    try {
      await ref
          .read(connectionProvider.notifier)
          .rejectConnectionRequest(connectionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection request declined'),
          backgroundColor: Colors.grey,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to decline request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
