import 'package:ai_friend/movie_type.dart';
import 'package:flutter/material.dart';

class FreeTimePage extends StatefulWidget {
  final String name;
  final int age;
  final String pronouns;

  const FreeTimePage({
    super.key,
    required this.name,
    required this.age,
    required this.pronouns,
  });

  @override
  State<FreeTimePage> createState() => _FreeTimePageState();
}

class _FreeTimePageState extends State<FreeTimePage> {
  int? selectedIndex;
  bool isButtonEnabled = false;

  final List<Map<String, String>> freeTimeOptions = [
    {"text": "Enjoying being alone", "image": "assets/images/reading.png"},
    {"text": "With friends and family", "image": "assets/images/friends.png"},
    {"text": "Engaging in hobbies", "image": "assets/images/watercolor.jpg"},
    {"text": "Partying/socializing", "image": "assets/images/men.jpg"},
    {"text": "Staying productive", "image": "assets/images/working.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1A3B), // Consistent dark background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'How do you usually\nspend your free time?',
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                itemCount: freeTimeOptions.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.blue : const Color(0xFF6E7191),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                          isButtonEnabled = true;
                        });
                      },
                      child: Text(
                        freeTimeOptions[index]["text"]!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'PoetsenOne',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 275,
              height: 64,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        // Navigate to next screen with all collected data
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MovieTypePage(
                              name: widget.name,
                              age: widget.age,
                              pronouns: widget.pronouns,
                              freeTime: freeTimeOptions[selectedIndex!]
                                  ["text"]!,
                            ),
                          ),
                        );
                      }
                    : null,
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
}
