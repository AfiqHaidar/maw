// lib/features/upsert_project/widgets/project_team_member_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/models/team_member_model.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

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

  @override
  void initState() {
    super.initState();
    _teamMembers = List.from(widget.initialMembers);
  }

  void _openAddTeamMemberDialog() async {
    final TeamMember? newMember = await showDialog<TeamMember>(
      context: context,
      builder: (context) => AddTeamMemberDialog(
        themeColor: widget.themeColor,
        teamMembers: _teamMembers,
      ),
    );

    if (newMember != null) {
      setState(() {
        _teamMembers.add(newMember);
      });

      // Notify parent of the change
      widget.onTeamMembersChanged(_teamMembers);
    }
  }

  void _removeTeamMember(int index) {
    setState(() {
      _teamMembers.removeAt(index);
    });

    // Notify parent of the change
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

        // Add Team Member button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _openAddTeamMemberDialog,
            icon: const Icon(Icons.person_add_rounded, size: 20),
            label: const Text("Add Team Member"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: widget.themeColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Display team members
        if (_teamMembers.isNotEmpty) ...[
          const Text(
            "Current Team",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _teamMembers.length,
            itemBuilder: (context, index) {
              final member = _teamMembers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.themeColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    // Avatar/Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.themeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: member.avatarPath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                member.avatarPath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    color: widget.themeColor,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              color: widget.themeColor,
                            ),
                    ),
                    const SizedBox(width: 12),
                    // Member name and role
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            member.role,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Remove button
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
              );
            },
          ),
        ] else ...[
          // Empty state
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  "No team members added yet",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Click the button above to add team members",
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

// Dialog for adding team members with both user selection and role input
class AddTeamMemberDialog extends ConsumerStatefulWidget {
  final Color themeColor;
  final List<TeamMember> teamMembers;

  const AddTeamMemberDialog({
    Key? key,
    required this.themeColor,
    required this.teamMembers,
  }) : super(key: key);

  @override
  ConsumerState<AddTeamMemberDialog> createState() =>
      _AddTeamMemberDialogState();
}

class _AddTeamMemberDialogState extends ConsumerState<AddTeamMemberDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  String _searchQuery = '';
  UserEntity? _selectedUser;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _selectUser(UserEntity user) {
    setState(() {
      _selectedUser = user;
    });
  }

  void _addTeamMember() {
    if (_selectedUser == null || _roleController.text.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a user and enter a role'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newMember = TeamMember(
      name: _selectedUser!.name,
      role: _roleController.text,
      avatarPath: _selectedUser!.profilePicture,
      userId: _selectedUser!.id,
    );

    Navigator.of(context).pop(newMember);
  }

  @override
  Widget build(BuildContext context) {
    // Get current user and all users
    final currentUser = ref.watch(userProvider);
    final allUsers = ref.watch(allUsersProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dialog header
            Row(
              children: [
                Icon(
                  Icons.group_add_rounded,
                  color: widget.themeColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Add Team Member",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 20,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search user by name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              autofocus: true,
            ),

            const SizedBox(height: 16),

            // Selected user and role section (visible when a user is selected)
            if (_selectedUser != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.themeColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.themeColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selected user info
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: widget.themeColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: _selectedUser!.profilePicture.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    _selectedUser!.profilePicture,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        color: widget.themeColor,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  color: widget.themeColor,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedUser!.name +
                                    (currentUser?.id == _selectedUser!.id
                                        ? " (You)"
                                        : ""),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "@${_selectedUser!.username}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Deselect button
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedUser = null;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Role input field
                    TextField(
                      controller: _roleController,
                      decoration: InputDecoration(
                        labelText: "Role",
                        hintText: "E.g., Developer, Designer, Team Lead",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Add button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addTeamMember,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: widget.themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Add to Team"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // User list
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: _selectedUser != null ? 200 : 300,
                ),
                child: allUsers.when(
                  data: (users) {
                    // Filter users:
                    // 1. Remove users already in the team
                    // 2. Apply search filter
                    final availableUsers = users.where((user) {
                      final bool isInTeam = widget.teamMembers
                          .any((member) => member.userId == user.id);
                      final bool matchesSearch = _searchQuery.isEmpty ||
                          user.name.toLowerCase().contains(_searchQuery) ||
                          user.username.toLowerCase().contains(_searchQuery);
                      return !isInTeam && matchesSearch;
                    }).toList();

                    if (availableUsers.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            _searchQuery.isNotEmpty
                                ? "No matching users found"
                                : "No available users to add",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableUsers.length,
                      itemBuilder: (context, index) {
                        final user = availableUsers[index];
                        final isCurrentUser = currentUser?.id == user.id;
                        final isSelected = _selectedUser?.id == user.id;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? widget.themeColor
                                  : widget.themeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                            child: user.profilePicture.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      user.profilePicture,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.person,
                                          color: isSelected
                                              ? Colors.white
                                              : widget.themeColor,
                                        );
                                      },
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: isSelected
                                        ? Colors.white
                                        : widget.themeColor,
                                  ),
                          ),
                          title: Text(
                            user.name + (isCurrentUser ? " (You)" : ""),
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "@${user.username}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: widget.themeColor,
                                  size: 20,
                                )
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: isSelected
                              ? widget.themeColor.withOpacity(0.05)
                              : null,
                          onTap: () {
                            _selectUser(user);
                          },
                        );
                      },
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: widget.themeColor,
                    ),
                  ),
                  error: (_, __) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade400,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Couldn't load users",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
