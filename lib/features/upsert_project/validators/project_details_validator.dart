// lib/features/upsert_project/utils/project_details_validator.dart

class ProjectDetailsValidator {
  /// Validates the project name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a project name.';
    }

    if (value.trim().length < 3) {
      return 'Project name must be at least 3 characters long.';
    }

    if (value.trim().length > 100) {
      return 'Project name cannot exceed 100 characters.';
    }

    return null;
  }

  /// Validates the short description (optional field)
  static String? validateShortDescription(String? value) {
    // Short description is optional
    if (value == null || value.trim().isEmpty) {
      return 'Please enter project short description.';
    }

    if (value.trim().length < 10) {
      return 'Short description must be at least 10 characters long.';
    }

    if (value.trim().length > 250) {
      return 'Short description cannot exceed 250 characters.';
    }

    return null;
  }

  /// Validates the project details
  static String? validateDetails(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter project details.';
    }

    if (value.trim().length < 50) {
      return 'Project details must be at least 50 characters long.';
    }

    // No upper limit enforced, but can be added if needed
    // if (value.trim().length > 5000) {
    //   return 'Project details are too long (maximum 5000 characters).';
    // }

    return null;
  }

  /// Validates the category selection
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a category.';
    }
    return null;
  }
}
