// lib/data/controller/connection_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/api/notification_api.dart';
import 'package:mb/data/entities/connection_entity.dart';
import 'package:mb/data/repository/connection_repository.dart';

class ConnectionController extends StateNotifier<List<ConnectionEntity>?> {
  final ConnectionRepository _repository;
  final String _userId;
  final NotificationApi _notificationApi;

  ConnectionController(this._repository, this._notificationApi, this._userId)
      : super(null) {
    fetchConnections();
  }

  Future<void> fetchConnections() async {
    try {
      final connections = await _repository.getUserConnections(_userId);
      state = connections;
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }

  Future<ConnectionEntity?> connectionBetweenUsers(
      String userId1, String userId2) async {
    try {
      final connection =
          await _repository.getConnectionBetweenUsers(userId1, userId2);
      return connection;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendConnectionRequest(String toUserId) async {
    try {
      final connection =
          await _repository.sendConnectionRequest(_userId, toUserId);

      _notificationApi.sendConnectionRequestNotification(
        targetUserId: toUserId,
        connectionId: connection.id,
        fromUserId: _userId,
      );

      fetchConnections();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptConnectionRequest(String connectionId) async {
    try {
      await _repository.acceptConnectionRequest(connectionId);

      final connections =
          state ?? await _repository.getUserConnections(_userId);
      final connection = connections.firstWhere((c) => c.id == connectionId);

      _notificationApi.sendConnectionAcceptedNotification(
        targetUserId: connection.initiatedBy,
        connectionId: connectionId,
        fromUserId: _userId,
      );

      fetchConnections();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectConnectionRequest(String connectionId) async {
    try {
      await _repository.rejectConnectionRequest(connectionId);
      fetchConnections();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeConnection(String connectionId) async {
    try {
      await _repository.removeConnection(connectionId);
      fetchConnections();
    } catch (e) {
      rethrow;
    }
  }
}
