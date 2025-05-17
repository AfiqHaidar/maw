// lib/data/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String username;
  final String profilePicture;
  final String? fcmToken;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.profilePicture,
    this.fcmToken,
  });

  factory UserEntity.fromMap(String id, Map<String, dynamic> map) {
    return UserEntity(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      fcmToken: map['fcmToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'username': username,
      'profilePicture': profilePicture,
      'fcmToken': fcmToken,
    };
  }
}
