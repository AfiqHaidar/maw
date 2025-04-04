import 'package:flutter/material.dart';
import 'package:mb/data/enums/banner_identifier.dart';
import 'package:mb/data/models/challenge_model.dart';
import 'package:mb/data/models/feature_model.dart';
import 'package:mb/data/models/future_enhancement_model.dart';
import 'package:mb/data/models/project_stats_model.dart';
import 'package:mb/data/models/team_member_model.dart';
import 'package:mb/data/models/testimonial_model.dart';

class ProjectEntity {
  final String id;
  final String userId;
  final String name;
  final Color bannerBgColor;
  final BannerIdentifier bannerType;
  final String bannerImagePath;
  final String bannerLottiePath;
  final List<String> carouselImagePaths;
  final String details;
  final String? shortDescription;
  final String? role;
  final List<String>? techStack;
  final List<String>? tags;
  final String link;
  final String? githubLink;
  final List<String>? additionalLinks;
  final DateTime? releaseDate;
  final String category;
  final Duration? developmentTime;
  final ProjectStats? stats;
  final List<TeamMember>? teamMembers;
  final List<Feature>? keyFeatures;
  final List<Challenge>? challenges;
  final List<FutureEnhancement>? futureEnhancements;
  final List<Testimonial>? testimonials;

  ProjectEntity({
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
    required this.category,
  });

  factory ProjectEntity.fromMap(String id, Map<String, dynamic> map) {
    return ProjectEntity(
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
              .map((f) => FutureEnhancement.fromMap(f))
              .toList()
          : null,
      category: map['category'] ?? '',
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
      'category': category,
    };
  }
}
