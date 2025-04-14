# 📱 Maw

**Maw** is a Flutter-based mobile application designed to showcase your software projects — a portfolio app for developers.

---

## 📌 Short Description

Maw helps developers display their projects in a beautiful and structured format — including details like technologies used, team members, features, and challenges. It serves as a hub where users can share, review, and engage with others' projects.

---

## 🎥 Demo

https://youtube.com/shorts/HalqDkYXgLQ?feature=share

---

## 🏗️ Project Creation & Architecture

This section outlines how the project was created and structured, providing insight into the architectural decisions and implementation approach.

### Project Setup

1. **Initial Setup**
   - Created a new Flutter project with `flutter create mb`
   - Set up Firebase integration using FlutterFire CLI
   - Configured project dependencies in `pubspec.yaml`

2. **Repository Creation**
   - Initialized Git repository
   - Set up project structure with feature-based organization
   - Created documentation and README files

### Codebase Structure

The codebase follows a feature-first architectural approach with clean separation of concerns:

```
lib/
├── core/             # Core functionality across features
│   ├── debuggers/    # Debugging tools (seeder, cache management)
│   ├── handlers/     # Global handlers (error, exit)
│   ├── mappers/      # Data mappers (error mapping)
│   └── theme/        # App theming and styles
├── data/             # Data layer
│   ├── controllers/  # State controllers
│   ├── entities/     # Domain entities
│   ├── enums/        # Enumerations
│   ├── models/       # Data models
│   ├── providers/    # Riverpod providers
│   ├── repositories/ # Data repositories
│   └── services/     # Services (cache, sound)
├── features/         # Feature modules
│   ├── auth/         # Authentication features
│   ├── home/         # Home screen
│   ├── portofolio/   # Portfolio features
│   ├── profile/      # User profile features
│   ├── project/      # Project display
│   └── upsert_project/ # Project creation/editing
└── widgets/          # Shared widgets
```

### Implementation Flow

1. **Data Layer Setup**
   - Created Firebase repository classes to handle CRUD operations
   - Defined entity models for Projects, Users, and related objects
   - Implemented Riverpod providers for state management

2. **Authentication Implementation**
   - Built Firebase Auth integration with custom UI
   - Created user registration and login flows
   - Implemented profile creation and management

3. **Project Management**
   - Designed comprehensive project entity with multiple sub-models
   - Implemented CRUD operations for projects in Firestore
   - Added media upload capabilities to Firebase Storage

4. **UI Components**
   - Created reusable UI components for consistent design
   - Implemented forms with validation for project creation/editing
   - Built navigation system with bottom tabs and drawer

5. **Feature Development**
   - Implemented portfolio view with interactive elements
   - Created project detail screens with expandable sections
   - Added profile management features

6. **Cache Integration**

