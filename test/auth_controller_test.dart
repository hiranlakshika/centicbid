import 'package:centicbid/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  group('Firebase Auth Test', () {
    AuthController authController = Get.put(AuthController());

    test('User Signup Test', () async {
      UserCredential? result = await authController.registerWithEmail(
          'test@zgmail.com', '123123123', 'Test User');
      expect(result!.user, isNotNull);
    });
    test('User Signin Test', () async {
      UserCredential? result =
          await authController.signInWithEmail('test@zgmail.com', '123123123');
      expect(result!.user, isNotNull);
    });
  });
}
