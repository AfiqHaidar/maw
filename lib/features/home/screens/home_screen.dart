// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/data/services/sound/sound_service.dart';
import 'package:mb/data/enums/sound_identifier.dart';
import 'package:mb/features/home/widgets/user_search_bar.dart';
import 'package:mb/features/home/widgets/user_search_results.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/features/home/screens/inbox_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback onMenuPressed;
  const HomeScreen({required this.onMenuPressed, super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeLottieAnimation();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _initializeLottieAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutSine),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToInbox() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const InboxScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userStreamProvider);
    final allUsersAsyncValue = ref.watch(allUsersProvider);

    return userAsyncValue.when(
      data: (user) => _buildHomeContent(context, user, allUsersAsyncValue),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error loading profile: $error')),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, UserEntity user,
      AsyncValue<List<UserEntity>> allUsersAsyncValue) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            UserSearchBar(
              controller: _searchController,
              isSearching: _isSearching,
              onToggleSearch: _toggleSearch,
              onInboxPressed: _navigateToInbox,
            ),
            Expanded(
              child: _isSearching && _searchQuery.isNotEmpty
                  ? UserSearchResults(
                      allUsersAsync: allUsersAsyncValue,
                      currentUser: user,
                      searchQuery: _searchQuery,
                    )
                  : _buildMainContent(user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(UserEntity user) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: InkWell(
          onTap: () async {
            SoundService().playSound(SoundIdentifier.meow);
            widget.onMenuPressed();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Lottie.asset(
            user.profilePicture.isNotEmpty
                ? user.profilePicture
                : 'assets/animations/hanging_cat.json',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
