// lib/features/portofolio/widgets/project_team_member_card.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/project_model.dart';

typedef LastNameGetter = String Function(String fullName);

class ProjectTeamMemberCard extends StatelessWidget {
  final TeamMember member;
  final Color themeColor;
  final LastNameGetter getLastName;

  const ProjectTeamMemberCard({
    Key? key,
    required this.member,
    required this.themeColor,
    required this.getLastName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
              image: member.avatarPath != null
                  ? DecorationImage(
                      image: AssetImage(member.avatarPath!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: member.avatarPath == null
                ? Center(
                    child: Text(
                      member.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            getLastName(member.name),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (member.role != null) ...[
            const SizedBox(height: 2),
            Text(
              member.role!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
