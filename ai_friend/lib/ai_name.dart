import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_friend/backend/collect_data.dart';
import 'package:ai_friend/chatscreen.dart';

class NameAIFriendPage extends StatefulWidget {
  final String userId;
  final String name;
  final int age;
  final String pronouns;
  final String freeTime;
  final String movieType;
  final String aiGender;

  const NameAIFriendPage({
    super.key,
    required this.userId,
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
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _nameController.text.trim().isNotEmpty;
    });
  }

  Future<void> _completeProfile() async {
    if (!_isButtonEnabled || _isLoading) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final aiName = _nameController.text.trim();

      // Create complete user data
      final userData = UserData(
        userId: widget.userId,
        name: widget.name,
        age: widget.age,
        pronouns: widget.pronouns,
        movieType: widget.movieType,
        freeTime: widget.freeTime,
        aiName: aiName,
        aiGender: widget.aiGender,
        bio: '', // Initialize empty bio
        interests: [], // Initialize empty interests
        profileComplete: true,
        createdAt: Timestamp.now(),
      );

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update(userData.toFirestore());

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            userData: userData,
            updateUserData: _updateUserData, // Pass the update function
          ),
        ),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Database error: ${e.message}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Added this method to handle user data updates
  Future<void> _updateUserData(UserData newData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newData.userId)
          .update(newData.toFirestore());
    } catch (e) {
      debugPrint("Error updating user data: $e");
      throw Exception("Failed to update user data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 28, 7, 188),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Name your AI friend',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PoetsenOne',
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    enabled: !_isLoading,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: SizedBox(
                    width: 275,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled && !_isLoading
                          ? _completeProfile
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonEnabled
                            ? const Color(0xFF6E7191)
                            : Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'PoetsenOne',
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
