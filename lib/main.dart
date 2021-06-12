import 'dart:ui';
import 'package:centicbid/screens/home.dart';
import 'package:centicbid/services/localization_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/messaging_controller.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  MessagingController messagingController = Get.put(MessagingController());
  await messagingController.configureFirebaseListeners();
  runApp(GetMaterialApp(
    home: Home(),
    locale: window.locale,
    fallbackLocale: LocalizationService.fallbackLocale,
    translations: LocalizationService(),
  ));
}
