import 'package:ai_friend/free_time.dart';
import 'package:flutter/material.dart';

class PronounSelectionPage extends StatefulWidget {
  final String name;
  //final String email;
  final String userId;
  final int age;

  const PronounSelectionPage({
    super.key,
    required this.name,
    required this.userId,
    required this.age,
    // required this.email,
  });

  @override
  State<PronounSelectionPage> createState() => _PronounSelectionPageState();
}

class _PronounSelectionPageState extends State<PronounSelectionPage> {
  String? selectedPronoun;
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 28, 7, 188),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100), // Space from top
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Select Your Pronouns',
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
            const SizedBox(height: 60), // Space before buttons
            _buildPronounButton("She / Her"),
            _buildPronounButton("He / Him"),
            _buildPronounButton("They / Them"),
            const Spacer(), // Push button to bottom
            SizedBox(
              width: 275, // Button width
              height: 64, // Button height
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FreeTimePage(
                              name: widget.name,
                              userId: widget.userId,
                              age: widget.age,
                              pronouns: selectedPronoun!,
                            ),
                          ),
                        );
                      }
                    : null, // Disabled if no pronoun selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6E7191),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'PoetsenOne',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPronounButton(String pronoun) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedPronoun == pronoun
              ? Colors.blue
              : const Color(0xFF6E7191),
          foregroundColor:
              selectedPronoun == pronoun ? Colors.white : Colors.black,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          setState(() {
            selectedPronoun = pronoun;
            isButtonEnabled = true;
          });
        },
        child: Text(
          pronoun,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'PoetsenOne',
          ),
        ),
      ),
    );
  }
}
