// lib/features/upsert_project/validators/project_enhancements_validator.dart

import 'package:flutter/material.dart';

class ProjectEnhancementsValidator {
  /// Validates the enhancement title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an enhancement title.';
    }

    if (value.trim().length < 3) {
      return 'Enhancement title must be at least 3 characters long.';
    }

    if (value.trim().length > 50) {
      return 'Enhancement title cannot exceed 50 characters.';
    }

    return null;
  }

  /// Validates the enhancement description
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an enhancement description.';
    }

    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long.';
    }

    if (value.trim().length > 500) {
      return 'Description is too long (maximum 500 characters).';
    }

    return null;
  }

  /// Validates the enhancement status
  static String? validateStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a status.';
    }

    // Optional: Validate against allowed statuses
    final allowedStatuses = ['Planned', 'In Progress', 'Completed', 'On Hold'];

    if (!allowedStatuses.contains(value)) {
      return 'Please select a valid status.';
    }

    return null;
  }

  /// Group validation for a complete enhancement
  static Map<String, String?> validateEnhancement({
    required String title,
    required String description,
    required String status,
  }) {
    return {
      'title': validateTitle(title),
      'description': validateDescription(description),
      'status': validateStatus(status),
    };
  }

  /// Check if an enhancement is valid
  static bool isEnhancementValid({
    required String title,
    required String description,
    required String status,
  }) {
    final validationResults = validateEnhancement(
      title: title,
      description: description,
      status: status,
    );

    return !validationResults.values.any((error) => error != null);
  }

  /// Get a color for the status
  static Color getStatusColor(String status,
      {Color defaultColor = const Color(0xFF9E9E9E)}) {
    switch (status.toLowerCase()) {
      case 'planned':
        return const Color(0xFF2196F3); // Blue
      case 'in progress':
        return const Color(0xFFFFC107); // Amber
      case 'completed':
        return const Color(0xFF4CAF50); // Green
      case 'on hold':
        return const Color(0xFF9E9E9E); // Grey
      default:
        return defaultColor;
    }
  }
}
