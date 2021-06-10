import 'package:centicbid/db/firestore_util.dart';
import 'package:centicbid/db/local_db.dart';
import 'package:centicbid/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);

    super.onReady();
  }

  handleAuthChanged(_firebaseUser) async {
    if (_firebaseUser == null) {
      print('Show Login');
    } else {
      print('Hide Login');
    }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  //Method to handle user sign in using email and password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (firebaseUser.value != null) {
        var db = DatabaseHelper();
        await db.database
            .whenComplete(() async => await db.deleteLocalDatabase());
        FirestoreController firestoreController =
            Get.put(FirestoreController());
        await firestoreController.getBids(firebaseUser.value!.uid);
        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorToast('user_not_found'.tr);
      } else if (e.code == 'wrong-password') {
        showErrorToast('wrong_pw'.tr);
      }
    }
  }

  Future<UserCredential?> registerWithEmail(
      String email, String password, String userName) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorToast('weak_pw'.tr);
      } else if (e.code == 'email-already-in-use') {
        showErrorToast('account_already_exists'.tr);
      }
    } catch (e) {
      print(e);
    } finally {
      if (firebaseUser.value != null) {
        await firebaseUser.value!.updateProfile(displayName: userName);
      }
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      showErrorToast(e.message.toString());
      return null;
    } catch (e) {
      showErrorToast("unknown_error".tr);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}
