import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/services/sharedPreferences.dart';

import 'databaseServices.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential result;

  Future<dynamic> registerWithEmail(email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      bool res = await DatabaseServices()
          .createUser(email, password, userCredential.user.uid);
      if (res == true) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return e.code;
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<dynamic> signInWithEmail(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String name, uid;
      bool isAdmin;

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userCredential.user.uid)
          .get()
          .then((value) {
        name = value["name"];
        isAdmin = value["isAdmin"];
        uid = value["uid"];
      });

      bool ans1 = await SharedFunctions.saveUserName(name);
      bool ans2 = await SharedFunctions.saveUserAdminStatus(isAdmin);
      bool ans3 = await SharedFunctions.saveUserUid(uid);

      return (ans1 && ans2 && ans3);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    } catch (e) {
      print(e);
      return e;
    }
  }

  signOutUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    await _auth.signOut();
  }
}
