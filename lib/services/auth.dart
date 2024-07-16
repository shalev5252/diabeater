import 'package:diabeater/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create UserModel object based on FirebaseUser
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(userId: user.uid, error: false) : null;
  }

  //set stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in by anon demo:
  Future signInAnon() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      print("Signed in with temporary account.");
      return _userFromFirebaseUser(userCredential.user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  //sign in via E-mail and password
  Future SignInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebaseUser(user);
    } on FirebaseException catch (e) {
      print(e.message.toString());
      return UserModel(userId: e.message.toString(), error: true);
    } catch (e) {
      return UserModel(userId: e.toString(), error: true);
    }
  }

  //register via E-mail and password
  Future RegisterWithEmailAndPassword(String email, String password,
      String name, String phone, DateTime birthday) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      bool is_verified = user!.emailVerified; // todo?
      if (user != null) {
        //&& is_verified) {
        await DatabaseService(uid: user.uid)
            .setUserData(name, email, birthday, phone, false);
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      print("error at registration");
      return UserModel(userId: e.toString(), error: true);
    }
  }

  //sign out
  Future signOut() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print("User currentely signed out");
        } else {
          print("User is signed in");
        }
      });
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
