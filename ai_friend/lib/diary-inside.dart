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
      home: const TextDisplayScreen(),
    );
  }
}

class TextDisplayScreen extends StatelessWidget {
  const TextDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/background.jpg', // Make sure the path is correct
            fit: BoxFit.cover,
          ),
          // Dark overlay for readability
          Container(
            color: Colors.black.withAlpha(128),
          ),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '3rd March 2024',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'I have big plan for this weekend',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'vbd sd bs d hjhjk vhjkuihu bhsdbd sds nbsjdbnk hjblihug.\n\n'
                    'nsbdjkd dbsdjkhksd jjnkjjhn bnskjsd sms bjkdsk fcgyhs bgdhwdwv gewv wfwgwyufw whgywww bwywynyhvw hywh yhwwwww yuuwhfwuf jni ojikw iuwb iuknjub8eij egw fwey.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
