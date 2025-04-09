// lib/features/upsert_project/validators/project_info_validator.dart

class ProjectInfoValidator {
  /// Validates the role field (optional)
  static String? validateRole(String? value) {
    // Role is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length < 3) {
      return 'Role must be at least 3 characters long.';
    }

    if (value.trim().length > 50) {
      return 'Role cannot exceed 50 characters.';
    }

    return null;
  }

  /// Validates the development days count
  static String? validateDevelopmentDays(String? value) {
    // Development time is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final int? days = int.tryParse(value.trim());

    if (days == null) {
      return 'Please enter a valid number.';
    }

    if (days < 0) {
      return 'Development time cannot be negative.';
    }

    if (days > 3650) {
      // Approximately 10 years max
      return 'Development time seems too high. Please check.';
    }

    return null;
  }

  /// Formats development time duration into human-readable format
  static String formatDevelopmentTime(int days) {
    if (days < 1) {
      return 'Less than a day';
    }

    if (days < 7) {
      return '$days day${days == 1 ? '' : 's'}';
    }

    if (days < 30) {
      final int weeks = (days / 7).floor();
      final int remainingDays = days % 7;

      if (remainingDays == 0) {
        return '$weeks week${weeks == 1 ? '' : 's'}';
      } else {
        return '$weeks week${weeks == 1 ? '' : 's'} and $remainingDays day${remainingDays == 1 ? '' : 's'}';
      }
    }

    if (days < 365) {
      final int months = (days / 30).floor();
      final int remainingDays = days % 30;

      if (remainingDays == 0) {
        return '$months month${months == 1 ? '' : 's'}';
      } else if (remainingDays < 7) {
        return '$months month${months == 1 ? '' : 's'} and $remainingDays day${remainingDays == 1 ? '' : 's'}';
      } else {
        final int weeks = (remainingDays / 7).floor();
        return '$months month${months == 1 ? '' : 's'} and $weeks week${weeks == 1 ? '' : 's'}';
      }
    }

    final int years = (days / 365).floor();
    final int remainingDays = days % 365;

    if (remainingDays == 0) {
      return '$years year${years == 1 ? '' : 's'}';
    } else if (remainingDays < 30) {
      final int weeks = (remainingDays / 7).floor();
      return '$years year${years == 1 ? '' : 's'} and $weeks week${weeks == 1 ? '' : 's'}';
    } else {
      final int months = (remainingDays / 30).floor();
      return '$years year${years == 1 ? '' : 's'} and $months month${months == 1 ? '' : 's'}';
    }
  }

  /// Parse human-readable development time into days
  static int? parseDevelopmentTime(String input) {
    final String normalized = input.toLowerCase().trim();

    if (normalized.isEmpty) {
      return null;
    }

    // Try to parse as a regular number first
    final int? directDays = int.tryParse(normalized);
    if (directDays != null) {
      return directDays;
    }

    // Handle various time formats
    if (normalized.contains('year') || normalized.contains('yr')) {
      final RegExp yearPattern = RegExp(r'(\d+)(?:\s+|-)(?:year|yr)');
      final match = yearPattern.firstMatch(normalized);

      if (match != null) {
        final int years = int.parse(match.group(1)!);
        return years * 365;
      }
    }

    if (normalized.contains('month') || normalized.contains('mo')) {
      final RegExp monthPattern = RegExp(r'(\d+)(?:\s+|-)(?:month|mo)');
      final match = monthPattern.firstMatch(normalized);

      if (match != null) {
        final int months = int.parse(match.group(1)!);
        return months * 30;
      }
    }

    if (normalized.contains('week') || normalized.contains('wk')) {
      final RegExp weekPattern = RegExp(r'(\d+)(?:\s+|-)(?:week|wk)');
      final match = weekPattern.firstMatch(normalized);

      if (match != null) {
        final int weeks = int.parse(match.group(1)!);
        return weeks * 7;
      }
    }

    if (normalized.contains('day')) {
      final RegExp dayPattern = RegExp(r'(\d+)(?:\s+|-)(?:day)');
      final match = dayPattern.firstMatch(normalized);

      if (match != null) {
        final int days = int.parse(match.group(1)!);
        return days;
      }
    }

    return null;
  }

  /// Validates the release date
  static String? validateReleaseDate(DateTime? date) {
    // Release date is optional
    if (date == null) {
      return null;
    }

    // Check if date is in the future
    if (date.isAfter(DateTime.now().add(const Duration(days: 30)))) {
      return 'Release date cannot be more than a month in the future.';
    }

    // Check if date is too far in the past (arbitrary limit of 30 years)
    if (date
        .isBefore(DateTime.now().subtract(const Duration(days: 365 * 30)))) {
      return 'Release date seems too old. Please check.';
    }

    return null;
  }
}
