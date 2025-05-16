// lib/features/home/widgets/accepted_card.dart
import 'package:flutter/material.dart';
import 'package:mb/data/entities/connection_entity.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/features/home/utils/date_formatter.dart';
import 'package:mb/features/portofolio/screens/user_portofolio_screen.dart';
import 'package:lottie/lottie.dart';

class AcceptedCard extends StatelessWidget {
  final UserEntity user;
  final ConnectionEntity connection;

  const AcceptedCard({
    Key? key,
    required this.user,
    required this.connection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final timeAgo = DateFormatter.formatTimeAgo(
        connection.updatedAt ?? connection.createdAt);

    return InkWell(
      onTap: () => _viewUserProfile(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
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

            // User info
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
                    "Connection established • $timeAgo",
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
