import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FreeTimeScreen(),
    );
  }
}

class FreeTimeScreen extends StatefulWidget {
  const FreeTimeScreen({super.key});

  @override
  State<FreeTimeScreen> createState() => _FreeTimeScreen();
}

class _FreeTimeScreen extends State<FreeTimeScreen> {
  int? selectedIndex;

  final List<Map<String, String>> movieOptions = [
    {"text": "Enjoying being alone", "image": "assets/images/reading.png"},
    {"text": "With friends and family", "image": "assets/images/friends.png"},
    {"text": "Engaging in hobbies", "image": "assets/images/watercolor.jpg"},
    {"text": "Partying/ socializing", "image": "assets/images/men.jpg"},
    {"text": "Staying productive", "image": "assets/images/working.jpg"},
  ];

  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "How do you usually spend your free time?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: movieOptions.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => onSelect(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white),
                        image: DecorationImage(
                          image: AssetImage(movieOptions[index]["image"]!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(isSelected ? 0.4 : 0.7),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          movieOptions[index]["text"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: selectedIndex != null ? () {} : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: selectedIndex != null ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
