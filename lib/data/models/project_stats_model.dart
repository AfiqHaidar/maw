// lib/data/models/project_stats_model.dart
class ProjectStats {
  final int users;
  final int stars;
  final int forks;
  final int downloads;
  final int contributions;

  ProjectStats({
    required this.users,
    required this.stars,
    required this.forks,
    required this.downloads,
    required this.contributions,
  });

  factory ProjectStats.fromMap(Map<String, dynamic> map) {
    return ProjectStats(
      users: map['users'] ?? '',
      stars: map['stars'] ?? '',
      forks: map['forks'] ?? '',
      downloads: map['downloads'] ?? '',
      contributions: map['contributions'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users,
      'stars': stars,
      'forks': forks,
      'downloads': downloads,
      'contributions': contributions,
    };
  }
}
