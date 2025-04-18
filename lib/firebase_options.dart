// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBkZt8PLh2TKMp4UtZib-FjXjWyFJ7kUzU',
    appId: '1:214319330535:web:b843a3218612d130755e42',
    messagingSenderId: '214319330535',
    projectId: 'mb-course',
    authDomain: 'mb-course.firebaseapp.com',
    storageBucket: 'mb-course.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBag7KLfuxqq2mqQjbSyGEB_wpT2GrAszc',
    appId: '1:214319330535:android:e3d4e1ab007bf601755e42',
    messagingSenderId: '214319330535',
    projectId: 'mb-course',
    storageBucket: 'mb-course.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBheFE4v5uKpLswTTwWAe5RpqE-GcklGhg',
    appId: '1:214319330535:ios:20ca03228a1e1341755e42',
    messagingSenderId: '214319330535',
    projectId: 'mb-course',
    storageBucket: 'mb-course.firebasestorage.app',
    iosBundleId: 'com.example.mb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBheFE4v5uKpLswTTwWAe5RpqE-GcklGhg',
    appId: '1:214319330535:ios:20ca03228a1e1341755e42',
    messagingSenderId: '214319330535',
    projectId: 'mb-course',
    storageBucket: 'mb-course.firebasestorage.app',
    iosBundleId: 'com.example.mb',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBkZt8PLh2TKMp4UtZib-FjXjWyFJ7kUzU',
    appId: '1:214319330535:web:e06125f88d1281bc755e42',
    messagingSenderId: '214319330535',
    projectId: 'mb-course',
    authDomain: 'mb-course.firebaseapp.com',
    storageBucket: 'mb-course.firebasestorage.app',
  );

}