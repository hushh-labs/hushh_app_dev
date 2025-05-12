import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ProgressBarNotificationService {
  //Hanle displaying of notifications.
  static final ProgressBarNotificationService _notificationService =
      ProgressBarNotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('ic_launcher');

  factory ProgressBarNotificationService() {
    return _notificationService;
  }

  ProgressBarNotificationService._internal() {
    init();
  }

  void init() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: _androidInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void createReceiptRadarNotification(int i, int total) {
    //show the notifications.
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'receipt radar', 'receipt radar',
        channelDescription: 'Receipt Radar notification',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: total,
        progress: i);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    _flutterLocalNotificationsPlugin.show(
        1,
        'Fetching Receipts from the inbox...',
        'Receipts: $i/$total',
        platformChannelSpecifics);
  }

  void removeNotification() {
    _flutterLocalNotificationsPlugin.cancel(1);
  }
}
