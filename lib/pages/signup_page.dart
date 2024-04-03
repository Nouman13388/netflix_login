import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netflix_login/components/my_button.dart';
import 'package:netflix_login/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool agreeToTerms = false;

  Future<void> _createAccount() async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      final String confirmPassword = confirmPasswordController.text.trim();

      // Validate email and password
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        // Show error message
        return;
      }

      if (password != confirmPassword) {
        // Show error message
        return;
      }

      // Create user account using Firebase Authentication
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Additional functionalities after successful account creation
      // For example, you can save user data to a database or perform other tasks
      // For simplicity, let's print the user data
      print('User created: ${userCredential.user}');

      // Account created successfully, navigate to login page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (error) {
      // Handle any errors that occur during account creation
      print('Error creating user: $error');
      // Show error message
      String errorMessage = 'An error occurred, please try again.';
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'empty-email':
            errorMessage = 'The email address is empty.';
            break;
          case 'empty-password':
            errorMessage = 'The password is empty.';
            break;
          default:
            errorMessage = 'An error occurred, please try again later.';
        }
      }
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'lib/images/Netflix-Logo.png',
          width: 200,
          height: 120,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('lib/images/background.jpg', fit: BoxFit.cover),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.srcOver,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.only(
                left: 50,
                right: 50,
                top: 70,
                bottom: 60,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                  const SizedBox(height: 35),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Agree to Terms and Conditions',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: 'Create',
                    onTap: _createAccount,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Sign in',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const LoginPage()));
                            },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text:
                          'This page is protected by Google reCAPTCHA to\nensure you\'re not a bot. ',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: 'Learn more',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Add your action here
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