The caching system was meticulously implemented to optimize performance, reduce network usage, and provide offline capabilities:

   - **Cache Architecture**
     - Multi-layered approach with three main components:
       1. **CacheManager**: High-level facade providing simple API for the app
       2. **ImageCacheService**: Core service managing image caching operations
       3. **SQFLite Database**: Persistent storage for cache metadata

   - **Database Schema**
     The cache uses a dedicated SQLite table to track cached assets:
     ```sql
     CREATE TABLE cached_images (
       id TEXT PRIMARY KEY,
       url TEXT NOT NULL,
       local_path TEXT NOT NULL,
       timestamp INTEGER NOT NULL,
       file_size INTEGER NOT NULL,
       project_id TEXT NOT NULL,
       image_type TEXT NOT NULL
     )
     ```

   - **Cache Flow**
     1. **Cache Initialization**:
        ```dart
        // lib/data/services/cache/cache_initializer.dart
        class CacheInitializer {
          static final CacheInitializer _instance = CacheInitializer._internal();
          final CacheManager _cacheManager = CacheManager();
          
          // Preference keys for tracking last cleanup
          static const String _lastCacheCleanupKey = 'last_cache_cleanup';
          static const int _cleanupIntervalDays = 3;
          
          // Singleton pattern implementation
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
              final int intervalMs = _cleanupIntervalDays * 24 * 60 * 60 * 1000;
              
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
        ```

     2. **Image Caching Process**:
        ```dart
        // lib/data/services/cache/image_cache_service.dart
        class ImageCacheService {
          // Cache an image and record its metadata
          Future<String> cacheImage(String url, String projectId, String imageType) async {
            try {
              // Check if already cached
              final cachedImage = await getCachedImage(url);
              if (cachedImage != null) {
                return cachedImage;
              }
              
              // Download the image
              final http.Response response = await http.get(Uri.parse(url));
              if (response.statusCode != 200) {
                throw Exception('Failed to download image: ${response.statusCode}');
              }
              
              // Create a unique filename
              final Uint8List imageData = response.bodyBytes;
              final Directory cacheDir = await _cacheDirectory;
              final String fileName = _generateFileName(url, projectId, imageType);
              final String localPath = '${cacheDir.path}/$fileName';
              
              // Save to filesystem
              final File imageFile = File(localPath);
              await imageFile.writeAsBytes(imageData);
              
              // Record in database
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
              return url; // Return original URL if caching fails
            }
          }
          
          // Get a cached image path if it exists and is valid
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
              
              // Check if file exists
              if (!await imageFile.exists()) {
                // Remove the entry if file doesn't exist
                await db.delete(
                  _tableCachedImages,
                  where: '$columnUrl = ?',
                  whereArgs: [url],
                );
                return null;
              }
              
              // Check if cache is expired
              final int now = DateTime.now().millisecondsSinceEpoch;
              final int expirationTime = _cacheExpirationDays * 24 * 60 * 60 * 1000;
              
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
        }
        ```

     3. **Cache Manager Interface**:
        ```dart
        // lib/data/services/cache/cache_manager.dart
        class CacheManager {
          static final CacheManager _instance = CacheManager._internal();
          final ImageCacheService _imageCacheService = ImageCacheService();
          
          factory CacheManager() {
            return _instance;
          }
          
          CacheManager._internal();
          
          // Gets a cached image or downloads and caches it
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
                cachedCarouselPaths.add(imagePath);
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
          
          // Cache maintenance methods
          Future<void> clearProjectCache(String projectId) async {
            await _imageCacheService.clearProjectCache(projectId);
          }
          
          Future<void> clearAllCache() async {
            await _imageCacheService.clearAllCache();
          }
          
          Future<Map<String, dynamic>> getCacheStats() async {
            return await _imageCacheService.getCacheStats();
          }
          
          Future<void> cleanExpiredCache() async {
            await _imageCacheService.cleanExpiredCache();
          }
        }
        ```

   - **UI Integration with CachedImageWidget**
     ```dart
     // lib/widgets/cached_image_widget.dart
     class CachedImageWidget extends StatefulWidget {
       final String imageUrl;
       final String projectId;
       final String imageType;
       final double? width;
       final double? height;
       final BoxFit? fit;
       final Widget? placeholder;
       final Widget? errorWidget;
       final BorderRadius? borderRadius;
       
       const CachedImageWidget({
         Key? key,
         required this.imageUrl,
         required this.projectId,
         required this.imageType,
         this.width,
         this.height,
         this.fit = BoxFit.cover,
         this.placeholder,
         this.errorWidget,
         this.borderRadius,
       }) : super(key: key);
       
       @override
       State<CachedImageWidget> createState() => _CachedImageWidgetState();
     }
     
     class _CachedImageWidgetState extends State<CachedImageWidget> {
       final CacheManager _cacheManager = CacheManager();
       late Future<String> _imageFuture;
       
       @override
       void initState() {
         super.initState();
         _loadImage();
       }
       
       void _loadImage() {
         _imageFuture = _cacheManager.getImage(
           widget.imageUrl,
           widget.projectId,
           widget.imageType,
         );
       }
       
       @override
       Widget build(BuildContext context) {
         // For asset images or empty URLs, return a direct image
         if (widget.imageUrl.isEmpty || widget.imageUrl.startsWith('assets/')) {
           return _buildImageWidget(widget.imageUrl, isAsset: true);
         }
         
         // For HTTP URLs, use the cache
         return FutureBuilder<String>(
           future: _imageFuture,
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return _buildPlaceholder();
             } else if (snapshot.hasError || !snapshot.hasData) {
               return _buildErrorWidget();
             } else {
               final String imagePath = snapshot.data!;
               return _buildImageWidget(imagePath);
             }
           },
         );
       }
       
       // Build methods for different states...
     }
     ```

   - **Cache Management Screen**
     ```dart
     // lib/core/debuggers/cache/cache.dart
     class CacheManagementScreen extends StatefulWidget {
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
       
       // Load cache statistics
       Future<void> _loadCacheStats() async {
         setState(() { _isLoading = true; });
         
         try {
           final stats = await _cacheManager.getCacheStats();
           setState(() {
             _cacheStats = stats;
             _isLoading = false;
           });
         } catch (e) {
           setState(() { _isLoading = false; });
           _showErrorSnackbar('Failed to load cache statistics: $e');
         }
       }
       
       // Clear all cache
       Future<void> _clearAllCache() async {
         setState(() { _isClearing = true; });
         
         try {
           await _cacheManager.clearAllCache();
           await _loadCacheStats();
           _showSuccessSnackbar('All cache cleared successfully');
         } catch (e) {
           _showErrorSnackbar('Failed to clear cache: $e');
         } finally {
           setState(() { _isClearing = false; });
         }
       }
       
       // Clean expired cache
       Future<void> _cleanExpiredCache() async {
         setState(() { _isCleaning = true; });
         
         try {
           await _cacheManager.cleanExpiredCache();
           await _loadCacheStats();
           _showSuccessSnackbar('Expired cache cleaned successfully');
         } catch (e) {
           _showErrorSnackbar('Failed to clean expired cache: $e');
         } finally {
           setState(() { _isCleaning = false; });
         }
       }
       
       // UI implementation...
     }
     ```

   - **Repository Integration**
     ```dart
     // lib/data/repository/project_repository.dart
     class ProjectRepository {
       final FirebaseFirestore _firestore = FirebaseFirestore.instance;
       final FirebaseStorage _storage = FirebaseStorage.instance;
       final CacheManager _cacheManager = CacheManager();
       
       Future<ProjectEntity?> getProject(String projectId) async {
         try {
           DocumentSnapshot doc = 
               await _firestore.collection('projects').doc(projectId).get();
           
           if (doc.exists) {
             ProjectEntity project = 
                 ProjectEntity.fromMap(doc.id, doc.data() as Map<String, dynamic>);
             
             // Process project images through cache before returning
             return await _cacheManager.processProjectImages(project);
           }
           return null;
         } catch (e) {
           throw Exception("Failed to fetch project: $e");
         }
       }
       
       Future<List<ProjectEntity>> getProjectsByUser(String userId) async {
         try {
           QuerySnapshot query = await _firestore
               .collection('projects')
               .where('userId', isEqualTo: userId)
               .get();
           
           List<ProjectEntity> projects = query.docs
               .map((doc) => 
                   ProjectEntity.fromMap(doc.id, doc.data() as Map<String, dynamic>))
               .toList();
           
           // Process all projects through cache
           List<ProjectEntity> cachedProjects = [];
           for (var project in projects) {
             cachedProjects.add(await _cacheManager.processProjectImages(project));
           }
           
           // Preload all project images in the background
           _cacheManager.preloadMultipleProjects(projects);
           
           return cachedProjects;
         } catch (e) {
           throw Exception("Failed to fetch user projects: $e");
         }
       }
     }
     ```

