import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "projects";
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<ProjectEntity?> getProject(String projectId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(projectId).get();
      if (doc.exists) {
        return ProjectEntity.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
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

      return query.docs
          .map((doc) =>
              ProjectEntity.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
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
    } catch (e) {
      throw Exception("Failed to save project: $e");
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection(collectionPath).doc(projectId).delete();
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
      return await snapshot.ref.getDownloadURL();
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
      return await snapshot.ref.getDownloadURL();
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
    } catch (e) {
      print('Error accessing image directories: $e');
    }
  }
}
