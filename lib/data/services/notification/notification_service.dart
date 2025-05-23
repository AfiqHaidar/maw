// lib/data/services/notification/notification_controller.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mb/data/enums/route_identifier.dart';
import 'package:mb/data/services/navigation/navigation_service.dart';
import 'package:mb/data/services/notification/notification_handler.dart';

@pragma('vm:entry-point')
class NotificationService {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATION METHODS
  ///  *********************************************

  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: Color(0xFF0A1931),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'silenced_channel',
          channelName: 'Silenced notifications',
          channelDescription: 'Notification channel for silenced notifications',
          defaultColor: Color(0xFF0A1931),
          ledColor: Colors.white,
          importance: NotificationImportance.Default,
          playSound: false,
          enableVibration: false,
        ),
        NotificationChannel(
          channelGroupKey: 'social_channel_group',
          channelKey: 'social_channel',
          channelName: 'Connection notifications',
          channelDescription: 'Notification channel for connection activities',
          defaultColor: Color(0xFF185ADB),
          ledColor: Colors.blue,
          importance: NotificationImportance.High,
          // You can add a custom sound here if you have one
          // soundSource: 'resource://raw/connection_sound'
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        ),
        NotificationChannelGroup(
          channelGroupKey: 'social_channel_group',
          channelGroupName: 'Social activities',
        ),
      ],
      debug: debug,
    );
    initialAction = await AwesomeNotifications().getInitialNotificationAction();

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
        onFcmSilentDataHandle: mySilentDataHandle,
        onFcmTokenHandle: myFcmTokenHandle,
        onNativeTokenHandle: myNativeTokenHandle,
        debug: debug);
  }

  static Future<bool> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Request permissions
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  /// Cancels a specific notification by ID
  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  /// Cancels all active notifications
  static Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  // Get Firebase FCM token
  static Future<String> getFirebaseMessagingToken() async {
    String firebaseAppToken = '';
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        firebaseAppToken =
            await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return firebaseAppToken;
  }

  // Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    await AwesomeNotificationsFcm().subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await AwesomeNotificationsFcm().unsubscribeToTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************

  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    if (silentData.data != null) {
      final data = silentData.data!;

      // Connection request notification
      if (data['type'] == 'connection_request' &&
          data.containsKey('connectionId') &&
          data.containsKey('userId')) {
        await NotificationTypeHandler.sendConnectionRequestNotification(
          userId: data['userId'],
          connectionId: data['connectionId'],
          username: data['username'],
          title: data['title'],
          body: data['body'],
        );
      }

      // Connection accepted notification
      else if (data['type'] == 'connection_accepted' &&
          data.containsKey('connectionId') &&
          data.containsKey('userId')) {
        await NotificationTypeHandler.sendConnectionAcceptedNotification(
          userId: data['userId'],
          connectionId: data['connectionId'],
          username: data['username'],
          title: data['title'],
          body: data['body'],
        );
      }
    }
  }

  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    debugPrint('FCM Token:"$token"');
  }

  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    debugPrint('Native Token:"$token"');
  }

  ///  *********************************************
  ///     LOCAL NOTIFICATION EVENTS
  ///  *********************************************

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Action received: ${receivedAction.toString()}');

    if (receivedAction.payload != null) {
      final payload = receivedAction.payload!;

      if (payload.containsKey('type')) {
        final type = payload['type'];

        switch (type) {
          case 'connection_request':
            NavigationService.navigateTo(RouteIdentifier.inbox);
            break;
          case 'connection_accepted':
            if (payload.containsKey('userId')) {
              NavigationService.navigateTo(RouteIdentifier.inbox);
            } else {
              NavigationService.navigateTo(RouteIdentifier.home);
            }
            break;
          default:
            {
              NavigationService.navigateTo(RouteIdentifier.home);
            }
        }
      } else {
        NavigationService.navigateTo(RouteIdentifier.home);
      }
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.toString()}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed: ${receivedNotification.toString()}');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification dismissed: ${receivedAction.toString()}');
  }
}
