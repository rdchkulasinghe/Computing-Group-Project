import 'package:ai_friend/backend/collect_data.dart';
import 'package:ai_friend/chatscreen.dart';
import 'package:ai_friend/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await configureFirebaseLocalization();

  runApp(const MyApp());
}

Future<void> configureFirebaseLocalization() async {
  try {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    await FirebaseAuth.instance.setLanguageCode(
        locale.languageCode.isNotEmpty ? locale.languageCode : 'en');
  } catch (e) {
    FirebaseAuth.instance.setLanguageCode('en');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return snapshot.hasData
              ? const ChatScreenWrapper()
              : const LoginPage();
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ChatScreenWrapper extends StatefulWidget {
  const ChatScreenWrapper({super.key});

  @override
  State<ChatScreenWrapper> createState() => _ChatScreenWrapperState();
}

class _ChatScreenWrapperState extends State<ChatScreenWrapper> {
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

  Future<UserData> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) throw Exception("User data not found");

    return UserData.fromFirestore(doc.id, doc.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasError) {
          return ErrorApp(message: snapshot.error.toString());
        }
        return ChatScreen(
          userData: snapshot.data as UserData,
          updateUserData: _updateUserData,
        );
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String message;
  const ErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'Error: ${message.replaceAll(RegExp(r'^Exception: '), '')}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => main(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
