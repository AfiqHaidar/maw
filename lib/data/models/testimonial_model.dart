class Testimonial {
  final String quote;
  final String author;
  final String role;
  final String avatarPath;

  Testimonial({
    required this.quote,
    required this.author,
    required this.role,
    required this.avatarPath,
  });

  factory Testimonial.fromMap(Map<String, dynamic> map) {
    return Testimonial(
      quote: map['quote'] ?? '',
      author: map['author'] ?? '',
      role: map['role'] ?? '',
      avatarPath: map['avatarPath'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quote': quote,
      'author': author,
      'role': role,
      'avatarPath': avatarPath,
    };
  }
}
