import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:test_notifications/core/utils/my_utils.dart';
import 'package:test_notifications/core/utils/notifications_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TimeOfDay? scheduleTime;
  late TimeOfDay _currentTime;
  late Timer timer;
  late Timer animationTimer;
  late AnimationController _animationController;
  @override
  void didChangeDependencies() {
    _currentTime = TimeOfDay.now();
    animationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      
      playStopAnimation();
    });
    
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    timer.cancel();
    animationTimer.cancel();
    super.dispose();
  }

  void _getTime() {
    setState(() {
      _currentTime = TimeOfDay.now();
    });
  }

  void playStopAnimation() {
    _animationController
        .forward()
        .whenComplete(() => _animationController.reset());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 35, 146),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Positioned(
                  left: 70,
                  top: 60,
                  child: Lottie.asset('assets/animations/clickme.zip',
                      height: 100,
                      alignment: Alignment.center,
                      controller: _animationController)),
              Column(
                children: [
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    splashColor: const Color.fromARGB(255, 15, 35, 146),
                    onTap: () async {
                      scheduleTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      timer.cancel();
                      _animationController.reset();
                      animationTimer.cancel();
                      setState(() {});
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                          alignment: Alignment.center,
                          width: 230,
                          height: 100,
                          child: Text(
                            scheduleTime == null
                                ? _currentTime.format(context)
                                : scheduleTime!.format(context),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 45),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    splashColor: const Color.fromARGB(255, 15, 35, 146),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () async {
                      int hours = scheduleTime == null
                          ? _currentTime.hour
                          : scheduleTime!.hour;
                      int minutes = scheduleTime == null
                          ? _currentTime.minute
                          : scheduleTime!.minute;
                      await NotificationsHelper.scheduleNotification(
                          'Repeating Local notifications', 'Hello world',
                          hours: hours, minutes: minutes);
                      // ignore: use_build_context_synchronously
                      showSnackBar(context,
                          'Notifications Scheduled for ${hours ~/ 10 == 0 ? '0' : ''}$hours:${minutes ~/ 10 == 0 ? '0' : ''}$minutes ${hours < 12 ? "AM" : "PM"} of every day.');
                      _animationController.reset();
                      animationTimer.cancel();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 9, 226, 27),
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        height: 50,
                        width: 230,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Schedule Notification',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(
                              Icons.notification_add,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    splashColor: const Color.fromARGB(255, 15, 35, 146),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () async {
                      NotificationsHelper.cancelAllNotifications();
                      showSnackBar(context, 'All Notifications canceled.');
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        height: 50,
                        width: 230,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Cancel Notifications',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Icon(
                              Icons.notifications_off,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      )),
    );
  }
}
