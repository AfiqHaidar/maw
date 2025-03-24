// lib/features/portofolio/widgets/project_icon_mapper.dart
import 'package:flutter/material.dart';

class ProjectIconMapper {
  static IconData getIconFromName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'settings':
        return Icons.settings;
      case 'security':
        return Icons.security;
      case 'performance':
        return Icons.speed;
      case 'design':
        return Icons.design_services;
      case 'integration':
        return Icons.integration_instructions;
      case 'analytics':
        return Icons.analytics;
      case 'notification':
        return Icons.notifications;
      case 'sync':
        return Icons.sync;
      case 'cloud':
        return Icons.cloud;
      case 'mobile':
        return Icons.smartphone;
      case 'web':
        return Icons.web;
      case 'accessibility':
        return Icons.accessibility;
      case 'payment':
        return Icons.payment;
      case 'social':
        return Icons.share;
      default:
        return Icons.check_circle_outline;
    }
  }
}
