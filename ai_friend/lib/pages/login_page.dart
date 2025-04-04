/*----/*----This works backend but firebase authentication should have details /user should have signed in earlier---*/---*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../componments/forgot_pass.dart';
import '../componments/log_textfields.dart';
import '../componments/log_button.dart';



class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _validateInput() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || !isValidEmail(email)) {
      return false;
    }

    if (password.isEmpty || password.length < 8 || password.length > 20) {
      return false;
    }
    return true;
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
    return emailRegExp.hasMatch(email);
  }

  Future<void> signUserIn(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      debugPrint("Message:---Sign in--> next page");
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'User account has been disabled';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 13, 21, 31),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    LoginTextfield(
                      controllarFor: emailController,
                      hintText: 'Enter Your Email',
                      obscureText: false,
                      textBoxName: 'Email:',
                    ),
                    SizedBox(height: 5),
                    LoginTextfield(
                      controllarFor: passwordController,
                      hintText: 'Enter Your Password',
                      obscureText: true,
                      textBoxName: 'Password:',
                    ),
                    SizedBox(height: 13),
                    LoginForgotPassword2 (onTapp: (){}),
                    SizedBox(height: 50),
                    SigninBtn(
                      onTap: () async {
                        if (_validateInput()) {
                          signUserIn(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid email or password'),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}