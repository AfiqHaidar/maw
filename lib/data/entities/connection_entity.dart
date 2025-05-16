// lib/data/entities/connection_entity.dart

import 'package:mb/data/enums/connection_identifier.dart';

class ConnectionEntity {
  final String id;
  final String user1Id;
  final String user2Id;
  final ConnectionIdentifier status;
  final String initiatedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ConnectionEntity({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.status,
    required this.initiatedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory ConnectionEntity.fromMap(String id, Map<String, dynamic> map) {
    return ConnectionEntity(
      id: id,
      user1Id: map['user1Id'] ?? '',
      user2Id: map['user2Id'] ?? '',
      status: ConnectionIdentifier.fromString(map['status'] ?? 'pending'),
      initiatedBy: map['initiatedBy'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      'status': status.name,
      'initiatedBy': initiatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ConnectionEntity copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    ConnectionIdentifier? status,
    String? initiatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConnectionEntity(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      status: status ?? this.status,
      initiatedBy: initiatedBy ?? this.initiatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
