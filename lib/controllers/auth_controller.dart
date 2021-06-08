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
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showErrorToast('Wrong password provided for that user.');
      }
    }
  }

  Future<UserCredential?> registerWithEmail(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showErrorToast('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      showErrorToast(e.message.toString());
      return null;
    } catch (e) {
      showErrorToast("Unknown error");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}
