import 'package:flutter/material.dart';

class Log extends StatelessWidget {
  const Log({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromARGB(255, 13, 21, 31) ,
      // appbar here
       appBar: AppBar(
        
        backgroundColor: Color.fromARGB(211, 7, 82, 73),
        title: const Text(
            'Login',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 25,
          ),
        ),
        automaticallyImplyLeading: false, // The title of the app bar
      ),
      body: SafeArea(
        child:Center(
          child: 
Text("you are now in forgotpass page"),
        )
      ),
    );
  }
}