import 'package:centicbid/models/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class MessagingController extends GetxController {
  static MessagingController to = Get.find();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late List<Message> messagesList;

  _requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<String> getDeviceToken() async {
    String deviceToken = '';
    await messaging.getToken().then((token) {
      deviceToken = token!;
    });
    return deviceToken;
  }

  configureFirebaseListeners() async {
    await _requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
