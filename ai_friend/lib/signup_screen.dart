import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Initial color for the login link
  Color loginLinkColor = Colors.white;

  // Initial color for the create account button
  Color createAccountButtonColor = const Color.fromARGB(255, 87, 105, 143);

  // Controller for the email TextField
  final TextEditingController _emailController = TextEditingController();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Email validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 6, 3, 56),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      WidgetSpan(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                loginLinkColor =
                                    const Color.fromARGB(255, 24, 169, 195);
                              });

                              Future.delayed(const Duration(seconds: 1), () {
                                setState(() {
                                  loginLinkColor = Colors.white;
                                });
                              });
                            },
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: loginLinkColor,
                                color: loginLinkColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // Continue with Facebook Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(350, 60),
                  ),
                  icon: Image.asset(
                    'assets/images/fb.png', // Path to your Facebook icon
                    width: 30,
                    height: 30,
                  ),
                  label: const Text(
                    'Continue with Facebook',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(height: 10),

                // Continue with Google Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(350, 60),
                  ),
                  icon: Image.asset(
                    'assets/images/google.png', // Path to your Google icon
                    width: 28,
                    height: 28,
                  ),
                  label: const Text(
                    'Continue with Google',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {},
                ),

                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                        height: 20,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your email address to create the account',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 10),

                // Email TextFormField with Validation
                SizedBox(
                  width: 550, // Set the desired width here
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Your email',
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      errorStyle: const TextStyle(color: Colors.red), // Error text color
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail, // Add validation
                  ),
                ),

                const SizedBox(height: 30),

                // Create an Account Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: createAccountButtonColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(300, 60),
                  ),
                  onPressed: () {
                    // Validate the form
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, proceed
                      // ignore: avoid_print
                      print('Email is valid: ${_emailController.text}');
                      setState(() {
                        createAccountButtonColor =
                            const Color.fromARGB(255, 40, 144, 255);
                      });

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          createAccountButtonColor =
                              const Color.fromARGB(255, 62, 119, 241);
                        });
                      });
                    }
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Color.fromARGB(255, 1, 15, 55),
                    ),
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