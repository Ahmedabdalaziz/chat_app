import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../helper/login_firebase.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/elevated_button.dart';
import 'chat_page.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kSecondColor),
      ),
      blur: double.infinity,
      color: kPrimaryColor,
      inAsyncCall: _isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 200),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: kSecondColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: _emailController,
                        icon: FontAwesomeIcons.envelope,
                        labelText: 'Email',
                        color: kSecondColor,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            color: kSecondColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        icon: FontAwesomeIcons.lock,
                        controller: _passwordController,
                        labelText: 'Password',
                        color: kSecondColor,
                        obscureText: _isObscure,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: kSecondColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    String email = _emailController.text;
                                    String password = _passwordController.text;

                                    UserCredential userCred =
                                        await userLogin(email, password);

                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(email: email,),
                                      ),
                                    );

                                    snackBar(
                                      context,
                                      message: 'Login Successful!',
                                      colorOfMessage: kSecondColor,
                                      colorOfText: kPrimaryColor,
                                    );
                                  } on FirebaseAuthException catch (ex) {
                                    print('Error code: ${ex.code}');
                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    if (ex.code case "user-not-found") {
                                      snackBar(
                                        context,
                                        message:
                                            'No user found for that email.',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else if (ex.code case "wrong-password") {
                                      snackBar(
                                        context,
                                        message: 'Wrong password provided.',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else if (ex.code case "invalid-email") {
                                      snackBar(
                                        context,
                                        message: 'Invalid email address.',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else if (ex.code case "user-disabled") {
                                      snackBar(
                                        context,
                                        message: 'User disabled.',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else if (ex.code
                                        case 'too-many-requests') {
                                      snackBar(
                                        context,
                                        message:
                                            'Too many login attempts. Please try again later.',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else if (ex.code
                                        case 'network-request-failed') {
                                      snackBar(
                                        context,
                                        message: 'network request failed.',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else {
                                      snackBar(
                                        context,
                                        message:
                                            'Something is Wrong may your Email or Password are invalid.',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    }
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                              text: 'Login',
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              paddingVertical: 14,
                              paddingHorizontal: 0,
                              borderRadius: 10,
                              borderWidth: 2,
                              borderColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: kSecondColor),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kFourthColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
