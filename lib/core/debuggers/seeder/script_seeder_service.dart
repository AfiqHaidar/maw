// lib/core/debuggers/seeder/script_seeder_service.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreSeeder {
  final FirebaseFirestore _firestore;

  FirestoreSeeder({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> seedProjects(
      {String assetPath = 'assets/data/projects.json'}) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> data = json.decode(jsonString);

      final Map<String, dynamic> projects = data['projects'];

      final WriteBatch batch = _firestore.batch();

      projects.forEach((String projectId, dynamic projectData) {
        final DocumentReference projectRef =
            _firestore.collection('projects').doc(projectId);
        batch.set(projectRef, projectData);
      });

      await batch.commit();

      print('Successfully seeded ${projects.length} projects to Firestore!');
    } catch (e) {
      print('Error seeding projects: $e');
      rethrow;
    }
  }

  Future<void> seedProjectsFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> data = json.decode(jsonString);
      final Map<String, dynamic> projects = data['projects'];

      final WriteBatch batch = _firestore.batch();

      projects.forEach((String projectId, dynamic projectData) {
        final DocumentReference projectRef =
            _firestore.collection('projects').doc(projectId);
        batch.set(projectRef, projectData);
      });

      await batch.commit();

      print('Successfully seeded ${projects.length} projects to Firestore!');
    } catch (e) {
      print('Error seeding projects: $e');
      rethrow;
    }
  }

  Future<void> seedProjectsFromMap(Map<String, dynamic> projects) async {
    try {
      final WriteBatch batch = _firestore.batch();

      projects.forEach((String projectId, dynamic projectData) {
        final DocumentReference projectRef =
            _firestore.collection('projects').doc(projectId);
        batch.set(projectRef, projectData);
      });

      await batch.commit();

      print('Successfully seeded ${projects.length} projects to Firestore!');
    } catch (e) {
      print('Error seeding projects: $e');
      rethrow;
    }
  }
}

/// Example usage:
/// 
/// // Option 1: Seed from an asset file
/// void seedProjectsFromAsset() async {
///   final seeder = FirestoreSeeder();
///   await seeder.seedProjects(assetPath: 'assets/data/projects.json');
/// }
/// 
/// // Option 2: Seed from a raw JSON string
/// void seedProjectsFromRawJson() async {
///   final seeder = FirestoreSeeder();
///   final String jsonData = '{"projects": {...}}'; // Your JSON string
///   await seeder.seedProjectsFromJson(jsonData);
/// }
///
/// // Option 3: Add a button in your app for seeding
/// ElevatedButton(
///   onPressed: () async {
///     final seeder = FirestoreSeeder();
///     await seeder.seedProjects();
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text('Database seeded successfully!'))
///     );
///   },
///   child: Text('Seed Database'),
/// )