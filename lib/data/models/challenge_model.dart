// lib/data/models/challenge_model.dart
class Challenge {
  final String title;
  final String description;
  final String? solution;

  Challenge({
    required this.title,
    required this.description,
    this.solution,
  });

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      solution: map['solution'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'solution': solution,
    };
  }
}
