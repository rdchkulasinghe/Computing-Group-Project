import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_friend/backend/collect_data.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserData?> getUserData(String email) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(email).get();

      if (userDoc.exists) {
        return UserData.fromFirestore(
            userDoc.id, userDoc.data()! as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  Future<UserData?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return await getUserData(email);
      }
      return null;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }
}
