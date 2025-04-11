// lib/data/repository/project_repository.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mb/data/services/cache/cache_manager.dart';

class ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "projects";
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CacheManager _cacheManager = CacheManager();

  Future<ProjectEntity?> getProject(String projectId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(projectId).get();
      if (doc.exists) {
        ProjectEntity project =
            ProjectEntity.fromMap(doc.id, doc.data() as Map<String, dynamic>);

        // Process project images through cache
        return await _cacheManager.processProjectImages(project);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch project: $e");
    }
  }

  Future<List<ProjectEntity>> getProjectsByUser(String userId) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(collectionPath)
          .where('userId', isEqualTo: userId)
          .get();

      List<ProjectEntity> projects = query.docs
          .map((doc) =>
              ProjectEntity.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      // Process all projects through cache
      List<ProjectEntity> cachedProjects = [];
      for (var project in projects) {
        cachedProjects.add(await _cacheManager.processProjectImages(project));
      }

      // Preload all project images in the background
      _cacheManager.preloadMultipleProjects(projects);

      return cachedProjects;
    } catch (e) {
      throw Exception("Failed to fetch user projects: $e");
    }
  }

  Future<void> saveProject(ProjectEntity project) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(project.id)
          .set(project.toMap(), SetOptions(merge: true));

      // Preload project images after saving
      _cacheManager.preloadProjectImages(project);
    } catch (e) {
      throw Exception("Failed to save project: $e");
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection(collectionPath).doc(projectId).delete();

      // Clear project cache
      await _cacheManager.clearProjectCache(projectId);
    } catch (e) {
      throw Exception("Failed to delete project: $e");
    }
  }

  Future<String> uploadProjectLogo(
      String projectId, String imagePath, String destinationFileName) async {
    try {
      final file = File(imagePath);
      final reference = _storage
          .ref()
          .child('projects/$projectId/logo/$destinationFileName')
          .putFile(file);

      final snapshot = await reference;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Cache the uploaded image
      await _cacheManager.getImage(downloadUrl, projectId, 'logo');

      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload project logo: $e");
    }
  }

  Future<String> uploadCarouselImage(
      String projectId, String imagePath, String destinationFileName) async {
    try {
      final file = File(imagePath);
      final reference = _storage
          .ref()
          .child('projects/$projectId/carousel/$destinationFileName')
          .putFile(file);

      final snapshot = await reference;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Cache the uploaded image
      await _cacheManager.getImage(
          downloadUrl, projectId, 'carousel_$destinationFileName');

      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload carousel image: $e");
    }
  }

  Future<void> deleteProjectImages(String projectId) async {
    try {
      final logoRef = _storage.ref().child('projects/$projectId/logo');
      final carouselRef = _storage.ref().child('projects/$projectId/carousel');

      try {
        final logoList = await logoRef.listAll();
        for (var item in logoList.items) {
          await item.delete();
        }

        final carouselList = await carouselRef.listAll();
        for (var item in carouselList.items) {
          await item.delete();
        }
      } catch (e) {
        print('Error deleting images: $e');
      }

      // Clear project cache
      await _cacheManager.clearProjectCache(projectId);
    } catch (e) {
      print('Error accessing image directories: $e');
    }
  }

  // Clean all expired cache
  Future<void> cleanExpiredCache() async {
    await _cacheManager.cleanExpiredCache();
  }

  // Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    return await _cacheManager.getCacheStats();
  }
}
