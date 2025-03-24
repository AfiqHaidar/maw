// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/project_model.dart';

// class ProjectRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionPath = "projects";

//   Future<ProjectModel?> getProject(String projectId) async {
//     try {
//       DocumentSnapshot doc =
//           await _firestore.collection(collectionPath).doc(projectId).get();
//       if (doc.exists) {
//         return ProjectModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       throw Exception("Failed to fetch project: $e");
//     }
//   }

//   Future<List<ProjectModel>> getProjectsByUser(String userId) async {
//     try {
//       QuerySnapshot query = await _firestore
//           .collection(collectionPath)
//           .where('userId', isEqualTo: userId)
//           .get();

//       return query.docs
//           .map((doc) =>
//               ProjectModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       throw Exception("Failed to fetch user projects: $e");
//     }
//   }

//   Future<void> saveProject(ProjectModel project) async {
//     try {
//       await _firestore
//           .collection(collectionPath)
//           .doc(project.id)
//           .set(project.toMap(), SetOptions(merge: true));
//     } catch (e) {
//       throw Exception("Failed to save project: $e");
//     }
//   }

//   Future<void> deleteProject(String projectId) async {
//     try {
//       await _firestore.collection(collectionPath).doc(projectId).delete();
//     } catch (e) {
//       throw Exception("Failed to delete project: $e");
//     }
//   }
// }
