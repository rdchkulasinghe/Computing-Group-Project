import 'package:flutter/material.dart';
import '../componments/log_textfields.dart';
import '../componments/log_button.dart';
import '../componments/log_forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _validateInput() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || !EmailValidator.validate(email)) {
      return false;
    }

    if (password.isEmpty || password.length < 8 || password.length > 20) {
      return false;
    }
    return true;
  }

  Future<void> signUserIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      debugPrint("Message:---Sign in--> next page");
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void forgotPass(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: const Text("Enter your email to receive a password reset link."),
        actions: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: emailController.text,
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Password reset link sent to your email.')),
                );
              } on FirebaseAuthException catch (e) {
                String errorMessage = 'An error occurred.';
                errorMessage = e.message ?? errorMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $errorMessage')),
                );
              }
            },
            child: const Text('Send'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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
                    LoginForgotPassword(onTapp: () => forgotPass(context)),
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