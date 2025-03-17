import 'package:flutter/material.dart';

void main() {
  runApp(const PronounSelectionApp());
}

class PronounSelectionApp extends StatelessWidget {
  const PronounSelectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PronounSelectionScreen(),
    );
  }
}

class PronounSelectionScreen extends StatefulWidget {
  const PronounSelectionScreen({super.key});

  @override
  _PronounSelectionScreenState createState() => _PronounSelectionScreenState();
}

class _PronounSelectionScreenState extends State<PronounSelectionScreen> {
  String? selectedPronoun;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 20, 151),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 109),
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
            const SizedBox(height: 50),
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
            const SizedBox(height: 60),
            _buildPronounButton("She / Her"),
            _buildPronounButton("He / Him"),
            _buildPronounButton("They / Them"),
            const Expanded(child: SizedBox()),
            SizedBox(
              width: 275,
              height: 64,
              child: ElevatedButton(
                onPressed: selectedPronoun != null ? _onContinuePressed : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.white;
                      }
                      return const Color(0xFF6E7191);
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
          backgroundColor:
              selectedPronoun == pronoun ? Colors.blue : Colors.grey[200],
          foregroundColor:
              selectedPronoun == pronoun ? Colors.white : Colors.black,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          setState(() {
            selectedPronoun = pronoun;
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

  void _onContinuePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You selected: $selectedPronoun"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
