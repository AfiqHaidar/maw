// lib/services/cache/cache_initializer.dart
import 'package:mb/data/service/cache/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheInitializer {
  static final CacheInitializer _instance = CacheInitializer._internal();
  final CacheManager _cacheManager = CacheManager();

  // Preference keys
  static const String _lastCacheCleanupKey = 'last_cache_cleanup';

  // Cleanup interval (default: 3 days)
  static const int _cleanupIntervalDays = 3;

  factory CacheInitializer() {
    return _instance;
  }

  CacheInitializer._internal();

  // Initialize cache when app starts
  Future<void> initialize() async {
    // Check if it's time to clean up the cache
    await _checkAndPerformCleanup();

    // Log cache statistics
    try {
      final stats = await _cacheManager.getCacheStats();
      print('Cache statistics on startup:');
      print('- Cached images: ${stats['imageCount']}');
      print('- Total size: ${stats['totalSizeMB']} MB');
    } catch (e) {
      print('Error getting cache statistics: $e');
    }
  }

  // Check if we need to perform cache cleanup
  Future<void> _checkAndPerformCleanup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int lastCleanup = prefs.getInt(_lastCacheCleanupKey) ?? 0;
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int intervalMs =
          _cleanupIntervalDays * 24 * 60 * 60 * 1000; // days to ms

      if (now - lastCleanup > intervalMs) {
        print('Performing automatic cache cleanup...');
        await _cacheManager.cleanExpiredCache();
        await prefs.setInt(_lastCacheCleanupKey, now);
        print('Automatic cache cleanup completed');
      }
    } catch (e) {
      print('Error during cache cleanup check: $e');
    }
  }
}
