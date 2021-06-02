import 'package:centicbid/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future registerWithEmail(String email, String password,
      {String? userName}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
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

  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showErrorToast('Wrong password provided for that user.');
      }
    }
  }

  Future signOut() async {
    await _auth.signOut();
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
}
