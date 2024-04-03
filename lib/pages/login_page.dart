import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:netflix_login/components/my_button.dart';
import 'package:netflix_login/pages/home_page.dart';
import 'package:netflix_login/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = true;
  bool _isLoading = false; // Track loading state

  Future<bool> _authenticateUser(BuildContext context) async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      // Authentication successful
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      // Handle specific authentication errors
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-not-found':
          errorMessage = 'User not found.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password.';
          break;
        // Handle other errors as needed
        default:
          errorMessage = 'Authentication failed: ${e.message}';
          break;
      }

      // Show error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );

      // Return false to indicate authentication failure
      return false;
    } catch (error) {
      // General error handling
      print('Authentication failed: $error');
      // Show general error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication failed: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
      // Return false to indicate authentication failure
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          MediaQuery.of(context).size.width > 400
              ? 'lib/images/Netflix-Logo.png'
              : 'lib/images/N.png', // Change logo based on screen size
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
              width: MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 400 ? 50 : 20,
                vertical: MediaQuery.of(context).size.width > 400 ? 70 : 20,
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
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                  const SizedBox(height: 35),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: 'Username',
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
                  MyButton(
                    text: 'Sign In',
                    onTap: () async {
                      final isAuthenticated = await _authenticateUser(context);

                      if (isAuthenticated) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomePage(
                              user: 'user',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            rememberMe = !rememberMe;
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Need help?',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text.rich(
                    TextSpan(
                      text: 'New to Netflix? ',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up now.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const SignupPage()));
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _signInWithGoogle();
                        },
                        child: Image.asset(
                          'lib/images/google.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: _signInWithFacebook,
                        child: Icon(
                          Icons.facebook,
                          color: Colors.blue[900],
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: _signInAsGuest,
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
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

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            '253389045243-o9e6difsv11l66pogopk339vlth43r0d.apps.googleusercontent.com',
      );

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigate to the home screen after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(
                    user: 'user',
                  )),
        );
      }
    } catch (error) {
      // Handle Google sign-in errors
      String errorMessage = 'An error occurred. Please try again later.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );

      if (kDebugMode) {
        print("Error signing in with Google: $error");
      }
    } finally {
      // Set loading state to false
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithFacebook() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Log in with Facebook
      final result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        // Sign in to Firebase with the Facebook credential
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigate to the home screen after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(
              user: 'user',
            ),
          ),
        );
      } else if (result.status == LoginStatus.cancelled) {
        // Handle login cancellation
        print('Facebook login cancelled');
      } else {
        // Handle login failure
        print('Facebook login failed');
      }
    } catch (error) {
      // Handle Facebook sign-in errors
      String errorMessage = 'An error occurred. Please try again later.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );

      if (kDebugMode) {
        print("Error signing in with Facebook: $error");
      }
    } finally {
      // Set loading state to false
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInAsGuest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInAnonymously();

      // Navigate to the home screen after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(
            user: 'guest',
          ),
        ),
      );
    } catch (error) {
      // Handle guest sign-in errors
      String errorMessage = 'An error occurred. Please try again later.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );

      if (kDebugMode) {
        print("Error signing in as guest: $error");
      }
    } finally {
      // Set loading state to false
      setState(() {
        _isLoading = false;
      });
    }
  }
}
