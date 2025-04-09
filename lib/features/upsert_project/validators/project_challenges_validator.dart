// lib/features/upsert_project/validators/project_challenges_validator.dart

class ProjectChallengesValidator {
  /// Validates the challenge title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a challenge title.';
    }

    if (value.trim().length < 3) {
      return 'Challenge title must be at least 3 characters long.';
    }

    if (value.trim().length > 50) {
      return 'Challenge title cannot exceed 50 characters.';
    }

    return null;
  }

  /// Validates the challenge description
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a challenge description.';
    }

    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long.';
    }

    if (value.trim().length > 500) {
      return 'Description is too long (maximum 500 characters).';
    }

    return null;
  }

  /// Validates the solution (optional field)
  static String? validateSolution(String? value) {
    // Solution is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length < 10) {
      return 'Solution must be at least 10 characters long.';
    }

    if (value.trim().length > 500) {
      return 'Solution is too long (maximum 500 characters).';
    }

    return null;
  }

  /// Group validation for a complete challenge
  static Map<String, String?> validateChallenge({
    required String title,
    required String description,
    String? solution,
  }) {
    return {
      'title': validateTitle(title),
      'description': validateDescription(description),
      'solution': validateSolution(solution),
    };
  }

  /// Check if a challenge is valid
  static bool isChallengeValid({
    required String title,
    required String description,
    String? solution,
  }) {
    final validationResults = validateChallenge(
      title: title,
      description: description,
      solution: solution,
    );

    return !validationResults.values.any((error) => error != null);
  }
}
