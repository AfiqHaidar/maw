// lib/data/models/feature_model.dart
class Feature {
  final String title;
  final String description;
  final String iconName;

  Feature({
    required this.title,
    required this.description,
    required this.iconName,
  });

  factory Feature.fromMap(Map<String, dynamic> map) {
    return Feature(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      iconName: map['iconName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'iconName': iconName,
    };
  }
}