The caching system follows a complete lifecycle:

1. **Initialization**: On app startup, cache is initialized and expired items are automatically cleaned
2. **Image Request Flow**: 
   - App requests image via CacheManager
   - System checks if image exists in cache
   - If found and valid, returns cached path
   - If not found or expired, downloads, stores in filesystem, records in database
3. **Project Loading**: 
   - When projects are fetched, all images are processed through cache
   - Remote URLs are replaced with local filesystem paths when available
4. **Preloading**: Background preloading of all project images for smoother user experience
5. **Maintenance**:
   - Automatic expiration of cached items based on configured timeframe
   - Database tracking with SQFLite for efficient querying and cleanup
   - Manual and automatic cache cleanup mechanisms
   - UI for cache management and statistics

This implementation significantly improves app performance by:
- Reducing network requests for already cached images
- Providing offline access to previously viewed content
- Managing cache size to prevent excessive storage usage
- Offering transparent handling through custom widgets

This architecture ensures the app remains responsive and efficient, even with limited connectivity, while providing a seamless user experience with optimized image loading.

---

## 📖 Current Features

- **Authentication Flow**  
  Secure login and registration system with profile management.

- **CRUD for Projects**  
  Full project management capabilities, including:
  - Banner customization (image or Lottie)
  - Tech stack list
  - Team member management
  - Features and challenges documentation
  - Testimonials
  - Project statistics & future plans
  
- **Project Showcase**
  - Beautiful, animated UI for project visualization
  - Carousel image display
  - Expandable sections for detailed information
  
- **Cache Management**
  - Efficient caching of project images
  - Automatic cache cleanup
  - Manual cache management options

- **Seeding Functionality**
  - Database seeding for demonstration and testing
  - Sample project templates

---

## 🧱 Tech Stack

- **Flutter** – Cross-platform UI framework
- **Riverpod** – State management
- **Firebase Auth** – Authentication
- **Cloud Firestore** – NoSQL database
- **Firebase Storage** – Media storage
- **Lottie** – Animation integration
- **SQFLite** – Local cache database

---

## 🚀 Getting Started

Follow these steps to set up **Maw** on your local machine:

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/maw.git
```

### 2. Navigate into the Project Directory

```bash
cd maw
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Firebase for Android

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Add an Android app with your app's package name
4. Download the `google-services.json` file
5. Place it inside the `android/app/` directory
6. If using `flutterfire_cli`, also run:

```bash
flutterfire configure
```

> This will generate the `firebase_options.dart` file used for initialization.

### 5. Run the App

```bash
flutter run
```

---

## 🌱 Future Enhancements

Here's what's coming to Maw in the future:

- 🔍 **Search Functionality**
  - Search for projects by name, technology, or category
  - Advanced filtering options for precise results
  - Discover trending projects and developers

- 👥 **Social Features**
  - Connect with other developers
  - Follow your favorite creators
  - Build a network of professionals
  - View other users' portfolios

- ⭐ **Engagement System**
  - Star projects you like
  - Leave meaningful reviews and feedback
  - Rate projects based on multiple criteria
  - Showcase project popularity metrics

- 🔔 **Notifications**
  - Get notified about interactions with your projects
  - Receive feedback alerts

---

## 🐈‍⬛ Cat

Meow maw.

---

Let's build the ultimate social platform for showcasing software projects!
