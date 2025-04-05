// lib/data/controller/project_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/repository/auth_repository.dart';
import 'package:mb/data/repository/project_repository.dart';

class ProjectController extends StateNotifier<List<ProjectEntity>?> {
  final ProjectRepository _repository;
  final AuthRepository _authRepository;
  bool _isLoading = false;

  ProjectController(this._repository, this._authRepository) : super(null);

  bool get isLoading => _isLoading;

  Future<void> fetch() async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      state = await _repository
          .getProjectsByUser(_authRepository.auth.currentUser!.uid);
    } catch (e) {
      print('Error fetching projects: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> upsertProject(ProjectEntity project) async {
    try {
      await _repository.saveProject(project);
      await fetch();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _repository.deleteProject(projectId);
      await fetch();
    } catch (e) {
      rethrow;
    }
  }
}
