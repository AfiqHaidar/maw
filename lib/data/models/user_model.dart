class UserModel {
  final String id;
  final String email;
  final String name;
  final String username;
  final String profilePicture;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    required this.profilePicture,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
    );
  }

  // Convert UserModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'username': username,
      'profilePicture': profilePicture,
    };
  }
}
