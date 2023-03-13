import 'package:flutter/material.dart';
import 'package:test_notifications/core/utils/notifications_helper.dart';
import 'package:test_notifications/presentation/screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await NotificationsHelper.init();
  runApp(const NotificationApp());
}
class NotificationApp extends StatelessWidget {
  const NotificationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return const MaterialApp(debugShowCheckedModeBanner: false,
  home: HomeScreen(),
);
  }
}

