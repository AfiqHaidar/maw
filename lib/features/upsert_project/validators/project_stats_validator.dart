// lib/features/upsert_project/validators/project_stats_validator.dart

class ProjectStatsValidator {
  /// Validates user count statistics
  static String? validateUsers(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 0) {
      return 'User count cannot be negative';
    }

    if (number > 1000000000) {
      // 1 billion max
      return 'Value is too large';
    }

    return null;
  }

  /// Validates star count
  static String? validateStars(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 0) {
      return 'Stars cannot be negative';
    }

    if (number > 1000000) {
      // 1 million max
      return 'Value is too large';
    }

    return null;
  }

  /// Validates fork count
  static String? validateForks(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 0) {
      return 'Forks cannot be negative';
    }

    if (number > 1000000) {
      // 1 million max
      return 'Value is too large';
    }

    return null;
  }

  /// Validates download count
  static String? validateDownloads(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 0) {
      return 'Downloads cannot be negative';
    }

    // Higher maximum since downloads can be very high
    if (number > 2000000000) {
      // 2 billion max
      return 'Value is too large';
    }

    return null;
  }

  /// Validates contribution count
  static String? validateContributions(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 0) {
      return 'Contributions cannot be negative';
    }

    if (number > 100000) {
      // 100,000 max (typically reasonable for contributions)
      return 'Value is too large';
    }

    return null;
  }

  /// Formats a number for display (e.g., 1000 -> 1K, 1500000 -> 1.5M)
  static String formatNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      final double result = number / 1000;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}K';
    } else if (number < 1000000000) {
      final double result = number / 1000000;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M';
    } else {
      final double result = number / 1000000000;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}B';
    }
  }

  /// Parse a formatted number back to int (e.g., "1K" -> 1000, "1.5M" -> 1500000)
  static int? parseFormattedNumber(String formattedNumber) {
    if (formattedNumber.isEmpty) {
      return 0;
    }

    // Try to parse as a regular number first
    final regularNumber = int.tryParse(formattedNumber);
    if (regularNumber != null) {
      return regularNumber;
    }

    // Handle formatted values
    final String sanitized = formattedNumber.trim().toUpperCase();

    if (sanitized.endsWith('K')) {
      final double? value =
          double.tryParse(sanitized.substring(0, sanitized.length - 1));
      if (value != null) {
        return (value * 1000).round();
      }
    } else if (sanitized.endsWith('M')) {
      final double? value =
          double.tryParse(sanitized.substring(0, sanitized.length - 1));
      if (value != null) {
        return (value * 1000000).round();
      }
    } else if (sanitized.endsWith('B')) {
      final double? value =
          double.tryParse(sanitized.substring(0, sanitized.length - 1));
      if (value != null) {
        return (value * 1000000000).round();
      }
    }

    return null;
  }
}
