import 'package:flutter/material.dart';

void main() {
  runApp(Start_1());
}

class Start_1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 28, 20, 151),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 109), // Position "Your Name" text
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Your name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PoetsenOne',
                  ),
                ),
              ),
              SizedBox(height: 100), // Space before TextField
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'poetsenOne',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      color: Color(0xFF6E7191),
                      fontSize: 32,
                      fontFamily: 'ponnala',
                    ),
                    border: InputBorder.none, // Remove underline
                  ),
                ),
              ),
              Expanded(child: SizedBox()), // Pushes button to the bottom
              SizedBox(
                width: 275, // Set button width
                height: 64, // Set button height
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint("Continue Button Pressed");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors
                              .white; // Button turns white when pressed
                        }
                        return Color(0xFF6E7191); // Default color of button
                      },
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'poetsenOne',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40), // Space from bottom
            ],
          ),
        ),
      ),
    );
  }
}
