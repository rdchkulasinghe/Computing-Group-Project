import 'package:ai_friend/backend/collect_data.dart';
import 'package:ai_friend/diary.dart';
import 'package:ai_friend/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_friend/backend/chat_service.dart';
import 'package:ai_friend/profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final UserData userData;
  final Function(UserData) updateUserData;

  const ChatScreen({
    super.key,
    required this.userData,
    required this.updateUserData,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Color gradientStart = Color.fromARGB(221, 20, 6, 121);
  static const Color gradientEnd = Color.fromARGB(255, 28, 20, 151);
  static const Color buttonColor = Colors.black;
  static const Color textColor = Colors.white;

  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    debugPrint('User Data: ${widget.userData.toJson()}');
    _loadChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Chat with ${widget.userData.aiName ?? 'AI Friend'}',
          style: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userData: widget.userData,
                        onProfileSaved: (updatedUser) {
                          // Handle profile updates
                          widget.updateUserData(updatedUser);
                        },
                      ),
                    ),
                  );
                  break;
                case 'diary':
                  _navigateToDiary();
                  break;
                case 'settings':
                  _showSettings(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'diary',
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Diary'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
            ],
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(221, 20, 6, 121),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final bool isUser = msg['sender'] == 'user';

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.teal : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft:
                              isUser ? const Radius.circular(12) : Radius.zero,
                          bottomRight:
                              isUser ? Radius.zero : const Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg['message'],
                            style: TextStyle(
                                color: isUser ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              msg['timestamp'] ?? '',
                              style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      isUser ? Colors.white70 : Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() => Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Say something...',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.teal),
              onPressed: _sendMessage,
            ),
          ],
        ),
      );

  Future<void> _sendMessage() async {
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({
        "sender": "user",
        "message": userMessage,
        "timestamp": TimeOfDay.now().format(context),
      });
    });

    _messageController.clear();

    try {
      final chatService = ChatService();
      final aiResponse = await chatService.sendMessage(
        userMessage,
        widget.userData.name,
        widget.userData.aiName,
        widget.userData.movieType,
        widget.userData.pronouns,
        widget.userData.userId, // <-- Added userId here
      );

      setState(() {
        messages.add({
          "sender": "ai",
          "message": aiResponse,
          "timestamp": TimeOfDay.now().format(context),
        });
      });

      await _saveChatToFirestore(userMessage, aiResponse);
    } catch (e) {
      debugPrint("Chat error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _saveChatToFirestore(String userMsg, String aiMsg) async {
    final userId = widget.userData.userId;
    final timestamp = Timestamp.now();

    await FirebaseFirestore.instance.collection('chats').add({
      'userId': userId,
      'message': userMsg,
      'response': aiMsg,
      'time': timestamp,
    });
  }

  Future<void> _loadChatHistory() async {
    final userId = widget.userData.userId;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('userId', isEqualTo: userId)
          .orderBy('time')
          .get();

      final List<Map<String, dynamic>> loadedMessages = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = _formatTimestamp(data['time']);

        loadedMessages.add({
          "sender": "user",
          "message": data['message'],
          "timestamp": timestamp,
        });

        loadedMessages.add({
          "sender": "ai",
          "message": data['response'],
          "timestamp": timestamp,
        });
      }

      setState(() {
        messages = loadedMessages;
      });
    } catch (e) {
      debugPrint("Failed to load chat history: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load chat history.")),
      );
    }
  }

  void _navigateToDiary() {
    if (widget.userData.userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User ID is missing!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryScreen(userData: widget.userData),
      ),
    );
  }

  void navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          userData: widget.userData,
          onProfileSaved: (updatedUser) {
            // Handle the updated user data
            widget.updateUserData(updatedUser);
          },
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${widget.userData.aiName}'s Settings"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('AI Friend Name'),
                subtitle: Text(widget.userData.aiName),
              ),
              ListTile(
                leading: const Icon(Icons.transgender),
                title: const Text('AI Gender'),
                subtitle: Text(widget.userData.aiGender),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _logout(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

String _formatTimestamp(Timestamp timestamp) {
  final time = timestamp.toDate();
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
