// lib/features/upsert_project/validators/project_features_validator.dart

class ProjectFeaturesValidator {
  /// Validates the feature title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a feature title.';
    }

    if (value.trim().length < 3) {
      return 'Feature title must be at least 3 characters long.';
    }

    if (value.trim().length > 50) {
      return 'Feature title cannot exceed 50 characters.';
    }

    return null;
  }

  /// Validates the feature description
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a feature description.';
    }

    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long.';
    }

    if (value.trim().length > 500) {
      return 'Description is too long (maximum 500 characters).';
    }

    return null;
  }

  /// Validates the feature icon name
  static String? validateIconName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select an icon for the feature.';
    }

    // Check if the value is a valid hex code for Material Icons
    // Format should be 0xeXXX
    final RegExp hexPattern = RegExp(r'^0x[e][0-9a-fA-F]{3,4}$');
    if (!value.startsWith('0xe') && !hexPattern.hasMatch(value)) {
      return 'Invalid icon format.';
    }

    return null;
  }

  /// Group validation for a complete feature
  static Map<String, String?> validateFeature({
    required String title,
    required String description,
    required String iconName,
  }) {
    return {
      'title': validateTitle(title),
      'description': validateDescription(description),
      'iconName': validateIconName(iconName),
    };
  }

  /// Check if a feature is valid
  static bool isFeatureValid({
    required String title,
    required String description,
    required String iconName,
  }) {
    final validationResults = validateFeature(
      title: title,
      description: description,
      iconName: iconName,
    );

    return !validationResults.values.any((error) => error != null);
  }

  /// Gets a readable name for a Material Icon
  static String getIconName(String iconCodePoint) {
    // Map of common icon code points to readable names
    final Map<String, String> iconNames = {
      '0xe5ca': 'Check',
      '0xe8b8': 'Settings',
      '0xe80c': 'Speed',
      '0xe3f4': 'Security',
      '0xe87f': 'Notifications',
      '0xe332': 'Palette',
      '0xe8f4': 'Statistics',
      '0xe8b5': 'Search',
      '0xe325': 'Music',
      '0xe051': 'Video',
      '0xe0d0': 'Cloud',
      '0xe8f8': 'Storage',
      '0xe873': 'Language',
      '0xe1db': 'Calendar',
      '0xe80e': 'Timer',
      '0xe0af': 'Share',
      // Add more mappings as needed
    };

    return iconNames[iconCodePoint] ?? 'Icon';
  }
}
