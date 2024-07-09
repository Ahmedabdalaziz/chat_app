import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> userLogin(String email, String password) async {
  UserCredential userCred = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
  return userCred;
}