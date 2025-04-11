// lib/data/providers/project_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/controller.dart/project_controller.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/data/repository/project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository();
});

final projectProvider =
    StateNotifierProvider<ProjectController, List<ProjectEntity>?>((ref) {
  return ProjectController(
    ref.watch(projectRepositoryProvider),
    ref.watch(authRepositoryProvider),
  );
});
