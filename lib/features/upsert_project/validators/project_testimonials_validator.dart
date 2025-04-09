// lib/features/upsert_project/validators/project_testimonials_validator.dart

class ProjectTestimonialsValidator {
  /// Validates the testimonial quote
  static String? validateQuote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a testimonial quote.';
    }

    if (value.trim().length < 10) {
      return 'Quote must be at least 10 characters long.';
    }

    if (value.trim().length > 500) {
      return 'Quote is too long (maximum 500 characters).';
    }

    return null;
  }

  /// Validates the author name
  static String? validateAuthor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an author name.';
    }

    if (value.trim().length < 2) {
      return 'Author name must be at least 2 characters long.';
    }

    if (value.trim().length > 50) {
      return 'Author name cannot exceed 50 characters.';
    }

    return null;
  }

  /// Validates the author role
  static String? validateRole(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an author role.';
    }

    if (value.trim().length < 2) {
      return 'Role must be at least 2 characters long.';
    }

    if (value.trim().length > 50) {
      return 'Role cannot exceed 50 characters.';
    }

    return null;
  }

  /// Validates the avatar path (optional)
  static String? validateAvatarPath(String? value) {
    // Avatar is optional, so null or empty is acceptable
    return null;
  }

  /// Group validation for a complete testimonial
  static Map<String, String?> validateTestimonial({
    required String quote,
    required String author,
    required String role,
    required String avatarPath,
  }) {
    return {
      'quote': validateQuote(quote),
      'author': validateAuthor(author),
      'role': validateRole(role),
      'avatarPath': validateAvatarPath(avatarPath),
    };
  }

  /// Check if a testimonial is valid
  static bool isTestimonialValid({
    required String quote,
    required String author,
    required String role,
    required String avatarPath,
  }) {
    final validationResults = validateTestimonial(
      quote: quote,
      author: author,
      role: role,
      avatarPath: avatarPath,
    );

    return !validationResults.values.any((error) => error != null);
  }
}
