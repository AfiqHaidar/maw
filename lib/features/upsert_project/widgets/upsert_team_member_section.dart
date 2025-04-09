// lib/features/upsert_project/widgets/upsert_team_member_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/models/team_member_model.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';
import 'package:mb/features/upsert_project/validators/project_team_members_validator.dart';

class ProjectTeamMemberSection extends ConsumerStatefulWidget {
  final Color themeColor;
  final List<TeamMember> initialMembers;
  final Function(List<TeamMember>) onTeamMembersChanged;

  const ProjectTeamMemberSection({
    Key? key,
    required this.themeColor,
    required this.initialMembers,
    required this.onTeamMembersChanged,
  }) : super(key: key);

  @override
  ConsumerState<ProjectTeamMemberSection> createState() =>
      _ProjectTeamMemberSectionState();
}

class _ProjectTeamMemberSectionState
    extends ConsumerState<ProjectTeamMemberSection> {
  late List<TeamMember> _teamMembers;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  // ignore: unused_field
  UserEntity? _selectedUser;

  @override
  void initState() {
    super.initState();
    _teamMembers = List.from(widget.initialMembers);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectUser(UserEntity user) {
    setState(() {
      _selectedUser = user;
    });
    _openRoleDialog(user, null);
  }

  void _openRoleDialog(UserEntity user, TeamMember? existingMember) async {
    final String? role = await showDialog<String>(
      context: context,
      builder: (context) => TeamMemberRoleDialog(
        themeColor: widget.themeColor,
        userName: user.name,
        userAvatar: user.profilePicture,
        initialRole: existingMember?.role,
      ),
    );

    if (role != null) {
      setState(() {
        if (existingMember != null) {
          // Update existing member's role
          final index = _teamMembers.indexOf(existingMember);
          _teamMembers[index] = TeamMember(
            name: existingMember.name,
            role: role,
            avatarPath: existingMember.avatarPath,
            userId: existingMember.userId,
          );
        } else {
          // Add new member
          _teamMembers.add(TeamMember(
            name: user.name,
            role: role,
            avatarPath: user.profilePicture,
            userId: user.id,
          ));
        }
        _selectedUser = null; // Clear selection after adding
      });
      widget.onTeamMembersChanged(_teamMembers);
    }
  }

  void _editTeamMember(TeamMember member) async {
    final allUsers = await ref.read(allUsersProvider.future);
    final user = allUsers.firstWhere((user) => user.id == member.userId);
    _openRoleDialog(user, member);
  }

  void _removeTeamMember(int index) {
    setState(() {
      _teamMembers.removeAt(index);
    });
    widget.onTeamMembersChanged(_teamMembers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.groups_rounded,
          title: "Team Members",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

        // Description text
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            "Add people who contributed to this project.",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ),

        // User search field
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Search Team Member",
            hintText: "Search by name or username",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            helperText: "Find a user to add to the team",
            helperStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Search results
        Consumer(
          builder: (context, ref, child) {
            final allUsers = ref.watch(allUsersProvider);

            return allUsers.when(
              data: (users) {
                // Filter users:
                // 1. Remove users already in the team
                // 2. Apply search filter
                final availableUsers = users.where((user) {
                  final bool isInTeam =
                      _teamMembers.any((member) => member.userId == user.id);
                  final bool matchesSearch = _searchQuery.isNotEmpty &&
                      (user.name.toLowerCase().contains(_searchQuery) ||
                          user.username.toLowerCase().contains(_searchQuery));
                  return !isInTeam && matchesSearch;
                }).toList();

                if (_searchQuery.isEmpty) {
                  return const SizedBox
                      .shrink(); // Don't show anything if no search query
                }

                if (availableUsers.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Text(
                      "No matching users found",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableUsers.length,
                    itemBuilder: (context, index) {
                      final user = availableUsers[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: widget.themeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: user.profilePicture.isNotEmpty
                                  ? Image.asset(
                                      user.profilePicture,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.person,
                                          color: widget.themeColor,
                                        );
                                      },
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: widget.themeColor,
                                    ),
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "@${user.username}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _selectUser(user),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: widget.themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text("Add"),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, __) => Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: Text(
                  "Error loading users",
                  style: TextStyle(
                    color: Colors.red.shade600,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Current team members header
        if (_teamMembers.isNotEmpty) ...[
          Row(
            children: [
              Icon(
                Icons.people,
                color: widget.themeColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "Current Team Members",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.themeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Display team members
        if (_teamMembers.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _teamMembers.length,
            itemBuilder: (context, index) {
              final member = _teamMembers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: widget.themeColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.themeColor.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: member.avatarPath.isNotEmpty
                          ? Image.asset(
                              member.avatarPath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: widget.themeColor,
                                  size: 28,
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              color: widget.themeColor,
                              size: 28,
                            ),
                    ),
                  ),
                  title: Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          member.role,
                          style: TextStyle(
                            color: widget.themeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: widget.themeColor,
                          size: 20,
                        ),
                        onPressed: () => _editTeamMember(member),
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                        onPressed: () => _removeTeamMember(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ] else ...[
          // Empty state
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: widget.themeColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.themeColor.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "No team members added yet",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Search above to add people",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Dialog for adding or editing team member roles
class TeamMemberRoleDialog extends StatefulWidget {
  final Color themeColor;
  final String userName;
  final String userAvatar;
  final String? initialRole;

  const TeamMemberRoleDialog({
    Key? key,
    required this.themeColor,
    required this.userName,
    required this.userAvatar,
    this.initialRole,
  }) : super(key: key);

  @override
  State<TeamMemberRoleDialog> createState() => _TeamMemberRoleDialogState();
}

class _TeamMemberRoleDialogState extends State<TeamMemberRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialRole != null) {
      _roleController.text = widget.initialRole!;
    }
  }

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_roleController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialRole != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isEdit ? Icons.edit : Icons.person_add,
                      color: widget.themeColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEdit ? "Edit Team Member Role" : "Add Team Member",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // User info
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: widget.userAvatar.isNotEmpty
                          ? Image.asset(
                              widget.userAvatar,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: widget.themeColor,
                                  size: 30,
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              color: widget.themeColor,
                              size: 30,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Role input field
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(
                  labelText: "Role in Project",
                  hintText: "E.g., Developer, Designer, Team Lead",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: "Specify their contribution to the project",
                  helperStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                validator: ProjectTeamMembersValidator.validateRole,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  // Save button
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: widget.themeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isEdit ? "Update Role" : "Add Member"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
