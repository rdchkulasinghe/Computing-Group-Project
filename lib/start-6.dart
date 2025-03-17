import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GenderSelectionScreen(),
    );
  }
}

class GenderSelectionScreen extends StatefulWidget {
  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 20, 151),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {},
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "What gender do you want your Nancy to be?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
            _buildGenderButton("Female"),
            SizedBox(height: 16),
            _buildGenderButton("Male"),
            SizedBox(height: 16),
            _buildGenderButton("Non-binary"),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: selectedGender != null ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70),
          borderRadius: BorderRadius.circular(30),
          color: selectedGender == gender ? Colors.white24 : Colors.transparent,
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
