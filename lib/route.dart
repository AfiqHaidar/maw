// lib/core/routes/route.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/enums/route_identifier.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/features/auth/screens/auth_screen.dart';
import 'package:mb/features/auth/screens/splash_screen.dart';
import 'package:mb/features/portofolio/screens/portofolio_screen.dart';
import 'package:mb/features/profile/screens/profile_screen.dart';
import 'package:mb/widgets/tabs.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings,
    WidgetRef ref,
  ) {
    final args = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case RouteIdentifier.splash:
        return MaterialPageRoute(
          builder: (context) => StreamBuilder<User?>(
            stream: ref.read(authRepositoryProvider).auth.idTokenChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.hasData) return const SplashScreen();
              return AuthScreen();
            },
          ),
        );

      case RouteIdentifier.auth:
        return MaterialPageRoute(
          builder: (context) => AuthScreen(),
        );

      case RouteIdentifier.home:
        return MaterialPageRoute(
          builder: (context) => const TabsWrapper(),
        );

      case RouteIdentifier.project:
        if (args.containsKey('projectId') && args['projectId'] != null) {
          return MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }

        return MaterialPageRoute(
          builder: (context) => const TabsWrapper(),
        );

      case RouteIdentifier.portfolio:
        return MaterialPageRoute(
          builder: (context) => const PortofolioScreen(),
        );

      case RouteIdentifier.profile:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const TabsWrapper(),
        );
    }
  }
}
