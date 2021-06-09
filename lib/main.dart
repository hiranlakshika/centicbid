import 'dart:ui';
import 'package:centicbid/controllers/auth_controller.dart';
import 'package:centicbid/screens/home.dart';
import 'package:centicbid/services/localization_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<AuthController>(AuthController());
  runApp(GetMaterialApp(
    home: Home(),
    locale: window.locale,
    fallbackLocale: LocalizationService.fallbackLocale,
    translations: LocalizationService(),
  ));
}
