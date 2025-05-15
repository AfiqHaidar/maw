// lib/main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/data/enums/route_identifier.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/data/services/cache/cache_initializer.dart';
import 'package:mb/data/services/navigation/navigation.service.dart';
import 'package:mb/data/services/notification/notification_service.dart';
import 'package:mb/features/auth/screens/auth_screen.dart';
import 'package:mb/features/auth/screens/splash_screen.dart';
import 'package:mb/route.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.initializeLocalNotifications(debug: true);
  await NotificationService.initializeRemoteNotifications(debug: true);
  await CacheInitializer().initialize();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Maw',
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      initialRoute: RouteIdentifier.splash,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, ref),
      home: StreamBuilder<User?>(
        stream: ref.read(authRepositoryProvider).auth.idTokenChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.hasData) return const SplashScreen();
          return AuthScreen();
        },
      ),
    );
  }
}
