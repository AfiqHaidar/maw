import 'package:flutter/material.dart';
import 'package:mb/data/enums/banner_identifier.dart';

class ProjectModel {
  final String id;
  final String userId;
  final String name;
  final Color bannerBgColor;
  final BannerIdentifier bannerType;
  final String bannerImagePath;
  final String bannerLottiePath;
  final List<String> carouselImagePaths;
  final String details;
  final String link;
  final List<String>? techStack;
  final List<String>? tags;
  final DateTime? releaseDate;

  // Added fields for enhanced project details
  final String? shortDescription;
  final String? role;
  final Duration? developmentTime;
  final List<TeamMember>? teamMembers;
  final List<Feature>? keyFeatures;
  final List<Challenge>? challenges;
  final String? githubLink;
  final List<String>? additionalLinks;
  final List<Testimonial>? testimonials;
  final ProjectStats? stats;
  final List<Future>? futureEnhancements;

  ProjectModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.bannerBgColor,
    required this.bannerType,
    required this.bannerImagePath,
    required this.bannerLottiePath,
    required this.carouselImagePaths,
    required this.details,
    required this.link,
    this.techStack,
    this.tags,
    this.releaseDate,
    this.shortDescription,
    this.role,
    this.developmentTime,
    this.teamMembers,
    this.keyFeatures,
    this.challenges,
    this.githubLink,
    this.additionalLinks,
    this.testimonials,
    this.stats,
    this.futureEnhancements,
  });

  factory ProjectModel.fromMap(String id, Map<String, dynamic> map) {
    return ProjectModel(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      bannerBgColor: Color(map['bannerBgColor'] ?? 0xFFFFFFFF),
      bannerType: BannerIdentifierExtension.fromString(map['bannerType'] ?? ''),
      bannerImagePath: map['bannerImagePath'] ?? '',
      bannerLottiePath: map['bannerLottiePath'] ?? '',
      carouselImagePaths: List<String>.from(map['carouselImagePaths'] ?? []),
      details: map['details'] ?? '',
      link: map['link'] ?? '',
      techStack:
          map['techStack'] != null ? List<String>.from(map['techStack']) : null,
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
      releaseDate: map['releaseDate'] != null
          ? DateTime.tryParse(map['releaseDate'])
          : null,
      shortDescription: map['shortDescription'],
      role: map['role'],
      developmentTime: map['developmentTime'] != null
          ? Duration(days: map['developmentTime'])
          : null,
      teamMembers: map['teamMembers'] != null
          ? (map['teamMembers'] as List)
              .map((m) => TeamMember.fromMap(m))
              .toList()
          : null,
      keyFeatures: map['keyFeatures'] != null
          ? (map['keyFeatures'] as List).map((f) => Feature.fromMap(f)).toList()
          : null,
      challenges: map['challenges'] != null
          ? (map['challenges'] as List)
              .map((c) => Challenge.fromMap(c))
              .toList()
          : null,
      githubLink: map['githubLink'],
      additionalLinks: map['additionalLinks'] != null
          ? List<String>.from(map['additionalLinks'])
          : null,
      testimonials: map['testimonials'] != null
          ? (map['testimonials'] as List)
              .map((t) => Testimonial.fromMap(t))
              .toList()
          : null,
      stats: map['stats'] != null ? ProjectStats.fromMap(map['stats']) : null,
      futureEnhancements: map['futureEnhancements'] != null
          ? (map['futureEnhancements'] as List)
              .map((f) => Future.fromMap(f))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'bannerBgColor': bannerBgColor.value,
      'bannerType': bannerType.name,
      'bannerImagePath': bannerImagePath,
      'bannerLottiePath': bannerLottiePath,
      'carouselImagePaths': carouselImagePaths,
      'details': details,
      'link': link,
      'techStack': techStack,
      'tags': tags,
      'releaseDate': releaseDate?.toIso8601String(),
      'shortDescription': shortDescription,
      'role': role,
      'developmentTime': developmentTime?.inDays,
      'teamMembers': teamMembers?.map((m) => m.toMap()).toList(),
      'keyFeatures': keyFeatures?.map((f) => f.toMap()).toList(),
      'challenges': challenges?.map((c) => c.toMap()).toList(),
      'githubLink': githubLink,
      'additionalLinks': additionalLinks,
      'testimonials': testimonials?.map((t) => t.toMap()).toList(),
      'stats': stats?.toMap(),
      'futureEnhancements': futureEnhancements?.map((f) => f.toMap()).toList(),
    };
  }
}

class TeamMember {
  final String name;
  final String? role;
  final String? avatarPath;
  final String? linkedinUrl;

  TeamMember({
    required this.name,
    this.role,
    this.avatarPath,
    this.linkedinUrl,
  });

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      name: map['name'] ?? '',
      role: map['role'],
      avatarPath: map['avatarPath'],
      linkedinUrl: map['linkedinUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'avatarPath': avatarPath,
      'linkedinUrl': linkedinUrl,
    };
  }
}

class Feature {
  final String title;
  final String description;
  final String? iconName;

  Feature({
    required this.title,
    required this.description,
    this.iconName,
  });

  factory Feature.fromMap(Map<String, dynamic> map) {
    return Feature(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      iconName: map['iconName'],
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

class Testimonial {
  final String quote;
  final String author;
  final String? role;
  final String? avatarPath;

  Testimonial({
    required this.quote,
    required this.author,
    this.role,
    this.avatarPath,
  });

  factory Testimonial.fromMap(Map<String, dynamic> map) {
    return Testimonial(
      quote: map['quote'] ?? '',
      author: map['author'] ?? '',
      role: map['role'],
      avatarPath: map['avatarPath'],
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

class ProjectStats {
  final int? users;
  final int? stars;
  final int? forks;
  final int? downloads;
  final int? contributions;

  ProjectStats({
    this.users,
    this.stars,
    this.forks,
    this.downloads,
    this.contributions,
  });

  factory ProjectStats.fromMap(Map<String, dynamic> map) {
    return ProjectStats(
      users: map['users'],
      stars: map['stars'],
      forks: map['forks'],
      downloads: map['downloads'],
      contributions: map['contributions'],
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

class Future {
  final String title;
  final String description;
  final String? status;

  Future({
    required this.title,
    required this.description,
    this.status,
  });

  factory Future.fromMap(Map<String, dynamic> map) {
    return Future(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'],
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
