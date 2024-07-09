import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> userRegister(String email, String password) async {
  UserCredential userCred = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  return userCred;
}