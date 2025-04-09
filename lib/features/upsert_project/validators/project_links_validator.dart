// lib/features/upsert_project/validators/project_links_validator.dart

class ProjectLinksValidator {
  /// Validates the main project link
  static String? validateMainLink(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a project link.';
    }

    if (!_isValidUrl(value)) {
      return 'Please enter a valid URL (e.g., https://example.com)';
    }

    return null;
  }

  /// Validates the GitHub link (optional field)
  static String? validateGithubLink(String? value) {
    // GitHub link is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!_isValidUrl(value)) {
      return 'Please enter a valid URL (e.g., https://github.com/username/repo)';
    }

    // Check if it's a GitHub URL
    final Uri? uri = Uri.tryParse(value);
    if (uri != null && uri.host.isNotEmpty) {
      if (!uri.host.contains('github.com')) {
        return 'Please enter a valid GitHub URL';
      }
    }

    return null;
  }

  /// Validates an additional link
  static String? validateAdditionalLink(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a link.';
    }

    if (!_isValidUrl(value)) {
      return 'Please enter a valid URL (e.g., https://example.com)';
    }

    return null;
  }

  /// Checks if a string is a valid URL
  static bool _isValidUrl(String value) {
    // Basic URL pattern matching
    final RegExp urlPattern = RegExp(
      r'^(https?:\/\/)?' + // protocol
          r'([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+' + // domain name
          r'[a-zA-Z]{2,}' + // TLD
          r'(\/[^\s]*)?' + // path
          r'$',
      caseSensitive: false,
    );

    return urlPattern.hasMatch(value.trim());
  }

  /// Formats a URL to ensure it has a protocol
  static String formatUrl(String url) {
    if (url.trim().isEmpty) {
      return url;
    }

    if (!url.trim().startsWith('http://') &&
        !url.trim().startsWith('https://')) {
      return 'https://${url.trim()}';
    }

    return url.trim();
  }
}
