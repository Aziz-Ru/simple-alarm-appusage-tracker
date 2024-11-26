import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mediationapp/feature/alarm/time_model.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {}
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Define AndroidInitializationSettings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/launcher_icon");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    //Request permission
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> setAlarm({
    required TimeModel timeModel,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        autoCancel: false,
        ticker: 'ticker',
        sound: RawResourceAndroidNotificationSound('alarm'),
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      timeModel.id,
      timeModel.title,
      timeModel.description,
      tz.TZDateTime.from(timeModel.scheduledTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin
        .cancel(id); // Cancels notification by ID
  }
}
