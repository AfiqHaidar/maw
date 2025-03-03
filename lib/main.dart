import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/theme/app_theme.dart';
import 'package:mb/features/home/home.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(
//     const ProviderScope(
//       child: App(),
//     ),
//   );
// }

// class App extends ConsumerWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return MaterialApp(
//       title: 'MB Course',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
//       ),
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, authSnapshot) {
//           if (authSnapshot.connectionState == ConnectionState.waiting) {
//             return const SplashScreen();
//           }

//           if (authSnapshot.hasData) {
//             return SplashRedirectorScreen(userId: authSnapshot.data!.uid);
//           }

//           return const AuthScreen();
//         },
//       ),
//     );
//   }
// }
