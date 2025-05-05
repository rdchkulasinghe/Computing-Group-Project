import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_friend/backend/collect_data.dart';

class AIDatabase {
  // Add a new user with auto-generated ID
  Future<void> addUser(UserData userData) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .add(userData.toJson());
    } catch (e) {
      print('Error adding user: $e');
      rethrow; // Optional: Propagate error to caller
    }
  }

  // Get all users (for admin purposes)
  Future<List<UserData>> getAllUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("users").get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return UserData(
          name: data['name'] ?? '',
          age: data['age'] ?? 0,
          userId: data['userId'] ?? '',
          pronouns: data['pronouns'] ?? '',
          freeTime: data['freeTime'] ?? '',
          movieType: data['movieType'] ?? '',
          aiName: data['aiName'] ?? '',
          aiGender: data['aiGender'] ?? '',
          email: data['email'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  // Update user by document ID
  Future<void> updateUser(String docId, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(docId)
          .update(updates);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Delete user by document ID
  Future<void> deleteUser(String docId) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(docId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // Get a specific user by document ID
  Future<UserData?> getUser(String docId) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection("users").doc(docId).get();

      if (doc.exists) {
        final data = doc.data()!;
        return UserData(
          name: data['name'] ?? '',
          age: data['age'] ?? 0,
          userId: data['userId'] ?? '',
          pronouns: data['pronouns'] ?? '',
          freeTime: data['freeTime'] ?? '',
          movieType: data['movieType'] ?? '',
          aiName: data['aiName'] ?? '',
          aiGender: data['aiGender'] ?? '',
          email: data['email'] ?? '',
        );
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }
}
