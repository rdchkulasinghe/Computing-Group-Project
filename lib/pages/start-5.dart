import 'package:flutter/material.dart';

class MovieTypeScreen extends StatefulWidget {
  @override
  _MovieTypeScreenState createState() => _MovieTypeScreenState();
}

class _MovieTypeScreenState extends State<MovieTypeScreen> {
  int? selectedIndex;

  final List<Map<String, String>> movieOptions = [
    {"text": "Action/ Adventure", "image": "assets/action.jpg"},
    {"text": "Drama/ Romance", "image": "assets/drama.jpg"},
    {"text": "Comedy", "image": "assets/comedy.jpg"},
    {"text": "Science fiction/ Fantasy", "image": "assets/scifi.jpg"},
    {"text": "Horror/ Thriller", "image": "assets/horror.jpg"},
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
              child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "What is your favorite movie type?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: movieOptions.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => onSelect(index),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                          style: TextStyle(
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
            SizedBox(height: 20),
            GestureDetector(
              onTap: selectedIndex != null ? () {} : null,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: selectedIndex != null ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
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
