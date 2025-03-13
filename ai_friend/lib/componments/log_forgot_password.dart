import 'package:flutter/material.dart';

class LoginForgotPassword extends StatelessWidget {

  final Function()? onTapp;
  const LoginForgotPassword({super.key,required this.onTapp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 40.0),
      child: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
               onTap: () {
              // Handle forgot password tap here.
              // or
               showDialog(context: context, builder: (context) => AlertDialog(title: Text("Forgot Password Tapped"), content: Text("Implement your logic here")));
        },
              //forgot password
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Color.fromARGB(255, 95, 95, 95),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  decorationColor: Color.fromARGB(255, 95, 95, 95), 
                  decorationStyle: TextDecorationStyle
                      .solid, 
                  decorationThickness: 2.0,
                ),
              ),
            ),
          ]),
    );
  }
}

