import 'package:ai_friend/movie_type.dart';
import 'package:flutter/material.dart';

class FreeTimePage extends StatefulWidget {
  final String name;
  final int age;
  final String pronouns;
  final String userId;

  const FreeTimePage({
    super.key,
    required this.name,
    required this.age,
    required this.pronouns,
    required this.userId,
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
      backgroundColor: const Color.fromARGB(221, 28, 7, 188),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'How do you usually\nspend your free time?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'PoetsenOne',
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: freeTimeOptions.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.blue.shade400
                            : const Color(0xFF6E7191),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                          isButtonEnabled = true;
                        });
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            freeTimeOptions[index]["image"]!,
                            width: 36,
                            height: 36,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            freeTimeOptions[index]["text"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'PoetsenOne',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 250,
                height: 55,
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MovieTypePage(
                                name: widget.name,
                                userId: widget.userId,
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
                    backgroundColor: isButtonEnabled
                        ? Colors.blue.shade400
                        : Colors.grey.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'PoetsenOne',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
