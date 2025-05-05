import 'package:ai_friend/ai_gender.dart';
import 'package:flutter/material.dart';

class MovieTypePage extends StatefulWidget {
  final String name;
  final int age;
  final String pronouns;
  final String freeTime;

  const MovieTypePage({
    super.key,
    required this.name,
    required this.age,
    required this.pronouns,
    required this.freeTime,
  });

  @override
  State<MovieTypePage> createState() => _MovieTypePageState();
}

class _MovieTypePageState extends State<MovieTypePage> {
  int? selectedIndex;
  bool isButtonEnabled = false;

  final List<Map<String, String>> movieOptions = [
    {"text": "Action/Adventure", "image": "assets/action.jpg"},
    {"text": "Drama/Romance", "image": "assets/drama.jpg"},
    {"text": "Comedy", "image": "assets/comedy.jpg"},
    {"text": "Science Fiction/Fantasy", "image": "assets/scifi.jpg"},
    {"text": "Horror/Thriller", "image": "assets/horror.jpg"},
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
                'What is your favorite\nmovie type?',
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
                itemCount: movieOptions.length,
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
                        movieOptions[index]["text"]!,
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
                            builder: (context) => GenderSelectionPage(
                              name: widget.name,
                              age: widget.age,
                              pronouns: widget.pronouns,
                              freeTime: widget.freeTime,
                              movieType: movieOptions[selectedIndex!]["text"]!,
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
