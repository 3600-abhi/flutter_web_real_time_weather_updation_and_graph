import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class signInAuthUsingEmailAndPassword {


  static Future signInAuth(BuildContext _context,String _email, String _password) async {

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator())
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
    } catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  static Future signUpAuth(BuildContext _context,String _email, String _password) async {

    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );


    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

  }

  static Future signOutAuth() async {
    FirebaseAuth.instance.signOut();
  }
}
