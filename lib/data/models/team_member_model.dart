class TeamMember {
  final String name;
  final String role;
  final String avatarPath;
  final String userId;

  TeamMember({
    required this.name,
    required this.role,
    required this.avatarPath,
    required this.userId,
  });

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      avatarPath: map['avatarPath'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'avatarPath': avatarPath,
      'userId': userId,
    };
  }
}
