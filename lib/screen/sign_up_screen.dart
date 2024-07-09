import 'package:chat_app/screen/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../helper/show_snack_bar.dart';
import '../helper/signup_firebase.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/elevated_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          iconTheme: const IconThemeData(color: kSecondColor),
          title: const Text(
            'Sign Up',
            style: TextStyle(color: kSecondColor),
          ),
        ),
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Create an Account',
                          style: TextStyle(
                            color: kSecondColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // name Text field
                      CustomTextField(
                        icon: FontAwesomeIcons.user,
                        controller: _nameController,
                        labelText: 'Full Name',
                        color: kSecondColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // email Text field
                      CustomTextField(
                        icon: FontAwesomeIcons.envelope,
                        controller: _emailController,
                        labelText: 'Email',
                        color: kSecondColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Email should contains @';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // phone Text field
                      CustomTextField(
                        icon: FontAwesomeIcons.phone,
                        controller: _phoneController,
                        labelText: 'Phone Number',
                        color: kSecondColor,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // password Text field
                      CustomTextField(
                        icon: FontAwesomeIcons.lock,
                        controller: _passwordController,
                        labelText: 'Password',
                        color: kSecondColor,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // sign up button
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
                                    String name = _nameController.text;
                                    String phoneNumber = _phoneController.text;

                                    UserCredential userCred =
                                        await userRegister(email, password);

                                    await userCred.user!
                                        .updateDisplayName(name);

                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    snackBar(
                                      context,
                                      message: 'Successful registration!',
                                      colorOfMessage: kSecondColor,
                                      colorOfText: kPrimaryColor,
                                    );

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChatPage(email: email),
                                        ));
                                  } on FirebaseAuthException catch (ex) {
                                    await Future.delayed(
                                        const Duration(seconds: 2));

                                    if (ex.code == 'email-already-in-use') {
                                      snackBar(
                                        context,
                                        message: 'Email Already Exist',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else if (ex.code == 'weak-password') {
                                      snackBar(
                                        context,
                                        message: 'Weak Password',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else if (ex.code == 'invalid-email') {
                                      snackBar(
                                        context,
                                        message: 'Invalid Email',
                                        colorOfMessage: kSecondColor,
                                        colorOfText: kPrimaryColor,
                                      );
                                    } else {
                                      snackBar(
                                        context,
                                        message:
                                            'An error occurred. Please try again.',
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
                              text: 'Sign Up',
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
