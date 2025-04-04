import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/repository/auth_repository.dart';
import 'package:mb/data/repository/project_repository.dart';

class ProjectController extends StateNotifier<List<ProjectEntity>?> {
  final ProjectRepository _repository;
  final AuthRepository _authRepository;

  ProjectController(this._repository, this._authRepository) : super(null);

  Future<void> fetch() async {
    state = await _repository
        .getProjectsByUser(_authRepository.auth.currentUser!.uid);
  }

  Future<void> upsertProject(ProjectEntity project) async {
    await _repository.saveProject(project);
    await fetch();
  }
}
