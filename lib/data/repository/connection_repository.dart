// lib/data/repository/connection_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mb/data/entities/connection_entity.dart';
import 'package:mb/data/enums/connection_identifier.dart';
import 'package:uuid/uuid.dart';

class ConnectionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "connections";

  Future<List<ConnectionEntity>> getUserConnections(String userId,
      {ConnectionIdentifier? status}) async {
    try {
      Query query = _firestore.collection(collectionPath).where(
            Filter.or(
              Filter('user1Id', isEqualTo: userId),
              Filter('user2Id', isEqualTo: userId),
            ),
          );

      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => ConnectionEntity.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user connections: $e');
    }
  }

  Future<ConnectionEntity> sendConnectionRequest(
      String fromUserId, String toUserId) async {
    try {
      final connectionId = const Uuid().v4();
      final now = DateTime.now();

      final connectionData = ConnectionEntity(
        id: connectionId,
        user1Id: fromUserId,
        user2Id: toUserId,
        status: ConnectionIdentifier.pending,
        initiatedBy: fromUserId,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(collectionPath)
          .doc(connectionId)
          .set(connectionData.toMap());

      return connectionData;
    } catch (e) {
      throw Exception('Failed to send connection request: $e');
    }
  }

  // Accept a connection request
  Future<ConnectionEntity> acceptConnectionRequest(String connectionId) async {
    try {
      final docRef = _firestore.collection(collectionPath).doc(connectionId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Connection request not found');
      }

      final connection =
          ConnectionEntity.fromMap(doc.id, doc.data() as Map<String, dynamic>);

      if (connection.status != ConnectionIdentifier.pending) {
        throw Exception('Connection is not in pending state');
      }

      final updatedConnection = connection.copyWith(
        status: ConnectionIdentifier.connected,
        updatedAt: DateTime.now(),
      );

      await docRef.update({
        'status': ConnectionIdentifier.connected.name,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      return updatedConnection;
    } catch (e) {
      throw Exception('Failed to accept connection request: $e');
    }
  }

  // Reject a connection request
  Future rejectConnectionRequest(String connectionId) async {
    try {
      //delete the connection request
      await _firestore.collection(collectionPath).doc(connectionId).delete();
    } catch (e) {
      throw Exception('Failed to reject connection request: $e');
    }
  }

  // Remove a connection
  Future<void> removeConnection(String connectionId) async {
    try {
      await _firestore.collection(collectionPath).doc(connectionId).delete();
    } catch (e) {
      throw Exception('Failed to remove connection: $e');
    }
  }

  Future<ConnectionEntity?> getConnectionBetweenUsers(
      String user1Id, String user2Id) async {
    try {
      // First check if user1 initiated to user2
      var query1 = await _firestore
          .collection(collectionPath)
          .where('user1Id', isEqualTo: user1Id)
          .where('user2Id', isEqualTo: user2Id)
          .limit(1)
          .get();

      if (query1.docs.isNotEmpty) {
        return ConnectionEntity.fromMap(
            query1.docs.first.id, query1.docs.first.data());
      }

      // Then check if user2 initiated to user1
      var query2 = await _firestore
          .collection(collectionPath)
          .where('user1Id', isEqualTo: user2Id)
          .where('user2Id', isEqualTo: user1Id)
          .limit(1)
          .get();

      if (query2.docs.isNotEmpty) {
        return ConnectionEntity.fromMap(
            query2.docs.first.id, query2.docs.first.data());
      }

      // No connection found between these users
      return null;
    } catch (e) {
      throw Exception('Failed to get connection between users: $e');
    }
  }

  // Watch a user's connections (stream)
  Stream<List<ConnectionEntity>> watchUserConnections(String userId,
      {ConnectionIdentifier? status}) {
    try {
      Query query = _firestore.collection(collectionPath).where(
            Filter.or(
              Filter('user1Id', isEqualTo: userId),
              Filter('user2Id', isEqualTo: userId),
            ),
          );

      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ConnectionEntity.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to watch user connections: $e');
    }
  }
}
