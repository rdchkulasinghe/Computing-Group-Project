import 'package:flutter/material.dart';

void main() {
  runApp(const Start1());
}

class Start1 extends StatelessWidget {
  const Start1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1C1A3B),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 109), // Space before text
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'How old are you?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PoetsenOne',
                  ),
                ),
              ),
              const SizedBox(height: 50), // Space before additional text
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'We need this information to make your experience more relevant and safe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'PoetsenOne',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60), // Space before input field
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'PoetsenOne',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your age',
                    hintStyle: TextStyle(
                      color: Color(0xFF6E7191),
                      fontSize: 32,
                      fontFamily: 'PoetsenOne',
                    ),
                    border: InputBorder.none, // Remove underline
                  ),
                ),
              ),
              const Expanded(child: SizedBox()), // Pushes button to bottom
              SizedBox(
                width: 275, // Button width
                height: 64, // Button height
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
                        return const Color(0xFF6E7191); // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'PoetsenOne',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Space from bottom
            ],
          ),
        ),
      ),
    );
  }
}
