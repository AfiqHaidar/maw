// lib/features/home/widgets/request_card.dart
import 'package:flutter/material.dart';
import 'package:mb/data/entities/connection_entity.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/features/home/utils/date_formatter.dart';
import 'package:mb/features/portofolio/screens/user_portofolio_screen.dart';
import 'package:lottie/lottie.dart';

class RequestCard extends StatelessWidget {
  final UserEntity user;
  final ConnectionEntity connection;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const RequestCard({
    Key? key,
    required this.user,
    required this.connection,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final timeAgo = DateFormatter.formatTimeAgo(connection.createdAt);

    return InkWell(
      onTap: () => _viewUserProfile(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User avatar
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.primary.withOpacity(0.1),
                  child: ClipOval(
                    child: Lottie.asset(
                      user.profilePicture,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // User info and action buttons
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "@${user.username}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "wants to connect with you • $timeAgo",
                        style: TextStyle(
                          color: theme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: const Text("Decline"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: const Text("Accept"),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewUserProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserPortfolioScreen(userId: user.id),
      ),
    );
  }
}
