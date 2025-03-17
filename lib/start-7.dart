import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NameYourAIFriendScreen(),
    );
  }
}

class NameYourAIFriendScreen extends StatefulWidget {
  @override
  _NameYourAIFriendScreenState createState() => _NameYourAIFriendScreenState();
}

class _NameYourAIFriendScreenState extends State<NameYourAIFriendScreen> {
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 20, 151),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {},
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Name your AI friend",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: _nameController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter name",
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        Spacer(),
                        Center(
                          child: ElevatedButton(
                            onPressed:
                                _nameController.text.isNotEmpty ? () {} : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _nameController.text.isNotEmpty
                                  ? Colors.white24
                                  : Colors.white10,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12),
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
