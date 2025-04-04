/*----This works with firbase----*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForgotPassword2 extends StatelessWidget {
  final Function()? onTapp;
  const LoginForgotPassword2({super.key, required this.onTapp});

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter your email address to reset your password.'),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset Password'),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailController.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent.'),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  String errorMessage = 'An error occurred. Please try again.';
                  if (e.code == 'user-not-found') {
                    errorMessage = 'No user found for that email.';
                  } else if (e.code == 'invalid-email') {
                    errorMessage = 'The email address is badly formatted.';
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _showForgotPasswordDialog(context); // Call the dialog function
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color:Color.fromARGB(255, 158, 134, 134),
                fontWeight: FontWeight.w500,
                fontSize: 18,
                decoration: TextDecoration.underline,
                decorationColor: Color.fromARGB(255, 158, 134, 134),
                decorationStyle: TextDecorationStyle.solid,
                decorationThickness: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}