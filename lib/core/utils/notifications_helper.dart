import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationsHelper {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  static late Location myLocation;
  static Future<void> init() async {
    tz.initializeTimeZones();
    myLocation = tz.getLocation(
      await FlutterNativeTimezone.getLocalTimezone(),
    );
    tz.setLocalLocation(myLocation);
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<void> scheduleNotification(String title, String body,
      {int hours = 0, int minutes = 0}) async {
    final TZDateTime timeNow = tz.TZDateTime.now(tz.local);
    final int day= ((hours < timeNow.hour) || (hours == timeNow.hour && minutes<=timeNow.minute) ) ? timeNow.day + 1 : timeNow.day;
    final TZDateTime scheduleTime = tz.TZDateTime(
      myLocation,
      timeNow.year,
      timeNow.month,
      day,
      hours,
      minutes,
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        scheduleTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Scheduled notifications',
            'scheduled notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
     
  }

static void cancelAllNotifications(){
  _flutterLocalNotificationsPlugin.cancelAll();
}
}
