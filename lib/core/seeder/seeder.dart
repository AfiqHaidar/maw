import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class AdminSeederScreen extends StatefulWidget {
  const AdminSeederScreen({Key? key}) : super(key: key);

  @override
  _AdminSeederScreenState createState() => _AdminSeederScreenState();
}

class _AdminSeederScreenState extends State<AdminSeederScreen> {
  final FirestoreSeeder _seeder = FirestoreSeeder();
  bool _isLoading = false;
  String _statusMessage = '';

  // This would be your JSON data from paste.txt
  final String _jsonData = '''
{
  "projects": {
    "project1": {
      "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
      "name": "Tetris Game",
      "bannerBgColor": "#FF0000",
      "bannerType": "lottie",
      "bannerImagePath": "seeder/logo.png",
      "bannerLottiePath": "assets/animations/stare_cat.json",
      "carouselImagePaths": [
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png"
      ],
      "details": "A block-stacking puzzle game built with Flutter. Features classic mechanics and responsive design.",
      "shortDescription": "Modern implementation of the classic Tetris puzzle game for mobile devices",
      "role": "Lead Developer",
      "techStack": ["Flutter", "Dart"],
      "tags": ["Game", "Puzzle", "Classic"],
      "link": "https://github.com/AfiqHaidar/mobile-programming-course",
      "githubLink": "https://github.com/AfiqHaidar/tetris-flutter",
      "additionalLinks": [
        "https://play.google.com/store/apps/tetris",
        "https://afiqhaidar.dev/projects/tetris"
      ],
      "releaseDate": "2024-06-01T00:00:00.000Z",
      "category": "Arcade Games",
      "duration": 45,
      "stats": {
        "users": 15000,
        "stars": 124,
        "forks": 45,
        "downloads": 25000,
        "contributions": 8
      },
      "teamMembers": [
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "Jane Doe",
          "role": "UI/UX Designer",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/janedoe"
        },
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "John Smith",
          "role": "Backend Developer",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/johnsmith"
        }
      ],
      "features": [
        {
          "title": "Classic Controls",
          "description": "Intuitive swipe and tap controls optimized for mobile",
          "iconName": "gamepad"
        },
        {
          "title": "Score System",
          "description": "Tracks high scores and gameplay statistics",
          "iconName": "leaderboard"
        },
        {
          "title": "Difficulty Levels",
          "description": "Multiple speed settings for players of all skill levels",
          "iconName": "speed"
        }
      ],
      "challenges": [
        {
          "title": "Touch Controls",
          "description": "Adapting traditional keyboard controls to touch interfaces",
          "solution": "Implemented a custom gesture detector with haptic feedback"
        },
        {
          "title": "Performance Optimization",
          "description": "Ensuring smooth gameplay on lower-end devices",
          "solution": "Used a custom rendering engine and efficient collision detection"
        }
      ],
      "futureEnhancements": [
        {
          "title": "Multiplayer Mode",
          "description": "Real-time competition with other players",
          "status": "Planned"
        },
        {
          "title": "Custom Themes",
          "description": "Personalized block and background designs",
          "status": "In Development"
        }
      ],
      "testimonials": [
        {
          "quote": "The best Tetris implementation I've seen on mobile!",
          "author": "Mobile Gaming Weekly",
          "role": "Publication",
          "avatarPath": "seeder/logo.png"
        }
      ]
    },
    "project2": {
      "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
      "name": "Dino Runner",
      "bannerBgColor": "#0000FF",
      "bannerType": "picture",
      "bannerImagePath": "seeder/logo.png",
      "bannerLottiePath": "assets/animations/stare_cat.json",
      "carouselImagePaths": [
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png"
      ],
      "details": "An offline-style endless runner game inspired by the Chrome Dino game. Built for mobile.",
      "shortDescription": "Endless runner inspired by the Chrome offline dinosaur game",
      "role": "Solo Developer",
      "techStack": ["Flutter", "Flame Engine"],
      "tags": ["Game", "Runner"],
      "link": "https://github.com/AfiqHaidar/mobile-programming-course",
      "githubLink": "https://github.com/AfiqHaidar/dino-runner",
      "additionalLinks": ["https://afiqhaidar.dev/projects/dino"],
      "releaseDate": "2024-07-10T00:00:00.000Z",
      "category": "Arcade Games",
      "duration": 30,
      "stats": {
        "users": 8000,
        "stars": 87,
        "forks": 23,
        "downloads": 12000,
        "contributions": 3
      },
      "teamMembers": [
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "Alex Chen",
          "role": "Art Designer",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/alexchen"
        }
      ],
      "features": [
        {
          "title": "Procedural Generation",
          "description": "Dynamically generated obstacles for endless gameplay",
          "iconName": "sync"
        },
        {
          "title": "Day/Night Cycle",
          "description": "Visual changes based on play duration",
          "iconName": "brightness_4"
        },
        {
          "title": "Power-ups",
          "description": "Collectible items that provide temporary abilities",
          "iconName": "flash_on"
        }
      ],
      "challenges": [
        {
          "title": "Game Physics",
          "description": "Creating realistic jumping mechanics with proper gravity",
          "solution": "Implemented custom physics engine with variable gravity"
        },
        {
          "title": "Difficulty Scaling",
          "description": "Gradually increasing difficulty without frustrating players",
          "solution": "Created an adaptive difficulty system based on player performance"
        }
      ],
      "futureEnhancements": [
        {
          "title": "Character Customization",
          "description": "Unlockable skins and characters",
          "status": "Planned"
        },
        {
          "title": "Global Leaderboard",
          "description": "Online score comparison with other players",
          "status": "In Development"
        }
      ],
      "testimonials": [
        {
          "quote": "Addictive gameplay with charming pixel art style!",
          "author": "Sarah Johnson",
          "role": "Game Reviewer",
          "avatarPath": "seeder/logo.png"
        }
      ]
    },
    "project3": {
      "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
      "name": "Minesweeper Clone",
      "bannerBgColor": "#008000",
      "bannerType": "picture",
      "bannerImagePath": "seeder/logo.png",
      "bannerLottiePath": "assets/animations/stare_cat.json",
      "carouselImagePaths": [
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png"
      ],
      "details": "A modern take on the classic minesweeper game, complete with animations and difficulty levels.",
      "shortDescription": "Modern redesign of the classic Minesweeper puzzle game",
      "role": "Lead Developer",
      "techStack": ["Flutter", "Dart"],
      "tags": ["Game", "Logic", "Classic"],
      "link": "https://github.com/AfiqHaidar/mobile-programming-course",
      "githubLink": "https://github.com/AfiqHaidar/minesweeper-flutter",
      "additionalLinks": ["https://afiqhaidar.dev/projects/minesweeper"],
      "releaseDate": "2024-08-05T00:00:00.000Z",
      "category": "Logic Puzzles",
      "duration": 21,
      "stats": {
        "users": 5500,
        "stars": 62,
        "forks": 18,
        "downloads": 9000,
        "contributions": 5
      },
      "teamMembers": [
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "Maria Rodriguez",
          "role": "UI Designer",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/mariarodriguez"
        }
      ],
      "features": [
        {
          "title": "Smart Flagging",
          "description": "Intelligent system to help players mark potential mines",
          "iconName": "flag"
        },
        {
          "title": "First-click Protection",
          "description": "Players never hit a mine on their first move",
          "iconName": "security"
        },
        {
          "title": "Custom Board Sizes",
          "description": "Adjustable grid dimensions for varied difficulty",
          "iconName": "grid_on"
        }
      ],
      "challenges": [
        {
          "title": "Random Board Generation",
          "description": "Creating balanced and solvable game boards",
          "solution": "Developed an algorithm to ensure logical solutions exist"
        },
        {
          "title": "Mobile Space Constraints",
          "description": "Adapting the game to smaller mobile screens",
          "solution": "Implemented pinch-to-zoom and smart UI scaling"
        }
      ],
      "futureEnhancements": [
        {
          "title": "Daily Challenges",
          "description": "New puzzles every day with variable difficulty",
          "status": "Planned"
        },
        {
          "title": "Hint System",
          "description": "Optional hints for players who get stuck",
          "status": "In Development"
        }
      ],
      "testimonials": [
        {
          "quote": "The interface is so clean, and the game runs perfectly!",
          "author": "Tech Games Today",
          "role": "Game Blog",
          "avatarPath": "seeder/logo.png"
        }
      ]
    },
    "project4": {
      "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
      "name": "Sudoku Solver App",
      "bannerBgColor": "#FFA500",
      "bannerType": "picture",
      "bannerImagePath": "seeder/logo.png",
      "bannerLottiePath": "assets/animations/stare_cat.json",
      "carouselImagePaths": [
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png"
      ],
      "details": "A clean Sudoku game with solving assistant and multiple difficulty levels. Built for learning algorithms.",
      "shortDescription": "Sudoku game and solver using backtracking algorithms",
      "role": "Algorithm Specialist",
      "techStack": ["Flutter", "Dart", "Algorithms"],
      "tags": ["Game", "Logic", "Solver"],
      "link": "https://github.com/AfiqHaidar/mobile-programming-course",
      "githubLink": "https://github.com/AfiqHaidar/sudoku-solver",
      "additionalLinks": [
        "https://sudoku.afiqhaidar.dev",
        "https://medium.com/@afiqhaidar/sudoku-algorithms"
      ],
      "releaseDate": "2024-09-15T00:00:00.000Z",
      "category": "Logic Puzzles",
      "duration": 60,
      "stats": {
        "users": 20000,
        "stars": 156,
        "forks": 67,
        "downloads": 35000,
        "contributions": 12
      },
      "teamMembers": [
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "David Park",
          "role": "Frontend Developer",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/davidpark"
        },
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "Lisa Wang",
          "role": "UX Researcher",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/lisawang"
        }
      ],
      "features": [
        {
          "title": "Automatic Solver",
          "description": "Solves any valid Sudoku puzzle using backtracking algorithms",
          "iconName": "auto_fix_high"
        },
        {
          "title": "Step-by-Step Solutions",
          "description": "Shows solving process one step at a time for learning",
          "iconName": "school"
        },
        {
          "title": "Puzzle Generator",
          "description": "Creates new puzzles with guaranteed single solutions",
          "iconName": "shuffle"
        }
      ],
      "challenges": [
        {
          "title": "Algorithm Efficiency",
          "description": "Making the solving algorithm fast enough for mobile devices",
          "solution": "Implemented constraint-based optimization to reduce backtracking steps"
        },
        {
          "title": "Puzzle Difficulty Rating",
          "description": "Creating an accurate system to rate puzzle difficulty",
          "solution": "Developed a machine learning model to classify puzzles based on solving techniques needed"
        }
      ],
      "futureEnhancements": [
        {
          "title": "Camera Input",
          "description": "Ability to scan physical Sudoku puzzles using the camera",
          "status": "In Development"
        },
        {
          "title": "Advanced Techniques Tutorial",
          "description": "Interactive lessons on Sudoku solving strategies",
          "status": "Planned"
        },
        {
          "title": "Variant Puzzles",
          "description": "Support for Sudoku variants like Killer Sudoku and Samurai Sudoku",
          "status": "Research"
        }
      ],
      "testimonials": [
        {
          "quote": "The step-by-step solution feature helped me understand Sudoku strategies I never knew about!",
          "author": "Miguel Torres",
          "role": "User",
          "avatarPath": "seeder/logo.png"
        },
        {
          "quote": "Best Sudoku app I've tried, with excellent puzzle generation",
          "author": "Puzzle Enthusiast Magazine",
          "role": "Publication",
          "avatarPath": "seeder/logo.png"
        }
      ]
    },
    "project5": {
      "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
      "name": "Flappy Clone",
      "bannerBgColor": "#800080",
      "bannerType": "lottie",
      "bannerImagePath": "seeder/logo.png",
      "bannerLottiePath": "assets/animations/hanging_cat.json",
      "carouselImagePaths": [
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png"
      ],
      "details": "A flappy bird style mobile game using Flutter and custom animations.",
      "shortDescription": "Fast-paced arcade game inspired by Flappy Bird",
      "role": "Game Developer",
      "techStack": ["Flutter", "Dart", "Game Physics"],
      "tags": ["Game", "Arcade"],
      "link": "https://github.com/AfiqHaidar/mobile-programming-course",
      "githubLink": "https://github.com/AfiqHaidar/flappy-clone",
      "additionalLinks": ["https://play.google.com/store/apps/flappyclone"],
      "releaseDate": "2024-10-03T00:00:00.000Z",
      "category": "Arcade Games",
      "duration": 15,
      "stats": {
        "users": 12000,
        "stars": 93,
        "forks": 34,
        "downloads": 18000,
        "contributions": 6
      },
      "teamMembers": [
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "Zoe Thompson",
          "role": "Artist",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/zoethompson"
        }
      ],
      "features": [
        {
          "title": "Simple Controls",
          "description": "One-touch gameplay accessible to all ages",
          "iconName": "touch_app"
        },
        {
          "title": "Custom Characters",
          "description": "Multiple playable characters with unique abilities",
          "iconName": "pets"
        },
        {
          "title": "Dynamic Obstacles",
          "description": "Randomly generated obstacles with increasing difficulty",
          "iconName": "block"
        }
      ],
      "challenges": [
        {
          "title": "Hit Detection",
          "description": "Creating precise collision detection without affecting performance",
          "solution": "Implemented simplified hitboxes with optimized collision algorithms"
        },
        {
          "title": "Game Balance",
          "description": "Making the game challenging but not frustrating",
          "solution": "Used playtest data to fine-tune difficulty progression"
        }
      ],
      "futureEnhancements": [
        {
          "title": "Seasonal Themes",
          "description": "Holiday-themed graphics and special events",
          "status": "Planned"
        },
        {
          "title": "Achievement System",
          "description": "Unlockable badges and rewards for skilled players",
          "status": "In Development"
        }
      ],
      "testimonials": [
        {
          "quote": "Just as addictive as the original, but with better graphics!",
          "author": "James Wilson",
          "role": "Mobile Gamer",
          "avatarPath": "seeder/logo.png"
        }
      ]
    },
    "project6": {
      "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
      "name": "Weather App",
      "bannerBgColor": "#87CEEB",
      "bannerType": "picture",
      "bannerImagePath": "seeder/logo.png",
      "bannerLottiePath": "assets/animations/stare_cat.json",
      "carouselImagePaths": [
        "seeder/logo.png",
        "seeder/logo.png",
        "seeder/logo.png"
      ],
      "details": "A sleek, minimalist weather application that provides accurate forecasts and beautiful visualizations.",
      "shortDescription": "Modern weather app with beautiful UI and accurate forecasts",
      "role": "Full-stack Developer",
      "techStack": ["Flutter", "Dart", "OpenWeather API", "Firebase"],
      "tags": ["Utility", "Weather", "Location"],
      "link": "https://github.com/AfiqHaidar/weather-app",
      "githubLink": "https://github.com/AfiqHaidar/weather-app",
      "additionalLinks": [
        "https://weather.afiqhaidar.dev",
        "https://play.google.com/store/apps/weather-app"
      ],
      "releaseDate": "2024-11-15T00:00:00.000Z",
      "category": "Utility",
      "duration": 25,
      "stats": {
        "users": 18000,
        "stars": 112,
        "forks": 42,
        "downloads": 30000,
        "contributions": 9
      },
      "teamMembers": [
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "Sam Johnson",
          "role": "UI/UX Designer",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/samjohnson"
        },
        {
          "userId": "Agq6REuMEBWae3BQcNOcdAJuOI32",
          "name": "Emily Liu",
          "role": "Backend Developer",
          "avatarPath": "assets/animations/stare_cat.json",
          "linkedinUrl": "https://linkedin.com/in/emilyliu"
        }
      ],
      "features": [
        {
          "title": "Location-based Forecasts",
          "description": "Automatically detects user location for accurate weather data",
          "iconName": "location_on"
        },
        {
          "title": "7-Day Forecast",
          "description": "Detailed weather predictions for the upcoming week",
          "iconName": "calendar_today"
        },
        {
          "title": "Weather Alerts",
          "description": "Notifications for severe weather conditions",
          "iconName": "warning"
        }
      ],
      "challenges": [
        {
          "title": "API Integration",
          "description": "Ensuring reliable data from multiple weather sources",
          "solution": "Implemented a fallback system that switches between providers"
        },
        {
          "title": "Battery Optimization",
          "description": "Reducing battery drain from location services",
          "solution": "Created an intelligent polling system that adjusts based on user movement"
        }
      ],
      "futureEnhancements": [
        {
          "title": "Weather Radar",
          "description": "Interactive map showing precipitation and storm movements",
          "status": "In Development"
        },
        {
          "title": "Historical Data",
          "description": "View and compare weather patterns from previous years",
          "status": "Planned"
        }
      ],
      "testimonials": [
        {
          "quote": "The most accurate weather app I've used, with a beautiful interface!",
          "author": "Tech Review Weekly",
          "role": "Publication",
          "avatarPath": "seeder/logo.png"
        },
        {
          "quote": "I love how the app adapts its theme to match current weather conditions",
          "author": "Olivia Parker",
          "role": "User",
          "avatarPath": "seeder/logo.png"
        }
      ]
    }
  }
}
''';

