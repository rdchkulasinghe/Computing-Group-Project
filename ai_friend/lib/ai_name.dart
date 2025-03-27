import 'package:ai_friend/chatscreen.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_friend/backend/collect_data.dart';

class NameAIFriendPage extends StatefulWidget {
  final String name;
  final int age;
  final String pronouns;
  final String freeTime;
  final String movieType;
  final String aiGender;

  const NameAIFriendPage({
    super.key,
    required this.name,
    required this.age,
    required this.pronouns,
    required this.freeTime,
    required this.movieType,
    required this.aiGender,
  });

  @override
  State<NameAIFriendPage> createState() => _NameAIFriendPageState();
}

class _NameAIFriendPageState extends State<NameAIFriendPage> {
  final TextEditingController _nameController = TextEditingController();
  bool isButtonEnabled = false;

  Future<bool> _sendUserDataToFirebase(UserData userData) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('users')
          .add(userData.toJson()); // Auto-generates document ID
      return true;
    } catch (e) {
      print('Firestore Error: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isButtonEnabled = _nameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1A3B),
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
            const Text(
              'Name your AI friend',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'PoetsenOne',
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'PoetsenOne',
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter name',
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
                    ? () async {
                        final userData = UserData(
                          name: widget.name,
                          age: widget.age,
                          pronouns: widget.pronouns,
                          movieType: widget.movieType,
                          freeTime: widget.freeTime,
                          aiName: _nameController.text.trim(),
                          aiGender: widget.aiGender,
                        );

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        final success = await _sendUserDataToFirebase(userData);
                        Navigator.pop(context); // Close loading dialog

                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => ChatScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Failed to save data. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
