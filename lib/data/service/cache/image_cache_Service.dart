// lib/services/cache/image_cache_service.dart
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  static Database? _database;

  // Database name and version
  static const String _databaseName = "image_cache.db";
  static const int _databaseVersion = 1;

  // Table name
  static const String _tableCachedImages = "cached_images";

  // Column names
  static const String columnId = "id";
  static const String columnUrl = "url";
  static const String columnLocalPath = "local_path";
  static const String columnTimestamp = "timestamp";
  static const String columnFileSize = "file_size";
  static const String columnProjectId = "project_id";
  static const String columnImageType = "image_type"; // banner, carousel, etc.

  // Cache expiration time (default: 7 days)
  static const int _cacheExpirationDays = 7;

  // Factory constructor
  factory ImageCacheService() {
    return _instance;
  }

  // Private constructor
  ImageCacheService._internal();

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create the database table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableCachedImages (
        $columnId TEXT PRIMARY KEY,
        $columnUrl TEXT NOT NULL,
        $columnLocalPath TEXT NOT NULL,
        $columnTimestamp INTEGER NOT NULL,
        $columnFileSize INTEGER NOT NULL,
        $columnProjectId TEXT NOT NULL,
        $columnImageType TEXT NOT NULL
      )
    ''');
  }

  // Get the cache directory
  Future<Directory> get _cacheDirectory async {
    final Directory cacheDir = await getTemporaryDirectory();
    final Directory imageCache = Directory('${cacheDir.path}/image_cache');

    if (!await imageCache.exists()) {
      await imageCache.create(recursive: true);
    }

    return imageCache;
  }

  // Generate a unique file name from the URL
  String _generateFileName(String url, String projectId, String imageType) {
    // Create a unique name based on URL and other parameters
    final String fileExtension = url.contains('.')
        ? url.split('.').last.split('?').first // Remove query parameters
        : 'jpg'; // Default extension

    return '$projectId-$imageType-${url.hashCode.abs()}.$fileExtension';
  }

  // Download and save an image to the cache
  Future<String> cacheImage(
      String url, String projectId, String imageType) async {
    try {
      // Check if the image is already cached
      final cachedImage = await getCachedImage(url);
      if (cachedImage != null) {
        return cachedImage;
      }

      // Download the image
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to download image: ${response.statusCode}');
      }

      final Uint8List imageData = response.bodyBytes;

      // Save the image to the file system
      final Directory cacheDir = await _cacheDirectory;
      final String fileName = _generateFileName(url, projectId, imageType);
      final String localPath = '${cacheDir.path}/$fileName';

      final File imageFile = File(localPath);
      await imageFile.writeAsBytes(imageData);

      // Save the cache info to the database
      final Map<String, dynamic> row = {
        columnId: '$projectId-$imageType-${url.hashCode}',
        columnUrl: url,
        columnLocalPath: localPath,
        columnTimestamp: DateTime.now().millisecondsSinceEpoch,
        columnFileSize: imageData.length,
        columnProjectId: projectId,
        columnImageType: imageType,
      };

      final Database db = await database;
      await db.insert(_tableCachedImages, row,
          conflictAlgorithm: ConflictAlgorithm.replace);

      return localPath;
    } catch (e) {
      print('Error caching image: $e');
      return url; // Return the original URL if caching fails
    }
  }

  // Get a cached image path
  Future<String?> getCachedImage(String url) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableCachedImages,
        columns: [columnLocalPath, columnTimestamp],
        where: '$columnUrl = ?',
        whereArgs: [url],
      );

      if (maps.isEmpty) {
        return null; // Image not cached
      }

      final String localPath = maps.first[columnLocalPath];
      final int timestamp = maps.first[columnTimestamp];
      final File imageFile = File(localPath);

      // Check if the file exists
      if (!await imageFile.exists()) {
        // Remove the entry from the database if the file doesn't exist
        await db.delete(
          _tableCachedImages,
          where: '$columnUrl = ?',
          whereArgs: [url],
        );
        return null;
      }

      // Check if the cache is expired
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int expirationTime =
          _cacheExpirationDays * 24 * 60 * 60 * 1000; // days to milliseconds

      if (now - timestamp > expirationTime) {
        // Remove expired cache
        await imageFile.delete();
        await db.delete(
          _tableCachedImages,
          where: '$columnUrl = ?',
          whereArgs: [url],
        );
        return null;
      }

      return localPath;
    } catch (e) {
      print('Error getting cached image: $e');
      return null;
    }
  }

  // Cache all project images (banner and carousel)
  Future<Map<String, String>> cacheProjectImages(String projectId,
      String bannerImageUrl, List<String> carouselImageUrls) async {
    final Map<String, String> cachedPaths = {};

    // Cache banner image
    if (bannerImageUrl.isNotEmpty && bannerImageUrl.startsWith('http')) {
      final String cachedBannerPath =
          await cacheImage(bannerImageUrl, projectId, 'banner');
      cachedPaths['bannerImagePath'] = cachedBannerPath;
    }

    // Cache carousel images
    final List<String> cachedCarouselPaths = [];
    for (final String imageUrl in carouselImageUrls) {
      if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
        final String cachedPath =
            await cacheImage(imageUrl, projectId, 'carousel');
        cachedCarouselPaths.add(cachedPath);
      } else {
        cachedCarouselPaths
            .add(imageUrl); // Keep original path for non-HTTP URLs
      }
    }
    cachedPaths['carouselImagePaths'] = cachedCarouselPaths.join(',');

    return cachedPaths;
  }

  // Clear cache for a specific project
  Future<void> clearProjectCache(String projectId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableCachedImages,
        columns: [columnLocalPath],
        where: '$columnProjectId = ?',
        whereArgs: [projectId],
      );

      // Delete cache files
      for (final map in maps) {
        final String localPath = map[columnLocalPath];
        final File imageFile = File(localPath);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }

      // Delete database entries
      await db.delete(
        _tableCachedImages,
        where: '$columnProjectId = ?',
        whereArgs: [projectId],
      );
    } catch (e) {
      print('Error clearing project cache: $e');
    }
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableCachedImages,
        columns: [columnLocalPath],
      );

      // Delete all cache files
      for (final map in maps) {
        final String localPath = map[columnLocalPath];
        final File imageFile = File(localPath);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }

      // Clear the database table
      await db.delete(_tableCachedImages);
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }

  // Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query(_tableCachedImages);

      int totalSize = 0;
      for (final map in maps) {
        totalSize += map[columnFileSize] as int;
      }

      return {
        'imageCount': maps.length,
        'totalSizeBytes': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      print('Error getting cache stats: $e');
      return {
        'imageCount': 0,
        'totalSizeBytes': 0,
        'totalSizeMB': '0.00',
      };
    }
  }

  // Clean expired cache
  Future<void> cleanExpiredCache() async {
    try {
      final Database db = await database;
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int expirationTime =
          _cacheExpirationDays * 24 * 60 * 60 * 1000; // days to milliseconds

      final List<Map<String, dynamic>> maps = await db.query(
        _tableCachedImages,
        columns: [columnId, columnLocalPath, columnTimestamp],
        where: '$columnTimestamp < ?',
        whereArgs: [now - expirationTime],
      );

      // Delete expired files
      for (final map in maps) {
        final String localPath = map[columnLocalPath];
        final File imageFile = File(localPath);
        if (await imageFile.exists()) {
          await imageFile.delete();
        }

        // Delete database entry
        await db.delete(
          _tableCachedImages,
          where: '$columnId = ?',
          whereArgs: [map[columnId]],
        );
      }
    } catch (e) {
      print('Error cleaning expired cache: $e');
    }
  }
}
