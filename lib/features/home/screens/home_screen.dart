import 'package:flutter/material.dart';
import 'package:mb/data/services/notification/notification_type.dart';
import 'package:mb/data/services/sound/sound_service.dart';
import 'package:mb/data/enums/sound_identifier.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/widgets/drawer/main_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/user_entity.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeLottieAnimation();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userStreamProvider);

    return userAsyncValue.when(
      data: (user) => _buildProfileContent(context, user),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error loading profile: $error')),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserEntity user) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenuPressed,
        ),
      ),
      drawer: const MainDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        SoundService().playSound(SoundIdentifier.meow);
                        await NotificationTypes.createBasicNotification(
                          id: 1,
                          title: 'Maw!',
                          body: 'UIIAIUIIIAIUIA',
                          payload: {'userId': user.id},
                        );
                        await NotificationTypes.createBasicNotification(
                          id: 2,
                          title: 'Maw Maw!',
                          body: 'UIIAIUIIIAIUIA',
                          payload: {'userId': user.id},
                        );
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
