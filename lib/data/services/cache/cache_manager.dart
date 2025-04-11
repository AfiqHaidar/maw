// lib/data/services/cache/cache_manager.dart
import 'dart:io';
import 'package:mb/data/services/cache/image_cache_Service.dart';
import 'package:mb/data/entities/project_entity.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  final ImageCacheService _imageCacheService = ImageCacheService();

  factory CacheManager() {
    return _instance;
  }

  CacheManager._internal();

  // Gets a cached image or returns the original URL if not cached
  Future<String> getImage(
      String url, String projectId, String imageType) async {
    if (url.isEmpty || !url.startsWith('http')) {
      return url; // Return original path for non-HTTP URLs or empty paths
    }

    final String? cachedPath = await _imageCacheService.getCachedImage(url);
    if (cachedPath != null) {
      return cachedPath;
    }

    // Cache the image
    return await _imageCacheService.cacheImage(url, projectId, imageType);
  }

  // Processes a project entity to use cached images
  Future<ProjectEntity> processProjectImages(ProjectEntity project) async {
    // Process banner image
    String bannerImagePath = project.bannerImagePath;
    if (bannerImagePath.isNotEmpty && bannerImagePath.startsWith('http')) {
      final cachedPath = await getImage(bannerImagePath, project.id, 'banner');
      bannerImagePath = cachedPath;
    }

    // Process carousel images
    List<String> cachedCarouselPaths = [];
    for (int i = 0; i < project.carouselImagePaths.length; i++) {
      final String imagePath = project.carouselImagePaths[i];
      if (imagePath.isNotEmpty && imagePath.startsWith('http')) {
        final cachedPath = await getImage(imagePath, project.id, 'carousel_$i');
        cachedCarouselPaths.add(cachedPath);
      } else {
        cachedCarouselPaths
            .add(imagePath); // Keep original path for non-HTTP URLs
      }
    }

    // Return a new project entity with cached image paths
    return project.copyWith(
      bannerImagePath: bannerImagePath,
      carouselImagePaths: cachedCarouselPaths,
    );
  }

  // Preload all project images to cache
  Future<void> preloadProjectImages(ProjectEntity project) async {
    if (project.bannerImagePath.isNotEmpty &&
        project.bannerImagePath.startsWith('http')) {
      await _imageCacheService.cacheImage(
          project.bannerImagePath, project.id, 'banner');
    }

    for (int i = 0; i < project.carouselImagePaths.length; i++) {
      final String imagePath = project.carouselImagePaths[i];
      if (imagePath.isNotEmpty && imagePath.startsWith('http')) {
        await _imageCacheService.cacheImage(
            imagePath, project.id, 'carousel_$i');
      }
    }
  }

  // Preload all images for a list of projects
  Future<void> preloadMultipleProjects(List<ProjectEntity> projects) async {
    for (final project in projects) {
      await preloadProjectImages(project);
    }
  }

  // Clear all cached images for a specific project
  Future<void> clearProjectCache(String projectId) async {
    await _imageCacheService.clearProjectCache(projectId);
  }

  // Clear all cached images
  Future<void> clearAllCache() async {
    await _imageCacheService.clearAllCache();
  }

  // Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    return await _imageCacheService.getCacheStats();
  }

  // Clean expired cache
  Future<void> cleanExpiredCache() async {
    await _imageCacheService.cleanExpiredCache();
  }

  // Check if a file is cached
  Future<bool> isImageCached(String url) async {
    final cachedPath = await _imageCacheService.getCachedImage(url);
    return cachedPath != null;
  }

  // Get a cached file path if it exists, or null
  Future<File?> getCachedFile(String url) async {
    final cachedPath = await _imageCacheService.getCachedImage(url);
    if (cachedPath != null) {
      final file = File(cachedPath);
      if (await file.exists()) {
        return file;
      }
    }
    return null;
  }
}
