// lib/features/home/widgets/user_search_results.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/features/portofolio/screens/user_portofolio_screen.dart';

class UserSearchResults extends ConsumerWidget {
  final AsyncValue<List<UserEntity>> allUsersAsync;
  final UserEntity currentUser;
  final String searchQuery;

  const UserSearchResults({
    Key? key,
    required this.allUsersAsync,
    required this.currentUser,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return allUsersAsync.when(
      data: (users) {
        final filteredUsers = users
            .where((user) =>
                user.id != currentUser.id &&
                (user.name.toLowerCase().contains(searchQuery) ||
                    user.username.toLowerCase().contains(searchQuery)))
            .toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return _buildUserCard(context, user);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error loading users: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserEntity user) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(6),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: ClipOval(
            child: Lottie.asset(
              user.profilePicture,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          user.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        onTap: () {
          // Navigate to the user's portfolio screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserPortfolioScreen(userId: user.id),
            ),
          );
        },
      ),
    );
  }
}
