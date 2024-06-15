import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo_list/controllers/invitation_controller.dart';
import 'package:todo_list/screens/pages/home_screen.dart';
import 'package:todo_list/screens/pages/notification_page.dart';

class NotificationController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  InvitationController invitationController = Get.find();
  //channel for foreground notif
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'todo_notif' // id
        'Todo notification', // title
    'Channel used for foreground notif on the app', // description
    importance: Importance.max,
  );
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, sound: true);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> initFLNotif() async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initilizationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initilizationSettings,
    );
  }

  Future<void> manageForegroundNotif() async {
    initFLNotif();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    //foreground message available
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // debugPrint(
        //     'Message also contained a notification: ${message.notification}');
        await flutterLocalNotificationsPlugin.show(
            message.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              icon: android.smallIcon,
            )),
            payload: message.data['body']);
      }
      if (message.data['type'] == 'invitation') {
        invitationController.getInvitations();
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'invitation') {
      Get.to(() => NotificationPage());
    } else if (message.data['type'] == 'due') {
      Get.to(() => const HomeScreen());
    } else if (message.data['type'] == 'New Task') {
      Get.to(() => const HomeScreen());
    }
  }
}
