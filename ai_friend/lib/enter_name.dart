import 'package:ai_friend/enter_age.dart';
import 'package:flutter/material.dart';

class EnterNamePage extends StatefulWidget {
  final String userId;
  const EnterNamePage({super.key, required this.userId});

  @override
  State<EnterNamePage> createState() => _EnterNamePageState();
}

class _EnterNamePageState extends State<EnterNamePage> {
  final TextEditingController nameController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isButtonEnabled = nameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(221, 28, 7, 188),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Your name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PoetsenOne',
                ),
              ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'PoetsenOne',
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(
                    color: Color(0xFF6E7191),
                    fontSize: 28,
                    fontFamily: 'PoetsenOne',
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 275,
              height: 64,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EnterAgePage(
                              userId: widget.userId,
                              name: nameController.text.trim(),
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
