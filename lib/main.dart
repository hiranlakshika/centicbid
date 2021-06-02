import 'package:centicbid/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(home: Home()));
}
