import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF141233),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: MediaQuery.of(context).size.width * 0.25,
              child: Image.asset(
                'assets/images/hhhhj.png',
                width: 150,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Image.asset(
                  'assets/images/Group.png',
                  width: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
