import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_twitter/model/data_user.dart';

class AccountManager with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  UserData? currentUser;
  bool get isLogin => currentUser != null;

  Future<void> checkLogin() async {
    User? user = await auth.userChanges().first;
    if (user != null) {
      currentUser = UserData(mail: user.email!, displayName: user.displayName!);
      print("user: $currentUser");
    } else {
      print('Not login');
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    currentUser = null;
  }

  Future<bool> register(UserData userData, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userData.mail,
        password: password,
      );
      await userCredential.user?.updateDisplayName(userData.displayName);
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      throw e;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<UserData?> login(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    var fUser = userCredential.user;
    if (fUser != null) {
      currentUser =
          UserData(mail: fUser.email!, displayName: fUser.displayName!);
    }
    return currentUser;
  }
}
