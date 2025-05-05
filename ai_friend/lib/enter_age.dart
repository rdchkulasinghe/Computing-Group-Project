import 'package:ai_friend/pronouns.dart';
import 'package:flutter/material.dart';

//void main() {
//  runApp(const MaterialApp(
//    home: EnterAgePage(name: 'user'), // Provide a default name for testing
//  ));
//}

class EnterAgePage extends StatefulWidget {
  final String name;
  final String userId;
  const EnterAgePage({
    super.key,
    required this.name,
    required this.userId,
  });

  @override
  State<EnterAgePage> createState() => _EnterAgePageState();
}

class _EnterAgePageState extends State<EnterAgePage> {
  final TextEditingController ageController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    ageController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isButtonEnabled = ageController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    ageController.dispose();
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
            Text(
              //  the passed name
              'Hello, ${widget.name}!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'PoetsenOne',
              ),
            ),
            const SizedBox(height: 50),
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'We need this information to make your experience more relevant and safe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'PoetsenOne',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: ageController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'PoetsenOne',
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter your age',
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
                            builder: (context) => PronounSelectionPage(
                              name: widget.name,
                              userId: widget.userId,
                              age: int.parse(ageController.text),
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
