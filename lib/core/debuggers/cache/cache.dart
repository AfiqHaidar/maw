// lib/core/debuggers/cache/cache.dart
import 'package:flutter/material.dart';
import 'package:mb/data/services/cache/cache_manager.dart';
import 'package:mb/widgets/drawer/main_drawer.dart';

class CacheManagementScreen extends StatefulWidget {
  const CacheManagementScreen({Key? key}) : super(key: key);

  @override
  State<CacheManagementScreen> createState() => _CacheManagementScreenState();
}

class _CacheManagementScreenState extends State<CacheManagementScreen> {
  final CacheManager _cacheManager = CacheManager();
  Map<String, dynamic> _cacheStats = {
    'imageCount': 0,
    'totalSizeBytes': 0,
    'totalSizeMB': '0.00',
  };
  bool _isLoading = true;
  bool _isClearing = false;
  bool _isCleaning = false;

  @override
  void initState() {
    super.initState();
    _loadCacheStats();
  }

  Future<void> _loadCacheStats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _cacheManager.getCacheStats();
      setState(() {
        _cacheStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar('Failed to load cache statistics: $e');
    }
  }

  Future<void> _clearAllCache() async {
    setState(() {
      _isClearing = true;
    });

    try {
      await _cacheManager.clearAllCache();
      await _loadCacheStats();
      _showSuccessSnackbar('All cache cleared successfully');
    } catch (e) {
      _showErrorSnackbar('Failed to clear cache: $e');
    } finally {
      setState(() {
        _isClearing = false;
      });
    }
  }

  Future<void> _cleanExpiredCache() async {
    setState(() {
      _isCleaning = true;
    });

    try {
      await _cacheManager.cleanExpiredCache();
      await _loadCacheStats();
      _showSuccessSnackbar('Expired cache cleaned successfully');
    } catch (e) {
      _showErrorSnackbar('Failed to clean expired cache: $e');
    } finally {
      setState(() {
        _isCleaning = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadCacheStats,
            tooltip: 'Refresh Statistics',
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCard(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                  _buildCacheInfoSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cache Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatItem(
              icon: Icons.image,
              title: 'Cached Images',
              value: _cacheStats['imageCount'].toString(),
            ),
            const Divider(),
            _buildStatItem(
              icon: Icons.storage,
              title: 'Total Cache Size',
              value: '${_cacheStats['totalSizeMB']} MB',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cache Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isCleaning ? null : _cleanExpiredCache,
                icon: _isCleaning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.cleaning_services),
                label:
                    Text(_isCleaning ? 'Cleaning...' : 'Clean Expired Cache'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isClearing ? null : _clearAllCache,
                icon: _isClearing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.delete_forever),
                label: Text(_isClearing ? 'Clearing...' : 'Clear All Cache'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCacheInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'About Caching',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Images are cached for 7 days to improve app performance and reduce data usage. '
              'You can manually clean expired cache or clear all cached data if needed.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Note: Clearing the cache may result in slower image loading times initially as images '
              'will need to be downloaded again.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
