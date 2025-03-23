import 'package:flutter/material.dart';
import 'package:mb/data/enums/banner_identifier.dart';
import 'package:mb/data/models/project_model.dart';

final List<ProjectModel> dummyProjects = [
  ProjectModel(
    id: 'project1',
    userId: 'user123',
    name: 'Tetris Game',
    bannerBgColor: Colors.red,
    bannerType: BannerIdentifier.lottie,
    bannerImagePath: 'assets/images/games/tetris.jpg',
    bannerLottiePath: 'assets/animations/stare_cat.json',
    carouselImagePaths: [
      'assets/images/games/tetris.jpg',
      'assets/images/games/dino.jpg',
      'assets/images/games/dino.jpg',
      'assets/images/games/dino.jpg',
    ],
    details:
        'A block-stacking puzzle game built with Flutter. Features classic mechanics and responsive design.',
    link: 'https://github.com/AfiqHaidar/mobile-programming-course',
    techStack: ['Flutter', 'Dart'],
    tags: ['Game', 'Puzzle', 'Classic'],
    releaseDate: DateTime(2024, 6, 1),
    shortDescription:
        'Modern implementation of the classic Tetris puzzle game for mobile devices',
    role: 'Lead Developer',
    developmentTime: Duration(days: 45),
    teamMembers: [
      TeamMember(
        name: 'Jane Doe',
        role: 'UI/UX Designer',
        avatarPath: 'assets/images/team/jane.jpg',
        linkedinUrl: 'https://linkedin.com/in/janedoe',
      ),
      TeamMember(
        name: 'John Smith',
        role: 'Backend Developer',
        avatarPath: 'assets/images/team/john.jpg',
        linkedinUrl: 'https://linkedin.com/in/johnsmith',
      ),
    ],
    keyFeatures: [
      Feature(
        title: 'Classic Controls',
        description: 'Intuitive swipe and tap controls optimized for mobile',
        iconName: 'gamepad',
      ),
      Feature(
        title: 'Score System',
        description: 'Tracks high scores and gameplay statistics',
        iconName: 'leaderboard',
      ),
      Feature(
        title: 'Difficulty Levels',
        description: 'Multiple speed settings for players of all skill levels',
        iconName: 'speed',
      ),
    ],
    challenges: [
      Challenge(
        title: 'Touch Controls',
        description:
            'Adapting traditional keyboard controls to touch interfaces',
        solution: 'Implemented a custom gesture detector with haptic feedback',
      ),
      Challenge(
        title: 'Performance Optimization',
        description: 'Ensuring smooth gameplay on lower-end devices',
        solution:
            'Used a custom rendering engine and efficient collision detection',
      ),
    ],
    githubLink: 'https://github.com/AfiqHaidar/tetris-flutter',
    additionalLinks: [
      'https://play.google.com/store/apps/tetris',
      'https://afiqhaidar.dev/projects/tetris'
    ],
    testimonials: [
      Testimonial(
        quote: 'The best Tetris implementation I\'ve seen on mobile!',
        author: 'Mobile Gaming Weekly',
        role: 'Publication',
        avatarPath: 'assets/images/testimonials/mgw.jpg',
      ),
    ],
    stats: ProjectStats(
      users: 15000,
      stars: 124,
      forks: 45,
      downloads: 25000,
      contributions: 8,
    ),
    futureEnhancements: [
      Future(
        title: 'Multiplayer Mode',
        description: 'Real-time competition with other players',
        status: 'Planned',
      ),
      Future(
        title: 'Custom Themes',
        description: 'Personalized block and background designs',
        status: 'In Development',
      ),
    ],
  ),
  ProjectModel(
    id: 'project2',
    userId: 'user123',
    name: 'Dino Runner',
    bannerBgColor: Colors.blue,
    bannerType: BannerIdentifier.picture,
    bannerImagePath: 'assets/images/logo.png',
    bannerLottiePath: 'assets/animations/stare_cat.json',
    carouselImagePaths: [
      'assets/images/games/dino.jpg',
      'assets/images/games/dino.jpg',
      'assets/images/games/dino.jpg',
      'assets/images/games/dino.jpg',
    ],
    details:
        'An offline-style endless runner game inspired by the Chrome Dino game. Built for mobile.',
    link: 'https://github.com/AfiqHaidar/mobile-programming-course',
    techStack: ['Flutter', 'Flame Engine'],
    tags: ['Game', 'Runner'],
    releaseDate: DateTime(2024, 7, 10),
    shortDescription:
        'Endless runner inspired by the Chrome offline dinosaur game',
    role: 'Solo Developer',
    developmentTime: Duration(days: 30),
    teamMembers: [
      TeamMember(
        name: 'Alex Chen',
        role: 'Art Designer',
        avatarPath: 'assets/images/team/alex.jpg',
        linkedinUrl: 'https://linkedin.com/in/alexchen',
      ),
    ],
    keyFeatures: [
      Feature(
        title: 'Procedural Generation',
        description: 'Dynamically generated obstacles for endless gameplay',
        iconName: 'sync',
      ),
      Feature(
        title: 'Day/Night Cycle',
        description: 'Visual changes based on play duration',
        iconName: 'brightness_4',
      ),
      Feature(
        title: 'Power-ups',
        description: 'Collectible items that provide temporary abilities',
        iconName: 'flash_on',
      ),
    ],
    challenges: [
      Challenge(
        title: 'Game Physics',
        description: 'Creating realistic jumping mechanics with proper gravity',
        solution: 'Implemented custom physics engine with variable gravity',
      ),
      Challenge(
        title: 'Difficulty Scaling',
        description:
            'Gradually increasing difficulty without frustrating players',
        solution:
            'Created an adaptive difficulty system based on player performance',
      ),
    ],
    githubLink: 'https://github.com/AfiqHaidar/dino-runner',
    additionalLinks: ['https://afiqhaidar.dev/projects/dino'],
    testimonials: [
      Testimonial(
        quote: 'Addictive gameplay with charming pixel art style!',
        author: 'Sarah Johnson',
        role: 'Game Reviewer',
        avatarPath: 'assets/images/testimonials/sarah.jpg',
      ),
    ],
    stats: ProjectStats(
      users: 8000,
      stars: 87,
      forks: 23,
      downloads: 12000,
      contributions: 3,
    ),
    futureEnhancements: [
      Future(
        title: 'Character Customization',
        description: 'Unlockable skins and characters',
        status: 'Planned',
      ),
      Future(
        title: 'Global Leaderboard',
        description: 'Online score comparison with other players',
        status: 'In Development',
      ),
    ],
  ),
  ProjectModel(
    id: 'project3',
    userId: 'user123',
    name: 'Minesweeper Clone',
    bannerBgColor: Colors.green,
    bannerType: BannerIdentifier.picture,
    bannerImagePath: 'assets/images/games/mine.jpg',
    bannerLottiePath: 'assets/animations/stare_cat.json',
    carouselImagePaths: [
      'assets/images/games/mine.jpg',
      'assets/images/games/mine.jpg',
      'assets/images/games/mine.jpg',
      'assets/images/games/mine.jpg',
    ],
    details:
        'A modern take on the classic minesweeper game, complete with animations and difficulty levels.',
    link: 'https://github.com/AfiqHaidar/mobile-programming-course',
    techStack: ['Flutter', 'Dart'],
    tags: ['Game', 'Logic', 'Classic'],
    releaseDate: DateTime(2024, 8, 5),
    shortDescription: 'Modern redesign of the classic Minesweeper puzzle game',
    role: 'Lead Developer',
    developmentTime: Duration(days: 21),
    teamMembers: [
      TeamMember(
        name: 'Maria Rodriguez',
        role: 'UI Designer',
        avatarPath: 'assets/images/team/maria.jpg',
        linkedinUrl: 'https://linkedin.com/in/mariarodriguez',
      ),
    ],
    keyFeatures: [
      Feature(
        title: 'Smart Flagging',
        description: 'Intelligent system to help players mark potential mines',
        iconName: 'flag',
      ),
      Feature(
        title: 'First-click Protection',
        description: 'Players never hit a mine on their first move',
        iconName: 'security',
      ),
      Feature(
        title: 'Custom Board Sizes',
        description: 'Adjustable grid dimensions for varied difficulty',
        iconName: 'grid_on',
      ),
    ],
    challenges: [
      Challenge(
        title: 'Random Board Generation',
        description: 'Creating balanced and solvable game boards',
        solution: 'Developed an algorithm to ensure logical solutions exist',
      ),
      Challenge(
        title: 'Mobile Space Constraints',
        description: 'Adapting the game to smaller mobile screens',
        solution: 'Implemented pinch-to-zoom and smart UI scaling',
      ),
    ],
    githubLink: 'https://github.com/AfiqHaidar/minesweeper-flutter',
    additionalLinks: ['https://afiqhaidar.dev/projects/minesweeper'],
    testimonials: [
      Testimonial(
        quote: 'The interface is so clean, and the game runs perfectly!',
        author: 'Tech Games Today',
        role: 'Game Blog',
        avatarPath: 'assets/images/testimonials/tgt.jpg',
      ),
    ],
    stats: ProjectStats(
      users: 5500,
      stars: 62,
      forks: 18,
      downloads: 9000,
      contributions: 5,
    ),
    futureEnhancements: [
      Future(
        title: 'Daily Challenges',
        description: 'New puzzles every day with variable difficulty',
        status: 'Planned',
      ),
      Future(
        title: 'Hint System',
        description: 'Optional hints for players who get stuck',
        status: 'In Development',
      ),
    ],
  ),
  ProjectModel(
    id: 'project4',
    userId: 'user123',
    name: 'Sudoku Solver App',
    bannerBgColor: Colors.orange,
    bannerType: BannerIdentifier.picture,
    bannerImagePath: 'assets/images/games/sudoku.jpg',
    bannerLottiePath: 'assets/animations/stare_cat.json',
    carouselImagePaths: [
      'assets/images/games/sudoku.jpg',
      'assets/images/games/sudoku.jpg',
      'assets/images/games/sudoku.jpg',
      'assets/images/games/sudoku.jpg',
    ],
    details:
        'A clean Sudoku game with solving assistant and multiple difficulty levels. Built for learning algorithms.',
    link: 'https://github.com/AfiqHaidar/mobile-programming-course',
    techStack: ['Flutter', 'Dart', 'Algorithms'],
    tags: ['Game', 'Logic', 'Solver'],
    releaseDate: DateTime(2024, 9, 15),
    shortDescription: 'Sudoku game and solver using backtracking algorithms',
    role: 'Algorithm Specialist',
    developmentTime: Duration(days: 60),
    teamMembers: [
      TeamMember(
        name: 'David Park',
        role: 'Frontend Developer',
        avatarPath: 'assets/images/team/david.jpg',
        linkedinUrl: 'https://linkedin.com/in/davidpark',
      ),
      TeamMember(
        name: 'Lisa Wang',
        role: 'UX Researcher',
        avatarPath: 'assets/images/team/lisa.jpg',
        linkedinUrl: 'https://linkedin.com/in/lisawang',
      ),
    ],
    keyFeatures: [
      Feature(
        title: 'Automatic Solver',
        description:
            'Solves any valid Sudoku puzzle using backtracking algorithms',
        iconName: 'auto_fix_high',
      ),
      Feature(
        title: 'Step-by-Step Solutions',
        description: 'Shows solving process one step at a time for learning',
        iconName: 'school',
      ),
      Feature(
        title: 'Puzzle Generator',
        description: 'Creates new puzzles with guaranteed single solutions',
        iconName: 'shuffle',
      ),
    ],
    challenges: [
      Challenge(
        title: 'Algorithm Efficiency',
        description:
            'Making the solving algorithm fast enough for mobile devices',
        solution:
            'Implemented constraint-based optimization to reduce backtracking steps',
      ),
      Challenge(
        title: 'Puzzle Difficulty Rating',
        description: 'Creating an accurate system to rate puzzle difficulty',
        solution:
            'Developed a machine learning model to classify puzzles based on solving techniques needed',
      ),
    ],
    githubLink: 'https://github.com/AfiqHaidar/sudoku-solver',
    additionalLinks: [
      'https://sudoku.afiqhaidar.dev',
      'https://medium.com/@afiqhaidar/sudoku-algorithms'
    ],
    testimonials: [
      Testimonial(
        quote:
            'The step-by-step solution feature helped me understand Sudoku strategies I never knew about!',
        author: 'Miguel Torres',
        role: 'User',
        avatarPath: 'assets/images/testimonials/miguel.jpg',
      ),
      Testimonial(
        quote: 'Best Sudoku app I\'ve tried, with excellent puzzle generation',
        author: 'Puzzle Enthusiast Magazine',
        role: 'Publication',
        avatarPath: 'assets/images/testimonials/pem.jpg',
      ),
    ],
    stats: ProjectStats(
      users: 20000,
      stars: 156,
      forks: 67,
      downloads: 35000,
      contributions: 12,
    ),
    futureEnhancements: [
      Future(
        title: 'Camera Input',
        description: 'Ability to scan physical Sudoku puzzles using the camera',
        status: 'In Development',
      ),
      Future(
        title: 'Advanced Techniques Tutorial',
        description: 'Interactive lessons on Sudoku solving strategies',
        status: 'Planned',
      ),
      Future(
        title: 'Variant Puzzles',
        description:
            'Support for Sudoku variants like Killer Sudoku and Samurai Sudoku',
        status: 'Research',
      ),
    ],
  ),
  ProjectModel(
    id: 'project5',
    userId: 'user123',
    name: 'Flappy Clone',
    bannerBgColor: Colors.purple,
    bannerType: BannerIdentifier.lottie,
    bannerImagePath: 'assets/images/games/flap.jpg',
    bannerLottiePath: 'assets/animations/hanging_cat.json',
    carouselImagePaths: [
      'assets/images/games/flap.jpg',
      'assets/images/games/flap.jpg',
      'assets/images/games/flap.jpg',
    ],
    details:
        'A flappy bird style mobile game using Flutter and custom animations.',
    link: 'https://github.com/AfiqHaidar/mobile-programming-course',
    techStack: ['Flutter', 'Dart', 'Game Physics'],
    tags: ['Game', 'Arcade'],
    releaseDate: DateTime(2024, 10, 3),
    shortDescription: 'Fast-paced arcade game inspired by Flappy Bird',
    role: 'Game Developer',
    developmentTime: Duration(days: 15),
    teamMembers: [
      TeamMember(
        name: 'Zoe Thompson',
        role: 'Artist',
        avatarPath: 'assets/images/team/zoe.jpg',
        linkedinUrl: 'https://linkedin.com/in/zoethompson',
      ),
    ],
    keyFeatures: [
      Feature(
        title: 'Simple Controls',
        description: 'One-touch gameplay accessible to all ages',
        iconName: 'touch_app',
      ),
      Feature(
        title: 'Custom Characters',
        description: 'Multiple playable characters with unique abilities',
        iconName: 'pets',
      ),
      Feature(
        title: 'Dynamic Obstacles',
        description: 'Randomly generated obstacles with increasing difficulty',
        iconName: 'block',
      ),
    ],
    challenges: [
      Challenge(
        title: 'Hit Detection',
        description:
            'Creating precise collision detection without affecting performance',
        solution:
            'Implemented simplified hitboxes with optimized collision algorithms',
      ),
      Challenge(
        title: 'Game Balance',
        description: 'Making the game challenging but not frustrating',
        solution: 'Used playtest data to fine-tune difficulty progression',
      ),
    ],
    githubLink: 'https://github.com/AfiqHaidar/flappy-clone',
    additionalLinks: ['https://play.google.com/store/apps/flappyclone'],
    testimonials: [
      Testimonial(
        quote: 'Just as addictive as the original, but with better graphics!',
        author: 'James Wilson',
        role: 'Mobile Gamer',
        avatarPath: 'assets/images/testimonials/james.jpg',
      ),
    ],
    stats: ProjectStats(
      users: 12000,
      stars: 93,
      forks: 34,
      downloads: 18000,
      contributions: 6,
    ),
    futureEnhancements: [
      Future(
        title: 'Seasonal Themes',
        description: 'Holiday-themed graphics and special events',
        status: 'Planned',
      ),
      Future(
        title: 'Achievement System',
        description: 'Unlockable badges and rewards for skilled players',
        status: 'In Development',
      ),
    ],
  ),
];
