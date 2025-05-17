// lib/data/providers/connection_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/controller/connection_controller.dart';
import 'package:mb/data/entities/connection_entity.dart';
import 'package:mb/data/enums/connection_identifier.dart';
import 'package:mb/data/providers/api_provider.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/data/repository/connection_repository.dart';

final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  return ConnectionRepository();
});

final connectionProvider =
    StateNotifierProvider<ConnectionController, List<ConnectionEntity>?>((ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  final notification = ref.watch(notificationApiProvider);
  final auth = ref.watch(authRepositoryProvider);

  return ConnectionController(
      repository, notification, auth.getCurrentUser()!.uid);
});

final establishedConnectionsProvider =
    StreamProvider<List<ConnectionEntity>>((ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  final auth = ref.watch(authRepositoryProvider);

  return repository.watchUserConnections(
    auth.getCurrentUser()!.uid,
    status: ConnectionIdentifier.connected,
  );
});

final incomingConnectionRequestsProvider =
    StreamProvider<List<ConnectionEntity>>((ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  final auth = ref.watch(authRepositoryProvider);
  final currentUserId = auth.getCurrentUser()!.uid;

  return repository
      .watchUserConnections(currentUserId, status: ConnectionIdentifier.pending)
      .map((connections) =>
          connections.where((c) => c.initiatedBy != currentUserId).toList());
});

final allUserConnectionsProvider =
    StreamProvider<List<ConnectionEntity>>((ref) {
  final repository = ref.watch(connectionRepositoryProvider);
  final auth = ref.watch(authRepositoryProvider);

  return repository.watchUserConnections(
    auth.getCurrentUser()!.uid,
  );
});
