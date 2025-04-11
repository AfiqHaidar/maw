// lib/data/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String username;
  final String profilePicture;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.profilePicture,
  });

  factory UserEntity.fromMap(String id, Map<String, dynamic> map) {
    return UserEntity(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'username': username,
      'profilePicture': profilePicture,
    };
  }
}
