// lib/data/controller/project_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/models/testimonial_model.dart';
import 'package:mb/data/repository/auth_repository.dart';
import 'package:mb/data/repository/project_repository.dart';
import 'package:path/path.dart' as path;

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
      _isLoading = true;

      String bannerImagePath =
          await _processLogoImage(project.id, project.bannerImagePath);
      List<String> processedCarouselImages =
          await _processCarouselImages(project.id, project.carouselImagePaths);
      List<Testimonial> processedTestimonials =
          await _processTestimonials(project.id, project.testimonials);

      final updatedProject = project.copyWith(
        bannerImagePath: bannerImagePath,
        carouselImagePaths: processedCarouselImages,
        testimonials:
            processedTestimonials.isEmpty ? null : processedTestimonials,
      );

      await _repository.saveProject(updatedProject);
      await fetch();
    } catch (e) {
      print('Error saving project with images: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _repository.deleteProjectImages(projectId);
      await _repository.deleteProject(projectId);
      await fetch();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _processLogoImage(String projectId, String imagePath) async {
    if (imagePath.isNotEmpty &&
        !imagePath.startsWith('http') &&
        !imagePath.startsWith('assets/')) {
      final fileExtension = path.extension(imagePath).toLowerCase();
      final destinationFileName = 'logo$fileExtension';

      return await _repository.uploadProjectLogo(
          projectId, imagePath, destinationFileName);
    }
    return imagePath;
  }

  Future<List<String>> _processCarouselImages(
      String projectId, List<String> imagePaths) async {
    List<String> processedImages = [];

    for (int i = 0; i < imagePaths.length; i++) {
      String imagePath = imagePaths[i];
      try {
        if (imagePath.isNotEmpty &&
            !imagePath.startsWith('http') &&
            !imagePath.startsWith('assets/')) {
          final fileExtension = path.extension(imagePath).toLowerCase();
          final destinationFileName = 'carousel_${i + 1}$fileExtension';

          String uploadedUrl = await _repository.uploadCarouselImage(
              projectId, imagePath, destinationFileName);
          processedImages.add(uploadedUrl);
        } else {
          processedImages.add(imagePath);
        }
      } catch (e) {
        print('Error uploading carousel image: $e');
        processedImages.add(imagePath);
      }
    }

    return processedImages;
  }

  Future<List<Testimonial>> _processTestimonials(
      String projectId, List<Testimonial>? testimonials) async {
    if (testimonials == null || testimonials.isEmpty) {
      return [];
    }

    List<Testimonial> processedTestimonials = [];

    for (int i = 0; i < testimonials.length; i++) {
      final testimonial = testimonials[i];
      String avatarPath = testimonial.avatarPath;

      if (avatarPath.isNotEmpty &&
          !avatarPath.startsWith('http') &&
          !avatarPath.startsWith('assets/')) {
        try {
          final String uploadedPath = await _repository.uploadTestimonialAvatar(
              projectId, avatarPath, i);
          avatarPath = uploadedPath;
        } catch (e) {
          print('Error uploading testimonial avatar: $e');
        }
      }

      final processedTestimonial = Testimonial(
        quote: testimonial.quote,
        author: testimonial.author,
        role: testimonial.role,
        avatarPath: avatarPath,
      );

      processedTestimonials.add(processedTestimonial);
    }

    return processedTestimonials;
  }
}
