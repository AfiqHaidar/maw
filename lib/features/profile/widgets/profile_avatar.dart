// lib/features/profile/widgets/profile_avatar.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfileAvatar extends StatelessWidget {
  final String avatarPath;
  final double size;

  const ProfileAvatar({
    Key? key,
    required this.avatarPath,
    this.size = 110,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.all(3), // Border width
      child: ClipOval(
        child: Lottie.asset(
          avatarPath.isNotEmpty
              ? avatarPath
              : 'assets/animations/blue_hang.json',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
