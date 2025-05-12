import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hushh_app/app/shared/core/utils/notification_listener_service.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Private constructor
  NotificationService._internal();

  // Singleton pattern
  factory NotificationService() {
    return _notificationService;
  }

  Future<void> setupFcmListeners(BuildContext context) async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance.requestPermission();
    }
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      print("AAAAAMAAAMESSSMSMSMSMSM::$initialMessage");
      showNotification(
        200, initialMessage.notification?.title ?? 'N/A', initialMessage.notification?.body ?? 'N/A', {}
      );
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print("MAAAMESSSMSMSMSMSM::"
            "$message");
        showNotification(
            200, message.notification?.title ?? 'N/A', message.notification?.body ?? 'N/A', {}
        );
      },
    );

    // currently user is using your app, and suddenly get notification. you will listen it here:
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("MMESSSMSMSMSMSM::$message");
      showNotification(int.tryParse(message.data['title'] ?? '') ?? 0,
          message.data['title'], message.data['description'], jsonDecode(message.data['payload']));
    });
  }

  // Initialize notification settings
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Use your own app icon
    DarwinInitializationSettings initializationSettingsIos =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            // onDidReceiveLocalNotification: (int id, String? title, String? body,
            //     String? payload) async {}
            );
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIos);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        NotificationListenerService.listen(response);
      },
    );
  }

  // Show notification
  Future<void> showNotification(
      int id, String title, String body, Map<String, dynamic> payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'notification', // Channel ID
      'noti_service', // Channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
        id, // Notification ID, used to cancel/update notification later
        title, // Notification title
        body, // Notification body
        platformChannelSpecifics,
        payload: jsonEncode(payload));
  }

  // Cancel a notification by ID
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
