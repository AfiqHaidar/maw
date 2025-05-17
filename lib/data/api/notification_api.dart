// lib/data/api/notification_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationApi {
  static const String _baseUrl =
      'https://us-central1-mb-course.cloudfunctions.net/notifications';

  Future<bool> sendConnectionRequestNotification({
    required String targetUserId,
    required String connectionId,
    required String fromUserId,
  }) async {
    return _sendNotification(
      targetUserId: targetUserId,
      type: 'connection_request',
      connectionId: connectionId,
      fromUserId: fromUserId,
    );
  }

  Future<bool> sendConnectionAcceptedNotification({
    required String targetUserId,
    required String connectionId,
    required String fromUserId,
  }) async {
    return _sendNotification(
      targetUserId: targetUserId,
      type: 'connection_accepted',
      connectionId: connectionId,
      fromUserId: fromUserId,
    );
  }

  Future<bool> _sendNotification({
    required String targetUserId,
    required String type,
    required String connectionId,
    required String fromUserId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send-notification'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'targetUserId': fromUserId,
          'type': type,
          'connectionId': connectionId,
          'fromUserId': fromUserId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error sending notification: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception sending notification: $e');
      return false;
    }
  }
}
