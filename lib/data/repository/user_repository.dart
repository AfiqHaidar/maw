import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "users";

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch user: $e");
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to save user: $e");
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(collectionPath).doc(userId).delete();
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }
}
