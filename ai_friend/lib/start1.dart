import 'package:ai_friend/start2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EnterName());
}

class EnterName extends StatelessWidget {
  const EnterName({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1C1A3B),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 109),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Your name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PoetsenOne', // Ensure this is correct
                  ),
                ),
              ),
              const SizedBox(height: 100),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'PoetsenOne', // Ensure this is correct
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      color: Color(0xFF6E7191),
                      fontSize: 32,
                      fontFamily: 'PoetsenOne', // Ensure this is correct
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(), // Pushes button to the bottom
              SizedBox(
                width: 275,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    print("next page");
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SelectAge()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white;
                        }
                        return const Color(0xFF6E7191);
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
