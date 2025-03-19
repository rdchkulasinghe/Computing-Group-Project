import 'package:flutter/material.dart';
import '../login_componments/log_textfields.dart';
import '../login_componments/log_button.dart';
import '../login_componments/log_forgot_password.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth and rthen errors will be fixed
//

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Firebase Authentication Instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Validation Function -------
  bool _validateInput() {
    String email = emailController.text; //  email text fields
    String password = passwordController.text; // passowrd
    // validation
    if (email.isEmpty || !isValidEmail(email)) {
      return false;
    }

    if (password.isEmpty || password.length < 8 || password.length > 20) {
      return false;
    }
    return true;
  }

// Email Validation Fun (later use a package like email_validator)
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"); // Regular expression
    return emailRegExp.hasMatch(email);
  }

  // sing in user method
  Future<void> signUserIn(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // User signed in successfully
      debugPrint("Message:---Sign in--> next page");
      // Navigate to the next page or perform other actions
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }else if (e.code == 'user-disabled'){
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

  void forgotPass() {
    // content
  }

  //-------------------------------UI start from here--------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 13, 21, 31),
      // appbar here...
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              // Scroll only the content within the Center
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
                    ), // Email
                    SizedBox(height: 5),
                    LoginTextfield(
                      controllarFor: passwordController,
                      hintText: 'Enter Your Password',
                      obscureText: true,
                      textBoxName: 'Password:',
                    ), // password
                    SizedBox(height: 13),
                    LoginForgotPassword(onTapp: forgotPass),
                    SizedBox(height: 50),
                    SigninBtn(
                      onTap: () async {
                        // Perform Validation
                        if (_validateInput()) {
                          signUserIn(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid email or password'),
                            ), // Error Message
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