  Future<void> _seedFirestore() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Seeding database...';
    });

    try {
      await _seeder.seedProjectsFromJson(_jsonData);

      setState(() {
        _statusMessage = 'Database seeded successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkCurrentData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking current data...';
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('projects').get();

      setState(() {
        _statusMessage =
            'Current projects in database: ${snapshot.docs.length}';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error checking data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearProjects() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing projects...';
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('projects').get();

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      setState(() {
        _statusMessage =
            'Cleared ${snapshot.docs.length} projects successfully';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error clearing data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Seeder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Project Database Management',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _seedFirestore,
              child: const Text('Seed Projects Database'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkCurrentData,
              child: const Text('Check Current Projects'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: _isLoading ? null : _clearProjects,
              child: const Text('Clear All Projects'),
            ),
            const SizedBox(height: 24),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_statusMessage.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_statusMessage),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Import the FirestoreSeeder class from the previous file
class FirestoreSeeder {
  final FirebaseFirestore _firestore;

  FirestoreSeeder({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> seedProjectsFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> data = json.decode(jsonString);
      final Map<String, dynamic> projects = data['projects'];

      final WriteBatch batch = _firestore.batch();

      projects.forEach((String projectId, dynamic projectData) {
        final DocumentReference projectRef =
            _firestore.collection('projects').doc(projectId);
        batch.set(projectRef, projectData);
      });

      await batch.commit();

      print('Successfully seeded ${projects.length} projects to Firestore!');
    } catch (e) {
      print('Error seeding projects: $e');
      rethrow;
    }
  }
}
