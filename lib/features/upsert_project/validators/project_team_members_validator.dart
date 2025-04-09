// lib/features/upsert_project/validators/project_team_members_validator.dart

class ProjectTeamMembersValidator {
  /// Validates the team member name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a team member name.';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long.';
    }

    if (value.trim().length > 50) {
      return 'Name cannot exceed 50 characters.';
    }

    return null;
  }

  /// Validates the team member role
  static String? validateRole(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a team member role.';
    }

    if (value.trim().length < 3) {
      return 'Role must be at least 3 characters long.';
    }

    if (value.trim().length > 50) {
      return 'Role cannot exceed 50 characters.';
    }

    return null;
  }

  /// Validates the team member userId
  static String? validateUserId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a valid user.';
    }

    return null;
  }

  /// Group validation for a complete team member
  static Map<String, String?> validateTeamMember({
    required String name,
    required String role,
    required String userId,
    required String avatarPath,
  }) {
    return {
      'name': validateName(name),
      'role': validateRole(role),
      'userId': validateUserId(userId),
      // Avatar path is typically handled separately since it's selected via UI
    };
  }

  /// Check if a team member is valid
  static bool isTeamMemberValid({
    required String name,
    required String role,
    required String userId,
    required String avatarPath,
  }) {
    final validationResults = validateTeamMember(
      name: name,
      role: role,
      userId: userId,
      avatarPath: avatarPath,
    );

    return !validationResults.values.any((error) => error != null);
  }
}
