import 'package:centicbid/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  await GetStorage.init();
  runApp(GetMaterialApp(home: Home()));
}
