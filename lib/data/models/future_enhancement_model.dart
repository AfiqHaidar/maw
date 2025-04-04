class FutureEnhancement {
  final String title;
  final String description;
  final String status;

  FutureEnhancement({
    required this.title,
    required this.description,
    required this.status,
  });

  factory FutureEnhancement.fromMap(Map<String, dynamic> map) {
    return FutureEnhancement(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
    };
  }
}
