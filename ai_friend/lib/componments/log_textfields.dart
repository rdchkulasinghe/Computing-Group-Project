import 'package:flutter/material.dart';

class LoginTextfield extends StatelessWidget {
  final dynamic controllarFor; // what is dynamic , what happnes withouth it?
  final String hintText;
  final bool obscureText;
  final String textBoxName;
  

  const LoginTextfield({
    super.key,
    required this.controllarFor,
    required this.hintText,
    required this.obscureText,
    required this.textBoxName,
  });

  @override  
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Column(  
         crossAxisAlignment: CrossAxisAlignment.start,      
        children: [
          // text field name
          Text(
             textBoxName,
             style: TextStyle(
             color: Colors.white70,
             fontSize: 18.0,
             fontWeight: FontWeight.w500,
            ),
            ),
          // text feild
          TextField(
              style: const TextStyle(color: Color.fromARGB(255, 1, 0, 0), fontSize: 20),
              controller: controllarFor,
              obscureText: obscureText,
              decoration: InputDecoration(
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(67, 255, 255, 255), width: 3.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF303841),),
                  borderRadius: BorderRadius.circular(12.0),                  
                ),

                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 135, 133, 133),
                  fontSize: 16,

                )
              ),
              ),
        ],
      ),
    );
  }
}   // login page text feilds for email and password
