import 'package:ai_friend/ai_name.dart';
import 'package:flutter/material.dart';

class GenderSelectionPage extends StatefulWidget {
  final String name;
  final int age;
  final String pronouns;
  final String freeTime;
  final String movieType;
  final String userId;

  const GenderSelectionPage({
    super.key,
    required this.name,
    required this.age,
    required this.pronouns,
    required this.freeTime,
    required this.movieType,
    required this.userId,
  });

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  String? selectedGender;
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 28, 7, 188),
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
                'What gender do you want\nyour AI friend to be?',
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
            _buildGenderButton("Female"),
            const SizedBox(height: 16),
            _buildGenderButton("Male"),
            const SizedBox(height: 16),
            _buildGenderButton("Non-binary"),
            const Spacer(),
            SizedBox(
              width: 275,
              height: 64,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        // Navigate to next screen with all collected data
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NameAIFriendPage(
                              name: widget.name,
                              userId: widget.userId,
                              age: widget.age,
                              pronouns: widget.pronouns,
                              freeTime: widget.freeTime,
                              movieType: widget.movieType,
                              aiGender: selectedGender!,
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

  Widget _buildGenderButton(String gender) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedGender == gender ? Colors.blue : const Color(0xFF6E7191),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          setState(() {
            selectedGender = gender;
            isButtonEnabled = true;
          });
        },
        child: Text(
          gender,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'PoetsenOne',
          ),
        ),
      ),
    );
  }
}
