import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/api/notification_api.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) {
  return NotificationApi();
});
