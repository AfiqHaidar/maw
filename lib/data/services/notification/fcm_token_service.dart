// lib/data/services/notification/fcm_token_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mb/data/services/notification/notification_service.dart';

class FcmTokenService {
  static final FcmTokenService _instance = FcmTokenService._internal();

  factory FcmTokenService() {
    return _instance;
  }

  FcmTokenService._internal();

  Future<void> updateFcmToken() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final String fcmToken =
            await NotificationService.getFirebaseMessagingToken();
        if (fcmToken.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .update({'fcmToken': fcmToken});

          print('FCM token updated successfully');
        }
      } catch (e) {
        print('Error updating FCM token: $e');
      }
    }
  }
}
