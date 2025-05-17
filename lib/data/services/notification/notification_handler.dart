// lib/data/services/notification/notification_handler.dart
import 'package:mb/data/services/notification/notification_type.dart';
import 'package:mb/data/enums/route_identifier.dart';

@pragma('vm:entry-point')
class NotificationTypeHandler {
  // These methods should be static
  @pragma('vm:entry-point')
  static Future<void> sendConnectionRequestNotification({
    String? userId,
    String? connectionId,
    String? username,
    String? title,
    String? body,
  }) async {
    await NotificationTypes.createBasicNotification(
      id: _generateNotificationId(connectionId ?? ''),
      title: title ?? "New Connection Request",
      body: body ??
          (username != null
              ? "@$username wants to connect with you"
              : "Someone wants to connect with you"),
      payload: {
        'type': 'connection_request',
        'connectionId': connectionId ?? '',
        'userId': userId ?? '',
        'screen': RouteIdentifier.inbox,
      },
      channelKey: 'social_channel',
    );
  }

  // This method should be static
  @pragma('vm:entry-point')
  static Future<void> sendConnectionAcceptedNotification({
    String? userId,
    String? connectionId,
    String? username,
    String? title,
    String? body,
  }) async {
    await NotificationTypes.createBasicNotification(
      id: _generateNotificationId(connectionId ?? ''),
      title: title ?? "Connection Accepted",
      body: body ??
          (username != null
              ? "@$username accepted your connection request"
              : "Someone accepted your connection request"),
      payload: {
        'type': 'connection_accepted',
        'connectionId': connectionId ?? '',
        'userId': userId ?? '',
        'screen': RouteIdentifier.inbox,
      },
      channelKey: 'social_channel',
    );
  }

  // This helper method should be static
  @pragma('vm:entry-point')
  static int _generateNotificationId(String connectionId) {
    // Use the hashCode of the connection ID to create a unique int ID
    // Add a base value to avoid potential negative numbers
    return (connectionId.hashCode.abs() % 100000) + 1000;
  }
}
